function pf=psychofunction(human,model,binz,rangey);

if nargin<3;
    binz=10;
end

if nargin<4;
    rangey=[0 1];
end

if isscalar(binz);
    qq=quantile(model,[1/(binz):1/(binz):1-(1/(binz))]);
else
    qq=binz;
end

if qq(1)~=rangey(1);
qq=[rangey(1) qq Inf];
else
    qq=[ qq Inf];
end


for q=1:length(qq)-1;
    indx=find(model>=qq(q) & model<qq(q+1));
    pf(q)=mean(human(indx));
end
    


