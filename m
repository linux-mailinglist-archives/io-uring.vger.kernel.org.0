Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5741168332
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 17:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgBUQX6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 11:23:58 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:41204 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgBUQX6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 11:23:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=a3GgPPeZl1d/+iiwtU6QQoaX6YNFUNomfhT8W2NPY50=; b=sRuirQckjzre4ZWw4M6E9VB+aX
        I+P9osxXahj8ftH9iqKbF5fIjoxk8HvSIyWVVDfvWeY3o/Q4CYWcV/yCazEWUT44yKL0riO6MZNr4
        dnleQFiO2Xtyg2atdu/ktT/TqrfcoiEUu7OOYsrNFRBkLlFrtNbqOXqghbFDxLNQgYGFGCjkqHTXd
        S5E++ltwjZk3mC4UC41gzICYN+Uj/uYvdXvrJ2ESuRod7UYt1d7hE4NKVzmGte2HhR26gwWZd8I4j
        3igQ67M0Q1coZ8VQmVSfiquzbQaZGtuTVoinN7pTlqes5dRTLnuAOzwWxQ3Q02p4d79HT8UkyNTZ3
        kqbDsZ8w==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j5B5o-0001dG-7v; Fri, 21 Feb 2020 16:23:56 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 48DDD304D2C;
        Fri, 21 Feb 2020 17:22:01 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 8F7FC2B26B89E; Fri, 21 Feb 2020 17:23:54 +0100 (CET)
Date:   Fri, 21 Feb 2020 17:23:54 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Jann Horn <jannh@google.com>, io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
Message-ID: <20200221162354.GZ14897@hirez.programming.kicks-ass.net>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <20200221104740.GE18400@hirez.programming.kicks-ass.net>
 <7e8d4355-fd2c-b155-b28c-57fd20db949d@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e8d4355-fd2c-b155-b28c-57fd20db949d@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 21, 2020 at 06:49:16AM -0800, Jens Axboe wrote:

> > Jens, what exactly is the benefit of running this on every random
> > schedule() vs in io_cqring_wait() ? Or even, since io_cqring_wait() is
> > the very last thing the syscall does, task_work.
> 
> I took a step back and I think we can just use the task work, which
> makes this a lot less complicated in terms of locking and schedule
> state. Ran some quick testing with the below and it works for me.
> 
> I'm going to re-spin based on this and just dump the sched_work
> addition.

Aswesome, simpler is better.

> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 81aa3959f326..413ac86d7882 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3529,7 +3529,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
>  	 * the exit check will ultimately cancel these work items. Hence we
>  	 * don't need to check here and handle it specifically.
>  	 */
> -	sched_work_add(tsk, &req->sched_work);
> +	task_work_add(tsk, &req->sched_work, true);
>  	wake_up_process(tsk);
>  	return 1;
>  }
> @@ -5367,9 +5367,9 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  	do {
>  		if (io_cqring_events(ctx, false) >= min_events)
>  			return 0;
> -		if (!current->sched_work)
> +		if (!current->task_works)
>  			break;
> -		sched_work_run();
> +		task_work_run();
>  	} while (1);
>  
>  	if (sig) {
> @@ -5392,6 +5392,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>  						TASK_INTERRUPTIBLE);
>  		if (io_should_wake(&iowq, false))
>  			break;
> +		if (current->task_works) {
> +			task_work_run();
> +			if (io_should_wake(&iowq, false))
> +				break;
> +			continue;
> +		}

		if (current->task_works)
			task_work_run();
		if (io_should_wake(&iowq, false);
			break;

doesn't work?

>  		schedule();
>  		if (signal_pending(current)) {
>  			ret = -EINTR;


Anyway, we need to be careful about the context where we call
task_work_run(), but afaict doing it here should be fine.
