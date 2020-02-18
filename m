Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A970A16290E
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 16:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgBRPIC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 10:08:02 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:48526 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgBRPIC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 10:08:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=k+6XLpSq+QofGERtDiXOt7zfNeqWATfZ0RQPjmhc9M4=; b=jnk83JhCcKtX0HN3ZcGfXNN3cl
        AZnYTVwT8GklDbngOpdBIgpPGtmIry/jqXTvjNkyabmhuxNGr/OUl5ZGpiFHs1qyLj8ZmgACk1HzL
        kXTIMD0Cxd9gXSeHQwIIsdOoZ5luoHEvhuXHTeIsGdq+AId2QLT33DoaMN3c0ABNr/i4hIpos8rfQ
        4dJZiiXSXsi/CTAcRxnap8aTf8bXlUbUN9QNseikcw97edkIFoH2INPPTKa8PgZDcJK0i3qcmfZax
        LllqjHmur6VT1UcmIoqlJS7AqSw2NNFZz1aidAT6Eku04+zT7StipcEyPyxxcv/fgt1AiY65XPIQs
        vWgPq8hg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j44Te-0001pg-IR; Tue, 18 Feb 2020 15:07:58 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A037A3008A9;
        Tue, 18 Feb 2020 16:06:04 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 454022B935590; Tue, 18 Feb 2020 16:07:56 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:07:56 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Message-ID: <20200218150756.GC14914@hirez.programming.kicks-ass.net>
References: <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218145645.GB3466@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 18, 2020 at 03:56:46PM +0100, Oleg Nesterov wrote:
> On 02/18, Peter Zijlstra wrote:
> >
> > But this has me wondering about task_work_run(), as it is it will
> > unconditionally take pi_lock,
> 
> because spin_unlock_wait() was removed ;) task_work_run() doesn't
> really need to take pi_lock at all. 

Right.

> > --- a/kernel/task_work.c
> > +++ b/kernel/task_work.c
> > @@ -93,16 +93,20 @@ void task_work_run(void)
> >  	struct callback_head *work, *head, *next;
> >
> >  	for (;;) {
> > +		work = READ_ONCE(task->task_work);
> > +		if (!work)
> > +			break
> 
> This is wrong if PF_EXITING is set, in this case we must set
> task->task_works = work_exited.

Indeed!

> > +
> >  		/*
> >  		 * work->func() can do task_work_add(), do not set
> >  		 * work_exited unless the list is empty.
> >  		 */
> >  		raw_spin_lock_irq(&task->pi_lock);
> >  		do {
> > -			work = READ_ONCE(task->task_works);
> > -			head = !work && (task->flags & PF_EXITING) ?
> > -				&work_exited : NULL;
> > -		} while (cmpxchg(&task->task_works, work, head) != work);
> > +			head = NULL;
> > +			if (unlikely(!work && (task->flags & PF_EXITING)))
> > +				head = &work_exited;
> > +		} while (!try_cmpxchg(&task->task_works, &work, head));
> >  		raw_spin_unlock_irq(&task->pi_lock);
> >
> >  		if (!work)
> 
> otherwise I think this is correct, but how about the patch below?
> Then this code can be changed to use try_cmpxchg().

Works for me. Thanks!
