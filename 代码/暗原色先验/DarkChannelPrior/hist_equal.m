function [J_after] = hist_equal(J)
%对rgb分别进行rgb均衡
J_r_after=adapthisteq(J(:,:,1));
J_g_after=adapthisteq(J(:,:,2));
J_b_after=adapthisteq(J(:,:,3));

J_after(:,:,1)=J_r_after;
J_after(:,:,2)=J_g_after;
J_after(:,:,3)=J_b_after;

end