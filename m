Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8EFD14F7B6
	for <lists+io-uring@lfdr.de>; Sat,  1 Feb 2020 13:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726484AbgBAMCe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Feb 2020 07:02:34 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:51229 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726385AbgBAMCd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Feb 2020 07:02:33 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id A706E395;
        Sat,  1 Feb 2020 07:02:32 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sat, 01 Feb 2020 07:02:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=anarazel.de; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=LxTx/iobLleXOvLzif2kKL9QP8/
        JKwT0wGnktjXfOQ8=; b=PcFDXefjONfD5be/SDOLRzsewIJ+tiKu2k81s7uwrqe
        vz1F7NyTX6kVNs0v9xxCs5sBcUPPc6TS5YD60aj5ELfyzy0dKDz6jFWszOpuo83C
        YOMuDxfIewVAo4gF9IznYd0u/CV1uIzXm9anrwdb6+COrTmzV/TWQXbI7EDK18zr
        4qBRhdZ3abYPTZpIsX3CLGurHO7iesel4+rDOnD0aLgCKjD7pFOH/ADHJJqa/T0K
        J0Sf/2ZqLWBFKiPrb+aVmGq0zVN4BQxfPEtCzDQxfzZFBxd//qPCnv44uXyeI+9B
        lqVliwhnyDhAVpOUCncARQMXX6PVUm35/CToe7pzTJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=LxTx/i
        obLleXOvLzif2kKL9QP8/JKwT0wGnktjXfOQ8=; b=elmAbbdmfSp6nIQKrwp81f
        eeehaTs5V4asVQiPN8vEH/11Mz2K/LsJrg4+cMtOTXW77X3GWy6oc+/bYJ2+chOm
        vGCY4Nyd9wOhf8OmrzYvVli34unsPGV5NmG7kArev5oiByFHEP8nR9mDPeBkn7kv
        YV9YftDe0A3SO8nvTAObh+jsGRpM1G1WoC05K3r9Jdwy4VGW1bAehlLr5CNbXQqQ
        i89iuJai7zjySUrTu6jup5ykMv8yQRgaRLQrmsX8t3QNNDqPYzepsfh16g1hie1U
        Q2Uf0XRzExWSgr1FqINy5neLsv/5i3dULMTAb/ZRJKGEaCnzAowi3XZjhf4MD1ZA
        ==
X-ME-Sender: <xms:12g1XlaUbMPj09kxrJqRFDAnNJyMwRTAilQN6vpXKEoLQ7roaZNNcQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrgedvgdefgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomheptehnughrvghs
    ucfhrhgvuhhnugcuoegrnhgurhgvshesrghnrghrrgiivghlrdguvgeqnecukfhppeduhe
    durddvudeirddufeeirdeivdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegrnhgurhgvshesrghnrghrrgiivghlrdguvg
X-ME-Proxy: <xmx:12g1XmyB_ZxAkYjk5Q8DbIGAx02KHBOLQm1BKDITNucohpLuW1w6GA>
    <xmx:12g1XuHCjT5zCiaYBpEYLBd9pUGzAJAxhvIS3kWmt-pxtxD4chW7yg>
    <xmx:12g1XuxDReDrESypyoDpnEzErIVyGIga8kOpNAQgLXRTuI1zbca6xA>
    <xmx:2Gg1XrisoZSp5X77fjykHsq8DrCKkIsiLYPEUCiypirsIl0aBRli6g>
Received: from intern.anarazel.de (unknown [151.216.136.62])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADD363280062;
        Sat,  1 Feb 2020 07:02:31 -0500 (EST)
Date:   Sat, 1 Feb 2020 04:02:29 -0800
From:   Andres Freund <andres@anarazel.de>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: Re: What does IOSQE_IO_[HARD]LINK actually mean?
Message-ID: <20200201120229.l7krkt6zstiruckf@alap3.anarazel.de>
References: <20200201091839.eji7fwudvozr3deb@alap3.anarazel.de>
 <a7d492a6-b8cf-4128-fdde-879371b7913f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a7d492a6-b8cf-4128-fdde-879371b7913f@gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi,

On 2020-02-01 14:30:06 +0300, Pavel Begunkov wrote:
> On 01/02/2020 12:18, Andres Freund wrote:
> > Hi,
> > 
> > Reading the manpage from liburing I read:
> >        IOSQE_IO_LINK
> >               When  this  flag is specified, it forms a link with the next SQE in the submission ring. That next SQE
> >               will not be started before this one completes.  This, in effect, forms a chain of SQEs, which  can  be
> >               arbitrarily  long. The tail of the chain is denoted by the first SQE that does not have this flag set.
> >               This flag has no effect on previous SQE submissions, nor does it impact SQEs that are outside  of  the
> >               chain  tail.  This  means  that multiple chains can be executing in parallel, or chains and individual
> >               SQEs. Only members inside the chain are serialized. Available since 5.3.
> > 
> >        IOSQE_IO_HARDLINK
> >               Like IOSQE_IO_LINK, but it doesn't sever regardless of the completion result.  Note that the link will
> >               still sever if we fail submitting the parent request, hard links are only resilient in the presence of
> >               completion results for requests that did submit correctly.  IOSQE_IO_HARDLINK  implies  IOSQE_IO_LINK.
> >               Available since 5.5.
> > 
> > I can make some sense out of that description of IOSQE_IO_LINK without
> > looking at kernel code. But I don't think it's possible to understand
> > what happens when an earlier chain member fails, and what denotes an
> > error.  IOSQE_IO_HARDLINK's description kind of implies that
> > IOSQE_IO_LINK will not start the next request if there was a failure,
> > but doesn't define failure either.
> > 
> 
> Right, after a "failure" occurred for a IOSQE_IO_LINK request, all subsequent
> requests in the link won't be executed, but completed with -ECANCELED. However,
> if IOSQE_IO_HARDLINK set for the request, it won't sever/break the link and will
> continue to the next one.

I think something along those lines should be added to the manpage... I
think severing the link isn't really a good description, because it's
not like it's separating off the tail to be independent, or such. If
anything it's the opposite.


> > Looks like it's defined in a somewhat adhoc manner. For file read/write
> > subsequent requests are failed if they are a short read/write. But
> > e.g. for sendmsg that looks not to be the case.
> > 
> 
> As you said, it's defined rather sporadically. We should unify for it to make
> sense. I'd prefer to follow the read/write pattern.

I think one problem with that is that it's not necessarily useful to
insist on the length being the maximum allowed length. E.g. for a
recvmsg you'd likely want to not fail the request if you read less than
what you provided for, because that's just a normal occurance. It could
e.g. be useful to just start the next recv (with a different buffer)
immediately.

I'm not even sure it's generally sensible for read either, as that
doesn't work well for EOF, non-file FDs, ... Perhaps there's just no
good solution though.


> > Perhaps it'd make sense to reject use of IOSQE_IO_LINK outside ops where
> > it's meaningful?
> 
> If we disregard it for either length-based operations or the rest ones (or
> whatever combination), the feature won't be flexible enough to be useful,
> but in combination it allows to remove much of context switches.

I really don't want to make it less useful ;) - In fact I'm pretty
excited about having it. I haven't yet implemented / benchmarked that,
but I think for databases it is likely to be very good to achieve low
but consistent IO queue depths for background tasks like checkpointing,
readahead, writeback etc, while still having a low context switch
rates. Without something like IOSQE_IO_LINK it's considerably harder to
have continuous IO that doesn't impact higher priority IO like journal
flushes.

Andres Freund
