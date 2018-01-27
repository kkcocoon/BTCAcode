function [scanorder,rbs,cbs] = get_scanorder(blksize)

% get morton scanning order
% The function can deal with irregular block whose size is arbitrary and not equal to 2^N¡Á2^N

brow = blksize(1);
bcol = blksize(2);

if bcol==1
     scanorder = [1 1];
     return;
end

% 1:2 rectangle
% scanorder = [1,1;1,2];
% rbs = 1; 
% cbs = 2;

scanorder = [1,1];
rbs = 1; 
cbs = 1;

while rbs < brow | cbs < bcol    
    if cbs<bcol
        hor = scanorder;
        hor(:,2) = hor(:,2) + cbs;  
        
        if 2*cbs>bcol
            L = find(hor(:,2) > bcol);
            hor(L,:) = [];
        end
    else
        hor = [];
    end
    
    if rbs<brow
        vor = scanorder;
        vor(:,1) = vor(:,1) + rbs;
        
        if 2*rbs>brow
            L = find(vor(:,1) > brow);
            vor(L,:) = [];
        end        
    else
        vor = [];
    end
    
    if cbs<bcol & rbs<brow
        dor = scanorder;
        dor(:,1) = dor(:,1) + rbs;
        dor(:,2) = dor(:,2) + cbs;

        if 2*rbs>brow
            L = find(dor(:,1) > brow);
            dor(L,:) = [];
        end          
        if 2*cbs>bcol
            L = find(dor(:,2) > bcol);
            dor(L,:) = [];
        end        
    else
        dor = [];
    end
    
    scanorder = [scanorder; hor; vor; dor];
    
    if rbs < brow 
        rbs = rbs*2;
    end
    if cbs < bcol
        cbs = cbs*2;
    end
end
