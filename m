Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A1331FA78
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 15:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhBSOSy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 09:18:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40792 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229808AbhBSOSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 09:18:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613744247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vcaXkz3DIMXR6O8tkWCRCDaH2CJZE8gRDs1qdSdAtsA=;
        b=dqikdrElXxjqxkXSpcP6/9H185Ch2BWOPtQ/c9BXwXkX7JEet9nhTCU7hilHlj5KVwklDr
        5LGMzItvQUf2zZt9CPVRLBxBPGuO19fCYKw959utADUJD9wlpZLbxwCGRWaGljR6L7EAF7
        9MPsHIpYpM5U8cGs92vvLagKnHkFrv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-5tiPo4NSO-ODLee_WA6QXA-1; Fri, 19 Feb 2021 09:17:23 -0500
X-MC-Unique: 5tiPo4NSO-ODLee_WA6QXA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCCB7AFA81;
        Fri, 19 Feb 2021 14:17:21 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B40145D9C6;
        Fri, 19 Feb 2021 14:17:14 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 11JEHEkJ007662;
        Fri, 19 Feb 2021 09:17:14 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 11JEHCXs007658;
        Fri, 19 Feb 2021 09:17:13 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Fri, 19 Feb 2021 09:17:12 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Jeffle Xu <jefflexu@linux.alibaba.com>
cc:     snitzer@redhat.com, axboe@kernel.dk, caspar@linux.alibaba.com,
        hch@lst.de, linux-block@vger.kernel.org,
        joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: Re: [dm-devel] [PATCH v3 09/11] dm: support IO polling for bio-based
 dm device
In-Reply-To: <20210208085243.82367-10-jefflexu@linux.alibaba.com>
Message-ID: <alpine.LRH.2.02.2102190907560.10545@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com> <20210208085243.82367-10-jefflexu@linux.alibaba.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On Mon, 8 Feb 2021, Jeffle Xu wrote:

> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index c2945c90745e..8423f1347bb8 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1657,6 +1657,68 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
>  	return BLK_QC_T_NONE;
>  }
>  
> +static int dm_poll_one_md(struct mapped_device *md);
> +
> +static int dm_poll_one_dev(struct dm_target *ti, struct dm_dev *dev,
> +				sector_t start, sector_t len, void *data)
> +{
> +	int i, *count = data;
> +	struct request_queue *q = bdev_get_queue(dev->bdev);
> +	struct blk_mq_hw_ctx *hctx;
> +
> +	if (queue_is_mq(q)) {
> +		if (!percpu_ref_tryget(&q->q_usage_counter))
> +			return 0;
> +
> +		queue_for_each_poll_hw_ctx(q, hctx, i)
> +			*count += blk_mq_poll_hctx(q, hctx);
> +
> +		percpu_ref_put(&q->q_usage_counter);
> +	} else
> +		*count += dm_poll_one_md(dev->bdev->bd_disk->private_data);

This is fragile, because in the future there may be other bio-based 
drivers that support polling. You should check that "q" is really a device 
mapper device before calling dm_poll_one_md on it.

Mikulas

