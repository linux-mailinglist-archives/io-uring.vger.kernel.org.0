Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 167D73374C7
	for <lists+io-uring@lfdr.de>; Thu, 11 Mar 2021 14:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhCKN5K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 08:57:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30871 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233511AbhCKN4l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 08:56:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615471000;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=C+ScMbdR52Xee4kQKYcH1NEbK4+U/YcVRwEPYz1S0oA=;
        b=iDWrkYXJTXDaHcRYRqRnL04ZRSsu4SRzgbCQWKMsYTfkc+5ce/yLHNG/n4Or7SHeHrK3OM
        h6pgYeyYlsRUUig7LruOOoSr4adUQykg6I/w3Lx1PrPdi39ZhtrZ/W3bG5ndwPFBUvEsBb
        cp5DjXuZiXj27WinhCJ7A9E7DllIQZg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-ISQI7s4rMeesc7OZIHZOFw-1; Thu, 11 Mar 2021 08:56:38 -0500
X-MC-Unique: ISQI7s4rMeesc7OZIHZOFw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 12323193248C;
        Thu, 11 Mar 2021 13:56:36 +0000 (UTC)
Received: from T590 (ovpn-12-19.pek2.redhat.com [10.72.12.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF3B92B16E;
        Thu, 11 Mar 2021 13:56:23 +0000 (UTC)
Date:   Thu, 11 Mar 2021 21:56:19 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
Cc:     msnitzer@redhat.com, axboe@kernel.dk, io-uring@vger.kernel.org,
        dm-devel@redhat.com, linux-block@vger.kernel.org,
        mpatocka@redhat.com, caspar@linux.alibaba.com,
        joseph.qi@linux.alibaba.com
Subject: Re: [PATCH v5 10/12] block: fastpath for bio-based polling
Message-ID: <YEohgwIIy5ryme8x@T590>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
 <20210303115740.127001-11-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303115740.127001-11-jefflexu@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Mar 03, 2021 at 07:57:38PM +0800, Jeffle Xu wrote:
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

In patch 8, dm_submit_bio() is changed to return BLK_QC_T_NONE always,
so the returned cookie may be BLK_QC_T_NONE for DM device, such as, in
case of DM_MAPIO_SUBMITTED returned from ->map(), and underlying bios
can be submitted from another context, then nothing is fed to blk_poll().


thanks, 
Ming

