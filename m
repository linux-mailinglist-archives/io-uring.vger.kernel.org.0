Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70631581C54
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 01:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239945AbiGZXKn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jul 2022 19:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232501AbiGZXKm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 Jul 2022 19:10:42 -0400
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [IPv6:2a03:a000:7:0:5054:ff:fe1c:15ff])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6A012625;
        Tue, 26 Jul 2022 16:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=lSaNiFXzk1GnospfycWuLPkX5TAfntKYa+fdXn5xbb8=; b=vx0bJl/RPFqFTXb0UScayxUUaR
        05ZLG+pBniD1SHzx4bAuDNjHO34KLnqj/cD6SGL+KCOLJ6SCDa8iPuIy6w/+nusM4HBdeQ8qbah6b
        feZTaQrvQXmnLcT8STYz/Sxx6u9mQprjlQBaG8GY9wWHWxnv69dyvgdFjNPPXDcTlj8ccJCKAVegO
        Oz5cSW2w6HjDDwjQiBUlF+qrDH3sgl3f9cyB4zs5h6NGBlYHMKZXXhilMYVB084YAqcd804XiTqAC
        LfaPXOm2HfIvFbYQO/U+QdOWDVBJ1cibVS1zysv7axZNOqtj0j8h+RyhzBX2i0cbqDKxxq20y/VnA
        isXRXfnw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.95 #2 (Red Hat Linux))
        id 1oGThB-00GAKq-Vr;
        Tue, 26 Jul 2022 23:10:34 +0000
Date:   Wed, 27 Jul 2022 00:10:33 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     Keith Busch <kbusch@fb.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 2/5] iov_iter: introduce type for preregistered dma tags
Message-ID: <YuB0ado/bhkow+LY@ZenIV>
References: <20220726173814.2264573-1-kbusch@fb.com>
 <20220726173814.2264573-3-kbusch@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220726173814.2264573-3-kbusch@fb.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 26, 2022 at 10:38:11AM -0700, Keith Busch wrote:

> +void iov_iter_dma_tag(struct iov_iter *i, unsigned int direction,
> +			void *dma_tag, unsigned int dma_offset,
> +			unsigned long nr_segs, size_t count)
> +{
> +	WARN_ON(direction & ~(READ | WRITE));
> +	*i = (struct iov_iter){
> +		.iter_type = ITER_DMA_TAG,
> +		.data_source = direction,
> +		.nr_segs = nr_segs,

Could you can that cargo-culting?  Just what the hell is nr_segs
here?
