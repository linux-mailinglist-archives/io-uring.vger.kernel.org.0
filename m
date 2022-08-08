Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7369C58BEA6
	for <lists+io-uring@lfdr.de>; Mon,  8 Aug 2022 03:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236841AbiHHBNx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 7 Aug 2022 21:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiHHBNw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 7 Aug 2022 21:13:52 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E61F263;
        Sun,  7 Aug 2022 18:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/V6MnTCLVoftkYF3g4ON5cGPPOU8522/Qgzg2Ih2yRc=; b=dUVXF7OA1PsGnfvhHBAojxamR7
        XKHfTtzI8McKgCPAbREShmxCdCKu+uLpO8NJFVsAEsPhrI+sZv0XgUJiCIxYMoPsLXr13VrOm4yRW
        MjOYo4f01cVIMqC5NfYrB97YJlAbQOt1rgtby+mlMoYfiHnDHg8QbxpYDn3DieMHijCbhYN2qiuBq
        IQuUrcNDPVXSozoLsRzexyhPDDTx7GfvgkKSMySLAOzQ/wWFGo9VgnZqgwZiu/2ua0yFWfu9jMEI/
        hlwxGy5m9ZuEIApzb9EI4A+BLRwgiHQYVfb3IUXRs0T0H6U23zlKvY1+p3FBwSXINw4HT+bdyfhG1
        6iAwAo2A==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oKrKv-00DRm8-Uq; Mon, 08 Aug 2022 01:13:42 +0000
Date:   Mon, 8 Aug 2022 02:13:41 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, hch@lst.de,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv3 2/7] file: add ops to dma map bvec
Message-ID: <YvBjRfy4XzzBajTX@casper.infradead.org>
References: <20220805162444.3985535-1-kbusch@fb.com>
 <20220805162444.3985535-3-kbusch@fb.com>
 <20220808002124.GG3861211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808002124.GG3861211@dread.disaster.area>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 08, 2022 at 10:21:24AM +1000, Dave Chinner wrote:
> > +#ifdef CONFIG_HAS_DMA
> > +	void *(*dma_map)(struct file *, struct bio_vec *, int);
> > +	void (*dma_unmap)(struct file *, void *);
> > +#endif
> 
> This just smells wrong. Using a block layer specific construct as a
> primary file operation parameter shouts "layering violation" to me.

A bio_vec is also used for networking; it's in disguise as an skb_frag,
but it's there.

> What we really need is a callout that returns the bdevs that the
> struct file is mapped to (one, or many), so the caller can then map
> the memory addresses to the block devices itself. The caller then
> needs to do an {file, offset, len} -> {bdev, sector, count}
> translation so the io_uring code can then use the correct bdev and
> dma mappings for the file offset that the user is doing IO to/from.

I don't even know if what you're proposing is possible.  Consider a
network filesystem which might transparently be moved from one network
interface to another.  I don't even know if the filesystem would know
which network device is going to be used for the IO at the time of
IO submission.

I think a totally different model is needed where we can find out if
the bvec contains pages which are already mapped to the device, and map
them if they aren't.  That also handles a DM case where extra devices
are hot-added to a RAID, for example.
