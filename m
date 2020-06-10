Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F091F4BAD
	for <lists+io-uring@lfdr.de>; Wed, 10 Jun 2020 05:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgFJDKb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Jun 2020 23:10:31 -0400
Received: from lavender.maple.relay.mailchannels.net ([23.83.214.99]:52820
        "EHLO lavender.maple.relay.mailchannels.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbgFJDKb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Jun 2020 23:10:31 -0400
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 777BE1E14F8;
        Wed, 10 Jun 2020 03:10:29 +0000 (UTC)
Received: from pdx1-sub0-mail-a89.g.dreamhost.com (100-96-6-17.trex.outbound.svc.cluster.local [100.96.6.17])
        (Authenticated sender: dreamhost)
        by relay.mailchannels.net (Postfix) with ESMTPA id 2BA8C1E1393;
        Wed, 10 Jun 2020 03:10:25 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|cosmos@claycon.org
Received: from pdx1-sub0-mail-a89.g.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
        (using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384)
        by 0.0.0.0:2500 (trex/5.18.8);
        Wed, 10 Jun 2020 03:10:29 +0000
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|cosmos@claycon.org
X-MailChannels-Auth-Id: dreamhost
X-Blushing-Wide-Eyed: 720ac0b4460540e5_1591758629286_3215069295
X-MC-Loop-Signature: 1591758629286:3055526191
X-MC-Ingress-Time: 1591758629286
Received: from pdx1-sub0-mail-a89.g.dreamhost.com (localhost [127.0.0.1])
        by pdx1-sub0-mail-a89.g.dreamhost.com (Postfix) with ESMTP id D502FA21F0;
        Tue,  9 Jun 2020 20:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=claycon.org; h=date:from
        :to:cc:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=claycon.org; bh=XO97ZKwXsl2oRlp3OZIZTf6n7gM=; b=
        HxKQZZhgU5I2Md0wa8rBI/2NWUFCR1gOEF9CeOFnt9KJ0ZHidjT5NXHMk0bWd1qN
        mLtBUBw5RPSsXsJS5N8DbnOsn+aNcH4uw8O02n9vUtv1F4gqd04ozTCtGR/b4+6X
        u6WfLE9D5vXDEYEFyMM28422h1p5/qNwihYu8FNsicA=
Received: from ps29521.dreamhostps.com (ps29521.dreamhostps.com [69.163.186.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cosmos@claycon.org)
        by pdx1-sub0-mail-a89.g.dreamhost.com (Postfix) with ESMTPSA id 9B27FA21D4;
        Tue,  9 Jun 2020 20:10:24 -0700 (PDT)
Date:   Tue, 9 Jun 2020 22:10:25 -0500
X-DH-BACKEND: pdx1-sub0-mail-a89
From:   Clay Harris <bugs@claycon.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: Re: io_uring_queue_exit is REALLY slow
Message-ID: <20200610031025.k45qe5slgqxxl7m4@ps29521.dreamhostps.com>
References: <20200607035555.tusxvwejhnb5lz2m@ps29521.dreamhostps.com>
 <c9446121-3229-565c-b946-f0efe6da52ce@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9446121-3229-565c-b946-f0efe6da52ce@kernel.dk>
User-Agent: NeoMutt/20170113 (1.7.2)
X-VR-OUT-STATUS: OK
X-VR-OUT-SCORE: -100
X-VR-OUT-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduhedrudehhedgieekucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuggftfghnshhusghstghrihgsvgdpffftgfetoffjqffuvfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepvehlrgihucfjrghrrhhishcuoegsuhhgshestghlrgihtghonhdrohhrgheqnecuggftrfgrthhtvghrnhepgfdtkeejhefffedvhfehtddtheekjefggeeitdejtdfhuedvgfeiveekkedvhfdvnecukfhppeeiledrudeifedrudekiedrjeegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhppdhhvghlohepphhsvdelhedvuddrughrvggrmhhhohhsthhpshdrtghomhdpihhnvghtpeeiledrudeifedrudekiedrjeegpdhrvghtuhhrnhdqphgrthhhpeevlhgrhicujfgrrhhrihhsuceosghughhssegtlhgrhigtohhnrdhorhhgqedpmhgrihhlfhhrohhmpegsuhhgshestghlrgihtghonhdrohhrghdpnhhrtghpthhtohepihhoqdhurhhinhhgsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Jun 07 2020 at 08:37:30 -0600, Jens Axboe quoth thus:

> On 6/6/20 9:55 PM, Clay Harris wrote:
> > So, I realize that this probably isn't something that you've looked
> > at yet.  But, I was interested in a different criteria looking at
> > io_uring.  That is how efficient it is for small numbers of requests
> > which don't transfer much data.  In other words, what is the minimum
> > amount of io_uring work for which a program speed-up can be obtained.
> > I realize that this is highly dependent on how much overlap can be
> > gained with async processing.
> > 
> > In order to get a baseline, I wrote a test program which performs
> > 4 opens, followed by 4 read + closes.  For the baseline I
> > intentionally used files in /proc so that there would be minimum
> > async and I could set IOSQE_ASYNC later.  I was quite surprised
> > by the result:  Almost the entire program wall time was used in
> > the io_uring_queue_exit() call.
> > 
> > I wrote another test program which does just inits followed by exits.
> > There are clock_gettime()s around the io_uring_queue_init(8, &ring, 0)
> > and io_uring_queue_exit() calls and I printed the ratio of the
> > io_uring_queue_exit() elapsed time and the sum of elapsed time of
> > both calls.
> > 
> > The result varied between 0.94 and 0.99.  In other words, exit is
> > between 16 and 100 times slower than init.  Average ratio was
> > around 0.97.  Looking at the liburing code, exit does just what
> > I'd expect (unmap pages and close io_uring fd).
> > 
> > I would have bet the ratio would be less than 0.50.  No
> > operations were ever performed by the ring, so there should be
> > minimal cleanup.  Even if the kernel needed to do a bunch of
> > cleanup, it shouldn't need the pages mapped into user space to work;
> > same thing for the fd being open in the user process.
> > 
> > Seems like there is some room for optimization here.
> 
> Can you share your test case? And what kernel are you using, that's
> kind of important.
> 
> There's no reason for teardown to be slow, except if you have
> pending IO that we need to either cancel or wait for. Due to
> other reasons, newer kernels will have most/some parts of
> the teardown done out-of-line.

I'm working up a test program for you.

Just FYI:
My initial analysis indicates that closing the io_uring fd is what's
taking all the extra time.

> -- 
> Jens Axboe
