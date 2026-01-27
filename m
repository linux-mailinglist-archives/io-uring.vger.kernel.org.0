Return-Path: <io-uring+bounces-11939-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4DQoDmGReGmirAEAu9opvQ
	(envelope-from <io-uring+bounces-11939-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:20:17 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EDCF292A81
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:20:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B6CFD3045033
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:15:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C258B33D515;
	Tue, 27 Jan 2026 10:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ByHkNgLP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC57D33BBBF
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508880; cv=none; b=YaT0IZqrhqydzz76EmruUgoRqsm9zPCmw/ENngDIWoUqsuzWZAyGof+PjnSAZToMVZgkZ5MA3Q6P32tRiFieO57sNHjuKCAN7nLXzkHy8d2JdMvDr89QAP+TxvoJO93uKWibeWkMQ6J2b+gDxG8pXpKhO9I8DRGJyDIa6Mwgyj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508880; c=relaxed/simple;
	bh=L1txXRr0WP3BonxYCNZOPIwjeaYkutbDmL2xJFKCQTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVLfNdzS7BdmEQn8NxgbaCJVm22oyiuRe5OrEtmQSYQXQASdR7O5VbRGkwo7Akx9kvrdO55ZA0iD3KL9NDsYyv+HwYXCl0Z8LTaDzqE+LxlmHR0LFWcbmsvGOLRcKd8YPWvilhUZagGP+sgWvslFSe7mc1sbZBwAcIs2TSH0AGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ByHkNgLP; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47ee807a4c5so57128305e9.2
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 02:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769508876; x=1770113676; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/yxiZqRVDqxUO+Ik6iupVbcA9QXCIlo+OqwjMQNbXXw=;
        b=ByHkNgLPSY0VVo874T3zXyiTOzGA+1gXQgZ5iW9656uOyFihNbhjzRsQcolPARkVkG
         KFyKga2yGsbgI5y9HOu/xy7XhE5TTKZLVs0N2tIFLnQa51bmI5zVMl6YSEu9hYd/FA0R
         ooRQGlav39TeWfPbzGd7TY3503iWN/qx7SNDMavWXI5t91m6503noUheHNwW7bOPfL+e
         t+gzcuxhyHVZDv0zmSqByn3yZpJE27bAwl7+RLyrWqQ0d9H0MNdBsH27IMjp10qYY4o2
         jHytWsazny/mgGS8lKX+7gwq6dF1BpsmziA4p/at3mRm/wjRYLNYmwC01vWu62VnEQU+
         FFJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769508876; x=1770113676;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/yxiZqRVDqxUO+Ik6iupVbcA9QXCIlo+OqwjMQNbXXw=;
        b=avPiUw5x9JmEQQiMzzbZwTAZw92dRgV+AzcGkA9tFOOGE2izcZIT8WmC0qbqFqlcK4
         QqFTJFVyNQPVqbh/6OVZk9CXX905owS+CFB2ECmrfKeZ7kHv2Lm2vMgsy9JQiCI6x8HA
         QrzDuIHxLlN1ExlX9mtcdJeq0lEA26kp8eIH+kFDysxap2tlXy3IiOhj2sLhcM30+TpN
         1AorAPeuAg3tnZM2rf+OULZQlWV3h/qrFK/NZe6qwuyUdvo6i50KI4m676utL4/2M1e9
         Bdyl+isLXMwd7lCSgzFMThyCWhBnXt08zUDYIk6izz3Lmj/ubxAT61XvT3D+O9k9877s
         /Z3Q==
X-Gm-Message-State: AOJu0Yy/GJ1A9VtEuKx0j0qQhtBXM2hZaz9QVfIAT/ZL/nOIRD+SU87t
	wSFVczfai7/bri4N5E+plM9NQ/cGo1zc5Ytut14NgOCSNabPnh6Qp2GCg+mbrU0Q
X-Gm-Gg: AZuq6aL37x0X9Z732KgcJvdMvDwncOMu0bD9KDs9uJBeZt+/DdYcE5IrUkw/2fb1bnF
	tcUpQiJIYpDQO6KsPwDJPPoOLonCBQHlnCS4GpceLXbNT3XljokW02bcnZMOBASfz5XBDT87jxB
	406hY6AKnObrdOpqpoZGUYuXzYktbXcgj9c8c0pHjIfWjOWQ0uUTuHflOSlJJeWWnPj5nMb5fKC
	8RXlBRZsJSNbQ7gnXSY9KkFmTNsXIXUdebKTE00LsxRvxfURjbBAt77D5eTp7gcH2wLlrtfjGYv
	GvJaqV2k6mRWT0hWMBNvk4raDeRuAt1mwLUPn0w5erjAMWt/WZJq5cFGkBKz2JEFQq5IwJynY9V
	gxt1h/7rRViRtn5G0ChrwUGYtYMbv9pPABdpkuVoHW3RYjgxruEaEx7+0V67c2ziBsiBJzhHUGP
	+bSaSw3IlWRj5wIWrO1vjpLioYrE24+ACrPj2BwSmHM/JAGKczjGtxw1EP2TasO8Aq8kp8isv4I
	eR5jTiSP3Tp9bEnGg==
X-Received: by 2002:a05:600c:350b:b0:477:58af:a91d with SMTP id 5b1f17b1804b1-48069c0de97mr14335675e9.5.1769508876258;
        Tue, 27 Jan 2026 02:14:36 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c24acdsm38190407f8f.13.2026.01.27.02.14.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 02:14:35 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org
Subject: [PATCH v4 4/6] io_uring/bpf-ops: add kfunc helpers
Date: Tue, 27 Jan 2026 10:14:08 +0000
Message-ID: <a896c564835ba9adbcc659a8f2b0dbe6f63409b4.1769470552.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769470552.git.asml.silence@gmail.com>
References: <cover.1769470552.git.asml.silence@gmail.com>
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
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-11939-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EDCF292A81
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
 io_uring/bpf-ops.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/bpf-ops.h |  6 ++++++
 2 files changed, 59 insertions(+)

diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index 7db07eda5a48..ad4e3dc889ba 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -4,11 +4,56 @@
 
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
+BTF_ID_FLAGS(func, bpf_io_uring_submit_sqes, KF_SLEEPABLE | KF_TRUSTED_ARGS);
+BTF_ID_FLAGS(func, bpf_io_uring_get_region, KF_RET_NULL | KF_TRUSTED_ARGS);
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
@@ -68,12 +113,20 @@ io_lookup_struct_type(struct btf *btf, const char *name)
 
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


