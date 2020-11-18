Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCE02B7AA9
	for <lists+io-uring@lfdr.de>; Wed, 18 Nov 2020 10:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727262AbgKRJuq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Nov 2020 04:50:46 -0500
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:47730 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726086AbgKRJuq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Nov 2020 04:50:46 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0UFnoS5C_1605693042;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UFnoS5C_1605693042)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Nov 2020 17:50:42 +0800
From:   JeffleXu <jefflexu@linux.alibaba.com>
Subject: Re: [PATCH v4 0/2] block, iomap: disable iopoll for split bio
To:     axboe@kernel.dk, hch@infradead.org, ming.lei@redhat.com
Cc:     linux-block@vger.kernel.org, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com
References: <20201117075625.46118-1-jefflexu@linux.alibaba.com>
 <cca4e028-58b4-24e0-51d5-1ebc45664ae2@linux.alibaba.com>
Message-ID: <b0e86685-6809-e48d-f583-9b3af4ff79b1@linux.alibaba.com>
Date:   Wed, 18 Nov 2020 17:50:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <cca4e028-58b4-24e0-51d5-1ebc45664ae2@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


On 11/17/20 8:51 PM, JeffleXu wrote:
>
> On 11/17/20 3:56 PM, Jeffle Xu wrote:
>> This patchset is to fix the potential hang occurred in sync polling.
>>
>> Please refer the following link for background info and the v1 patch:
>> https://patchwork.kernel.org/project/linux-block/patch/20201013084051.27255-1-jefflexu@linux.alibaba.com/ 
>>
>>
>> The first patch disables iopoll for split bio in block layer, which is
>> suggested by Ming Lei.
>>
>>
>> The second patch disables iopoll when one dio need to be split into
>> multiple bios. As for this patch, Ming Lei had ever asked what's the
>> expected behaviour of upper layers when simply clear IOCB_HIPRI in
>> the direct routine of blkdev fs, iomap-based fs. Currently there are
>> two parts concerning IOCB_HIPRI (or io polling). One is the sync
>> polling logic embedded in the direct IO routine. In this case, sync
>> polling won't be executed any more since IOCB_HIPRI flag has been
>> cleared from iocb->ki_flags. Consider the following code snippet:
>>
>> fs/block_dev.c: __blkdev_direct_IO
>>     for (;;) {
>>         ...
>>         if (!(iocb->ki_flags & IOCB_HIPRI) ||
>>             !blk_poll(bdev_get_queue(bdev), qc, true))
>>             blk_io_schedule();
>>     }
>>
>> fs/iomap/direct-io.c: __iomap_dio_rw
>>     for (;;) {
>>         ...
>>         if (!(iocb->ki_flags & IOCB_HIPRI) ||
>>             !dio->submit.last_queue ||
>>             !blk_poll(dio->submit.last_queue,
>>                  dio->submit.cookie, true))
>>             blk_io_schedule();
>>     }
>>
>>
>> The other part is io_uring.
>>
>> fs/io_uring.c:
>> io_iopoll_getevents
>>    io_do_iopoll
>>      list_for_each_entry_safe(...) {
>>        ret = kiocb->ki_filp->f_op->iopoll(kiocb, spin);
>>      }
>>
>> In this case, though the split bios have been enqueued into DEFAULT
>> hw queues, io_uring will still poll POLL hw queues. When polling on
>> the cookie returned by split bio, blk_poll() will return 0 immediately
>> since the hw queue type check added in patch 1. If there's no other
>> bio in the POLL hw queues, io_do_iopoll() will loop indefinitely
>> until the split bio is completed by interrupt of DEFAULT queue. Indeed
>> there may be a pulse of high CPU sys in this time window here, but it
>> is no worse than before. After all io_do_iopoll() will still get stuck
>> in this loop when there's only one bio (that we are polling on) in POLL
>> hw queue, before this patch applied.
>>
>> The situation described above may be less impossible. As long as there
>> are other bios in POLL hw queue, work of io_do_iopoll() is still
>> meaningful as it *helps* reap these other bios in POLL hw queue, while
>> the split bios are still completed by interrupt of DEFAULT hw queue.
>
> ops, this design could still be problematic. Once the cookie of split 
> bio is iterated in io_do_iopoll(),
>
> io_do_iopoll() will get stuck in indefinite loop doing nothing until 
> the split bio is completed by the interrupt of
>
> DEFAULT hw queue, even when there may be other bios in POLL hw queue 
> waiting to be reaped.

This shouldn't be a problem. After this patch applied, blk_poll() will 
return 0 immediately

since the hw queue type check added in patch 1, and thus io_do_iopoll() 
will iterate next

kiocb in @iopoll_list. There will be no indefinite loop. Sorry for the 
noise...

-- 
Thanks,
Jeffle

