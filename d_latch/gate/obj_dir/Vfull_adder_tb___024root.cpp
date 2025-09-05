// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vfull_adder_tb.h for the primary calling header

#include "Vfull_adder_tb___024root.h"
#include "Vfull_adder_tb__Syms.h"

//==========

void Vfull_adder_tb___024root___eval(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___eval\n"); );
}

QData Vfull_adder_tb___024root___change_request_1(Vfull_adder_tb___024root* vlSelf);

VL_INLINE_OPT QData Vfull_adder_tb___024root___change_request(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___change_request\n"); );
    // Body
    return (Vfull_adder_tb___024root___change_request_1(vlSelf));
}

VL_INLINE_OPT QData Vfull_adder_tb___024root___change_request_1(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___change_request_1\n"); );
    // Body
    // Change detection
    QData __req = false;  // Logically a bool
    __req |= ((vlSelf->full_adder_tb__DOT__sum ^ vlSelf->__Vchglast__TOP__full_adder_tb__DOT__sum)
         | (vlSelf->full_adder_tb__DOT__uut__DOT__w2 ^ vlSelf->__Vchglast__TOP__full_adder_tb__DOT__uut__DOT__w2)
         | (vlSelf->full_adder_tb__DOT__uut__DOT__w3 ^ vlSelf->__Vchglast__TOP__full_adder_tb__DOT__uut__DOT__w3));
    VL_DEBUG_IF( if(__req && ((vlSelf->full_adder_tb__DOT__sum ^ vlSelf->__Vchglast__TOP__full_adder_tb__DOT__sum))) VL_DBG_MSGF("        CHANGE: ../01_tb/full_adder_tb.v:6: full_adder_tb.sum\n"); );
    VL_DEBUG_IF( if(__req && ((vlSelf->full_adder_tb__DOT__uut__DOT__w2 ^ vlSelf->__Vchglast__TOP__full_adder_tb__DOT__uut__DOT__w2))) VL_DBG_MSGF("        CHANGE: full_adder.v:8: full_adder_tb.uut.w2\n"); );
    VL_DEBUG_IF( if(__req && ((vlSelf->full_adder_tb__DOT__uut__DOT__w3 ^ vlSelf->__Vchglast__TOP__full_adder_tb__DOT__uut__DOT__w3))) VL_DBG_MSGF("        CHANGE: full_adder.v:8: full_adder_tb.uut.w3\n"); );
    // Final
    vlSelf->__Vchglast__TOP__full_adder_tb__DOT__sum 
        = vlSelf->full_adder_tb__DOT__sum;
    vlSelf->__Vchglast__TOP__full_adder_tb__DOT__uut__DOT__w2 
        = vlSelf->full_adder_tb__DOT__uut__DOT__w2;
    vlSelf->__Vchglast__TOP__full_adder_tb__DOT__uut__DOT__w3 
        = vlSelf->full_adder_tb__DOT__uut__DOT__w3;
    return __req;
}

#ifdef VL_DEBUG
void Vfull_adder_tb___024root___eval_debug_assertions(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___eval_debug_assertions\n"); );
}
#endif  // VL_DEBUG
