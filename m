Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A637D399EF8
	for <lists+io-uring@lfdr.de>; Thu,  3 Jun 2021 12:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhFCKdY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 3 Jun 2021 06:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFCKdX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 3 Jun 2021 06:33:23 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FE2C06174A;
        Thu,  3 Jun 2021 03:31:23 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g18so4501583edq.8;
        Thu, 03 Jun 2021 03:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TaY/KShKKe6WZ0j3eo7DrAFLRKXuUVMzTxqu38vt8I0=;
        b=mDehyLCy6q3kRZsDFNaw+L45nU+MQwf96ZUS/F+BISvL+QXKYkKJV2AasQaCzEJ2j9
         vfRXdrKZhVy+BGVrRXv0in/yr28dBwB284JQrktqdRaWx71Vgy/RxkPoGCf7HUmfDwYk
         g5fBd8G2UoTgSCg8eHBUVpu4UODFyHIfyWsnyPY0w0jiG/UasURlNEt9rpiypUrpxf93
         qSZuK6LzNDHi7Tz9S3dhhYrmGsY/cR2riVR1VvvSj6yD30a99UZ3EdXphADrhWgfx4wq
         sTFsGptMiobOL9XWlXCY3RrFh8BIapCjGm6zl8rqvKqvutGxa0DCRxrW+R/zzcWOqBoH
         lslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TaY/KShKKe6WZ0j3eo7DrAFLRKXuUVMzTxqu38vt8I0=;
        b=g6dufRmyqCoYsqNOxtwmaEOg31SsT22ArLOJZV2+wq9VT8LcxqmE/drpZE51eSfL6a
         H6IEd11AGwq4CyHGlt8tPYJsWjxi+3oksAbR7rECeLOVS6Iyxh6jzDoSLE2BBwWdFXd6
         BjjVkE6/cK1MnW1CUSkC1Gg1TO2l9/k90MiKjrPvb3ai7r5sWsWFyGrzWgejKlmdsvG1
         sNGY2SJ5vO5U42yJ+0+YiJcJ2pZc6afdmhaew3vC8EacPlbLntyKA1a7Hg1IAdwLxwGP
         iToJ54DWyuYB+Vmuob1/UbN26lcEUd0DwyMb/Jvp8kuhGSNZ76cjpG/3JPjgywoc61Bu
         gTzQ==
X-Gm-Message-State: AOAM532VvslVI7nxHDaSU0lv80Qwj9HICq2SFJB5rLBWXiq3B7eTP1q6
        Fre5xXkQTJWwLxedSN9nAymnQLkdAOzW0JFD
X-Google-Smtp-Source: ABdhPJxLiUJCfbNOq6BI3F8rCKIg2VJOjp0niuiWyT5VTp+vjYmEeV++EItVTMZED+58GMbTQUTGpQ==
X-Received: by 2002:a50:cb8a:: with SMTP id k10mr5026396edi.267.1622716281589;
        Thu, 03 Jun 2021 03:31:21 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c093:600::2:6c45])
        by smtp.gmail.com with ESMTPSA id m12sm1526880edc.40.2021.06.03.03.31.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 03:31:21 -0700 (PDT)
To:     Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org
Cc:     Andres Freund <andres@anarazel.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        linux-kernel@vger.kernel.org
References: <cover.1622558659.git.asml.silence@gmail.com>
 <e91af9d8f8d6e376635005fd111e9fe7a1c50fea.1622558659.git.asml.silence@gmail.com>
 <bd824ec8-48af-b554-67a1-7ce20fcf608c@kernel.dk>
 <409a624c-de75-0ee5-b65f-ee09fff34809@gmail.com>
 <bdc55fcd-b172-def4-4788-8bf808ccf6d6@kernel.dk>
 <5ab4c8bd-3e82-e87b-1ae8-3b32ced72009@gmail.com>
 <87sg211ccj.ffs@nanos.tec.linutronix.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC 4/4] io_uring: implement futex wait
Message-ID: <30bdf12c-6287-4c13-920c-bb5cc6ac02bf@gmail.com>
Date:   Thu, 3 Jun 2021 11:31:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87sg211ccj.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/1/21 10:53 PM, Thomas Gleixner wrote:
> Pavel, Jens,
> 
> On Tue, Jun 01 2021 at 17:29, Pavel Begunkov wrote:
>> On 6/1/21 5:01 PM, Jens Axboe wrote:
>>>> Yes, that would be preferable, but looks futexes don't use
>>>> waitqueues but some manual enqueuing into a plist_node, see
>>>> futex_wait_queue_me() or mark_wake_futex().
>>>> Did I miss it somewhere?
>>>
>>> Yes, we'd need to augment that with a callback. I do think that's going
>>
>> Yeah, that was the first idea, but it's also more intrusive for the
>> futex codebase. Can be piled on top for next revision of patches.
>>
>> A question to futex maintainers, how much resistance to merging
>> something like that I may expect?
> 
> Adding a waitqueue like callback or the proposed thing?
> 
> TBH. Neither one has a charm.
> 
> 1) The proposed solution: I can't figure out from the changelogs or the
>    cover letter what kind of problems it solves and what the exact
>    semantics are. If you ever consider to submit futex patches, may I
>    recommend to study Documentation/process and get some inspiration
>    from git-log?

I'm sorry you're incapable of grasping ideas quick, but may we
stop this stupid galling and switch to a more productive way of
speaking?

>    What are the lifetime rules, what's the interaction with regular>    futexes, what's the interaction with robust list ....? Without

Robust lists are not supported, neither they are mentioned to be.

>    interaction with regular futexes such a functionality does not make
>    any sense at all.

Would have not touched futex code if it was not interoperable.

 
>    Also once we'd open that can of worms where is this going to end and
>    where can we draw the line? This is going to be a bottomless pit
>    because I don't believe for a split second that this simple interface
>    is going to be sufficient.
> 
>    Aside of that we are definitely _not_ going to expose any of the
>    internal functions simply because they evade any sanity check which
>    happens at the syscall wrappers and I have zero interest to deal with
>    the fallout of unfiltered input which comes via io-uring interfaces
>    or try to keep those up to date when the core filtering changes.
> 
> 2) Adding a waitqueue like callback is daft.
> 
>    a) Lifetime rules
> 
>       See mark_wake_futex().
> 
>    b) Locking
> 
>       The wakeup mechanism is designed to avoid hb->lock contention as much
>       as possible. The dequeue/mark for wakeup happens under hb->lock
>       and the actual wakeup happens after dropping hb->lock.
> 
>       This is not going to change. It's not even debatable.
> 
>       Aside of that this is optimized for minimal hb->lock hold time in
>       general.
> 
>    So the only way to do that would be to invoke the callback from
>    mark_wake_futex() _before_ invalidating futex_q and the callback plus
>    the argument(s) would have to be stored in futex_q.
> 
>    Where does this information come from? Which context would invoke the
>    wait with callback and callback arguments? User space, io-uring state
>    machine or what?
> 
>    Aside of the extra storage (on stack) and yet more undefined life
>    time rules and no semantics for error cases etc., that also would
>    enforce that the callback is invoked with hb->lock held. IOW, it's
>    making the hb->lock held time larger, which is exactly what the
>    existing code tries to avoid by all means.
> 
> But what would that solve?
> 
> I can't tell because the provided information is absolutely useless
> for anyone not familiar with your great idea:
>    
>   "Add futex wait requests, those always go through io-wq for
>    simplicity."
>       
> What am I supposed to read out of this? Doing it elsewhere would be
> more complex? Really useful information.

It's io_uring specific, I'd rather assume this information should
be irrelevant for you, but you're welcome to look at io_uring/io-wq
if of any interest.


> And I can't tell either what Jens means here:
> 
>   "Not a huge fan of that, I think this should tap into the waitqueue
>    instead and just rely on the wakeup callback to trigger the
>    event. That would be a lot more efficient than punting to io-wq, both
>    in terms of latency on trigger, but also for efficiency if the app is
>    waiting on a lot of futexes."
> 
> and here:
> 
>   "Yes, we'd need to augment that with a callback. I do think that's
>    going to be necessary, I don't see the io-wq solution working well
>    outside of the most basic of use cases. And even for that, it won't
>    be particularly efficient for single waits."
> 
> All of these quotes are useless word salad without context and worse

Same, it's weird to assume that there won't be io_uring specific parts
and discussions.

> without the minimal understanding how futexes work.

> So can you folks please sit down and write up a coherent description of:
> 
>  1) The problem you are trying to solve

1. allowing to use futex from io_uring without extra context switches,
which is the case if we would have a request doing futex operations.

2. having async futexes in general, again handled by io_uring.
And if I get if right, interaction b/w futexes and other primitives
is limited. Is it? io_uring naturally allows to pass notify eventfd,
via some other read/write mechanism and so on, as per this series.

3. maybe .net would be interested in it as a half-baked solution
for their wait many problem. However, I haven't heard long about it.

4. To use futexes as a synchronisation for io_uring-bpf requests.
Won't be called from a bpf program, but bpf may be responsible for
doing memory modifications and then only a simple wake will be
needed instead of an *op version. But that's orthogonal

> 
>  2) How this futex functionality should be integrated into io-uring
>     including the contexts which invoke it.

If we're not talking about the callback stuff, it's always invoked from
a context of a user task or a worker task that looks almost exactly like
a normal user thread.

>  3) Interaction with regular sys_futex() operations.

Think of it as passing a request to make a sys_futex() call. Any
happens-before / acquire-release is propagated via io_uring submissions
and completions.

Is there some dependency on syscalling itself? E.g. in terms of
synchronisation. I don't think so, but better to clear it up if
you're concerned.

>  4) Lifetime and locking rules.

For the locking, there is only one extra io_uring specific mutex
under which it may happen. Do you think it may be a problem?

Lifetime of what exactly? In any case it may be trickier with
callbacks, e.g. considering futex_exit_release() and so on, but
currently it's just called by one of tasks that die as any other
normal task.

> Unless that materializes any futex related changes are not even going to
> be reviewed.
> 
> I did not even try to review this stuff, I just tried to make sense out
> of it, but while skimming it, it was inevitable to spot this gem:
> 
>  +int futex_wake_op_single(u32 __user *uaddr, int nr_wake, unsigned int op,
>  +			 bool shared, bool try);
> ...
>  +		ret = futex_wake_op_single(f->uaddr, f->nr_wake, f->wake_op_arg,
>  +					   !(f->flags & IORING_FUTEX_SHARED),
>  +					   nonblock);
> 
> You surely made your point that this is well thought out.

Specifically? I may tell what I don't like

1) it being a rather internal helper. Other options I had are
to go through do_futex(FUTEX_WAKE_OP), but I don't see why
io_uring would need two addresses as a default operation,
though open to suggestions and clue bats. Either to add a
new futex opcode doing same thing as this function and
again call do_futex().

2) flags, but I didn't want to export internal futex flags,
especially as it may be not the way to go in the first place.

3) naming. Suggestions?

However, that's exactly the reason why it's an RFC. Would
be stupid rehearsing it if there are deeper problems

-- 
Pavel Begunkov
