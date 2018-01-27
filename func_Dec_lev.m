function codeList = func_Dec_lev(codeList,Tk)
% % 
% % Reference:
% % K. K. Huang and D. Q. Dai, A new on-board image codec based on binary tree with adaptive scanning order in scan-based mode,
% % IEEE Transactions on Geoscience and Remote Sensing, vol. 50, no. 10, 3737-3750, October 2012
% % Email: kkcocoon@163.com
% %

global row tree_dec tlen

tl = log(row*row)/log(2);
tlen = sum(2.^(0:tl));

ei = tlen;
bi = ei - 2^tl + 1;

ti=tl;
while bi>1
    Ind = bi:ei;
    
    di = find(abs(tree_dec(Ind))>=Tk);   
    dj0 = find(mod(Ind(di),2)==0); 
    dj1 = find(mod(Ind(di),2)==1); 
    Jnd = [Ind(di(dj0)) + 1, Ind(di(dj1)) - 1]; 
    Jnd(find(abs(tree_dec(Jnd))>=Tk))=[];  
    
    for j=Jnd        
        func_Dec(codeList,j,Tk);
    end
    
    ti=ti-1;
    ei = bi - 1;
    bi = ei - 2^ti + 1;
end
