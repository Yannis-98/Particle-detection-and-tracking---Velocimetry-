function [distance2,indice] =fonction_sort(xp,yp,N, abs, ord)

j=0;
dmax=30;
for i=1:size(ord,1)
    d=sqrt(((abs(i,1)-xp)^2)+((ord(i,1)-yp)^2));
    if (d<dmax)
        j=j+1;
        temp(j)=i;
        temp2(j)=d;
        hold on
    end    
end
for m=1:(size(temp,2)-1)
    for p=(m+1):size(temp,2)
        temp2(m);
        temp2(p);
        if (temp2(m)>temp2(p))
%% Tri croissant 
            tmp2=temp2(m);
            temp2(m)=temp2(p);
            temp2(p)=tmp2;
%% sauvegarde des indices
            tmp=temp(m);
            temp(m)=temp(p);
            temp(p)=tmp;
        end
    end
end
distance2=temp2(1:N).^2;
indice=temp(1:N);

end
