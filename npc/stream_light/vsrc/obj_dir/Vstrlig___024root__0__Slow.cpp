// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vstrlig.h for the primary calling header

#include "Vstrlig__pch.h"

VL_ATTR_COLD void Vstrlig___024root___eval_static(Vstrlig___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___eval_static\n"); );
    Vstrlig__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
}

VL_ATTR_COLD void Vstrlig___024root___eval_initial(Vstrlig___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___eval_initial\n"); );
    Vstrlig__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vstrlig___024root___eval_final(Vstrlig___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___eval_final\n"); );
    Vstrlig__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vstrlig___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vstrlig___024root___eval_phase__stl(Vstrlig___024root* vlSelf);

VL_ATTR_COLD void Vstrlig___024root___eval_settle(Vstrlig___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___eval_settle\n"); );
    Vstrlig__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00000064U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vstrlig___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("strlig.v", 1, "", "Settle region did not converge after 100 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
    } while (Vstrlig___024root___eval_phase__stl(vlSelf));
}

VL_ATTR_COLD void Vstrlig___024root___eval_triggers__stl(Vstrlig___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___eval_triggers__stl\n"); );
    Vstrlig__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VstlTriggered
                                      [0U]) | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
    vlSelfRef.__VstlFirstIteration = 0U;
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vstrlig___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
}

VL_ATTR_COLD bool Vstrlig___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vstrlig___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vstrlig___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vstrlig___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___trigger_anySet__stl\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        if (in[n]) {
            return (1U);
        }
        n = ((IData)(1U) + n);
    } while ((1U > n));
    return (0U);
}

VL_ATTR_COLD void Vstrlig___024root___stl_sequent__TOP__0(Vstrlig___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___stl_sequent__TOP__0\n"); );
    Vstrlig__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.led = vlSelfRef.strlig__DOT__temp;
}

VL_ATTR_COLD void Vstrlig___024root___eval_stl(Vstrlig___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___eval_stl\n"); );
    Vstrlig__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
        vlSelfRef.led = vlSelfRef.strlig__DOT__temp;
    }
}

VL_ATTR_COLD bool Vstrlig___024root___eval_phase__stl(Vstrlig___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___eval_phase__stl\n"); );
    Vstrlig__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    Vstrlig___024root___eval_triggers__stl(vlSelf);
    __VstlExecute = Vstrlig___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        Vstrlig___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

bool Vstrlig___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vstrlig___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vstrlig___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vstrlig___024root___ctor_var_reset(Vstrlig___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vstrlig___024root___ctor_var_reset\n"); );
    Vstrlig__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16707436170211756652ull);
    vlSelf->rst = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 18209466448985614591ull);
    vlSelf->led = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 14009161575225144129ull);
    vlSelf->strlig__DOT__temp = VL_SCOPED_RAND_RESET_I(16, __VscopeHash, 1496361863881376856ull);
    vlSelf->strlig__DOT__count = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17149286498361381ull);
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
}
