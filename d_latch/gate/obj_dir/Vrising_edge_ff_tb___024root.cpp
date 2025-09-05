// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vrising_edge_ff_tb.h for the primary calling header

#include "Vrising_edge_ff_tb___024root.h"
#include "Vrising_edge_ff_tb__Syms.h"

//==========

VL_INLINE_OPT void Vrising_edge_ff_tb___024root___combo__TOP__1(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___combo__TOP__1\n"); );
    // Body
    vlSelf->rising_edge_ff_tb__DOT__clk = (1U & (~ (IData)(vlSelf->rising_edge_ff_tb__DOT__clk)));
}

VL_INLINE_OPT void Vrising_edge_ff_tb___024root___sequent__TOP__3(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___sequent__TOP__3\n"); );
    // Body
    vlSelf->rising_edge_ff_tb__DOT__q = vlSelf->rising_edge_ff_tb__DOT__data;
}

VL_INLINE_OPT void Vrising_edge_ff_tb___024root___sequent__TOP__4(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___sequent__TOP__4\n"); );
    // Body
    vlSelf->q = vlSelf->data;
}

void Vrising_edge_ff_tb___024root___eval(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___eval\n"); );
    // Body
    Vrising_edge_ff_tb___024root___combo__TOP__1(vlSelf);
    if (((IData)(vlSelf->__VinpClk__TOP__rising_edge_ff_tb__DOT__clk) 
         & (~ (IData)(vlSelf->__Vclklast__TOP____VinpClk__TOP__rising_edge_ff_tb__DOT__clk)))) {
        Vrising_edge_ff_tb___024root___sequent__TOP__3(vlSelf);
    }
    if (((~ (IData)(vlSelf->clk)) & (IData)(vlSelf->__Vclklast__TOP__clk))) {
        Vrising_edge_ff_tb___024root___sequent__TOP__4(vlSelf);
    }
    // Final
    vlSelf->__Vclklast__TOP____VinpClk__TOP__rising_edge_ff_tb__DOT__clk 
        = vlSelf->__VinpClk__TOP__rising_edge_ff_tb__DOT__clk;
    vlSelf->__Vclklast__TOP__clk = vlSelf->clk;
    vlSelf->__VinpClk__TOP__rising_edge_ff_tb__DOT__clk 
        = vlSelf->rising_edge_ff_tb__DOT__clk;
}

QData Vrising_edge_ff_tb___024root___change_request_1(Vrising_edge_ff_tb___024root* vlSelf);

VL_INLINE_OPT QData Vrising_edge_ff_tb___024root___change_request(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___change_request\n"); );
    // Body
    return (Vrising_edge_ff_tb___024root___change_request_1(vlSelf));
}

VL_INLINE_OPT QData Vrising_edge_ff_tb___024root___change_request_1(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___change_request_1\n"); );
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    __req |= ((vlSelf->rising_edge_ff_tb__DOT__clk ^ vlSelf->__Vchglast__TOP__rising_edge_ff_tb__DOT__clk));
    VL_DEBUG_IF( if(__req && ((vlSelf->rising_edge_ff_tb__DOT__clk ^ vlSelf->__Vchglast__TOP__rising_edge_ff_tb__DOT__clk))) VL_DBG_MSGF("        CHANGE: rising_edge_ff_tb.v:5: rising_edge_ff_tb.clk\n"); );
    // Final
    vlSelf->__Vchglast__TOP__rising_edge_ff_tb__DOT__clk 
        = vlSelf->rising_edge_ff_tb__DOT__clk;
    return __req;
}

#ifdef VL_DEBUG
void Vrising_edge_ff_tb___024root___eval_debug_assertions(Vrising_edge_ff_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vrising_edge_ff_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vrising_edge_ff_tb___024root___eval_debug_assertions\n"); );
    // Body
    if (VL_UNLIKELY((vlSelf->data & 0xfeU))) {
        Verilated::overWidthError("data");}
    if (VL_UNLIKELY((vlSelf->clk & 0xfeU))) {
        Verilated::overWidthError("clk");}
}
#endif  // VL_DEBUG
