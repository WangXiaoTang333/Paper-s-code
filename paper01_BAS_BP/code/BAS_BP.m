%% ����ţ���㷨���Ż�BP��Ȩֵ����ֵ,��������Ϊ�������ݣ�������ʵ�����ݣ�����60��������ÿ����������401������ֵ��NIRΪ�����Ĺ������ݣ�octaneΪ60*1������ֵ����
% 1.0�汾
%% ��ջ�������
clear all
close all
clc
tic
%% ��������
load spectra_data.mat
% �������ѵ�����Ͳ��Լ�
temp=randperm(size(NIR,1));
%ѵ��������50������
P=NIR(temp(1:50),:)';
T=octane(temp(1:50),:)';
%���Լ�����10������
P_test=NIR(temp(51:end),:)';
T_test=octane(temp(51:end),:)';
N=size(P_test,2);
M=size(P,2);

%% ��һ��
[P, ps_input] = mapminmax(P,0,1);%p_train��һ��������ΧΪ[0,1]��Ĭ�������Ϊ[-1,1]
P_test = mapminmax('apply',P_test,ps_input);%��P_test������ͬ��ӳ��
[T, ps_output] = mapminmax(T,0,1);
%% 
inputnum=size(P,1);
outputnum=size(T,1);
hiddennum=9;%��ʼ��������Ԫ����
%% ��������
net=newff(P,T,hiddennum);
net.trainParam.epochs = 1000;
net.trainParam.goal = 1e-3;
net.trainParam.lr = 0.01;
%% ��ţ���㷨��ʼ��
eta=0.8;
c=5;%�������ʼ����֮��Ĺ�ϵ
step=30;%��ʼ����
n=100;%��������
k=inputnum*hiddennum+outputnum*hiddennum+hiddennum+outputnum;
x=rands(k,1);
bestX=x;
bestY=fitness(bestX,inputnum,hiddennum,outputnum,net,P,T);
fbest_store=bestY;
x_store=[0;x;bestY];
display(['0:','xbest=[',num2str(bestX'),'],fbest=',num2str(bestY)])
%% ��������
for i=1:n
d0=step/c;
    dir=rands(k,1);
    dir=dir/(eps+norm(dir));
    xleft=x+dir*d0/2;
    fleft=fitness(xleft,inputnum,hiddennum,outputnum,net,P,T);
    xright=x-dir*d0/2;
    fright=fitness(xright,inputnum,hiddennum,outputnum,net,P,T);
    x=x-step*dir*sign(fleft-fright);
    y=fitness(x,inputnum,hiddennum,outputnum,net,P,T);
    if y<bestY
        bestX=x;
        bestY=y;
    end
    if y<0.001
         bestX=x;
        bestY=y;
    end
    x_store=cat(2,x_store,[i;x;y]);
    fbest_store=[fbest_store;bestY];
    step=step*eta;
     display([num2str(i),':xbest=[',num2str(bestX'),'],fbest=',num2str(bestY)])
end

%% ���ӻ�
figure(1)
%plot(x_store(1,:),x_store(end,:),'r-o')
hold on,
plot(x_store(1,:),fbest_store,'b-.')
xlabel('Iteration')
ylabel('BestFit')
toc