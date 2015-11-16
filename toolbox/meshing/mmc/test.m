nrow=356;
ncol=160;
for i=1:128
    if i==1 || i==128
        a=zeros(nrow,ncol,'uint8');
        imwrite(a,['foo' num2str(i) '.bmp'],'bmp');
        continue
    end
    a=ones(nrow,ncol,'uint8')*50;
    a(1:2,:)=0;
    a(:,1:2)=0;
    a(end-2:end,:)=0;
    a(:,end-2:end)=0;
    if (i>20 && i<80)
        a(50:100,50:100)=100;
        a(80:150,80:150)=200;
    end 
    imwrite(a,['foo' num2str(i) '.bmp'],'bmp');
end
MMC('foo2.bmp', 2, 4, 16, 'myoutput')

for i=1:128
    delete(['foo' num2str(i) '.bmp'])
end
