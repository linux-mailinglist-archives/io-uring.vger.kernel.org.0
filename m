Return-Path: <io-uring+bounces-6335-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D4286A2EF6E
	for <lists+io-uring@lfdr.de>; Mon, 10 Feb 2025 15:13:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E7C82164C66
	for <lists+io-uring@lfdr.de>; Mon, 10 Feb 2025 14:13:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A2B0235351;
	Mon, 10 Feb 2025 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KVmIrfEY"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14A8235356
	for <io-uring@vger.kernel.org>; Mon, 10 Feb 2025 14:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739196785; cv=none; b=BT//1MK6g3bnt7f6c5GU3X9Aktc/5jTCmx4m/WcBww9UryrSN5FlkOGIvS+II6FlytlJdwwjIHzypgYNt2qerfpYUSTS6xxIH9S1BGFdwhgf7/nBPNh62bXASD8r+GV9NEfynZDasG3m88BtHDGEyWUoiniEaYfzc4ZeCDKfNS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739196785; c=relaxed/simple;
	bh=F1GQunofvZymwaw6OImDDuUuSgczN6ZtGh5ttLFMbz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQEQomZNKxPptv71GsRSWpiTiqDevjsrjWL2Z30QirBivt8UoVHzam7wUnW+5faDAw4B1t3MuFTMBNMnvpXzQIXDS4PChhXK8EPTzlJD8xknl0BYSJy/uB6XxspBEqcHloiXeDB032qnPYdHIK0aniLGkv7TI/2VNuKtSL/Ju7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KVmIrfEY; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739196782;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O/56VSVljZRXAfq5xCEI3sQnGPKbEh4zS3nINFQ+5DY=;
	b=KVmIrfEYdNMTain/mDTK0K57plTiEopwyvDr8hT5+75xb6CnqcHpNUF3ujwNvhANI/xTTu
	N4YoLBARM8iH5se6UJ9KgsRh2VlIknKsdOLgCgyqG60Fn5PRbMqHA3LkIRKmBQNfR+4SR3
	FhKqMiYvNormZxhwhfuwqx8tV6dn6KE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-226-IS8gbWHAOEG4oM7Oy5Ep-Q-1; Mon,
 10 Feb 2025 09:12:55 -0500
X-MC-Unique: IS8gbWHAOEG4oM7Oy5Ep-Q-1
X-Mimecast-MFC-AGG-ID: IS8gbWHAOEG4oM7Oy5Ep-Q
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E8801955D65;
	Mon, 10 Feb 2025 14:12:54 +0000 (UTC)
Received: from fedora (unknown [10.72.116.149])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD3CD195608D;
	Mon, 10 Feb 2025 14:12:49 +0000 (UTC)
Date: Mon, 10 Feb 2025 22:12:44 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk,
	asml.silence@gmail.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 3/6] io_uring: add support for kernel registered bvecs
Message-ID: <Z6oJXIsBMMkCpW_3@fedora>
References: <20250203154517.937623-1-kbusch@meta.com>
 <20250203154517.937623-4-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250203154517.937623-4-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Feb 03, 2025 at 07:45:14AM -0800, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> Provide an interface for the kernel to leverage the existing
> pre-registered buffers that io_uring provides. User space can reference
> these later to achieve zero-copy IO.
> 
> User space must register an empty fixed buffer table with io_uring in
> order for the kernel to make use of it.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/linux/io_uring.h       |   1 +
>  include/linux/io_uring_types.h |   3 +
>  io_uring/rsrc.c                | 114 +++++++++++++++++++++++++++++++--
>  io_uring/rsrc.h                |   1 +
>  4 files changed, 114 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 85fe4e6b275c7..b5637a2aae340 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -5,6 +5,7 @@
>  #include <linux/sched.h>
>  #include <linux/xarray.h>
>  #include <uapi/linux/io_uring.h>
> +#include <linux/blk-mq.h>
>  
>  #if defined(CONFIG_IO_URING)
>  void __io_uring_cancel(bool cancel_all);
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index 623d8e798a11a..7e5a5a70c35f2 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -695,4 +695,7 @@ static inline bool io_ctx_cqe32(struct io_ring_ctx *ctx)
>  	return ctx->flags & IORING_SETUP_CQE32;
>  }
>  
> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, const struct request *rq, unsigned int tag);
> +void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int tag);
> +
>  #endif
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 4d0e1c06c8bc6..8c4c374abcc10 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -111,7 +111,10 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
>  		if (!refcount_dec_and_test(&imu->refs))
>  			return;
>  		for (i = 0; i < imu->nr_bvecs; i++)
> -			unpin_user_page(imu->bvec[i].bv_page);
> +			if (node->type == IORING_RSRC_KBUF)
> +				put_page(imu->bvec[i].bv_page);
> +			else
> +				unpin_user_page(imu->bvec[i].bv_page);
>  		if (imu->acct_pages)
>  			io_unaccount_mem(ctx, imu->acct_pages);
>  		kvfree(imu);
> @@ -240,6 +243,13 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>  		struct io_rsrc_node *node;
>  		u64 tag = 0;
>  
> +		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
> +		node = io_rsrc_node_lookup(&ctx->buf_table, i);
> +		if (node && node->type != IORING_RSRC_BUFFER) {
> +			err = -EBUSY;
> +			break;
> +		}
> +
>  		uvec = u64_to_user_ptr(user_data);
>  		iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
>  		if (IS_ERR(iov)) {
> @@ -258,6 +268,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>  			err = PTR_ERR(node);
>  			break;
>  		}
> +
>  		if (tag) {
>  			if (!node) {
>  				err = -EINVAL;
> @@ -265,7 +276,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>  			}
>  			node->tag = tag;
>  		}
> -		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
>  		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
>  		ctx->buf_table.nodes[i] = node;
>  		if (ctx->compat)
> @@ -453,6 +463,7 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
>  			fput(io_slot_file(node));
>  		break;
>  	case IORING_RSRC_BUFFER:
> +	case IORING_RSRC_KBUF:
>  		if (node->buf)
>  			io_buffer_unmap(ctx, node);
>  		break;
> @@ -860,6 +871,92 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  	return ret;
>  }
>  
> +static struct io_rsrc_node *io_buffer_alloc_node(struct io_ring_ctx *ctx,
> +						 unsigned int nr_bvecs,
> +						 unsigned int len)
> +{
> +	struct io_mapped_ubuf *imu;
> +	struct io_rsrc_node *node;
> +
> +	node = io_rsrc_node_alloc(IORING_RSRC_KBUF);
> +	if (!node)
> +		return NULL;
> +
> +	imu = kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
> +	if (!imu) {
> +		io_put_rsrc_node(ctx, node);
> +		return NULL;
> +	}
> +
> +	imu->ubuf = 0;
> +	imu->len = len;
> +	imu->acct_pages = 0;
> +	imu->nr_bvecs = nr_bvecs;
> +	refcount_set(&imu->refs, 1);
> +
> +	node->buf = imu;
> +	return node;
> +}
> +
> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, const struct request *rq,
> +			    unsigned int index)
> +{
> +	struct io_rsrc_data *data = &ctx->buf_table;
> +	u16 nr_bvecs = blk_rq_nr_phys_segments(rq);
> +	struct req_iterator rq_iter;
> +	struct io_rsrc_node *node;
> +	struct bio_vec bv;
> +	int i = 0;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	if (WARN_ON_ONCE(!data->nr))
> +		return -EINVAL;
> +	if (WARN_ON_ONCE(index >= data->nr))
> +		return -EINVAL;
> +
> +	node = data->nodes[index];
> +	if (WARN_ON_ONCE(node))
> +		return -EBUSY;
> +
> +	node = io_buffer_alloc_node(ctx, nr_bvecs, blk_rq_bytes(rq));
> +	if (!node)
> +		return -ENOMEM;
> +
> +	rq_for_each_bvec(bv, rq, rq_iter) {
> +		get_page(bv.bv_page);
> +		node->buf->bvec[i].bv_page = bv.bv_page;
> +		node->buf->bvec[i].bv_len = bv.bv_len;
> +		node->buf->bvec[i].bv_offset = bv.bv_offset;
> +		i++;

In this patchset, ublk request buffer may cross uring OPs, so it is inevitable
for buggy application to complete IO command & ublk request before
io_uring read/write OP using the buffer/page is completed .

That is probably the reason why page reference is increased here, then
bvec page lifetime becomes not aligned with request any more from block
layer viewpoint.

Not sure this way is safe:

1) for current block storage driver, when request is completed, all
request bvec page ownership is transferred to upper layer(FS, application, ...),
but it becomes not true for ublk zero copy with this patchset 

2) BIO_PAGE_PINNED may not be set for bio, so upper layer might think that
bvec pages can be reused or reclaimed after this ublk bio is completed.



Thanks,
Ming


