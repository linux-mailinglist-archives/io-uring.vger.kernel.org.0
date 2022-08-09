Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E1458DFC1
	for <lists+io-uring@lfdr.de>; Tue,  9 Aug 2022 21:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245436AbiHITFR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Aug 2022 15:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345468AbiHITEY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Aug 2022 15:04:24 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EE6B615D;
        Tue,  9 Aug 2022 11:41:41 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id CE83A68AA6; Tue,  9 Aug 2022 20:41:37 +0200 (CEST)
Date:   Tue, 9 Aug 2022 20:41:37 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@fb.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCHv3 0/7] dma mapping optimisations
Message-ID: <20220809184137.GB15107@lst.de>
References: <20220805162444.3985535-1-kbusch@fb.com> <20220809064613.GA9040@lst.de> <YvKPTGf56v/3iSxg@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvKPTGf56v/3iSxg@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 09, 2022 at 10:46:04AM -0600, Keith Busch wrote:
> I am a bit reluctant to require a new memory allocator to use the feature. I'm
> also generally not concerned about the odd resource constrained IOMMU. User
> space drivers pre-map all their memory resources up front, and this is
> essentially the same concept.

Yes, it really isn't an issue for the modern iommus that support vfio,
but it is a limitation on the dma-api.  The old iommus aren't really the
issue, but..

> For swiotlb, though, we can error out the mapping if the requested memory uses
> swiotlb with the device: the driver's .dma_map() can return ENOTSUPP if
> is_swiotlb_buffer() is true. Would that be more acceptable?

No, is_swiotlb_buffer and similar are not exported APIs.  More importantly
with the various secure hypervisor schemes swiotlb is unfortunately
actually massively increasing these days.  On those systems all streaming
mappings use swiotlb.  And the only way to get any kind of half-decent
I/O performance would be the "special" premapped allocator, which is
another reason why I'd like to see it.
