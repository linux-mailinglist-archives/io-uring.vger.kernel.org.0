Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 495FA58293D
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 17:04:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiG0PEe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 11:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233497AbiG0PEb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 11:04:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2890746D87;
        Wed, 27 Jul 2022 08:04:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B93D0618B4;
        Wed, 27 Jul 2022 15:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A1EC433C1;
        Wed, 27 Jul 2022 15:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658934269;
        bh=HFb8X/HqRK8bv/tpwPJwNOjVs0MnycxP/qMIKdDeQEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NxEh6TKqeAqFSEzKhR+k+oDo+uy9ugBHqZ/VOptXoQdug5xACDoifBV91s9ymijBq
         27B0sKfoXUEUz82oR2d5xOZWUjo4ioDlcgnCEslJZsn0jyVo5PSqx/tOQQffBNx4s1
         Wg3Zy8meB3ivWuM8x07/vBxXmcOX5/ErXCKHyS0nJ4kyrpKq/5gNbX8e6cMd0eLi7s
         hi1eXTmrFLmZpocwqHm90sgKqcF61Y2YBDmf9+KUoJSYiyeaztfJFoRqJOV9EOfiKO
         xkbD8+kfSo/NNj/lZgvJA/1hh24m291WuBg7N11PosfB17RVIv2vhqYvYE9X6uPN+v
         zARmtezSmldcw==
Date:   Wed, 27 Jul 2022 09:04:25 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de
Subject: Re: [PATCH 4/5] io_uring: add support for dma pre-mapping
Message-ID: <YuFT+UYxd2QtDPe5@kbusch-mbp.dhcp.thefacebook.com>
References: <20220726173814.2264573-1-kbusch@fb.com>
 <20220726173814.2264573-5-kbusch@fb.com>
 <YuB09cZh7rmd260c@ZenIV>
 <YuFEhQuFtyWcw7rL@kbusch-mbp.dhcp.thefacebook.com>
 <YuFGCO7M29fr3bVB@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuFGCO7M29fr3bVB@ZenIV>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 27, 2022 at 03:04:56PM +0100, Al Viro wrote:
> On Wed, Jul 27, 2022 at 07:58:29AM -0600, Keith Busch wrote:
> > On Wed, Jul 27, 2022 at 12:12:53AM +0100, Al Viro wrote:
> > > On Tue, Jul 26, 2022 at 10:38:13AM -0700, Keith Busch wrote:
> > > 
> > > > +	if (S_ISBLK(file_inode(file)->i_mode))
> > > > +		bdev = I_BDEV(file->f_mapping->host);
> > > > +	else if (S_ISREG(file_inode(file)->i_mode))
> > > > +		bdev = file->f_inode->i_sb->s_bdev;
> > > 
> > > *blink*
> > > 
> > > Just what's the intended use of the second case here?
> > 
> > ??
> > 
> > The use case is same as the first's: dma map the user addresses to the backing
> > storage. There's two cases here because getting the block_device for a regular
> > filesystem file is different than a raw block device.
> 
> Excuse me, but "file on some filesystem + block number on underlying device"
> makes no sense as an API...

Sorry if I'm misunderstanding your concern here.

The API is a file descriptor + index range of registered buffers (which is a
pre-existing io_uring API). The file descriptor can come from opening either a
raw block device (ex: /dev/nvme0n1), or any regular file on a mounted
filesystem using nvme as a backing store.

You don't need to know about specific block numbers. You can use the result
with any offset in the underlying block device.

This also isn't necessarily tied to nvme-pci; that's just the only low-level
driver I've enabled in this series, but others may come later.
