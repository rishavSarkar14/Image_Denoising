function [CW1,S1] = Wavelet_Decomposition(J,Nlevels,NoOfBands,wname)
%% Wavelet decomposition
dwtmode('per');
% dwtmode('symw');
[C1,S1]=wavedec2(J,Nlevels,wname);
k1=NoOfBands;
CW1{k1}=reshape(C1(1:S1(1,1)*S1(1,2)),S1(1,1),S1(1,2));
k1=k1-1;
st_pt1=S1(1,1)*S1(1,2);
for i=2:size(S1,1)-1
   slen1=S1(i,1)*S1(i,2);
   CW1{k1}=reshape(C1(st_pt1+slen1+1:st_pt1+2*slen1),S1(i,1),S1(i,2));  %% Vertical
   CW1{k1-1}=reshape(C1(st_pt1+1:st_pt1+slen1),S1(i,1),S1(i,2));   %% Horizontal
   CW1{k1-2}=reshape(C1(st_pt1+2*slen1+1:st_pt1+3*slen1),S1(i,1),S1(i,2));  %% Diagonal
   st_pt1=st_pt1+3*slen1;
   k1=k1-3;
end
end