# This script was generated automatically by bender.
set ROOT "/home/igorcintra13/culsans_questa/modules/cva6"

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "$ROOT/.bender/git/checkouts/common_verification-fd5a4c811d618157/src/clk_rst_gen.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-fd5a4c811d618157/src/rand_id_queue.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-fd5a4c811d618157/src/rand_stream_mst.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-fd5a4c811d618157/src/rand_synch_holdable_driver.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-fd5a4c811d618157/src/rand_verif_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-fd5a4c811d618157/src/signal_highlighter.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-fd5a4c811d618157/src/sim_timeout.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-fd5a4c811d618157/src/stream_watchdog.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-fd5a4c811d618157/src/rand_synch_driver.sv" \
    "$ROOT/.bender/git/checkouts/common_verification-fd5a4c811d618157/src/rand_stream_slv.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/rtl/tc_sram.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/rtl/tc_sram_impl.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/rtl/tc_clk.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/deprecated/cluster_pwr_cells.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/deprecated/generic_memory.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/deprecated/generic_rom.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/deprecated/pad_functional.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/deprecated/pulp_buffer.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/deprecated/pulp_pwr_cells.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/tc_pwr.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/deprecated/pulp_clock_gating_async.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/deprecated/cluster_clk_cells.sv" \
    "$ROOT/.bender/git/checkouts/tech_cells_generic-cc24c124b7267269/src/deprecated/pulp_clk_cells.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/binary_to_gray.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cb_filter_pkg.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cc_onehot.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cf_math_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/clk_int_div.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/delta_counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/ecc_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/edge_propagator_tx.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/exp_backoff.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/fifo_v3.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/gray_to_binary.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/isochronous_4phase_handshake.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/isochronous_spill_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/lfsr.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/lfsr_16bit.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/lfsr_8bit.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/mv_filter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/onehot_to_bin.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/plru_tree.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/popcount.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/rr_arb_tree.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/rstgen_bypass.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/serial_deglitch.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/shift_reg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/shift_reg_gated.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/spill_register_flushable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_demux.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_filter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_fork.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_intf.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_join.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_mux.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_throttle.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/lossy_valid_to_stream.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/sub_per_hash.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/sync.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/sync_wedge.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/unread.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/read.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cdc_reset_ctrlr_pkg.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/clk_int_div_static.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/addr_decode_napot.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cdc_2phase.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cdc_4phase.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/addr_decode.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cb_filter.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cdc_fifo_2phase.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/ecc_decode.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/ecc_encode.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/edge_detect.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/lzc.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/max_counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/rstgen.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/spill_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_delay.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_fifo.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_fork_dynamic.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/clk_mux_glitch_free.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cdc_reset_ctrlr.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cdc_fifo_gray.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/fall_through_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/id_queue.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_to_mem.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_arbiter_flushable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_fifo_optimal_wrap.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_register.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_xbar.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cdc_fifo_gray_clearable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/cdc_2phase_clearable.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/mem_to_banks.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_arbiter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/stream_omega_net.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/sram.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/clock_divider_counter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/clk_div.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/find_first_one.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/generic_LFSR_8bit.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/generic_fifo.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/prioarbiter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/pulp_sync.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/pulp_sync_wedge.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/rrarbiter.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/clock_divider.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/fifo_v2.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/deprecated/fifo_v1.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/edge_propagator_ack.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/edge_propagator.sv" \
    "$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/src/edge_propagator_rx.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/include" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_pkg.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_intf.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_atop_filter.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_burst_splitter.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_bus_compare.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_cdc_dst.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_cdc_src.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_cut.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_delayer.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_demux.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_dw_downsizer.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_dw_upsizer.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_fifo.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_id_remap.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_id_prepend.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_isolate.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_join.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_demux.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_dw_converter.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_from_mem.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_join.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_lfsr.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_mailbox.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_mux.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_regs.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_to_apb.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_to_axi.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_modify_address.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_mux.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_rw_join.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_rw_split.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_serializer.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_slave_compare.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_throttle.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_to_mem.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_cdc.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_err_slv.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_dw_converter.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_from_mem.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_id_serialize.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lfsr.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_multicut.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_to_axi_lite.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_to_mem_banked.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_to_mem_interleaved.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_to_mem_split.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_iw_converter.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_lite_xbar.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_xbar.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_xp.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/include" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_chan_compare.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_dumper.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_sim_mem.sv" \
    "$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/src/axi_test.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-dd98d4eaba0b805e/hdl/defs_div_sqrt_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-dd98d4eaba0b805e/hdl/iteration_div_sqrt_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-dd98d4eaba0b805e/hdl/control_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-dd98d4eaba0b805e/hdl/norm_div_sqrt_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-dd98d4eaba0b805e/hdl/preprocess_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-dd98d4eaba0b805e/hdl/nrbd_nrsc_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-dd98d4eaba0b805e/hdl/div_sqrt_top_mvp.sv" \
    "$ROOT/.bender/git/checkouts/fpu_div_sqrt_mvp-dd98d4eaba0b805e/hdl/div_sqrt_mvp_wrapper.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/include" \
    "+incdir+$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/include" \
    "$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/src/ace_pkg.sv" \
    "$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/src/snoop_pkg.sv" \
    "$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/src/ace_intf.sv" \
    "$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/src/snoop_intf.sv" \
    "$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/src/ace_trs_dec.sv" \
    "$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/src/ccu_fsm.sv" \
    "$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/src/ace_ccu_top.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/include" \
    "+incdir+$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/include" \
    "$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/src/ace_test.sv" \
    "$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/src/snoop_test.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_pkg.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_cast_multi.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_classifier.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/clk/rtl/gated_clk_cell.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_ctrl.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_ff1.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_pack_single.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_prepare.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_round_single.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_special.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_srt_single.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_top.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_dp.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_frbus.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_src_type.v" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_divsqrt_th_32.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_divsqrt_multi.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_fma.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_fma_multi.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_sdotp_multi.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_sdotp_multi_wrapper.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_noncomp.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_opgroup_block.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_opgroup_fmt_slice.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_opgroup_multifmt_slice.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_rounding.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/lfsr_sr.sv" \
    "$ROOT/.bender/git/checkouts/fpnew-be42bfd5f9e85d24/src/fpnew_top.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/include" \
    "+incdir+$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/include" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "$ROOT/core/include/ariane_axi_pkg.sv" \
    "$ROOT/core/include/ariane_ace_pkg.sv" \
    "$ROOT/core/include/wt_cache_pkg.sv" \
    "$ROOT/core/include/std_cache_pkg.sv" \
    "$ROOT/core/include/axi_intf.sv" \
    "$ROOT/core/include/cvxif_pkg.sv" \
    "$ROOT/core/cvxif_example/include/cvxif_instr_pkg.sv" \
    "$ROOT/core/cvxif_fu.sv" \
    "$ROOT/core/cvxif_example/cvxif_example_coprocessor.sv" \
    "$ROOT/core/cvxif_example/instr_decoder.sv" \
    "$ROOT/corev_apu/tb/ariane.sv" \
    "$ROOT/core/cva6.sv" \
    "$ROOT/core/alu.sv" \
    "$ROOT/core/fpu_wrap.sv" \
    "$ROOT/core/branch_unit.sv" \
    "$ROOT/core/compressed_decoder.sv" \
    "$ROOT/core/controller.sv" \
    "$ROOT/core/csr_buffer.sv" \
    "$ROOT/core/csr_regfile.sv" \
    "$ROOT/core/decoder.sv" \
    "$ROOT/core/ex_stage.sv" \
    "$ROOT/core/instr_realign.sv" \
    "$ROOT/core/id_stage.sv" \
    "$ROOT/core/issue_read_operands.sv" \
    "$ROOT/core/issue_stage.sv" \
    "$ROOT/core/load_unit.sv" \
    "$ROOT/core/load_store_unit.sv" \
    "$ROOT/core/lsu_bypass.sv" \
    "$ROOT/core/mult.sv" \
    "$ROOT/core/multiplier.sv" \
    "$ROOT/core/serdiv.sv" \
    "$ROOT/core/perf_counters.sv" \
    "$ROOT/core/ariane_regfile_ff.sv" \
    "$ROOT/core/ariane_regfile_fpga.sv" \
    "$ROOT/core/re_name.sv" \
    "$ROOT/core/scoreboard.sv" \
    "$ROOT/core/store_buffer.sv" \
    "$ROOT/core/amo_buffer.sv" \
    "$ROOT/core/store_unit.sv" \
    "$ROOT/core/commit_stage.sv" \
    "$ROOT/core/axi_shim.sv" \
    "$ROOT/core/frontend/btb.sv" \
    "$ROOT/core/frontend/bht.sv" \
    "$ROOT/core/frontend/ras.sv" \
    "$ROOT/core/frontend/instr_scan.sv" \
    "$ROOT/core/frontend/instr_queue.sv" \
    "$ROOT/core/frontend/frontend.sv" \
    "$ROOT/core/cache_subsystem/wt_dcache_ctrl.sv" \
    "$ROOT/core/cache_subsystem/wt_dcache_mem.sv" \
    "$ROOT/core/cache_subsystem/wt_dcache_missunit.sv" \
    "$ROOT/core/cache_subsystem/wt_dcache_wbuffer.sv" \
    "$ROOT/core/cache_subsystem/wt_dcache.sv" \
    "$ROOT/core/cache_subsystem/cva6_icache.sv" \
    "$ROOT/core/cache_subsystem/wt_cache_subsystem.sv" \
    "$ROOT/core/cache_subsystem/wt_axi_adapter.sv" \
    "$ROOT/core/cache_subsystem/tag_cmp.sv" \
    "$ROOT/core/cache_subsystem/cache_ctrl.sv" \
    "$ROOT/core/cache_subsystem/amo_alu.sv" \
    "$ROOT/core/cache_subsystem/wt_l15_adapter.sv" \
    "$ROOT/core/cache_subsystem/axi_adapter.sv" \
    "$ROOT/core/cache_subsystem/miss_handler.sv" \
    "$ROOT/core/cache_subsystem/std_nbdcache.sv" \
    "$ROOT/core/cache_subsystem/cva6_icache_axi_wrapper.sv" \
    "$ROOT/core/cache_subsystem/std_cache_subsystem.sv" \
    "$ROOT/core/pmp/src/pmp.sv" \
    "$ROOT/core/pmp/src/pmp_entry.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/include" \
    "+incdir+$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/include" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "+incdir+$ROOT/common/local/util" \
    "$ROOT/common/local/util/sram_pulp.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/include" \
    "+incdir+$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/include" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "+incdir+$ROOT/common/local/util" \
    "$ROOT/common/local/util/tc_sram_wrapper.sv" \
}]} {return 1}

if {[catch { vlog -incr -sv \
    "+define+TARGET_SIMULATION" \
    "+define+TARGET_VSIM" \
    "+incdir+$ROOT/.bender/git/checkouts/ace-83727eaab94e0d3f/include" \
    "+incdir+$ROOT/.bender/git/checkouts/axi-f14341c32cf56c49/include" \
    "+incdir+$ROOT/.bender/git/checkouts/common_cells-7e395bb92335c3c4/include" \
    "+incdir+$ROOT/common/local/util" \
    "+incdir+$ROOT/core/include" \
    "$ROOT/core/include/instr_tracer_pkg.sv" \
    "$ROOT/common/local/util/instr_tracer.sv" \
    "$ROOT/common/local/util/instr_tracer_if.sv" \
}]} {return 1}

