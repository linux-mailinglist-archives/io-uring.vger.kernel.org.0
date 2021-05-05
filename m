Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E15E374BD3
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 01:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbhEEXXk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 19:23:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:57942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229619AbhEEXXk (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 5 May 2021 19:23:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D29F5613EC
        for <io-uring@vger.kernel.org>; Wed,  5 May 2021 23:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620256962;
        bh=F+mnMMlF78TxCmvF3CvXV4DSs15i/Wd7uu7DampNkVI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=r5oHMC6uQn0rBeksxQYQ6ORMY/A7fulWtjrZqmMKwQFeNs13fMzlCTBGlgVzlgEx9
         HKeQ/ToXjxOzoPGA9iyXXph0f1ZBb7mPn7tqF3An7tmnAzh1cJHltFtdDmujC6q7nq
         RaMr23uagsa1hinYpVSENgnUwLl/plMGEx3xv4hU6JE2mJhO1DAHYi8Vf6YgTLKS8G
         rXQd64h4lrbHu5IAU60+8oQcmZI0ljSLnuQLK33IkF34DIxkohxyfJiBOxlvQtC0tK
         ouqcww5XnHDAI2bD9n3I0N9WhrV9AIB1rrBCA7tPnGMKoS2DcdtVWYwGEF2ZyRhlte
         InFZ5YXDONLOg==
Received: by mail-ed1-f50.google.com with SMTP id s6so3932952edu.10
        for <io-uring@vger.kernel.org>; Wed, 05 May 2021 16:22:42 -0700 (PDT)
X-Gm-Message-State: AOAM530tREVDcp7tuqwwP7pMj3XQd4bHaqod3EqODfN/v6rPAKhjlLgU
        sui+vWOeGhe5mG9FD4VDUX8YHeDpst4G4gfQCM9P5A==
X-Google-Smtp-Source: ABdhPJwFLoNYrpL4CTxTz77gnCsjjNufMO1tqV2hkAAFm4x4wfWew/wKMDOsGcOIqKLM5rVvMeRc+E3805CM1Qbq05U=
X-Received: by 2002:a05:6402:17b0:: with SMTP id j16mr1524042edy.97.1620256961331;
 Wed, 05 May 2021 16:22:41 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net> <YJFptPyDtow//5LU@zn.tnic>
 <044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca> <932d65e1-5a8f-c86a-8673-34f0e006c27f@samba.org>
 <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca> <CALCETrUF5M+Qw+RfY8subR7nzmpMyFsE3NHSAPoMVWMz6_hr-w@mail.gmail.com>
 <YJMmVHGn33W2n2Ux@zn.tnic>
In-Reply-To: <YJMmVHGn33W2n2Ux@zn.tnic>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 5 May 2021 16:22:29 -0700
X-Gmail-Original-Message-ID: <CALCETrXieCM3f2sYQLk36horw1Cgt9OrZyDqCYrN71VgGusdVg@mail.gmail.com>
Message-ID: <CALCETrXieCM3f2sYQLk36horw1Cgt9OrZyDqCYrN71VgGusdVg@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Borislav Petkov <bp@alien8.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Simon Marchi <simon.marchi@polymtl.ca>,
        Stefan Metzmacher <metze@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-toolchains@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, May 5, 2021 at 4:12 PM Borislav Petkov <bp@alien8.de> wrote:
>
> On Wed, May 05, 2021 at 03:11:18PM -0700, Andy Lutomirski wrote:
> > Since I'm not holding my breath, please at least keep in mind that
> > anything you do here is merely a heuristic, cannot be fully correct,
> > and then whenever gdb determines that a thread group or a thread is
> > "32-bit", gdb is actually deciding to operate in a degraded mode for
> > that task, is not accurately representing the task state, and is at
> > risk of crashing, malfunctioning, or crashing the inferior due to its
> > incorrect assumptions.  If you have ever attached gdb to QEMU's
> > gdbserver and tried to debug the early boot process of a 64-bit Linux
> > kernel, you may have encountered this class of bugs.  gdb works very,
> > very poorly for this use case.
>
> So we were talking about this with toolchain folks today and they gave
> me this example:
>
> Imagine you've stopped the target this way:
>
>         <insn><-- stopped here
>         <insn>
>         <mode changing insn>
>         <insn>
>         <insn>
>         ...
>
> now, if you dump rIP and say, rIP + the 10 following insns at the place
> you've stopped it, gdb cannot know that 2 insns further into the stream
> a
>
> <mode changing insn>
>
> is coming and it should change the disassembly of the insns after that
> <mode changing insn> to the new mode. Unless it goes and inspects all
> further instructions and disassembles them and analyzes the flow...

That's fine.  x86 machine code is like this.  You also can't
disassemble instructions before rIP accurately either.

>
> So what you can do is
>
> (gdb) set arch ...
>
> at the <mode changing insn> to the mode you're changing to.
>
> Dunno, maybe I'm missing something but this sounds like without user
> help gdb can only assume things.

In the tools/testing/x86/selftests directory, edited slightly for brevity:

$ gdb ./test_syscall_vdso_32
(gdb) b call64_from_32
Breakpoint 1 at 0x80499ef: file thunks_32.S, line 19.
(gdb) display/i $pc
1: x/i $pc
<error: No registers.>
(gdb) r
Starting program:
/home/luto/apps/linux/tools/testing/selftests/x86/test_syscall_vdso_32
...
[RUN]    Executing 6-argument 32-bit syscall via VDSO

Breakpoint 1, call64_from_32 () at thunks_32.S:19
19        mov    4(%esp), %eax
1: x/i $pc
=> 0x80499ef <call64_from_32>:    mov    0x4(%esp),%eax
(gdb) si
22        push    %ecx
1: x/i $pc
=> 0x80499f3 <call64_from_32+4>:    push   %ecx
(gdb)
call64_from_32 () at thunks_32.S:23
23        push    %edx
1: x/i $pc
=> 0x80499f4 <call64_from_32+5>:    push   %edx
(gdb)
call64_from_32 () at thunks_32.S:24
24        push    %esi
1: x/i $pc
=> 0x80499f5 <call64_from_32+6>:    push   %esi
(gdb)
call64_from_32 () at thunks_32.S:25
25        push    %edi
1: x/i $pc
=> 0x80499f6 <call64_from_32+7>:    push   %edi
(gdb)
call64_from_32 () at thunks_32.S:28
28        jmp    $0x33,$1f
1: x/i $pc
=> 0x80499f7 <call64_from_32+8>:    ljmp   $0x33,$0x80499fe
(gdb) info registers
eax            0x80492e8           134517480
ecx            0x3f                63
edx            0x1                 1
ebx            0xf7fc8550          -134445744
esp            0xffffc57c          0xffffc57c
ebp            0xffffc5e8          0xffffc5e8
esi            0x0                 0
edi            0x8049180           134517120
eip            0x80499f7           0x80499f7 <call64_from_32+8>
eflags         0x292               [ AF SF IF ]
cs             0x23                35
ss             0x2b                43
ds             0x2b                43
es             0x2b                43
fs             0x0                 0
gs             0x63                99
(gdb) si
32        call    *%rax
1: x/i $pc
=> 0x80499fe <call64_from_32+15>:    call   *%eax
(gdb) info registers
eax            0x80492e8           134517480

^^^ Should be rax

ecx            0x3f                63
edx            0x1                 1
ebx            0xf7fc8550          -134445744
esp            0xffffc57c          0xffffc57c
ebp            0xffffc5e8          0xffffc5e8
esi            0x0                 0
edi            0x8049180           134517120
eip            0x80499fe           0x80499fe <call64_from_32+15>

^^^ r8, etc are all missing

eflags         0x292               [ AF SF IF ]
cs             0x33                51

^^^ 64-bit!

ss             0x2b                43
ds             0x2b                43
es             0x2b                43
fs             0x0                 0
gs             0x63                99
(gdb) si
poison_regs64 () at test_syscall_vdso.c:35
35    long syscall_addr;
1: x/i $pc
=> 0x80492e8 <poison_regs64>:    dec    %ecx
(gdb) si
36    long get_syscall(char **envp)
1: x/i $pc
=> 0x80492ef <poison_regs64+7>:    dec    %ecx
(gdb) set arch i386:x86-64
warning: Selected architecture i386:x86-64 is not compatible with
reported target architecture i386
Architecture `i386:x86-64' not recognized.
The target architecture is set to "auto" (currently "i386").
(gdb) set arch i386:x86-64:intel
warning: Selected architecture i386:x86-64:intel is not compatible
with reported target architecture i386
Architecture `i386:x86-64:intel' not recognized.
The target architecture is set to "auto" (currently "i386").

I don't know enough about gdb internals to know precisely what failed
here, but this did not work the way it should have.

Sure, ptrace should provide a nice API to figure out that CS == 0x33
means long mode, but gdb could do a whole lot better here.
