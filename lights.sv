module lights (clk, reset, SW, LEDR);
    input logic clk, reset;
    input logic [1:0] SW;
    output logic [2:0] LEDR;
    
    enum {state010, state001, state100, state101} ps, ns;
    
    always_comb begin
        case (ps)
            state101: ns = (SW == 2'b00) ? state010 :
                            (SW == 2'b01) ? state001 :
                            (SW == 2'b10) ? state100 : state101;
            
            state010: ns = (SW == 2'b00) ? state101 :
                            (SW == 2'b01) ? state100 :
                            (SW == 2'b10) ? state001 : state010;
            
            state001: ns = (SW == 2'b01) ? state010 :
                            (SW == 2'b10) ? state100 :
                            (SW == 2'b00) ? state010 : state001;
            
            state100: ns = (SW == 2'b10) ? state010 :
                            (SW == 2'b01) ? state001 :
                            (SW == 2'b00) ? state010 : state100;
            
            default: ns = state010;
        endcase
    end

    always_comb begin
        case (ps)
            state101: LEDR = 3'b101;
            state010: LEDR = 3'b010;
            state001: LEDR = 3'b001;
            state100: LEDR = 3'b100;
            default: LEDR = 3'b000;
        endcase
    end
    
    always_ff @(posedge clk) begin
        if (reset)
            ps <= state010;
        else 
            ps <= ns;
    end
endmodule
