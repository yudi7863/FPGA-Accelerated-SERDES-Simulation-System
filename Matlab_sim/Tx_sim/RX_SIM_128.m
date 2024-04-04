clc
clear
order = 31;
num_data = 50000;
SEED = [1,1,0,1,0,0,0,1,0,1,0,1,1,0,1,0,0,1,0,0,1,0,1,0,0,0,1,1,1,1,1];
prbs_length = 31;
% Generating random data
c_randomdata = prbs_gen(SEED,num_data);
% Passing data to gray encoder
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

%pass through channel
h = [1, 0.5];
channel_output = conv(PAM4_out, h);
channel_output

% Noise
noise_array = [-63:64];
mu = 0;
sigma = 15;
probability = pdf('Normal', noise_array, mu, sigma);
%total_probability = 0;
%for i = 1:length(probability)
%    total_probability = total_probability + probability(i);
%end
%for i = 1:length(probability)
%    probability(i) = probability(i)/total_probability;
%end
possibilities = zeros(1, length(probability));
for i = 1:length(probability)
    if i == 1
        possibilities(i) = probability(i)*(2^64-1)+0;
    else
        possibilities(i) = probability(i)*(2^64-1)+possibilities(i-1);
    end
    %var=dec2bin(probability_verilog_helper(i),64);
    %display(var);
end
%probability
%possibilities
%total_probability
%sprintf('%d is noise output.',noise_output(i));

probability_verilog_helper_var = noise_to_verilog(possibilities,'probability_verilog_helper.mem',length(probability),64);

% With noise
% Generate random integer within range 0 to 1
noise_value_array = zeros(1,num_data_half+1);
noise_output = zeros(1,num_data_half+1);
for i = 1:length(channel_output)
    noise = 0;
    rand_num = rand();
    % Determine which noise it corresponds to
    total_prob = 0;
    for j = 1:length(probability)
        if(rand_num < total_prob + probability(j))
            noise = j - 64;
            %X = sprintf('%d is noise.',noise);
            %disp(X)
            break;
        end
        total_prob = total_prob + probability(j);
    end
    noise_value_array(i)=noise;
    noise_output(i) = channel_output(i) + noise;
    %Y = sprintf('%d is noise output.',noise_output(i));
    %disp(Y)
end
%noise_value_array
%noise_var=noise_to_verilog(noise_value_array,'noise.mem',num_data_half+1,8);
%noise_output = channel_output;
noise_output

% DFE
% Define length
DFE_output = zeros(1,num_data_half);
for i = 1:num_data_half
    %if (i == 1)
    %    DFE_output(i) = noise_output(i);
    %else
    %    DFE_output(i) = noise_output(i) - 0.5 * DFE_output(i-1);
    %end
    DFE_output(i) = noise_output(i);
    for j = 1:(length(h)-1)
        if (j < i)
            DFE_output(i) = DFE_output(i) - h(j+1) * DFE_output(i-j);
        end
    end
    DFE_output(i) = DFE_output(i) / h(1);
    % Make decision
    if(DFE_output(i) >= 56)
        DFE_output(i) = 84;
    elseif((DFE_output(i) >= 0) && (DFE_output(i) < 56))
        DFE_output(i) = 28;
    elseif((DFE_output(i) >= -56) && (DFE_output(i) < 0))
        DFE_output(i) = -28;
    else
        DFE_output(i) = -84;
    end
end
DFE_output

PAM4_dfe = zeros(ceil(double(num_data)/2.0),2);
for i = 1:num_data_half
    PAM4_dfe(i,:) = pam4_RX(DFE_output(i));
end
%PAM4_dfe

gray_dfe = zeros(ceil(double(num_data)/2.0),2);
for i = 1:num_data_half
    gray_dfe(i,:) = gray_decoder(PAM4_dfe(i,:));
end
%gray_dfe

data_out = zeros(1,num_data);
for i = 1:num_data_half
    data_out(2*i-1) = gray_dfe(i,1);
    data_out(2*i) = gray_dfe(i,2);
end
%c_randomdata
%data_out

% Calculate bit error rate
error = 0;
for i = 1:num_data
    if (c_randomdata(i) ~= data_out(i))
        error = error + 1;
    end
end
bit_error_rate = error/num_data;
num_data
bit_error_rate

%loopback to rx side:
