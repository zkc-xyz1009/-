function result = func4(x)
[row,col]=size(x);
if row>1
    error('����Ĳ�������');
end
y=sum(x.^2-10*cos(2*pi*x)+10);
result=y;                                                                                                                                                                     
end