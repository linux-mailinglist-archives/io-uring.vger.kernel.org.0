Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299EA37234A
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 00:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbhECW5Q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 18:57:16 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:50332 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229594AbhECW5Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 18:57:16 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620082581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B84p/IJYuwcwlUo5VV9baLC5gQPtbfpdB7bWr7TSjiE=;
        b=wNo43GJ1Ca/eA1VjnpMc6U+NfvyAQmFCt1seHkbQgNw/rZNzGZCYq7b1tJiFxaTHqBjWsg
        dT1Be8HRs8Ma89lW8646O6sFmUEEdUNU3hCMpsfMd2hq0MZERdbFVEF5vJKO1+jMpl8StQ
        AbwO9J7Vs0mjVuyNCYKa9vED4ZhLlm1iA4oZTbz1xK/rQo1tGsQGEhxh1anEg6UEytPuIY
        fOdYre4a0J+pb9xzs5qPM6CcAYVVsn0WGZlRtEAIvhoeKyG2EkOEoJzUJl/WWLBReWvXdb
        HNYaBCJ8qc3G/wdwwdegB/SqNXe8lZe+nRpL74XuLeXLMfscAX0N3oUM20jXTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620082581;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B84p/IJYuwcwlUo5VV9baLC5gQPtbfpdB7bWr7TSjiE=;
        b=lfgn04cVVhb7f9uTX9owNgFOmING8neTfDqK30SwQmJqQKmKa4bBmG3B+3uqHqyO1gQpqc
        tYaGIEVGogBnQjAw==
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es' registers for io_threads
In-Reply-To: <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net> <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com> <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com> <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com> <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk> <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com> <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com>
Date:   Tue, 04 May 2021 00:56:20 +0200
Message-ID: <8735v3jujv.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 03 2021 at 15:08, Linus Torvalds wrote:
> On Mon, May 3, 2021 at 2:49 PM Andy Lutomirski <luto@kernel.org> wrote:
>>
>> To be clear, I'm suggesting that we -EINVAL the PTRACE_GETREGS calls
>> and such, not the ATTACH.  I have no idea what gdb will do if this
>> happens, though.
>
> I feel like the likelihood that it will make gdb work any better is
> basically zero.
>
> I think we should just do Stefan's patch - I assume it generates
> something like four instructions (two loads, two stores) on x86-64,
> and it "just works".
>
> Yeah, yeah, it presumably generates 8 instructions on 32-bit x86, and
> we could fix that by just using the constant __USER_CS/DS instead (no
> loads necessary) since 32-bit doesn't have any compat issues.
>
> But is it worth complicating the patch for a couple of instructions in
> a non-critical path?
>
> And I don't see anybody stepping up to say "yes, I will do the patch
> for gdb", so I really think the least pain is to just take the very
> straightforward and tested kernel patch.
>
> Yes, yes, that also means admitting to ourselves that the gdb
> situation isn't likely going to improve, but hey, if nobody in this
> thread is willing to work on the gdb side to fix the known issues
> there, isn't that the honest thing to do anyway?

GDB is one thing. But is this setup actually correct under all
circumstances?

It's all fine that we have lots of blurb about GDB, but there is no
reasoning why this does not affect regular kernel threads which take the
same code path.

Neither is there an answer what happens in case of a signal delivered to
this thread and what any other GDB/ptraced induced poking might cause.

This is a half setup user space thread which is assumed to behave like a
regular kernel thread, but is this assumption actually true?

Thanks,

        tglx
