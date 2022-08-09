Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5574058D400
	for <lists+io-uring@lfdr.de>; Tue,  9 Aug 2022 08:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235582AbiHIGqT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 02:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233045AbiHIGqS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 02:46:18 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21DC1929E;
        Mon,  8 Aug 2022 23:46:17 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BCD3D68AA6; Tue,  9 Aug 2022 08:46:13 +0200 (CEST)
Date:   Tue, 9 Aug 2022 08:46:13 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@fb.com>
Cc:     linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 0/7] dma mapping optimisations
Message-ID: <20220809064613.GA9040@lst.de>
References: <20220805162444.3985535-1-kbusch@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220805162444.3985535-1-kbusch@fb.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

I finally found some time to look over this, and I have some
very high level problems with the implementations:

 - the DMA streaming ops (dma_map_*) are only intended for short term
   mappings, not for long living ones that can lead to starvation.
   Especially with swiotlb, but also with some IOMMUs.  I think this
   needs to be changed to an API that can allocate DMA mapped memory
   using dma_alloc_noncoherent/dma_alloc_noncontigious for the device
   and then give access to that to the user instead
 - I really do not like the special casing in the bio.  Did you try
   to just stash away the DMA mapping information in an efficient
   lookup data structure (e.g. rthashtable, but details might need
   analysis and benchmarking) and thus touch very little code outside
   of the driver I/O path and the place that performs the mapping?
 - the design seems to ignore DMA ownership.  Every time data in
   transfered data needs to be transferred to and from the device,
   take a look at Documentation/core-api/dma-api.rst and
   Documentation/core-api/dma-api-howto.rst.

As for the multiple devices discussion:  mapping memory for multiple
devices is possible, but nontrivial to get right, mostly due to the
ownership.  So unless we have a really good reason I'd suggest to
not support this initially.
