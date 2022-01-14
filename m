Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4801A48F201
	for <lists+io-uring@lfdr.de>; Fri, 14 Jan 2022 22:25:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiANVZS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jan 2022 16:25:18 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42177 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbiANVZR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jan 2022 16:25:17 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 143695C00BA;
        Fri, 14 Jan 2022 16:25:15 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 14 Jan 2022 16:25:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rydia.net; h=
        date:from:to:cc:subject:in-reply-to:message-id:references
        :mime-version:content-type; s=fm3; bh=cXaX/y4++G86KDs5IXG+C4Jaj0
        pxQr++cphVmQblQ8M=; b=gGGcd29gNL4oKe0z55HQuPNQGK4AOJ1I2XHd4bypb/
        pTTBkDjK8NUYsY3SrhYznf+8D/3V3vawb3k9Ou20IETFI0Jkjqz7UTBNyfsxH9/9
        iAsoSBg00ECjCO+pTmKi1BDHGvh4LTPwFhrnbDO1cw7Xa5GrYTfh55nyby6QxuLt
        CeYAUagkelg9IO6mYSOBSHGqrU+8UqMi4YBwTN2Nk1Cdw+aIxLcVbDTTBmDzxeor
        XYXCfFWzOcw3TzmSM61OUL0uarwRWH+Aof03gXqzMs0MJ2HFoBfTXGlrzhWoJW5s
        zg/PWuKDuiu6nAz71Iu/i1P4qrZkk+5QSJb4KVML/gtg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=cXaX/y
        4++G86KDs5IXG+C4Jaj0pxQr++cphVmQblQ8M=; b=X7HAY/fj4yR2vgkOAzk55e
        5RufPwSE8baxdFrFV/19RE1XnYiyaRyI9HDsfyScxF45F0vIB7iLxVt7YyFnKthD
        VuKCkMbYHeP/XXx/leq9jD2IE7I+ekY3gdlvy8hc8JTyxQItpd15DNCQdI+4OFrI
        7bsbWgr8gmIYSPb8lEGnB33oNvK4L1uhxbJKqzWqqTnc9sD6PGYzi6McAok+6uYD
        yPfYmQeaZNr5wOKhdtgC3wZ8uurS3VXH88dMqXjYV9AJHNGwDpvtKjET6Ja50KyD
        QK6P1vyUoPq3AkL+GMsehgDlkatIBM0lrO1nLVqUCDz8JQQNvRUayLTAhGskJkow
        ==
X-ME-Sender: <xms:OurhYTs-usJI-LjrRNDL4MsBXDmT-8RRV6hoclGsejqpI55xwTzhgQ>
    <xme:OurhYUedjw0Adry3VX2y_KKjv-SPqXQfu8TYNoTsm723gUn2C1bznih9_e9jq3Zmu
    RiLwbBZFLSMunV_SnI>
X-ME-Received: <xmr:OurhYWwZSFQIFnZhvl49acaQTI5R-dk8eZFJWuCdE3c_TA1Tc2fHuqRUsuEDRG5Wk8WOUonN8fi4arh-oZsMZm6dLzoo5T7neufPqi3YcgmcHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrtdehgddugeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvufgjkfhfgggtsehttdertd
    dttddvnecuhfhrohhmpeguohhrmhgrnhguohcuoeguohhrmhgrnhguohesrhihughirgdr
    nhgvtheqnecuggftrfgrthhtvghrnhepkeefueegteejhfeitedvhfejgeefleeffffghe
    efieejieehiedvjeeftefhvdffnecuffhomhgrihhnpehgihhthhhusgdrtghomhdpihho
    uhhrihhnghhsuhgsmhhishhsihhonhhquhgvuhgvrdhjrghvrgdpihhouhhrihhnghgtoh
    hmphhlvghtihhonhhquhgvuhgvrdhjrghvrgdpihhouhhrihhnghgvvhgvnhhtlhhoohhp
    rdhjrghvrgenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpeguohhrmhgrnhguohesrhihughirgdrnhgvth
X-ME-Proxy: <xmx:OurhYSNH_QUbYcYkFcvH8dL5zqeLoNjIAghEW-5F92KOBQdi-RFPLA>
    <xmx:OurhYT-ASEXFloHgOsHUB0GT4hhQAVpDyhZ8UBmKXSSk2sjWD8gjcg>
    <xmx:OurhYSXREQB53UtzlnyQtJruJK1oWXdBM9gsePmkUvcOZCintaqccQ>
    <xmx:O-rhYQF4_o1MJ6_q7zSDbajpXH5wWz8It5jHsF_DbIcAezqYW_ktng>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Jan 2022 16:25:14 -0500 (EST)
Date:   Fri, 14 Jan 2022 13:25:13 -0800 (PST)
From:   dormando <dormando@rydia.net>
To:     Josef <josef.grieb@gmail.com>
cc:     io-uring <io-uring@vger.kernel.org>
Subject: Re: User questions: client code and SQE/CQE starvation
In-Reply-To: <CAAss7+qkBUzADaG+B6WTHz5hdZbbGvLFkD56sRhUzni7Js7amA@mail.gmail.com>
Message-ID: <c030a93d-7a6b-5b66-627d-13e3cf25b8aa@rydia.net>
References: <e354897-adca-114-3830-4cc243f99fc1@rydia.net> <CAAss7+q_qjYBbiN+RaGrd3ngOPPGRwJiQU+Gkq1YPzfy7X8wqg@mail.gmail.com> <CAAss7+qkBUzADaG+B6WTHz5hdZbbGvLFkD56sRhUzni7Js7amA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On Fri, 14 Jan 2022, Josef wrote:

> sorry i accidentally pressed send message...
>
> run out of SQE should not be problem, when
> io_uring_get_sqe(https://github.com/axboe/liburing/blob/master/src/queue.c#L409)
> returns a null, you can run io_uring_submit
> in netty we do that automatically when its full
> https://github.com/netty/netty-incubator-transport-io_uring/blob/main/transport-classes-io_uring/src/main/java/io/netty/incubator/channel/uring/IOUringSubmissionQueue.java#L117

Thanks! Unless I'm completely misreading the liburing code,
io_uring_submit() can return EBUSY and fail to submit the sqe's, if there
is currently a queue of CQE's beyond the limit (ie; FEAT_NODROP). Which
would mean you can't reliably submit when get_sqe() returns NULL? I hope I
have this wrong since it would be much simpler otherwise :)

> In theory you could run out of CQE, netty io_uring approach is a little
> bit different.
> https://github.com/netty/netty-incubator-transport-io_uring/blob/main/transport-classes-io_uring/src/main/java/io/netty/incubator/channel/uring/IOUringCompletionQueue.java#L86
> (similar to io_uring_for_each_cqe) to make sure the kernel sees that and
> the process function is called here
> https://github.com/netty/netty-incubator-transport-io_uring/blob/main/transport-classes-io_uring/src/main/java/io/netty/incubator/channel/uring/IOUringEventLoop.java#L203

Thanks. I'll study these a bit more.

>
>
> > On Wed, 12 Jan 2022 at 22:17, dormando <dormando@rydia.net> wrote:
> > >
> > > Hey,
> > >
> > > Been integrating io_uring in my stack which has been going well-ish.
> > > Wondering if you folks have seen implementations of client libraries that
> > > feel clean and user friendly?
> > >
> > > IE: with poll/select/epoll/kqueue most client libraries (like libcurl)
> > > implement functions like "client_send_data(ctx, etc)", which returns
> > > -WANT_READ/-WANT_WRITE/etc and an fd if it needs more data to move
> > > forward. With the syscalls themselves externalized in io_uring I'm
> > > struggling to come up with abstractions I like and haven't found much
> > > public on a googlin'. Do any public ones exist yet?
> > >
> > > On implementing networked servers, it feels natural to do a core loop
> > > like:
> > >
> > >       while (1) {
> > >           io_uring_submit_and_wait(&t->ring, 1);
> > >
> > >           uint32_t head = 0;
> > >           uint32_t count = 0;
> > >
> > >           io_uring_for_each_cqe(&t->ring, head, cqe) {
> > >
> > >               event *pe = io_uring_cqe_get_data(cqe);
> > >               pe->callback(pe->udata, cqe);
> > >
> > >               count++;
> > >           }
> > >           io_uring_cq_advance(&t->ring, count);
> > >       }
> > >
> > > ... but A) you can run out of SQE's if they're generated from within
> > > callbacks()'s (retries, get further data, writes after reads, etc).
> > > B) Run out of CQE's with IORING_FEAT_NODROP and can no longer free up
> > > SQE's
> > >
> > > So this loop doesn't work under pressure :)
> > >
> > > I see that qemu's implementation walks an object queue, which calls
> > > io_uring_submit() if SQE's are exhausted. I don't recall it trying to do
> > > anything if submit returns EBUSY because of CQE exhaustion? I've not found
> > > other merged code implementing non-toy network servers and most examples
> > > are rewrites of CLI tooling which are much more constrained problems. Have
> > > I missed anything?
> > >
> > > I can make this work but a lot of solutions are double walking lists
> > > (fetch all CQE's into an array, advance them, then process), or not being
> > > able to take advantage of any of the batching API's. Hoping the
> > > community's got some better examples to untwist my brain a bit :)
> > >
> > > For now I have things working but want to do a cleanup pass before making
> > > my clients/server bits public facing.
> > >
> > > Thanks!
> > > -Dormando
> >
> >
> >
> > --
> > Josef Grieb
>
> --
> Josef Grieb
>
