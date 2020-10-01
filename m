Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4972B28026C
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 17:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732104AbgJAPTN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 11:19:13 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36450 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732516AbgJAPTK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 11:19:10 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601565548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iNt6q1891XBXfQOj3GXswUcY8586ILcqIeO3Tk9oMiM=;
        b=TcY/Pm8jHms3Gq1bYsUKLCPFPvsVTde4O9k5mIGaS0Kx/HG026MLk160BFDQ81SX1l3DSB
        +Ts2w7ekmVyYbn3pyFMXLJX5w7nULdAmjbVTMIFYHANlPci1MRTF81sbhSuXOGE6r1+bMG
        4Z+KIJN9dY7Cc5WdigxhjTb3t7hJ7F73uDioLCsyWRmZ90ZkIRpS6PrTIdkqtKcc6ccUJ+
        Rlg7yIw0/H0H3403IGH6blxkk8GTo/mVCvaUcjhUZ8bx0gFOkJsImA33IBjydykIMnVK2t
        SimXhzrArxrTECU6VsOkFHErDvlxVMOGgEbS4YsJETnOFeeIvPjb5ok8PeqZkA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601565548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iNt6q1891XBXfQOj3GXswUcY8586ILcqIeO3Tk9oMiM=;
        b=FDeW1iUzZvgdZkqqm6lkraty36zdgv6mNx6+APNE+9MEnIigZHH+5qeOMvTZNqMW487x+c
        x74gclvMgOlW/VBw==
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RFC] kernel: decouple TASK_WORK TWA_SIGNAL handling from signals
In-Reply-To: <0b5336a7-c975-a8f8-e988-e983e2340d99@kernel.dk>
References: <0b5336a7-c975-a8f8-e988-e983e2340d99@kernel.dk>
Date:   Thu, 01 Oct 2020 17:19:07 +0200
Message-ID: <875z7uezys.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 01 2020 at 08:29, Jens Axboe wrote:
> This adds TIF_TASKWORK for x86, which if set, will return true on
> checking for pending signals. That in turn causes tasks to restart the
> system call, which will run the added task_work.

Huch? The syscall restart does not cause the task work to run.

> If TIF_TASKWORK is available, we'll use that for notification when
> TWA_SIGNAL is specified.  If it isn't available, the existing
> TIF_SIGPENDING path is used.

Bah. Yet another TIF flag just because.

> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1767,7 +1767,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
>  		notify = TWA_SIGNAL;
>  
>  	ret = task_work_add(tsk, cb, notify);
> -	if (!ret)
> +	if (!ret && !notify)

!notify assumes that TWA_RESUME == 0. Fun to debug if that ever changes.

>  		wake_up_process(tsk);
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -28,7 +28,6 @@ int
>  task_work_add(struct task_struct *task, struct callback_head *work, int notify)
>  {
>  	struct callback_head *head;
> -	unsigned long flags;
>  
>  	do {
>  		head = READ_ONCE(task->task_works);
> @@ -41,7 +40,10 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
>  	case TWA_RESUME:
>  		set_notify_resume(task);
>  		break;
> -	case TWA_SIGNAL:
> +	case TWA_SIGNAL: {
> +#ifndef TIF_TASKWORK
> +		unsigned long flags;
> +
>  		/*
>  		 * Only grab the sighand lock if we don't already have some
>  		 * task_work pending. This pairs with the smp_store_mb()
> @@ -53,7 +55,12 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
>  			signal_wake_up(task, 0);
>  			unlock_task_sighand(task, &flags);
>  		}
> +#else
> +		set_tsk_thread_flag(task, TIF_TASKWORK);
> +		wake_up_process(task);
> +#endif

This is really a hack. TWA_SIGNAL is a misnomer with the new
functionality and combined with the above

         if (!ret && !notify)
  		wake_up_process(tsk);

there is not really a big difference between TWA_RESUME and TWA_SIGNAL
anymore. Just the delivery mode and the syscall restart magic.

>  static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
>  					    unsigned long ti_work)
>  {
> +	bool restart_sys = false;
> +
>  	/*
>  	 * Before returning to user space ensure that all pending work
>  	 * items have been completed.
> @@ -157,8 +159,13 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
>  		if (ti_work & _TIF_PATCH_PENDING)
>  			klp_update_patch_state(current);
>  
> +		if (ti_work & _TIF_TASKWORK) {
> +			task_work_run();
> +			restart_sys = true;
> +		}
> +
>  		if (ti_work & _TIF_SIGPENDING)
> -			arch_do_signal(regs);
> +			restart_sys |= !arch_do_signal(regs);
>  
>  		if (ti_work & _TIF_NOTIFY_RESUME) {
>  			clear_thread_flag(TIF_NOTIFY_RESUME);
> @@ -178,6 +185,9 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
>  		ti_work = READ_ONCE(current_thread_info()->flags);
>  	}
>  
> +	if (restart_sys)
> +		arch_restart_syscall(regs);
> +

How is that supposed to work?

Assume that both TIF_TASKWORK and TIF_SIGPENDING are set, i.e. after
running task work and requesting syscall restart there is an actual
signal to be delivered.

This needs a lot more thoughts.

Thanks,

        tglx


