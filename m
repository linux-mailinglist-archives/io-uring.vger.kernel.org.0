Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39A82F0D84
	for <lists+io-uring@lfdr.de>; Mon, 11 Jan 2021 08:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727653AbhAKHvQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jan 2021 02:51:16 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42246 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727652AbhAKHvQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jan 2021 02:51:16 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0ULL1B17_1610351422;
Received: from admindeMacBook-Pro-2.local(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0ULL1B17_1610351422)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 11 Jan 2021 15:50:23 +0800
Subject: Re: [dm-devel] [PATCH RFC 3/7] block: add iopoll method for non-mq
 device
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-4-jefflexu@linux.alibaba.com>
 <20210107214758.GC21239@redhat.com>
 <b081f3bd-fc6f-f7c1-80eb-c8380fc8e8b9@linux.alibaba.com>
 <20210108173320.GA6584@lobo>
From:   JeffleXu <jefflexu@linux.alibaba.com>
Message-ID: <877a1c04-38a4-a648-464a-d17556b92554@linux.alibaba.com>
Date:   Mon, 11 Jan 2021 15:50:22 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108173320.GA6584@lobo>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On 1/9/21 1:33 AM, Mike Snitzer wrote:
> On Thu, Jan 07 2021 at 10:24pm -0500,
> JeffleXu <jefflexu@linux.alibaba.com> wrote:
> 
>>
>>
>> On 1/8/21 5:47 AM, Mike Snitzer wrote:
>>> On Wed, Dec 23 2020 at  6:26am -0500,
>>> Jeffle Xu <jefflexu@linux.alibaba.com> wrote:
>>>
>>>> ->poll_fn is introduced in commit ea435e1b9392 ("block: add a poll_fn
>>>> callback to struct request_queue") for supporting non-mq queues such as
>>>> nvme multipath, but removed in commit 529262d56dbe ("block: remove
>>>> ->poll_fn").
>>>>
>>>> To add support of IO polling for non-mq device, this method need to be
>>>> back. Since commit c62b37d96b6e ("block: move ->make_request_fn to
>>>> struct block_device_operations") has moved all callbacks into struct
>>>> block_device_operations in gendisk, we also add the new method named
>>>> ->iopoll in block_device_operations.
>>>
>>> Please update patch subject and header to:
>>>
>>> block: add iopoll method to support bio-based IO polling
>>>
>>> ->poll_fn was introduced in commit ea435e1b9392 ("block: add a poll_fn
>>> callback to struct request_queue") to support bio-based queues such as
>>> nvme multipath, but was later removed in commit 529262d56dbe ("block:
>>> remove ->poll_fn").
>>>
>>> Given commit c62b37d96b6e ("block: move ->make_request_fn to struct
>>> block_device_operations") restore the possibility of bio-based IO
>>> polling support by adding an ->iopoll method to gendisk->fops.
>>> Elevate bulk of blk_mq_poll() implementation to blk_poll() and reduce
>>> blk_mq_poll() to blk-mq specific code that is called from blk_poll().
>>>
>>>> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
>>>> ---
>>>>  block/blk-core.c       | 79 ++++++++++++++++++++++++++++++++++++++++++
>>>>  block/blk-mq.c         | 70 +++++--------------------------------
>>>>  include/linux/blk-mq.h |  3 ++
>>>>  include/linux/blkdev.h |  1 +
>>>>  4 files changed, 92 insertions(+), 61 deletions(-)
>>>>
>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>> index 96e5fcd7f071..2f5c51ce32e3 100644
>>>> --- a/block/blk-core.c
>>>> +++ b/block/blk-core.c
>>>> @@ -1131,6 +1131,85 @@ blk_qc_t submit_bio(struct bio *bio)
>>>>  }
>>>>  EXPORT_SYMBOL(submit_bio);
>>>>  
>>>> +static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
>>>> +{
>>>> +	struct blk_mq_hw_ctx *hctx;
>>>> +
>>>> +	/* TODO: bio-based device doesn't support hybrid poll. */
>>>> +	if (!queue_is_mq(q))
>>>> +		return false;
>>>> +
>>>> +	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
>>>> +	if (blk_mq_poll_hybrid(q, hctx, cookie))
>>>> +		return true;
>>>> +
>>>> +	hctx->poll_considered++;
>>>> +	return false;
>>>> +}
>>>
>>> I don't see where you ever backfill bio-based hybrid support (in
>>> the following patches in this series, so it is lingering TODO).
>>
>> Yes the hybrid polling is not implemented and thus bypassed for
>> bio-based device currently.
>>
>>>
>>>> +
>>>> +/**
>>>> + * blk_poll - poll for IO completions
>>>> + * @q:  the queue
>>>> + * @cookie: cookie passed back at IO submission time
>>>> + * @spin: whether to spin for completions
>>>> + *
>>>> + * Description:
>>>> + *    Poll for completions on the passed in queue. Returns number of
>>>> + *    completed entries found. If @spin is true, then blk_poll will continue
>>>> + *    looping until at least one completion is found, unless the task is
>>>> + *    otherwise marked running (or we need to reschedule).
>>>> + */
>>>> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>>>> +{
>>>> +	long state;
>>>> +
>>>> +	if (!blk_qc_t_valid(cookie) ||
>>>> +	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
>>>> +		return 0;
>>>> +
>>>> +	if (current->plug)
>>>> +		blk_flush_plug_list(current->plug, false);
>>>> +
>>>> +	/*
>>>> +	 * If we sleep, have the caller restart the poll loop to reset
>>>> +	 * the state. Like for the other success return cases, the
>>>> +	 * caller is responsible for checking if the IO completed. If
>>>> +	 * the IO isn't complete, we'll get called again and will go
>>>> +	 * straight to the busy poll loop. If specified not to spin,
>>>> +	 * we also should not sleep.
>>>> +	 */
>>>> +	if (spin && blk_poll_hybrid(q, cookie))
>>>> +		return 1;
>>>> +
>>>> +	state = current->state;
>>>> +	do {
>>>> +		int ret;
>>>> +		struct gendisk *disk = queue_to_disk(q);
>>>> +
>>>> +		if (disk->fops->iopoll)
>>>> +			ret = disk->fops->iopoll(q, cookie);
>>>> +		else
>>>> +			ret = blk_mq_poll(q, cookie);
>>
>> The original code is indeed buggy. For bio-based device, ->iopoll() may
>> not be implemented while QUEUE_FLAG_POLL flag is still set, in which
>> case blk_mq_poll() will be called for this bio-based device.
> 
> Yes, here is the patch I created to capture my suggestions.  Provided it
> looks good to you, please fold it into patch 3 when you rebase for
> posting a v2 of your patchset:

Thanks, I will merge it into the next version.


Thanks,
Jeffle

> 
> From: Mike Snitzer <snitzer@redhat.com>
> Date: Thu, 7 Jan 2021 20:45:17 -0500
> Subject: [PATCH] fixup patch 3
> 
> ---
>  block/blk-core.c       | 51 +++++++++++++++++++++-----------------------------
>  block/blk-mq.c         |  6 ++----
>  include/linux/blk-mq.h |  3 ++-
>  3 files changed, 25 insertions(+), 35 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index e6671f6ce1a4..44f62dc0fa9f 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1212,22 +1212,6 @@ int blk_bio_poll(struct request_queue *q, blk_qc_t cookie)
>  }
>  EXPORT_SYMBOL(blk_bio_poll);
>  
> -static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
> -{
> -	struct blk_mq_hw_ctx *hctx;
> -
> -	/* TODO: bio-based device doesn't support hybrid poll. */
> -	if (!queue_is_mq(q))
> -		return false;
> -
> -	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> -	if (blk_mq_poll_hybrid(q, hctx, cookie))
> -		return true;
> -
> -	hctx->poll_considered++;
> -	return false;
> -}
> -
>  /**
>   * blk_poll - poll for IO completions
>   * @q:  the queue
> @@ -1243,6 +1227,8 @@ static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
>  int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>  {
>  	long state;
> +	struct blk_mq_hw_ctx *hctx = NULL;
> +	struct gendisk *disk = NULL;
>  
>  	if (!blk_qc_t_valid(cookie) ||
>  	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> @@ -1251,26 +1237,31 @@ int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>  	if (current->plug)
>  		blk_flush_plug_list(current->plug, false);
>  
> -	/*
> -	 * If we sleep, have the caller restart the poll loop to reset
> -	 * the state. Like for the other success return cases, the
> -	 * caller is responsible for checking if the IO completed. If
> -	 * the IO isn't complete, we'll get called again and will go
> -	 * straight to the busy poll loop. If specified not to spin,
> -	 * we also should not sleep.
> -	 */
> -	if (spin && blk_poll_hybrid(q, cookie))
> -		return 1;
> +	if (queue_is_mq(q)) {
> +		/*
> +		 * If we sleep, have the caller restart the poll loop to reset
> +		 * the state. Like for the other success return cases, the
> +		 * caller is responsible for checking if the IO completed. If
> +		 * the IO isn't complete, we'll get called again and will go
> +		 * straight to the busy poll loop. If specified not to spin,
> +		 * we also should not sleep.
> +		 */
> +		hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> +		if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
> +			return 1;
> +		hctx->poll_considered++;
> +	} else
> +		disk = queue_to_disk(q);
>  
>  	state = current->state;
>  	do {
>  		int ret;
> -		struct gendisk *disk = queue_to_disk(q);
>  
> -		if (disk->fops->iopoll)
> +		if (hctx)
> +			ret = blk_mq_poll(q, hctx, cookie);
> +		else if (disk->fops->iopoll)
>  			ret = disk->fops->iopoll(q, cookie);
> -		else
> -			ret = blk_mq_poll(q, cookie);
> +
>  		if (ret > 0) {
>  			__set_current_state(TASK_RUNNING);
>  			return ret;
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index fcb44604f806..90d8dead1da5 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3826,12 +3826,10 @@ bool blk_mq_poll_hybrid(struct request_queue *q,
>  	return blk_mq_poll_hybrid_sleep(q, rq);
>  }
>  
> -int blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
> +int blk_mq_poll(struct request_queue *q,
> +		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
>  {
>  	int ret;
> -	struct blk_mq_hw_ctx *hctx;
> -
> -	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
>  
>  	hctx->poll_invoked++;
>  	ret = q->mq_ops->poll(hctx);
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 2f3742207df5..b95f2ffa866f 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -607,7 +607,8 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
>  }
>  
>  blk_qc_t blk_mq_submit_bio(struct bio *bio);
> -int blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
> +int blk_mq_poll(struct request_queue *q,
> +		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
>  bool blk_mq_poll_hybrid(struct request_queue *q,
>  		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
>  void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
> 

-- 
Thanks,
Jeffle
