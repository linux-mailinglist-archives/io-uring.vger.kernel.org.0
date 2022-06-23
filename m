Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9B35576B5
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 11:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiFWJfP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jun 2022 05:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230157AbiFWJfO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jun 2022 05:35:14 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 646D749686
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:12 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id r20so6658302wra.1
        for <io-uring@vger.kernel.org>; Thu, 23 Jun 2022 02:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ObHf+Q+U332P8r4EPQq6M4FmfZMgUHMGiVM2B9IjNdQ=;
        b=RJVSSHVqtR5jcfQ7ZooaDyrGxj9SfmgW4dG391OdDq9pFRhHwWPwh9KYQuVNC811sI
         B4+hH63a6X8vS0QoKxFebpNHQ1CJYIY1DcHP9snTkoA2vYXrg2TgJP1rG/2WXHCKUDsw
         4t5Lt3GonF0RuR8pDWc0tqc59HIa4b9zN+5kORGNNFBLTn0TJLcsudofHhUdql/61DpU
         JJ/nsuix6+FTkiJ6+NR1y4r7fa/R+p1yDanLyUyiqwAt8FWXp/JYkwfFMJAICI+cCWZM
         YzIlPFIwuvhdvreZJQLwJgrPAbknFZcEeG0qlR4ig7BhuP0MCziOpGEY/DsNn8556uDs
         9WpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ObHf+Q+U332P8r4EPQq6M4FmfZMgUHMGiVM2B9IjNdQ=;
        b=uOPYXHVP4+Kzk30QNGX5+TFGoQOhhL0nsjPNnOtpffcX3yZMn1IsRPEU/lPTRW/LM8
         NDVHS2TfOMKDLcqIvuGh9w1iaqZ+v9JJV1oWjo6iRRVqmSgoLzR/JGZyqMzqv7UDmD2v
         Y4Ro9iNpef1k4H0n+maSCKJwf+Kir5zdgPJQxkLd4DnquALPR1PwzAw1FktcEmvPMwNr
         mJ5u7tMpZY3unWRHLDjXROy15Cws97DYasEtntuqcEJaSoSV7pqynfpX97R2fWvRJY7B
         BtIaO3nyJChE+T+c6BUEQwfi2dIRXi/CBlOMLt9PLof5w9JU3ZACerpZPXK2eFjS1zQM
         Zxug==
X-Gm-Message-State: AJIora/O8ajbHnR7QLrW8McLkXofvdrGUyQ169ZS45fXzExfpJtCB9cK
        ovg+mUEuQo2V1tLEq1FAwAUJcxjTLUuMPI/Y
X-Google-Smtp-Source: AGRyM1uRIEZoYSfbHHVsWDavxSMJFfrwapFG5mxPDZK5YMz7WmiXBaYEcGh0yn06SXBQvUbvj1ccXQ==
X-Received: by 2002:adf:d22b:0:b0:21b:90be:2dc8 with SMTP id k11-20020adfd22b000000b0021b90be2dc8mr7179336wrh.423.1655976910409;
        Thu, 23 Jun 2022 02:35:10 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id r21-20020a05600c35d500b003a02f957245sm2431202wmq.26.2022.06.23.02.35.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:35:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 6/6] io_uring: optimise submission side poll_refs
Date:   Thu, 23 Jun 2022 10:34:35 +0100
Message-Id: <c3b5484c1236f86e3d60a5975456a927670f11b6.1655976119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655976119.git.asml.silence@gmail.com>
References: <cover.1655976119.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The final poll_refs put in __io_arm_poll_handler() takes quite some
cycles. When we're arming from the original task context task_work won't
be run, so in this case we can assume that we won't race with task_works
and so not take the initial ownership ref.

One caveat is that after arming a poll we may race with it, so we have
to add a bunch of io_poll_get_ownership() hidden inside of
io_poll_can_finish_inline() whenever we want to complete arming inline.
For the same reason we can't just set REQ_F_DOUBLE_POLL in
__io_queue_proc() and so need to sync with the first poll entry by
taking its wq head lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 88 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 67 insertions(+), 21 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 149205eae418..69b2f4bab3b2 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -34,6 +34,7 @@ struct io_poll_table {
 	struct io_kiocb *req;
 	int nr_entries;
 	int error;
+	bool owning;
 	/* output value, set only if arm poll returns >0 */
 	__poll_t result_mask;
 };
@@ -374,6 +375,27 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	return 1;
 }
 
+static void io_poll_double_prepare(struct io_kiocb *req)
+{
+	struct wait_queue_head *head;
+	struct io_poll *poll = io_poll_get_single(req);
+
+	/* head is RCU protected, see io_poll_remove_entries() comments */
+	rcu_read_lock();
+	head = smp_load_acquire(&poll->head);
+	if (head) {
+		/*
+		 * poll arm may not hold ownership and so race with
+		 * io_poll_wake() by modifying req->flags. There is only one
+		 * poll entry queued, serialise with it by taking its head lock.
+		 */
+		spin_lock_irq(&head->lock);
+		req->flags |= REQ_F_DOUBLE_POLL;
+		spin_unlock_irq(&head->lock);
+	}
+	rcu_read_unlock();
+}
+
 static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 			    struct wait_queue_head *head,
 			    struct io_poll **poll_ptr)
@@ -405,16 +427,19 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 			pt->error = -ENOMEM;
 			return;
 		}
+
+		io_poll_double_prepare(req);
 		/* mark as double wq entry */
 		wqe_private |= IO_WQE_F_DOUBLE;
-		req->flags |= REQ_F_DOUBLE_POLL;
 		io_init_poll_iocb(poll, first->events, first->wait.func);
 		*poll_ptr = poll;
 		if (req->opcode == IORING_OP_POLL_ADD)
 			req->flags |= REQ_F_ASYNC_DATA;
+	} else {
+		/* fine to modify, there is no poll queued to race with us */
+		req->flags |= REQ_F_SINGLE_POLL;
 	}
 
-	req->flags |= REQ_F_SINGLE_POLL;
 	pt->nr_entries++;
 	poll->head = head;
 	poll->wait.private = (void *) wqe_private;
@@ -435,6 +460,12 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 			(struct io_poll **) &pt->req->async_data);
 }
 
+static bool io_poll_can_finish_inline(struct io_kiocb *req,
+				      struct io_poll_table *pt)
+{
+	return pt->owning || io_poll_get_ownership(req);
+}
+
 /*
  * Returns 0 when it's handed over for polling. The caller owns the requests if
  * it returns non-zero, but otherwise should not touch it. Negative values
@@ -443,7 +474,8 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
  */
 static int __io_arm_poll_handler(struct io_kiocb *req,
 				 struct io_poll *poll,
-				 struct io_poll_table *ipt, __poll_t mask)
+				 struct io_poll_table *ipt, __poll_t mask,
+				 unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int v;
@@ -452,34 +484,45 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
 	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
-
 	req->apoll_events = poll->events;
 
 	ipt->pt._key = mask;
 	ipt->req = req;
 	ipt->error = 0;
 	ipt->nr_entries = 0;
-
 	/*
-	 * Take the ownership to delay any tw execution up until we're done
-	 * with poll arming. see io_poll_get_ownership().
+	 * Polling is either completed here or via task_work, so if we're in the
+	 * task context we're naturally serialised with tw by merit of running
+	 * the same task. When it's io-wq, take the ownership to prevent tw
+	 * from running. However, when we're in the task context, skip taking
+	 * it as an optimisation.
+	 *
+	 * Note: even though the request won't be completed/freed, without
+	 * ownership we still can race with io_poll_wake().
+	 * io_poll_can_finish_inline() tries to deal with that.
 	 */
-	atomic_set(&req->poll_refs, 1);
+	ipt->owning = issue_flags & IO_URING_F_UNLOCKED;
+
+	atomic_set(&req->poll_refs, (int)ipt->owning);
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
 
 	if (unlikely(ipt->error || !ipt->nr_entries)) {
 		io_poll_remove_entries(req);
 
-		if (mask && !(poll->events & EPOLLET)) {
+		if (!io_poll_can_finish_inline(req, ipt)) {
+			io_poll_mark_cancelled(req);
+			return 0;
+		} else if (mask && !(poll->events & EPOLLET)) {
 			ipt->result_mask = mask;
 			return 1;
-		} else {
-			return ipt->error ?: -EINVAL;
 		}
+		return ipt->error ?: -EINVAL;
 	}
 
 	if (mask &&
 	   ((poll->events & (EPOLLET|EPOLLONESHOT)) == (EPOLLET|EPOLLONESHOT))) {
+		if (!io_poll_can_finish_inline(req, ipt))
+			return 0;
 		io_poll_remove_entries(req);
 		ipt->result_mask = mask;
 		/* no one else has access to the req, forget about the ref */
@@ -491,18 +534,21 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	else
 		io_poll_req_insert(req);
 
-	if (mask && (poll->events & EPOLLET)) {
+	if (mask && (poll->events & EPOLLET) &&
+	    io_poll_can_finish_inline(req, ipt)) {
 		__io_poll_execute(req, mask);
 		return 0;
 	}
 
-	/*
-	 * Release ownership. If someone tried to queue a tw while it was
-	 * locked, kick it off for them.
-	 */
-	v = atomic_dec_return(&req->poll_refs);
-	if (unlikely(v & IO_POLL_REF_MASK))
-		__io_poll_execute(req, 0);
+	if (ipt->owning) {
+		/*
+		 * Release ownership. If someone tried to queue a tw while it was
+		 * locked, kick it off for them.
+		 */
+		v = atomic_dec_return(&req->poll_refs);
+		if (unlikely(v & IO_POLL_REF_MASK))
+			__io_poll_execute(req, 0);
+	}
 	return 0;
 }
 
@@ -585,7 +631,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 
 	io_kbuf_recycle(req, issue_flags);
 
-	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask);
+	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask, issue_flags);
 	if (ret)
 		return ret > 0 ? IO_APOLL_READY : IO_APOLL_ABORTED;
 	trace_io_uring_poll_arm(req, mask, apoll->poll.events);
@@ -817,7 +863,7 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		req->flags &= ~REQ_F_HASH_LOCKED;
 
-	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events);
+	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events, issue_flags);
 	if (ret > 0) {
 		io_req_set_res(req, ipt.result_mask, 0);
 		return IOU_OK;
-- 
2.36.1

