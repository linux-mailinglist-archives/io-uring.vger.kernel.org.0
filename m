Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97A9E15D150
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 06:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgBNFD5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 00:03:57 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32908 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgBNFD5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 00:03:57 -0500
Received: by mail-pf1-f196.google.com with SMTP id n7so4281055pfn.0
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2020 21:03:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2c5GMAvBULNw1419ZR1W16CTcb5uUL6T70SAnmt9fKw=;
        b=fy3LwmqsBIpGdlGP5TGcJfJlyehZ8MFd/TW4Cj/9OuvcynNZqMqsxI8EFqQUrP330B
         uNVf0VblhdKsloncyE2OBlRMBX+nOW6mBcBTPqOoCcEn96tMSC7d/DUbzsAVvTAOn1T8
         yWyrn+mNhMehK31XwB2YOYhCDDyL3AUoWBhwCTAJ7GB796YLwR6u1FFFJYDJi5gkpdZy
         P+kr/Zez9CqAowum0JaUQLTmSWkxIJahWxz1gGetCb+3mKYVUsVnXxKaj2g4p4l5sxjp
         f6ePjao8rAWQdTYJwMzmY6GO7EYfIonRRlGQARULlz6ClPpPIMmluttSbrO7HrBc9MRo
         PAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2c5GMAvBULNw1419ZR1W16CTcb5uUL6T70SAnmt9fKw=;
        b=ghc1ZmRu1vKJlMvQ7RN8ZbJ8Spc7dJT06ShqpJlWBq/25dCuSP3a+9AEVTgddrb0EP
         +crVrNnbbeLnPHqdYOetY13iJ4JEaxftTuZNC0Bl92rr1By+LsapPvJYHGa29bcD5A2e
         9JxhZ41NURIQ/wOX8PhyPEHuL4vfTwOMjjb0siW5TFAiD1TiIkPRr3thObPfllytfBNh
         PNrfNDDyEGbDzT5Ivd5gfsxDkf0316zpMIy3ugu9m1c9aV7Z07mzAVrtBJdZ2bTB5WCe
         Oixepfsvn2teUhoWz3QhAbpwmR+pcLb6Sfx0OE3tWsD4q6XPYskGWC+4es+TyzxV6RV6
         mN9Q==
X-Gm-Message-State: APjAAAUgVp5BVGzlS1zlMVwqII+XF2NpJKEehCY3nWVV7MhD7H5IQ2IL
        OKHnHtTEwE4FX4l2rSUfK9ezUQ==
X-Google-Smtp-Source: APXvYqy/3frSnbyQblYxDrDuo87sVVRAP4qiwzqjwlh+1OQVu0rI59WgAoA6Ax38rBxd6CDEGmxJdA==
X-Received: by 2002:aa7:82ce:: with SMTP id f14mr1555320pfn.167.1581656636106;
        Thu, 13 Feb 2020 21:03:56 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id x26sm5340181pfq.55.2020.02.13.21.03.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2020 21:03:55 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
From:   Jens Axboe <axboe@kernel.dk>
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
Message-ID: <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
Date:   Thu, 13 Feb 2020 22:03:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/13/20 7:45 PM, Jens Axboe wrote:
> On 2/13/20 6:25 PM, Carter Li 李通洲 wrote:
>> Another suggestion: we should always try completing operations inline
>> unless IOSQE_ASYNC is specified, no matter if the operations are preceded
>> by a poll.
> 
> Yes that's a given, the problem is that the poll completion is run
> inside the waitqueue handler, and with that locked and interrupts
> disabled. So it's not quite that easy, unfortunately.

Super hack alert... While we can't do it from within the wakeup handler,
we can ensure that the task runs the work when it is scheduled. This
patch attempts to do that - when we run the poll wakeup handler inline
and we have a linked request, instead of just sending that async, we
queue it up in our task uring work log. When the task is scheduled in,
the backlog is run. This achieves the desired result of having the next
work item done inline, instead of having a worker thread do it.

CC'ing peterz for some cluebat knowledge. Peter, is there a nice way to
currently do something like this? Only thing I'm currently aware of is
the preempt in/out notifiers, but they don't quite provide what I need,
since I need to pass some data (a request) as well.

The full detail on what I'm trying here is:

io_uring can have linked requests. One obvious use case for that is to
queue a POLLIN on a socket, and then link a read/recv to that. When the
poll completes, we want to run the read/recv. io_uring hooks into the
waitqueue wakeup handler to finish the poll request, and since we're
deep in waitqueue wakeup code, it queues the linked read/recv for
execution via an async thread. This is not optimal, obviously, as it
relies on a switch to a new thread to perform this read. This hack
queues a backlog to the task itself, and runs it when it's scheduled in.
Probably want to do the same for sched out as well, currently I just
hack that in the io_uring wait part...

This nets me about a 20% boost running the echo example that Carter
supplied.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 56799be66b49..e100406f4842 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -574,6 +574,7 @@ struct io_kiocb {
 
 	struct list_head	inflight_entry;
 
+	struct task_struct	*task;
 	struct io_wq_work	work;
 };
 
@@ -931,6 +932,8 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 	}
 	if (!req->work.task_pid)
 		req->work.task_pid = task_pid_vnr(current);
+	if (!req->task)
+		req->task = get_task_struct(current);
 }
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
@@ -953,6 +956,8 @@ static inline void io_req_work_drop_env(struct io_kiocb *req)
 		if (fs)
 			free_fs_struct(fs);
 	}
+	if (req->task)
+		put_task_struct(req->task);
 }
 
 static inline bool io_prep_async_work(struct io_kiocb *req,
@@ -1239,6 +1244,7 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	refcount_set(&req->refs, 2);
 	req->result = 0;
 	INIT_IO_WORK(&req->work, io_wq_submit_work);
+	req->task = NULL;
 	return req;
 fallback:
 	req = io_get_fallback_req(ctx);
@@ -3670,8 +3676,24 @@ static void __io_poll_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			trigger_ev = false;
 			req->work.func = io_poll_trigger_evfd;
 		} else {
+			struct io_kiocb *nxt = NULL;
+
 			req->flags |= REQ_F_COMP_LOCKED;
+#if 1
+			io_put_req_find_next(req, &nxt);
+			if (nxt) {
+				struct task_struct *tsk = nxt->task;
+
+				raw_spin_lock(&tsk->uring_lock);
+				list_add_tail(&nxt->list, &tsk->uring_work);
+				raw_spin_unlock(&tsk->uring_lock);
+
+				/* do we need this? */
+				wake_up_process(tsk);
+			}
+#else
 			io_put_req(req);
+#endif
 			req = NULL;
 		}
 		spin_unlock_irqrestore(&ctx->completion_lock, flags);
@@ -5316,6 +5338,40 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	return autoremove_wake_function(curr, mode, wake_flags, key);
 }
 
+static void __io_uring_task_handler(struct list_head *list)
+{
+	struct io_kiocb *req;
+
+	while (!list_empty(list)) {
+		req = list_first_entry(list, struct io_kiocb, list);
+		list_del(&req->list);
+
+		__io_queue_sqe(req, NULL);
+	}
+}
+
+void io_uring_task_handler(struct task_struct *tsk)
+{
+	LIST_HEAD(list);
+
+	raw_spin_lock_irq(&tsk->uring_lock);
+	if (!list_empty(&tsk->uring_work))
+		list_splice_init(&tsk->uring_work, &list);
+	raw_spin_unlock_irq(&tsk->uring_lock);
+
+	__io_uring_task_handler(&list);
+}
+
+static bool io_uring_handle_tasklog(void)
+{
+	if (list_empty(&current->uring_work))
+		return false;
+
+	__set_current_state(TASK_RUNNING);
+	io_uring_task_handler(current);
+	return true;
+}
+
 /*
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
@@ -5358,6 +5414,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 						TASK_INTERRUPTIBLE);
 		if (io_should_wake(&iowq, false))
 			break;
+		/* should be a sched-out handler */
+		if (io_uring_handle_tasklog()) {
+			if (io_should_wake(&iowq, false))
+				break;
+			continue;
+		}
 		schedule();
 		if (signal_pending(current)) {
 			ret = -EINTR;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 04278493bf15..447b06c6bed0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -685,6 +685,11 @@ struct task_struct {
 #endif
 	struct sched_dl_entity		dl;
 
+#ifdef CONFIG_IO_URING
+	struct list_head		uring_work;
+	raw_spinlock_t			uring_lock;
+#endif
+
 #ifdef CONFIG_UCLAMP_TASK
 	/* Clamp values requested for a scheduling entity */
 	struct uclamp_se		uclamp_req[UCLAMP_CNT];
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index fc1dfc007604..b60f081cac17 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2717,6 +2717,11 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
 
+#ifdef CONFIG_IO_URING
+	INIT_LIST_HEAD(&p->uring_work);
+	raw_spin_lock_init(&p->uring_lock);
+#endif
+
 #ifdef CONFIG_COMPACTION
 	p->capture_control = NULL;
 #endif
@@ -3069,6 +3074,20 @@ fire_sched_out_preempt_notifiers(struct task_struct *curr,
 
 #endif /* CONFIG_PREEMPT_NOTIFIERS */
 
+#ifdef CONFIG_IO_URING
+extern void io_uring_task_handler(struct task_struct *tsk);
+
+static inline void io_uring_handler(struct task_struct *tsk)
+{
+	if (!list_empty(&tsk->uring_work))
+		io_uring_task_handler(tsk);
+}
+#else /* !CONFIG_IO_URING */
+static inline void io_uring_handler(struct task_struct *tsk)
+{
+}
+#endif
+
 static inline void prepare_task(struct task_struct *next)
 {
 #ifdef CONFIG_SMP
@@ -3322,6 +3341,8 @@ asmlinkage __visible void schedule_tail(struct task_struct *prev)
 	balance_callback(rq);
 	preempt_enable();
 
+	io_uring_handler(current);
+
 	if (current->set_child_tid)
 		put_user(task_pid_vnr(current), current->set_child_tid);
 

-- 
Jens Axboe

