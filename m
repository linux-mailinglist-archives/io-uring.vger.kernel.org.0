Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651893AE0B0
	for <lists+io-uring@lfdr.de>; Sun, 20 Jun 2021 23:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbhFTVdr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 20 Jun 2021 17:33:47 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:59674 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbhFTVdq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 20 Jun 2021 17:33:46 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33270 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lv52S-0001l9-7c; Sun, 20 Jun 2021 17:31:32 -0400
Message-ID: <be356f5f0e951a3b5a76b9369ed7715393e12a15.camel@trillion01.com>
Subject: Re: [PATCH] io_uring: reduce latency by reissueing the operation
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Sun, 20 Jun 2021 17:31:31 -0400
In-Reply-To: <bc6d5e7b-fc63-827f-078b-b3423da0e5f7@gmail.com>
References: <60c13bec.1c69fb81.73967.f06dSMTPIN_ADDED_MISSING@mx.google.com>
         <84e42313-d738-fb19-c398-08a4ed0e0d9c@gmail.com>
         <4b5644bff43e072a98a19d7a5ca36bb5e11497ec.camel@trillion01.com>
         <a7d6f2fd-b59e-e6fa-475a-23962d45b6fa@gmail.com>
         <9938f22a0bb09f344fa5c9c5c1b91f0d12e7566f.camel@trillion01.com>
         <a12e218a-518d-1dac-5e8c-d9784c9850b0@gmail.com>
         <b0a8c92cffb3dc1b48b081e5e19b016fee4c6511.camel@trillion01.com>
         <7d9a481b-ae8c-873e-5c61-ab0a57243905@gmail.com>
         <f511d34b1a1ae5f76c9c4ba1ab87bbf15046a588.camel@trillion01.com>
         <bc6d5e7b-fc63-827f-078b-b3423da0e5f7@gmail.com>
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

On Sun, 2021-06-20 at 21:55 +0100, Pavel Begunkov wrote:
> On 6/18/21 11:45 PM, Olivier Langlois wrote:
> > 
> 
> For io_uring part, e.g. recv is slimmer than recvmsg, doesn't
> need to copy extra.
> 
> Read can be more expensive on the io_uring side because it
> may copy/alloc extra stuff. Plus additional logic on the
> io_read() part for generality.
> 
> But don't expect it to be much of a difference, but never
> tested.

That is super interesting. The way that I see it after getting your
explanations it is that in the worse case scenario, there won't be any
difference but in the best case, I could see a small speed gain.

I made the switch yesterday evening. One of the metric that I monitor
the most is my system reaction time from incoming packets.

I will let you know if switching to recv() is beneficial in that
regard.
> 
> > 
> 
> > > Also, not particularly about reissue stuff, but a note to myself:
> > > 59us is much, so I wonder where the overhead comes from.
> > > Definitely not the iowq queueing (i.e. putting into a list).
> > > - waking a worker?
> > > - creating a new worker? Do we manage workers sanely? e.g.
> > >   don't keep them constantly recreated and dying back.
> > > - scheduling a worker?
> > 
> > creating a new worker is for sure not free but I would remove that
> > cause from the suspect list as in my scenario, it was a one-shot
> > event.
> 
> Not sure what you mean, but speculating, io-wq may have not
> optimal policy for recycling worker threads leading to
> recreating/removing more than needed. Depends on bugs, use
> cases and so on.

Since that I absolutely don't use the async workers feature I was
obsessed about the fact that I was seeing a io worker created. This is
root of why I ended up writing the patch.

My understanding of how io worker life scope are managed, it is that
one remains present once created.

In my scenario, once that single persistent io worker thread is
created, no others are ever created. So this is a one shot cost. I was
prepared to eliminate the first measurement to be as fair as possible
and not pollute the async performance result with a one time only
thread creation cost but to my surprise... The thread creation cost was
not visible in the first measurement time...

From that, maybe this is an erroneous shortcut, I do not feel that
thread creation is the bottleneck.
> 
> > First measurement was even not significantly higher than all the
> > other
> > measurements.
> 
> You get a huge max for io-wq case. Obviously nothing can be
> said just because of max. We'd need latency distribution
> and probably longer runs, but I'm still curious where it's
> coming from. Just keeping an eye in general

Maybe it is scheduling...

I'll keep this mystery in the back of my mind in case that I would end
up with a way to find out where the time is spend...

> > 

