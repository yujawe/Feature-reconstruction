function [posi,num_length] =find_most_contin_region( x )
a=diff(x);
num0=0;numSeq=[];zeroNum=[];
for ki=1:length(a)
  if a(ki)==0
    num0=num0+1;
    if ki<length(a)
        if a(ki+1)~=0
            numSeq=[numSeq;num0];
            num0=0;
        end
    elseif ki==length(a)
        numSeq=[numSeq;num0];
            num0=0;
    end
     if ki==1 && a(1)==0
        zeroNum=[zeroNum;1];
    end
    if ki>2
        if a(ki-1)~=0
            zeroNum=[zeroNum;ki];
        end
    end
    
  end
end
[C,I]=max(numSeq);
num_length=C;
posi=zeroNum(I);

end
