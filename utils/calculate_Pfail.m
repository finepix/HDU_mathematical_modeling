function [ Pfail ] = calculate_Pfail( contributes, PLAN_PH )
%UNTITLED16 �����ܵ�ʧ����
%   �˴���ʾ��ϸ˵��
    Pfail = 1 - calculate_SDh(contributes, PLAN_PH);

end

function [SDh] = calculate_SDh(contributes, PLAN_PH)
    
    SDh = 1 - exp(-contributes * PLAN_PH);
end