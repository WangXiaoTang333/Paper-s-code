%% ʹ���Ż����Ȩֵ����ֵ���Խ��
%% ʹ���Ż����Ȩֵ����ֵ
inputnum=size(P,1);%�������Ԫ����
outputnum=size(T,1);%�������Ԫ����
N=size(P_test,2);
M=size(P,2);
%% �½�BP
net=newff(P,T,9);
%% �������������ѵ������1000��ѵ��Ŀ��0.001��ѧϰ����00.1
net.trainParam.epochs =3000;
net.trainParam.goal = 1e-6;
net.trainParam.lr = 0.01;
%% BP��ʼȨֵ����ֵ
w1num=inputnum*hiddennum;%����㵽�������Ȩֵ����
w2num=outputnum*hiddennum;%�����㵽������Ȩֵ����
w1=bestX(1:w1num);%��ʼ����㵽�������Ȩֵ
B1=bestX(w1num+1:w1num+hiddennum);
w2=bestX(w1num+hiddennum+1:w1num+hiddennum+w2num);%��ʼ�����㵽������Ȩֵ
B2=bestX(w1num+hiddennum+w2num+1:w1num+hiddennum+w2num+outputnum);%�������ֵ
net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=reshape(B2,outputnum,1);
%% ѵ������
net=train(net,P,T);
%% ��������
t_sim_P= sim(net,P);
t_sim_P_test= sim(net,P_test);
%% ����һ��
T=mapminmax('reverse',T,ps_output);

T_sim_P= mapminmax('reverse',t_sim_P,ps_output);
T_sim_P_test = mapminmax('reverse',t_sim_P_test,ps_output);
%% ������
error_P=abs(T_sim_P-T)./T;
error_P_test=abs(T_sim_P_test-T_test)./T_test;
%% ���ϵ��
R2_P= (M * sum(T_sim_P .* T) - sum(T_sim_P) * sum(T))^2 / ((M * sum((T_sim_P).^2) - (sum(T_sim_P))^2) * (M * sum((T).^2) - (sum(T))^2)); 
R2_P_test = (N * sum(T_sim_P_test .* T_test) - sum(T_sim_P_test) * sum(T_test))^2 / ((N * sum((T_sim_P_test).^2) - (sum(T_sim_P_test))^2) * (N * sum((T_test).^2) - (sum(T_test))^2)); 
%% ����Ա�
result = [T_test' T_sim_P_test' abs(T_test-T_sim_P_test)']
result=[T' T_sim_P' abs(T-T_sim_P)']