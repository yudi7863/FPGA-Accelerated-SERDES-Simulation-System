clc
clear
order = 31;
num_data = 98;
SEED = [1,1,0,1,0,0,0,1,0,1,0,1,1,0,1,0,0,1,0,0,1,0,1,0,0,0,1,1,1,1,1];
%SEED = [1,1,1,1,1,0,0,0,1,0,1,0,0,1,0,0,1,0,1,1,0,1,0,1,0,0,0,1,0,1,1]; %reverse???
prbs_length = 31;
%generating random data

%c_randomdata =zeros(num_data,data_length); -> not the same as verilog,
%need to figure otu waht is wrong
%c_randomdata = prbs(order,num_data,SEED);
 c_randomdata = prbs_gen(SEED,num_data)
%passing data to grey encoder:
gray_data = zeros(ceil(double(num_data)/2.0),2);
num_data_half = ceil(double(num_data)/2.0);
shifting_reg = [0,0];
count = 0;
grey_count = 1;
for i = 1:num_data
    shifting_reg(1) = shifting_reg(2);
    shifting_reg(2) = c_randomdata(i);
    count = count + 1;
    if(count == 2)
        count = 0;
        gray_data(grey_count,:) = gray_encoder(shifting_reg);
        grey_count = grey_count + 1;
    end
    if(grey_count > num_data_half)
        break;
    end
end

PAM4_out = zeros(1,num_data_half);

%%passing through pam-4
for i = 1:num_data_half
    PAM4_out(i) = pam4_TX(gray_data(i,:));
end

c_randomdata
gray_data
PAM4_out

%before looping to rx side: make sure that data matches verilog:
hold_var = to_verilog(PAM4_out,'pam4_output.mem',num_data_half);

%loopback to rx side:

