Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FDD37299D
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 13:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbhEDLke (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 May 2021 07:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhEDLkd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 May 2021 07:40:33 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B84FC061574;
        Tue,  4 May 2021 04:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=Yka7LNg7ewHAq2XpviLt372rpxVqwZXVShfcGxLca20=; b=lOwHMLcKNWzm+crLQEUY3mnsqU
        uIQsHCk01m7sgi+MT/+eJ7cfVq068lB+wSGbArh+st+CbIgGZQuycV3aa6QXgJJ8/q7Jqxcb9X2fK
        9g+S5yQWybXNpu5HYuesfOhNlLp8Z1qoGMFMQUVTGySSbi5/oucBGCCMUWiq0HCOzBHKbbXAapoKa
        4lk3vz3juSwNv5BdpywshMFbnyr3pn4qz669inKsRd74xfTwwF2k0yRzXaEEWZSwLpzmEyKx9rEuh
        Kvy7UOvB7F8oc8uACGDUXugiWM4mNigW04wCV73zdqpTw8jSxa5UF0F2UlvgvXWcxXqtSSgvCPXk9
        b8T9jypkgkPu4cgO+vYzAt1eBzVfnmCSNarQClAOfU+OYSWH8eeJH43UAp/Si9pDI0C1YLQPAEgoi
        Ecib08VtulRo/fiH4bjNndfV5zLB8ZZ3Y/WCG5B66NURskKM2T/A3eTGqLgrqvqr4/g3mzclmpfOc
        UT1/zH9nLvqh9U18m71hul6p;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1ldtOp-0004uU-HY; Tue, 04 May 2021 11:39:35 +0000
To:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
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
 <12710fda-1732-ee55-9ac1-0df9882aa71b@samba.org>
 <CAHk-=wiR7c-UHh_3Rj-EU8=AbURKchnMFJWW7=5EH=qEUDT8wg@mail.gmail.com>
 <59ea3b5a-d7b3-b62e-cc83-1f32a83c4ac2@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
Message-ID: <4d0bb1e7-acbd-4afb-e6d6-a2e7f78ccaaa@samba.org>
Date:   Tue, 4 May 2021 13:39:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <59ea3b5a-d7b3-b62e-cc83-1f32a83c4ac2@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Am 04.05.21 um 04:50 schrieb Jens Axboe:
> On 5/3/21 5:48 PM, Linus Torvalds wrote:
>> On Mon, May 3, 2021 at 4:27 PM Stefan Metzmacher <metze@samba.org> wrote:
>>>
>>> If I remember correctly gdb showed bogus addresses for the backtraces of the io_threads,
>>> as some regs where not cleared.
>>
>> Yeah, so that patch will make the IO thread have the user stack
>> pointer point to the original user stack, but that stack will
>> obviously be used by the original thread which means that it will
>> contain random stuff on it.
>>
>> Doing a
>>
>>         childregs->sp = 0;
>>
>> is probably a good idea for that PF_IO_WORKER case, since it really
>> doesn't have - or need - a user stack.
>>
>> Of course, it doesn't really have - or need - any of the other user
>> registers either, but once you fill in the segment stuff to make gdb
>> happy, you might as well fill it all in using the same code that the
>> regular case does.
> 
> I tested the below, which is the two combined, with a case that
> deliberately has two types of io threads - one for SQPOLL submission,
> and one that was created due to async work being needed. gdb attaches
> just fine to the creator, with a slight complaint:
> 
> Attaching to process 370
> [New LWP 371]
> [New LWP 372]
> Error while reading shared library symbols for /usr/lib/libpthread.so.0:
> Cannot find user-level thread for LWP 372: generic error
> 0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
> (gdb) info threads
>   Id   Target Id             Frame 
> * 1    LWP 370 "io_uring"    0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 ()
>    from /usr/lib/libc.so.6
>   2    LWP 371 "iou-sqp-370" 0x00007f1a746a7a9d in syscall () from /usr/lib/libc.so.6
>   3    LWP 372 "io_uring"    0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 ()
>    from /usr/lib/libc.so.6
> 
> (gdb) thread 2
> [Switching to thread 2 (LWP 371)]
> #0  0x00007f1a746a7a9d in syscall () from /usr/lib/libc.so.6
> (gdb) bt
> #0  0x00007f1a746a7a9d in syscall () from /usr/lib/libc.so.6
> Backtrace stopped: Cannot access memory at address 0x0
> 
> (gdb) thread 1
> [Switching to thread 1 (LWP 370)]
> #0  0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
> (gdb) bt
> #0  0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
> #1  0x00007f1a7467a357 in nanosleep () from /usr/lib/libc.so.6
> #2  0x00007f1a7467a28e in sleep () from /usr/lib/libc.so.6
> #3  0x000055bd41e929ba in main (argc=<optimized out>, argv=<optimized out>)
>     at t/io_uring.c:658
> 
> which looks very reasonable to me - no backtraces for the io threads, and
> no arch complaints.
> 
> 
> diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
> index 43cbfc84153a..58987bce90e2 100644
> --- a/arch/x86/kernel/process.c
> +++ b/arch/x86/kernel/process.c
> @@ -156,7 +156,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
>  #endif
>  
>  	/* Kernel thread ? */
> -	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
> +	if (unlikely(p->flags & PF_KTHREAD)) {
>  		memset(childregs, 0, sizeof(struct pt_regs));
>  		kthread_frame_init(frame, sp, arg);
>  		return 0;
> @@ -168,6 +168,12 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
>  	if (sp)
>  		childregs->sp = sp;
>  
> +	if (unlikely(p->flags & PF_IO_WORKER)) {
> +		childregs->sp = 0;
> +		kthread_frame_init(frame, sp, arg);
> +		return 0;
> +	}
> +
>  #ifdef CONFIG_X86_32
>  	task_user_gs(p) = get_user_gs(current_pt_regs());
>  #endif

I'm currently testing this (moving things to the end and resetting ->ip = 0 too)

--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -161,7 +161,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 #endif

        /* Kernel thread ? */
-       if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
+       if (unlikely(p->flags & PF_KTHREAD)) {
                memset(childregs, 0, sizeof(struct pt_regs));
                kthread_frame_init(frame, sp, arg);
                return 0;
@@ -184,6 +184,23 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
        if (!ret && unlikely(test_tsk_thread_flag(current, TIF_IO_BITMAP)))
                io_bitmap_share(p);

+       /*
+        * An IO thread is a user space thread, but it doesn't
+        * return to ret_after_fork().
+        *
+        * In order to indicate that to tools like gdb,
+        * we reset the stack and instruction pointers.
+        *
+        * It does the same kernel frame setup to return to a kernel
+        * function that a kernel thread does.
+        */
+       if (!ret && unlikely(p->flags & PF_IO_WORKER)) {
+               childregs->sp = 0;
+               childregs->ip = 0;
+               kthread_frame_init(frame, sp, arg);
+               return 0;
+       }
+
        return ret;
 }

which means the output looks like this:

(gdb) info threads
  Id   Target Id                  Frame
* 1    LWP 4863 "io_uring-cp-for" syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
  2    LWP 4864 "iou-mgr-4863"    0x0000000000000000 in ?? ()
  3    LWP 4865 "iou-wrk-4863"    0x0000000000000000 in ?? ()
(gdb) thread 3
[Switching to thread 3 (LWP 4865)]
#0  0x0000000000000000 in ?? ()
(gdb) bt
#0  0x0000000000000000 in ?? ()
Backtrace stopped: Cannot access memory at address 0x0

I think "0x0000000000000000 in ?? ()" is a relative sane indication that this thread
will never return to userspace. I'd prefer this over:

> (gdb) thread 2
> [Switching to thread 2 (LWP 371)]
> #0  0x00007f1a746a7a9d in syscall () from /usr/lib/libc.so.6
> (gdb) bt
> #0  0x00007f1a746a7a9d in syscall () from /usr/lib/libc.so.6
> Backtrace stopped: Cannot access memory at address 0x0

which seem to indicate that the syscall returns eventually.

What do you think? Should I post that as v2 if my final testing doesn't find any problem?

Thanks!
metze
