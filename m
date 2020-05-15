Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4751D585F
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2020 19:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgEORyt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 May 2020 13:54:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726183AbgEORys (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 May 2020 13:54:48 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB6CC061A0C
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 10:54:47 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id n18so1334813pfa.2
        for <io-uring@vger.kernel.org>; Fri, 15 May 2020 10:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=2346GfdTqGrSjw9H2hBDvH0SVS0BRBKAyFgevQZH1Kc=;
        b=OySj+mqT1xUb8k735TTNB+gHH+/GEUpNAHRdgV9vTCyAc/aZ/UWFjz4lHccu2V7A0S
         SkyUhHsqBpfZGXOAhpGydR0E17wzNJ6Jfn0ClQes/VKZQ1mBDOoyE97BS+mFomDYn/EV
         Z3DQEaBLjULpWz0TjsaaHTRFUdIILUohnAWD7R3q2AQBKvgopVaOjUsFAy3R9M63rSVN
         n7FthxuuNtBFbME53cUN7l9QhbQibIqL2TGVeeAaS5MCvaNsMmjOAeWdRbPAzixnMD94
         akwlNJlegiucGHHieQjOuj85Fwv3W5jxHNcgTJziX3+bg2MAridMqBl6OPZ4GAPoSnKa
         Su5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=2346GfdTqGrSjw9H2hBDvH0SVS0BRBKAyFgevQZH1Kc=;
        b=hp53EzF1nGtGiu5Gq78Xe+g3JTGKk90KVACGds+4llDn8zsk6mqQYgtVEkqzC9zQV/
         pvz0aR3cU/fIwZdLJ4wlKIakztunHjH1CmicdZwqkA/Y3qXw1dDXwMCmblMQwptz/4XR
         zTU+nhVW4uOG2vt2H227NeKOfOS/UBv1Av5VzmGkGaweY2FQ7ufsffPLvR/+Ysu8u1Qk
         5lIfr4Rgert0GzjW+4/pkZTrC6Ehq9OQmmeIANbXUp2f7xhTaoJJbHqp3J53C5qZMhXl
         Dvw7/NtwFAJnog/JtPjn7FcB82myS7CtzjlzYy23JIotPOu0m6q71Jj4i/CEK2DAyx9I
         w9OQ==
X-Gm-Message-State: AOAM532jU3BEfk1lN41L3w52UQ7sKeyV6wWM6/ErMW1y3OF1aMFEaLKS
        QtcWZAV+e1ReEhnjvqLOfEZWSeAhfs8=
X-Google-Smtp-Source: ABdhPJyyHKxzAQC1RhClno9z4AZ0Xi65i16e/UeGeG6KaySqNheKM6qiTZ9DuP3YATB2jF0AsySdAg==
X-Received: by 2002:a65:40c3:: with SMTP id u3mr4361514pgp.305.1589565286536;
        Fri, 15 May 2020 10:54:46 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:adf1:7e34:eff4:95bb? ([2605:e000:100e:8c61:adf1:7e34:eff4:95bb])
        by smtp.gmail.com with ESMTPSA id a136sm2453908pfa.99.2020.05.15.10.54.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 10:54:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3] io_uring: allow POLL_ADD with double poll_wait() users
To:     io-uring <io-uring@vger.kernel.org>
Message-ID: <8a9c0ab3-db02-d355-1633-8ef749789ba2@kernel.dk>
Date:   Fri, 15 May 2020 11:54:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some file descriptors use separate waitqueues for their f_ops->poll()
handler, most commonly one for read and one for write. The io_uring
poll implementation doesn't work with that, as the 2nd poll_wait()
call will cause the io_uring poll request to -EINVAL.

This affects (at least) tty devices and /dev/random as well. This is a
big problem for event loops where some file descriptors work, and others
don't. 

With this fix, io_uring handles multiple waitqueues.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

Changes since v2:

- Add double poll removal for the arm failure case
- poll->head init cleanup

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5fa17bb7fe20..770baa4704ac 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4099,27 +4099,6 @@ struct io_poll_table {
 	int error;
 };
 
-static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
-			    struct wait_queue_head *head)
-{
-	if (unlikely(poll->head)) {
-		pt->error = -EINVAL;
-		return;
-	}
-
-	pt->error = 0;
-	poll->head = head;
-	add_wait_queue(head, &poll->wait);
-}
-
-static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
-			       struct poll_table_struct *p)
-{
-	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
-
-	__io_queue_proc(&pt->req->apoll->poll, pt, head);
-}
-
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
@@ -4171,6 +4150,144 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 	return false;
 }
 
+static void io_poll_remove_double(struct io_kiocb *req)
+{
+	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+
+	lockdep_assert_held(&req->ctx->completion_lock);
+
+	if (poll && poll->head) {
+		struct wait_queue_head *head = poll->head;
+
+		spin_lock(&head->lock);
+		list_del_init(&poll->wait.entry);
+		if (poll->wait.private)
+			refcount_dec(&req->refs);
+		poll->head = NULL;
+		spin_unlock(&head->lock);
+	}
+}
+
+static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_poll_remove_double(req);
+	req->poll.done = true;
+	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
+	io_commit_cqring(ctx);
+}
+
+static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (io_poll_rewait(req, &req->poll)) {
+		spin_unlock_irq(&ctx->completion_lock);
+		return;
+	}
+
+	hash_del(&req->hash_node);
+	io_poll_complete(req, req->result, 0);
+	req->flags |= REQ_F_COMP_LOCKED;
+	io_put_req_find_next(req, nxt);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+}
+
+static void io_poll_task_func(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_kiocb *nxt = NULL;
+
+	io_poll_task_handler(req, &nxt);
+	if (nxt) {
+		struct io_ring_ctx *ctx = nxt->ctx;
+
+		mutex_lock(&ctx->uring_lock);
+		__io_queue_sqe(nxt, NULL);
+		mutex_unlock(&ctx->uring_lock);
+	}
+}
+
+static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
+			       int sync, void *key)
+{
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+	__poll_t mask = key_to_poll(key);
+
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	if (req->poll.head) {
+		bool done;
+
+		spin_lock(&req->poll.head->lock);
+		done = list_empty(&req->poll.wait.entry);
+		if (!done)
+			list_del_init(&req->poll.wait.entry);
+		spin_unlock(&req->poll.head->lock);
+		if (!done)
+			__io_async_wake(req, poll, mask, io_poll_task_func);
+	}
+	refcount_dec(&req->refs);
+	return 1;
+}
+
+static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
+			      wait_queue_func_t wake_func)
+{
+	poll->head = NULL;
+	poll->done = false;
+	poll->canceled = false;
+	poll->events = events;
+	INIT_LIST_HEAD(&poll->wait.entry);
+	init_waitqueue_func_entry(&poll->wait, wake_func);
+}
+
+static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
+			    struct wait_queue_head *head)
+{
+	struct io_kiocb *req = pt->req;
+
+	/*
+	 * If poll->head is already set, it's because the file being polled
+	 * uses multiple waitqueues for poll handling (eg one for read, one
+	 * for write). Setup a separate io_poll_iocb if this happens.
+	 */
+	if (unlikely(poll->head)) {
+		/* already have a 2nd entry, fail a third attempt */
+		if (req->io) {
+			pt->error = -EINVAL;
+			return;
+		}
+		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
+		if (!poll) {
+			pt->error = -ENOMEM;
+			return;
+		}
+		io_init_poll_iocb(poll, req->poll.events, io_poll_double_wake);
+		refcount_inc(&req->refs);
+		poll->wait.private = req;
+		req->io = (void *) poll;
+	}
+
+	pt->error = 0;
+	poll->head = head;
+	add_wait_queue(head, &poll->wait);
+}
+
+static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
+			       struct poll_table_struct *p)
+{
+	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+
+	__io_queue_proc(&pt->req->apoll->poll, pt, head);
+}
+
 static void io_async_task_func(struct callback_head *cb)
 {
 	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
@@ -4246,18 +4363,13 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 	bool cancel = false;
 
 	poll->file = req->file;
-	poll->head = NULL;
-	poll->done = poll->canceled = false;
-	poll->events = mask;
+	io_init_poll_iocb(poll, mask, wake_func);
+	poll->wait.private = req;
 
 	ipt->pt._key = mask;
 	ipt->req = req;
 	ipt->error = -EINVAL;
 
-	INIT_LIST_HEAD(&poll->wait.entry);
-	init_waitqueue_func_entry(&poll->wait, wake_func);
-	poll->wait.private = req;
-
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
 
 	spin_lock_irq(&ctx->completion_lock);
@@ -4288,6 +4400,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
+	bool had_io;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
@@ -4302,6 +4415,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 
 	req->flags |= REQ_F_POLLED;
 	memcpy(&apoll->work, &req->work, sizeof(req->work));
+	had_io = req->io != NULL;
 
 	get_task_struct(current);
 	req->task = current;
@@ -4322,6 +4436,9 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	if (ret) {
 		ipt.error = 0;
 		apoll->poll.done = true;
+		/* only remove double add if we did it here */
+		if (!had_io)
+			io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
 		memcpy(&req->work, &apoll->work, sizeof(req->work));
 		kfree(apoll);
@@ -4354,6 +4471,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	bool do_complete;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
+		io_poll_remove_double(req);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
 		apoll = req->apoll;
@@ -4455,49 +4573,6 @@ static int io_poll_remove(struct io_kiocb *req)
 	return 0;
 }
 
-static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	req->poll.done = true;
-	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
-	io_commit_cqring(ctx);
-}
-
-static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_poll_iocb *poll = &req->poll;
-
-	if (io_poll_rewait(req, poll)) {
-		spin_unlock_irq(&ctx->completion_lock);
-		return;
-	}
-
-	hash_del(&req->hash_node);
-	io_poll_complete(req, req->result, 0);
-	req->flags |= REQ_F_COMP_LOCKED;
-	io_put_req_find_next(req, nxt);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
-}
-
-static void io_poll_task_func(struct callback_head *cb)
-{
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-	struct io_kiocb *nxt = NULL;
-
-	io_poll_task_handler(req, &nxt);
-	if (nxt) {
-		struct io_ring_ctx *ctx = nxt->ctx;
-
-		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(nxt, NULL);
-		mutex_unlock(&ctx->uring_lock);
-	}
-}
-
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {

-- 
Jens Axboe

