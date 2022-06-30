Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAEC561AC5
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 14:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbiF3Mvb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 08:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235104AbiF3Mva (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 08:51:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AE43FBF9;
        Thu, 30 Jun 2022 05:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E94761EBF;
        Thu, 30 Jun 2022 12:51:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EBC9C34115;
        Thu, 30 Jun 2022 12:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656593487;
        bh=DM/TYsqYiOvdjG/uty8sr6pwhJoi5aAEyXmb+tzRM8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VQQft16yMwDbBxJ2ZWc9I5BH1o4esxCTpMmKjkaLcTGF+gnhwvDYh9LmoiHo9GwDu
         8zIeNXjZ48x7J27UdDrUxTcbIPfonfZvTJhDascAPcbGLy5yPyye39B8KqzC2WejiN
         CE/M5kdZpcByccpSrMpu4LNXe+XLk7gdVUmaeLePuMrp8QObqI1hARCb6KDolZgqRp
         g9tHKU5NMsWKNbX5wfuFIkbDewYU2kkpoXlPK1bc6hFKAZWYkJvSRZROEf4XLcT5mQ
         2iwnjGyop0PNEfPogIG+Ql7dKeFKwUVp3c6mAT5xiq3XA2SaVY0xYKlh5Wm//JrGob
         /XQh2Gas/QOmg==
Date:   Thu, 30 Jun 2022 13:51:24 +0100
From:   Filipe Manana <fdmanana@kernel.org>
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <20220630125124.GA446657@falcondesktop>
References: <33cd0f9a-cdb1-1018-ebb0-89222cb1c759@kernel.dk>
 <bd342da1-8c98-eb78-59f1-e3cf537181e3@suse.com>
 <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
 <YrueYDXqppHZzOsy@atmark-techno.com>
 <Yrvfqh0eqN0J5T6V@atmark-techno.com>
 <20220629153710.GA379981@falcondesktop>
 <YrzxHbWCR6zhIAcx@atmark-techno.com>
 <Yr1XNe9V3UY/MkDz@atmark-techno.com>
 <20220630104536.GA434846@falcondesktop>
 <Yr2ItqlxeII0sReD@atmark-techno.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yr2ItqlxeII0sReD@atmark-techno.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jun 30, 2022 at 08:27:50PM +0900, Dominique MARTINET wrote:
> Filipe Manana wrote on Thu, Jun 30, 2022 at 11:45:36AM +0100:
> > So here's a patch for you to try:
> > 
> > https://gist.githubusercontent.com/fdmanana/4b24d6b30983e956bb1784a44873c5dd/raw/572490b127071bf827c3bc05dd58dcb7bcff373a/dio.patch
> 
> Thanks.
> Unfortunately I still hit short reads with this; I can't really tell if
> there are more or less than before (unfortunately the parallelism of my
> reproducer means that even dropping caches and restarting with the same
> seed I get a different offset for short read), but it looks fairly
> similar -- usually happens within the first 1000 operations with
> sometimes a bit slower with or without the patch.
> 
> I went ahead and added a printk in dio_fault_in_size to see if it was
> used and it looks like it is, but that doesn't really tell if it is the
> reason for short reads (hm, thinking back I could just have printed the
> offsets...):
> ----
> / # /mnt/repro /mnt/t/t/atde-test 
> random seed 4061910570
> Starting io_uring reads...
> [   17.872992] dio_fault_in_size: left 3710976 prev_left 0 size 131072
> [   17.873958] dio_fault_in_size: left 3579904 prev_left 3710976 size 131072
> [   17.874246] dio_fault_in_size: left 1933312 prev_left 0 size 131072
> [   17.875111] dio_fault_in_size: left 3448832 prev_left 3579904 size 131072
> [   17.876446] dio_fault_in_size: left 3317760 prev_left 3448832 size 131072
> [   17.877493] dio_fault_in_size: left 3186688 prev_left 3317760 size 131072
> [   17.878667] dio_fault_in_size: left 3055616 prev_left 3186688 size 131072
> [   17.880001] dio_fault_in_size: left 2924544 prev_left 3055616 size 131072
> [   17.881524] dio_fault_in_size: left 2793472 prev_left 2924544 size 131072
> [   17.882462] dio_fault_in_size: left 2662400 prev_left 2793472 size 131072
> [   17.883433] dio_fault_in_size: left 2531328 prev_left 2662400 size 131072
> [   17.884573] dio_fault_in_size: left 2400256 prev_left 2531328 size 131072
> [   17.886008] dio_fault_in_size: left 2269184 prev_left 2400256 size 131072
> [   17.887058] dio_fault_in_size: left 2138112 prev_left 2269184 size 131072
> [   17.888313] dio_fault_in_size: left 2007040 prev_left 2138112 size 131072
> [   17.889873] dio_fault_in_size: left 1875968 prev_left 2007040 size 131072
> [   17.891041] dio_fault_in_size: left 1744896 prev_left 1875968 size 131072
> [   17.893174] dio_fault_in_size: left 802816 prev_left 1744896 size 131072
> [   17.930249] dio_fault_in_size: left 3325952 prev_left 0 size 131072
> [   17.931472] dio_fault_in_size: left 1699840 prev_left 0 size 131072
> [   17.956509] dio_fault_in_size: left 1699840 prev_left 0 size 131072
> [   17.957522] dio_fault_in_size: left 1888256 prev_left 0 size 131072
> bad read result for io 3, offset 4022030336: 176128 should be 1531904
> ----
> 
> (ugh, saw the second patch after writing all this.. but it's the same:

Yep, it only prevents an infinite loop on rare scenarios (not triggered
by your reproducer).

> ----
> / # /mnt/repro /mnt/t/t/atde-test 
> random seed 634214270
> Starting io_uring reads...
> [   17.858718] dio_fault_in_size: left 1949696 prev_left 0 size 131072
> [   18.193604] dio_fault_in_size: left 1142784 prev_left 0 size 131072
> [   18.218500] dio_fault_in_size: left 528384 prev_left 0 size 131072
> [   18.248184] dio_fault_in_size: left 643072 prev_left 0 size 131072
> [   18.291639] dio_fault_in_size: left 131072 prev_left 0 size 131072
> bad read result for io 4, offset 5079498752: 241664 should be 2142208
> ----
> rest of the mail is on first patch as I used offset of first message,
> but shouldn't matter)
> 
> Given my file has many many extents, my guess would be that short reads
> happen when we're crossing an extent boundary.
> 
> 
> Using the fiemap[1] command I can confirm that it is the case:
> [1] https://github.com/ColinIanKing/fiemap
> 
> $ printf "%x\n" $((4022030336 + 176128))
> efbe0000
> $ fiemap /mnt/t/t/atde-test
> File atde-test has 199533 extents:
> #       Logical          Physical         Length           Flags
> ...
> 23205:  00000000efba0000 0000001324f00000 0000000000020000 0008
> 23206:  00000000efbc0000 00000013222af000 0000000000020000 0008
> 23207:  00000000efbe0000 00000013222bb000 0000000000020000 0008
> 
> but given how many extents there are that doesn't explain why it stopped
> at this offset within the file and not another before it: transition
> from compressed to non-compressed or something? I didn't find any tool
> able to show extent attributes; here's what `btrfs insp dump-tree` has
> to say about this physical offset:
> 
> $ printf "%d\n" 0x00000013222af000
> 82177617920
> $ printf "%d\n" 0x00000013222bb000
> 82177667072
> $ btrfs insp dump-tree /dev/vg/test
> ...
> leaf 171360256 items 195 free space 29 generation 527 owner EXTENT_TREE
> leaf 171360256 flags 0x1(WRITTEN) backref revision 1
> checksum stored d9b6566b00000000000000000000000000000000000000000000000000000000
> checksum calced d9b6566b00000000000000000000000000000000000000000000000000000000
> fs uuid 3f85a731-21b4-4f3d-85b5-f9c45e8493f5
> chunk uuid 77575a06-4d6f-4748-a62c-59e6d9221be8
>         item 0 key (82177576960 EXTENT_ITEM 40960) itemoff 16230 itemsize 53
>                 refs 1 gen 527 flags DATA
>                 extent data backref root 256 objectid 257 offset 4021682176 count 1
>         item 1 key (82177617920 EXTENT_ITEM 49152) itemoff 16177 itemsize 53
>                 refs 1 gen 527 flags DATA
>                 extent data backref root 256 objectid 257 offset 4022075392 count 1
>         item 2 key (82177667072 EXTENT_ITEM 36864) itemoff 16124 itemsize 53
>                 refs 1 gen 527 flags DATA
>                 extent data backref root 256 objectid 257 offset 4022206464 count 1
> 
> ... but that doesn't really help me understand here.
> 
> Oh, well, passing you the ball again! :)
> Please ask if there's any infos I could get you.

Ok, maybe it's page fault related or there's something else besides page faults
involved.

Can you dump the subvolume tree like this:

btrfs inspect-internal dump-tree -t 5 /dev/sda 2>&1 | xz -9 > dump.xz

Here the 5 is the ID of the default subvolume. If the test file is on
a different subvolume, you'll need to replace 5 with the subvolume's ID.

This is just to look at the file extent layout.
Also, then tell me what's the inode number of the file (or just its name,
and I'll find out its inode number), and an example file offset and read
length that triggers a short read, so that I know where to look at.

And btw, that dump-tree command will dump all file names, directory names
and xattr names and values (if they are human readable) - so if privacy is
a concern here, just pass --hide-names to the dump-tree command.

Thanks.

> -- 
> Dominique
