Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C15158F842
	for <lists+io-uring@lfdr.de>; Thu, 11 Aug 2022 09:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbiHKHWh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Aug 2022 03:22:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbiHKHWg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Aug 2022 03:22:36 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7A289CF4;
        Thu, 11 Aug 2022 00:22:36 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 5F78068AA6; Thu, 11 Aug 2022 09:22:32 +0200 (CEST)
Date:   Thu, 11 Aug 2022 09:22:32 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Christoph Hellwig <hch@lst.de>, Keith Busch <kbusch@fb.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCHv3 0/7] dma mapping optimisations
Message-ID: <20220811072232.GA13803@lst.de>
References: <20220805162444.3985535-1-kbusch@fb.com> <20220809064613.GA9040@lst.de> <YvKPTGf56v/3iSxg@kbusch-mbp.dhcp.thefacebook.com> <20220809184137.GB15107@lst.de> <YvPzUSx87VkwSH2C@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvPzUSx87VkwSH2C@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Aug 10, 2022 at 12:05:05PM -0600, Keith Busch wrote:
> The functions are implemented under 'include/linux/', indistinguishable from
> exported APIs. I think I understand why they are there, but they look the same
> as exported functions from a driver perspective.

swiotlb.h is not a driver API.  There's two leftovers used by the drm
code I'm trying to get fixed up, but in general the DMA API is the
interface and swiotlb is just an implementation detail.

> Perhaps I'm being daft, but I'm totally missing why I should care if swiotlb
> leverages this feature. If you're using that, you've traded performance for
> security or compatibility already. If this idea can be used to make it perform
> better, then great, but that shouldn't be the reason to hold this up IMO.

We firstly need to make sure that everything actually works on swiotlb, or
any other implementation that properly implements the DMA API.

And the fact that I/O performance currently sucks and we can fix it on
the trusted hypervisor is an important consideration.  At least as
importantant as micro-optimizing performance a little more on setups
not using them.  So not taking care of both in one go seems rather silly
for a feature that is in its current form pretty intrusive and thus needs
a really good justification.

> This optimization needs to be easy to reach if we expect anyone to use it.
> Working with arbitrary user addresses with minimal additions to the user ABI
> was deliberate. If you want a special allocator, we can always add one later;
> this series doesn't affect that.
> 
> If this has potential to starve system resource though, I can constrain it to
> specific users like CAP_SYS_ADMIN, or maybe only memory allocated from
> hugetlbfs. Or perhaps a more complicated scheme of shuffling dma mapping
> resources on demand if that is an improvement over the status quo.

Or just not bother with it at all.  Because with all those limits it
really does not seems to be worth to an entirely need type of bio
payload to the block layer and a lot of boilerplate to drivers.
