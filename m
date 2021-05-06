Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74795374CB1
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 03:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbhEFBGF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 21:06:05 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:58035 "EHLO smtp.polymtl.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229956AbhEFBGE (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 5 May 2021 21:06:04 -0400
Received: from simark.ca (simark.ca [158.69.221.121])
        (authenticated bits=0)
        by smtp.polymtl.ca (8.14.7/8.14.7) with ESMTP id 14614Yoa022533
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 5 May 2021 21:04:39 -0400
DKIM-Filter: OpenDKIM Filter v2.11.0 smtp.polymtl.ca 14614Yoa022533
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=polymtl.ca;
        s=default; t=1620263082;
        bh=uUo+JyP3qzUuqgNQ/RvU1uL6jonWVAN28uarKh6TD/c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Lv18hIk2Y1RyBaDJ+UApPpMNy4tAABqYbqxt+KBIVTRkTC8bflIpGKsCt/WjN1kp9
         /6KqtHVILhxp3gaPYAOO4pFIL1lXU5nVsMHOGekwwe5lqvWLOlIoTsI/w2ZpR35BOB
         hNbJ3/M1t+tRxZwNZOJsiZNHUbcgQP0ocQ3O/GdM=
Received: from [10.0.0.11] (192-222-157-6.qc.cable.ebox.net [192.222.157.6])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simark.ca (Postfix) with ESMTPSA id AAE551E01F;
        Wed,  5 May 2021 21:04:32 -0400 (EDT)
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Borislav Petkov <bp@alien8.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jens Axboe <axboe@kernel.dk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-toolchains@vger.kernel.org
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de>
 <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net> <YJFptPyDtow//5LU@zn.tnic>
 <044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca>
 <932d65e1-5a8f-c86a-8673-34f0e006c27f@samba.org>
 <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca>
 <CALCETrUF5M+Qw+RfY8subR7nzmpMyFsE3NHSAPoMVWMz6_hr-w@mail.gmail.com>
From:   Simon Marchi <simon.marchi@polymtl.ca>
Message-ID: <f4d0c304-2fe0-087f-90f4-1ad9c1b32694@polymtl.ca>
Date:   Wed, 5 May 2021 21:04:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CALCETrUF5M+Qw+RfY8subR7nzmpMyFsE3NHSAPoMVWMz6_hr-w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Poly-FromMTA: (simark.ca [158.69.221.121]) at Thu,  6 May 2021 01:04:34 +0000
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2021-05-05 6:11 p.m., Andy Lutomirski wrote:
> For what it's worth, this is already fundamentally incorrect.  On
> x86_64 Linux, a process *does* *not* *have* an architecture.  Every
> task on an x86_64 Linux host has a full 64-bit register state.  The
> task can, and sometimes does, change CS using far transfers or other
> bizarre techniques, and neither the kernel nor GDB will be notified or
> have a chance to take any action in response.  ELF files can be
> 32-bit, CS:rIP can point at 32-bit code, and system calls can be
> 32-bit (even from 64-bit code), but *tasks* are not 32-bit.

Thanks for that explanation: I didn't know that "32-bit" tasks had the
same register state as any other task.  I never really looked into it,
but I was assuming that tasks were either 32-bit or 64-bit (based on the
ELF header of the file they exec'd or something) and that 32-bit tasks
had the register state as a task on an i386 machine would have.  And
that PEEKUSER would return the 64-bit register state for 64-bit tasks,
and 32-bit register state for 32-bit tasks.

I looked at how GDB reads registers from a "64-bit" task and a "32-bit"
task (I have to quote now, since I now know it's an abuse of
terminology) side by side.  And indeed, GDB reads a full 64-bit state in
both cases.  For the 32-bit case, it picks the 32-bit values from that
buffer.  For example, to get the eax value it picks the low 4 bytes of
rax (well, ax in user_regs_struct).

So I suppose that if GDB wanted to tell nothing but the truth, it would
present the full 64-bit register state to the user even when debugging a
32-bit program.  But at the end of the day, the typical user debugging a
32-bit program on a 64-bit probably just wants the illusion that they
are on i386.

> Now I realize that the ptrace() API is awful and makes life difficult
> in several respects for no good reason but, if gdb is ever interested
> in fixing its ideas about architecture to understand that all tasks,
> even those that think of themselves as "compat", have full 64-bit
> state, I would be more than willing to improve the ptrace() API as
> needed to make this work well.

Just wondering, do you have specific ptrace shortcomings in mind when
saying this?  As I found above, ptrace lets us read the whole 64-bit
register state.  After that it's up to us to analyze the state of the
program based on its registers and memory.  What more could ptrace give
us?

> Since I'm not holding my breath, please at least keep in mind that
> anything you do here is merely a heuristic, cannot be fully correct,
> and then whenever gdb determines that a thread group or a thread is
> "32-bit", gdb is actually deciding to operate in a degraded mode for
> that task, is not accurately representing the task state, and is at
> risk of crashing, malfunctioning, or crashing the inferior due to its
> incorrect assumptions.  If you have ever attached gdb to QEMU's
> gdbserver and tried to debug the early boot process of a 64-bit Linux
> kernel, you may have encountered this class of bugs.  gdb works very,
> very poorly for this use case.

Yes, that QEMU case comes up often.  I wish that things were better, but
the reality is that this is an edge case, it would require somebody with
that particular itch to scratch to work on GDB to improve that use case.
So as you said, don't hold your breath :).

I completely understand that GDB putting processes in the "32-bit" or
"64-bit" bin is not the right thing to do in general, from a kernel
perspective.  But it converged to this because it's enough for and
useful to the 99.9% of users who debug programs that don't do funky
things.  At least, it's good to know about it in case problems related
to this arise in the future.

Simon
