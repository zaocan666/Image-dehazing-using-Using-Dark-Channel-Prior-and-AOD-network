function [A] = getA_ave(I, I_darkChannel, ratio)
    % 获得全局背景光，使用平均值的方式
    % I：输入图像
    % I_darkChannel：输入图像的暗通道
    % ratio：从暗通道中选出点的比列

    [~, darkC_sort_index] = sort(I_darkChannel(:), 'descend');
    num_topDarkC = floor(length(darkC_sort_index)*ratio);
    Light_all = zeros(num_topDarkC,3);
    for k=1:num_topDarkC
        darkC_index = darkC_sort_index(k);
        [i, j] = getIJ_index(darkC_index, size(I,1));
        I_light = I(i, j, :);
        Light_all(k,:)=I_light;
    end
    A=mean(Light_all);
    A=reshape(A,[1,1,3]);
    A = repmat(A, size(I_darkChannel));
end

function [i, j] = getIJ_index(index, rowNum)
    j = floor((index-1)/rowNum)+1;
    i = rem(index-1,rowNum)+1;
end