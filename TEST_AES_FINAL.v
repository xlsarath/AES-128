module AES_TESTBENCH;
reg		clk;
reg		rst;
reg		kld;
reg	[255:0]	key; 
reg	[127:0]	text_in;
wire	[127:0]	enc_data;
reg	[127:0]	dec_data;
wire  [127:0]  temp;
wire		enc_complete;
wire  dec_complete;
AES_ENCRYPT inst_enc(
	.clk(		clk		),
	.rst(		rst		),   
	.ld(		kld		),
	.done(enc_complete),
	.key(		key		),
	.text_in(	text_in		),
	.text_out(enc_data	)
	);

AES_DECRYPT inst_dec(
	.clk(		clk		),
	.rst(		rst		),
	.kld(		kld		),
	.ld(enc_complete),
	.done(dec_complete),
	.key(key),
	.text_in(enc_data),
	.text_out(temp)
	);


initial
begin
    clk=0;
    rst=0;
    kld=1;
end



initial
begin
    #100; kld=1;key=255'd107;text_in=128'd100; rst=1;
    #10;  kld=0; 
    

end

always #5 clk = ~clk;

always@(posedge clk or dec_complete)
	begin
	if(!rst)
		dec_data <= 128'd0;
	else if(kld)
		dec_data <= 128'd0;
	else if(dec_complete)
		dec_data <= text_in;
	else;
	
	end

always @(posedge clk)
begin
    
    if(enc_complete)
    begin
    $display("INPUT DATA=%b",text_in);
    $display("KEY DATA=%b",key);
    $display("AES ENCRYPT DATA=%b",enc_data);
    end

    
    if(dec_complete)
    begin
     $display("AES DECRYPT DATA=%b",dec_data);
     #100 $finish;   
    end
    

end


endmodule
