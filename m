Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36760375643
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 17:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234759AbhEFPMg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 May 2021 11:12:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234918AbhEFPMg (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Thu, 6 May 2021 11:12:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF18661176
        for <io-uring@vger.kernel.org>; Thu,  6 May 2021 15:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620313897;
        bh=uYngsBOEXyuKUF30zOjK0g2fvk2gImdmQXO7lICHy9I=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dnak2iMZQcwx6REhUPFjuXbafE+Dh5BlolqB1oWMlwAmRearJ24bjq+QX2s7U8oBi
         +e4FLIA0mM8sknSsa8rdugEK2THZiPfsnVqi1Ty/UG93Bxewi0VD2bjNi3oTFzhpXj
         uK22126uBgMTyrMeS10Hzsj2OiUH9BAcOwmYSAEJuftnNE0l3r3mtndVKiaiN7Nyfo
         qmWpHKHeDF5pgHS8oGT/qkQKTYzyrq9V0SA30fQNqhgCnItq3+NAr/fyBbQm6xFaEm
         Niciqhgq5s5BUrpcCCaOWVmkrlNGH27jsh6Y/v9plqgzAmiHBlCz1WslXbdIaIIUPr
         kf/pOJl0OllSg==
Received: by mail-ed1-f47.google.com with SMTP id n15so1964912edw.8
        for <io-uring@vger.kernel.org>; Thu, 06 May 2021 08:11:37 -0700 (PDT)
X-Gm-Message-State: AOAM531tMWBz9BxdyPY1jJ4ILzszQ7RzcoEArYFOBvx4Trun/VC6F+3e
        lKa9Rn+Yr/P5g1TBJuEsdI5uvcVn92btuR1Kd6H1Ug==
X-Google-Smtp-Source: ABdhPJz4IG9+/ZvyOV8PwvhW9TihJRyb6c1OlqPbuhF0F4hv48qHpBsFcXI7M4MTuzGCZQr1yQLTqyrwhwHiUDIZLao=
X-Received: by 2002:aa7:dd96:: with SMTP id g22mr5983284edv.222.1620313896213;
 Thu, 06 May 2021 08:11:36 -0700 (PDT)
MIME-Version: 1.0
References: <8735v3ex3h.ffs@nanos.tec.linutronix.de> <3C41339D-29A2-4AB1-958F-19DB0A92D8D7@amacapital.net>
 <CAHk-=wh0KoEZXPYMGkfkeVEerSCEF1AiCZSvz9TRrx=Kj74D+Q@mail.gmail.com>
 <YJEIOx7GVyZ+36zJ@hirez.programming.kicks-ass.net> <YJFptPyDtow//5LU@zn.tnic>
 <044d0bad-6888-a211-e1d3-159a4aeed52d@polymtl.ca> <932d65e1-5a8f-c86a-8673-34f0e006c27f@samba.org>
 <30e248aa-534d-37ff-2954-a70a454391fc@polymtl.ca> <CALCETrUF5M+Qw+RfY8subR7nzmpMyFsE3NHSAPoMVWMz6_hr-w@mail.gmail.com>
 <f4d0c304-2fe0-087f-90f4-1ad9c1b32694@polymtl.ca>
In-Reply-To: <f4d0c304-2fe0-087f-90f4-1ad9c1b32694@polymtl.ca>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 6 May 2021 08:11:24 -0700
X-Gmail-Original-Message-ID: <CALCETrUP1+Vy=PJASbXWgUUFHTrskLb+fO2-1huQT7A_GZpTyA@mail.gmail.com>
Message-ID: <CALCETrUP1+Vy=PJASbXWgUUFHTrskLb+fO2-1huQT7A_GZpTyA@mail.gmail.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
To:     Simon Marchi <simon.marchi@polymtl.ca>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Stefan Metzmacher <metze@samba.org>,
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

On Wed, May 5, 2021 at 6:04 PM Simon Marchi <simon.marchi@polymtl.ca> wrote:
>
> On 2021-05-05 6:11 p.m., Andy Lutomirski wrote:

> I looked at how GDB reads registers from a "64-bit" task and a "32-bit"
> task (I have to quote now, since I now know it's an abuse of
> terminology) side by side.  And indeed, GDB reads a full 64-bit state in
> both cases.  For the 32-bit case, it picks the 32-bit values from that
> buffer.  For example, to get the eax value it picks the low 4 bytes of
> rax (well, ax in user_regs_struct).
>
> So I suppose that if GDB wanted to tell nothing but the truth, it would
> present the full 64-bit register state to the user even when debugging a
> 32-bit program.  But at the end of the day, the typical user debugging a
> 32-bit program on a 64-bit probably just wants the illusion that they
> are on i386.

True.  I see no reason, especially by default, to show the extra
registers.  On the other hand, if the program switches modes, having
gdb notice would be nice.  And, if gdb handled this correctly, all
this io_uring stuff would be entirely moot.  The made-up register
state of the io_uring thread would have no bearing on the debugging of
other threads.

>
> > Now I realize that the ptrace() API is awful and makes life difficult
> > in several respects for no good reason but, if gdb is ever interested
> > in fixing its ideas about architecture to understand that all tasks,
> > even those that think of themselves as "compat", have full 64-bit
> > state, I would be more than willing to improve the ptrace() API as
> > needed to make this work well.
>
> Just wondering, do you have specific ptrace shortcomings in mind when
> saying this?  As I found above, ptrace lets us read the whole 64-bit
> register state.  After that it's up to us to analyze the state of the
> program based on its registers and memory.  What more could ptrace give
> us?

Two specific issues come to mind:

1. PTRACE_GETREGSET and PTRACE_SETREGSET are terminally broken.  See
the comment above task_user_regset_view() in arch/x86/kernel/ptrace.c.
We need a new version of those APIs that takes an e_machine parameter.
(I don't even see how you can call these APIs safely at all, short of
allocating a buffer with a guard page or intentionally over-allocating
and calculating the maximum possible size of buffer that could be used
in case of a screwup.)

2. There should be an API to either read the descriptor table or to
look up a specific descriptor.  How else are you supposed to know
whether CS.L is set?  (Keep in mind that 0x33 is not necessarily the
only long mode segment that gets used.  Linux on Xen PV has an extra
one.)

--Andy
