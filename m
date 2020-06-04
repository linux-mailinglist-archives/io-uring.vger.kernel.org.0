Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D96E1EDA74
	for <lists+io-uring@lfdr.de>; Thu,  4 Jun 2020 03:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgFDBas (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 21:30:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:45699 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725983AbgFDBas (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 21:30:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 11BAD5C0106;
        Wed,  3 Jun 2020 21:30:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 03 Jun 2020 21:30:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=4vipdXWneTcdQDAu6JbWhyQeuEq
        wMDjkliQKHSJwEH8=; b=cIwUViirQ9aI81E1h0bKidmTFtjoZ3LThdQfLivnDXP
        2btgd5UtvVfYduXrqevolSErnEYP2HZnQbdnc61HbLzpZdUJc/RvgQpiMGH+bOlb
        6Ivkzm0h2a4JS6qL+aRABncNgBWPKrHvbb+lkJblhT43dkmDPk1Ddf5MBjZdf+BH
        ww74xt8wIMuMw8/aBBQUF0FM3jsARRUK96SqIA+AoX929SoDHZb910EXEchb/2nf
        JaLfrJPWdHt9vuWjtQGARoNXfeE/4QaoMaUi5MxH0tGt7plBif2Yi7tUHTIZ52rC
        EdsfjCMdnHkVk8KWGWBk4XwevOM1KbHD+PVZEbs+xDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4vipdX
        WneTcdQDAu6JbWhyQeuEqwMDjkliQKHSJwEH8=; b=S8YKghCehYdlM9NUVAcy4B
        VSjw0fBXZl7sAnCD5BS8WoUavWx0V3IfVv39aT+ViY8jH3ezW1RJPupIUm5m6NSZ
        4Obj2dJVtVZBSWrh89ONFFxa2U9F833qfyVEnAagdSAF2oryyD4YAMnPYRdF68F/
        nCHzGOnlAx1uXOAgTsfoJPiLGxHC0kMTdBPQlUkoIc050N4blHTk6tlPutvHLlhA
        dGAbC8V54HSB+ElKNShotd9H9NiI0g8ghKxf/PaKkRJ+LmXkm2PYenjhrAPwZM73
        SYx3r+yNZEd0unJs0GEfXMpoorV+t+QJmIp9WwtIp4Uig3F2VGGPx821uhu1Z48A
        ==
X-ME-Sender: <xms:xk7YXjotCgMhjSg8JiQBr5kfok2z4dhwN3EOhuifuvkNSLoi2bpy3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudegtddggeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeetnhgurhgv
    shcuhfhrvghunhguuceorghnughrvghssegrnhgrrhgriigvlhdruggvqeenucggtffrrg
    htthgvrhhnpedukefhkeelueegveetheelffffjeegleeuudelfeefuedtleffueejfffh
    ueffudenucfkphepieejrdduiedtrddvudejrddvhedtnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghnughrvghssegrnhgrrhgriigvlhdr
    uggv
X-ME-Proxy: <xmx:xk7YXtp5ZbUUly9jsELG0yos269NcSSsK1HdpmB3g1LP1-g26LItDA>
    <xmx:xk7YXgMWB8CbJkqyi3wxyO0gtFnStxLx-DmUlnyDcFOxFnAf5qiNpQ>
    <xmx:xk7YXm59ckpYdEnpybu9o4jOV5b-3Q4f7_YWHalDsufJgdx6eV2ZXw>
    <xmx:x07YXiGlKa4Q0ask8n5CAbddDBD-iVvpYiyku3egEYkhUiyFskOWTg>
Received: from intern.anarazel.de (c-67-160-217-250.hsd1.ca.comcast.net [67.160.217.250])
        by mail.messagingengine.com (Postfix) with ESMTPA id 504183280065;
        Wed,  3 Jun 2020 21:30:46 -0400 (EDT)
Date:   Wed, 3 Jun 2020 18:30:45 -0700
From:   Andres Freund <andres@anarazel.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
Message-ID: <20200604013045.7gu7xopreusbdea2@alap3.anarazel.de>
References: <20200526195123.29053-1-axboe@kernel.dk>
 <20200604005916.niy2mejjcsx4sv6t@alap3.anarazel.de>
 <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e3072371-1d6b-8ae5-d946-d83e60427cb0@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-06-03 19:04:17 -0600, Jens Axboe wrote:
> > The workload that triggers the bug within a few seconds is postgres
> > doing a parallel sequential scan of a large table (and aggregating the
> > data, but that shouldn't matter). In the triggering case that boils down
> > to 9 processes sequentially reading a number of 1GB files (we chunk
> > tables internally into smaller files). Each process will read a 512kB
> > chunk of the file on its own, and then claim the next 512kB from a
> > shared memory location. Most of the IO will be READV requests, reading
> > 16 * 8kB into postgres' buffer pool (which may or may not be neighboring
> > 8kB pages).
> 
> I'll try and reproduce this, any chance you have a test case that can
> be run so I don't have to write one from scratch? The more detailed
> instructions the better.

It shouldn't be too hard to write you a detailed script for reproducing
the issue. But it'd not be an all that minimal reproducer, unless it
also triggers on smaller scale (it's a 130GB database that triggers the
problem reliably, and small tables don't seem to do so reliably).

I'll try to write that up after I set up kvm / repro there.

One thing I forgot in the earlier email: I ran the benchmark using 'perf
stat -a -e ...'. I'm fairly, but not absolutely, certain that it also
triggered without that. I don't think it's related, but I thought I
better mention it.


> I have a known issue with request starvation, wonder if that could be it.
> I'm going to rebase the branch on top of the aops->readahead() changes
> shortly, and fix that issue. Hopefully that's what's plaguing your run
> here, but if not, I'll hunt that one down.

FWIW, I had iostat -xm /dev/nvme1n1 1 running during this. Shortly
before the crash I see:

Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
nvme1n1       6221.00    956.09  3428.00  35.53    0.24   157.38    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    1.48  99.00

Device            r/s     rMB/s   rrqm/s  %rrqm r_await rareq-sz     w/s     wMB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dMB/s   drqm/s  %drqm d_await dareq-sz     f/s f_await  aqu-sz  %util
nvme1n1       6456.00    978.83  3439.00  34.75    0.21   155.25    0.00      0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00    0.00     0.00    0.00    0.00    1.38  98.70

It's maybe also worth noting that in this workload the results are
*worse* than when using 5.7-rc7 io_uring. So perhaps request starvation
isn't the worst guess...

Greetings,

Andres Freund
