Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8ACA4176538
	for <lists+io-uring@lfdr.de>; Mon,  2 Mar 2020 21:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbgCBUq0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Mar 2020 15:46:26 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56073 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgCBUqY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Mar 2020 15:46:24 -0500
Received: by mail-wm1-f68.google.com with SMTP id 6so557284wmi.5;
        Mon, 02 Mar 2020 12:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=iL8XkZ3bohObdyki9erpkDmWE7PZz8rBVjTwpnCnlK0=;
        b=nDLP8OndFPvPiuH7XJcsOUk39QK4VKGjamBMl+y9hpzxcppH0mvU+BxkrHvLBO8qzM
         05haWkV0UB1KCShVrZVvKXdi8J4FPXBJU/Sq3xksWk9jTWZ82RvcZDTs72OcO/+XVDp9
         pxWMw4WPHDcqoqCZBkiUutYqsDemOs/QmZpi/jhI2KoSBTz4OXqkztv9PticdS1CF5Q6
         hbnUVjPwMsPgKVuLPwq3k1T+xDSupcTpYbRXhz5yhGXDObQcUHNHdzARg642slqx1DOt
         5Qm6yW8IookiZ0gyKZUTwm9yOfTFYCRwdkbENOov4wBm6ciLgf3yokFC5XOy5ik6z4Ia
         N7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iL8XkZ3bohObdyki9erpkDmWE7PZz8rBVjTwpnCnlK0=;
        b=KvD0M3OpQ6W6P4dDelzYAULj+/r32rtqTqHlCZ1Wsx0meS6ZvN2NQ8gc+LqgPyZfvh
         JqMkEo+WtR/nP/LJ++jVv7ZaHQ3Nt+GunC80M3k7/ifGJZJn59OdwomutWl4fvYbW1Fd
         T5izkVglhilrzJFP6x6lIrIIlYf+rwDt66kNHvwXw20Cd16GkuTcjc0R8k5Ndhs6XXg3
         csDUNIwV8MFK5tOXRYIfaLxifAMOZxSuhgmHqdWWeN5L197yXKya5gnkug7Jh1N6IEIu
         4Ru7LrStT0t4FOtiYmeEfBgbyimY/5ndxbYdBPc/z0pfhXb+8f7Gsw+dcBNDRFBNk/Hp
         Tgwg==
X-Gm-Message-State: ANhLgQ2TG842TZHWMiHdCv+4ybc19hZktcA+0gPAWCh3oRbmdgv503nx
        NmB7xS75yhOKe9c/jxG/ScM=
X-Google-Smtp-Source: ADFU+vtV9H7d66QDnqCeF4lsAfRdatMO5LB4geo0eceYIkaMjn64qYLHPTsHlOBBKClC75MO0XVvUQ==
X-Received: by 2002:a05:600c:291e:: with SMTP id i30mr277777wmd.40.1583181982354;
        Mon, 02 Mar 2020 12:46:22 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id b14sm20186549wrn.75.2020.03.02.12.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 12:46:21 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] io_uring: get next req on subm ref drop
Date:   Mon,  2 Mar 2020 23:45:19 +0300
Message-Id: <444aef98f849d947d7f10e88f30244fa0bc82360.1583181841.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583181841.git.asml.silence@gmail.com>
References: <cover.1583181841.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Get next request when dropping the submission reference. However, if
there is an asynchronous counterpart (i.e. read/write, timeout, etc),
that would be dangerous to do, so ignore them using new
REQ_F_DONT_STEAL_NEXT flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 129 ++++++++++++++++++++++++++------------------------
 1 file changed, 66 insertions(+), 63 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index daf7c2095523..e05710ca63d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -488,6 +488,7 @@ enum {
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
+	REQ_F_DONT_STEAL_NEXT_BIT,
 };
 
 enum {
@@ -532,6 +533,8 @@ enum {
 	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
 	/* already went through poll handler */
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
+	/* don't try to get next req, it's async and racy */
+	REQ_F_DONT_STEAL_NEXT	= BIT(REQ_F_DONT_STEAL_NEXT_BIT),
 };
 
 struct async_poll {
@@ -1218,6 +1221,27 @@ static void io_cqring_add_event(struct io_kiocb *req, long res)
 	io_cqring_ev_posted(ctx);
 }
 
+static void io_link_work_cb(struct io_wq_work **workptr)
+{
+	struct io_wq_work *work = *workptr;
+	struct io_kiocb *link = work->data;
+
+	io_queue_linked_timeout(link);
+	io_wq_submit_work(workptr);
+}
+
+static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
+{
+	struct io_kiocb *link;
+
+	*workptr = &nxt->work;
+	link = io_prep_linked_timeout(nxt);
+	if (link) {
+		nxt->work.func = io_link_work_cb;
+		nxt->work.data = link;
+	}
+}
+
 static inline bool io_is_fallback_req(struct io_kiocb *req)
 {
 	return req == (struct io_kiocb *)
@@ -1518,25 +1542,35 @@ static void io_free_req(struct io_kiocb *req)
 		io_queue_async_work(nxt);
 }
 
-/*
- * Drop reference to request, return next in chain (if there is one) if this
- * was the last reference to this request.
- */
-__attribute__((nonnull))
-static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
-{
-	if (refcount_dec_and_test(&req->refs)) {
-		io_req_find_next(req, nxtptr);
-		__io_free_req(req);
-	}
-}
-
 static void io_put_req(struct io_kiocb *req)
 {
 	if (refcount_dec_and_test(&req->refs))
 		io_free_req(req);
 }
 
+__attribute__((warn_unused_result))
+static struct io_kiocb *io_put_req_submission(struct io_kiocb *req)
+{
+	struct io_kiocb *nxt = NULL;
+
+	/* do it first, while holding a ref */
+	if (!(req->flags & REQ_F_DONT_STEAL_NEXT))
+		io_req_find_next(req, &nxt);
+
+	io_put_req(req);
+	return nxt;
+}
+
+static void io_put_req_async_submission(struct io_kiocb *req,
+					struct io_wq_work **workptr)
+{
+	static struct io_kiocb *nxt;
+
+	nxt = io_put_req_submission(req);
+	if (nxt)
+		io_wq_assign_next(workptr, nxt);
+}
+
 /*
  * Must only be used if we don't need to care about links, usually from
  * within the completion handling itself.
@@ -1979,8 +2013,11 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 {
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
+
 	switch (ret) {
 	case -EIOCBQUEUED:
+		req->flags |= REQ_F_DONT_STEAL_NEXT;
 		break;
 	case -ERESTARTSYS:
 	case -ERESTARTNOINTR:
@@ -2526,6 +2563,7 @@ static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->sync.flags & ~IORING_FSYNC_DATASYNC))
 		return -EINVAL;
 
+	req->flags |= REQ_F_DONT_STEAL_NEXT;
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->len);
 	return 0;
@@ -2543,27 +2581,6 @@ static bool io_req_cancelled(struct io_kiocb *req)
 	return false;
 }
 
-static void io_link_work_cb(struct io_wq_work **workptr)
-{
-	struct io_wq_work *work = *workptr;
-	struct io_kiocb *link = work->data;
-
-	io_queue_linked_timeout(link);
-	io_wq_submit_work(workptr);
-}
-
-static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
-{
-	struct io_kiocb *link;
-
-	*workptr = &nxt->work;
-	link = io_prep_linked_timeout(nxt);
-	if (link) {
-		nxt->work.func = io_link_work_cb;
-		nxt->work.data = link;
-	}
-}
-
 static void __io_fsync(struct io_kiocb *req)
 {
 	loff_t end = req->sync.off + req->sync.len;
@@ -2581,14 +2598,11 @@ static void __io_fsync(struct io_kiocb *req)
 static void io_fsync_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_fsync(req);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 
 static int io_fsync(struct io_kiocb *req, bool force_nonblock)
@@ -2617,14 +2631,11 @@ static void __io_fallocate(struct io_kiocb *req)
 static void io_fallocate_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_fallocate(req);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 
 static int io_fallocate_prep(struct io_kiocb *req,
@@ -2988,13 +2999,10 @@ static void __io_close_finish(struct io_kiocb *req)
 static void io_close_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	/* not cancellable, don't do io_req_cancelled() */
 	__io_close_finish(req);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 
 static int io_close(struct io_kiocb *req, bool force_nonblock)
@@ -3016,6 +3024,7 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 		 */
 		io_queue_async_work(req);
 		/* submission ref will be dropped, take it for async */
+		req->flags |= REQ_F_DONT_STEAL_NEXT;
 		refcount_inc_not_zero(&req->refs);
 		return 0;
 	}
@@ -3062,14 +3071,11 @@ static void __io_sync_file_range(struct io_kiocb *req)
 static void io_sync_file_range_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_sync_file_range(req);
-	io_put_req(req); /* put submission ref */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 
 static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
@@ -3435,14 +3441,11 @@ static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 static void io_accept_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_accept(req, false);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 #endif
 
@@ -3859,9 +3862,10 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 	hash_del(&req->hash_node);
 	io_poll_complete(req, req->result, 0);
 	req->flags |= REQ_F_COMP_LOCKED;
-	io_put_req_find_next(req, nxt);
 	spin_unlock_irq(&ctx->completion_lock);
 
+	req->flags &= ~REQ_F_DONT_STEAL_NEXT;
+	*nxt = io_put_req_submission(req);
 	io_cqring_ev_posted(ctx);
 }
 
@@ -3943,7 +3947,10 @@ static int io_poll_add(struct io_kiocb *req)
 	if (mask) {
 		io_cqring_ev_posted(ctx);
 		io_put_req(req);
+	} else {
+		req->flags |= REQ_F_DONT_STEAL_NEXT;
 	}
+
 	return ipt.error;
 }
 
@@ -4066,6 +4073,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (flags & ~IORING_TIMEOUT_ABS)
 		return -EINVAL;
 
+	req->flags |= REQ_F_DONT_STEAL_NEXT;
 	req->timeout.count = READ_ONCE(sqe->off);
 
 	if (!req->io && io_alloc_async_ctx(req))
@@ -4680,7 +4688,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 {
 	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 	int ret = 0;
 
 	/* if NO_CANCEL is set, we must still run the work */
@@ -4709,9 +4716,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		io_put_req(req);
 	}
 
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 
 static int io_req_needs_file(struct io_kiocb *req, int fd)
@@ -4935,10 +4940,6 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 
 err:
-	nxt = NULL;
-	/* drop submission reference */
-	io_put_req_find_next(req, &nxt);
-
 	if (linked_timeout) {
 		if (!ret)
 			io_queue_linked_timeout(linked_timeout);
@@ -4952,6 +4953,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req_set_fail_links(req);
 		io_put_req(req);
 	}
+
+	nxt = io_put_req_submission(req);
 	if (nxt) {
 		req = nxt;
 
-- 
2.24.0

