module awm(clk,rst,start,doorclose,filled,detergent,cycletout,drained,spintout,doorlock, motoron, fillvalve, drainvalve, done, soapwash,waterwash);
  input clk,rst,start,doorclose,filled,detergent,cycletout,drained,spintout;
  output reg doorlock, motoron, fillvalve, drainvalve, done, soapwash,waterwash;
  parameter   doorcheck=3'b000,fillwater=3'b001,addet=3'b010,cycle=3'b011,drainwater=3'b100,spin=3'b101;
  reg[2:0] cs,ns;
  always @(posedge clk or rst)
    begin
      if(rst)
        cs<=doorcheck;
      else
        cs<=ns;
    end
  always@(cs or start or doorclose or filled or detergent or drained or cycletout or spintout)
    case(cs)
      doorcheck:
        if(start==1 && doorclose==1)
			begin
				ns<= fillwater;
				motoron = 0;
				fillvalve = 0;
				drainvalve = 0;
				doorlock = 1;
				soapwash = 0;
				waterwash = 0;
				done = 0;
            end
        else
	    begin
            ns<=doorcheck;
            motoron = 0;
            fillvalve = 0;
            drainvalve = 0;
            doorlock = 0;
            soapwash = 0;
            waterwash = 0;
            done = 0;
          end
      fillwater:
        if (filled==1)
			begin
				if(soapwash == 0)
				begin
					ns <= addet;
					motoron = 0;
					fillvalve = 0;
					drainvalve = 0;
					doorlock = 1;
					soapwash = 1;
					waterwash = 0;
					done = 0;
				end
				else
				begin
					ns <= cycle;
					motoron = 0;
					fillvalve = 0;
					drainvalve = 0;
					doorlock = 1;
					soapwash = 1;
					waterwash = 1;
					done = 0;
				end
            end
        else
          begin
            ns <= cs;
            motoron = 0;
            fillvalve = 1;
            drainvalve = 0;
            doorlock = 1;
            done = 0;
          end
      addet:
        if(detergent==1)
			begin
				ns<=cs;
				motoron = 0;
				fillvalve = 0;
				drainvalve = 0;
				doorlock = 1;
				soapwash = 1;
				done = 0;
			end
        else
          begin
            ns<=cs;
            motoron = 0;
            fillvalve = 0;
            drainvalve = 0;
            doorlock = 1;
            soapwash = 1;
            waterwash = 0;
            done = 0;
          end
      cycle:
        if(cycletout == 1)
          begin
            ns <= drainwater;
            motoron = 0;
            fillvalve = 0;
            drainvalve = 0;
            doorlock = 1;
            done = 0;
          end
        else
          begin
            ns <= cs;
            motoron = 1;
            fillvalve = 0;
            drainvalve = 0;
            doorlock = 1;
            done = 0;
          end
      drainwater:
        if(drained==1)
          begin
            if(waterwash==0)
              begin
                ns <= fillwater;
                motoron = 0;
                fillvalve = 0;
                drainvalve = 0;
                doorlock = 1;
                soapwash = 1;
                done = 0;
              end
            else
              begin
                ns = spin;
                motoron = 0;
                fillvalve = 0;
                drainvalve = 0;
                doorlock = 1;
                soapwash = 1;
                waterwash = 1;
                done = 0;
              end
          end
			else
			begin
				ns = cs;
				motoron = 0;
				fillvalve = 0;
				drainvalve = 1;
				doorlock = 1;
				soapwash = 1;
				done = 0;
			end
      spin:
        if(spintout==1)
          begin
            ns <= doorclose;
            motoron = 0;
            fillvalve = 0;
            drainvalve = 0;
            doorlock = 1;
            soapwash = 1;
            waterwash = 1;
            done = 1;
          end
        else
          begin
            ns <= cs;
            motoron = 0;
            fillvalve = 0;
            drainvalve = 1;
            doorlock = 1;
            soapwash = 1;
            waterwash = 1;
            done = 0;
          end
      default:
        begin
          ns<=doorcheck;
          motoron = 0;
            fillvalve = 0;
            drainvalve = 0;
            doorlock = 0;
            soapwash = 0;
            waterwash = 0;
            done = 0;
        end
    endcase
endmodule
