Return-Path: <io-uring+bounces-5274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A451F9E751A
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 17:05:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 846BB1608C8
	for <lists+io-uring@lfdr.de>; Fri,  6 Dec 2024 16:05:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A54F207E0C;
	Fri,  6 Dec 2024 16:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i4YK4Dge"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 321BBBA20;
	Fri,  6 Dec 2024 16:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733501117; cv=none; b=Io6EFAcPz/bQYB1oS7bYGvxqD2vFVdfYzOVztF0L/ShNG2IZgq/a7CxaKJS3HYlkkfvl/3Zbw2EF7biAwItU6q77B3Y9g5AMo8o1jztcYfgKD0bjmtirnzLDQVxoTCaOaSqh+UVIQM8txrUZ92w7qq4clXQwwHoxqqAxScqbLfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733501117; c=relaxed/simple;
	bh=/fCk0+zZfe7tdUZvLJPAKEs1Sm3hugcNfZSIpGOqhY8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NhneIj+yqktiZ3I/IiXh9UkviVpB+uZMVHaF/YcFj8oreF5iqaBYTqJRNW7IJsuxdZ8ESHSNiZ2yLEU13n4zrXaALESrL5Vx6sy7ScioVEqtCCUt5zjWDuFTZ7F50eTP+vC+QNcRjch/FU5ncqiWgWQ3UuDyB4xbE27A17DEnRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i4YK4Dge; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1451C4CED1;
	Fri,  6 Dec 2024 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733501116;
	bh=/fCk0+zZfe7tdUZvLJPAKEs1Sm3hugcNfZSIpGOqhY8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i4YK4DgeK20Cnxd0RT6rUcjv0euSPTJczpeSHlDO8I5NCxd4TN3ByUzk3iKPCE7KO
	 45mU2nJU2u/DS+RiOHSDFVUMnURxy9UmhBqS6gDsOA3v2ITcgwMF822ijoj4xDcz0Z
	 meH/ugC/aZEg4HbPxduOZrJRXDJQ8e+Y8fiw0nO8S27n5tm8ST5VbbRElAJ9hwMHr6
	 Lg6EzEtYNLBmKzW1jvHPOwk9wYbdAEhCX9IMkGcWUdkuZwJbgvJF310t9wubmbq3Tt
	 V/EM1CdenMyqLauODB9WEUPxt7/btuMKGdU+/gr3PmCgHtwdaK4almGNbZAP4IkUMH
	 +o+2MhRUcV+Bg==
Date: Fri, 6 Dec 2024 16:05:11 +0000
From: Simon Horman <horms@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 09/17] io_uring/zcrx: add interface queue and
 refill queue
Message-ID: <20241206160511.GY2581@kernel.org>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-10-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241204172204.4180482-10-dw@davidwei.uk>

On Wed, Dec 04, 2024 at 09:21:48AM -0800, David Wei wrote:
> From: David Wei <davidhwei@meta.com>
> 
> Add a new object called an interface queue (ifq) that represents a net
> rx queue that has been configured for zero copy. Each ifq is registered
> using a new registration opcode IORING_REGISTER_ZCRX_IFQ.
> 
> The refill queue is allocated by the kernel and mapped by userspace
> using a new offset IORING_OFF_RQ_RING, in a similar fashion to the main
> SQ/CQ. It is used by userspace to return buffers that it is done with,
> which will then be re-used by the netdev again.
> 
> The main CQ ring is used to notify userspace of received data by using
> the upper 16 bytes of a big CQE as a new struct io_uring_zcrx_cqe. Each
> entry contains the offset + len to the data.
> 
> For now, each io_uring instance only has a single ifq.
> 
> Signed-off-by: David Wei <dw@davidwei.uk>

...

> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c

...

> +int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
> +			  struct io_uring_zcrx_ifq_reg __user *arg)
> +{
> +	struct io_uring_zcrx_ifq_reg reg;
> +	struct io_uring_region_desc rd;
> +	struct io_zcrx_ifq *ifq;
> +	size_t ring_sz, rqes_sz;
> +	int ret;
> +
> +	/*
> +	 * 1. Interface queue allocation.
> +	 * 2. It can observe data destined for sockets of other tasks.
> +	 */
> +	if (!capable(CAP_NET_ADMIN))
> +		return -EPERM;
> +
> +	/* mandatory io_uring features for zc rx */
> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
> +	      ctx->flags & IORING_SETUP_CQE32))
> +		return -EINVAL;
> +	if (ctx->ifq)
> +		return -EBUSY;
> +	if (copy_from_user(&reg, arg, sizeof(reg)))
> +		return -EFAULT;
> +	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
> +		return -EFAULT;
> +	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)))
> +		return -EINVAL;
> +	if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
> +		return -EINVAL;
> +	if (reg.rq_entries > IO_RQ_MAX_ENTRIES) {
> +		if (!(ctx->flags & IORING_SETUP_CLAMP))
> +			return -EINVAL;
> +		reg.rq_entries = IO_RQ_MAX_ENTRIES;
> +	}
> +	reg.rq_entries = roundup_pow_of_two(reg.rq_entries);
> +
> +	if (!reg.area_ptr)
> +		return -EFAULT;
> +
> +	ifq = io_zcrx_ifq_alloc(ctx);
> +	if (!ifq)
> +		return -ENOMEM;
> +
> +	ret = io_allocate_rbuf_ring(ifq, &reg, &rd);
> +	if (ret)
> +		goto err;
> +
> +	ifq->rq_entries = reg.rq_entries;
> +	ifq->if_rxq = reg.if_rxq;
> +
> +	ring_sz = sizeof(struct io_uring);
> +	rqes_sz = sizeof(struct io_uring_zcrx_rqe) * ifq->rq_entries;

Hi David,

A minor nit from my side: rqes_sz is set but otherwise unused in this
function. Perhaps it can be removed?

Flagged by W=1 builds.

> +	reg.offsets.rqes = ring_sz;
> +	reg.offsets.head = offsetof(struct io_uring, head);
> +	reg.offsets.tail = offsetof(struct io_uring, tail);
> +
> +	if (copy_to_user(arg, &reg, sizeof(reg)) ||
> +	    copy_to_user(u64_to_user_ptr(reg.region_ptr), &rd, sizeof(rd))) {
> +		ret = -EFAULT;
> +		goto err;
> +	}
> +
> +	ctx->ifq = ifq;
> +	return 0;
> +err:
> +	io_zcrx_ifq_free(ifq);
> +	return ret;
> +}

...

