Return-Path: <io-uring+bounces-12433-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iG8ANYhBoGmrhAQAu9opvQ
	(envelope-from <io-uring+bounces-12433-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:50:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EA3B1A5E61
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:50:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 72E8530E97ED
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 12:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CCFB2882D6;
	Thu, 26 Feb 2026 12:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xw5gfrxx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B19B02D0C89
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 12:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110133; cv=none; b=SQI0NXFWRO8SGIpB1uOdKLTiLYAthG26KRfFC686k7kB2pLliFh/NMLtjmVmzXhKDMb8SRyHi2uLOrMw1l5A/KxuIBnikQps9ImdOhf3xLAfvfip6MLhDpiNFPxKwLUZYD0isrFGu0rHx6JwI65r7qYYBFBS07aULh01FwjC9CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110133; c=relaxed/simple;
	bh=SzOVkdAJnAZVcqrU09MenmaB/QPocxmGAqrdT+QS6tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qs82dnyAFvBUMOL2rfGa8MWQewQ4q9KSks9ghNFth0NGwN4N9p8a+F1u4IJ5npltxsSglS2ubSB5nos/JYRm9rEjbXkXkS2J/aRs3P56+IeYfrozyswMFmKPkP6JX1BnbIoFb+YOb2KW423aZZsCD8SRnCzyJmhgN8W9I3jbY9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xw5gfrxx; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43990aa7dbaso635304f8f.1
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 04:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772110130; x=1772714930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kSRqAwdk1Btnm7V8ndK1fwdFXhphECwdHx4TrxZYE2c=;
        b=Xw5gfrxxcSm01Mu2mAgKvNOvPee11UujcsXBhpWMh4RhI1mvbV6BBExT7puwv8IQFw
         XPo0Qr99I1m5yjlhDG9+wUc1Cj6P99AzduF0E81PStF6/IFLCPsykja+FbU9uyghZCVX
         kRcqMeKhGmEfL6dE03FXtiw5+dUSHRO5yXJIw5RBi4QWkTlAnVkGqiRqj5qGBB8g1xf5
         LmIjVrW4wS5zVR8bBcwkI5kHqO48XH1Zbne3bAeSYo6HbHFFjC0bIaza0gUFH9Ge16r1
         rP8+hMAFrpZ5Xz14UYlWPnsNSKWQTWILZ3agHCXaVM7EkV9LSSz24yGH7l3QJDF4owf7
         D4SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772110130; x=1772714930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kSRqAwdk1Btnm7V8ndK1fwdFXhphECwdHx4TrxZYE2c=;
        b=uZo30pSHMdNQYdtZa5ee4/8ApgB925DPcjS7ToziCIeZQBk1ri0o4SzY5cRP5uo/Kc
         6UfH18/YITOwRdIvN8qG9eZ29+3khb988hgseBWLYGGOV8ndSqWz7uu1ZujkKpHD6LAs
         OlPd7LfM1N6i9Osbe86aBCYdeUtUjLiiUOA5MGStGoCaEyuDB31revkgV501XINzQ/Bu
         7uy+RckTeyu6MeIQIvPHbJzfyyfhZ53jSWgdh250YrvFK7SPHC1MU4eTvCb9TBnIIW8f
         MgYffdSkvV8O/xAcfpHTZ35iyPt5V3TdsnT7AT/wF+4sYG6bpozdRf9bJyz8NrGQf60u
         fSMw==
X-Gm-Message-State: AOJu0YyXejfxdkf7TOFtcIDqkbpb2A3zG0LWwY3VtJ3Khj8ipr0dztgX
	mHSlLB3s/94SQFFdGWEvaoEJRpj+VSHc0NSY7ThocQQKRkT8BXn5+i3x9qfM4w==
X-Gm-Gg: ATEYQzzyRQtTNTR9htLpNqoifJnwfZlGJKK241jhH1/EZQJeUP4mFphRjl9hdcvs6U9
	sBcZHZ7Nd3U2VpC15Px8F2uPvwHI89pDUIMY3HoweOQ+Lrsf1EzicxHU2en8bqJICkD9ce4AHqU
	nHEP5ADt9nAyz2l4D0gjuRnL/UMKhgkJpCSCyag1aeeoLjXEiFLQzld7W0Wc7nxB1YC1h8Wbcoz
	a646Z+XNVjvVsI4WnMtgDBSaIf6880vyE5GUfXJl+yt9WMBjDuJFVWUVq7fj0rS3OA5UrEPIU8+
	HtkwSRdsvCayuurFJJZBhyFX+kXfFFnNwbaRmA7JTb2W7n/cQY6UQeaEy2B37mk0JSKEXb7rIIF
	5dX3WL1AFNV23FUcYHiIvB4ErI8BxJ2GGhjshjUtZL8V3PvimWM3Jzs1AqQdjZgBg3zwwCE9JEF
	n8Rmwgd5+FWq0wmyRS99KwKDnTI1FhgsCtCdMwfuJYPEMuUdTVA7w5OTTYghG7PZGvhCb0hMTEB
	Klrn7jPpA==
X-Received: by 2002:a05:6000:2484:b0:432:5b81:480 with SMTP id ffacd0b85a97d-439942a5891mr7708251f8f.24.1772110129557;
        Thu, 26 Feb 2026 04:48:49 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2ab0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4c977sm43734576f8f.32.2026.02.26.04.48.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 04:48:49 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v10 3/4] io_uring/bpf-ops: add kfunc helpers
Date: Thu, 26 Feb 2026 12:48:40 +0000
Message-ID: <967bcc10e94c796eb273998621551b2a21848cde.1772109579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1772109579.git.asml.silence@gmail.com>
References: <cover.1772109579.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12433-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6EA3B1A5E61
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


