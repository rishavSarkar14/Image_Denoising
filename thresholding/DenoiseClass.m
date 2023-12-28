function denoised = NeighShrinkSUREdenoise(noisy, sigma, wtype, L)

    %% Determine parameters
    if nargin < 4
        L = 4;
    end
    if nargin < 3
        wtype = 'sym8';
    end
    
    % Apply DWT to noisy
    [C,S] = wavedec2(noisy,L,wtype);
    
    % Estimate noise level
    if nargin < 2
        d1 = detcoef2('d',C,S,1);
        sigma = median(abs(d1(:)))/0.6745;
    end
    
    %% Extract all detail subbands from C
    C = C/sigma; % normalize the noise level of the noisy coefficients
    for i = 1:L
        [H{i},V{i},D{i}] = detcoef2('all',C,S,i); 
    end
    
    % Threshold 3 details subbands in each scale
    for i = 1:L
            T_H{i} = SubbandThresholding(H{i});
        T_V{i} = SubbandThresholding(V{i});
        T_D{i} = SubbandThresholding(D{i});
    end
    
    %% Regroup the thresholded subbands to Matlab C and S structure
    t_C = C; 
    tail = S(1,1)*S(1,2); % the number of approximation coefficients
    for i = 1:L
    
        % The number of coefficients in decomposition level i
        num = S(i+1,1)*S(i+1,2);
    
        % Horizontal sbbband in decomposition level i
        head = tail+1;
        tail = head+num-1;
        t_C(head:tail)=(T_H{L-i+1}(:))';
    
    
        % Vertical sbbband in decomposition level i
        head = tail+1;
        tail = head+num-1;
        t_C(head:tail) = (T_V{L-i+1}(:))';
    
        % Diagonal sbbband in decomposition level i
        head = tail+1;
        tail = head+num-1;
        t_C(head:tail) = (T_D{L-i+1}(:))';
    
    end

    %% Reconstruct the denoised image
    denoised_norm = waverec2(t_C, S, wtype);
    denoised = denoised_norm*sigma;
end

function denoised = sureshrink(noisy)
	%% Wavelet transform
	Nlevels=4;
	NoOfBands=3*Nlevels+1;
	wname='db8';
	[C,S] = Wavelet_Decomposition(noisy,Nlevels,NoOfBands,wname);
	
	%% Wavelet Sureshrinkage
	Eband=cell(1,NoOfBands);
	for i=1:NoOfBands-1
		Sband=C{i};                 
		Sbandd = Sband(:); 
		n = length(Sbandd);
		Tlambda = 0:0.01:Sigma*sqrt(2*log(n));
		Sure_thr = zeros(1,length(Tlambda));
		for j = 1:length(Tlambda)
			T = Tlambda(j);        
			Temp1 = Sigma^2;
			Temp2 = (2*Sigma^2*(length(find(abs(Sbandd)<=T))))/n;
			Temp3 =(sum( min(abs(Sbandd),T).^2))/n;
			Sure_thr(j) = Temp1 - Temp2 + Temp3;
		end
		minn = min(Sure_thr);
		bb = find(Sure_thr==minn);
		Thr = Tlambda(bb);
		Tcoeff = wthresh(Sband,'s',Thr);
	%   Sband(abs(Sband)>Thr) = 0; % hard thresholding
		Eband{i}=Tcoeff;
	end
	Eband{i+1}=C{i+1};

	%% General Wavelet Reconstruction.
	[denoised] = Wavelet_Reconstruction(Eband,NoOfBands,S,wname);
end