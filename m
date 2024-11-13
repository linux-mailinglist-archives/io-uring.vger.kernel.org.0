Return-Path: <io-uring+bounces-4667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DFB79C7EC0
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 00:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D19CB2844A9
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 23:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FD8917FAC2;
	Wed, 13 Nov 2024 23:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JrOojgLJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8485918BC2C
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 23:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731540325; cv=none; b=l5XGemDQ+BtQ9Xt94uR7fDis7tWO1V4Wq2VjDWJEIzULdihGtjrnS4cc1M8oBIj7eR2kvQpvPEN80iZ0WNwUaKIvKqL67+iFK6W5A9ayoY9cxdwmU2r58/HTsp8wE9jNYZbBhOqf5TjzCj9DVDf3LeJZRusnDXBbPfFm0XWwgQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731540325; c=relaxed/simple;
	bh=c5dYtWrY11OG4lgQlqIZVJE4vP5JPLMTqoyIrqudnWI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PJLWD4diZkxoO/akd4LuxBEcoqgjnvRmIBrERXNwJx8ft5S7rRUPpB9zmssDaGEg5A74/sl2zbEUjIIBSHU+JTX4UkOw0txWQtRVPOEg7kMNVj3yyJ7dQy7JeDf0VR5Ez6CsLPIxI64kLoYBb45vaEH4vxStgoQGB2XQeePOsZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JrOojgLJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731540322;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RzPWmh0C8RYeAeZIKKXP7q682GlgR+SBS+qZzgFuwNs=;
	b=JrOojgLJc48x9O04lakp0xc7Rrdy/gaRUhbkOdSI7xaFHmZZ0LVcZah1tvHeKrSc8b8Thl
	1NMWPDC008PyWMMaS2ubThucJ2QiiZMRcvBVlPhcPS2AS82Q2ZlMz5rGvvnJ+g+08aInZl
	XksBSnPVc2Oly/rTurZRRg/IhN1tENY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-pFjKMDPLOq-7mgm-n3VLkQ-1; Wed, 13 Nov 2024 18:25:21 -0500
X-MC-Unique: pFjKMDPLOq-7mgm-n3VLkQ-1
X-Mimecast-MFC-AGG-ID: pFjKMDPLOq-7mgm-n3VLkQ
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4315eaa3189so336905e9.1
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 15:25:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731540320; x=1732145120;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RzPWmh0C8RYeAeZIKKXP7q682GlgR+SBS+qZzgFuwNs=;
        b=sBeMVnhep+5Pu0u0r1JRv5/eKy50387o950jhfLdwe6smA+zhRd7zo+BAM9s9hYfSI
         3ST5HU+mmGPq4QSwtI4QaRj6OnQYdH+KY9vYPmJgNmgtM9FBdlMR86bSipXDoQO0urM0
         4O/4jWy+Br9Rf0dNu2eS+l1yaTpIRA2SV4qQX82dAaWC5tO+UAtjSSXqGWlASn6IGRPQ
         qn0ubi2WBSqtsHj3YOfP/fvJDfGRCgfhDMiel4qNUuMFM8jZ5FABx9VrCVy0oWPtz3+n
         sUiSOH50NOQ7Yj77qJnia1IX5mYa6ufnSPzhstV0cnfDoUU8t3TvLFppOuZdqlC1lrs6
         Dsgw==
X-Forwarded-Encrypted: i=1; AJvYcCWfF6jqq8q1kLv1xYgUfldd4Zt+rl9q5CTgiThq4XzntQZz9uCLbGQc7FYmyTjNsLoVFboS0fwygQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwpbMcS2fujFhGUQK34TgQLE0RGoDFwAnB8nmsjd/rYgRx3P7Xd
	5ucL794XmeoiCzWu6xbsVBrPY5q5OpuGYThZ+BG1FeO+saoP18OcJnYUBteJ4dg9yGEC27tiUpM
	qYmw//t/W07DJncC5Hzt8cUH3TpNJ5ogwVbcHM4HFKyVQLtmClchjC3NI
X-Received: by 2002:a05:600c:3d8d:b0:431:4847:47c0 with SMTP id 5b1f17b1804b1-432da76ec4amr935395e9.7.1731540320197;
        Wed, 13 Nov 2024 15:25:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHDNE+4rEsYxD1YNYi7V9qyaFYVxzcxTW8otS2BtZTbP6JFcM1ds70h/SDQ68r3Vw5bW0apPw==
X-Received: by 2002:a05:600c:3d8d:b0:431:4847:47c0 with SMTP id 5b1f17b1804b1-432da76ec4amr935285e9.7.1731540319813;
        Wed, 13 Nov 2024 15:25:19 -0800 (PST)
Received: from redhat.com ([2.55.171.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432d9d0a4absm4692895e9.24.2024.11.13.15.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 15:25:18 -0800 (PST)
Date: Wed, 13 Nov 2024 18:25:13 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Jason Wang <jasowang@redhat.com>,
	Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org, virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/6] virtio_blk: reverse request order in virtio_queue_rqs
Message-ID: <20241113182448-mutt-send-email-mst@kernel.org>
References: <20241113152050.157179-1-hch@lst.de>
 <20241113152050.157179-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241113152050.157179-3-hch@lst.de>

On Wed, Nov 13, 2024 at 04:20:42PM +0100, Christoph Hellwig wrote:
> blk_mq_flush_plug_list submits requests in the reverse order that they
> were submitted, which leads to a rather suboptimal I/O pattern especially
> in rotational devices.  Fix this by rewriting nvme_queue_rqs so that it
> always pops the requests from the passed in request list, and then adds
> them to the head of a local submit list.  This actually simplifies the
> code a bit as it removes the complicated list splicing, at the cost of
> extra updates of the rq_next pointer.  As that should be cache hot
> anyway it should be an easy price to pay.
> 
> Fixes: 0e9911fa768f ("virtio-blk: support mq_ops->queue_rqs()")
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/block/virtio_blk.c | 46 +++++++++++++++++---------------------
>  1 file changed, 21 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 0e99a4714928..b25f7c06a28e 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -471,18 +471,18 @@ static bool virtblk_prep_rq_batch(struct request *req)
>  	return virtblk_prep_rq(req->mq_hctx, vblk, req, vbr) == BLK_STS_OK;
>  }
>  
> -static bool virtblk_add_req_batch(struct virtio_blk_vq *vq,
> +static void virtblk_add_req_batch(struct virtio_blk_vq *vq,
>  					struct request **rqlist)
>  {
> +	struct request *req;
>  	unsigned long flags;
> -	int err;
>  	bool kick;
>  
>  	spin_lock_irqsave(&vq->lock, flags);
>  
> -	while (!rq_list_empty(*rqlist)) {
> -		struct request *req = rq_list_pop(rqlist);
> +	while ((req = rq_list_pop(rqlist))) {
>  		struct virtblk_req *vbr = blk_mq_rq_to_pdu(req);
> +		int err;
>  
>  		err = virtblk_add_req(vq->vq, vbr);
>  		if (err) {
> @@ -495,37 +495,33 @@ static bool virtblk_add_req_batch(struct virtio_blk_vq *vq,
>  	kick = virtqueue_kick_prepare(vq->vq);
>  	spin_unlock_irqrestore(&vq->lock, flags);
>  
> -	return kick;
> +	if (kick)
> +		virtqueue_notify(vq->vq);
>  }
>  
>  static void virtio_queue_rqs(struct request **rqlist)
>  {
> -	struct request *req, *next, *prev = NULL;
> +	struct request *submit_list = NULL;
>  	struct request *requeue_list = NULL;
> +	struct request **requeue_lastp = &requeue_list;
> +	struct virtio_blk_vq *vq = NULL;
> +	struct request *req;
>  
> -	rq_list_for_each_safe(rqlist, req, next) {
> -		struct virtio_blk_vq *vq = get_virtio_blk_vq(req->mq_hctx);
> -		bool kick;
> -
> -		if (!virtblk_prep_rq_batch(req)) {
> -			rq_list_move(rqlist, &requeue_list, req, prev);
> -			req = prev;
> -			if (!req)
> -				continue;
> -		}
> +	while ((req = rq_list_pop(rqlist))) {
> +		struct virtio_blk_vq *this_vq = get_virtio_blk_vq(req->mq_hctx);
>  
> -		if (!next || req->mq_hctx != next->mq_hctx) {
> -			req->rq_next = NULL;
> -			kick = virtblk_add_req_batch(vq, rqlist);
> -			if (kick)
> -				virtqueue_notify(vq->vq);
> +		if (vq && vq != this_vq)
> +			virtblk_add_req_batch(vq, &submit_list);
> +		vq = this_vq;
>  
> -			*rqlist = next;
> -			prev = NULL;
> -		} else
> -			prev = req;
> +		if (virtblk_prep_rq_batch(req))
> +			rq_list_add(&submit_list, req); /* reverse order */
> +		else
> +			rq_list_add_tail(&requeue_lastp, req);
>  	}
>  
> +	if (vq)
> +		virtblk_add_req_batch(vq, &submit_list);
>  	*rqlist = requeue_list;
>  }



looks ok from virtio POV

Acked-by: Michael S. Tsirkin <mst@redhat.com>


> -- 
> 2.45.2


