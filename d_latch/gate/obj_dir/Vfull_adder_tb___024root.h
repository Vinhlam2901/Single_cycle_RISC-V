// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design internal header
// See Vfull_adder_tb.h for the primary calling header

#ifndef VERILATED_VFULL_ADDER_TB___024ROOT_H_
#define VERILATED_VFULL_ADDER_TB___024ROOT_H_  // guard

#include "verilated_heavy.h"

//==========

class Vfull_adder_tb__Syms;

//----------

VL_MODULE(Vfull_adder_tb___024root) {
  public:

    // LOCAL SIGNALS
    CData/*0:0*/ full_adder_tb__DOT__a;
    CData/*0:0*/ full_adder_tb__DOT__b;
    CData/*0:0*/ full_adder_tb__DOT__c;
    CData/*0:0*/ full_adder_tb__DOT__sum;
    CData/*0:0*/ full_adder_tb__DOT__uut__DOT__w1;
    CData/*0:0*/ full_adder_tb__DOT__uut__DOT__w2;
    CData/*0:0*/ full_adder_tb__DOT__uut__DOT__w3;
    VlUnpacked<CData/*0:0*/, 8> full_adder_tb__DOT__a_tc;
    VlUnpacked<CData/*0:0*/, 8> full_adder_tb__DOT__b_tc;
    VlUnpacked<CData/*0:0*/, 8> full_adder_tb__DOT__c_tc;
    VlUnpacked<CData/*0:0*/, 8> full_adder_tb__DOT__sum_tc;
    VlUnpacked<CData/*0:0*/, 8> full_adder_tb__DOT__cout_tc;

    // LOCAL VARIABLES
    CData/*0:0*/ __Vchglast__TOP__full_adder_tb__DOT__sum;
    CData/*0:0*/ __Vchglast__TOP__full_adder_tb__DOT__uut__DOT__w2;
    CData/*0:0*/ __Vchglast__TOP__full_adder_tb__DOT__uut__DOT__w3;

    // INTERNAL VARIABLES
    Vfull_adder_tb__Syms* vlSymsp;  // Symbol table

    // CONSTRUCTORS
  private:
    VL_UNCOPYABLE(Vfull_adder_tb___024root);  ///< Copying not allowed
  public:
    Vfull_adder_tb___024root(const char* name);
    ~Vfull_adder_tb___024root();

    // INTERNAL METHODS
    void __Vconfigure(Vfull_adder_tb__Syms* symsp, bool first);
} VL_ATTR_ALIGNED(VL_CACHE_LINE_BYTES);

//----------


#endif  // guard
