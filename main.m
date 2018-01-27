% % matlab code for BTCA(Binary Tree Coding with Adaptive scanning order)
% % unoptimized, without head information, without entropy coding.
% % Reference:
% % K. K. Huang and D. Q. Dai*, A new on-board image codec based on binary tree with adaptive scanning order in scan-based mode,
% % IEEE Transactions on Geoscience and Remote Sensing, vol. 50, no. 10, 3737-3750, October 2012
% % (IEEE TGRS 2012 IF=3.467)
% % Email: kkcocoon@163.com
% %

% =================================================================== 
clc;clear;
global level carow row tree tree_max tree_dec tlen ci cri brates I_ind Orig_I max_bits

imname =  'lena.bmp';
Orig_I = double(imread(imname));

% imname = 'coastal-b1.raw';
% Orig_I = func_ReadRaw(imname, 1024*1024, 1024, 1024);

[row, col] = size(Orig_I);

% bit rates [128:1, 64:1, 32:1, 16:1, 8:1]
brates = [row*col];
for bi=1:4
    brates = [brates(1)/2, brates];
end
brates = round(brates);

% =================================================================== 
% Wavelet Decomposition 
n = size(Orig_I,1);
n_log = log2(n); 

level = 5; 

carow = 2^(n_log-level);

I_W = wavecdf97(Orig_I, level);

% =================================================================== 
% max bitrate
rate = 1; 
max_bits = floor(rate * n^2);

% Select threshold 
MaxDecIm=max(max(abs(I_W)));
T=2^floor(log2(MaxDecIm));
i=1;
while T(i) > 2
    i=i+1;
    T(i) = T(i-1)/2;
end
codeDim = i;

% coding =================================================================== 
disp('% BTCA Coding ...');
BTime = clock;

tree = zeros(1,2*row*col-1);  % linear storage structure for binary tree
tlen = length(tree);  

scanorder = get_scanorder([row,col]);
I_ind = ((scanorder(:,2)-1)*row) + scanorder(:,1); % scanning order of 1D
scanlist = [(1:size(scanorder,1))', scanorder, I_W(I_ind)];

tree_max = zeros(1,2*row*col-1);  % record the max value of each sub-tree
tree_max(end-row*col+1:end) = abs(I_W(I_ind)'); 
vm = func_max(1); % global variable: tree_max, tlen

% The sign of leaf nodes
tree_max(end-row*col+1:end) = tree_max(end-row*col+1:end) .* sign(I_W(I_ind)');

codeList=[];
codeRef=[];

% Before traversing the tree by levels, 
% we should traverse the tree by depth with T0, so that there are
% previous significant nodes with smaller thresholds.
codeList = func_Enc(1,T(1));

for d=2:codeDim

%     codeList = [codeList, func_Enc(1,T(d))]; % traverse by depth
    codeList = [codeList, func_Enc_lev(T(d))]; % traverse by levels

    % a refinement pass is performed in order to refine all the coefficients found to be significant.
    aa = tree(end-row*row+1:end);
    Lsp = find(aa>T(d));

    value = floor(abs(scanlist(Lsp,4)));
    n = log2(T(d));
    sb = bitget(value,n+1);
    codeRef = [codeRef; sb];
    
    if length(codeList)+length(codeRef)>max_bits
        break;
    end
end

disp(['% Coding time: ' num2str(etime(clock,BTime)) ' s.']);

% Decoding =================================================================== 
disp('% BTCA Decoding ...');
BTime = clock;

tree_dec = zeros(size(tree));
ci=0;
cri=0;

disp(['BTCA_' imname ' = [']);

func_Dec(codeList,1,T(1));

for d=2:codeDim
    
%     func_Dec(codeList,1,T(d));
    func_Dec_lev(codeList,T(d));
        
    if d==1
        continue;
    end
    
    aa = tree_dec(end-row*row+1:end);
    Lsp = find(abs(aa) >= T(d-1));
    
    if length(Lsp)==0
        continue;
    end    
    
    sb = codeRef(cri+1:cri+length(Lsp))';
    cri=cri+length(Lsp);
    
    aa(Lsp) = aa(Lsp) + ((-1).^(sb + 1)) .* T(d)/2 .* sign(aa(Lsp));
  
    tree_dec(end-row*row+1:end) = aa;
    
    if ci+cri>max_bits
        break;
    end
end

disp(['];']);

disp(['% Decoding time: ' num2str(etime(clock,BTime)) ' s.']);

% =================================================================== 
    
% aa = tree_dec(end-row*row+1:end);
% I_W_dec = zeros(size(I_W));
% I_W_dec(I_ind) = aa';
% 
% img_dec = wavecdf97(I_W_dec, -level);
% Q = 255;
% MSE = sum(sum((img_dec - Orig_I) .^ 2)) / (row*col);
% psnr = 10*log10(Q*Q/MSE);

