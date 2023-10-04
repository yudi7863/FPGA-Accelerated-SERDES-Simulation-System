function out_data = gray_encoder(in_data)
    if(in_data == [0,0]) 
        out_data = [0,0];
    elseif(in_data == [1,0]) 
        out_data = [1,0]; %[lsb,msb] v: []
    elseif(in_data == [0,1]) 
        out_data = [1,1];
    elseif(in_data == [1,1])
        out_data = [0,1];
    else
        disp('wrong value')
        %out_data = [-1,-1];
    end
end