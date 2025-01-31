module rx_tx_interface_demo
(
    input CLK,
	 input RSTn,
	 
	 input RX_Pin_In,
	 output TX_Pin_Out,
	 output [23:0]iClk 
);

    /******************************/
	 
	 wire [7:0]FIFO_Read_Data /*synthesis keep*/;
	 wire Empty_Sig;
	 
	 Accumulator_module U4
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .Result( iClk )
	 );
	 
	 rx_interface U1
	 (
	     .CLK( CLK ),
		  .RSTn( RSTn ),
		  .RX_Pin_In( RX_Pin_In ),           // input - from top
		  .Read_Req_Sig( Read_Req_Sig ),     // input - from U2
		  .FIFO_Read_Data( FIFO_Read_Data ), // output - to U2
		  .Empty_Sig( Empty_Sig )                // output - to U2
	 );
	 
	  /******************************/ 
	  
	  wire Read_Req_Sig;
	  wire [7:0]FIFO_Write_Data;
	  wire Write_Req_Sig;
	  
	  inter_control_module U2
	  (
	      .CLK( CLK ),
			.RSTn( RSTn ),
			.Empty_Sig( Empty_Sig ),                 // input - from U1
		   .FIFO_Read_Data( FIFO_Read_Data ),   // input - from U1
			.Read_Req_Sig( Read_Req_Sig ),       // output - to U1
		   .Full_Sig( Full_Sig ),               // input - from U3
		   .FIFO_Write_Data( FIFO_Write_Data ), // output - to U3
		   .Write_Req_Sig( Write_Req_Sig )	    // output - to U3
	  );
	  
	  /******************************/
	  
	  wire Full_Sig;
	  
	  tx_interface U3
	  (
	      .CLK( CLK ),
			.RSTn( RSTn ),
			.Write_Req_Sig( Write_Req_Sig ),     // input - from U2
			.FIFO_Write_Data( FIFO_Write_Data ), // input - from U2
			.Full_Sig( Full_Sig ),               // output - to U2
			.TX_Pin_Out( TX_Pin_Out )            // output - to top
	  );
	  
	  /******************************/

	//  assign TX_Pin_Out = RX_Pin_In;
endmodule
