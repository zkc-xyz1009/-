function result = func3(X)
%XҪ��1��N��
[row,col]=size(X);
if row>1
    error('����Ĳ�������');
end
y1=1/4000*sum(X.^2);
y2=1;
for h=1:col
    y2=y2*cos(X(h)/sqrt(h));
end
y=y1-y2+1;
result=y;                                                                                                                                                                          
end
