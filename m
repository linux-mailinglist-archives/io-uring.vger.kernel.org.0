Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9C35827FE
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 15:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiG0Nwe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 09:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231518AbiG0Nwd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 09:52:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F6330F70;
        Wed, 27 Jul 2022 06:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EAF0B61784;
        Wed, 27 Jul 2022 13:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB854C433C1;
        Wed, 27 Jul 2022 13:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658929951;
        bh=iDKLy0R2Z1r9BBUQnqSCBeU8s4vnDRz70BEF1qctZhE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V1TJJceAo7ccSkFs0C1gUxHdm0ySHqTL7CXQx2ex2LRwaYnEEqnQQlds2UdZnKPGy
         RfZ8zJXwd/4nhVDxQniT6Q743saeIvndIoZNjDrXIc9yaa4yAcuWY/dOVxK9KUIKLx
         hMHYTWNJKSBnT6Gu98xCadGSmJnbrJYolulxl1h70GYXATqm0m5CK3Tjq8Z8P22334
         jbOIKEeLD4ugrVqh3wPQPi5NKQbFLPxiGIV5iJRjM8PzwOwTmvIZ4gSMIarYYLWhwj
         nyfO9jkx0gLVXGhD+vOSc/cAJNbtnkIX6T3RQOLueG/s1x8VLvGp9FNV1ltif1AORG
         6kjJxOjDl6IAg==
Date:   Wed, 27 Jul 2022 07:52:27 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de
Subject: Re: [PATCH 2/5] iov_iter: introduce type for preregistered dma tags
Message-ID: <YuFDG1x/4//TYDNL@kbusch-mbp.dhcp.thefacebook.com>
References: <20220726173814.2264573-1-kbusch@fb.com>
 <20220726173814.2264573-3-kbusch@fb.com>
 <YuB0ado/bhkow+LY@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YuB0ado/bhkow+LY@ZenIV>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 27, 2022 at 12:10:33AM +0100, Al Viro wrote:
> On Tue, Jul 26, 2022 at 10:38:11AM -0700, Keith Busch wrote:
> 
> > +void iov_iter_dma_tag(struct iov_iter *i, unsigned int direction,
> > +			void *dma_tag, unsigned int dma_offset,
> > +			unsigned long nr_segs, size_t count)
> > +{
> > +	WARN_ON(direction & ~(READ | WRITE));
> > +	*i = (struct iov_iter){
> > +		.iter_type = ITER_DMA_TAG,
> > +		.data_source = direction,
> > +		.nr_segs = nr_segs,
> 
> Could you can that cargo-culting?  Just what the hell is nr_segs
> here?

Thanks for the catch. Setting nr_segs here is useless carry-over from an
earlier version when I thought it would be used to build the request. Turns out
it's not used at all.
