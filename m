Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE083A4F42
	for <lists+io-uring@lfdr.de>; Sat, 12 Jun 2021 16:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhFLOiT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 12 Jun 2021 10:38:19 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:55432 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbhFLOiS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 12 Jun 2021 10:38:18 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:41668 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1ls4kC-0001KT-UU; Sat, 12 Jun 2021 10:36:16 -0400
Message-ID: <9628ac27c07db760415d382e26b5a0ced41f5851.camel@trillion01.com>
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
From:   Olivier Langlois <olivier@trillion01.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Date:   Sat, 12 Jun 2021 10:36:15 -0400
In-Reply-To: <87sg1p4h0g.fsf_-_@disp2133>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
         <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
         <87h7i694ij.fsf_-_@disp2133>
         <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
         <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
         <87eeda7nqe.fsf@disp2133>
         <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
         <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
         <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
         <87y2bh4jg5.fsf@disp2133>
         <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
         <87sg1p4h0g.fsf_-_@disp2133>
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

On Thu, 2021-06-10 at 15:11 -0500, Eric W. Biederman wrote:
> 
> Olivier Langlois has been struggling with coredumps being incompletely
> written in
> processes using io_uring.
> 
> Olivier Langlois <olivier@trillion01.com> writes:
> > io_uring is a big user of task_work and any event that io_uring made
> > a
> > task waiting for that occurs during the core dump generation will
> > generate a TIF_NOTIFY_SIGNAL.
> > 
> > Here are the detailed steps of the problem:
> > 1. io_uring calls vfs_poll() to install a task to a file wait queue
> >    with io_async_wake() as the wakeup function cb from
> > io_arm_poll_handler()
> > 2. wakeup function ends up calling task_work_add() with TWA_SIGNAL
> > 3. task_work_add() sets the TIF_NOTIFY_SIGNAL bit by calling
> >    set_notify_signal()
> 
> The coredump code deliberately supports being interrupted by SIGKILL,
> and depends upon prepare_signal to filter out all other signals.   Now
> that signal_pending includes wake ups for TIF_NOTIFY_SIGNAL this hack
> in dump_emitted by the coredump code no longer works.
> 
> Make the coredump code more robust by explicitly testing for all of
> the wakeup conditions the coredump code supports.  This prevents
> new wakeup conditions from breaking the coredump code, as well
> as fixing the current issue.
> 
> The filesystem code that the coredump code uses already limits
> itself to only aborting on fatal_signal_pending.  So it should
> not develop surprising wake-up reasons either.
> 
> v2: Don't remove the now unnecessary code in prepare_signal.
> 
> Cc: stable@vger.kernel.org
> Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
> Reported-by: Olivier Langlois <olivier@trillion01.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/coredump.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index 2868e3e171ae..c3d8fc14b993 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -519,7 +519,7 @@ static bool dump_interrupted(void)
>          * but then we need to teach dump_write() to restart and clear
>          * TIF_SIGPENDING.
>          */
> -       return signal_pending(current);
> +       return fatal_signal_pending(current) || freezing(current);
>  }
>  
>  static void wait_for_dump_helpers(struct file *file)

Tested-by: Olivier Langlois <olivier@trillion01.com>


