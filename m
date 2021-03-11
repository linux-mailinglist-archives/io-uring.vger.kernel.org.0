Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEACD336BAA
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 06:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbhCKFbQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 00:31:16 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:56162 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229686AbhCKFbO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 00:31:14 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0URNSjFi_1615440670;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0URNSjFi_1615440670)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 11 Mar 2021 13:31:10 +0800
Subject: Re: [dm-devel] [PATCH v5 03/12] block: add poll method to support
 bio-based IO polling
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     axboe@kernel.dk, caspar@linux.alibaba.com,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, mpatocka@redhat.com, io-uring@vger.kernel.org
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
 <20210303115740.127001-4-jefflexu@linux.alibaba.com>
 <20210310220122.GB23410@redhat.com>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <7a934ba0-40b1-8611-4ed4-58a85923d6d9@linux.alibaba.com>
Date:   Thu, 11 Mar 2021 13:31:10 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210310220122.GB23410@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 3/11/21 6:01 AM, Mike Snitzer wrote:
> On Wed, Mar 03 2021 at  6:57am -0500,
> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
> 
>> ->poll_fn was introduced in commit ea435e1b9392 ("block: add a poll_fn
>> callback to struct request_queue") to support bio-based queues such as
>> nvme multipath, but was later removed in commit 529262d56dbe ("block:
>> remove ->poll_fn").
>>
>> Given commit c62b37d96b6e ("block: move ->make_request_fn to struct
>> block_device_operations") restore the possibility of bio-based IO
>> polling support by adding an ->poll method to gendisk->fops.
>>
>> Make blk_mq_poll() specific to blk-mq, while blk_bio_poll() is
>> originally a copy from blk_mq_poll(), and is specific to bio-based
>> polling. Currently hybrid polling is not supported by bio-based polling.
>>
>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>> ---
>>  block/blk-core.c       | 58 ++++++++++++++++++++++++++++++++++++++++++
>>  block/blk-mq.c         | 22 +---------------
>>  include/linux/blk-mq.h |  1 +
>>  include/linux/blkdev.h |  1 +
>>  4 files changed, 61 insertions(+), 21 deletions(-)
>>
>> diff --git a/block/blk-core.c b/block/blk-core.c
>> index fc60ff208497..6d7d53030d7c 100644
>> --- a/block/blk-core.c
>> +++ b/block/blk-core.c
>> @@ -1119,6 +1119,64 @@ blk_qc_t submit_bio(struct bio *bio)
>>  }
>>  EXPORT_SYMBOL(submit_bio);
>>  
>> +
> 
> Minor nit: Extra empty new line here? ^

Regards. Thanks.

> 
> Otherwise, looks good (I like the end result of blk-mq and bio-based
> polling being decoupled like hch suggested).
> 
> Reviewed-by: Mike Snitzer <snitzer@redhat.com>
> 
>> +static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>> +{
>> +	long state;
>> +	struct gendisk *disk = queue_to_disk(q);
>> +
>> +	state = current->state;
>> +	do {
>> +		int ret;
>> +
>> +		ret = disk->fops->poll(q, cookie);
>> +		if (ret > 0) {
>> +			__set_current_state(TASK_RUNNING);
>> +			return ret;
>> +		}
>> +
>> +		if (signal_pending_state(state, current))
>> +			__set_current_state(TASK_RUNNING);
>> +
>> +		if (current->state == TASK_RUNNING)
>> +			return 1;
>> +		if (ret < 0 || !spin)
>> +			break;
>> +		cpu_relax();
>> +	} while (!need_resched());
>> +
>> +	__set_current_state(TASK_RUNNING);
>> +	return 0;
>> +}
>> +
>> +/**
>> + * blk_poll - poll for IO completions
>> + * @q:  the queue
>> + * @cookie: cookie passed back at IO submission time
>> + * @spin: whether to spin for completions
>> + *
>> + * Description:
>> + *    Poll for completions on the passed in queue. Returns number of
>> + *    completed entries found. If @spin is true, then blk_poll will continue
>> + *    looping until at least one completion is found, unless the task is
>> + *    otherwise marked running (or we need to reschedule).
>> + */
>> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>> +{
>> +	if (!blk_qc_t_valid(cookie) ||
>> +	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
>> +		return 0;
>> +
>> +	if (current->plug)
>> +		blk_flush_plug_list(current->plug, false);
>> +
>> +	if (queue_is_mq(q))
>> +		return blk_mq_poll(q, cookie, spin);
>> +	else
>> +		return blk_bio_poll(q, cookie, spin);
>> +}
>> +EXPORT_SYMBOL_GPL(blk_poll);
>> +
>>  /**
>>   * blk_cloned_rq_check_limits - Helper function to check a cloned request
>>   *                              for the new queue limits
>> diff --git a/block/blk-mq.c b/block/blk-mq.c
>> index d4d7c1caa439..214fa30b460a 100644
>> --- a/block/blk-mq.c
>> +++ b/block/blk-mq.c
>> @@ -3852,30 +3852,11 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
>>  	return blk_mq_poll_hybrid_sleep(q, rq);
>>  }
>>  
>> -/**
>> - * blk_poll - poll for IO completions
>> - * @q:  the queue
>> - * @cookie: cookie passed back at IO submission time
>> - * @spin: whether to spin for completions
>> - *
>> - * Description:
>> - *    Poll for completions on the passed in queue. Returns number of
>> - *    completed entries found. If @spin is true, then blk_poll will continue
>> - *    looping until at least one completion is found, unless the task is
>> - *    otherwise marked running (or we need to reschedule).
>> - */
>> -int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>> +int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>>  {
>>  	struct blk_mq_hw_ctx *hctx;
>>  	long state;
>>  
>> -	if (!blk_qc_t_valid(cookie) ||
>> -	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
>> -		return 0;
>> -
>> -	if (current->plug)
>> -		blk_flush_plug_list(current->plug, false);
>> -
>>  	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
>>  
>>  	/*
>> @@ -3917,7 +3898,6 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>>  	__set_current_state(TASK_RUNNING);
>>  	return 0;
>>  }
>> -EXPORT_SYMBOL_GPL(blk_poll);
>>  
>>  unsigned int blk_mq_rq_cpu(struct request *rq)
>>  {
>> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
>> index 2c473c9b8990..6a7b693b9917 100644
>> --- a/include/linux/blk-mq.h
>> +++ b/include/linux/blk-mq.h
>> @@ -615,6 +615,7 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
>>  }
>>  
>>  blk_qc_t blk_mq_submit_bio(struct bio *bio);
>> +int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, bool spin);
>>  void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
>>  		struct lock_class_key *key);
>>  
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index b81a9fe015ab..9dc83c30e7bc 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -1866,6 +1866,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
>>  
>>  struct block_device_operations {
>>  	blk_qc_t (*submit_bio) (struct bio *bio);
>> +	int (*poll)(struct request_queue *q, blk_qc_t cookie);
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
