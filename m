Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD2D658C1DA
	for <lists+io-uring@lfdr.de>; Mon,  8 Aug 2022 04:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiHHCtR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Aug 2022 22:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiHHCtR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Aug 2022 22:49:17 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D903032F;
        Sun,  7 Aug 2022 19:49:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mOJLN4pYorTgDgHUp6RyWTSqCbw6XoYzTeB8WcDahEM=; b=t8zmrKPhyAb3QJgKN1uTD9Ypmk
        tJSzdlfojH3XH9ChjIZHSo+6aD9vXhjSakknQO51Is6we1H3TH5JmW3gBIT4lFQFAozLsfQh/h5Yu
        nDmds5ekTT73HR2G4e6ybbeAst0R4FAfb2LHB45TpITbJrGQzVHvagAIyaeYSAh4oqq8h8e6tBJt4
        RAQ/lZO11jXr7TLfBH9Ua/rCz4bxZfx66PXHdW7nJng95xnCKTyKOQPOBvTdsfZbj501KyOgACz0f
        R+0siTUbHJWulTiNrlZRVSpYMdfkKfzFckH6bwaKcv10SJKmnh9c0MOS9gC8MrM7szjijzExR2N1g
        4ZHrJOSw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oKspJ-00DVmd-6q; Mon, 08 Aug 2022 02:49:09 +0000
Date:   Mon, 8 Aug 2022 03:49:09 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 2/7] file: add ops to dma map bvec
Message-ID: <YvB5pbsfM6QuR5Y7@casper.infradead.org>
References: <20220805162444.3985535-1-kbusch@fb.com>
 <20220805162444.3985535-3-kbusch@fb.com>
 <20220808002124.GG3861211@dread.disaster.area>
 <YvBjRfy4XzzBajTX@casper.infradead.org>
 <20220808021501.GH3861211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808021501.GH3861211@dread.disaster.area>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 08, 2022 at 12:15:01PM +1000, Dave Chinner wrote:
> On Mon, Aug 08, 2022 at 02:13:41AM +0100, Matthew Wilcox wrote:
> > On Mon, Aug 08, 2022 at 10:21:24AM +1000, Dave Chinner wrote:
> > > > +#ifdef CONFIG_HAS_DMA
> > > > +	void *(*dma_map)(struct file *, struct bio_vec *, int);
> > > > +	void (*dma_unmap)(struct file *, void *);
> > > > +#endif
> > > 
> > > This just smells wrong. Using a block layer specific construct as a
> > > primary file operation parameter shouts "layering violation" to me.
> > 
> > A bio_vec is also used for networking; it's in disguise as an skb_frag,
> > but it's there.
> 
> Which is just as awful. Just because it's done somewhere else
> doesn't make it right.
> 
> > > What we really need is a callout that returns the bdevs that the
> > > struct file is mapped to (one, or many), so the caller can then map
> > > the memory addresses to the block devices itself. The caller then
> > > needs to do an {file, offset, len} -> {bdev, sector, count}
> > > translation so the io_uring code can then use the correct bdev and
> > > dma mappings for the file offset that the user is doing IO to/from.
> > 
> > I don't even know if what you're proposing is possible.  Consider a
> > network filesystem which might transparently be moved from one network
> > interface to another.  I don't even know if the filesystem would know
> > which network device is going to be used for the IO at the time of
> > IO submission.
> 
> Sure, but nobody is suggesting we support direct DMA buffer mapping
> and reuse for network devices right now, whereas we have working
> code for block devices in front of us.

But we have working code already (merged) in the networking layer for
reusing pages that are mapped to particular devices.

> What I want to see is broad-based generic block device based
> filesysetm support, not niche functionality that can only work on a
> single type of block device. Network filesystems and devices are a
> *long* way from being able to do anything like this, so I don't see
> a need to cater for them at this point in time.
> 
> When someone has a network device abstraction and network filesystem
> that can do direct data placement based on that device abstraction,
> then we can talk about the high level interface we should use to
> drive it....
> 
> > I think a totally different model is needed where we can find out if
> > the bvec contains pages which are already mapped to the device, and map
> > them if they aren't.  That also handles a DM case where extra devices
> > are hot-added to a RAID, for example.
> 
> I cannot form a picture of what you are suggesting from such a brief
> description. Care to explain in more detail?

Let's suppose you have a RAID 5 of NVMe devices.  One fails and now
the RAID-5 is operating in degraded mode.  So you hot-unplug the failed
device, plug in a new NVMe drive and add it to the RAID.  The pages now
need to be DMA mapped to that new PCI device.

What I'm saying is that the set of devices that the pages need to be
mapped to is not static and cannot be known at "setup time", even given
the additional information that you were proposing earlier in this thread.
It has to be dynamically adjusted.
