Return-Path: <io-uring+bounces-12288-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gMh2J5BSlGl3CgIAu9opvQ
	(envelope-from <io-uring+bounces-12288-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:35:44 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DFE214B726
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:35:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CA647305C293
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:34:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05DD5333740;
	Tue, 17 Feb 2026 11:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LsTQMwdU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5F0302741
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 11:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771328038; cv=none; b=OB7FquvUkbYQu+/aeiLLUby6D0HdCke5VBdXNQuBAJfmWc6k6VZGErxV7HXReKIQEtGHDndjUXI/EsP5ihGyUHqRxdl7sgxBcKHiOfmxkuAHpvGeLuWkToN43M23xZc3D6jh4DhZkrfcfPkKLDcgT8nOdsEmcJxywXN5lEYDhNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771328038; c=relaxed/simple;
	bh=0On/O/JwrdhLe9LQEIpHxWB6lwVhQOmEdQjLmrIM6Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsUF6X4wo3QJpVjZ+W5wrq1SiKsY6jNqmxoz4lBtWuaasw3weyRKarrwyOC4Tjm0tqo40tvuvUuvm88QDBzxm1DSvvFx7+PBoveNJMlzgOvC/VNo+FpuGbFBDEMlzTCNrQIYXZ9OLEl9digcbu4PAZXUYZVfkxzFbnQFJwo+zMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LsTQMwdU; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-436356740e6so4887469f8f.2
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 03:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771328035; x=1771932835; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHo+GhzwemN1oIIYYrO9jf01kzrJwN539Cek687xENU=;
        b=LsTQMwdUO7R/oHp53J/BkdOX8FqB2/4KcaQ2t4e7Z6lTX1u0AMH+4XPhVfrKNBHh0R
         lm//1G1aKhSklRvvx9waFlTibXW6LpFIHS6kXPdUugbQ+77PtngISLZfwFVH3JF2s0vI
         Qx0LebE+qpuUhr83Ts2NTsE4/VRTCX6e8t62o0nulyjanBT3HtOpWhlN28NwILBC/NCb
         3RCb3qfmxYnNsz9CzW+6M4RCGCs7dMWOHthi9Z3F6PCYegOTD02/Otyt5g60l63MyZOn
         j4F23P+Rqe5gSvcGL6/NHlV/ZwkxDbjuRSW1cX24s3nNqQIN+Tr117doQ0hQoVGOgK6u
         kPtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771328035; x=1771932835;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nHo+GhzwemN1oIIYYrO9jf01kzrJwN539Cek687xENU=;
        b=a1NtfUXrsQn+dJ/xyg86zoahYn/ylr/3e7wRLRnxxiYRMLxAbTaBpmIssgxvjCQ1Vu
         VRTbAoKpGrS3/1Mx/Jiy/vEeBHgDDCnm6KjjFnkEP067vvyTF+DbeMjrXyZ3KrSVg035
         Lm0YU8JNSz5FdzVKT2Ah8p8rvC6ajgeHHg80xrhWF8KckzzZuB6194Zt6ZXmAIy6KglL
         eKFEbcFwA2O7fvlhzy25EPb6cSez7gWYHjO4c2hM8ps7ioc581edFJKguTUpDV/mPk6I
         trjmHCIdduG95hN1BKYRmUq8V6dYtc5fkwRkqlKZV6d+Oc6x7ALGnTrN9OhTbfo0ISGZ
         eahQ==
X-Gm-Message-State: AOJu0YwdIoknUulXU7NEC24s011fHrRVx9+468XDmvsA+RLS9/n/jVjz
	82CaCueN/BQGi4lUJsIEApni9K+0uuynOG3sqXdAIL2HQVqS8BUf4M9nwGYNMw==
X-Gm-Gg: AZuq6aL8G5zJnsqHCKIG1Tby7FOJpCN9hSFrq8NLTbRvMBS+sY6PYY6BxfJcqh6hRO9
	IhkuoyL8pxXBPJS6xGVCsCz5KQIYVbK1aIE7cXb8MYUiQ2GVmj5VV5Bgv93lQ5iP0okpHsQStgT
	PDBcK6sb7mBvd8g3kpXpU2AFM068a5xDo/yWXb24oN5IdEAjxawtGOUq19IDnbPUYmlvra6aLMK
	rVCOECct08MdTb/ja1itIJWEaIvySxwncxg5K+v3vyay/r5qe9nTH0fmD7+AqHTpxAdZstPYFUR
	BUyN/DwNoFq0tNJw6ssiJn3EXFrH7VTGONYr2kRNQfeOqrYV3Hze9Th7ONR2q0VgoPpiYYakitE
	MOpgUp7FtD5r601lJl+kvbu37pX1Gi/2iaiAUlfXs42UoKTU4SyJ/uPu1JwSS8IvvWgPxdcgvti
	avuMzYSNVIR58tUfGjEVQDuMz12mlXrRfWGU8+63giVfz/DyCBC0z8AC0xyl93mOX8lunmBUpgB
	Dc7Z586KAS+Z+SsoZGGEd0irXcEAQ==
X-Received: by 2002:a05:6000:2c0c:b0:435:dba0:7c0b with SMTP id ffacd0b85a97d-4379db31b43mr18479219f8f.3.1771328035155;
        Tue, 17 Feb 2026 03:33:55 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac800esm36258343f8f.27.2026.02.17.03.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 03:33:54 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v8 3/5] io_uring/bpf-ops: add kfunc helpers
Date: Tue, 17 Feb 2026 11:33:45 +0000
Message-ID: <60c053a451afc4307230a7e8bf08a97567cd5d96.1771327059.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1771327059.git.asml.silence@gmail.com>
References: <cover.1771327059.git.asml.silence@gmail.com>
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
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-12288-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 3DFE214B726
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
2.52.0


