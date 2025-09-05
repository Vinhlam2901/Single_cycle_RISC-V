// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vfull_adder_tb.h"
#include "Vfull_adder_tb__Syms.h"

//============================================================
// Constructors

Vfull_adder_tb::Vfull_adder_tb(VerilatedContext* _vcontextp__, const char* _vcname__)
    : vlSymsp{new Vfull_adder_tb__Syms(_vcontextp__, _vcname__, this)}
    , rootp{&(vlSymsp->TOP)}
{
}

Vfull_adder_tb::Vfull_adder_tb(const char* _vcname__)
    : Vfull_adder_tb(nullptr, _vcname__)
{
}

//============================================================
// Destructor

Vfull_adder_tb::~Vfull_adder_tb() {
    delete vlSymsp;
}

//============================================================
// Evaluation loop

void Vfull_adder_tb___024root___eval_initial(Vfull_adder_tb___024root* vlSelf);
void Vfull_adder_tb___024root___eval_settle(Vfull_adder_tb___024root* vlSelf);
void Vfull_adder_tb___024root___eval(Vfull_adder_tb___024root* vlSelf);
QData Vfull_adder_tb___024root___change_request(Vfull_adder_tb___024root* vlSelf);
#ifdef VL_DEBUG
void Vfull_adder_tb___024root___eval_debug_assertions(Vfull_adder_tb___024root* vlSelf);
#endif  // VL_DEBUG
void Vfull_adder_tb___024root___final(Vfull_adder_tb___024root* vlSelf);

static void _eval_initial_loop(Vfull_adder_tb__Syms* __restrict vlSymsp) {
    vlSymsp->__Vm_didInit = true;
    Vfull_adder_tb___024root___eval_initial(&(vlSymsp->TOP));
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial loop\n"););
        Vfull_adder_tb___024root___eval_settle(&(vlSymsp->TOP));
        Vfull_adder_tb___024root___eval(&(vlSymsp->TOP));
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = Vfull_adder_tb___024root___change_request(&(vlSymsp->TOP));
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("../01_tb/full_adder_tb.v", 1, "",
                "Verilated model didn't DC converge\n"
                "- See https://verilator.org/warn/DIDNOTCONVERGE");
        } else {
            __Vchange = Vfull_adder_tb___024root___change_request(&(vlSymsp->TOP));
        }
    } while (VL_UNLIKELY(__Vchange));
}

void Vfull_adder_tb::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vfull_adder_tb::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vfull_adder_tb___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    // Initialize
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) _eval_initial_loop(vlSymsp);
    // Evaluate till stable
    int __VclockLoop = 0;
    QData __Vchange = 1;
    do {
        VL_DEBUG_IF(VL_DBG_MSGF("+ Clock loop\n"););
        Vfull_adder_tb___024root___eval(&(vlSymsp->TOP));
        if (VL_UNLIKELY(++__VclockLoop > 100)) {
            // About to fail, so enable debug to see what's not settling.
            // Note you must run make with OPT=-DVL_DEBUG for debug prints.
            int __Vsaved_debug = Verilated::debug();
            Verilated::debug(1);
            __Vchange = Vfull_adder_tb___024root___change_request(&(vlSymsp->TOP));
            Verilated::debug(__Vsaved_debug);
            VL_FATAL_MT("../01_tb/full_adder_tb.v", 1, "",
                "Verilated model didn't converge\n"
                "- See https://verilator.org/warn/DIDNOTCONVERGE");
        } else {
            __Vchange = Vfull_adder_tb___024root___change_request(&(vlSymsp->TOP));
        }
    } while (VL_UNLIKELY(__Vchange));
}

//============================================================
// Invoke final blocks

void Vfull_adder_tb::final() {
    Vfull_adder_tb___024root___final(&(vlSymsp->TOP));
}

//============================================================
// Utilities

VerilatedContext* Vfull_adder_tb::contextp() const {
    return vlSymsp->_vm_contextp__;
}

const char* Vfull_adder_tb::name() const {
    return vlSymsp->name();
}
