Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4A31DFE16
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 12:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728766AbgEXKAi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 06:00:38 -0400
Received: from mail.movency.com ([151.236.222.166]:48932 "EHLO b-6.movency.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728704AbgEXKAi (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 24 May 2020 06:00:38 -0400
X-Greylist: delayed 862 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 May 2020 06:00:36 EDT
Received: by b-6.movency.com  with ESMTPSA id 04O9kAQW1722314; Sun, 24 May 2020 09:46:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=movency.com; s=mail;
        t=1590313570; bh=7BbKC33g6/SJX0HzjCZQwGRQaPz1+PXkt/MsPwq9E8w=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=CJyLgB48NcEl+KvLnGv3WibuDbym811oaMyjEZ1ZO0MCYcDUELobQgrckBj+HTaU1
         Mtpqgs5GhlHt6H7JbvylLaJwcvzuHBzwr4aP5P6+OwgIURhZl/i3XK5uo2W3NHrSgk
         IGtMTKO3O0a6mhRPxmMOIIv04OHQOKa8mwtPdiQQBgVGSCXbq8wE+C275GW/KDC8RZ
         NR5rJ/Dx2LYz9p42yoRkWLus5JkunLcR1QKgU7qJSLe/P2pnorYqlapIcXFuiqnCar
         uTuQZbQX8V7c2WT/RR2+bGnUAYNyG71HtK5p5M/RZlvn309aJxUPszKex29bTU+xvg
         8RDjBmlrtL6ZA==
Subject: Re: [PATCHSET v2 0/12] Add support for async buffered reads
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <20200523185755.8494-1-axboe@kernel.dk>
 <2b42c0c3-5d3c-e381-4193-83cb3f971399@kernel.dk>
From:   Chris Panayis <chris@movency.com>
Message-ID: <43ee202c-ffd1-2276-3c8d-7d5201b60684@movency.com>
Date:   Sun, 24 May 2020 10:46:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2b42c0c3-5d3c-e381-4193-83cb3f971399@kernel.dk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Yes! Jens & Team! Yes!

My code has never looked so beautiful, been so efficient and run so well 
since switching to io_uring/async awesome-ness.. Really, really is a 
game-changer in terms of software design, control, performance, 
expressiveness... so many levels. Really, really great work! Thank you!

Chris


On 23/05/2020 20:20, Jens Axboe wrote:
> And this one is v3, obviously, not v2...
>
>
> On 5/23/20 12:57 PM, Jens Axboe wrote:
>> We technically support this already through io_uring, but it's
>> implemented with a thread backend to support cases where we would
>> block. This isn't ideal.
>>
>> After a few prep patches, the core of this patchset is adding support
>> for async callbacks on page unlock. With this primitive, we can simply
>> retry the IO operation. With io_uring, this works a lot like poll based
>> retry for files that support it. If a page is currently locked and
>> needed, -EIOCBQUEUED is returned with a callback armed. The callers
>> callback is responsible for restarting the operation.
>>
>> With this callback primitive, we can add support for
>> generic_file_buffered_read(), which is what most file systems end up
>> using for buffered reads. XFS/ext4/btrfs/bdev is wired up, but probably
>> trivial to add more.
>>
>> The file flags support for this by setting FMODE_BUF_RASYNC, similar
>> to what we do for FMODE_NOWAIT. Open to suggestions here if this is
>> the preferred method or not.
>>
>> In terms of results, I wrote a small test app that randomly reads 4G
>> of data in 4K chunks from a file hosted by ext4. The app uses a queue
>> depth of 32. If you want to test yourself, you can just use buffered=1
>> with ioengine=io_uring with fio. No application changes are needed to
>> use the more optimized buffered async read.
>>
>> preadv for comparison:
>> 	real    1m13.821s
>> 	user    0m0.558s
>> 	sys     0m11.125s
>> 	CPU	~13%
>>
>> Mainline:
>> 	real    0m12.054s
>> 	user    0m0.111s
>> 	sys     0m5.659s
>> 	CPU	~32% + ~50% == ~82%
>>
>> This patchset:
>> 	real    0m9.283s
>> 	user    0m0.147s
>> 	sys     0m4.619s
>> 	CPU	~52%
>>
>> The CPU numbers are just a rough estimate. For the mainline io_uring
>> run, this includes the app itself and all the threads doing IO on its
>> behalf (32% for the app, ~1.6% per worker and 32 of them). Context
>> switch rate is much smaller with the patchset, since we only have the
>> one task performing IO.
>>
>> The goal here is efficiency. Async thread offload adds latency, and
>> it also adds noticable overhead on items such as adding pages to the
>> page cache. By allowing proper async buffered read support, we don't
>> have X threads hammering on the same inode page cache, we have just
>> the single app actually doing IO.
>>
>> Been beating on this and it's solid for me, and I'm now pretty happy
>> with how it all turned out. Not aware of any missing bits/pieces or
>> code cleanups that need doing.
>>
>> Series can also be found here:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered.3
>>
>> or pull from:
>>
>> git://git.kernel.dk/linux-block async-buffered.3
>>
>>   fs/block_dev.c            |   2 +-
>>   fs/btrfs/file.c           |   2 +-
>>   fs/ext4/file.c            |   2 +-
>>   fs/io_uring.c             |  99 ++++++++++++++++++++++++++++++++++
>>   fs/xfs/xfs_file.c         |   2 +-
>>   include/linux/blk_types.h |   3 +-
>>   include/linux/fs.h        |   5 ++
>>   include/linux/pagemap.h   |  64 ++++++++++++++++++++++
>>   mm/filemap.c              | 111 ++++++++++++++++++++++++--------------
>>   9 files changed, 245 insertions(+), 45 deletions(-)
>>
>> Changes since v2:
>> - Get rid of unnecessary wait_page_async struct, just use wait_page_async
>> - Add another prep handler, adding wake_page_match()
>> - Use wake_page_match() in both callers
>> Changes since v1:
>> - Fix an issue with inline page locking
>> - Fix a potential race with __wait_on_page_locked_async()
>> - Fix a hang related to not setting page_match, thus missing a wakeup
>>
>
