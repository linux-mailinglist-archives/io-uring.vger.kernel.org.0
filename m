Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57ADC374B05
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 00:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbhEEWM2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 18:12:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233500AbhEEWM2 (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 5 May 2021 18:12:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 337C8613EC
        for <io-uring@vger.kernel.org>; Wed,  5 May 2021 22:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620252691;
        bh=rI0oHHeZd9YFRS4z4bbyC/mM0GIFRiRccYpAXqggogU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UefWFi1yB6sGKXkq0KUiaiPofvpVlfmFlOCcXNAb4bogajrzoMZIPFSYCIqKcqryB
         04vo8ftBG4KRwEqcypNybAKi7+0PkmY2prwnbsEvc4T+nCkaAAlqX0+XSO6mk0ApUo
         XKHxWiyKIdOrtq8VpKWPTrqmhjd/b+GQUNdMTuOhdxGI0P9I1LFOPx6jNUWB7LQ16k
         yNpxxNSrDo7xQXviyDdBtvnxRFKhNzXm6EQnz0G8sEHREQCxmuiWX3wk8FYAe8PQIO
         dJkk8BWZq6ktjxtPoJCKUoP2uA+RdrCy2MkazrFFYV97U0wadCtGIuaUwPxD+te7MB
         njq/1zA7X9//w==
Received: by mail-ed1-f43.google.com with SMTP id h10so3780819edt.13
        for <io-uring@vger.kernel.org>; Wed, 05 May 2021 15:11:31 -0700 (PDT)
X-Gm-Message-State: AOAM530cd6ASOU1z1CRng+ixTEE//DjFlRp6yg6QLmeBgg3YYu1caCWm
        jYwy9WXAwkuzttqsZP4WUbGBZv5UzmDSu7nT1nNn/g==
X-Google-Smtp-Source: ABdhPJwa1mtDX6B2XDVMbQyd/7X5vw28833micGneWZAkt/jXimVIn3YzNyG7UEDSe95fdqdlTKw38uZT/OEYSmo6BA=
X-Received: by 2002:a50:fc91:: with SMTP id f17mr1291143edq.23.1620252689704;
 Wed, 05 May 2021 15:11:29 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net> <YJFptPyDtow//5LU@zn.tnic>
 <044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca> <932d65e1-5a8f-c86a-8673-34f0e006c27f@samba.org>
 <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca>
In-Reply-To: <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Wed, 5 May 2021 15:11:18 -0700
X-Gmail-Original-Message-ID: <CALCETrUF5M+Qw+RfY8subR7nzmpMyFsE3NHSAPoMVWMz6_hr-w@mail.gmail.com>
Message-ID: <CALCETrUF5M+Qw+RfY8subR7nzmpMyFsE3NHSAPoMVWMz6_hr-w@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Simon Marchi <simon.marchi@polymtl.ca>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Borislav Petkov <bp@alien8.de>,
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

I'm not holding my breath, but:

On Wed, May 5, 2021 at 2:59 PM Simon Marchi <simon.marchi@polymtl.ca> wrote:
>
> On 2021-05-05 7:29 a.m., Stefan Metzmacher wrote:
> > See https://lore.kernel.org/io-uring/0375b37f-2e1e-7999-53b8-c567422aa181@samba.org/
> > and https://lore.kernel.org/io-uring/20210411152705.2448053-1-metze@samba.org/T/#m461f280e8c3d32a49bc7da7bb5e214e90d97cf65
> >
> > The question is why does inferior_ptid doesn't represent the thread
> > that was specified by 'gdb --pid PIDVAL'
>
> Hi Stefan,
>
> When you attach to PIDVAL (assuming that PIDVAL is a thread-group
> leader), GDB attaches to all the threads of that thread group.  The
> inferior_ptid global variable is "the thread we are currently working
> with", and changes whenever GDB wants to deal with a different thread.
>
> After attaching to all threads, GDB wants to know more about that
> process' architecture (that read_description call mentioned in [1]).

^^^^^^

For what it's worth, this is already fundamentally incorrect.  On
x86_64 Linux, a process *does* *not* *have* an architecture.  Every
task on an x86_64 Linux host has a full 64-bit register state.  The
task can, and sometimes does, change CS using far transfers or other
bizarre techniques, and neither the kernel nor GDB will be notified or
have a chance to take any action in response.  ELF files can be
32-bit, CS:rIP can point at 32-bit code, and system calls can be
32-bit (even from 64-bit code), but *tasks* are not 32-bit.

Now I realize that the ptrace() API is awful and makes life difficult
in several respects for no good reason but, if gdb is ever interested
in fixing its ideas about architecture to understand that all tasks,
even those that think of themselves as "compat", have full 64-bit
state, I would be more than willing to improve the ptrace() API as
needed to make this work well.

Since I'm not holding my breath, please at least keep in mind that
anything you do here is merely a heuristic, cannot be fully correct,
and then whenever gdb determines that a thread group or a thread is
"32-bit", gdb is actually deciding to operate in a degraded mode for
that task, is not accurately representing the task state, and is at
risk of crashing, malfunctioning, or crashing the inferior due to its
incorrect assumptions.  If you have ever attached gdb to QEMU's
gdbserver and tried to debug the early boot process of a 64-bit Linux
kernel, you may have encountered this class of bugs.  gdb works very,
very poorly for this use case.

(To avoid confusion, this is not a universal property of Linux.  arm64
and arm32 tasks on an arm64 Linux host are different and cannot
arbitrarily switch modes.)

--Andy
