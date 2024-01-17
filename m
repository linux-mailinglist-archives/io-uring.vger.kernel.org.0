Return-Path: <io-uring+bounces-412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B4A582FE25
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 01:59:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4813A1C24169
	for <lists+io-uring@lfdr.de>; Wed, 17 Jan 2024 00:59:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185AB1C05;
	Wed, 17 Jan 2024 00:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WNNmVmyM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE0B15BF
	for <io-uring@vger.kernel.org>; Wed, 17 Jan 2024 00:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705453172; cv=none; b=iCyEmElVsOUjmmRphHQnCQpAO66I7FyxFt8HrrIctEKmrjQgSen6IDjYbdOEfTNzeDLyp9GO9CWzttosUKY1IYQl4fbNC7FTK5V0thY8FqyTXBpTQ/HlkSPsSx9Cd1e2G1nk1t0gzFxp+5xm8NtTOyZgcNH2qLWyMp0CDcCbm6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705453172; c=relaxed/simple;
	bh=LOg4EdZ5UDksxVyNDbpKjQDGPdohXkB0ZpRjq/QqbAY=;
	h=Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Google-Smtp-Source:X-Received:Received:From:
	 To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding; b=HU59aDN+Yj/cwxBU3mSKDSDybSZvVUaEKnAY3bpZfVyXkwN6hfm3KmSZokU/F2ncb2msb84uhULWKPfE6JeTdmYaDg++Bb2qxmr/382V7pWCzkVC8OBj04/xGYR+ovo3PKNI0qv+w5VCmz9jzoYnOPJbDTuUIoG+fllOFGSGiRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WNNmVmyM; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-50e7ddd999bso11623229e87.1
        for <io-uring@vger.kernel.org>; Tue, 16 Jan 2024 16:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705453168; x=1706057968; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XF1DWHT1/nwHkfy7jjWqjsO6epemJ97JrIogpTWqeoE=;
        b=WNNmVmyM8G3mz72DWDl+Bt+JCjjY9h6pjC11YdQDXIj+attZqnNEquqSAcvc8a02f4
         APvIjopoXQj0aHDeoB8wUpg0hcujwagVHFwy9RZZeOlMPFpxoZUFcbz1LnNKVFYG9Lj0
         GS58zSF7/aSfUQIpSF2yJHiUUm8ecvWBUHr6bZvbB4RZvY8ZALeEs25bV9AWfarrvkVC
         3YBO0hmfjmqxjbCIkvq3fMfQu2uNGOeSs3BmLdwdjm+SDChgVFbB55op+giQ/WW36Woc
         Cu02xo3EyFdrMSAuqnzK6JikEFvamPNa8RsG8Z9C7mAYJ1n8KtKgmpP+b/LeoI6AZ2jp
         4d9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705453168; x=1706057968;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XF1DWHT1/nwHkfy7jjWqjsO6epemJ97JrIogpTWqeoE=;
        b=fYBjTRnQhLagLa1vanfzGsNxJ9oEQnEDL63CC4lj0t01On6Y9nQ6mKOa/ljd9iVx87
         UbMyyemvzup8GRoqTGqqakGsh2TEHzer3IfskOzuaHrZo1h1xW5NtCL4+byGwmN1HuPy
         q6HtnSeWlLmHJbPbD5h0aaHeYXI0GC+TMnYSelFzO+ofxNzhl3tWhnlotWhEFCjjn/yZ
         +hwOsXjo5Vp/0X9529GdNAF5vzEGTHzkZQAG4DozkHoJ4qlJX1mZsaO8+8EL1YelHDLN
         +IUK68ef0S1dXZJuHWnxnFYv6XplVMfAbAophOe5fpxL/kyP3D5geyYI965DRuEGNdvl
         sldg==
X-Gm-Message-State: AOJu0YzAmfY+ICyr5oIau5ayVY9EDqtZT2BZkeOx7iXAU6UfSUYq7n+H
	RQgePSZlfkug4S9tfBtJlHdoRsshO6Y=
X-Google-Smtp-Source: AGHT+IGltLT8JsKtmUfkkFYai264UObsPgXjxlr8aWT9L1e2FI7czR/RxPHdJ5yshgY2m13A8J63KA==
X-Received: by 2002:a05:6512:74:b0:50e:79a5:545a with SMTP id i20-20020a056512007400b0050e79a5545amr3467146lfo.23.1705453168096;
        Tue, 16 Jan 2024 16:59:28 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.96])
        by smtp.gmail.com with ESMTPSA id t15-20020a17090605cf00b00a28aa4871c7sm7038982ejt.205.2024.01.16.16.59.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jan 2024 16:59:27 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring: combine cq_wait_nr checks
Date: Wed, 17 Jan 2024 00:57:29 +0000
Message-ID: <38def30282654d980673976cd42fde9bab19b297.1705438669.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1705438669.git.asml.silence@gmail.com>
References: <cover.1705438669.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of explicitly checking ->cq_wait_nr for whether there are
waiting, which is currently represented by 0, we can store there a
large value and the nr_tw will automatically filter out those cases.
Add a named constant for that and for the wake up bias value.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3508198d17ba..b5fa3c7df1cf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -137,6 +137,14 @@ struct io_defer_entry {
 #define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
 #define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
 
+/*
+ * No waiters. It's larger than any valid value of the tw counter
+ * so that tests against ->cq_wait_nr would fail and skip wake_up().
+ */
+#define IO_CQ_WAKE_INIT		(-1U)
+/* Forced wake up if there is a waiter regardless of ->cq_wait_nr */
+#define IO_CQ_WAKE_FORCE	(IO_CQ_WAKE_INIT >> 1)
+
 static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 bool cancel_all);
@@ -303,6 +311,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
@@ -1306,6 +1315,13 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	unsigned nr_wait, nr_tw, nr_tw_prev;
 	struct llist_node *head;
 
+	/* See comment above IO_CQ_WAKE_INIT */
+	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
+
+	/*
+	 * We don't know how many reuqests is there in the link and whether
+	 * they can even be queued lazily, fall back to non-lazy.
+	 */
 	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
 		flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
@@ -1322,10 +1338,14 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 			 */
 			nr_tw_prev = READ_ONCE(first_req->nr_tw);
 		}
+
+		/*
+		 * Theoretically, it can overflow, but that's fine as one of
+		 * previous adds should've tried to wake the task.
+		 */
 		nr_tw = nr_tw_prev + 1;
-		/* Large enough to fail the nr_wait comparison below */
 		if (!(flags & IOU_F_TWQ_LAZY_WAKE))
-			nr_tw = INT_MAX;
+			nr_tw = IO_CQ_WAKE_FORCE;
 
 		req->nr_tw = nr_tw;
 		req->io_task_work.node.next = head;
@@ -1348,11 +1368,11 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	}
 
 	nr_wait = atomic_read(&ctx->cq_wait_nr);
-	/* no one is waiting */
-	if (!nr_wait)
+	/* not enough or no one is waiting */
+	if (nr_tw < nr_wait)
 		return;
-	/* either not enough or the previous add has already woken it up */
-	if (nr_wait > nr_tw || nr_tw_prev >= nr_wait)
+	/* the previous add has already woken it up */
+	if (nr_tw_prev >= nr_wait)
 		return;
 	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
@@ -2620,7 +2640,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 		ret = io_cqring_wait_schedule(ctx, &iowq);
 		__set_current_state(TASK_RUNNING);
-		atomic_set(&ctx->cq_wait_nr, 0);
+		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 
 		/*
 		 * Run task_work after scheduling and before io_should_wake().
-- 
2.43.0


