Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A4F582812
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 15:58:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbiG0N6z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 09:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbiG0N6e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 09:58:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0679D3DBC7;
        Wed, 27 Jul 2022 06:58:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 990396177A;
        Wed, 27 Jul 2022 13:58:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605FDC433C1;
        Wed, 27 Jul 2022 13:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658930313;
        bh=17GP6FcLTV3Rd1Cweg5aWI41jqGfgh4ZCwrLv6DSbNY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U0XYX2AGZyJwdWANtRg6LpwcQuvl+xr2HLGkGWnpFK5y9KS+L7APi/5fmpqxLrmt8
         pi08uxzPVmGID7HPPwwV4MzMyj08Yt3sr/xeoriz1WkIEcFVHuvWLkTEARGo7A/ks1
         +IxvxeQNCcx2xHYDlk83yCjWDdAowVnr6Y0DQRVdNkCX1dOVmpE5SEJ2KRGuyvuEx3
         qqGf6CbF/zgA/bzKOBBRboLeqjO5JE4wVWtVKnheMazRD0815JGRWFUg22GuTGZS0P
         87hj+zrYLG6G+eZBrzr+EKBDDRv5M2CpCTffLva8z06ztsvgl0ChFqYyA8J5a0/CK2
         qR1D574xhT7Tg==
Date:   Wed, 27 Jul 2022 07:58:29 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de
Subject: Re: [PATCH 4/5] io_uring: add support for dma pre-mapping
Message-ID: <YuFEhQuFtyWcw7rL@kbusch-mbp.dhcp.thefacebook.com>
References: <20220726173814.2264573-1-kbusch@fb.com>
 <20220726173814.2264573-5-kbusch@fb.com>
 <YuB09cZh7rmd260c@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuB09cZh7rmd260c@ZenIV>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 27, 2022 at 12:12:53AM +0100, Al Viro wrote:
> On Tue, Jul 26, 2022 at 10:38:13AM -0700, Keith Busch wrote:
> 
> > +	if (S_ISBLK(file_inode(file)->i_mode))
> > +		bdev = I_BDEV(file->f_mapping->host);
> > +	else if (S_ISREG(file_inode(file)->i_mode))
> > +		bdev = file->f_inode->i_sb->s_bdev;
> 
> *blink*
> 
> Just what's the intended use of the second case here?

??

The use case is same as the first's: dma map the user addresses to the backing
storage. There's two cases here because getting the block_device for a regular
filesystem file is different than a raw block device.
