function [A] = getA(I, I_darkChannel, ratio)
    % 获得全局背景光
    % I：输入图像
    % I_darkChannel：输入图像的暗通道
    % ratio：从暗通道中选出点的比列

    [~, darkC_sort_index] = sort(I_darkChannel(:), 'descend');
    num_topDarkC = floor(length(darkC_sort_index)*ratio);
    I_light_max = -100;
    I_gray=rgb2gray(I);
    for k=1:num_topDarkC
        darkC_index = darkC_sort_index(k);
        [i, j] = getIJ_index(darkC_index, size(I,1));
        I_light = I_gray(i, j);
        if I_light>I_light_max
           I_light_max = I_light;
           Lightest_ij = [i j];
        end
    end
    A = I(Lightest_ij(1), Lightest_ij(2), :);
    A = repmat(A, size(I_darkChannel));
end

function [i, j] = getIJ_index(index, rowNum)
    j = floor((index-1)/rowNum)+1;
    i = rem(index-1,rowNum)+1;
end