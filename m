Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6A3582831
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 16:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbiG0OFK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 10:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiG0OFJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 10:05:09 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487DD1BA;
        Wed, 27 Jul 2022 07:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=87PpohpIQw2/2uejY1wH41QfeQi8AtRn7VZFb7SjhYA=; b=umCU0DL1bjKE1YAZuuK/2KMKIR
        va3iBrAYx+CAGHHWzo199YCpVxiTZhrsNZuAqt/isCyAbeSHmTtePkotiiL10FMsFM7TFP97de5HV
        WZVZXQ5Te55WFKRBD8G05o5sjnN02sjWq83oX036/zWLWYwLOotLOvZA0IPiin+6pJ1eNBPDTqGbv
        pRVTcEX2u6YwV0gmW9m6oxoXErCQaNOagKV5DlYuB1aYv7hN0aOJxGnoe2h0Wz4MInQRwDcUOrzpu
        6WX2ErHHV7GxOjOC1M78bgtLWkwdMiBq9O2GldjJVjaYwRauNtQp8y2W3/tmaGSf5iv4H4hi2h9NI
        GZPJno8w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1oGhei-00GNnL-BO;
        Wed, 27 Jul 2022 14:04:56 +0000
Date:   Wed, 27 Jul 2022 15:04:56 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de
Subject: Re: [PATCH 4/5] io_uring: add support for dma pre-mapping
Message-ID: <YuFGCO7M29fr3bVB@ZenIV>
References: <20220726173814.2264573-1-kbusch@fb.com>
 <20220726173814.2264573-5-kbusch@fb.com>
 <YuB09cZh7rmd260c@ZenIV>
 <YuFEhQuFtyWcw7rL@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuFEhQuFtyWcw7rL@kbusch-mbp.dhcp.thefacebook.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 27, 2022 at 07:58:29AM -0600, Keith Busch wrote:
> On Wed, Jul 27, 2022 at 12:12:53AM +0100, Al Viro wrote:
> > On Tue, Jul 26, 2022 at 10:38:13AM -0700, Keith Busch wrote:
> > 
> > > +	if (S_ISBLK(file_inode(file)->i_mode))
> > > +		bdev = I_BDEV(file->f_mapping->host);
> > > +	else if (S_ISREG(file_inode(file)->i_mode))
> > > +		bdev = file->f_inode->i_sb->s_bdev;
> > 
> > *blink*
> > 
> > Just what's the intended use of the second case here?
> 
> ??
> 
> The use case is same as the first's: dma map the user addresses to the backing
> storage. There's two cases here because getting the block_device for a regular
> filesystem file is different than a raw block device.

Excuse me, but "file on some filesystem + block number on underlying device"
makes no sense as an API...
