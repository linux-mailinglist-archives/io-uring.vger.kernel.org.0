Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BA1372488
	for <lists+io-uring@lfdr.de>; Tue,  4 May 2021 04:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbhEDCvP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 3 May 2021 22:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhEDCvP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 3 May 2021 22:51:15 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868AEC06174A
        for <io-uring@vger.kernel.org>; Mon,  3 May 2021 19:50:21 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id a11so4028495plh.3
        for <io-uring@vger.kernel.org>; Mon, 03 May 2021 19:50:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bs2uDwxwq1zZi6hfXlJFHm5DU97INKbe3KBPR4vz8kc=;
        b=xOCEKg+lkLAZgc8KF/dua6pJchU9Z4xAuGC3A0C/3oS3nfZXIYBXgNaJp9QBxdy/d+
         YFt3d/kpVMxS9Y5QbXmMy5y6K5NmsOG2R03vhIE06/K9xW2VNhG4dB0pbG3+QBIfSdFk
         FSzlu0cYHuKTrWJITlRyrwvW0EZhMeKAueucCt5J1Fh4w7aOQ0+EQ/Vyew2cO8j4YzWr
         sUlymfbl/zAj5OvyJ7PsFpVQWTm5DIMz8gqC/IA6HyieQARsfqJx/AOiyYoa9EALMGXr
         J6DoF+fe5Hil85itNf2RhIzM82bulKeSgmC7UfrOMh+Cd5HepZTmMol8b3//FXoou0PE
         afBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bs2uDwxwq1zZi6hfXlJFHm5DU97INKbe3KBPR4vz8kc=;
        b=D6OAsHLrCj3fyAOJiwDE0N9IFJgYbZOUqI8C+10yfzfDMUq1C3XkHH1HaTQIzl1Shs
         Tsd8JAUtPdlzkndTK5oTQfevDkzwy4lyZikSiy/17+zJUiVLZQ08/P+mi+9URW2Mp1Hi
         /f/f9EPrv7/QquTl866/GIkIwWEDSHpkmhLDEey9nE5qBDtQF43Md0hBSmRKELg84GEt
         MjsaCzJu3P22v+1tCkTMGiJFjdI8PaoYORo65vs9ncOabzF/Byl8xE3rjZOs6txomlGN
         GNZawsPBpu/ALvFrkKnxz3OfYE/m0rH+ve1Gj7xOfAZXJcqE2Cbsk7sGGZBwsPaFhYt2
         pXag==
X-Gm-Message-State: AOAM533aitqOAfVMRD6WMYImNcruiHna6cBCxRQfQaLesJ/aeWL1WqOD
        6k3UqJqQXWJ0rPwjfvF91NQ2Jh8/+2i6og==
X-Google-Smtp-Source: ABdhPJykzi/Xftd7waKsIZaby04AB8Rz3GDQ8P0D/r3gYwmA4nMIpiXC7yprmG34l3ljPjvcqP5FcQ==
X-Received: by 2002:a17:902:a514:b029:ed:18b0:1d10 with SMTP id s20-20020a170902a514b02900ed18b01d10mr23776152plq.7.1620096620904;
        Mon, 03 May 2021 19:50:20 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id c16sm1143556pgl.79.2021.05.03.19.50.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 19:50:20 -0700 (PDT)
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <59ea3b5a-d7b3-b62e-cc83-1f32a83c4ac2@kernel.dk>
Date:   Mon, 3 May 2021 20:50:19 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiR7c-UHh_3Rj-EU8=AbURKchnMFJWW7=5EH=qEUDT8wg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/3/21 5:48 PM, Linus Torvalds wrote:
> On Mon, May 3, 2021 at 4:27 PM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> If I remember correctly gdb showed bogus addresses for the backtraces of the io_threads,
>> as some regs where not cleared.
> 
> Yeah, so that patch will make the IO thread have the user stack
> pointer point to the original user stack, but that stack will
> obviously be used by the original thread which means that it will
> contain random stuff on it.
> 
> Doing a
> 
>         childregs->sp = 0;
> 
> is probably a good idea for that PF_IO_WORKER case, since it really
> doesn't have - or need - a user stack.
> 
> Of course, it doesn't really have - or need - any of the other user
> registers either, but once you fill in the segment stuff to make gdb
> happy, you might as well fill it all in using the same code that the
> regular case does.

I tested the below, which is the two combined, with a case that
deliberately has two types of io threads - one for SQPOLL submission,
and one that was created due to async work being needed. gdb attaches
just fine to the creator, with a slight complaint:

Attaching to process 370
[New LWP 371]
[New LWP 372]
Error while reading shared library symbols for /usr/lib/libpthread.so.0:
Cannot find user-level thread for LWP 372: generic error
0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
(gdb) info threads
  Id   Target Id             Frame 
* 1    LWP 370 "io_uring"    0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 ()
   from /usr/lib/libc.so.6
  2    LWP 371 "iou-sqp-370" 0x00007f1a746a7a9d in syscall () from /usr/lib/libc.so.6
  3    LWP 372 "io_uring"    0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 ()
   from /usr/lib/libc.so.6

(gdb) thread 2
[Switching to thread 2 (LWP 371)]
#0  0x00007f1a746a7a9d in syscall () from /usr/lib/libc.so.6
(gdb) bt
#0  0x00007f1a746a7a9d in syscall () from /usr/lib/libc.so.6
Backtrace stopped: Cannot access memory at address 0x0

(gdb) thread 1
[Switching to thread 1 (LWP 370)]
#0  0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
(gdb) bt
#0  0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 () from /usr/lib/libc.so.6
#1  0x00007f1a7467a357 in nanosleep () from /usr/lib/libc.so.6
#2  0x00007f1a7467a28e in sleep () from /usr/lib/libc.so.6
#3  0x000055bd41e929ba in main (argc=<optimized out>, argv=<optimized out>)
    at t/io_uring.c:658

which looks very reasonable to me - no backtraces for the io threads, and
no arch complaints.


diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 43cbfc84153a..58987bce90e2 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -156,7 +156,7 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 #endif
 
 	/* Kernel thread ? */
-	if (unlikely(p->flags & (PF_KTHREAD | PF_IO_WORKER))) {
+	if (unlikely(p->flags & PF_KTHREAD)) {
 		memset(childregs, 0, sizeof(struct pt_regs));
 		kthread_frame_init(frame, sp, arg);
 		return 0;
@@ -168,6 +168,12 @@ int copy_thread(unsigned long clone_flags, unsigned long sp, unsigned long arg,
 	if (sp)
 		childregs->sp = sp;
 
+	if (unlikely(p->flags & PF_IO_WORKER)) {
+		childregs->sp = 0;
+		kthread_frame_init(frame, sp, arg);
+		return 0;
+	}
+
 #ifdef CONFIG_X86_32
 	task_user_gs(p) = get_user_gs(current_pt_regs());
 #endif


-- 
Jens Axboe

