Return-Path: <io-uring+bounces-13589-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPIkKHewHmr7JAAAu9opvQ
	(envelope-from <io-uring+bounces-13589-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 12:29:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 488F262C900
	for <lists+io-uring@lfdr.de>; Tue, 02 Jun 2026 12:29:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id F3F66302732E
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2026 10:22:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AAEA2C11E2;
	Tue,  2 Jun 2026 10:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mTd6nPov"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F2A3D091F
	for <io-uring@vger.kernel.org>; Tue,  2 Jun 2026 10:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780395738; cv=none; b=ooO1MKJPzHy63la52Cl2FuVigmxx0RTB8zpYMAHRDMg1wLaTWV3GfJU/xcRaCSSfQbeRZMJXbJ1Y4C292cVXTf/EI5c9D2Ks+LnzwvsZLl/yJS4KRwCZtaPUhJ9gLAqOTmXjCgRGCyojEScZ4xunGAFFTUWVg6oHIwJelmj1p+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780395738; c=relaxed/simple;
	bh=3PbY8cDuZJ89/Vh/p/LlSMJlT1tYYQIQa2pCQ2/EiLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Im6VMyBhTFYh0zgHNlFFAwApwa+WYrczhWNAH/eabNffat/pqBHBuex5CaE2pczzKKGVGMSQ8vp/Jc3LeiGhGNvda3Ws0gURYJ3c/E0f4ppuYIpiEs+exCiLYG15JfkFRCadePEnb9N6KJ/ECp1j2LhWRc4D24L6wlOD6IXyJkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mTd6nPov; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490ae94a89eso13029405e9.1
        for <io-uring@vger.kernel.org>; Tue, 02 Jun 2026 03:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780395736; x=1781000536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2EMcp4tyo3/e7KWwGE1lzkF+6neLH/1tBS0kkBtx9Fw=;
        b=mTd6nPovwL0AdABzwPuxWZ09ItAQdXeqgDNkkoAvnnRcbYGlw5Xl0TK8hTEsPZ5KV8
         AyBeKhX5mIi1WDEQclb9uwSynG0ik0IR5y1djnz7+wRD00dPkNcbCmeyFBX5ScLXhJOt
         /9nY5hdhkhtpFEpwB8ezw6mVL44OZT9+zHnjWsrJJanmWZhm5psTIgkrIseDVkirigJO
         T2H6beuR/fZkwz4997WfwNE9FAf8jAIV5pU9xZOxiWScdtDAqr3fsz5RcrB/wJLljh6Q
         TFl30CJB2PYfvD0sv2vp1E15f7G72+jBh/tD++g34LR8QD0mY/2hWx+Cd+1oYfUnZbK/
         EwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780395736; x=1781000536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2EMcp4tyo3/e7KWwGE1lzkF+6neLH/1tBS0kkBtx9Fw=;
        b=NRuoXkB8yiDtNRPM2/6j/LVXLF+VDTHPrL/R0nYTXMestsgp2gBQJ2X7fyv3kPSuuj
         JiCZrsWqhXCUoSSVF/78PL3pIAHUkTJRssruU1Q1trHysDamtYNS0OpjQ+eN/aKWtz/s
         bWSg1LfL4bYQ7qg2qUleW75q2b7e6rKjr6Vx1qiA4wPm9jll57yNqfZ8KRpBr5hzqMfj
         Lhf5fXwvo6GrS/u9emKGZvmL+zRV66KCqqbwb8DRfDPO3hMbNaS7lSl97Yz80aLqZGGN
         yO50dHwJxA0ls8vQfJEQ9Ces2JR9bVpck0XeFxt5unhPeAuslQ7DDufOzqXSg+BeneR3
         QqDg==
X-Gm-Message-State: AOJu0YzlPuDTapq04A1N8Hx+9uCe4CQdlfvs34IjkQXq4UmYQzL5cqTA
	pmLwtYsTbEoR82PIio/5QPdWDcshR+bL+1aAwFQQ6A4IORXHtETguZ9nqKVGJw==
X-Gm-Gg: Acq92OFs1VaL486hHkPbFl9WLj05IgdPmeJlbhdeZ0bOnzmRt5nfnUWgOfI+wVHOqHW
	rHkosUQ517fdS2ShrifPfuOe9xao6+q5X2KxJaNMnbYZ5m0l2MiR0uInrsVMgAQr4Oa1M8YE/Nh
	ERqY1f7/f0N3DD+e4Cx4CB0Uo0ANH3Xfeu0G2g4Ti7Hf5R3341Hr/l7YEQ1aDPymzmcOtlvjFXk
	jDGn/4gsggSA0+IxtcTRAMmjHKDsRcZMGI2//gVHC9QuHZWWVleNUhsh2UqoICvk5vCgw5cpQRg
	cVeAPubYEVB+cYC3LyGB68DbftatTbvi18npf825/udtnkt2x1GJVP6IhqxCJHFXUlpEyr9hlNr
	A6vxmtrUxegjNYUCYkvsKxtFI9fdWpgKuS549O2h8mD/tjlXzjfutn0tpQhUsxqr5WulkU8WDGd
	aPlGXQBS1Lo5sQoouK+keyLk0QUi2YQG7+9oCeQiuypv1yNduRS0OWOLXuoM3sWsCNjJguUc1+a
	z97LuoF1CW07YgpJeVZYsSpXoDUwXSv/0WNzryK
X-Received: by 2002:a05:600c:1c0a:b0:490:846d:e2de with SMTP id 5b1f17b1804b1-490a293fcfcmr282898265e9.28.1780395736178;
        Tue, 02 Jun 2026 03:22:16 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b0e24069sm59123105e9.8.2026.06.02.03.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 03:22:15 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 2/2] io_uring/loop: introduce wait timeouts
Date: Tue,  2 Jun 2026 11:22:06 +0100
Message-ID: <e846c74327265d58fd592b01facbbfe2829af084.1780395120.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780395120.git.asml.silence@gmail.com>
References: <cover.1780395120.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 488F262C900
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13589-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	TO_DN_NONE(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FREEMAIL_FROM(0.00)[gmail.com];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo]
X-Rspamd-Action: no action

The basic waiting functionality should be able to time out of CQE
waiting. Implement timeouts for the loop logic and let BPF to control
it. The BPF API consists of two flags it can set in struct
iou_loop_params, IOU_LOOP_TIMEOUT[_ABS], which instruct the loop to arm
a timeout while waiting using the value passed in struct
iou_loop_params::timeout_ns as either a relative of absolute timeout. It
can also find out if the last waiting timed out by checking for the
IOU_LOOP_WAIT_TIMED_OUT flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/bpf-ops.c |  6 ++++++
 io_uring/loop.c    | 21 ++++++++++++++++++++-
 io_uring/loop.h    | 14 ++++++++++++++
 3 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index 5a50f0675fe5..ee99f675a43c 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -95,6 +95,12 @@ static int bpf_io_btf_struct_access(struct bpf_verifier_log *log,
 	if (t == loop_params_type) {
 		if (off + size <= offsetofend(struct iou_loop_params, cq_wait_idx))
 			return SCALAR_VALUE;
+		if (off >= offsetof(struct iou_loop_params, timeout_ns) &&
+		    off + size <= offsetofend(struct iou_loop_params, timeout_ns))
+			return SCALAR_VALUE;
+		if (off >= offsetof(struct iou_loop_params, flags) &&
+		    off + size <= offsetofend(struct iou_loop_params, flags))
+			return SCALAR_VALUE;
 	}
 
 	return -EACCES;
diff --git a/io_uring/loop.c b/io_uring/loop.c
index affaee440dc3..de0d326a3f81 100644
--- a/io_uring/loop.c
+++ b/io_uring/loop.c
@@ -5,6 +5,7 @@
 
 struct io_loop_state {
 	struct iou_loop_params lp;
+	__u32 cur_flags;
 };
 
 static inline int io_loop_nr_cqes(const struct io_ring_ctx *ctx,
@@ -40,7 +41,20 @@ static void io_loop_wait(struct io_ring_ctx *ctx, struct io_loop_state *ls,
 	}
 
 	mutex_unlock(&ctx->uring_lock);
-	schedule();
+
+	if (ls->cur_flags & IOU_LOOP_TIMEOUT) {
+		ktime_t timeout = ns_to_ktime(lp->timeout_ns);
+		enum hrtimer_mode mode = HRTIMER_MODE_REL;
+
+		if (ls->cur_flags & IOU_LOOP_TIMEOUT_ABS)
+			mode = HRTIMER_MODE_ABS;
+
+		if (!schedule_hrtimeout_range_clock(&timeout, 0, mode,ctx->clockid))
+			ls->lp.flags |= IOU_LOOP_WAIT_TIMED_OUT;
+	} else {
+		schedule();
+	}
+
 	io_loop_wait_finish(ctx);
 	mutex_lock(&ctx->uring_lock);
 }
@@ -60,6 +74,11 @@ static int __io_run_loop(struct io_ring_ctx *ctx)
 			break;
 		if (step_res != IOU_LOOP_CONTINUE)
 			return -EINVAL;
+		if (ls.lp.flags & ~IOU_LOOP_VALID_FLAGS)
+			return -EINVAL;
+
+		ls.cur_flags = ls.lp.flags;
+		ls.lp.flags = 0;
 
 		nr_wait = io_loop_nr_cqes(ctx, &ls.lp);
 		if (nr_wait > 0)
diff --git a/io_uring/loop.h b/io_uring/loop.h
index 4dd4fb3aefef..555210721a84 100644
--- a/io_uring/loop.h
+++ b/io_uring/loop.h
@@ -4,12 +4,26 @@
 
 #include <linux/io_uring_types.h>
 
+enum iou_loop_flags {
+	IOU_LOOP_TIMEOUT			= 1U << 0,
+	IOU_LOOP_TIMEOUT_ABS			= 1U << 1,
+	/* If set, the last loop waiting was interrupted by a timeout */
+	IOU_LOOP_WAIT_TIMED_OUT			= 1U << 2,
+};
+
+#define IOU_LOOP_VALID_FLAGS	(IOU_LOOP_TIMEOUT |\
+				 IOU_LOOP_TIMEOUT_ABS |\
+				 IOU_LOOP_WAIT_TIMED_OUT)
+
 struct iou_loop_params {
 	/*
 	 * The CQE index to wait for. Only serves as a hint and can still be
 	 * woken up earlier.
 	 */
 	__u32			cq_wait_idx;
+	/* see IOU_LOOP_* flags */
+	__u32			flags;
+	__u64			timeout_ns;
 };
 
 enum {
-- 
2.54.0


