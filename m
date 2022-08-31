Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 497305A881D
	for <lists+io-uring@lfdr.de>; Wed, 31 Aug 2022 23:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232289AbiHaV3p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Aug 2022 17:29:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232329AbiHaV3o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Aug 2022 17:29:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29FC0BCB4;
        Wed, 31 Aug 2022 14:19:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73318B82371;
        Wed, 31 Aug 2022 21:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8826FC433D6;
        Wed, 31 Aug 2022 21:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661980793;
        bh=EuFVtF27UHzZ95m2iAVZr88pBg2NFFrI0iNLOelRyrg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Wljct3mBAodbROj8O/9kcBwlEJPrCw4g2YpmVaVswGofxdOZBYvrIE8+6eh9YfBir
         klg/v3l7dfsHdTX/SQxogCaudW9U6u7Wz+t1mLOORCl8zws8d83jAwrHCCgFVtw+X0
         +MIS81RaFP9pSm2aLQVGY1p5T8j/tr8Yu3ob9Tkj5O+2h8lSEX6jzIYeIknePODM2x
         zXXQak7U22takWnvrBDyCc2LOBM6JxjOEi98IUOj5EBTrxZgddGU0lVtKQwNxHlrzG
         VZVwDYklnwrT8kqS+2ziWX65x4wuzl5efs6oClsQnV+pbWPGo0XPFuGaJBfCtgiRk5
         zpw1BC5hLlrAQ==
Date:   Wed, 31 Aug 2022 15:19:49 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Keith Busch <kbusch@fb.com>, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCHv3 0/7] dma mapping optimisations
Message-ID: <Yw/Qdf+280vZSYU4@kbusch-mbp.dhcp.thefacebook.com>
References: <20220805162444.3985535-1-kbusch@fb.com>
 <20220809064613.GA9040@lst.de>
 <YvKPTGf56v/3iSxg@kbusch-mbp.dhcp.thefacebook.com>
 <20220809184137.GB15107@lst.de>
 <YvPzUSx87VkwSH2C@kbusch-mbp.dhcp.thefacebook.com>
 <20220811072232.GA13803@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220811072232.GA13803@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Aug 11, 2022 at 09:22:32AM +0200, Christoph Hellwig wrote:
> On Wed, Aug 10, 2022 at 12:05:05PM -0600, Keith Busch wrote:
> > The functions are implemented under 'include/linux/', indistinguishable from
> > exported APIs. I think I understand why they are there, but they look the same
> > as exported functions from a driver perspective.
> 
> swiotlb.h is not a driver API.  There's two leftovers used by the drm
> code I'm trying to get fixed up, but in general the DMA API is the
> interface and swiotlb is just an implementation detail.
> 
> > Perhaps I'm being daft, but I'm totally missing why I should care if swiotlb
> > leverages this feature. If you're using that, you've traded performance for
> > security or compatibility already. If this idea can be used to make it perform
> > better, then great, but that shouldn't be the reason to hold this up IMO.
> 
> We firstly need to make sure that everything actually works on swiotlb, or
> any other implementation that properly implements the DMA API.
> 
> And the fact that I/O performance currently sucks and we can fix it on
> the trusted hypervisor is an important consideration.  At least as
> importantant as micro-optimizing performance a little more on setups
> not using them.  So not taking care of both in one go seems rather silly
> for a feature that is in its current form pretty intrusive and thus needs
> a really good justification.

Sorry for the delay response; I had some trouble with test setup.

Okay, I will restart developing this with swiotlb in mind.

In the mean time, I wanted to share some results with this series because I'm
thinking this might be past the threshold for when we can drop the "micro-"
prefix on optimisations.

The most significant data points are these:

  * submission latency stays the same regardless of the transfer size or depth
  * IOPs is always equal or better (usually better) with up to 50% reduced
    cpu cost

Based on this, I do think this type of optimisation is worth having a something
like a new bio type. I know this introduces some complications in the io-path,
but it is pretty minimal and doesn't add any size penalties to common structs
for drivers that don't use them.

Test details:

  fio with ioengine=io_uring
    'none': using __user void*
    'bvec': using buf registered with IORING_REGISTER_BUFFERS
    'dma': using buf registered with IORING_REGISTER_MAP_BUFFERS (new)

  intel_iommu=on

Results:

(submission latency [slat] in nano-seconds)
Q-Depth 1:

 Size |  Premap  |   IOPs  |  slat  | sys-cpu%
 .....|..........|.........|........|.........
 4k   |    none  |  41.4k  |  2126  |   16.47%
      |    bvec  |  43.8k  |  1843  |   15.79%
      |     dma  |  46.8k  |  1504  |   14.94%
 16k  |    none  |  33.3k  |  3279  |   17.78%
      |    bvec  |  33.9k  |  2607  |   14.59%
      |     dma  |  40.2k  |  1490  |   12.57%
 64k  |    none  |  18.7k  |  6778  |   18.22%
      |    bvec  |  20.0k  |  4626  |   13.80%
      |     dma  |  22.6k  |  1586  |    7.58%

Q-Depth 16:

 Size |  Premap  |   IOPs  |  slat  | sys-cpu%
 .....|..........|.........|........|.........
 4k   |    none  |   207k  |  3657  |   72.81%
      |    bvec  |   219k  |  3369  |   71.55%
      |     dma  |   310k  |  2237  |   60.16%
 16k  |    none  |   164k  |  5024  |   78.38%
      |    bvec  |   177k  |  4553  |   76.29%
      |     dma  |   186k  |  1880  |   43.56%
 64k  |    none  |  46.7k  |  4424  |   30.51%
      |    bvec  |  46.7k  |  4389  |   29.42%
      |     dma  |  46.7k  |  1574  |   15.61%

