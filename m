Return-Path: <io-uring+bounces-1911-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA9F88C7B34
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 19:35:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A3E2C1C21183
	for <lists+io-uring@lfdr.de>; Thu, 16 May 2024 17:35:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E759E156864;
	Thu, 16 May 2024 17:34:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553C4156642;
	Thu, 16 May 2024 17:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715880898; cv=none; b=mSuT48zo+6ruL5wYwLtLdJQTLJMmG99XCZ607MXeVzQdKQ6kI3Axq1kp3yMXY+wmmdD+30Igyn5EMf+ezfWrSufN65/2DJVAbEpfkP/xytoCJBw5Odcsh6R6LN31fZQhDhllV6OExdxP44YtOn+KqF0QAGYlYP/r2Zj1m3zMkik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715880898; c=relaxed/simple;
	bh=LpDxJ9DpA9lPwIyZvjFJgcu6QUNRWYonItM+il1qBKw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=prijsLR8HOAWT08dTWQaW/Bw6vr13g/i8+qMZ/4ke7a3VqBURxAkv+OOO5fHU3FqT0z1t3IITf7Ct2NasnZGmlbyR9u/ew1E4bfuHilDhT/v8NrKePx+2Ol7h2Fsfm8sxldQ71k6MJNqHvs+v3kSKFlZTPn62vrqoAGuH7nin8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3195EC32786;
	Thu, 16 May 2024 17:34:56 +0000 (UTC)
Date: Thu, 16 May 2024 13:34:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, Linux trace kernel
 <linux-trace-kernel@vger.kernel.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers 
 <mathieu.desnoyers@efficios.com>, Linus Torvalds 
 <torvalds@linux-foundation.org>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, linux-block@vger.kernel.org,
 linux-cxl@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, amd-gfx@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 virtualization@lists.linux.dev, linux-rdma@vger.kernel.org,
 linux-pm@vger.kernel.org, iommu@lists.linux.dev,
 linux-tegra@vger.kernel.org, netdev@vger.kernel.org,
 linux-hyperv@vger.kernel.org, ath10k@lists.infradead.org,
 linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
 ath12k@lists.infradead.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-usb@vger.kernel.org,
 linux-bcachefs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ocfs2-devel@lists.linux.dev, linux-cifs@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-edac@vger.kernel.org,
 selinux@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-erofs@lists.ozlabs.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-hwmon@vger.kernel.org, io-uring@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org,
 linux-wpan@vger.kernel.org, dev@openvswitch.org,
 linux-s390@vger.kernel.org, tipc-discussion@lists.sourceforge.net, Julia 
 Lawall <Julia.Lawall@inria.fr>
Subject: [PATCH] tracing/treewide: Remove second parameter of __assign_str()
Message-ID: <20240516133454.681ba6a0@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

[
   This is a treewide change. I will likely re-create this patch again in
   the second week of the merge window of v6.10 and submit it then. Hoping
   to keep the conflicts that it will cause to a minimum.
]

With the rework of how the __string() handles dynamic strings where it
saves off the source string in field in the helper structure[1], the
assignment of that value to the trace event field is stored in the helper
value and does not need to be passed in again.

This means that with:

  __string(field, mystring)

Which use to be assigned with __assign_str(field, mystring), no longer
needs the second parameter and it is unused. With this, __assign_str()
will now only get a single parameter.

There's over 700 users of __assign_str() and because coccinelle does not
handle the TRACE_EVENT() macro I ended up using the following sed script:

  git grep -l __assign_str | while read a ; do
      sed -e 's/\(__assign_str([^,]*[^ ,]\) *,[^;]*/\1)/' $a > /tmp/test-file;
      mv /tmp/test-file $a;
  done

I then searched for __assign_str() that did not end with ';' as those
were multi line assignments that the sed script above would fail to catch.

Note, the same updates will need to be done for:

  __assign_str_len()
  __assign_rel_str()
  __assign_rel_str_len()

I tested this with both an allmodconfig and an allyesconfig (build only for both).

[1] https://lore.kernel.org/linux-trace-kernel/20240222211442.634192653@goodmis.org/

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Julia Lawall <Julia.Lawall@inria.fr>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 arch/arm64/kernel/trace-events-emulation.h    |   2 +-
 arch/powerpc/include/asm/trace.h              |   4 +-
 arch/x86/kvm/trace.h                          |   2 +-
 drivers/base/regmap/trace.h                   |  18 +--
 drivers/base/trace.h                          |   2 +-
 drivers/block/rnbd/rnbd-srv-trace.h           |  12 +-
 drivers/bus/mhi/host/trace.h                  |  12 +-
 drivers/cxl/core/trace.h                      |  24 ++--
 drivers/dma-buf/sync_trace.h                  |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h     |  16 +--
 .../amd/display/amdgpu_dm/amdgpu_dm_trace.h   |   2 +-
 .../drm/i915/display/intel_display_trace.h    |  56 ++++-----
 drivers/gpu/drm/lima/lima_trace.h             |   2 +-
 drivers/gpu/drm/msm/disp/dpu1/dpu_trace.h     |  12 +-
 .../gpu/drm/scheduler/gpu_scheduler_trace.h   |   4 +-
 drivers/gpu/drm/virtio/virtgpu_trace.h        |   2 +-
 drivers/infiniband/core/cma_trace.h           |   4 +-
 drivers/infiniband/hw/hfi1/hfi.h              |   2 +-
 drivers/infiniband/hw/hfi1/trace_dbg.h        |   2 +-
 drivers/infiniband/hw/hfi1/trace_rx.h         |   2 +-
 drivers/infiniband/hw/hfi1/trace_tid.h        |   4 +-
 drivers/infiniband/hw/hfi1/trace_tx.h         |   4 +-
 drivers/infiniband/sw/rdmavt/trace.h          |   2 +-
 drivers/infiniband/sw/rdmavt/trace_rvt.h      |   2 +-
 drivers/interconnect/trace.h                  |  10 +-
 drivers/iommu/intel/trace.h                   |   6 +-
 .../media/platform/nvidia/tegra-vde/trace.h   |   2 +-
 drivers/misc/mei/mei-trace.h                  |   6 +-
 drivers/net/dsa/mv88e6xxx/trace.h             |   4 +-
 .../ethernet/freescale/dpaa/dpaa_eth_trace.h  |   2 +-
 .../freescale/dpaa2/dpaa2-eth-trace.h         |   4 +-
 .../ethernet/fungible/funeth/funeth_trace.h   |   6 +-
 .../net/ethernet/hisilicon/hns3/hns3_trace.h  |   4 +-
 .../hisilicon/hns3/hns3pf/hclge_trace.h       |  12 +-
 .../hisilicon/hns3/hns3vf/hclgevf_trace.h     |  10 +-
 drivers/net/ethernet/intel/i40e/i40e_trace.h  |  10 +-
 drivers/net/ethernet/intel/iavf/iavf_trace.h  |   6 +-
 drivers/net/ethernet/intel/ice/ice_trace.h    |  12 +-
 .../ethernet/marvell/octeontx2/af/rvu_trace.h |  12 +-
 .../mellanox/mlx5/core/diag/cmd_tracepoint.h  |   4 +-
 .../mlx5/core/diag/en_rep_tracepoint.h        |   2 +-
 .../mlx5/core/diag/en_tc_tracepoint.h         |   2 +-
 .../mlx5/core/diag/fw_tracer_tracepoint.h     |   5 +-
 .../mlx5/core/esw/diag/qos_tracepoint.h       |   8 +-
 .../mlx5/core/sf/dev/diag/dev_tracepoint.h    |   2 +-
 .../mlx5/core/sf/diag/sf_tracepoint.h         |  14 +--
 .../mlx5/core/sf/diag/vhca_tracepoint.h       |   2 +-
 drivers/net/fjes/fjes_trace.h                 |  10 +-
 drivers/net/hyperv/netvsc_trace.h             |   8 +-
 drivers/net/wireless/ath/ath10k/trace.h       |  64 +++++-----
 drivers/net/wireless/ath/ath11k/trace.h       |  44 +++----
 drivers/net/wireless/ath/ath12k/trace.h       |  16 +--
 drivers/net/wireless/ath/ath6kl/trace.h       |   4 +-
 drivers/net/wireless/ath/trace.h              |   4 +-
 .../broadcom/brcm80211/brcmfmac/tracepoint.h  |   4 +-
 .../brcm80211/brcmsmac/brcms_trace_brcmsmac.h |   2 +-
 .../brcmsmac/brcms_trace_brcmsmac_msg.h       |   2 +-
 .../brcmsmac/brcms_trace_brcmsmac_tx.h        |   6 +-
 .../wireless/intel/iwlwifi/iwl-devtrace-msg.h |   2 +-
 .../net/wireless/intel/iwlwifi/iwl-devtrace.h |   2 +-
 drivers/soc/qcom/pmic_pdcharger_ulog.h        |   2 +-
 drivers/soc/qcom/trace-aoss.h                 |   4 +-
 drivers/soc/qcom/trace-rpmh.h                 |   4 +-
 drivers/thermal/thermal_trace.h               |  10 +-
 drivers/usb/cdns3/cdns3-trace.h               |  26 ++--
 drivers/usb/cdns3/cdnsp-trace.h               |  10 +-
 drivers/usb/chipidea/trace.h                  |   4 +-
 drivers/usb/dwc3/trace.h                      |   8 +-
 drivers/usb/gadget/udc/cdns2/cdns2-trace.h    |  22 ++--
 drivers/usb/gadget/udc/trace.h                |   4 +-
 drivers/usb/mtu3/mtu3_trace.h                 |   8 +-
 drivers/usb/musb/musb_trace.h                 |  12 +-
 fs/bcachefs/trace.h                           |   6 +-
 fs/nfs/nfs4trace.h                            |  42 +++----
 fs/nfs/nfstrace.h                             |  41 +++---
 fs/nfsd/trace.h                               |  40 +++---
 fs/ocfs2/ocfs2_trace.h                        |  60 ++++-----
 fs/smb/client/trace.h                         |  18 +--
 fs/xfs/scrub/trace.h                          |  10 +-
 fs/xfs/xfs_trace.h                            |  26 ++--
 include/ras/ras_event.h                       |  12 +-
 include/trace/events/asoc.h                   |  22 ++--
 include/trace/events/avc.h                    |   6 +-
 include/trace/events/bridge.h                 |  16 +--
 include/trace/events/btrfs.h                  |   6 +-
 include/trace/events/cgroup.h                 |  10 +-
 include/trace/events/clk.h                    |  18 +--
 include/trace/events/cma.h                    |   8 +-
 include/trace/events/devfreq.h                |   4 +-
 include/trace/events/devlink.h                |  50 ++++----
 include/trace/events/dma_fence.h              |   4 +-
 include/trace/events/erofs.h                  |   2 +-
 include/trace/events/f2fs.h                   |  20 +--
 include/trace/events/habanalabs.h             |  10 +-
 include/trace/events/huge_memory.h            |   4 +-
 include/trace/events/hwmon.h                  |   6 +-
 include/trace/events/initcall.h               |   2 +-
 include/trace/events/intel_ish.h              |   2 +-
 include/trace/events/io_uring.h               |  14 +--
 include/trace/events/iocost.h                 |  14 +--
 include/trace/events/iommu.h                  |   8 +-
 include/trace/events/irq.h                    |   2 +-
 include/trace/events/iscsi.h                  |   2 +-
 include/trace/events/kmem.h                   |   2 +-
 include/trace/events/lock.h                   |   4 +-
 include/trace/events/mmap_lock.h              |   4 +-
 include/trace/events/mmc.h                    |   4 +-
 include/trace/events/module.h                 |   8 +-
 include/trace/events/napi.h                   |   2 +-
 include/trace/events/neigh.h                  |   6 +-
 include/trace/events/net.h                    |  12 +-
 include/trace/events/netlink.h                |   2 +-
 include/trace/events/oom.h                    |   2 +-
 include/trace/events/osnoise.h                |   2 +-
 include/trace/events/power.h                  |  23 ++--
 include/trace/events/pwc.h                    |   4 +-
 include/trace/events/qdisc.h                  |  12 +-
 include/trace/events/qla.h                    |   2 +-
 include/trace/events/qrtr.h                   |   2 +-
 include/trace/events/regulator.h              |   6 +-
 include/trace/events/rpcgss.h                 |  20 +--
 include/trace/events/rpcrdma.h                |  52 ++++----
 include/trace/events/rpm.h                    |   6 +-
 include/trace/events/sched.h                  |   8 +-
 include/trace/events/sof.h                    |  12 +-
 include/trace/events/sof_intel.h              |  16 +--
 include/trace/events/sunrpc.h                 | 118 +++++++++---------
 include/trace/events/swiotlb.h                |   2 +-
 include/trace/events/target.h                 |   4 +-
 include/trace/events/tegra_apb_dma.h          |   6 +-
 include/trace/events/ufs.h                    |  24 ++--
 include/trace/events/workqueue.h              |   2 +-
 include/trace/events/xdp.h                    |   2 +-
 include/trace/stages/stage6_event_callback.h  |   4 +-
 kernel/trace/bpf_trace.h                      |   2 +-
 net/batman-adv/trace.h                        |   4 +-
 net/dsa/trace.h                               |  34 ++---
 net/ieee802154/trace.h                        |   2 +-
 net/mac80211/trace.h                          |   2 +-
 net/openvswitch/openvswitch_trace.h           |   8 +-
 net/smc/smc_tracepoint.h                      |   4 +-
 net/tipc/trace.h                              |  16 +--
 net/wireless/trace.h                          |   2 +-
 samples/trace_events/trace-events-sample.h    |  19 +--
 sound/core/pcm_trace.h                        |   2 +-
 sound/hda/trace.h                             |   6 +-
 sound/soc/intel/avs/trace.h                   |   4 +-
 147 files changed, 785 insertions(+), 799 deletions(-)

diff --git a/arch/arm64/kernel/trace-events-emulation.h b/arch/arm64/kernel/trace-events-emulation.h
index 6c40f58b844a..c51b547b583e 100644
--- a/arch/arm64/kernel/trace-events-emulation.h
+++ b/arch/arm64/kernel/trace-events-emulation.h
@@ -18,7 +18,7 @@ TRACE_EVENT(instruction_emulation,
 	),
 
 	TP_fast_assign(
-		__assign_str(instr, instr);
+		__assign_str(instr);
 		__entry->addr = addr;
 	),
 
diff --git a/arch/powerpc/include/asm/trace.h b/arch/powerpc/include/asm/trace.h
index d9ac3a4f46e1..a7b69b25296b 100644
--- a/arch/powerpc/include/asm/trace.h
+++ b/arch/powerpc/include/asm/trace.h
@@ -137,7 +137,7 @@ TRACE_EVENT(rtas_input,
 
 	TP_fast_assign(
 		__entry->nargs = be32_to_cpu(rtas_args->nargs);
-		__assign_str(name, name);
+		__assign_str(name);
 		be32_to_cpu_array(__get_dynamic_array(inputs), rtas_args->args, __entry->nargs);
 	),
 
@@ -162,7 +162,7 @@ TRACE_EVENT(rtas_output,
 	TP_fast_assign(
 		__entry->nr_other = be32_to_cpu(rtas_args->nret) - 1;
 		__entry->status = be32_to_cpu(rtas_args->rets[0]);
-		__assign_str(name, name);
+		__assign_str(name);
 		be32_to_cpu_array(__get_dynamic_array(other_outputs),
 				  &rtas_args->rets[1], __entry->nr_other);
 	),
diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
index c6b4b1728006..b6d52751dba8 100644
--- a/arch/x86/kvm/trace.h
+++ b/arch/x86/kvm/trace.h
@@ -1678,7 +1678,7 @@ TRACE_EVENT(kvm_nested_vmenter_failed,
 	),
 
 	TP_fast_assign(
-		__assign_str(msg, msg);
+		__assign_str(msg);
 		__entry->err = err;
 	),
 
diff --git a/drivers/base/regmap/trace.h b/drivers/base/regmap/trace.h
index 704e106e5dbd..bcc5a8b226a6 100644
--- a/drivers/base/regmap/trace.h
+++ b/drivers/base/regmap/trace.h
@@ -27,7 +27,7 @@ DECLARE_EVENT_CLASS(regmap_reg,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, regmap_name(map));
+		__assign_str(name);
 		__entry->reg = reg;
 		__entry->val = val;
 	),
@@ -74,7 +74,7 @@ DECLARE_EVENT_CLASS(regmap_bulk,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, regmap_name(map));
+		__assign_str(name);
 		__entry->reg = reg;
 		__entry->val_len = val_len;
 		memcpy(__get_dynamic_array(buf), val, val_len);
@@ -113,7 +113,7 @@ DECLARE_EVENT_CLASS(regmap_block,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, regmap_name(map));
+		__assign_str(name);
 		__entry->reg = reg;
 		__entry->count = count;
 	),
@@ -163,9 +163,9 @@ TRACE_EVENT(regcache_sync,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, regmap_name(map));
-		__assign_str(status, status);
-		__assign_str(type, type);
+		__assign_str(name);
+		__assign_str(status);
+		__assign_str(type);
 	),
 
 	TP_printk("%s type=%s status=%s", __get_str(name),
@@ -184,7 +184,7 @@ DECLARE_EVENT_CLASS(regmap_bool,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, regmap_name(map));
+		__assign_str(name);
 		__entry->flag = flag;
 	),
 
@@ -216,7 +216,7 @@ DECLARE_EVENT_CLASS(regmap_async,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, regmap_name(map));
+		__assign_str(name);
 	),
 
 	TP_printk("%s", __get_str(name))
@@ -264,7 +264,7 @@ TRACE_EVENT(regcache_drop_region,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, regmap_name(map));
+		__assign_str(name);
 		__entry->from = from;
 		__entry->to = to;
 	),
diff --git a/drivers/base/trace.h b/drivers/base/trace.h
index 3192e18f877e..e52b6eae060d 100644
--- a/drivers/base/trace.h
+++ b/drivers/base/trace.h
@@ -28,7 +28,7 @@ DECLARE_EVENT_CLASS(devres,
 		__field(size_t, size)
 	),
 	TP_fast_assign(
-		__assign_str(devname, dev_name(dev));
+		__assign_str(devname);
 		__entry->op = op;
 		__entry->node = node;
 		__entry->name = name;
diff --git a/drivers/block/rnbd/rnbd-srv-trace.h b/drivers/block/rnbd/rnbd-srv-trace.h
index 8dedf73bdd28..89d0bcb17195 100644
--- a/drivers/block/rnbd/rnbd-srv-trace.h
+++ b/drivers/block/rnbd/rnbd-srv-trace.h
@@ -27,7 +27,7 @@ DECLARE_EVENT_CLASS(rnbd_srv_link_class,
 
 	TP_fast_assign(
 		__entry->qdepth = srv->queue_depth;
-		__assign_str(sessname, srv->sessname);
+		__assign_str(sessname);
 	),
 
 	TP_printk("sessname: %s qdepth: %d",
@@ -85,7 +85,7 @@ TRACE_EVENT(process_rdma,
 	),
 
 	TP_fast_assign(
-		__assign_str(sessname, srv->sessname);
+		__assign_str(sessname);
 		__entry->dir = id->dir;
 		__entry->ver = srv->ver;
 		__entry->device_id = le32_to_cpu(msg->device_id);
@@ -130,7 +130,7 @@ TRACE_EVENT(process_msg_sess_info,
 		__entry->proto_ver = srv->ver;
 		__entry->clt_ver = msg->ver;
 		__entry->srv_ver = RNBD_PROTO_VER_MAJOR;
-		__assign_str(sessname, srv->sessname);
+		__assign_str(sessname);
 	),
 
 	TP_printk("Session %s using proto-ver %d (clt-ver: %d, srv-ver: %d)",
@@ -165,8 +165,8 @@ TRACE_EVENT(process_msg_open,
 
 	TP_fast_assign(
 		__entry->access_mode = msg->access_mode;
-		__assign_str(sessname, srv->sessname);
-		__assign_str(dev_name, msg->dev_name);
+		__assign_str(sessname);
+		__assign_str(dev_name);
 	),
 
 	TP_printk("Open message received: session='%s' path='%s' access_mode=%s",
@@ -189,7 +189,7 @@ TRACE_EVENT(process_msg_close,
 
 	TP_fast_assign(
 		__entry->device_id = le32_to_cpu(msg->device_id);
-		__assign_str(sessname, srv->sessname);
+		__assign_str(sessname);
 	),
 
 	TP_printk("Close message received: session='%s' device id='%d'",
diff --git a/drivers/bus/mhi/host/trace.h b/drivers/bus/mhi/host/trace.h
index 368515dcb22d..95613c8ebe06 100644
--- a/drivers/bus/mhi/host/trace.h
+++ b/drivers/bus/mhi/host/trace.h
@@ -103,7 +103,7 @@ TRACE_EVENT(mhi_gen_tre,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, mhi_cntrl->mhi_dev->name);
+		__assign_str(name);
 		__entry->ch_num = mhi_chan->chan;
 		__entry->wp = mhi_tre;
 		__entry->tre_ptr = mhi_tre->ptr;
@@ -131,7 +131,7 @@ TRACE_EVENT(mhi_intvec_states,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, mhi_cntrl->mhi_dev->name);
+		__assign_str(name);
 		__entry->local_ee = mhi_cntrl->ee;
 		__entry->state = mhi_cntrl->dev_state;
 		__entry->dev_ee = dev_ee;
@@ -158,7 +158,7 @@ TRACE_EVENT(mhi_tryset_pm_state,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, mhi_cntrl->mhi_dev->name);
+		__assign_str(name);
 		if (pm_state)
 			pm_state = __fls(pm_state);
 		__entry->pm_state = pm_state;
@@ -184,7 +184,7 @@ DECLARE_EVENT_CLASS(mhi_process_event_ring,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, mhi_cntrl->mhi_dev->name);
+		__assign_str(name);
 		__entry->rp = rp;
 		__entry->ptr = rp->ptr;
 		__entry->dword0 = rp->dword[0];
@@ -226,7 +226,7 @@ DECLARE_EVENT_CLASS(mhi_update_channel_state,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, mhi_cntrl->mhi_dev->name);
+		__assign_str(name);
 		__entry->ch_num = mhi_chan->chan;
 		__entry->state = state;
 		__entry->reason = reason;
@@ -265,7 +265,7 @@ TRACE_EVENT(mhi_pm_st_transition,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, mhi_cntrl->mhi_dev->name);
+		__assign_str(name);
 		__entry->state = state;
 	),
 
diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index e5f13260fc52..fdd05e938c59 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -60,8 +60,8 @@ TRACE_EVENT(cxl_aer_uncorrectable_error,
 		__array(u32, header_log, CXL_HEADERLOG_SIZE_U32)
 	),
 	TP_fast_assign(
-		__assign_str(memdev, dev_name(&cxlmd->dev));
-		__assign_str(host, dev_name(cxlmd->dev.parent));
+		__assign_str(memdev);
+		__assign_str(host);
 		__entry->serial = cxlmd->cxlds->serial;
 		__entry->status = status;
 		__entry->first_error = fe;
@@ -106,8 +106,8 @@ TRACE_EVENT(cxl_aer_correctable_error,
 		__field(u32, status)
 	),
 	TP_fast_assign(
-		__assign_str(memdev, dev_name(&cxlmd->dev));
-		__assign_str(host, dev_name(cxlmd->dev.parent));
+		__assign_str(memdev);
+		__assign_str(host);
 		__entry->serial = cxlmd->cxlds->serial;
 		__entry->status = status;
 	),
@@ -142,8 +142,8 @@ TRACE_EVENT(cxl_overflow,
 	),
 
 	TP_fast_assign(
-		__assign_str(memdev, dev_name(&cxlmd->dev));
-		__assign_str(host, dev_name(cxlmd->dev.parent));
+		__assign_str(memdev);
+		__assign_str(host);
 		__entry->serial = cxlmd->cxlds->serial;
 		__entry->log = log;
 		__entry->count = le16_to_cpu(payload->overflow_err_count);
@@ -200,8 +200,8 @@ TRACE_EVENT(cxl_overflow,
 	__field(u8, hdr_maint_op_class)
 
 #define CXL_EVT_TP_fast_assign(cxlmd, l, hdr)					\
-	__assign_str(memdev, dev_name(&(cxlmd)->dev));				\
-	__assign_str(host, dev_name((cxlmd)->dev.parent));			\
+	__assign_str(memdev);				\
+	__assign_str(host);			\
 	__entry->log = (l);							\
 	__entry->serial = (cxlmd)->cxlds->serial;				\
 	__entry->hdr_length = (hdr).length;					\
@@ -668,8 +668,8 @@ TRACE_EVENT(cxl_poison,
 	    ),
 
 	TP_fast_assign(
-		__assign_str(memdev, dev_name(&cxlmd->dev));
-		__assign_str(host, dev_name(cxlmd->dev.parent));
+		__assign_str(memdev);
+		__assign_str(host);
 		__entry->serial = cxlmd->cxlds->serial;
 		__entry->overflow_ts = cxl_poison_overflow(flags, overflow_ts);
 		__entry->dpa = cxl_poison_record_dpa(record);
@@ -678,12 +678,12 @@ TRACE_EVENT(cxl_poison,
 		__entry->trace_type = trace_type;
 		__entry->flags = flags;
 		if (cxlr) {
-			__assign_str(region, dev_name(&cxlr->dev));
+			__assign_str(region);
 			memcpy(__entry->uuid, &cxlr->params.uuid, 16);
 			__entry->hpa = cxl_trace_hpa(cxlr, cxlmd,
 						     __entry->dpa);
 		} else {
-			__assign_str(region, "");
+			__assign_str(region);
 			memset(__entry->uuid, 0, 16);
 			__entry->hpa = ULLONG_MAX;
 		}
diff --git a/drivers/dma-buf/sync_trace.h b/drivers/dma-buf/sync_trace.h
index 06e468a218ff..d71dcf954b8d 100644
--- a/drivers/dma-buf/sync_trace.h
+++ b/drivers/dma-buf/sync_trace.h
@@ -20,7 +20,7 @@ TRACE_EVENT(sync_timeline,
 	),
 
 	TP_fast_assign(
-			__assign_str(name, timeline->name);
+			__assign_str(name);
 			__entry->value = timeline->value;
 	),
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
index f539b1d00234..7aafeb763e5d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_trace.h
@@ -178,10 +178,10 @@ TRACE_EVENT(amdgpu_cs_ioctl,
 
 	    TP_fast_assign(
 			   __entry->sched_job_id = job->base.id;
-			   __assign_str(timeline, AMDGPU_JOB_GET_TIMELINE_NAME(job));
+			   __assign_str(timeline);
 			   __entry->context = job->base.s_fence->finished.context;
 			   __entry->seqno = job->base.s_fence->finished.seqno;
-			   __assign_str(ring, to_amdgpu_ring(job->base.sched)->name);
+			   __assign_str(ring);
 			   __entry->num_ibs = job->num_ibs;
 			   ),
 	    TP_printk("sched_job=%llu, timeline=%s, context=%u, seqno=%u, ring_name=%s, num_ibs=%u",
@@ -203,10 +203,10 @@ TRACE_EVENT(amdgpu_sched_run_job,
 
 	    TP_fast_assign(
 			   __entry->sched_job_id = job->base.id;
-			   __assign_str(timeline, AMDGPU_JOB_GET_TIMELINE_NAME(job));
+			   __assign_str(timeline);
 			   __entry->context = job->base.s_fence->finished.context;
 			   __entry->seqno = job->base.s_fence->finished.seqno;
-			   __assign_str(ring, to_amdgpu_ring(job->base.sched)->name);
+			   __assign_str(ring);
 			   __entry->num_ibs = job->num_ibs;
 			   ),
 	    TP_printk("sched_job=%llu, timeline=%s, context=%u, seqno=%u, ring_name=%s, num_ibs=%u",
@@ -231,7 +231,7 @@ TRACE_EVENT(amdgpu_vm_grab_id,
 
 	    TP_fast_assign(
 			   __entry->pasid = vm->pasid;
-			   __assign_str(ring, ring->name);
+			   __assign_str(ring);
 			   __entry->vmid = job->vmid;
 			   __entry->vm_hub = ring->vm_hub,
 			   __entry->pd_addr = job->vm_pd_addr;
@@ -425,7 +425,7 @@ TRACE_EVENT(amdgpu_vm_flush,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(ring, ring->name);
+			   __assign_str(ring);
 			   __entry->vmid = vmid;
 			   __entry->vm_hub = ring->vm_hub;
 			   __entry->pd_addr = pd_addr;
@@ -526,7 +526,7 @@ TRACE_EVENT(amdgpu_ib_pipe_sync,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(ring, sched_job->base.sched->name);
+			   __assign_str(ring);
 			   __entry->id = sched_job->base.id;
 			   __entry->fence = fence;
 			   __entry->ctx = fence->context;
@@ -563,7 +563,7 @@ TRACE_EVENT(amdgpu_runpm_reference_dumps,
 			     ),
 	    TP_fast_assign(
 			   __entry->index = index;
-			   __assign_str(func, func);
+			   __assign_str(func);
 			   ),
 	    TP_printk("amdgpu runpm reference dump 0x%x: 0x%s\n",
 		      __entry->index,
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
index 133af994a08c..4686d4b0cbad 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_trace.h
@@ -87,7 +87,7 @@ TRACE_EVENT(amdgpu_dc_performance,
 			__entry->writes = write_count;
 			__entry->read_delta = read_count - *last_read;
 			__entry->write_delta = write_count - *last_write;
-			__assign_str(func, func);
+			__assign_str(func);
 			__entry->line = line;
 			*last_read = read_count;
 			*last_write = write_count;
diff --git a/drivers/gpu/drm/i915/display/intel_display_trace.h b/drivers/gpu/drm/i915/display/intel_display_trace.h
index 7862e7cefe02..49a5e6d9dc0d 100644
--- a/drivers/gpu/drm/i915/display/intel_display_trace.h
+++ b/drivers/gpu/drm/i915/display/intel_display_trace.h
@@ -34,7 +34,7 @@ TRACE_EVENT(intel_pipe_enable,
 	    TP_fast_assign(
 			   struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 			   struct intel_crtc *it__;
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   for_each_intel_crtc(&dev_priv->drm, it__) {
 				   __entry->frame[it__->pipe] = intel_crtc_get_vblank_counter(it__);
 				   __entry->scanline[it__->pipe] = intel_get_crtc_scanline(it__);
@@ -63,7 +63,7 @@ TRACE_EVENT(intel_pipe_disable,
 	    TP_fast_assign(
 			   struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
 			   struct intel_crtc *it__;
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   for_each_intel_crtc(&dev_priv->drm, it__) {
 				   __entry->frame[it__->pipe] = intel_crtc_get_vblank_counter(it__);
 				   __entry->scanline[it__->pipe] = intel_get_crtc_scanline(it__);
@@ -91,7 +91,7 @@ TRACE_EVENT(intel_pipe_crc,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -119,7 +119,7 @@ TRACE_EVENT(intel_cpu_fifo_underrun,
 
 	    TP_fast_assign(
 			    struct intel_crtc *crtc = intel_crtc_for_pipe(dev_priv, pipe);
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   __entry->pipe = pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -144,7 +144,7 @@ TRACE_EVENT(intel_pch_fifo_underrun,
 	    TP_fast_assign(
 			   enum pipe pipe = pch_transcoder;
 			   struct intel_crtc *crtc = intel_crtc_for_pipe(dev_priv, pipe);
-			   __assign_str(dev, __dev_name_i915(dev_priv));
+			   __assign_str(dev);
 			   __entry->pipe = pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -169,7 +169,7 @@ TRACE_EVENT(intel_memory_cxsr,
 
 	    TP_fast_assign(
 			   struct intel_crtc *crtc;
-			   __assign_str(dev, __dev_name_i915(dev_priv));
+			   __assign_str(dev);
 			   for_each_intel_crtc(&dev_priv->drm, crtc) {
 				   __entry->frame[crtc->pipe] = intel_crtc_get_vblank_counter(crtc);
 				   __entry->scanline[crtc->pipe] = intel_get_crtc_scanline(crtc);
@@ -209,7 +209,7 @@ TRACE_EVENT(g4x_wm,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -256,7 +256,7 @@ TRACE_EVENT(vlv_wm,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -293,7 +293,7 @@ TRACE_EVENT(vlv_fifo_size,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -323,8 +323,8 @@ TRACE_EVENT(intel_plane_update_noarm,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(plane));
-			   __assign_str(name, plane->base.name);
+			   __assign_str(dev);
+			   __assign_str(name);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -354,8 +354,8 @@ TRACE_EVENT(intel_plane_update_arm,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(plane));
-			   __assign_str(name, plane->base.name);
+			   __assign_str(dev);
+			   __assign_str(name);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -383,8 +383,8 @@ TRACE_EVENT(intel_plane_disable_arm,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(plane));
-			   __assign_str(name, plane->base.name);
+			   __assign_str(dev);
+			   __assign_str(name);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -410,8 +410,8 @@ TRACE_EVENT(intel_fbc_activate,
 	    TP_fast_assign(
 			   struct intel_crtc *crtc = intel_crtc_for_pipe(to_i915(plane->base.dev),
 									 plane->pipe);
-			   __assign_str(dev, __dev_name_kms(plane));
-			   __assign_str(name, plane->base.name);
+			   __assign_str(dev);
+			   __assign_str(name);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -437,8 +437,8 @@ TRACE_EVENT(intel_fbc_deactivate,
 	    TP_fast_assign(
 			   struct intel_crtc *crtc = intel_crtc_for_pipe(to_i915(plane->base.dev),
 									 plane->pipe);
-			   __assign_str(dev, __dev_name_kms(plane));
-			   __assign_str(name, plane->base.name);
+			   __assign_str(dev);
+			   __assign_str(name);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -464,8 +464,8 @@ TRACE_EVENT(intel_fbc_nuke,
 	    TP_fast_assign(
 			   struct intel_crtc *crtc = intel_crtc_for_pipe(to_i915(plane->base.dev),
 									 plane->pipe);
-			   __assign_str(dev, __dev_name_kms(plane));
-			   __assign_str(name, plane->base.name);
+			   __assign_str(dev);
+			   __assign_str(name);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -488,7 +488,7 @@ TRACE_EVENT(intel_crtc_vblank_work_start,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -511,7 +511,7 @@ TRACE_EVENT(intel_crtc_vblank_work_end,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -536,7 +536,7 @@ TRACE_EVENT(intel_pipe_update_start,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = intel_crtc_get_vblank_counter(crtc);
 			   __entry->scanline = intel_get_crtc_scanline(crtc);
@@ -564,7 +564,7 @@ TRACE_EVENT(intel_pipe_update_vblank_evaded,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = crtc->debug.start_vbl_count;
 			   __entry->scanline = crtc->debug.scanline_start;
@@ -590,7 +590,7 @@ TRACE_EVENT(intel_pipe_update_end,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_kms(crtc));
+			   __assign_str(dev);
 			   __entry->pipe = crtc->pipe;
 			   __entry->frame = frame;
 			   __entry->scanline = scanline_end;
@@ -613,7 +613,7 @@ TRACE_EVENT(intel_frontbuffer_invalidate,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_i915(i915));
+			   __assign_str(dev);
 			   __entry->frontbuffer_bits = frontbuffer_bits;
 			   __entry->origin = origin;
 			   ),
@@ -634,7 +634,7 @@ TRACE_EVENT(intel_frontbuffer_flush,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(dev, __dev_name_i915(i915));
+			   __assign_str(dev);
 			   __entry->frontbuffer_bits = frontbuffer_bits;
 			   __entry->origin = origin;
 			   ),
diff --git a/drivers/gpu/drm/lima/lima_trace.h b/drivers/gpu/drm/lima/lima_trace.h
index 494b9790b1da..3a349d10304e 100644
--- a/drivers/gpu/drm/lima/lima_trace.h
+++ b/drivers/gpu/drm/lima/lima_trace.h
@@ -24,7 +24,7 @@ DECLARE_EVENT_CLASS(lima_task,
 		__entry->task_id = task->base.id;
 		__entry->context = task->base.s_fence->finished.context;
 		__entry->seqno = task->base.s_fence->finished.seqno;
-		__assign_str(pipe, task->base.sched->name);
+		__assign_str(pipe);
 		),
 
 	TP_printk("task=%llu, context=%u seqno=%u pipe=%s",
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_trace.h b/drivers/gpu/drm/msm/disp/dpu1/dpu_trace.h
index bd92fb2979aa..0fdd41162e4b 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_trace.h
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_trace.h
@@ -113,7 +113,7 @@ TRACE_EVENT(tracing_mark_write,
 	),
 	TP_fast_assign(
 			__entry->pid = pid;
-			__assign_str(trace_name, name);
+			__assign_str(trace_name);
 			__entry->trace_begin = trace_begin;
 	),
 	TP_printk("%s|%d|%s", __entry->trace_begin ? "B" : "E",
@@ -130,7 +130,7 @@ TRACE_EVENT(dpu_trace_counter,
 	),
 	TP_fast_assign(
 			__entry->pid = current->tgid;
-			__assign_str(counter_name, name);
+			__assign_str(counter_name);
 			__entry->value = value;
 	),
 	TP_printk("%d|%s|%d", __entry->pid,
@@ -379,7 +379,7 @@ TRACE_EVENT(dpu_enc_rc,
 		__entry->sw_event = sw_event;
 		__entry->idle_pc_supported = idle_pc_supported;
 		__entry->rc_state = rc_state;
-		__assign_str(stage_str, stage);
+		__assign_str(stage_str);
 	),
 	TP_printk("%s: id:%u, sw_event:%d, idle_pc_supported:%s, rc_state:%d",
 		  __get_str(stage_str), __entry->drm_id, __entry->sw_event,
@@ -401,7 +401,7 @@ TRACE_EVENT(dpu_enc_frame_done_cb_not_busy,
 	TP_fast_assign(
 		__entry->drm_id = drm_id;
 		__entry->event = event;
-		__assign_str(intf_mode_str, intf_mode);
+		__assign_str(intf_mode_str);
 		__entry->intf_idx = intf_idx;
 		__entry->wb_idx = wb_idx;
 	),
@@ -446,7 +446,7 @@ TRACE_EVENT(dpu_enc_trigger_flush,
 	),
 	TP_fast_assign(
 		__entry->drm_id = drm_id;
-		__assign_str(intf_mode_str, intf_mode);
+		__assign_str(intf_mode_str);
 		__entry->intf_idx = intf_idx;
 		__entry->wb_idx = wb_idx;
 		__entry->pending_kickoff_cnt = pending_kickoff_cnt;
@@ -946,7 +946,7 @@ TRACE_EVENT(dpu_core_perf_update_clk,
 		__field(	u64,			clk_rate	)
 	),
 	TP_fast_assign(
-		__assign_str(dev_name, dev->unique);
+		__assign_str(dev_name);
 		__entry->stop_req = stop_req;
 		__entry->clk_rate = clk_rate;
 	),
diff --git a/drivers/gpu/drm/scheduler/gpu_scheduler_trace.h b/drivers/gpu/drm/scheduler/gpu_scheduler_trace.h
index f8ed093b7356..c75302ca3427 100644
--- a/drivers/gpu/drm/scheduler/gpu_scheduler_trace.h
+++ b/drivers/gpu/drm/scheduler/gpu_scheduler_trace.h
@@ -48,7 +48,7 @@ DECLARE_EVENT_CLASS(drm_sched_job,
 			   __entry->entity = entity;
 			   __entry->id = sched_job->id;
 			   __entry->fence = &sched_job->s_fence->finished;
-			   __assign_str(name, sched_job->sched->name);
+			   __assign_str(name);
 			   __entry->job_count = spsc_queue_count(&entity->job_queue);
 			   __entry->hw_job_count = atomic_read(
 				   &sched_job->sched->credit_count);
@@ -94,7 +94,7 @@ TRACE_EVENT(drm_sched_job_wait_dep,
 			     ),
 
 	    TP_fast_assign(
-			   __assign_str(name, sched_job->sched->name);
+			   __assign_str(name);
 			   __entry->id = sched_job->id;
 			   __entry->fence = fence;
 			   __entry->ctx = fence->context;
diff --git a/drivers/gpu/drm/virtio/virtgpu_trace.h b/drivers/gpu/drm/virtio/virtgpu_trace.h
index 031bc77689d5..227bf0ae7ed5 100644
--- a/drivers/gpu/drm/virtio/virtgpu_trace.h
+++ b/drivers/gpu/drm/virtio/virtgpu_trace.h
@@ -25,7 +25,7 @@ DECLARE_EVENT_CLASS(virtio_gpu_cmd,
 	TP_fast_assign(
 		       __entry->dev = vq->vdev->index;
 		       __entry->vq = vq->index;
-		       __assign_str(name, vq->name);
+		       __assign_str(name);
 		       __entry->type = le32_to_cpu(hdr->type);
 		       __entry->flags = le32_to_cpu(hdr->flags);
 		       __entry->fence_id = le64_to_cpu(hdr->fence_id);
diff --git a/drivers/infiniband/core/cma_trace.h b/drivers/infiniband/core/cma_trace.h
index 47f3c6e4be89..dc622f3778be 100644
--- a/drivers/infiniband/core/cma_trace.h
+++ b/drivers/infiniband/core/cma_trace.h
@@ -84,7 +84,7 @@ TRACE_EVENT(cm_id_attach,
 		       sizeof(struct sockaddr_in6));
 		memcpy(__entry->dstaddr, &id_priv->id.route.addr.dst_addr,
 		       sizeof(struct sockaddr_in6));
-		__assign_str(devname, device->name);
+		__assign_str(devname);
 	),
 
 	TP_printk("cm.id=%u src=%pISpc dst=%pISpc device=%s",
@@ -334,7 +334,7 @@ DECLARE_EVENT_CLASS(cma_client_class,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, device->name);
+		__assign_str(name);
 	),
 
 	TP_printk("device name=%s",
diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 4b3f1cb125fc..eb38f81aeeb1 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -2425,7 +2425,7 @@ static inline bool hfi1_need_drop(struct hfi1_devdata *dd)
 int hfi1_tempsense_rd(struct hfi1_devdata *dd, struct hfi1_temp *temp);
 
 #define DD_DEV_ENTRY(dd)       __string(dev, dev_name(&(dd)->pcidev->dev))
-#define DD_DEV_ASSIGN(dd)      __assign_str(dev, dev_name(&(dd)->pcidev->dev))
+#define DD_DEV_ASSIGN(dd)      __assign_str(dev)
 
 static inline void hfi1_update_ah_attr(struct ib_device *ibdev,
 				       struct rdma_ah_attr *attr)
diff --git a/drivers/infiniband/hw/hfi1/trace_dbg.h b/drivers/infiniband/hw/hfi1/trace_dbg.h
index 75599d5168db..58304b91380f 100644
--- a/drivers/infiniband/hw/hfi1/trace_dbg.h
+++ b/drivers/infiniband/hw/hfi1/trace_dbg.h
@@ -33,7 +33,7 @@ DECLARE_EVENT_CLASS(hfi1_trace_template,
 		    TP_STRUCT__entry(__string(function, function)
 				     __vstring(msg, vaf->fmt, vaf->va)
 				     ),
-		    TP_fast_assign(__assign_str(function, function);
+		    TP_fast_assign(__assign_str(function);
 				   __assign_vstr(msg, vaf->fmt, vaf->va);
 				   ),
 		    TP_printk("(%s) %s",
diff --git a/drivers/infiniband/hw/hfi1/trace_rx.h b/drivers/infiniband/hw/hfi1/trace_rx.h
index e6904aa80c00..8d5e12fe88a5 100644
--- a/drivers/infiniband/hw/hfi1/trace_rx.h
+++ b/drivers/infiniband/hw/hfi1/trace_rx.h
@@ -90,7 +90,7 @@ TRACE_EVENT(hfi1_mmu_invalidate,
 	    TP_fast_assign(
 			__entry->ctxt = ctxt;
 			__entry->subctxt = subctxt;
-			__assign_str(type, type);
+			__assign_str(type);
 			__entry->start = start;
 			__entry->end = end;
 	    ),
diff --git a/drivers/infiniband/hw/hfi1/trace_tid.h b/drivers/infiniband/hw/hfi1/trace_tid.h
index d129b8195959..e358f5b885fa 100644
--- a/drivers/infiniband/hw/hfi1/trace_tid.h
+++ b/drivers/infiniband/hw/hfi1/trace_tid.h
@@ -358,7 +358,7 @@ DECLARE_EVENT_CLASS(/* msg */
 	),
 	TP_fast_assign(/* assign */
 		__entry->qpn = qp ? qp->ibqp.qp_num : 0;
-		__assign_str(msg, msg);
+		__assign_str(msg);
 		__entry->more = more;
 	),
 	TP_printk(/* print */
@@ -651,7 +651,7 @@ DECLARE_EVENT_CLASS(/* tid_node */
 	TP_fast_assign(/* assign */
 		DD_DEV_ASSIGN(dd_from_ibdev(qp->ibqp.device));
 		__entry->qpn = qp->ibqp.qp_num;
-		__assign_str(msg, msg);
+		__assign_str(msg);
 		__entry->index = index;
 		__entry->base = base;
 		__entry->map = map;
diff --git a/drivers/infiniband/hw/hfi1/trace_tx.h b/drivers/infiniband/hw/hfi1/trace_tx.h
index c79856d4fdfb..c0ba6b0a2c4e 100644
--- a/drivers/infiniband/hw/hfi1/trace_tx.h
+++ b/drivers/infiniband/hw/hfi1/trace_tx.h
@@ -740,8 +740,8 @@ TRACE_EVENT(hfi1_sdma_state,
 		__string(newstate, nstate)
 	    ),
 	    TP_fast_assign(DD_DEV_ASSIGN(sde->dd);
-		__assign_str(curstate, cstate);
-		__assign_str(newstate, nstate);
+		__assign_str(curstate);
+		__assign_str(newstate);
 	    ),
 	    TP_printk("[%s] current state %s new state %s",
 		      __get_str(dev),
diff --git a/drivers/infiniband/sw/rdmavt/trace.h b/drivers/infiniband/sw/rdmavt/trace.h
index 4341965a5ea7..bdb6b9326b64 100644
--- a/drivers/infiniband/sw/rdmavt/trace.h
+++ b/drivers/infiniband/sw/rdmavt/trace.h
@@ -4,7 +4,7 @@
  */
 
 #define RDI_DEV_ENTRY(rdi)   __string(dev, rvt_get_ibdev_name(rdi))
-#define RDI_DEV_ASSIGN(rdi)  __assign_str(dev, rvt_get_ibdev_name(rdi))
+#define RDI_DEV_ASSIGN(rdi)  __assign_str(dev)
 
 #include "trace_rvt.h"
 #include "trace_qp.h"
diff --git a/drivers/infiniband/sw/rdmavt/trace_rvt.h b/drivers/infiniband/sw/rdmavt/trace_rvt.h
index df33c2ca9710..a00489e66ddf 100644
--- a/drivers/infiniband/sw/rdmavt/trace_rvt.h
+++ b/drivers/infiniband/sw/rdmavt/trace_rvt.h
@@ -24,7 +24,7 @@ TRACE_EVENT(rvt_dbg,
 	),
 	TP_fast_assign(
 		RDI_DEV_ASSIGN(rdi);
-		__assign_str(msg, msg);
+		__assign_str(msg);
 	),
 	TP_printk("[%s]: %s", __get_str(dev), __get_str(msg))
 );
diff --git a/drivers/interconnect/trace.h b/drivers/interconnect/trace.h
index 3d668ff566bf..206373546528 100644
--- a/drivers/interconnect/trace.h
+++ b/drivers/interconnect/trace.h
@@ -32,9 +32,9 @@ TRACE_EVENT(icc_set_bw,
 	),
 
 	TP_fast_assign(
-		__assign_str(path_name, p->name);
-		__assign_str(dev, dev_name(p->reqs[i].dev));
-		__assign_str(node_name, n->name);
+		__assign_str(path_name);
+		__assign_str(dev);
+		__assign_str(node_name);
 		__entry->avg_bw = avg_bw;
 		__entry->peak_bw = peak_bw;
 		__entry->node_avg_bw = n->avg_bw;
@@ -64,8 +64,8 @@ TRACE_EVENT(icc_set_bw_end,
 	),
 
 	TP_fast_assign(
-		__assign_str(path_name, p->name);
-		__assign_str(dev, dev_name(p->reqs[0].dev));
+		__assign_str(path_name);
+		__assign_str(dev);
 		__entry->ret = ret;
 	),
 
diff --git a/drivers/iommu/intel/trace.h b/drivers/iommu/intel/trace.h
index 93d96f93a89b..3fa48ff9d4e0 100644
--- a/drivers/iommu/intel/trace.h
+++ b/drivers/iommu/intel/trace.h
@@ -32,7 +32,7 @@ TRACE_EVENT(qi_submit,
 	),
 
 	TP_fast_assign(
-		__assign_str(iommu, iommu->name);
+		__assign_str(iommu);
 		__entry->qw0 = qw0;
 		__entry->qw1 = qw1;
 		__entry->qw2 = qw2;
@@ -79,8 +79,8 @@ TRACE_EVENT(prq_report,
 		__entry->dw2 = dw2;
 		__entry->dw3 = dw3;
 		__entry->seq = seq;
-		__assign_str(iommu, iommu->name);
-		__assign_str(dev, dev_name(dev));
+		__assign_str(iommu);
+		__assign_str(dev);
 	),
 
 	TP_printk("%s/%s seq# %ld: %s",
diff --git a/drivers/media/platform/nvidia/tegra-vde/trace.h b/drivers/media/platform/nvidia/tegra-vde/trace.h
index 7853ab095ca4..e8a75a7bd05d 100644
--- a/drivers/media/platform/nvidia/tegra-vde/trace.h
+++ b/drivers/media/platform/nvidia/tegra-vde/trace.h
@@ -20,7 +20,7 @@ DECLARE_EVENT_CLASS(register_access,
 		__field(u32, value)
 	),
 	TP_fast_assign(
-		__assign_str(hw_name, tegra_vde_reg_base_name(vde, base));
+		__assign_str(hw_name);
 		__entry->offset = offset;
 		__entry->value = value;
 	),
diff --git a/drivers/misc/mei/mei-trace.h b/drivers/misc/mei/mei-trace.h
index fe46ff2b9d69..5312edbf5190 100644
--- a/drivers/misc/mei/mei-trace.h
+++ b/drivers/misc/mei/mei-trace.h
@@ -26,7 +26,7 @@ TRACE_EVENT(mei_reg_read,
 		__field(u32, val)
 	),
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dev));
+		__assign_str(dev);
 		__entry->reg  = reg;
 		__entry->offs = offs;
 		__entry->val = val;
@@ -45,7 +45,7 @@ TRACE_EVENT(mei_reg_write,
 		__field(u32, val)
 	),
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dev));
+		__assign_str(dev);
 		__entry->reg = reg;
 		__entry->offs = offs;
 		__entry->val = val;
@@ -64,7 +64,7 @@ TRACE_EVENT(mei_pci_cfg_read,
 		__field(u32, val)
 	),
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dev));
+		__assign_str(dev);
 		__entry->reg  = reg;
 		__entry->offs = offs;
 		__entry->val = val;
diff --git a/drivers/net/dsa/mv88e6xxx/trace.h b/drivers/net/dsa/mv88e6xxx/trace.h
index f59ca04768e7..5bd015b2b97a 100644
--- a/drivers/net/dsa/mv88e6xxx/trace.h
+++ b/drivers/net/dsa/mv88e6xxx/trace.h
@@ -28,7 +28,7 @@ DECLARE_EVENT_CLASS(mv88e6xxx_atu_violation,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, dev_name(dev));
+		__assign_str(name);
 		__entry->spid = spid;
 		__entry->portvec = portvec;
 		memcpy(__entry->addr, addr, ETH_ALEN);
@@ -68,7 +68,7 @@ DECLARE_EVENT_CLASS(mv88e6xxx_vtu_violation,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, dev_name(dev));
+		__assign_str(name);
 		__entry->spid = spid;
 		__entry->vid = vid;
 	),
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h
index 889f89df9930..6f0e58a2a58a 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth_trace.h
@@ -57,7 +57,7 @@ DECLARE_EVENT_CLASS(dpaa_eth_fd,
 		__entry->fd_offset = qm_fd_get_offset(fd);
 		__entry->fd_length = qm_fd_get_length(fd);
 		__entry->fd_status = fd->status;
-		__assign_str(name, netdev->name);
+		__assign_str(name);
 	),
 
 	/* This is what gets printed when the trace event is triggered */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
index 9b43fadb9b11..956767e0869c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-trace.h
@@ -48,7 +48,7 @@ DECLARE_EVENT_CLASS(dpaa2_eth_fd,
 				   __entry->fd_addr = dpaa2_fd_get_addr(fd);
 				   __entry->fd_len = dpaa2_fd_get_len(fd);
 				   __entry->fd_offset = dpaa2_fd_get_offset(fd);
-				   __assign_str(name, netdev->name);
+				   __assign_str(name);
 		    ),
 
 		    /* This is what gets printed when the trace event is
@@ -144,7 +144,7 @@ DECLARE_EVENT_CLASS(dpaa2_eth_buf,
 				   __entry->dma_addr = dma_addr;
 				   __entry->map_size = map_size;
 				   __entry->bpid = bpid;
-				   __assign_str(name, netdev->name);
+				   __assign_str(name);
 		    ),
 
 		    /* This is what gets printed when the trace event is
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_trace.h b/drivers/net/ethernet/fungible/funeth/funeth_trace.h
index 9e58dfec19d5..b9985900f30b 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_trace.h
+++ b/drivers/net/ethernet/fungible/funeth/funeth_trace.h
@@ -32,7 +32,7 @@ TRACE_EVENT(funeth_tx,
 		__entry->len = len;
 		__entry->sqe_idx = sqe_idx;
 		__entry->ngle = ngle;
-		__assign_str(devname, txq->netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk("%s: Txq %u, SQE idx %u, len %u, num GLEs %u",
@@ -62,7 +62,7 @@ TRACE_EVENT(funeth_tx_free,
 		__entry->sqe_idx = sqe_idx;
 		__entry->num_sqes = num_sqes;
 		__entry->hw_head = hw_head;
-		__assign_str(devname, txq->netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk("%s: Txq %u, SQE idx %u, SQEs %u, HW head %u",
@@ -97,7 +97,7 @@ TRACE_EVENT(funeth_rx,
 		__entry->len = pkt_len;
 		__entry->hash = hash;
 		__entry->cls_vec = cls_vec;
-		__assign_str(devname, rxq->netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk("%s: Rxq %u, CQ head %u, RQEs %u, len %u, hash %u, CV %#x",
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
index b8a1ecb4b8fb..3362b8d14d4f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_trace.h
@@ -84,7 +84,7 @@ TRACE_EVENT(hns3_tx_desc,
 		__entry->desc_dma = ring->desc_dma_addr,
 		memcpy(__entry->desc, &ring->desc[cur_ntu],
 		       sizeof(struct hns3_desc));
-		__assign_str(devname, ring->tqp->handle->kinfo.netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk(
@@ -117,7 +117,7 @@ TRACE_EVENT(hns3_rx_desc,
 		__entry->buf_dma = ring->desc_cb[ring->next_to_clean].dma;
 		memcpy(__entry->desc, &ring->desc[ring->next_to_clean],
 		       sizeof(struct hns3_desc));
-		__assign_str(devname, ring->tqp->handle->kinfo.netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk(
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
index 7e47f0c21d88..7103cf04bffc 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_trace.h
@@ -33,8 +33,8 @@ TRACE_EVENT(hclge_pf_mbx_get,
 		__entry->vfid = req->mbx_src_vfid;
 		__entry->code = req->msg.code;
 		__entry->subcode = req->msg.subcode;
-		__assign_str(pciname, pci_name(hdev->pdev));
-		__assign_str(devname, hdev->vport[0].nic.kinfo.netdev->name);
+		__assign_str(pciname);
+		__assign_str(devname);
 		memcpy(__entry->mbx_data, req,
 		       sizeof(struct hclge_mbx_vf_to_pf_cmd));
 	),
@@ -64,8 +64,8 @@ TRACE_EVENT(hclge_pf_mbx_send,
 	TP_fast_assign(
 		__entry->vfid = req->dest_vfid;
 		__entry->code = le16_to_cpu(req->msg.code);
-		__assign_str(pciname, pci_name(hdev->pdev));
-		__assign_str(devname, hdev->vport[0].nic.kinfo.netdev->name);
+		__assign_str(pciname);
+		__assign_str(devname);
 		memcpy(__entry->mbx_data, req,
 		       sizeof(struct hclge_mbx_pf_to_vf_cmd));
 	),
@@ -101,7 +101,7 @@ DECLARE_EVENT_CLASS(hclge_pf_cmd_template,
 			__entry->rsv = le16_to_cpu(desc->rsv);
 			__entry->index = index;
 			__entry->num = num;
-			__assign_str(pciname, pci_name(hw->cmq.csq.pdev));
+			__assign_str(pciname);
 			for (i = 0; i < HCLGE_DESC_DATA_LEN; i++)
 				__entry->data[i] = le32_to_cpu(desc->data[i]);),
 
@@ -144,7 +144,7 @@ DECLARE_EVENT_CLASS(hclge_pf_special_cmd_template,
 		    TP_fast_assign(int i;
 			__entry->index = index;
 			__entry->num = num;
-			__assign_str(pciname, pci_name(hw->cmq.csq.pdev));
+			__assign_str(pciname);
 			for (i = 0; i < PF_DESC_LEN; i++)
 				__entry->data[i] = le32_to_cpu(data[i]);
 		),
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
index e2e3a2602b6a..66b084309c91 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_trace.h
@@ -30,8 +30,8 @@ TRACE_EVENT(hclge_vf_mbx_get,
 	TP_fast_assign(
 		__entry->vfid = req->dest_vfid;
 		__entry->code = le16_to_cpu(req->msg.code);
-		__assign_str(pciname, pci_name(hdev->pdev));
-		__assign_str(devname, hdev->nic.kinfo.netdev->name);
+		__assign_str(pciname);
+		__assign_str(devname);
 		memcpy(__entry->mbx_data, req,
 		       sizeof(struct hclge_mbx_pf_to_vf_cmd));
 	),
@@ -63,8 +63,8 @@ TRACE_EVENT(hclge_vf_mbx_send,
 		__entry->vfid = req->mbx_src_vfid;
 		__entry->code = req->msg.code;
 		__entry->subcode = req->msg.subcode;
-		__assign_str(pciname, pci_name(hdev->pdev));
-		__assign_str(devname, hdev->nic.kinfo.netdev->name);
+		__assign_str(pciname);
+		__assign_str(devname);
 		memcpy(__entry->mbx_data, req,
 		       sizeof(struct hclge_mbx_vf_to_pf_cmd));
 	),
@@ -101,7 +101,7 @@ DECLARE_EVENT_CLASS(hclge_vf_cmd_template,
 			__entry->rsv = le16_to_cpu(desc->rsv);
 			__entry->index = index;
 			__entry->num = num;
-			__assign_str(pciname, pci_name(hw->cmq.csq.pdev));
+			__assign_str(pciname);
 			for (i = 0; i < HCLGE_DESC_DATA_LEN; i++)
 				__entry->data[i] = le32_to_cpu(desc->data[i]);),
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_trace.h b/drivers/net/ethernet/intel/i40e/i40e_trace.h
index 33b4e30f5e00..759f3d1c4c8f 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_trace.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_trace.h
@@ -89,8 +89,8 @@ TRACE_EVENT(i40e_napi_poll,
 		__entry->tx_clean_complete = tx_clean_complete;
 		__entry->irq_num = q->irq_num;
 		__entry->curr_cpu = get_cpu();
-		__assign_str(qname, q->name);
-		__assign_str(dev_name, napi->dev ? napi->dev->name : NO_DEV);
+		__assign_str(qname);
+		__assign_str(dev_name);
 		__assign_bitmask(irq_affinity, cpumask_bits(&q->affinity_mask),
 				 nr_cpumask_bits);
 	),
@@ -132,7 +132,7 @@ DECLARE_EVENT_CLASS(
 		__entry->ring = ring;
 		__entry->desc = desc;
 		__entry->buf = buf;
-		__assign_str(devname, ring->netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk(
@@ -177,7 +177,7 @@ DECLARE_EVENT_CLASS(
 		__entry->ring = ring;
 		__entry->desc = desc;
 		__entry->xdp = xdp;
-		__assign_str(devname, ring->netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk(
@@ -219,7 +219,7 @@ DECLARE_EVENT_CLASS(
 	TP_fast_assign(
 		__entry->skb = skb;
 		__entry->ring = ring;
-		__assign_str(devname, ring->netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk(
diff --git a/drivers/net/ethernet/intel/iavf/iavf_trace.h b/drivers/net/ethernet/intel/iavf/iavf_trace.h
index 82fda6f5abf0..62212011c807 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_trace.h
+++ b/drivers/net/ethernet/intel/iavf/iavf_trace.h
@@ -83,7 +83,7 @@ DECLARE_EVENT_CLASS(
 		__entry->ring = ring;
 		__entry->desc = desc;
 		__entry->buf = buf;
-		__assign_str(devname, ring->netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk(
@@ -128,7 +128,7 @@ DECLARE_EVENT_CLASS(
 		__entry->ring = ring;
 		__entry->desc = desc;
 		__entry->skb = skb;
-		__assign_str(devname, ring->netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk(
@@ -170,7 +170,7 @@ DECLARE_EVENT_CLASS(
 	TP_fast_assign(
 		__entry->skb = skb;
 		__entry->ring = ring;
-		__assign_str(devname, ring->netdev->name);
+		__assign_str(devname);
 	),
 
 	TP_printk(
diff --git a/drivers/net/ethernet/intel/ice/ice_trace.h b/drivers/net/ethernet/intel/ice/ice_trace.h
index b2f5c9fe0149..244cddd2a9ea 100644
--- a/drivers/net/ethernet/intel/ice/ice_trace.h
+++ b/drivers/net/ethernet/intel/ice/ice_trace.h
@@ -69,7 +69,7 @@ DECLARE_EVENT_CLASS(ice_rx_dim_template,
 
 		    TP_fast_assign(__entry->q_vector = q_vector;
 				   __entry->dim = dim;
-				   __assign_str(devname, q_vector->rx.rx_ring->netdev->name);),
+				   __assign_str(devname);),
 
 		    TP_printk("netdev: %s Rx-Q: %d dim-state: %d dim-profile: %d dim-tune: %d dim-st-right: %d dim-st-left: %d dim-tired: %d",
 			      __get_str(devname),
@@ -96,7 +96,7 @@ DECLARE_EVENT_CLASS(ice_tx_dim_template,
 
 		    TP_fast_assign(__entry->q_vector = q_vector;
 				   __entry->dim = dim;
-				   __assign_str(devname, q_vector->tx.tx_ring->netdev->name);),
+				   __assign_str(devname);),
 
 		    TP_printk("netdev: %s Tx-Q: %d dim-state: %d dim-profile: %d dim-tune: %d dim-st-right: %d dim-st-left: %d dim-tired: %d",
 			      __get_str(devname),
@@ -128,7 +128,7 @@ DECLARE_EVENT_CLASS(ice_tx_template,
 		    TP_fast_assign(__entry->ring = ring;
 				   __entry->desc = desc;
 				   __entry->buf = buf;
-				   __assign_str(devname, ring->netdev->name);),
+				   __assign_str(devname);),
 
 		    TP_printk("netdev: %s ring: %pK desc: %pK buf %pK", __get_str(devname),
 			      __entry->ring, __entry->desc, __entry->buf)
@@ -156,7 +156,7 @@ DECLARE_EVENT_CLASS(ice_rx_template,
 
 		    TP_fast_assign(__entry->ring = ring;
 				   __entry->desc = desc;
-				   __assign_str(devname, ring->netdev->name);),
+				   __assign_str(devname);),
 
 		    TP_printk("netdev: %s ring: %pK desc: %pK", __get_str(devname),
 			      __entry->ring, __entry->desc)
@@ -180,7 +180,7 @@ DECLARE_EVENT_CLASS(ice_rx_indicate_template,
 		    TP_fast_assign(__entry->ring = ring;
 				   __entry->desc = desc;
 				   __entry->skb = skb;
-				   __assign_str(devname, ring->netdev->name);),
+				   __assign_str(devname);),
 
 		    TP_printk("netdev: %s ring: %pK desc: %pK skb %pK", __get_str(devname),
 			      __entry->ring, __entry->desc, __entry->skb)
@@ -203,7 +203,7 @@ DECLARE_EVENT_CLASS(ice_xmit_template,
 
 		    TP_fast_assign(__entry->ring = ring;
 				   __entry->skb = skb;
-				   __assign_str(devname, ring->netdev->name);),
+				   __assign_str(devname);),
 
 		    TP_printk("netdev: %s skb: %pK ring: %pK", __get_str(devname),
 			      __entry->skb, __entry->ring)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
index 28984d0e848a..5704520f9b02 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_trace.h
@@ -24,7 +24,7 @@ TRACE_EVENT(otx2_msg_alloc,
 			     __field(u16, id)
 			     __field(u64, size)
 	    ),
-	    TP_fast_assign(__assign_str(dev, pci_name(pdev));
+	    TP_fast_assign(__assign_str(dev);
 			   __entry->id = id;
 			   __entry->size = size;
 	    ),
@@ -39,7 +39,7 @@ TRACE_EVENT(otx2_msg_send,
 			     __field(u16, num_msgs)
 			     __field(u64, msg_size)
 	    ),
-	    TP_fast_assign(__assign_str(dev, pci_name(pdev));
+	    TP_fast_assign(__assign_str(dev);
 			   __entry->num_msgs = num_msgs;
 			   __entry->msg_size = msg_size;
 	    ),
@@ -55,7 +55,7 @@ TRACE_EVENT(otx2_msg_check,
 			     __field(u16, rspid)
 			     __field(int, rc)
 	    ),
-	    TP_fast_assign(__assign_str(dev, pci_name(pdev));
+	    TP_fast_assign(__assign_str(dev);
 			   __entry->reqid = reqid;
 			   __entry->rspid = rspid;
 			   __entry->rc = rc;
@@ -72,8 +72,8 @@ TRACE_EVENT(otx2_msg_interrupt,
 			     __string(str, msg)
 			     __field(u64, intr)
 	    ),
-	    TP_fast_assign(__assign_str(dev, pci_name(pdev));
-			   __assign_str(str, msg);
+	    TP_fast_assign(__assign_str(dev);
+			   __assign_str(str);
 			   __entry->intr = intr;
 	    ),
 	    TP_printk("[%s] mbox interrupt %s (0x%llx)\n", __get_str(dev),
@@ -87,7 +87,7 @@ TRACE_EVENT(otx2_msg_process,
 			     __field(u16, id)
 			     __field(int, err)
 	    ),
-	    TP_fast_assign(__assign_str(dev, pci_name(pdev));
+	    TP_fast_assign(__assign_str(dev);
 			   __entry->id = id;
 			   __entry->err = err;
 	    ),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h
index 406ebe17405f..b4b3a43e56a0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/cmd_tracepoint.h
@@ -22,10 +22,10 @@ TRACE_EVENT(mlx5_cmd,
 			    __field(u32, syndrome)
 			    __field(int, err)
 			    ),
-	    TP_fast_assign(__assign_str(command_str, command_str);
+	    TP_fast_assign(__assign_str(command_str);
 			__entry->opcode = opcode;
 			__entry->op_mod = op_mod;
-			__assign_str(status_str, status_str);
+			__assign_str(status_str);
 			__entry->status = status;
 			__entry->syndrome = syndrome;
 			__entry->err = err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint.h
index f15718db5d0e..78e481b2c015 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_rep_tracepoint.h
@@ -25,7 +25,7 @@ TRACE_EVENT(mlx5e_rep_neigh_update,
 			struct in6_addr *pin6;
 			__be32 *p32;
 
-			__assign_str(devname, nhe->neigh_dev->name);
+			__assign_str(devname);
 			__entry->neigh_connected = neigh_connected;
 			memcpy(__entry->ha, ha, ETH_ALEN);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
index ac52ef37f38a..4b1ca228012b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/en_tc_tracepoint.h
@@ -86,7 +86,7 @@ TRACE_EVENT(mlx5e_tc_update_neigh_used_value,
 			struct in6_addr *pin6;
 			__be32 *p32;
 
-			__assign_str(devname, nhe->neigh_dev->name);
+			__assign_str(devname);
 			__entry->neigh_used = neigh_used;
 
 			p32 = (__be32 *)__entry->v4;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer_tracepoint.h
index 3038be575923..50f8a7630f86 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer_tracepoint.h
@@ -55,12 +55,11 @@ TRACE_EVENT(mlx5_fw,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name,
-			     dev_name(tracer->dev->device));
+		__assign_str(dev_name);
 		__entry->trace_timestamp = trace_timestamp;
 		__entry->lost = lost;
 		__entry->event_id = event_id;
-		__assign_str(msg, msg);
+		__assign_str(msg);
 	),
 
 	TP_printk("%s [0x%llx] %d [0x%x] %s",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/qos_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/qos_tracepoint.h
index 458baf0c6415..1ce332f21ebe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/qos_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/diag/qos_tracepoint.h
@@ -17,7 +17,7 @@ TRACE_EVENT(mlx5_esw_vport_qos_destroy,
 			     __field(unsigned short, vport_id)
 			     __field(unsigned int,   tsar_ix)
 			     ),
-	    TP_fast_assign(__assign_str(devname, dev_name(vport->dev->device));
+	    TP_fast_assign(__assign_str(devname);
 		    __entry->vport_id = vport->vport;
 		    __entry->tsar_ix = vport->qos.esw_tsar_ix;
 	    ),
@@ -36,7 +36,7 @@ DECLARE_EVENT_CLASS(mlx5_esw_vport_qos_template,
 				     __field(unsigned int, max_rate)
 				     __field(void *, group)
 				     ),
-		    TP_fast_assign(__assign_str(devname, dev_name(vport->dev->device));
+		    TP_fast_assign(__assign_str(devname);
 			    __entry->vport_id = vport->vport;
 			    __entry->tsar_ix = vport->qos.esw_tsar_ix;
 			    __entry->bw_share = bw_share;
@@ -68,7 +68,7 @@ DECLARE_EVENT_CLASS(mlx5_esw_group_qos_template,
 				     __field(const void *, group)
 				     __field(unsigned int, tsar_ix)
 				     ),
-		    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    TP_fast_assign(__assign_str(devname);
 			    __entry->group = group;
 			    __entry->tsar_ix = tsar_ix;
 		    ),
@@ -102,7 +102,7 @@ TRACE_EVENT(mlx5_esw_group_qos_config,
 			     __field(unsigned int, bw_share)
 			     __field(unsigned int, max_rate)
 			     ),
-	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+	    TP_fast_assign(__assign_str(devname);
 		    __entry->group = group;
 		    __entry->tsar_ix = tsar_ix;
 		    __entry->bw_share = bw_share;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/diag/dev_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/diag/dev_tracepoint.h
index 7f7c9af5deed..0537de86f981 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/diag/dev_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/diag/dev_tracepoint.h
@@ -22,7 +22,7 @@ DECLARE_EVENT_CLASS(mlx5_sf_dev_template,
 				     __field(u16, hw_fn_id)
 				     __field(u32, sfnum)
 		    ),
-		    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    TP_fast_assign(__assign_str(devname);
 				   __entry->sfdev = sfdev;
 				   __entry->aux_id = aux_id;
 				   __entry->hw_fn_id = sfdev->fn_id;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h
index 8bf1cd90930d..302ce00da5a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/sf_tracepoint.h
@@ -24,7 +24,7 @@ TRACE_EVENT(mlx5_sf_add,
 			     __field(u16, hw_fn_id)
 			     __field(u32, sfnum)
 			    ),
-	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+	    TP_fast_assign(__assign_str(devname);
 		    __entry->port_index = port_index;
 		    __entry->controller = controller;
 		    __entry->hw_fn_id = hw_fn_id;
@@ -46,7 +46,7 @@ TRACE_EVENT(mlx5_sf_free,
 			     __field(u32, controller)
 			     __field(u16, hw_fn_id)
 			    ),
-	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+	    TP_fast_assign(__assign_str(devname);
 		    __entry->port_index = port_index;
 		    __entry->controller = controller;
 		    __entry->hw_fn_id = hw_fn_id;
@@ -67,7 +67,7 @@ TRACE_EVENT(mlx5_sf_hwc_alloc,
 			     __field(u16, hw_fn_id)
 			     __field(u32, sfnum)
 			    ),
-	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+	    TP_fast_assign(__assign_str(devname);
 		    __entry->controller = controller;
 		    __entry->hw_fn_id = hw_fn_id;
 		    __entry->sfnum = sfnum;
@@ -84,7 +84,7 @@ TRACE_EVENT(mlx5_sf_hwc_free,
 	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
 			     __field(u16, hw_fn_id)
 			    ),
-	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+	    TP_fast_assign(__assign_str(devname);
 		    __entry->hw_fn_id = hw_fn_id;
 	    ),
 	    TP_printk("(%s) hw_id=0x%x\n", __get_str(devname), __entry->hw_fn_id)
@@ -97,7 +97,7 @@ TRACE_EVENT(mlx5_sf_hwc_deferred_free,
 	    TP_STRUCT__entry(__string(devname, dev_name(dev->device))
 			     __field(u16, hw_fn_id)
 			    ),
-	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+	    TP_fast_assign(__assign_str(devname);
 		    __entry->hw_fn_id = hw_fn_id;
 	    ),
 	    TP_printk("(%s) hw_id=0x%x\n", __get_str(devname), __entry->hw_fn_id)
@@ -113,7 +113,7 @@ DECLARE_EVENT_CLASS(mlx5_sf_state_template,
 				     __field(unsigned int, port_index)
 				     __field(u32, controller)
 				     __field(u16, hw_fn_id)),
-		    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+		    TP_fast_assign(__assign_str(devname);
 				   __entry->port_index = port_index;
 				   __entry->controller = controller;
 				   __entry->hw_fn_id = hw_fn_id;
@@ -152,7 +152,7 @@ TRACE_EVENT(mlx5_sf_update_state,
 			     __field(u16, hw_fn_id)
 			     __field(u8, state)
 			    ),
-	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+	    TP_fast_assign(__assign_str(devname);
 		    __entry->port_index = port_index;
 		    __entry->controller = controller;
 		    __entry->hw_fn_id = hw_fn_id;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/vhca_tracepoint.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/vhca_tracepoint.h
index fd814a190b8b..6352cb004a18 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/vhca_tracepoint.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/diag/vhca_tracepoint.h
@@ -20,7 +20,7 @@ TRACE_EVENT(mlx5_sf_vhca_event,
 			     __field(u32, sfnum)
 			     __field(u8, vhca_state)
 			    ),
-	    TP_fast_assign(__assign_str(devname, dev_name(dev->device));
+	    TP_fast_assign(__assign_str(devname);
 		    __entry->hw_fn_id = event->function_id;
 		    __entry->sfnum = event->sw_function_id;
 		    __entry->vhca_state = event->new_vhca_state;
diff --git a/drivers/net/fjes/fjes_trace.h b/drivers/net/fjes/fjes_trace.h
index 6437ddbd7842..166ef015262b 100644
--- a/drivers/net/fjes/fjes_trace.h
+++ b/drivers/net/fjes/fjes_trace.h
@@ -85,7 +85,7 @@ TRACE_EVENT(fjes_hw_request_info_err,
 		__string(err, err)
 	),
 	TP_fast_assign(
-		__assign_str(err, err);
+		__assign_str(err);
 	),
 	TP_printk("%s", __get_str(err))
 );
@@ -145,7 +145,7 @@ TRACE_EVENT(fjes_hw_register_buff_addr_err,
 		__string(err, err)
 	),
 	TP_fast_assign(
-		__assign_str(err, err);
+		__assign_str(err);
 	),
 	TP_printk("%s", __get_str(err))
 );
@@ -189,7 +189,7 @@ TRACE_EVENT(fjes_hw_unregister_buff_addr_err,
 		__string(err, err)
 	),
 	TP_fast_assign(
-		__assign_str(err, err);
+		__assign_str(err);
 	),
 	TP_printk("%s", __get_str(err))
 );
@@ -232,7 +232,7 @@ TRACE_EVENT(fjes_hw_start_debug_err,
 		 __string(err, err)
 	),
 	TP_fast_assign(
-		__assign_str(err, err);
+		__assign_str(err);
 	),
 	TP_printk("%s", __get_str(err))
 );
@@ -258,7 +258,7 @@ TRACE_EVENT(fjes_hw_stop_debug_err,
 		 __string(err, err)
 	),
 	TP_fast_assign(
-		__assign_str(err, err);
+		__assign_str(err);
 	),
 	TP_printk("%s", __get_str(err))
 );
diff --git a/drivers/net/hyperv/netvsc_trace.h b/drivers/net/hyperv/netvsc_trace.h
index f7585563dea5..05e620cbdd29 100644
--- a/drivers/net/hyperv/netvsc_trace.h
+++ b/drivers/net/hyperv/netvsc_trace.h
@@ -51,7 +51,7 @@ DECLARE_EVENT_CLASS(rndis_msg_class,
 	       __field(	 u32,  msg_len	   )
        ),
        TP_fast_assign(
-	       __assign_str(name, ndev->name);
+	       __assign_str(name);
 	       __entry->queue	 = q;
 	       __entry->req_id	 = msg->msg.init_req.req_id;
 	       __entry->msg_type = msg->ndis_msg_type;
@@ -121,7 +121,7 @@ TRACE_EVENT(nvsp_send,
 		__field(  u32,	msg_type    )
 	),
 	TP_fast_assign(
-		__assign_str(name, ndev->name);
+		__assign_str(name);
 		__entry->msg_type = msg->hdr.msg_type;
 	),
 	TP_printk("dev=%s type=%s",
@@ -142,7 +142,7 @@ TRACE_EVENT(nvsp_send_pkt,
 		__field(  u32,	section_size  )
 	),
 	TP_fast_assign(
-		__assign_str(name, ndev->name);
+		__assign_str(name);
 		__entry->qid = chan->offermsg.offer.sub_channel_index;
 		__entry->channel_type = rpkt->channel_type;
 		__entry->section_index = rpkt->send_buf_section_index;
@@ -165,7 +165,7 @@ TRACE_EVENT(nvsp_recv,
 		__field(  u32,	msg_type    )
 	),
 	TP_fast_assign(
-		__assign_str(name, ndev->name);
+		__assign_str(name);
 		__entry->qid = chan->offermsg.offer.sub_channel_index;
 		__entry->msg_type = msg->hdr.msg_type;
 	),
diff --git a/drivers/net/wireless/ath/ath10k/trace.h b/drivers/net/wireless/ath/ath10k/trace.h
index 64e7a767d963..68b78ca17eaa 100644
--- a/drivers/net/wireless/ath/ath10k/trace.h
+++ b/drivers/net/wireless/ath/ath10k/trace.h
@@ -55,8 +55,8 @@ DECLARE_EVENT_CLASS(ath10k_log_event,
 		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk(
@@ -92,8 +92,8 @@ TRACE_EVENT(ath10k_log_dbg,
 		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->level = level;
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
@@ -121,10 +121,10 @@ TRACE_EVENT(ath10k_log_dbg_dump,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
-		__assign_str(msg, msg);
-		__assign_str(prefix, prefix);
+		__assign_str(device);
+		__assign_str(driver);
+		__assign_str(msg);
+		__assign_str(prefix);
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
 	),
@@ -152,8 +152,8 @@ TRACE_EVENT(ath10k_wmi_cmd,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->id = id;
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
@@ -182,8 +182,8 @@ TRACE_EVENT(ath10k_wmi_event,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->id = id;
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
@@ -211,8 +211,8 @@ TRACE_EVENT(ath10k_htt_stats,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
 	),
@@ -239,8 +239,8 @@ TRACE_EVENT(ath10k_wmi_dbglog,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->hw_type = ar->hw_rev;
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
@@ -269,8 +269,8 @@ TRACE_EVENT(ath10k_htt_pktlog,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->hw_type = ar->hw_rev;
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(pktlog), buf, buf_len);
@@ -301,8 +301,8 @@ TRACE_EVENT(ath10k_htt_tx,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->msdu_id = msdu_id;
 		__entry->msdu_len = msdu_len;
 		__entry->vdev_id = vdev_id;
@@ -332,8 +332,8 @@ TRACE_EVENT(ath10k_txrx_tx_unref,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->msdu_id = msdu_id;
 	),
 
@@ -358,8 +358,8 @@ DECLARE_EVENT_CLASS(ath10k_hdr_event,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->len = ath10k_frm_hdr_len(data, len);
 		memcpy(__get_dynamic_array(data), data, __entry->len);
 	),
@@ -386,8 +386,8 @@ DECLARE_EVENT_CLASS(ath10k_payload_event,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->len = len - ath10k_frm_hdr_len(data, len);
 		memcpy(__get_dynamic_array(payload),
 		       data + ath10k_frm_hdr_len(data, len), __entry->len);
@@ -435,8 +435,8 @@ TRACE_EVENT(ath10k_htt_rx_desc,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->hw_type = ar->hw_rev;
 		__entry->len = len;
 		memcpy(__get_dynamic_array(rxdesc), data, len);
@@ -472,8 +472,8 @@ TRACE_EVENT(ath10k_wmi_diag_container,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->type = type;
 		__entry->timestamp = timestamp;
 		__entry->code = code;
@@ -505,8 +505,8 @@ TRACE_EVENT(ath10k_wmi_diag,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->dev));
-		__assign_str(driver, dev_driver_string(ar->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->len = len;
 		memcpy(__get_dynamic_array(data), data, len);
 	),
diff --git a/drivers/net/wireless/ath/ath11k/trace.h b/drivers/net/wireless/ath/ath11k/trace.h
index 235ab8ea715f..75246b0a82e3 100644
--- a/drivers/net/wireless/ath/ath11k/trace.h
+++ b/drivers/net/wireless/ath/ath11k/trace.h
@@ -48,8 +48,8 @@ TRACE_EVENT(ath11k_htt_pktlog,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->ab->dev));
-		__assign_str(driver, dev_driver_string(ar->ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->buf_len = buf_len;
 		__entry->pktlog_checksum = pktlog_checksum;
 		memcpy(__get_dynamic_array(pktlog), buf, buf_len);
@@ -77,8 +77,8 @@ TRACE_EVENT(ath11k_htt_ppdu_stats,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->ab->dev));
-		__assign_str(driver, dev_driver_string(ar->ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->len = len;
 		memcpy(__get_dynamic_array(ppdu), data, len);
 	),
@@ -105,8 +105,8 @@ TRACE_EVENT(ath11k_htt_rxdesc,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->ab->dev));
-		__assign_str(driver, dev_driver_string(ar->ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->len = len;
 		__entry->log_type = log_type;
 		memcpy(__get_dynamic_array(rxdesc), data, len);
@@ -130,8 +130,8 @@ DECLARE_EVENT_CLASS(ath11k_log_event,
 		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		__assign_str(device, dev_name(ab->dev));
-		__assign_str(driver, dev_driver_string(ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk(
@@ -171,8 +171,8 @@ TRACE_EVENT(ath11k_wmi_cmd,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ab->dev));
-		__assign_str(driver, dev_driver_string(ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->id = id;
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
@@ -201,8 +201,8 @@ TRACE_EVENT(ath11k_wmi_event,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ab->dev));
-		__assign_str(driver, dev_driver_string(ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->id = id;
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
@@ -230,8 +230,8 @@ TRACE_EVENT(ath11k_log_dbg,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ab->dev));
-		__assign_str(driver, dev_driver_string(ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->level = level;
 		WARN_ON_ONCE(vsnprintf(__get_dynamic_array(msg),
 				       ATH11K_MSG_MAX, vaf->fmt,
@@ -262,10 +262,10 @@ TRACE_EVENT(ath11k_log_dbg_dump,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ab->dev));
-		__assign_str(driver, dev_driver_string(ab->dev));
-		__assign_str(msg, msg);
-		__assign_str(prefix, prefix);
+		__assign_str(device);
+		__assign_str(driver);
+		__assign_str(msg);
+		__assign_str(prefix);
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
 	),
@@ -292,8 +292,8 @@ TRACE_EVENT(ath11k_wmi_diag,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ab->dev));
-		__assign_str(driver, dev_driver_string(ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->len = len;
 		memcpy(__get_dynamic_array(data), data, len);
 	),
@@ -318,8 +318,8 @@ TRACE_EVENT(ath11k_ps_timekeeper,
 			 __field(u32, peer_ps_timestamp)
 	),
 
-	TP_fast_assign(__assign_str(device, dev_name(ar->ab->dev));
-		       __assign_str(driver, dev_driver_string(ar->ab->dev));
+	TP_fast_assign(__assign_str(device);
+		       __assign_str(driver);
 		       memcpy(__get_dynamic_array(peer_addr), peer_addr,
 			      ETH_ALEN);
 		       __entry->peer_ps_state = peer_ps_state;
diff --git a/drivers/net/wireless/ath/ath12k/trace.h b/drivers/net/wireless/ath/ath12k/trace.h
index 240737e1542d..253c67accb0e 100644
--- a/drivers/net/wireless/ath/ath12k/trace.h
+++ b/drivers/net/wireless/ath/ath12k/trace.h
@@ -36,8 +36,8 @@ TRACE_EVENT(ath12k_htt_pktlog,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->ab->dev));
-		__assign_str(driver, dev_driver_string(ar->ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->buf_len = buf_len;
 		__entry->pktlog_checksum = pktlog_checksum;
 		memcpy(__get_dynamic_array(pktlog), buf, buf_len);
@@ -73,8 +73,8 @@ TRACE_EVENT(ath12k_htt_ppdu_stats,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->ab->dev));
-		__assign_str(driver, dev_driver_string(ar->ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->len = len;
 		__entry->info = ar->pdev->timestamp.info;
 		__entry->sync_tstmp_lo_us = ar->pdev->timestamp.sync_timestamp_hi_us;
@@ -117,8 +117,8 @@ TRACE_EVENT(ath12k_htt_rxdesc,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ar->ab->dev));
-		__assign_str(driver, dev_driver_string(ar->ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->len = len;
 		__entry->type = type;
 		__entry->info = ar->pdev->timestamp.info;
@@ -153,8 +153,8 @@ TRACE_EVENT(ath12k_wmi_diag,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(ab->dev));
-		__assign_str(driver, dev_driver_string(ab->dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->len = len;
 		memcpy(__get_dynamic_array(data), data, len);
 	),
diff --git a/drivers/net/wireless/ath/ath6kl/trace.h b/drivers/net/wireless/ath/ath6kl/trace.h
index 231a94769ddb..8577aa459c58 100644
--- a/drivers/net/wireless/ath/ath6kl/trace.h
+++ b/drivers/net/wireless/ath/ath6kl/trace.h
@@ -304,8 +304,8 @@ TRACE_EVENT(ath6kl_log_dbg_dump,
 	),
 
 	TP_fast_assign(
-		__assign_str(msg, msg);
-		__assign_str(prefix, prefix);
+		__assign_str(msg);
+		__assign_str(prefix);
 		__entry->buf_len = buf_len;
 		memcpy(__get_dynamic_array(buf), buf, buf_len);
 	),
diff --git a/drivers/net/wireless/ath/trace.h b/drivers/net/wireless/ath/trace.h
index 9935cf475b6d..82aac0a4baff 100644
--- a/drivers/net/wireless/ath/trace.h
+++ b/drivers/net/wireless/ath/trace.h
@@ -44,8 +44,8 @@ TRACE_EVENT(ath_log,
 	    ),
 
 	    TP_fast_assign(
-		    __assign_str(device, wiphy_name(wiphy));
-		    __assign_str(driver, KBUILD_MODNAME);
+		    __assign_str(device);
+		    __assign_str(driver);
 		    __assign_vstr(msg, vaf->fmt, vaf->va);
 	    ),
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h
index 5d66e94c806d..96032322b165 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/tracepoint.h
@@ -41,7 +41,7 @@ TRACE_EVENT(brcmf_err,
 		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		__assign_str(func, func);
+		__assign_str(func);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s: %s", __get_str(func), __get_str(msg))
@@ -57,7 +57,7 @@ TRACE_EVENT(brcmf_dbg,
 	),
 	TP_fast_assign(
 		__entry->level = level;
-		__assign_str(func, func);
+		__assign_str(func);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s: %s", __get_str(func), __get_str(msg))
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac.h
index a0da3248b942..53b3dba50737 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac.h
@@ -81,7 +81,7 @@ TRACE_EVENT(brcms_macintstatus,
 		__field(u32, mask)
 	),
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dev));
+		__assign_str(dev);
 		__entry->in_isr = in_isr;
 		__entry->macintstatus = macintstatus;
 		__entry->mask = mask;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h
index 42b0a91656c4..908ce3c864fe 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_msg.h
@@ -71,7 +71,7 @@ TRACE_EVENT(brcms_dbg,
 	),
 	TP_fast_assign(
 		__entry->level = level;
-		__assign_str(func, func);
+		__assign_str(func);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s: %s", __get_str(func), __get_str(msg))
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_tx.h b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_tx.h
index cf2cc070f1e5..24ac34fa0207 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_tx.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/brcms_trace_brcmsmac_tx.h
@@ -31,7 +31,7 @@ TRACE_EVENT(brcms_txdesc,
 		__dynamic_array(u8, txh, txh_len)
 	),
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dev));
+		__assign_str(dev);
 		memcpy(__get_dynamic_array(txh), txh, txh_len);
 	),
 	TP_printk("[%s] txdesc", __get_str(dev))
@@ -54,7 +54,7 @@ TRACE_EVENT(brcms_txstatus,
 		__field(u16, ackphyrxsh)
 	),
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dev));
+		__assign_str(dev);
 		__entry->framelen = framelen;
 		__entry->frameid = frameid;
 		__entry->status = status;
@@ -85,7 +85,7 @@ TRACE_EVENT(brcms_ampdu_session,
 		__field(u16, dma_len)
 	),
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dev));
+		__assign_str(dev);
 		__entry->max_ampdu_len = max_ampdu_len;
 		__entry->max_ampdu_frames = max_ampdu_frames;
 		__entry->ampdu_len = ampdu_len;
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
index 1d6c292cf545..0db1fa5477af 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-msg.h
@@ -57,7 +57,7 @@ TRACE_EVENT(iwlwifi_dbg,
 	),
 	TP_fast_assign(
 		__entry->level = level;
-		__assign_str(function, function);
+		__assign_str(function);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s", __get_str(msg))
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
index c3e09f4fefeb..76166e1b10e5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
@@ -87,7 +87,7 @@ static inline void trace_ ## name(proto) {}
 #endif
 
 #define DEV_ENTRY	__string(dev, dev_name(dev))
-#define DEV_ASSIGN	__assign_str(dev, dev_name(dev))
+#define DEV_ASSIGN	__assign_str(dev)
 
 #include "iwl-devtrace-io.h"
 #include "iwl-devtrace-ucode.h"
diff --git a/drivers/soc/qcom/pmic_pdcharger_ulog.h b/drivers/soc/qcom/pmic_pdcharger_ulog.h
index 152e3a6b5480..1cfa58f0e34c 100644
--- a/drivers/soc/qcom/pmic_pdcharger_ulog.h
+++ b/drivers/soc/qcom/pmic_pdcharger_ulog.h
@@ -18,7 +18,7 @@ TRACE_EVENT(pmic_pdcharger_ulog_msg,
 		__string(msg, msg)
 	),
 	TP_fast_assign(
-		__assign_str(msg, msg);
+		__assign_str(msg);
 	),
 	TP_printk("%s", __get_str(msg))
 );
diff --git a/drivers/soc/qcom/trace-aoss.h b/drivers/soc/qcom/trace-aoss.h
index 554029b33b44..fb5b0470c40d 100644
--- a/drivers/soc/qcom/trace-aoss.h
+++ b/drivers/soc/qcom/trace-aoss.h
@@ -18,7 +18,7 @@ TRACE_EVENT(aoss_send,
 		__string(msg, msg)
 	),
 	TP_fast_assign(
-		__assign_str(msg, msg);
+		__assign_str(msg);
 	),
 	TP_printk("%s", __get_str(msg))
 );
@@ -31,7 +31,7 @@ TRACE_EVENT(aoss_send_done,
 		__field(int, ret)
 	),
 	TP_fast_assign(
-		__assign_str(msg, msg);
+		__assign_str(msg);
 		__entry->ret = ret;
 	),
 	TP_printk("%s: %d", __get_str(msg), __entry->ret)
diff --git a/drivers/soc/qcom/trace-rpmh.h b/drivers/soc/qcom/trace-rpmh.h
index be6b42ecc1f8..593ec1d4e010 100644
--- a/drivers/soc/qcom/trace-rpmh.h
+++ b/drivers/soc/qcom/trace-rpmh.h
@@ -26,7 +26,7 @@ TRACE_EVENT(rpmh_tx_done,
 	),
 
 	TP_fast_assign(
-		       __assign_str(name, d->name);
+		       __assign_str(name);
 		       __entry->m = m;
 		       __entry->addr = r->cmds[0].addr;
 		       __entry->data = r->cmds[0].data;
@@ -55,7 +55,7 @@ TRACE_EVENT(rpmh_send_msg,
 	),
 
 	TP_fast_assign(
-		       __assign_str(name, d->name);
+		       __assign_str(name);
 		       __entry->m = m;
 		       __entry->state = state;
 		       __entry->n = n;
diff --git a/drivers/thermal/thermal_trace.h b/drivers/thermal/thermal_trace.h
index 88a962f560f2..df8f4edd6068 100644
--- a/drivers/thermal/thermal_trace.h
+++ b/drivers/thermal/thermal_trace.h
@@ -37,7 +37,7 @@ TRACE_EVENT(thermal_temperature,
 	),
 
 	TP_fast_assign(
-		__assign_str(thermal_zone, tz->type);
+		__assign_str(thermal_zone);
 		__entry->id = tz->id;
 		__entry->temp_prev = tz->last_temperature;
 		__entry->temp = tz->temperature;
@@ -60,7 +60,7 @@ TRACE_EVENT(cdev_update,
 	),
 
 	TP_fast_assign(
-		__assign_str(type, cdev->type);
+		__assign_str(type);
 		__entry->target = target;
 	),
 
@@ -82,7 +82,7 @@ TRACE_EVENT(thermal_zone_trip,
 	),
 
 	TP_fast_assign(
-		__assign_str(thermal_zone, tz->type);
+		__assign_str(thermal_zone);
 		__entry->id = tz->id;
 		__entry->trip = trip;
 		__entry->trip_type = trip_type;
@@ -156,7 +156,7 @@ TRACE_EVENT(thermal_power_devfreq_get_power,
 	),
 
 	TP_fast_assign(
-		__assign_str(type, cdev->type);
+		__assign_str(type);
 		__entry->freq = freq;
 		__entry->busy_time = status->busy_time;
 		__entry->total_time = status->total_time;
@@ -184,7 +184,7 @@ TRACE_EVENT(thermal_power_devfreq_limit,
 	),
 
 	TP_fast_assign(
-		__assign_str(type, cdev->type);
+		__assign_str(type);
 		__entry->freq = freq;
 		__entry->cdev_state = cdev_state;
 		__entry->power = power;
diff --git a/drivers/usb/cdns3/cdns3-trace.h b/drivers/usb/cdns3/cdns3-trace.h
index 40db89e3333c..c4e542f1b9b7 100644
--- a/drivers/usb/cdns3/cdns3-trace.h
+++ b/drivers/usb/cdns3/cdns3-trace.h
@@ -33,7 +33,7 @@ TRACE_EVENT(cdns3_halt,
 		__field(u8, flush)
 	),
 	TP_fast_assign(
-		__assign_str(name, ep_priv->name);
+		__assign_str(name);
 		__entry->halt = halt;
 		__entry->flush = flush;
 	),
@@ -49,8 +49,8 @@ TRACE_EVENT(cdns3_wa1,
 		__string(msg, msg)
 	),
 	TP_fast_assign(
-		__assign_str(ep_name, ep_priv->name);
-		__assign_str(msg, msg);
+		__assign_str(ep_name);
+		__assign_str(msg);
 	),
 	TP_printk("WA1: %s %s", __get_str(ep_name), __get_str(msg))
 );
@@ -63,8 +63,8 @@ TRACE_EVENT(cdns3_wa2,
 		__string(msg, msg)
 	),
 	TP_fast_assign(
-		__assign_str(ep_name, ep_priv->name);
-		__assign_str(msg, msg);
+		__assign_str(ep_name);
+		__assign_str(msg);
 	),
 	TP_printk("WA2: %s %s", __get_str(ep_name), __get_str(msg))
 );
@@ -77,7 +77,7 @@ DECLARE_EVENT_CLASS(cdns3_log_doorbell,
 		__field(u32, ep_trbaddr)
 	),
 	TP_fast_assign(
-		__assign_str(name, ep_name);
+		__assign_str(name);
 		__entry->ep_trbaddr = ep_trbaddr;
 	),
 	TP_printk("%s, ep_trbaddr %08x", __get_str(name),
@@ -125,7 +125,7 @@ DECLARE_EVENT_CLASS(cdns3_log_epx_irq,
 		__field(u32, use_streams)
 	),
 	TP_fast_assign(
-		__assign_str(ep_name, priv_ep->name);
+		__assign_str(ep_name);
 		__entry->ep_sts = readl(&priv_dev->regs->ep_sts);
 		__entry->ep_traddr = readl(&priv_dev->regs->ep_traddr);
 		__entry->ep_last_sid = priv_ep->last_stream_id;
@@ -214,7 +214,7 @@ DECLARE_EVENT_CLASS(cdns3_log_request,
 		__field(unsigned int, stream_id)
 	),
 	TP_fast_assign(
-		__assign_str(name, req->priv_ep->name);
+		__assign_str(name);
 		__entry->req = req;
 		__entry->buf = req->request.buf;
 		__entry->actual = req->request.actual;
@@ -294,7 +294,7 @@ DECLARE_EVENT_CLASS(cdns3_stream_split_transfer_len,
 		__field(unsigned int, stream_id)
 	),
 	TP_fast_assign(
-		__assign_str(name, req->priv_ep->name);
+		__assign_str(name);
 		__entry->req = req;
 		__entry->actual = req->request.length;
 		__entry->length = req->request.actual;
@@ -329,7 +329,7 @@ DECLARE_EVENT_CLASS(cdns3_log_aligned_request,
 		__field(u32, aligned_buf_size)
 	),
 	TP_fast_assign(
-		__assign_str(name, priv_req->priv_ep->name);
+		__assign_str(name);
 		__entry->req = &priv_req->request;
 		__entry->buf = priv_req->request.buf;
 		__entry->dma = priv_req->request.dma;
@@ -364,7 +364,7 @@ DECLARE_EVENT_CLASS(cdns3_log_map_request,
 		__field(dma_addr_t, dma)
 	),
 	TP_fast_assign(
-		__assign_str(name, priv_req->priv_ep->name);
+		__assign_str(name);
 		__entry->req = &priv_req->request;
 		__entry->buf = priv_req->request.buf;
 		__entry->dma = priv_req->request.dma;
@@ -395,7 +395,7 @@ DECLARE_EVENT_CLASS(cdns3_log_trb,
 		__field(unsigned int, last_stream_id)
 	),
 	TP_fast_assign(
-		__assign_str(name, priv_ep->name);
+		__assign_str(name);
 		__entry->trb = trb;
 		__entry->buffer = le32_to_cpu(trb->buffer);
 		__entry->length = le32_to_cpu(trb->length);
@@ -467,7 +467,7 @@ DECLARE_EVENT_CLASS(cdns3_log_ep,
 		__field(u8, dequeue)
 	),
 	TP_fast_assign(
-		__assign_str(name, priv_ep->name);
+		__assign_str(name);
 		__entry->maxpacket = priv_ep->endpoint.maxpacket;
 		__entry->maxpacket_limit = priv_ep->endpoint.maxpacket_limit;
 		__entry->max_streams = priv_ep->endpoint.max_streams;
diff --git a/drivers/usb/cdns3/cdnsp-trace.h b/drivers/usb/cdns3/cdnsp-trace.h
index 4b51011eb00b..f2bcf77a5d0a 100644
--- a/drivers/usb/cdns3/cdnsp-trace.h
+++ b/drivers/usb/cdns3/cdnsp-trace.h
@@ -48,7 +48,7 @@ DECLARE_EVENT_CLASS(cdnsp_log_ep,
 		__field(u8, drbls_count)
 	),
 	TP_fast_assign(
-		__assign_str(name, pep->name);
+		__assign_str(name);
 		__entry->state = pep->ep_state;
 		__entry->stream_id = stream_id;
 		__entry->enabled = pep->ep_state & EP_HAS_STREAMS;
@@ -138,7 +138,7 @@ DECLARE_EVENT_CLASS(cdnsp_log_simple,
 		__string(text, msg)
 	),
 	TP_fast_assign(
-		__assign_str(text, msg);
+		__assign_str(text);
 	),
 	TP_printk("%s", __get_str(text))
 );
@@ -303,7 +303,7 @@ DECLARE_EVENT_CLASS(cdnsp_log_bounce,
 		__field(unsigned int, unalign)
 	),
 	TP_fast_assign(
-		__assign_str(name, preq->pep->name);
+		__assign_str(name);
 		__entry->new_buf_len = new_buf_len;
 		__entry->offset = offset;
 		__entry->dma = dma;
@@ -470,7 +470,7 @@ DECLARE_EVENT_CLASS(cdnsp_log_request,
 
 	),
 	TP_fast_assign(
-		__assign_str(name, req->pep->name);
+		__assign_str(name);
 		__entry->request = &req->request;
 		__entry->preq = req;
 		__entry->buf = req->request.buf;
@@ -674,7 +674,7 @@ DECLARE_EVENT_CLASS(cdnsp_log_td_info,
 		__field(dma_addr_t, trb_dma)
 	),
 	TP_fast_assign(
-		__assign_str(name, preq->pep->name);
+		__assign_str(name);
 		__entry->request = &preq->request;
 		__entry->preq = preq;
 		__entry->first_trb = preq->td.first_trb;
diff --git a/drivers/usb/chipidea/trace.h b/drivers/usb/chipidea/trace.h
index ca0e65b48f0a..1875419cd17f 100644
--- a/drivers/usb/chipidea/trace.h
+++ b/drivers/usb/chipidea/trace.h
@@ -31,7 +31,7 @@ TRACE_EVENT(ci_log,
 		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		__assign_str(name, dev_name(ci->dev));
+		__assign_str(name);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s: %s", __get_str(name), __get_str(msg))
@@ -51,7 +51,7 @@ DECLARE_EVENT_CLASS(ci_log_trb,
 		__field(u32, type)
 	),
 	TP_fast_assign(
-		__assign_str(name, hwep->name);
+		__assign_str(name);
 		__entry->req = &hwreq->req;
 		__entry->td = td;
 		__entry->dma = td->dma;
diff --git a/drivers/usb/dwc3/trace.h b/drivers/usb/dwc3/trace.h
index d2997d17cfbe..bdeb1aaf65d8 100644
--- a/drivers/usb/dwc3/trace.h
+++ b/drivers/usb/dwc3/trace.h
@@ -112,7 +112,7 @@ DECLARE_EVENT_CLASS(dwc3_log_request,
 		__field(int, no_interrupt)
 	),
 	TP_fast_assign(
-		__assign_str(name, req->dep->name);
+		__assign_str(name);
 		__entry->req = req;
 		__entry->actual = req->request.actual;
 		__entry->length = req->request.length;
@@ -193,7 +193,7 @@ DECLARE_EVENT_CLASS(dwc3_log_gadget_ep_cmd,
 		__field(int, cmd_status)
 	),
 	TP_fast_assign(
-		__assign_str(name, dep->name);
+		__assign_str(name);
 		__entry->cmd = cmd;
 		__entry->param0 = params->param0;
 		__entry->param1 = params->param1;
@@ -229,7 +229,7 @@ DECLARE_EVENT_CLASS(dwc3_log_trb,
 		__field(u32, dequeue)
 	),
 	TP_fast_assign(
-		__assign_str(name, dep->name);
+		__assign_str(name);
 		__entry->trb = trb;
 		__entry->bpl = trb->bpl;
 		__entry->bph = trb->bph;
@@ -301,7 +301,7 @@ DECLARE_EVENT_CLASS(dwc3_log_ep,
 		__field(u8, trb_dequeue)
 	),
 	TP_fast_assign(
-		__assign_str(name, dep->name);
+		__assign_str(name);
 		__entry->maxpacket = dep->endpoint.maxpacket;
 		__entry->maxpacket_limit = dep->endpoint.maxpacket_limit;
 		__entry->max_streams = dep->endpoint.max_streams;
diff --git a/drivers/usb/gadget/udc/cdns2/cdns2-trace.h b/drivers/usb/gadget/udc/cdns2/cdns2-trace.h
index 61f241634ea5..ade1752956b1 100644
--- a/drivers/usb/gadget/udc/cdns2/cdns2-trace.h
+++ b/drivers/usb/gadget/udc/cdns2/cdns2-trace.h
@@ -64,7 +64,7 @@ DECLARE_EVENT_CLASS(cdns2_log_simple,
 		__string(text, msg)
 	),
 	TP_fast_assign(
-		__assign_str(text, msg);
+		__assign_str(text);
 	),
 	TP_printk("%s", __get_str(text))
 );
@@ -103,7 +103,7 @@ TRACE_EVENT(cdns2_ep_halt,
 		__field(u8, flush)
 	),
 	TP_fast_assign(
-		__assign_str(name, ep_priv->name);
+		__assign_str(name);
 		__entry->halt = halt;
 		__entry->flush = flush;
 	),
@@ -119,8 +119,8 @@ TRACE_EVENT(cdns2_wa1,
 		__string(msg, msg)
 	),
 	TP_fast_assign(
-		__assign_str(ep_name, ep_priv->name);
-		__assign_str(msg, msg);
+		__assign_str(ep_name);
+		__assign_str(msg);
 	),
 	TP_printk("WA1: %s %s", __get_str(ep_name), __get_str(msg))
 );
@@ -134,7 +134,7 @@ DECLARE_EVENT_CLASS(cdns2_log_doorbell,
 		__field(u32, ep_trbaddr)
 	),
 	TP_fast_assign(
-		__assign_str(name, pep->name);
+		__assign_str(name);
 		__entry->ep_trbaddr = ep_trbaddr;
 	),
 	TP_printk("%s, ep_trbaddr %08x", __get_str(name),
@@ -196,7 +196,7 @@ DECLARE_EVENT_CLASS(cdns2_log_epx_irq,
 		__field(u32, ep_traddr)
 	),
 	TP_fast_assign(
-		__assign_str(ep_name, pep->name);
+		__assign_str(ep_name);
 		__entry->ep_sts = readl(&pdev->adma_regs->ep_sts);
 		__entry->ep_ists = readl(&pdev->adma_regs->ep_ists);
 		__entry->ep_traddr = readl(&pdev->adma_regs->ep_traddr);
@@ -288,7 +288,7 @@ DECLARE_EVENT_CLASS(cdns2_log_request,
 		__field(int, end_trb)
 	),
 	TP_fast_assign(
-		__assign_str(name, preq->pep->name);
+		__assign_str(name);
 		__entry->request = &preq->request;
 		__entry->preq = preq;
 		__entry->buf = preq->request.buf;
@@ -380,7 +380,7 @@ DECLARE_EVENT_CLASS(cdns2_log_map_request,
 		__field(dma_addr_t, dma)
 	),
 	TP_fast_assign(
-		__assign_str(name, priv_req->pep->name);
+		__assign_str(name);
 		__entry->req = &priv_req->request;
 		__entry->buf = priv_req->request.buf;
 		__entry->dma = priv_req->request.dma;
@@ -411,7 +411,7 @@ DECLARE_EVENT_CLASS(cdns2_log_trb,
 		__field(u32, type)
 	),
 	TP_fast_assign(
-		__assign_str(name, pep->name);
+		__assign_str(name);
 		__entry->trb = trb;
 		__entry->buffer = le32_to_cpu(trb->buffer);
 		__entry->length = le32_to_cpu(trb->length);
@@ -476,7 +476,7 @@ DECLARE_EVENT_CLASS(cdns2_log_ep,
 		__field(u8, dequeue)
 	),
 	TP_fast_assign(
-		__assign_str(name, pep->name);
+		__assign_str(name);
 		__entry->maxpacket = pep->endpoint.maxpacket;
 		__entry->maxpacket_limit = pep->endpoint.maxpacket_limit;
 		__entry->flags = pep->ep_state;
@@ -568,7 +568,7 @@ DECLARE_EVENT_CLASS(cdns2_log_epx_reg_config,
 		__field(u32, ep_cfg_reg)
 	),
 	TP_fast_assign(
-		__assign_str(ep_name, pep->name);
+		__assign_str(ep_name);
 		__entry->burst_size = pep->trb_burst_size;
 		__entry->maxpack_reg = pep->dir ? readw(&pdev->epx_regs->txmaxpack[pep->num - 1]) :
 						  readw(&pdev->epx_regs->rxmaxpack[pep->num - 1]);
diff --git a/drivers/usb/gadget/udc/trace.h b/drivers/usb/gadget/udc/trace.h
index a5ed26fbc2da..4e334298b0e8 100644
--- a/drivers/usb/gadget/udc/trace.h
+++ b/drivers/usb/gadget/udc/trace.h
@@ -157,7 +157,7 @@ DECLARE_EVENT_CLASS(udc_log_ep,
 		__field(int, ret)
 	),
 	TP_fast_assign(
-		__assign_str(name, ep->name);
+		__assign_str(name);
 		__entry->maxpacket = ep->maxpacket;
 		__entry->maxpacket_limit = ep->maxpacket_limit;
 		__entry->max_streams = ep->max_streams;
@@ -233,7 +233,7 @@ DECLARE_EVENT_CLASS(udc_log_req,
 		__field(struct usb_request *, req)
 	),
 	TP_fast_assign(
-		__assign_str(name, ep->name);
+		__assign_str(name);
 		__entry->length = req->length;
 		__entry->actual = req->actual;
 		__entry->num_sgs = req->num_sgs;
diff --git a/drivers/usb/mtu3/mtu3_trace.h b/drivers/usb/mtu3/mtu3_trace.h
index 03d2a9bac27e..89870175d635 100644
--- a/drivers/usb/mtu3/mtu3_trace.h
+++ b/drivers/usb/mtu3/mtu3_trace.h
@@ -26,7 +26,7 @@ TRACE_EVENT(mtu3_log,
 		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		__assign_str(name, dev_name(dev));
+		__assign_str(name);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s: %s", __get_str(name), __get_str(msg))
@@ -127,7 +127,7 @@ DECLARE_EVENT_CLASS(mtu3_log_request,
 		__field(int, no_interrupt)
 	),
 	TP_fast_assign(
-		__assign_str(name, mreq->mep->name);
+		__assign_str(name);
 		__entry->mreq = mreq;
 		__entry->gpd = mreq->gpd;
 		__entry->actual = mreq->request.actual;
@@ -182,7 +182,7 @@ DECLARE_EVENT_CLASS(mtu3_log_gpd,
 		__field(u32, dw3)
 	),
 	TP_fast_assign(
-		__assign_str(name, mep->name);
+		__assign_str(name);
 		__entry->gpd = gpd;
 		__entry->dw0 = le32_to_cpu(gpd->dw0_info);
 		__entry->dw1 = le32_to_cpu(gpd->next_gpd);
@@ -226,7 +226,7 @@ DECLARE_EVENT_CLASS(mtu3_log_ep,
 		__field(struct mtu3_gpd_ring *, gpd_ring)
 	),
 	TP_fast_assign(
-		__assign_str(name, mep->name);
+		__assign_str(name);
 		__entry->type = mep->type;
 		__entry->slot = mep->slot;
 		__entry->maxp = mep->ep.maxpacket;
diff --git a/drivers/usb/musb/musb_trace.h b/drivers/usb/musb/musb_trace.h
index f246b14394c4..726e6697d475 100644
--- a/drivers/usb/musb/musb_trace.h
+++ b/drivers/usb/musb/musb_trace.h
@@ -31,7 +31,7 @@ TRACE_EVENT(musb_log,
 		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		__assign_str(name, dev_name(musb->controller));
+		__assign_str(name);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 	TP_printk("%s: %s", __get_str(name), __get_str(msg))
@@ -46,9 +46,9 @@ TRACE_EVENT(musb_state,
 		__string(desc, desc)
 	),
 	TP_fast_assign(
-		__assign_str(name, dev_name(musb->controller));
+		__assign_str(name);
 		__entry->devctl = devctl;
-		__assign_str(desc, desc);
+		__assign_str(desc);
 	),
 	TP_printk("%s: devctl: %02x %s", __get_str(name), __entry->devctl,
 		  __get_str(desc))
@@ -160,7 +160,7 @@ TRACE_EVENT(musb_isr,
 		__field(u16, int_rx)
 	),
 	TP_fast_assign(
-		__assign_str(name, dev_name(musb->controller));
+		__assign_str(name);
 		__entry->int_usb = musb->int_usb;
 		__entry->int_tx = musb->int_tx;
 		__entry->int_rx = musb->int_rx;
@@ -184,7 +184,7 @@ DECLARE_EVENT_CLASS(musb_urb,
 		__field(u32, actual_len)
 	),
 	TP_fast_assign(
-		__assign_str(name, dev_name(musb->controller));
+		__assign_str(name);
 		__entry->urb = urb;
 		__entry->pipe = urb->pipe;
 		__entry->status = urb->status;
@@ -325,7 +325,7 @@ DECLARE_EVENT_CLASS(musb_cppi41,
 	),
 	TP_fast_assign(
 		__entry->ch = ch;
-		__assign_str(name, dev_name(ch->hw_ep->musb->controller));
+		__assign_str(name);
 		__entry->hwep = ch->hw_ep->epnum;
 		__entry->port = ch->port_num;
 		__entry->is_tx = ch->is_tx;
diff --git a/fs/bcachefs/trace.h b/fs/bcachefs/trace.h
index 6aa81d1e6d36..0b9774168b1d 100644
--- a/fs/bcachefs/trace.h
+++ b/fs/bcachefs/trace.h
@@ -43,7 +43,7 @@ DECLARE_EVENT_CLASS(fs_str,
 
 	TP_fast_assign(
 		__entry->dev		= c->dev;
-		__assign_str(str, str);
+		__assign_str(str);
 	),
 
 	TP_printk("%d,%d\n%s", MAJOR(__entry->dev), MINOR(__entry->dev), __get_str(str))
@@ -64,7 +64,7 @@ DECLARE_EVENT_CLASS(trans_str,
 		__entry->dev		= trans->c->dev;
 		strscpy(__entry->trans_fn, trans->fn, sizeof(__entry->trans_fn));
 		__entry->caller_ip		= caller_ip;
-		__assign_str(str, str);
+		__assign_str(str);
 	),
 
 	TP_printk("%d,%d %s %pS %s",
@@ -85,7 +85,7 @@ DECLARE_EVENT_CLASS(trans_str_nocaller,
 	TP_fast_assign(
 		__entry->dev		= trans->c->dev;
 		strscpy(__entry->trans_fn, trans->fn, sizeof(__entry->trans_fn));
-		__assign_str(str, str);
+		__assign_str(str);
 	),
 
 	TP_printk("%d,%d %s %s",
diff --git a/fs/nfs/nfs4trace.h b/fs/nfs/nfs4trace.h
index 10985a4b8259..4de8780a7c48 100644
--- a/fs/nfs/nfs4trace.h
+++ b/fs/nfs/nfs4trace.h
@@ -47,7 +47,7 @@ DECLARE_EVENT_CLASS(nfs4_clientid_event,
 
 		TP_fast_assign(
 			__entry->error = error < 0 ? -error : 0;
-			__assign_str(dstaddr, clp->cl_hostname);
+			__assign_str(dstaddr);
 		),
 
 		TP_printk(
@@ -94,8 +94,8 @@ TRACE_EVENT(nfs4_trunked_exchange_id,
 
 		TP_fast_assign(
 			__entry->error = error < 0 ? -error : 0;
-			__assign_str(main_addr, clp->cl_hostname);
-			__assign_str(trunk_addr, addr);
+			__assign_str(main_addr);
+			__assign_str(trunk_addr);
 		),
 
 		TP_printk(
@@ -365,7 +365,7 @@ TRACE_EVENT(nfs4_state_mgr,
 
 		TP_fast_assign(
 			__entry->state = clp->cl_state;
-			__assign_str(hostname, clp->cl_hostname);
+			__assign_str(hostname);
 		),
 
 		TP_printk(
@@ -393,8 +393,8 @@ TRACE_EVENT(nfs4_state_mgr_failed,
 		TP_fast_assign(
 			__entry->error = status < 0 ? -status : 0;
 			__entry->state = clp->cl_state;
-			__assign_str(hostname, clp->cl_hostname);
-			__assign_str(section, section);
+			__assign_str(hostname);
+			__assign_str(section);
 		),
 
 		TP_printk(
@@ -578,7 +578,7 @@ DECLARE_EVENT_CLASS(nfs4_open_event,
 				__entry->fhandle = 0;
 			}
 			__entry->dir = NFS_FILEID(d_inode(ctx->dentry->d_parent));
-			__assign_str(name, ctx->dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -1072,7 +1072,7 @@ DECLARE_EVENT_CLASS(nfs4_lookup_event,
 			__entry->dev = dir->i_sb->s_dev;
 			__entry->dir = NFS_FILEID(dir);
 			__entry->error = -error;
-			__assign_str(name, name->name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -1156,8 +1156,8 @@ TRACE_EVENT(nfs4_rename,
 			__entry->olddir = NFS_FILEID(olddir);
 			__entry->newdir = NFS_FILEID(newdir);
 			__entry->error = error < 0 ? -error : 0;
-			__assign_str(oldname, oldname->name);
-			__assign_str(newname, newname->name);
+			__assign_str(oldname);
+			__assign_str(newname);
 		),
 
 		TP_printk(
@@ -1359,7 +1359,7 @@ DECLARE_EVENT_CLASS(nfs4_inode_callback_event,
 				__entry->fileid = 0;
 				__entry->dev = 0;
 			}
-			__assign_str(dstaddr, clp ? clp->cl_hostname : "unknown");
+			__assign_str(dstaddr);
 		),
 
 		TP_printk(
@@ -1416,7 +1416,7 @@ DECLARE_EVENT_CLASS(nfs4_inode_stateid_callback_event,
 				__entry->fileid = 0;
 				__entry->dev = 0;
 			}
-			__assign_str(dstaddr, clp ? clp->cl_hostname : "unknown");
+			__assign_str(dstaddr);
 			__entry->stateid_seq =
 				be32_to_cpu(stateid->seqid);
 			__entry->stateid_hash =
@@ -1960,7 +1960,7 @@ DECLARE_EVENT_CLASS(nfs4_deviceid_event,
 		),
 
 		TP_fast_assign(
-			__assign_str(dstaddr, clp->cl_hostname);
+			__assign_str(dstaddr);
 			memcpy(__entry->deviceid, deviceid->data,
 			       NFS4_DEVICEID4_SIZE);
 		),
@@ -1998,7 +1998,7 @@ DECLARE_EVENT_CLASS(nfs4_deviceid_status,
 		TP_fast_assign(
 			__entry->dev = server->s_dev;
 			__entry->status = status;
-			__assign_str(dstaddr, server->nfs_client->cl_hostname);
+			__assign_str(dstaddr);
 			memcpy(__entry->deviceid, deviceid->data,
 			       NFS4_DEVICEID4_SIZE);
 		),
@@ -2036,8 +2036,8 @@ TRACE_EVENT(fl_getdevinfo,
 		),
 
 		TP_fast_assign(
-			__assign_str(mds_addr, server->nfs_client->cl_hostname);
-			__assign_str(ds_ips, ds_remotestr);
+			__assign_str(mds_addr);
+			__assign_str(ds_ips);
 			memcpy(__entry->deviceid, deviceid->data,
 			       NFS4_DEVICEID4_SIZE);
 		),
@@ -2083,9 +2083,7 @@ DECLARE_EVENT_CLASS(nfs4_flexfiles_io_event,
 				be32_to_cpu(hdr->args.stateid.seqid);
 			__entry->stateid_hash =
 				nfs_stateid_hash(&hdr->args.stateid);
-			__assign_str(dstaddr, hdr->ds_clp ?
-				rpc_peeraddr2str(hdr->ds_clp->cl_rpcclient,
-					RPC_DISPLAY_ADDR) : "unknown");
+			__assign_str(dstaddr);
 		),
 
 		TP_printk(
@@ -2139,9 +2137,7 @@ TRACE_EVENT(ff_layout_commit_error,
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->offset = data->args.offset;
 			__entry->count = data->args.count;
-			__assign_str(dstaddr, data->ds_clp ?
-				rpc_peeraddr2str(data->ds_clp->cl_rpcclient,
-					RPC_DISPLAY_ADDR) : "unknown");
+			__assign_str(dstaddr);
 		),
 
 		TP_printk(
@@ -2579,7 +2575,7 @@ DECLARE_EVENT_CLASS(nfs4_xattr_event,
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->fileid = NFS_FILEID(inode);
 			__entry->fhandle = nfs_fhandle_hash(NFS_FH(inode));
-			__assign_str(name, name);
+			__assign_str(name);
 		),
 
 		TP_printk(
diff --git a/fs/nfs/nfstrace.h b/fs/nfs/nfstrace.h
index afedb449b54f..1e710654af11 100644
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -409,7 +409,7 @@ DECLARE_EVENT_CLASS(nfs_lookup_event,
 			__entry->dir = NFS_FILEID(dir);
 			__entry->flags = flags;
 			__entry->fileid = d_is_negative(dentry) ? 0 : NFS_FILEID(d_inode(dentry));
-			__assign_str(name, dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -457,7 +457,7 @@ DECLARE_EVENT_CLASS(nfs_lookup_event_done,
 			__entry->error = error < 0 ? -error : 0;
 			__entry->flags = flags;
 			__entry->fileid = d_is_negative(dentry) ? 0 : NFS_FILEID(d_inode(dentry));
-			__assign_str(name, dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -512,7 +512,7 @@ TRACE_EVENT(nfs_atomic_open_enter,
 			__entry->dir = NFS_FILEID(dir);
 			__entry->flags = flags;
 			__entry->fmode = (__force unsigned long)ctx->mode;
-			__assign_str(name, ctx->dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -551,7 +551,7 @@ TRACE_EVENT(nfs_atomic_open_exit,
 			__entry->dir = NFS_FILEID(dir);
 			__entry->flags = flags;
 			__entry->fmode = (__force unsigned long)ctx->mode;
-			__assign_str(name, ctx->dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -587,7 +587,7 @@ TRACE_EVENT(nfs_create_enter,
 			__entry->dev = dir->i_sb->s_dev;
 			__entry->dir = NFS_FILEID(dir);
 			__entry->flags = flags;
-			__assign_str(name, dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -623,7 +623,7 @@ TRACE_EVENT(nfs_create_exit,
 			__entry->dev = dir->i_sb->s_dev;
 			__entry->dir = NFS_FILEID(dir);
 			__entry->flags = flags;
-			__assign_str(name, dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -654,7 +654,7 @@ DECLARE_EVENT_CLASS(nfs_directory_event,
 		TP_fast_assign(
 			__entry->dev = dir->i_sb->s_dev;
 			__entry->dir = NFS_FILEID(dir);
-			__assign_str(name, dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -693,7 +693,7 @@ DECLARE_EVENT_CLASS(nfs_directory_event_done,
 			__entry->dev = dir->i_sb->s_dev;
 			__entry->dir = NFS_FILEID(dir);
 			__entry->error = error < 0 ? -error : 0;
-			__assign_str(name, dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -747,7 +747,7 @@ TRACE_EVENT(nfs_link_enter,
 			__entry->dev = inode->i_sb->s_dev;
 			__entry->fileid = NFS_FILEID(inode);
 			__entry->dir = NFS_FILEID(dir);
-			__assign_str(name, dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -783,7 +783,7 @@ TRACE_EVENT(nfs_link_exit,
 			__entry->fileid = NFS_FILEID(inode);
 			__entry->dir = NFS_FILEID(dir);
 			__entry->error = error < 0 ? -error : 0;
-			__assign_str(name, dentry->d_name.name);
+			__assign_str(name);
 		),
 
 		TP_printk(
@@ -819,8 +819,8 @@ DECLARE_EVENT_CLASS(nfs_rename_event,
 			__entry->dev = old_dir->i_sb->s_dev;
 			__entry->old_dir = NFS_FILEID(old_dir);
 			__entry->new_dir = NFS_FILEID(new_dir);
-			__assign_str(old_name, old_dentry->d_name.name);
-			__assign_str(new_name, new_dentry->d_name.name);
+			__assign_str(old_name);
+			__assign_str(new_name);
 		),
 
 		TP_printk(
@@ -868,8 +868,8 @@ DECLARE_EVENT_CLASS(nfs_rename_event_done,
 			__entry->error = -error;
 			__entry->old_dir = NFS_FILEID(old_dir);
 			__entry->new_dir = NFS_FILEID(new_dir);
-			__assign_str(old_name, old_dentry->d_name.name);
-			__assign_str(new_name, new_dentry->d_name.name);
+			__assign_str(old_name);
+			__assign_str(new_name);
 		),
 
 		TP_printk(
@@ -1636,8 +1636,8 @@ TRACE_EVENT(nfs_mount_assign,
 	),
 
 	TP_fast_assign(
-		__assign_str(option, option);
-		__assign_str(value, value);
+		__assign_str(option);
+		__assign_str(value);
 	),
 
 	TP_printk("option %s=%s",
@@ -1657,7 +1657,7 @@ TRACE_EVENT(nfs_mount_option,
 	),
 
 	TP_fast_assign(
-		__assign_str(option, param->key);
+		__assign_str(option);
 	),
 
 	TP_printk("option %s", __get_str(option))
@@ -1675,7 +1675,7 @@ TRACE_EVENT(nfs_mount_path,
 	),
 
 	TP_fast_assign(
-		__assign_str(path, path);
+		__assign_str(path);
 	),
 
 	TP_printk("path='%s'", __get_str(path))
@@ -1710,9 +1710,8 @@ DECLARE_EVENT_CLASS(nfs_xdr_event,
 			__entry->xid = be32_to_cpu(rqstp->rq_xid);
 			__entry->version = task->tk_client->cl_vers;
 			__entry->error = error;
-			__assign_str(program,
-				     task->tk_client->cl_program->name);
-			__assign_str(procedure, task->tk_msg.rpc_proc->p_name);
+			__assign_str(program);
+			__assign_str(procedure);
 		),
 
 		TP_printk(SUNRPC_TRACE_TASK_SPECIFIER
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index 1cd2076210b1..023fee92a508 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -104,7 +104,7 @@ TRACE_EVENT(nfsd_compound,
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqst->rq_xid);
 		__entry->opcnt = opcnt;
-		__assign_str(tag, tag);
+		__assign_str(tag);
 	),
 	TP_printk("xid=0x%08x opcnt=%u tag=%s",
 		__entry->xid, __entry->opcnt, __get_str(tag)
@@ -127,7 +127,7 @@ TRACE_EVENT(nfsd_compound_status,
 		__entry->args_opcnt = args_opcnt;
 		__entry->resp_opcnt = resp_opcnt;
 		__entry->status = be32_to_cpu(status);
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 	TP_printk("op=%u/%u %s status=%d",
 		__entry->resp_opcnt, __entry->args_opcnt,
@@ -318,7 +318,7 @@ TRACE_EVENT(nfsd_exp_find_key,
 	TP_fast_assign(
 		__entry->fsidtype = key->ek_fsidtype;
 		memcpy(__entry->fsid, key->ek_fsid, 4*6);
-		__assign_str(auth_domain, key->ek_client->name);
+		__assign_str(auth_domain);
 		__entry->status = status;
 	),
 	TP_printk("fsid=%x::%s domain=%s status=%d",
@@ -342,8 +342,8 @@ TRACE_EVENT(nfsd_expkey_update,
 	TP_fast_assign(
 		__entry->fsidtype = key->ek_fsidtype;
 		memcpy(__entry->fsid, key->ek_fsid, 4*6);
-		__assign_str(auth_domain, key->ek_client->name);
-		__assign_str(path, exp_path);
+		__assign_str(auth_domain);
+		__assign_str(path);
 		__entry->cache = !test_bit(CACHE_NEGATIVE, &key->h.flags);
 	),
 	TP_printk("fsid=%x::%s domain=%s path=%s cache=%s",
@@ -365,8 +365,8 @@ TRACE_EVENT(nfsd_exp_get_by_name,
 		__field(int, status)
 	),
 	TP_fast_assign(
-		__assign_str(path, key->ex_path.dentry->d_name.name);
-		__assign_str(auth_domain, key->ex_client->name);
+		__assign_str(path);
+		__assign_str(auth_domain);
 		__entry->status = status;
 	),
 	TP_printk("path=%s domain=%s status=%d",
@@ -385,8 +385,8 @@ TRACE_EVENT(nfsd_export_update,
 		__field(bool, cache)
 	),
 	TP_fast_assign(
-		__assign_str(path, key->ex_path.dentry->d_name.name);
-		__assign_str(auth_domain, key->ex_client->name);
+		__assign_str(path);
+		__assign_str(auth_domain);
 		__entry->cache = !test_bit(CACHE_NEGATIVE, &key->h.flags);
 	),
 	TP_printk("path=%s domain=%s cache=%s",
@@ -485,7 +485,7 @@ TRACE_EVENT(nfsd_dirent,
 	TP_fast_assign(
 		__entry->fh_hash = fhp ? knfsd_fh_hash(&fhp->fh_handle) : 0;
 		__entry->ino = ino;
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 	TP_printk("fh_hash=0x%08x ino=%llu name=%s",
 		__entry->fh_hash, __entry->ino, __get_str(name)
@@ -906,7 +906,7 @@ DECLARE_EVENT_CLASS(nfsd_clid_class,
 		__entry->flavor = clp->cl_cred.cr_flavor;
 		memcpy(__entry->verifier, (void *)&clp->cl_verifier,
 		       NFS4_VERIFIER_SIZE);
-		__assign_str(name, clp->cl_name.data);
+		__assign_str(name);
 	),
 	TP_printk("addr=%pISpc name='%s' verifier=0x%s flavor=%s client=%08x:%08x",
 		__entry->addr, __get_str(name),
@@ -1425,7 +1425,7 @@ TRACE_EVENT(nfsd_cb_setup,
 	TP_fast_assign(
 		__entry->cl_boot = clp->cl_clientid.cl_boot;
 		__entry->cl_id = clp->cl_clientid.cl_id;
-		__assign_str(netid, netid);
+		__assign_str(netid);
 		__entry->authflavor = authflavor;
 		__assign_sockaddr(addr, &clp->cl_cb_conn.cb_addr,
 				  clp->cl_cb_conn.cb_addrlen)
@@ -1770,7 +1770,7 @@ TRACE_EVENT(nfsd_ctl_unlock_ip,
 	),
 	TP_fast_assign(
 		__entry->netns_ino = net->ns.inum;
-		__assign_str(address, address);
+		__assign_str(address);
 	),
 	TP_printk("address=%s",
 		__get_str(address)
@@ -1789,7 +1789,7 @@ TRACE_EVENT(nfsd_ctl_unlock_fs,
 	),
 	TP_fast_assign(
 		__entry->netns_ino = net->ns.inum;
-		__assign_str(path, path);
+		__assign_str(path);
 	),
 	TP_printk("path=%s",
 		__get_str(path)
@@ -1813,8 +1813,8 @@ TRACE_EVENT(nfsd_ctl_filehandle,
 	TP_fast_assign(
 		__entry->netns_ino = net->ns.inum;
 		__entry->maxsize = maxsize;
-		__assign_str(domain, domain);
-		__assign_str(path, path);
+		__assign_str(domain);
+		__assign_str(path);
 	),
 	TP_printk("domain=%s path=%s maxsize=%d",
 		__get_str(domain), __get_str(path), __entry->maxsize
@@ -1874,7 +1874,7 @@ TRACE_EVENT(nfsd_ctl_version,
 	),
 	TP_fast_assign(
 		__entry->netns_ino = net->ns.inum;
-		__assign_str(mesg, mesg);
+		__assign_str(mesg);
 	),
 	TP_printk("%s",
 		__get_str(mesg)
@@ -1915,7 +1915,7 @@ TRACE_EVENT(nfsd_ctl_ports_addxprt,
 	TP_fast_assign(
 		__entry->netns_ino = net->ns.inum;
 		__entry->port = port;
-		__assign_str(transport, transport);
+		__assign_str(transport);
 	),
 	TP_printk("transport=%s port=%d",
 		__get_str(transport), __entry->port
@@ -1976,7 +1976,7 @@ TRACE_EVENT(nfsd_ctl_time,
 	TP_fast_assign(
 		__entry->netns_ino = net->ns.inum;
 		__entry->time = time;
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 	TP_printk("file=%s time=%d\n",
 		__get_str(name), __entry->time
@@ -1995,7 +1995,7 @@ TRACE_EVENT(nfsd_ctl_recoverydir,
 	),
 	TP_fast_assign(
 		__entry->netns_ino = net->ns.inum;
-		__assign_str(recdir, recdir);
+		__assign_str(recdir);
 	),
 	TP_printk("recdir=%s",
 		__get_str(recdir)
diff --git a/fs/ocfs2/ocfs2_trace.h b/fs/ocfs2/ocfs2_trace.h
index 9898c11bdfa1..60e208b01c8d 100644
--- a/fs/ocfs2/ocfs2_trace.h
+++ b/fs/ocfs2/ocfs2_trace.h
@@ -82,7 +82,7 @@ DECLARE_EVENT_CLASS(ocfs2__string,
 		__string(name,name)
 	),
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 	TP_printk("%s", __get_str(name))
 );
@@ -1289,7 +1289,7 @@ DECLARE_EVENT_CLASS(ocfs2__file_ops,
 		__entry->dentry = dentry;
 		__entry->ino = ino;
 		__entry->d_len = d_len;
-		__assign_str(d_name, d_name);
+		__assign_str(d_name);
 		__entry->para = para;
 	),
 	TP_printk("%p %p %p %llu %llu %.*s", __entry->inode, __entry->file,
@@ -1425,7 +1425,7 @@ TRACE_EVENT(ocfs2_setattr,
 		__entry->dentry = dentry;
 		__entry->ino = ino;
 		__entry->d_len = d_len;
-		__assign_str(d_name, d_name);
+		__assign_str(d_name);
 		__entry->ia_valid = ia_valid;
 		__entry->ia_mode = ia_mode;
 		__entry->ia_uid = ia_uid;
@@ -1683,7 +1683,7 @@ TRACE_EVENT(ocfs2_parse_options,
 	),
 	TP_fast_assign(
 		__entry->is_remount = is_remount;
-		__assign_str(options, options);
+		__assign_str(options);
 	),
 	TP_printk("%d %s", __entry->is_remount, __get_str(options))
 );
@@ -1718,8 +1718,8 @@ TRACE_EVENT(ocfs2_initialize_super,
 		__field(int, cluster_bits)
 	),
 	TP_fast_assign(
-		__assign_str(label, label);
-		__assign_str(uuid_str, uuid_str);
+		__assign_str(label);
+		__assign_str(uuid_str);
 		__entry->root_dir = root_dir;
 		__entry->system_dir = system_dir;
 		__entry->cluster_bits = cluster_bits;
@@ -1746,7 +1746,7 @@ TRACE_EVENT(ocfs2_init_xattr_set_ctxt,
 		__field(int, credits)
 	),
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->meta = meta;
 		__entry->clusters = clusters;
 		__entry->credits = credits;
@@ -1770,7 +1770,7 @@ DECLARE_EVENT_CLASS(ocfs2__xattr_find,
 	),
 	TP_fast_assign(
 		__entry->ino = ino;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->name_index = name_index;
 		__entry->hash = hash;
 		__entry->location = location;
@@ -2019,7 +2019,7 @@ TRACE_EVENT(ocfs2_sync_dquot_helper,
 		__entry->dq_id = dq_id;
 		__entry->dq_type = dq_type;
 		__entry->type = type;
-		__assign_str(s_id, s_id);
+		__assign_str(s_id);
 	),
 	TP_printk("%u %u %lu %s", __entry->dq_id, __entry->dq_type,
 		  __entry->type, __get_str(s_id))
@@ -2060,7 +2060,7 @@ TRACE_EVENT(ocfs2_dx_dir_search,
 	TP_fast_assign(
 		__entry->ino = ino;
 		__entry->namelen = namelen;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->major_hash = major_hash;
 		__entry->minor_hash = minor_hash;
 		__entry->blkno = blkno;
@@ -2088,7 +2088,7 @@ TRACE_EVENT(ocfs2_find_files_on_disk,
 	),
 	TP_fast_assign(
 		__entry->namelen = namelen;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->blkno = blkno;
 		__entry->dir = dir;
 	),
@@ -2107,7 +2107,7 @@ TRACE_EVENT(ocfs2_check_dir_for_entry,
 	TP_fast_assign(
 		__entry->dir = dir;
 		__entry->namelen = namelen;
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 	TP_printk("%llu %.*s", __entry->dir,
 		  __entry->namelen, __get_str(name))
@@ -2135,7 +2135,7 @@ TRACE_EVENT(ocfs2_dx_dir_index_root_block,
 		__entry->major_hash = major_hash;
 		__entry->minor_hash = minor_hash;
 		__entry->namelen = namelen;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->num_used = num_used;
 	),
 	TP_printk("%llu %x %x %.*s %u", __entry->dir,
@@ -2171,7 +2171,7 @@ DECLARE_EVENT_CLASS(ocfs2__dentry_ops,
 		__entry->dir = dir;
 		__entry->dentry = dentry;
 		__entry->name_len = name_len;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->dir_blkno = dir_blkno;
 		__entry->extra = extra;
 	),
@@ -2217,7 +2217,7 @@ TRACE_EVENT(ocfs2_mknod,
 		__entry->dir = dir;
 		__entry->dentry = dentry;
 		__entry->name_len = name_len;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->dir_blkno = dir_blkno;
 		__entry->dev = dev;
 		__entry->mode = mode;
@@ -2241,9 +2241,9 @@ TRACE_EVENT(ocfs2_link,
 	TP_fast_assign(
 		__entry->ino = ino;
 		__entry->old_len = old_len;
-		__assign_str(old_name, old_name);
+		__assign_str(old_name);
 		__entry->name_len = name_len;
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 	TP_printk("%llu %.*s %.*s", __entry->ino,
 		  __entry->old_len, __get_str(old_name),
@@ -2279,9 +2279,9 @@ TRACE_EVENT(ocfs2_rename,
 		__entry->new_dir = new_dir;
 		__entry->new_dentry = new_dentry;
 		__entry->old_len = old_len;
-		__assign_str(old_name, old_name);
+		__assign_str(old_name);
 		__entry->new_len = new_len;
-		__assign_str(new_name, new_name);
+		__assign_str(new_name);
 	),
 	TP_printk("%p %p %p %p %.*s %.*s",
 		  __entry->old_dir, __entry->old_dentry,
@@ -2301,7 +2301,7 @@ TRACE_EVENT(ocfs2_rename_target_exists,
 	),
 	TP_fast_assign(
 		__entry->new_len = new_len;
-		__assign_str(new_name, new_name);
+		__assign_str(new_name);
 	),
 	TP_printk("%.*s", __entry->new_len, __get_str(new_name))
 );
@@ -2344,7 +2344,7 @@ TRACE_EVENT(ocfs2_symlink_begin,
 		__entry->dentry = dentry;
 		__entry->symname = symname;
 		__entry->len = len;
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 	TP_printk("%p %p %s %.*s", __entry->dir, __entry->dentry,
 		  __entry->symname, __entry->len, __get_str(name))
@@ -2360,7 +2360,7 @@ TRACE_EVENT(ocfs2_blkno_stringify,
 	),
 	TP_fast_assign(
 		__entry->blkno = blkno;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->namelen = namelen;
 	),
 	TP_printk("%llu %s %d", __entry->blkno, __get_str(name),
@@ -2381,7 +2381,7 @@ TRACE_EVENT(ocfs2_orphan_del,
 	),
 	TP_fast_assign(
 		__entry->dir = dir;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->namelen = namelen;
 	),
 	TP_printk("%llu %s %d", __entry->dir, __get_str(name),
@@ -2403,7 +2403,7 @@ TRACE_EVENT(ocfs2_dentry_revalidate,
 	TP_fast_assign(
 		__entry->dentry = dentry;
 		__entry->len = len;
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 	TP_printk("%p %.*s", __entry->dentry, __entry->len, __get_str(name))
 );
@@ -2420,7 +2420,7 @@ TRACE_EVENT(ocfs2_dentry_revalidate_negative,
 	),
 	TP_fast_assign(
 		__entry->len = len;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->pgen = pgen;
 		__entry->gen = gen;
 	),
@@ -2445,7 +2445,7 @@ TRACE_EVENT(ocfs2_find_local_alias,
 	),
 	TP_fast_assign(
 		__entry->len = len;
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 	TP_printk("%.*s", __entry->len, __get_str(name))
 );
@@ -2462,7 +2462,7 @@ TRACE_EVENT(ocfs2_dentry_attach_lock,
 	),
 	TP_fast_assign(
 		__entry->len = len;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->parent = parent;
 		__entry->fsdata = fsdata;
 	),
@@ -2480,7 +2480,7 @@ TRACE_EVENT(ocfs2_dentry_attach_lock_found,
 		__field(unsigned long long, ino)
 	),
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->parent = parent;
 		__entry->ino = ino;
 	),
@@ -2527,7 +2527,7 @@ TRACE_EVENT(ocfs2_get_parent,
 	TP_fast_assign(
 		__entry->child = child;
 		__entry->len = len;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->ino = ino;
 	),
 	TP_printk("%p %.*s %llu", __entry->child, __entry->len,
@@ -2551,7 +2551,7 @@ TRACE_EVENT(ocfs2_encode_fh_begin,
 	TP_fast_assign(
 		__entry->dentry = dentry;
 		__entry->name_len = name_len;
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->fh = fh;
 		__entry->len = len;
 		__entry->connectable = connectable;
diff --git a/fs/smb/client/trace.h b/fs/smb/client/trace.h
index af97389e983e..36d47ce59631 100644
--- a/fs/smb/client/trace.h
+++ b/fs/smb/client/trace.h
@@ -518,7 +518,7 @@ DECLARE_EVENT_CLASS(smb3_inf_compound_enter_class,
 		__entry->xid = xid;
 		__entry->tid = tid;
 		__entry->sesid = sesid;
-		__assign_str(path, full_path);
+		__assign_str(path);
 	),
 	TP_printk("xid=%u sid=0x%llx tid=0x%x path=%s",
 		__entry->xid, __entry->sesid, __entry->tid,
@@ -762,7 +762,7 @@ DECLARE_EVENT_CLASS(smb3_exit_err_class,
 	),
 	TP_fast_assign(
 		__entry->xid = xid;
-		__assign_str(func_name, func_name);
+		__assign_str(func_name);
 		__entry->rc = rc;
 	),
 	TP_printk("\t%s: xid=%u rc=%d",
@@ -815,7 +815,7 @@ DECLARE_EVENT_CLASS(smb3_enter_exit_class,
 	),
 	TP_fast_assign(
 		__entry->xid = xid;
-		__assign_str(func_name, func_name);
+		__assign_str(func_name);
 	),
 	TP_printk("\t%s: xid=%u",
 		__get_str(func_name), __entry->xid)
@@ -852,7 +852,7 @@ DECLARE_EVENT_CLASS(smb3_tcon_class,
 		__entry->xid = xid;
 		__entry->tid = tid;
 		__entry->sesid = sesid;
-		__assign_str(name, unc_name);
+		__assign_str(name);
 		__entry->rc = rc;
 	),
 	TP_printk("xid=%u sid=0x%llx tid=0x%x unc_name=%s rc=%d",
@@ -896,7 +896,7 @@ DECLARE_EVENT_CLASS(smb3_open_enter_class,
 		__entry->xid = xid;
 		__entry->tid = tid;
 		__entry->sesid = sesid;
-		__assign_str(path, full_path);
+		__assign_str(path);
 		__entry->create_options = create_options;
 		__entry->desired_access = desired_access;
 	),
@@ -1098,7 +1098,7 @@ DECLARE_EVENT_CLASS(smb3_connect_class,
 		__entry->conn_id = conn_id;
 		pss = (struct sockaddr_storage *)__entry->dst_addr;
 		*pss = *dst_addr;
-		__assign_str(hostname, hostname);
+		__assign_str(hostname);
 	),
 	TP_printk("conn_id=0x%llx server=%s addr=%pISpsfc",
 		__entry->conn_id,
@@ -1134,7 +1134,7 @@ DECLARE_EVENT_CLASS(smb3_connect_err_class,
 		__entry->rc = rc;
 		pss = (struct sockaddr_storage *)__entry->dst_addr;
 		*pss = *dst_addr;
-		__assign_str(hostname, hostname);
+		__assign_str(hostname);
 	),
 	TP_printk("rc=%d conn_id=0x%llx server=%s addr=%pISpsfc",
 		__entry->rc,
@@ -1166,7 +1166,7 @@ DECLARE_EVENT_CLASS(smb3_reconnect_class,
 	TP_fast_assign(
 		__entry->currmid = currmid;
 		__entry->conn_id = conn_id;
-		__assign_str(hostname, hostname);
+		__assign_str(hostname);
 	),
 	TP_printk("conn_id=0x%llx server=%s current_mid=%llu",
 		__entry->conn_id,
@@ -1255,7 +1255,7 @@ DECLARE_EVENT_CLASS(smb3_credit_class,
 	TP_fast_assign(
 		__entry->currmid = currmid;
 		__entry->conn_id = conn_id;
-		__assign_str(hostname, hostname);
+		__assign_str(hostname);
 		__entry->credits = credits;
 		__entry->credits_to_add = credits_to_add;
 		__entry->in_flight = in_flight;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 5b294be52c55..2f728fc493d7 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -475,7 +475,7 @@ TRACE_EVENT(xchk_btree_op_error,
 
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->type = sc->sm->sm_type;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
@@ -518,7 +518,7 @@ TRACE_EVENT(xchk_ifork_btree_op_error,
 		__entry->ino = sc->ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->level = level;
 		__entry->ptr = cur->bc_levels[level].ptr;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
@@ -558,7 +558,7 @@ TRACE_EVENT(xchk_btree_error,
 		xfs_fsblock_t fsbno = xchk_btree_cur_fsbno(cur, level);
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->type = sc->sm->sm_type;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
@@ -598,7 +598,7 @@ TRACE_EVENT(xchk_ifork_btree_error,
 		__entry->ino = sc->ip->i_ino;
 		__entry->whichfork = cur->bc_ino.whichfork;
 		__entry->type = sc->sm->sm_type;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->level = level;
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
@@ -637,7 +637,7 @@ DECLARE_EVENT_CLASS(xchk_sbtree_class,
 
 		__entry->dev = sc->mp->m_super->s_dev;
 		__entry->type = sc->sm->sm_type;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp, fsbno);
 		__entry->bno = XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno);
 		__entry->level = level;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index aea97fc074f8..3032b56dcdc3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -159,7 +159,7 @@ TRACE_EVENT(xlog_intent_recovery_failed,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__assign_str(name, ops->name);
+		__assign_str(name);
 		__entry->error = error;
 	),
 	TP_printk("dev %d:%d optype %s error %d",
@@ -1905,7 +1905,7 @@ TRACE_EVENT(xfs_alloc_cur_check,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->bno = bno;
 		__entry->len = len;
 		__entry->diff = diff;
@@ -2467,7 +2467,7 @@ DECLARE_EVENT_CLASS(xfs_btree_cur_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
 		__entry->ptr = cur->bc_levels[level].ptr;
@@ -2517,7 +2517,7 @@ TRACE_EVENT(xfs_btree_alloc_block,
 			__entry->ino = 0;
 			break;
 		}
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->error = error;
 		if (!error && stat) {
 			if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN) {
@@ -2561,7 +2561,7 @@ TRACE_EVENT(xfs_btree_free_block,
 			__entry->ino = cur->bc_ino.ip->i_ino;
 		else
 			__entry->ino = 0;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->agbno = xfs_daddr_to_agbno(cur->bc_mp,
 							xfs_buf_daddr(bp));
 	),
@@ -2637,7 +2637,7 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
-		__assign_str(name, dfp->dfp_ops->name);
+		__assign_str(name);
 		__entry->intent = dfp->dfp_intent;
 		__entry->flags = dfp->dfp_flags;
 		__entry->committed = dfp->dfp_done != NULL;
@@ -2726,7 +2726,7 @@ DECLARE_EVENT_CLASS(xfs_defer_pending_item_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp ? mp->m_super->s_dev : 0;
-		__assign_str(name, dfp->dfp_ops->name);
+		__assign_str(name);
 		__entry->intent = dfp->dfp_intent;
 		__entry->item = item;
 		__entry->committed = dfp->dfp_done != NULL;
@@ -4239,7 +4239,7 @@ TRACE_EVENT(xfs_btree_commit_afakeroot,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->agbno = cur->bc_ag.afake->af_root;
 		__entry->levels = cur->bc_ag.afake->af_levels;
@@ -4268,7 +4268,7 @@ TRACE_EVENT(xfs_btree_commit_ifakeroot,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->agno = XFS_INO_TO_AGNO(cur->bc_mp,
 					cur->bc_ino.ip->i_ino);
 		__entry->agino = XFS_INO_TO_AGINO(cur->bc_mp,
@@ -4307,7 +4307,7 @@ TRACE_EVENT(xfs_btree_bload_level_geometry,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->level = level;
 		__entry->nlevels = cur->bc_nlevels;
 		__entry->nr_this_level = nr_this_level;
@@ -4345,7 +4345,7 @@ TRACE_EVENT(xfs_btree_bload_block,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__assign_str(name, cur->bc_ops->name);
+		__assign_str(name);
 		__entry->level = level;
 		__entry->block_idx = block_idx;
 		__entry->nr_blocks = nr_blocks;
@@ -4568,7 +4568,7 @@ TRACE_EVENT(xfs_force_shutdown,
 		__entry->dev = mp->m_super->s_dev;
 		__entry->ptag = ptag;
 		__entry->flags = flags;
-		__assign_str(fname, fname);
+		__assign_str(fname);
 		__entry->line_num = line_num;
 	),
 	TP_printk("dev %d:%d tag %s flags %s file %s line_num %d",
@@ -4750,7 +4750,7 @@ DECLARE_EVENT_CLASS(xfbtree_freesp_class,
 	),
 	TP_fast_assign(
 		__entry->xfino = file_inode(xfbt->target->bt_file)->i_ino;
-		__assign_str(btname, cur->bc_ops->name);
+		__assign_str(btname);
 		__entry->nlevels = cur->bc_nlevels;
 		__entry->fileoff = fileoff;
 	),
diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index c011ea236e9b..7c47151d5c72 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -61,7 +61,7 @@ TRACE_EVENT(extlog_mem_event,
 		else
 			__entry->pa_mask_lsb = ~0;
 		__entry->fru_id = *fru_id;
-		__assign_str(fru_text, fru_text);
+		__assign_str(fru_text);
 		cper_mem_err_pack(mem, &__entry->data);
 	),
 
@@ -131,8 +131,8 @@ TRACE_EVENT(mc_event,
 
 	TP_fast_assign(
 		__entry->error_type		= err_type;
-		__assign_str(msg, error_msg);
-		__assign_str(label, label);
+		__assign_str(msg);
+		__assign_str(label);
 		__entry->error_count		= error_count;
 		__entry->mc_index		= mc_index;
 		__entry->top_layer		= top_layer;
@@ -141,7 +141,7 @@ TRACE_EVENT(mc_event,
 		__entry->address		= address;
 		__entry->grain_bits		= grain_bits;
 		__entry->syndrome		= syndrome;
-		__assign_str(driver_detail, driver_detail);
+		__assign_str(driver_detail);
 	),
 
 	TP_printk("%d %s error%s:%s%s on %s (mc:%d location:%d:%d:%d address:0x%08lx grain:%d syndrome:0x%08lx%s%s)",
@@ -239,7 +239,7 @@ TRACE_EVENT(non_standard_event,
 	TP_fast_assign(
 		memcpy(__entry->sec_type, sec_type, UUID_SIZE);
 		memcpy(__entry->fru_id, fru_id, UUID_SIZE);
-		__assign_str(fru_text, fru_text);
+		__assign_str(fru_text);
 		__entry->sev = sev;
 		__entry->len = len;
 		memcpy(__get_dynamic_array(buf), err, len);
@@ -313,7 +313,7 @@ TRACE_EVENT(aer_event,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
+		__assign_str(dev_name);
 		__entry->status		= status;
 		__entry->severity	= severity;
 		__entry->tlp_header_valid = tlp_header_valid;
diff --git a/include/trace/events/asoc.h b/include/trace/events/asoc.h
index 4eed9028bb11..c33dcb556ae0 100644
--- a/include/trace/events/asoc.h
+++ b/include/trace/events/asoc.h
@@ -30,8 +30,8 @@ DECLARE_EVENT_CLASS(snd_soc_dapm,
 	),
 
 	TP_fast_assign(
-		__assign_str(card_name, dapm->card->name);
-		__assign_str(comp_name, dapm->component ? dapm->component->name : "(none)");
+		__assign_str(card_name);
+		__assign_str(comp_name);
 		__entry->val = val;
 	),
 
@@ -67,7 +67,7 @@ DECLARE_EVENT_CLASS(snd_soc_dapm_basic,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, card->name);
+		__assign_str(name);
 		__entry->event = event;
 	),
 
@@ -102,7 +102,7 @@ DECLARE_EVENT_CLASS(snd_soc_dapm_widget,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, w->name);
+		__assign_str(name);
 		__entry->val = val;
 	),
 
@@ -148,7 +148,7 @@ TRACE_EVENT(snd_soc_dapm_walk_done,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, card->name);
+		__assign_str(name);
 		__entry->power_checks = card->dapm_stats.power_checks;
 		__entry->path_checks = card->dapm_stats.path_checks;
 		__entry->neighbour_checks = card->dapm_stats.neighbour_checks;
@@ -177,9 +177,9 @@ TRACE_EVENT(snd_soc_dapm_path,
 	),
 
 	TP_fast_assign(
-		__assign_str(wname, widget->name);
-		__assign_str(pname, path->name ? path->name : DAPM_DIRECT);
-		__assign_str(pnname, path->node[dir]->name);
+		__assign_str(wname);
+		__assign_str(pname);
+		__assign_str(pnname);
 		__entry->path_connect = path->connect;
 		__entry->path_node = (long)path->node[dir];
 		__entry->path_dir = dir;
@@ -224,7 +224,7 @@ TRACE_EVENT(snd_soc_jack_irq,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 
 	TP_printk("%s", __get_str(name))
@@ -243,7 +243,7 @@ TRACE_EVENT(snd_soc_jack_report,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, jack->jack->id);
+		__assign_str(name);
 		__entry->mask = mask;
 		__entry->val = val;
 	),
@@ -264,7 +264,7 @@ TRACE_EVENT(snd_soc_jack_notify,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, jack->jack->id);
+		__assign_str(name);
 		__entry->val = val;
 	),
 
diff --git a/include/trace/events/avc.h b/include/trace/events/avc.h
index b55fda2e0773..fed0f141d5f6 100644
--- a/include/trace/events/avc.h
+++ b/include/trace/events/avc.h
@@ -36,9 +36,9 @@ TRACE_EVENT(selinux_audited,
 		__entry->denied		= sad->denied;
 		__entry->audited	= sad->audited;
 		__entry->result		= sad->result;
-		__assign_str(tcontext, tcontext);
-		__assign_str(scontext, scontext);
-		__assign_str(tclass, tclass);
+		__assign_str(tcontext);
+		__assign_str(scontext);
+		__assign_str(tclass);
 	),
 
 	TP_printk("requested=0x%x denied=0x%x audited=0x%x result=%d scontext=%s tcontext=%s tclass=%s",
diff --git a/include/trace/events/bridge.h b/include/trace/events/bridge.h
index a6b3a4e409f0..3fe4725c83ff 100644
--- a/include/trace/events/bridge.h
+++ b/include/trace/events/bridge.h
@@ -25,7 +25,7 @@ TRACE_EVENT(br_fdb_add,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, dev->name);
+		__assign_str(dev);
 		memcpy(__entry->addr, addr, ETH_ALEN);
 		__entry->vid = vid;
 		__entry->nlh_flags = nlh_flags;
@@ -54,8 +54,8 @@ TRACE_EVENT(br_fdb_external_learn_add,
 	),
 
 	TP_fast_assign(
-		__assign_str(br_dev, br->dev->name);
-		__assign_str(dev, p ? p->dev->name : "null");
+		__assign_str(br_dev);
+		__assign_str(dev);
 		memcpy(__entry->addr, addr, ETH_ALEN);
 		__entry->vid = vid;
 	),
@@ -80,8 +80,8 @@ TRACE_EVENT(fdb_delete,
 	),
 
 	TP_fast_assign(
-		__assign_str(br_dev, br->dev->name);
-		__assign_str(dev, f->dst ? f->dst->dev->name : "null");
+		__assign_str(br_dev);
+		__assign_str(dev);
 		memcpy(__entry->addr, f->key.addr.addr, ETH_ALEN);
 		__entry->vid = f->key.vlan_id;
 	),
@@ -108,8 +108,8 @@ TRACE_EVENT(br_fdb_update,
 	),
 
 	TP_fast_assign(
-		__assign_str(br_dev, br->dev->name);
-		__assign_str(dev, source->dev->name);
+		__assign_str(br_dev);
+		__assign_str(dev);
 		memcpy(__entry->addr, addr, ETH_ALEN);
 		__entry->vid = vid;
 		__entry->flags = flags;
@@ -141,7 +141,7 @@ TRACE_EVENT(br_mdb_full,
 	TP_fast_assign(
 		struct in6_addr *in6;
 
-		__assign_str(dev, dev->name);
+		__assign_str(dev);
 		__entry->vid = group->vid;
 
 		if (!group->proto) {
diff --git a/include/trace/events/btrfs.h b/include/trace/events/btrfs.h
index d2d94d7c3fb5..fadf406b5260 100644
--- a/include/trace/events/btrfs.h
+++ b/include/trace/events/btrfs.h
@@ -1140,7 +1140,7 @@ TRACE_EVENT(btrfs_space_reservation,
 	),
 
 	TP_fast_assign_btrfs(fs_info,
-		__assign_str(type, type);
+		__assign_str(type);
 		__entry->val		= val;
 		__entry->bytes		= bytes;
 		__entry->reserve	= reserve;
@@ -1169,7 +1169,7 @@ TRACE_EVENT(btrfs_trigger_flush,
 		__entry->flags	= flags;
 		__entry->bytes	= bytes;
 		__entry->flush	= flush;
-		__assign_str(reason, reason);
+		__assign_str(reason);
 	),
 
 	TP_printk_btrfs("%s: flush=%d(%s) flags=%llu(%s) bytes=%llu",
@@ -1622,7 +1622,7 @@ DECLARE_EVENT_CLASS(btrfs_workqueue,
 
 	TP_fast_assign_btrfs(btrfs_workqueue_owner(wq),
 		__entry->wq		= wq;
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 
 	TP_printk_btrfs("name=%s wq=%p", __get_str(name),
diff --git a/include/trace/events/cgroup.h b/include/trace/events/cgroup.h
index dd7d7c9efecd..ff2e8eca9c91 100644
--- a/include/trace/events/cgroup.h
+++ b/include/trace/events/cgroup.h
@@ -23,7 +23,7 @@ DECLARE_EVENT_CLASS(cgroup_root,
 	TP_fast_assign(
 		__entry->root = root->hierarchy_id;
 		__entry->ss_mask = root->subsys_mask;
-		__assign_str(name, root->name);
+		__assign_str(name);
 	),
 
 	TP_printk("root=%d ss_mask=%#x name=%s",
@@ -68,7 +68,7 @@ DECLARE_EVENT_CLASS(cgroup,
 		__entry->root = cgrp->root->hierarchy_id;
 		__entry->id = cgroup_id(cgrp);
 		__entry->level = cgrp->level;
-		__assign_str(path, path);
+		__assign_str(path);
 	),
 
 	TP_printk("root=%d id=%llu level=%d path=%s",
@@ -137,9 +137,9 @@ DECLARE_EVENT_CLASS(cgroup_migrate,
 		__entry->dst_root = dst_cgrp->root->hierarchy_id;
 		__entry->dst_id = cgroup_id(dst_cgrp);
 		__entry->dst_level = dst_cgrp->level;
-		__assign_str(dst_path, path);
+		__assign_str(dst_path);
 		__entry->pid = task->pid;
-		__assign_str(comm, task->comm);
+		__assign_str(comm);
 	),
 
 	TP_printk("dst_root=%d dst_id=%llu dst_level=%d dst_path=%s pid=%d comm=%s",
@@ -181,7 +181,7 @@ DECLARE_EVENT_CLASS(cgroup_event,
 		__entry->root = cgrp->root->hierarchy_id;
 		__entry->id = cgroup_id(cgrp);
 		__entry->level = cgrp->level;
-		__assign_str(path, path);
+		__assign_str(path);
 		__entry->val = val;
 	),
 
diff --git a/include/trace/events/clk.h b/include/trace/events/clk.h
index daed3c7a48c1..759f7371a6dc 100644
--- a/include/trace/events/clk.h
+++ b/include/trace/events/clk.h
@@ -23,7 +23,7 @@ DECLARE_EVENT_CLASS(clk,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, core->name);
+		__assign_str(name);
 	),
 
 	TP_printk("%s", __get_str(name))
@@ -97,7 +97,7 @@ DECLARE_EVENT_CLASS(clk_rate,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, core->name);
+		__assign_str(name);
 		__entry->rate = rate;
 	),
 
@@ -145,7 +145,7 @@ DECLARE_EVENT_CLASS(clk_rate_range,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, core->name);
+		__assign_str(name);
 		__entry->min = min;
 		__entry->max = max;
 	),
@@ -174,8 +174,8 @@ DECLARE_EVENT_CLASS(clk_parent,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, core->name);
-		__assign_str(pname, parent ? parent->name : "none");
+		__assign_str(name);
+		__assign_str(pname);
 	),
 
 	TP_printk("%s %s", __get_str(name), __get_str(pname))
@@ -207,7 +207,7 @@ DECLARE_EVENT_CLASS(clk_phase,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, core->name);
+		__assign_str(name);
 		__entry->phase = phase;
 	),
 
@@ -241,7 +241,7 @@ DECLARE_EVENT_CLASS(clk_duty_cycle,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, core->name);
+		__assign_str(name);
 		__entry->num = duty->num;
 		__entry->den = duty->den;
 	),
@@ -279,8 +279,8 @@ DECLARE_EVENT_CLASS(clk_rate_request,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, req->core ? req->core->name : "none");
-		__assign_str(pname, req->best_parent_hw ? clk_hw_get_name(req->best_parent_hw) : "none");
+		__assign_str(name);
+		__assign_str(pname);
 		__entry->min = req->min_rate;
 		__entry->max = req->max_rate;
 		__entry->prate = req->best_parent_rate;
diff --git a/include/trace/events/cma.h b/include/trace/events/cma.h
index 25103e67737c..383c09f583ac 100644
--- a/include/trace/events/cma.h
+++ b/include/trace/events/cma.h
@@ -23,7 +23,7 @@ TRACE_EVENT(cma_release,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->pfn = pfn;
 		__entry->page = page;
 		__entry->count = count;
@@ -49,7 +49,7 @@ TRACE_EVENT(cma_alloc_start,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->count = count;
 		__entry->align = align;
 	),
@@ -77,7 +77,7 @@ TRACE_EVENT(cma_alloc_finish,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->pfn = pfn;
 		__entry->page = page;
 		__entry->count = count;
@@ -110,7 +110,7 @@ TRACE_EVENT(cma_alloc_busy_retry,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->pfn = pfn;
 		__entry->page = page;
 		__entry->count = count;
diff --git a/include/trace/events/devfreq.h b/include/trace/events/devfreq.h
index 7627c620bbda..6cbc4d59fd96 100644
--- a/include/trace/events/devfreq.h
+++ b/include/trace/events/devfreq.h
@@ -23,7 +23,7 @@ TRACE_EVENT(devfreq_frequency,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name(&devfreq->dev));
+		__assign_str(dev_name);
 		__entry->freq = freq;
 		__entry->prev_freq = prev_freq;
 		__entry->busy_time = devfreq->last_status.busy_time;
@@ -54,7 +54,7 @@ TRACE_EVENT(devfreq_monitor,
 		__entry->busy_time = devfreq->last_status.busy_time;
 		__entry->total_time = devfreq->last_status.total_time;
 		__entry->polling_ms = devfreq->profile->polling_ms;
-		__assign_str(dev_name, dev_name(&devfreq->dev));
+		__assign_str(dev_name);
 	),
 
 	TP_printk("dev_name=%-30s freq=%-12lu polling_ms=%-3u load=%-2lu",
diff --git a/include/trace/events/devlink.h b/include/trace/events/devlink.h
index 77ff7cfc6049..f241e204fe6b 100644
--- a/include/trace/events/devlink.h
+++ b/include/trace/events/devlink.h
@@ -31,9 +31,9 @@ TRACE_EVENT(devlink_hwmsg,
 	),
 
 	TP_fast_assign(
-		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
-		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
-		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
+		__assign_str(bus_name);
+		__assign_str(dev_name);
+		__assign_str(driver_name);
 		__entry->incoming = incoming;
 		__entry->type = type;
 		memcpy(__get_dynamic_array(buf), buf, len);
@@ -63,11 +63,11 @@ TRACE_EVENT(devlink_hwerr,
 		),
 
 	TP_fast_assign(
-		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
-		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
-		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
+		__assign_str(bus_name);
+		__assign_str(dev_name);
+		__assign_str(driver_name);
 		__entry->err = err;
-		__assign_str(msg, msg);
+		__assign_str(msg);
 		),
 
 	TP_printk("bus_name=%s dev_name=%s driver_name=%s err=%d %s",
@@ -93,11 +93,11 @@ TRACE_EVENT(devlink_health_report,
 	),
 
 	TP_fast_assign(
-		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
-		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
-		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
-		__assign_str(reporter_name, reporter_name);
-		__assign_str(msg, msg);
+		__assign_str(bus_name);
+		__assign_str(dev_name);
+		__assign_str(driver_name);
+		__assign_str(reporter_name);
+		__assign_str(msg);
 	),
 
 	TP_printk("bus_name=%s dev_name=%s driver_name=%s reporter_name=%s: %s",
@@ -125,10 +125,10 @@ TRACE_EVENT(devlink_health_recover_aborted,
 	),
 
 	TP_fast_assign(
-		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
-		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
-		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
-		__assign_str(reporter_name, reporter_name);
+		__assign_str(bus_name);
+		__assign_str(dev_name);
+		__assign_str(driver_name);
+		__assign_str(reporter_name);
 		__entry->health_state = health_state;
 		__entry->time_since_last_recover = time_since_last_recover;
 	),
@@ -158,10 +158,10 @@ TRACE_EVENT(devlink_health_reporter_state_update,
 	),
 
 	TP_fast_assign(
-		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
-		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
-		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
-		__assign_str(reporter_name, reporter_name);
+		__assign_str(bus_name);
+		__assign_str(dev_name);
+		__assign_str(driver_name);
+		__assign_str(reporter_name);
 		__entry->new_state = new_state;
 	),
 
@@ -192,11 +192,11 @@ TRACE_EVENT(devlink_trap_report,
 	TP_fast_assign(
 		struct net_device *input_dev = metadata->input_dev;
 
-		__assign_str(bus_name, devlink_to_dev(devlink)->bus->name);
-		__assign_str(dev_name, dev_name(devlink_to_dev(devlink)));
-		__assign_str(driver_name, devlink_to_dev(devlink)->driver->name);
-		__assign_str(trap_name, metadata->trap_name);
-		__assign_str(trap_group_name, metadata->trap_group_name);
+		__assign_str(bus_name);
+		__assign_str(dev_name);
+		__assign_str(driver_name);
+		__assign_str(trap_name);
+		__assign_str(trap_group_name);
 		strscpy(__entry->input_dev_name, input_dev ? input_dev->name : "NULL", IFNAMSIZ);
 	),
 
diff --git a/include/trace/events/dma_fence.h b/include/trace/events/dma_fence.h
index 3963e79ca7b4..a4de3df8500b 100644
--- a/include/trace/events/dma_fence.h
+++ b/include/trace/events/dma_fence.h
@@ -23,8 +23,8 @@ DECLARE_EVENT_CLASS(dma_fence,
 	),
 
 	TP_fast_assign(
-		__assign_str(driver, fence->ops->get_driver_name(fence));
-		__assign_str(timeline, fence->ops->get_timeline_name(fence));
+		__assign_str(driver);
+		__assign_str(timeline);
 		__entry->context = fence->context;
 		__entry->seqno = fence->seqno;
 	),
diff --git a/include/trace/events/erofs.h b/include/trace/events/erofs.h
index e18684b02c3d..b9bbfd855f2a 100644
--- a/include/trace/events/erofs.h
+++ b/include/trace/events/erofs.h
@@ -47,7 +47,7 @@ TRACE_EVENT(erofs_lookup,
 	TP_fast_assign(
 		__entry->dev	= dir->i_sb->s_dev;
 		__entry->nid	= EROFS_I(dir)->nid;
-		__assign_str(name, dentry->d_name.name);
+		__assign_str(name);
 		__entry->flags	= flags;
 	),
 
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index 7ed0fc430dc6..5c688edb8143 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -354,7 +354,7 @@ TRACE_EVENT(f2fs_unlink_enter,
 		__entry->ino	= dir->i_ino;
 		__entry->size	= dir->i_size;
 		__entry->blocks	= dir->i_blocks;
-		__assign_str(name, dentry->d_name.name);
+		__assign_str(name);
 	),
 
 	TP_printk("dev = (%d,%d), dir ino = %lu, i_size = %lld, "
@@ -843,7 +843,7 @@ TRACE_EVENT(f2fs_lookup_start,
 	TP_fast_assign(
 		__entry->dev	= dir->i_sb->s_dev;
 		__entry->ino	= dir->i_ino;
-		__assign_str(name, dentry->d_name.name);
+		__assign_str(name);
 		__entry->flags	= flags;
 	),
 
@@ -871,7 +871,7 @@ TRACE_EVENT(f2fs_lookup_end,
 	TP_fast_assign(
 		__entry->dev	= dir->i_sb->s_dev;
 		__entry->ino	= dir->i_ino;
-		__assign_str(name, dentry->d_name.name);
+		__assign_str(name);
 		__entry->cino	= ino;
 		__entry->err	= err;
 	),
@@ -903,9 +903,9 @@ TRACE_EVENT(f2fs_rename_start,
 	TP_fast_assign(
 		__entry->dev		= old_dir->i_sb->s_dev;
 		__entry->ino		= old_dir->i_ino;
-		__assign_str(old_name, old_dentry->d_name.name);
+		__assign_str(old_name);
 		__entry->new_pino	= new_dir->i_ino;
-		__assign_str(new_name, new_dentry->d_name.name);
+		__assign_str(new_name);
 		__entry->flags		= flags;
 	),
 
@@ -937,8 +937,8 @@ TRACE_EVENT(f2fs_rename_end,
 	TP_fast_assign(
 		__entry->dev		= old_dentry->d_sb->s_dev;
 		__entry->ino		= old_dentry->d_inode->i_ino;
-		__assign_str(old_name, old_dentry->d_name.name);
-		__assign_str(new_name, new_dentry->d_name.name);
+		__assign_str(old_name);
+		__assign_str(new_name);
 		__entry->flags		= flags;
 		__entry->ret		= ret;
 	),
@@ -1557,7 +1557,7 @@ TRACE_EVENT(f2fs_write_checkpoint,
 	TP_fast_assign(
 		__entry->dev		= sb->s_dev;
 		__entry->reason		= reason;
-		__assign_str(dest_msg, msg);
+		__assign_str(dest_msg);
 	),
 
 	TP_printk("dev = (%d,%d), checkpoint for %s, state = %s",
@@ -2333,12 +2333,12 @@ DECLARE_EVENT_CLASS(f2fs__rw_start,
 		 * because this screws up the tooling that parses
 		 * the traces.
 		 */
-		__assign_str(pathbuf, pathname);
+		__assign_str(pathbuf);
 		(void)strreplace(__get_str(pathbuf), ' ', '_');
 		__entry->offset = offset;
 		__entry->bytes = bytes;
 		__entry->i_size = i_size_read(inode);
-		__assign_str(cmdline, command);
+		__assign_str(cmdline);
 		(void)strreplace(__get_str(cmdline), ' ', '_');
 		__entry->pid = pid;
 		__entry->ino = inode->i_ino;
diff --git a/include/trace/events/habanalabs.h b/include/trace/events/habanalabs.h
index a78d21fa9f29..4a2bb2c896d1 100644
--- a/include/trace/events/habanalabs.h
+++ b/include/trace/events/habanalabs.h
@@ -27,7 +27,7 @@ DECLARE_EVENT_CLASS(habanalabs_mmu_template,
 	),
 
 	TP_fast_assign(
-		__assign_str(dname, dev_name(dev));
+		__assign_str(dname);
 		__entry->virt_addr = virt_addr;
 		__entry->phys_addr = phys_addr;
 		__entry->page_size = page_size;
@@ -64,7 +64,7 @@ DECLARE_EVENT_CLASS(habanalabs_dma_alloc_template,
 	),
 
 	TP_fast_assign(
-		__assign_str(dname, dev_name(dev));
+		__assign_str(dname);
 		__entry->cpu_addr = cpu_addr;
 		__entry->dma_addr = dma_addr;
 		__entry->size = size;
@@ -103,7 +103,7 @@ DECLARE_EVENT_CLASS(habanalabs_dma_map_template,
 	),
 
 	TP_fast_assign(
-		__assign_str(dname, dev_name(dev));
+		__assign_str(dname);
 		__entry->phys_addr = phys_addr;
 		__entry->dma_addr = dma_addr;
 		__entry->len = len;
@@ -141,7 +141,7 @@ DECLARE_EVENT_CLASS(habanalabs_comms_template,
 	),
 
 	TP_fast_assign(
-		__assign_str(dname, dev_name(dev));
+		__assign_str(dname);
 		__entry->op_str = op_str;
 	),
 
@@ -178,7 +178,7 @@ DECLARE_EVENT_CLASS(habanalabs_reg_access_template,
 	),
 
 	TP_fast_assign(
-		__assign_str(dname, dev_name(dev));
+		__assign_str(dname);
 		__entry->addr = addr;
 		__entry->val = val;
 	),
diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 6e2ef1d4b002..0e32fc35d758 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -191,7 +191,7 @@ TRACE_EVENT(mm_khugepaged_scan_file,
 	TP_fast_assign(
 		__entry->mm = mm;
 		__entry->pfn = page ? page_to_pfn(page) : -1;
-		__assign_str(filename, file->f_path.dentry->d_iname);
+		__assign_str(filename);
 		__entry->present = present;
 		__entry->swap = swap;
 		__entry->result = result;
@@ -228,7 +228,7 @@ TRACE_EVENT(mm_khugepaged_collapse_file,
 		__entry->index = index;
 		__entry->addr = addr;
 		__entry->is_shmem = is_shmem;
-		__assign_str(filename, file->f_path.dentry->d_iname);
+		__assign_str(filename);
 		__entry->nr = nr;
 		__entry->result = result;
 	),
diff --git a/include/trace/events/hwmon.h b/include/trace/events/hwmon.h
index d7a1d0ffb679..d1ff560cd9b5 100644
--- a/include/trace/events/hwmon.h
+++ b/include/trace/events/hwmon.h
@@ -21,7 +21,7 @@ DECLARE_EVENT_CLASS(hwmon_attr_class,
 
 	TP_fast_assign(
 		__entry->index = index;
-		__assign_str(attr_name, attr_name);
+		__assign_str(attr_name);
 		__entry->val = val;
 	),
 
@@ -57,8 +57,8 @@ TRACE_EVENT(hwmon_attr_show_string,
 
 	TP_fast_assign(
 		__entry->index = index;
-		__assign_str(attr_name, attr_name);
-		__assign_str(label, s);
+		__assign_str(attr_name);
+		__assign_str(label);
 	),
 
 	TP_printk("index=%d, attr_name=%s, val=%s",
diff --git a/include/trace/events/initcall.h b/include/trace/events/initcall.h
index eb903c3f195f..5282afdf3ddf 100644
--- a/include/trace/events/initcall.h
+++ b/include/trace/events/initcall.h
@@ -18,7 +18,7 @@ TRACE_EVENT(initcall_level,
 	),
 
 	TP_fast_assign(
-		__assign_str(level, level);
+		__assign_str(level);
 	),
 
 	TP_printk("level=%s", __get_str(level))
diff --git a/include/trace/events/intel_ish.h b/include/trace/events/intel_ish.h
index e6d7ff55ee8c..64b6612c41bc 100644
--- a/include/trace/events/intel_ish.h
+++ b/include/trace/events/intel_ish.h
@@ -18,7 +18,7 @@ TRACE_EVENT(ishtp_dump,
 	),
 
 	TP_fast_assign(
-		__assign_str(message, message);
+		__assign_str(message);
 	),
 
 	TP_printk("%s", __get_str(message))
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index e948df7ce625..412c9c210a32 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -164,7 +164,7 @@ TRACE_EVENT(io_uring_queue_async_work,
 		__entry->work		= &req->work;
 		__entry->rw		= rw;
 
-		__assign_str(op_str, io_uring_get_opcode(req->opcode));
+		__assign_str(op_str);
 	),
 
 	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, flags 0x%llx, %s queue, work %p",
@@ -202,7 +202,7 @@ TRACE_EVENT(io_uring_defer,
 		__entry->data	= req->cqe.user_data;
 		__entry->opcode	= req->opcode;
 
-		__assign_str(op_str, io_uring_get_opcode(req->opcode));
+		__assign_str(op_str);
 	),
 
 	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s",
@@ -303,7 +303,7 @@ TRACE_EVENT(io_uring_fail_link,
 		__entry->opcode		= req->opcode;
 		__entry->link		= link;
 
-		__assign_str(op_str, io_uring_get_opcode(req->opcode));
+		__assign_str(op_str);
 	),
 
 	TP_printk("ring %p, request %p, user_data 0x%llx, opcode %s, link %p",
@@ -392,7 +392,7 @@ TRACE_EVENT(io_uring_submit_req,
 		__entry->flags		= (__force unsigned long long) req->flags;
 		__entry->sq_thread	= req->ctx->flags & IORING_SETUP_SQPOLL;
 
-		__assign_str(op_str, io_uring_get_opcode(req->opcode));
+		__assign_str(op_str);
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, flags 0x%llx, "
@@ -436,7 +436,7 @@ TRACE_EVENT(io_uring_poll_arm,
 		__entry->mask		= mask;
 		__entry->events		= events;
 
-		__assign_str(op_str, io_uring_get_opcode(req->opcode));
+		__assign_str(op_str);
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, mask 0x%x, events 0x%x",
@@ -475,7 +475,7 @@ TRACE_EVENT(io_uring_task_add,
 		__entry->opcode		= req->opcode;
 		__entry->mask		= mask;
 
-		__assign_str(op_str, io_uring_get_opcode(req->opcode));
+		__assign_str(op_str);
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, opcode %s, mask %x",
@@ -538,7 +538,7 @@ TRACE_EVENT(io_uring_req_failed,
 		__entry->addr3		= sqe->addr3;
 		__entry->error		= error;
 
-		__assign_str(op_str, io_uring_get_opcode(sqe->opcode));
+		__assign_str(op_str);
 	),
 
 	TP_printk("ring %p, req %p, user_data 0x%llx, "
diff --git a/include/trace/events/iocost.h b/include/trace/events/iocost.h
index af8bfed528fc..e772b1bc60d6 100644
--- a/include/trace/events/iocost.h
+++ b/include/trace/events/iocost.h
@@ -34,8 +34,8 @@ DECLARE_EVENT_CLASS(iocost_iocg_state,
 	),
 
 	TP_fast_assign(
-		__assign_str(devname, ioc_name(iocg->ioc));
-		__assign_str(cgroup, path);
+		__assign_str(devname);
+		__assign_str(cgroup);
 		__entry->now = now->now;
 		__entry->vnow = now->vnow;
 		__entry->vrate = iocg->ioc->vtime_base_rate;
@@ -93,8 +93,8 @@ DECLARE_EVENT_CLASS(iocg_inuse_update,
 	),
 
 	TP_fast_assign(
-		__assign_str(devname, ioc_name(iocg->ioc));
-		__assign_str(cgroup, path);
+		__assign_str(devname);
+		__assign_str(cgroup);
 		__entry->now = now->now;
 		__entry->old_inuse = old_inuse;
 		__entry->new_inuse = new_inuse;
@@ -159,7 +159,7 @@ TRACE_EVENT(iocost_ioc_vrate_adj,
 	),
 
 	TP_fast_assign(
-		__assign_str(devname, ioc_name(ioc));
+		__assign_str(devname);
 		__entry->old_vrate = ioc->vtime_base_rate;
 		__entry->new_vrate = new_vrate;
 		__entry->busy_level = ioc->busy_level;
@@ -200,8 +200,8 @@ TRACE_EVENT(iocost_iocg_forgive_debt,
 	),
 
 	TP_fast_assign(
-		__assign_str(devname, ioc_name(iocg->ioc));
-		__assign_str(cgroup, path);
+		__assign_str(devname);
+		__assign_str(cgroup);
 		__entry->now = now->now;
 		__entry->vnow = now->vnow;
 		__entry->usage_pct = usage_pct;
diff --git a/include/trace/events/iommu.h b/include/trace/events/iommu.h
index 70743db1fb75..373007e567cb 100644
--- a/include/trace/events/iommu.h
+++ b/include/trace/events/iommu.h
@@ -28,7 +28,7 @@ DECLARE_EVENT_CLASS(iommu_group_event,
 
 	TP_fast_assign(
 		__entry->gid = group_id;
-		__assign_str(device, dev_name(dev));
+		__assign_str(device);
 	),
 
 	TP_printk("IOMMU: groupID=%d device=%s",
@@ -62,7 +62,7 @@ DECLARE_EVENT_CLASS(iommu_device_event,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(dev));
+		__assign_str(device);
 	),
 
 	TP_printk("IOMMU: device=%s", __get_str(device)
@@ -138,8 +138,8 @@ DECLARE_EVENT_CLASS(iommu_error,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(dev));
-		__assign_str(driver, dev_driver_string(dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->iova = iova;
 		__entry->flags = flags;
 	),
diff --git a/include/trace/events/irq.h b/include/trace/events/irq.h
index a07b4607b663..837c1740d0d0 100644
--- a/include/trace/events/irq.h
+++ b/include/trace/events/irq.h
@@ -63,7 +63,7 @@ TRACE_EVENT(irq_handler_entry,
 
 	TP_fast_assign(
 		__entry->irq = irq;
-		__assign_str(name, action->name);
+		__assign_str(name);
 	),
 
 	TP_printk("irq=%d name=%s", __entry->irq, __get_str(name))
diff --git a/include/trace/events/iscsi.h b/include/trace/events/iscsi.h
index 8ff2a3ca5d75..990fd154f586 100644
--- a/include/trace/events/iscsi.h
+++ b/include/trace/events/iscsi.h
@@ -30,7 +30,7 @@ DECLARE_EVENT_CLASS(iscsi_log_msg,
 	),
 
 	TP_fast_assign(
-		__assign_str(dname, dev_name(dev));
+		__assign_str(dname);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 
diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 6e62cc64cd92..8a829e0f6e55 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -126,7 +126,7 @@ TRACE_EVENT(kmem_cache_free,
 	TP_fast_assign(
 		__entry->call_site	= call_site;
 		__entry->ptr		= ptr;
-		__assign_str(name, s->name);
+		__assign_str(name);
 	),
 
 	TP_printk("call_site=%pS ptr=%p name=%s",
diff --git a/include/trace/events/lock.h b/include/trace/events/lock.h
index 9ebd081e057e..8e89baa3775f 100644
--- a/include/trace/events/lock.h
+++ b/include/trace/events/lock.h
@@ -37,7 +37,7 @@ TRACE_EVENT(lock_acquire,
 
 	TP_fast_assign(
 		__entry->flags = (trylock ? 1 : 0) | (read ? 2 : 0);
-		__assign_str(name, lock->name);
+		__assign_str(name);
 		__entry->lockdep_addr = lock;
 	),
 
@@ -59,7 +59,7 @@ DECLARE_EVENT_CLASS(lock,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, lock->name);
+		__assign_str(name);
 		__entry->lockdep_addr = lock;
 	),
 
diff --git a/include/trace/events/mmap_lock.h b/include/trace/events/mmap_lock.h
index 14db8044c1ff..f2827f98a44f 100644
--- a/include/trace/events/mmap_lock.h
+++ b/include/trace/events/mmap_lock.h
@@ -27,7 +27,7 @@ DECLARE_EVENT_CLASS(mmap_lock,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__assign_str(memcg_path, memcg_path);
+		__assign_str(memcg_path);
 		__entry->write = write;
 	),
 
@@ -65,7 +65,7 @@ TRACE_EVENT_FN(mmap_lock_acquire_returned,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__assign_str(memcg_path, memcg_path);
+		__assign_str(memcg_path);
 		__entry->write = write;
 		__entry->success = success;
 	),
diff --git a/include/trace/events/mmc.h b/include/trace/events/mmc.h
index 7b706ff21335..f1c2e94f7f68 100644
--- a/include/trace/events/mmc.h
+++ b/include/trace/events/mmc.h
@@ -68,7 +68,7 @@ TRACE_EVENT(mmc_request_start,
 		__entry->need_retune = host->need_retune;
 		__entry->hold_retune = host->hold_retune;
 		__entry->retune_period = host->retune_period;
-		__assign_str(name, mmc_hostname(host));
+		__assign_str(name);
 		__entry->mrq = mrq;
 	),
 
@@ -156,7 +156,7 @@ TRACE_EVENT(mmc_request_done,
 		__entry->need_retune = host->need_retune;
 		__entry->hold_retune = host->hold_retune;
 		__entry->retune_period = host->retune_period;
-		__assign_str(name, mmc_hostname(host));
+		__assign_str(name);
 		__entry->mrq = mrq;
 	),
 
diff --git a/include/trace/events/module.h b/include/trace/events/module.h
index 097485c73c01..e5a006be9dc6 100644
--- a/include/trace/events/module.h
+++ b/include/trace/events/module.h
@@ -41,7 +41,7 @@ TRACE_EVENT(module_load,
 
 	TP_fast_assign(
 		__entry->taints = mod->taints;
-		__assign_str(name, mod->name);
+		__assign_str(name);
 	),
 
 	TP_printk("%s %s", __get_str(name), show_module_flags(__entry->taints))
@@ -58,7 +58,7 @@ TRACE_EVENT(module_free,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, mod->name);
+		__assign_str(name);
 	),
 
 	TP_printk("%s", __get_str(name))
@@ -82,7 +82,7 @@ DECLARE_EVENT_CLASS(module_refcnt,
 	TP_fast_assign(
 		__entry->ip	= ip;
 		__entry->refcnt	= atomic_read(&mod->refcnt);
-		__assign_str(name, mod->name);
+		__assign_str(name);
 	),
 
 	TP_printk("%s call_site=%ps refcnt=%d",
@@ -119,7 +119,7 @@ TRACE_EVENT(module_request,
 	TP_fast_assign(
 		__entry->ip	= ip;
 		__entry->wait	= wait;
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 
 	TP_printk("%s wait=%d call_site=%ps",
diff --git a/include/trace/events/napi.h b/include/trace/events/napi.h
index dc03cf8e0369..b567b9ffedc1 100644
--- a/include/trace/events/napi.h
+++ b/include/trace/events/napi.h
@@ -26,7 +26,7 @@ TRACE_EVENT(napi_poll,
 
 	TP_fast_assign(
 		__entry->napi = napi;
-		__assign_str(dev_name, napi->dev ? napi->dev->name : NO_DEV);
+		__assign_str(dev_name);
 		__entry->work = work;
 		__entry->budget = budget;
 	),
diff --git a/include/trace/events/neigh.h b/include/trace/events/neigh.h
index 833143d0992e..12362c35dbc0 100644
--- a/include/trace/events/neigh.h
+++ b/include/trace/events/neigh.h
@@ -42,7 +42,7 @@ TRACE_EVENT(neigh_create,
 		__be32 *p32;
 
 		__entry->family = tbl->family;
-		__assign_str(dev, (dev ? dev->name : "NULL"));
+		__assign_str(dev);
 		__entry->entries = atomic_read(&tbl->gc_entries);
 		__entry->created = n != NULL;
 		__entry->gc_exempt = exempt_from_gc;
@@ -103,7 +103,7 @@ TRACE_EVENT(neigh_update,
 		__be32 *p32;
 
 		__entry->family = n->tbl->family;
-		__assign_str(dev, (n->dev ? n->dev->name : "NULL"));
+		__assign_str(dev);
 		__entry->lladdr_len = lladdr_len;
 		memcpy(__entry->lladdr, n->ha, lladdr_len);
 		__entry->flags = n->flags;
@@ -180,7 +180,7 @@ DECLARE_EVENT_CLASS(neigh__update,
 		__be32 *p32;
 
 		__entry->family = n->tbl->family;
-		__assign_str(dev, (n->dev ? n->dev->name : "NULL"));
+		__assign_str(dev);
 		__entry->lladdr_len = lladdr_len;
 		memcpy(__entry->lladdr, n->ha, lladdr_len);
 		__entry->flags = n->flags;
diff --git a/include/trace/events/net.h b/include/trace/events/net.h
index f667c76a3b02..d55162c12f90 100644
--- a/include/trace/events/net.h
+++ b/include/trace/events/net.h
@@ -38,7 +38,7 @@ TRACE_EVENT(net_dev_start_xmit,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, dev->name);
+		__assign_str(name);
 		__entry->queue_mapping = skb->queue_mapping;
 		__entry->skbaddr = skb;
 		__entry->vlan_tagged = skb_vlan_tag_present(skb);
@@ -89,7 +89,7 @@ TRACE_EVENT(net_dev_xmit,
 		__entry->skbaddr = skb;
 		__entry->len = skb_len;
 		__entry->rc = rc;
-		__assign_str(name, dev->name);
+		__assign_str(name);
 	),
 
 	TP_printk("dev=%s skbaddr=%p len=%u rc=%d",
@@ -110,8 +110,8 @@ TRACE_EVENT(net_dev_xmit_timeout,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, dev->name);
-		__assign_str(driver, netdev_drivername(dev));
+		__assign_str(name);
+		__assign_str(driver);
 		__entry->queue_index = queue_index;
 	),
 
@@ -134,7 +134,7 @@ DECLARE_EVENT_CLASS(net_dev_template,
 	TP_fast_assign(
 		__entry->skbaddr = skb;
 		__entry->len = skb->len;
-		__assign_str(name, skb->dev->name);
+		__assign_str(name);
 	),
 
 	TP_printk("dev=%s skbaddr=%p len=%u",
@@ -191,7 +191,7 @@ DECLARE_EVENT_CLASS(net_dev_rx_verbose_template,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, skb->dev->name);
+		__assign_str(name);
 #ifdef CONFIG_NET_RX_BUSY_POLL
 		__entry->napi_id = skb->napi_id;
 #else
diff --git a/include/trace/events/netlink.h b/include/trace/events/netlink.h
index 3b7be3b386a4..f036b8a20505 100644
--- a/include/trace/events/netlink.h
+++ b/include/trace/events/netlink.h
@@ -17,7 +17,7 @@ TRACE_EVENT(netlink_extack,
 	),
 
 	TP_fast_assign(
-		__assign_str(msg, msg);
+		__assign_str(msg);
 	),
 
 	TP_printk("msg=%s", __get_str(msg))
diff --git a/include/trace/events/oom.h b/include/trace/events/oom.h
index b799f3bcba82..a42be4c8563b 100644
--- a/include/trace/events/oom.h
+++ b/include/trace/events/oom.h
@@ -92,7 +92,7 @@ TRACE_EVENT(mark_victim,
 
 	TP_fast_assign(
 		__entry->pid = task->pid;
-		__assign_str(comm, task->comm);
+		__assign_str(comm);
 		__entry->total_vm = PG_COUNT_TO_KB(task->mm->total_vm);
 		__entry->anon_rss = PG_COUNT_TO_KB(get_mm_counter(task->mm, MM_ANONPAGES));
 		__entry->file_rss = PG_COUNT_TO_KB(get_mm_counter(task->mm, MM_FILEPAGES));
diff --git a/include/trace/events/osnoise.h b/include/trace/events/osnoise.h
index 82f741ec0f57..a2379a4f0684 100644
--- a/include/trace/events/osnoise.h
+++ b/include/trace/events/osnoise.h
@@ -75,7 +75,7 @@ TRACE_EVENT(irq_noise,
 	),
 
 	TP_fast_assign(
-		__assign_str(desc, desc);
+		__assign_str(desc);
 		__entry->vector = vector;
 		__entry->start = start;
 		__entry->duration = duration;
diff --git a/include/trace/events/power.h b/include/trace/events/power.h
index 77f14f7a11d4..d2349b6b531a 100644
--- a/include/trace/events/power.h
+++ b/include/trace/events/power.h
@@ -76,7 +76,7 @@ TRACE_EVENT(powernv_throttle,
 
 	TP_fast_assign(
 		__entry->chip_id = chip_id;
-		__assign_str(reason, reason);
+		__assign_str(reason);
 		__entry->pmax = pmax;
 	),
 
@@ -210,11 +210,10 @@ TRACE_EVENT(device_pm_callback_start,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(dev));
-		__assign_str(driver, dev_driver_string(dev));
-		__assign_str(parent,
-			dev->parent ? dev_name(dev->parent) : "none");
-		__assign_str(pm_ops, pm_ops ? pm_ops : "none ");
+		__assign_str(device);
+		__assign_str(driver);
+		__assign_str(parent);
+		__assign_str(pm_ops);
 		__entry->event = event;
 	),
 
@@ -236,8 +235,8 @@ TRACE_EVENT(device_pm_callback_end,
 	),
 
 	TP_fast_assign(
-		__assign_str(device, dev_name(dev));
-		__assign_str(driver, dev_driver_string(dev));
+		__assign_str(device);
+		__assign_str(driver);
 		__entry->error = error;
 	),
 
@@ -279,7 +278,7 @@ DECLARE_EVENT_CLASS(wakeup_source,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->state = state;
 	),
 
@@ -318,7 +317,7 @@ DECLARE_EVENT_CLASS(clock,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->state = state;
 		__entry->cpu_id = cpu_id;
 	),
@@ -364,7 +363,7 @@ DECLARE_EVENT_CLASS(power_domain,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->state = state;
 		__entry->cpu_id = cpu_id;
 ),
@@ -486,7 +485,7 @@ DECLARE_EVENT_CLASS(dev_pm_qos_request,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->type = type;
 		__entry->new_value = new_value;
 	),
diff --git a/include/trace/events/pwc.h b/include/trace/events/pwc.h
index a2da764a3b41..0543702542d9 100644
--- a/include/trace/events/pwc.h
+++ b/include/trace/events/pwc.h
@@ -26,7 +26,7 @@ TRACE_EVENT(pwc_handler_enter,
 		__entry->urb__actual_length = urb->actual_length;
 		__entry->fbuf__filled = (pdev->fill_buf
 					 ? pdev->fill_buf->filled : 0);
-		__assign_str(name, pdev->v4l2_dev.name);
+		__assign_str(name);
 	),
 	TP_printk("dev=%s (fbuf=%p filled=%d) urb=%p (status=%d actual_length=%u)",
 		__get_str(name),
@@ -50,7 +50,7 @@ TRACE_EVENT(pwc_handler_exit,
 		__entry->urb = urb;
 		__entry->fbuf = pdev->fill_buf;
 		__entry->fbuf__filled = pdev->fill_buf->filled;
-		__assign_str(name, pdev->v4l2_dev.name);
+		__assign_str(name);
 	),
 	TP_printk(" dev=%s (fbuf=%p filled=%d) urb=%p",
 		__get_str(name),
diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 1f4258308b96..f1b5e816e7e5 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -88,8 +88,8 @@ TRACE_EVENT(qdisc_reset,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, qdisc_dev(q)->name);
-		__assign_str(kind, q->ops->id);
+		__assign_str(dev);
+		__assign_str(kind);
 		__entry->parent = q->parent;
 		__entry->handle = q->handle;
 	),
@@ -113,8 +113,8 @@ TRACE_EVENT(qdisc_destroy,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, qdisc_dev(q)->name);
-		__assign_str(kind, q->ops->id);
+		__assign_str(dev);
+		__assign_str(kind);
 		__entry->parent = q->parent;
 		__entry->handle = q->handle;
 	),
@@ -137,8 +137,8 @@ TRACE_EVENT(qdisc_create,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, dev->name);
-		__assign_str(kind, ops->id);
+		__assign_str(dev);
+		__assign_str(kind);
 		__entry->parent = parent;
 	),
 
diff --git a/include/trace/events/qla.h b/include/trace/events/qla.h
index e7fd55e7dc3d..8800c35525a1 100644
--- a/include/trace/events/qla.h
+++ b/include/trace/events/qla.h
@@ -25,7 +25,7 @@ DECLARE_EVENT_CLASS(qla_log_event,
 		__vstring(msg, vaf->fmt, vaf->va)
 	),
 	TP_fast_assign(
-		__assign_str(buf, buf);
+		__assign_str(buf);
 		__assign_vstr(msg, vaf->fmt, vaf->va);
 	),
 
diff --git a/include/trace/events/qrtr.h b/include/trace/events/qrtr.h
index 441132c67133..14f822983741 100644
--- a/include/trace/events/qrtr.h
+++ b/include/trace/events/qrtr.h
@@ -102,7 +102,7 @@ TRACE_EVENT(qrtr_ns_message,
 	),
 
 	TP_fast_assign(
-		__assign_str(ctrl_pkt_str, ctrl_pkt_str);
+		__assign_str(ctrl_pkt_str);
 		__entry->sq_node = sq_node;
 		__entry->sq_port = sq_port;
 	),
diff --git a/include/trace/events/regulator.h b/include/trace/events/regulator.h
index 72b3ba93b0a5..c58481a5d955 100644
--- a/include/trace/events/regulator.h
+++ b/include/trace/events/regulator.h
@@ -23,7 +23,7 @@ DECLARE_EVENT_CLASS(regulator_basic,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 	),
 
 	TP_printk("name=%s", __get_str(name))
@@ -119,7 +119,7 @@ DECLARE_EVENT_CLASS(regulator_range,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->min  = min;
 		__entry->max  = max;
 	),
@@ -152,7 +152,7 @@ DECLARE_EVENT_CLASS(regulator_value,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->val  = val;
 	),
 
diff --git a/include/trace/events/rpcgss.h b/include/trace/events/rpcgss.h
index f50fcafc69de..7f0c1ceae726 100644
--- a/include/trace/events/rpcgss.h
+++ b/include/trace/events/rpcgss.h
@@ -154,7 +154,7 @@ DECLARE_EVENT_CLASS(rpcgss_ctx_class,
 	TP_fast_assign(
 		__entry->cred = gc;
 		__entry->service = gc->gc_service;
-		__assign_str(principal, gc->gc_principal);
+		__assign_str(principal);
 	),
 
 	TP_printk("cred=%p service=%s principal='%s'",
@@ -189,7 +189,7 @@ DECLARE_EVENT_CLASS(rpcgss_svc_gssapi_class,
 	TP_fast_assign(
 		__entry->xid = __be32_to_cpu(rqstp->rq_xid);
 		__entry->maj_stat = maj_stat;
-		__assign_str(addr, rqstp->rq_xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s xid=0x%08x maj_stat=%s",
@@ -225,7 +225,7 @@ TRACE_EVENT(rpcgss_svc_wrap_failed,
 
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqstp->rq_xid);
-		__assign_str(addr, rqstp->rq_xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s xid=0x%08x", __get_str(addr), __entry->xid)
@@ -245,7 +245,7 @@ TRACE_EVENT(rpcgss_svc_unwrap_failed,
 
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqstp->rq_xid);
-		__assign_str(addr, rqstp->rq_xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s xid=0x%08x", __get_str(addr), __entry->xid)
@@ -271,7 +271,7 @@ TRACE_EVENT(rpcgss_svc_seqno_bad,
 		__entry->expected = expected;
 		__entry->received = received;
 		__entry->xid = __be32_to_cpu(rqstp->rq_xid);
-		__assign_str(addr, rqstp->rq_xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s xid=0x%08x expected seqno %u, received seqno %u",
@@ -299,7 +299,7 @@ TRACE_EVENT(rpcgss_svc_accept_upcall,
 		__entry->minor_status = minor_status;
 		__entry->major_status = major_status;
 		__entry->xid = be32_to_cpu(rqstp->rq_xid);
-		__assign_str(addr, rqstp->rq_xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s xid=0x%08x major_status=%s (0x%08lx) minor_status=%u",
@@ -327,7 +327,7 @@ TRACE_EVENT(rpcgss_svc_authenticate,
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqstp->rq_xid);
 		__entry->seqno = gc->gc_seq;
-		__assign_str(addr, rqstp->rq_xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s xid=0x%08x seqno=%u", __get_str(addr),
@@ -563,7 +563,7 @@ TRACE_EVENT(rpcgss_upcall_msg,
 	),
 
 	TP_fast_assign(
-		__assign_str(msg, buf);
+		__assign_str(msg);
 	),
 
 	TP_printk("msg='%s'", __get_str(msg))
@@ -618,7 +618,7 @@ TRACE_EVENT(rpcgss_context,
 		__entry->timeout = timeout;
 		__entry->window_size = window_size;
 		__entry->len = len;
-		__assign_str(acceptor, data);
+		__assign_str(acceptor);
 	),
 
 	TP_printk("win_size=%u expiry=%lu now=%lu timeout=%u acceptor=%.*s",
@@ -677,7 +677,7 @@ TRACE_EVENT(rpcgss_oid_to_mech,
 	),
 
 	TP_fast_assign(
-		__assign_str(oid, oid);
+		__assign_str(oid);
 	),
 
 	TP_printk("mech for oid %s was not found", __get_str(oid))
diff --git a/include/trace/events/rpcrdma.h b/include/trace/events/rpcrdma.h
index 027ac3ab457d..14392652273a 100644
--- a/include/trace/events/rpcrdma.h
+++ b/include/trace/events/rpcrdma.h
@@ -304,8 +304,8 @@ DECLARE_EVENT_CLASS(xprtrdma_reply_class,
 		__entry->xid = be32_to_cpu(rep->rr_xid);
 		__entry->version = be32_to_cpu(rep->rr_vers);
 		__entry->proc = be32_to_cpu(rep->rr_proc);
-		__assign_str(addr, rpcrdma_addrstr(rep->rr_rxprt));
-		__assign_str(port, rpcrdma_portstr(rep->rr_rxprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s xid=0x%08x version=%u proc=%u",
@@ -335,8 +335,8 @@ DECLARE_EVENT_CLASS(xprtrdma_rxprt,
 	),
 
 	TP_fast_assign(
-		__assign_str(addr, rpcrdma_addrstr(r_xprt));
-		__assign_str(port, rpcrdma_portstr(r_xprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s",
@@ -369,8 +369,8 @@ DECLARE_EVENT_CLASS(xprtrdma_connect_class,
 	TP_fast_assign(
 		__entry->rc = rc;
 		__entry->connect_status = r_xprt->rx_ep->re_connect_status;
-		__assign_str(addr, rpcrdma_addrstr(r_xprt));
-		__assign_str(port, rpcrdma_portstr(r_xprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s rc=%d connection status=%d",
@@ -608,8 +608,8 @@ DECLARE_EVENT_CLASS(xprtrdma_callback_class,
 
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqst->rq_xid);
-		__assign_str(addr, rpcrdma_addrstr(r_xprt));
-		__assign_str(port, rpcrdma_portstr(r_xprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s xid=0x%08x",
@@ -687,8 +687,8 @@ TRACE_EVENT(xprtrdma_op_connect,
 
 	TP_fast_assign(
 		__entry->delay = delay;
-		__assign_str(addr, rpcrdma_addrstr(r_xprt));
-		__assign_str(port, rpcrdma_portstr(r_xprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s delay=%lu",
@@ -716,8 +716,8 @@ TRACE_EVENT(xprtrdma_op_set_cto,
 	TP_fast_assign(
 		__entry->connect = connect;
 		__entry->reconnect = reconnect;
-		__assign_str(addr, rpcrdma_addrstr(r_xprt));
-		__assign_str(port, rpcrdma_portstr(r_xprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s connect=%lu reconnect=%lu",
@@ -746,8 +746,8 @@ TRACE_EVENT(xprtrdma_createmrs,
 
 	TP_fast_assign(
 		__entry->count = count;
-		__assign_str(addr, rpcrdma_addrstr(r_xprt));
-		__assign_str(port, rpcrdma_portstr(r_xprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s created %u MRs",
@@ -775,8 +775,8 @@ TRACE_EVENT(xprtrdma_nomrs_err,
 
 		__entry->task_id = rqst->rq_task->tk_pid;
 		__entry->client_id = rqst->rq_task->tk_client->cl_clid;
-		__assign_str(addr, rpcrdma_addrstr(r_xprt));
-		__assign_str(port, rpcrdma_portstr(r_xprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk(SUNRPC_TRACE_TASK_SPECIFIER " peer=[%s]:%s",
@@ -1001,8 +1001,8 @@ TRACE_EVENT(xprtrdma_post_recvs,
 		__entry->cq_id = ep->re_attr.recv_cq->res.id;
 		__entry->count = count;
 		__entry->posted = ep->re_receive_count;
-		__assign_str(addr, rpcrdma_addrstr(r_xprt));
-		__assign_str(port, rpcrdma_portstr(r_xprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s cq.id=%d %u new recvs, %d active",
@@ -1031,8 +1031,8 @@ TRACE_EVENT(xprtrdma_post_recvs_err,
 
 		__entry->cq_id = ep->re_attr.recv_cq->res.id;
 		__entry->status = status;
-		__assign_str(addr, rpcrdma_addrstr(r_xprt));
-		__assign_str(port, rpcrdma_portstr(r_xprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s cq.id=%d rc=%d",
@@ -1445,8 +1445,8 @@ TRACE_EVENT(xprtrdma_cb_setup,
 
 	TP_fast_assign(
 		__entry->reqs = reqs;
-		__assign_str(addr, rpcrdma_addrstr(r_xprt));
-		__assign_str(port, rpcrdma_portstr(r_xprt));
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s %u reqs",
@@ -1476,7 +1476,7 @@ DECLARE_EVENT_CLASS(svcrdma_accept_class,
 
 	TP_fast_assign(
 		__entry->status = status;
-		__assign_str(addr, rdma->sc_xprt.xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s status=%ld",
@@ -1962,7 +1962,7 @@ TRACE_EVENT(svcrdma_send_err,
 	TP_fast_assign(
 		__entry->status = status;
 		__entry->xid = __be32_to_cpu(rqst->rq_xid);
-		__assign_str(addr, rqst->rq_xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s xid=0x%08x status=%d", __get_str(addr),
@@ -2025,7 +2025,7 @@ TRACE_EVENT(svcrdma_rq_post_err,
 
 	TP_fast_assign(
 		__entry->status = status;
-		__assign_str(addr, rdma->sc_xprt.xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s status=%d",
@@ -2138,7 +2138,7 @@ TRACE_EVENT(svcrdma_qp_error,
 
 	TP_fast_assign(
 		__entry->event = event->event;
-		__assign_str(device, event->device->name);
+		__assign_str(device);
 		snprintf(__entry->addr, sizeof(__entry->addr) - 1,
 			 "%pISpc", sap);
 	),
diff --git a/include/trace/events/rpm.h b/include/trace/events/rpm.h
index bd120e23ce12..2b0b4b6ef862 100644
--- a/include/trace/events/rpm.h
+++ b/include/trace/events/rpm.h
@@ -33,7 +33,7 @@ DECLARE_EVENT_CLASS(rpm_internal,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, dev_name(dev));
+		__assign_str(name);
 		__entry->flags = flags;
 		__entry->usage_count = atomic_read(
 			&dev->power.usage_count);
@@ -92,7 +92,7 @@ TRACE_EVENT(rpm_return_int,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, dev_name(dev));
+		__assign_str(name);
 		__entry->ip = ip;
 		__entry->ret = ret;
 	),
@@ -135,7 +135,7 @@ TRACE_EVENT(rpm_status,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, dev_name(dev));
+		__assign_str(name);
 		__entry->status = status;
 	),
 
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 68973f650c26..6df2b4685b08 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -411,7 +411,7 @@ TRACE_EVENT(sched_process_exec,
 	),
 
 	TP_fast_assign(
-		__assign_str(filename, bprm->filename);
+		__assign_str(filename);
 		__entry->pid		= p->pid;
 		__entry->old_pid	= old_pid;
 	),
@@ -445,10 +445,10 @@ TRACE_EVENT(sched_prepare_exec,
 	),
 
 	TP_fast_assign(
-		__assign_str(interp, bprm->interp);
-		__assign_str(filename, bprm->filename);
+		__assign_str(interp);
+		__assign_str(filename);
 		__entry->pid = task->pid;
-		__assign_str(comm, task->comm);
+		__assign_str(comm);
 	),
 
 	TP_printk("interp=%s filename=%s pid=%d comm=%s",
diff --git a/include/trace/events/sof.h b/include/trace/events/sof.h
index 21c2a1efb9f6..3681b6ef625d 100644
--- a/include/trace/events/sof.h
+++ b/include/trace/events/sof.h
@@ -23,7 +23,7 @@ DECLARE_EVENT_CLASS(sof_widget_template,
 		__field(int, use_count)
 	),
 	TP_fast_assign(
-		__assign_str(name, swidget->widget->name);
+		__assign_str(name);
 		__entry->use_count = swidget->use_count;
 	),
 	TP_printk("name=%s use_count=%d", __get_str(name), __entry->use_count)
@@ -49,7 +49,7 @@ TRACE_EVENT(sof_ipc3_period_elapsed_position,
 		__field(u64, wallclock)
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(sdev->dev));
+		__assign_str(device_name);
 		__entry->host_posn = posn->host_posn;
 		__entry->dai_posn = posn->dai_posn;
 		__entry->wallclock = posn->wallclock;
@@ -75,7 +75,7 @@ TRACE_EVENT(sof_pcm_pointer_position,
 		__field(unsigned long, dai_posn)
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(sdev->dev));
+		__assign_str(device_name);
 		__entry->pcm_id = le32_to_cpu(spcm->pcm.pcm_id);
 		__entry->stream = substream->stream;
 		__entry->dma_posn = dma_posn;
@@ -93,7 +93,7 @@ TRACE_EVENT(sof_stream_position_ipc_rx,
 		__string(device_name, dev_name(dev))
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(dev));
+		__assign_str(device_name);
 	),
 	TP_printk("device_name=%s", __get_str(device_name))
 );
@@ -107,8 +107,8 @@ TRACE_EVENT(sof_ipc4_fw_config,
 		__field(u32, value)
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(sdev->dev));
-		__assign_str(key, key);
+		__assign_str(device_name);
+		__assign_str(key);
 		__entry->value = value;
 	),
 	TP_printk("device_name=%s key=%s value=%d",
diff --git a/include/trace/events/sof_intel.h b/include/trace/events/sof_intel.h
index 2a77f9d26c0b..f6414f437546 100644
--- a/include/trace/events/sof_intel.h
+++ b/include/trace/events/sof_intel.h
@@ -22,8 +22,8 @@ TRACE_EVENT(sof_intel_hda_irq,
 		__string(source, source)
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(sdev->dev));
-		__assign_str(source, source);
+		__assign_str(device_name);
+		__assign_str(source);
 	),
 	TP_printk("device_name=%s source=%s",
 		  __get_str(device_name), __get_str(source))
@@ -38,7 +38,7 @@ DECLARE_EVENT_CLASS(sof_intel_ipc_firmware_template,
 		__field(u32, msg_ext)
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(sdev->dev));
+		__assign_str(device_name);
 		__entry->msg = msg;
 		__entry->msg_ext = msg_ext;
 	),
@@ -64,7 +64,7 @@ TRACE_EVENT(sof_intel_D0I3C_updated,
 		__field(u8, reg)
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(sdev->dev));
+		__assign_str(device_name);
 		__entry->reg = reg;
 	),
 	TP_printk("device_name=%s register=%#x",
@@ -79,7 +79,7 @@ TRACE_EVENT(sof_intel_hda_irq_ipc_check,
 		__field(u32, irq_status)
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(sdev->dev));
+		__assign_str(device_name);
 		__entry->irq_status = irq_status;
 	),
 	TP_printk("device_name=%s irq_status=%#x",
@@ -100,7 +100,7 @@ TRACE_EVENT(sof_intel_hda_dsp_pcm,
 		__field(unsigned long, pos)
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(sdev->dev));
+		__assign_str(device_name);
 		__entry->hstream_index = hstream->index;
 		__entry->substream = substream->stream;
 		__entry->pos = pos;
@@ -119,7 +119,7 @@ TRACE_EVENT(sof_intel_hda_dsp_stream_status,
 		__field(u32, status)
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(dev));
+		__assign_str(device_name);
 		__entry->stream = s->index;
 		__entry->status = status;
 	),
@@ -135,7 +135,7 @@ TRACE_EVENT(sof_intel_hda_dsp_check_stream_irq,
 		__field(u32, status)
 	),
 	TP_fast_assign(
-		__assign_str(device_name, dev_name(sdev->dev));
+		__assign_str(device_name);
 		__entry->status = status;
 	),
 	TP_printk("device_name=%s status=%#x",
diff --git a/include/trace/events/sunrpc.h b/include/trace/events/sunrpc.h
index ac05ed06a071..5e8495216689 100644
--- a/include/trace/events/sunrpc.h
+++ b/include/trace/events/sunrpc.h
@@ -188,10 +188,10 @@ TRACE_EVENT(rpc_clnt_new,
 		__entry->client_id = clnt->cl_clid;
 		__entry->xprtsec = args->xprtsec.policy;
 		__entry->flags = args->flags;
-		__assign_str(program, clnt->cl_program->name);
-		__assign_str(server, xprt->servername);
-		__assign_str(addr, xprt->address_strings[RPC_DISPLAY_ADDR]);
-		__assign_str(port, xprt->address_strings[RPC_DISPLAY_PORT]);
+		__assign_str(program);
+		__assign_str(server);
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("client=" SUNRPC_TRACE_CLID_SPECIFIER " peer=[%s]:%s"
@@ -220,8 +220,8 @@ TRACE_EVENT(rpc_clnt_new_err,
 
 	TP_fast_assign(
 		__entry->error = error;
-		__assign_str(program, program);
-		__assign_str(server, server);
+		__assign_str(program);
+		__assign_str(server);
 	),
 
 	TP_printk("program=%s server=%s error=%d",
@@ -325,8 +325,8 @@ TRACE_EVENT(rpc_request,
 		__entry->client_id = task->tk_client->cl_clid;
 		__entry->version = task->tk_client->cl_vers;
 		__entry->async = RPC_IS_ASYNC(task);
-		__assign_str(progname, task->tk_client->cl_program->name);
-		__assign_str(procname, rpc_proc_name(task));
+		__assign_str(progname);
+		__assign_str(procname);
 	),
 
 	TP_printk(SUNRPC_TRACE_TASK_SPECIFIER " %sv%d %s (%ssync)",
@@ -439,7 +439,7 @@ DECLARE_EVENT_CLASS(rpc_task_queued,
 		__entry->runstate = task->tk_runstate;
 		__entry->status = task->tk_status;
 		__entry->flags = task->tk_flags;
-		__assign_str(q_name, rpc_qname(q));
+		__assign_str(q_name);
 		),
 
 	TP_printk(SUNRPC_TRACE_TASK_SPECIFIER
@@ -515,10 +515,10 @@ DECLARE_EVENT_CLASS(rpc_reply_event,
 		__entry->task_id = task->tk_pid;
 		__entry->client_id = task->tk_client->cl_clid;
 		__entry->xid = be32_to_cpu(task->tk_rqstp->rq_xid);
-		__assign_str(progname, task->tk_client->cl_program->name);
+		__assign_str(progname);
 		__entry->version = task->tk_client->cl_vers;
-		__assign_str(procname, rpc_proc_name(task));
-		__assign_str(servername, task->tk_xprt->servername);
+		__assign_str(procname);
+		__assign_str(servername);
 	),
 
 	TP_printk(SUNRPC_TRACE_TASK_SPECIFIER
@@ -647,8 +647,8 @@ TRACE_EVENT(rpc_stats_latency,
 		__entry->task_id = task->tk_pid;
 		__entry->xid = be32_to_cpu(task->tk_rqstp->rq_xid);
 		__entry->version = task->tk_client->cl_vers;
-		__assign_str(progname, task->tk_client->cl_program->name);
-		__assign_str(procname, rpc_proc_name(task));
+		__assign_str(progname);
+		__assign_str(procname);
 		__entry->backlog = ktime_to_us(backlog);
 		__entry->rtt = ktime_to_us(rtt);
 		__entry->execute = ktime_to_us(execute);
@@ -697,16 +697,15 @@ TRACE_EVENT(rpc_xdr_overflow,
 
 			__entry->task_id = task->tk_pid;
 			__entry->client_id = task->tk_client->cl_clid;
-			__assign_str(progname,
-				     task->tk_client->cl_program->name);
+			__assign_str(progname);
 			__entry->version = task->tk_client->cl_vers;
-			__assign_str(procedure, task->tk_msg.rpc_proc->p_name);
+			__assign_str(procedure);
 		} else {
 			__entry->task_id = -1;
 			__entry->client_id = -1;
-			__assign_str(progname, "unknown");
+			__assign_str(progname);
 			__entry->version = 0;
-			__assign_str(procedure, "unknown");
+			__assign_str(procedure);
 		}
 		__entry->requested = requested;
 		__entry->end = xdr->end;
@@ -763,10 +762,9 @@ TRACE_EVENT(rpc_xdr_alignment,
 
 		__entry->task_id = task->tk_pid;
 		__entry->client_id = task->tk_client->cl_clid;
-		__assign_str(progname,
-			     task->tk_client->cl_program->name);
+		__assign_str(progname);
 		__entry->version = task->tk_client->cl_vers;
-		__assign_str(procedure, task->tk_msg.rpc_proc->p_name);
+		__assign_str(procedure);
 
 		__entry->offset = offset;
 		__entry->copied = copied;
@@ -1018,8 +1016,8 @@ DECLARE_EVENT_CLASS(rpc_xprt_lifetime_class,
 
 	TP_fast_assign(
 		__entry->state = xprt->state;
-		__assign_str(addr, xprt->address_strings[RPC_DISPLAY_ADDR]);
-		__assign_str(port, xprt->address_strings[RPC_DISPLAY_PORT]);
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s state=%s",
@@ -1061,8 +1059,8 @@ DECLARE_EVENT_CLASS(rpc_xprt_event,
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(xid);
 		__entry->status = status;
-		__assign_str(addr, xprt->address_strings[RPC_DISPLAY_ADDR]);
-		__assign_str(port, xprt->address_strings[RPC_DISPLAY_PORT]);
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s xid=0x%08x status=%d", __get_str(addr),
@@ -1140,10 +1138,9 @@ TRACE_EVENT(xprt_retransmit,
 		__entry->xid = be32_to_cpu(rqst->rq_xid);
 		__entry->ntrans = rqst->rq_ntrans;
 		__entry->timeout = task->tk_timeout;
-		__assign_str(progname,
-			     task->tk_client->cl_program->name);
+		__assign_str(progname);
 		__entry->version = task->tk_client->cl_vers;
-		__assign_str(procname, rpc_proc_name(task));
+		__assign_str(procname);
 	),
 
 	TP_printk(SUNRPC_TRACE_TASK_SPECIFIER
@@ -1167,8 +1164,8 @@ TRACE_EVENT(xprt_ping,
 
 	TP_fast_assign(
 		__entry->status = status;
-		__assign_str(addr, xprt->address_strings[RPC_DISPLAY_ADDR]);
-		__assign_str(port, xprt->address_strings[RPC_DISPLAY_PORT]);
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s status=%d",
@@ -1315,8 +1312,8 @@ TRACE_EVENT(xs_data_ready,
 	),
 
 	TP_fast_assign(
-		__assign_str(addr, xprt->address_strings[RPC_DISPLAY_ADDR]);
-		__assign_str(port, xprt->address_strings[RPC_DISPLAY_PORT]);
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s", __get_str(addr), __get_str(port))
@@ -1339,10 +1336,8 @@ TRACE_EVENT(xs_stream_read_data,
 	TP_fast_assign(
 		__entry->err = err;
 		__entry->total = total;
-		__assign_str(addr, xprt ?
-			xprt->address_strings[RPC_DISPLAY_ADDR] : EVENT_NULL_STR);
-		__assign_str(port, xprt ?
-			xprt->address_strings[RPC_DISPLAY_PORT] : EVENT_NULL_STR);
+		__assign_str(addr);
+		__assign_str(port);
 	),
 
 	TP_printk("peer=[%s]:%s err=%zd total=%zu", __get_str(addr),
@@ -1364,8 +1359,8 @@ TRACE_EVENT(xs_stream_read_request,
 	),
 
 	TP_fast_assign(
-		__assign_str(addr, xs->xprt.address_strings[RPC_DISPLAY_ADDR]);
-		__assign_str(port, xs->xprt.address_strings[RPC_DISPLAY_PORT]);
+		__assign_str(addr);
+		__assign_str(port);
 		__entry->xid = be32_to_cpu(xs->recv.xid);
 		__entry->copied = xs->recv.copied;
 		__entry->reclen = xs->recv.len;
@@ -1403,7 +1398,7 @@ TRACE_EVENT(rpcb_getport,
 		__entry->version = clnt->cl_vers;
 		__entry->protocol = task->tk_xprt->prot;
 		__entry->bind_version = bind_version;
-		__assign_str(servername, task->tk_xprt->servername);
+		__assign_str(servername);
 	),
 
 	TP_printk(SUNRPC_TRACE_TASK_SPECIFIER
@@ -1493,8 +1488,8 @@ TRACE_EVENT(rpcb_register,
 	TP_fast_assign(
 		__entry->program = program;
 		__entry->version = version;
-		__assign_str(addr, addr);
-		__assign_str(netid, netid);
+		__assign_str(addr);
+		__assign_str(netid);
 	),
 
 	TP_printk("program=%u version=%u addr=%s netid=%s",
@@ -1521,7 +1516,7 @@ TRACE_EVENT(rpcb_unregister,
 	TP_fast_assign(
 		__entry->program = program;
 		__entry->version = version;
-		__assign_str(netid, netid);
+		__assign_str(netid);
 	),
 
 	TP_printk("program=%u version=%u netid=%s",
@@ -1551,8 +1546,8 @@ DECLARE_EVENT_CLASS(rpc_tls_class,
 	TP_fast_assign(
 		__entry->requested_policy = clnt->cl_xprtsec.policy;
 		__entry->version = clnt->cl_vers;
-		__assign_str(servername, xprt->servername);
-		__assign_str(progname, clnt->cl_program->name)
+		__assign_str(servername);
+		__assign_str(progname);
 	),
 
 	TP_printk("server=%s %sv%u requested_policy=%s",
@@ -1794,10 +1789,9 @@ TRACE_EVENT(svc_process,
 		__entry->xid = be32_to_cpu(rqst->rq_xid);
 		__entry->vers = rqst->rq_vers;
 		__entry->proc = rqst->rq_proc;
-		__assign_str(service, name);
-		__assign_str(procedure, svc_proc_name(rqst));
-		__assign_str(addr, rqst->rq_xprt ?
-			     rqst->rq_xprt->xpt_remotebuf : EVENT_NULL_STR);
+		__assign_str(service);
+		__assign_str(procedure);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s xid=0x%08x service=%s vers=%u proc=%s",
@@ -1915,7 +1909,7 @@ TRACE_EVENT(svc_stats_latency,
 
 		__entry->execute = ktime_to_us(ktime_sub(ktime_get(),
 							 rqst->rq_stime));
-		__assign_str(procedure, svc_proc_name(rqst));
+		__assign_str(procedure);
 	),
 
 	TP_printk(SVC_RQST_ENDPOINT_FORMAT " proc=%s execute-us=%lu",
@@ -1980,8 +1974,8 @@ TRACE_EVENT(svc_xprt_create_err,
 
 	TP_fast_assign(
 		__entry->error = PTR_ERR(xprt);
-		__assign_str(program, program);
-		__assign_str(protocol, protocol);
+		__assign_str(program);
+		__assign_str(protocol);
 		__assign_sockaddr(addr, sap, salen);
 	),
 
@@ -2120,8 +2114,8 @@ TRACE_EVENT(svc_xprt_accept,
 	TP_fast_assign(
 		SVC_XPRT_ENDPOINT_ASSIGNMENTS(xprt);
 
-		__assign_str(protocol, xprt->xpt_class->xcl_name);
-		__assign_str(service, service);
+		__assign_str(protocol);
+		__assign_str(service);
 	),
 
 	TP_printk(SVC_XPRT_ENDPOINT_FORMAT " protocol=%s service=%s",
@@ -2260,7 +2254,7 @@ TRACE_EVENT(svcsock_marker,
 	TP_fast_assign(
 		__entry->length = be32_to_cpu(marker) & RPC_FRAGMENT_SIZE_MASK;
 		__entry->last = be32_to_cpu(marker) & RPC_LAST_STREAM_FRAGMENT;
-		__assign_str(addr, xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s length=%u%s", __get_str(addr),
@@ -2284,7 +2278,7 @@ DECLARE_EVENT_CLASS(svcsock_class,
 	TP_fast_assign(
 		__entry->result = result;
 		__entry->flags = xprt->xpt_flags;
-		__assign_str(addr, xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s result=%zd flags=%s", __get_str(addr),
@@ -2330,7 +2324,7 @@ TRACE_EVENT(svcsock_tcp_recv_short,
 		__entry->expected = expected;
 		__entry->received = received;
 		__entry->flags = xprt->xpt_flags;
-		__assign_str(addr, xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s flags=%s expected=%u received=%u",
@@ -2358,7 +2352,7 @@ TRACE_EVENT(svcsock_tcp_state,
 		__entry->socket_state = socket->state;
 		__entry->sock_state = socket->sk->sk_state;
 		__entry->flags = xprt->xpt_flags;
-		__assign_str(addr, xprt->xpt_remotebuf);
+		__assign_str(addr);
 	),
 
 	TP_printk("addr=%s state=%s sk_state=%s flags=%s", __get_str(addr),
@@ -2385,7 +2379,7 @@ DECLARE_EVENT_CLASS(svcsock_accept_class,
 
 	TP_fast_assign(
 		__entry->status = status;
-		__assign_str(service, service);
+		__assign_str(service);
 		__entry->netns_ino = xprt->xpt_net->ns.inum;
 	),
 
@@ -2421,7 +2415,7 @@ DECLARE_EVENT_CLASS(cache_event,
 
 	TP_fast_assign(
 		__entry->h = h;
-		__assign_str(name, cd->name);
+		__assign_str(name);
 	),
 
 	TP_printk("cache=%s entry=%p", __get_str(name), __entry->h)
@@ -2466,7 +2460,7 @@ DECLARE_EVENT_CLASS(register_class,
 		__entry->protocol = protocol;
 		__entry->port = port;
 		__entry->error = error;
-		__assign_str(program, program);
+		__assign_str(program);
 	),
 
 	TP_printk("program=%sv%u proto=%s port=%u family=%s error=%d",
@@ -2511,7 +2505,7 @@ TRACE_EVENT(svc_unregister,
 	TP_fast_assign(
 		__entry->version = version;
 		__entry->error = error;
-		__assign_str(program, program);
+		__assign_str(program);
 	),
 
 	TP_printk("program=%sv%u error=%d",
diff --git a/include/trace/events/swiotlb.h b/include/trace/events/swiotlb.h
index da05c9ebd224..3b6ddb136e4e 100644
--- a/include/trace/events/swiotlb.h
+++ b/include/trace/events/swiotlb.h
@@ -20,7 +20,7 @@ TRACE_EVENT(swiotlb_bounced,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name(dev));
+		__assign_str(dev_name);
 		__entry->dma_mask = (dev->dma_mask ? *dev->dma_mask : 0);
 		__entry->dev_addr = dev_addr;
 		__entry->size = size;
diff --git a/include/trace/events/target.h b/include/trace/events/target.h
index 67fad2677ed5..a13cbf2b3405 100644
--- a/include/trace/events/target.h
+++ b/include/trace/events/target.h
@@ -154,7 +154,7 @@ TRACE_EVENT(target_sequencer_start,
 		__entry->task_attribute	= cmd->sam_task_attr;
 		__entry->control	= scsi_command_control(cmd->t_task_cdb);
 		memcpy(__entry->cdb, cmd->t_task_cdb, TCM_MAX_COMMAND_SIZE);
-		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
+		__assign_str(initiator);
 	),
 
 	TP_printk("%s -> LUN %03u tag %#llx %s data_length %6u  CDB %s  (TA:%s C:%02x)",
@@ -198,7 +198,7 @@ TRACE_EVENT(target_cmd_complete,
 			min(18, ((u8 *) cmd->sense_buffer)[SPC_ADD_SENSE_LEN_OFFSET] + 8) : 0;
 		memcpy(__entry->cdb, cmd->t_task_cdb, TCM_MAX_COMMAND_SIZE);
 		memcpy(__entry->sense_data, cmd->sense_buffer, __entry->sense_length);
-		__assign_str(initiator, cmd->se_sess->se_node_acl->initiatorname);
+		__assign_str(initiator);
 	),
 
 	TP_printk("%s <- LUN %03u tag %#llx status %s (sense len %d%s%s)  %s data_length %6u  CDB %s  (TA:%s C:%02x)",
diff --git a/include/trace/events/tegra_apb_dma.h b/include/trace/events/tegra_apb_dma.h
index 971cd02d2daf..6d9f5075baa3 100644
--- a/include/trace/events/tegra_apb_dma.h
+++ b/include/trace/events/tegra_apb_dma.h
@@ -16,7 +16,7 @@ TRACE_EVENT(tegra_dma_tx_status,
 		__field(__u32,	residue)
 	),
 	TP_fast_assign(
-		__assign_str(chan, dev_name(&dc->dev->device));
+		__assign_str(chan);
 		__entry->cookie = cookie;
 		__entry->residue = state ? state->residue : (u32)-1;
 	),
@@ -33,7 +33,7 @@ TRACE_EVENT(tegra_dma_complete_cb,
 		__field(void *,	ptr)
 		),
 	TP_fast_assign(
-		__assign_str(chan, dev_name(&dc->dev->device));
+		__assign_str(chan);
 		__entry->count = count;
 		__entry->ptr = ptr;
 		),
@@ -49,7 +49,7 @@ TRACE_EVENT(tegra_dma_isr,
 		__field(int,	irq)
 	),
 	TP_fast_assign(
-		__assign_str(chan, dev_name(&dc->dev->device));
+		__assign_str(chan);
 		__entry->irq = irq;
 	),
 	TP_printk("%s: irq %d\n",  __get_str(chan), __entry->irq)
diff --git a/include/trace/events/ufs.h b/include/trace/events/ufs.h
index b930669bd1f0..c4e209fbdfbb 100644
--- a/include/trace/events/ufs.h
+++ b/include/trace/events/ufs.h
@@ -92,7 +92,7 @@ TRACE_EVENT(ufshcd_clk_gating,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
+		__assign_str(dev_name);
 		__entry->state = state;
 	),
 
@@ -117,9 +117,9 @@ TRACE_EVENT(ufshcd_clk_scaling,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
-		__assign_str(state, state);
-		__assign_str(clk, clk);
+		__assign_str(dev_name);
+		__assign_str(state);
+		__assign_str(clk);
 		__entry->prev_state = prev_state;
 		__entry->curr_state = curr_state;
 	),
@@ -141,8 +141,8 @@ TRACE_EVENT(ufshcd_auto_bkops_state,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
-		__assign_str(state, state);
+		__assign_str(dev_name);
+		__assign_str(state);
 	),
 
 	TP_printk("%s: auto bkops - %s",
@@ -163,8 +163,8 @@ DECLARE_EVENT_CLASS(ufshcd_profiling_template,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
-		__assign_str(profile_info, profile_info);
+		__assign_str(dev_name);
+		__assign_str(profile_info);
 		__entry->time_us = time_us;
 		__entry->err = err;
 	),
@@ -206,7 +206,7 @@ DECLARE_EVENT_CLASS(ufshcd_template,
 	TP_fast_assign(
 		__entry->usecs = usecs;
 		__entry->err = err;
-		__assign_str(dev_name, dev_name);
+		__assign_str(dev_name);
 		__entry->dev_state = dev_state;
 		__entry->link_state = link_state;
 	),
@@ -326,7 +326,7 @@ TRACE_EVENT(ufshcd_uic_command,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
+		__assign_str(dev_name);
 		__entry->str_t = str_t;
 		__entry->cmd = cmd;
 		__entry->arg1 = arg1;
@@ -356,7 +356,7 @@ TRACE_EVENT(ufshcd_upiu,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
+		__assign_str(dev_name);
 		__entry->str_t = str_t;
 		memcpy(__entry->hdr, hdr, sizeof(__entry->hdr));
 		memcpy(__entry->tsf, tsf, sizeof(__entry->tsf));
@@ -384,7 +384,7 @@ TRACE_EVENT(ufshcd_exception_event,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev_name);
+		__assign_str(dev_name);
 		__entry->status = status;
 	),
 
diff --git a/include/trace/events/workqueue.h b/include/trace/events/workqueue.h
index 262d52021c23..51b0e874f667 100644
--- a/include/trace/events/workqueue.h
+++ b/include/trace/events/workqueue.h
@@ -38,7 +38,7 @@ TRACE_EVENT(workqueue_queue_work,
 	TP_fast_assign(
 		__entry->work		= work;
 		__entry->function	= work->func;
-		__assign_str(workqueue, pwq->wq->name);
+		__assign_str(workqueue);
 		__entry->req_cpu	= req_cpu;
 		__entry->cpu		= pwq->pool->cpu;
 	),
diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
index 9adc2bdf2f94..a7e5452b5d21 100644
--- a/include/trace/events/xdp.h
+++ b/include/trace/events/xdp.h
@@ -416,7 +416,7 @@ TRACE_EVENT(bpf_xdp_link_attach_failed,
 	),
 
 	TP_fast_assign(
-		__assign_str(msg, msg);
+		__assign_str(msg);
 	),
 
 	TP_printk("errmsg=%s", __get_str(msg))
diff --git a/include/trace/stages/stage6_event_callback.h b/include/trace/stages/stage6_event_callback.h
index 3690e677263f..1691676fd858 100644
--- a/include/trace/stages/stage6_event_callback.h
+++ b/include/trace/stages/stage6_event_callback.h
@@ -31,12 +31,10 @@
 #define __vstring(item, fmt, ap) __dynamic_array(char, item, -1)
 
 #undef __assign_str
-#define __assign_str(dst, src)						\
+#define __assign_str(dst)						\
 	do {								\
 		char *__str__ = __get_str(dst);				\
 		int __len__ = __get_dynamic_array_len(dst) - 1;		\
-		WARN_ON_ONCE(!(void *)(src) != !(void *)__data_offsets.dst##_ptr_); \
-		WARN_ON_ONCE((src) && strcmp((src), __data_offsets.dst##_ptr_)); \
 		memcpy(__str__, __data_offsets.dst##_ptr_ ? :		\
 		       EVENT_NULL_STR, __len__);			\
 		__str__[__len__] = '\0';				\
diff --git a/kernel/trace/bpf_trace.h b/kernel/trace/bpf_trace.h
index 9acbc11ac7bb..c4075b56becc 100644
--- a/kernel/trace/bpf_trace.h
+++ b/kernel/trace/bpf_trace.h
@@ -19,7 +19,7 @@ TRACE_EVENT(bpf_trace_printk,
 	),
 
 	TP_fast_assign(
-		__assign_str(bpf_string, bpf_string);
+		__assign_str(bpf_string);
 	),
 
 	TP_printk("%s", __get_str(bpf_string))
diff --git a/net/batman-adv/trace.h b/net/batman-adv/trace.h
index 5dd52bc5cabb..6b816cf1a953 100644
--- a/net/batman-adv/trace.h
+++ b/net/batman-adv/trace.h
@@ -40,8 +40,8 @@ TRACE_EVENT(batadv_dbg,
 	    ),
 
 	    TP_fast_assign(
-		    __assign_str(device, bat_priv->soft_iface->name);
-		    __assign_str(driver, KBUILD_MODNAME);
+		    __assign_str(device);
+		    __assign_str(driver);
 		    __assign_vstr(msg, vaf->fmt, vaf->va);
 	    ),
 
diff --git a/net/dsa/trace.h b/net/dsa/trace.h
index 567f29a39707..83f3e5f78491 100644
--- a/net/dsa/trace.h
+++ b/net/dsa/trace.h
@@ -39,8 +39,8 @@ DECLARE_EVENT_CLASS(dsa_port_addr_op_hw,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dp->ds->dev));
-		__assign_str(kind, dsa_port_kind(dp));
+		__assign_str(dev);
+		__assign_str(kind);
 		__entry->port = dp->index;
 		ether_addr_copy(__entry->addr, addr);
 		__entry->vid = vid;
@@ -98,8 +98,8 @@ DECLARE_EVENT_CLASS(dsa_port_addr_op_refcount,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dp->ds->dev));
-		__assign_str(kind, dsa_port_kind(dp));
+		__assign_str(dev);
+		__assign_str(kind);
 		__entry->port = dp->index;
 		ether_addr_copy(__entry->addr, addr);
 		__entry->vid = vid;
@@ -157,8 +157,8 @@ DECLARE_EVENT_CLASS(dsa_port_addr_del_not_found,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dp->ds->dev));
-		__assign_str(kind, dsa_port_kind(dp));
+		__assign_str(dev);
+		__assign_str(kind);
 		__entry->port = dp->index;
 		ether_addr_copy(__entry->addr, addr);
 		__entry->vid = vid;
@@ -199,7 +199,7 @@ TRACE_EVENT(dsa_lag_fdb_add_hw,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, lag_dev->name);
+		__assign_str(dev);
 		ether_addr_copy(__entry->addr, addr);
 		__entry->vid = vid;
 		dsa_db_print(db, __entry->db_buf);
@@ -227,7 +227,7 @@ TRACE_EVENT(dsa_lag_fdb_add_bump,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, lag_dev->name);
+		__assign_str(dev);
 		ether_addr_copy(__entry->addr, addr);
 		__entry->vid = vid;
 		dsa_db_print(db, __entry->db_buf);
@@ -255,7 +255,7 @@ TRACE_EVENT(dsa_lag_fdb_del_hw,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, lag_dev->name);
+		__assign_str(dev);
 		ether_addr_copy(__entry->addr, addr);
 		__entry->vid = vid;
 		dsa_db_print(db, __entry->db_buf);
@@ -283,7 +283,7 @@ TRACE_EVENT(dsa_lag_fdb_del_drop,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, lag_dev->name);
+		__assign_str(dev);
 		ether_addr_copy(__entry->addr, addr);
 		__entry->vid = vid;
 		dsa_db_print(db, __entry->db_buf);
@@ -310,7 +310,7 @@ TRACE_EVENT(dsa_lag_fdb_del_not_found,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, lag_dev->name);
+		__assign_str(dev);
 		ether_addr_copy(__entry->addr, addr);
 		__entry->vid = vid;
 		dsa_db_print(db, __entry->db_buf);
@@ -338,8 +338,8 @@ DECLARE_EVENT_CLASS(dsa_vlan_op_hw,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dp->ds->dev));
-		__assign_str(kind, dsa_port_kind(dp));
+		__assign_str(dev);
+		__assign_str(kind);
 		__entry->port = dp->index;
 		__entry->vid = vlan->vid;
 		__entry->flags = vlan->flags;
@@ -383,8 +383,8 @@ DECLARE_EVENT_CLASS(dsa_vlan_op_refcount,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dp->ds->dev));
-		__assign_str(kind, dsa_port_kind(dp));
+		__assign_str(dev);
+		__assign_str(kind);
 		__entry->port = dp->index;
 		__entry->vid = vlan->vid;
 		__entry->flags = vlan->flags;
@@ -426,8 +426,8 @@ TRACE_EVENT(dsa_vlan_del_not_found,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev, dev_name(dp->ds->dev));
-		__assign_str(kind, dsa_port_kind(dp));
+		__assign_str(dev);
+		__assign_str(kind);
 		__entry->port = dp->index;
 		__entry->vid = vlan->vid;
 	),
diff --git a/net/ieee802154/trace.h b/net/ieee802154/trace.h
index 62aa6465253a..591ce0a16fc0 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -75,7 +75,7 @@ TRACE_EVENT(802154_rdev_add_virtual_intf,
 	),
 	TP_fast_assign(
 		WPAN_PHY_ASSIGN;
-		__assign_str(vir_intf_name, name ? name : "<noname>");
+		__assign_str(vir_intf_name);
 		__entry->type = type;
 		__entry->extended_addr = extended_addr;
 	),
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 8e758b5074bd..b26aacfbc622 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -33,7 +33,7 @@
 			__string(vif_name, sdata->name)
 #define VIF_ASSIGN	__entry->vif_type = sdata->vif.type; __entry->sdata = sdata;	\
 			__entry->p2p = sdata->vif.p2p;					\
-			__assign_str(vif_name, sdata->name)
+			__assign_str(vif_name)
 #define VIF_PR_FMT	" vif:%s(%d%s)"
 #define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type, __entry->p2p ? "/p2p" : ""
 
diff --git a/net/openvswitch/openvswitch_trace.h b/net/openvswitch/openvswitch_trace.h
index 3eb35d9eb700..74d75aaebef4 100644
--- a/net/openvswitch/openvswitch_trace.h
+++ b/net/openvswitch/openvswitch_trace.h
@@ -43,8 +43,8 @@ TRACE_EVENT(ovs_do_execute_action,
 
 	TP_fast_assign(
 		__entry->dpaddr = dp;
-		__assign_str(dp_name, ovs_dp_name(dp));
-		__assign_str(dev_name, skb->dev->name);
+		__assign_str(dp_name);
+		__assign_str(dev_name);
 		__entry->skbaddr = skb;
 		__entry->len = skb->len;
 		__entry->data_len = skb->data_len;
@@ -113,8 +113,8 @@ TRACE_EVENT(ovs_dp_upcall,
 
 	TP_fast_assign(
 		__entry->dpaddr = dp;
-		__assign_str(dp_name, ovs_dp_name(dp));
-		__assign_str(dev_name, skb->dev->name);
+		__assign_str(dp_name);
+		__assign_str(dev_name);
 		__entry->skbaddr = skb;
 		__entry->len = skb->len;
 		__entry->data_len = skb->data_len;
diff --git a/net/smc/smc_tracepoint.h b/net/smc/smc_tracepoint.h
index 9fc5e586d24a..a9a6e3c1113a 100644
--- a/net/smc/smc_tracepoint.h
+++ b/net/smc/smc_tracepoint.h
@@ -60,7 +60,7 @@ DECLARE_EVENT_CLASS(smc_msg_event,
 				   __entry->smc = smc;
 				   __entry->net_cookie = sock_net(sk)->net_cookie;
 				   __entry->len = len;
-				   __assign_str(name, smc->conn.lnk->ibname);
+				   __assign_str(name);
 		    ),
 
 		    TP_printk("smc=%p net=%llu len=%zu dev=%s",
@@ -104,7 +104,7 @@ TRACE_EVENT(smcr_link_down,
 			   __entry->lgr = lgr;
 			   __entry->net_cookie = lgr->net->net_cookie;
 			   __entry->state = lnk->state;
-			   __assign_str(name, lnk->ibname);
+			   __assign_str(name);
 			   __entry->location = location;
 	    ),
 
diff --git a/net/tipc/trace.h b/net/tipc/trace.h
index 04af83f0500c..865142ed0ab4 100644
--- a/net/tipc/trace.h
+++ b/net/tipc/trace.h
@@ -145,7 +145,7 @@ DECLARE_EVENT_CLASS(tipc_skb_class,
 	),
 
 	TP_fast_assign(
-		__assign_str(header, header);
+		__assign_str(header);
 		tipc_skb_dump(skb, more, __get_str(buf));
 	),
 
@@ -172,7 +172,7 @@ DECLARE_EVENT_CLASS(tipc_list_class,
 	),
 
 	TP_fast_assign(
-		__assign_str(header, header);
+		__assign_str(header);
 		tipc_list_dump(list, more, __get_str(buf));
 	),
 
@@ -200,7 +200,7 @@ DECLARE_EVENT_CLASS(tipc_sk_class,
 	),
 
 	TP_fast_assign(
-		__assign_str(header, header);
+		__assign_str(header);
 		__entry->portid = tipc_sock_get_portid(sk);
 		tipc_sk_dump(sk, dqueues, __get_str(buf));
 		if (skb)
@@ -254,7 +254,7 @@ DECLARE_EVENT_CLASS(tipc_link_class,
 	),
 
 	TP_fast_assign(
-		__assign_str(header, header);
+		__assign_str(header);
 		memcpy(__entry->name, tipc_link_name(l), TIPC_MAX_LINK_NAME);
 		tipc_link_dump(l, dqueues, __get_str(buf));
 	),
@@ -337,7 +337,7 @@ DECLARE_EVENT_CLASS(tipc_node_class,
 	),
 
 	TP_fast_assign(
-		__assign_str(header, header);
+		__assign_str(header);
 		__entry->addr = tipc_node_get_addr(n);
 		tipc_node_dump(n, more, __get_str(buf));
 	),
@@ -374,7 +374,7 @@ DECLARE_EVENT_CLASS(tipc_fsm_class,
 	),
 
 	TP_fast_assign(
-		__assign_str(name, name);
+		__assign_str(name);
 		__entry->os = os;
 		__entry->ns = ns;
 		__entry->evt = evt;
@@ -409,8 +409,8 @@ TRACE_EVENT(tipc_l2_device_event,
 	),
 
 	TP_fast_assign(
-		__assign_str(dev_name, dev->name);
-		__assign_str(b_name, b->name);
+		__assign_str(dev_name);
+		__assign_str(b_name);
 		__entry->evt = evt;
 		__entry->b_up = test_bit(0, &b->up);
 		__entry->carrier = netif_carrier_ok(dev);
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 9bf987519811..87986170d1b1 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -372,7 +372,7 @@ TRACE_EVENT(rdev_add_virtual_intf,
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
-		__assign_str(vir_intf_name, name ? name : "<noname>");
+		__assign_str(vir_intf_name);
 		__entry->type = type;
 	),
 	TP_printk(WIPHY_PR_FMT ", virtual intf name: %s, type: %d",
diff --git a/samples/trace_events/trace-events-sample.h b/samples/trace_events/trace-events-sample.h
index 500981eca74d..55f9a3da92d5 100644
--- a/samples/trace_events/trace-events-sample.h
+++ b/samples/trace_events/trace-events-sample.h
@@ -136,10 +136,11 @@
  *
  *         To assign a string, use the helper macro __assign_str().
  *
- *         __assign_str(foo, bar);
+ *         __assign_str(foo);
  *
- *         In most cases, the __assign_str() macro will take the same
- *         parameters as the __string() macro had to declare the string.
+ *	   The __string() macro saves off the string that is passed into
+ *         the second parameter, and the __assign_str() will store than
+ *         saved string into the "foo" field.
  *
  *   __vstring: This is similar to __string() but instead of taking a
  *         dynamic length, it takes a variable list va_list 'va' variable.
@@ -177,7 +178,7 @@
  *         The length is saved via the __string_len() and is retrieved in
  *         __assign_str().
  *
- *         __assign_str(foo, bar);
+ *         __assign_str(foo);
  *
  *         Then len + 1 is allocated to the ring buffer, and a nul terminating
  *         byte is added. This is similar to:
@@ -311,8 +312,8 @@ TRACE_EVENT(foo_bar,
 		__entry->bar	= bar;
 		memcpy(__get_dynamic_array(list), lst,
 		       __length_of(lst) * sizeof(int));
-		__assign_str(str, string);
-		__assign_str(lstr, foo);
+		__assign_str(str);
+		__assign_str(lstr);
 		__assign_vstr(vstr, fmt, va);
 		__assign_bitmask(cpus, cpumask_bits(mask), num_possible_cpus());
 		__assign_cpumask(cpum, cpumask_bits(mask));
@@ -418,7 +419,7 @@ TRACE_EVENT_CONDITION(foo_bar_with_cond,
 	),
 
 	TP_fast_assign(
-		__assign_str(foo, foo);
+		__assign_str(foo);
 		__entry->bar	= bar;
 	),
 
@@ -459,7 +460,7 @@ TRACE_EVENT_FN(foo_bar_with_fn,
 	),
 
 	TP_fast_assign(
-		__assign_str(foo, foo);
+		__assign_str(foo);
 		__entry->bar	= bar;
 	),
 
@@ -506,7 +507,7 @@ DECLARE_EVENT_CLASS(foo_template,
 	),
 
 	TP_fast_assign(
-		__assign_str(foo, foo);
+		__assign_str(foo);
 		__entry->bar	= bar;
 	),
 
diff --git a/sound/core/pcm_trace.h b/sound/core/pcm_trace.h
index 350b40b906ca..adb9b1f3bbfa 100644
--- a/sound/core/pcm_trace.h
+++ b/sound/core/pcm_trace.h
@@ -95,7 +95,7 @@ TRACE_EVENT(hw_ptr_error,
 		__entry->device = (substream)->pcm->device;
 		__entry->number = (substream)->number;
 		__entry->stream = (substream)->stream;
-		__assign_str(reason, why);
+		__assign_str(reason);
 	),
 	TP_printk("pcmC%dD%d%s/sub%d: ERROR: %s",
 		  __entry->card, __entry->device,
diff --git a/sound/hda/trace.h b/sound/hda/trace.h
index 2cc493434a8f..280c42f3eb75 100644
--- a/sound/hda/trace.h
+++ b/sound/hda/trace.h
@@ -24,7 +24,7 @@ TRACE_EVENT(hda_send_cmd,
 		__field(u32, cmd)
 	),
 	TP_fast_assign(
-		__assign_str(name, dev_name((bus)->dev));
+		__assign_str(name);
 		__entry->cmd = cmd;
 	),
 	TP_printk("[%s:%d] val=0x%08x", __get_str(name), __entry->cmd >> 28, __entry->cmd)
@@ -39,7 +39,7 @@ TRACE_EVENT(hda_get_response,
 		__field(u32, res)
 	),
 	TP_fast_assign(
-		__assign_str(name, dev_name((bus)->dev));
+		__assign_str(name);
 		__entry->addr = addr;
 		__entry->res = res;
 	),
@@ -55,7 +55,7 @@ TRACE_EVENT(hda_unsol_event,
 		__field(u32, res_ex)
 	),
 	TP_fast_assign(
-		__assign_str(name, dev_name((bus)->dev));
+		__assign_str(name);
 		__entry->res = res;
 		__entry->res_ex = res_ex;
 	),
diff --git a/sound/soc/intel/avs/trace.h b/sound/soc/intel/avs/trace.h
index 855b06bb14b0..c9eaa5a60ed3 100644
--- a/sound/soc/intel/avs/trace.h
+++ b/sound/soc/intel/avs/trace.h
@@ -24,7 +24,7 @@ TRACE_EVENT(avs_dsp_core_op,
 	TP_fast_assign(
 		__entry->reg = reg;
 		__entry->mask = mask;
-		__assign_str(op, op);
+		__assign_str(op);
 		__entry->flag = flag;
 	),
 
@@ -135,7 +135,7 @@ TRACE_EVENT(avs_d0ix,
 	),
 
 	TP_fast_assign(
-		__assign_str(op, op);
+		__assign_str(op);
 		__entry->proceed = proceed;
 		__entry->header = header;
 	),
-- 
2.43.0


