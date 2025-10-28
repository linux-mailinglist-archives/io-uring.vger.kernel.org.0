Return-Path: <io-uring+bounces-10273-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 67A1FC1648D
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 18:49:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7DEE71C26FCF
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 17:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC7234EEE5;
	Tue, 28 Oct 2025 17:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="1Nr9CXWl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B692D34DCCC
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 17:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761673611; cv=none; b=CmY3DIdlFq/3+wC/EkzJysJD2opaX9VPgFMHJ4e20/+YJvLnjMFXxxnzURbU0w49rdMpImpvktQxnM2UuAyICJ1rrUA9gzTPOy1hN3KOV1eAp0iTG6eT7c5dhTUOPAIxdmPrHvJdPMHdEZuJPJTttvOCtgYCaBK/zLpqpwBukj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761673611; c=relaxed/simple;
	bh=sR5KTAJ1qX7NTAind3uBuB+y3bPielF9T92+VG0Pm/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu0rvwzH+dv7QB0lWN2axbIGHP2BHxdnLR4uAXwZieWgI1Tys8gZq5bUiU6FYzPt0QHbcD3ONzhSdIzMApECBZED1lfBBzEGF40h6oM+c2Oam+34MA92Auv+cXhsYq/cmObWSZuQlo9OsN50BJmKanJSnkVIdcVONIyBhKvYGTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=1Nr9CXWl; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-443ac11a7b7so1469957b6e.0
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 10:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761673608; x=1762278408; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H1H5FIjUD5fZtLsxVqgbA1/ASgasVs7HS+4Xszj+/Vc=;
        b=1Nr9CXWlnU6HOdb7WZHQqrYUngn1nmhfBLzcWZ90BCbGAIO8bbDUUo2bCtvblRZwAW
         OhN40nRZlFYmVbKTYXi7V4u1OMK4i1lsN7oXZi9Bhnkooh79wlOVgBuNHtZCJPtVb+nL
         q7TpmNrWSQVYTDLiZ521K4N66zjb2eZfcHs0DWQ4MUmCXb6jonvTv2W+FwJm2gAQhOfS
         IyXP88W2jKaKTxcnbWinotKilJBORBF7I8sUNap8SX3VsjSoHUf3nhlwjY+gXAb8SxqD
         RZn6GkC72eRbyYr8VkB5SpzodgwFVbk2oEvhs92k+b+6z9bg0r8/00rlo0v1fcWgHSh3
         hDdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673608; x=1762278408;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H1H5FIjUD5fZtLsxVqgbA1/ASgasVs7HS+4Xszj+/Vc=;
        b=CFri5kAGx4it7Ob8QtD0oB3eUjw7ztohcLUs/cYN1DhPP7oZANPn1uHJD3FN/NkAtr
         d2sFMP0DYayJCXgSNZG2+85OrgWNLkf5oY9YCJ40aJVDPENM8A+NkTIL9mn/TLGiXIND
         2DKxrKvt0tYb8zjCzMn/xb58vXnatoWyynaSxI/V8Nb3ehHeUuvTemWutoBnG+ehLGs6
         knipbGbb+6O8ks38wRgfPbqHIqMbjdfuqiGbBMlHoeXUX1vOTm8n5yJq8/xlfyu59Bt7
         aVp49LTPumtMf40RM+kxEtjhdFQM5nio5VowMOcn8VUHFiJ8FoAJExxlVigZzKB9WaD8
         5gIg==
X-Gm-Message-State: AOJu0Yxm5ymbC1bF8D9bk7t5jOLjdRGYaIG6j2Ym48IecNMNXM6HVxNO
	+ekZB3H6UwixdKseE80lCpgT1hzmb4UbsDJ2N8j01pFZoBAzw9+w+vj4tFYmjqEYPaC0ZsLPv2j
	wu14P
X-Gm-Gg: ASbGncvdNpdRTLn6d2b+0tawRELcPNW8LC0oxj391rhb4M0u6OQZg0JeDoWpk1X03J8
	DvTfY4p5qRLbl3AiRtU9Y8aDOQgwvU2TEBcY5hFe4F0NrKDOXXZ9/l3ZuUGjIaCZ72fgpqNaiZ7
	MFBPyJDd6Nx2ftQ4qFD1TFCutj00aC9FpY4FAz+kVyG1E0lXcEd8O/p9ljwfKWK8mrCqDbtgUMg
	PSCOgQMIdqi21J+n3oJbcgdKC45ia0GmR1FydiErx6MoMAnqu5Em+JcDnEfy/cpriieDM8iMwpl
	uQ4+Tkzg0BuQ4cmrXE11yHlHzUF9VcBJocc5KO7yvCOzpJbN16AUk7tqJyxREZjGRm5VdJwHLPM
	71eKUaaJ/m0AZRC6N30fOreUlmuS612BfJ4X0pb25BOLVF8wSbcMdLMscA1zt8F3NeBKTlFqtM7
	kbI1pccSc24Xz9a7xelnU=
X-Google-Smtp-Source: AGHT+IGfBeHNEpuV0IjI8ZIiSI1As/6mZc06GH3+ejMb9gpj6vLekzTSlcbgY4LisVuYwZEu9Z8d2A==
X-Received: by 2002:a05:6808:4f60:b0:441:8f74:f3c with SMTP id 5614622812f47-44f7a557121mr128504b6e.54.1761673608435;
        Tue, 28 Oct 2025 10:46:48 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:71::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-44da3e80083sm2770913b6e.14.2025.10.28.10.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 10:46:48 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v4 7/8] io_uring/zcrx: add refcount to ifq and remove ifq->ctx
Date: Tue, 28 Oct 2025 10:46:38 -0700
Message-ID: <20251028174639.1244592-8-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251028174639.1244592-1-dw@davidwei.uk>
References: <20251028174639.1244592-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a refcount to struct io_zcrx_ifq to track the number of rings that
share it. For now, this is only ever 1 i.e. not shared.

This refcount replaces the ref that the ifq holds on ctx->refs via the
page pool memory provider. This was used to keep the ifq around until
the ring ctx is being freed i.e. ctx->refs fall to 0. But with ifq now
being refcounted directly by the ring, and ifq->ctx removed, this is no
longer necessary.

Since ifqs now no longer hold refs to ring ctx, there isn't a need to
split the cleanup of ifqs into two: io_shutdown_zcrx_ifqs() in
io_ring_exit_work() while waiting for ctx->refs to drop to 0, and
io_unregister_zcrx_ifqs() after. Remove io_shutdown_zcrx_ifqs().

So an ifq now behaves like a normal refcounted object; the last ref from
a ring will free the ifq.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/io_uring.c |  5 -----
 io_uring/zcrx.c     | 24 +++++-------------------
 io_uring/zcrx.h     |  6 +-----
 3 files changed, 6 insertions(+), 29 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7d42748774f8..8af5efda9c11 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3042,11 +3042,6 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			io_cqring_overflow_kill(ctx);
 			mutex_unlock(&ctx->uring_lock);
 		}
-		if (!xa_empty(&ctx->zcrx_ctxs)) {
-			mutex_lock(&ctx->uring_lock);
-			io_shutdown_zcrx_ifqs(ctx);
-			mutex_unlock(&ctx->uring_lock);
-		}
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 			io_move_task_work_from_local(ctx);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b3f3d55d2f63..6324dfa61ce0 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -479,7 +479,6 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ifq->if_rxq = -1;
-	ifq->ctx = ctx;
 	spin_lock_init(&ifq->rq_lock);
 	mutex_init(&ifq->pp_lock);
 	return ifq;
@@ -592,6 +591,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	ifq = io_zcrx_ifq_alloc(ctx);
 	if (!ifq)
 		return -ENOMEM;
+	refcount_set(&ifq->refs, 1);
 	if (ctx->user) {
 		get_uid(ctx->user);
 		ifq->user = ctx->user;
@@ -714,19 +714,6 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
 	}
 }
 
-void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
-{
-	struct io_zcrx_ifq *ifq;
-	unsigned long index;
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	xa_for_each(&ctx->zcrx_ctxs, index, ifq) {
-		io_zcrx_scrub(ifq);
-		io_close_queue(ifq);
-	}
-}
-
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
@@ -743,7 +730,10 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 		}
 		if (!ifq)
 			break;
-		io_zcrx_ifq_free(ifq);
+		if (refcount_dec_and_test(&ifq->refs)) {
+			io_zcrx_scrub(ifq);
+			io_zcrx_ifq_free(ifq);
+		}
 	}
 
 	xa_destroy(&ctx->zcrx_ctxs);
@@ -894,15 +884,11 @@ static int io_pp_zc_init(struct page_pool *pp)
 	if (ret)
 		return ret;
 
-	percpu_ref_get(&ifq->ctx->refs);
 	return 0;
 }
 
 static void io_pp_zc_destroy(struct page_pool *pp)
 {
-	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
-
-	percpu_ref_put(&ifq->ctx->refs);
 }
 
 static int io_pp_nl_fill(void *mp_priv, struct sk_buff *rsp,
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 8d828dc9b0e4..5951f127298c 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -39,9 +39,9 @@ struct io_zcrx_area {
 };
 
 struct io_zcrx_ifq {
-	struct io_ring_ctx		*ctx;
 	struct io_zcrx_area		*area;
 	unsigned			niov_shift;
+	refcount_t			refs;
 	struct user_struct		*user;
 	struct mm_struct		*mm_account;
 
@@ -70,7 +70,6 @@ int io_zcrx_return_bufs(struct io_ring_ctx *ctx,
 int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 			 struct io_uring_zcrx_ifq_reg __user *arg);
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
-void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 struct socket *sock, unsigned int flags,
 		 unsigned issue_flags, unsigned int *len);
@@ -85,9 +84,6 @@ static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 static inline void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 }
-static inline void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
-{
-}
 static inline int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			       struct socket *sock, unsigned int flags,
 			       unsigned issue_flags, unsigned int *len)
-- 
2.47.3


