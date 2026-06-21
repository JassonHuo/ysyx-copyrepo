// Verilated -*- C++ -*-
// DESCRIPTION: Verilator output: Tracing implementation internals

#include "verilated_vcd_c.h"
#include "Vtop__Syms.h"


void Vtop___024root__trace_chg_0_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp);

void Vtop___024root__trace_chg_0(void* voidSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_chg_0\n"); );
    // Body
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    if (VL_UNLIKELY(!vlSymsp->__Vm_activity)) return;
    Vtop___024root__trace_chg_0_sub_0((&vlSymsp->TOP), bufp);
}

void Vtop___024root__trace_chg_0_sub_0(Vtop___024root* vlSelf, VerilatedVcd::Buffer* bufp) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_chg_0_sub_0\n"); );
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    auto& vlSelfRef = std::ref(*vlSelf).get();
    // Body
    uint32_t* const oldp VL_ATTR_UNUSED = bufp->oldp(vlSymsp->__Vm_baseCode + 0);
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[1U]))) {
        bufp->chgBit(oldp+0,(vlSelfRef.top__DOT__pc_en_wb_pc));
        bufp->chgIData(oldp+1,(vlSelfRef.top__DOT__imm_idu_exu),32);
        bufp->chgCData(oldp+2,(vlSelfRef.top__DOT__alu_op_idu_exu),4);
        bufp->chgCData(oldp+3,(vlSelfRef.top__DOT__pc_src_idu_exu),2);
        bufp->chgCData(oldp+4,(vlSelfRef.top__DOT__reg_src_idu_exu),2);
        bufp->chgBit(oldp+5,(vlSelfRef.top__DOT__alu_src_idu_exu));
        bufp->chgBit(oldp+6,(vlSelfRef.top__DOT__wen_idu_exu));
        bufp->chgBit(oldp+7,(vlSelfRef.top__DOT__mem_wen_idu_exu));
        bufp->chgBit(oldp+8,(vlSelfRef.top__DOT__valid_idu_exu));
        bufp->chgCData(oldp+9,(vlSelfRef.top__DOT__width_idu_exu),2);
        bufp->chgBit(oldp+10,(vlSelfRef.top__DOT__break_idu_pc));
        bufp->chgIData(oldp+11,(vlSelfRef.top__DOT__idu0__DOT__Iimm),32);
    }
    if (VL_UNLIKELY(((vlSelfRef.__Vm_traceActivity[1U] 
                      | vlSelfRef.__Vm_traceActivity[2U])))) {
        bufp->chgIData(oldp+12,(((0U == (IData)(vlSelfRef.top__DOT__pc_src_idu_exu))
                                  ? ((IData)(4U) + vlSelfRef.top__DOT__pc0__DOT__pc)
                                  : ((3U == (IData)(vlSelfRef.top__DOT__pc_src_idu_exu))
                                      ? vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z
                                      : ((IData)(4U) 
                                         + vlSelfRef.top__DOT__pc0__DOT__pc)))),32);
        bufp->chgIData(oldp+13,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rdata2),32);
        bufp->chgIData(oldp+14,(((0U == (IData)(vlSelfRef.top__DOT__reg_src_idu_exu))
                                  ? vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z
                                  : ((2U == (IData)(vlSelfRef.top__DOT__reg_src_idu_exu))
                                      ? ((IData)(4U) 
                                         + vlSelfRef.top__DOT__pc0__DOT__pc)
                                      : ((3U == (IData)(vlSelfRef.top__DOT__reg_src_idu_exu))
                                          ? vlSelfRef.top__DOT__imm_idu_exu
                                          : ((1U == (IData)(vlSelfRef.top__DOT__reg_src_idu_exu))
                                              ? vlSelfRef.top__DOT__rdata_lsu_wbu
                                              : 0U))))),32);
        bufp->chgIData(oldp+15,(vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z),32);
        bufp->chgIData(oldp+16,((vlSelfRef.top__DOT__imm_idu_exu 
                                 + vlSelfRef.top__DOT__pc0__DOT__pc)),32);
        bufp->chgIData(oldp+17,(vlSelfRef.top__DOT__rdata_lsu_wbu),32);
        bufp->chgBit(oldp+18,((0U == vlSelfRef.top__DOT__exu0__DOT__alu0__DOT__z)));
        bufp->chgIData(oldp+19,(((IData)(vlSelfRef.top__DOT__alu_src_idu_exu)
                                  ? vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rdata2
                                  : vlSelfRef.top__DOT__imm_idu_exu)),32);
        bufp->chgCData(oldp+20,(((2U == (IData)(vlSelfRef.top__DOT__width_idu_exu))
                                  ? 0x0000000fU : (0x0000000fU 
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
                                                        : 0U))))),4);
    }
    if (VL_UNLIKELY((vlSelfRef.__Vm_traceActivity[2U]))) {
        bufp->chgIData(oldp+21,(vlSelfRef.top__DOT__pc0__DOT__pc),32);
        bufp->chgIData(oldp+22,(((IData)(4U) + vlSelfRef.top__DOT__pc0__DOT__pc)),32);
        bufp->chgIData(oldp+23,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[0]),32);
        bufp->chgIData(oldp+24,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[1]),32);
        bufp->chgIData(oldp+25,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[2]),32);
        bufp->chgIData(oldp+26,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[3]),32);
        bufp->chgIData(oldp+27,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[4]),32);
        bufp->chgIData(oldp+28,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[5]),32);
        bufp->chgIData(oldp+29,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[6]),32);
        bufp->chgIData(oldp+30,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[7]),32);
        bufp->chgIData(oldp+31,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[8]),32);
        bufp->chgIData(oldp+32,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[9]),32);
        bufp->chgIData(oldp+33,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[10]),32);
        bufp->chgIData(oldp+34,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[11]),32);
        bufp->chgIData(oldp+35,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[12]),32);
        bufp->chgIData(oldp+36,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[13]),32);
        bufp->chgIData(oldp+37,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[14]),32);
        bufp->chgIData(oldp+38,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf[15]),32);
    }
    bufp->chgBit(oldp+39,(vlSelfRef.clk));
    bufp->chgBit(oldp+40,(vlSelfRef.rst));
    bufp->chgIData(oldp+41,(vlSelfRef.pc),32);
    bufp->chgIData(oldp+42,(vlSelfRef.inst),32);
    bufp->chgIData(oldp+43,(vlSelfRef.a0),32);
    bufp->chgIData(oldp+44,(vlSelfRef.top__DOT__gpr0__DOT__Gpr__DOT__rf
                            [(0x0000000fU & (vlSelfRef.inst 
                                             >> 0x0000000fU))]),32);
    bufp->chgCData(oldp+45,((0x0000000fU & (vlSelfRef.inst 
                                            >> 7U))),4);
    bufp->chgCData(oldp+46,((0x0000000fU & (vlSelfRef.inst 
                                            >> 0x0000000fU))),4);
    bufp->chgCData(oldp+47,((0x0000000fU & (vlSelfRef.inst 
                                            >> 0x00000014U))),4);
    bufp->chgCData(oldp+48,((0x0000007fU & vlSelfRef.inst)),7);
    bufp->chgCData(oldp+49,((0x0000001fU & (vlSelfRef.inst 
                                            >> 0x0000000fU))),5);
    bufp->chgCData(oldp+50,((0x0000001fU & (vlSelfRef.inst 
                                            >> 0x00000014U))),5);
    bufp->chgCData(oldp+51,((0x0000001fU & (vlSelfRef.inst 
                                            >> 7U))),5);
    bufp->chgCData(oldp+52,((7U & (vlSelfRef.inst >> 0x0000000cU))),3);
    bufp->chgCData(oldp+53,((vlSelfRef.inst >> 0x00000019U)),7);
    bufp->chgIData(oldp+54,((((- (IData)((vlSelfRef.inst 
                                          >> 0x0000001fU))) 
                              << 0x0000000cU) | ((0x00000fe0U 
                                                  & (vlSelfRef.inst 
                                                     >> 0x00000014U)) 
                                                 | (0x0000001fU 
                                                    & (vlSelfRef.inst 
                                                       >> 7U))))),32);
    bufp->chgIData(oldp+55,((((- (IData)((vlSelfRef.inst 
                                          >> 0x0000001fU))) 
                              << 0x0000000cU) | ((0x00000800U 
                                                  & (vlSelfRef.inst 
                                                     << 4U)) 
                                                 | ((0x000007e0U 
                                                     & (vlSelfRef.inst 
                                                        >> 0x00000014U)) 
                                                    | (0x0000001eU 
                                                       & (vlSelfRef.inst 
                                                          >> 7U)))))),32);
    bufp->chgIData(oldp+56,((0xfffff000U & vlSelfRef.inst)),32);
    bufp->chgIData(oldp+57,(((((0x00000ffeU & ((- (IData)(
                                                          (vlSelfRef.inst 
                                                           >> 0x0000001fU))) 
                                               << 1U)) 
                               | (vlSelfRef.inst >> 0x0000001fU)) 
                              << 0x00000014U) | (((
                                                   (0x000001feU 
                                                    & (vlSelfRef.inst 
                                                       >> 0x0000000bU)) 
                                                   | (1U 
                                                      & (vlSelfRef.inst 
                                                         >> 0x00000014U))) 
                                                  << 0x0000000bU) 
                                                 | (0x000007feU 
                                                    & (vlSelfRef.inst 
                                                       >> 0x00000014U))))),32);
}

void Vtop___024root__trace_cleanup(void* voidSelf, VerilatedVcd* /*unused*/) {
    VL_DEBUG_IF(VL_DBG_MSGF("+    Vtop___024root__trace_cleanup\n"); );
    // Body
    Vtop___024root* const __restrict vlSelf VL_ATTR_UNUSED = static_cast<Vtop___024root*>(voidSelf);
    Vtop__Syms* const __restrict vlSymsp VL_ATTR_UNUSED = vlSelf->vlSymsp;
    vlSymsp->__Vm_activity = false;
    vlSymsp->TOP.__Vm_traceActivity[0U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[1U] = 0U;
    vlSymsp->TOP.__Vm_traceActivity[2U] = 0U;
}
