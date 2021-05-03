Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9353722A8
	for <lists+io-uring@lfdr.de>; Mon,  3 May 2021 23:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbhECVuX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 17:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhECVuX (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 3 May 2021 17:50:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A32BC613BB
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 21:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620078569;
        bh=SUobvnxDOcS4NQCxjuHJDoDm7mOu/wNRf2lZIyJtqhY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jzfZ4s4ZvInoL7pl+G0Krxbae1u8JoPDd55ENwWWpGuYcMrPtNPRAh1siK2MmZh+m
         rvPBS/fv1uuas1Lrab3ZopvMWF5BiOHcsj1g0l247HrZ71ynq99i8E9Wxe4walT/vG
         OWOBnQ9IJW+ujkBS34fsh6iTD3CDJ+mflGLmoBSwCKsVdS0oIbKuuxmQfrkdeMFrZJ
         RYGcFEUtbQ1OeRiRHUosIJO7JBuWwlXnylLB56ZcHpLqFsmgCy1Usv5GzLkcGjFPzs
         HWiQY0lM98KLD08aWnyCOApw6texU+WhzD1Q2o1SL+PBUMyNNEnWo5TdmW6isjqFz0
         +wOWxhN/mSC/g==
Received: by mail-ed1-f44.google.com with SMTP id c22so8112726edn.7
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 14:49:29 -0700 (PDT)
X-Gm-Message-State: AOAM533GnperySbZrZPkh8pe1ztcUGosLlv65xgP0aiE9iq+I2QM3FIf
        W6AOvQaHyLYeXXKR/xw/hXRW8fRyARTPScQVgzG57g==
X-Google-Smtp-Source: ABdhPJx3ErDskZSsztMDIoZFd8sfrZCN4xmh9XK89vQ3bPnLFAJmt2bRrb5cX1CucAt6msoeQpK+nlhh7cgseYm11fo=
X-Received: by 2002:a05:6402:3063:: with SMTP id bs3mr22881433edb.84.1620078568184;
 Mon, 03 May 2021 14:49:28 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
 <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com> <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk>
In-Reply-To: <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 3 May 2021 14:49:16 -0700
X-Gmail-Original-Message-ID: <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
Message-ID: <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 3, 2021 at 2:26 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 5/3/21 2:37 PM, Linus Torvalds wrote:
> > On Mon, May 3, 2021 at 1:15 PM Andy Lutomirski <luto@kernel.org> wrote:
> >>
> >> On Mon, May 3, 2021 at 12:15 PM Linus Torvalds
> >> <torvalds@linux-foundation.org> wrote:
> >>> So generally, the IO threads are now 100% normal threads - it's
> >>> literally just that they never return to user space because they are
> >>> always just doing the IO offload on the kernel side.
> >>>
> >>> That part is lovely, but part of the "100% IO threads" really is that
> >>> they share the signal struct too, which in turn means that they very
> >>> much show up as normal threads. Again, not a problem: they really
> >>> _are_ normal threads for all intents and purposes.
> >>
> >> I'm a bit confused, though.  All the ptrace register access (AFAICS)
> >> goes through ptrace_check_attach(), which should wait until the tracee
> >> is stopped.  Does the io_uring thread now stop in response to ptrace
> >> stop requests?
> >
> > Yup. They really are 100% regular threads. Things like ^Z and friends
> > also stop them now, and the freezer freezes them etc.
> >
> > And making PTRACE_ATTACH fail just causes gdb to fail.
> >
> >> Fair enough.  But I would really, really rather that gdb starts fixing
> >> its amazingly broken assumptions about bitness.
> >
> > "Preach it, Brother"
>
> That's actually what the original code did, and the "only" problem with
> it was that gdb shits itself and just go into an infinite loop trying to
> attach. And yes, that's most certainly a gdb bug, and we entertained a
> few options for making that work. One was hiding the threads, but nobody
> (myself included) liked that, because then we're special casing
> something again, and for no other reason than gdb is buggy.
>
> On principle, I think it's arguably the right change to just -EINVAL the
> attach. However, a part of me also finds it very annoying that anyone
> attempting to debug any program that uses io_uring will not be able to
> do so with a buggy gdb. That's regardless of whether or not you want to
> look at the io threads or not, or even if you don't care about debugging
> the io_uring side of things. And I'm assuming this will take a while to
> get fixed, and then even longer to make its way back to distros.
>
> So... You should just make the call. At least then I can just tell
> people that Linus made that decision :-)
>
> >>>    So I think Stefan's patch is reasonable, if not pretty. Literally
> >>> becasue of that "make these threads look even more normal"
> >>
> >> I think it's reasonable except for the bit about copying the segment
> >> regs.  Can we hardcode __USER_CS, etc, and, when gdb crashes or
> >> otherwise malfunctions for compat programs, we can say that gdb needs
> >> to stop sucking.
> >
> > So that was actually my initial suggestion. Stefan really does seem to
> > care about compat programs.
> >
> > Any "gdb breaks" would be good to motivate people to fix gdb, but the
> > thing is, presumably nobody actually wants to touch gdb with a ten
> > foot pole.
> >
> > And a "let's break gdb to encourage people to fix it" only works if
> > people actually _do_ fit it. Which doesn't seem to be happening.
> >
> > Two lines of kernel code seems to be the better option than hoping for
> > gdb to be fixed.
>
> As far as I'm concerned, gdb works "well enough" with io threads as it
> stands. Yes, it'll complain a bit, but nothing that prevents you from
> attaching to a progrem. If we -EINVAL, then gdb will become useless for
> debugging a program that uses io_uring. And I'm not holding my breath
> while someone fixes that.

To be clear, I'm suggesting that we -EINVAL the PTRACE_GETREGS calls
and such, not the ATTACH.  I have no idea what gdb will do if this
happens, though.

--Andy
