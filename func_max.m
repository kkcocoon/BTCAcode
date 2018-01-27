function vm = func_max(i)
% % 
% % Reference:
% % K. K. Huang and D. Q. Dai, A new on-board image codec based on binary tree with adaptive scanning order in scan-based mode,
% % IEEE Transactions on Geoscience and Remote Sensing, vol. 50, no. 10, 3737-3750, October 2012
% % Email: kkcocoon@163.com
% %
% The max value of each sub-tree

global tree_max tlen

% if leaf
if 2*i > tlen    
    vm = tree_max(i);
    return
end

vm = max([func_max(2*i),func_max(2*i+1)]);

tree_max(i) = vm;