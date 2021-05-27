Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D98393256
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 17:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhE0PWn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 11:22:43 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:36896 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbhE0PWn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 11:22:43 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:58504 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lmHor-0007mF-6e; Thu, 27 May 2021 11:21:09 -0400
Message-ID: <1e5c308bd25055ac8a899d40f00df08fc755e066.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: handle signals before letting io-worker exit
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 27 May 2021 11:21:08 -0400
In-Reply-To: <3d1bd9e2-b711-0aac-628e-89b95ff8dbc3@kernel.dk>
References: <60ae94d1.1c69fb81.94f7a.2a35SMTPIN_ADDED_MISSING@mx.google.com>
         <3d1bd9e2-b711-0aac-628e-89b95ff8dbc3@kernel.dk>
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

On Thu, 2021-05-27 at 07:46 -0600, Jens Axboe wrote:
> On 5/26/21 12:21 PM, Olivier Langlois wrote:
> > This is required for proper core dump generation.
> > 
> > Because signals are normally serviced before resuming userspace and
> > an
> > io_worker thread will never resume userspace, it needs to
> > explicitly
> > call the signal servicing functions.
> > 
> > Also, notice that it is possible to exit from the io_wqe_worker()
> > function main loop while having a pending signal such as when
> > the IO_WQ_BIT_EXIT bit is set.
> > 
> > It is crucial to service any pending signal before calling
> > do_exit()
> > Proper coredump generation is relying on PF_SIGNALED to be set.
> > 
> > More specifically, exit_mm() is using this flag to wait for the
> > core dump completion before releasing its memory descriptor.
> > 
> > Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> > ---
> >  fs/io-wq.c | 22 ++++++++++++++++++++--
> >  1 file changed, 20 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/io-wq.c b/fs/io-wq.c
> > index 5361a9b4b47b..b76c61e9aff2 100644
> > --- a/fs/io-wq.c
> > +++ b/fs/io-wq.c
> > @@ -9,8 +9,6 @@
> >  #include <linux/init.h>
> >  #include <linux/errno.h>
> >  #include <linux/sched/signal.h>
> > -#include <linux/mm.h>
> > -#include <linux/sched/mm.h>
> >  #include <linux/percpu.h>
> >  #include <linux/slab.h>
> >  #include <linux/rculist_nulls.h>
> > @@ -193,6 +191,26 @@ static void io_worker_exit(struct io_worker
> > *worker)
> >  
> >         kfree_rcu(worker, rcu);
> >         io_worker_ref_put(wqe->wq);
> > +       /*
> > +        * Because signals are normally serviced before resuming
> > userspace and an
> > +        * io_worker thread will never resume userspace, it needs
> > to explicitly
> > +        * call the signal servicing functions.
> > +        *
> > +        * Also notice that it is possible to exit from the
> > io_wqe_worker()
> > +        * function main loop while having a pending signal such as
> > when
> > +        * the IO_WQ_BIT_EXIT bit is set.
> > +        *
> > +        * It is crucial to service any pending signal before
> > calling do_exit()
> > +        * Proper coredump generation is relying on PF_SIGNALED to
> > be set.
> > +        *
> > +        * More specifically, exit_mm() is using this flag to wait
> > for the
> > +        * core dump completion before releasing its memory
> > descriptor.
> > +        */
> > +       if (signal_pending(current)) {
> > +               struct ksignal ksig;
> > +
> > +               get_signal(&ksig);
> > +       }
> >         do_exit(0);
> >  }
> 
> Do we need the same thing in fs/io_uring.c:io_sq_thread()?
> 
Jens,

You are 100% correct. In fact, this is the same problem for ALL
currently existing and future io threads. Therefore, I start to think
that the right place for the fix might be straight into do_exit()...


