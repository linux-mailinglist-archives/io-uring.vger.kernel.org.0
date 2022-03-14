Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C0A4D8417
	for <lists+io-uring@lfdr.de>; Mon, 14 Mar 2022 13:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241426AbiCNMWk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 14 Mar 2022 08:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243954AbiCNMVZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 14 Mar 2022 08:21:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E43C13D06
        for <io-uring@vger.kernel.org>; Mon, 14 Mar 2022 05:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647260342;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8FmWX2QMQos3nrVKwSLKK2qdikCJoBGM3MvZCsjeGHc=;
        b=Uh0CGMVrtg9gmS7+BixukUq1cpW3Qmet77DcF5QMDW757+Rlmofluxh7tKJFAA5QbI9/41
        9QOqypbkmuahYy/TV+mL6EYlWMGFUSfjQ43R0/Ne8lDY0b/hvlFrrsfGNiwbXLSI92qvZ2
        R2/hvZEXX1205yQnzmv+1mG3x4KBDC4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-mhN1FJi_MDOAOIy3YIpexw-1; Mon, 14 Mar 2022 08:18:59 -0400
X-MC-Unique: mhN1FJi_MDOAOIy3YIpexw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8F9862999B2F;
        Mon, 14 Mar 2022 12:18:57 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4C883407EE6E;
        Mon, 14 Mar 2022 12:18:42 +0000 (UTC)
Date:   Mon, 14 Mar 2022 20:18:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kanchan Joshi <joshi.k@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        asml.silence@gmail.com, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        sbates@raithlin.com, logang@deltatee.com, pankydev8@gmail.com,
        javier@javigon.com, mcgrof@kernel.org, a.manzanares@samsung.com,
        joshiiitr@gmail.com, anuj20.g@samsung.com
Subject: Re: [PATCH 08/17] nvme: enable passthrough with fixed-buffer
Message-ID: <Yi8ynSFjllfuj4NB@T590>
References: <20220308152105.309618-1-joshi.k@samsung.com>
 <CGME20220308152709epcas5p1f9d274a0214dc462c22c278a72d8697c@epcas5p1.samsung.com>
 <20220308152105.309618-9-joshi.k@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220308152105.309618-9-joshi.k@samsung.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Mar 08, 2022 at 08:50:56PM +0530, Kanchan Joshi wrote:
> From: Anuj Gupta <anuj20.g@samsung.com>
> 
> Add support to carry out passthrough command with pre-mapped buffers.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kanchan Joshi <joshi.k@samsung.com>
> ---
>  block/blk-map.c           | 45 +++++++++++++++++++++++++++++++++++++++
>  drivers/nvme/host/ioctl.c | 27 ++++++++++++++---------
>  include/linux/blk-mq.h    |  2 ++
>  3 files changed, 64 insertions(+), 10 deletions(-)
> 
> diff --git a/block/blk-map.c b/block/blk-map.c
> index 4526adde0156..027e8216e313 100644
> --- a/block/blk-map.c
> +++ b/block/blk-map.c
> @@ -8,6 +8,7 @@
>  #include <linux/bio.h>
>  #include <linux/blkdev.h>
>  #include <linux/uio.h>
> +#include <linux/io_uring.h>
>  
>  #include "blk.h"
>  
> @@ -577,6 +578,50 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
>  }
>  EXPORT_SYMBOL(blk_rq_map_user);
>  
> +/* Unlike blk_rq_map_user () this is only for fixed-buffer async passthrough. */
> +int blk_rq_map_user_fixedb(struct request_queue *q, struct request *rq,
> +		     u64 ubuf, unsigned long len, gfp_t gfp_mask,
> +		     struct io_uring_cmd *ioucmd)
> +{
> +	struct iov_iter iter;
> +	size_t iter_count, nr_segs;
> +	struct bio *bio;
> +	int ret;
> +
> +	/*
> +	 * Talk to io_uring to obtain BVEC iterator for the buffer.
> +	 * And use that iterator to form bio/request.
> +	 */
> +	ret = io_uring_cmd_import_fixed(ubuf, len, rq_data_dir(rq), &iter,
> +			ioucmd);
> +	if (unlikely(ret < 0))
> +		return ret;
> +	iter_count = iov_iter_count(&iter);
> +	nr_segs = iter.nr_segs;
> +
> +	if (!iter_count || (iter_count >> 9) > queue_max_hw_sectors(q))
> +		return -EINVAL;
> +	if (nr_segs > queue_max_segments(q))
> +		return -EINVAL;
> +	/* no iovecs to alloc, as we already have a BVEC iterator */
> +	bio = bio_alloc(gfp_mask, 0);
> +	if (!bio)
> +		return -ENOMEM;
> +
> +	ret = bio_iov_iter_get_pages(bio, &iter);

Here bio_iov_iter_get_pages() may not work as expected since the code
needs to check queue limit before adding page to bio and we don't run
split for passthrough bio. __bio_iov_append_get_pages() may be generalized
for covering this case.


Thanks, 
Ming

