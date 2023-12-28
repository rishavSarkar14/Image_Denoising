I=imread("C:\Users\risha\Study\Projects\DSP Assignment\img\molnar.jpg");
Im=rgb2gray(I);
noisy= imnoise(Im, 'salt & pepper',0.1);

[m,n] =size(noisy);

output=zeros(m,n);
output=uint8(output);

for i=1:m
    for j=1:n
        xmin=max(1,i-1);
        xmax=min(m,i+1);
        ymin=max(1,j-1);
        ymax=min(n,j+1);

        temp=noisy(xmin:xmax,ymin:ymax);
        output(i,j)=median(temp(:));
    end
end


figure(I);
set(gcf,'Position',get(0,'ScreenSize'));
subplot(131),imshow(I),title('Original Image');
subplot(132),imshow(noisy),title('Noisy Image');
subplot(133),imshow(output),title('Filtered Image');