Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE3A58356E
	for <lists+io-uring@lfdr.de>; Thu, 28 Jul 2022 01:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiG0XAR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 19:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiG0XAP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 19:00:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3BA6460;
        Wed, 27 Jul 2022 16:00:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 92EC2615E0;
        Wed, 27 Jul 2022 23:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43851C433C1;
        Wed, 27 Jul 2022 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658962813;
        bh=veOAnZxvbOBddmDqvdKGF+NNLNl9hODsSly+sqndRGU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OSgcGmrf5akuzXrwbRYiJXLWazzuUN1l6feWZdmAyRxR0iKaikoaJ+2bCuDcevafF
         TpvVPiOyKX+aopVz26vJJFMDc2lbTtC9dcllju50CnnUDYzI3n/o5t8FAEhZ/3o9c2
         DHC9ZNdYuY7noqXNgPLL+7r4k+vaAMH7q363aqGrVe8m/PBYafExN4+pHk/5Zm8QPR
         giHc0GP83YefYg+niewL0v1TT+MRQVhkX1OmcHkqQnpUMvcTPHb+LDQ6DOrgtuLHsb
         lHtRk/zOarXCIsqPvUaf/hBH8zMzWzpJCxPBLN1kz71C2voFgivlNsmMUkWYNkNCRy
         wF/uGo04iDjKQ==
Date:   Wed, 27 Jul 2022 17:00:09 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Keith Busch <kbusch@fb.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de
Subject: Re: [PATCH 4/5] io_uring: add support for dma pre-mapping
Message-ID: <YuHDeRImQPuuV2Mr@kbusch-mbp.dhcp.thefacebook.com>
References: <20220726173814.2264573-1-kbusch@fb.com>
 <20220726173814.2264573-5-kbusch@fb.com>
 <YuB09cZh7rmd260c@ZenIV>
 <YuFEhQuFtyWcw7rL@kbusch-mbp.dhcp.thefacebook.com>
 <YuFGCO7M29fr3bVB@ZenIV>
 <YuFT+UYxd2QtDPe5@kbusch-mbp.dhcp.thefacebook.com>
 <20220727223232.GV3600936@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220727223232.GV3600936@dread.disaster.area>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 28, 2022 at 08:32:32AM +1000, Dave Chinner wrote:
> On Wed, Jul 27, 2022 at 09:04:25AM -0600, Keith Busch wrote:
> > On Wed, Jul 27, 2022 at 03:04:56PM +0100, Al Viro wrote:
> > > On Wed, Jul 27, 2022 at 07:58:29AM -0600, Keith Busch wrote:
> > > > On Wed, Jul 27, 2022 at 12:12:53AM +0100, Al Viro wrote:
> > > > > On Tue, Jul 26, 2022 at 10:38:13AM -0700, Keith Busch wrote:
> > > > > 
> > > > > > +	if (S_ISBLK(file_inode(file)->i_mode))
> > > > > > +		bdev = I_BDEV(file->f_mapping->host);
> > > > > > +	else if (S_ISREG(file_inode(file)->i_mode))
> > > > > > +		bdev = file->f_inode->i_sb->s_bdev;
> > > > > 
> > > > > *blink*
> > > > > 
> > > > > Just what's the intended use of the second case here?
> > > > 
> > > > ??
> > > > 
> > > > The use case is same as the first's: dma map the user addresses to the backing
> > > > storage. There's two cases here because getting the block_device for a regular
> > > > filesystem file is different than a raw block device.
> > > 
> > > Excuse me, but "file on some filesystem + block number on underlying device"
> > > makes no sense as an API...
> > 
> > Sorry if I'm misunderstanding your concern here.
> > 
> > The API is a file descriptor + index range of registered buffers (which is a
> > pre-existing io_uring API). The file descriptor can come from opening either a
> > raw block device (ex: /dev/nvme0n1), or any regular file on a mounted
> > filesystem using nvme as a backing store.
> 
> That's fundamentally flawed. Filesystems can have multiple block
> devices backing them that the VFS doesn't actually know about (e.g.
> btrfs, XFS, etc). Further, some of these filesystems can spread
> indiivdual file data across mutliple block devices i.e. the backing
> bdev changes as file offset changes....
> 
> Filesystems might not even have a block device (NFS, CIFS, etc) -
> what happens if you call this function on a file belonging to such a
> filesystem?

The block_device driver has to opt-in to this feature. If a multi-device block
driver wants to opt-in to this, then it would be responsible to handle
translating that driver's specific cookie to whatever representation the
drivers it stacks atop require. Otherwise, the cookie threaded through the bio
is an opque value: nothing between io_uring and the block_device driver need to
decode it.

If the block_device doesn't support providing this cookie, then io_uring just
falls back to the existing less optimal methond, and all will continue to work
as it does today.
