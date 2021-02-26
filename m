Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBEC325EAF
	for <lists+io-uring@lfdr.de>; Fri, 26 Feb 2021 09:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbhBZINF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Feb 2021 03:13:05 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42786 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229482AbhBZINF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Feb 2021 03:13:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R861e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UPckvXq_1614327140;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UPckvXq_1614327140)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Feb 2021 16:12:20 +0800
Subject: Re: [dm-devel] [PATCH v3 11/11] dm: fastpath of bio-based polling
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     axboe@kernel.dk, snitzer@redhat.com, caspar@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        joseph.qi@linux.alibaba.com, dm-devel@redhat.com, hch@lst.de
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
 <20210208085243.82367-12-jefflexu@linux.alibaba.com>
 <alpine.LRH.2.02.2102191351200.10545@file01.intranet.prod.int.rdu2.redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <af9223b9-8960-1ed4-799a-bcd56299c587@linux.alibaba.com>
Date:   Fri, 26 Feb 2021 16:12:20 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.2102191351200.10545@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 2/20/21 3:38 AM, Mikulas Patocka wrote:
> 
> 
> On Mon, 8 Feb 2021, Jeffle Xu wrote:
> 
>> Offer one fastpath of bio-based polling when bio submitted to dm device
>> is not split.
>>
>> In this case, there will be only one bio submitted to only one polling
>> hw queue of one underlying mq device, and thus we don't need to track
>> all split bios or iterate through all polling hw queues. The pointer to
>> the polling hw queue the bio submitted to is returned here as the
>> returned cookie.
> 
> This doesn't seem safe - note that between submit_bio() and blk_poll(), no 
> locks are held - so the device mapper device may be reconfigured 
> arbitrarily. When you call blk_poll() with a pointer returned by 
> submit_bio(), the pointer may point to a stale address.
> 

Thanks for the feedback. Indeed maybe it's not a good idea to directly
return a 'struct blk_mq_hw_ctx *' pointer as the returned cookie.

Currently I have no idea to fix it, orz... The
blk_get_queue()/blk_put_queue() tricks may not work in this case.
Because the returned cookie may not be used at all. Before calling
blk_poll(), the polling routine may find that the corresponding IO has
already completed, and thus won't call blk_poll(), in which case we have
no place to put the refcount.

But I really don't want to drop this optimization, since this
optimization is quite intuitive when dm device maps to a lot of
underlying devices. Though this optimization doesn't actually achieve
reasonable performance gain in my test, maybe because there are at most
seven nvme devices in my test machine.

Any thoughts?

Thanks,
Jeffle


> 
>> In this case, the polling routine will call
>> mq_ops->poll() directly with the hw queue converted from the input
>> cookie.
>>
>> If the original bio submitted to dm device is split to multiple bios and
>> thus submitted to multiple polling hw queues, the bio submission routine
>> will return BLK_QC_T_BIO_MULTI, while the polling routine will fall
>> back to iterating all hw queues (in polling mode) of all underlying mq
>> devices.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  block/blk-core.c          | 33 +++++++++++++++++++++++++++++++--
>>  include/linux/blk_types.h |  8 ++++++++
>>  include/linux/types.h     |  2 +-
>>  3 files changed, 40 insertions(+), 3 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index 37aa513da5f2..cb24b33a4870 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -956,11 +956,19 @@ static blk_qc_t __submit_bio(struct bio *bio)
>>   * bio_list_on_stack[0] contains bios submitted by the current ->submit_bio.
>>   * bio_list_on_stack[1] contains bios that were submitted before the current
>>   *	->submit_bio_bio, but that haven't been processed yet.
>> + *
>> + * Return:
>> + *   - BLK_QC_T_NONE, no need for IO polling.
>> + *   - BLK_QC_T_BIO_MULTI, @bio gets split and enqueued into multi hw queues.
>> + *   - Otherwise, @bio is not split, returning the pointer to the corresponding
>> + *     hw queue that the bio enqueued into as the returned cookie.
>>   */
>>  static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  {
>>  	struct bio_list bio_list_on_stack[2];
>>  	blk_qc_t ret = BLK_QC_T_NONE;
>> +	struct request_queue *top_q = bio->bi_disk->queue;
>> +	bool poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags);
>>  
>>  	BUG_ON(bio->bi_next);
>>  
>> @@ -968,6 +976,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  	current->bio_list = bio_list_on_stack;
>>  
>>  	do {
>> +		blk_qc_t cookie;
>>  		struct request_queue *q = bio->bi_disk->queue;
>>  		struct bio_list lower, same;
>>  
>> @@ -980,7 +989,20 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>>  		bio_list_init(&bio_list_on_stack[0]);
>>  
>> -		ret = __submit_bio(bio);
>> +		cookie = __submit_bio(bio);
>> +
>> +		if (poll_on &&
>> +		    blk_qc_t_bio_valid(ret) && blk_qc_t_valid(cookie)) {
>> +			unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
>> +			struct blk_mq_hw_ctx *hctx = q->queue_hw_ctx[queue_num];
>> +
>> +			cookie = (blk_qc_t)hctx;
>> +
>> +			if (!blk_qc_t_valid(ret)) /* set initial value */
>> +				ret = cookie;
>> +			else if (ret != cookie)   /* bio got split */
>> +				ret = BLK_QC_T_BIO_MULTI;
>> +		}
>>  
>>  		/*
>>  		 * Sort new bios into those for a lower level and those for the
>> @@ -1003,6 +1025,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>>  	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
>>  
>>  	current->bio_list = NULL;
>> +
>>  	return ret;
>>  }
>>  
>> @@ -1142,7 +1165,13 @@ static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>>  	do {
>>  		int ret;
>>  
>> -		ret = disk->fops->poll(q, cookie);
>> +		if (blk_qc_t_bio_valid(cookie)) {
>> +			struct blk_mq_hw_ctx *hctx = (struct blk_mq_hw_ctx *)cookie;
>> +			struct request_queue *target_q = hctx->queue;
>> +
>> +			ret = blk_mq_poll_hctx(target_q, hctx);
>> +		} else
>> +			ret = disk->fops->poll(q, cookie);
>>  		if (ret > 0) {
>>  			__set_current_state(TASK_RUNNING);
>>  			return ret;
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 2e05244fc16d..4173754532c0 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -557,6 +557,14 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
>>  	return (cookie & BLK_QC_T_INTERNAL) != 0;
>>  }
>>  
>> +/* Macros for blk_qc_t used for bio-based polling */
>> +#define BLK_QC_T_BIO_MULTI	-2U
>> +
>> +static inline bool blk_qc_t_bio_valid(blk_qc_t cookie)
>> +{
>> +	return cookie != BLK_QC_T_BIO_MULTI;
>> +}
>> +
>>  struct blk_rq_stat {
>>  	u64 mean;
>>  	u64 min;
>> diff --git a/include/linux/types.h b/include/linux/types.h
>> index da5ca7e1bea9..f6301014a459 100644
>> --- a/include/linux/types.h
>> +++ b/include/linux/types.h
>> @@ -126,7 +126,7 @@ typedef u64 sector_t;
>>  typedef u64 blkcnt_t;
>>  
>>  /* cookie used for IO polling */
>> -typedef unsigned int blk_qc_t;
>> +typedef uintptr_t blk_qc_t;
>>  
>>  /*
>>   * The type of an index into the pagecache.
>> -- 
>> 2.27.0
>>
>> --
>> dm-devel mailing list
>> dm-devel@redhat.com
>> https://listman.redhat.com/mailman/listinfo/dm-devel
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
