# 图像去雾
本项目用暗原色先验算法和AOD神经网络实现图像去雾
## 暗原色先验
### 可执行程序
可程序程序带有UI用户界面，在Windows系统下打开“可执行程序\暗原色先验\dehaze.exe”来使用。
点击“选择图片”按钮选择要处理的图片，点击“去雾”按钮获得图像去雾结果，可选择对结果进行直方图均衡，可以调整结果图片的亮度。
### 代码
可以将测试图片放在testbench文件夹内，运行main.m，在results文件夹内查看结果。
- mygui.m: UI用户界面的代码
- main.m: 对同目录下“testbench”文件夹中的图片进行去雾，存储在results文件夹下。
- dehaze.m: 图像去雾主逻辑
- getA.m: 获得全局背景光。
- getA_ave.m: 获得全局背景光，使用平均值的方式。
- guidFilter.m: 快速引导滤波算法.
- hist_equal.m: 对rgb分别进行rgb均衡

## AOD神经网络
### 可执行程序
由于可执行程序太大（780M），所以上传至清华网盘 https://cloud.tsinghua.edu.cn/d/6be1526e6dfb4fc08e57/。
下载ui.exe和epoch11.pth，放在同一目录下，运行ui.exe
点击“选择图片”按钮选择要处理的图片，点击“去雾”按钮获得图像去雾结果，可选择对结果进行直方图均衡，可以调整结果图片的亮度。
### 代码
- ui.py: UI用户界面的代码。
- train.py: 训练网络所用代码。
- dataloader.py: 提取图片数据。
- utilis.py: 附加函数，如保存模型参数等。
- model.py: AOD模型。
- test.py: 载入模型参数并在给定图片上进行测试。
### 环境
- torch 1.2.0
- python 3.5.2
- Cuda compilation tools, release 10.1, V10.1.105
- cudnn 6
### 训练参数
- **FC_LR = 1e-4** (learning rate of fully-connected parameters)
- **NET_LR = 1e-4** (learning rate of other parameters)
- **BATCH_SIZE = 64** (training batch size)
- **OPTIMIZER = 'adam'** (optimizer choice, adam or sgd)
- **WEIGHT_DECAY = 1e-4** (weight decay, applied only when using SGD)
- **MOMENTUM = 0.9** (momentum, applied only when using SGD)
- **DECAY_RATE = 0.1** (decay rate of learning rate every 10 epoches)
### 训练方法
首先需要从https://sites.google.com/site/boyilics/website-builder/project-page下载训练数据集放在code文件夹同目录data文件夹内
data文件夹内应该由data文件夹（有雾图片）和images文件夹（原图）
在根目录下运行python code/train.py
