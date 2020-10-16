Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898C9290056
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 11:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394366AbgJPJAZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 05:00:25 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43246 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732226AbgJPJAZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 05:00:25 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602838820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I/DKWrB4OAhNZBuftcrG8Hlu4OJlkxODtGD9GRhR6CU=;
        b=3Dm+tWn385v6XGqTiIDMnWDgLxYcozGmsSRKDCedOqE4zBLK4/LxrQ9eKHxqTnERFeSNra
        hGFNGsg+nWWnvv1f+w39+B0CrUFw9RZ/j29Qrx278ANVlgVYp6sq9KWQbPLBRZY1WsZ/OE
        E14zK83WeBpJ7GyLJyL7BT4GMRBCITg04kzTouAHeATPPXuqdSMqurneTlRL2paZq0rNHN
        PrOsYh/k92fnsq9nFpgYuDQ59HpgHHsWLHb/uBa4EUJLGiVKqnwHNCMu30QWECDaVTVq8b
        LRvsmSltu3UM8/hOBS5+/+Njma8B0CjSu25LpSIOTj1hsEgoqz563egQDabb+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602838820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=I/DKWrB4OAhNZBuftcrG8Hlu4OJlkxODtGD9GRhR6CU=;
        b=FN0JJIxVA79a+ecF6y8lLO9cUv5cLYviOTPrHNpQxbidQIQ0ZG6hjI04GQwyr0krZdNz+A
        OYkoaV3bp7ACSNCA==
To:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, Roman Gershman <romger@amazon.com>
Subject: Re: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
In-Reply-To: <e17cd91e-97b2-1eae-964b-fc90f8f9ef31@kernel.dk>
References: <20201015131701.511523-1-axboe@kernel.dk> <20201015131701.511523-6-axboe@kernel.dk> <20201015154953.GM24156@redhat.com> <e17cd91e-97b2-1eae-964b-fc90f8f9ef31@kernel.dk>
Date:   Fri, 16 Oct 2020 11:00:20 +0200
Message-ID: <87a6wmv93v.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 15 2020 at 12:39, Jens Axboe wrote:
> On 10/15/20 9:49 AM, Oleg Nesterov wrote:
>> You can simply nack the patch which adds TIF_NOTIFY_SIGNAL to
>> arch/xxx/include/asm/thread_info.h.

As if that is going to change anything...

> This seems to be the biggest area of contention right now. Just to
> summarize, we have two options:
>
> 1) We leave the CONFIG_GENERIC_ENTRY requirement, which means that the
>    rest of the cleanups otherwise enabled by this series will not be
>    able to move forward until the very last arch is converted to the
>    generic entry code.
>
> 2) We go back to NOT having the CONFIG_GENERIC_ENTRY requirement, and
>    archs can easily opt-in to TIF_NOTIFY_SIGNAL independently of
>    switching to the generic entry code.
>
> I understand Thomas's reasoning in wanting to push archs towards the
> generic entry code, and I fully support that. However, it does seem like
> the road paved by #1 is long and potentially neverending, which would
> leave us with never being able to kill the various bits of code that we
> otherwise would be able to.
>
> Thomas, I do agree with Oleg on this one, I think we can make quicker
> progress on cleanups with option #2. This isn't really going to hinder
> any arch conversion to the generic entry code, as arch patches would be
> funeled through the arch trees anyway.

I completely understand the desire to remove the jobctl mess and it
looks like a valuable cleanup on it's own.

But I fundamentaly disagree with the wording of #2:

    'and archs can easily opt-in ....'

Just doing it on an opt-in base is not any different from making it
dependent on CONFIG_GENERIC_ENTRY. It's just painted differently and
makes it easy for you to bring the performance improvement to the less
than a handful architectures which actually care about io_uring.

So if you change #2 to:

   Drop the CONFIG_GENERIC_ENTRY dependency, make _all_ architectures
   use TIF_NOTIFY_SIGNAL and clean up the jobctl and whatever related
   mess.

and actually act apon it, then I'm fine with that approach.

Anything else is just proliferating the existing mess and yet another
promise of great improvements which never materialize.

Just to prove my point:

e91b48162332 ("task_work: teach task_work_add() to do signal_wake_up()")

added TWA_SIGNAL in June with the following in the changelog:

    TODO: once this patch is merged we need to change all current users
    of task_work_add(notify = true) to use TWA_RESUME.

Now let's look at reality:

arch/x86/kernel/cpu/mce/core.c:	task_work_add(current, &current->mce_kill_me, true);
arch/x86/kernel/cpu/resctrl/rdtgroup.c:	ret = task_work_add(tsk, &callback->work, true);
drivers/acpi/apei/ghes.c:			ret = task_work_add(current, &estatus_node->task_work,
drivers/acpi/apei/ghes.c-					    true);
drivers/android/binder.c:		task_work_add(current, &twcb->twork, true);
fs/file_table.c:			if (!task_work_add(task, &file->f_u.fu_rcuhead, true))

fs/io_uring.c:		ret = task_work_add(req->task, &req->task_work, TWA_RESUME);

fs/io_uring.c:			task_work_add(tsk, &req->task_work, 0);

fs/io_uring.c-	notify = 0;
fs/io_uring.c-	if (!(ctx->flags & IORING_SETUP_SQPOLL) && twa_signal_ok)
fs/io_uring.c-		notify = TWA_SIGNAL;
fs/io_uring.c-
fs/io_uring.c:	ret = task_work_add(tsk, &req->task_work, notify);

fs/io_uring.c:		task_work_add(tsk, &req->task_work, 0);

fs/io_uring.c:		task_work_add(tsk, &req->task_work, 0);
fs/io_uring.c:		task_work_add(tsk, &req->task_work, 0);

fs/namespace.c:			if (!task_work_add(task, &mnt->mnt_rcu, true))

kernel/events/uprobes.c:	task_work_add(t, &t->utask->dup_xol_work, true);

kernel/irq/manage.c:	task_work_add(current, &on_exit_work, false);

kernel/sched/fair.c:			task_work_add(curr, work, true);

kernel/task_work.c:task_work_add(struct task_struct *task, struct callback_head *work, int notify)
kernel/time/posix-cpu-timers.c:	task_work_add(tsk, &tsk->posix_cputimers_work.work, TWA_RESUME);

security/keys/keyctl.c:	ret = task_work_add(parent, newwork, true);

security/yama/yama_lsm.c:	if (task_work_add(current, &info->work, true) == 0)

See? Adding TODO's and making promises about cleanups is easy.

The patch adding this is sloppy at best. Instead of using a named enum
it just defines TWA_RESUME and TWA_SIGNAL.

That makes the code really readable:

     notify = 0;
     if (cond)
     	notify = TWA_SIGNAL;

Making that

enum task_work_notify_mode {
	TWA_NONE,
        TWA_RESUME,
        TWA_SIGNAL,
};

would have been not convoluted enough, right?

Also the kernel documentation of task_work_add() is outdated and
partially wrong. Can be fixed later as well, right?

This features first and let others deal with the mess we create mindset
has to stop. I'm dead tired of it.

Thanks,

        tglx
