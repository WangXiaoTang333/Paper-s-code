%_________________________________________________________________________%
%  Beetle Swarm Optimization (BSO)Algorithm source codes demo V1.0        
%                                                                         
%  Developed in MATLAB R2016a                                             
%                                                                         
%  Author and programmer: Long Yang and Tiantian Wang    
%                                                                         
%         e-Mail: yanglongren@163.com                 
%                 18366135507@163.com                   
%                                                                                           
%  Main paper: Tiantian Wang ,  Long Yang , Qiang Liu                        
%             Beetle Swarm Optimization Algorithm:Theory and Application
%                 
%_________________________________________________________________________%
function Target=BSO_fun17(N, Max_iter,lb,ub,dim,fobj)
%% III. ������ʼ��

%�ٶȵı߽�
Vmax=5.12;
Vmin=-5.12;
%��Ⱥ��Χ
 step0=0.9;
 step1=0.2;
eta=0.95;
c=2;
 %����Ȩ�����ֵ����Сֵ
 wmax=0.9;
 wmin=0.4; 
 k=0.4;
 %��ʼ����
 step=10;
 Y=zeros(1,2);
%% IV. ������ʼ���Ӻ��ٶ�
for i = 1:N;
    % �������һ����ţȺ
    pop(i,:) = (rands(1,dim) ) *(ub-lb)+lb ;   %��ʼ��Ⱥ(��֤��ʼ��Ⱥ���ᳬ���߽�1-2��
    V(i,:) = 0.5 * rands(1,dim);  %��ʼ���ٶ�
    % ������Ӧ��
    fitness(i) =fobj(pop(i,:));  
end
%% ���Ƴ�ʼ��Ⱥ��Ӧ�Ⱥ���ֵͼ��
%% V. ���弫ֵ��Ⱥ�弫ֵ
[bestfitness bestindex] = max(fitness);
zbest = pop(bestindex,:);   %ȫ�����
gbest = pop;    %�������
fitnessgbest = fitness;   %���������Ӧ��ֵ
fitnesszbest = bestfitness;   %ȫ�������Ӧ��ֵ
%% VI. ����Ѱ��
for i = 1:Max_iter
    %ѧϰ����c1,c2�ĵ���
    c1=1.3+1.2*(cos(i*pi)/Max_iter);
    c2=2-1.2*(cos(i*pi)/Max_iter);
    d0=step/c;%����֮��ľ���
    w= wmax- (wmax-wmin)*(i/Max_iter);%Ȩ��ϵ������
    for j = 1:N;
        %bas��������λ���ƶ�
        xleft=pop(j,:)+V(j,:)*d0/2;
        fleft=fobj(xleft);
        xright=pop(j,:)-V(j,:)*d0/2;
        fright=fobj(xright);
     
        Y(j,:)=step.*V(j,:).*sign(fleft-fright);
        % �ٶȸ���
        V(j,:) = w*V(j,:) + c1*rand*(gbest(j,:) - pop(j,:)) + c2*rand*(zbest - pop(j,:));
        V(j,find(V(j,:)>Vmax)) = Vmax;
        V(j,find(V(j,:)<Vmin)) = Vmin;
        
        % ��Ⱥλ�ø���
        pop(j,:) = pop(j,:) + k*V(j,:)+(1-k)*Y(j,:);
         pop(j,:)=(pop(j,:)>ub').*ub'+(pop(j,:)<ub').*pop(j,:);
         pop(j,:)=(pop(j,:)<lb').*lb'+(pop(j,:)>lb').*pop(j,:);
       
        
        % ��Ӧ��ֵ����
        fitness(j) = fobj(pop(j,:)); 
    end
    %ÿ������Ӧ�Ⱥ���ֵ
    fitnesstable(i,:)=fitness;
    for j = 1:N;   
        % �������Ÿ���
        if fitness(j) <fitnessgbest(j)
            gbest(j,:) = pop(j,:);
            fitnessgbest(j) = fitness(j);
        end
        
        % Ⱥ�����Ÿ���
        if fitness(j) < fitnesszbest
            zbest = pop(j,:);
            fitnesszbest = fitness(j);
        end
    end 
     yy(i) = fitnesszbest;        
   eta= step1 * (step0/step1)^(1/(1+10*i/Max_iter));
    step=eta*step;
end
Target=min(yy);



