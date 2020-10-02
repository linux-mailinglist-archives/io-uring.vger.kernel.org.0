Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE322816A5
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388337AbgJBPbI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 11:31:08 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:43330 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388127AbgJBPbI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 11:31:08 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1601652667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2k/uk5Q61kfFbx4o1quTUaDHyKYAV/wduere4YBYfgY=;
        b=172bzGOw43/yqmxoga1+kIcH0ilZVmDwIFzXwSPODOSr7Wt5GEXR15p1xoHK8nWdv+snlk
        CCKa+Pd5eJguThCuZe4dpioCxL/okihyJlkVG/sr6i2pyIoAsmHyhCXxvbO/EetVYpUIl6
        JpvgJXDIPUTbNyW2vXO0iUzMcQZOOrx9P3WP+CHdTymOvdwwF5ZnWYFcCHQJUBRX/jIqyQ
        lkriry+tcHdEFolXgmsKDt2GGSLw4hoVyTTLjYS4DP+AfZ0ZHzEt16o20I6q83G8ldIvfT
        Jilzhh5HG3XK3FkJCa7b73hJk2PzaXxAxOOb50tYLSzxzgccAyP8CTxHv8nq+g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1601652667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2k/uk5Q61kfFbx4o1quTUaDHyKYAV/wduere4YBYfgY=;
        b=+JBArhux1QGsz7SXKGhdjVt6SNCvavylnYb9R3nKqe/pgcaMiihPlWctLaO7FonpzHx2BS
        JR2cmWtgvFgKlnDQ==
To:     Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org
Subject: Re: [PATCH 3/3] task_work: use TIF_TASKWORK if available
In-Reply-To: <20201002151415.GA29066@redhat.com>
References: <20201001194208.1153522-1-axboe@kernel.dk> <20201001194208.1153522-4-axboe@kernel.dk> <20201002151415.GA29066@redhat.com>
Date:   Fri, 02 Oct 2020 17:31:07 +0200
Message-ID: <871rigejb8.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Oct 02 2020 at 17:14, Oleg Nesterov wrote:
> Heh. To be honest I don't really like 1-2 ;)

I do not like any of this :)

> So I think that if we are going to add TIF_TASKWORK we should generalize
> this logic and turn it into TIF_NOTIFY_SIGNAL. Similar to TIF_NOTIFY_RESUME
> but implies signal_pending().
>
> IOW, something like
>
> 	void set_notify_signal(task)
> 	{
> 		if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL)) {
> 			if (!wake_up_state(task, TASK_INTERRUPTIBLE))
> 				kick_process(t);
> 		}
> 	}
>
> 	// called by exit_to_user_mode_loop() if ti_work & _TIF_NOTIFY_SIGNAL
> 	void tracehook_notify_signal(regs)
> 	{
> 		clear_thread_flag(TIF_NOTIFY_SIGNAL);
> 		smp_mb__after_atomic();
> 		if (unlikely(current->task_works))
> 			task_work_run();
> 	}
>
> This way task_work_run() doesn't need to clear TIF_NOTIFY_SIGNAL and it can
> have more users.

I think it's fundamentaly wrong that we have several places and several
flags which handle task_work_run() instead of having exactly one place
and one flag.

Thanks,

        tglx

