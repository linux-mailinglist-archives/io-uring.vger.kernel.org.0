Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B24EE372397
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 01:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbhECX2y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 19:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbhECX2y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 19:28:54 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE5CC061574;
        Mon,  3 May 2021 16:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=LwU0+eb1IWwlpCdF/tlgc+NJ3NGOv3+O9SeM3Vf4AGU=; b=i/z3IVaPYmpcs+1pn7CYrE0DIE
        95R4Jhrui1UJPySWj+n0hNdsN88Lh8gJToqNeIUBqRy4olP8bAw9BwfrWaMWidYkJqRGOLpQS24Xe
        tpN22uJDK7iJouVMzuqQylxT/EzuYZcbeWcOTJp9oA1CFwv6Wo8InMM/gfukKMdMiqADfrOGHOLSY
        Kd87uvHnxWHkO6gFKS/NNgmwG61x6n66jG9rfM6pimfxtM4iwJdhqlVbc2VrIxaD1oAoaPdz5ut5k
        vLLGG0cNp4dtLyVtir1xBJInqxrVdhGmcUrUktOIl5kISyzDOGxkCWelXRKvZp3QkII7Gw9v0s+P3
        uLxnaTkHq2K+b+0XW5/Knti5WcqJH8lnLcqBFZlcmSMtykIHUQoNs6PHq4Eh5An/QVsTTfNwd5Jvx
        3SxU658yXdqBRlPzXgXUs62nStxJHXS71Lm1e5SrajQNZICxsOROzc1s8TDwMUmgcXVL8rs2K25RN
        zLEhjbuT9/sQ5CXHJiUe+j+S;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1ldhym-0007SW-LQ; Mon, 03 May 2021 23:27:56 +0000
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Andy Lutomirski <luto@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <CALCETrV9bCenqzzaW6Ra18tCvNP-my09decTjmLDVZZAQxR6VA@mail.gmail.com>
 <CAHk-=wgo6XEz3VQ9ntqzWLR3-hm1YXrXUz4_heDs4wcLe9NYvA@mail.gmail.com>
 <d26e3a82-8a2c-7354-d36b-cac945c208c7@kernel.dk>
 <CALCETrWmhquicE2C=G2Hmwfj4VNypXVxY-K3CWOkyMe9Edv88A@mail.gmail.com>
 <CAHk-=wgqK0qUskrzeWXmChErEm32UiOaUmynWdyrjAwNzkDKaw@mail.gmail.com>
 <8735v3jujv.ffs@nanos.tec.linutronix.de>
 <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Message-ID: <12710fda-1732-ee55-9ac1-0df9882aa71b@samba.org>
Date:   Tue, 4 May 2021 01:27:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAHk-=wi4Dyg_Z70J_hJbtFLPQDG+Zx3dP2jB5QrOdZC6W6j4Gw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Am 04.05.21 um 01:16 schrieb Linus Torvalds:
> On Mon, May 3, 2021 at 3:56 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>>
>> It's all fine that we have lots of blurb about GDB, but there is no
>> reasoning why this does not affect regular kernel threads which take the
>> same code path.
> 
> Actual kernel threads don't get attached to by ptrace.
> 
>> This is a half setup user space thread which is assumed to behave like a
>> regular kernel thread, but is this assumption actually true?
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

I think I also tested something similar, see:

https://git.samba.org/?p=metze/linux/wip.git;a=commitdiff;h=82fcee2774add04fbc0e4755c405e6c0b7467e3a

If I remember correctly gdb showed bogus addresses for the backtraces of the io_threads,
as some regs where not cleared.

The patch I posted shows this instead:

  Thread 2 (LWP 8744):
  #0  0x0000000000000000 in ?? ()
  Backtrace stopped: Cannot access memory at address 0x0

I think that's a saner behavior.

However splitting the if statements might be a good idea to make things
more clear.

Thanks discussing this again!
metze
