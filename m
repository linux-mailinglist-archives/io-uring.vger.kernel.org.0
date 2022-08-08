Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B871B58CB4A
	for <lists+io-uring@lfdr.de>; Mon,  8 Aug 2022 17:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243714AbiHHP25 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Aug 2022 11:28:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243628AbiHHP2z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Aug 2022 11:28:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 896571409C;
        Mon,  8 Aug 2022 08:28:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0667D60FF8;
        Mon,  8 Aug 2022 15:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9187AC433D6;
        Mon,  8 Aug 2022 15:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659972533;
        bh=lpFQdsjZh8wL+uNBQDVltfnf7Gcs7geIK2yl0gZEZis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DuabrMO3JhQYKj/lsRfa4eWTX5vJ/OD5elQ3cp0RJFhxmFivmc3uRLkaTf9DoIe5p
         uBMCFwueUu+gmYNgHmsBBLIRJcRbgWsGfyul8JIm+fhLaMUYQLQAC/9/UWG+CTvckC
         JL7A5Geed95RZ04FGpBOY8uJJrc8XgUNtNHupCWjiEr0pLg2i58LwXvXlyjXHP+LeK
         urpTTbYRmuOxN6i+H6oUa1pVSnfzLMFLUzT2NQM/4qr6rQHTCaUVWa6PCQxUfta/Ic
         idtNv4fQOtRMvL4hr5zKZR4ham7kYrM5t3MLhIkgA/E1vR5cfhPnISAjWdLWBwBZgR
         Ai3mjsGZTfhvA==
Date:   Mon, 8 Aug 2022 09:28:49 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Matthew Wilcox <willy@infradead.org>, Keith Busch <kbusch@fb.com>,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, hch@lst.de,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCHv3 2/7] file: add ops to dma map bvec
Message-ID: <YvErsVTIQqTykcbq@kbusch-mbp>
References: <20220805162444.3985535-1-kbusch@fb.com>
 <20220805162444.3985535-3-kbusch@fb.com>
 <20220808002124.GG3861211@dread.disaster.area>
 <YvBjRfy4XzzBajTX@casper.infradead.org>
 <20220808021501.GH3861211@dread.disaster.area>
 <YvB5pbsfM6QuR5Y7@casper.infradead.org>
 <20220808073134.GI3861211@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808073134.GI3861211@dread.disaster.area>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Aug 08, 2022 at 05:31:34PM +1000, Dave Chinner wrote:
> On Mon, Aug 08, 2022 at 03:49:09AM +0100, Matthew Wilcox wrote:
> 
> > So you hot-unplug the failed
> > device, plug in a new NVMe drive and add it to the RAID.  The pages now
> > need to be DMA mapped to that new PCI device.
> 
> yup, and now the dma tags for the mappings to that sub-device return
> errors, which then tell the application that it needs to remap the
> dma buffers it is using.
> 
> That's just bog standard error handling - if a bdev goes away,
> access to the dma tags have to return IO errors, and it is up to the
> application level (i.e. the io_uring code) to handle that sanely.

I didn't think anyone should see IO errors in such scenarios. This feature is
more of an optional optimization, and everything should work as it does today
if a tag becomes invalid.

For md raid or multi-device filesystem, I imagined this would return dma tag
that demuxes to dma tags of the member devices. If any particular member device
doesn't have a dma tag for whatever reason, the filesystem or md would
transparently fall back to the registered bvec that it currently uses when it
needs to do IO to that device.

If you do a RAID hot-swap, MD could request a new dma tag for the new device
without io_uring knowing about the event. MD can continue servicing new IO
referencing its dma tag, and use the new device's tag only once the setup is
complete.

I'm not familiar enough with the networking side, but I thought the file level
abstraction would allow similar handling without io_uring's knowledge.
