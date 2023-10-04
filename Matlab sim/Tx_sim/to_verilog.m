function  output_file = to_verilog(in_data,filename,size)
    %add data to output file:
        fileID = fopen(filename,'w');

    for i = 1: size
       fprintf(fileID,"%1d ", in_data(i));
    end
    output_file = fileID;
end