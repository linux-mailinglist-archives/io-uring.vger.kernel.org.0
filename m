Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914343B0D6C
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 21:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhFVTIN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 15:08:13 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:56562 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbhFVTIM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 15:08:12 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33442 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lvlie-0003DP-3y; Tue, 22 Jun 2021 15:05:56 -0400
Message-ID: <32495917a028e9c70b75357029a87ca593378dde.camel@trillion01.com>
Subject: Re: [PATCH v4] io_uring: reduce latency by reissueing the operation
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 22 Jun 2021 15:05:55 -0400
In-Reply-To: <7c47078a-9e2d-badf-a47d-1ca78e1a3253@gmail.com>
References: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
         <678deb93-c4a5-5a14-9687-9e44f0f00b5a@gmail.com>
         <7c47078a-9e2d-badf-a47d-1ca78e1a3253@gmail.com>
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

On Tue, 2021-06-22 at 19:01 +0100, Pavel Begunkov wrote:
> On 6/22/21 6:54 PM, Pavel Begunkov wrote:
> > On 6/22/21 1:17 PM, Olivier Langlois wrote:
> > > 
> > 
> > >  static bool __io_poll_remove_one(struct io_kiocb *req,
> > > @@ -6437,6 +6445,7 @@ static void __io_queue_sqe(struct io_kiocb
> > > *req)
> > >         struct io_kiocb *linked_timeout =
> > > io_prep_linked_timeout(req);
> > >         int ret;
> > >  
> > > +issue_sqe:
> > >         ret = io_issue_sqe(req,
> > > IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
> > >  
> > >         /*
> > > @@ -6456,12 +6465,16 @@ static void __io_queue_sqe(struct
> > > io_kiocb *req)
> > >                         io_put_req(req);
> > >                 }
> > >         } else if (ret == -EAGAIN && !(req->flags &
> > > REQ_F_NOWAIT)) {
> > > -               if (!io_arm_poll_handler(req)) {
> > > +               switch (io_arm_poll_handler(req)) {
> > > +               case IO_APOLL_READY:
> > > +                       goto issue_sqe;
> > > +               case IO_APOLL_ABORTED:
> > >                         /*
> > >                          * Queued up for async execution, worker
> > > will release
> > >                          * submit reference when the iocb is
> > > actually submitted.
> > >                          */
> > >                         io_queue_async_work(req);
> > > +                       break;
> > 
> > Hmm, why there is a new break here? It will miscount
> > @linked_timeout
> > if you do that. Every io_prep_linked_timeout() should be matched
> > with
> > io_queue_linked_timeout().
> 
> Never mind, I said some nonsense and apparently need some coffee

but this is a pertinant question, imho. I guess that you could get away
without it since it is the last case of the switch statement... I am
not sure what kernel coding standard says about that.

However, I can tell you that there was also a break statement at the
end of the case for IO_APOLL_READY and checkpatch.pl did complain about
it saying that it was useless since it was following a goto statement.
Therefore, I did remove that one.

checkpatch.pl did remain silent about the other remaining break. Hence
this is why I left it there.

Greetings,


