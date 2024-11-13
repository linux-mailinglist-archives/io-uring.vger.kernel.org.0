Return-Path: <io-uring+bounces-4642-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B9AFB9C6A80
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 09:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 412FD1F23007
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 08:22:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E13B178CE4;
	Wed, 13 Nov 2024 08:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DCUPb80N"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342CA170A03
	for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 08:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731486125; cv=none; b=f+TUjcHhv6j6DYf7dA3eqnJpOO/KAW76slAXaydJG7IiBK4z/HLM2/No1LuNWyZiMHjbUhBCROz6lVCVRpmBQDbwGBOH+FYb15maM0GoaxUDxW0js6r13wAewh36RWLLtu+tHZ9sW14Qx449HfjwEiLRFX2pLfpGUi5WngZaVCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731486125; c=relaxed/simple;
	bh=ihU4653sS88XlDZKcGYKS8GTplbffqyofHAFf53OIF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nt4jn2oyaO2jTHcpjph+ZIPVKhY7LOaOD0/xbcKFrChzhg1o9VGOi2ZVS3JY9pB38QE4l6q/iGJHbVmzf5STv6DBJ9FqjAZI2+c5eQjgLfvTgzk2DCTOVJqXklUZOnT7FYiSJ1jDLOxRg6UnF8r6EB4o62GFD+eXDZyuao1q+V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DCUPb80N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731486122;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w+wTOgJUYwCWQeKYvlbfUw3Q/3AETGabYnZ3FOdO2IA=;
	b=DCUPb80N0c/cAxUC00cCtZdBdgyVcM8mJWVmQrGr4tdfFGvMHzbh+gzQiT/lDHwbzD8xrc
	nJYUiEB+b0MJuZCvmfMGgLAiDN+QmKBzVxZ1QNvsunYVxvAshIiM0eGPJLGYE1CZakRohI
	iwpJ8Y1KZDc3z+ZIJDC2WWXZ/ORTbPk=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-136-PZpHsZcIORGCu7BmwY6FTQ-1; Wed,
 13 Nov 2024 03:21:58 -0500
X-MC-Unique: PZpHsZcIORGCu7BmwY6FTQ-1
X-Mimecast-MFC-AGG-ID: PZpHsZcIORGCu7BmwY6FTQ
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7DE2D1955EE7;
	Wed, 13 Nov 2024 08:21:57 +0000 (UTC)
Received: from fedora (unknown [10.72.116.65])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D947119560A3;
	Wed, 13 Nov 2024 08:21:53 +0000 (UTC)
Date: Wed, 13 Nov 2024 16:21:48 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, ming.lei@redhat.com
Subject: Re: [RFC 2/3] io_uring/bpf: allow to register and run BPF programs
Message-ID: <ZzRhnDXxkahNB0rx@fedora>
References: <cover.1731285516.git.asml.silence@gmail.com>
 <cffec449e9f6a37b0701f2a8fdd37688db25be55.1731285516.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cffec449e9f6a37b0701f2a8fdd37688db25be55.1731285516.git.asml.silence@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Mon, Nov 11, 2024 at 01:50:45AM +0000, Pavel Begunkov wrote:
> Let the user to register a BPF_PROG_TYPE_IOURING BPF program to a ring.
> The progrma will be run in the waiting loop every time something
> happens, i.e. the task was woken up by a task_work / signal / etc.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  include/linux/io_uring_types.h |  4 +++
>  include/uapi/linux/io_uring.h  |  9 +++++
>  io_uring/bpf.c                 | 63 ++++++++++++++++++++++++++++++++++
>  io_uring/bpf.h                 | 41 ++++++++++++++++++++++
>  io_uring/io_uring.c            | 15 ++++++++
>  io_uring/register.c            |  7 ++++
>  6 files changed, 139 insertions(+)
>  create mode 100644 io_uring/bpf.h
> 
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index ad5001102c86..50cee0d3622e 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -8,6 +8,8 @@
>  #include <linux/llist.h>
>  #include <uapi/linux/io_uring.h>
>  
> +struct io_bpf_ctx;
> +
>  enum {
>  	/*
>  	 * A hint to not wake right away but delay until there are enough of
> @@ -246,6 +248,8 @@ struct io_ring_ctx {
>  
>  		enum task_work_notify_mode	notify_method;
>  		unsigned			sq_thread_idle;
> +
> +		struct io_bpf_ctx		*bpf_ctx;
>  	} ____cacheline_aligned_in_smp;
>  
>  	/* submission data */
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index ba373deb8406..f2c2fefc8514 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -634,6 +634,8 @@ enum io_uring_register_op {
>  	/* register fixed io_uring_reg_wait arguments */
>  	IORING_REGISTER_CQWAIT_REG		= 34,
>  
> +	IORING_REGISTER_BPF			= 35,
> +
>  	/* this goes last */
>  	IORING_REGISTER_LAST,
>  
> @@ -905,6 +907,13 @@ enum io_uring_socket_op {
>  	SOCKET_URING_OP_SETSOCKOPT,
>  };
>  
> +struct io_uring_bpf_reg {
> +	__u64		prog_fd;
> +	__u32		flags;
> +	__u32		resv1;
> +	__u64		resv2[2];
> +};
> +
>  #ifdef __cplusplus
>  }
>  #endif
> diff --git a/io_uring/bpf.c b/io_uring/bpf.c
> index 6eb0c47b4aa9..8b7c74761c63 100644
> --- a/io_uring/bpf.c
> +++ b/io_uring/bpf.c
> @@ -1,6 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
>  #include <linux/bpf.h>
> +#include <linux/filter.h>
> +
> +#include "bpf.h"
>  
>  static const struct bpf_func_proto *
>  io_bpf_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> @@ -22,3 +25,63 @@ const struct bpf_verifier_ops bpf_io_uring_verifier_ops = {
>  	.get_func_proto			= io_bpf_func_proto,
>  	.is_valid_access		= io_bpf_is_valid_access,
>  };
> +
> +int io_run_bpf(struct io_ring_ctx *ctx)
> +{
> +	struct io_bpf_ctx *bc = ctx->bpf_ctx;
> +	int ret;
> +
> +	mutex_lock(&ctx->uring_lock);
> +	ret = bpf_prog_run_pin_on_cpu(bc->prog, bc);
> +	mutex_unlock(&ctx->uring_lock);
> +	return ret;
> +}
> +
> +int io_unregister_bpf(struct io_ring_ctx *ctx)
> +{
> +	struct io_bpf_ctx *bc = ctx->bpf_ctx;
> +
> +	if (!bc)
> +		return -ENXIO;
> +	bpf_prog_put(bc->prog);
> +	kfree(bc);
> +	ctx->bpf_ctx = NULL;
> +	return 0;
> +}
> +
> +int io_register_bpf(struct io_ring_ctx *ctx, void __user *arg,
> +		    unsigned int nr_args)
> +{
> +	struct __user io_uring_bpf_reg *bpf_reg_usr = arg;
> +	struct io_uring_bpf_reg bpf_reg;
> +	struct io_bpf_ctx *bc;
> +	struct bpf_prog *prog;
> +
> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
> +		return -EOPNOTSUPP;
> +
> +	if (nr_args != 1)
> +		return -EINVAL;
> +	if (copy_from_user(&bpf_reg, bpf_reg_usr, sizeof(bpf_reg)))
> +		return -EFAULT;
> +	if (bpf_reg.flags || bpf_reg.resv1 ||
> +	    bpf_reg.resv2[0] || bpf_reg.resv2[1])
> +		return -EINVAL;
> +
> +	if (ctx->bpf_ctx)
> +		return -ENXIO;
> +
> +	bc = kzalloc(sizeof(*bc), GFP_KERNEL);
> +	if (!bc)
> +		return -ENOMEM;
> +
> +	prog = bpf_prog_get_type(bpf_reg.prog_fd, BPF_PROG_TYPE_IOURING);
> +	if (IS_ERR(prog)) {
> +		kfree(bc);
> +		return PTR_ERR(prog);
> +	}
> +
> +	bc->prog = prog;
> +	ctx->bpf_ctx = bc;
> +	return 0;
> +}
> diff --git a/io_uring/bpf.h b/io_uring/bpf.h
> new file mode 100644
> index 000000000000..2b4e555ff07a
> --- /dev/null
> +++ b/io_uring/bpf.h
> @@ -0,0 +1,41 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#ifndef IOU_BPF_H
> +#define IOU_BPF_H
> +
> +#include <linux/io_uring/bpf.h>
> +#include <linux/io_uring_types.h>
> +
> +struct bpf_prog;
> +
> +struct io_bpf_ctx {
> +	struct io_bpf_ctx_kern kern;
> +	struct bpf_prog *prog;
> +};
> +
> +static inline bool io_bpf_enabled(struct io_ring_ctx *ctx)
> +{
> +	return IS_ENABLED(CONFIG_BPF) && ctx->bpf_ctx != NULL;
> +}
> +
> +#ifdef CONFIG_BPF
> +int io_register_bpf(struct io_ring_ctx *ctx, void __user *arg,
> +		    unsigned int nr_args);
> +int io_unregister_bpf(struct io_ring_ctx *ctx);
> +int io_run_bpf(struct io_ring_ctx *ctx);
> +
> +#else
> +static inline int io_register_bpf(struct io_ring_ctx *ctx, void __user *arg,
> +				  unsigned int nr_args)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline int io_unregister_bpf(struct io_ring_ctx *ctx)
> +{
> +	return -EOPNOTSUPP;
> +}
> +static inline int io_run_bpf(struct io_ring_ctx *ctx)
> +{
> +}
> +#endif
> +
> +#endif
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index f34fa1ead2cf..82599e2a888a 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -104,6 +104,7 @@
>  #include "rw.h"
>  #include "alloc_cache.h"
>  #include "eventfd.h"
> +#include "bpf.h"
>  
>  #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
>  			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
> @@ -2834,6 +2835,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>  
>  	io_napi_busy_loop(ctx, &iowq);
>  
> +	if (io_bpf_enabled(ctx)) {
> +		ret = io_run_bpf(ctx);
> +		if (ret == IOU_BPF_RET_STOP)
> +			return 0;
> +	}
> +
>  	trace_io_uring_cqring_wait(ctx, min_events);
>  	do {
>  		unsigned long check_cq;
> @@ -2879,6 +2886,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
>  		if (ret < 0)
>  			break;
>  
> +		if (io_bpf_enabled(ctx)) {
> +			ret = io_run_bpf(ctx);
> +			if (ret == IOU_BPF_RET_STOP)
> +				break;
> +			continue;
> +		}

I believe 'struct_ops' is much simpler to run the prog and return the result.
Then you needn't any bpf core change and the bpf register code.


Thanks,
Ming


