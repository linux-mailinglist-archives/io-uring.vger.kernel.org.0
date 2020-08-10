Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16179240B6C
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 18:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgHJQxU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 12:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbgHJQxT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 12:53:19 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2FBCC061756
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 09:53:18 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m71so5393968pfd.1
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 09:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=demJTYvqVm7/B6udfKKYTH8CSRdpCicL24k0feQJYaM=;
        b=CBweG1tmjjNO38Xjm2I54pGGQ80yt7+dLFbqURBEoszlZGZsKCBjh0Phw+Zs7vGM4K
         we0ZMJHQuWD/5/JopeOeqczO4T7aBxm4CiQplJK8oinmBG5yXTYLYz8/Ei4Blwza+RUR
         ahu0InJqD7NR+ZcSxYvILhBYxtmLO02rJ/MC0qTxjw7h5WGWOg5DDBXZNSJTGyGVek8k
         nXUOvbvvI4JQIzEyTSPXEya49UAfxNLIEQqq8Ac3r5xizf0ujKbTT9pIxFGIWqh962lG
         YWbjp695vF2NCt2qkUD3OcsR2eVjGPwdBHUv/y7PKqyvI+KKERJ+7BYtGx4kN0dUpDKM
         5zzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=demJTYvqVm7/B6udfKKYTH8CSRdpCicL24k0feQJYaM=;
        b=onkB3gHqiAP3iMzrNP/45inIw0KX17sT3ZFXqevKRBPxCT/PYag2LhtmFx3Pbfh8Xn
         ZZS9kJ+8bN6hiYUG53EfVi5VKXrufFoF73Ieab5J31k3Ub+os9iO6eeo18+BX9IrVhOK
         04UNBrGnVENQIIDGCmO4SSCBd30V+nY8wbTPm8EhMew0baIsFOWmhNLkT8RlATkPMKbg
         O8wFt2L6ZyF+d8F+Sfp9QALs7M0d5QDmFyJ5zxUeYqe7Inupe+rHvRnownIk/hpoY/kH
         rCyBl/n7zVllV4Js+YhaR3HPIFcdyhrh/JbL3bqzvPuUb/lIT8NZsF0j8j4wt8mrFjYm
         J+Mg==
X-Gm-Message-State: AOAM5312UFiR5a+sCN3qmaCJeaM7CPyyY3F+KBF1dXsHE3bWbsmifnkf
        dDw+rm0B9GqLGWzYgNoaMzSELQ==
X-Google-Smtp-Source: ABdhPJwDpfTqcEJ1ZVvlAC41XmgUyGzPmHUdduAl3NVuhoPhe8VvQdCO3mXG85FYMz4us2RpFoR00g==
X-Received: by 2002:a62:26c2:: with SMTP id m185mr1916989pfm.115.1597078397875;
        Mon, 10 Aug 2020 09:53:17 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id cv3sm85858pjb.45.2020.08.10.09.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 09:53:17 -0700 (PDT)
Subject: Re: possible deadlock in io_timeout_fn
To:     syzbot <syzbot+ef4b654b49ed7ff049bf@syzkaller.appspotmail.com>,
        bijan.mottahedeh@oracle.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
References: <000000000000cb5dff05ac87ba2e@google.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <739db873-d8f2-c7fa-a5fc-19b4c7e107e6@kernel.dk>
Date:   Mon, 10 Aug 2020 10:53:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <000000000000cb5dff05ac87ba2e@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 9:37 AM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    449dc8c9 Merge tag 'for-v5.9' of git://git.kernel.org/pub/..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11293dc6900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9d25235bf0162fbc
> dashboard link: https://syzkaller.appspot.com/bug?extid=ef4b654b49ed7ff049bf
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=126b0f1a900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13e32994900000
> 
> The issue was bisected to:
> 
> commit e62753e4e2926f249d088cc0517be5ed4efec6d6
> Author: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> Date:   Sat May 23 04:31:18 2020 +0000
> 
>     io_uring: call statx directly

I don't think this one is to blame, it's a generic issue with needing
to put the file table from the error/fail path.

Something like the below should fix it - if we have the completion
lock locked, then punt the file table put to a safe context through
task_work instead. Looks bigger than it is, due to moving some of
the generic task_work handling functions up a bit.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index f9be665d1c5e..5df805d6251e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1108,10 +1108,16 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 	}
 }
 
-static void io_req_clean_work(struct io_kiocb *req)
+/*
+ * Returns true if we need to defer file table putting. This can only happen
+ * from the error path with REQ_F_COMP_LOCKED set.
+ */
+static bool io_req_clean_work(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_WORK_INITIALIZED))
-		return;
+		return false;
+
+	req->flags &= ~REQ_F_WORK_INITIALIZED;
 
 	if (req->work.mm) {
 		mmdrop(req->work.mm);
@@ -1124,6 +1130,9 @@ static void io_req_clean_work(struct io_kiocb *req)
 	if (req->work.fs) {
 		struct fs_struct *fs = req->work.fs;
 
+		if (req->flags & REQ_F_COMP_LOCKED)
+			return true;
+
 		spin_lock(&req->work.fs->lock);
 		if (--fs->users)
 			fs = NULL;
@@ -1132,7 +1141,8 @@ static void io_req_clean_work(struct io_kiocb *req)
 			free_fs_struct(fs);
 		req->work.fs = NULL;
 	}
-	req->flags &= ~REQ_F_WORK_INITIALIZED;
+
+	return false;
 }
 
 static void io_prep_async_work(struct io_kiocb *req)
@@ -1544,7 +1554,7 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 		fput(file);
 }
 
-static void io_dismantle_req(struct io_kiocb *req)
+static bool io_dismantle_req(struct io_kiocb *req)
 {
 	io_clean_op(req);
 
@@ -1552,7 +1562,6 @@ static void io_dismantle_req(struct io_kiocb *req)
 		kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
-	io_req_clean_work(req);
 
 	if (req->flags & REQ_F_INFLIGHT) {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -1564,15 +1573,108 @@ static void io_dismantle_req(struct io_kiocb *req)
 			wake_up(&ctx->inflight_wait);
 		spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	}
+
+	return io_req_clean_work(req);
 }
 
-static void __io_free_req(struct io_kiocb *req)
+static void __io_req_task_cancel(struct io_kiocb *req, int error)
 {
-	struct io_ring_ctx *ctx;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	io_cqring_fill_event(req, error);
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	req_set_fail_links(req);
+	io_double_put_req(req);
+}
+
+static void io_req_task_cancel(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+
+	__io_req_task_cancel(req, -ECANCELED);
+}
+
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
+{
+	struct task_struct *tsk = req->task;
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret, notify = TWA_RESUME;
+
+	ret = __task_work_add(tsk, cb);
+	if (unlikely(ret))
+		return ret;
+
+	/*
+	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
+	 * For any other work, use signaled wakeups if the task isn't
+	 * running to avoid dependencies between tasks or threads. If
+	 * the issuing task is currently waiting in the kernel on a thread,
+	 * and same thread is waiting for a completion event, then we need
+	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
+	 * is needed for that.
+	 */
+	if (ctx->flags & IORING_SETUP_SQPOLL)
+		notify = 0;
+	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
+		notify = TWA_SIGNAL;
+
+	__task_work_notify(tsk, notify);
+	wake_up_process(tsk);
+	return 0;
+}
+
+static void __io_req_task_submit(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (!__io_sq_thread_acquire_mm(ctx)) {
+		mutex_lock(&ctx->uring_lock);
+		__io_queue_sqe(req, NULL, NULL);
+		mutex_unlock(&ctx->uring_lock);
+	} else {
+		__io_req_task_cancel(req, -EFAULT);
+	}
+}
+
+static void io_req_task_submit(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+
+	__io_req_task_submit(req);
+}
+
+
+static void __io_req_task_queue(struct io_kiocb *req, task_work_func_t func)
+{
+	int ret;
+
+	init_task_work(&req->task_work, func);
+
+	ret = io_req_task_work_add(req, &req->task_work);
+	if (unlikely(ret)) {
+		struct task_struct *tsk;
+
+		init_task_work(&req->task_work, io_req_task_cancel);
+		tsk = io_wq_get_task(req->ctx->io_wq);
+		task_work_add(tsk, &req->task_work, 0);
+		wake_up_process(tsk);
+	}
+}
+
+static void io_req_task_queue(struct io_kiocb *req)
+{
+	__io_req_task_queue(req, io_req_task_submit);
+}
+
+static void __io_free_req_finish(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
 
-	io_dismantle_req(req);
 	__io_put_req_task(req);
-	ctx = req->ctx;
 	if (likely(!io_is_fallback_req(req)))
 		kmem_cache_free(req_cachep, req);
 	else
@@ -1580,6 +1682,29 @@ static void __io_free_req(struct io_kiocb *req)
 	percpu_ref_put(&ctx->refs);
 }
 
+static void io_req_task_file_table_put(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct fs_struct *fs = req->work.fs;
+
+	spin_lock(&req->work.fs->lock);
+	if (--fs->users)
+		fs = NULL;
+	spin_unlock(&req->work.fs->lock);
+	if (fs)
+		free_fs_struct(fs);
+	req->work.fs = NULL;
+	__io_free_req_finish(req);
+}
+
+static void __io_free_req(struct io_kiocb *req)
+{
+	if (!io_dismantle_req(req))
+		__io_free_req_finish(req);
+	else
+		__io_req_task_queue(req, io_req_task_file_table_put);
+}
+
 static bool io_link_cancel_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1667,6 +1792,7 @@ static void __io_fail_links(struct io_kiocb *req)
 		trace_io_uring_fail_link(req, link);
 
 		io_cqring_fill_event(link, -ECANCELED);
+		link->flags |= REQ_F_COMP_LOCKED;
 		__io_double_put_req(link);
 		req->flags &= ~REQ_F_LINK_TIMEOUT;
 	}
@@ -1717,93 +1843,6 @@ static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return __io_req_find_next(req);
 }
 
-static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
-{
-	struct task_struct *tsk = req->task;
-	struct io_ring_ctx *ctx = req->ctx;
-	int ret, notify = TWA_RESUME;
-
-	ret = __task_work_add(tsk, cb);
-	if (unlikely(ret))
-		return ret;
-
-	/*
-	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
-	 * For any other work, use signaled wakeups if the task isn't
-	 * running to avoid dependencies between tasks or threads. If
-	 * the issuing task is currently waiting in the kernel on a thread,
-	 * and same thread is waiting for a completion event, then we need
-	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
-	 * is needed for that.
-	 */
-	if (ctx->flags & IORING_SETUP_SQPOLL)
-		notify = 0;
-	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
-		notify = TWA_SIGNAL;
-
-	__task_work_notify(tsk, notify);
-	wake_up_process(tsk);
-	return 0;
-}
-
-static void __io_req_task_cancel(struct io_kiocb *req, int error)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	spin_lock_irq(&ctx->completion_lock);
-	io_cqring_fill_event(req, error);
-	io_commit_cqring(ctx);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
-	req_set_fail_links(req);
-	io_double_put_req(req);
-}
-
-static void io_req_task_cancel(struct callback_head *cb)
-{
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-
-	__io_req_task_cancel(req, -ECANCELED);
-}
-
-static void __io_req_task_submit(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (!__io_sq_thread_acquire_mm(ctx)) {
-		mutex_lock(&ctx->uring_lock);
-		__io_queue_sqe(req, NULL, NULL);
-		mutex_unlock(&ctx->uring_lock);
-	} else {
-		__io_req_task_cancel(req, -EFAULT);
-	}
-}
-
-static void io_req_task_submit(struct callback_head *cb)
-{
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-
-	__io_req_task_submit(req);
-}
-
-static void io_req_task_queue(struct io_kiocb *req)
-{
-	int ret;
-
-	init_task_work(&req->task_work, io_req_task_submit);
-
-	ret = io_req_task_work_add(req, &req->task_work);
-	if (unlikely(ret)) {
-		struct task_struct *tsk;
-
-		init_task_work(&req->task_work, io_req_task_cancel);
-		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, 0);
-		wake_up_process(tsk);
-	}
-}
-
 static void io_queue_next(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt = io_req_find_next(req);
@@ -1872,7 +1911,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 		req->flags &= ~REQ_F_TASK_PINNED;
 	}
 
-	io_dismantle_req(req);
+	WARN_ON_ONCE(io_dismantle_req(req));
 	rb->reqs[rb->to_free++] = req;
 	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
 		__io_req_free_batch_flush(req->ctx, rb);

-- 
Jens Axboe

