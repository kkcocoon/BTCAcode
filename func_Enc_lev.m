function codeList = func_Enc_lev(Tk)
% % Reference:
% % K. K. Huang and D. Q. Dai, A new on-board image codec based on binary tree with adaptive scanning order in scan-based mode,
% % IEEE Transactions on Geoscience and Remote Sensing, vol. 50, no. 10, 3737-3750, October 2012
% % Email: kkcocoon@163.com
% %
% Traverse by level
% From bottom to the top of the tree, we find the brother of previous significant nodes to traverse.

global row tree tlen 

tl = log(row*row)/log(2);
tlen = sum(2.^(0:tl));

ei = tlen;
bi = ei - 2^tl + 1;

codeList = [];

ti=tl;
while bi>1
    Ind = bi:ei;
    
    di = find(tree(Ind)>=Tk);     % significant nodes
    dj0 = find(mod(Ind(di),2)==0); % significant nodes in the left sub-tree
    dj1 = find(mod(Ind(di),2)==1); %  significant nodes in the right sub-tree
    Jnd = [Ind(di(dj0)) + 1, Ind(di(dj1)) - 1]; % neighbors of significant nodes
    Jnd(find(tree(Jnd)>=Tk))=[];   % delete previous significant nodes
    
    for j=Jnd                       
        codeList = [codeList, func_Enc(j,Tk)];
    end   
    
    ti=ti-1;
    ei = bi - 1;
    bi = ei - 2^ti + 1;
end
