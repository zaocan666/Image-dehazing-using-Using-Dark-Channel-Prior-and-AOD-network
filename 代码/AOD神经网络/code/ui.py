from PyQt5.QtWidgets import QMainWindow, QApplication, QDesktopWidget, QLabel, QFileDialog, QPushButton, QMessageBox, QWidget
import sys
from PyQt5 import QtGui
import cv2
from test import test_on_img_
import numpy as np
import torchvision.transforms as transforms

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.ui_basic = Ui_basic()
        self.ui_basic.setParent(self)
        self.ui_basic.initUI()

        self.resize(1200, 700)
        self.center()
        self.setWindowTitle('Dehaze')
        self.show()

    def center(self):
        screen = QDesktopWidget().screenGeometry()
        size = self.geometry()
        self.move((screen.width() - size.width()) / 2,
                  (screen.height() - size.height()) / 2)

class Ui_basic(QWidget):
    def __init__(self):
        super().__init__()
        self.src_img = None

    def initUI(self):
        self.resize(1200, 700)

        self.open_src_button = QPushButton(parent = self)
        self.open_src_button.setText("打开图片")
        self.open_src_button.move(200, 20)
        self.open_src_button.pressed.connect(self.open_src_img)

        self.dehaze_button = QPushButton(parent=self)
        self.dehaze_button.setText("去雾")
        self.dehaze_button.move(self.open_src_button.x()+self.open_src_button.width()+30, self.open_src_button.y())
        self.dehaze_button.pressed.connect(self.dehze)

        self.src_img_area = QLabel(parent=self)  # 图形显示区域
        self.src_img_area.resize(500, 500)
        self.src_img_area.move(40, self.open_src_button.y()+self.open_src_button.height()+20)

        self.result_img_area = QLabel(parent=self)  # 结果图形显示区域
        self.result_img_area.resize(500, 500)
        self.result_img_area.move(self.src_img_area.x()+self.src_img_area.width()+40, self.src_img_area.y())

    def open_src_img(self):
        fileName, filetype = QFileDialog.getOpenFileName(self,
                                                          "选取文件",
                                                          "./",
                                                          "photo(*.jpg *.png *.bmp);;All Files (*)")

        self.src_img=cv2.imread(fileName)
        try:
            self.src_img.shape
        except:
            QMessageBox.warning(self, '提示','图片无法打开',QMessageBox.Yes)
            return

        self.showImage(self.src_img_area, self.src_img)


    def showImage(self, qlabel, img):
        size = (int(qlabel.width()), int(qlabel.height()))
        shrink = cv2.resize(img, size, interpolation=cv2.INTER_AREA)
        # cv2.imshow('img', shrink)
        shrink = cv2.cvtColor(shrink, cv2.COLOR_BGR2RGB)
        self.QtImg = QtGui.QImage(shrink.data,
                                  shrink.shape[1],
                                  shrink.shape[0],
                                  QtGui.QImage.Format_RGB888)

        qlabel.setPixmap(QtGui.QPixmap.fromImage(self.QtImg))

    def dehze(self):
        try:
            self.src_img.shape
        except:
            QMessageBox.warning(self, '提示','请先打开原图片',QMessageBox.Yes)
            return

        result = test_on_img_('epoch11.pth', self.src_img)
        image = result.cpu().clone()
        image = image.squeeze(0)
        image = transforms.ToPILImage()(image)
        image = np.array(image)

        self.showImage(self.result_img_area, image)

if __name__ == "__main__":
    app = QApplication([])
    ui = MainWindow()
    sys.exit(app.exec_())
