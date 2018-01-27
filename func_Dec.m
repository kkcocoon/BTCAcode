function func_Dec(codeList,i,Tk)
% % 
% % Reference:
% % K. K. Huang and D. Q. Dai, A new on-board image codec based on binary tree with adaptive scanning order in scan-based mode,
% % IEEE Transactions on Geoscience and Remote Sensing, vol. 50, no. 10, 3737-3750, October 2012
% % Email: kkcocoon@163.com
% %

global tree_dec tlen ci cri brates row level Orig_I I_ind

% if i > tlen
%     return
% end

% if length(brates)==0
%     return
% end

if tree_dec(i) ~= 0
    if (2*i<=tlen)
        func_Dec(codeList, 2*i,Tk);
        func_Dec(codeList, 2*i+1,Tk);
    end
    return;
end

if i>1 & mod(i,2)==1 & tree_dec(i-1)==0 & tree_dec((i-1)/2)==Tk
    tree_dec(i) = Tk;
    if (2*i<=tlen)          
        func_Dec(codeList, 2*i,Tk);
        func_Dec(codeList, 2*i+1,Tk);
    else
        ci=ci+1;
        tree_dec(i) = codeList(ci)*(Tk+Tk/2); 
    end
    return;
end


ci=ci+1;
if codeList(ci) == 1 
    tree_dec(i) = Tk;
    if (2*i<=tlen)  
        func_Dec(codeList, 2*i,Tk);
        func_Dec(codeList, 2*i+1,Tk);
    else
        ci=ci+1;
        tree_dec(i) = codeList(ci)*(Tk+Tk/2); 
        
        % calculate PSNR
        lci = find((ci+cri)>=brates);
        if length(lci)>0
            aa = tree_dec(end-row*row+1:end);
            I_W_dec = zeros(row,row);
            I_W_dec(I_ind) = aa';
            
            img_dec = wavecdf97(I_W_dec, -level);
            MSE = sum(sum((img_dec - Orig_I) .^ 2)) / (row*row);
            psnr = 10*log10(255*255/MSE);
            
            disp([num2str(psnr), ', ',num2str(row*row*8/(ci+cri))]);

            brates(lci)=[];            
        end
    end
else
    tree_dec(i) = 0;
end