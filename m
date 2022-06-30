Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61CCF56193B
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 13:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234949AbiF3LaS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 07:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbiF3LaR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 07:30:17 -0400
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3895651B28
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 04:30:15 -0700 (PDT)
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id A610F20D60
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 20:30:14 +0900 (JST)
Received: by mail-pj1-f72.google.com with SMTP id j14-20020a17090a694e00b001ed112b078aso1328310pjm.3
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 04:30:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cx3Dj7HU8xXuNateb26QlINwAzFiK2pj8V6L/fw6oxg=;
        b=Amrtd3xinx5keKsl2hfiQ+fiw2NshrJsRSn+Mc0TcCBxUut1FhVCgGj5Kc/I4AhWNy
         VsNH2+QveN/Twf26Jwvh7nZVJa/uTH3JkgCj8Pft+fdcduT16tNZC1+eE/zYBpmucX1p
         3l06CGw2bdB7MNgJLatPpMJztFvQngg/Eq2BxKsS5DW384S90dghzYKOnXH0shnMN/H5
         /uwwrC2TuJgCOLNim+AAqccaHGmvwKxLHQgGpi1/QuG9rFtz6U+LJlaXbm4jBCAvyWDv
         Hfsfhx6kDrnvGWd1Ct96eFGt0eijXSpVzvSaAA7u6qyZNPUuoYzNxPQSHUuHUhFvUvjz
         SVoA==
X-Gm-Message-State: AJIora+5GVrkkFRV/xyTFe1qu4kYw7qIXpZzRnjDb1fDLv/l0XDQa9Ev
        JqjZp305L1RQ+JZ2V2AsVLVJcU7D0Ik7uwQpj9ngfqpp25IjuE+uMBEgEDxQ73dHpaQdDot1Wp3
        ppGLx6L+vzu1uQSC82zdl
X-Received: by 2002:a17:902:cf41:b0:16b:7c56:13f4 with SMTP id e1-20020a170902cf4100b0016b7c5613f4mr15133593plg.58.1656588613685;
        Thu, 30 Jun 2022 04:30:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sM64sO9rQdWesB3tS+dHfVmPlx2w2hFzAzvJw7VUxmaJuEoAHOn2C6qgVcTvAmFsC1VkOSeQ==
X-Received: by 2002:a17:902:cf41:b0:16b:7c56:13f4 with SMTP id e1-20020a170902cf4100b0016b7c5613f4mr15133568plg.58.1656588613366;
        Thu, 30 Jun 2022 04:30:13 -0700 (PDT)
Received: from pc-zest.atmarktech (145.82.198.104.bc.googleusercontent.com. [104.198.82.145])
        by smtp.gmail.com with ESMTPSA id 36-20020a630c64000000b003fc4001fd5fsm12657655pgm.10.2022.06.30.04.30.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jun 2022 04:30:13 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o6sL2-0005wA-KA;
        Thu, 30 Jun 2022 20:28:00 +0900
Date:   Thu, 30 Jun 2022 20:27:50 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <Yr2ItqlxeII0sReD@atmark-techno.com>
References: <33cd0f9a-cdb1-1018-ebb0-89222cb1c759@kernel.dk>
 <bd342da1-8c98-eb78-59f1-e3cf537181e3@suse.com>
 <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
 <YrueYDXqppHZzOsy@atmark-techno.com>
 <Yrvfqh0eqN0J5T6V@atmark-techno.com>
 <20220629153710.GA379981@falcondesktop>
 <YrzxHbWCR6zhIAcx@atmark-techno.com>
 <Yr1XNe9V3UY/MkDz@atmark-techno.com>
 <20220630104536.GA434846@falcondesktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220630104536.GA434846@falcondesktop>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Filipe Manana wrote on Thu, Jun 30, 2022 at 11:45:36AM +0100:
> So here's a patch for you to try:
> 
> https://gist.githubusercontent.com/fdmanana/4b24d6b30983e956bb1784a44873c5dd/raw/572490b127071bf827c3bc05dd58dcb7bcff373a/dio.patch

Thanks.
Unfortunately I still hit short reads with this; I can't really tell if
there are more or less than before (unfortunately the parallelism of my
reproducer means that even dropping caches and restarting with the same
seed I get a different offset for short read), but it looks fairly
similar -- usually happens within the first 1000 operations with
sometimes a bit slower with or without the patch.

I went ahead and added a printk in dio_fault_in_size to see if it was
used and it looks like it is, but that doesn't really tell if it is the
reason for short reads (hm, thinking back I could just have printed the
offsets...):
----
/ # /mnt/repro /mnt/t/t/atde-test 
random seed 4061910570
Starting io_uring reads...
[   17.872992] dio_fault_in_size: left 3710976 prev_left 0 size 131072
[   17.873958] dio_fault_in_size: left 3579904 prev_left 3710976 size 131072
[   17.874246] dio_fault_in_size: left 1933312 prev_left 0 size 131072
[   17.875111] dio_fault_in_size: left 3448832 prev_left 3579904 size 131072
[   17.876446] dio_fault_in_size: left 3317760 prev_left 3448832 size 131072
[   17.877493] dio_fault_in_size: left 3186688 prev_left 3317760 size 131072
[   17.878667] dio_fault_in_size: left 3055616 prev_left 3186688 size 131072
[   17.880001] dio_fault_in_size: left 2924544 prev_left 3055616 size 131072
[   17.881524] dio_fault_in_size: left 2793472 prev_left 2924544 size 131072
[   17.882462] dio_fault_in_size: left 2662400 prev_left 2793472 size 131072
[   17.883433] dio_fault_in_size: left 2531328 prev_left 2662400 size 131072
[   17.884573] dio_fault_in_size: left 2400256 prev_left 2531328 size 131072
[   17.886008] dio_fault_in_size: left 2269184 prev_left 2400256 size 131072
[   17.887058] dio_fault_in_size: left 2138112 prev_left 2269184 size 131072
[   17.888313] dio_fault_in_size: left 2007040 prev_left 2138112 size 131072
[   17.889873] dio_fault_in_size: left 1875968 prev_left 2007040 size 131072
[   17.891041] dio_fault_in_size: left 1744896 prev_left 1875968 size 131072
[   17.893174] dio_fault_in_size: left 802816 prev_left 1744896 size 131072
[   17.930249] dio_fault_in_size: left 3325952 prev_left 0 size 131072
[   17.931472] dio_fault_in_size: left 1699840 prev_left 0 size 131072
[   17.956509] dio_fault_in_size: left 1699840 prev_left 0 size 131072
[   17.957522] dio_fault_in_size: left 1888256 prev_left 0 size 131072
bad read result for io 3, offset 4022030336: 176128 should be 1531904
----

(ugh, saw the second patch after writing all this.. but it's the same:
----
/ # /mnt/repro /mnt/t/t/atde-test 
random seed 634214270
Starting io_uring reads...
[   17.858718] dio_fault_in_size: left 1949696 prev_left 0 size 131072
[   18.193604] dio_fault_in_size: left 1142784 prev_left 0 size 131072
[   18.218500] dio_fault_in_size: left 528384 prev_left 0 size 131072
[   18.248184] dio_fault_in_size: left 643072 prev_left 0 size 131072
[   18.291639] dio_fault_in_size: left 131072 prev_left 0 size 131072
bad read result for io 4, offset 5079498752: 241664 should be 2142208
----
rest of the mail is on first patch as I used offset of first message,
but shouldn't matter)

Given my file has many many extents, my guess would be that short reads
happen when we're crossing an extent boundary.


Using the fiemap[1] command I can confirm that it is the case:
[1] https://github.com/ColinIanKing/fiemap

$ printf "%x\n" $((4022030336 + 176128))
efbe0000
$ fiemap /mnt/t/t/atde-test
File atde-test has 199533 extents:
#       Logical          Physical         Length           Flags
...
23205:  00000000efba0000 0000001324f00000 0000000000020000 0008
23206:  00000000efbc0000 00000013222af000 0000000000020000 0008
23207:  00000000efbe0000 00000013222bb000 0000000000020000 0008

but given how many extents there are that doesn't explain why it stopped
at this offset within the file and not another before it: transition
from compressed to non-compressed or something? I didn't find any tool
able to show extent attributes; here's what `btrfs insp dump-tree` has
to say about this physical offset:

$ printf "%d\n" 0x00000013222af000
82177617920
$ printf "%d\n" 0x00000013222bb000
82177667072
$ btrfs insp dump-tree /dev/vg/test
...
leaf 171360256 items 195 free space 29 generation 527 owner EXTENT_TREE
leaf 171360256 flags 0x1(WRITTEN) backref revision 1
checksum stored d9b6566b00000000000000000000000000000000000000000000000000000000
checksum calced d9b6566b00000000000000000000000000000000000000000000000000000000
fs uuid 3f85a731-21b4-4f3d-85b5-f9c45e8493f5
chunk uuid 77575a06-4d6f-4748-a62c-59e6d9221be8
        item 0 key (82177576960 EXTENT_ITEM 40960) itemoff 16230 itemsize 53
                refs 1 gen 527 flags DATA
                extent data backref root 256 objectid 257 offset 4021682176 count 1
        item 1 key (82177617920 EXTENT_ITEM 49152) itemoff 16177 itemsize 53
                refs 1 gen 527 flags DATA
                extent data backref root 256 objectid 257 offset 4022075392 count 1
        item 2 key (82177667072 EXTENT_ITEM 36864) itemoff 16124 itemsize 53
                refs 1 gen 527 flags DATA
                extent data backref root 256 objectid 257 offset 4022206464 count 1

... but that doesn't really help me understand here.

Oh, well, passing you the ball again! :)
Please ask if there's any infos I could get you.

-- 
Dominique
