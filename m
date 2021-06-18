Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685C33AD356
	for <lists+io-uring@lfdr.de>; Fri, 18 Jun 2021 22:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230338AbhFRUHu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Jun 2021 16:07:50 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:55278 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbhFRUHu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Jun 2021 16:07:50 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33072 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1luKkD-0008K1-VF; Fri, 18 Jun 2021 16:05:38 -0400
Message-ID: <b8327afcd3ba1d9a2d2def40343efb2e79c489b7.camel@trillion01.com>
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
From:   Olivier Langlois <olivier@trillion01.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
Date:   Fri, 18 Jun 2021 16:05:36 -0400
In-Reply-To: <87v96dd1gz.fsf@disp2133>
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
         <4163ed48afbcb1c288b366fe2745205cd66bea3d.camel@trillion01.com>
         <87v96dd1gz.fsf@disp2133>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
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

On Wed, 2021-06-16 at 15:00 -0500, Eric W. Biederman wrote:
> Olivier Langlois <olivier@trillion01.com> writes:
> 
> > I redid my test but this time instead of dumping directly into a
> > file,
> > I did let the coredump be piped to the systemd coredump module and
> > the
> > coredump generation isn't working as expected when piping.
> > 
> > So your code review conclusions are correct.
> 
> Thank you for confirming that.
> 
> Do you know how your test program is using io_uring?
> 
> I have been trying to put the pieces together on what io_uring is
> doing
> that stops the coredump.  The fact that it takes a little while
> before
> it kills the coredump is a little puzzling.  The code looks like all
> of
> the io_uring operations should have been canceled before the coredump
> starts.
> 
> 
With a very simple setup, I guess that this could easily be
reproducible. Make a TCP connection with a server that is streaming
non-stop data and enter a loop where you keep initiating async
OP_IOURING_READ operations on your TCP fd.

Once you have that, manually sending a SIG_SEGV is a sure fire way to
stumble into the problem. This is how I am testing the patches.

IRL, it is possible to call io_uring_enter() to submit operations and
return from the syscall without waiting on all events to have
completed. Once the process is back in userspace, if it stumble into a
bug that triggers a coredump, any remaining pending I/O operations can
set TIF_SIGNAL_NOTIFY while the coredump is generated.

I have read the part of your previous email where you share the result
of your ongoing investigation. I didn't comment as the definitive
references in io_uring matters are Jens and Pavel but I am going to
share my opinion on the matter.

I think that you did put the finger on the code cleaning up the
io_uring instance in regards to pending operations. It seems to be
io_uring_release() which is probably called from exit_files() which
happens to be after the call to exit_mm().

At first, I did entertain the idea of considering if it could be
possible to duplicate some of the operations performed by
io_uring_release() related to the infamous TIF_SIGNAL_NOTIFY setting
into io_uring_files_cancel() which is called before exit_mm().

but the idea is useless as it is not the other threads of the group
that are causing the TIF_SIGNAL_NOTIFY problem. It is the thread
calling do_coredump() which is done by the signal handing code even
before that thread enters do_exit() and start to be cleaned up. That
thread when it enters do_coredump() is still fully loaded and
operational in terms of io_uring functionality.

I guess that this io_uring cancel all pending operations hook would
have to be called from do_coredump or from get_signal() but if it is
the way to go, I feel that this is a change major enough that wouldn't
dare going there without the blessing of the maintainers in cause....


