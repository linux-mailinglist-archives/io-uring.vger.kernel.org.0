Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC436389C5C
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 06:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbhETEOn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 May 2021 00:14:43 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:48442 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhETEOn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 May 2021 00:14:43 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:45864 helo=[192.168.1.177])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lja3l-0007Hw-2N; Thu, 20 May 2021 00:13:21 -0400
Message-ID: <b360ed542526da0a510988ce30545f429a7da000.camel@trillion01.com>
Subject: Re: [PATCH] io_thread/x86: don't reset 'cs', 'ss', 'ds' and 'es'
 registers for io_threads
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Lutomirski <luto@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Date:   Thu, 20 May 2021 00:13:19 -0400
In-Reply-To: <3df541c3-728c-c63d-eaeb-a4c382e01f0b@kernel.dk>
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
         <17471c9fec18765449ef3a5a4cddc23561b97f52.camel@trillion01.com>
         <CAHk-=whoJCocFsQ7+Sqq=dkuzHE+RXxvRdd4ZvyYqnsKBqsKAA@mail.gmail.com>
         <3df541c3-728c-c63d-eaeb-a4c382e01f0b@kernel.dk>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
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

Hi Jens,

On Wed, 2021-05-12 at 14:55 -0600, Jens Axboe wrote:
> 
> > Jens, have you played with core-dumping when there are active
> > io_uring
> > threads? There's a test-program in that github issue report..
> 
> Yes, I also did that again after the report, and did so again right now
> just to verify. I'm not seeing any issues with coredumps being
> generated
> if the app crashes, or if I send it SIGILL, for example... I also just
> now tried Olivier's test case, and it seems to dump just fine for me.
> 
> I then tried backing out the patch from Stefan, and it works fine with
> that reverted too. So a bit puzzled as to what is going on here...
> 
> Anyway, I'll check in on that github thread and see if we can narrow
> this down.
> 
I know that my test case isn't conclusive. It is a failed attempt to
capture what my program is doing.

The priority of investigating my core dump issue has substantially
dropped last week because I did solve my primary issue (A buffer leak
in the provided buffers to io_uring during disconnection). My program
did run for days but it did crash morning without any core dump again.
It is a very frustrating situation because it would probably be a bug
trivial to diagnostic and fix but without the core, the logs are opaque
and they just don't give no clue about why the program did crash.

A key characteristic of my program, it is that it generates at least 1
io-worker thread per io_uring instance.

Oddly enough, I am having a hard time recreating a test case that will
generate io-worker threads.

My first attempt was with the github issue test-case. I have kept
tweaking it and I know that I will find the right sequence to get io-
worker threads spawned.

I suspect that once you meet that condition, it might be sufficient to
trigger the core dump generation problem.

I have also tried to run benchmark io_uring with
https://github.com/frevib/io_uring-echo-server/blob/io-uring-feat-fast-poll/benchmarks/benchmarks.md
(If you give it a try, make sure you erase its private out-of-date
liburing copy before compiling it...)
This didn't generate any io-worker thread neither.

In a nutshell here is what my program does for most of its 85-86
sockets:
1. create TCP socket
2. Set O_NONBLOCK to it
3. Call connect()
4. Use IORING_OP_POLL_ADD with POLLOUT to be notified when the
connection completes
5. Once connection is completed, clear the socket O_NONBLOCK flag, use
IORING_OP_WRITE to send a request
6. Submit a IORING_OP_READ with IOSQE_BUFFER_SELECT to read server
reply asynchronously.

Here are 2 more notes about the sequence:
a) If you wonder about the flip-flop about blocking and non-nblocking,
it is because I have adapated existing code to use io_uring. To
minimize the required code change, I left untouched the non-blocking
connection code.
b) If I add IOSQE_ASYNC to the IORING_OP_READ, io_uring will generate a
lot of io-worker threads. I mean a lot... You can see here:
https://github.com/axboe/liburing/issues/349

So what I am currently doing is to tweak my test-case to emulate as
much as possible the described sequence to have some io-worker threads
spawn and then force a core dump to validate that it is the io-worker
thread presence that is causing the core dump generation issue (or
not!)

Quick question to the devs: Is there any example program bundled with
liburing that is creating some io-workers thread in a sure way?

Greetings,
Olivier


