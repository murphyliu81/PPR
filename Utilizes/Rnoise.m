function [ Rn] = Rnoise( Fabs,Fabs_n )
%UNTITLED3 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
Rn=sum(sum(abs(Fabs-Fabs_n)))./sum(sum(Fabs));

end

