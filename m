Return-Path: <io-uring+bounces-12263-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MCBoM+pLk2mi3AEAu9opvQ
	(envelope-from <io-uring+bounces-12263-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:55:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A3AF14678F
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:55:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E4B5A305C285
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:51:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B267026158C;
	Mon, 16 Feb 2026 16:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AEuRRMVa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C7F2737F2
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 16:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260714; cv=none; b=qs189EvYyucRkiFGLkjdGlWY45YVxmAq5gJPZNcOtiLI8/WEz7r0aXSAtW7DfVk9Sk0zmS1kbdUjFV3r0CPmjOpVeurorlF143p3SgzlZzDrnQvK6Hw9J4zr631lA2aOOg2snAlzcP3pcwtnRVZt//2uI+xJ2f9NFTviRn8kkSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260714; c=relaxed/simple;
	bh=QE96R9eicSGpjinXpGU8uaHaRIew9YzdrFxbUp3vIgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NlHUjkP5Fhf+p1zgW+M/Vwmn4Pa9mHOAdV/WyDPFZjQTUJOGlbsmqRZl6pHq2XrIzMDoIBfk42zPbYPTN/dpLNgxI3gcO7uQrMH1woYbG9plC8CH4nzhMpj8217cS4sIqSjhE4WcmcNJWTERUTPblAjdWLmzehPWYVbVIvLSbVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AEuRRMVa; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-483770e0b25so28719015e9.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 08:51:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771260710; x=1771865510; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x44aAcQjnWa1QWZK/N7Lh2pdpMQOoZvekrVC+aS3QjU=;
        b=AEuRRMVa98nEBKG2qQfT8RepXphEUpC4YVUkXgtdIolBu3jzrP1QqIHSEFZVNmBx1i
         RnjCQHGUEzQ1cD1a1O7XREJEJa4HxjREGYdsycsHE8yIUZrhIML8joaxQa2/Jpt/C6NY
         Rz4275LuPBMBWDy0oPnPJXGUInlEhRmmqaFMuz/GDLURJ5VOsgIldbF0SROiVw2CLA6L
         IShGPMyhTXIl+jywTscP/NMW1FHavA46eFr8mIxxyPcrxM6aePrSPJuQX5H72PW4MpGg
         BIXzbUiQCnnF0ww9vaTpmNweI4EDowvrjo98drujvuCkcjFt/gHzt8S1HjfE/KeKyBuU
         HRvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771260710; x=1771865510;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x44aAcQjnWa1QWZK/N7Lh2pdpMQOoZvekrVC+aS3QjU=;
        b=NTbOFfzSIw3Agsgbp/CsM4UKoNV3EziZZ/Vb9UBipWmMjZHwx/NZLmyHMeg5nHJxhZ
         +DFcnz4EOuVhJ9laJAhdFrt6K06FP+aNJ9C2qfiCUyuB0tSbCna0Mr6Qujl7HShZ+oRu
         6GfPhsphrt9YUmyNlPUS4F22RUwxf9sFsmRfcAzDdsnqhmzVH7NQOsP3Kfo8PPrR0kGI
         Hu2QIblt1OWQzH5iclZbRsrr5f1eLfOpdNRzyuZ0uu9pYfaRcQKF+OMLv0Us7PQw3Hv5
         Gp8MPFg3j29dNNJBuoj7JKwsAJmRcPbUVNlhwp/AfyG/aIlWF02s0hl5oCoM+HsmZcgA
         f3NA==
X-Gm-Message-State: AOJu0Yx4XpbWVdBmzQVwSDyUFjEATlrv+3DY24LbUYIp1x4ZkyI9Sjqt
	4U9pNGYhuatn8w7VGdIvu0P/NP3fw3q2wLlj6zP2zRG2eUD6h5enzrCazUKcc48A
X-Gm-Gg: AZuq6aJI7OWS0GEUV0OW217M2EYegl6ROneD7uCk4ITQA59sSYB+UX98uL8VT0TrOlu
	rg2oUYwyWh+AXehcR8SzhK3immYdg49FbM3LbHtQVSs9dzhhT6AnChromjdiIbiIekQMhsOwuFy
	Es423yi1JO3Zi7DyIh9MfI9uIXUl+n+7kTdAzDJY1kLmwUbjkGz+jkwgziBTZMmxXSPVGKS5vOz
	xDoCeVoPcq3wKqM5qgnmPCwuVXs/bdgSfEVFNwMRdE8oAJXxBbL+V6IBIBPexxZR9iK9fu7AhUW
	RvV5j9zYeMYWwx5N1xzpCBm9BMAa5qUVFUZsLaRQ5AoquW6vUnYdUv6KdKLAyO3OlK3NM0EbneB
	/k2Qfk4YJlR00sT3rPzYElAYAvbM+qgHrshvgUNEu6LPfg5w3PoESxrIxK4QYfLkirPmM7C/rLW
	AM/p3N8RIjZQwopSA8rqVsqOIMapxtPB8nHluOJBjbSA+gdzvfFzm1K1zw+8MEdQMXnGDsw++f+
	/n9fKfc
X-Received: by 2002:a05:600c:348e:b0:47e:e2ec:9947 with SMTP id 5b1f17b1804b1-483710960eamr219840995e9.33.1771260709783;
        Mon, 16 Feb 2026 08:51:49 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837b64b08bsm76454255e9.6.2026.02.16.08.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 08:51:49 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v7 3/5] io_uring/bpf-ops: add kfunc helpers
Date: Mon, 16 Feb 2026 16:51:24 +0000
Message-ID: <de06ced9b6cdbf2e300d888de02ee061214d0e88.1771260487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771260487.git.asml.silence@gmail.com>
References: <cover.1771260487.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12263-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7A3AF14678F
X-Rspamd-Action: no action

Add two kfuncs that should cover most of the needs:

1. bpf_io_uring_submit_sqes(), which allows to submit io_uring requests.
   It mirrors the normal user space submission path and follows all
   related io_uring_enter(2) rules. i.e. SQEs are taken from the SQ
   according to head/tail values. In case of IORING_SETUP_SQ_REWIND,
   it'll submit first N entries.

2. bpf_io_uring_get_region() returns a pointer to the specified region,
   where io_uring regions are kernel-userspace shared chunks of memory.
   It takes the size as an argument, which should be a load time
   constant. There are 3 types of regions:
   - IOU_REGION_SQ returns the submission queue.
   - IOU_REGION_CQ stores the CQ, SQ/CQ headers and the sqarray. In
     other words, it gives same memory that would normally be mmap'ed
     with IORING_FEAT_SINGLE_MMAP enabled IORING_OFF_SQ_RING.
   - IOU_REGION_MEM represents the memory / parameter region. It can be
     used to store request indirect parameters and for kernel - user
     communication.

It intentionally provides a thin but flexible API and expects BPF
programs to implement CQ/SQ header parsing, CQ walking, etc. That
mirrors how the normal user space works with rings and should help
to minimise kernel / kfunc helpers changes while introducing new generic
io_uring features.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/bpf-ops.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/bpf-ops.h |  6 +++++
 2 files changed, 61 insertions(+)

diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index ea9c062a4d9f..1cc4fc647add 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -5,11 +5,58 @@
 
 #include "io_uring.h"
 #include "register.h"
+#include "memmap.h"
 #include "bpf-ops.h"
 #include "loop.h"
 
 static const struct btf_type *loop_params_type;
 
+__bpf_kfunc_start_defs();
+
+__bpf_kfunc int bpf_io_uring_submit_sqes(struct io_ring_ctx *ctx, u32 nr)
+{
+	return io_submit_sqes(ctx, nr);
+}
+
+__bpf_kfunc
+__u8 *bpf_io_uring_get_region(struct io_ring_ctx *ctx, __u32 region_id,
+			      const size_t rdwr_buf_size)
+{
+	struct io_mapped_region *r;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	switch (region_id) {
+	case IOU_REGION_MEM:
+		r = &ctx->param_region;
+		break;
+	case IOU_REGION_CQ:
+		r = &ctx->ring_region;
+		break;
+	case IOU_REGION_SQ:
+		r = &ctx->sq_region;
+		break;
+	default:
+		return NULL;
+	}
+
+	if (unlikely(rdwr_buf_size > io_region_size(r)))
+		return NULL;
+	return io_region_get_ptr(r);
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(io_uring_kfunc_set)
+BTF_ID_FLAGS(func, bpf_io_uring_submit_sqes, KF_SLEEPABLE);
+BTF_ID_FLAGS(func, bpf_io_uring_get_region, KF_RET_NULL);
+BTF_KFUNCS_END(io_uring_kfunc_set)
+
+static const struct btf_kfunc_id_set bpf_io_uring_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set = &io_uring_kfunc_set,
+};
+
 static int io_bpf_ops__loop_step(struct io_ring_ctx *ctx,
 				 struct iou_loop_params *lp)
 {
@@ -69,12 +116,20 @@ io_lookup_struct_type(struct btf *btf, const char *name)
 
 static int bpf_io_init(struct btf *btf)
 {
+	int ret;
+
 	loop_params_type = io_lookup_struct_type(btf, "iou_loop_params");
 	if (!loop_params_type) {
 		pr_err("io_uring: Failed to locate iou_loop_params\n");
 		return -EINVAL;
 	}
 
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					&bpf_io_uring_kfunc_set);
+	if (ret) {
+		pr_err("io_uring: Failed to register kfuncs (%d)\n", ret);
+		return ret;
+	}
 	return 0;
 }
 
diff --git a/io_uring/bpf-ops.h b/io_uring/bpf-ops.h
index e8a08ae2df0a..b9e589ad519a 100644
--- a/io_uring/bpf-ops.h
+++ b/io_uring/bpf-ops.h
@@ -4,6 +4,12 @@
 
 #include <linux/io_uring_types.h>
 
+enum {
+	IOU_REGION_MEM,
+	IOU_REGION_CQ,
+	IOU_REGION_SQ,
+};
+
 struct io_uring_bpf_ops {
 	int (*loop_step)(struct io_ring_ctx *ctx, struct iou_loop_params *lp);
 
-- 
2.52.0


