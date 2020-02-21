Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BED51680BB
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 15:49:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgBUOtU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 09:49:20 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40805 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbgBUOtU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 09:49:20 -0500
Received: by mail-pf1-f195.google.com with SMTP id b185so1318746pfb.7
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 06:49:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bKL0HV+RekHUW11Khs5i6FuS6UgNZYStcK9nvG5qbnE=;
        b=DSPMOs6/djkkHq0z3OpDcXfLCOvfwHfCxD1XKlcJzahJgSCCtbFxAU7FX+ifBoQCzl
         4vQSquUfLrxepvz0ZtqRINdZtAS1PfTfq2+IC2CVOEmi/+OEMUrzglJ/JdZeKQCUs6U8
         nydbtP6lQdkjNiLf32vcM418O1fEPnmxov0KqdCIm5zM0yVEKl4hhJndOUkMtZGLtcvQ
         OxPFJhZYY1/+bR/vnOco6ZHSne2YLGqejkyq/ihfYWSWWidhJoQAbXfELgRl0/WIGoPs
         p9ZnXjUvzRKhu4lg5y2W4kboSB0Dpe3WhHFCBkZVE8C+LIczynYa/zuDqq5YsurcYRUz
         O1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bKL0HV+RekHUW11Khs5i6FuS6UgNZYStcK9nvG5qbnE=;
        b=Vlqj14DBtnW4wmDqDctX27wYMZYnso5r6APlbCM72yB89achwZeucire6XOTrA8so4
         y+6aT7EvyLxClNZUB/BBfKJ3riOfA7dgT7+DeEwmb7rS7JO0RJ/2lMMj/NoVWXyXqOb7
         IWbOK0XrHAWb6CjDlfT3g7iimoV0ZqVzUMD3oghc8NPpr8FOcTmafLF6Iegy8ZV1Ju0t
         FRHlfWWa6CUqAsAJEx/viVjMufn/pxPDaDjMHYv5cPYg8wNxL+mBj5Ra0+1ufl/l1wee
         nDCAB0X6KcC6PSkA4od1FwyS2KIqjyPnNk/6N89w1e8afGM7Qdfb4NHHdThM4plPGst/
         HJ3Q==
X-Gm-Message-State: APjAAAUXIs5uC450BAHljQ9hFdeDKG2l+7AnTetDnV4pQiWS6B795FaJ
        UW0823XQOkteVDH6iOucgv/6RA==
X-Google-Smtp-Source: APXvYqzXuvMxYS3M91u5M+QYsHfxPnH+w57sqYx4fZSPC7FFQvPHg3HNrTXC+Z24iLn1Q962G18XRg==
X-Received: by 2002:a63:be09:: with SMTP id l9mr16936850pgf.439.1582296558700;
        Fri, 21 Feb 2020 06:49:18 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:fdca:2b3c:ac97:51da? ([2605:e000:100e:8c61:fdca:2b3c:ac97:51da])
        by smtp.gmail.com with ESMTPSA id q8sm3140182pfs.161.2020.02.21.06.49.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 06:49:18 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <20200221104740.GE18400@hirez.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e8d4355-fd2c-b155-b28c-57fd20db949d@kernel.dk>
Date:   Fri, 21 Feb 2020 06:49:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200221104740.GE18400@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 3:47 AM, Peter Zijlstra wrote:
> On Thu, Feb 20, 2020 at 11:02:16PM +0100, Jann Horn wrote:
>> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> For poll requests, it's not uncommon to link a read (or write) after
>>> the poll to execute immediately after the file is marked as ready.
>>> Since the poll completion is called inside the waitqueue wake up handler,
>>> we have to punt that linked request to async context. This slows down
>>> the processing, and actually means it's faster to not use a link for this
>>> use case.
>>>
>>> We also run into problems if the completion_lock is contended, as we're
>>> doing a different lock ordering than the issue side is. Hence we have
>>> to do trylock for completion, and if that fails, go async. Poll removal
>>> needs to go async as well, for the same reason.
>>>
>>> eventfd notification needs special case as well, to avoid stack blowing
>>> recursion or deadlocks.
>>>
>>> These are all deficiencies that were inherited from the aio poll
>>> implementation, but I think we can do better. When a poll completes,
>>> simply queue it up in the task poll list. When the task completes the
>>> list, we can run dependent links inline as well. This means we never
>>> have to go async, and we can remove a bunch of code associated with
>>> that, and optimizations to try and make that run faster. The diffstat
>>> speaks for itself.
>> [...]
>>> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
>>> +static void io_poll_task_func(struct callback_head *cb)
>>>  {
>>> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
>>> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
>>> +       struct io_kiocb *nxt = NULL;
>>>
>> [...]
>>> +       io_poll_task_handler(req, &nxt);
>>> +       if (nxt)
>>> +               __io_queue_sqe(nxt, NULL);
>>
>> This can now get here from anywhere that calls schedule(), right?
>> Which means that this might almost double the required kernel stack
>> size, if one codepath exists that calls schedule() while near the
>> bottom of the stack and another codepath exists that goes from here
>> through the VFS and again uses a big amount of stack space? This is a
>> somewhat ugly suggestion, but I wonder whether it'd make sense to
>> check whether we've consumed over 25% of stack space, or something
>> like that, and if so, directly punt the request.
> 
> I'm still completely confused as to how io_uring works, and concequently
> the ramifications of all this.
> 
> But I thought to understand that these sched_work things were only
> queued on tasks that were stuck waiting on POLL (or it's io_uring
> equivalent). Earlier patches were explicitly running things from
> io_cqring_wait(), which might have given me this impression.

No, that is correct.

> The above seems to suggest this is not the case. Which then does indeed
> lead to all the worries expressed by Jann. All sorts of nasty nesting is
> possible with this.
> 
> Can someone please spell this out for me?

Let me try with an example - the tldr is that a task wants to eg read
from a socket, it issues a io_uring recv() for example. We always do
these non-blocking, there's no data there, the task gets -EAGAIN on the
attempt. What would happen in the previous code is the task would then
offload the recv() to a worker thread, and the worker thread would
block waiting on the receive. This is sub-optimal, in that it both
requires a thread offload and has a thread alive waiting for that data
to come in.

This, instead, arms a poll handler for the task. When we get notified of
data availability, we queue a work item that will the perform the
recv(). This is what is offloaded to the sched_work list currently.

> Afaict the req->tsk=current thing is set for whomever happens to run
> io_poll_add_prep(), which is either a sys_io_uring_enter() or an io-wq
> thread afaict.
> 
> But I'm then unsure what happens to that thread afterwards.
> 
> Jens, what exactly is the benefit of running this on every random
> schedule() vs in io_cqring_wait() ? Or even, since io_cqring_wait() is
> the very last thing the syscall does, task_work.

I took a step back and I think we can just use the task work, which
makes this a lot less complicated in terms of locking and schedule
state. Ran some quick testing with the below and it works for me.

I'm going to re-spin based on this and just dump the sched_work
addition.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 81aa3959f326..413ac86d7882 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3529,7 +3529,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 * the exit check will ultimately cancel these work items. Hence we
 	 * don't need to check here and handle it specifically.
 	 */
-	sched_work_add(tsk, &req->sched_work);
+	task_work_add(tsk, &req->sched_work, true);
 	wake_up_process(tsk);
 	return 1;
 }
@@ -5367,9 +5367,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		if (io_cqring_events(ctx, false) >= min_events)
 			return 0;
-		if (!current->sched_work)
+		if (!current->task_works)
 			break;
-		sched_work_run();
+		task_work_run();
 	} while (1);
 
 	if (sig) {
@@ -5392,6 +5392,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 						TASK_INTERRUPTIBLE);
 		if (io_should_wake(&iowq, false))
 			break;
+		if (current->task_works) {
+			task_work_run();
+			if (io_should_wake(&iowq, false))
+				break;
+			continue;
+		}
 		schedule();
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -6611,7 +6617,7 @@ static void __io_uring_cancel_task(struct task_struct *tsk,
 {
 	struct callback_head *head;
 
-	while ((head = sched_work_cancel(tsk, func)) != NULL) {
+	while ((head = task_work_cancel(tsk, func)) != NULL) {
 		struct io_kiocb *req;
 
 		req = container_of(head, struct io_kiocb, sched_work);
@@ -6886,7 +6892,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		struct io_kiocb *req;
 
 		hlist_for_each_entry(req, list, hash_node)
-			seq_printf(m, "  req=%lx, op=%d, tsk list=%d\n", (long) req, req->opcode, req->task->sched_work != NULL);
+			seq_printf(m, "  req=%lx, op=%d, tsk list=%d\n", (long) req, req->opcode, req->task->task_works != NULL);
 	}
 	spin_unlock_irq(&ctx->completion_lock);
 	mutex_unlock(&ctx->uring_lock);

-- 
Jens Axboe

