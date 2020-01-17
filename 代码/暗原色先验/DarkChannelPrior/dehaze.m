function [J, J_hist] = dehaze(I)
%去雾主逻辑
%参数
darkChannel_r=2;
omega=0.95;
guidFilter_s = 1/floor(min(size(I, 1), size(I, 2)) / 16); %快速引导滤波中的缩小倍数
guidFilter_r = 4; %快速引导滤波中的窗口大小
guidFilter_epsilon = 0.001;
t_threhold = 0.1;

I_darkChannel = getDarkChannel(I, darkChannel_r);
%A = getA(I, I_darkChannel, 0.001);
%改进后的全局背景光估算
A = getA_ave(I, I_darkChannel, 0.001);
A(A>0.86)=0.9;

t_=1-omega*getDarkChannel(I_darkChannel./A, darkChannel_r);
t = guidFilter(I, t_, guidFilter_r, guidFilter_s, guidFilter_epsilon);

%对浓雾部分的改进
% k_correct = t_;
% correct_threhold = 0.48;
% k_correct(t_>correct_threhold) = 1;
% k_correct(t_<=correct_threhold) = 0.97;
% ave_size = 5;
% ave_kernel = ones(ave_size)/(ave_size*ave_size);
% k_correct = conv2(k_correct, double(ave_kernel), 'same');  
% t = t.*k_correct;

J = (I-A)./max(t,t_threhold)+A;
J(J>1)=1;
J(J<0)=0;

J_hist=hist_equal(J);
end

%获得图像I暗通道的值
function [I_darkChannel] = getDarkChannel(I, patch_r)
    I_rgb_min = min(I, [], 3);
    I_darkChannel = ordfilt2(I_rgb_min, 1, true(patch_r*2+1, patch_r*2+1), 'symmetric'); %最小值滤波
end