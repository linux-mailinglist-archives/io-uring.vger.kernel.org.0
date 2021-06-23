Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A58223B1B98
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 15:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhFWNzN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 09:55:13 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:37922 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbhFWNzN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 09:55:13 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:33544 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lw3JG-0005gz-KD; Wed, 23 Jun 2021 09:52:54 -0400
Message-ID: <a2ade714df72c0adeb19897811133a0e0244a729.camel@trillion01.com>
Subject: Re: [PATCH 1/2 v2] io_uring: Fix race condition when sqp thread
 goes to sleep
From:   Olivier Langlois <olivier@trillion01.com>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 23 Jun 2021 09:52:53 -0400
In-Reply-To: <2603ffd4-c318-66ed-9807-173159536f6a@gmail.com>
References: <67c806d0bcf2e096c1b0c7e87bd5926c37231b87.1624387080.git.olivier@trillion01.com>
         <60d23218.1c69fb81.79e86.f345SMTPIN_ADDED_MISSING@mx.google.com>
         <dcc24da6-33d6-ce71-8c87-f0ef4e7f8006@gmail.com>
         <b00eb9407276f54e94ec80e6d80af128de97f10c.camel@trillion01.com>
         <169899caad96c3214d6e380ac7686d054eed3b12.camel@trillion01.com>
         <2603ffd4-c318-66ed-9807-173159536f6a@gmail.com>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
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

On Wed, 2021-06-23 at 00:03 +0100, Pavel Begunkov wrote:
> On 6/22/21 11:42 PM, Olivier Langlois wrote:
> > On Tue, 2021-06-22 at 18:37 -0400, Olivier Langlois wrote:
> > > On Tue, 2021-06-22 at 21:45 +0100, Pavel Begunkov wrote:
> > > 
> > > 
> > > I can do that if you want but considering that the function is
> > > inline
> > > and the race condition is a relatively rare occurence, is the
> > > cost
> > > coming with inline expansion really worth it in this case?
> > > > 
> > On hand, there is the inline expansion concern.
> > 
> > OTOH, the benefit of going with your suggestion is that completions
> > generally precedes new submissions so yes, it might be better that
> > way.
> > 
> > I'm really unsure about this. I'm just raising the concern and I'll
> > let
> > you make the final decision...
> 
> It seems it may actually loop infinitely until it gets a signal,
> so yes. And even if not, rare stalls are nasty, they will ruin
> some 9s of latency and hard to catch.
> 
> That part is quite cold anyway, would generate some extra cold
> instructions, meh
> 
I'm not 100% sure to see the infinite loop possibility but I guess that
with some badly placed preemptions, it could take few iterations before
entering the block:

		if (sqt_spin || !time_after(jiffies, timeout)) {

So I will go ahead with your suggestion.

I'll retest the new patch version (it should be a formality) and I'll
resend an update once done.

Greetings,


