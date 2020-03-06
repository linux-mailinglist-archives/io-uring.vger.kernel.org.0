Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D636517C339
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2020 17:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgCFQoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Mar 2020 11:44:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:43274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgCFQoo (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 6 Mar 2020 11:44:44 -0500
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39A3A2072A;
        Fri,  6 Mar 2020 16:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583513083;
        bh=uM6BBzCXa6HAUuOEGiA8P2jf81J77c6GVb5q3IeM3R4=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=suKLdZ7u99Tu+TZXXLBW/DTPMhhpoblbweU/aMPVupcPWtgSo/+q6IAK70+gMPfRL
         ah5o8KFpGEyp2Ul18AA3nzRoMfgJYb3P5A7YF5u3e5JqpvT3J9JTC8iW7bZG8EUK/I
         jZckRz4TQB2vJtmbOVkawf2lRhrHScoF9i7hpsxg=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 0E85935226BF; Fri,  6 Mar 2020 08:44:43 -0800 (PST)
Date:   Fri, 6 Mar 2020 08:44:43 -0800
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Jann Horn <jannh@google.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        io-uring <io-uring@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, tony.luck@intel.com,
        the arch/x86 maintainers <x86@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: KASAN: use-after-free Read in percpu_ref_switch_to_atomic_rcu
Message-ID: <20200306164443.GU2935@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <00000000000067c6df059df7f9f5@google.com>
 <CACT4Y+ZVLs7O84qixsvFqk_Nur1WOaCU81RiCwDf3wOqvHB-ag@mail.gmail.com>
 <3f805e51-1db7-3e57-c9a3-15a20699ea54@kernel.dk>
 <CAG48ez3DUAraFL1+agBX=1JVxzh_e2GR=UpX5JUaoyi+1gQ=6w@mail.gmail.com>
 <075e7fbe-aeec-cb7d-9338-8eb4e1576293@kernel.dk>
 <CAG48ez07bD4sr5hpDhUKe2g5ETk0iYb6PCWqyofPuJbXz1z+hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez07bD4sr5hpDhUKe2g5ETk0iYb6PCWqyofPuJbXz1z+hw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 06, 2020 at 04:36:20PM +0100, Jann Horn wrote:
> On Fri, Mar 6, 2020 at 4:34 PM Jens Axboe <axboe@kernel.dk> wrote:
> > On 3/6/20 7:57 AM, Jann Horn wrote:
> > > +paulmck
> > >
> > > On Wed, Mar 4, 2020 at 3:40 PM Jens Axboe <axboe@kernel.dk> wrote:
> > >> On 3/4/20 12:59 AM, Dmitry Vyukov wrote:
> > >>> On Fri, Feb 7, 2020 at 9:14 AM syzbot
> > >>> <syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com> wrote:
> > >>>>
> > >>>> Hello,
> > >>>>
> > >>>> syzbot found the following crash on:
> > >>>>
> > >>>> HEAD commit:    4c7d00cc Merge tag 'pwm/for-5.6-rc1' of git://git.kernel.o..
> > >>>> git tree:       upstream
> > >>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12fec785e00000
> > >>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e162021ddededa72
> > >>>> dashboard link: https://syzkaller.appspot.com/bug?extid=e017e49c39ab484ac87a
> > >>>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > >>>>
> > >>>> Unfortunately, I don't have any reproducer for this crash yet.
> > >>>>
> > >>>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > >>>> Reported-by: syzbot+e017e49c39ab484ac87a@syzkaller.appspotmail.com
> > >>>
> > >>> +io_uring maintainers
> > >>>
> > >>> Here is a repro:
> > >>> https://gist.githubusercontent.com/dvyukov/6b340beab6483a036f4186e7378882ce/raw/cd1922185516453c201df8eded1d4b006a6d6a3a/gistfile1.txt
> > >>
> > >> I've queued up a fix for this:
> > >>
> > >> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.6&id=9875fe3dc4b8cff1f1b440fb925054a5124403c3
> > >
> > > I believe that this fix relies on call_rcu() having FIFO ordering; but
> > > <https://www.kernel.org/doc/Documentation/RCU/Design/Memory-Ordering/Tree-RCU-Memory-Ordering.html#Callback%20Registry>
> > > says:
> > >
> > > | call_rcu() normally acts only on CPU-local state[...] It simply
> > > enqueues the rcu_head structure on a per-CPU list,

Indeed.  For but one example, if there was a CPU-to-CPU migration between
the two call_rcu() invocations, it would not be at all surprising for
the two callbacks to execute out of order.

> > > Is this fix really correct?
> >
> > That's a good point, there's a potentially stronger guarantee we need
> > here that isn't "nobody is inside an RCU critical section", but rather
> > that we're depending on a previous call_rcu() to have happened. Hence I
> > think you are right - it'll shrink the window drastically, since the
> > previous callback is already queued up, but it's not a full close.
> >
> > Hmm...
> 
> You could potentially hack up the semantics you want by doing a
> call_rcu() whose callback does another call_rcu(), or something like
> that - but I'd like to hear paulmck's opinion on this first.

That would work!

Or, alternatively, do an rcu_barrier() between the two calls to
call_rcu(), assuming that the use case can tolerate rcu_barrier()
overhead and latency.

							Thanx, Paul
