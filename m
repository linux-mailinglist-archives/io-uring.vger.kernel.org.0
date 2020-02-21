Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E094167B41
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 11:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728321AbgBUKrs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 05:47:48 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:40830 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728311AbgBUKrq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 05:47:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gs7gkyTuqpIeeD6N7XSe4PrOvDA3q3ruDWaBnShCDoE=; b=uvxFAesn99iJDpcNGZiodPNlKG
        FUondremJpmal9stkxlxhVpFinmzhokzndpfrKo8E0JTCTPvMm4uUSp1+b2ueZ4esQ1i6nEYEfKGp
        F0t+KAcmnty+ClEE1m8TXJrnoX48JWm99tdXx69sBGWTQY2KCKADd7pTYIujhK/hulggqt2GR7Fec
        MxUpE0B8KLep9+qEofcPtI0M87O8OymzhGgCFFIhwQKSj75ZEdC+Fn3OZLke1rxtMlo/Q+UFT8PSk
        W6Z5DA2qIHkBVRXiEmG75NpjF6D0Nowg1kZ3jjWJQu1lcOn7xxI3saS15PEprRDiFFTitqYUSNWHf
        iIPNKrUg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j55qQ-0002oe-Rv; Fri, 21 Feb 2020 10:47:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3CFC3300565;
        Fri, 21 Feb 2020 11:45:47 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6CCB1203C3ED0; Fri, 21 Feb 2020 11:47:40 +0100 (CET)
Date:   Fri, 21 Feb 2020 11:47:40 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
Message-ID: <20200221104740.GE18400@hirez.programming.kicks-ass.net>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 20, 2020 at 11:02:16PM +0100, Jann Horn wrote:
> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
> > For poll requests, it's not uncommon to link a read (or write) after
> > the poll to execute immediately after the file is marked as ready.
> > Since the poll completion is called inside the waitqueue wake up handler,
> > we have to punt that linked request to async context. This slows down
> > the processing, and actually means it's faster to not use a link for this
> > use case.
> >
> > We also run into problems if the completion_lock is contended, as we're
> > doing a different lock ordering than the issue side is. Hence we have
> > to do trylock for completion, and if that fails, go async. Poll removal
> > needs to go async as well, for the same reason.
> >
> > eventfd notification needs special case as well, to avoid stack blowing
> > recursion or deadlocks.
> >
> > These are all deficiencies that were inherited from the aio poll
> > implementation, but I think we can do better. When a poll completes,
> > simply queue it up in the task poll list. When the task completes the
> > list, we can run dependent links inline as well. This means we never
> > have to go async, and we can remove a bunch of code associated with
> > that, and optimizations to try and make that run faster. The diffstat
> > speaks for itself.
> [...]
> > -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
> > +static void io_poll_task_func(struct callback_head *cb)
> >  {
> > -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> > +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
> > +       struct io_kiocb *nxt = NULL;
> >
> [...]
> > +       io_poll_task_handler(req, &nxt);
> > +       if (nxt)
> > +               __io_queue_sqe(nxt, NULL);
> 
> This can now get here from anywhere that calls schedule(), right?
> Which means that this might almost double the required kernel stack
> size, if one codepath exists that calls schedule() while near the
> bottom of the stack and another codepath exists that goes from here
> through the VFS and again uses a big amount of stack space? This is a
> somewhat ugly suggestion, but I wonder whether it'd make sense to
> check whether we've consumed over 25% of stack space, or something
> like that, and if so, directly punt the request.

I'm still completely confused as to how io_uring works, and concequently
the ramifications of all this.

But I thought to understand that these sched_work things were only
queued on tasks that were stuck waiting on POLL (or it's io_uring
equivalent). Earlier patches were explicitly running things from
io_cqring_wait(), which might have given me this impression.

The above seems to suggest this is not the case. Which then does indeed
lead to all the worries expressed by Jann. All sorts of nasty nesting is
possible with this.

Can someone please spell this out for me?

Afaict the req->tsk=current thing is set for whomever happens to run
io_poll_add_prep(), which is either a sys_io_uring_enter() or an io-wq
thread afaict.

But I'm then unsure what happens to that thread afterwards.

Jens, what exactly is the benefit of running this on every random
schedule() vs in io_cqring_wait() ? Or even, since io_cqring_wait() is
the very last thing the syscall does, task_work.
