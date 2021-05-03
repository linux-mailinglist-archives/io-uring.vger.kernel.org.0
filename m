Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B109D37216E
	for <lists+io-uring@lfdr.de>; Mon,  3 May 2021 22:38:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhECUjE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 16:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbhECUjE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 16:39:04 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38FBC06174A
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 13:38:10 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id h4so2379420lfv.0
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 13:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ru07+XZDTxwzK4jUGyvNJ8nPyWHzD7JMhamPJRv956w=;
        b=geyUfYKigOBv46IJHm5p8IRjI8P75fuuiW/8dFRm5UxxjsLXKnG0AdA6TEjgX07WUW
         wx4tp76iM+hkxuhi+N3aipTpKG62Qw3bp0MG8Hd6UtnObxbVhLdBGa547sten8YOCRV3
         icqs9/KRl6YDpzKXNaKZb0ZubRI/cyAyWZ6hs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ru07+XZDTxwzK4jUGyvNJ8nPyWHzD7JMhamPJRv956w=;
        b=SIuykUeVem5bAuBchrFkfMSFMUUK/GxnUXJMBmWi1PumMOO3VqcIh+AkMwE/yoZKuF
         KCgMm8JxMSgPLM9pZyoEJyM+boYs2SQDyNbKxHi4lWH5gHtmM070cqIvLTDwpukA0cu+
         zd+OjjpPVAR+su6g9cA6spD73PA+y2DDX2/aLHDhzlAYJY3hzli8LyuMts0Kc1GeeOOn
         MVGGhsAuofEFfNVgubkJZ2FfWUcMcWgTOvAoePwJUW7BzmzdNFT+KeiInuwWyvYSaL1i
         4KJ0/87lyJnx8264zd3MHVlFjAPXbOLZvFXaKjkLhnM7hzfDniiigOCRl2mJjrzXzNeA
         Pv5Q==
X-Gm-Message-State: AOAM531gSBIBpEbM6ej/oieAk0zvGiniR6eqPf99zlGy6I2UmporgPwS
        jkuS5OZ5QoSUFX5cZ69GGZM1Q5Jt4naTAo4JmGA=
X-Google-Smtp-Source: ABdhPJzwNVhSBX8KUJY/whSRFaD4lPX4jjlkDdvYK7YPYC8MMFK9M2bOaRS+AwsMztV121zMNj03rA==
X-Received: by 2002:ac2:528d:: with SMTP id q13mr6051784lfm.73.1620074288422;
        Mon, 03 May 2021 13:38:08 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id d4sm40659lfl.77.2021.05.03.13.38.07
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 13:38:07 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id p12so8490135ljg.1
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 13:38:07 -0700 (PDT)
X-Received: by 2002:a05:651c:33a:: with SMTP id b26mr14791761ljp.220.1620074287361;
 Mon, 03 May 2021 13:38:07 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com> <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
In-Reply-To: <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 May 2021 13:37:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
Message-ID: <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Andy Lutomirski <luto@kernel.org>
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

Yup. They really are 100% regular threads. Things like ^Z and friends
also stop them now, and the freezer freezes them etc.

And making PTRACE_ATTACH fail just causes gdb to fail.

> Fair enough.  But I would really, really rather that gdb starts fixing
> its amazingly broken assumptions about bitness.

"Preach it, Brother"

> >    So I think Stefan's patch is reasonable, if not pretty. Literally
> > becasue of that "make these threads look even more normal"
>
> I think it's reasonable except for the bit about copying the segment
> regs.  Can we hardcode __USER_CS, etc, and, when gdb crashes or
> otherwise malfunctions for compat programs, we can say that gdb needs
> to stop sucking.

So that was actually my initial suggestion. Stefan really does seem to
care about compat programs.

Any "gdb breaks" would be good to motivate people to fix gdb, but the
thing is, presumably nobody actually wants to touch gdb with a ten
foot pole.

And a "let's break gdb to encourage people to fix it" only works if
people actually _do_ fit it. Which doesn't seem to be happening.

Two lines of kernel code seems to be the better option than hoping for
gdb to be fixed.

               Linus
