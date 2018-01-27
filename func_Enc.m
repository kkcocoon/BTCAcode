function codeList = func_Enc(i,Tk)
% % 
% % Reference:
% % K. K. Huang and D. Q. Dai, A new on-board image codec based on binary tree with adaptive scanning order in scan-based mode,
% % IEEE Transactions on Geoscience and Remote Sensing, vol. 50, no. 10, 3737-3750, October 2012
% % Email: kkcocoon@163.com
% %
% traverse by depth

global row tree tree_max tlen

tlen = length(tree);

% If it has been coded with significant in larger threshold
if tree(i)~=0
    if (2*i<=tlen)  % not leaf
        codeList = [func_Enc(2*i,Tk),func_Enc(2*i+1,Tk)];
    else
        codeList = [];
    end
    return;
end

% if it has a significant parent and its brother has just been coded with insignificant
if i>1 & mod(i,2)==1 & tree(i-1)==0
% if i>1 & mod(i,2)==1 & tree(i-1)==0 & tree((i-1)/2)==Tk
    tree(i) = Tk;
    if (2*i<=tlen) 
        codeList = [func_Enc(2*i,Tk),func_Enc(2*i+1,Tk)];
    else
        codeList = sign(tree_max(i));   % leaf
    end
    return;
end

if abs(tree_max(i)) >= Tk 
    tree(i) = Tk;
    if (2*i<=tlen) 
        codeList = [1,func_Enc(2*i,Tk),func_Enc(2*i+1,Tk)];
    else
        codeList = [1, sign(tree_max(i))];   % leaf, code sign
    end    
else
    codeList = 0; 
end
