Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF7F185060
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 21:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgCMUdW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 16:33:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbgCMUdW (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 13 Mar 2020 16:33:22 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C08D52073E;
        Fri, 13 Mar 2020 20:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584131601;
        bh=Z5/ANwaJRsxTperPsOjqXDHSTFsjsliL0uw9pV+2bT8=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=y4AuYnGVGvKRDjAaHcCc8XFtWkUoE/v5dSJEAHS2HnBZ/tBJxvsdm8np2CZv9+DLB
         kdG8YrUwsM8ADfSTj4erJMmm9NsDDr26zY8wMsY/GNDN/lohaBoud6qLBnGWHZXKtC
         IzcK6TVHZgciRdEV21NZO+3SbDQv40SQ3W9RtreA=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 943A53522891; Fri, 13 Mar 2020 13:33:21 -0700 (PDT)
Date:   Fri, 13 Mar 2020 13:33:21 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Jens Axboe <axboe@fb.com>, Tejun Heo <tj@kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] io_uring fixes for 5.6-rc
Message-ID: <20200313203321.GD3199@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <00e5ab7d-f0ad-bc94-204a-d2b7fb88f594@fb.com>
 <CAHk-=wgGN-9dmso4L+6RWdouEg4zQfd74m23K6c9E_=Qua+H1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgGN-9dmso4L+6RWdouEg4zQfd74m23K6c9E_=Qua+H1Q@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Mar 13, 2020 at 01:18:30PM -0700, Linus Torvalds wrote:
> On Fri, Mar 13, 2020 at 10:50 AM Jens Axboe <axboe@fb.com> wrote:
> >
> > Just a single fix here, improving the RCU callback ordering from last
> > week. After a bit more perusing by Paul, he poked a hole in the
> > original.
> 
> Ouch.
> 
> If I read this patch correctly, you're now adding a rcu_barrier() onto
> the system workqueue for each io_uring context freeing op.
> 
> This makes me worry:
> 
>  - I think system_wq is unordered, so does it even guarantee that the
> rcu_barrier happens after whatever work you're expecting it to be
> after?
> 
> Or is it using a workqueue not because it wants to serialize with any
> other work, but because it needs to use rcu_barrier in a context where
> it can't sleep?
> 
> But the commit message does seem to imply that ordering is important..
> 
>  - doesn't this have the potential to flood the system_wq be full of
> flushing things that all could take a while..
> 
> I've pulled it, and it may all be correct, just chalk this message up
> to "Linus got nervous looking at it".
> 
> Added Paul and Tejun to the participants explicitly.

The idea is that rcu_barrier() waits for callbacks from all earlier
call_rcu()s to be invoked.  So as long as you know that the call_rcu()
happened earlier than the rcu_barrier(), the rcu_barrier() is guaranteed
to wait for that call_rcu()'s callback.

In this case (and Jens will correct me in the sadly likely event that
I get the story confused), we have a call_rcu() followed by scheduling
work on that same task.  The work has to start executing after it was
scheduled, so if that work does an rcu_barrier(), then that rcu_barrier()
will wait on the call_rcu()'s callback to be invoked.

Jens could invoke the rcu_barrier() just before scheduling the work,
but the synchronous delay from the rcu_barrier() is a problem.

Jens, what did I mess up in the above story?  ;-)

I defer to Jens and Tejun on the possibility of ending up with all
workqueue kthreads waiting on rcu_barrier().  If that is a problem,
there are some ways of dealing with it, though none that I can think of
that come for free.

							Thanx, Paul
