module hexDisplay(
		input clk,
		input rstn,
		input [7:0] voltage_level,
		input voltage_valid,
		output [6:0] ones_digit,
		output [6:0] tens_digit,
		output [6:0] hund_digit,
		output [6:0] neg
		);
	
		always  @ (posedge clk) begin
        if (!rstn) begin
				//set every bit on:
				ones_digit <= 'b1111111;
				tens_digit <= 'b1111111;
				hund_digit <= 'b1111111;
				neg <= 'b0;
			end
			else begin
				if(voltage_valid == 'b1) begin
					case(voltage_level)
						'b10101100: begin //this is -84
									neg <= 'b1000000;
									hund_digit <= 'b0;
									tens_digit <= 'b1111111;
									ones_digit <= 'b1100110;
								end
						'b11100100: begin // this is -28
									neg <= 'b1000000;
									hund_digit <= 'b0;
									tens_digit <= 'b1011011;
									ones_digit <= 'b1111111;
								end
						'b00011100: begin//28
									neg <= 'b0000000;
									hund_digit <= 'b0;
									tens_digit <= 'b1011011;
									ones_digit <= 'b1111111;
									
								end
						'b01010100: begin //84
									neg <= 'b1000000;
									hund_digit <= 'b0;
									tens_digit <= 'b1111111;
									ones_digit <= 'b1100110;
								end
						default: begin
									ones_digit <= 'b0;
									tens_digit <= 'b0;
									hund_digit <= 'b0;
									neg <= 'b0;
								end
					endcase
				end
			
			end
		end
		

endmodule
			