Return-Path: <io-uring+bounces-3888-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 245939A965B
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:43:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9E15B21EB7
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0585333DF;
	Tue, 22 Oct 2024 02:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dMMvRODS"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0041212F5B3
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729565009; cv=none; b=mapSyEs7Je4zA7sCa0iYquqoLtaZaz11KrJjuwZQ3Zsk30BDieqeJAiglMemBQgKA9vDVoLJjEfJlXDYefpT67oybJeXTxkPxDmw2jouHyMPp+bxID363rFYRCGkfVWwd0/H58M+/iw2zKIBj1Y5nLd33a5Nl4IPN7ExYoZcJ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729565009; c=relaxed/simple;
	bh=Eb0HB8UjIdcuQMQNt+PSQyTnBe/RbMMJNtrU5z3Iok0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iceyC98OGb92s8EoaDlkQPutpENcnJ3habPHiIvyHmc863sydien/8A6rLY5UZQmKOnO4UfM4cyHZASNAgxf9KLF5i4imCMZNRLgTlUDqlL9LBXnpBLHBlTNsW+a03QyTsviFUUktHZfZOdHaa9fQUTENm2e2zM3CZKl8/fbnDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dMMvRODS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729565006;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/2pSlUmMqtCHpAt7lAYbOyyrhYkS1ull550JDVxmaiU=;
	b=dMMvRODS/MSmcR4Ii2itwDDfdy9Qu8OOWDGQ/Hck0OYGEJ3L7eRkZmbSeObL8EWgleg3Fz
	jKCZBaOLusfCYkUEVD6qjMTefWyB41vOHHk0rhZU9WSbfLYzzU01L54g08ocvF7KqSulet
	8ib9SU4XG+czxpZb4aXwSVIxyJHZUHo=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-436-PRcRVYOfMauU-atqIp54RQ-1; Mon,
 21 Oct 2024 22:43:23 -0400
X-MC-Unique: PRcRVYOfMauU-atqIp54RQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4CC2C1956089;
	Tue, 22 Oct 2024 02:43:22 +0000 (UTC)
Received: from fedora (unknown [10.72.116.81])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B87361956088;
	Tue, 22 Oct 2024 02:43:18 +0000 (UTC)
Date: Tue, 22 Oct 2024 10:43:13 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Subject: Re: [PATCH 1/4] io_uring/uring_cmd: get rid of using req->imu
Message-ID: <ZxcRQZzAmwm1XT3K@fedora>
References: <20241022020426.819298-1-axboe@kernel.dk>
 <20241022020426.819298-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022020426.819298-2-axboe@kernel.dk>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Oct 21, 2024 at 08:03:20PM -0600, Jens Axboe wrote:
> It's pretty pointless to use io_kiocb as intermediate storage for this,
> so split the validity check and the actual usage. The resource node is
> assigned upfront at prep time, to prevent it from going away. The actual
> import is never called with the ctx->uring_lock held, so grab it for
> the import.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/uring_cmd.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 39c3c816ec78..313e2a389174 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -211,11 +211,15 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>  		struct io_ring_ctx *ctx = req->ctx;
>  		u16 index;
>  
> -		req->buf_index = READ_ONCE(sqe->buf_index);
> -		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
> +		index = READ_ONCE(sqe->buf_index);
> +		if (unlikely(index >= ctx->nr_user_bufs))
>  			return -EFAULT;
> -		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
> -		req->imu = ctx->user_bufs[index];
> +		req->buf_index = array_index_nospec(index, ctx->nr_user_bufs);
> +		/*
> +		 * Pi node upfront, prior to io_uring_cmd_import_fixed()
> +		 * being called. This prevents destruction of the mapped buffer
> +		 * we'll need at actual import time.
> +		 */
>  		io_req_set_rsrc_node(req, ctx, 0);
>  	}
>  	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
> @@ -272,8 +276,16 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>  			      struct iov_iter *iter, void *ioucmd)
>  {
>  	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +	struct io_ring_ctx *ctx = req->ctx;
> +	struct io_mapped_ubuf *imu;
> +	int ret;
>  
> -	return io_import_fixed(rw, iter, req->imu, ubuf, len);
> +	mutex_lock(&ctx->uring_lock);
> +	imu = ctx->user_bufs[req->buf_index];
> +	ret = io_import_fixed(rw, iter, imu, ubuf, len);
> +	mutex_unlock(&ctx->uring_lock);

io_uring_cmd_import_fixed is called in nvme ->issue(), and ->uring_lock
may be held already.



thanks,
Ming


