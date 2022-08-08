Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B71C58C3F8
	for <lists+io-uring@lfdr.de>; Mon,  8 Aug 2022 09:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235326AbiHHHbm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Aug 2022 03:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234798AbiHHHbl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Aug 2022 03:31:41 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0F83A60F5;
        Mon,  8 Aug 2022 00:31:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-193-158.pa.nsw.optusnet.com.au [49.181.193.158])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id EC6C962CFDB;
        Mon,  8 Aug 2022 17:31:36 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oKxEc-00AYwu-SY; Mon, 08 Aug 2022 17:31:34 +1000
Date:   Mon, 8 Aug 2022 17:31:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 2/7] file: add ops to dma map bvec
Message-ID: <20220808073134.GI3861211@dread.disaster.area>
References: <20220805162444.3985535-1-kbusch@fb.com>
 <20220805162444.3985535-3-kbusch@fb.com>
 <20220808002124.GG3861211@dread.disaster.area>
 <YvBjRfy4XzzBajTX@casper.infradead.org>
 <20220808021501.GH3861211@dread.disaster.area>
 <YvB5pbsfM6QuR5Y7@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvB5pbsfM6QuR5Y7@casper.infradead.org>
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=62f0bbd9
        a=SeswVvpAPK2RnNNwqI8AaA==:117 a=SeswVvpAPK2RnNNwqI8AaA==:17
        a=kj9zAlcOel0A:10 a=biHskzXt2R4A:10 a=7-415B0cAAAA:8
        a=W59aziHrq2b68gXyYW4A:9 a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 08, 2022 at 03:49:09AM +0100, Matthew Wilcox wrote:
> On Mon, Aug 08, 2022 at 12:15:01PM +1000, Dave Chinner wrote:
> > On Mon, Aug 08, 2022 at 02:13:41AM +0100, Matthew Wilcox wrote:
> > > On Mon, Aug 08, 2022 at 10:21:24AM +1000, Dave Chinner wrote:
> > > > > +#ifdef CONFIG_HAS_DMA
> > > > > +	void *(*dma_map)(struct file *, struct bio_vec *, int);
> > > > > +	void (*dma_unmap)(struct file *, void *);
> > > > > +#endif
> > > > 
> > > > This just smells wrong. Using a block layer specific construct as a
> > > > primary file operation parameter shouts "layering violation" to me.
> > > 
> > > A bio_vec is also used for networking; it's in disguise as an skb_frag,
> > > but it's there.
> > 
> > Which is just as awful. Just because it's done somewhere else
> > doesn't make it right.
> > 
> > > > What we really need is a callout that returns the bdevs that the
> > > > struct file is mapped to (one, or many), so the caller can then map
> > > > the memory addresses to the block devices itself. The caller then
> > > > needs to do an {file, offset, len} -> {bdev, sector, count}
> > > > translation so the io_uring code can then use the correct bdev and
> > > > dma mappings for the file offset that the user is doing IO to/from.
> > > 
> > > I don't even know if what you're proposing is possible.  Consider a
> > > network filesystem which might transparently be moved from one network
> > > interface to another.  I don't even know if the filesystem would know
> > > which network device is going to be used for the IO at the time of
> > > IO submission.
> > 
> > Sure, but nobody is suggesting we support direct DMA buffer mapping
> > and reuse for network devices right now, whereas we have working
> > code for block devices in front of us.
> 
> But we have working code already (merged) in the networking layer for
> reusing pages that are mapped to particular devices.

Great! How is it hooked up to the network filesystems? I'm kinda
betting that it isn't at all - it's the kernel bypass paths that use
these device based mappings, right? And the user applications are
bound directly to the devices, unlike network filesytsems?

> > What I want to see is broad-based generic block device based
> > filesysetm support, not niche functionality that can only work on a
> > single type of block device. Network filesystems and devices are a
> > *long* way from being able to do anything like this, so I don't see
> > a need to cater for them at this point in time.
> > 
> > When someone has a network device abstraction and network filesystem
> > that can do direct data placement based on that device abstraction,
> > then we can talk about the high level interface we should use to
> > drive it....
> > 
> > > I think a totally different model is needed where we can find out if
> > > the bvec contains pages which are already mapped to the device, and map
> > > them if they aren't.  That also handles a DM case where extra devices
> > > are hot-added to a RAID, for example.
> > 
> > I cannot form a picture of what you are suggesting from such a brief
> > description. Care to explain in more detail?
> 
> Let's suppose you have a RAID 5 of NVMe devices.  One fails and now
> the RAID-5 is operating in degraded mode.

Yes, but this is purely an example of a stacked device type that
requires fined grained mapping of data offset to block device and
offset. When the device fails, it just doesn't return a data mapping
that points to the failed device.

> So you hot-unplug the failed
> device, plug in a new NVMe drive and add it to the RAID.  The pages now
> need to be DMA mapped to that new PCI device.

yup, and now the dma tags for the mappings to that sub-device return
errors, which then tell the application that it needs to remap the
dma buffers it is using.

That's just bog standard error handling - if a bdev goes away,
access to the dma tags have to return IO errors, and it is up to the
application level (i.e. the io_uring code) to handle that sanely.

> What I'm saying is that the set of devices that the pages need to be
> mapped to is not static and cannot be known at "setup time", even given
> the additional information that you were proposing earlier in this thread.
> It has to be dynamically adjusted.

Sure, I'm assuming that IOs based on dma tags will fail if there's a
bdev issue.  The DMA mappings have to be set up somewhere, and it
has to be done before the IO is started. That means there has to be
"discovery" done at "setup time", and if there's an issue between
setup and IO submission, then an error will result and the IO setup
code is going to have to handle that. I can't see how this would
work any other way....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
