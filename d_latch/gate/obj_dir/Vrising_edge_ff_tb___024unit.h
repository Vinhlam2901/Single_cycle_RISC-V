// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vrising_edge_ff_tb.h for the primary calling header

#ifndef VERILATED_VRISING_EDGE_FF_TB___024UNIT_H_
#define VERILATED_VRISING_EDGE_FF_TB___024UNIT_H_  // guard

#include "verilated_heavy.h"

//==========

class Vrising_edge_ff_tb__Syms;

//----------

VL_MODULE(Vrising_edge_ff_tb___024unit) {
  public:

    // LOCAL VARIABLES
    CData/*0:0*/ __VmonitorOff;
    QData/*63:0*/ __VmonitorNum;

    // INTERNAL VARIABLES
    Vrising_edge_ff_tb__Syms* vlSymsp;  // Symbol table

    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vrising_edge_ff_tb___024unit);  ///< Copying not allowed
  public:
    Vrising_edge_ff_tb___024unit(const char* name);
    ~Vrising_edge_ff_tb___024unit();

    // INTERNAL METHODS
    void __Vconfigure(Vrising_edge_ff_tb__Syms* symsp, bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
