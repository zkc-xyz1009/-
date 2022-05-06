clear all;
close all;
clc;
 



iter_max = 5000;     %��������
Pc = 0.9;    %����
Pm = 0.1;   %����
num_g = 500;     %��Ⱥ��ģ
dim=2;%ά��
len = 16;
xmax=2.048;
xmin=-2.048;
%��ʾͼ��
X=[ -10:0.1 : 10 ];
Y =[ -10 :0.1 : 10 ];
[m,n] = meshgrid(X,Y);
[row,col] = size(n);
for  l = 1 :col
     for  h = 1 :row
        z(h,l) = func3([m(h,l),n(h,l)]);
    end
end
mesh(m,n,z)

 
 
 
%������ʼ��Ⱥ
f = rand(num_g,len*dim);%100��16�У�0��1��
f = round(f);%��0��1
%����      
for iter = 1:iter_max%ÿһ��
    %��������ת��Ϊʮ��������������Ӧ��ֵ
    for i = 1:num_g%һ����ÿһ������
        for j=1:dim%yһ�������ά��
            y(j)=0;
            for k=1:len%һ��ά�ȵĴ�СתΪ10����
                y(j)=y(j)+f(i,j*len-k+1)*2^(k-1);
%                 y(j)=y(j)+f(i,(j-1)*len+k)*2^(k*(j-1)-1);
            end
            x(j)=xmin+(xmax-xmin)*y(j)/(2^len);%תΪ��Χ��ʮ����
        end
        Fit(i) = func3(x);
    end
    Fit
    maxFit = max(Fit);
    minFit = min(Fit);
    minFit
    loc= find(Fit==minFit);
    fBest = f(loc,:)
    Fit = (Fit-minFit)/(maxFit-minFit);

   
    %ѡ�����
    sum_Fit = sum(Fit);
    fitvalue = Fit./sum_Fit;%ÿ�����������һ���ĸ��ʵ���������Ӧ��ֵ��������Ⱥ�и�����Ӧ��ֵ�͵ı���.
    fitvalue = cumsum(fitvalue);%1��100��
%     [x,y]=size(fitvalue);
    ms = sort(rand(1,num_g));
%     [m,n]=size(ms);
    fiti = 1;
    newi = 1;
    while newi<=num_g
      if ms(newi)<fitvalue(fiti)
          nf(newi,:) = f(fiti,:);%���µ�
          newi = newi+1;
      else
          fiti = fiti+1;
      end
   end   
%     while newi<=num_g
%        if ms(newi)<fitvalue(fiti)
%            nf(newi,:) = f(fiti,:);%���µ�
%            newi = newi+1;
%        else
%            fiti = fiti+1;
%        end
%     end     
    
    %����
    for i = 1:2:num_g       %������Ⱥ��i = 1,3,5.....NP
        if rand< Pc        %�ж������p�Ƿ�С�ڽ������
            q = randi(1,len*dim);      %����һ��1��D�еľ���q��q�е�ÿ��Ԫ��Ϊ0��1
            for j = 1:len*dim
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
        for j = 1:len*dim
            if rand<Pm          %���pС�ڱ�����ʣ�����б���
                nf(i,j) = ~nf(i,j);    %%��i��Ⱦɫ��ĵ�jλȡ��
            end
        end
    end
    
   
    f = nf;
    f(1,:) = fBest;       
    trace(iter) = minFit;
end

for j=1:dim%yһ�������ά��
    y(j)=0;
    for k=1:len%һ��ά�ȵĴ�СתΪ10����
        y(j)=y(j)+f(i,j*len-k+1)*2^(k-1);
%         y(j)=y(j)+(fBest(1,(j-1)*len+k))*2^(k*(j-1)-1);
    end
    x(j)=xmin+(xmax-xmin)*y(j)/(2^(len));%תΪ��Χ��ʮ����
end
 figure

plot(trace);
xlabel('��������')
ylabel('Ŀ�꺯��ֵ')
% title({['���ŵ�x1 = ', num2str(x(1)), ',���ŵ�x2 = ',num2str(x(2))],['��Сֵ = ',num2str(minFit)],'��Ӧ�Ƚ�������'})
title({['��Сֵ = ',num2str(minFit)],[num2str(minFit)],'��Ӧ�Ƚ�������'})