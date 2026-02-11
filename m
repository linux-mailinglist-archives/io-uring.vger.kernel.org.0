Return-Path: <io-uring+bounces-12153-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eEvnBFqTjGlIrQAAu9opvQ
	(envelope-from <io-uring+bounces-12153-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:34:02 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D75512547E
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:34:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2861F30238E0
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 14:33:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BDEF153598;
	Wed, 11 Feb 2026 14:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ar5QEteU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F52B2C15BE
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 14:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770820385; cv=none; b=FOmVvx/X9pOfUuBNKMQvXWn6yhSQ+BFE70RAndr4iygfQ2m3Z6OLX8cC4RH2NC0lXah67IpCQBwmcpY4+4CrohtRVUIONPwrqcdzredQy6dzLGielnGsLO0tiETHAW+1W5DP9LI5NjxEBLqt5fnl81jOOQcNvuinzbqY6iLfykU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770820385; c=relaxed/simple;
	bh=ALuKSSqac/+GM53UGJZlX8az80XWgYVG1bbhQsQ0qjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kN2QCUDEF2BJL4K6mvE4YHYfaUtz34ZaEJye46fgEalHhG8vgxkZBVx8m4uOK2WhOFcLQdc4ijqNmAfxGW7Du/oCpMa8m0qIUHextdKmYi7vJ88xUOhJ6oGSG1am0+5OxwPh4ydCLsUhSDwZroplmwlTHoA+YiuRiWHFyJzB8x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ar5QEteU; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-4362197d174so1399685f8f.3
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 06:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770820382; x=1771425182; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMIoPS42J6Pl/vzph2bdYRKefnhaAaVFjkhJhTrwf2U=;
        b=Ar5QEteUFJiiYP3nMG8O5EptBJHJv7KPMgBIxApKoQDwvdvJ6pkQQBgTS7PWL5YjRU
         oYuqYHrhFIIv/AkWRNWTaj6qMLE/d57YwuCqHfCxhkIyEJNpM5o7HYwQFny9eZyn8Ucv
         /YGYvzUqnQZme37S2BJs4Ad0MhSDIACAYx5GeeDRAgybkMgGpTO6ARW/E8PeGpPjfbgX
         6aLQ/4toqPRAqAaEM9hlxu71z1P+Dwkw11irQKXr65uicYs+qL6Xo0S3b+m3EEUeTUVV
         feisLNDpkd/4Bou7iYP3/WbEAiGW7o/PsLw/rgwSyFrHul9MHMjSx9CtNN4XT9k7b36+
         nJBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770820382; x=1771425182;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FMIoPS42J6Pl/vzph2bdYRKefnhaAaVFjkhJhTrwf2U=;
        b=MqmPPu2/nyouAurXsEvxkJydw/iDl8sKSjZWM8wBGPPbwkPjQrrGcehZEfHj76aAt7
         l41XYtfDREgTNuLNwucdLtAOUBE0ThU6U6Z8GGvWrgT1TElnbzICPbvXBj7ykEMQq09Z
         JuerKKt4iOp0YQ4Kx7Bdc54EGk8bVHORKbJN25jkMZ5CRmEU14HFtYpxSVQTworARh0F
         i7amXam0+J2OcmpT3uhNeux04uPplZXFOgibWhxlQtwJQUoQ9M9VwCHmQ0OTbr7K4yzR
         EtLbK5PJV393vuG13r6D8L6OyWYdE5m0Lj+ftM7UeI/INwhRL4K+OkmRAMTTqbAs6836
         CvjQ==
X-Gm-Message-State: AOJu0Yz6oba6DmYOY7iIBNX83izMH1ER5j1WSy400lOqkVwyMf41bSQj
	hvXGneh40kv+zcGMA8Vlit+t6CvRc96CyqZ0EKDxzisj60tlmeMMaE2R38elERR1
X-Gm-Gg: AZuq6aKD880fAgfkELA68o76wBI73apIjL5sF+SSPZSfyfsZBti67zD6NeUSELDnYrK
	VNbvxYP7S4WzfBCAZuRNcbmfB+39FO7HKR9lGtZKO9hsPq8AOGOANU8g5T45n7w4fMEMyxNzYPT
	Fd3ipQ+VpP2QpEXdNcySMDF5ZvGsroxlXeKn3K3iK6K3lbRPXsypB+UyTOg8zBDemLsvS9neifx
	yj7VtbLnkYJbCrHnNx8O4XMuYFN1P05JoyFm4+z8bs1O5ZZR0kgAR2Nga8YmH0wwDavyDzH4t05
	Pem/bUjTArry8uonLdVu+q6yCu/ytYouYLrrf+ax3To4JZuQFiXnR+KMVk6+sHlL+DVyCTS2box
	6Sif4Zcqer+PLNdbwaQIODIdCO4szkVjhMVk6Wmn3SE/25JO36gJaj+Gv2JxIO+2xkxaKlcFqXT
	TsJJubO9nVYULihXqZqS2CrXqUYgPvISxpeR54HzxrTh/UI1kzRBM8jb+7OaCpynyT2HjBnFZ78
	oK/6C7xBA==
X-Received: by 2002:a5d:4809:0:b0:436:32e9:994c with SMTP id ffacd0b85a97d-43632e99a5dmr18454994f8f.28.1770820381740;
        Wed, 11 Feb 2026 06:33:01 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:b997])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783e39c75sm4973747f8f.29.2026.02.11.06.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 06:33:01 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v5 3/5] io_uring/bpf-ops: add kfunc helpers
Date: Wed, 11 Feb 2026 14:32:42 +0000
Message-ID: <1ac15fa8ce52a0ebf28555c8353eabf199d1d49a.1770818588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1770818588.git.asml.silence@gmail.com>
References: <cover.1770818588.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12153-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
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
X-Rspamd-Queue-Id: 8D75512547E
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
index 7db07eda5a48..66938514211f 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -4,11 +4,58 @@
 
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


