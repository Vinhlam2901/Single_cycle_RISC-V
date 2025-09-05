// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrising_edge_ff_tb.h for the primary calling header

#include "Vrising_edge_ff_tb___024root.h"
#include "Vrising_edge_ff_tb__Syms.h"

//==========


void Vrising_edge_ff_tb___024root___ctor_var_reset(Vrising_edge_ff_tb___024root* vlSelf);

Vrising_edge_ff_tb___024root::Vrising_edge_ff_tb___024root(const char* _vcname__)
    : VerilatedModule(_vcname__)
 {
    // Reset structure values
    Vrising_edge_ff_tb___024root___ctor_var_reset(this);
}

void Vrising_edge_ff_tb___024root::__Vconfigure(Vrising_edge_ff_tb__Syms* _vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->vlSymsp = _vlSymsp;
}

Vrising_edge_ff_tb___024root::~Vrising_edge_ff_tb___024root() {
}

void Vrising_edge_ff_tb___024root___initial__TOP__5(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___initial__TOP__5\n"); );
    // Variables
    CData/*0:0*/ __Vtask_rising_edge_ff_tb__DOT__check__0__expected;
    CData/*0:0*/ __Vtask_rising_edge_ff_tb__DOT__check__1__expected;
    CData/*0:0*/ __Vtask_rising_edge_ff_tb__DOT__check__2__expected;
    // Body
    VL_WRITEF("\360\237\224\215 B\341\272\257t \304\221\341\272\247u m\303\264 ph\341\273\217ng falling_edge_ff_tb...\n");
    vlSelf->rising_edge_ff_tb__DOT__clk = 1U;
    vlSelf->rising_edge_ff_tb__DOT__data = 1U;
    __Vtask_rising_edge_ff_tb__DOT__check__0__expected = 1U;
    if (vlSelf->rising_edge_ff_tb__DOT__q) {
        VL_WRITEF("\342\234\205 [PASS] Time %0t: data = %b, q = %b\n",
                  64,VL_TIME_UNITED_Q(1000),-9,1,(IData)(vlSelf->rising_edge_ff_tb__DOT__data),
                  1,vlSelf->rising_edge_ff_tb__DOT__q);
    } else {
        VL_WRITEF("\342\235\214 [FAIL] Time %0t: data = %b, expected q = %b, got q = %b\n",
                  64,VL_TIME_UNITED_Q(1000),-9,1,(IData)(vlSelf->rising_edge_ff_tb__DOT__data),
                  1,__Vtask_rising_edge_ff_tb__DOT__check__0__expected,
                  1,(IData)(vlSelf->rising_edge_ff_tb__DOT__q));
    }
    vlSelf->rising_edge_ff_tb__DOT__data = 0U;
    __Vtask_rising_edge_ff_tb__DOT__check__1__expected = 0U;
    if (vlSelf->rising_edge_ff_tb__DOT__q) {
        VL_WRITEF("\342\235\214 [FAIL] Time %0t: data = %b, expected q = %b, got q = %b\n",
                  64,VL_TIME_UNITED_Q(1000),-9,1,(IData)(vlSelf->rising_edge_ff_tb__DOT__data),
                  1,__Vtask_rising_edge_ff_tb__DOT__check__1__expected,
                  1,(IData)(vlSelf->rising_edge_ff_tb__DOT__q));
    } else {
        VL_WRITEF("\342\234\205 [PASS] Time %0t: data = %b, q = %b\n",
                  64,VL_TIME_UNITED_Q(1000),-9,1,(IData)(vlSelf->rising_edge_ff_tb__DOT__data),
                  1,vlSelf->rising_edge_ff_tb__DOT__q);
    }
    vlSelf->rising_edge_ff_tb__DOT__data = 1U;
    __Vtask_rising_edge_ff_tb__DOT__check__2__expected = 0U;
    if (vlSelf->rising_edge_ff_tb__DOT__q) {
        VL_WRITEF("\342\235\214 [FAIL] Time %0t: data = %b, expected q = %b, got q = %b\n",
                  64,VL_TIME_UNITED_Q(1000),-9,1,(IData)(vlSelf->rising_edge_ff_tb__DOT__data),
                  1,__Vtask_rising_edge_ff_tb__DOT__check__2__expected,
                  1,(IData)(vlSelf->rising_edge_ff_tb__DOT__q));
    } else {
        VL_WRITEF("\342\234\205 [PASS] Time %0t: data = %b, q = %b\n",
                  64,VL_TIME_UNITED_Q(1000),-9,1,(IData)(vlSelf->rising_edge_ff_tb__DOT__data),
                  1,vlSelf->rising_edge_ff_tb__DOT__q);
    }
    VL_WRITEF("\342\234\205 M\303\264 ph\341\273\217ng k\341\272\277t th\303\272c.\n");
    VL_FINISH_MT("rising_edge_ff_tb.v", 49, "");
}

void Vrising_edge_ff_tb___024root___eval_initial(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___eval_initial\n"); );
    // Body
    vlSelf->__Vclklast__TOP____VinpClk__TOP__rising_edge_ff_tb__DOT__clk 
        = vlSelf->__VinpClk__TOP__rising_edge_ff_tb__DOT__clk;
    vlSelf->__Vclklast__TOP__clk = vlSelf->clk;
    Vrising_edge_ff_tb___024root___initial__TOP__5(vlSelf);
}

void Vrising_edge_ff_tb___024root___combo__TOP__1(Vrising_edge_ff_tb___024root* vlSelf);

void Vrising_edge_ff_tb___024root___eval_settle(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___eval_settle\n"); );
    // Body
    Vrising_edge_ff_tb___024root___combo__TOP__1(vlSelf);
}

void Vrising_edge_ff_tb___024root___final(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___final\n"); );
}

void Vrising_edge_ff_tb___024root___ctor_var_reset(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->data = VL_RAND_RESET_I(1);
    vlSelf->clk = VL_RAND_RESET_I(1);
    vlSelf->q = VL_RAND_RESET_I(1);
    vlSelf->rising_edge_ff_tb__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->rising_edge_ff_tb__DOT__data = VL_RAND_RESET_I(1);
    vlSelf->rising_edge_ff_tb__DOT__q = VL_RAND_RESET_I(1);
    vlSelf->__VinpClk__TOP__rising_edge_ff_tb__DOT__clk = VL_RAND_RESET_I(1);
    vlSelf->__Vchglast__TOP__rising_edge_ff_tb__DOT__clk = VL_RAND_RESET_I(1);
}
