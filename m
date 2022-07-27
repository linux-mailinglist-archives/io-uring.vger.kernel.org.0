Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F80582843
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 16:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiG0OLN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 10:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233182AbiG0OLM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 10:11:12 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C10D1ADA6;
        Wed, 27 Jul 2022 07:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=nz8d23NSiWY2hdiOgZOr1vnvRbGOdq9iBMH+yrl+zZA=; b=B6ZH8gfYpTXKq3ix9knpyKtbE7
        ZGotR6GvA1OYCa/5Xgu60cdvZPCUyBzcUussQiMYimCRuhdU/PAIhs8inJ88G4dzwwj8jYONfQosX
        o4aN2vjawAmXYAf/yF81Jvrd+hAl4Q3vKpWjxcZCRvld2NgSfR9q2LI/90hfW4nlt8xyJmrZ2Sech
        pZErCory52ka8FmAwgme6O3FEbrGsCcVQGmmDLltOQrdxqwvMnXqZRxMMDJxXg10OObe9HmBcWkmg
        GtcVohNk/FSANbduyCW4BX6CaJyGg52SdjRyRyTA/iqC4KQFu5icVbX7czaPDemaTgyykT81XS8jE
        quiPH6QQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1oGhkf-00GOD6-Qb;
        Wed, 27 Jul 2022 14:11:05 +0000
Date:   Wed, 27 Jul 2022 15:11:05 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Keith Busch <kbusch@fb.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 4/5] io_uring: add support for dma pre-mapping
Message-ID: <YuFHeT0UaQsYssin@ZenIV>
References: <20220726173814.2264573-1-kbusch@fb.com>
 <20220726173814.2264573-5-kbusch@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726173814.2264573-5-kbusch@fb.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 26, 2022 at 10:38:13AM -0700, Keith Busch wrote:

> +	file = fget(map.fd);
> +	if (!file)
> +		return -EBADF;
> +
> +	if (S_ISBLK(file_inode(file)->i_mode))
> +		bdev = I_BDEV(file->f_mapping->host);
> +	else if (S_ISREG(file_inode(file)->i_mode))
> +		bdev = file->f_inode->i_sb->s_bdev;
> +	else
> +		return -EOPNOTSUPP;
> +
> +	for (i = map.buf_start; i < map.buf_end; i++) {
> +		struct io_mapped_ubuf *imu = ctx->user_bufs[i];
> +		void *tag;
> +
> +		if (imu->dma_tag) {
> +			ret = -EBUSY;
> +			goto err;
> +		}
> +
> +		tag = block_dma_map(bdev, imu->bvec, imu->nr_bvecs);
> +		if (IS_ERR(tag)) {
> +			ret = PTR_ERR(tag);
> +			goto err;
> +		}
> +
> +		imu->dma_tag = tag;
> +		imu->dma_file = file;
> +		imu->bdev = bdev;
> +	}
> +
> +	fput(file);

This, BTW, is completely insane - what happens if you follow that
with close(map.fd)?  A bunch of dangling struct file references?

I really don't understand what you are trying to do here.
