Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3686583FE9
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 15:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbiG1NZq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Jul 2022 09:25:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238051AbiG1NZp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Jul 2022 09:25:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A8039B92;
        Thu, 28 Jul 2022 06:25:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD239B80171;
        Thu, 28 Jul 2022 13:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C213AC433D6;
        Thu, 28 Jul 2022 13:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659014741;
        bh=SIh451UOcr5P1ZCc5zO+DXTL5bn6jrzBhDakMU5uaXk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d4fyPdHKmYH+9jSIi/OFSrp+usiba4BARaXzUEdw/Vg6F51YzPcr+GlXTj4J428uW
         Vc5AdT3NPuKTnbs+tcvGw4jKh4x1G/qNx0ZXk4D+R2fFiKD9jV6x58uUZuZw0UgDtp
         r9Ne4++h5myKt/d2wpYAhv/ulTKK6MZrgvBF88siYvLycPng7h8vf33oTTUltOd6dT
         fXu19t8l4X6Ngn07OLOq1EEL0ZEXlM3YVFhHkGtwo/Zzw6rjyyjWqiRImgEaZDrqxy
         mVm1vZYYi+JjZVBGHYvIFKaSFYBNt5p6TObsbNCMRFowbSqK5EOEAJAgI2qlSDAo4v
         6OgN3S6YuuVVw==
Date:   Thu, 28 Jul 2022 07:25:38 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@fb.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de
Subject: Re: [PATCH 4/5] io_uring: add support for dma pre-mapping
Message-ID: <YuKOUh6MJGGFuIm/@kbusch-mbp.dhcp.thefacebook.com>
References: <20220726173814.2264573-1-kbusch@fb.com>
 <20220726173814.2264573-5-kbusch@fb.com>
 <YuB09cZh7rmd260c@ZenIV>
 <YuFEhQuFtyWcw7rL@kbusch-mbp.dhcp.thefacebook.com>
 <YuFGCO7M29fr3bVB@ZenIV>
 <YuFT+UYxd2QtDPe5@kbusch-mbp.dhcp.thefacebook.com>
 <20220727223232.GV3600936@dread.disaster.area>
 <YuHDeRImQPuuV2Mr@kbusch-mbp.dhcp.thefacebook.com>
 <20220728023511.GX3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728023511.GX3600936@dread.disaster.area>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 28, 2022 at 12:35:11PM +1000, Dave Chinner wrote:
> On Wed, Jul 27, 2022 at 05:00:09PM -0600, Keith Busch wrote:
> > The block_device driver has to opt-in to this feature. If a multi-device block
> > driver wants to opt-in to this, then it would be responsible to handle
> > translating that driver's specific cookie to whatever representation the
> > drivers it stacks atop require. Otherwise, the cookie threaded through the bio
> > is an opque value: nothing between io_uring and the block_device driver need to
> > decode it.
> 
> I'm not talking about "multi-device" block devices like we build
> with DM or MD to present a single stacked block device to the
> filesystem. I'm talking about the fact that both btrfs and XFS
> support multiple *independent* block devices in the one filesystem.
> 
> i.e.:
> 
> # mkfs.xfs -r rtdev=/dev/nvme0n1 -l logdev=/dev/nvme1n1,size=2000m /dev/nvme2n1
> meta-data=/dev/nvme2n1           isize=512    agcount=4, agsize=22893287 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=0
>          =                       reflink=0    bigtime=1 inobtcount=1 nrext64=0
> data     =                       bsize=4096   blocks=91573146, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =/dev/nvme1n1           bsize=4096   blocks=512000, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =/dev/nvme0n1           extsz=4096   blocks=91573146, rtextents=91573146
> #
> 
> This builds an XFS filesystem which can write file data to either
> /dev/nvme0n1 or /dev/nvme2n1, and journal IO will get sent to a
> third block dev (/dev/nvme1n1).
> 
> So, which block device do we map for the DMA buffers that contain
> the file data for any given file in that filesystem? There is no
> guarantee that is is sb->s_bdev, because it only points at one of
> the two block devices that can contain file data.
> 
> Btrfs is similar, but it might stripe data across /dev/nvme0n1,
> /dev/nvme1n1 and /dev/nvme2n1 for a single file writes (and hence
> reads) and so needs separate DMA mappings for each block device just
> to do IO direct to/from one file....
> 
> Indeed, for XFS there's no requirement that the block devices have
> the same capabilities or even storage types - the rtdev could be
> spinning disks, the logdev an nvme SSD, and the datadev is pmem. If
> XFs has to do something special, it queries the bdev it needs to
> operate on (e.g. DAX mappings are only allowed on pmem based
> devices).
> 
> Hence it is invalid to assume that sb->s_bdev points at the actual
> block device the data for any given regular file is stored on. It is
> also invalid to assume the characteristics of the device in
> sb->s_bdev are common for all files in the filesystem.
> 
> IOWs, the only way you can make something like this work via
> filesystem mapping infrastructure to translate file offset to
> to a {dev, dev_offset} tuple to tell you what persistently mapped
> device buffers you need to use for IO to the given file {offset,len}
> range that IO needs to be done on....

Thank you for the explanation. I understand now, sorry for my previous
misunderstanding.

I may consider just initially supporting direct raw block devices if I can't
find a viable solution quick enough.
