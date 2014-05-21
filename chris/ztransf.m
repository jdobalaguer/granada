%ztransforms a matrix.
% 
% function z=ztransf(x,trim);
% 
% a=size(x);
% numdim=ndims(x);
% 
% stdlx=std(x(:));
% meanlx=mean(x(:));
% z=(x(:)-meanlx)./stdlx;
% 
% if nargin>1
% z(find(z>trim))=trim;
% z(find(z<trim*-1))=trim*-1;
% end
% 
% 
% if numdim==2;
% z=reshape(z,a(1),a(2));    
% elseif numdim==3;
% z=reshape(z,a(1),a(2),a(3));
% elseif numdim==4;
% z=reshape(z,a(1),a(2),a(3),a(4));
% elseif numdim==5;
% z=reshape(z,a(1),a(2),a(3),a(4),a(5));
% end
% 
%     

function z = ztransf(x)
    s = nanstd(x);
    z = (x - nanmean(x)) ./ nanstd(x);
end
