Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8821F25CEAC
	for <lists+io-uring@lfdr.de>; Fri,  4 Sep 2020 02:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbgIDAEi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Sep 2020 20:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728134AbgIDAEh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Sep 2020 20:04:37 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCB7C061244
        for <io-uring@vger.kernel.org>; Thu,  3 Sep 2020 17:04:36 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b16so2340251pjp.0
        for <io-uring@vger.kernel.org>; Thu, 03 Sep 2020 17:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=itDJu9EF7mzDdjP5PTcIjFeFVLaLdA5v6VN5XLJINJA=;
        b=zFaGl3GnGpvRYbzZZAIAFixyXTmsejlER1/SHxz3JKcDlA4txWKYhiTZOY00mFq1Iz
         ABudivBY+Fs20KRvEumTlNKafqYiAhngbOAj5Ho6rnNrXVFjvIFUB8Iw6g21PrUUfTnV
         kwzo89CMi5bW5EAJtiOOzeroDCGQI7Dd09H33tWXG7GxqsKGSw7UWLcZYCdKlNUz8MCb
         jW03Fk5tIyo+gaYqPFAssSq+vleCf/ytWVMP6hKYI3F2WuKK17chFSbxmQ7VwKANx55y
         fqcqGhYDsOpbw6BsI3ws9o7HXiUMPlKYdueLKHU6TSYnp99YOWxWLKA+GThHt8V0g4Fm
         Nl/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=itDJu9EF7mzDdjP5PTcIjFeFVLaLdA5v6VN5XLJINJA=;
        b=feqj72wSg9iDi3c3m/+U5V2NKWCZdFO0mX2xT3xpN04QOzFOiZKF/ESo4tsNhW6/Y9
         Iq2GDj8/y/6v+G9RYWGvDmhQ4YN2sOo/A2e1wqceH0oBGpRiWsZO1ELj3TzKmyvWOIf9
         gbHmqlhfXWD0Igg8X8ie6OAzmsLpO+qjtsrNfRmK0dS6SinKOOJW+BTaGuwAV8+Lz6wl
         KKtSVCzIcBXC+DCeoC6i9oE26Fqb/bsuIII7t+thS5lU6GmqKroFk9GUoGo0L7n9NpdU
         5ISJiXczXwHRgo2o/wyRQ72rDkEJJGpF0NqGaEiBsmyEDWBNjongaB7BXcDCwkEGLWj5
         btIg==
X-Gm-Message-State: AOAM532Z/08AjaMRUVgpFZkFQs56N24TF1lr0WDnNaJTjU4Ia5wdxFpY
        dJF9zloB/rUlfe7lJA9RDaOFkREufZwLHq9H
X-Google-Smtp-Source: ABdhPJw016Uyl9sfQosR34JOIli7hn3cim9MuqgQRjsoj2ttfRec4wlaYxCsFrFS3zy+dCtZwspeqw==
X-Received: by 2002:a17:902:7606:: with SMTP id k6mr6454690pll.171.1599177875865;
        Thu, 03 Sep 2020 17:04:35 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id v8sm18894482pju.1.2020.09.03.17.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2020 17:04:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: provide IORING_ENTER_SQ_WAIT for SQPOLL SQ ring waits
Date:   Thu,  3 Sep 2020 18:02:29 -0600
Message-Id: <20200904000229.90868-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904000229.90868-2-axboe@kernel.dk>
References: <20200904000229.90868-1-axboe@kernel.dk>
 <20200904000229.90868-2-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When using SQPOLL, applications can run into the issue of running out of
SQ ring entries because the thread hasn't consumed them yet. The only
option for dealing with that is checking later, or busy checking for the
condition.

Provide IORING_ENTER_SQ_WAIT if applications want to wait on this
condition.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 40 ++++++++++++++++++++++++++++++++---
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7a3f10a9329a..44c11bdc0dc7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -304,6 +304,7 @@ struct io_ring_ctx {
 
 	struct wait_queue_entry	sqo_wait_entry;
 	struct list_head	sqd_list;
+	struct wait_queue_head	sqo_sq_wait;
 
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
@@ -1094,6 +1095,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	init_waitqueue_head(&ctx->cq_wait);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
@@ -1324,6 +1326,13 @@ static void io_commit_cqring(struct io_ring_ctx *ctx)
 		__io_queue_deferred(ctx);
 }
 
+static inline bool io_sqring_full(struct io_ring_ctx *ctx)
+{
+	struct io_rings *r = ctx->rings;
+
+	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == r->sq_ring_entries;
+}
+
 static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
@@ -6673,6 +6682,10 @@ static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
 	if (likely(!percpu_ref_is_dying(&ctx->refs)))
 		ret = io_submit_sqes(ctx, to_submit, NULL, -1);
 	mutex_unlock(&ctx->uring_lock);
+
+	if (!io_sqring_full(ctx) && wq_has_sleeper(&ctx->sqo_sq_wait))
+		wake_up(&ctx->sqo_sq_wait);
+
 	return SQT_DID_WORK;
 }
 
@@ -8124,8 +8137,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	 * io_commit_cqring
 	 */
 	smp_rmb();
-	if (READ_ONCE(ctx->rings->sq.tail) - ctx->cached_sq_head !=
-	    ctx->rings->sq_ring_entries)
+	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
 	if (io_cqring_events(ctx, false))
 		mask |= EPOLLIN | EPOLLRDNORM;
@@ -8448,6 +8460,25 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
 
 #endif /* !CONFIG_MMU */
 
+static void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
+{
+	DEFINE_WAIT(wait);
+
+	do {
+		if (!io_sqring_full(ctx))
+			break;
+
+		prepare_to_wait(&ctx->sqo_sq_wait, &wait, TASK_INTERRUPTIBLE);
+
+		if (!io_sqring_full(ctx))
+			break;
+
+		schedule();
+	} while (!signal_pending(current));
+
+	finish_wait(&ctx->sqo_sq_wait, &wait);
+}
+
 SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		u32, min_complete, u32, flags, const sigset_t __user *, sig,
 		size_t, sigsz)
@@ -8459,7 +8490,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 	io_run_task_work();
 
-	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
+	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
+			IORING_ENTER_SQ_WAIT))
 		return -EINVAL;
 
 	f = fdget(fd);
@@ -8489,6 +8521,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			io_cqring_overflow_flush(ctx, false);
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
+		if (flags & IORING_ENTER_SQ_WAIT)
+			io_sqpoll_wait_sq(ctx);
 		submitted = to_submit;
 	} else if (to_submit) {
 		mutex_lock(&ctx->uring_lock);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1112c0f05641..7539d912690b 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -225,6 +225,7 @@ struct io_cqring_offsets {
  */
 #define IORING_ENTER_GETEVENTS	(1U << 0)
 #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
+#define IORING_ENTER_SQ_WAIT	(1U << 2)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
-- 
2.28.0

