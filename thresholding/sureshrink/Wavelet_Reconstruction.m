function [DImg] = Wavelet_Reconstruction(Eband1,NoOfBands,S1,wname)
%% General Wavelet Reconstruction.
yw1=Eband1;
k1=NoOfBands;
xrtemp1=reshape(yw1{k1},1,S1(1,1)*S1(1,2));
k1=k1-1;
for i=2:size(S1,1)-1
   xrtemp1=[xrtemp1 reshape(yw1{k1-1},1,S1(i,1)*S1(i,2)) reshape(yw1{k1},1,S1(i,1)*S1(i,2)) reshape(yw1{k1-2},1,S1(i,1)*S1(i,2))];
   k1=k1-3;
end
DImg=waverec2(xrtemp1,S1,wname);
end