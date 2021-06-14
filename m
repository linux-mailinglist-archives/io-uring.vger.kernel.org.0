Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC8F3A721C
	for <lists+io-uring@lfdr.de>; Tue, 15 Jun 2021 00:38:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhFNWkM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Jun 2021 18:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhFNWkJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Jun 2021 18:40:09 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8F0C0613A3
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:00 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id n35-20020a05600c3ba3b02901cdecb6bda8so400403wms.5
        for <io-uring@vger.kernel.org>; Mon, 14 Jun 2021 15:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=QyamZhAZemZONH+cdbzKclyyGLTJChbL46z1mD2EUds=;
        b=h8zMB0jw4QXll3YyitSRY27YTZprgHtozuq6AOnbGm6G0MonkxMpSrxc0jR+wNymlB
         /yxRj8SIWWcmnulW177gPxgSFVQ46wH6rqqO0siAjbaclS8EDMHB3od47MoSwQulHLXX
         eez6ejFwW5Y/I/RV8tZ9reML8ADb+87t29mK/neeEf1Qhgr72TD4ti/cGYIqrmlnUAL4
         YHwra8yJDIzkx9mNWSX0k+qXKhAmpkTOcIN3JPrajNuZyHht7M2Vapb1P5j81dU7C/kq
         HfR2NH/gemxftugGkk7dbzQbk5QxsKZzSIokt8MlNL8LCF/MZDAqFB/Bk2fnvPq9IbqZ
         aYqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QyamZhAZemZONH+cdbzKclyyGLTJChbL46z1mD2EUds=;
        b=mY1XX+1kbljRCfwiIUz6B0r934gTm0aR7237I0BGfiXTKN7MnKlK+mJcQtI+wQltNu
         FQTAz2xwXNO25o4l8CwfDo4XUU67CllYAEuY7JzphIAHr+3VdzHfGriSVyGjIoMRxMM3
         zlqX2C30dAeNGoAyiVjZqnZ7ci5QY2DdVU0TcHtp63hAdPQF4ADc2p5Jn9/P+gTZrBvD
         zFfr0q4f66VpGjA40aEtmOsrU6Abns6BriMaQKgGsoSUIjPPCzSokT08ZaRis591H52U
         icDBPMrGCC2x2HX0pQA9l8udr0jxpb5+L6kH+Eh42BG63hNKbbIZGoYJjSpneeyURLNT
         Ap9g==
X-Gm-Message-State: AOAM533NKuB8na5ClgsKFS1CQHRSvJmPHE+xrHSzd9OC5XR3nBQMuROM
        wrRmccY+KGON8wKIS/iopO4iNUG3EppzGyq4
X-Google-Smtp-Source: ABdhPJyun6L7YAFosrOuA05e1AC7lCrdCWpDYQZMqv7+48x05AAt7+ih4ghng1aWl4L7N7AaST4q1Q==
X-Received: by 2002:a05:600c:1546:: with SMTP id f6mr1516033wmg.47.1623710279073;
        Mon, 14 Jun 2021 15:37:59 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.209])
        by smtp.gmail.com with ESMTPSA id x3sm621074wmj.30.2021.06.14.15.37.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 15:37:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/12] io_uring: clean up check_overflow flag
Date:   Mon, 14 Jun 2021 23:37:27 +0100
Message-Id: <25927394964df31d113e3c729416af573afff5f5.1623709150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623709150.git.asml.silence@gmail.com>
References: <cover.1623709150.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are no users of ->sq_check_overflow, only ->cq_check_overflow is
used. Combine it and move out of completion related part of struct
io_ring_ctx.

A not so obvious benefit of it is fitting all completion side fields
into a single cacheline. It was taking 2 lines before with 56B padding,
and io_cqring_ev_posted*() were still touching both of them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9c73991465c8..65d51e2d5c15 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -371,7 +371,6 @@ struct io_ring_ctx {
 		struct io_uring_sqe	*sq_sqes;
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
-		unsigned long		sq_check_overflow;
 		struct list_head	defer_list;
 
 		/*
@@ -408,13 +407,14 @@ struct io_ring_ctx {
 	struct wait_queue_head	sqo_sq_wait;
 	struct list_head	sqd_list;
 
+	unsigned long		check_cq_overflow;
+
 	struct {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
 		atomic_t		cq_timeouts;
 		unsigned		cq_last_tm_flush;
 		unsigned		cq_extra;
-		unsigned long		cq_check_overflow;
 		struct wait_queue_head	cq_wait;
 		struct fasync_struct	*cq_fasync;
 		struct eventfd_ctx	*cq_ev_fd;
@@ -1464,8 +1464,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 
 	all_flushed = list_empty(&ctx->cq_overflow_list);
 	if (all_flushed) {
-		clear_bit(0, &ctx->sq_check_overflow);
-		clear_bit(0, &ctx->cq_check_overflow);
+		clear_bit(0, &ctx->check_cq_overflow);
 		ctx->rings->sq_flags &= ~IORING_SQ_CQ_OVERFLOW;
 	}
 
@@ -1481,7 +1480,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
 	bool ret = true;
 
-	if (test_bit(0, &ctx->cq_check_overflow)) {
+	if (test_bit(0, &ctx->check_cq_overflow)) {
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
@@ -1544,8 +1543,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 		return false;
 	}
 	if (list_empty(&ctx->cq_overflow_list)) {
-		set_bit(0, &ctx->sq_check_overflow);
-		set_bit(0, &ctx->cq_check_overflow);
+		set_bit(0, &ctx->check_cq_overflow);
 		ctx->rings->sq_flags |= IORING_SQ_CQ_OVERFLOW;
 	}
 	ocqe->cqe.user_data = user_data;
@@ -2391,7 +2389,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 	 * If we do, we can potentially be spinning for commands that
 	 * already triggered a CQE (eg in error).
 	 */
-	if (test_bit(0, &ctx->cq_check_overflow))
+	if (test_bit(0, &ctx->check_cq_overflow))
 		__io_cqring_overflow_flush(ctx, false);
 	if (io_cqring_events(ctx))
 		goto out;
@@ -6965,7 +6963,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
 	 * the task, and the next invocation will do it.
 	 */
-	if (io_should_wake(iowq) || test_bit(0, &iowq->ctx->cq_check_overflow))
+	if (io_should_wake(iowq) || test_bit(0, &iowq->ctx->check_cq_overflow))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
 	return -1;
 }
@@ -6993,7 +6991,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (ret || io_should_wake(iowq))
 		return ret;
 	/* let the caller flush overflows, retry */
-	if (test_bit(0, &ctx->cq_check_overflow))
+	if (test_bit(0, &ctx->check_cq_overflow))
 		return 1;
 
 	*timeout = schedule_timeout(*timeout);
@@ -8702,7 +8700,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	 * Users may get EPOLLIN meanwhile seeing nothing in cqring, this
 	 * pushs them to do the flush.
 	 */
-	if (io_cqring_events(ctx) || test_bit(0, &ctx->cq_check_overflow))
+	if (io_cqring_events(ctx) || test_bit(0, &ctx->check_cq_overflow))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;
-- 
2.31.1

