function out_data = pam4_RX(in_data)
    if(in_data == -84) 
        out_data = [0,0];
    elseif(in_data == -28) 
        out_data = [0,1]; %[lsb,msb] v: []
    elseif(in_data == 28) 
        out_data = [1,0];
    elseif(in_data == 84)
        out_data = [1,1];
    else
        disp('wrong value')
        %out_data = [-1,-1];
    end
end