Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 608E9372136
	for <lists+io-uring@lfdr.de>; Mon,  3 May 2021 22:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhECUWX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 16:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55675 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhECUWX (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 3 May 2021 16:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA955611C0
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 20:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620073289;
        bh=NFIMJkSJ9Cg2dqp0sEV+wPubHyrbBZCbTXsgOucpTMw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IkQQITYW8SotPICyZA/EYv4zYym5H+6PpbVAxQm+aID7HO1xResaX7RLkHksNo+jA
         5h4RRIRsKR/oVfgvyh3KOmR0uvyizeOpviRjnn5Yfk1xFv33ziKUudsIaMecnQOpqV
         X/Y51QwoKBP9xiW65zZilAZfRLnxV9IMZfcKS/1gXaqvX9lW7sX/vi58cLsI4Gvi2u
         tID6OPZHI3B1xILphZWa3envS5Riu190QhblTZK+xpmth15oYNlHIx9odUx25bR8Ut
         nA7Z0ThqzbkRrU9rRPbzgWSV9JUyTjyZmR3f5GR2dc6VIeweN88ZxJ9e02wXdblE/2
         BBlUu14LFtjuA==
Received: by mail-ed1-f46.google.com with SMTP id h10so7803965edt.13
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 13:21:29 -0700 (PDT)
X-Gm-Message-State: AOAM530r07jfyYC+YguJo2N5BSpUj6F0GugVbNZt15fYPPCrT8+A9prQ
        /pukVBf31emRZVUWT8Iyc5nCph1HCw6R7GsZ5fg2Tw==
X-Google-Smtp-Source: ABdhPJyZWCDJIbN/CtDpdv0HAIBCgFmQL7I18QRepBZATTVqoZao1qD7TGnmsbOfEbv9C4EuLZiXLjD/nRn1Y6Z+5/c=
X-Received: by 2002:a05:6402:cac:: with SMTP id cn12mr12237128edb.238.1620073288337;
 Mon, 03 May 2021 13:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com> <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
In-Reply-To: <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 3 May 2021 13:21:17 -0700
X-Gmail-Original-Message-ID: <CALCETrU+f346HXbQAVZ9+hK9SxOy0O_37erBKMis+LGXtgDexw@mail.gmail.com>
Message-ID: <CALCETrU+f346HXbQAVZ9+hK9SxOy0O_37erBKMis+LGXtgDexw@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Metzmacher <metze@samba.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 3, 2021 at 1:15 PM Andy Lutomirski <luto@kernel.org> wrote:
>
> On Mon, May 3, 2021 at 12:15 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > So generally, the IO threads are now 100% normal threads - it's
> > literally just that they never return to user space because they are
> > always just doing the IO offload on the kernel side.
> >
> > That part is lovely, but part of the "100% IO threads" really is that
> > they share the signal struct too, which in turn means that they very
> > much show up as normal threads. Again, not a problem: they really
> > _are_ normal threads for all intents and purposes.
>
> I'm a bit confused, though.  All the ptrace register access (AFAICS)
> goes through ptrace_check_attach(), which should wait until the tracee
> is stopped.  Does the io_uring thread now stop in response to ptrace
> stop requests?
>
> >
> > But then that (b) issue means that gdb gets confused by them. I
> > personally think that's just a pure gdb mis-feature, but I also think
> > that "hey, if we just make the register state look like the main
> > thread, and unconfuse gdb that way, problem solved".
> >
> > So I'd actually rather not make these non-special threads any more
> > special at all. And I strongly suspect that making ptrace() not work
> > on them will just confuse gdb even more - so it would make them just
> > unnecessarily special in the kernel, for no actual gain.
> >
> > Is the right thing to do to fix gdb to not look at irrelevant thread B
> > when deciding whether thread A is 64-bit or not? Yeah, that seems like
> > obviously the RightThing(tm) to me.
> >
> > But at the same time, this is arguably about "regression", although at
> > the same time it's "gdb doesn't understand new user programs that use
> > new features, film at 11", so I think that argument is partly bogus
> > too.
> >
>
> Fair enough.  But I would really, really rather that gdb starts fixing
> its amazingly broken assumptions about bitness.
>
> > So my personal preference would be:
> >
> >  - make those threads look even more like user threads, even if that
> > means giving them pointless user segment data that the threads
> > themselves will never use
> >
> >    So I think Stefan's patch is reasonable, if not pretty. Literally
> > becasue of that "make these threads look even more normal"
>
> I think it's reasonable except for the bit about copying the segment
> regs.  Can we hardcode __USER_CS, etc, and, when gdb crashes or
> otherwise malfunctions for compat programs, we can say that gdb needs
> to stop sucking.  In general, I think that piling a bitness hack in
> here is a mess, and we're going to have to carry it forward forever
> once we do it.

Actually... if we have your permission, I'd rather do the -EINVAL
thing.  Arguably, if gdb breaks cleanly, that's a win.  This only
affects programs using io_uring, it avoids a kludge, and hopefully it
will encourage gdb to fix their bug.  May we do that instead?

--Andy
