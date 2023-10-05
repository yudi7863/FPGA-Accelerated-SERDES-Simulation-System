function out_data = pam4_TX(in_data)
    if(in_data == [0,0]) 
        out_data = -84;
    elseif(in_data == [0,1]) 
        out_data = -28; %[lsb,msb] v: []
    elseif(in_data == [1,0]) 
        out_data = 28;
    elseif(in_data == [1,1])
        out_data = 84;
    else
        disp('wrong value')
        %out_data = [-1,-1];
    end
end