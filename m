Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A4E37212C
	for <lists+io-uring@lfdr.de>; Mon,  3 May 2021 22:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhECUQ2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 16:16:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhECUQ2 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 3 May 2021 16:16:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3B32611AC
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 20:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620072934;
        bh=mP8Y7U43gy2c5RTnca0Wv9xuHE58Zvi51r0OQS2/7/0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=avmp6FZKS+si9oRkKl/vvk04008WSnuDrPtqS7fFY/Hp8cT8mscn2JfnY3/rouno9
         L2kFyCLcQBNKS1kh9nd21PFuC/kXyZ1uge1wbqyA+kjEUEZgnJx0npPm2zmndMdEBV
         thrzn0YPQN230jDVfJO5a/dCWaX6hNfFBZtBWTFT2jwuNRuE/cR0jY4ejH8o8+8v+q
         ryi9dmvInZ8ApsJPlGyRpQkRupK9Tout99v327RXZdc9wDmOMmUdWT47KuG/SCbVf3
         bFJ++wBbJBodw5HLVoHRk76GrcBd1c9/fTUH4dAbFkRXdVO7H/Ygus1agH1tQ1GJYU
         4MWYFbtvYBCbg==
Received: by mail-ej1-f43.google.com with SMTP id m12so9796903eja.2
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 13:15:34 -0700 (PDT)
X-Gm-Message-State: AOAM533uzypntxQRA2Gmi7MrkTi2zqYQQIO1Q2XWEyi00JORjka1VKkd
        AufgkvL5fvtCwk1Ioj5QaaYu8317sMmPX1I8j6Uk4g==
X-Google-Smtp-Source: ABdhPJwTbJtDY0RHqWqeld85iOGmfh83pTkW4GCjicAzfALmyEJlLm4Qk+00oeYg5eGOVDJ7ECshMvfzpVC1wxFikww=
X-Received: by 2002:a17:906:ccc9:: with SMTP id ot9mr5555145ejb.253.1620072933403;
 Mon, 03 May 2021 13:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
In-Reply-To: <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 3 May 2021 13:15:21 -0700
X-Gmail-Original-Message-ID: <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
Message-ID: <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 3, 2021 at 12:15 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> So generally, the IO threads are now 100% normal threads - it's
> literally just that they never return to user space because they are
> always just doing the IO offload on the kernel side.
>
> That part is lovely, but part of the "100% IO threads" really is that
> they share the signal struct too, which in turn means that they very
> much show up as normal threads. Again, not a problem: they really
> _are_ normal threads for all intents and purposes.

I'm a bit confused, though.  All the ptrace register access (AFAICS)
goes through ptrace_check_attach(), which should wait until the tracee
is stopped.  Does the io_uring thread now stop in response to ptrace
stop requests?

>
> But then that (b) issue means that gdb gets confused by them. I
> personally think that's just a pure gdb mis-feature, but I also think
> that "hey, if we just make the register state look like the main
> thread, and unconfuse gdb that way, problem solved".
>
> So I'd actually rather not make these non-special threads any more
> special at all. And I strongly suspect that making ptrace() not work
> on them will just confuse gdb even more - so it would make them just
> unnecessarily special in the kernel, for no actual gain.
>
> Is the right thing to do to fix gdb to not look at irrelevant thread B
> when deciding whether thread A is 64-bit or not? Yeah, that seems like
> obviously the RightThing(tm) to me.
>
> But at the same time, this is arguably about "regression", although at
> the same time it's "gdb doesn't understand new user programs that use
> new features, film at 11", so I think that argument is partly bogus
> too.
>

Fair enough.  But I would really, really rather that gdb starts fixing
its amazingly broken assumptions about bitness.

> So my personal preference would be:
>
>  - make those threads look even more like user threads, even if that
> means giving them pointless user segment data that the threads
> themselves will never use
>
>    So I think Stefan's patch is reasonable, if not pretty. Literally
> becasue of that "make these threads look even more normal"

I think it's reasonable except for the bit about copying the segment
regs.  Can we hardcode __USER_CS, etc, and, when gdb crashes or
otherwise malfunctions for compat programs, we can say that gdb needs
to stop sucking.  In general, I think that piling a bitness hack in
here is a mess, and we're going to have to carry it forward forever
once we do it.

Meanwhile, I am going to put my foot down about one thing: NAK to this
patch until it comes with a selftest.  That selftest needs to test the
cs behavior, but it also needs to read the FPU state from an io_uring
thread, write some FPU state to that thread, and read it back.  And it
needs to not OOPS.  Not breaking ABI is nice and all, but even more
important is not breaking the kernel.

--Andy
