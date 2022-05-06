clear all;
close all;
clc;
 
%��ʾ����
x=-10:0.01:10;
y=-10:0.01:10;
N=size(x,2);
for i =1:N
    for j=1:N
        z(i,j)=func2(x(i),y(j));
    end
end
mesh(x,y,z)


iter_max = 10000;     %��������
Pc = 0.8;    
Pm = 0.1;
num_g = 100;     %��Ⱥ��ģ
len = 20;    %Ⱦɫ�峤��(2*8,1(����)+7������ֵ��)

xmax=10;
xmin=-10;
precision=(xmax-xmin)/(2^10);
% precision=1;
 
%������ʼ��Ⱥ
f = rand(num_g,len);%100��16�У�0��1��
f = round(f);
%����      
for iter = 1:iter_max
    
    %��������ת��Ϊʮ��������������Ӧ��ֵ
    for i = 1:num_g
        U = f(i,:);%i������ֵ
        m1 = 0;
        m2 = 0;
        for j = 1:(len/2-1)
            m1 = (U(j)*2^(j-1))*precision+m1;
        end
        if U(len/2) == 1
            m1 = -m1;
        end
        x(i) = m1; 
        
        for j = (len/2+1):(len-1)
            m2 = (U(j)*2^(j-11))*precision+m2;
        end
        if U(len) == 1
            m2 = -m2;
        end
        y(i) = m2;
        
        Fit(i) = func2(x(i),y(i));
    end
  
        
    maxFit = max(Fit);
    minFit = min(Fit);
    loc= find(Fit==minFit);
    loc
    fBest = f(loc(1,1),:);
    xBest = x(loc(1,1));
    yBest = y(loc(1,1));
    Fit = (Fit-minFit)/(maxFit-minFit);
   
    %ѡ�����
    sum_Fit = sum(Fit);
    fitvalue = Fit./sum_Fit;%ÿ�����������һ���ĸ��ʵ���������Ӧ��ֵ��������Ⱥ�и�����Ӧ��ֵ�͵ı���.
    fitvalue = cumsum(fitvalue);
    ms = sort(rand(num_g,1));
    fiti = 1;
    newi = 1;
    while newi<=num_g
        if (ms(newi))<fitvalue(fiti)%��Ӧ��
            nf(newi,:) = f(fiti,:);%���µ�
            newi = newi+1;
        else
            fiti = fiti+1;
        end
    end     
    
    %����
    for i = 1:2:num_g       %������Ⱥ��i = 1,3,5.....NP
        if rand< Pc        %�ж������p�Ƿ�С�ڽ������
            q = randi(1,len);      %����һ��1��D�еľ���q��q�е�ÿ��Ԫ��Ϊ0��1
            for j = 1:len
                if q(j) == 1     %����q�е�j��Ԫ�أ����q(j)=1,�Ͱ���Ⱥ�е�i��Ⱦɫ��ĵ�jλ���i+1��Ⱦɫ���jλ���н���
                   %�������
                    temp = nf(i+1,j);
                    nf(i+1,j) = nf(i,j);
                    nf(i,j) = temp;       
                end
            end
        end
    end
    
    %����
    for i = 1:num_g
        for j = 1:len
            if rand<Pm          %���pС�ڱ�����ʣ�����б���
                nf(i,j) = ~nf(i,j);    %%��i��Ⱦɫ��ĵ�jλȡ��
            end
        end
    end
    
   
    f = nf;
    f(1,:) = fBest;
    
    %%Fit(i) = 10/(Fit(i)+10);
    %%maxFit = 10/maxFit-10;
    
    %%trace(gen) = maxFit;
    trace(iter) = minFit;
    
end

figure

plot(trace);
xlabel('��������')
ylabel('Ŀ�꺯��ֵ')
title({['���ŵ�x1 = ', num2str(xBest), ',���ŵ�x2 = ',num2str(yBest)],['��Сֵ = ',num2str(minFit)],'��Ӧ�Ƚ�������'})