Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF5B2EE847
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 23:20:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbhAGWUB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jan 2021 17:20:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44686 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726720AbhAGWUB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jan 2021 17:20:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610057913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T2ooHRJ7strp274aIY3xth7LbN3f9tIb9RMjgg0uXdU=;
        b=CmKHAsd757QSAMpFQ1LqIO/uvsdjw0WcneJ2iN2rNgu6oCo8LNYcnEd3h3YDuyKlRgC40R
        9DZVWx02476y+cWuJpOkVW37usXkUyMsLhKWh7/u59TtxY3LbjDsVT/ZMH+2HFqzJY96Rb
        m9g7+LqWGm3TmU1lLyA4g0PhskpiwpI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-HfcM4XcxOHWBhkVEKfH_Jg-1; Thu, 07 Jan 2021 17:18:31 -0500
X-MC-Unique: HfcM4XcxOHWBhkVEKfH_Jg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D8028143EB;
        Thu,  7 Jan 2021 22:18:30 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4006D1001B2C;
        Thu,  7 Jan 2021 22:18:25 +0000 (UTC)
Date:   Thu, 7 Jan 2021 17:18:25 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [PATCH RFC 6/7] block: track cookies of split bios for bio-based
 device
Message-ID: <20210107221825.GF21239@redhat.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
 <20201223112624.78955-7-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223112624.78955-7-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Dec 23 2020 at  6:26am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> This is actuaaly the core when supporting iopoll for bio-based device.
> 
> A list is maintained in the top bio (the original bio submitted to dm
> device), which is used to maintain all valid cookies of split bios. The
> IO polling routine will actually iterate this list and poll on
> corresponding hardware queues of the underlying mq devices.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Like I said in response to patch 4 in this series: please fold patch 4
into this patch and _really_ improve this patch header.

In particular, the (ab)use of bio_inc_remaining() needs be documented in
this patch header very well.

But its use could easily be why you're seeing a performance hit (coupled
with the extra spinlock locking and list management used).  Just added
latency and contention across CPUs.

> ---
>  block/bio.c               |  8 ++++
>  block/blk-core.c          | 84 ++++++++++++++++++++++++++++++++++++++-
>  include/linux/blk_types.h | 39 ++++++++++++++++++
>  3 files changed, 129 insertions(+), 2 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 1f2cc1fbe283..ca6d1a7ee196 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -284,6 +284,10 @@ void bio_init(struct bio *bio, struct bio_vec *table,
>  
>  	bio->bi_io_vec = table;
>  	bio->bi_max_vecs = max_vecs;
> +
> +	INIT_LIST_HEAD(&bio->bi_plist);
> +	INIT_LIST_HEAD(&bio->bi_pnode);
> +	spin_lock_init(&bio->bi_plock);
>  }
>  EXPORT_SYMBOL(bio_init);
>  
> @@ -689,6 +693,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
>  	bio->bi_write_hint = bio_src->bi_write_hint;
>  	bio->bi_iter = bio_src->bi_iter;
>  	bio->bi_io_vec = bio_src->bi_io_vec;
> +	bio->bi_root = bio_src->bi_root;
>  
>  	bio_clone_blkg_association(bio, bio_src);
>  	blkcg_bio_issue_init(bio);
> @@ -1425,6 +1430,8 @@ void bio_endio(struct bio *bio)
>  	if (bio->bi_disk)
>  		rq_qos_done_bio(bio->bi_disk->queue, bio);
>  
> +	bio_del_poll_list(bio);
> +
>  	/*
>  	 * Need to have a real endio function for chained bios, otherwise
>  	 * various corner cases will break (like stacking block devices that
> @@ -1446,6 +1453,7 @@ void bio_endio(struct bio *bio)
>  	blk_throtl_bio_endio(bio);
>  	/* release cgroup info */
>  	bio_uninit(bio);
> +
>  	if (bio->bi_end_io)
>  		bio->bi_end_io(bio);
>  }
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 2f5c51ce32e3..5a332af01939 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -960,12 +960,31 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  {
>  	struct bio_list bio_list_on_stack[2];
>  	blk_qc_t ret = BLK_QC_T_NONE;
> +	bool iopoll;
> +	struct bio *root;
>  
>  	BUG_ON(bio->bi_next);
>  
>  	bio_list_init(&bio_list_on_stack[0]);
>  	current->bio_list = bio_list_on_stack;
>  
> +	iopoll = test_bit(QUEUE_FLAG_POLL, &bio->bi_disk->queue->queue_flags);
> +	iopoll = iopoll && (bio->bi_opf & REQ_HIPRI);
> +
> +	if (iopoll) {
> +		bio->bi_root = root = bio;
> +		/*
> +		 * We need to pin root bio here since there's a reference from
> +		 * the returned cookie. bio_get() is not enough since the whole
> +		 * bio and the corresponding kiocb/dio may have already
> +		 * completed and thus won't call blk_poll() at all, in which
> +		 * case the pairing bio_put() in blk_bio_poll() won't be called.
> +		 * The side effect of bio_inc_remaining() is that, the whole bio
> +		 * won't complete until blk_poll() called.
> +		 */
> +		bio_inc_remaining(root);
> +	}
> +
>  	do {
>  		struct request_queue *q = bio->bi_disk->queue;
>  		struct bio_list lower, same;
> @@ -979,7 +998,18 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>  		bio_list_init(&bio_list_on_stack[0]);
>  
> -		ret = __submit_bio(bio);
> +		if (iopoll) {
> +			/* See the comments of above bio_inc_remaining(). */
> +			bio_inc_remaining(bio);
> +			bio->bi_cookie = __submit_bio(bio);
> +
> +			if (blk_qc_t_valid(bio->bi_cookie))
> +				bio_add_poll_list(bio);
> +
> +			bio_endio(bio);
> +		} else {
> +			ret = __submit_bio(bio);
> +		}
>  
>  		/*
>  		 * Sort new bios into those for a lower level and those for the
> @@ -1002,7 +1032,11 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
>  
>  	current->bio_list = NULL;
> -	return ret;
> +
> +	if (iopoll)
> +		return (blk_qc_t)root;
> +
> +	return BLK_QC_T_NONE;
>  }
>  
>  static blk_qc_t __submit_bio_noacct_mq(struct bio *bio)
> @@ -1131,6 +1165,52 @@ blk_qc_t submit_bio(struct bio *bio)
>  }
>  EXPORT_SYMBOL(submit_bio);
>  
> +int blk_bio_poll(struct request_queue *q, blk_qc_t cookie)
> +{
> +	int ret = 0;
> +	struct bio *bio, *root = (struct bio*)cookie;
> +
> +	if (list_empty(&root->bi_plist)) {
> +		bio_endio(root);
> +		return 1;
> +	}
> +
> +	spin_lock(&root->bi_plock);
> +	bio = list_first_entry_or_null(&root->bi_plist, struct bio, bi_pnode);
> +
> +	while (bio) {
> +		struct request_queue *q = bio->bi_disk->queue;
> +		blk_qc_t cookie = bio->bi_cookie;
> +
> +		spin_unlock(&root->bi_plock);
> +		BUG_ON(!blk_qc_t_valid(cookie));
> +
> +		ret += blk_mq_poll(q, cookie);

Not yet clear to me how you _know_ this q is blk-mq...
What about a deep stack of bio-based DM devices?

Or are you confining bio-based DM IO polling support to bio-based
stacked directly on blk-mq? (patch 7 likely shows that to be the case).

If so, I'm not liking that at all.  So if your implementation doesn't
support arbitrary bio-based IO stacks then this bio-based IO polling
support really has limited utility still.

Helps explin how you got away with having bio-based DM always returning
BLK_QC_T_NONE in patch 5 though... feels far too simplistic.  Patch 5+6
together are implicitly ignoring the complexity that results from
arbitrary bio-based DM stacking.

Or am I missing something?

Mike


> +
> +		spin_lock(&root->bi_plock);
> +		/*
> +		 * One blk_mq_poll() call could complete multiple bios, and
> +		 * thus multiple bios could be removed from root->bi_plock
> +		 * list.
> +		 */
> +		bio = list_first_entry_or_null(&root->bi_plist, struct bio, bi_pnode);
> +	}
> +
> +	spin_unlock(&root->bi_plock);
> +
> +	if (list_empty(&root->bi_plist)) {
> +		bio_endio(root);
> +		/*
> +		 * 'ret' may be 0 here. root->bi_plist may be empty once we
> +		 * acquire the list spinlock.
> +		 */
> +		ret = max(ret, 1);
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(blk_bio_poll);
> +
>  static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
>  {
>  	struct blk_mq_hw_ctx *hctx;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 2e05244fc16d..2cf5d8f0ea34 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -277,6 +277,12 @@ struct bio {
>  
>  	struct bio_set		*bi_pool;
>  
> +	struct bio		*bi_root;	/* original bio of submit_bio() */
> +	struct list_head        bi_plist;
> +	struct list_head        bi_pnode;
> +	struct spinlock         bi_plock;
> +	blk_qc_t		bi_cookie;
> +
>  	/*
>  	 * We can inline a number of vecs at the end of the bio, to avoid
>  	 * double allocations for a small number of bio_vecs. This member
> @@ -557,6 +563,39 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
>  	return (cookie & BLK_QC_T_INTERNAL) != 0;
>  }
>  
> +static inline void bio_add_poll_list(struct bio *bio)
> +{
> +	struct bio *root = bio->bi_root;
> +
> +	/*
> +	 * The spin_lock() variant is enough since bios in root->bi_plist are
> +	 * all enqueued into polling mode hardware queue, thus the list_del()
> +	 * operation is handled only in process context.
> +	 */
> +	spin_lock(&root->bi_plock);
> +	list_add_tail(&bio->bi_pnode, &root->bi_plist);
> +	spin_unlock(&root->bi_plock);
> +}
> +
> +static inline void bio_del_poll_list(struct bio *bio)
> +{
> +	struct bio *root = bio->bi_root;
> +
> +	/*
> +	 * bios in mq routine: @bi_root is NULL, @bi_cookie is 0;
> +	 * bios in bio-based routine: @bi_root is non-NULL, @bi_cookie is valid
> +	 * (including 0) for those in root->bi_plist, invalid for the
> +	 * remaining.
> +	 */
> +	if (bio->bi_root && blk_qc_t_valid(bio->bi_cookie)) {
> +		spin_lock(&root->bi_plock);
> +		list_del(&bio->bi_pnode);
> +		spin_unlock(&root->bi_plock);
> +	}
> +}
> +
> +int blk_bio_poll(struct request_queue *q, blk_qc_t cookie);
> +
>  struct blk_rq_stat {
>  	u64 mean;
>  	u64 min;
> -- 
> 2.27.0
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel

