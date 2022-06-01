Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF800539E20
	for <lists+io-uring@lfdr.de>; Wed,  1 Jun 2022 09:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234238AbiFAHYS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 1 Jun 2022 03:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiFAHYR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Jun 2022 03:24:17 -0400
X-Greylist: delayed 1548 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 01 Jun 2022 00:24:15 PDT
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF274EA3A
        for <io-uring@vger.kernel.org>; Wed,  1 Jun 2022 00:24:15 -0700 (PDT)
Received: from [45.44.224.220] (port=40498 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <olivier@trillion01.com>)
        id 1nwIJX-0004H3-79;
        Wed, 01 Jun 2022 02:58:43 -0400
Message-ID: <954f5b1559d01ff184c6f778a98b37ddedc14d1f.camel@trillion01.com>
Subject: Re: [GIT PULL] io_uring updates for 5.18-rc1
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        io-uring <io-uring@vger.kernel.org>
Date:   Wed, 01 Jun 2022 02:58:42 -0400
In-Reply-To: <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <b7bbc124-8502-0ee9-d4c8-7c41b4487264@kernel.dk>
         <20220326122838.19d7193f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <9a932cc6-2cb7-7447-769f-3898b576a479@kernel.dk>
         <20220326130615.2d3c6c85@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On Sat, 2022-03-26 at 13:06 -0700, Jakub Kicinski wrote:
> On Sat, 26 Mar 2022 13:47:24 -0600 Jens Axboe wrote:
> 
> > Which constants are you referring to? Only odd one I see is
> > NAPI_TIMEOUT, other ones are using the sysctl bits. If we're
> > missing something here, do speak up and we'll make sure it's
> > consistent with the regular NAPI.
> 
> SO_BUSY_POLL_BUDGET, 8 is quite low for many practical uses.
> I'd also like to have a conversation about continuing to use
> the socket as a proxy for NAPI_ID, NAPI_ID is exposed to user
> space now. io_uring being a new interface I wonder if it's not 
> better to let the user specify the request parameters directly.
> 
> 
My napi busy poll integration is strongly inspired from epoll code as
its persistent context is much closer to the io_uring situation than
what select/poll code is doing.

For instance, BUSY_POLL_BUDGET constant is taken straight from epoll
code.

I am a little bit surprised about your questioning. If BUSY_POLL_BUDGET
is quite low for many practical uses, how is it ok to use for epoll
code?

If 8 is not a good default value, may I suggest that you change the
define value?

TBH, I didn't find the documentation about the busy poll budget
parameter so I did assume that existing code was doing the right
thing...

For your other suggestion, I do not think that it is a good idea to let
user specify the request napi ids to busy poll because it would make
the io_uring interface more complex without being even sure that this
is something that people want or need.

select/poll implementation examine each and every sockets on every call
and it can afford to do it since it is rebuilding the polling set every
time through sock_poll().

epoll code does not want to do that as it would defeat its purpose and
it relies on the busy poll global setting. Also, epoll code makes a
pretty bold assumption that its users desiring busy polling will be
willing to create an epoll set per receive queue and presumably run
each set in a dedicated thread.

In:
https://legacy.netdevconf.info/2.1/slides/apr6/dumazet-BUSY-POLLING-Netdev-2.1.pdf

Linux-4.12 changes:
epoll() support was added by Sridhar Samudrala and Alexander Duyck,
with the assumption that an application using epoll() and busy polling
would first make sure that it would classify sockets based on their
receive queue (NAPI ID), and use at least one epoll fd per receive
queue.

To me, this is a very big burden placed on the shoulders of their users
as not every application design can accomodate this requirement. For
instance, I have an Intel igb nic with 8 receive queues. I am not
running my app on a 24 cores machine where I can easily allocate 8
threads just for the networking I/O. I sincerely feel that epoll busy
poll integration has been specifically tailored for the patch authors
needs without all the usability concerns that you appear to have for
the io_uring implementation.

I went beyond what epoll offers by allowing the busy polling of several
receive queues from a single ring.

When I did mention my interest in a napi busy poll to the io_uring list
but I did not know how to proceed due to several unknown issues, Jens
did encourage to give it a shot and in that context, my design goal has
been to keep the initial implementation reasonable and simple.

One concession that could be done to address your concern, it is that
the socket receive queues added to the list of queues busy polled could
be further narrowed by using sk_can_busy_loop() instead of just
checking net_busy_loop_on().

Would that be a satisfactory compromise to you and your team?

