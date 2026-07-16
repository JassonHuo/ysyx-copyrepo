// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Model implementation (design independent parts)

#include "Vstrlig__pch.h"

//============================================================
// Constructors

Vstrlig::Vstrlig(VerilatedContext* _vcontextp__, const char* _vcname__)
    : VerilatedModel{*_vcontextp__}
    , vlSymsp{new Vstrlig__Syms(contextp(), _vcname__, this)}
    , clk{vlSymsp->TOP.clk}
    , rst{vlSymsp->TOP.rst}
    , led{vlSymsp->TOP.led}
    , rootp{&(vlSymsp->TOP)}
{
    // Register model with the context
    contextp()->addModel(this);
}

Vstrlig::Vstrlig(const char* _vcname__)
    : Vstrlig(Verilated::threadContextp(), _vcname__)
{
}

//============================================================
// Destructor

Vstrlig::~Vstrlig() {
    delete vlSymsp;
}

//============================================================
// Evaluation function

#ifdef VL_DEBUG
void Vstrlig___024root___eval_debug_assertions(Vstrlig___024root* vlSelf);
#endif  // VL_DEBUG
void Vstrlig___024root___eval_static(Vstrlig___024root* vlSelf);
void Vstrlig___024root___eval_initial(Vstrlig___024root* vlSelf);
void Vstrlig___024root___eval_settle(Vstrlig___024root* vlSelf);
void Vstrlig___024root___eval(Vstrlig___024root* vlSelf);

void Vstrlig::eval_step() {
    VL_DEBUG_IF(VL_DBG_MSGF("+++++TOP Evaluate Vstrlig::eval_step\n"); );
#ifdef VL_DEBUG
    // Debug assertions
    Vstrlig___024root___eval_debug_assertions(&(vlSymsp->TOP));
#endif  // VL_DEBUG
    vlSymsp->__Vm_deleter.deleteAll();
    if (VL_UNLIKELY(!vlSymsp->__Vm_didInit)) {
        vlSymsp->__Vm_didInit = true;
        VL_DEBUG_IF(VL_DBG_MSGF("+ Initial\n"););
        Vstrlig___024root___eval_static(&(vlSymsp->TOP));
        Vstrlig___024root___eval_initial(&(vlSymsp->TOP));
        Vstrlig___024root___eval_settle(&(vlSymsp->TOP));
    }
    VL_DEBUG_IF(VL_DBG_MSGF("+ Eval\n"););
    Vstrlig___024root___eval(&(vlSymsp->TOP));
    // Evaluate cleanup
    Verilated::endOfEval(vlSymsp->__Vm_evalMsgQp);
}

//============================================================
// Events and timing
bool Vstrlig::eventsPending() { return false; }

uint64_t Vstrlig::nextTimeSlot() {
    VL_FATAL_MT(__FILE__, __LINE__, "", "No delays in the design");
    return 0;
}

//============================================================
// Utilities

const char* Vstrlig::name() const {
    return vlSymsp->name();
}

//============================================================
// Invoke final blocks

void Vstrlig___024root___eval_final(Vstrlig___024root* vlSelf);

VL_ATTR_COLD void Vstrlig::final() {
    Vstrlig___024root___eval_final(&(vlSymsp->TOP));
}

//============================================================
// Implementations of abstract methods from VerilatedModel

const char* Vstrlig::hierName() const { return vlSymsp->name(); }
const char* Vstrlig::modelName() const { return "Vstrlig"; }
unsigned Vstrlig::threads() const { return 1; }
void Vstrlig::prepareClone() const { contextp()->prepareClone(); }
void Vstrlig::atClone() const {
    contextp()->threadPoolpOnClone();
}
