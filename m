Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C244334B79
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231998AbhCJWV7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:21:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60300 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231207AbhCJWVl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:21:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615414900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a8wkRiZtvWwWyRoboFXy6dQYlpoVRAGRhwfWOwJIINo=;
        b=h8vpl/7Zp1KI/i43/FG6of6mthjQtgF67TiV2nt4VVIB+fy1Z7tv1tpybq2pZnGDbDDeqy
        35SHIz3V7F6jZCyapJedsxLRphOXy68Z8pFa0haSzL36ueDWO6hUMz3t0hInPZ9yWwPa3W
        aCGa5uWGoXelekbrd7jCwth5x5Zz8d4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-9VaqlFKJNUixtqY-Sofotg-1; Wed, 10 Mar 2021 17:21:36 -0500
X-MC-Unique: 9VaqlFKJNUixtqY-Sofotg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3783780432F;
        Wed, 10 Mar 2021 22:21:35 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 39ED05D6D7;
        Wed, 10 Mar 2021 22:21:30 +0000 (UTC)
Date:   Wed, 10 Mar 2021 17:21:30 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     axboe@kernel.dk, io-uring@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, mpatocka@redhat.com,
        caspar@linux.alibaba.com, joseph.qi@linux.alibaba.com
Subject: Re: [PATCH v5 04/12] block: add poll_capable method to support
 bio-based IO polling
Message-ID: <20210310222130.GC23410@redhat.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
 <20210303115740.127001-5-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303115740.127001-5-jefflexu@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 03 2021 at  6:57am -0500,
Jeffle Xu <jefflexu@linux.alibaba.com> wrote:

> This method can be used to check if bio-based device supports IO polling
> or not. For mq devices, checking for hw queue in polling mode is
> adequate, while the sanity check shall be implementation specific for
> bio-based devices. For example, dm device needs to check if all
> underlying devices are capable of IO polling.
> 
> Though bio-based device may have done the sanity check during the
> device initialization phase, cacheing the result of this sanity check
> (such as by cacheing in the queue_flags) may not work. Because for dm

s/cacheing/caching/

> devices, users could change the state of the underlying devices through
> '/sys/block/<dev>/io_poll', bypassing the dm device above. In this case,
> the cached result of the very beginning sanity check could be
> out-of-date. Thus the sanity check needs to be done every time 'io_poll'
> is to be modified.
> 
> Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>

Ideally QUEUE_FLAG_POLL would be authoritative.. but I appreciate the
problem you've described.  Though I do wonder if this should be solved
by bio-based's fops->poll() method clearing the request_queue's
QUEUE_FLAG_POLL if it finds an underlying device doesn't have
QUEUE_FLAG_POLL set.  Though making bio-based's fops->poll() always need
to validate the an underlying device does support polling is pretty
unfortunate.

Either way, queue_poll_store() will need to avoid blk-mq specific poll
checking for bio-based devices.

Mike

> ---
>  block/blk-sysfs.c      | 14 +++++++++++---
>  include/linux/blkdev.h |  1 +
>  2 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index 0f4f0c8a7825..367c1d9a55c6 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -426,9 +426,17 @@ static ssize_t queue_poll_store(struct request_queue *q, const char *page,
>  	unsigned long poll_on;
>  	ssize_t ret;
>  
> -	if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
> -	    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
> -		return -EINVAL;
> +	if (queue_is_mq(q)) {
> +		if (!q->tag_set || q->tag_set->nr_maps <= HCTX_TYPE_POLL ||
> +		    !q->tag_set->map[HCTX_TYPE_POLL].nr_queues)
> +			return -EINVAL;
> +	} else {
> +		struct gendisk *disk = queue_to_disk(q);
> +
> +		if (!disk->fops->poll_capable ||
> +		    !disk->fops->poll_capable(disk))
> +			return -EINVAL;
> +	}
>  
>  	ret = queue_var_store(&poll_on, page, count);
>  	if (ret < 0)
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 9dc83c30e7bc..7df40792c032 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1867,6 +1867,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
>  struct block_device_operations {
>  	blk_qc_t (*submit_bio) (struct bio *bio);
>  	int (*poll)(struct request_queue *q, blk_qc_t cookie);
> +	bool (*poll_capable)(struct gendisk *disk);
>  	int (*open) (struct block_device *, fmode_t);
>  	void (*release) (struct gendisk *, fmode_t);
>  	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
> -- 
> 2.27.0
> 

