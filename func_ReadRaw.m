function result = func_ReadRaw(filename, nSize, nRow, nColumn)
% % 
% % Reference:
% % K. K. Huang and D. Q. Dai, A new on-board image codec based on binary tree with adaptive scanning order in scan-based mode,
% % IEEE Transactions on Geoscience and Remote Sensing, vol. 50, no. 10, 3737-3750, October 2012
% % Email: kkcocoon@163.com
% %

fid = fopen(filename,'rb');
if (fid==1)
   error('Cannot open image file...press CTRL-C to exit ');pause
end
temp = fread(fid, nSize, 'uchar');
fclose(fid);
result = reshape(temp, [nRow nColumn])';

