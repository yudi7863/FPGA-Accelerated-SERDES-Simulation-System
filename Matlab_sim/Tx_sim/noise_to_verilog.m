function output_file = noise_to_verilog(in_data,filename,size,num_bits)
    %open the output file for writing
    fileID = fopen(filename,'w');

    %Iterate through each element in in_data
    for i = 1:size
        %convert the current number to binary representation
        if num_bits ==8 
            binVal = dec2bin(typecast(int8(in_data(i)), 'uint8'),8);
        elseif num_bits == 64
            %if sum(dec2bin(in_data(i),64) == 10000000000000000000000000000000000000000000000000011000000000000)==64
                %binVal = 1111111111111111111111111111111111111111111111111111111111111111
            %else
                binVal = dec2bin(in_data(i),64);
            %end
        end
        fprintf(fileID, '%s\n',binVal);
    end

    fclose(fileID);

    output_file = filename;
end