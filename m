Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD11258F217
	for <lists+io-uring@lfdr.de>; Wed, 10 Aug 2022 20:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232482AbiHJSFP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Aug 2022 14:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231424AbiHJSFN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Aug 2022 14:05:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74FC4B1A;
        Wed, 10 Aug 2022 11:05:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 138CFB81611;
        Wed, 10 Aug 2022 18:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11174C433D6;
        Wed, 10 Aug 2022 18:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660154708;
        bh=nhGr02sSN89GKEkq7FccjXFENhz9XIFY79Zk1MeBFDE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=giwdIhQSTRjg1XY592kRRArKEADaCYIFb0IfSAf5vSAAqZPkITd1VNS31sKmvjLHY
         QZ5zTWD7x1qLyuh8xA3n7RFw4wR4aV4jBH78K2xHiYXQqMtPpepIUoftftH8NkARnz
         froPTiPS0sbSWrcTJfKFysqmONFj/cExjXFDlcbqP1hTZrLlkVKbG0IlQYZ7h7519j
         8jkQEU3HBANrmut4RcNOvhGZVr5yQBobhJGMqjYraFsHrpXfdjbgVU+drNYU2ER9Su
         qD/ARUaZVD70Uc79Am1rehEVjBKYpmXPabLA1gSTrBhfCCwlKEiW+RwKzxvC9KxCcx
         VFEPcUyWeyo1g==
Date:   Wed, 10 Aug 2022 12:05:05 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCHv3 0/7] dma mapping optimisations
Message-ID: <YvPzUSx87VkwSH2C@kbusch-mbp.dhcp.thefacebook.com>
References: <20220805162444.3985535-1-kbusch@fb.com>
 <20220809064613.GA9040@lst.de>
 <YvKPTGf56v/3iSxg@kbusch-mbp.dhcp.thefacebook.com>
 <20220809184137.GB15107@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809184137.GB15107@lst.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 09, 2022 at 08:41:37PM +0200, Christoph Hellwig wrote:
> On Tue, Aug 09, 2022 at 10:46:04AM -0600, Keith Busch wrote:
> 
> > For swiotlb, though, we can error out the mapping if the requested memory uses
> > swiotlb with the device: the driver's .dma_map() can return ENOTSUPP if
> > is_swiotlb_buffer() is true. Would that be more acceptable?
> 
> No, is_swiotlb_buffer and similar are not exported APIs.

The functions are implemented under 'include/linux/', indistinguishable from
exported APIs. I think I understand why they are there, but they look the same
as exported functions from a driver perspective.

> More importantly with the various secure hypervisor schemes swiotlb is
> unfortunately actually massively increasing these days.  On those systems all
> streaming mappings use swiotlb.  And the only way to get any kind of
> half-decent I/O performance would be the "special" premapped allocator, which
> is another reason why I'd like to see it.

Perhaps I'm being daft, but I'm totally missing why I should care if swiotlb
leverages this feature. If you're using that, you've traded performance for
security or compatibility already. If this idea can be used to make it perform
better, then great, but that shouldn't be the reason to hold this up IMO.

This optimization needs to be easy to reach if we expect anyone to use it.
Working with arbitrary user addresses with minimal additions to the user ABI
was deliberate. If you want a special allocator, we can always add one later;
this series doesn't affect that.

If this has potential to starve system resource though, I can constrain it to
specific users like CAP_SYS_ADMIN, or maybe only memory allocated from
hugetlbfs. Or perhaps a more complicated scheme of shuffling dma mapping
resources on demand if that is an improvement over the status quo.
