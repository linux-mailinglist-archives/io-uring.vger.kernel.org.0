Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42AA25828EB
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 16:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiG0Osi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 10:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234162AbiG0Osg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 10:48:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0162DAAB;
        Wed, 27 Jul 2022 07:48:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7633AB8218E;
        Wed, 27 Jul 2022 14:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F578C433D6;
        Wed, 27 Jul 2022 14:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658933313;
        bh=UrnAv0JUvZRBOMkWvoPZsUROAgXpyM4eAmQqkZCCJxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pzfjo/WAa3VADJG2baaY1RgJhwqerFsIRDQ8gVp2Ai937qIX3ZeUOv1lP/sKuIhHU
         jpp0iOq4nau1yQiS0253jmKMK4hqHuzrijxrox9nkP/8crIHRhOeifC6K9nwhouSrt
         wrXT3yWzvjD4NsGnofbNQ1w+/HZGAAB55zMfP+qUOD1gQcx5zm/WrMdr50FjO14+63
         oqNgheQsorkjuRTHwU3zmcsAClW6P0rxjgMBxaHLvN0HtiWAdOv2SFGkH8wHcbTyCx
         8u6ORYBhjX5jTdjxQzoL40gqkY2n9iuMV2FPw/XZvOIFTN8An62cMyx1ftLnOWMGqZ
         Hjf4rlehKiLPw==
Date:   Wed, 27 Jul 2022 08:48:29 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de
Subject: Re: [PATCH 4/5] io_uring: add support for dma pre-mapping
Message-ID: <YuFQPYvOHzpVimJA@kbusch-mbp.dhcp.thefacebook.com>
References: <20220726173814.2264573-1-kbusch@fb.com>
 <20220726173814.2264573-5-kbusch@fb.com>
 <YuFHeT0UaQsYssin@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuFHeT0UaQsYssin@ZenIV>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 27, 2022 at 03:11:05PM +0100, Al Viro wrote:
> On Tue, Jul 26, 2022 at 10:38:13AM -0700, Keith Busch wrote:
> 
> > +	file = fget(map.fd);
> > +	if (!file)
> > +		return -EBADF;
> > +
> > +	if (S_ISBLK(file_inode(file)->i_mode))
> > +		bdev = I_BDEV(file->f_mapping->host);
> > +	else if (S_ISREG(file_inode(file)->i_mode))
> > +		bdev = file->f_inode->i_sb->s_bdev;
> > +	else
> > +		return -EOPNOTSUPP;
> > +
> > +	for (i = map.buf_start; i < map.buf_end; i++) {
> > +		struct io_mapped_ubuf *imu = ctx->user_bufs[i];
> > +		void *tag;
> > +
> > +		if (imu->dma_tag) {
> > +			ret = -EBUSY;
> > +			goto err;
> > +		}
> > +
> > +		tag = block_dma_map(bdev, imu->bvec, imu->nr_bvecs);
> > +		if (IS_ERR(tag)) {
> > +			ret = PTR_ERR(tag);
> > +			goto err;
> > +		}
> > +
> > +		imu->dma_tag = tag;
> > +		imu->dma_file = file;
> > +		imu->bdev = bdev;
> > +	}
> > +
> > +	fput(file);
> 
> This, BTW, is completely insane - what happens if you follow that
> with close(map.fd)?  A bunch of dangling struct file references?

This should have been tied to files registered with the io_uring instance
holding a reference, and cleaned up when the files are unregistered. I may be
missing some cases here, so I'll fix that up.

> I really don't understand what you are trying to do here

We want to register userspace addresses with the block_device just once. We can
skip costly per-IO setup this way.
