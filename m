Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D28D2EC79A
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 02:15:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725860AbhAGBPj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 20:15:39 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:55981 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725789AbhAGBPi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 20:15:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UKxLUP3_1609982093;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UKxLUP3_1609982093)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 07 Jan 2021 09:14:54 +0800
Subject: Re: [dm-devel] [PATCH RFC 0/7] dm: add support of iopoll
From:   JeffleXu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
Message-ID: <568720e6-b574-eba4-cdf6-6c41c8901772@linux.alibaba.com>
Date:   Thu, 7 Jan 2021 09:14:53 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Mike,

Would you please give some suggestions on this series?


Thanks,
Jeffle

On 12/23/20 7:26 PM, Jeffle Xu wrote:
> This patch set adds support of iopoll for dm devices.
> 
> Several months ago, I also sent a patch set adding support of iopoll
> for dm devices [1]. The old patch set implement this by polling all
> polling mode hardware queues of all underlying target devices
> unconditionally, no matter which hardware queue the bio is enqueued
> into.
> 
> Ming Lei pointed out that this implementation may have performance
> issue. Mike Snitzer also discussed and helpt a lot on the design
> issue. At that time, we agreed that this feature should be
> implemented on the basis of split-bio tracking, since the bio to the
> dm device could be split into multiple split bios to the underlying
> target devices.
> 
> This patch set actually implement the split-bio tracking part.
> Regrettably this implementation is quite coarse and original. Quite
> code refactoring is introduced to the block core, since device mapper
> also calls methods provided by block core to split bios. The new
> fields are directly added into 'struct bio' structure. So this is
> just an RFC version and there may be quite a lot design issues be
> fronted on. I just implement a version quickly and would like to share
> with you my thoughts and problems at hand.
> 
> This implementation works but has poor performance. Awkwardly the
> performance of direct 8k randread decreases ~20% on a 8k-striped
> dm-stripe device.
> 
> The first 5 patches prepare the introduction of iopoll for dm device.
> Patch 6 is the core part and implements a mechanism of tracking split
> bios for bio-based device. Patch 7 just enables this feature.
> 
> [1] https://patchwork.kernel.org/project/linux-block/cover/20201020065420.124885-1-jefflexu@linux.alibaba.com/
> 
> 
> [Design Notes]
> 
> - recursive way or non-recursive way?
> 
> The core of the split-bio tracking mechanism is that, a list is
> maintained in the top bio (the original bio submitted to the dm
> device), which is actually used to maintain all valid cookies of all
> split bios.
> 
> This is actually a non-recursive way to implement the tracking
> mechanism. On the contrary, the recursive way is that, maintain the
> split bios at each dm layer. DM device can be build into a device
> stack. For example, considering the following device stack,
> 
> ```
>             dm0(bio 0)
> dm1(bio 1)             dm2(bio 2)
> nvme0(bio 3)           nvme1(bio 4)
> 
> ```
> 
> The non-recursive way is that bio 3/4 are directly maintained as a
> list beneath bio 0. The recursive way is that, bio 3 is maintained
> as a list beneath bio 1 and bio 4 is maintained as a list beneath
> bio 2, while bio 1/2 are maintained as a list beneath bio 0.
> 
> The reason why I choose the non-recursive way is that, we need call
> blk_bio_poll() or something recursively if it's implemented in the
> recursive way, and I worry this would consume up the stack space if
> the device stack is too deep. After all bio_list is used to prevent
> the dm device using up stack space when submitting bio. 
> 
> 
> - why embed new fields into struct bio directly?
> 
> Mike Snitzer had ever suggested that the newly added fields could be
> integrated into the clone bio allocated by dm subsystem through
> bio_set. There're 3 reasons why I directly embed these fields into
> struct bio:
> 
> 1. The implementation difference of DM and MD
> DM subsystem indeed allocate clone bio itself, in which case we could
> allocate extra per-bio space for specific usage. However MD subsystem
> doesn't allocate extra clone bio, and just uses the bio structure
> originally submitted to MD device as the bio structure submitted to
> the underlying target device. (At least raid0 works in this way.)
> 
> 2. In the previously mentioned non-recursive way of iopoll, a list
> containing all valid cookies should be maintained. For convenience, I
> just put this list in the top bio (the original bio structure
> submitted to the dm device). This original bio structure is allocated
> by the upper layer, e.g. filesystem, and is out of control of DM
> subsystem. (Of course we could resolve this problem technically, e.g.,
> put these newlly added fields into the corresponding dm_io structure
> of the top bio.)
> 
> 3. As a quick implementation, I just put these fields into struct bio
> directly. Obviously more design issues need to be considered when it
> comes into the formal version.
> 
> 
> Jeffle Xu (7):
>   block: move definition of blk_qc_t to types.h
>   block: add helper function fetching gendisk from queue
>   block: add iopoll method for non-mq device
>   block: define blk_qc_t as uintptr_t
>   dm: always return BLK_QC_T_NONE for bio-based device
>   block: track cookies of split bios for bio-based device
>   dm: add support for IO polling
> 
>  block/bio.c                  |   8 ++
>  block/blk-core.c             | 163 ++++++++++++++++++++++++++++++++++-
>  block/blk-mq.c               |  70 ++-------------
>  drivers/md/dm-table.c        |  28 ++++++
>  drivers/md/dm.c              |  27 +++---
>  include/linux/blk-mq.h       |   3 +
>  include/linux/blk_types.h    |  41 ++++++++-
>  include/linux/blkdev.h       |   3 +
>  include/linux/fs.h           |   2 +-
>  include/linux/types.h        |   3 +
>  include/trace/events/kyber.h |   6 +-
>  11 files changed, 270 insertions(+), 84 deletions(-)
> 

-- 
Thanks,
Jeffle
