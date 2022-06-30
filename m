Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41DD0561ED9
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 17:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbiF3PKo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 11:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235606AbiF3PKn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 11:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BA32AE26;
        Thu, 30 Jun 2022 08:10:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6CEA60ABF;
        Thu, 30 Jun 2022 15:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E11E2C3411E;
        Thu, 30 Jun 2022 15:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656601841;
        bh=BkGW5Xjs92vJQ/LaobdSoLoAjMgbz56UiKiJi3QMEIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AhCGqBvaW0/nE+gYgMHZ/aKvHmjCAa3UTHne7qEoR+zs6E+RTxa30WmGOsybW9u7l
         atYHAjgC80CTUs7eAimHVg6IDbRD7BqinVJ/LBi6zqawSQUzQf8b7ioE7RO4/1h2CZ
         3zAsfRJw13zQAircfNkbkAzvRLYxPPxfAKiqKBiZtqPIqZldo46gmq+qBKQxzUeDLj
         Me061AtQAg41JIYobeALsWmQQUYedPVQ8zcvTEywpO7SQyV3z9oXM5BtiiSM5XNG3P
         0B0hwPJhNIRkRFdb/R01AwoskqHyJ9mp/bkTyQ81riE0d83TUlWrK0L53YTtpBUAi1
         gRU35thBg39Cw==
Date:   Thu, 30 Jun 2022 16:10:38 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <20220630151038.GA459423@falcondesktop>
References: <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
 <YrueYDXqppHZzOsy@atmark-techno.com>
 <Yrvfqh0eqN0J5T6V@atmark-techno.com>
 <20220629153710.GA379981@falcondesktop>
 <YrzxHbWCR6zhIAcx@atmark-techno.com>
 <Yr1XNe9V3UY/MkDz@atmark-techno.com>
 <20220630104536.GA434846@falcondesktop>
 <Yr2ItqlxeII0sReD@atmark-techno.com>
 <20220630125124.GA446657@falcondesktop>
 <Yr2gQh5GaVmTEDW2@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr2gQh5GaVmTEDW2@atmark-techno.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 30, 2022 at 10:08:18PM +0900, Dominique MARTINET wrote:
> Filipe Manana wrote on Thu, Jun 30, 2022 at 01:51:24PM +0100:
> > > Please ask if there's any infos I could get you.
> > 
> > Ok, maybe it's page fault related or there's something else besides page faults
> > involved.
> > 
> > Can you dump the subvolume tree like this:
> > 
> > btrfs inspect-internal dump-tree -t 5 /dev/sda 2>&1 | xz -9 > dump.xz
> > 
> > Here the 5 is the ID of the default subvolume. If the test file is on
> > a different subvolume, you'll need to replace 5 with the subvolume's ID.
> 
> Sure thing.
> 
> It's 2MB compressed:
> https://gaia.codewreck.org/local/tmp/dump-tree.xz

Ok, the file has a mix of compressed and non-compressed extents.

This may prevent the short reads (not tested yet):

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7a54f964ff37..42fb56ed0021 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7684,7 +7684,7 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
        if (test_bit(EXTENT_FLAG_COMPRESSED, &em->flags) ||
            em->block_start == EXTENT_MAP_INLINE) {
                free_extent_map(em);
-               ret = -ENOTBLK;
+               ret = (flags & IOMAP_NOWAIT) ? -EAGAIN : -ENOTBLK;
                goto unlock_err;
        }
 
Can you give it a try?

Thanks.

> 
> 
> > This is just to look at the file extent layout.
> > Also, then tell me what's the inode number of the file (or just its name,
> > and I'll find out its inode number), and an example file offset and read
> > length that triggers a short read, so that I know where to look at.
> 
> There's just a single file in that subvolume, inode 257
> 
> > And btw, that dump-tree command will dump all file names, directory names
> > and xattr names and values (if they are human readable) - so if privacy is
> > a concern here, just pass --hide-names to the dump-tree command.
> 
> (thanks for the warning)
> -- 
> Dominique
