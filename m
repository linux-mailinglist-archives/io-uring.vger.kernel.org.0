Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2D53E99DC
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 22:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229655AbhHKUs1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 16:48:27 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:47944 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbhHKUs0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 16:48:26 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:54440 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mDv8q-000667-4E; Wed, 11 Aug 2021 16:48:00 -0400
Message-ID: <cbfa38bf5536fe37850823c68ea23f6c93dda154.camel@trillion01.com>
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
From:   Olivier Langlois <olivier@trillion01.com>
To:     Tony Battersby <tonyb@cybernetics.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
Date:   Wed, 11 Aug 2021 16:47:58 -0400
In-Reply-To: <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
References: <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
         <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
         <87eeda7nqe.fsf@disp2133>
         <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
         <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
         <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
         <87y2bh4jg5.fsf@disp2133>
         <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
         <87sg1p4h0g.fsf_-_@disp2133> <20210614141032.GA13677@redhat.com>
         <87pmwmn5m0.fsf@disp2133>
         <4d93d0600e4a9590a48d320c5a7dd4c54d66f095.camel@trillion01.com>
         <8af373ec-9609-35a4-f185-f9bdc63d39b7@cybernetics.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.3 
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

On Tue, 2021-08-10 at 17:48 -0400, Tony Battersby wrote:
> > 
> I just ran into this problem also - coredumps from an io_uring
> program
> to a pipe are truncated.  But I am using kernel 5.10.57, which does
> NOT
> have commit 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
> or
> commit 06af8679449d ("coredump: Limit what can interrupt
> coredumps"). 
> Kernel 5.4 works though, so I bisected the problem to commit
> f38c7e3abfba ("io_uring: ensure async buffered read-retry is setup
> properly") in kernel 5.9.  Note that my io_uring program uses only
> async
> buffered reads, which may be why this particular commit makes a
> difference to my program.
> 
> My io_uring program is a multi-purpose long-running program with many
> threads.  Most threads don't use io_uring but a few of them do. 
> Normally, my core dumps are piped to a program so that they can be
> compressed before being written to disk, but I can also test writing
> the
> core dumps directly to disk.  This is what I have found:
> 
> *) Unpatched 5.10.57: if a thread that doesn't use io_uring triggers
> a
> coredump, the core file is written correctly, whether it is written
> to
> disk or piped to a program, even if another thread is using io_uring
> at
> the same time.
> 
> *) Unpatched 5.10.57: if a thread that uses io_uring triggers a
> coredump, the core file is truncated, whether written directly to
> disk
> or piped to a program.
> 
> *) 5.10.57+backport 06af8679449d: if a thread that uses io_uring
> triggers a coredump, and the core is written directly to disk, then
> it
> is written correctly.
> 
> *) 5.10.57+backport 06af8679449d: if a thread that uses io_uring
> triggers a coredump, and the core is piped to a program, then it is
> truncated.
> 
> *) 5.10.57+revert f38c7e3abfba: core dumps are written correctly,
> whether written directly to disk or piped to a program.
> 
> Tony Battersby
> Cybernetics
> 
Tony,

this is super interesting details. I'm leaving for few days so I will
not be able to look into it until I am back but here is my
interpretation of your findings:

f38c7e3abfba makes it more likely that your task ends up in a fd read
wait queue. Previously the io_uring req queuing was failing and
returning EAGAIN. Now it ends up using io uring fast poll.

When the core dump gets written through a pipe, pipe_write must block
waiting for some event. If the task gets waken up by the io_uring wait
queue entry instead, it must somehow make pipe_write fails.

So the problem must be a mix of TIF_NOTIFY_SIGNAL and the fact that
io_uring wait queue entries aren't cleaned up while doing the core
dump.

I have a new modif to try out. I'll hopefully be able to submit a patch
to fix that once I come back (I cannot do it now or else, I'll never
leave ;-))


