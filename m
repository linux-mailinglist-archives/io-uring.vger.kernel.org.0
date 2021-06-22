Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF98D3B1031
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 00:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbhFVWoi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 18:44:38 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:45286 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhFVWoi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 18:44:38 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33486 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lvp65-00031U-1f; Tue, 22 Jun 2021 18:42:21 -0400
Message-ID: <169899caad96c3214d6e380ac7686d054eed3b12.camel@trillion01.com>
Subject: Re: [PATCH 1/2 v2] io_uring: Fix race condition when sqp thread
 goes to sleep
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 22 Jun 2021 18:42:20 -0400
In-Reply-To: <b00eb9407276f54e94ec80e6d80af128de97f10c.camel@trillion01.com>
References: <67c806d0bcf2e096c1b0c7e87bd5926c37231b87.1624387080.git.olivier@trillion01.com>
         <60d23218.1c69fb81.79e86.f345SMTPIN_ADDED_MISSING@mx.google.com>
         <dcc24da6-33d6-ce71-8c87-f0ef4e7f8006@gmail.com>
         <b00eb9407276f54e94ec80e6d80af128de97f10c.camel@trillion01.com>
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

On Tue, 2021-06-22 at 18:37 -0400, Olivier Langlois wrote:
> On Tue, 2021-06-22 at 21:45 +0100, Pavel Begunkov wrote:
> > On 6/22/21 7:55 PM, Olivier Langlois wrote:
> > > If an asynchronous completion happens before the task is
> > > preparing
> > > itself to wait and set its state to TASK_INTERRUPTIBLE, the
> > > completion
> > > will not wake up the sqp thread.
> > > 
> > > Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> > > ---
> > >  fs/io_uring.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > > index fc8637f591a6..02f789e07d4c 100644
> > > --- a/fs/io_uring.c
> > > +++ b/fs/io_uring.c
> > > @@ -6902,7 +6902,7 @@ static int io_sq_thread(void *data)
> > >                 }
> > >  
> > >                 prepare_to_wait(&sqd->wait, &wait,
> > > TASK_INTERRUPTIBLE);
> > > -               if (!io_sqd_events_pending(sqd)) {
> > > +               if (!io_sqd_events_pending(sqd) && !current-
> > > > task_works) {
> > 
> > Agree that it should be here, but we also lack a good enough
> > task_work_run() around, and that may send the task burn CPU
> > for a while in some cases. Let's do
> > 
> > if (!io_sqd_events_pending(sqd) && !io_run_task_work())
> >    ...
> 
> I can do that if you want but considering that the function is inline
> and the race condition is a relatively rare occurence, is the cost
> coming with inline expansion really worth it in this case?
> > 
On hand, there is the inline expansion concern.

OTOH, the benefit of going with your suggestion is that completions
generally precedes new submissions so yes, it might be better that way.

I'm really unsure about this. I'm just raising the concern and I'll let
you make the final decision...


