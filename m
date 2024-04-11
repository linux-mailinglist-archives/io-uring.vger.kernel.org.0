Return-Path: <io-uring+bounces-1506-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A97A8A181D
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 17:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4DBFB1C224E0
	for <lists+io-uring@lfdr.de>; Thu, 11 Apr 2024 15:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6106E111A3;
	Thu, 11 Apr 2024 15:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="SpCRueCY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07375DF6C
	for <io-uring@vger.kernel.org>; Thu, 11 Apr 2024 15:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712847970; cv=none; b=DmfDftdFt3e1ozr4kJc+VfeTXbU5nXJR5MbYf+wAM3vOiPx8yz8f/YAmh56s1EIy3OoWJscqD1sq3k21lWxro/7NskiCnykJkh60V+4FJmZB21YPOJPoZp/Tb9Hh3YD+C5GaKtJUTFUVH06o6c3ffXmIhZQpd/VG7HZYVFetB2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712847970; c=relaxed/simple;
	bh=w7NeHPXuxhlt4bcVNQJHlRlEoLFIpX5hi3FANB5lJoM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=inxaK3JOzEkqbugb2sU3PC8mKU9jIv84XKXY+MA1UrXMlTRI/H98O+jkQD760lH0Hp43X0e8mJqrw1gs53SUxWfnCJEFkCr0yh75L12Myovs5yRaDMqJfBvrkZ/xcInGB4AAOSg0PAmoH2JqzVEzXpELGSoRIvw/mPA2epsgfR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=SpCRueCY; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-56e6f4ee104so4794399a12.2
        for <io-uring@vger.kernel.org>; Thu, 11 Apr 2024 08:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1712847964; x=1713452764; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=3XY9FvpYK3RhqyAoY8N9ZZOBhodm4LlWdXEwCqf+YMk=;
        b=SpCRueCY3GBMXfkdos93dg6AgTwH6FaMrPB7YZ9UWPWlhjp06iZE+iDosOIqru+UFH
         JHdzImS7K8sBp+fwN6z9Yhz9FC3tKok1MtzPkbgO4xcOKHNiHZv0OdjVsr4Nbn11MtGq
         TWN2vNIfDtaUBv0yxlvI3vNrz6Extzxxb32xou63RuCI4ACeCTQPWNLNbOqkHG3YcWLu
         ef9DZSRFWHwXoNqzmlcIj88QQMlvf8NY2kJvpZHeuoG0jpe8NaEerwIyaJDFs/XJCYsu
         3UYmVzEpBns7gNMY6idu69peOfkSvs1BrPyzJeyEfTq2w64VZMhdPDvv3db6G7heRO4e
         XFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712847964; x=1713452764;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3XY9FvpYK3RhqyAoY8N9ZZOBhodm4LlWdXEwCqf+YMk=;
        b=u4Ne/bNPZkgbWyALrt8ieaCu6u5mkQGt16Y2lRkLsch9WuldtTQtrowTHLKGSt7EV6
         lnH8VP9IrF75Edj/Kq/zOkWhkRQzIJjlPjTNkNODq6n15XauP7ipv+r2Cy5CwAyYm+zB
         itXzdBokAALp5xUg/4CaEoSfWIKV3gOo9qEhHA/pSXKSORFGixaK+TftPDfk+4ieda6C
         4QVjGlqXqAlHvIaYf6F8b8STyUmp7uH05f8fowdRPacGO1hNApms3FiYfsyghGJYNbyQ
         UJB60/xKlMIv0EfizQxDy0NjmEfK16xSYtWd887w6x1jKbVJeOHFEiiCT8oCciOy01KT
         Mcag==
X-Forwarded-Encrypted: i=1; AJvYcCWsD5BrUYJAZ0V8f68fP3YzonJgbdU5+MM0sLtkuNJzIsREdlbEvQcV2QqprF5Y5vwbjIxgBTZfqEO+sBspA9bZpIglNN5R3cA=
X-Gm-Message-State: AOJu0YxpYjjoj30Rl8EREG1gMYIGPSV0B+CS1BTIPJdmAzA5oKSdT+xL
	qBHCuPlmk7MuXmtTmENJJ8YQw48TJBC0AbvpW0tkZKNo6JMsmSXFtJpydByfegE=
X-Google-Smtp-Source: AGHT+IHD8Aol4VG3+TWeRF8vO+k+xa2SzGRSIh0TnwsiDVmsP/sGKLIykE4sii1nSP4TUsdBmFyt2w==
X-Received: by 2002:a50:9ea9:0:b0:566:18ba:6b80 with SMTP id a38-20020a509ea9000000b0056618ba6b80mr45026edf.31.1712847963956;
        Thu, 11 Apr 2024 08:06:03 -0700 (PDT)
Received: from fedora.fritz.box (aftr-82-135-80-212.dynamic.mnet-online.de. [82.135.80.212])
        by smtp.gmail.com with ESMTPSA id w4-20020a056402128400b0056e2b351956sm777108edv.22.2024.04.11.08.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Apr 2024 08:06:03 -0700 (PDT)
From: Thorsten Blum <thorsten.blum@toblux.com>
To: kernel-janitors@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org,
	speakup@linux-speakup.org,
	intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-wireless@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-afs@lists.infradead.org,
	ecryptfs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-arch@vger.kernel.org,
	io-uring@vger.kernel.org,
	cocci@inria.fr,
	linux-perf-users@vger.kernel.org,
	Thorsten Blum <thorsten.blum@toblux.com>
Subject: [PATCH] treewide: Fix common grammar mistake "the the"
Date: Thu, 11 Apr 2024 17:04:40 +0200
Message-ID: <20240411150437.496153-4-thorsten.blum@toblux.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use `find . -type f -exec sed -i 's/\<the the\>/the/g' {} +` to find all
occurrences of "the the" and replace them with a single "the".

Changes only comments and documentation - no code changes.

Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
---
 Documentation/trace/histogram.rst                 | 2 +-
 arch/arm/Kconfig                                  | 4 ++--
 arch/arm/include/asm/unwind.h                     | 2 +-
 arch/arm64/Kconfig                                | 2 +-
 arch/arm64/kernel/entry-ftrace.S                  | 2 +-
 arch/s390/kernel/perf_cpum_sf.c                   | 2 +-
 arch/s390/kernel/sthyi.c                          | 2 +-
 drivers/accessibility/speakup/speakup_soft.c      | 2 +-
 drivers/gpu/drm/i915/display/intel_crt.c          | 2 +-
 drivers/gpu/drm/i915/i915_request.c               | 2 +-
 drivers/mailbox/Kconfig                           | 2 +-
 drivers/net/wireless/intel/iwlwifi/fw/api/tx.h    | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 2 +-
 drivers/scsi/bfa/bfa_fcs_rport.c                  | 2 +-
 drivers/scsi/fcoe/fcoe_ctlr.c                     | 2 +-
 drivers/scsi/isci/host.h                          | 2 +-
 drivers/scsi/isci/remote_device.h                 | 2 +-
 drivers/scsi/isci/remote_node_context.h           | 2 +-
 drivers/scsi/isci/task.c                          | 2 +-
 fs/afs/flock.c                                    | 2 +-
 fs/ecryptfs/keystore.c                            | 2 +-
 fs/netfs/direct_read.c                            | 2 +-
 fs/netfs/direct_write.c                           | 2 +-
 fs/overlayfs/super.c                              | 2 +-
 include/uapi/asm-generic/fcntl.h                  | 2 +-
 io_uring/kbuf.c                                   | 2 +-
 lib/zstd/common/fse_decompress.c                  | 2 +-
 lib/zstd/decompress/zstd_decompress_block.c       | 2 +-
 scripts/coccinelle/misc/badty.cocci               | 2 +-
 tools/perf/Documentation/perf-diff.txt            | 2 +-
 30 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/Documentation/trace/histogram.rst b/Documentation/trace/histogram.rst
index 3c9b263de9c2..18a419925a08 100644
--- a/Documentation/trace/histogram.rst
+++ b/Documentation/trace/histogram.rst
@@ -840,7 +840,7 @@ Extended error information
 
   The compound key examples used a key and a sum value (hitcount) to
   sort the output, but we can just as easily use two keys instead.
-  Here's an example where we use a compound key composed of the the
+  Here's an example where we use a compound key composed of the
   common_pid and size event fields.  Sorting with pid as the primary
   key and 'size' as the secondary key allows us to display an
   ordered summary of the recvfrom sizes, with counts, received by
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index b14aed3a17ab..f46fb69ff247 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1479,7 +1479,7 @@ config ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND
 	bool "Extend with bootloader kernel arguments"
 	help
 	  The command-line arguments provided by the boot loader will be
-	  appended to the the device tree bootargs property.
+	  appended to the device tree bootargs property.
 
 endchoice
 
@@ -1617,7 +1617,7 @@ config DMI
 	  continue to boot on existing non-UEFI platforms.
 
 	  NOTE: This does *NOT* enable or encourage the use of DMI quirks,
-	  i.e., the the practice of identifying the platform via DMI to
+	  i.e., the practice of identifying the platform via DMI to
 	  decide whether certain workarounds for buggy hardware and/or
 	  firmware need to be enabled. This would require the DMI subsystem
 	  to be enabled much earlier than we do on ARM, which is non-trivial.
diff --git a/arch/arm/include/asm/unwind.h b/arch/arm/include/asm/unwind.h
index d60b09a5acfc..a75da9a01f91 100644
--- a/arch/arm/include/asm/unwind.h
+++ b/arch/arm/include/asm/unwind.h
@@ -10,7 +10,7 @@
 
 #ifndef __ASSEMBLY__
 
-/* Unwind reason code according the the ARM EABI documents */
+/* Unwind reason code according the ARM EABI documents */
 enum unwind_reason_code {
 	URC_OK = 0,			/* operation completed successfully */
 	URC_CONTINUE_UNWIND = 8,
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 7b11c98b3e84..285ae4ca0b83 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -2253,7 +2253,7 @@ config CMDLINE
 	default ""
 	help
 	  Provide a set of default command-line options at build time by
-	  entering them here. As a minimum, you should specify the the
+	  entering them here. As a minimum, you should specify the
 	  root device (e.g. root=/dev/nfs).
 
 choice
diff --git a/arch/arm64/kernel/entry-ftrace.S b/arch/arm64/kernel/entry-ftrace.S
index f0c16640ef21..e24e7d8f8b61 100644
--- a/arch/arm64/kernel/entry-ftrace.S
+++ b/arch/arm64/kernel/entry-ftrace.S
@@ -94,7 +94,7 @@ SYM_CODE_START(ftrace_caller)
 	stp	x29, x30, [sp, #FREGS_SIZE]
 	add	x29, sp, #FREGS_SIZE
 
-	/* Prepare arguments for the the tracer func */
+	/* Prepare arguments for the tracer func */
 	sub	x0, x30, #AARCH64_INSN_SIZE		// ip (callsite's BL insn)
 	mov	x1, x9					// parent_ip (callsite's LR)
 	mov	x3, sp					// regs
diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 06efad5b4f93..3e1d8c58e4d1 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1193,7 +1193,7 @@ static void perf_event_count_update(struct perf_event *event, u64 count)
  * combined-sampling data entry consists of a basic- and a diagnostic-sampling
  * data entry.	The sampling function is determined by the flags in the perf
  * event hardware structure.  The function always works with a combined-sampling
- * data entry but ignores the the diagnostic portion if it is not available.
+ * data entry but ignores the diagnostic portion if it is not available.
  *
  * Note that the implementation focuses on basic-sampling data entries and, if
  * such an entry is not valid, the entire combined-sampling data entry is
diff --git a/arch/s390/kernel/sthyi.c b/arch/s390/kernel/sthyi.c
index 30bb20461db4..77e08ab92568 100644
--- a/arch/s390/kernel/sthyi.c
+++ b/arch/s390/kernel/sthyi.c
@@ -250,7 +250,7 @@ static void fill_diag_mac(struct sthyi_sctns *sctns,
 	sctns->mac.infmval1 |= MAC_CNT_VLD;
 }
 
-/* Returns a pointer to the the next partition block. */
+/* Returns a pointer to the next partition block. */
 static struct diag204_x_part_block *lpar_cpu_inf(struct lpar_cpu_inf *part_inf,
 						 bool this_lpar,
 						 void *diag224_buf,
diff --git a/drivers/accessibility/speakup/speakup_soft.c b/drivers/accessibility/speakup/speakup_soft.c
index 6d446824677b..6549bfb96e7f 100644
--- a/drivers/accessibility/speakup/speakup_soft.c
+++ b/drivers/accessibility/speakup/speakup_soft.c
@@ -446,7 +446,7 @@ static int softsynth_adjust(struct spk_synth *synth, struct st_var_header *var)
 	if (var->var_id != PUNC_LEVEL)
 		return 0;
 
-	/* We want to set the the speech synthesis punctuation level
+	/* We want to set the speech synthesis punctuation level
 	 * accordingly, so it properly tunes speaking A_PUNC characters */
 	var_data = var->data;
 	if (!var_data)
diff --git a/drivers/gpu/drm/i915/display/intel_crt.c b/drivers/gpu/drm/i915/display/intel_crt.c
index 93479db0f89f..9ee0c6e986c3 100644
--- a/drivers/gpu/drm/i915/display/intel_crt.c
+++ b/drivers/gpu/drm/i915/display/intel_crt.c
@@ -1114,7 +1114,7 @@ void intel_crt_init(struct drm_i915_private *dev_priv)
 	drm_connector_helper_add(connector, &intel_crt_connector_helper_funcs);
 
 	/*
-	 * TODO: find a proper way to discover whether we need to set the the
+	 * TODO: find a proper way to discover whether we need to set the
 	 * polarity and link reversal bits or not, instead of relying on the
 	 * BIOS.
 	 */
diff --git a/drivers/gpu/drm/i915/i915_request.c b/drivers/gpu/drm/i915/i915_request.c
index 519e096c607c..e0fe24452f38 100644
--- a/drivers/gpu/drm/i915/i915_request.c
+++ b/drivers/gpu/drm/i915/i915_request.c
@@ -1779,7 +1779,7 @@ __i915_request_add_to_timeline(struct i915_request *rq)
 }
 
 /*
- * NB: This function is not allowed to fail. Doing so would mean the the
+ * NB: This function is not allowed to fail. Doing so would mean the
  * request is not being tracked for completion but the work itself is
  * going to happen on the hardware. This would be a Bad Thing(tm).
  */
diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index 42940108a187..1e0a14bcdeec 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -54,7 +54,7 @@ config ARMADA_37XX_RWTM_MBOX
 	depends on ARCH_MVEBU || COMPILE_TEST
 	depends on OF
 	help
-	  Mailbox implementation for communication with the the firmware
+	  Mailbox implementation for communication with the firmware
 	  running on the Cortex-M3 rWTM secure processor of the Armada 37xx
 	  SOC. Say Y here if you are building for such a device (for example
 	  the Turris Mox router).
diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
index d9e4c75403b8..b19c1d69223e 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/tx.h
@@ -191,7 +191,7 @@ enum iwl_tx_offload_assist_flags_pos {
  *	cleared. Combination of RATE_MCS_*
  * @sta_id: index of destination station in FW station table
  * @sec_ctl: security control, TX_CMD_SEC_*
- * @initial_rate_index: index into the the rate table for initial TX attempt.
+ * @initial_rate_index: index into the rate table for initial TX attempt.
  *	Applied if TX_CMD_FLG_STA_RATE_MSK is set, normally 0 for data frames.
  * @reserved2: reserved
  * @key: security key
@@ -851,7 +851,7 @@ struct iwl_extended_beacon_notif {
 
 /**
  * enum iwl_dump_control - dump (flush) control flags
- * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the the FIFO is empty
+ * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the FIFO is empty
  *	and the TFD queues are empty.
  */
 enum iwl_dump_control {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index ce264b386029..4c958a4692b2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -31,7 +31,7 @@ u8 iwl_mvm_get_channel_width(const struct cfg80211_chan_def *chandef)
 
 /*
  * Maps the driver specific control channel position (relative to the center
- * freq) definitions to the the fw values
+ * freq) definitions to the fw values
  */
 u8 iwl_mvm_get_ctrl_pos(const struct cfg80211_chan_def *chandef)
 {
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index ce52a9c88ae6..567a640c39c7 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1987,7 +1987,7 @@ bfa_fcs_rport_gidpn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			/*
 			 * Device's PID has changed. We need to cleanup
 			 * and re-login. If there is another device with
-			 * the the newly discovered pid, send an scn notice
+			 * the newly discovered pid, send an scn notice
 			 * so that its new pid can be discovered.
 			 */
 			list_for_each(qe, &rport->port->rport_q) {
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 5c8d1ba3f8f3..4050a8d99b1d 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -205,7 +205,7 @@ static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
 		 * that doesn't have a priv (fcf was deleted). However,
 		 * libfcoe will always delete FCFs before trying to add
 		 * them. This is ensured because both recv_adv and
-		 * age_fcfs are protected by the the fcoe_ctlr's mutex.
+		 * age_fcfs are protected by the fcoe_ctlr's mutex.
 		 * This means that we should never get a FCF with a
 		 * non-NULL priv pointer.
 		 */
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 52388374cf31..e4971ca00769 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -244,7 +244,7 @@ enum sci_controller_states {
 	SCIC_INITIALIZED,
 
 	/**
-	 * This state indicates the the controller is in the process of becoming
+	 * This state indicates the controller is in the process of becoming
 	 * ready (i.e. starting).  In this state no new IO operations are permitted.
 	 * This state is entered from the INITIALIZED state.
 	 */
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 3ad681c4c20a..db097483ff04 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -198,7 +198,7 @@ enum sci_status sci_remote_device_reset_complete(
  * permitted.  This state is entered from the INITIAL state.  This state
  * is entered from the STOPPING state.
  *
- * @SCI_DEV_STARTING: This state indicates the the remote device is in
+ * @SCI_DEV_STARTING: This state indicates the remote device is in
  * the process of becoming ready (i.e. starting).  In this state no new
  * IO operations are permitted.  This state is entered from the STOPPED
  * state.
diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index c7ee81d01125..f22950b12b8b 100644
--- a/drivers/scsi/isci/remote_node_context.h
+++ b/drivers/scsi/isci/remote_node_context.h
@@ -154,7 +154,7 @@ enum sci_remote_node_context_destination_state {
 /**
  * struct sci_remote_node_context - This structure contains the data
  *    associated with the remote node context object.  The remote node context
- *    (RNC) object models the the remote device information necessary to manage
+ *    (RNC) object models the remote device information necessary to manage
  *    the silicon RNC.
  */
 struct sci_remote_node_context {
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 3a25b1a2c52d..aeb2cda92465 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -67,7 +67,7 @@
 /**
 * isci_task_refuse() - complete the request to the upper layer driver in
 *     the case where an I/O needs to be completed back in the submit path.
-* @ihost: host on which the the request was queued
+* @ihost: host on which the request was queued
 * @task: request to complete
 * @response: response code for the completed task.
 * @status: status code for the completed task.
diff --git a/fs/afs/flock.c b/fs/afs/flock.c
index f0e96a35093f..2b1d6eb02553 100644
--- a/fs/afs/flock.c
+++ b/fs/afs/flock.c
@@ -151,7 +151,7 @@ static void afs_next_locker(struct afs_vnode *vnode, int error)
 }
 
 /*
- * Kill off all waiters in the the pending lock queue due to the vnode being
+ * Kill off all waiters in the pending lock queue due to the vnode being
  * deleted.
  */
 static void afs_kill_lockers_enoent(struct afs_vnode *vnode)
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 3fe41964c0d8..2452d6fd7062 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -878,7 +878,7 @@ struct ecryptfs_parse_tag_70_packet_silly_stack {
  * @filename: This function kmalloc's the memory for the filename
  * @filename_size: This function sets this to the amount of memory
  *                 kmalloc'd for the filename
- * @packet_size: This function sets this to the the number of octets
+ * @packet_size: This function sets this to the number of octets
  *               in the packet parsed
  * @mount_crypt_stat: The mount-wide cryptographic context
  * @data: The memory location containing the start of the tag 70
diff --git a/fs/netfs/direct_read.c b/fs/netfs/direct_read.c
index ad4370b3935d..a8a5323e2736 100644
--- a/fs/netfs/direct_read.c
+++ b/fs/netfs/direct_read.c
@@ -56,7 +56,7 @@ static ssize_t netfs_unbuffered_read_iter_locked(struct kiocb *iocb, struct iov_
 	 * buffer for ourselves as the caller's iterator will be trashed when
 	 * we return.
 	 *
-	 * In such a case, extract an iterator to represent as much of the the
+	 * In such a case, extract an iterator to represent as much of the
 	 * output buffer as we can manage.  Note that the extraction might not
 	 * be able to allocate a sufficiently large bvec array and may shorten
 	 * the request.
diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index bee047e20f5d..b46e34d528cd 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -57,7 +57,7 @@ static ssize_t netfs_unbuffered_write_iter_locked(struct kiocb *iocb, struct iov
 		/* If this is an async op and we're not using a bounce buffer,
 		 * we have to save the source buffer as the iterator is only
 		 * good until we return.  In such a case, extract an iterator
-		 * to represent as much of the the output buffer as we can
+		 * to represent as much of the output buffer as we can
 		 * manage.  Note that the extraction might not be able to
 		 * allocate a sufficiently large bvec array and may shorten the
 		 * request.
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a40fc7e05525..80042bfd4b92 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1456,7 +1456,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_iflags |= SB_I_SKIP_SYNC;
 	/*
 	 * Ensure that umask handling is done by the filesystems used
-	 * for the the upper layer instead of overlayfs as that would
+	 * for the upper layer instead of overlayfs as that would
 	 * lead to unexpected results.
 	 */
 	sb->s_iflags |= SB_I_NOUMASK;
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 80f37a0d40d7..1c7a0f6632c0 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -142,7 +142,7 @@
  * record  locks, but are "owned" by the open file description, not the
  * process. This means that they are inherited across fork() like BSD (flock)
  * locks, and they are only released automatically when the last reference to
- * the the open file against which they were acquired is put.
+ * the open file against which they were acquired is put.
  */
 #define F_OFD_GETLK	36
 #define F_OFD_SETLK	37
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3aa16e27f509..503244e8470a 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -731,7 +731,7 @@ struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
 	 * going away, if someone is trying to be sneaky. Look it up under rcu
 	 * so we know it's not going away, and attempt to grab a reference to
 	 * it. If the ref is already zero, then fail the mapping. If successful,
-	 * the caller will call io_put_bl() to drop the the reference at at the
+	 * the caller will call io_put_bl() to drop the reference at at the
 	 * end. This may then safely free the buffer_list (and drop the pages)
 	 * at that point, vm_insert_pages() would've already grabbed the
 	 * necessary vma references.
diff --git a/lib/zstd/common/fse_decompress.c b/lib/zstd/common/fse_decompress.c
index 8dcb8ca39767..2de48eee3653 100644
--- a/lib/zstd/common/fse_decompress.c
+++ b/lib/zstd/common/fse_decompress.c
@@ -127,7 +127,7 @@ static size_t FSE_buildDTable_internal(FSE_DTable* dt, const short* normalizedCo
             }
         }
         /* Now we spread those positions across the table.
-         * The benefit of doing it in two stages is that we avoid the the
+         * The benefit of doing it in two stages is that we avoid the
          * variable size inner loop, which caused lots of branch misses.
          * Now we can run through all the positions without any branch misses.
          * We unroll the loop twice, since that is what emperically worked best.
diff --git a/lib/zstd/decompress/zstd_decompress_block.c b/lib/zstd/decompress/zstd_decompress_block.c
index c1913b8e7c89..cd2e9acecd84 100644
--- a/lib/zstd/decompress/zstd_decompress_block.c
+++ b/lib/zstd/decompress/zstd_decompress_block.c
@@ -510,7 +510,7 @@ void ZSTD_buildFSETable_body(ZSTD_seqSymbol* dt,
             }
         }
         /* Now we spread those positions across the table.
-         * The benefit of doing it in two stages is that we avoid the the
+         * The benefit of doing it in two stages is that we avoid the
          * variable size inner loop, which caused lots of branch misses.
          * Now we can run through all the positions without any branch misses.
          * We unroll the loop twice, since that is what emperically worked best.
diff --git a/scripts/coccinelle/misc/badty.cocci b/scripts/coccinelle/misc/badty.cocci
index ed3e0b8f3b1a..e3530cade156 100644
--- a/scripts/coccinelle/misc/badty.cocci
+++ b/scripts/coccinelle/misc/badty.cocci
@@ -4,7 +4,7 @@
 //# This makes an effort to find cases where the argument to sizeof is wrong
 //# in memory allocation functions by checking the type of the allocated memory
 //# when it is a double pointer and ensuring the sizeof argument takes a pointer
-//# to the the memory being allocated. There are false positives in cases the
+//# to the memory being allocated. There are false positives in cases the
 //# sizeof argument is not used in constructing the return value. The result
 //# may need some reformatting.
 //
diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index f3067a4af294..58efab72d2e5 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -285,7 +285,7 @@ If specified the 'Weighted diff' column is displayed with value 'd' computed as:
 
   - period being the hist entry period value
 
-  - WEIGHT-A/WEIGHT-B being user supplied weights in the the '-c' option
+  - WEIGHT-A/WEIGHT-B being user supplied weights in the '-c' option
     behind ':' separator like '-c wdiff:1,2'.
     - WEIGHT-A being the weight of the data file
     - WEIGHT-B being the weight of the baseline data file
-- 
2.44.0


