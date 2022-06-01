Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6147F539E22
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 09:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiFAHYW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 1 Jun 2022 03:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236450AbiFAHYV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 03:24:21 -0400
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B77744EA3A
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 00:24:20 -0700 (PDT)
Received: from [45.44.224.220] (port=40500 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <olivier@trillion01.com>)
        id 1nwIK1-0004JD-LK;
        Wed, 01 Jun 2022 02:59:13 -0400
Message-ID: <78d9a5e2eaad11058f54b1392662099549aa925f.camel@trillion01.com>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Date:   Wed, 01 Jun 2022 02:59:12 -0400
In-Reply-To: <20220326143049.671b463c@kernel.org>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
         <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
         <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <234e3155-e8b1-5c08-cfa3-730cc72c642c@kernel.dk>
         <f6203da1-1bf4-c5f4-4d8e-c5d1e10bd7ea@kernel.dk>
         <20220326143049.671b463c@kernel.org>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 2022-03-26 at 14:30 -0700, Jakub Kicinski wrote:
> On Sat, 26 Mar 2022 15:06:40 -0600 Jens Axboe wrote:
> > On 3/26/22 2:57 PM, Jens Axboe wrote:
> > > > I'd also like to have a conversation about continuing to use
> > > > the socket as a proxy for NAPI_ID, NAPI_ID is exposed to user
> > > > space now. io_uring being a new interface I wonder if it's not 
> > > > better to let the user specify the request parameters
> > > > directly.  
> > > 
> > > Definitely open to something that makes more sense, given we
> > > don't
> > > have to shoehorn things through the regular API for NAPI with
> > > io_uring.  
> > 
> > The most appropriate is probably to add a way to get/set NAPI
> > settings
> > on a per-io_uring basis, eg through io_uring_register(2). It's a
> > bit
> > more difficult if they have to be per-socket, as the polling
> > happens off
> > what would normally be the event wait path.
> > 
> > What did you have in mind?
> 
> Not sure I fully comprehend what the current code does. IIUC it uses
> the socket and the caches its napi_id, presumably because it doesn't
> want to hold a reference on the socket?

Again, the io_uring napi busy_poll integration is strongly inspired
from epoll implementation which caches a single napi_id.

I guess that I did reverse engineer the rational justifying the epoll
design decisions.

If you were to busy poll receive queues for a socket set containing
hundreds of thousands of sockets, would you rather scan the whole
socket set to retrieve which queues to poll or simple iterate through a
list containing a dozen of so of ids?
> 
> This may give the user a false impression that the polling follows 
> the socket. NAPIs may get reshuffled underneath on pretty random
> reconfiguration / recovery events (random == driver dependent).

There is nothing random. When a socket is added to the poll set, its
receive queue is added to the short list of queues to poll.

A very common usage pattern among networking applications it is to
reinsert the socket into the polling set after each polling event. In
recognition to this pattern and to avoid allocating/deallocating memory
to modify the napi_id list all the time, each napi id is kept in the
list until a very long period of inactivity is reached where it is
finally removed to stop the receive queue busy polling.
> 
> I'm not entirely clear how the thing is supposed to be used with TCP
> socket, as from a quick grep it appears that listening sockets don't
> get napi_id marked at all.
> 
> The commit mentions a UDP benchmark, Olivier can you point me to more
> info on the use case? I'm mostly familiar with NAPI busy poll with
> XDP
> sockets, where it's pretty obvious.

https://github.com/lano1106/io_uring_udp_ping

IDK what else I can tell you. I choose to unit test the new feature
with an UDP app because it was the simplest setup for testing. AFAIK,
the ultimate goal of busy polling is to minimize latency in packets
reception and the NAPI busy polling code should not treat differently
packets whether they are UDP or TCP or whatever the type of frames the
NIC does receive...
> 
> My immediate reaction is that we should either explicitly call out
> NAPI
> instances by id in uAPI, or make sure we follow the socket in every
> case. Also we can probably figure out an easy way of avoiding the
> hash
> table lookups and cache a pointer to the NAPI struct.
> 
That is an interesting idea. If this is something that NAPI API would
offer, I would gladly use that to avoid the hash lookup but IMHO, I see
it as a very interesting improvement but hopefully this should not
block my patch...

