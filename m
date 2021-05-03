Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782D7372267
	for <lists+io-uring@lfdr.de>; Mon,  3 May 2021 23:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbhECV1H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 17:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhECV1F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 17:27:05 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B8BC061573
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 14:26:12 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id m37so4725197pgb.8
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 14:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XPeMU1gbb2Ouz0+R/qJWXXU61XPTpHJzJYNFXNLpGRA=;
        b=yCaR+DVH5sT8hRYk5O8m8/4/+XRDtTPPQt8QYb8IvpHwl98R7KbLM8Y56nM7f+6uMo
         z8WELQYH2AbDlTTqt0hhkF7HiQmSzX4+BLRBgC5cBMOH7V4M0CxuVwaqlCMq+E3bRn6F
         KmBEtor4deIjLvWflIHRUgumBkdhCBEFxrXaoG2B3SIfGLbadzIZnmsqp8jpdnEUlpcn
         gT0fiQt5N52MerEHJLg50MZXNb13s7lyzN6wAgy9EoVR72VnqnfC8T2j5+QM2nxNr9vL
         AkUMQb/i6CLpkXy38a9KK6Y1rcsns8jvckje1FrotQKTbgDHvm8QZdX9ICDaBu6BwbpQ
         CW1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XPeMU1gbb2Ouz0+R/qJWXXU61XPTpHJzJYNFXNLpGRA=;
        b=pCYuYguFw68nUGJ/QWqMgTZYAj4oNiVlOKqLpB2NYwKtaCszWpEEU9DyTJupxfAuj2
         GQGVYQM/jod/1O2qfWF40sTA1jYbHTTqvI5iF3zx+hbGldQrEFKzC3UfHMwlCSUhKLTG
         RmF5W6FaUTIqfdzJyd/3yzc2fL4NopBgfSCK/I/Qvc+FG5Ye1e6eoyItyRSIM616H3ph
         aj5vwEJZ/a5UrXscoH1X5rR2+s4s/3ankzRyiPvpval+Spm+D/yisDv81cBApTtUMfIJ
         fbr5EA9y6IZU2C0AZaczGvU5s2odtulywN/CnisN0WUejbd9ZwOO3G1Lwa0+Y1N+AQzP
         lghw==
X-Gm-Message-State: AOAM530H1HcmrbXKkYJdEZ80FF573s5owggQsC9vVBFHEkD9T/+EaAtP
        vgfHJgG7aQeVSFfjKbBUQcQO+Q==
X-Google-Smtp-Source: ABdhPJxhw2twyML4nlZAwd5NBONNy16EoM5fy51V7FRjw0k3rqxKk1dhMjSM/3g4ycrtbDi/wsAaCA==
X-Received: by 2002:a17:90a:73c4:: with SMTP id n4mr703803pjk.201.1620077171737;
        Mon, 03 May 2021 14:26:11 -0700 (PDT)
Received: from ?IPv6:2600:380:4b2f:4dc3:5b46:253c:6ea5:c4fe? ([2600:380:4b2f:4dc3:5b46:253c:6ea5:c4fe])
        by smtp.gmail.com with ESMTPSA id 123sm10083664pfx.180.2021.05.03.14.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 14:26:11 -0700 (PDT)
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
 <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk>
Date:   Mon, 3 May 2021 15:26:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/21 2:37 PM, Linus Torvalds wrote:
> On Mon, May 3, 2021 at 1:15 PM Andy Lutomirski <luto@kernel.org> wrote:
>>
>> On Mon, May 3, 2021 at 12:15 PM Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>> So generally, the IO threads are now 100% normal threads - it's
>>> literally just that they never return to user space because they are
>>> always just doing the IO offload on the kernel side.
>>>
>>> That part is lovely, but part of the "100% IO threads" really is that
>>> they share the signal struct too, which in turn means that they very
>>> much show up as normal threads. Again, not a problem: they really
>>> _are_ normal threads for all intents and purposes.
>>
>> I'm a bit confused, though.  All the ptrace register access (AFAICS)
>> goes through ptrace_check_attach(), which should wait until the tracee
>> is stopped.  Does the io_uring thread now stop in response to ptrace
>> stop requests?
> 
> Yup. They really are 100% regular threads. Things like ^Z and friends
> also stop them now, and the freezer freezes them etc.
> 
> And making PTRACE_ATTACH fail just causes gdb to fail.
> 
>> Fair enough.  But I would really, really rather that gdb starts fixing
>> its amazingly broken assumptions about bitness.
> 
> "Preach it, Brother"

That's actually what the original code did, and the "only" problem with
it was that gdb shits itself and just go into an infinite loop trying to
attach. And yes, that's most certainly a gdb bug, and we entertained a
few options for making that work. One was hiding the threads, but nobody
(myself included) liked that, because then we're special casing
something again, and for no other reason than gdb is buggy.

On principle, I think it's arguably the right change to just -EINVAL the
attach. However, a part of me also finds it very annoying that anyone
attempting to debug any program that uses io_uring will not be able to
do so with a buggy gdb. That's regardless of whether or not you want to
look at the io threads or not, or even if you don't care about debugging
the io_uring side of things. And I'm assuming this will take a while to
get fixed, and then even longer to make its way back to distros.

So... You should just make the call. At least then I can just tell
people that Linus made that decision :-)

>>>    So I think Stefan's patch is reasonable, if not pretty. Literally
>>> becasue of that "make these threads look even more normal"
>>
>> I think it's reasonable except for the bit about copying the segment
>> regs.  Can we hardcode __USER_CS, etc, and, when gdb crashes or
>> otherwise malfunctions for compat programs, we can say that gdb needs
>> to stop sucking.
> 
> So that was actually my initial suggestion. Stefan really does seem to
> care about compat programs.
> 
> Any "gdb breaks" would be good to motivate people to fix gdb, but the
> thing is, presumably nobody actually wants to touch gdb with a ten
> foot pole.
> 
> And a "let's break gdb to encourage people to fix it" only works if
> people actually _do_ fit it. Which doesn't seem to be happening.
> 
> Two lines of kernel code seems to be the better option than hoping for
> gdb to be fixed.

As far as I'm concerned, gdb works "well enough" with io threads as it
stands. Yes, it'll complain a bit, but nothing that prevents you from
attaching to a progrem. If we -EINVAL, then gdb will become useless for
debugging a program that uses io_uring. And I'm not holding my breath
while someone fixes that.

-- 
Jens Axboe

