
f=imread("img\1.jpg");
f=im2gray(im2double(f));
f = padarray(f, [1 1], 'replicate', 'both');

MF=filt(f);
figure,imshow(f),title('Original Image');
figure,imshow(MF),title('Median Filtered Image');
SP=imnoise(f,"salt & pepper",0.2);
figure,imshow(SP),title('Salt & Pepper Noisy Image');
SPMF=filt(SP);
figure,imshow(SPMF),title('Salt & Pepper - Median Filtered  Image');


function M=filt(f)
M = zeros(size(f));
[r,c]=size(f);
for i=2:r-1
    for j=2:c-1
        W = f(i-1:i+1, j-1:j+1);
        m=median(W, "all");
        M(i,j)=m;
    end
end
end
