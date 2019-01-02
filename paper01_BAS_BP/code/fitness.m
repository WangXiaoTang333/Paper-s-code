function  error = fitness(x,inputnum,hiddennum,outputnum,net,P,T)
%�ú�������������Ӧ��ֵ
%% ����
%x                     ����
%inputnum        �����ڵ���
%hiddennum     ������ڵ���
%outputnum     �����ڵ���
%net                 ����
%P                    ѵ����������
%T                     ѵ���������
%% ���
%error       ������Ӧ��ֵ
%% ��ȡ
M=size(P,2);
w1=x(1:inputnum*hiddennum);
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);
%% ����Ȩֵ��ֵ
net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=reshape(B2,outputnum,1);
%% ѵ������
net=train(net,P,T);
%% ����
Y=sim(net,P);
error=sum(abs(Y-T).^2)./M;
end

