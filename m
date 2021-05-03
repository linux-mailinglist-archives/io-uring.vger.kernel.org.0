Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3801F37237B
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 01:16:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhECXRb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 19:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbhECXRb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 19:17:31 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2727DC06174A
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 16:16:37 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id x20so10544154lfu.6
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 16:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z9KOFf1NZVdQnIit6tiPPrEtDnkQyMpuOTw2ZsjIy58=;
        b=dFwm+qXIxzZW5CfweYRXpu8xapkcLiDD1oOidHs9QY+jXkveW3cLyH1u4aVHDQr4Bk
         U8HCyzhqKwEEmkASOfFuFnXNPq6X4OoiHSDosf9thWu11tr/pT1gLTndYp46+x/joSpz
         8uE2SkLCDxu5zsxVEihDBIFAuYcCNygUrWjNc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z9KOFf1NZVdQnIit6tiPPrEtDnkQyMpuOTw2ZsjIy58=;
        b=Ni7ufggD1jpP8s8FRTpfcKEJTdYk1+rUccP7uOH0/kE/fGGAgmV+Dv+1mDYu5sgh6T
         5CJj6a/cnFlY+tZi+YOTwK+T/v4YB2eVDh0xzJgBLR1cAjwKNUejC8fd23zInt+FEHkv
         2oa7keX0gjD2WxluY3fITBq++uz/FcAVI4a8Bi5mqjIK8WPqI4DgmTxhXVw2Dm73G1QP
         8LtIKORXrya92fqeLoc+vNqKBXB9pT3O4Kt0VhgNRrMXBE+0/BpaNj5GO4N6+jFXFwLM
         d7m6B0ugxWR7wvTPpnoN8cSHvZ/0zvQcBTkB1C+LB4LvwcDyfZ8UyueBgrKjr+8LKo16
         njjA==
X-Gm-Message-State: AOAM533m+b1ew8ot5iKBucAGlBBvLkzN/EyKvdzzsVzso/ovq+tAQu2X
        U/mCBl3Tc5C2DFF4gKMvYC6TTM0ZjZ0KIr8S
X-Google-Smtp-Source: ABdhPJymYlhwTuL/DvqemKQdv2JgWspnW+a/7i1/FOsY3adEGRD/BpExzFarjo2tEcl4F134ydgKeA==
X-Received: by 2002:a05:6512:3094:: with SMTP id z20mr15179186lfd.354.1620083794991;
        Mon, 03 May 2021 16:16:34 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id e26sm409613ljl.81.2021.05.03.16.16.34
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 16:16:34 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id v6so8899009ljj.5
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 16:16:34 -0700 (PDT)
X-Received: by 2002:a2e:9251:: with SMTP id v17mr1317895ljg.507.1620083793861;
 Mon, 03 May 2021 16:16:33 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
 <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
 <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk> <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
 <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com> <8735v3jujv.ffs@nanos.tec.linutronix.de>
In-Reply-To: <8735v3jujv.ffs@nanos.tec.linutronix.de>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 May 2021 16:16:17 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
Message-ID: <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Stefan Metzmacher <metze@samba.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 3, 2021 at 3:56 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> It's all fine that we have lots of blurb about GDB, but there is no
> reasoning why this does not affect regular kernel threads which take the
> same code path.

Actual kernel threads don't get attached to by ptrace.

> This is a half setup user space thread which is assumed to behave like a
> regular kernel thread, but is this assumption actually true?

No, no.

It's a *fully set up USER thread*.

Those IO threads used to be kernel threads. That didn't work out for
the reasons already mentioned earlier.

These days they really are fully regular user threads, they just don't
return to user space because they continue to do the IO work that they
were created for.

Maybe instead of Stefan's patch, we could do something like this:

   diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
   index 43cbfc84153a..890f3992e781 100644
   --- a/arch/x86/kernel/process.c
   +++ b/arch/x86/kernel/process.c
   @@ -156,7 +156,7 @@ int copy_thread(unsigned long clone_flags,
unsigned long sp, unsigned long arg,
    #endif

        /* Kernel thread ? */
   -    if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
   +    if (unlikely(p->flags & PF_KTHREAD)) {
                memset(childregs, 0, sizeof(struct pt_regs));
                kthread_frame_init(frame, sp, arg);
                return 0;
   @@ -168,6 +168,17 @@ int copy_thread(unsigned long clone_flags,
unsigned long sp, unsigned long arg,
        if (sp)
                childregs->sp = sp;

   +    /*
   +     * An IO thread is a user space thread, but it doesn't
   +     * return to ret_after_fork(), it does the same kernel
   +     * frame setup to return to a kernel function that
   +     * a kernel thread does.
   +     */
   +    if (unlikely(p->flags & PF_IO_WORKER)) {
   +            kthread_frame_init(frame, sp, arg);
   +            return 0;
   +    }
   +
    #ifdef CONFIG_X86_32
        task_user_gs(p) = get_user_gs(current_pt_regs());
    #endif

does that clarify things and make people happier?

Maybe the compiler might even notice that the

                kthread_frame_init(frame, sp, arg);
                return 0;

part is common code and then it will result in less generated code too.

NOTE! The above is - as usual - COMPLETELY UNTESTED. It looks obvious
enough, and it builds cleanly. But that's all I'm going to guarantee.

It's whitespace-damaged on purpose.

            Linus
