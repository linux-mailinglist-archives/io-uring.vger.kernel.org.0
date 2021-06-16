Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5223AA43C
	for <lists+io-uring@lfdr.de>; Wed, 16 Jun 2021 21:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhFPTZY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Jun 2021 15:25:24 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:58004 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhFPTZX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Jun 2021 15:25:23 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:32882 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1ltb88-0000z6-2x; Wed, 16 Jun 2021 15:23:16 -0400
Message-ID: <4163ed48afbcb1c288b366fe2745205cd66bea3d.camel@trillion01.com>
Subject: Re: [PATCH] coredump: Limit what can interrupt coredumps
From:   Olivier Langlois <olivier@trillion01.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov>" <asml.silence@gmail.com>
Date:   Wed, 16 Jun 2021 15:23:14 -0400
In-Reply-To: <87pmwmn5m0.fsf@disp2133>
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

On Tue, 2021-06-15 at 17:08 -0500, Eric W. Biederman wrote:
> Oleg Nesterov <oleg@redhat.com> writes:
> 
> > > --- a/fs/coredump.c
> > > +++ b/fs/coredump.c
> > > @@ -519,7 +519,7 @@ static bool dump_interrupted(void)
> > >          * but then we need to teach dump_write() to restart and
> > > clear
> > >          * TIF_SIGPENDING.
> > >          */
> > > -       return signal_pending(current);
> > > +       return fatal_signal_pending(current) ||
> > > freezing(current);
> > >  }
> > 
> > 
> > Well yes, this is what the comment says.
> > 
> > But note that there is another reason why dump_interrupted()
> > returns true
> > if signal_pending(), it assumes thagt __dump_emit()-
> > >__kernel_write() may
> > fail anyway if signal_pending() is true. Say, pipe_write(), or iirc
> > nfs,
> > perhaps something else...
> > 
> > That is why zap_threads() clears TIF_SIGPENDING. Perhaps it should
> > clear
> > TIF_NOTIFY_SIGNAL as well and we should change io-uring to not
> > abuse the
> > dumping threads?
> > 
> > Or perhaps we should change __dump_emit() to clear signal_pending()
> > and
> > restart __kernel_write() if it fails or returns a short write.
> > 
> > Otherwise the change above doesn't look like a full fix to me.
> 
> Agreed.  The coredump to a pipe will still be short.  That needs
> something additional.
> 
> The problem Olivier Langlois <olivier@trillion01.com> reported was
> core dumps coming up short because TIF_NOTIFY_SIGNAL was being
> set during a core dump.
> 
> We can see this with pipe_write returning -ERESTARTSYS
> on a full pipe if signal_pending which includes TIF_NOTIFY_SIGNAL
> is true.
> 
Eric,

I redid my test but this time instead of dumping directly into a file,
I did let the coredump be piped to the systemd coredump module and the
coredump generation isn't working as expected when piping.

So your code review conclusions are correct.


