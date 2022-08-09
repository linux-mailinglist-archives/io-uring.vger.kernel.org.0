Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1075758DC5B
	for <lists+io-uring@lfdr.de>; Tue,  9 Aug 2022 18:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243517AbiHIQqM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 12:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239029AbiHIQqL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 12:46:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4747115C;
        Tue,  9 Aug 2022 09:46:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7388AB8160F;
        Tue,  9 Aug 2022 16:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C6BC433C1;
        Tue,  9 Aug 2022 16:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660063568;
        bh=H7kbVRAtb9GZOzmFO3rQ0QGsMQNhMUqqE1xRN8YJRvc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QrG0LcgUBcrq8e7AF9I0le9zmYPq/7kwYXWyPmBP+stBShkPKxfIU6eX8ORcPBsJc
         wtiON+GuQr9K3VkRFmyzifIYmSBm3LkMe/VYrj3/u0hbDhwOIwElZiIlCL/PeYLU6L
         NKYdNQgRVDnFX9wcxld3oCU3uLtT2Noq/X01ZpZtJnofqvTE4qSLb58TI2wT44cm0V
         o/xGytd4OpTgqPnV9dCYU453PPKCCV4ELr+3i5O8ndMK/mU0xv/vtv94dzFMuFS9Sk
         tUMRmTr5cHBuu2cmaXv0LgSWcMZYwSm2vwrC5TzTWl+xg3iEu+n9lTt30E9WG4/saF
         vn0Amndb3VTzQ==
Date:   Tue, 9 Aug 2022 10:46:04 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCHv3 0/7] dma mapping optimisations
Message-ID: <YvKPTGf56v/3iSxg@kbusch-mbp.dhcp.thefacebook.com>
References: <20220805162444.3985535-1-kbusch@fb.com>
 <20220809064613.GA9040@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809064613.GA9040@lst.de>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 09, 2022 at 08:46:13AM +0200, Christoph Hellwig wrote:
>  - the DMA streaming ops (dma_map_*) are only intended for short term
>    mappings, not for long living ones that can lead to starvation.
>    Especially with swiotlb, but also with some IOMMUs.  I think this
>    needs to be changed to an API that can allocate DMA mapped memory
>    using dma_alloc_noncoherent/dma_alloc_noncontigious for the device
>    and then give access to that to the user instead

I am a bit reluctant to require a new memory allocator to use the feature. I'm
also generally not concerned about the odd resource constrained IOMMU. User
space drivers pre-map all their memory resources up front, and this is
essentially the same concept.

For swiotlb, though, we can error out the mapping if the requested memory uses
swiotlb with the device: the driver's .dma_map() can return ENOTSUPP if
is_swiotlb_buffer() is true. Would that be more acceptable?
