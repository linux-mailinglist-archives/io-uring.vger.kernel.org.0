Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB474336BBA
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 06:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbhCKFoR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 00:44:17 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:51089 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229702AbhCKFno (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 00:43:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0URPRT.J_1615441421;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0URPRT.J_1615441421)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Mar 2021 13:43:41 +0800
Subject: Re: [dm-devel] [PATCH v5 04/12] block: add poll_capable method to
 support bio-based IO polling
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     axboe@kernel.dk, caspar@linux.alibaba.com,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, mpatocka@redhat.com, io-uring@vger.kernel.org
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
 <20210303115740.127001-5-jefflexu@linux.alibaba.com>
 <20210310222130.GC23410@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <74101e54-5276-b67a-f275-3214630c9cad@linux.alibaba.com>
Date:   Thu, 11 Mar 2021 13:43:41 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310222130.GC23410@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/11/21 6:21 AM, Mike Snitzer wrote:
> On Wed, Mar 03 2021 at  6:57am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> This method can be used to check if bio-based device supports IO polling
>> or not. For mq devices, checking for hw queue in polling mode is
>> adequate, while the sanity check shall be implementation specific for
>> bio-based devices. For example, dm device needs to check if all
>> underlying devices are capable of IO polling.
>>
>> Though bio-based device may have done the sanity check during the
>> device initialization phase, cacheing the result of this sanity check
>> (such as by cacheing in the queue_flags) may not work. Because for dm
> 
> s/cacheing/caching/
> 
>> devices, users could change the state of the underlying devices through
>> '/sys/block/<dev>/io_poll', bypassing the dm device above. In this case,
>> the cached result of the very beginning sanity check could be
>> out-of-date. Thus the sanity check needs to be done every time 'io_poll'
>> is to be modified.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> 
> Ideally QUEUE_FLAG_POLL would be authoritative.. but I appreciate the
> problem you've described.  Though I do wonder if this should be solved
> by bio-based's fops->poll() method clearing the request_queue's
> QUEUE_FLAG_POLL if it finds an underlying device doesn't have
> QUEUE_FLAG_POLL set.  Though making bio-based's fops->poll() always need
> to validate the an underlying device does support polling is pretty
> unfortunate.

Agreed. It should be avoided to do control (slow) path in IO (fast) path
as much as possible.

Besides, considering the following patch [1], you should flush the queue
before clearing QUEUE_FLAG_POLL flag. If we embed the checking and
clearing in the normal IO path, then it may result in deadlock. For
example, once the polling routine finds that one of the underlying
device has cleared QUEUE_FLAG_POLL flag, then it needs to flush the
queue (of dm device) before clearing QUEUE_FLAG_POLL flag (of dm
device), while the polling routine itself is responsible for reaping the
completion events.

Of course the polling routine could defer clearing QUEUE_FLAG_POLL flag
to workqueue or something, but all these will lead to much complexity...


[1]
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?h=v5.12-rc2&id=6b09b4d33bd964f49d07d3cabfb4204d58cf9811

> 
> Either way, queue_poll_store() will need to avoid blk-mq specific poll
> checking for bio-based devices.
> 
> Mike
> 
>> ---
>>  block/blk-sysfs.c      | 14 +++++++++++---
>>  include/linux/blkdev.h |  1 +
>>  2 files changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
>> index 0f4f0c8a7825..367c1d9a55c6 100644
>> --- a/block/blk-sysfs.c
>> +++ b/block/blk-sysfs.c
>> @@ -426,9 +426,17 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
>>  	unsigned long poll_on;
>>  	ssize_t ret;
>>  
>> -	if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
>> -	    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
>> -		return -EINVAL;
>> +	if (queue_is_mq(q)) {
>> +		if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
>> +		    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
>> +			return -EINVAL;
>> +	} else {
>> +		struct gendisk *disk = queue_to_disk(q);
>> +
>> +		if (!disk->fops->poll_capable ||
>> +		    !disk->fops->poll_capable(disk))
>> +			return -EINVAL;
>> +	}
>>  
>>  	ret = queue_var_store(&poll_on, page, count);
>>  	if (ret < 0)
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 9dc83c30e7bc..7df40792c032 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1867,6 +1867,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
>>  struct block_device_operations {
>>  	blk_qc_t (*submit_bio) (struct bio *bio);
>>  	int (*poll)(struct request_queue *q, blk_qc_t cookie);
>> +	bool (*poll_capable)(struct gendisk *disk);
>>  	int (*open) (struct block_device *, fmode_t);
>>  	void (*release) (struct gendisk *, fmode_t);
>>  	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
>> -- 
>> 2.27.0
>>
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://listman.redhat.com/mailman/listinfo/dm-devel
> 

-- 
Thanks,
Jeffle
