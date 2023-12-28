function psnr=PSNR(x,y)
[m,n]=size(x);
msee=sum(sum(((x-y).^2)))/(m*n);
% psnr=20*log10(max(max(x))/sqrt(msee));
% msee=mean2(err);
if  max(max(x))<=1
    psnr=20*log10(1/sqrt(msee));
elseif max(max(x))>1 && max(max(x))<=255
    psnr=20*log10(255/sqrt(msee));
end

end
