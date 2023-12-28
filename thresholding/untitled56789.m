clear;
I=imread('C:\Users\Aniket Sourav\Desktop\123.jpeg');
B = imresize(I, [512 512]);
x=imnoise(B,"gaussian",0,0.05);
