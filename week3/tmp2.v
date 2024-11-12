 `timescale 1ns/1ps
 module top_module ( 
     input a, 
     input b, 
     input c,
     input d,
     output out1,
     output out2
 );
     mod_a u_mod_a (
         .in1(a),
         .in2(b),
         .in3(c),
         .in4(d),
         .out1(out1),
         .out2(out2)      
     );
 endmodule