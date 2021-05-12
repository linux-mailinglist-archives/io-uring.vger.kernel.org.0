Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4AD37B4E7
	for <lists+io-uring@lfdr.de>; Wed, 12 May 2021 06:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbhELEZn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 12 May 2021 00:25:43 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:36816 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbhELEZm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 12 May 2021 00:25:42 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:53822 helo=[192.168.1.177])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lggQD-00008a-LO; Wed, 12 May 2021 00:24:33 -0400
Message-ID: <17471c9fec18765449ef3a5a4cddc23561b97f52.camel@trillion01.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Metzmacher <metze@samba.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Date:   Wed, 12 May 2021 00:24:32 -0400
In-Reply-To: <59ea3b5a-d7b3-b62e-cc83-1f32a83c4ac2@kernel.dk>
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
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, 2021-05-03 at 20:50 -0600, Jens Axboe wrote:
> 
> I tested the below, which is the two combined, with a case that
> deliberately has two types of io threads - one for SQPOLL submission,
> and one that was created due to async work being needed. gdb attaches
> just fine to the creator, with a slight complaint:
> 
> Attaching to process 370
> [New LWP 371]
> [New LWP 372]
> Error while reading shared library symbols for
> /usr/lib/libpthread.so.0:
> Cannot find user-level thread for LWP 372: generic error
> 0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 () from
> /usr/lib/libc.so.6
> (gdb) info threads
>   Id   Target Id             Frame 
> * 1    LWP 370 "io_uring"    0x00007f1a74675125 in
> clock_nanosleep@GLIBC_2.2.5 ()
>    from /usr/lib/libc.so.6
>   2    LWP 371 "iou-sqp-370" 0x00007f1a746a7a9d in syscall () from
> /usr/lib/libc.so.6
>   3    LWP 372 "io_uring"    0x00007f1a74675125 in
> clock_nanosleep@GLIBC_2.2.5 ()
>    from /usr/lib/libc.so.6
> 
> (gdb) thread 2
> [Switching to thread 2 (LWP 371)]
> #0  0x00007f1a746a7a9d in syscall () from /usr/lib/libc.so.6
> (gdb) bt
> #0  0x00007f1a746a7a9d in syscall () from /usr/lib/libc.so.6
> Backtrace stopped: Cannot access memory at address 0x0
> 
> (gdb) thread 1
> [Switching to thread 1 (LWP 370)]
> #0  0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 () from
> /usr/lib/libc.so.6
> (gdb) bt
> #0  0x00007f1a74675125 in clock_nanosleep@GLIBC_2.2.5 () from
> /usr/lib/libc.so.6
> #1  0x00007f1a7467a357 in nanosleep () from /usr/lib/libc.so.6
> #2  0x00007f1a7467a28e in sleep () from /usr/lib/libc.so.6
> #3  0x000055bd41e929ba in main (argc=<optimized out>, argv=<optimized
> out>)
>     at t/io_uring.c:658
> 
> which looks very reasonable to me - no backtraces for the io threads,
> and
> no arch complaints.
> 
I have reported an issue that I have with a user process using io_uring
where when it core dumps, the dump fails to be generated.
https://github.com/axboe/liburing/issues/346

Pavel did comment to my report and he did point out this thread as
possibly a related issue.

I'm far from being 100% convinced that Stefan patch can help but I am
going to give it a try and report back here if it does help.

Greetings,
Olivier

