Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613712246D9
	for <lists+io-uring@lfdr.de>; Sat, 18 Jul 2020 01:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGQXOm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jul 2020 19:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgGQXOm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jul 2020 19:14:42 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F9FC0619D2
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 16:14:42 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ch3so7179500pjb.5
        for <io-uring@vger.kernel.org>; Fri, 17 Jul 2020 16:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=N6fMmgHW94pKdH5qMFw2TGqvSACwXE9mSANM+yENaZ8=;
        b=qdoHSDN/8R2OQt1tgaS+VnIP3RdNcJYC6AmRFyNObEtS8hH5wbMcAoctn9YumgUi/G
         gbTCrZw6i4rI6AajzxYFQWANfPzYcrINl72qrnaKhY+tX3W5I2coUCcv+KkOGDeOR8D9
         X1RJhjJ1ih6WK9VVm8A6vNoQSnD6Q5+i698HDUkMlcB/GrAHA9HPXzGOcYZEtiCP/xis
         r1wETufLiHZs0+/GANH2EFw3kTSlvng5phzUGsQtMHFoOaft+WdS8QZJ8HU25CPNfPI+
         eHk2m2ya1UjeyoBdWSrmfidjYOSOWM7cj3bWiJ5qZK1t2TpPzTHyRBz9epT8KzWFeQMs
         jDwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=N6fMmgHW94pKdH5qMFw2TGqvSACwXE9mSANM+yENaZ8=;
        b=cibQwehA60C/q+R69Z+3j4SuwOKWCP9PbaEuliC5d6kP8Re80fq7rOSeoBTpAh0aOP
         YwYe3vevuQvU52GEvG2MztiyckwEg5j4AWeVDQmbTbmsax30IviJZi6oAfiXFba3T5Yb
         dRxUUE6ieL2f79KvRYR+1mCnJBSfyf1r7pf7QudUvJCalCqBh0zQTMm7dC+GqoJI5P+q
         9DQBX8SkPmJuD279w5x1m2RFXhZe7zG3oxgmCwCp8hwpuBw7Pe6KLs4WvPfOYg2cY4Ta
         rwpKTaGxY/3J8fcmn3T4EfiWw46MSpRrBq+iAW8wz6HuTC32qQ6Pt5vA5cZNPEr4QeHc
         zctg==
X-Gm-Message-State: AOAM531Y+Pury0V1+HsO+Czaxv2xmbx8kZnjysGm3l1G8nQ6dF8NEoWT
        GXuMcyhsOJoDzncNhtyTjcBUWbgxL1MSJw==
X-Google-Smtp-Source: ABdhPJxLtpxGB6LsAvY2ANVo9SGzBpe909ASv0CX6Imdt9uw84E4Nm0hk3OpFQL319VwYsIxHxunZg==
X-Received: by 2002:a17:902:8348:: with SMTP id z8mr9303222pln.113.1595027681550;
        Fri, 17 Jul 2020 16:14:41 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s6sm8661398pfd.20.2020.07.17.16.14.40
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 16:14:41 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: ensure double poll additions work with both request
 types
Message-ID: <6b58c113-89bb-813a-7f23-931bab4d7d33@kernel.dk>
Date:   Fri, 17 Jul 2020 17:14:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The double poll additions were centered around doing POLL_ADD on file
descriptors that use more than one waitqueue (typically one for read,
one for write) when being polled. However, it can also end up being
triggered for when we use poll triggered retry. For that case, we cannot
safely use req->io, as that could be used by the request type itself.

Add a second io_poll_iocb pointer in the structure we allocate for poll
based retry, and ensure we use the right one from the two paths.

Fixes: 18bceab101ad ("io_uring: allow POLL_ADD with double poll_wait() users")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 74bc4a04befa..6e8f4266b85d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -605,6 +605,7 @@ enum {
 
 struct async_poll {
 	struct io_poll_iocb	poll;
+	struct io_poll_iocb	*double_poll;
 	struct io_wq_work	work;
 };
 
@@ -4159,9 +4160,9 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 	return false;
 }
 
-static void io_poll_remove_double(struct io_kiocb *req)
+static void io_poll_remove_double(struct io_kiocb *req, void *data)
 {
-	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+	struct io_poll_iocb *poll = data;
 
 	lockdep_assert_held(&req->ctx->completion_lock);
 
@@ -4181,7 +4182,7 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_poll_remove_double(req);
+	io_poll_remove_double(req, req->io);
 	req->poll.done = true;
 	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
 	io_commit_cqring(ctx);
@@ -4224,21 +4225,21 @@ static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
 			       int sync, void *key)
 {
 	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = (struct io_poll_iocb *) req->io;
+	struct io_poll_iocb *poll = req->apoll->double_poll;
 	__poll_t mask = key_to_poll(key);
 
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
 		return 0;
 
-	if (req->poll.head) {
+	if (poll && poll->head) {
 		bool done;
 
-		spin_lock(&req->poll.head->lock);
-		done = list_empty(&req->poll.wait.entry);
+		spin_lock(&poll->head->lock);
+		done = list_empty(&poll->wait.entry);
 		if (!done)
-			list_del_init(&req->poll.wait.entry);
-		spin_unlock(&req->poll.head->lock);
+			list_del_init(&poll->wait.entry);
+		spin_unlock(&poll->head->lock);
 		if (!done)
 			__io_async_wake(req, poll, mask, io_poll_task_func);
 	}
@@ -4258,7 +4259,7 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 }
 
 static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
-			    struct wait_queue_head *head)
+			    struct wait_queue_head *head, bool use_io)
 {
 	struct io_kiocb *req = pt->req;
 
@@ -4269,7 +4270,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	 */
 	if (unlikely(poll->head)) {
 		/* already have a 2nd entry, fail a third attempt */
-		if (req->io) {
+		if (use_io && req->io) {
 			pt->error = -EINVAL;
 			return;
 		}
@@ -4281,7 +4282,10 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 		io_init_poll_iocb(poll, req->poll.events, io_poll_double_wake);
 		refcount_inc(&req->refs);
 		poll->wait.private = req;
-		req->io = (void *) poll;
+		if (use_io)
+			req->io = (void *) poll;
+		else
+			req->apoll->double_poll = poll;
 	}
 
 	pt->error = 0;
@@ -4294,7 +4298,7 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
 
-	__io_queue_proc(&pt->req->apoll->poll, pt, head);
+	__io_queue_proc(&pt->req->apoll->poll, pt, head, false);
 }
 
 static void io_sq_thread_drop_mm(struct io_ring_ctx *ctx)
@@ -4344,11 +4348,13 @@ static void io_async_task_func(struct callback_head *cb)
 		}
 	}
 
+	io_poll_remove_double(req, apoll->double_poll);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	/* restore ->work in case we need to retry again */
 	if (req->flags & REQ_F_WORK_INITIALIZED)
 		memcpy(&req->work, &apoll->work, sizeof(req->work));
+	kfree(apoll->double_poll);
 	kfree(apoll);
 
 	if (!canceled) {
@@ -4436,7 +4442,6 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
 	__poll_t mask, ret;
-	bool had_io;
 
 	if (!req->file || !file_can_poll(req->file))
 		return false;
@@ -4448,11 +4453,11 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
 		return false;
+	apoll->double_poll = NULL;
 
 	req->flags |= REQ_F_POLLED;
 	if (req->flags & REQ_F_WORK_INITIALIZED)
 		memcpy(&apoll->work, &req->work, sizeof(req->work));
-	had_io = req->io != NULL;
 
 	io_get_req_task(req);
 	req->apoll = apoll;
@@ -4470,13 +4475,11 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret) {
-		ipt.error = 0;
-		/* only remove double add if we did it here */
-		if (!had_io)
-			io_poll_remove_double(req);
+		io_poll_remove_double(req, apoll->double_poll);
 		spin_unlock_irq(&ctx->completion_lock);
 		if (req->flags & REQ_F_WORK_INITIALIZED)
 			memcpy(&req->work, &apoll->work, sizeof(req->work));
+		kfree(apoll->double_poll);
 		kfree(apoll);
 		return false;
 	}
@@ -4507,11 +4510,13 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	bool do_complete;
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
-		io_poll_remove_double(req);
+		io_poll_remove_double(req, req->io);
 		do_complete = __io_poll_remove_one(req, &req->poll);
 	} else {
 		struct async_poll *apoll = req->apoll;
 
+		io_poll_remove_double(req, apoll->double_poll);
+
 		/* non-poll requests have submit ref still */
 		do_complete = __io_poll_remove_one(req, &apoll->poll);
 		if (do_complete) {
@@ -4524,6 +4529,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 			if (req->flags & REQ_F_WORK_INITIALIZED)
 				memcpy(&req->work, &apoll->work,
 				       sizeof(req->work));
+			kfree(apoll->double_poll);
 			kfree(apoll);
 		}
 	}
@@ -4624,7 +4630,7 @@ static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
 
-	__io_queue_proc(&pt->req->poll, pt, head);
+	__io_queue_proc(&pt->req->poll, pt, head, true);
 }
 
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)

-- 
Jens Axboe

