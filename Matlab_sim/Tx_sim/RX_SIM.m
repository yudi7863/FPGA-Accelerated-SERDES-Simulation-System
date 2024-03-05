clc
clear
order = 31;
num_data = 98;
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
h = [0.3, 0.4, 0.1, 0.1, 0.2];
approximation = zeros(length(h),2);
y = 8;
for i=1:length(h)
    x=round(h(i)/2.^((-1)*y));
    approximation(i,2)=y;
    approximation(i,1)=x;
end
h(1) = approximation(1, 1) * 2 ^ (-approximation(1, 2));
h(2) = approximation(2, 1) * 2 ^ (-approximation(2, 2));
h
channel_output = conv(PAM4_out, h);
channel_output

% With noise
% Generate random integer within range 0 to 1
noise_output = zeros(1,num_data_half+1);
for i = 1:length(channel_output)
    noise = 0;
    rand_num = rand();
    % Determine which noise it corresponds to
    if(rand_num < 0.25*1)
        noise = -1*28;
    elseif(rand_num < 0.75*1)
        noise = 0;
    else
        noise = 1*28;
    end
    noise_output(i) = channel_output(i) + noise;
end
noise_output

% DFE
% Define length
DFE_output = zeros(1,num_data_half);
for i = 1:num_data_half
    if (i == 1)
        DFE_output(i) = noise_output(i);
    else
        DFE_output(i) = noise_output(i) - 0.5 * DFE_output(i-1);
    end
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
PAM4_dfe

gray_dfe = zeros(ceil(double(num_data)/2.0),2);
for i = 1:num_data_half
    gray_dfe(i,:) = gray_decoder(PAM4_dfe(i,:));
end
gray_dfe

data_out = zeros(1,num_data);
for i = 1:num_data_half
    data_out(2*i-1) = gray_dfe(i,1);
    data_out(2*i) = gray_dfe(i,2);
end
c_randomdata
data_out

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

% Noise
pdf = [0.25, 0.5, 0.25];

%loopback to rx side:
