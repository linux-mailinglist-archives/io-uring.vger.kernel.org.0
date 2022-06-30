Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 309A8561B0B
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 15:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbiF3NKr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 09:10:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiF3NKq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 09:10:46 -0400
Received: from gw2.atmark-techno.com (gw2.atmark-techno.com [35.74.137.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3960D27CC3
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 06:10:43 -0700 (PDT)
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
        by gw2.atmark-techno.com (Postfix) with ESMTPS id 9781220D60
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 22:10:42 +0900 (JST)
Received: by mail-pg1-f199.google.com with SMTP id 196-20020a6300cd000000b0040c9c64e7e4so9691749pga.9
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 06:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KXHvFJE+Ra1Ta2VHsFr1xKZy6p8ZRnSJx8lAp3hz1zo=;
        b=ftDVV0pH8jADYrX3LiY4w4Dndk1vnNvV7iwhYFBFqrvaauI7Nv8UCj9uyqFc/CzfMe
         R2SK7YBhUvq5Gbt3SycZnGYBRH7XirNKalDmiMb+jzGp7M004wNP70UWEXKnstVrl9r9
         VLW1RTN6Ox24UZLVkahsJMzWw54Yr9qLW1QocpLcLwV8etm5ocfSU74ybqYZOpCQeT4e
         ylkO5ePZ0+R9UlW0Rwj4rE4NGxBrsrTlv/UG7CIgYr7cm2N/RzJr1oCyompZ+Ksuk7wv
         f0WxU7tGzdJc3Og1Gra27rQuVIF3ANc/vErn7NLYje3yLsFP9gdVEZzcCD7k7brVgbm3
         8S0g==
X-Gm-Message-State: AJIora/z4zWqpZivNtcYjqCpwN/VwmQIg/r/f3u4JcNILPbffOg1b6VU
        KkD1hajY7Qt2F2SZ6grXiHsFat5xd/52Xu7iz5lBUyeR6YVjUS9qyuGvAamFZzMJM8YjovDJK52
        bCKbSAPcbIoJc2Ya+FfK8
X-Received: by 2002:a65:5a42:0:b0:411:bf36:eeec with SMTP id z2-20020a655a42000000b00411bf36eeecmr617420pgs.522.1656594641704;
        Thu, 30 Jun 2022 06:10:41 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tMjKrlMY81Wg5EQjBFVsz+y9WcW1EPe860eX3wq9j49Vm6Pnuflkj6Pk8bucdksCmDfNFfmw==
X-Received: by 2002:a65:5a42:0:b0:411:bf36:eeec with SMTP id z2-20020a655a42000000b00411bf36eeecmr617405pgs.522.1656594641501;
        Thu, 30 Jun 2022 06:10:41 -0700 (PDT)
Received: from pc-zest.atmarktech (162.198.187.35.bc.googleusercontent.com. [35.187.198.162])
        by smtp.gmail.com with ESMTPSA id i12-20020a17090a64cc00b001eccb13dfb0sm1913575pjm.4.2022.06.30.06.10.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jun 2022 06:10:41 -0700 (PDT)
Received: from martinet by pc-zest.atmarktech with local (Exim 4.95)
        (envelope-from <martinet@pc-zest>)
        id 1o6tuG-0007Ng-Ib;
        Thu, 30 Jun 2022 22:08:28 +0900
Date:   Thu, 30 Jun 2022 22:08:18 +0900
From:   Dominique MARTINET <dominique.martinet@atmark-techno.com>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Nikolay Borisov <nborisov@suse.com>, Jens Axboe <axboe@kernel.dk>,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: read corruption with qemu master io_uring engine / linux master
 / btrfs(?)
Message-ID: <Yr2gQh5GaVmTEDW2@atmark-techno.com>
References: <bd342da1-8c98-eb78-59f1-e3cf537181e3@suse.com>
 <dd55e282-1147-08ae-6b9f-cf3ef672fce8@suse.com>
 <YrueYDXqppHZzOsy@atmark-techno.com>
 <Yrvfqh0eqN0J5T6V@atmark-techno.com>
 <20220629153710.GA379981@falcondesktop>
 <YrzxHbWCR6zhIAcx@atmark-techno.com>
 <Yr1XNe9V3UY/MkDz@atmark-techno.com>
 <20220630104536.GA434846@falcondesktop>
 <Yr2ItqlxeII0sReD@atmark-techno.com>
 <20220630125124.GA446657@falcondesktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220630125124.GA446657@falcondesktop>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Filipe Manana wrote on Thu, Jun 30, 2022 at 01:51:24PM +0100:
> > Please ask if there's any infos I could get you.
> 
> Ok, maybe it's page fault related or there's something else besides page faults
> involved.
> 
> Can you dump the subvolume tree like this:
> 
> btrfs inspect-internal dump-tree -t 5 /dev/sda 2>&1 | xz -9 > dump.xz
> 
> Here the 5 is the ID of the default subvolume. If the test file is on
> a different subvolume, you'll need to replace 5 with the subvolume's ID.

Sure thing.

It's 2MB compressed:
https://gaia.codewreck.org/local/tmp/dump-tree.xz


> This is just to look at the file extent layout.
> Also, then tell me what's the inode number of the file (or just its name,
> and I'll find out its inode number), and an example file offset and read
> length that triggers a short read, so that I know where to look at.

There's just a single file in that subvolume, inode 257

> And btw, that dump-tree command will dump all file names, directory names
> and xattr names and values (if they are human readable) - so if privacy is
> a concern here, just pass --hide-names to the dump-tree command.

(thanks for the warning)
-- 
Dominique
