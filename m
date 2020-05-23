Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB741DFAA9
	for <lists+io-uring@lfdr.de>; Sat, 23 May 2020 21:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387551AbgEWTUq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 May 2020 15:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbgEWTUq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 May 2020 15:20:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09156C05BD43
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 12:20:45 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id k7so6462099pjs.5
        for <io-uring@vger.kernel.org>; Sat, 23 May 2020 12:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hA9QPDx7hlE3ND4DwWRlDMJ19Frvrmq/H2EqY+eNJ64=;
        b=0q+YU9P9GK7f7corz/MS41QLym929QjELiRrpW8MG8nwgFwcsxsqzCbNyC7laJ1+PF
         glJphrkI1udiLmwSzBkbGBRq+UPe73XZoD2mvtEOZ4ia2S44JuxRfUumeDe4yb98XkRZ
         P5yD3lBb+VKq6WVq34r3Ou4D6u7gizH6e7wDh7/5gwBjIVCkJ5KgFhS+c6pf7/vrEzJy
         AkgSLIH8Z/r7HU6xk2xehOVbOp05rjgCDx4olsrirOGmqMR80ofSNU686R2TjN7Rhvct
         fjYmAUM0vHO1N3eVEB+5PPKJmsdd0ligK7RL/JZb1osl2D7+Z2ZNcRhTw69SNr8BEkjg
         r9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hA9QPDx7hlE3ND4DwWRlDMJ19Frvrmq/H2EqY+eNJ64=;
        b=gqtoCKoGYJuFnXBFx+3oqYe7JbY1YnHsyOWvAunMaVQV9Yznc3mf++ThHf7HjPN7Ne
         a9SOace+iyHJPNX342n1YqHzZ3vIcA6bCuskNRmJhPkahrQ3FG9SYYxnd4eZ48yEnz5Z
         jrWmGPHzsQ5kmLeR3Fyd2QETRb1UNml6VL2p4XulcKJOQzyhcIlHiS+O54bc2lktUOvx
         F1orx7xUaUFPlr4NT6ummopXj8PrZi6aXwxg5xA5swYtNgX14gY/cKt5+noy694MUTVB
         RBjrAbFCQMl4SDRvJ48YwOZ9AHz8ePBeoqCmf4LgKBy8QLmlHozkfgKkTg+1rDRlM71S
         xKhw==
X-Gm-Message-State: AOAM531mnGlb9F/r4xHcDtIvbl46xllOXRqNJJg+1OZFQEaWeib4kseu
        8u21YRiHoIno6KVp+Ayf+isoqw==
X-Google-Smtp-Source: ABdhPJxXzjl6T/Z1yURPua6/Yup1Xp5ljESCno0qdshH4asOxNjDPYFoS3I9T3IMOBXTfYoB8AZclg==
X-Received: by 2002:a17:90a:8545:: with SMTP id a5mr11496077pjw.200.1590261644246;
        Sat, 23 May 2020 12:20:44 -0700 (PDT)
Received: from ?IPv6:2605:e000:100e:8c61:c94:a67a:9209:cf5f? ([2605:e000:100e:8c61:c94:a67a:9209:cf5f])
        by smtp.gmail.com with ESMTPSA id 202sm2033541pfv.155.2020.05.23.12.20.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 May 2020 12:20:43 -0700 (PDT)
Subject: Re: [PATCHSET v2 0/12] Add support for async buffered reads
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20200523185755.8494-1-axboe@kernel.dk>
Message-ID: <2b42c0c3-5d3c-e381-4193-83cb3f971399@kernel.dk>
Date:   Sat, 23 May 2020 13:20:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200523185755.8494-1-axboe@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

And this one is v3, obviously, not v2...


On 5/23/20 12:57 PM, Jens Axboe wrote:
> We technically support this already through io_uring, but it's
> implemented with a thread backend to support cases where we would
> block. This isn't ideal.
> 
> After a few prep patches, the core of this patchset is adding support
> for async callbacks on page unlock. With this primitive, we can simply
> retry the IO operation. With io_uring, this works a lot like poll based
> retry for files that support it. If a page is currently locked and
> needed, -EIOCBQUEUED is returned with a callback armed. The callers
> callback is responsible for restarting the operation.
> 
> With this callback primitive, we can add support for
> generic_file_buffered_read(), which is what most file systems end up
> using for buffered reads. XFS/ext4/btrfs/bdev is wired up, but probably
> trivial to add more.
> 
> The file flags support for this by setting FMODE_BUF_RASYNC, similar
> to what we do for FMODE_NOWAIT. Open to suggestions here if this is
> the preferred method or not.
> 
> In terms of results, I wrote a small test app that randomly reads 4G
> of data in 4K chunks from a file hosted by ext4. The app uses a queue
> depth of 32. If you want to test yourself, you can just use buffered=1
> with ioengine=io_uring with fio. No application changes are needed to
> use the more optimized buffered async read.
> 
> preadv for comparison:
> 	real    1m13.821s
> 	user    0m0.558s
> 	sys     0m11.125s
> 	CPU	~13%
> 
> Mainline:
> 	real    0m12.054s
> 	user    0m0.111s
> 	sys     0m5.659s
> 	CPU	~32% + ~50% == ~82%
> 
> This patchset:
> 	real    0m9.283s
> 	user    0m0.147s
> 	sys     0m4.619s
> 	CPU	~52%
> 
> The CPU numbers are just a rough estimate. For the mainline io_uring
> run, this includes the app itself and all the threads doing IO on its
> behalf (32% for the app, ~1.6% per worker and 32 of them). Context
> switch rate is much smaller with the patchset, since we only have the
> one task performing IO.
> 
> The goal here is efficiency. Async thread offload adds latency, and
> it also adds noticable overhead on items such as adding pages to the
> page cache. By allowing proper async buffered read support, we don't
> have X threads hammering on the same inode page cache, we have just
> the single app actually doing IO.
> 
> Been beating on this and it's solid for me, and I'm now pretty happy
> with how it all turned out. Not aware of any missing bits/pieces or
> code cleanups that need doing.
> 
> Series can also be found here:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered.3
> 
> or pull from:
> 
> git://git.kernel.dk/linux-block async-buffered.3
> 
>  fs/block_dev.c            |   2 +-
>  fs/btrfs/file.c           |   2 +-
>  fs/ext4/file.c            |   2 +-
>  fs/io_uring.c             |  99 ++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_file.c         |   2 +-
>  include/linux/blk_types.h |   3 +-
>  include/linux/fs.h        |   5 ++
>  include/linux/pagemap.h   |  64 ++++++++++++++++++++++
>  mm/filemap.c              | 111 ++++++++++++++++++++++++--------------
>  9 files changed, 245 insertions(+), 45 deletions(-)
> 
> Changes since v2:
> - Get rid of unnecessary wait_page_async struct, just use wait_page_async
> - Add another prep handler, adding wake_page_match()
> - Use wake_page_match() in both callers
> Changes since v1:
> - Fix an issue with inline page locking
> - Fix a potential race with __wait_on_page_locked_async()
> - Fix a hang related to not setting page_match, thus missing a wakeup
> 


-- 
Jens Axboe

