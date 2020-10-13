Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2F328DCFA
	for <lists+io-uring@lfdr.de>; Wed, 14 Oct 2020 11:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731006AbgJNJVf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Oct 2020 05:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731014AbgJNJUk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Oct 2020 05:20:40 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97E3C08EAE0;
        Tue, 13 Oct 2020 16:42:55 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1602632574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IGLsy7zJKFsqjqav7kd9QaEQcL8Zxfhq3qOudECtU88=;
        b=ZEkE2pZN5e3HVrZrlnZgxzqhLHOl2ten8u6ZW/fchrROrt51iMxaKZCQFRtgM2Ahb/d0KO
        EIuEkNvzuxWWXSffIJRckbZ2S2IfbQw3evLTxi3owEhy0j4gkH5qy/olsT3yc4JyL68lJ0
        i3/jfbY2icsxkVOuHI8R2BfW7Akxj8GrU7UTHY0olmbXthblvI/fVbCyR6LkpvnxqDnOn4
        fTlMHtA4sN3VgmDbxvwzuN97Z8ef4ygUosfvacKVu2H2mwnWZ0Z+ikpXB//YoIL+zzy0ST
        xQ0RLPR3zKJx+TBSSL1/U7KDB4GuH7Wwjnx0GpabWRALdqGfF9dQxn+Svc0Iew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1602632574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IGLsy7zJKFsqjqav7kd9QaEQcL8Zxfhq3qOudECtU88=;
        b=wZINN9vNra5AzI4Mku/3oxHq3yM3IDlJvL68r8e3ye+6rkFumuUuBlt9dZ7dHODXs2NtBu
        vOyADYUjMkpPsuCw==
To:     Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/4] kernel: add support for TIF_NOTIFY_SIGNAL
In-Reply-To: <20201008152752.218889-4-axboe@kernel.dk>
References: <20201008152752.218889-1-axboe@kernel.dk> <20201008152752.218889-4-axboe@kernel.dk>
Date:   Wed, 14 Oct 2020 01:42:53 +0200
Message-ID: <878sc9d75u.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Oct 08 2020 at 09:27, Jens Axboe wrote:
> This adds TIF_NOTIFY_SIGNAL handling in the generic code, which if set,
> will return true if signal_pending() is used in a wait loop. That causes
> an exit of the loop so that notify_signal tracehooks can be run. If the
> wait loop is currently inside a system call, the system call is restarted
> once task_work has been processed.
>
> x86 is using the generic entry code, add the necessary TIF_NOTIFY_SIGNAL
> definitions for it.

Can you please split that into core changes and a patch which adds
support for x86?

>  static inline int signal_pending(struct task_struct *p)
>  {
> +#ifdef TIF_NOTIFY_SIGNAL

As I said in the other thread, plase make this

#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)

> +/*
> + * called by exit_to_user_mode_loop() if ti_work & _TIF_NOTIFY_SIGNAL. This
> + * is currently used by TWA_SIGNAL based task_work, which requires breaking
> + * wait loops to ensure that task_work is noticed and run.
> + */
> +static inline void tracehook_notify_signal(void)
> +{
> +#ifdef TIF_NOTIFY_SIGNAL

Ditto.

> +	clear_thread_flag(TIF_NOTIFY_SIGNAL);
> +	smp_mb__after_atomic();
> +	if (current->task_works)
> +		task_work_run();
> +#endif
> +}
> +
> +/*
> + * Called when we have work to process from exit_to_user_mode_loop()
> + */
> +static inline void set_notify_signal(struct task_struct *task)
> +{
> +#ifdef TIF_NOTIFY_SIGNAL

And this one.

Other than that, this approach of using arch_do_signal() addresses my
earlier concerns about the syscall restart machinery.

Thanks,

        tglx
