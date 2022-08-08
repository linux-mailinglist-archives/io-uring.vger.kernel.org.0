Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1057558C197
	for <lists+io-uring@lfdr.de>; Mon,  8 Aug 2022 04:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242264AbiHHC1R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Aug 2022 22:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242413AbiHHC1C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Aug 2022 22:27:02 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 39D82B7CF;
        Sun,  7 Aug 2022 19:15:03 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 1420762D0BA;
        Mon,  8 Aug 2022 12:15:02 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oKsIH-00ATVq-0V; Mon, 08 Aug 2022 12:15:01 +1000
Date:   Mon, 8 Aug 2022 12:15:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 2/7] file: add ops to dma map bvec
Message-ID: <20220808021501.GH3861211@dread.disaster.area>
References: <20220805162444.3985535-1-kbusch@fb.com>
 <20220805162444.3985535-3-kbusch@fb.com>
 <20220808002124.GG3861211@dread.disaster.area>
 <YvBjRfy4XzzBajTX@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvBjRfy4XzzBajTX@casper.infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=OJNEYQWB c=1 sm=1 tr=0 ts=62f071a6
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=7-415B0cAAAA:8
        a=8EX0so7LDa7W9hh0J8wA:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 08, 2022 at 02:13:41AM +0100, Matthew Wilcox wrote:
> On Mon, Aug 08, 2022 at 10:21:24AM +1000, Dave Chinner wrote:
> > > +#ifdef CONFIG_HAS_DMA
> > > +	void *(*dma_map)(struct file *, struct bio_vec *, int);
> > > +	void (*dma_unmap)(struct file *, void *);
> > > +#endif
> > 
> > This just smells wrong. Using a block layer specific construct as a
> > primary file operation parameter shouts "layering violation" to me.
> 
> A bio_vec is also used for networking; it's in disguise as an skb_frag,
> but it's there.

Which is just as awful. Just because it's done somewhere else
doesn't make it right.

> > What we really need is a callout that returns the bdevs that the
> > struct file is mapped to (one, or many), so the caller can then map
> > the memory addresses to the block devices itself. The caller then
> > needs to do an {file, offset, len} -> {bdev, sector, count}
> > translation so the io_uring code can then use the correct bdev and
> > dma mappings for the file offset that the user is doing IO to/from.
> 
> I don't even know if what you're proposing is possible.  Consider a
> network filesystem which might transparently be moved from one network
> interface to another.  I don't even know if the filesystem would know
> which network device is going to be used for the IO at the time of
> IO submission.

Sure, but nobody is suggesting we support direct DMA buffer mapping
and reuse for network devices right now, whereas we have working
code for block devices in front of us.

What I want to see is broad-based generic block device based
filesysetm support, not niche functionality that can only work on a
single type of block device. Network filesystems and devices are a
*long* way from being able to do anything like this, so I don't see
a need to cater for them at this point in time.

When someone has a network device abstraction and network filesystem
that can do direct data placement based on that device abstraction,
then we can talk about the high level interface we should use to
drive it....

> I think a totally different model is needed where we can find out if
> the bvec contains pages which are already mapped to the device, and map
> them if they aren't.  That also handles a DM case where extra devices
> are hot-added to a RAID, for example.

I cannot form a picture of what you are suggesting from such a brief
description. Care to explain in more detail?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
