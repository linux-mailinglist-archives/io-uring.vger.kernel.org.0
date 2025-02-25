Return-Path: <io-uring+bounces-6735-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20515A439F6
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 10:43:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2C6F1758CF
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2025 09:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC4D262D03;
	Tue, 25 Feb 2025 09:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZU+NulY7"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DB713A88A
	for <io-uring@vger.kernel.org>; Tue, 25 Feb 2025 09:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740476435; cv=none; b=KpoSJNhwq3jtCRYHM4nA1Xy7X/YNkvC5o5qYpz85XmMnXXk5TqbtiQikPUfuy6qkntuQSTcxvpzQfH6Bq4hxbAAUtVBYnXBIywpmcUxe1F1Tdp6HHBne5ulUbh7prQSLPu/Q9aBXK6ZLfweXYlfiXBobpx9drBL9ynGYNX5HpfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740476435; c=relaxed/simple;
	bh=2RR1z2ssOVqHZEQ4KVdW8k2uqVouPE7QcZQYsUhZe3E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D7aYpQogQuVs80cE98VLlBkds3mPpfWzC0O1aAflKgwQHXro1BNrVJAYq3V5KHbrUS6qMFDjV+iWo+/6MSY1fi4p6IgA0YQfezxQ/Z1CkOD2OOisXsYUSQVNiLdkHEFlwfPflBlWar4H1SKPfV8+7aWktSmEbo6Mhl8yVVe8Zkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZU+NulY7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740476432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AjC4aaGoYnAYqCasKhsv5uVhxLGG5kz1nCK3SAt6bck=;
	b=ZU+NulY7wuit4hghY6upn9Ncu0NXJ8Tp8ZEUuwWF7MYAPrqsHRc/al8oM5tg0u87eEdM0b
	WjagulbXmYaows+oBpV4xOiwUsGAB15C2EAcSm/Fc1leLBZo4yq5JaS4L1gFEv7gAh4gxA
	WlGiTH0sMRDR8hkV3ErTXTlWuu2ZqPM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-423-lO0SlxzyN2yQC4TPm0UQig-1; Tue,
 25 Feb 2025 04:40:28 -0500
X-MC-Unique: lO0SlxzyN2yQC4TPm0UQig-1
X-Mimecast-MFC-AGG-ID: lO0SlxzyN2yQC4TPm0UQig_1740476426
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E1EC18E6952;
	Tue, 25 Feb 2025 09:40:26 +0000 (UTC)
Received: from fedora (unknown [10.72.120.31])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58B9019560AE;
	Tue, 25 Feb 2025 09:40:19 +0000 (UTC)
Date: Tue, 25 Feb 2025 17:40:14 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Keith Busch <kbusch@meta.com>
Cc: asml.silence@gmail.com, axboe@kernel.dk, linux-block@vger.kernel.org,
	io-uring@vger.kernel.org, bernd@bsbernd.com,
	csander@purestorage.com, Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCHv5 07/11] io_uring: add support for kernel registered bvecs
Message-ID: <Z72P_nnZD9i-ya-1@fedora>
References: <20250224213116.3509093-1-kbusch@meta.com>
 <20250224213116.3509093-8-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224213116.3509093-8-kbusch@meta.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Mon, Feb 24, 2025 at 01:31:12PM -0800, Keith Busch wrote:
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
>  include/linux/io_uring/cmd.h |   7 ++
>  io_uring/rsrc.c              | 123 +++++++++++++++++++++++++++++++++--
>  io_uring/rsrc.h              |   8 +++
>  3 files changed, 131 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 87150dc0a07cf..cf8d80d847344 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -4,6 +4,7 @@
>  
>  #include <uapi/linux/io_uring.h>
>  #include <linux/io_uring_types.h>
> +#include <linux/blk-mq.h>
>  
>  /* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
>  #define IORING_URING_CMD_CANCELABLE	(1U << 30)
> @@ -125,4 +126,10 @@ static inline struct io_uring_cmd_data *io_uring_cmd_get_async_data(struct io_ur
>  	return cmd_to_io_kiocb(cmd)->async_data;
>  }
>  
> +int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
> +			    void (*release)(void *), unsigned int index,
> +			    unsigned int issue_flags);
> +void io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
> +			       unsigned int issue_flags);
> +
>  #endif /* _LINUX_IO_URING_CMD_H */
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index f814526982c36..e0c6ed3aef5b5 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -9,6 +9,7 @@
>  #include <linux/hugetlb.h>
>  #include <linux/compat.h>
>  #include <linux/io_uring.h>
> +#include <linux/io_uring/cmd.h>
>  
>  #include <uapi/linux/io_uring.h>
>  
> @@ -104,14 +105,21 @@ int io_buffer_validate(struct iovec *iov)
>  static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
>  {
>  	struct io_mapped_ubuf *imu = node->buf;
> -	unsigned int i;
>  
>  	if (!refcount_dec_and_test(&imu->refs))
>  		return;
> -	for (i = 0; i < imu->nr_bvecs; i++)
> -		unpin_user_page(imu->bvec[i].bv_page);
> -	if (imu->acct_pages)
> -		io_unaccount_mem(ctx, imu->acct_pages);
> +
> +	if (imu->release) {
> +		imu->release(imu->priv);
> +	} else {
> +		unsigned int i;
> +
> +		for (i = 0; i < imu->nr_bvecs; i++)
> +			unpin_user_page(imu->bvec[i].bv_page);
> +		if (imu->acct_pages)
> +			io_unaccount_mem(ctx, imu->acct_pages);
> +	}
> +
>  	kvfree(imu);
>  }
>  
> @@ -761,6 +769,9 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>  	imu->len = iov->iov_len;
>  	imu->nr_bvecs = nr_pages;
>  	imu->folio_shift = PAGE_SHIFT;
> +	imu->release = NULL;
> +	imu->priv = NULL;
> +	imu->perm = IO_IMU_READABLE | IO_IMU_WRITEABLE;
>  	if (coalesced)
>  		imu->folio_shift = data.folio_shift;
>  	refcount_set(&imu->refs, 1);
> @@ -857,6 +868,95 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  	return ret;
>  }
>  
> +int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
> +			    void (*release)(void *), unsigned int index,
> +			    unsigned int issue_flags)
> +{
> +	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> +	struct io_rsrc_data *data = &ctx->buf_table;
> +	struct req_iterator rq_iter;
> +	struct io_mapped_ubuf *imu;
> +	struct io_rsrc_node *node;
> +	struct bio_vec bv, *bvec;
> +	u16 nr_bvecs;
> +	int ret = 0;
> +
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +	if (index >= data->nr) {
> +		ret = -EINVAL;
> +		goto unlock;
> +	}
> +	index = array_index_nospec(index, data->nr);
> +
> +	if (data->nodes[index] ) {
> +		ret = -EBUSY;
> +		goto unlock;
> +	}
> +
> +	node = io_rsrc_node_alloc(IORING_RSRC_BUFFER);
> +	if (!node) {
> +		ret = -ENOMEM;
> +		goto unlock;
> +	}
> +
> +	nr_bvecs = blk_rq_nr_phys_segments(rq);
> +	imu = kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
> +	if (!imu) {
> +		kfree(node);
> +		ret = -ENOMEM;
> +		goto unlock;
> +	}
> +
> +	imu->ubuf = 0;
> +	imu->len = blk_rq_bytes(rq);
> +	imu->acct_pages = 0;
> +	imu->folio_shift = PAGE_SHIFT;
> +	imu->nr_bvecs = nr_bvecs;
> +	refcount_set(&imu->refs, 1);
> +	imu->release = release;
> +	imu->priv = rq;
> +
> +	if (op_is_write(req_op(rq)))
> +		imu->perm = IO_IMU_WRITEABLE;
> +	else
> +		imu->perm = IO_IMU_READABLE;

Looks the above is wrong, if request is for write op, the buffer
should be readable & !writeable.

IO_IMU_WRITEABLE is supposed to mean the buffer is writeable, isn't it?

> +
> +	bvec = imu->bvec;
> +	rq_for_each_bvec(bv, rq, rq_iter)
> +		*bvec++ = bv;
> +
> +	node->buf = imu;
> +	data->nodes[index] = node;
> +unlock:
> +	io_ring_submit_unlock(ctx, issue_flags);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> +
> +void io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
> +			       unsigned int issue_flags)
> +{
> +	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
> +	struct io_rsrc_data *data = &ctx->buf_table;
> +	struct io_rsrc_node *node;
> +
> +	io_ring_submit_lock(ctx, issue_flags);
> +	if (index >= data->nr)
> +		goto unlock;
> +	index = array_index_nospec(index, data->nr);
> +
> +	node = data->nodes[index];
> +	if (!node || !node->buf->release)
> +		goto unlock;
> +
> +	io_put_rsrc_node(ctx, node);
> +	data->nodes[index] = NULL;
> +unlock:
> +	io_ring_submit_unlock(ctx, issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
> +
>  static int io_import_fixed(int ddir, struct iov_iter *iter,
>  			   struct io_mapped_ubuf *imu,
>  			   u64 buf_addr, size_t len)
> @@ -871,6 +971,8 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>  	/* not inside the mapped region */
>  	if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
>  		return -EFAULT;
> +	if (!(imu->perm & (1 << ddir)))
> +		return -EFAULT;
>  
>  	/*
>  	 * Might not be a start of buffer, set size appropriately
> @@ -883,8 +985,8 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>  		/*
>  		 * Don't use iov_iter_advance() here, as it's really slow for
>  		 * using the latter parts of a big fixed buffer - it iterates
> -		 * over each segment manually. We can cheat a bit here, because
> -		 * we know that:
> +		 * over each segment manually. We can cheat a bit here for user
> +		 * registered nodes, because we know that:
>  		 *
>  		 * 1) it's a BVEC iter, we set it up
>  		 * 2) all bvecs are the same in size, except potentially the
> @@ -898,8 +1000,15 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>  		 */
>  		const struct bio_vec *bvec = imu->bvec;
>  
> +		/*
> +		 * Kernel buffer bvecs, on the other hand, don't necessarily
> +		 * have the size property of user registered ones, so we have
> +		 * to use the slow iter advance.
> +		 */
>  		if (offset < bvec->bv_len) {
>  			iter->iov_offset = offset;
> +		} else if (imu->release) {
> +			iov_iter_advance(iter, offset);
>  		} else {
>  			unsigned long seg_skip;
>  
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index f0e9080599646..64bf35667cf9c 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -20,6 +20,11 @@ struct io_rsrc_node {
>  	};
>  };
>  
> +enum {
> +	IO_IMU_READABLE		= 1 << 0,
> +	IO_IMU_WRITEABLE	= 1 << 1,
> +};
> +

The above definition could be wrong too, IO_IMU_READABLE is supposed to
mean that the buffer is readable, but it is aligned with 1 << ITER_DEST.


Thanks,
Ming


