function result = func5(X)
%XҪ��1��N��
[row,col]=size(X);
if row>1
    error('����Ĳ�������');
end
for i=1:col-1
    y=sum(100*(X(i)^2-X(i+1))^2+(X(i)-1)^2);
end
result=y;

end