Return-Path: <io-uring+bounces-2081-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B77A78D8864
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 20:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78FFE287DFF
	for <lists+io-uring@lfdr.de>; Mon,  3 Jun 2024 18:04:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAEA136E39;
	Mon,  3 Jun 2024 18:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NJauFVsa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75997137C29
	for <io-uring@vger.kernel.org>; Mon,  3 Jun 2024 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717437887; cv=none; b=IlNeXQcVuGo6xsbDpJZarhPaqInnaDpepqWVeXBWmcu7a30l0+S2MpQPp98CnVsrLF+mhThAY131HI7n4AFDC0ANqi6VDxqOfAUsPAGgVaZG0pNsxmq34/M3ElRk8QF7fwEWGZBkm8oTbR9wGovHH/zxBuILrHBLnHpocvXlquA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717437887; c=relaxed/simple;
	bh=3brA8scZy7S+Pulb2KAwHMSsm7Y2OEuCUHcZ6BULFJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BkxxSV2baXgcqQ7KnFzdzucBbOxVZ+oW8jL6dfxbrsfIlBFAMmObr/AngT2D41DDerk+wY9+E+aCfCZ/61sialtmSQjX/225rLeP4QRsm4o/DAIjrblZZhr5ZuWiFwD+FKU4FZuJmeyponFhzNe+Sh/xiC/FZEOK8unQudLIwpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NJauFVsa; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3d1b6b6b2c5so570244b6e.0
        for <io-uring@vger.kernel.org>; Mon, 03 Jun 2024 11:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717437883; x=1718042683; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZMmrO15iKpvVgP49zC+LzkiraI/2eIm7lp4sMbUFLk=;
        b=NJauFVsaOHa50baGS7u/xbP8BbhR/vWXNAtsMfVNnRCjPBhQY6j/KTR3cNrlzJUGWU
         eHnvYUCgBLVgdC48DQIqIYDc2EeuxZz7OI3AxtzSeTnzpDTYzXCWd/OhTRGnrb8tA4Jy
         Fj/xdyL5OH1R2f7xNzukHsbzrdy3vQpcyBrN/5a64FpmSJXUek/aE2t2wjKY9YdP7n4I
         UeqEH66OaOx7GhFOom75HrKuFp7xqMlpEVMU27MhG71d+LpiREiNRD9YIddWCXJCLDC1
         eAnFig5x9cb6pySt9v3qpRWI5dQvU1aLEIQbsMu9S8R8rPILtnYuefGb6DpSjz9Xu/9D
         rMtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717437883; x=1718042683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZMmrO15iKpvVgP49zC+LzkiraI/2eIm7lp4sMbUFLk=;
        b=U5k94EjnaI1tIAJltM9eN8wRKGXdsw3WN4pr4uAWLYWJdwF3Hnd2PRmOYlhSPtFlto
         6mct1HLtbuwuG5HFSqiCtyo1r46V/Rfnm9H29/qZEhsYdBaCXEMNXdTlwfuC0gC9LyIi
         wDqC9qUjFtr8Vk6snDlB/q2qELDIyU6e92MkoRTBrXLyj3DT8DZMtPYffTwkycFcLLIn
         9D4TAGwEIdmHfn/6LxO4uM96y1cYs7KJzr9SuyT703OXtB85UyXG4Z5eXAlg1JCd+/EW
         ufmoNHwj4+Ll/5lqrPk+egNVhr+6dr8U+5eCvhqO5YiILy/JBQz1iajJ/GbyKCf2bAth
         daZg==
X-Gm-Message-State: AOJu0YyYS04yfnFUrs4T2gaaHc7SpjaSvTK6Z9CWQORjclzPhBvAn8C6
	xSNoyxwv/bCGgkroSBOJ9tKxsIhLJqbflpl/v4gTpoofPiCLFj+GJvaidpDnusVwbbQD9FltRDs
	R
X-Google-Smtp-Source: AGHT+IHAd+ulq+r4N8XoKdJaFTw6oi5s0pCqvr4Fg3pwtb61jL/kukTY5QLKrRwfPnBx8nzLLn1VYQ==
X-Received: by 2002:a05:6870:40c9:b0:24f:c055:fc52 with SMTP id 586e51a60fabf-2508b47b0camr11644217fac.0.1717437882739;
        Mon, 03 Jun 2024 11:04:42 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-6f910550371sm1564046a34.47.2024.06.03.11.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 11:04:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring/eventfd: move eventfd handling to separate file
Date: Mon,  3 Jun 2024 12:03:18 -0600
Message-ID: <20240603180436.312386-3-axboe@kernel.dk>
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

This is pretty nicely abstracted already, but let's move it to a separate
file rather than have it in the main io_uring file. With that, we can
also move the io_ev_fd struct and enum out of global scope.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   8 --
 io_uring/Makefile              |   6 +-
 io_uring/eventfd.c             | 160 +++++++++++++++++++++++++++++++++
 io_uring/eventfd.h             |   8 ++
 io_uring/io_uring.c            |  82 +----------------
 io_uring/io_uring.h            |   6 --
 io_uring/register.c            |  56 +-----------
 7 files changed, 173 insertions(+), 153 deletions(-)
 create mode 100644 io_uring/eventfd.c
 create mode 100644 io_uring/eventfd.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 91224bbcfa73..a2227ab7fd16 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -211,14 +211,6 @@ struct io_submit_state {
 	struct blk_plug		plug;
 };
 
-struct io_ev_fd {
-	struct eventfd_ctx	*cq_ev_fd;
-	unsigned int		eventfd_async: 1;
-	struct rcu_head		rcu;
-	atomic_t		refs;
-	atomic_t		ops;
-};
-
 struct io_alloc_cache {
 	void			**entries;
 	unsigned int		nr_cached;
diff --git a/io_uring/Makefile b/io_uring/Makefile
index fc1b23c524e8..61923e11c767 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -4,9 +4,9 @@
 
 obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					tctx.o filetable.o rw.o net.o poll.o \
-					uring_cmd.o openclose.o sqpoll.o \
-					xattr.o nop.o fs.o splice.o sync.o \
-					msg_ring.o advise.o openclose.o \
+					eventfd.o uring_cmd.o openclose.o \
+					sqpoll.o xattr.o nop.o fs.o splice.o \
+					sync.o msg_ring.o advise.o openclose.o \
 					epoll.o statx.o timeout.o fdinfo.o \
 					cancel.o waitid.o register.o \
 					truncate.o memmap.o
diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
new file mode 100644
index 000000000000..b9384503a2b7
--- /dev/null
+++ b/io_uring/eventfd.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/eventfd.h>
+#include <linux/eventpoll.h>
+#include <linux/io_uring.h>
+#include <linux/io_uring_types.h>
+
+#include "io-wq.h"
+#include "eventfd.h"
+
+struct io_ev_fd {
+	struct eventfd_ctx	*cq_ev_fd;
+	unsigned int		eventfd_async: 1;
+	struct rcu_head		rcu;
+	atomic_t		refs;
+	atomic_t		ops;
+};
+
+enum {
+	IO_EVENTFD_OP_SIGNAL_BIT,
+};
+
+static void io_eventfd_free(struct rcu_head *rcu)
+{
+	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
+
+	eventfd_ctx_put(ev_fd->cq_ev_fd);
+	kfree(ev_fd);
+}
+
+static void io_eventfd_do_signal(struct rcu_head *rcu)
+{
+	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
+
+	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
+
+	if (atomic_dec_and_test(&ev_fd->refs))
+		io_eventfd_free(rcu);
+}
+
+void io_eventfd_signal(struct io_ring_ctx *ctx)
+{
+	struct io_ev_fd *ev_fd = NULL;
+
+	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
+		return;
+
+	guard(rcu)();
+
+	/*
+	 * rcu_dereference ctx->io_ev_fd once and use it for both for checking
+	 * and eventfd_signal
+	 */
+	ev_fd = rcu_dereference(ctx->io_ev_fd);
+
+	/*
+	 * Check again if ev_fd exists incase an io_eventfd_unregister call
+	 * completed between the NULL check of ctx->io_ev_fd at the start of
+	 * the function and rcu_read_lock.
+	 */
+	if (unlikely(!ev_fd))
+		return;
+	if (!atomic_inc_not_zero(&ev_fd->refs))
+		return;
+	if (ev_fd->eventfd_async && !io_wq_current_is_worker())
+		goto out;
+
+	if (likely(eventfd_signal_allowed())) {
+		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
+	} else {
+		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops)) {
+			call_rcu_hurry(&ev_fd->rcu, io_eventfd_do_signal);
+			return;
+		}
+	}
+out:
+	if (atomic_dec_and_test(&ev_fd->refs))
+		call_rcu(&ev_fd->rcu, io_eventfd_free);
+}
+
+void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
+{
+	bool skip;
+
+	spin_lock(&ctx->completion_lock);
+
+	/*
+	 * Eventfd should only get triggered when at least one event has been
+	 * posted. Some applications rely on the eventfd notification count
+	 * only changing IFF a new CQE has been added to the CQ ring. There's
+	 * no depedency on 1:1 relationship between how many times this
+	 * function is called (and hence the eventfd count) and number of CQEs
+	 * posted to the CQ ring.
+	 */
+	skip = ctx->cached_cq_tail == ctx->evfd_last_cq_tail;
+	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
+	spin_unlock(&ctx->completion_lock);
+	if (skip)
+		return;
+
+	io_eventfd_signal(ctx);
+}
+
+int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
+			unsigned int eventfd_async)
+{
+	struct io_ev_fd *ev_fd;
+	__s32 __user *fds = arg;
+	int fd;
+
+	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
+					lockdep_is_held(&ctx->uring_lock));
+	if (ev_fd)
+		return -EBUSY;
+
+	if (copy_from_user(&fd, fds, sizeof(*fds)))
+		return -EFAULT;
+
+	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
+	if (!ev_fd)
+		return -ENOMEM;
+
+	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
+	if (IS_ERR(ev_fd->cq_ev_fd)) {
+		int ret = PTR_ERR(ev_fd->cq_ev_fd);
+		kfree(ev_fd);
+		return ret;
+	}
+
+	spin_lock(&ctx->completion_lock);
+	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
+	spin_unlock(&ctx->completion_lock);
+
+	ev_fd->eventfd_async = eventfd_async;
+	ctx->has_evfd = true;
+	atomic_set(&ev_fd->refs, 1);
+	atomic_set(&ev_fd->ops, 0);
+	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
+	return 0;
+}
+
+int io_eventfd_unregister(struct io_ring_ctx *ctx)
+{
+	struct io_ev_fd *ev_fd;
+
+	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
+					lockdep_is_held(&ctx->uring_lock));
+	if (ev_fd) {
+		ctx->has_evfd = false;
+		rcu_assign_pointer(ctx->io_ev_fd, NULL);
+		if (atomic_dec_and_test(&ev_fd->refs))
+			call_rcu(&ev_fd->rcu, io_eventfd_free);
+		return 0;
+	}
+
+	return -ENXIO;
+}
diff --git a/io_uring/eventfd.h b/io_uring/eventfd.h
new file mode 100644
index 000000000000..d394f49c6321
--- /dev/null
+++ b/io_uring/eventfd.h
@@ -0,0 +1,8 @@
+
+struct io_ring_ctx;
+int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
+			unsigned int eventfd_async);
+int io_eventfd_unregister(struct io_ring_ctx *ctx);
+
+void io_eventfd_flush_signal(struct io_ring_ctx *ctx);
+void io_eventfd_signal(struct io_ring_ctx *ctx);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b874836ee49d..96f6da0bf5cd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -101,6 +101,7 @@
 #include "poll.h"
 #include "rw.h"
 #include "alloc_cache.h"
+#include "eventfd.h"
 
 #define IORING_MAX_ENTRIES	32768
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
@@ -541,87 +542,6 @@ static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 	}
 }
 
-void io_eventfd_free(struct rcu_head *rcu)
-{
-	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
-
-	eventfd_ctx_put(ev_fd->cq_ev_fd);
-	kfree(ev_fd);
-}
-
-void io_eventfd_do_signal(struct rcu_head *rcu)
-{
-	struct io_ev_fd *ev_fd = container_of(rcu, struct io_ev_fd, rcu);
-
-	eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
-
-	if (atomic_dec_and_test(&ev_fd->refs))
-		io_eventfd_free(rcu);
-}
-
-static void io_eventfd_signal(struct io_ring_ctx *ctx)
-{
-	struct io_ev_fd *ev_fd = NULL;
-
-	if (READ_ONCE(ctx->rings->cq_flags) & IORING_CQ_EVENTFD_DISABLED)
-		return;
-
-	guard(rcu)();
-
-	/*
-	 * rcu_dereference ctx->io_ev_fd once and use it for both for checking
-	 * and eventfd_signal
-	 */
-	ev_fd = rcu_dereference(ctx->io_ev_fd);
-
-	/*
-	 * Check again if ev_fd exists incase an io_eventfd_unregister call
-	 * completed between the NULL check of ctx->io_ev_fd at the start of
-	 * the function and rcu_read_lock.
-	 */
-	if (unlikely(!ev_fd))
-		return;
-	if (!atomic_inc_not_zero(&ev_fd->refs))
-		return;
-	if (ev_fd->eventfd_async && !io_wq_current_is_worker())
-		goto out;
-
-	if (likely(eventfd_signal_allowed())) {
-		eventfd_signal_mask(ev_fd->cq_ev_fd, EPOLL_URING_WAKE);
-	} else {
-		if (!atomic_fetch_or(BIT(IO_EVENTFD_OP_SIGNAL_BIT), &ev_fd->ops)) {
-			call_rcu_hurry(&ev_fd->rcu, io_eventfd_do_signal);
-			return;
-		}
-	}
-out:
-	if (atomic_dec_and_test(&ev_fd->refs))
-		call_rcu(&ev_fd->rcu, io_eventfd_free);
-}
-
-static void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
-{
-	bool skip;
-
-	spin_lock(&ctx->completion_lock);
-
-	/*
-	 * Eventfd should only get triggered when at least one event has been
-	 * posted. Some applications rely on the eventfd notification count
-	 * only changing IFF a new CQE has been added to the CQ ring. There's
-	 * no depedency on 1:1 relationship between how many times this
-	 * function is called (and hence the eventfd count) and number of CQEs
-	 * posted to the CQ ring.
-	 */
-	skip = ctx->cached_cq_tail == ctx->evfd_last_cq_tail;
-	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
-	spin_unlock(&ctx->completion_lock);
-	if (skip)
-		return;
-
-	io_eventfd_signal(ctx);
-}
-
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
 	if (ctx->poll_activated)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 804cd55416e9..8518da64ada9 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -104,12 +104,6 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
-enum {
-	IO_EVENTFD_OP_SIGNAL_BIT,
-};
-
-void io_eventfd_do_signal(struct rcu_head *rcu);
-void io_eventfd_free(struct rcu_head *rcu);
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
diff --git a/io_uring/register.c b/io_uring/register.c
index e1e9d005718e..50e9cbf85f7d 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -27,65 +27,11 @@
 #include "cancel.h"
 #include "kbuf.h"
 #include "napi.h"
+#include "eventfd.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
-static int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
-			       unsigned int eventfd_async)
-{
-	struct io_ev_fd *ev_fd;
-	__s32 __user *fds = arg;
-	int fd;
-
-	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
-					lockdep_is_held(&ctx->uring_lock));
-	if (ev_fd)
-		return -EBUSY;
-
-	if (copy_from_user(&fd, fds, sizeof(*fds)))
-		return -EFAULT;
-
-	ev_fd = kmalloc(sizeof(*ev_fd), GFP_KERNEL);
-	if (!ev_fd)
-		return -ENOMEM;
-
-	ev_fd->cq_ev_fd = eventfd_ctx_fdget(fd);
-	if (IS_ERR(ev_fd->cq_ev_fd)) {
-		int ret = PTR_ERR(ev_fd->cq_ev_fd);
-		kfree(ev_fd);
-		return ret;
-	}
-
-	spin_lock(&ctx->completion_lock);
-	ctx->evfd_last_cq_tail = ctx->cached_cq_tail;
-	spin_unlock(&ctx->completion_lock);
-
-	ev_fd->eventfd_async = eventfd_async;
-	ctx->has_evfd = true;
-	atomic_set(&ev_fd->refs, 1);
-	atomic_set(&ev_fd->ops, 0);
-	rcu_assign_pointer(ctx->io_ev_fd, ev_fd);
-	return 0;
-}
-
-int io_eventfd_unregister(struct io_ring_ctx *ctx)
-{
-	struct io_ev_fd *ev_fd;
-
-	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
-					lockdep_is_held(&ctx->uring_lock));
-	if (ev_fd) {
-		ctx->has_evfd = false;
-		rcu_assign_pointer(ctx->io_ev_fd, NULL);
-		if (atomic_dec_and_test(&ev_fd->refs))
-			call_rcu(&ev_fd->rcu, io_eventfd_free);
-		return 0;
-	}
-
-	return -ENXIO;
-}
-
 static __cold int io_probe(struct io_ring_ctx *ctx, void __user *arg,
 			   unsigned nr_args)
 {
-- 
2.43.0


