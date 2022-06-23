Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FE1556F72
	for <lists+io-uring@lfdr.de>; Thu, 23 Jun 2022 02:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359105AbiFWA3y (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Jun 2022 20:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbiFWA3y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Jun 2022 20:29:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B7F04162C;
        Wed, 22 Jun 2022 17:29:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 27B7161BBB;
        Thu, 23 Jun 2022 00:29:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDC5C34114;
        Thu, 23 Jun 2022 00:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655944192;
        bh=aAoFgHtWas++I53ocsvZ6Q17Zzsw1Rs+N4ahYVrgBOU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a8sEpVbYfYOXuyt0gsYxvuJoq7iiX7/sksHGJ38xs+6WfBhE86MzVoKM7PFB/Ip0q
         OvvD66ubSx5e+JUYg9sUzWZUhnifs/KufGdnHmRnxPQqCFRS+DQea5ngdHULEsc7yP
         WsV2p1GZipw5yMsgOE9Xm9oDpIFySdw+yDWMVr83W6kHvhP8IDdlb+yNNOeTms5/wy
         Fcae6Ej2WgdZq8I3VA3YMREVMcpLlSHXN6u0pETkTl6Pur2vQOADfqER8M7uowT0dj
         sJgnEQFTc+D5AexJ8nnHvxhDYPIZI+e7tlfWgJ+F5prD9DvpYoEvHg/Ng41tZ/0grP
         U0iigj3pFrygg==
Date:   Wed, 22 Jun 2022 17:29:52 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-mm@kvack.org, kernel-team@fb.com, linux-xfs@vger.kernel.org,
        io-uring@vger.kernel.org, shr@fb.com,
        linux-fsdevel@vger.kernel.org, david@fromorbit.com,
        hch@infradead.org, jack@suse.cz, willy@infradead.org
Subject: Re: [PATCH v9 00/14] io-uring/xfs: support async buffered writes
Message-ID: <YrO0AP4y3OGUjnXE@magnolia>
References: <20220616212221.2024518-1-shr@fb.com>
 <165593682792.161026.12974983413174964699.b4-ty@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165593682792.161026.12974983413174964699.b4-ty@kernel.dk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jun 22, 2022 at 04:27:07PM -0600, Jens Axboe wrote:
> On Thu, 16 Jun 2022 14:22:07 -0700, Stefan Roesch wrote:
> > This patch series adds support for async buffered writes when using both
> > xfs and io-uring. Currently io-uring only supports buffered writes in the
> > slow path, by processing them in the io workers. With this patch series it is
> > now possible to support buffered writes in the fast path. To be able to use
> > the fast path the required pages must be in the page cache, the required locks
> > in xfs can be granted immediately and no additional blocks need to be read
> > form disk.
> > 
> > [...]
> 
> Applied, thanks!
> 
> [01/14] mm: Move starting of background writeback into the main balancing loop
>         commit: 29c36351d61fd08a2ed50a8028a7f752401dc88a
> [02/14] mm: Move updates of dirty_exceeded into one place
>         commit: a3fa4409eec3c094ad632ac1029094e061daf152
> [03/14] mm: Add balance_dirty_pages_ratelimited_flags() function
>         commit: 407619d2cef3b4d74565999a255a17cf5d559fa4
> [04/14] iomap: Add flags parameter to iomap_page_create()
>         commit: 49b5cd0830c1e9aa0f9a3717ac11a74ef23b9d4e
> [05/14] iomap: Add async buffered write support
>         commit: ccb885b4392143cea1bdbd8a0f35f0e6d909b114
> [06/14] iomap: Return -EAGAIN from iomap_write_iter()
>         commit: f0f9828d64393ea2ce87bd97f033051c8d7a337f

I'm not sure /what/ happened here, but I never received the full V9
series, and neither did lore:

https://lore.kernel.org/linux-fsdevel/165593682792.161026.12974983413174964699.b4-ty@kernel.dk/T/#t

As it is, I already have my hands full trying to figure out why
generic/522 reports file corruption after 20 minutes of running on
vanilla 5.19-rc3, so I don't think I'm going to get to this for a while
either.

The v8 series looked all right to me, but ********* I hate how our
development process relies on such unreliable **** tooling.  I don't
think it's a /great/ idea to be pushing new code into -next when both
the xfs and pagecache maintainers are too busy to read the whole thing
through... but did hch actually RVB the whole thing prior to v9?

--D

> [07/14] fs: Add check for async buffered writes to generic_write_checks
>         commit: cba06e23bc664ef419d389f1ed4cee523f468f8f
> [08/14] fs: add __remove_file_privs() with flags parameter
>         commit: 79d8ac83d6305fd8e996f720f955191e0d8c63b9
> [09/14] fs: Split off inode_needs_update_time and __file_update_time
>         commit: 1899b196859bac61ad71c3b3916e06de4b65246c
> [10/14] fs: Add async write file modification handling.
>         commit: 4705f225a56f216a59e09f7c2df16daabb7b4f76
> [11/14] io_uring: Add support for async buffered writes
>         commit: 6c8bbd82a43a0c7937e3e8e38cf46fcd90e15e68
> [12/14] io_uring: Add tracepoint for short writes
>         commit: 6c33dae4526ad079af6432aaf76827d0a27a9690
> [13/14] xfs: Specify lockmode when calling xfs_ilock_for_iomap()
>         commit: ddda2d473df70607bb456c515d984d05bf689790
> [14/14] xfs: Add async buffered write support
>         commit: e9cfc64a27f7a581b8c5d14da4efccfeae9c63bd
> 
> Best regards,
> -- 
> Jens Axboe
> 
> 
