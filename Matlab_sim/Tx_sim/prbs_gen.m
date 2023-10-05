function  [outdata] = prbs_gen(SEED, data_length)
    %add data to output file:
    outdata = zeros(1, data_length);
    temp = SEED;
    temp
    for i = 1:data_length
        %need to shift through the seed
        sr_in = xor(temp(1), temp(4));
        temp = cat(2,temp(2:size(SEED,2)),sr_in);
        outdata(i) = sr_in;
        temp
    end
end