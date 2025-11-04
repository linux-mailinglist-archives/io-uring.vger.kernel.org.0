Return-Path: <io-uring+bounces-10376-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F56C334A7
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 23:45:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E704C18C4C52
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 22:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B7A2347BA9;
	Tue,  4 Nov 2025 22:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Ld45tVj0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B70B346E56
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 22:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762296311; cv=none; b=DsUBp4KTV+gvmsLqh6/w0Z5uJBQYoq9Nd/taFEfGTo7EVEyDKbNP2A0amngrktU2kcumRYWgSXhSHYI7aVFKSMe0BCqBlV6e1IzOrHOMROXZoLGw86oXCcEwzVqXqbmjJLa9Gkq4fNhxML7VMHm99/M97Qx0Y6y3W6hQn9YB6K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762296311; c=relaxed/simple;
	bh=Yzc0yUSUnSJa70unRI+jumF5/eia476jZ6Ca/wbpHj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPLa4QoT7PZMr7Oyp27SPWtFpFCt92yWtOQ5fsRynDjb4aWRMOLvsSKBOEaOMAXOLz0Ri3Jmo+uTAJ2n64n01VgPpspnSCYn8uPsNLmLJ5GNlwmS8P+EtRWVVkuv8drlB7llKrCGwa/hMrMaPxnMPpZ0H7u3M39MZ4vjlwLVOCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Ld45tVj0; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-44fe6771b2dso191589b6e.1
        for <io-uring@vger.kernel.org>; Tue, 04 Nov 2025 14:45:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762296308; x=1762901108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z3mnGhxXvTX5YPH4vGXbTpguKAb+GCffgjE453+9++c=;
        b=Ld45tVj0xo/GM7fpyASf6o6Qt6EnNero4RJzk00nAId8fJeRfzwTkrWhfCdtsuviQP
         2tX05MpoV5N1jS2tDmdco905sJ2tObg9pW+U1XC1b3P5X8LYb2YzeuzQ+/dNnKPSMrep
         wkTa7X8bFokzhQCX3gya07uswPRNMo2/+2525ff388yvJ9U64umQxlQjRO9WpvpF2780
         Km2PZ6UcYTBXmP8jTVZFMYYkA55+spN0r/2q9xmac7gsJi7nDG0DSCSWf/IFl4HebZTu
         rsGozBY0cBzydkSTy2qXRyvL0d8mG+6tRqptzqG3htpWAJgWA/cet+4nTpPSjEXBn/51
         va2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762296308; x=1762901108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z3mnGhxXvTX5YPH4vGXbTpguKAb+GCffgjE453+9++c=;
        b=OG9C3MsbzsHZ1qNZcT5x8zkvnT3OCDBiB7QRiYDQrH8jt9029pEAfer+PSqKySSlDC
         KwOEIjE76P/kaAtCd5TyEciir7B1DWllJGcHrsPn/kzCwTS/4fHJeHpd274Rpq/oQXfx
         p/w7s4BFe4itpzraB7X1S1CMSj1CeJNvtZM3AiN2n4gDeD/56Ku8bJr3rChjlPcCXdNw
         DG7fZZzRbbixEPSI2ksDPwcm3v2Oy4miPkUqEcunKzFBgboz1IgaOmWMQgCY7fug2Ttd
         /0czUwDa5Jm/RPChsGoAGCLNopBKoq8HlFAvbpO5QoSuZgVtKqPCi83yg9x3ET1IAmij
         SeBA==
X-Gm-Message-State: AOJu0YxVv4YGFtS54EnmRD523hFtfU6TNHSd9lIR+nCgKPiQf84oT6BV
	1XcCjJj77rU+HLMS+QvrBmCox/lp6Qu5ORX8EPaLAtpvT2+IGp+80Fzg2XQviTugCCQcnH2x4Kb
	P4bUZ
X-Gm-Gg: ASbGncsSydacB0mnJf7sctdnZv0uEz8aKdOAYPFyhrJtRvXLvt3NclJy3QtAngJkuMK
	hfdWiaMw8yK8PHE0rgLxGYyzRucaPBW9uzzJiV8CHFA6lrZohKNHH19ZiFnTQDGH9QUGDVEy8yd
	iD2QAAZkBwi/kWSrNE1gPBsYRXp7Bjs+O7zI94ZH8cb8TRavs1ScudpywKsM61euM43feD1VepU
	IhXdgHwZFUGGn6iZzId1Ek4JFNiXamvbN/2FZbC/+xiHB5iyoKGN2Em9dTRLJBVG7KVb0xRWQJ1
	OVtZ/lDZmOlTFleTNXwBN7ZcuGBjM9wiXyzGluNIAS4ZQh+jQWp0pek0UnmVcIcG8AqNEtIbn5A
	XPn4nPXKj/uQcP/BjZh3sRb/WnTQRHwnTfn86Ec1CfOcown3e0jg0dgQzgkNs0CPBUFktqjWjZl
	DJmGFm7N2SovXgLREco3E=
X-Google-Smtp-Source: AGHT+IEuZ6ncbaOOEGKk6373/MLu8DMOYLB6Dx4PYQcUqBjJJPy2oW1CQRrDqFED21KR59Pt+G25FA==
X-Received: by 2002:a05:6808:188a:b0:443:a224:8f98 with SMTP id 5614622812f47-44fed3bbec0mr531331b6e.61.1762296308306;
        Tue, 04 Nov 2025 14:45:08 -0800 (PST)
Received: from localhost ([2a03:2880:12ff:72::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-656b44cce6csm629471eaf.6.2025.11.04.14.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 14:45:07 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v1 7/7] io_uring/zcrx: reverse ifq refcount
Date: Tue,  4 Nov 2025 14:44:58 -0800
Message-ID: <20251104224458.1683606-8-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251104224458.1683606-1-dw@davidwei.uk>
References: <20251104224458.1683606-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a refcount to struct io_zcrx_ifq to reverse the refcounting
relationship i.e. rings now reference ifqs instead. As a result of this,
remove ctx->refs that an ifq holds on a ring via the page pool memory
provider.

This ref ifq->refs is held by internal users of an ifq, namely rings and
the page pool memory provider associated with an ifq. This is needed to
keep the ifq around until the page pool is destroyed.

Since ifqs now no longer hold refs to ring ctx, there isn't a need to
split the cleanup of ifqs into two: io_shutdown_zcrx_ifqs() in
io_ring_exit_work() while waiting for ctx->refs to drop to 0, and
io_unregister_zcrx_ifqs() after. Remove io_shutdown_zcrx_ifqs().

Signed-off-by: David Wei <dw@davidwei.uk>
Co-developed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  5 -----
 io_uring/zcrx.c     | 33 ++++++++++++++-------------------
 io_uring/zcrx.h     |  6 +-----
 3 files changed, 15 insertions(+), 29 deletions(-)

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
index b3f3d55d2f63..5752ff9a103f 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -479,9 +479,9 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 		return NULL;
 
 	ifq->if_rxq = -1;
-	ifq->ctx = ctx;
 	spin_lock_init(&ifq->rq_lock);
 	mutex_init(&ifq->pp_lock);
+	refcount_set(&ifq->refs, 1);
 	return ifq;
 }
 
@@ -537,6 +537,12 @@ static void io_zcrx_ifq_free(struct io_zcrx_ifq *ifq)
 	kfree(ifq);
 }
 
+static void io_put_zcrx_ifq(struct io_zcrx_ifq *ifq)
+{
+	if (refcount_dec_and_test(&ifq->refs))
+		io_zcrx_ifq_free(ifq);
+}
+
 struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
 					    unsigned int id)
 {
@@ -592,6 +598,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	ifq = io_zcrx_ifq_alloc(ctx);
 	if (!ifq)
 		return -ENOMEM;
+
 	if (ctx->user) {
 		get_uid(ctx->user);
 		ifq->user = ctx->user;
@@ -714,19 +721,6 @@ static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
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
@@ -743,7 +737,10 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 		}
 		if (!ifq)
 			break;
-		io_zcrx_ifq_free(ifq);
+
+		io_close_queue(ifq);
+		io_zcrx_scrub(ifq);
+		io_put_zcrx_ifq(ifq);
 	}
 
 	xa_destroy(&ctx->zcrx_ctxs);
@@ -894,15 +891,13 @@ static int io_pp_zc_init(struct page_pool *pp)
 	if (ret)
 		return ret;
 
-	percpu_ref_get(&ifq->ctx->refs);
+	refcount_inc(&ifq->refs);
 	return 0;
 }
 
 static void io_pp_zc_destroy(struct page_pool *pp)
 {
-	struct io_zcrx_ifq *ifq = io_pp_to_ifq(pp);
-
-	percpu_ref_put(&ifq->ctx->refs);
+	io_put_zcrx_ifq(io_pp_to_ifq(pp));
 }
 
 static int io_pp_nl_fill(void *mp_priv, struct sk_buff *rsp,
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 8d828dc9b0e4..45e3e71448ff 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -39,7 +39,6 @@ struct io_zcrx_area {
 };
 
 struct io_zcrx_ifq {
-	struct io_ring_ctx		*ctx;
 	struct io_zcrx_area		*area;
 	unsigned			niov_shift;
 	struct user_struct		*user;
@@ -55,6 +54,7 @@ struct io_zcrx_ifq {
 	struct device			*dev;
 	struct net_device		*netdev;
 	netdevice_tracker		netdev_tracker;
+	refcount_t			refs;
 
 	/*
 	 * Page pool and net configuration lock, can be taken deeper in the
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


