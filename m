Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE77562EA1
	for <lists+io-uring@lfdr.de>; Fri,  1 Jul 2022 10:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbiGAIpJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Jul 2022 04:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiGAIpJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Jul 2022 04:45:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D6273589;
        Fri,  1 Jul 2022 01:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF761621F9;
        Fri,  1 Jul 2022 08:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA801C3411E;
        Fri,  1 Jul 2022 08:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656665107;
        bh=RYofUrK0/1fvEA6tRwiK6oM5o6K/jGlRpVWCFeOOfSw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kz6fvG24HQsCeWrcMGs4RnZwRvT3k1XUPPlzO9pwNjQUVov7cpdzq5kOFoIrQw2Mp
         A+aYfbmeLB6CLM6vr9BNhpmdWyq2nXfB5+sWeOOdgb3XiCYXBTNHB4V+oPBxMLECsA
         hd4OidlDixg2nhFIrqiG9E6F7rKkR61B2wbXkGxvN+cTQoWb3UILRofAB+Lo8HlBDT
         RSDEnDBjCaJtQKszU7SQavDrRtTxkV3Rk/Yi6QwPen0jZ7ZFJElvXX8L3YahYRaESD
         GBPF2YHAWmBq6sG57SLOWAfF19Cp9SBasdcEeJ9Dh4/WaLs9+pmZ/i6q+oLOyLf6MO
         WL4sYQZ+aF2+A==
Date:   Fri, 1 Jul 2022 09:45:04 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <20220701084504.GA493565@falcondesktop>
References: <Yrvfqh0eqN0J5T6V@atmark-techno.com>
 <20220629153710.GA379981@falcondesktop>
 <YrzxHbWCR6zhIAcx@atmark-techno.com>
 <Yr1XNe9V3UY/MkDz@atmark-techno.com>
 <20220630104536.GA434846@falcondesktop>
 <Yr2ItqlxeII0sReD@atmark-techno.com>
 <20220630125124.GA446657@falcondesktop>
 <Yr2gQh5GaVmTEDW2@atmark-techno.com>
 <20220630151038.GA459423@falcondesktop>
 <Yr5NJnyKoWqAHsad@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr5NJnyKoWqAHsad@atmark-techno.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 01, 2022 at 10:25:58AM +0900, Dominique MARTINET wrote:
> Filipe Manana wrote on Thu, Jun 30, 2022 at 04:10:38PM +0100:
> > This may prevent the short reads (not tested yet):
> > 
> > diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> > index 7a54f964ff37..42fb56ed0021 100644
> > --- a/fs/btrfs/inode.c
> > +++ b/fs/btrfs/inode.c
> > @@ -7684,7 +7684,7 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
> >         if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) ||
> >             em->block_start == EXTENT_MAP_INLINE) {
> >                 free_extent_map(em);
> > -               ret = -ENOTBLK;
> > +               ret = (flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOTBLK;
> >                 goto unlock_err;
> >         }
> >  
> > Can you give it a try?
> 
> This appears to do the trick!
> I've also removed the first patch and still cannot see any short reads,
> so this would be enough on its own for my case.

Great.

After my last reply, I retried your reproducer (and qemu image file) on a fs
mounted with -o compress-force=zstd and was able to trigger the short reads
in less than a minute.

Witht that patch I can no longer trigger the short reads too (after running
the reproducer for about 2 hours).

I'll give it some more testing here along with other minor fixes I have for
other scenarios. I'll submit a patchset, with this fix included, on monday.

I'll add your Tested-by tag for this specific patch.

Thanks for all the testing and the reproducer!


> 
> -- 
> Dominique
