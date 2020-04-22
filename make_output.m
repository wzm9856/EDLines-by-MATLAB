max=0;
for i = 1:lineCount
    if max<lineList(i).length
        max=lineList(i).length;
    end
end
for i = 1:lineCount
    output(i,1)=i;
    output(i,2)=lineList(i).start(1);
    output(i,3)=lineList(i).start(2);
    output(i,4)=lineList(i).ending(1);
    output(i,5)=lineList(i).ending(2);
    output(i,6)=lineList(i).length;
    output(i,7)=lineList(i).coef(1);
    output(i,8)=lineList(i).coef(2);
    output(i,9)=lineList(i).ori;
    output(i,10:lineList(i).length+9)=lineList(i).pointsList(1,1:lineList(i).length);
    output(i,10+lineList(i).length:lineList(i).length*2+9)=lineList(i).pointsList(2,1:lineList(i).length);
    output(i,lineList(i).length*2+10)=-1;
end
