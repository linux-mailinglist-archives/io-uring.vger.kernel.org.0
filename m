Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 338BB3A7219
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhFNWkF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbhFNWkE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:40:04 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FCCC0613A4
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:01 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id l9so12982223wms.1
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=l8IXZMyUdGNPFcM+jvf71NPDHlynJvqRh+RePPa4mpU=;
        b=kzbaxjN6fMrHNgPZ3GWWpxvzOlnHlSEjkG8grAX+ef6zGyitWBMA5LN2co+Ey61rEe
         kn6HBMxT2Owf+wUM2RLnr14Gkccl9OzoXmbZEKlRjv0LySWdykpwI5fjNd9RFMsSHuzy
         2JV/7y4JzLeTTGm0RCvpD5pQuM+6NAWAx+O1DlYU6SZ6N1qlwGiPyQ5Q/5wda7eDWuz8
         YjquWbmvbCEUL4rmi8xkN+M9hijDq84jS/i8EH5PYtQ2WpRA1BaDV70mbQy59H38ktxq
         vKLrS+058qNmVFzoZnqgixqhBcvC53wliFalQHBjzc1Z/Dn0+HYCrEclyfrO1o2sj3eX
         Xmmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l8IXZMyUdGNPFcM+jvf71NPDHlynJvqRh+RePPa4mpU=;
        b=NC4vAy1uT6j9OCR1mSqb8vDkBJB5xcMjVgDj8/bHowEFz8bt/acX+2r+kvVsaGggz0
         iQESz2duS1vjHl+nf1w6j2Rul2ZTnv3SQwD+6jOVG1BRnWs/eabQbdHOm7bT28DfovJu
         QM823QndryexGfUoOh32k7l6oSAHnle6iWlWxncKVj8GHV/BusuOMHXOaBxtTrgD82Md
         2hBGDLzSOGpPwR4mzDg9bpREWhpm6lhI0yxygvfl+2u27pK3S5jyfaV6GPnLtbEviyTt
         s9UDBVmt0unz84jdvI2R3EEOXjQzOpMr6BmMiD1NdNopuzVTpbinIzpxh3NYZ0fdKXCE
         ghuA==
X-Gm-Message-State: AOAM530Ec2pVUE3+oImdrUFNITNAR8dUOUucIT7nFzyZcAH9a9QBP6Su
        BENOW+sHGDpBVsJEuEISjAw=
X-Google-Smtp-Source: ABdhPJwX0vzQ7LZHTHQCPSWrqh1/2W/Ocel51pfpmzDf4GU0qZKWXvrtkFYQFqG1whB6alfC1N8+/w==
X-Received: by 2002:a1c:7402:: with SMTP id p2mr1487443wmc.88.1623710279948;
        Mon, 14 Jun 2021 15:37:59 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.37.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:37:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/12] io_uring: wait heads renaming
Date:   Mon, 14 Jun 2021 23:37:28 +0100
Message-Id: <47b97a097780c86c67b20b6ccc4e077523dce682.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use several wait_queue_head's for different purposes, but namings are
confusing. First rename ctx->cq_wait into ctx->poll_wait, because this
one is used for polling an io_uring instance. Then rename ctx->wait into
ctx->cq_wait, which is responsible for CQE waiting.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 65d51e2d5c15..e9bf26fbf65d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -394,7 +394,7 @@ struct io_ring_ctx {
 
 	struct {
 		struct mutex		uring_lock;
-		wait_queue_head_t	wait;
+		wait_queue_head_t	cq_wait;
 	} ____cacheline_aligned_in_smp;
 
 	/* IRQ completion list, under ->completion_lock */
@@ -415,7 +415,7 @@ struct io_ring_ctx {
 		atomic_t		cq_timeouts;
 		unsigned		cq_last_tm_flush;
 		unsigned		cq_extra;
-		struct wait_queue_head	cq_wait;
+		struct wait_queue_head	poll_wait;
 		struct fasync_struct	*cq_fasync;
 		struct eventfd_ctx	*cq_ev_fd;
 	} ____cacheline_aligned_in_smp;
@@ -1178,13 +1178,13 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	ctx->flags = p->flags;
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
-	init_waitqueue_head(&ctx->cq_wait);
+	init_waitqueue_head(&ctx->poll_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	init_completion(&ctx->ref_comp);
 	xa_init_flags(&ctx->io_buffers, XA_FLAGS_ALLOC1);
 	xa_init_flags(&ctx->personalities, XA_FLAGS_ALLOC1);
 	mutex_init(&ctx->uring_lock);
-	init_waitqueue_head(&ctx->wait);
+	init_waitqueue_head(&ctx->cq_wait);
 	spin_lock_init(&ctx->completion_lock);
 	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
@@ -1404,14 +1404,14 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 	/* see waitqueue_active() comment */
 	smp_mb();
 
-	if (waitqueue_active(&ctx->wait))
-		wake_up(&ctx->wait);
+	if (waitqueue_active(&ctx->cq_wait))
+		wake_up(&ctx->cq_wait);
 	if (ctx->sq_data && waitqueue_active(&ctx->sq_data->wait))
 		wake_up(&ctx->sq_data->wait);
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (waitqueue_active(&ctx->cq_wait)) {
-		wake_up_interruptible(&ctx->cq_wait);
+	if (waitqueue_active(&ctx->poll_wait)) {
+		wake_up_interruptible(&ctx->poll_wait);
 		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
 	}
 }
@@ -1422,13 +1422,13 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 	smp_mb();
 
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		if (waitqueue_active(&ctx->wait))
-			wake_up(&ctx->wait);
+		if (waitqueue_active(&ctx->cq_wait))
+			wake_up(&ctx->cq_wait);
 	}
 	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
-	if (waitqueue_active(&ctx->cq_wait)) {
-		wake_up_interruptible(&ctx->cq_wait);
+	if (waitqueue_active(&ctx->poll_wait)) {
+		wake_up_interruptible(&ctx->poll_wait);
 		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
 	}
 }
@@ -7056,10 +7056,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			ret = -EBUSY;
 			break;
 		}
-		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
+		prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		ret = io_cqring_wait_schedule(ctx, &iowq, &timeout);
-		finish_wait(&ctx->wait, &iowq.wq);
+		finish_wait(&ctx->cq_wait, &iowq.wq);
 		cond_resched();
 	} while (ret > 0);
 
@@ -8678,7 +8678,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	struct io_ring_ctx *ctx = file->private_data;
 	__poll_t mask = 0;
 
-	poll_wait(file, &ctx->cq_wait, wait);
+	poll_wait(file, &ctx->poll_wait, wait);
 	/*
 	 * synchronizes with barrier from wq_has_sleeper call in
 	 * io_commit_cqring
-- 
2.31.1

