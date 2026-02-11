Return-Path: <io-uring+bounces-12168-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4P/UBPnSjGm+tgAAu9opvQ
	(envelope-from <io-uring+bounces-12168-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 20:05:29 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B121127016
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 20:05:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 59D933023DC6
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 19:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29CF34B691;
	Wed, 11 Feb 2026 19:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iuADs2a8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8682989B5
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 19:05:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770836702; cv=none; b=QoARTW4GaiagLK+2YKG/hNhw4mF9yskvb8z6nE/1jeYNFzQSADRXSG3A6ejho9395WIxI8fqxQyUWEMh8ZILKCDPySc5SP+w23r+hBXJ5BXz7kwJu/x6JJjdpX2o++yz4bTF5FD4/PlSwQs4q09/Zma5wN1yuT1PMiNoCoSBT6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770836702; c=relaxed/simple;
	bh=QE96R9eicSGpjinXpGU8uaHaRIew9YzdrFxbUp3vIgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dXmdHJ1MarDeB1QIsOTJRi0+VOp//ROxJWnZjzHSkCnBEp3nWWSQnrzoaSfy5XsJ7o5eOdh02ojZB7DySEBLF3ZwY0DEZbJGhC7SOlUGOBjNHjmLwfBmrSbnMlIcE5WhPDDR9D8Wx6Sh7mWTV7heHSqs8jyhTyizsEKOGiaTcn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iuADs2a8; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4358fb60802so888133f8f.1
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 11:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770836699; x=1771441499; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x44aAcQjnWa1QWZK/N7Lh2pdpMQOoZvekrVC+aS3QjU=;
        b=iuADs2a8Y+WNRVySQoDGSIt7XVCMA+QvGYXLpXnaC2tVV71Xzh2jhjEbuUDFI3JmIo
         bvybXthbl+tD0LlME8VWzLjvPxLJi3Kp5QWlKIEciYsfilBymyx/4dCNtYUAeowaACdA
         Vc853YZVyyfJtlYZisgFvi83mOGlHuKZxF0qIcCM+ejOqeTdvTrvWYl0cum9QDBQy3SZ
         0SGIZyRrFl5ir8eVcAouHQN+ikmgTmD093vLZrd7bJQoJZgIhgTgQkgcwhu+PbiSekjb
         w4wNYL5nQEGz4JCcDVqgboC3A6qNL0YfErDIsxP8dIyjL7s34N9f2tfljPzCrYj/N3RI
         B92A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770836699; x=1771441499;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x44aAcQjnWa1QWZK/N7Lh2pdpMQOoZvekrVC+aS3QjU=;
        b=RMOBLYOCSEeS0d9ZjJnazByVsk4ftZ+KZgRpZoN8uCsw5c855VqtizkfJkpCV02LFw
         uy2O+tyEftPumNxANae7m4yuGpn3i8k5CEupxMWBmsUoag77cA5CczB+t7MLb2RHLwIZ
         6Oa1SSQN8Qz5wCFwHDHeMhV0h25QCXSQra7MmEnk7F99HONTUQIRty2oYDNoWOgyOm5k
         XuKxWsPeap2VCX0TKp1x4rhZDyRTbtCq316IzfzuG3rBEaSfej7e6TuMRKUiKQdZvWQ3
         uzOkGX2kdZkMuM1OV9nFawGFGY3ZReVUjc+Fahgq4JVmX+B/hBL8E0anci3TNbLOTYVa
         2rhg==
X-Gm-Message-State: AOJu0Yy7je/QKi0ygmYdtSpJ9Z48PrEKWUg2azb0i6pdSKyhe1gEgm/n
	Kt/tEdot6ujMdcXRNeFb4tg6FuUGQZ9jAD1mva+L2EArLFZoMSjvT8Wdmd6O91pX
X-Gm-Gg: AZuq6aJrkULvBwS+WISZ10wEyqpaNDSm0BuRnap4tqVUeJvOApTZKBO8skG5c5tu8PO
	tubgBdsOUiEAy+JvIEezHu8p5EuXglRknKN0j3GHvasPBM+sSjqiysWHizT8ii3i8K+BURxlNR9
	PYcETly2HgwMMbg94KazcOA++dJkmDLPTH+MQFtCIpxWF/gMkmPJxtSG78K1kvqSUeMe8a7dD7W
	OSj5PcKakXGPzg9fkOv/4UD6uD2Nucny3qhjlen0c5txoMi2N9BLJSNTQHqIuSEDhWaYkxE5/sY
	Fg1M+PFIg0cQV9pYnm7XQ4W1mqPQE9O7N1dBWmnKYSMvKL4gf+HdRy4CdVtwsecRKqXk7IqUP/Q
	zCjDRD9wCoxzlOXNeFDa5Yp+dy4pyoN3GnDglqnU/lhlI2VSFSU2ttKOXTINR75qogp9fNqHD02
	60PK4BI+sV/gm1jZZX2Oe5mpkWf3hribmgYVTof6uP22rdVskdT8L3udCuj32kKEh5ePfHlDay4
	OJFAboKPKWexrqpbL4x++7RHKpa2A==
X-Received: by 2002:a5d:6702:0:b0:436:15d3:ed2e with SMTP id ffacd0b85a97d-4378e3dc0ebmr22729f8f.0.1770836699462;
        Wed, 11 Feb 2026 11:04:59 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783dfc8b9sm6174169f8f.24.2026.02.11.11.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:04:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v6 3/5] io_uring/bpf-ops: add kfunc helpers
Date: Wed, 11 Feb 2026 19:04:54 +0000
Message-ID: <d0b2f03831b4ea7caa39956325bef1a3b9653b4e.1770836401.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1770836401.git.asml.silence@gmail.com>
References: <cover.1770836401.git.asml.silence@gmail.com>
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
	TAGGED_FROM(0.00)[bounces-12168-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 5B121127016
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


