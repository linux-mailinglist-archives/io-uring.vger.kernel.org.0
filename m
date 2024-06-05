Return-Path: <io-uring+bounces-2113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 01EE28FD0B3
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:20:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9E99C2888BB
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 14:20:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E9901A291;
	Wed,  5 Jun 2024 14:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SwDFbvOG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538192837A
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597187; cv=none; b=bkSzNALpLZ8BoBHhIRiopGXvm7C35YPKDkDd6RwxPqQ4sljIe+wpPB5I+XYuuDGK0j58Kv7baNmQxgv6G/0mNtlotR7o6IqULLQyVhXnwTPZuxWv+MqwKHHj16u2simWlg3ZbJcgbLXFi/0t3PwTIcmyzp+nDlXvOxXk53oCHXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597187; c=relaxed/simple;
	bh=+jLUBktFTPJ7GG9oqx0iEin3WExYTbOfnclwL0wT+gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJ/CzlLVG3NNfl0DwkttRVmXGQOhU/CrXDdWs6bAy7KRpZU7KqCdF+C3S2y/+iWkk0oE1HHo/jHr+8/5p5uFJeMbljKB47NoGQJ/4XktDqRSI4ENEEZGU8gJnkOIChhEM3W3ZRxWqlBLVmQcfCz2rvuOMPRO4owmQWZTCZ/S61w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SwDFbvOG; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3d1ffa160b8so254290b6e.1
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 07:19:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717597184; x=1718201984; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0Pr/GgWGhD1e0y7bJe1ugy4uzP4rrsfTEk9Z0eKw/mo=;
        b=SwDFbvOGkrrmyxKFRN8JvCEtuMXDtRJdsro7V/FRMquKQ0KmgLUAMHyUoAHSfzZMtL
         gFOmd2nVN6ru24jl6vQrgk7Kv4V0CLRnL3g3Ui+McmnuWOLtdMJsM+z3/XzpVtSLMYWN
         nsTYptQNaimLkzgt8OMy+O6swWcnf4EyblzZLSIslAPDimfoNK92KpdIqzYwsygSJBXV
         g9wXa7EO85zeu0+DBywbFW6PwFZiGarvW/IEiWWwuX5GcetT1hFRGXhwqKVrc6Rl1+Lf
         yqbyaQcZxG0SWUeKJI65BxrqCHO4F1LtPxDbtALtxlepA8FNrNfosSlK/5FKcV2UZuWH
         4+TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597184; x=1718201984;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0Pr/GgWGhD1e0y7bJe1ugy4uzP4rrsfTEk9Z0eKw/mo=;
        b=G+ZPkCVtPHjf2XqkpBTAb+QrgswqO6gGOlXuemffMUEfSpYXOjIbvq6rp7EgWhFLKr
         wOoJ+kHrx7C58qhgMqOdBR60BS805iJyq1EDWiUbm3VWUDMyMhljHhTXsHtHQTTQjBDN
         pLUZpxTBke9bInW+Yz2wF5Hqf6LMipx1xiYt7pyfeSkgBWj3hZnFopzldEXtglNZxVst
         ppdOb3HXJobTg7+/0BZlrraOIQYlRFgxQ2sc/cvCVYCXGCG23GZG1hVNWjV4ZZO16KIS
         GJc/oRLKIoJhBt1FzuQvMji1lNGrLyoAk7IjQZ/utzylkhWQuAixtodhqTVGfBZqm/eG
         SMUg==
X-Gm-Message-State: AOJu0Yz37DVbVzs+7A4pgCFyLL201RJo2UqqEHOSy5BAcDPceGBhZfOf
	y0sBwcS7eBsk2vhMyewfGesFe66LVuGbCMmKqrOyKjRU+tNmEhzmk0YWfuh3QyVEJYaKNwvMNuK
	s
X-Google-Smtp-Source: AGHT+IHv9C+08cTmcfHjGY1m9OiVLlNxxtb6bBKkIFIYxI2aFDVrHK7rWPWoDUv4oPAFUEMyHvyeeg==
X-Received: by 2002:a05:6870:4d18:b0:24c:b092:fd38 with SMTP id 586e51a60fabf-25121cf42eamr3315507fac.1.1717597183583;
        Wed, 05 Jun 2024 07:19:43 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-250853ca28esm4048918fac.55.2024.06.05.07.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 07:19:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/9] io_uring: abstract out helpers for DEFER_TASKRUN wakeup batching
Date: Wed,  5 Jun 2024 07:51:11 -0600
Message-ID: <20240605141933.11975-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605141933.11975-1-axboe@kernel.dk>
References: <20240605141933.11975-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for being able to use these two elsewhere, factor out
the helpers that io_req_local_work_add() uses to do wakeup batching.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 24 +++---------------------
 io_uring/io_uring.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 94af56dd5344..499255ef62c7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1103,7 +1103,7 @@ void tctx_task_work(struct callback_head *cb)
 static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned nr_wait, nr_tw, nr_tw_prev;
+	unsigned nr_tw, nr_tw_prev;
 	struct llist_node *head;
 
 	/* See comment above IO_CQ_WAKE_INIT */
@@ -1116,19 +1116,8 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
 		flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
-	head = READ_ONCE(ctx->work_llist.first);
 	do {
-		nr_tw_prev = 0;
-		if (head) {
-			struct io_kiocb *first_req = container_of(head,
-							struct io_kiocb,
-							io_task_work.node);
-			/*
-			 * Might be executed at any moment, rely on
-			 * SLAB_TYPESAFE_BY_RCU to keep it alive.
-			 */
-			nr_tw_prev = READ_ONCE(first_req->nr_tw);
-		}
+		head = io_defer_tw_count(ctx, &nr_tw_prev);
 
 		/*
 		 * Theoretically, it can overflow, but that's fine as one of
@@ -1158,14 +1147,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 			io_eventfd_signal(ctx);
 	}
 
-	nr_wait = atomic_read(&ctx->cq_wait_nr);
-	/* not enough or no one is waiting */
-	if (nr_tw < nr_wait)
-		return;
-	/* the previous add has already woken it up */
-	if (nr_tw_prev >= nr_wait)
-		return;
-	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
+	io_defer_wake(ctx, nr_tw, nr_tw_prev);
 }
 
 static void io_req_normal_work_add(struct io_kiocb *req)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cd43924eed04..fdcf1a2a6b8a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -444,4 +444,48 @@ static inline bool io_has_work(struct io_ring_ctx *ctx)
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
 	       !llist_empty(&ctx->work_llist);
 }
+
+/*
+ * Return first request nr_tw field. Only applicable for users of
+ * ctx->work_llist, which is DEFER_TASKRUN. Must be called with the RCU read
+ * lock held. Returns the current task_work count and head of list, if any.
+ */
+static inline struct llist_node *io_defer_tw_count(struct io_ring_ctx *ctx,
+						   unsigned *nr_tw_prev)
+{
+	struct llist_node *head = READ_ONCE(ctx->work_llist.first);
+
+	*nr_tw_prev = 0;
+	if (head) {
+		struct io_kiocb *first;
+
+		first = container_of(head, struct io_kiocb, io_task_work.node);
+		/*
+		 * Might be executed at any moment, rely on
+		 * SLAB_TYPESAFE_BY_RCU to keep it alive.
+		 */
+		*nr_tw_prev = READ_ONCE(first->nr_tw);
+	}
+
+	return head;
+}
+
+static inline void io_defer_wake(struct io_ring_ctx *ctx, unsigned nr_tw,
+				 unsigned nr_tw_prev)
+{
+	struct task_struct *task = READ_ONCE(ctx->submitter_task);
+	unsigned nr_wait;
+
+	/* add pending overflows, for MSG_RING */
+	nr_tw += READ_ONCE(ctx->nr_overflow);
+
+	nr_wait = atomic_read(&ctx->cq_wait_nr);
+	/* not enough or no one is waiting */
+	if (nr_tw < nr_wait)
+		return;
+	/* the previous add has already woken it up */
+	if (nr_tw_prev >= nr_wait)
+		return;
+	wake_up_state(task, TASK_INTERRUPTIBLE);
+}
 #endif
-- 
2.43.0


