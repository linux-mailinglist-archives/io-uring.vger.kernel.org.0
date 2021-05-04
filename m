Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF7B3723C2
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 02:02:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhEDACw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 20:02:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:37752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229499AbhEDACw (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 3 May 2021 20:02:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22318610E6
        for <io-uring@vger.kernel.org>; Tue,  4 May 2021 00:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620086518;
        bh=IKpKf7PhC4k2UZheSYL1fEwwAl2gFqXtlCWhSayr0sY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Qawfd1SE7EDaQtWrx5lNXQlaa6e/mPEldFfkFRDevH8IcTz5YkOYjCK1/JyZI4UkB
         crpWEcIDIcqWcNLrvE0D/VGYJLuREY4B3/jHr/4xgs1gLwNwf1wOC5W7JJ+aeLolEi
         lOOfYejUhkHXocyB3LNG8KBFKDF4UFUQaA9xW9RNZHYIoMglM/B4ubR5LBSB/9nxGC
         /1js7N+YgjlYKzBQ63S3GL43xYlPDZL12QkgqjJVFlP8DfswEllWCTmcyUorv2VB8t
         WoC3SMhWbW6gCwK6OYY47ABF4d97KhDZnJRqqoMGGf7mLsucExFdqDmR8Y3z9Rv/An
         sxmlML8xUY3SA==
Received: by mail-ej1-f52.google.com with SMTP id r9so10444144ejj.3
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 17:01:58 -0700 (PDT)
X-Gm-Message-State: AOAM530Y5oCdERsKd3Swd967xgXVRiXW60Pay4HP/BRYi6A3QRY/Me2l
        YKsCUq6mMjE0KrnkCrGOvNxBCZEklFRI9aMm2C3Grg==
X-Google-Smtp-Source: ABdhPJwBn8JeNuxiPtZcB6RVcrwDaqmLIJBExddckI7Y2zSt42SGvalk9nv7cMZmnP7w5qND43ZrGzZSHhcr/YmRkkg=
X-Received: by 2002:a17:906:4f91:: with SMTP id o17mr18944005eju.503.1620086516574;
 Mon, 03 May 2021 17:01:56 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
 <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
 <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk> <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
 <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com>
 <8735v3jujv.ffs@nanos.tec.linutronix.de> <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
In-Reply-To: <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 3 May 2021 17:01:45 -0700
X-Gmail-Original-Message-ID: <CALCETrXW4BxhXt5AhW9-kOOqtz7O9cHtCsMNg7UWcAuS5HBB8Q@mail.gmail.com>
Message-ID: <CALCETrXW4BxhXt5AhW9-kOOqtz7O9cHtCsMNg7UWcAuS5HBB8Q@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 3, 2021 at 4:16 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Mon, May 3, 2021 at 3:56 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > It's all fine that we have lots of blurb about GDB, but there is no
> > reasoning why this does not affect regular kernel threads which take the
> > same code path.
>
> Actual kernel threads don't get attached to by ptrace.
>
> > This is a half setup user space thread which is assumed to behave like a
> > regular kernel thread, but is this assumption actually true?
>
> No, no.
>
> It's a *fully set up USER thread*.
>
> Those IO threads used to be kernel threads. That didn't work out for
> the reasons already mentioned earlier.
>
> These days they really are fully regular user threads, they just don't
> return to user space because they continue to do the IO work that they
> were created for.
>
> Maybe instead of Stefan's patch, we could do something like this:
>
>    diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
>    index 43cbfc84153a..890f3992e781 100644
>    --- a/arch/x86/kernel/process.c
>    +++ b/arch/x86/kernel/process.c
>    @@ -156,7 +156,7 @@ int copy_thread(unsigned long clone_flags,
> unsigned long sp, unsigned long arg,
>     #endif
>
>         /* Kernel thread ? */
>    -    if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
>    +    if (unlikely(p->flags & PF_KTHREAD)) {
>                 memset(childregs, 0, sizeof(struct pt_regs));
>                 kthread_frame_init(frame, sp, arg);
>                 return 0;
>    @@ -168,6 +168,17 @@ int copy_thread(unsigned long clone_flags,
> unsigned long sp, unsigned long arg,
>         if (sp)
>                 childregs->sp = sp;
>
>    +    /*
>    +     * An IO thread is a user space thread, but it doesn't
>    +     * return to ret_after_fork(), it does the same kernel
>    +     * frame setup to return to a kernel function that
>    +     * a kernel thread does.
>    +     */
>    +    if (unlikely(p->flags & PF_IO_WORKER)) {
>    +            kthread_frame_init(frame, sp, arg);
>    +            return 0;
>    +    }
>    +
>     #ifdef CONFIG_X86_32
>         task_user_gs(p) = get_user_gs(current_pt_regs());
>     #endif
>
> does that clarify things and make people happier?
>
> Maybe the compiler might even notice that the
>
>                 kthread_frame_init(frame, sp, arg);
>                 return 0;
>
> part is common code and then it will result in less generated code too.
>
> NOTE! The above is - as usual - COMPLETELY UNTESTED. It looks obvious
> enough, and it builds cleanly. But that's all I'm going to guarantee.
>
> It's whitespace-damaged on purpose.

I like this patch considerably more than I liked the previous patch.

FWIW, I have this fixlet sitting around:

https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/commit/?h=x86/kentry&id=1eef07ae5b236112c9a0c5d880d7f9bb13e73761

Your patch fixes the same bug for the specific case of io_uring.
