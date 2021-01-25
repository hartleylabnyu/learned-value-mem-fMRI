function memTestArray = shufflerows(memTestArray, idx, idx2, numItems)
 if isempty(idx) == 0 %if there are problematic rows
    for i = 1:length(idx)
        rowIdx = idx(i); %identify the problematic row
        swapRow = randi(4,1); %generate random row to swap with
        swapStamp1 = memTestArray(rowIdx, 3);
        swapStamp2 = memTestArray((swapRow), 3);
        memTestArray(rowIdx, 3) = swapStamp2;
        memTestArray(swapRow,3) = swapStamp1;
    end
 end

    
 if isempty(idx2) == 0
     for i = 1:length(idx2)
        rowIdx = idx2(i);
        swapRow = randi(4,1);
        swapStamp1 = memTestArray(rowIdx, 4);
        swapStamp2 = memTestArray(swapRow, 4);
        memTestArray(rowIdx, 4) = swapStamp2;
        memTestArray(swapRow,4) = swapStamp1;
     end
 end

end

