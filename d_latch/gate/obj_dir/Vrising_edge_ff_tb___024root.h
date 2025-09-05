// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vrising_edge_ff_tb.h for the primary calling header

#ifndef VERILATED_VRISING_EDGE_FF_TB___024ROOT_H_
#define VERILATED_VRISING_EDGE_FF_TB___024ROOT_H_  // guard

#include "verilated_heavy.h"

//==========

class Vrising_edge_ff_tb__Syms;

//----------

VL_MODULE(Vrising_edge_ff_tb___024root) {
  public:

    // PORTS
    VL_IN8(clk,0,0);
    VL_IN8(data,0,0);
    VL_OUT8(q,0,0);

    // LOCAL SIGNALS
    CData/*0:0*/ rising_edge_ff_tb__DOT__clk;
    CData/*0:0*/ rising_edge_ff_tb__DOT__data;
    CData/*0:0*/ rising_edge_ff_tb__DOT__q;

    // LOCAL VARIABLES
    CData/*0:0*/ __VinpClk__TOP__rising_edge_ff_tb__DOT__clk;
    CData/*0:0*/ __Vclklast__TOP____VinpClk__TOP__rising_edge_ff_tb__DOT__clk;
    CData/*0:0*/ __Vclklast__TOP__clk;
    CData/*0:0*/ __Vchglast__TOP__rising_edge_ff_tb__DOT__clk;

    // INTERNAL VARIABLES
    Vrising_edge_ff_tb__Syms* vlSymsp;  // Symbol table

    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vrising_edge_ff_tb___024root);  ///< Copying not allowed
  public:
    Vrising_edge_ff_tb___024root(const char* name);
    ~Vrising_edge_ff_tb___024root();

    // INTERNAL METHODS
    void __Vconfigure(Vrising_edge_ff_tb__Syms* symsp, bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
