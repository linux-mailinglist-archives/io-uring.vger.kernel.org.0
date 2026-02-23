Return-Path: <io-uring+bounces-12370-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YOyBIgZgnGntFQQAu9opvQ
	(envelope-from <io-uring+bounces-12370-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:11:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EBAD9177CED
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 15:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A5F13068ED6
	for <lists+io-uring@lfdr.de>; Mon, 23 Feb 2026 14:10:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12CD027FD49;
	Mon, 23 Feb 2026 14:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jW0CFaOc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEB627EFF7
	for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 14:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771855848; cv=none; b=OXa2mxMwiHd02VG20mfze71FRkoXD5/Z76CdF94NLw9ioGXiRUL4ROQb4K+IrdT+qhON5WZq//DzwgE7YYQIAccjwGNoFYp55B6ahP10nnzd7Usdh8V+WCp61oBotJhSAMlcSB7pDwpZBHR2Ji5ieBn/DMK6lWp5VnNsoxNiaM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771855848; c=relaxed/simple;
	bh=SzOVkdAJnAZVcqrU09MenmaB/QPocxmGAqrdT+QS6tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVzqmpLeUQQ7aAGfJnmQYQb7aJdX3A+UvNR1C6JC6FD5xZXkZp4woGE86t662DC+FrtiV/I5Q3oOY/V+pb8QmMBkRyOE/NDj5rntUeQRNMunInIjz82xa3Kc9ai/ETJlTZR/X6rP9j5hnlDvBy0FkX26xrI7gk/i8WOcgzV8/is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jW0CFaOc; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43638a33157so4093018f8f.1
        for <io-uring@vger.kernel.org>; Mon, 23 Feb 2026 06:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771855844; x=1772460644; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSRqAwdk1Btnm7V8ndK1fwdFXhphECwdHx4TrxZYE2c=;
        b=jW0CFaOcu3k3Ao8Ro4b13Vz8Fr26RQR4UI8vDGfWSgvZv5HWVqVkJUtBXrgKh/z1A1
         rLmlKGJ6QkfBpeZds1qoKnP8KmPdnbUwIyVL/8yp9w7CnHPbAHU8J5GwhwRmRZs29f30
         C+sW2e+F4Qz7AZy1qPE8zzR5KMsJCts1rc8iELq33xW6m46wMc4S9uOYBvF2gLEZuK8K
         cf5vt2fjpTSfKtEnDfHmUcam7OPYlu/PCd/xCDkNYWI5yMhLSBby4/1pY4ELiWMbY5ah
         VrYhSuIPZNaxH//mM3k0iNsk8kFFCm2ySxh4IkaYXlfQ8kK2JK4+qVYABakMGXhzwjGu
         DsKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771855844; x=1772460644;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kSRqAwdk1Btnm7V8ndK1fwdFXhphECwdHx4TrxZYE2c=;
        b=SHxdrR6mQ8zBPul0TKVzj4m1V6NBY4oV+lEo44+G3wLZQvdvqlPezMZbD0hxfvhbaz
         vK7L2ccQhM7vyMIeGGAReZwmb9Rwi7XhI/nAokg0Wjsyc2ffTNNkz1l4RS5Eh88pDN7Y
         4sdfUBgV+XI7bNq2OJjJ2Jo2yFB8OtxBjYRmBOO0Cmrvbx/P1pQLoeZrTzvdRsVKl83N
         yZSVfsgLuOMIh541eU0fiu4mjjithssFvV0vQEw+GUpGFcKrFqiy4/xSvSU9QZIyw+Ge
         ngXp7jhPmCYSuHYaHste8ccAskT7meUYoLA9iwJQgqGyhHJi4FC0C99nfwvPAjBlZr5y
         MU6g==
X-Gm-Message-State: AOJu0Yw26hzHYhhHH951TWSeF/s/VlRY9tNWsWWruZICLrXtZTuPLDqy
	GpsbcK+zVcpu8EoJGE+c6hZFLHZDiwyF2Mfazy4lGKVJTGSShsR1ekgvxV5hQw==
X-Gm-Gg: ATEYQzyMGHscH06NPe6q6ezKlT0wjBfnoNG/n3dCEPKg8u/CB6RHlafTQ+SfmieZKTT
	J+diKSBObuFsfXgaTka+SsA02ub4ixKsZjhz120fFhW/QkNICJgSCwpdA79brN+ZQpO86ZoiEKh
	x3ySYJJpxqHfbpPIi6lO2VhYuNqwmBYx9cjwPR3PTFD09QErh/8VxbEL9cA+S/71Cua5tyyx6/U
	fZUA/AP62jh153CtVrLwHTdLmsR16hxzedEfoU2p95vsBtqOIcKEjwVV7bguXUSM6aP53gkEXvz
	56Y8j1fJezd0tM3EGbszk5LvU3CBDRceHmZvk4H6YA+wI+JewBKVnUnEXW/1G+mygkxBTChem41
	ZN8vk7YWZfoYuZFd0ycfOwhB4E5NMp7ijqEXxwS1lC2LKXpvDCuupSqFtCzVMPoc7PXok/EYTCc
	+VTS60JuBALOkJpJA2Ym1N65BZy8GKUH6/96k6RB5a5dCkFG3vhb24ayJaKZAGxemrkNrJm3cLM
	rvn9sLtkvWYGlCWzmFY
X-Received: by 2002:a05:6000:26c2:b0:436:8058:449 with SMTP id ffacd0b85a97d-4396f17b48dmr16230773f8f.45.1771855844380;
        Mon, 23 Feb 2026 06:10:44 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:36ea])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970bf9feasm19464640f8f.6.2026.02.23.06.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 06:10:43 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v9 03/10] io_uring/bpf-ops: add kfunc helpers
Date: Mon, 23 Feb 2026 14:10:14 +0000
Message-ID: <60c053a451afc4307230a7e8bf08a97567cd5d96.1771855761.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1771855760.git.asml.silence@gmail.com>
References: <cover.1771855760.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12370-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: EBAD9177CED
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
index 975db5a78188..17518f4ecca9 100644
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
@@ -68,12 +115,20 @@ io_lookup_struct_type(struct btf *btf, const char *name)
 
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
2.53.0


