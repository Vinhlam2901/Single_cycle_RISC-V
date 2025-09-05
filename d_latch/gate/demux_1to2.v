module demux_1to2 (
    input s,
    input d,
    output y0,
    output y1
);
  not (sn, s);
  and (y0, sn, d);
  and (y1, s, d);
endmodule

