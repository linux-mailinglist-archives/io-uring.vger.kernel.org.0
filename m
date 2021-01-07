Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A322EE7E0
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 22:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbhAGVte (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 16:49:34 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37034 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727738AbhAGVtd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 16:49:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610056086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kHJGSqE1FbYYMsmd52JX53xuTUKbMA6cjuTztSqhmJ0=;
        b=D02cvBGsavqtTEqsinZLQqy7gXwGbFUBtRli91MTyTPutsJ3pAO1eyujrM3O64Km6Xqgsh
        H+KpSVEBSbSL8L37tEds/DgzFbPcaaSE8Uf3IM9KxGhzPcRVUNX03KWmhkDoqt64fxRUc4
        BIIo0VeLx89l8QiUSNGIJhVZ8WzY1bs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-8pm-d7bNNUWgHfvSyaGYgA-1; Thu, 07 Jan 2021 16:48:04 -0500
X-MC-Unique: 8pm-d7bNNUWgHfvSyaGYgA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 05596190A7A0;
        Thu,  7 Jan 2021 21:48:03 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8635219809;
        Thu,  7 Jan 2021 21:47:59 +0000 (UTC)
Date:   Thu, 7 Jan 2021 16:47:58 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 3/7] block: add iopoll method for non-mq device
Message-ID: <20210107214758.GC21239@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-4-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223112624.78955-4-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23 2020 at  6:26am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> ->poll_fn is introduced in commit ea435e1b9392 ("block: add a poll_fn
> callback to struct request_queue") for supporting non-mq queues such as
> nvme multipath, but removed in commit 529262d56dbe ("block: remove
> ->poll_fn").
> 
> To add support of IO polling for non-mq device, this method need to be
> back. Since commit c62b37d96b6e ("block: move ->make_request_fn to
> struct block_device_operations") has moved all callbacks into struct
> block_device_operations in gendisk, we also add the new method named
> ->iopoll in block_device_operations.

Please update patch subject and header to:

block: add iopoll method to support bio-based IO polling

->poll_fn was introduced in commit ea435e1b9392 ("block: add a poll_fn
callback to struct request_queue") to support bio-based queues such as
nvme multipath, but was later removed in commit 529262d56dbe ("block:
remove ->poll_fn").

Given commit c62b37d96b6e ("block: move ->make_request_fn to struct
block_device_operations") restore the possibility of bio-based IO
polling support by adding an ->iopoll method to gendisk->fops.
Elevate bulk of blk_mq_poll() implementation to blk_poll() and reduce
blk_mq_poll() to blk-mq specific code that is called from blk_poll().

> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  block/blk-core.c       | 79 ++++++++++++++++++++++++++++++++++++++++++
>  block/blk-mq.c         | 70 +++++--------------------------------
>  include/linux/blk-mq.h |  3 ++
>  include/linux/blkdev.h |  1 +
>  4 files changed, 92 insertions(+), 61 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 96e5fcd7f071..2f5c51ce32e3 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -1131,6 +1131,85 @@ blk_qc_t submit_bio(struct bio *bio)
>  }
>  EXPORT_SYMBOL(submit_bio);
>  
> +static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
> +{
> +	struct blk_mq_hw_ctx *hctx;
> +
> +	/* TODO: bio-based device doesn't support hybrid poll. */
> +	if (!queue_is_mq(q))
> +		return false;
> +
> +	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
> +	if (blk_mq_poll_hybrid(q, hctx, cookie))
> +		return true;
> +
> +	hctx->poll_considered++;
> +	return false;
> +}

I don't see where you ever backfill bio-based hybrid support (in
the following patches in this series, so it is lingering TODO).

> +
> +/**
> + * blk_poll - poll for IO completions
> + * @q:  the queue
> + * @cookie: cookie passed back at IO submission time
> + * @spin: whether to spin for completions
> + *
> + * Description:
> + *    Poll for completions on the passed in queue. Returns number of
> + *    completed entries found. If @spin is true, then blk_poll will continue
> + *    looping until at least one completion is found, unless the task is
> + *    otherwise marked running (or we need to reschedule).
> + */
> +int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> +{
> +	long state;
> +
> +	if (!blk_qc_t_valid(cookie) ||
> +	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> +		return 0;
> +
> +	if (current->plug)
> +		blk_flush_plug_list(current->plug, false);
> +
> +	/*
> +	 * If we sleep, have the caller restart the poll loop to reset
> +	 * the state. Like for the other success return cases, the
> +	 * caller is responsible for checking if the IO completed. If
> +	 * the IO isn't complete, we'll get called again and will go
> +	 * straight to the busy poll loop. If specified not to spin,
> +	 * we also should not sleep.
> +	 */
> +	if (spin && blk_poll_hybrid(q, cookie))
> +		return 1;
> +
> +	state = current->state;
> +	do {
> +		int ret;
> +		struct gendisk *disk = queue_to_disk(q);
> +
> +		if (disk->fops->iopoll)
> +			ret = disk->fops->iopoll(q, cookie);
> +		else
> +			ret = blk_mq_poll(q, cookie);

Really don't like that blk-mq is needlessly getting gendisk and checking
disk->fops->iopoll.

This is just to give an idea, whitespace damaged due to coding in mail
client, but why not remove above blk_poll_hybrid() and do:

struct blk_mq_hw_ctx *hctx = NULL;
struct gendisk *disk = NULL;
...

if (queue_is_mq(q)) {
	/*
	 * If we sleep, have the caller restart the poll loop to reset
	 * the state. Like for the other success return cases, the
	 * caller is responsible for checking if the IO completed. If
	 * the IO isn't complete, we'll get called again and will go
	 * straight to the busy poll loop. If specified not to spin,
	 * we also should not sleep.
	 */
	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
	if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
		return 1;
	hctx->poll_considered++;   
} else {
	disk = queue_to_disk(q);
}

do {
	int ret;

	if (hctx)
	        ret = blk_mq_poll(q, hctx, cookie);
	else if (disk->fops->iopoll)
		ret = disk->fops->iopoll(q, cookie);
		
> +		if (ret > 0) {
> +			__set_current_state(TASK_RUNNING);
> +			return ret;
> +		}
> +
> +		if (signal_pending_state(state, current))
> +			__set_current_state(TASK_RUNNING);
> +
> +		if (current->state == TASK_RUNNING)
> +			return 1;
> +		if (ret < 0 || !spin)
> +			break;
> +		cpu_relax();
> +	} while (!need_resched());
> +
> +	__set_current_state(TASK_RUNNING);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(blk_poll);
> +
>  /**
>   * blk_cloned_rq_check_limits - Helper function to check a cloned request
>   *                              for the new queue limits
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b09ce00cc6af..85258958e9f1 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3818,8 +3818,8 @@ static bool blk_mq_poll_hybrid_sleep(struct request_queue *q,
>  	return true;
>  }
>  
> -static bool blk_mq_poll_hybrid(struct request_queue *q,
> -			       struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
> +bool blk_mq_poll_hybrid(struct request_queue *q,
> +			struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
>  {
>  	struct request *rq;
>  
> @@ -3843,72 +3843,20 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
>  	return blk_mq_poll_hybrid_sleep(q, rq);
>  }
>  
> -/**
> - * blk_poll - poll for IO completions
> - * @q:  the queue
> - * @cookie: cookie passed back at IO submission time
> - * @spin: whether to spin for completions
> - *
> - * Description:
> - *    Poll for completions on the passed in queue. Returns number of
> - *    completed entries found. If @spin is true, then blk_poll will continue
> - *    looping until at least one completion is found, unless the task is
> - *    otherwise marked running (or we need to reschedule).
> - */
> -int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
> +int blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
>  {
> +	int ret;
>  	struct blk_mq_hw_ctx *hctx;
> -	long state;
> -
> -	if (!blk_qc_t_valid(cookie) ||
> -	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> -		return 0;
> -
> -	if (current->plug)
> -		blk_flush_plug_list(current->plug, false);
>  
>  	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];


Given my suggested code changes above, pass hctx in to blk_mq_poll() to
avoid redundant code to access it in q->queue_hw_ctx[], so:

int blk_mq_poll(struct request_queue *q,
    		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)

> -	/*
> -	 * If we sleep, have the caller restart the poll loop to reset
> -	 * the state. Like for the other success return cases, the
> -	 * caller is responsible for checking if the IO completed. If
> -	 * the IO isn't complete, we'll get called again and will go
> -	 * straight to the busy poll loop. If specified not to spin,
> -	 * we also should not sleep.
> -	 */
> -	if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
> -		return 1;
> -
> -	hctx->poll_considered++;
> +	hctx->poll_invoked++;
> +	ret = q->mq_ops->poll(hctx);
> +	if (ret > 0)
> +		hctx->poll_success++;
>  
> -	state = current->state;
> -	do {
> -		int ret;
> -
> -		hctx->poll_invoked++;
> -
> -		ret = q->mq_ops->poll(hctx);
> -		if (ret > 0) {
> -			hctx->poll_success++;
> -			__set_current_state(TASK_RUNNING);
> -			return ret;
> -		}
> -
> -		if (signal_pending_state(state, current))
> -			__set_current_state(TASK_RUNNING);
> -
> -		if (current->state == TASK_RUNNING)
> -			return 1;
> -		if (ret < 0 || !spin)
> -			break;
> -		cpu_relax();
> -	} while (!need_resched());
> -
> -	__set_current_state(TASK_RUNNING);
> -	return 0;
> +	return ret;
>  }
> -EXPORT_SYMBOL_GPL(blk_poll);
>  
>  unsigned int blk_mq_rq_cpu(struct request *rq)
>  {
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index 47b021952ac7..032e08ecd42e 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -607,6 +607,9 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
>  }
>  
>  blk_qc_t blk_mq_submit_bio(struct bio *bio);
> +int blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
> +bool blk_mq_poll_hybrid(struct request_queue *q,
> +		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
>  void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
>  		struct lock_class_key *key);
>  
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 2303d06a5a82..e8965879eb90 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1845,6 +1845,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
>  
>  struct block_device_operations {
>  	blk_qc_t (*submit_bio) (struct bio *bio);
> +	int (*iopoll)(struct request_queue *q, blk_qc_t cookie);
>  	int (*open) (struct block_device *, fmode_t);
>  	void (*release) (struct gendisk *, fmode_t);
>  	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
> -- 
> 2.27.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

