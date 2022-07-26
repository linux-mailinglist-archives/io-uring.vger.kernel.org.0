Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC82581C57
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 01:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiGZXNB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 19:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiGZXNB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 19:13:01 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EFEB57;
        Tue, 26 Jul 2022 16:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=guB1cTIS1RRgHxlh1DGoPy13IP31UCciVViLjNYzMvY=; b=SxJjZiwzslnm81HdqmigkghWkM
        3XFhpuDVJ/UAvWdRaU6R976S0ZfSdaH30q6gGxwGJJojPWqJzw+wyZTxMnj0dALQkgP958DK+rv9R
        80Usq58V53ImrSOk5Uu7QM1uxo1haVbOtDE9XAfQB6z42vW/v6CtLM3gMrqTp7cXOpN/SH+sSCOUR
        1P/TfaIzIenEGEIJr/kmNj41a1zmRQHRSKtHFvi0enEG4cUGLQKKSBc2DwotQPqSK9jKTtIqCNJHc
        vdhaasYibAX9CKzXmwXj3IDwNXrF9dnEK3ZSzHFkTOlb0xnItbN6Kn9Mxas3jlvFj5q0OV1Wziglo
        akfijmVQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1oGTjR-00GALr-2x;
        Tue, 26 Jul 2022 23:12:53 +0000
Date:   Wed, 27 Jul 2022 00:12:53 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Keith Busch <kbusch@fb.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 4/5] io_uring: add support for dma pre-mapping
Message-ID: <YuB09cZh7rmd260c@ZenIV>
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

> +	if (S_ISBLK(file_inode(file)->i_mode))
> +		bdev = I_BDEV(file->f_mapping->host);
> +	else if (S_ISREG(file_inode(file)->i_mode))
> +		bdev = file->f_inode->i_sb->s_bdev;

*blink*

Just what's the intended use of the second case here?
