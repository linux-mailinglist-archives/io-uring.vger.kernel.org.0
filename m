Return-Path: <io-uring+bounces-2080-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 96A408D8863
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 20:04:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 201A01F23D7F
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 18:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC245137C33;
	Mon,  3 Jun 2024 18:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fOthBpHO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C54E136E39
	for <io-uring@vger.kernel.org>; Mon,  3 Jun 2024 18:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717437885; cv=none; b=gPzdxoqR97jXQnx2dTMCowx1I/3a1dmZ38d+EVyVr2BrQoSPEmJPPXrhvT2Zs+76H4QU2OFf1HEzEXdIIg7GbU2RIOnG8muA61nSrdjd4pMgIOCSTymg0hgLUCelyzuKEOM0MNsiPoJGpiQc3sjPCfAUq/6t/tBe7yCGmCQpiDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717437885; c=relaxed/simple;
	bh=eLz+fustqnN9YbbMihdJGfzq9NmAapUZnuGKqGZQDPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nl48brH9zTzz/oiiYosx3nyWyPLOXH7cmt/gZ5BYbeZe6ayJYlZJKy9BdHt3BFcf/GfTlIvE4sQ4/DrjjS2UL3NlNxRorxaheUuAGsONiOLo5RgQE/DyrX5+TqgEkoZGpdtpdqbQrywOMZuHLRTp5kupVeoqiwZCxV8os3+V+sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fOthBpHO; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-6f907f89dc0so118080a34.2
        for <io-uring@vger.kernel.org>; Mon, 03 Jun 2024 11:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717437881; x=1718042681; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yrGYJlfdIdx9RikSDlZRfIJThLeFq/ZW+tc2pgPQKl4=;
        b=fOthBpHO6oaTi7Nfq3/SG/o+NbLqi2wn6g11uvatmksnJGAbqppTw3FUYTwhSeyeBB
         vSGZf53ww7TcgrqpNWYaxknV/AgnojKVqedJP6xIJ9sh2Ago+OdetMJlpYkJ4MBtdQOh
         6ZrQaIu6W4HVBe91f33F6rP+krTq9pJLrSqicIVp2u9UnDKy/oxSZ66V8rrrISnWDnfK
         WjHqJitAhGojpermy+iL+/rX/Tm/HwAiXSFRUl7tcaFbP2kYDzToskn5ICP/yU2yh6Sq
         1nW/Mpdcu6qgh5iOR8w4CtU7BY4dBHS4rS8q/4OdSKtYB8YOw676oQth4eiwCc3b1bWj
         0bjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717437881; x=1718042681;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yrGYJlfdIdx9RikSDlZRfIJThLeFq/ZW+tc2pgPQKl4=;
        b=KfMAJzBgXVm7NZDxoF4V+V6QHSIz3l1gKnh4vHnpLjNDXRztkIycBTd7Act1zWLIH1
         HNtCHn8731xuOivCN98MRGojKU97osLuFMrO+IEPeMtxNaGo12ymzDm8ltbw0sdnmQnM
         b/BiBB1R0H4cTwM9A0XmgZ4c4RNk9b7Q8nEGE2X4K+jjnKKctJXsdlUMG2yFkLAfiQRR
         DMWrcxQtPqhdoqvkeXUCJrcnOu2i5Ued9gRpkHQSeFR4osVe2i4XbBkbrRJv4iQnz2Xx
         EZyFv7ghEryZGhAS/i+E3eD5tebvcRJNI4e5yY/2XEEgwjznN2hVgDB+HAG+u+k7JL3S
         5KCg==
X-Gm-Message-State: AOJu0YxORfhmbSDHnghD/rSpPNX0W7P1Su+6PMquAFKgjyDTjxF7hH++
	srvdCribhk1ONuwFgfodoiV49RxE7YYhYyFQpX4a1/UMw/eDtvyvfJWdDMXR7xo1QpTnFowF9dK
	T
X-Google-Smtp-Source: AGHT+IHsNw/mbGsfffYcSJMfVdlzI9yJmtH4PPc+tlDA8REuckbKFJIh9X4U5GuYGgaWy9Z2LAYs3A==
X-Received: by 2002:a05:6830:c89:b0:6f0:e529:4f0d with SMTP id 46e09a7af769-6f911f25123mr9696664a34.1.1717437880846;
        Mon, 03 Jun 2024 11:04:40 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f910550371sm1564046a34.47.2024.06.03.11.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 11:04:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/eventfd: move to more idiomatic RCU free usage
Date: Mon,  3 Jun 2024 12:03:17 -0600
Message-ID: <20240603180436.312386-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240603180436.312386-1-axboe@kernel.dk>
References: <20240603180436.312386-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In some ways, it just "happens to work" currently with using the ops
field for both the free and signaling bit. But it depends on ordering
of operations in terms of freeing and signaling. Clean it up and use the
usual refs == 0 under RCU read side lock to determine if the ev_fd is
still valid, and use the reference to gate the freeing as well.

Fixes: 21a091b970cd ("io_uring: signal registered eventfd to process deferred task work")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 49 ++++++++++++++++++++++++---------------------
 io_uring/io_uring.h |  4 ++--
 io_uring/register.c |  6 +++---
 3 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 816e93e7f949..b874836ee49d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -541,29 +541,33 @@ static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 	}
 }
 
-void io_eventfd_ops(struct rcu_head *rcu)
+void io_eventfd_free(struct rcu_head *rcu)
 {
 	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
-	int ops = atomic_xchg(&ev_fd->ops, 0);
 
-	if (ops & BIT(IO_EVENTFD_OP_SIGNAL_BIT))
-		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
+	eventfd_ctx_put(ev_fd->cq_ev_fd);
+	kfree(ev_fd);
+}
 
-	/* IO_EVENTFD_OP_FREE_BIT may not be set here depending on callback
-	 * ordering in a race but if references are 0 we know we have to free
-	 * it regardless.
-	 */
-	if (atomic_dec_and_test(&ev_fd->refs)) {
-		eventfd_ctx_put(ev_fd->cq_ev_fd);
-		kfree(ev_fd);
-	}
+void io_eventfd_do_signal(struct rcu_head *rcu)
+{
+	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
+
+	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
+
+	if (atomic_dec_and_test(&ev_fd->refs))
+		io_eventfd_free(rcu);
 }
 
 static void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd = NULL;
 
-	rcu_read_lock();
+	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
+		return;
+
+	guard(rcu)();
+
 	/*
 	 * rcu_dereference ctx->io_ev_fd once and use it for both for checking
 	 * and eventfd_signal
@@ -576,24 +580,23 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 	 * the function and rcu_read_lock.
 	 */
 	if (unlikely(!ev_fd))
-		goto out;
-	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
-		goto out;
+		return;
+	if (!atomic_inc_not_zero(&ev_fd->refs))
+		return;
 	if (ev_fd->eventfd_async && !io_wq_current_is_worker())
 		goto out;
 
 	if (likely(eventfd_signal_allowed())) {
 		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
 	} else {
-		atomic_inc(&ev_fd->refs);
-		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops))
-			call_rcu_hurry(&ev_fd->rcu, io_eventfd_ops);
-		else
-			atomic_dec(&ev_fd->refs);
+		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops)) {
+			call_rcu_hurry(&ev_fd->rcu, io_eventfd_do_signal);
+			return;
+		}
 	}
-
 out:
-	rcu_read_unlock();
+	if (atomic_dec_and_test(&ev_fd->refs))
+		call_rcu(&ev_fd->rcu, io_eventfd_free);
 }
 
 static void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 624ca9076a50..804cd55416e9 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -106,10 +106,10 @@ bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 
 enum {
 	IO_EVENTFD_OP_SIGNAL_BIT,
-	IO_EVENTFD_OP_FREE_BIT,
 };
 
-void io_eventfd_ops(struct rcu_head *rcu);
+void io_eventfd_do_signal(struct rcu_head *rcu);
+void io_eventfd_free(struct rcu_head *rcu);
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
diff --git a/io_uring/register.c b/io_uring/register.c
index ef8c908346a4..e1e9d005718e 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -63,9 +63,9 @@ static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 
 	ev_fd->eventfd_async = eventfd_async;
 	ctx->has_evfd = true;
-	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	atomic_set(&ev_fd->refs, 1);
 	atomic_set(&ev_fd->ops, 0);
+	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
 	return 0;
 }
 
@@ -78,8 +78,8 @@ int io_eventfd_unregister(struct io_ring_ctx *ctx)
 	if (ev_fd) {
 		ctx->has_evfd = false;
 		rcu_assign_pointer(ctx->io_ev_fd, NULL);
-		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_FREE_BIT), &ev_fd->ops))
-			call_rcu(&ev_fd->rcu, io_eventfd_ops);
+		if (atomic_dec_and_test(&ev_fd->refs))
+			call_rcu(&ev_fd->rcu, io_eventfd_free);
 		return 0;
 	}
 
-- 
2.43.0


