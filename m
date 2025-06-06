Return-Path: <io-uring+bounces-8252-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1B9BAD03A3
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 15:58:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CB9B1713F5
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 13:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B34E328A1D8;
	Fri,  6 Jun 2025 13:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DnkOUMVy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAAAE289E1B;
	Fri,  6 Jun 2025 13:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749218212; cv=none; b=X9ij/VJ43QFH85MJa42KqbBZyRcFIKnEen4Q7FxSHr+0wZ/42TzIC4fP+H/iGZUoGh5MYmgEntfSiPDERwTOZ2aeQnvAxP3kTZnZO5AEwhjmBC121zuPesggDuXTdVidEtqIBA1IiDXqjlvhqATfKT2xR7f/VAKf6o13a7/4V1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749218212; c=relaxed/simple;
	bh=6XuUXclfgoEKljVaIZCM2rGLK7pYyEG8d9ML+mCyG1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8sWQeZybx4SgeC5ivSoCFmT0aMIP5mPJ8lJP4NtOuVk5mDkHm3A2D0KOrYhDUzCFV+kPIKWtBrlY/LIB+xzFRJwVZ6Jp9KcuHaEDyR7YHe0RpECUbuyiUSTQgywD3oOY3CvtNYiytiOskKzt51rWB9K0ZgCyftyGl2ibuOVmAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DnkOUMVy; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-adb2bd27c7bso342193466b.2;
        Fri, 06 Jun 2025 06:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749218209; x=1749823009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvUd63Qr4Uj7TI50ZVFoqkRT4E5BfeemVFyk/+/NcyI=;
        b=DnkOUMVyYh1qZ84LvYOqpK1J2zChMvMwTvckKYCvF1xYzdk+2FM8KhwbRpmlJ0qWvl
         Vkj62lwzFc0TLLxgBgc/XTNmwqPPDgLobrQUbX9MqwgLSQeSNN7Sif9VhakHUbxg/lAw
         iGU43ok02uwgcrehgtbzAUdq6A5u4CdBfYWZGDozPCYG8KfKHUmd+YXQYv3qusnBp8Fj
         OMlBV6KViefJ4ksoW1xjC41Zq31MRLrNMbRgh35SZVjw1dHac8ixa/ChpyAPVA2XyQpy
         m7XJtbbxHIk3Hzx2Yz2Flw4WHnjWjJjPDPKAq+InfTR+/FZuiiCX6fNFl0xgyJStSup4
         Yf+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749218209; x=1749823009;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fvUd63Qr4Uj7TI50ZVFoqkRT4E5BfeemVFyk/+/NcyI=;
        b=s3KQwRzx5/HLvFYNva5IZQN4dy27quNZojJWY/6XsnpmlhAOJ7UzHlmbI7VVnA1/CV
         u5euLbPM3qdkMOVPzuRUn2sChmLvJESbPmJEA01eGOmV1yV9qBPqR+THcBMHbDWtc/rS
         az4c5u3Nk7vqNO38xOOwEM3tl9adC0Luo1iBhU15nC6iCSpKSdppWFNU+Sad9LL8MY1x
         VupuCgF89K7vdyoTgsRShlmStBqfsUXz83wNNG0guNGYHRqyle7ihXNKK8Y131L5y4N/
         vleD0czanNdVRHXFG4WtXDAe8sLzDr6SrzPF+IKWT3r0hIvJpGL6m4LqNCN+tL0qmLEW
         LBfA==
X-Forwarded-Encrypted: i=1; AJvYcCWr4eHgZFaUGz0CBfI3AQrc7qpbbw2Z64KOJCMI7TbeOZ6X0KSRMyAtcAJv9veUiHxTYe0=@vger.kernel.org, AJvYcCXDX++ZsAA7+Pss/HOnDRSFBjtcHbcwu9fBk/BBfo4T49cH0dLfk2YjcwvIJUhyUd27aKReOVEb7LMzmGwp@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4ZMCFQ58tiiu9inXW0GsNrzB//gggiClnhDHvtxjfMNhq295a
	1Sj5wn8ixGQL4Su6cDvbFvJQnxD731ZN4InGr37yF6/ttFjOkZkwghEXpdl65w==
X-Gm-Gg: ASbGnctKo1l2EziC4vshnllekvOs1TCAgyrUWxWyLTAUhyVlBXa/xx2pRxLlZY1NspR
	M3tVB3iWKYCQjWW64Ay1/VBuS2ASxo+hI6dX7nNB1N65a7Y5y/a/F8kCXVnG2xMCjNL98vbbsTj
	laWpZ9EMn+W0ff7dscEWuVM+rcxAWTqGo8DjxjfA5XG0csvds/zQFOLvcSl4QBnVS9X9omz+Yie
	2ZDqpR+fHiHQhP/7RBSpkjTB1x6vHtwu+Dn9Le+iDwSNS3E5pI7Qvn/0Y4769+n9dUWqdt+2fMv
	kT0oxZlb+zIcLaPjDlNftwPW62ZhqJ5UY8XxuvwOCSVjyw==
X-Google-Smtp-Source: AGHT+IEsx3hUnaelYT0aEIVsQCZHO0xm/AdKQqvAEwfCIS6P16J6XswUGs8Rz+chBLEDz7p9hGnd/g==
X-Received: by 2002:a17:907:5ce:b0:adb:469d:223b with SMTP id a640c23a62f3a-ade1aa469bbmr277091866b.49.1749218208386;
        Fri, 06 Jun 2025 06:56:48 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a199])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ade1dc379f6sm118026766b.110.2025.06.06.06.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 06:56:47 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC v2 5/5] io_uring/bpf: add basic kfunc helpers
Date: Fri,  6 Jun 2025 14:58:02 +0100
Message-ID: <c4de7ed6e165f54e2166e84bc88632887d87cfdf.1749214572.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1749214572.git.asml.silence@gmail.com>
References: <cover.1749214572.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A handle_events program should be able to parse the CQ and submit new
requests, add kfuncs to cover that. The only essential kfunc here is
bpf_io_uring_submit_sqes, and the rest are likely be removed in a
non-RFC version in favour of a more general approach.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/bpf.c | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index f86b12f280e8..9494e4289605 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -1,12 +1,92 @@
 #include <linux/mutex.h>
 #include <linux/bpf_verifier.h>
 
+#include "io_uring.h"
 #include "bpf.h"
 #include "register.h"
 
 static const struct btf_type *loop_state_type;
 DEFINE_MUTEX(io_bpf_ctrl_mutex);
 
+__bpf_kfunc_start_defs();
+
+__bpf_kfunc int bpf_io_uring_submit_sqes(struct io_ring_ctx *ctx,
+					 unsigned nr)
+{
+	return io_submit_sqes(ctx, nr);
+}
+
+__bpf_kfunc int bpf_io_uring_post_cqe(struct io_ring_ctx *ctx,
+				      u64 data, u32 res, u32 cflags)
+{
+	bool posted;
+
+	posted = io_post_aux_cqe(ctx, data, res, cflags);
+	return posted ? 0 : -ENOMEM;
+}
+
+__bpf_kfunc int bpf_io_uring_queue_sqe(struct io_ring_ctx *ctx,
+					void *bpf_sqe, int mem__sz)
+{
+	unsigned tail = ctx->rings->sq.tail;
+	struct io_uring_sqe *sqe;
+
+	if (mem__sz != sizeof(*sqe))
+		return -EINVAL;
+
+	ctx->rings->sq.tail++;
+	tail &= (ctx->sq_entries - 1);
+	/* double index for 128-byte SQEs, twice as long */
+	if (ctx->flags & IORING_SETUP_SQE128)
+		tail <<= 1;
+	sqe = &ctx->sq_sqes[tail];
+	memcpy(sqe, bpf_sqe, sizeof(*sqe));
+	return 0;
+}
+
+__bpf_kfunc
+struct io_uring_cqe *bpf_io_uring_get_cqe(struct io_ring_ctx *ctx, u32 idx)
+{
+	unsigned max_entries = ctx->cq_entries;
+	struct io_uring_cqe *cqe_array = ctx->rings->cqes;
+
+	if (ctx->flags & IORING_SETUP_CQE32)
+		max_entries *= 2;
+	return &cqe_array[idx & (max_entries - 1)];
+}
+
+__bpf_kfunc
+struct io_uring_cqe *bpf_io_uring_extract_next_cqe(struct io_ring_ctx *ctx)
+{
+	struct io_rings *rings = ctx->rings;
+	unsigned int mask = ctx->cq_entries - 1;
+	unsigned head = rings->cq.head;
+	struct io_uring_cqe *cqe;
+
+	/* TODO CQE32 */
+	if (head == rings->cq.tail)
+		return NULL;
+
+	cqe = &rings->cqes[head & mask];
+	rings->cq.head++;
+	return cqe;
+}
+
+__bpf_kfunc_end_defs();
+
+BTF_KFUNCS_START(io_uring_kfunc_set)
+BTF_ID_FLAGS(func, bpf_io_uring_submit_sqes, KF_SLEEPABLE);
+BTF_ID_FLAGS(func, bpf_io_uring_post_cqe, KF_SLEEPABLE);
+BTF_ID_FLAGS(func, bpf_io_uring_queue_sqe, KF_SLEEPABLE);
+BTF_ID_FLAGS(func, bpf_io_uring_get_cqe, 0);
+BTF_ID_FLAGS(func, bpf_io_uring_extract_next_cqe, KF_RET_NULL);
+BTF_KFUNCS_END(io_uring_kfunc_set)
+
+static const struct btf_kfunc_id_set bpf_io_uring_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set = &io_uring_kfunc_set,
+};
+
 static int io_bpf_ops__handle_events(struct io_ring_ctx *ctx,
 				     struct iou_loop_state *state)
 {
@@ -186,6 +266,12 @@ static int __init io_uring_bpf_init(void)
 		return ret;
 	}
 
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_STRUCT_OPS,
+					&bpf_io_uring_kfunc_set);
+	if (ret) {
+		pr_err("io_uring: Failed to register kfuncs (%d)\n", ret);
+		return ret;
+	}
 	return 0;
 }
 __initcall(io_uring_bpf_init);
-- 
2.49.0


