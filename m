Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34646334C5C
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 00:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhCJXSg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 18:18:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40949 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232933AbhCJXSR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 18:18:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615418296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uQa2y2z0XvsRj129MhvdBh9Jiis+7gxwF1yLINcwOYQ=;
        b=NZiwRkl5Mv55AnsUi59fZlHEHSFJmEiWlLGFFaKHoKIlKudhXz4WakGlOAR2hQTJ5pI8Fd
        /jn6FD99GA7svzsYk5DNvwHOmVeK1CZeSO1wU4HLgxplPs3gnKSlqc/eL4pO+jYpJleLAI
        Y34nRoppZ/MgT5ukDJxswWIgt4IbXZY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-E5v-o-OuOiaI18dHgGKnWQ-1; Wed, 10 Mar 2021 18:18:14 -0500
X-MC-Unique: E5v-o-OuOiaI18dHgGKnWQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C872A1005D4C;
        Wed, 10 Mar 2021 23:18:12 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3CDE05D6D7;
        Wed, 10 Mar 2021 23:18:08 +0000 (UTC)
Date:   Wed, 10 Mar 2021 18:18:08 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, mpatocka@redhat.com,
        caspar@linux.alibaba.com, joseph.qi@linux.alibaba.com
Subject: Re: [PATCH v5 10/12] block: fastpath for bio-based polling
Message-ID: <20210310231808.GD23410@redhat.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
 <20210303115740.127001-11-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303115740.127001-11-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 03 2021 at  6:57am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> Offer one fastpath for bio-based polling when bio submitted to dm
> device is not split.
> 
> In this case, there will be only one bio submitted to only one polling
> hw queue of one underlying mq device, and thus we don't need to track
> all split bios or iterate through all polling hw queues. The pointer to
> the polling hw queue the bio submitted to is returned here as the
> returned cookie. In this case, the polling routine will call
> mq_ops->poll() directly with the hw queue converted from the input
> cookie.
> 
> If the original bio submitted to dm device is split to multiple bios and
> thus submitted to multiple polling hw queues, the polling routine will
> fall back to iterating all hw queues (in polling mode) of all underlying
> mq devices.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
> ---
>  block/blk-core.c          | 73 +++++++++++++++++++++++++++++++++++++--
>  include/linux/blk_types.h | 66 +++++++++++++++++++++++++++++++++--
>  include/linux/types.h     |  2 +-
>  3 files changed, 135 insertions(+), 6 deletions(-)
> 
> diff --git a/block/blk-core.c b/block/blk-core.c
> index 6d7d53030d7c..e5cd4ff08f5c 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -947,14 +947,22 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  {
>  	struct bio_list bio_list_on_stack[2];
>  	blk_qc_t ret = BLK_QC_T_NONE;
> +	struct request_queue *top_q;
> +	bool poll_on;
>  
>  	BUG_ON(bio->bi_next);
>  
>  	bio_list_init(&bio_list_on_stack[0]);
>  	current->bio_list = bio_list_on_stack;
>  
> +	top_q = bio->bi_bdev->bd_disk->queue;
> +	poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags) &&
> +		  (bio->bi_opf & REQ_HIPRI);
> +
>  	do {
> -		struct request_queue *q = bio->bi_bdev->bd_disk->queue;
> +		blk_qc_t cookie;
> +		struct block_device *bdev = bio->bi_bdev;
> +		struct request_queue *q = bdev->bd_disk->queue;
>  		struct bio_list lower, same;
>  
>  		if (unlikely(bio_queue_enter(bio) != 0))
> @@ -966,7 +974,23 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  		bio_list_on_stack[1] = bio_list_on_stack[0];
>  		bio_list_init(&bio_list_on_stack[0]);
>  
> -		ret = __submit_bio(bio);
> +		cookie = __submit_bio(bio);
> +
> +		if (poll_on && blk_qc_t_valid(cookie)) {
> +			unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
> +			unsigned int devt = bdev_whole(bdev)->bd_dev;
> +
> +			cookie = blk_qc_t_get_by_devt(devt, queue_num);

The need to rebuild the cookie here is pretty awkward.  This
optimization living in block core may be worthwhile but the duality of
block core conditionally overriding the driver's returned cookie (that
is meant to be opaque to upper layer) is not great.

> +
> +			if (!blk_qc_t_valid(ret)) {
> +				/* set initial value */
> +				ret = cookie;
> +			} else if (ret != cookie) {
> +				/* bio gets split and enqueued to multi hctxs */
> +				ret = BLK_QC_T_BIO_POLL_ALL;
> +				poll_on = false;
> +			}
> +		}
>  
>  		/*
>  		 * Sort new bios into those for a lower level and those for the
> @@ -989,6 +1013,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
>  	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
>  
>  	current->bio_list = NULL;
> +
>  	return ret;
>  }

Nit: Not seeing need to alter white space here.

>  
> @@ -1119,6 +1144,44 @@ blk_qc_t submit_bio(struct bio *bio)
>  }
>  EXPORT_SYMBOL(submit_bio);
>  
> +static int blk_poll_bio(blk_qc_t cookie)
> +{
> +	unsigned int devt = blk_qc_t_to_devt(cookie);
> +	unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
> +	struct block_device *bdev;
> +	struct request_queue *q;
> +	struct blk_mq_hw_ctx *hctx;
> +	int ret;
> +
> +	bdev = blkdev_get_no_open(devt);

As you pointed out to me in private, but for the benefit of others,
blkdev_get_no_open()'s need to take inode lock is not ideal here.

> +
> +	/*
> +	 * One such case is that dm device has reloaded table and the original
> +	 * underlying device the bio submitted to has been detached. When
> +	 * reloading table, dm will ensure that previously submitted IOs have
> +	 * all completed, thus return directly here.
> +	 */
> +	if (!bdev)
> +		return 1;
> +
> +	q = bdev->bd_disk->queue;
> +	hctx = q->queue_hw_ctx[queue_num];
> +
> +	/*
> +	 * Similar to the case described in the above comment, that dm device
> +	 * has reloaded table and the original underlying device the bio
> +	 * submitted to has been detached. Thus the dev_t stored in cookie may
> +	 * be reused by another blkdev, and if that's the case, return directly
> +	 * here.
> +	 */
> +	if (hctx->type != HCTX_TYPE_POLL)
> +		return 1;

These checks really aren't authoritative or safe enough.  If the bdev
may have changed then it may not have queue_num hctxs (so you'd access
out-of-bounds). Similarly, a new bdev may have queue_num hctxs and may
just so happen to have its type be HCTX_TYPE_POLL.. but in reality it
isn't the same bdev the cookie was generated from.

And I'm now curious how blk-mq's polling code isn't subject to async io
polling tripping over the possibility of the underlying device having
been changed out from under it -- meaning should this extra validation
be common to bio and request-based?  If not, why not?

> +
> +	ret = blk_mq_poll_hctx(q, hctx);
> +
> +	blkdev_put_no_open(bdev);
> +	return ret;
> +}
>  
>  static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>  {
> @@ -1129,7 +1192,11 @@ static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
>  	do {
>  		int ret;
>  
> -		ret = disk->fops->poll(q, cookie);
> +		if (unlikely(blk_qc_t_is_poll_multi(cookie)))
> +			ret = disk->fops->poll(q, cookie);
> +		else
> +			ret = blk_poll_bio(cookie);
> +

Again, this just seems too limiting. Would rather always call into
disk->fops->poll and have it optimize for single hctx based on cookie it
established.

Not seeing why all this needs to be driven by block core _yet_.
Could be I'm just wanting some flexibility for the design to harden (and
potential for optimization left as a driver concern.. as I mentioned in
my reply to the 0th patch header for this v5 patchset).

>  		if (ret > 0) {
>  			__set_current_state(TASK_RUNNING);
>  			return ret;
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index fb429daaa909..8f970e026be9 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -505,10 +505,19 @@ static inline int op_stat_group(unsigned int op)
>  	return op_is_write(op);
>  }
>  
> -/* Macros for blk_qc_t */
> +/*
> + * blk_qc_t for request-based mq devices.
> + * 63                    31 30          15          0 (bit)
> + * +----------------------+-+-----------+-----------+
> + * |      reserved        | | queue_num |    tag    |
> + * +----------------------+-+-----------+-----------+
> + *                         ^
> + *                         BLK_QC_T_INTERNAL
> + */
>  #define BLK_QC_T_NONE		-1U
>  #define BLK_QC_T_SHIFT		16
>  #define BLK_QC_T_INTERNAL	(1U << 31)
> +#define BLK_QC_T_QUEUE_NUM_SIZE	15
>  
>  static inline bool blk_qc_t_valid(blk_qc_t cookie)
>  {
> @@ -517,7 +526,8 @@ static inline bool blk_qc_t_valid(blk_qc_t cookie)
>  
>  static inline unsigned int blk_qc_t_to_queue_num(blk_qc_t cookie)
>  {
> -	return (cookie & ~BLK_QC_T_INTERNAL) >> BLK_QC_T_SHIFT;
> +	return (cookie >> BLK_QC_T_SHIFT) &
> +	       ((1u << BLK_QC_T_QUEUE_NUM_SIZE) - 1);
>  }
>  
>  static inline unsigned int blk_qc_t_to_tag(blk_qc_t cookie)
> @@ -530,6 +540,58 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
>  	return (cookie & BLK_QC_T_INTERNAL) != 0;
>  }
>  
> +/*
> + * blk_qc_t for bio-based devices.
> + *
> + * 1. When @bio is not split, the returned cookie has following format.
> + *    @dev_t specifies the dev_t number of the underlying device the bio
> + *    submitted to, while @queue_num specifies the hw queue the bio submitted
> + *    to.
> + *
> + * 63                    31 30          15          0 (bit)
> + * +----------------------+-+-----------+-----------+
> + * |        dev_t         | | queue_num |  reserved |
> + * +----------------------+-+-----------+-----------+
> + *                         ^
> + *                         reserved for compatibility with mq
> + *
> + * 2. When @bio gets split and enqueued into multi hw queues, the returned
> + *    cookie is just BLK_QC_T_BIO_POLL_ALL flag.
> + *
> + * 63                                              0 (bit)
> + * +----------------------------------------------+-+
> + * |                                              |1|
> + * +----------------------------------------------+-+
> + *                                                 ^
> + *                                                 BLK_QC_T_BIO_POLL_ALL
> + *
> + * 3. Otherwise, return BLK_QC_T_NONE as the cookie.
> + *
> + * 63                                              0 (bit)
> + * +-----------------------------------------------+
> + * |                  BLK_QC_T_NONE                |
> + * +-----------------------------------------------+
> + */
> +#define BLK_QC_T_HIGH_SHIFT	32
> +#define BLK_QC_T_BIO_POLL_ALL	1U

Pulling on same thread I raised above, the cookie is meant to be
opaque.  Pinning down how the cookie is (ab)used in block core seems to
undermine the intended flexibility.

I'd much rather these details be pushed into drivers/md/bio-poll.h or
something for the near-term.  We can always elevate it to block core
if/when there is sufficient justification.

Just feels we're getting too constraining too quickly.

Mike


> +
> +static inline unsigned int blk_qc_t_to_devt(blk_qc_t cookie)
> +{
> +	return cookie >> BLK_QC_T_HIGH_SHIFT;
> +}
> +
> +static inline blk_qc_t blk_qc_t_get_by_devt(unsigned int dev,
> +					    unsigned int queue_num)
> +{
> +	return ((blk_qc_t)dev << BLK_QC_T_HIGH_SHIFT) |
> +	       (queue_num << BLK_QC_T_SHIFT);
> +}
> +
> +static inline bool blk_qc_t_is_poll_multi(blk_qc_t cookie)
> +{
> +	return cookie & BLK_QC_T_BIO_POLL_ALL;
> +}
> +
>  struct blk_rq_stat {
>  	u64 mean;
>  	u64 min;
> diff --git a/include/linux/types.h b/include/linux/types.h
> index 52a54ed6ffac..7ff4bb96e0ea 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -126,7 +126,7 @@ typedef u64 sector_t;
>  typedef u64 blkcnt_t;
>  
>  /* cookie used for IO polling */
> -typedef unsigned int blk_qc_t;
> +typedef u64 blk_qc_t;
>  
>  /*
>   * The type of an index into the pagecache.
> -- 
> 2.27.0
> 

