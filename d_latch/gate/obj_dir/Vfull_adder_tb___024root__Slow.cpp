// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vfull_adder_tb.h for the primary calling header

#include "Vfull_adder_tb___024root.h"
#include "Vfull_adder_tb__Syms.h"

//==========


void Vfull_adder_tb___024root___ctor_var_reset(Vfull_adder_tb___024root* vlSelf);

Vfull_adder_tb___024root::Vfull_adder_tb___024root(const char* _vcname__)
    : VerilatedModule(_vcname__)
 {
    // Reset structure values
    Vfull_adder_tb___024root___ctor_var_reset(this);
}

void Vfull_adder_tb___024root::__Vconfigure(Vfull_adder_tb__Syms* _vlSymsp, bool first) {
    if (false && first) {}  // Prevent unused
    this->vlSymsp = _vlSymsp;
}

Vfull_adder_tb___024root::~Vfull_adder_tb___024root() {
}

void Vfull_adder_tb___024root___initial__TOP__1(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___initial__TOP__1\n"); );
    // Body
    vlSelf->full_adder_tb__DOT__a_tc[0U] = 0U;
    vlSelf->full_adder_tb__DOT__b_tc[0U] = 0U;
    vlSelf->full_adder_tb__DOT__c_tc[0U] = 0U;
    vlSelf->full_adder_tb__DOT__sum_tc[0U] = 0U;
    vlSelf->full_adder_tb__DOT__cout_tc[0U] = 0U;
    vlSelf->full_adder_tb__DOT__a_tc[1U] = 0U;
    vlSelf->full_adder_tb__DOT__b_tc[1U] = 0U;
    vlSelf->full_adder_tb__DOT__c_tc[1U] = 1U;
    vlSelf->full_adder_tb__DOT__sum_tc[1U] = 1U;
    vlSelf->full_adder_tb__DOT__cout_tc[1U] = 0U;
    vlSelf->full_adder_tb__DOT__a_tc[2U] = 0U;
    vlSelf->full_adder_tb__DOT__b_tc[2U] = 1U;
    vlSelf->full_adder_tb__DOT__c_tc[2U] = 0U;
    vlSelf->full_adder_tb__DOT__sum_tc[2U] = 1U;
    vlSelf->full_adder_tb__DOT__cout_tc[2U] = 0U;
    vlSelf->full_adder_tb__DOT__a_tc[3U] = 0U;
    vlSelf->full_adder_tb__DOT__b_tc[3U] = 1U;
    vlSelf->full_adder_tb__DOT__c_tc[3U] = 1U;
    vlSelf->full_adder_tb__DOT__sum_tc[3U] = 0U;
    vlSelf->full_adder_tb__DOT__cout_tc[3U] = 1U;
    vlSelf->full_adder_tb__DOT__a_tc[4U] = 1U;
    vlSelf->full_adder_tb__DOT__b_tc[4U] = 0U;
    vlSelf->full_adder_tb__DOT__c_tc[4U] = 0U;
    vlSelf->full_adder_tb__DOT__sum_tc[4U] = 1U;
    vlSelf->full_adder_tb__DOT__cout_tc[4U] = 0U;
    vlSelf->full_adder_tb__DOT__a_tc[5U] = 1U;
    vlSelf->full_adder_tb__DOT__b_tc[5U] = 0U;
    vlSelf->full_adder_tb__DOT__c_tc[5U] = 1U;
    vlSelf->full_adder_tb__DOT__sum_tc[5U] = 0U;
    vlSelf->full_adder_tb__DOT__cout_tc[5U] = 1U;
    vlSelf->full_adder_tb__DOT__a_tc[6U] = 1U;
    vlSelf->full_adder_tb__DOT__b_tc[6U] = 1U;
    vlSelf->full_adder_tb__DOT__c_tc[6U] = 0U;
    vlSelf->full_adder_tb__DOT__sum_tc[6U] = 0U;
    vlSelf->full_adder_tb__DOT__cout_tc[6U] = 1U;
    vlSelf->full_adder_tb__DOT__a_tc[7U] = 1U;
    vlSelf->full_adder_tb__DOT__b_tc[7U] = 1U;
    vlSelf->full_adder_tb__DOT__c_tc[7U] = 1U;
    vlSelf->full_adder_tb__DOT__sum_tc[7U] = 1U;
    vlSelf->full_adder_tb__DOT__cout_tc[7U] = 1U;
    vlSelf->full_adder_tb__DOT__a = vlSelf->full_adder_tb__DOT__a_tc
        [0U];
    vlSelf->full_adder_tb__DOT__b = vlSelf->full_adder_tb__DOT__b_tc
        [0U];
    vlSelf->full_adder_tb__DOT__c = vlSelf->full_adder_tb__DOT__c_tc
        [0U];
    if (((IData)(vlSelf->full_adder_tb__DOT__sum) != 
         vlSelf->full_adder_tb__DOT__sum_tc[0U])) {
        VL_WRITEF("Testcase # 1 FAILED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [0U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [0U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    } else {
        VL_WRITEF("Testcase # 1 PASSED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [0U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [0U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    }
    vlSelf->full_adder_tb__DOT__a = vlSelf->full_adder_tb__DOT__a_tc
        [1U];
    vlSelf->full_adder_tb__DOT__b = vlSelf->full_adder_tb__DOT__b_tc
        [1U];
    vlSelf->full_adder_tb__DOT__c = vlSelf->full_adder_tb__DOT__c_tc
        [1U];
    if (((IData)(vlSelf->full_adder_tb__DOT__sum) != 
         vlSelf->full_adder_tb__DOT__sum_tc[1U])) {
        VL_WRITEF("Testcase # 2 FAILED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [1U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [1U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    } else {
        VL_WRITEF("Testcase # 2 PASSED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [1U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [1U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    }
    vlSelf->full_adder_tb__DOT__a = vlSelf->full_adder_tb__DOT__a_tc
        [2U];
    vlSelf->full_adder_tb__DOT__b = vlSelf->full_adder_tb__DOT__b_tc
        [2U];
    vlSelf->full_adder_tb__DOT__c = vlSelf->full_adder_tb__DOT__c_tc
        [2U];
    if (((IData)(vlSelf->full_adder_tb__DOT__sum) != 
         vlSelf->full_adder_tb__DOT__sum_tc[2U])) {
        VL_WRITEF("Testcase # 3 FAILED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [2U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [2U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    } else {
        VL_WRITEF("Testcase # 3 PASSED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [2U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [2U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    }
    vlSelf->full_adder_tb__DOT__a = vlSelf->full_adder_tb__DOT__a_tc
        [3U];
    vlSelf->full_adder_tb__DOT__b = vlSelf->full_adder_tb__DOT__b_tc
        [3U];
    vlSelf->full_adder_tb__DOT__c = vlSelf->full_adder_tb__DOT__c_tc
        [3U];
    if (((IData)(vlSelf->full_adder_tb__DOT__sum) != 
         vlSelf->full_adder_tb__DOT__sum_tc[3U])) {
        VL_WRITEF("Testcase # 4 FAILED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [3U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [3U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    } else {
        VL_WRITEF("Testcase # 4 PASSED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [3U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [3U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    }
    vlSelf->full_adder_tb__DOT__a = vlSelf->full_adder_tb__DOT__a_tc
        [4U];
    vlSelf->full_adder_tb__DOT__b = vlSelf->full_adder_tb__DOT__b_tc
        [4U];
    vlSelf->full_adder_tb__DOT__c = vlSelf->full_adder_tb__DOT__c_tc
        [4U];
    if (((IData)(vlSelf->full_adder_tb__DOT__sum) != 
         vlSelf->full_adder_tb__DOT__sum_tc[4U])) {
        VL_WRITEF("Testcase # 5 FAILED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [4U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [4U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    } else {
        VL_WRITEF("Testcase # 5 PASSED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [4U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [4U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    }
    vlSelf->full_adder_tb__DOT__a = vlSelf->full_adder_tb__DOT__a_tc
        [5U];
    vlSelf->full_adder_tb__DOT__b = vlSelf->full_adder_tb__DOT__b_tc
        [5U];
    vlSelf->full_adder_tb__DOT__c = vlSelf->full_adder_tb__DOT__c_tc
        [5U];
    if (((IData)(vlSelf->full_adder_tb__DOT__sum) != 
         vlSelf->full_adder_tb__DOT__sum_tc[5U])) {
        VL_WRITEF("Testcase # 6 FAILED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [5U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [5U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    } else {
        VL_WRITEF("Testcase # 6 PASSED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [5U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [5U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    }
    vlSelf->full_adder_tb__DOT__a = vlSelf->full_adder_tb__DOT__a_tc
        [6U];
    vlSelf->full_adder_tb__DOT__b = vlSelf->full_adder_tb__DOT__b_tc
        [6U];
    vlSelf->full_adder_tb__DOT__c = vlSelf->full_adder_tb__DOT__c_tc
        [6U];
    if (((IData)(vlSelf->full_adder_tb__DOT__sum) != 
         vlSelf->full_adder_tb__DOT__sum_tc[6U])) {
        VL_WRITEF("Testcase # 7 FAILED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [6U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [6U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    } else {
        VL_WRITEF("Testcase # 7 PASSED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [6U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [6U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    }
    vlSelf->full_adder_tb__DOT__a = vlSelf->full_adder_tb__DOT__a_tc
        [7U];
    vlSelf->full_adder_tb__DOT__b = vlSelf->full_adder_tb__DOT__b_tc
        [7U];
    vlSelf->full_adder_tb__DOT__c = vlSelf->full_adder_tb__DOT__c_tc
        [7U];
    if (((IData)(vlSelf->full_adder_tb__DOT__sum) != 
         vlSelf->full_adder_tb__DOT__sum_tc[7U])) {
        VL_WRITEF("Testcase # 8 FAILED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [7U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [7U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    } else {
        VL_WRITEF("Testcase # 8 PASSED:| a = %b| b = %b| c_in = %b| sum_expected = %b| sum_got = %b| cout_expected = %b| cout_got = %b\n",
                  1,vlSelf->full_adder_tb__DOT__a,1,
                  (IData)(vlSelf->full_adder_tb__DOT__b),
                  1,vlSelf->full_adder_tb__DOT__c,1,
                  vlSelf->full_adder_tb__DOT__sum_tc
                  [7U],1,vlSelf->full_adder_tb__DOT__sum,
                  1,vlSelf->full_adder_tb__DOT__cout_tc
                  [7U],1,((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w2) 
                          | (IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w3)));
    }
    VL_FINISH_MT("../01_tb/full_adder_tb.v", 70, "");
    vlSelf->full_adder_tb__DOT__uut__DOT__w3 = ((IData)(vlSelf->full_adder_tb__DOT__a) 
                                                & (IData)(vlSelf->full_adder_tb__DOT__b));
    vlSelf->full_adder_tb__DOT__uut__DOT__w1 = ((IData)(vlSelf->full_adder_tb__DOT__a) 
                                                ^ (IData)(vlSelf->full_adder_tb__DOT__b));
}

void Vfull_adder_tb___024root___settle__TOP__2(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___settle__TOP__2\n"); );
    // Body
    vlSelf->full_adder_tb__DOT__uut__DOT__w3 = ((IData)(vlSelf->full_adder_tb__DOT__a) 
                                                & (IData)(vlSelf->full_adder_tb__DOT__b));
    vlSelf->full_adder_tb__DOT__uut__DOT__w1 = ((IData)(vlSelf->full_adder_tb__DOT__a) 
                                                ^ (IData)(vlSelf->full_adder_tb__DOT__b));
    vlSelf->full_adder_tb__DOT__uut__DOT__w2 = ((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w1) 
                                                & (IData)(vlSelf->full_adder_tb__DOT__c));
    vlSelf->full_adder_tb__DOT__sum = ((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w1) 
                                       ^ (IData)(vlSelf->full_adder_tb__DOT__c));
}

void Vfull_adder_tb___024root___initial__TOP__3(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___initial__TOP__3\n"); );
    // Body
    vlSelf->full_adder_tb__DOT__uut__DOT__w2 = ((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w1) 
                                                & (IData)(vlSelf->full_adder_tb__DOT__c));
    vlSelf->full_adder_tb__DOT__sum = ((IData)(vlSelf->full_adder_tb__DOT__uut__DOT__w1) 
                                       ^ (IData)(vlSelf->full_adder_tb__DOT__c));
}

void Vfull_adder_tb___024root___eval_initial(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___eval_initial\n"); );
    // Body
    Vfull_adder_tb___024root___initial__TOP__1(vlSelf);
    Vfull_adder_tb___024root___initial__TOP__3(vlSelf);
}

void Vfull_adder_tb___024root___eval_settle(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___eval_settle\n"); );
    // Body
    Vfull_adder_tb___024root___settle__TOP__2(vlSelf);
}

void Vfull_adder_tb___024root___final(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___final\n"); );
}

void Vfull_adder_tb___024root___ctor_var_reset(Vfull_adder_tb___024root* vlSelf) {
    if (false && vlSelf) {}  // Prevent unused
    Vfull_adder_tb__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vfull_adder_tb___024root___ctor_var_reset\n"); );
    // Body
    vlSelf->full_adder_tb__DOT__a = VL_RAND_RESET_I(1);
    vlSelf->full_adder_tb__DOT__b = VL_RAND_RESET_I(1);
    vlSelf->full_adder_tb__DOT__c = VL_RAND_RESET_I(1);
    vlSelf->full_adder_tb__DOT__sum = VL_RAND_RESET_I(1);
    for (int __Vi0=0; __Vi0<8; ++__Vi0) {
        vlSelf->full_adder_tb__DOT__a_tc[__Vi0] = VL_RAND_RESET_I(1);
    }
    for (int __Vi0=0; __Vi0<8; ++__Vi0) {
        vlSelf->full_adder_tb__DOT__b_tc[__Vi0] = VL_RAND_RESET_I(1);
    }
    for (int __Vi0=0; __Vi0<8; ++__Vi0) {
        vlSelf->full_adder_tb__DOT__c_tc[__Vi0] = VL_RAND_RESET_I(1);
    }
    for (int __Vi0=0; __Vi0<8; ++__Vi0) {
        vlSelf->full_adder_tb__DOT__sum_tc[__Vi0] = VL_RAND_RESET_I(1);
    }
    for (int __Vi0=0; __Vi0<8; ++__Vi0) {
        vlSelf->full_adder_tb__DOT__cout_tc[__Vi0] = VL_RAND_RESET_I(1);
    }
    vlSelf->full_adder_tb__DOT__uut__DOT__w1 = VL_RAND_RESET_I(1);
    vlSelf->full_adder_tb__DOT__uut__DOT__w2 = VL_RAND_RESET_I(1);
    vlSelf->full_adder_tb__DOT__uut__DOT__w3 = VL_RAND_RESET_I(1);
    vlSelf->__Vchglast__TOP__full_adder_tb__DOT__sum = VL_RAND_RESET_I(1);
    vlSelf->__Vchglast__TOP__full_adder_tb__DOT__uut__DOT__w2 = VL_RAND_RESET_I(1);
    vlSelf->__Vchglast__TOP__full_adder_tb__DOT__uut__DOT__w3 = VL_RAND_RESET_I(1);
}
