function  output_file = to_verilog(in_data,filename,size)
    %add data to output file:
        fileID = fopen(filename,'w');

    for i = 1: size
        switch in_data(i)
            case -84
                binVal = [1,0,1,0,1,1,0,0];
            case -28
                binVal = [1,1,1,0,0,1,0,0];
            case 28
                binVal = [0,0,0,1,1,1,0,0];
            case 84
                binVal = [0,1,0,1,0,1,0,0];
            otherwise
                binVal = [1,1,1,1,1,1,1,1];
        end
        for j = 1:8
            fprintf(fileID,"%1d", binVal(j));
        end
        fprintf(fileID," ");
    end
    output_file = fileID;
end