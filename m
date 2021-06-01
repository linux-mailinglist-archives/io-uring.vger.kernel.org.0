Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6EA397BEA
	for <lists+io-uring@lfdr.de>; Tue,  1 Jun 2021 23:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234833AbhFAVyo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Jun 2021 17:54:44 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:35590 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234782AbhFAVyo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Jun 2021 17:54:44 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622584381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WXbXuXynML1A3nvGjqb7EvteJijHOA+zjmWZjkRgOq8=;
        b=I4umCnWahun+4xGy14HUk2QAjgXuyS7QSTz2u6Bh4h9KmxrGXdpn9ES7GC3WFODGBfPut6
        raayGHARGsEmU6YKSBKVCOnwbnlBReoVLkDIMB0CqosO3JqafVmLq5BNMoF30D2U+jZvUj
        uLsw4VXeCuZl1uh/b6gGZHxivaIUEgd11BpPJ024EPaVO0DFcUq6q6MxL0PwsXcEM0+3OX
        eVujAPVqM/S1YIAIT/Y6D6jsPo+f/tMLK4SLrW5CpypYIZPjEQSjy+pLCBDY+vPlejTom8
        pf0w0GAW6oXLdAdeUv1RIhqXlwo2BVCAF+8hgLazGXQ9N0PZ0qJ26HI6zri5mg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622584381;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WXbXuXynML1A3nvGjqb7EvteJijHOA+zjmWZjkRgOq8=;
        b=qes7/41xS/GVCI+4k4eVj+vnPesW/cySPA2KtxdhSM8WQXVZB2cXJcYLwqJu5gjKsCZBeF
        cs+Kl/ugUHRH+yDQ==
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 4/4] io_uring: implement futex wait
In-Reply-To: <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
References: <cover.1622558659.git.asml.silence@gmail.com> <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com> <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk> <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com> <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk> <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
Date:   Tue, 01 Jun 2021 23:53:00 +0200
Message-ID: <87sg211ccj.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel, Jens,

On Tue, Jun 01 2021 at 17:29, Pavel Begunkov wrote:
> On 6/1/21 5:01 PM, Jens Axboe wrote:
>>> Yes, that would be preferable, but looks futexes don't use
>>> waitqueues but some manual enqueuing into a plist_node, see
>>> futex_wait_queue_me() or mark_wake_futex().
>>> Did I miss it somewhere?
>> 
>> Yes, we'd need to augment that with a callback. I do think that's going
>
> Yeah, that was the first idea, but it's also more intrusive for the
> futex codebase. Can be piled on top for next revision of patches.
>
> A question to futex maintainers, how much resistance to merging
> something like that I may expect?

Adding a waitqueue like callback or the proposed thing?

TBH. Neither one has a charm.

1) The proposed solution: I can't figure out from the changelogs or the
   cover letter what kind of problems it solves and what the exact
   semantics are. If you ever consider to submit futex patches, may I
   recommend to study Documentation/process and get some inspiration
   from git-log?

   What are the lifetime rules, what's the interaction with regular
   futexes, what's the interaction with robust list ....? Without
   interaction with regular futexes such a functionality does not make
   any sense at all.

   Also once we'd open that can of worms where is this going to end and
   where can we draw the line? This is going to be a bottomless pit
   because I don't believe for a split second that this simple interface
   is going to be sufficient.

   Aside of that we are definitely _not_ going to expose any of the
   internal functions simply because they evade any sanity check which
   happens at the syscall wrappers and I have zero interest to deal with
   the fallout of unfiltered input which comes via io-uring interfaces
   or try to keep those up to date when the core filtering changes.

2) Adding a waitqueue like callback is daft.

   a) Lifetime rules

      See mark_wake_futex().

   b) Locking

      The wakeup mechanism is designed to avoid hb->lock contention as much
      as possible. The dequeue/mark for wakeup happens under hb->lock
      and the actual wakeup happens after dropping hb->lock.

      This is not going to change. It's not even debatable.

      Aside of that this is optimized for minimal hb->lock hold time in
      general.

   So the only way to do that would be to invoke the callback from
   mark_wake_futex() _before_ invalidating futex_q and the callback plus
   the argument(s) would have to be stored in futex_q.

   Where does this information come from? Which context would invoke the
   wait with callback and callback arguments? User space, io-uring state
   machine or what?

   Aside of the extra storage (on stack) and yet more undefined life
   time rules and no semantics for error cases etc., that also would
   enforce that the callback is invoked with hb->lock held. IOW, it's
   making the hb->lock held time larger, which is exactly what the
   existing code tries to avoid by all means.

But what would that solve?

I can't tell because the provided information is absolutely useless
for anyone not familiar with your great idea:
   
  "Add futex wait requests, those always go through io-wq for
   simplicity."
      
What am I supposed to read out of this? Doing it elsewhere would be
more complex? Really useful information.

And I can't tell either what Jens means here:

  "Not a huge fan of that, I think this should tap into the waitqueue
   instead and just rely on the wakeup callback to trigger the
   event. That would be a lot more efficient than punting to io-wq, both
   in terms of latency on trigger, but also for efficiency if the app is
   waiting on a lot of futexes."

and here:

  "Yes, we'd need to augment that with a callback. I do think that's
   going to be necessary, I don't see the io-wq solution working well
   outside of the most basic of use cases. And even for that, it won't
   be particularly efficient for single waits."

All of these quotes are useless word salad without context and worse
without the minimal understanding how futexes work.

So can you folks please sit down and write up a coherent description of:

 1) The problem you are trying to solve

 2) How this futex functionality should be integrated into io-uring
    including the contexts which invoke it.

 3) Interaction with regular sys_futex() operations.

 4) Lifetime and locking rules.

Unless that materializes any futex related changes are not even going to
be reviewed.

I did not even try to review this stuff, I just tried to make sense out
of it, but while skimming it, it was inevitable to spot this gem:

 +int futex_wake_op_single(u32 __user *uaddr, int nr_wake, unsigned int op,
 +			 bool shared, bool try);
...
 +		ret = futex_wake_op_single(f->uaddr, f->nr_wake, f->wake_op_arg,
 +					   !(f->flags & IORING_FUTEX_SHARED),
 +					   nonblock);

You surely made your point that this is well thought out.

Thanks,

        tglx
