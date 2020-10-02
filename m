Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8DD28164D
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 17:14:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388304AbgJBPOc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 11:14:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59128 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726017AbgJBPOa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 11:14:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601651669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BZTDFQTt49BGOxnJTv9mK0z9XLZx1BSCPudd/gNH2iY=;
        b=ciO8hw6c+POnzgU3QwpBwesKjT8s77sEt1M9HI+WE0I7DV59TvspXa8TjD4EqxCgT345sL
        Hj1p6XqJN0Prb0exCeCRGrewJIsahL5k55MwBgCvgcQ3LbDe5vvpUVZYjez5GQcTUhKzr9
        sFtGDd6jgEREspd1r49jVNQVTnNoze4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-279-S96k0srWPw-4ACP-YwwGzg-1; Fri, 02 Oct 2020 11:14:25 -0400
X-MC-Unique: S96k0srWPw-4ACP-YwwGzg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E36A91062744;
        Fri,  2 Oct 2020 15:14:18 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.40.192.246])
        by smtp.corp.redhat.com (Postfix) with SMTP id 66AFB5C1D7;
        Fri,  2 Oct 2020 15:14:17 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Fri,  2 Oct 2020 17:14:18 +0200 (CEST)
Date:   Fri, 2 Oct 2020 17:14:16 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org, tglx@linutronix.de
Subject: Re: [PATCH 3/3] task_work: use TIF_TASKWORK if available
Message-ID: <20201002151415.GA29066@redhat.com>
References: <20201001194208.1153522-1-axboe@kernel.dk>
 <20201001194208.1153522-4-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001194208.1153522-4-axboe@kernel.dk>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Heh. To be honest I don't really like 1-2 ;)

Unfortunately, I do not see a better approach right now. Let me think
until Monday, it is not that I think I will find a better solution, but
I'd like to try anyway.

Let me comment 3/3 for now.

On 10/01, Jens Axboe wrote:
>
> +static void task_work_signal(struct task_struct *task)
> +{
> +#ifndef TIF_TASKWORK
> +	unsigned long flags;
> +
> +	/*
> +	 * Only grab the sighand lock if we don't already have some
> +	 * task_work pending. This pairs with the smp_store_mb()
> +	 * in get_signal(), see comment there.
> +	 */
> +	if (!(READ_ONCE(task->jobctl) & JOBCTL_TASK_WORK) &&
> +	    lock_task_sighand(task, &flags)) {
> +		task->jobctl |= JOBCTL_TASK_WORK;
> +		signal_wake_up(task, 0);
> +		unlock_task_sighand(task, &flags);
> +	}
> +#else
> +	set_tsk_thread_flag(task, TIF_TASKWORK);
> +	set_notify_resume(task);
> +#endif

Again, I can't understand. task_work_signal(task) should set TIF_TASKWORK
to make signal_pending() = T _and_ wake/kick the target up, just like
signal_wake_up() does. Why do we set TIF_NOTIFY_RESUME ?

So I think that if we are going to add TIF_TASKWORK we should generalize
this logic and turn it into TIF_NOTIFY_SIGNAL. Similar to TIF_NOTIFY_RESUME
but implies signal_pending().

IOW, something like

	void set_notify_signal(task)
	{
		if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL)) {
			if (!wake_up_state(task, TASK_INTERRUPTIBLE))
				kick_process(t);
		}
	}

	// called by exit_to_user_mode_loop() if ti_work & _TIF_NOTIFY_SIGNAL
	void tracehook_notify_signal(regs)
	{
		clear_thread_flag(TIF_NOTIFY_SIGNAL);
		smp_mb__after_atomic();
		if (unlikely(current->task_works))
			task_work_run();
	}

This way task_work_run() doesn't need to clear TIF_NOTIFY_SIGNAL and it can
have more users.

What do you think?

Oleg.

