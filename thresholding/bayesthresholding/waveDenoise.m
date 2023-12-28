function img_denoise = waveDenoise(img, noisy, wavelet, sorh, level)
x = noisy;
[thr,~,keepapp] = ddencmp('den','wv',x);
wv = '';
switch wavelet
    case 1
        wv='haar';
    case 2
        wv='db2';
    case 3
        wv='db4' ;
    case 4
        wv='sym4';
    case 5
        wv='bior6.8';
    case 6
        wv='mexh';
    case 7
        wv='coif5';
    case 8
        wv='dmey';
    case 9
        wv='mor1';
    case 10
        wv='jpeg9.7';
    otherwise
        quit;
end

switch sorh
    case 1
        sorh='s';
        xd = wdencmp('gbl',x,wv,level,thr,sorh,keepapp);
    case 2
        sorh='h';
        xd = wdencmp('gbl',x,wv,level,thr,sorh,keepapp);
    case 3
        %%%%%%%%%%%%%%%%%%%%%
        % clear all;

        pic=img;

        %While using 'imnoise' the pixel values(0 to 255) are converted to double in the range 0 to 1
        %So variance also has to be suitably converted
        sig=15;
        V=(sig/256)^2;
        npic=noisy;
        %npic=imnoise(pic,'gaussian',0,V);
        %figure, imagesc(npic);colormap(gray);

        %Define the type of wavelet(filterbank) used and the number of scales in the wavelet decomp
        filtertype=wv;
        levels=level;

        %Doing the wavelet decomposition
        [C,S]=wavedec2(npic,levels,filtertype);

        st=(S(1,1)^2)+1;
        bayesC=[C(1:st-1),zeros(1,length(st:1:length(C)))];
        var=length(C)-S(size(S,1)-1,1)^2+1;


        %Calculating sigmahat
        sigmahat=median(abs(C(var:length(C))))/0.6745;

        for jj=2:size(S,1)-1
            %for the H detail coefficients
            coefh=C(st:st+S(jj,1)^2-1);
            thr=bayes(coefh,sigmahat);
            bayesC(st:st+S(jj,1)^2-1)=sthresh(coefh,thr);
            st=st+S(jj,1)^2;

            % for the V detail coefficients
            coefv=C(st:st+S(jj,1)^2-1);
            thr=bayes(coefv,sigmahat);
            bayesC(st:st+S(jj,1)^2-1)=sthresh(coefv,thr);
            st=st+S(jj,1)^2;

            %for Diag detail coefficients
            coefd=C(st:st+S(jj,1)^2-1);
            thr=bayes(coefd,sigmahat);
            bayesC(st:st+S(jj,1)^2-1)=sthresh(coefd,thr);
            st=st+S(jj,1)^2;
        end


        %Reconstructing the image from the Bayes-thresholded wavelet coefficients
        bayespic=waverec2(bayesC,S,filtertype);
        xd=bayespic;
        %Displaying the Bayes-denoised image
        %figure, imagesc(uint8(bayespic));colormap(gray);



        %%%%%%%%%%%%%%%%%%%%%%%%%%


end

noisy = real(noisy);
[c,s]=wavefast(noisy,level,wv);
img_denoise = xd;




end