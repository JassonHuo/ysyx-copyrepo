// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Design implementation internals
// See Vtop.h for the primary calling header

#include "Vtop__pch.h"

void Vtop___024root___eval_triggers_vec__ico(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_triggers_vec__ico\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VicoTriggered[0U] = ((0xfffffffffffffffeULL 
                                      & vlSelfRef.__VicoTriggered[0U]) 
                                     | (IData)((IData)(vlSelfRef.__VicoFirstIteration)));
}

bool Vtop___024root___trigger_anySet__ico(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___trigger_anySet__ico\n"); );
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

void Vtop___024root___ico_sequent__TOP__0(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___ico_sequent__TOP__0\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
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
    vlSelfRef.top__DOT__pc_en_wb_pc = (0U != (IData)(vlSelfRef.top__DOT__pc_src_idu_exu));
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

void Vtop___024root___eval_ico(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_ico\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VicoTriggered[0U])) {
        Vtop___024root___ico_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[1U] = 1U;
    }
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__ico(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vtop___024root___eval_phase__ico(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__ico\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VicoExecute;
    // Body
    Vtop___024root___eval_triggers_vec__ico(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtop___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
    }
#endif
    __VicoExecute = Vtop___024root___trigger_anySet__ico(vlSelfRef.__VicoTriggered);
    if (__VicoExecute) {
        Vtop___024root___eval_ico(vlSelf);
    }
    return (__VicoExecute);
}

void Vtop___024root___eval_triggers_vec__act(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_triggers_vec__act\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    vlSelfRef.__VactTriggered[0U] = (QData)((IData)(
                                                    ((IData)(vlSelfRef.clk) 
                                                     & (~ (IData)(vlSelfRef.__Vtrigprevexpr___TOP__clk__0)))));
    vlSelfRef.__Vtrigprevexpr___TOP__clk__0 = vlSelfRef.clk;
}

bool Vtop___024root___trigger_anySet__act(const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___trigger_anySet__act\n"); );
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

void Vtop___024unit____Vdpiimwrap_ebreak_TOP____024unit();

void Vtop___024root___nba_sequent__TOP__0(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___nba_sequent__TOP__0\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VdlyVal__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0;
    __VdlyVal__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0 = 0;
    CData/*3:0*/ __VdlyDim0__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0;
    __VdlyDim0__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0 = 0;
    CData/*0:0*/ __VdlySet__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0;
    __VdlySet__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0 = 0;
    // Body
    __VdlySet__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0 = 0U;
    if (((IData)(vlSelfRef.top__DOT__wen_idu_exu) & 
         (0U != (0x0000000fU & (vlSelfRef.inst >> 7U))))) {
        __VdlyVal__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0 
            = ((0U == (IData)(vlSelfRef.top__DOT__reg_src_idu_exu))
                ? vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z
                : ((2U == (IData)(vlSelfRef.top__DOT__reg_src_idu_exu))
                    ? ((IData)(4U) + vlSelfRef.top__DOT__pc0__DOT__pc)
                    : ((3U == (IData)(vlSelfRef.top__DOT__reg_src_idu_exu))
                        ? vlSelfRef.top__DOT__imm_idu_exu
                        : ((1U == (IData)(vlSelfRef.top__DOT__reg_src_idu_exu))
                            ? vlSelfRef.top__DOT__rdata_lsu_wbu
                            : 0U))));
        __VdlyDim0__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0 
            = (0x0000000fU & (vlSelfRef.inst >> 7U));
        __VdlySet__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0 = 1U;
    }
    if (__VdlySet__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0) {
        vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[__VdlyDim0__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0] 
            = __VdlyVal__top__DOT__gpr0__DOT__Gpr__DOT__rf__v0;
    }
    if (vlSelfRef.rst) {
        vlSelfRef.top__DOT__pc0__DOT__pc = 0x80000000U;
    } else if (vlSelfRef.top__DOT__break_idu_pc) {
        Vtop___024unit____Vdpiimwrap_ebreak_TOP____024unit();
    } else {
        vlSelfRef.top__DOT__pc0__DOT__pc = ((IData)(vlSelfRef.top__DOT__pc_en_wb_pc)
                                             ? vlSelfRef.top__DOT__pc_wb_pc
                                             : vlSelfRef.top__DOT__exu0__DOT__pc_sync_in);
    }
    vlSelfRef.a0 = vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[10U];
    vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rdata2 
        = vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf
        [(0x0000000fU & (vlSelfRef.inst >> 0x00000014U))];
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
    vlSelfRef.pc = vlSelfRef.top__DOT__pc0__DOT__pc;
    vlSelfRef.top__DOT__exu0__DOT__pc_sync_in = ((IData)(4U) 
                                                 + vlSelfRef.top__DOT__pc0__DOT__pc);
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

void Vtop___024root___eval_nba(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_nba\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if ((1ULL & vlSelfRef.__VnbaTriggered[0U])) {
        Vtop___024root___nba_sequent__TOP__0(vlSelf);
        vlSelfRef.__Vm_traceActivity[2U] = 1U;
    }
}

void Vtop___024root___trigger_orInto__act_vec_vec(VlUnpacked<QData/*63:0*/, 1> &out, const VlUnpacked<QData/*63:0*/, 1> &in) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___trigger_orInto__act_vec_vec\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = (out[n] | in[n]);
        n = ((IData)(1U) + n);
    } while ((0U >= n));
}

#ifdef VL_DEBUG
VL_ATTR_COLD void Vtop___024root___dump_triggers__act(const VlUnpacked<QData/*63:0*/, 1> &triggers, const std::string &tag);
#endif  // VL_DEBUG

bool Vtop___024root___eval_phase__act(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__act\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    Vtop___024root___eval_triggers_vec__act(vlSelf);
#ifdef VL_DEBUG
    if (VL_UNLIKELY(vlSymsp->_vm_contextp__->debug())) {
        Vtop___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
    }
#endif
    Vtop___024root___trigger_orInto__act_vec_vec(vlSelfRef.__VnbaTriggered, vlSelfRef.__VactTriggered);
    return (0U);
}

void Vtop___024root___trigger_clear__act(VlUnpacked<QData/*63:0*/, 1> &out) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___trigger_clear__act\n"); );
    // Locals
    IData/*31:0*/ n;
    // Body
    n = 0U;
    do {
        out[n] = 0ULL;
        n = ((IData)(1U) + n);
    } while ((1U > n));
}

bool Vtop___024root___eval_phase__nba(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_phase__nba\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    CData/*0:0*/ __VnbaExecute;
    // Body
    __VnbaExecute = Vtop___024root___trigger_anySet__act(vlSelfRef.__VnbaTriggered);
    if (__VnbaExecute) {
        Vtop___024root___eval_nba(vlSelf);
        Vtop___024root___trigger_clear__act(vlSelfRef.__VnbaTriggered);
    }
    return (__VnbaExecute);
}

void Vtop___024root___eval(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Locals
    IData/*31:0*/ __VicoIterCount;
    IData/*31:0*/ __VnbaIterCount;
    // Body
    __VicoIterCount = 0U;
    vlSelfRef.__VicoFirstIteration = 1U;
    do {
        if (VL_UNLIKELY(((0x00000064U < __VicoIterCount)))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__ico(vlSelfRef.__VicoTriggered, "ico"s);
#endif
            VL_FATAL_MT("vsrc/top.v", 1, "", "DIDNOTCONVERGE: Input combinational region did not converge after '--converge-limit' of 100 tries");
        }
        __VicoIterCount = ((IData)(1U) + __VicoIterCount);
        vlSelfRef.__VicoPhaseResult = Vtop___024root___eval_phase__ico(vlSelf);
        vlSelfRef.__VicoFirstIteration = 0U;
    } while (vlSelfRef.__VicoPhaseResult);
    __VnbaIterCount = 0U;
    do {
        if (VL_UNLIKELY(((0x00000064U < __VnbaIterCount)))) {
#ifdef VL_DEBUG
            Vtop___024root___dump_triggers__act(vlSelfRef.__VnbaTriggered, "nba"s);
#endif
            VL_FATAL_MT("vsrc/top.v", 1, "", "DIDNOTCONVERGE: NBA region did not converge after '--converge-limit' of 100 tries");
        }
        __VnbaIterCount = ((IData)(1U) + __VnbaIterCount);
        vlSelfRef.__VactIterCount = 0U;
        do {
            if (VL_UNLIKELY(((0x00000064U < vlSelfRef.__VactIterCount)))) {
#ifdef VL_DEBUG
                Vtop___024root___dump_triggers__act(vlSelfRef.__VactTriggered, "act"s);
#endif
                VL_FATAL_MT("vsrc/top.v", 1, "", "DIDNOTCONVERGE: Active region did not converge after '--converge-limit' of 100 tries");
            }
            vlSelfRef.__VactIterCount = ((IData)(1U) 
                                         + vlSelfRef.__VactIterCount);
            vlSelfRef.__VactPhaseResult = Vtop___024root___eval_phase__act(vlSelf);
        } while (vlSelfRef.__VactPhaseResult);
        vlSelfRef.__VnbaPhaseResult = Vtop___024root___eval_phase__nba(vlSelf);
    } while (vlSelfRef.__VnbaPhaseResult);
}

#ifdef VL_DEBUG
void Vtop___024root___eval_debug_assertions(Vtop___024root* vlSelf) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root___eval_debug_assertions\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    if (VL_UNLIKELY(((vlSelfRef.clk & 0xfeU)))) {
        Verilated::overWidthError("clk");
    }
    if (VL_UNLIKELY(((vlSelfRef.rst & 0xfeU)))) {
        Verilated::overWidthError("rst");
    }
}
#endif  // VL_DEBUG
