Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0EE23F4C3
	for <lists+io-uring@lfdr.de>; Sat,  8 Aug 2020 00:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGWL0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Aug 2020 18:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHGWL0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Aug 2020 18:11:26 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8430C061756
        for <io-uring@vger.kernel.org>; Fri,  7 Aug 2020 15:11:25 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ep8so1675078pjb.3
        for <io-uring@vger.kernel.org>; Fri, 07 Aug 2020 15:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=lQ+YzAQuE8CGijcN7DHiAriX2AnEQ2P1a1HHN2PZwj8=;
        b=UYCyIrOS3+hAKpCnnBmfiZ4Bhpdgg0+w62/l3tCe1E7fcYYD5gBPMA3ZZls5AlypUl
         IazJtSytxGqz68GN/+/VEP+2fNGsn1uyVjMyIY7yTlc+VhDF2nJTIc8PGT4go6A5RW6P
         lICVq6hWZoqMVme/gg8b80ApL0ABV5xNBFNkcNna2ra/PATetoqLkxszoinybRDIJIGb
         qeLTnNTuvGb1BGwU4BE1ZlHEQh6NOfHszjPa1nfzxJG0dhsHJ+OFkZxLhEAgD/3XW1xT
         cXppvGeq8B7xxrJBE16DQduwM/fLnZoRsBRtMSzhqIwrwdpHqXFjZqUOwuUOTjjhjPv5
         WGBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=lQ+YzAQuE8CGijcN7DHiAriX2AnEQ2P1a1HHN2PZwj8=;
        b=leFiefSXn2Gqqfk5sdpBNWY4yVxWliQVv1tNJUUILK8ClrL4hASC2S2x3FNtyxaghi
         MxprX/ns00fDSew/5zu8fdLgfFfMrr1/J4qy1OAQoFGJZmUsiRro7w0NKa+bZRiqemtt
         4GALwCpU/naC3g4lk8erZ5oI2sBRHEkU1piSAEqR5iyPg43HCjbYLDHksdeTZYdAJTMq
         ghmDNN3ex+k48a+UlgqguXWjH+9ViGN9GadvU0ov3voqOxYkr8XKy7QMoSt0gJFyikOQ
         zS0n4Z0/uuAYWtTXcDrkij6JAmpySf1K+n3++5prJts8xIm/tE6cj1iearv8/D87dPnW
         sGcg==
X-Gm-Message-State: AOAM5332IE51ywIlu7OP9WgG62v2+KB9MQ9bFx7fSQTraMYDVi2h54Z3
        2L6yyZX5+plleoc/OUa4YsF9UnpONWw=
X-Google-Smtp-Source: ABdhPJx3xUaWi7vGH+tHaDqDADAkvTb0N9kZ2t5cGGcEZ0ZDpMpv2iLDwgbYOgYcaLmWQtezCFhqrQ==
X-Received: by 2002:a17:90a:d98f:: with SMTP id d15mr15611741pjv.212.1596838284876;
        Fri, 07 Aug 2020 15:11:24 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id x26sm13745989pfn.218.2020.08.07.15.11.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 15:11:23 -0700 (PDT)
Subject: Re: [PATCH v2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
From:   Jens Axboe <axboe@kernel.dk>
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <ba5b8ee4-2c6f-dec7-97f2-d02c8b3fe3f8@kernel.dk>
 <CAG48ez3dX8aK2m918fxAZGaOf5h9QV6X+Z5LMzJV2yZO8+bsvg@mail.gmail.com>
 <3b4ad90f-59b3-b279-fcee-419bd370f470@kernel.dk>
Message-ID: <0781658f-5a31-2fed-63b5-79abacea10ae@kernel.dk>
Date:   Fri, 7 Aug 2020 16:11:22 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <3b4ad90f-59b3-b279-fcee-419bd370f470@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------AF6329A08EA2A863C0AA56D4"
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------AF6329A08EA2A863C0AA56D4
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 8/7/20 3:50 PM, Jens Axboe wrote:
> On 8/7/20 12:00 PM, Jann Horn wrote:
>> On Fri, Aug 7, 2020 at 6:56 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> An earlier commit:
>>>
>>> b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")
>>>
>>> ensured that we didn't get stuck waiting for eventfd reads when it's
>>> registered with the io_uring ring for event notification, but we still
>>> have a gap where the task can be waiting on other events in the kernel
>>> and need a bigger nudge to make forward progress.
>>>
>>> Ensure that we use signaled notifications for a task that isn't currently
>>> running, to be certain the work is seen and processed immediately.
>>>
>>> Cc: stable@vger.kernel.org # v5.7+
>>> Reported-by: Josef <josef.grieb@gmail.com>
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>>
>>> ---
>>>
>>> This isn't perfect, as it'll use TWA_SIGNAL even for cases where we
>>> don't absolutely need it (like task waiting for completions in
>>> io_cqring_wait()), but we don't have a good way to tell right now. We
>>> can probably improve on this in the future, for now I think this is the
>>> best solution.
>>>
>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>>> index e9b27cdaa735..b4300a61f231 100644
>>> --- a/fs/io_uring.c
>>> +++ b/fs/io_uring.c
>>> @@ -1720,7 +1720,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>>>          */
>>>         if (ctx->flags & IORING_SETUP_SQPOLL)
>>>                 notify = 0;
>>> -       else if (ctx->cq_ev_fd)
>>> +       else if (ctx->cq_ev_fd || (tsk->state != TASK_RUNNING))
>>>                 notify = TWA_SIGNAL;
>>>
>>>         ret = task_work_add(tsk, cb, notify);
>>
>> I don't get it. Apart from still not understanding the big picture:
>>
>> What guarantees that the lockless read of tsk->state is in any way
>> related to the state of the remote process by the time we reach
>> task_work_add()? And why do we not need to signal in TASK_RUNNING
>> state (e.g. directly before the remote process switches to
>> TASK_INTERRUPTIBLE or something like that)?
> 
> Yeah it doesn't, the patch doesn't cover the racy case. As far as I can
> tell, we've got two ways to do it:
> 
> 1) We split the task_work_add() into two parts, one adding the work and
>    one doing the signaling. Then we could do:
> 
> int notify = TWA_RESUME;
> 
> __task_work_add(tsk, cb);
> 
> if (ctx->flags & IORING_SETUP_SQPOLL)
> 	notify = 0;
> else if (ctx->cq_ev_fd || (tsk->state != TASK_RUNNING))
> 	notify = TWA_SIGNAL;
> 
> __task_work_signal(tsk, notify);

Something like the attached - totally untested so far, but it implements
that idea.

-- 
Jens Axboe


--------------AF6329A08EA2A863C0AA56D4
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-use-TWA_SIGNAL-for-task_work-if-the-task-is.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-io_uring-use-TWA_SIGNAL-for-task_work-if-the-task-is.pa";
 filename*1="tch"

From ec67af3b1e0c9325a04d5d1c12311086349d3a79 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 6 Aug 2020 19:41:50 -0600
Subject: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task isn't
 running

An earlier commit:

b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")

ensured that we didn't get stuck waiting for eventfd reads when it's
registered with the io_uring ring for event notification, but we still
have a gap where the task can be waiting on other events in the kernel
and need a bigger nudge to make forward progress.

Ensure that we use signaled notifications for a task that isn't currently
running, to be certain the work is seen and processed immediately.

Cc: stable@vger.kernel.org # v5.7+
Reported-by: Josef <josef.grieb@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9b27cdaa735..443eecdfeda9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1712,21 +1712,27 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret, notify = TWA_RESUME;
 
+	ret = __task_work_add(tsk, cb);
+	if (unlikely(ret))
+		return ret;
+
 	/*
 	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
-	 * If we're not using an eventfd, then TWA_RESUME is always fine,
-	 * as we won't have dependencies between request completions for
-	 * other kernel wait conditions.
+	 * For any other work, use signaled wakeups if the task isn't
+	 * running to avoid dependencies between tasks or threads. If
+	 * the issuing task is currently waiting in the kernel on a thread,
+	 * and same thread is waiting for a completion event, then we need
+	 * to ensure that the issuing task processes task_work. TWA_SIGNAL
+	 * is needed for that.
 	 */
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		notify = 0;
-	else if (ctx->cq_ev_fd)
+	else if (READ_ONCE(tsk->state) != TASK_RUNNING)
 		notify = TWA_SIGNAL;
 
-	ret = task_work_add(tsk, cb, notify);
-	if (!ret)
-		wake_up_process(tsk);
-	return ret;
+	__task_work_notify(tsk, notify);
+	wake_up_process(tsk);
+	return 0;
 }
 
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
-- 
2.28.0


--------------AF6329A08EA2A863C0AA56D4
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-kernel-split-task_work_add-into-two-separate-helpers.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-kernel-split-task_work_add-into-two-separate-helpers.pa";
 filename*1="tch"

From 802b09d10bdd2f90e510049b1c52b81edc2ae0a3 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Fri, 7 Aug 2020 16:00:53 -0600
Subject: [PATCH 1/2] kernel: split task_work_add() into two separate helpers

Some callers may need to make signaling decisions based on the state
of the targeted task, and that can only safely be done post adding
the task_work to the task. Split task_work_add() into:

__task_work_add()	- adds the work item
__task_work_notify()	- sends the notification

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/task_work.h | 19 ++++++++++++++++
 kernel/task_work.c        | 48 +++++++++++++++++++++------------------
 2 files changed, 45 insertions(+), 22 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 0fb93aafa478..7abbd8df5e13 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -5,6 +5,8 @@
 #include <linux/list.h>
 #include <linux/sched.h>
 
+extern struct callback_head work_exited;
+
 typedef void (*task_work_func_t)(struct callback_head *);
 
 static inline void
@@ -13,6 +15,21 @@ init_task_work(struct callback_head *twork, task_work_func_t func)
 	twork->func = func;
 }
 
+static inline int __task_work_add(struct task_struct *task,
+				  struct callback_head *work)
+{
+	struct callback_head *head;
+
+	do {
+		head = READ_ONCE(task->task_works);
+		if (unlikely(head == &work_exited))
+			return -ESRCH;
+		work->next = head;
+	} while (cmpxchg(&task->task_works, head, work) != head);
+
+	return 0;
+}
+
 #define TWA_RESUME	1
 #define TWA_SIGNAL	2
 int task_work_add(struct task_struct *task, struct callback_head *twork, int);
@@ -20,6 +37,8 @@ int task_work_add(struct task_struct *task, struct callback_head *twork, int);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
 
+void __task_work_notify(struct task_struct *task, int notify);
+
 static inline void exit_task_work(struct task_struct *task)
 {
 	task_work_run();
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 5c0848ca1287..9bde81481984 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -3,7 +3,27 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
-static struct callback_head work_exited; /* all we need is ->next == NULL */
+struct callback_head work_exited = {
+	.next = NULL	/* all we need is ->next == NULL */
+};
+
+void __task_work_notify(struct task_struct *task, int notify)
+{
+	unsigned long flags;
+
+	switch (notify) {
+	case TWA_RESUME:
+		set_notify_resume(task);
+		break;
+	case TWA_SIGNAL:
+		if (lock_task_sighand(task, &flags)) {
+			task->jobctl |= JOBCTL_TASK_WORK;
+			signal_wake_up(task, 0);
+			unlock_task_sighand(task, &flags);
+		}
+		break;
+	}
+}
 
 /**
  * task_work_add - ask the @task to execute @work->func()
@@ -27,29 +47,13 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
 int
 task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 {
-	struct callback_head *head;
-	unsigned long flags;
+	int ret;
 
-	do {
-		head = READ_ONCE(task->task_works);
-		if (unlikely(head == &work_exited))
-			return -ESRCH;
-		work->next = head;
-	} while (cmpxchg(&task->task_works, head, work) != head);
-
-	switch (notify) {
-	case TWA_RESUME:
-		set_notify_resume(task);
-		break;
-	case TWA_SIGNAL:
-		if (lock_task_sighand(task, &flags)) {
-			task->jobctl |= JOBCTL_TASK_WORK;
-			signal_wake_up(task, 0);
-			unlock_task_sighand(task, &flags);
-		}
-		break;
-	}
+	ret = __task_work_add(task, work);
+	if (unlikely(ret))
+		return ret;
 
+	__task_work_notify(task, notify);
 	return 0;
 }
 
-- 
2.28.0


--------------AF6329A08EA2A863C0AA56D4--
