Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CFC309F3A
	for <lists+io-uring@lfdr.de>; Sun, 31 Jan 2021 23:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbhAaW1V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 31 Jan 2021 17:27:21 -0500
Received: from mail-pg1-f174.google.com ([209.85.215.174]:35891 "EHLO
        mail-pg1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbhAaWVW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 31 Jan 2021 17:21:22 -0500
Received: by mail-pg1-f174.google.com with SMTP id c132so10735392pga.3
        for <io-uring@vger.kernel.org>; Sun, 31 Jan 2021 14:21:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nCveuUS7AlzvYQYS7tDybItdgft6n4wGGJu/4VfWVMQ=;
        b=JFUuv7/A/Dhu/SwA94mfZHLFS9sFeoMZrAR3NDq16xRyYgYMlKxyhc8bXoRifDdQ2K
         vMyeb2wET5/+UdoPxLiS2sIK6931fSKbzltS2ozpYExcZZ/DTg5gU4D9sHlyU7YPNiDE
         5HNv+DloGJ82EwA6Au9ljd96yE7GbsJM4EH8mnDT8B7BBXHQxyV0NjBQKCL5+4E5c7HY
         8N3/GHH/NJq0oMLJDuReRvDhJDJG3Jo5iABXks5XcQJ8Cd1o5femcU+ru/bQ+8NUdfmg
         HrOVSphwQPCnK6oZbAzplWOhg5mMcAyTfnssdvSNAwW66KsqKsraGDryXhsTknr7nIFw
         ugPQ==
X-Gm-Message-State: AOAM531uPmIUnbupyrfIRjxnIw/aEZZgqXpShClJEgryweayHbv+ZQnU
        aTfpAbQQM3P6eE+jKsOEcNU=
X-Google-Smtp-Source: ABdhPJx6kXykTiC3S0plXSLa71Q3i5xM3RWnuiPYvrwU6B235yYFXmtjJhFlG88uC7eIUDWtRuRGag==
X-Received: by 2002:a63:c43:: with SMTP id 3mr13781111pgm.250.1612131639871;
        Sun, 31 Jan 2021 14:20:39 -0800 (PST)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:d792:df3e:7885:dc0e])
        by smtp.gmail.com with ESMTPSA id w13sm15467705pfc.7.2021.01.31.14.20.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Jan 2021 14:20:38 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH v2] io_uring: Optimize and improve SQ tail and CQ head handling
Date:   Sun, 31 Jan 2021 14:20:32 -0800
Message-Id: <20210131222032.10996-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The improvements in this patch are as follows:
- Move the io_sqring_entries() definition up such that this function can be
  used in the io_sqring_full() implementation.
- Introduce the new function io_cqring_full().
- Change several memory barriers into load acquire / store release
  instructions since the latter are faster on non-x86 CPUs. Note: on x86
  CPUs smp_rmb() and smp_wmb() only involve a compiler barrier.
- Ensure completions have been reaped from use space before these are
  overwritten by using smp_load_acquire() in __io_cqring_events().
  Preceding __io_cqring_events() with smp_rmb() is not sufficient because
  the CPU may reorder READ_ONCE() in __io_cqring_events() with later memory
  accesses.

This patch has been tested by running the liburing test suite on an x86 system.

Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 fs/io_uring.c | 72 +++++++++++++++++++++++----------------------------
 1 file changed, 32 insertions(+), 40 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 03748faa5295..287ad97ff992 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1699,16 +1699,31 @@ static void io_commit_cqring(struct io_ring_ctx *ctx)
 		__io_queue_deferred(ctx);
 }
 
+static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
+{
+	struct io_rings *rings = ctx->rings;
+
+	/* make sure SQ entry isn't read before tail */
+	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
+}
+
 static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 {
 	struct io_rings *r = ctx->rings;
 
-	return READ_ONCE(r->sq.tail) - ctx->cached_sq_head == r->sq_ring_entries;
+	return io_sqring_entries(ctx) == r->sq_ring_entries;
 }
 
-static inline unsigned int __io_cqring_events(struct io_ring_ctx *ctx)
+static inline unsigned int io_cqring_events(struct io_ring_ctx *ctx)
 {
-	return ctx->cached_cq_tail - READ_ONCE(ctx->rings->cq.head);
+	return ctx->cached_cq_tail - smp_load_acquire(&ctx->rings->cq.head);
+}
+
+static inline bool io_cqring_full(struct io_ring_ctx *ctx)
+{
+	struct io_rings *rings = ctx->rings;
+
+	return io_cqring_events(ctx) == rings->cq_ring_entries;
 }
 
 static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
@@ -1717,11 +1732,12 @@ static struct io_uring_cqe *io_get_cqring(struct io_ring_ctx *ctx)
 	unsigned tail;
 
 	/*
-	 * writes to the cq entry need to come after reading head; the
-	 * control dependency is enough as we're using WRITE_ONCE to
-	 * fill the cq entry
+	 * Writes to the CQ entry must happen after reading the CQ head. The
+	 * load-acquire in io_cqring_events() combined with the store-release
+	 * in liburing guarantee that filling the CQ entry will happen after
+	 * the cq entry has been read from user space.
 	 */
-	if (__io_cqring_events(ctx) == rings->cq_ring_entries)
+	if (io_cqring_full(ctx))
 		return NULL;
 
 	tail = ctx->cached_cq_tail++;
@@ -1778,14 +1794,13 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 				       struct task_struct *tsk,
 				       struct files_struct *files)
 {
-	struct io_rings *rings = ctx->rings;
 	struct io_kiocb *req, *tmp;
 	struct io_uring_cqe *cqe;
 	unsigned long flags;
 	bool all_flushed, posted;
 	LIST_HEAD(list);
 
-	if (!force && __io_cqring_events(ctx) == rings->cq_ring_entries)
+	if (!force && io_cqring_full(ctx))
 		return false;
 
 	posted = false;
@@ -2392,21 +2407,6 @@ static void io_double_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static unsigned io_cqring_events(struct io_ring_ctx *ctx)
-{
-	/* See comment at the top of this file */
-	smp_rmb();
-	return __io_cqring_events(ctx);
-}
-
-static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
-{
-	struct io_rings *rings = ctx->rings;
-
-	/* make sure SQ entry isn't read before tail */
-	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
-}
-
 static unsigned int io_put_kbuf(struct io_kiocb *req, struct io_buffer *kbuf)
 {
 	unsigned int cflags;
@@ -2464,15 +2464,12 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	struct io_kiocb *req;
 	LIST_HEAD(again);
 
-	/* order with ->result store in io_complete_rw_iopoll() */
-	smp_rmb();
-
 	io_init_req_batch(&rb);
 	while (!list_empty(done)) {
 		int cflags = 0;
 
 		req = list_first_entry(done, struct io_kiocb, inflight_entry);
-		if (READ_ONCE(req->result) == -EAGAIN) {
+		if (req->result == -EAGAIN) {
 			req->result = 0;
 			req->iopoll_completed = 0;
 			list_move_tail(&req->inflight_entry, &again);
@@ -2521,7 +2518,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		 * If we find a request that requires polling, break out
 		 * and complete those lists first, if we have entries there.
 		 */
-		if (READ_ONCE(req->iopoll_completed)) {
+		if (smp_load_acquire(&req->iopoll_completed)) {
 			list_move_tail(&req->inflight_entry, &done);
 			continue;
 		}
@@ -2533,7 +2530,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, unsigned int *nr_events,
 			break;
 
 		/* iopoll may have completed current req */
-		if (READ_ONCE(req->iopoll_completed))
+		if (smp_load_acquire(&req->iopoll_completed))
 			list_move_tail(&req->inflight_entry, &done);
 
 		if (ret && spin)
@@ -2768,10 +2765,9 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
 	if (res != -EAGAIN && res != req->result)
 		req_set_fail_links(req);
 
-	WRITE_ONCE(req->result, res);
-	/* order with io_poll_complete() checking ->result */
-	smp_wmb();
-	WRITE_ONCE(req->iopoll_completed, 1);
+	req->result = res;
+	/* order with io_poll_complete() checking ->iopoll_completed */
+	smp_store_release(&req->iopoll_completed, 1);
 }
 
 /*
@@ -2804,7 +2800,7 @@ static void io_iopoll_req_issued(struct io_kiocb *req, bool in_async)
 	 * For fast devices, IO may have already completed. If it has, add
 	 * it to the front so we find it first.
 	 */
-	if (READ_ONCE(req->iopoll_completed))
+	if (smp_load_acquire(&req->iopoll_completed))
 		list_add(&req->inflight_entry, &ctx->iopoll_list);
 	else
 		list_add_tail(&req->inflight_entry, &ctx->iopoll_list);
@@ -6749,11 +6745,7 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
 
-	/*
-	 * Ensure any loads from the SQEs are done at this point,
-	 * since once we write the new head, the application could
-	 * write new data to them.
-	 */
+	/* Ensure SQE reads happen before user space sees the new SQ head. */
 	smp_store_release(&rings->sq.head, ctx->cached_sq_head);
 }
 
