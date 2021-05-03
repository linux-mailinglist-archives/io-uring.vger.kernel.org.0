Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88C83372032
	for <lists+io-uring@lfdr.de>; Mon,  3 May 2021 21:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhECTP7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 15:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhECTP6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 15:15:58 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2F55C061763
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 12:15:04 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id t11so8174958lfl.11
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 12:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DJgGJrhwcoXrsNcVH65EW460hiZlG/3mKr+mdPOmwaw=;
        b=ArDk/eaTr/kkGPFcCpYEZajWO44RCaJKH+b1o8EmM7AOse5072yHZueMMaZddHBEnS
         A5iloy12/uJTSVmwqhy055betI76iDhJU5q8HcIwb7G7UL1xNcYXTgKGds2bT/19oj1v
         Oedxt59dlIocQemrVIAYfAwn8vmTHkIvto8Uo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DJgGJrhwcoXrsNcVH65EW460hiZlG/3mKr+mdPOmwaw=;
        b=snoN4mjxiYMr9JspedljsKSv6MhqPrXNlwkbFigfLbLJLCAFzmXCJQ9ERgx4Mjlh2e
         2/5v0xwtGoQG+0Nxkxo7+Fu6Z04T21aZbZTmRKponFIwswUJi3h9CPnQ6bl57cfp0A4S
         Fnkt/eEHzWoZevRM9KarREeyMOQzh0czk7XE70DOFEEOkaMO7xAbKNEuP4TvlFQcOUYX
         CduFx3hascVYT79QMYsd+OgDfltmijjfGCiN4EOaGPfMZ5jqw/3EHjgsx86isSYQZ4Vj
         ph53oOJG2Z0zT+rIL3SMSjSBJuwz68W8A5P12DO+ag4IL66/YOQTWDijwsMx2ADMA4a6
         13YQ==
X-Gm-Message-State: AOAM531d8gzKp11Z5YsGI4r40hsEnUCSiU2aMSkuhDyIi1ghHXPdblYt
        NoV5qqDyORHENe+72ynHwcmo5drWey0abSHjBLs=
X-Google-Smtp-Source: ABdhPJyDlYrAECmvqW72mJuKDRu0mZnaJoRXxpapnicqHxRYMvG/HH97+7PSwKmbqsYLchNerk5Pzg==
X-Received: by 2002:a05:6512:3f93:: with SMTP id x19mr14095141lfa.182.1620069302797;
        Mon, 03 May 2021 12:15:02 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id o20sm43912lfu.283.2021.05.03.12.15.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 12:15:02 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id u20so8130217lja.13
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 12:15:01 -0700 (PDT)
X-Received: by 2002:a2e:9251:: with SMTP id v17mr666578ljg.507.1620069301472;
 Mon, 03 May 2021 12:15:01 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
In-Reply-To: <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 May 2021 12:14:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
Message-ID: <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Andy Lutomirski <luto@amacapital.net>
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

On Mon, May 3, 2021 at 9:05 AM Andy Lutomirski <luto@amacapital.net> wrote:
>
> Linus, what is the actual effect of allowing gdb to attach these threads?  Can we instead make all the regset ops do:
>
> if (not actually a user thread) return -EINVAL;

I don't think it matters - the end result ends up  being the same, ie
gdb gets confused about whether the (parent) thread is a 32-bit or
64-bit one.

So the basic issue is

 (a) we want the IO threads to look exactly like normal user threads
as far as the kernel is concerned, because we had way too many bugs
due to special cases.

 (b) but that means that they are also visible to user space, and then
gdb has this odd thing where it takes the 64-bit vs 32-bit data for
the whole process from one thread, and picks the worst possible thread
to do it (ie explicitly not even the main thread, so usually the IO
thread!)

That (a) ended up really being critical. The issues with special cases
were just horrendous, both for security issues (ie "make them kernel
threads but carry user credentials" just caused lots of problems) but
also for various just random other state handling issues (signal state
in particular).

So generally, the IO threads are now 100% normal threads - it's
literally just that they never return to user space because they are
always just doing the IO offload on the kernel side.

That part is lovely, but part of the "100% IO threads" really is that
they share the signal struct too, which in turn means that they very
much show up as normal threads. Again, not a problem: they really
_are_ normal threads for all intents and purposes.

But then that (b) issue means that gdb gets confused by them. I
personally think that's just a pure gdb mis-feature, but I also think
that "hey, if we just make the register state look like the main
thread, and unconfuse gdb that way, problem solved".

So I'd actually rather not make these non-special threads any more
special at all. And I strongly suspect that making ptrace() not work
on them will just confuse gdb even more - so it would make them just
unnecessarily special in the kernel, for no actual gain.

Is the right thing to do to fix gdb to not look at irrelevant thread B
when deciding whether thread A is 64-bit or not? Yeah, that seems like
obviously the RightThing(tm) to me.

But at the same time, this is arguably about "regression", although at
the same time it's "gdb doesn't understand new user programs that use
new features, film at 11", so I think that argument is partly bogus
too.

So my personal preference would be:

 - make those threads look even more like user threads, even if that
means giving them pointless user segment data that the threads
themselves will never use

   So I think Stefan's patch is reasonable, if not pretty. Literally
becasue of that "make these threads look even more normal"

 - ALSO fix gdb that is doing obviously garbage stupid things

But I'm obviously not involved in that "ALSO fix gdb" part, and
arguably the kernel hack then makes it more likely that gdb will
continue doing its insane broken thing.

             Linus
