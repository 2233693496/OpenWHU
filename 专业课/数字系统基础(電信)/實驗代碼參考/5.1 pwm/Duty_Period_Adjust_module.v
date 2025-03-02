module Duty_Period_Adjust_module
(
	CLK, RSTn, AddDuty_In, SubDuty_In, AddPeriod_In, SubPeriod_In, Duty, Count_P
);
	 input CLK;
	 input RSTn;
	 input AddDuty_In;  //Add Duty Ratio
	 input SubDuty_In;	//Subtract Duty Ratio
	 input AddPeriod_In;		//Add Period
	 input SubPeriod_In;		//Subtract Period
	 output reg [7:0]Duty;		//Duty Ratio of PWM
	 output reg [23:0]Count_P;	//period of PWM = Count_P/50_000_000
	 
	 wire neg_AddDuty;
	 wire neg_SubDuty;
	 wire neg_AddPeriod;
	 wire neg_SubPeriod;
	 
	Jitter_Elimination_module U1	
	(	
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.Button_In( AddDuty_In ) ,  	//While AdjtDuty_In from 1 to 0, neg_AddDuty = 1			
		.Button_Out( neg_AddDuty ) 	
	);
	
	Jitter_Elimination_module U2
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.Button_In( SubDuty_In ) ,		//While SubDuty_In from 1 to 0, neg_SubDuty = 1	
		.Button_Out( neg_SubDuty ) 	
	);

	Jitter_Elimination_module U3
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.Button_In( AddPeriod_In ) ,		//While AddPeriod_In from 1 to 0, neg_AddPeriod = 1			
		.Button_Out( neg_AddPeriod ) 	
	);
	
	Jitter_Elimination_module U4
	(
		.CLK( CLK ) ,	
		.RSTn( RSTn ) ,	
		.Button_In( SubPeriod_In ) ,		//While SubPeriod_In from 1 to 0, neg_SubPeriod = 1	
		.Button_Out( neg_SubPeriod ) 	
	);
	 
	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn )
				Duty <= 'd50;
			else if( neg_AddDuty == 1'b1 )
				if( Duty == 'd100 )
					Duty <= 'd0;
				else 			
					Duty <= Duty + 'd10;
			else if( neg_SubDuty == 1'b1 )
				if( Duty == 'd0 )
					Duty <= 'd100;
				else 			
					Duty <= Duty - 'd10;
			else
				Duty <= Duty;
		end
/*******************
While Count_P = 500_000, Period of PWM = 10ms, Frequency of PWM = 100HZ ;
While Count_P = 250_000, Period of PWM = 5ms, Frequency of PWM = 200HZ ;
While Count_P = 50_000, Period of PWM = 1ms, Frequency of PWM = 1000HZ ;
*******************/
	always @ ( posedge CLK or negedge RSTn )
		begin
			if( !RSTn )
				Count_P <= 'd250_000;
			else if( neg_AddPeriod == 1'b1 )
				begin
					if( Count_P == 'd500_000 )
						Count_P <= 'd50_000;  
					else 			
						Count_P <= Count_P + 'd50_000;
				end
			else if( neg_SubPeriod == 1'b1 )
				begin
					if( Count_P == 'd50_000 )
						Count_P <= 'd500_000;  
					else 			
						Count_P <= Count_P - 'd50_000;
				end	
			else
				Count_P <= Count_P;
		end
			
endmodule
		