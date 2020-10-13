Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453C728DD74
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 11:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbgJNJYh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 05:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730796AbgJNJUK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 05:20:10 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4603C08EC3E;
        Tue, 13 Oct 2020 16:50:26 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602633025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nCUoUR6+uxjkAbOY3zTEcQ6IAUO/zrzgTWOr/0AWWRs=;
        b=4PY7LNBoRXqxj/FvQ2UuL4sn4aIV+c3iuZJqB4xkKktMBpwAnMOCIsjezj03IbYj49ZA87
        YBapabkSVlWCImVTcoKY6dFTNmXN4qaCitNodjmsL3bymobul0l0nyk52Sn/POPJLGwnGS
        j9EatuVJHhxRPGiSibJAuq/5/lR6paH+KleQ4Rpz7XPqCjsyk9T18v3Z55fWwFUHN7lnpy
        8rTIki7XjVuCTR4cl9KO98lWE039/ctMMv/Xk0j4FZsWZJiPujg/8U5EOEqA14mjMQkWbA
        PSGc0iP1QlMKOqxR9rmdbSglCdQOakIQNyKeKhD7pdiktx1Kf+jKlrLy4iCwZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602633025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nCUoUR6+uxjkAbOY3zTEcQ6IAUO/zrzgTWOr/0AWWRs=;
        b=irnr61MlGns1BMSW3/RQ4H0MBJXOfrzsYMZRxGkM5Nj1ruoXIAg/oSfWWBC5GsZ8tEOsM8
        Y9RWNGK19xda56CA==
To:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com,
        Jens Axboe <axboe@kernel.dk>,
        Roman Gershman <romger@amazon.com>
Subject: Re: [PATCH 4/4] task_work: use TIF_NOTIFY_SIGNAL if available
In-Reply-To: <20201008152752.218889-5-axboe@kernel.dk>
References: <20201008152752.218889-1-axboe@kernel.dk> <20201008152752.218889-5-axboe@kernel.dk>
Date:   Wed, 14 Oct 2020 01:50:25 +0200
Message-ID: <87362hd6ta.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 08 2020 at 09:27, Jens Axboe wrote:
> +/*
> + * TWA_SIGNAL signaling - use TIF_NOTIFY_SIGNAL, if available, as it's faster
> + * than TIF_SIGPENDING as there's no dependency on ->sighand. The latter is
> + * shared for threads, and can cause contention on sighand->lock. Even for
> + * the non-threaded case TIF_NOTIFY_SIGNAL is more efficient, as no locking
> + * or IRQ disabling is involved for notification (or running) purposes.
> + */
> +static void task_work_notify_signal(struct task_struct *task)
> +{
> +#ifdef TIF_NOTIFY_SIGNAL
> +	set_notify_signal(task);
> +#else
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
> +#endif

Same #ifdeffery comment as before.

Thanks,

        tglx

