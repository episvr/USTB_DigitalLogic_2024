// 2024.9.23 Epi Week 2 code 5
// target: AND ,then OR
module top_module(input a,input b,input c,input d,output out,output out_n); 
  wire a_and_b=a&b;
  wire c_and_d=c&d;
  wire ans = a_and_b | c_and_d;
  assign out=ans;
  assign out_n=~ans;
endmodule