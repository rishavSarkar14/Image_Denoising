img = imread('C:\Users\risha\Study\Projects\DSP Assignment\1.jpg');
img = im2gray(img);

img_noise = imnoise(img, "gaussian", 0.1);
img_denoise = NLM(img_noise, 0.2, 7, 3);

clf;
subplot(2,2,1), imshow(img), title("Original");
subplot(2,2,2), imshow(img_noise), title("Noisy");
subplot(2,2,3), imshow(img_denoise), title("Denoised");