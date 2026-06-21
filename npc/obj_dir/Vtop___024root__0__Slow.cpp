// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"

VL_ATTR_COLD void Vtop___024root___eval_static__TOP(Vtop___024root* vlSelf);
VL_ATTR_COLD void Vtop___024root____Vm_traceActivitySetAll(Vtop___024root* vlSelf);

VL_ATTR_COLD void Vtop___024root___eval_static(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_static\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtop___024root___eval_static__TOP(vlSelf);
    Vtop___024root____Vm_traceActivitySetAll(vlSelf);
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
}

VL_ATTR_COLD void Vtop___024root___eval_static__TOP(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_static__TOP\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.top__DOT__pc0__DOT__pc = 0x80000000U;
}

VL_ATTR_COLD void Vtop___024root___eval_initial(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_initial\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

VL_ATTR_COLD void Vtop___024root___eval_final(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_final\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG
VL_ATTR_COLD bool Vtop___024root___eval_phase__stl(Vtop___024root* vlSelf);

VL_ATTR_COLD void Vtop___024root___eval_settle(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_settle\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VstlIterCount;
    // Body
    __VstlIterCount = 0U;
    vlSelfRef.__VstlFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00000064U < __VstlIterCount)))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
#endif
            VL_FATAL_MT("vsrc/top.v", 1, "", "DIDNOTCONVERGE: Settle region did not converge after '--converge-limit' of 100 tries");
        }
        __VstlIterCount = ((IData)(1U) + __VstlIterCount);
        vlSelfRef.__VstlPhaseResult = Vtop___024root___eval_phase__stl(vlSelf);
        vlSelfRef.__VstlFirstIteration = 0U;
    } while (vlSelfRef.__VstlPhaseResult);
}

VL_ATTR_COLD void Vtop___024root___eval_triggers_vec__stl(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_triggers_vec__stl\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VstlTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VstlTriggered[0U]) 
                                     | (IData)((IData)(vlSelfRef.__VstlFirstIteration)));
}

VL_ATTR_COLD bool Vtop___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__stl(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__stl\n"); );
    // Body
    if ((1U & (~ (IData)(Vtop___024root___trigger_anySet__stl(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'stl' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD bool Vtop___024root___trigger_anySet__stl(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___trigger_anySet__stl\n"); );
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

void Vtop___024unit____Vdpiimwrap_pmem_read_TOP____024unit(IData/*31:0*/ raddr, IData/*31:0*/ &pmem_read__Vfuncrtn);
void Vtop___024unit____Vdpiimwrap_pmem_write_TOP____024unit(IData/*31:0*/ waddr, IData/*31:0*/ wdata, CData/*7:0*/ wmask);

VL_ATTR_COLD void Vtop___024root___stl_sequent__TOP__0(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___stl_sequent__TOP__0\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.pc = vlSelfRef.top__DOT__pc0__DOT__pc;
    vlSelfRef.a0 = vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[10U];
    vlSelfRef.top__DOT__exu0__DOT__pc_sync_in = ((IData)(4U) 
                                                 + vlSelfRef.top__DOT__pc0__DOT__pc);
    vlSelfRef.top__DOT__mem_wen_idu_exu = 0U;
    vlSelfRef.top__DOT__valid_idu_exu = 0U;
    vlSelfRef.top__DOT__width_idu_exu = 0U;
    if ((1U & (~ (vlSelfRef.inst >> 6U)))) {
        if ((0x00000020U & vlSelfRef.inst)) {
            if ((1U & (~ (vlSelfRef.inst >> 4U)))) {
                if ((1U & (~ (vlSelfRef.inst >> 3U)))) {
                    if ((1U & (~ (vlSelfRef.inst >> 2U)))) {
                        if ((2U & vlSelfRef.inst)) {
                            if ((1U & vlSelfRef.inst)) {
                                vlSelfRef.top__DOT__mem_wen_idu_exu = 1U;
                                vlSelfRef.top__DOT__valid_idu_exu = 1U;
                                if ((0U == (7U & (vlSelfRef.inst 
                                                  >> 0x0000000cU)))) {
                                    vlSelfRef.top__DOT__width_idu_exu = 0U;
                                } else if ((2U == (7U 
                                                   & (vlSelfRef.inst 
                                                      >> 0x0000000cU)))) {
                                    vlSelfRef.top__DOT__width_idu_exu = 2U;
                                }
                            }
                        }
                    }
                }
            }
        } else if ((1U & (~ (vlSelfRef.inst >> 4U)))) {
            if ((1U & (~ (vlSelfRef.inst >> 3U)))) {
                if ((1U & (~ (vlSelfRef.inst >> 2U)))) {
                    if ((2U & vlSelfRef.inst)) {
                        if ((1U & vlSelfRef.inst)) {
                            vlSelfRef.top__DOT__valid_idu_exu = 1U;
                            if ((2U == (7U & (vlSelfRef.inst 
                                              >> 0x0000000cU)))) {
                                vlSelfRef.top__DOT__width_idu_exu = 2U;
                            } else if ((4U == (7U & 
                                               (vlSelfRef.inst 
                                                >> 0x0000000cU)))) {
                                vlSelfRef.top__DOT__width_idu_exu = 0U;
                            }
                        }
                    }
                }
            }
        }
    }
    vlSelfRef.top__DOT__idu0__DOT__Iimm = (((- (IData)(
                                                       (vlSelfRef.inst 
                                                        >> 0x0000001fU))) 
                                            << 0x0000000cU) 
                                           | (vlSelfRef.inst 
                                              >> 0x00000014U));
    vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rdata2 
        = vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf
        [(0x0000000fU & (vlSelfRef.inst >> 0x00000014U))];
    vlSelfRef.top__DOT__idu0__DOT____VdfgExtracted_h87ea21a1__0 
        = (IData)((0U == (0xfe007000U & vlSelfRef.inst)));
    vlSelfRef.top__DOT__break_idu_pc = 0U;
    vlSelfRef.top__DOT__imm_idu_exu = 0U;
    vlSelfRef.top__DOT__reg_src_idu_exu = 0U;
    vlSelfRef.top__DOT__wen_idu_exu = 0U;
    vlSelfRef.top__DOT__pc_src_idu_exu = 0U;
    vlSelfRef.top__DOT__alu_src_idu_exu = 0U;
    vlSelfRef.top__DOT__alu_op_idu_exu = 2U;
    if ((0x00000040U & vlSelfRef.inst)) {
        if ((0x00000020U & vlSelfRef.inst)) {
            if ((0x00000010U & vlSelfRef.inst)) {
                if ((1U & (~ (vlSelfRef.inst >> 3U)))) {
                    if ((1U & (~ (vlSelfRef.inst >> 2U)))) {
                        if ((2U & vlSelfRef.inst)) {
                            if ((1U & vlSelfRef.inst)) {
                                if ((1U == vlSelfRef.top__DOT__idu0__DOT__Iimm)) {
                                    vlSelfRef.top__DOT__break_idu_pc = 1U;
                                }
                            }
                        }
                    }
                }
            }
            if ((1U & (~ (vlSelfRef.inst >> 4U)))) {
                if ((1U & (~ (vlSelfRef.inst >> 3U)))) {
                    if ((4U & vlSelfRef.inst)) {
                        if ((2U & vlSelfRef.inst)) {
                            if ((1U & vlSelfRef.inst)) {
                                vlSelfRef.top__DOT__imm_idu_exu 
                                    = vlSelfRef.top__DOT__idu0__DOT__Iimm;
                                vlSelfRef.top__DOT__reg_src_idu_exu = 2U;
                                vlSelfRef.top__DOT__wen_idu_exu = 1U;
                                vlSelfRef.top__DOT__pc_src_idu_exu = 3U;
                                vlSelfRef.top__DOT__alu_src_idu_exu = 0U;
                                vlSelfRef.top__DOT__alu_op_idu_exu = 0U;
                            }
                        }
                    }
                }
            }
        }
    } else if ((0x00000020U & vlSelfRef.inst)) {
        if ((0x00000010U & vlSelfRef.inst)) {
            if ((1U & (~ (vlSelfRef.inst >> 3U)))) {
                if ((4U & vlSelfRef.inst)) {
                    if ((2U & vlSelfRef.inst)) {
                        if ((1U & vlSelfRef.inst)) {
                            vlSelfRef.top__DOT__imm_idu_exu 
                                = (0xfffff000U & vlSelfRef.inst);
                            vlSelfRef.top__DOT__reg_src_idu_exu = 3U;
                            vlSelfRef.top__DOT__wen_idu_exu = 1U;
                            vlSelfRef.top__DOT__pc_src_idu_exu = 0U;
                        }
                    }
                } else if ((2U & vlSelfRef.inst)) {
                    if ((1U & vlSelfRef.inst)) {
                        if (vlSelfRef.top__DOT__idu0__DOT____VdfgExtracted_h87ea21a1__0) {
                            vlSelfRef.top__DOT__reg_src_idu_exu = 0U;
                            vlSelfRef.top__DOT__wen_idu_exu = 1U;
                            vlSelfRef.top__DOT__pc_src_idu_exu = 0U;
                        }
                    }
                }
                if ((1U & (~ (vlSelfRef.inst >> 2U)))) {
                    if ((2U & vlSelfRef.inst)) {
                        if ((1U & vlSelfRef.inst)) {
                            if (vlSelfRef.top__DOT__idu0__DOT____VdfgExtracted_h87ea21a1__0) {
                                vlSelfRef.top__DOT__alu_src_idu_exu = 1U;
                                vlSelfRef.top__DOT__alu_op_idu_exu = 0U;
                            }
                        }
                    }
                }
            }
        } else if ((1U & (~ (vlSelfRef.inst >> 3U)))) {
            if ((1U & (~ (vlSelfRef.inst >> 2U)))) {
                if ((2U & vlSelfRef.inst)) {
                    if ((1U & vlSelfRef.inst)) {
                        vlSelfRef.top__DOT__imm_idu_exu 
                            = (((- (IData)((vlSelfRef.inst 
                                            >> 0x0000001fU))) 
                                << 0x0000000cU) | (
                                                   (0x00000fe0U 
                                                    & (vlSelfRef.inst 
                                                       >> 0x00000014U)) 
                                                   | (0x0000001fU 
                                                      & (vlSelfRef.inst 
                                                         >> 7U))));
                        vlSelfRef.top__DOT__wen_idu_exu = 0U;
                        vlSelfRef.top__DOT__alu_src_idu_exu = 0U;
                        vlSelfRef.top__DOT__alu_op_idu_exu = 0U;
                    }
                }
            }
        }
    } else if ((0x00000010U & vlSelfRef.inst)) {
        if ((1U & (~ (vlSelfRef.inst >> 3U)))) {
            if ((1U & (~ (vlSelfRef.inst >> 2U)))) {
                if ((2U & vlSelfRef.inst)) {
                    if ((1U & vlSelfRef.inst)) {
                        if ((0U == (7U & (vlSelfRef.inst 
                                          >> 0x0000000cU)))) {
                            vlSelfRef.top__DOT__imm_idu_exu 
                                = vlSelfRef.top__DOT__idu0__DOT__Iimm;
                            vlSelfRef.top__DOT__reg_src_idu_exu = 0U;
                            vlSelfRef.top__DOT__wen_idu_exu = 1U;
                            vlSelfRef.top__DOT__pc_src_idu_exu = 0U;
                            vlSelfRef.top__DOT__alu_src_idu_exu = 0U;
                            vlSelfRef.top__DOT__alu_op_idu_exu = 0U;
                        }
                    }
                }
            }
        }
    } else if ((1U & (~ (vlSelfRef.inst >> 3U)))) {
        if ((1U & (~ (vlSelfRef.inst >> 2U)))) {
            if ((2U & vlSelfRef.inst)) {
                if ((1U & vlSelfRef.inst)) {
                    vlSelfRef.top__DOT__imm_idu_exu 
                        = vlSelfRef.top__DOT__idu0__DOT__Iimm;
                    vlSelfRef.top__DOT__reg_src_idu_exu = 1U;
                    vlSelfRef.top__DOT__wen_idu_exu = 1U;
                    vlSelfRef.top__DOT__alu_src_idu_exu = 0U;
                    vlSelfRef.top__DOT__alu_op_idu_exu = 0U;
                }
            }
        }
    }
    vlSelfRef.top__DOT__pc_en_wb_pc = ((0U != (IData)(vlSelfRef.top__DOT__pc_src_idu_exu)) 
                                       && (3U == (IData)(vlSelfRef.top__DOT__pc_src_idu_exu)));
    vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z = (
                                                   (0U 
                                                    == (IData)(vlSelfRef.top__DOT__alu_op_idu_exu))
                                                    ? 
                                                   (vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf
                                                    [
                                                    (0x0000000fU 
                                                     & (vlSelfRef.inst 
                                                        >> 0x0000000fU))] 
                                                    + 
                                                    ((IData)(vlSelfRef.top__DOT__alu_src_idu_exu)
                                                      ? vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rdata2
                                                      : vlSelfRef.top__DOT__imm_idu_exu))
                                                    : 0U);
    vlSelfRef.top__DOT__pc_wb_pc = ((0U == (IData)(vlSelfRef.top__DOT__pc_src_idu_exu))
                                     ? ((IData)(4U) 
                                        + vlSelfRef.top__DOT__pc0__DOT__pc)
                                     : ((3U == (IData)(vlSelfRef.top__DOT__pc_src_idu_exu))
                                         ? vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z
                                         : ((IData)(4U) 
                                            + vlSelfRef.top__DOT__pc0__DOT__pc)));
    VL_WRITEF_NX("pc: %08x, src1: %08x, src2: %08x, imm: %08x alu:%08x\n",0,
                 32,vlSelfRef.top__DOT__pc0__DOT__pc,
                 32,vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf
                 [(0x0000000fU & (vlSelfRef.inst >> 0x0000000fU))],
                 32,vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rdata2,
                 32,vlSelfRef.top__DOT__imm_idu_exu,
                 32,vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z);
    if (vlSelfRef.top__DOT__valid_idu_exu) {
        vlSelfRef.top__DOT__rdata_lsu_wbu = ((([&]() {
                        Vtop___024unit____Vdpiimwrap_pmem_read_TOP____024unit(vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z, vlSelfRef.__Vfunc_pmem_read__1__Vfuncout);
                    }(), vlSelfRef.__Vfunc_pmem_read__1__Vfuncout) 
                                              >> (0x00000018U 
                                                  & (vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z 
                                                     << 3U))) 
                                             & ((2U 
                                                 == (IData)(vlSelfRef.top__DOT__width_idu_exu))
                                                 ? 0xffffffffU
                                                 : 
                                                ((1U 
                                                  == (IData)(vlSelfRef.top__DOT__width_idu_exu))
                                                  ? 0x0000ffffU
                                                  : 
                                                 ((0U 
                                                   == (IData)(vlSelfRef.top__DOT__width_idu_exu))
                                                   ? 0x000000ffU
                                                   : 0U))));
        if (vlSelfRef.top__DOT__mem_wen_idu_exu) {
            Vtop___024unit____Vdpiimwrap_pmem_write_TOP____024unit(vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z, vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rdata2, 
                                                                   ((2U 
                                                                     == (IData)(vlSelfRef.top__DOT__width_idu_exu))
                                                                     ? 0x0000000fU
                                                                     : 
                                                                    (0x0000000fU 
                                                                     & ((1U 
                                                                         == (IData)(vlSelfRef.top__DOT__width_idu_exu))
                                                                         ? 
                                                                        ((IData)(3U) 
                                                                         << 
                                                                         (3U 
                                                                          & vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z))
                                                                         : 
                                                                        ((0U 
                                                                          == (IData)(vlSelfRef.top__DOT__width_idu_exu))
                                                                          ? 
                                                                         ((IData)(1U) 
                                                                          << 
                                                                          (3U 
                                                                           & vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z))
                                                                          : 0U)))));
        }
    } else {
        vlSelfRef.top__DOT__rdata_lsu_wbu = 0U;
    }
}

VL_ATTR_COLD void Vtop___024root___eval_stl(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_stl\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VstlTriggered[0U])) {
        Vtop___024root___stl_sequent__TOP__0(vlSelf);
        Vtop___024root____Vm_traceActivitySetAll(vlSelf);
    }
}

VL_ATTR_COLD bool Vtop___024root___eval_phase__stl(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__stl\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VstlExecute;
    // Body
    Vtop___024root___eval_triggers_vec__stl(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtop___024root___dump_triggers__stl(vlSelfRef.__VstlTriggered, "stl"s);
    }
#endif
    __VstlExecute = Vtop___024root___trigger_anySet__stl(vlSelfRef.__VstlTriggered);
    if (__VstlExecute) {
        Vtop___024root___eval_stl(vlSelf);
    }
    return (__VstlExecute);
}

bool Vtop___024root___trigger_anySet__ico(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__ico\n"); );
    // Body
    if ((1U & (~ (IData)(Vtop___024root___trigger_anySet__ico(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: Internal 'ico' trigger - first iteration\n");
    }
}
#endif  // VL_DEBUG

bool Vtop___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in);

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___dump_triggers__act\n"); );
    // Body
    if ((1U & (~ (IData)(Vtop___024root___trigger_anySet__act(triggers))))) {
        VL_DBG_MSGS("         No '" + tag + "' region triggers active\n");
    }
    if ((1U & (IData)(triggers[0U]))) {
        VL_DBG_MSGS("         '" + tag + "' region trigger index 0 is active: @(posedge clk)\n");
    }
}
#endif  // VL_DEBUG

VL_ATTR_COLD void Vtop___024root____Vm_traceActivitySetAll(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root____Vm_traceActivitySetAll\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__Vm_traceActivity[0U] = 1U;
    vlSelfRef.__Vm_traceActivity[1U] = 1U;
    vlSelfRef.__Vm_traceActivity[2U] = 1U;
}

VL_ATTR_COLD void Vtop___024root___ctor_var_reset(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ctor_var_reset\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    const uint64_t __VscopeHash = VL_MURMUR64_HASH(vlSelf->vlNamep);
    vlSelf->clk = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 16707436170211756652ull);
    vlSelf->rst = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 18209466448985614591ull);
    vlSelf->pc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 4211327832146562899ull);
    vlSelf->inst = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 9812503827101699671ull);
    vlSelf->a0 = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17342812819118991936ull);
    vlSelf->top__DOT__pc_en_wb_pc = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 7935241606323689082ull);
    vlSelf->top__DOT__pc_wb_pc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17790758170788412518ull);
    vlSelf->top__DOT__imm_idu_exu = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14630139422896806268ull);
    vlSelf->top__DOT__alu_op_idu_exu = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 9893720311961449924ull);
    vlSelf->top__DOT__pc_src_idu_exu = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 12296968528037000490ull);
    vlSelf->top__DOT__reg_src_idu_exu = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 18369608021547965176ull);
    vlSelf->top__DOT__alu_src_idu_exu = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 4149450208957070876ull);
    vlSelf->top__DOT__wen_idu_exu = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 10153083167708220638ull);
    vlSelf->top__DOT__raddr1_wbu_gpr = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 15862907962633135096ull);
    vlSelf->top__DOT__raddr2_wbu_gpr = VL_SCOPED_RAND_RESET_I(4, __VscopeHash, 9595305977994654248ull);
    vlSelf->top__DOT__rdata_gpr_idu = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 10329203839276823524ull);
    vlSelf->top__DOT__mem_wen_idu_exu = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 14686892590925278784ull);
    vlSelf->top__DOT__valid_idu_exu = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 8886517829719358358ull);
    vlSelf->top__DOT__rdata_lsu_wbu = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 13143859624615586301ull);
    vlSelf->top__DOT__width_idu_exu = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 12594875755283304448ull);
    vlSelf->top__DOT__break_idu_pc = VL_SCOPED_RAND_RESET_I(1, __VscopeHash, 18150703762578084692ull);
    vlSelf->top__DOT__pc0__DOT__pc = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 6099226751608281888ull);
    vlSelf->top__DOT__idu0__DOT__Iimm = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 14668386419717248568ull);
    vlSelf->top__DOT__idu0__DOT____VdfgExtracted_h87ea21a1__0 = 0;
    vlSelf->top__DOT__gpr0__DOT__Gpr__DOT__rdata2 = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 17519060587607904787ull);
    for (int __Vi0 = 0; __Vi0 < 16; ++__Vi0) {
        vlSelf->top__DOT__gpr0__DOT__Gpr__DOT__rf[__Vi0] = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 230308290063882739ull);
    }
    vlSelf->top__DOT__exu0__DOT__pc_sync_in = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 13792959745532292548ull);
    vlSelf->top__DOT__exu0__DOT__alu0__DOT__z = VL_SCOPED_RAND_RESET_I(32, __VscopeHash, 11747356967443884239ull);
    vlSelf->top__DOT__lsu0__DOT__mem_data = VL_SCOPED_RAND_RESET_I(2, __VscopeHash, 8215566560132465476ull);
    vlSelf->__Vfunc_pmem_read__1__Vfuncout = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VstlTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VicoTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VactTriggered[__Vi0] = 0;
    }
    vlSelf->__Vtrigprevexpr___TOP__clk__0 = 0;
    for (int __Vi0 = 0; __Vi0 < 1; ++__Vi0) {
        vlSelf->__VnbaTriggered[__Vi0] = 0;
    }
    for (int __Vi0 = 0; __Vi0 < 3; ++__Vi0) {
        vlSelf->__Vm_traceActivity[__Vi0] = 0;
    }
}
