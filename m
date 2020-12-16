Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C392DC32A
	for <lists+io-uring@lfdr.de>; Wed, 16 Dec 2020 16:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726502AbgLPPd6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Dec 2020 10:33:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbgLPPd6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Dec 2020 10:33:58 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C7A5C061794
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 07:33:17 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d26so10367430wrb.12
        for <io-uring@vger.kernel.org>; Wed, 16 Dec 2020 07:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mdsB10UHCVb5/z+fyBCsUFtPvub1mtdWzfgz5sz6fBg=;
        b=JEo6EXywg14vaY1P/DryFB03xp+/iN0MvxA0zU9iLPPJxfW3puwqlgPM8Sn3yvXTnr
         EZYzl2CeNQ0ojyEBJgoSslGIljxEAj+cH/VJiEXQiX5NsR1r6Lxr5V4Q/nWlRvvgvrfF
         e3qjpP30nmM1xINFoTZcbz+W8x0lLgkZmchTYCLKBWCk0he8lMGi286rymNZns5T9eUu
         m6YAsfMs+4StWKRdBgLB01Oq8DTSGLCTuef1oKYw28dyY7qtgSVuNmHEjHjsGVt8Zs9D
         q1lqEzkiIksRhQrrkJAcWOQn1xpJWoWUTQD70jV0A7y1BKCA+uDeZu9hO/sBC3U9rH9p
         Cf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mdsB10UHCVb5/z+fyBCsUFtPvub1mtdWzfgz5sz6fBg=;
        b=eEalrEsDO7+9YWD1Fm0r/3rYBK/2AKtAn+nNmtxqQOZvGjXPQqMHUy9FdwGdVyBRwt
         TPFhJimP4y9aBl9TjZ0jHsWTvkOBsRHUgD/AxqAm1jdNTRDSZJF4QYDwd8yLA7jSqwAC
         ctt5W2avCVkHzGUxGn1RoiMFFzXXgWtKIWMhybkUWSsXodD3A8Lm9LppZ2loV2vjGdEp
         BNljj33HJ31WfNWAi5yxURHDiifIYExqOwj0GHKOXXgcU6qrFQ7wL7cj1IfrehgxFc00
         Tx0RAJxjeTBo9r6vHyI5WDSGnM5eFpiQQrO093HZmS7ig/BiRo47z1zqSbC9qVrj3tAi
         f2mA==
X-Gm-Message-State: AOAM5333aK0/iZ1tikMqwZc+NYBATGddEqLabNRnF/r9DlKig5MRxIMg
        8TobVIG5O5qnBCkHxrXxyG/C9PxnTV0rew==
X-Google-Smtp-Source: ABdhPJxGsC4J+0Gl2sXn11URNLx2lttN3PmCt0xYmsZXI61l3ZmFg8sLEh09+coVCQQ2aXI5qQNwow==
X-Received: by 2002:a5d:4683:: with SMTP id u3mr39341046wrq.19.1608132795899;
        Wed, 16 Dec 2020 07:33:15 -0800 (PST)
Received: from [192.168.8.128] ([185.69.144.225])
        by smtp.gmail.com with ESMTPSA id r1sm3686104wrl.95.2020.12.16.07.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 07:33:15 -0800 (PST)
To:     Bijan Mottahedeh <bijan.mottahedeh@oracle.com>, axboe@kernel.dk,
        io-uring@vger.kernel.org
References: <1607379352-68109-1-git-send-email-bijan.mottahedeh@oracle.com>
 <1607379352-68109-14-git-send-email-bijan.mottahedeh@oracle.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2 13/13] io_uring: support buffer registration sharing
Message-ID: <ff17d576-27eb-9008-d858-e1ebb7c93dad@gmail.com>
Date:   Wed, 16 Dec 2020 15:29:55 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1607379352-68109-14-git-send-email-bijan.mottahedeh@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/12/2020 22:15, Bijan Mottahedeh wrote:
> Implement buffer sharing among multiple rings.
> 
> A ring shares its (future) buffer registrations at setup time with
> IORING_SETUP_SHARE_BUF. A ring attaches to another ring's buffer
> registration at setup time with IORING_SETUP_ATTACH_BUF, after
> authenticating with the buffer registration owner's fd. Any updates to
> the owner's buffer registrations become immediately available to the
> attached rings.
> 
> Signed-off-by: Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
> ---
>  fs/io_uring.c                 | 85 +++++++++++++++++++++++++++++++++++++++++--
>  include/uapi/linux/io_uring.h |  2 +
>  2 files changed, 83 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 479a6b9..b75cbd7 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -8408,6 +8408,12 @@ static void io_buffers_map_free(struct io_ring_ctx *ctx)
>  	ctx->nr_user_bufs = 0;
>  }
>  
> +static void io_detach_buf_data(struct io_ring_ctx *ctx)
> +{
> +	percpu_ref_put(&ctx->buf_data->refs);
> +	ctx->buf_data = NULL;
> +}
> +
>  static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
>  {
>  	struct fixed_rsrc_data *data = ctx->buf_data;
> @@ -8415,6 +8421,12 @@ static int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
>  	if (!data)
>  		return -ENXIO;
>  
> +	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
> +		io_detach_buf_data(ctx);
> +		ctx->nr_user_bufs = 0;

nr_user_bufs is a part of invariant and should stay together with
stuff in io_detach_buf_data().

> +		return 0;
> +	}
> +
>  	io_rsrc_ref_quiesce(data, ctx);
>  	io_buffers_unmap(ctx);
>  	io_buffers_map_free(ctx);
> @@ -8660,9 +8672,13 @@ static struct fixed_rsrc_data *io_buffers_map_alloc(struct io_ring_ctx *ctx,
>  	if (!nr_args || nr_args > IORING_MAX_FIXED_BUFS)
>  		return ERR_PTR(-EINVAL);
>  
> -	buf_data = alloc_fixed_rsrc_data(ctx);
> -	if (IS_ERR(buf_data))
> -		return buf_data;
> +	if (ctx->buf_data) {
> +		buf_data = ctx->buf_data;
> +	} else {
> +		buf_data = alloc_fixed_rsrc_data(ctx);
> +		if (IS_ERR(buf_data))
> +			return buf_data;
> +	}
>  
>  	nr_tables = DIV_ROUND_UP(nr_args, IORING_MAX_BUFS_TABLE);
>  	buf_data->table = kcalloc(nr_tables, sizeof(*buf_data->table),
> @@ -8724,9 +8740,17 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  	struct fixed_rsrc_ref_node *ref_node;
>  	struct fixed_rsrc_data *buf_data;
>  
> +	if (ctx->flags & IORING_SETUP_ATTACH_BUF) {
> +		if (!ctx->buf_data)
> +			return -EFAULT;
> +		ctx->nr_user_bufs = ctx->buf_data->ctx->nr_user_bufs;

Why? Once a table is initialised it shouldn't change its size, would
be racy otherwise.

> +		return 0;
> +	}
> +
>  	buf_data = io_buffers_map_alloc(ctx, nr_args);
>  	if (IS_ERR(buf_data))
>  		return PTR_ERR(buf_data);
> +	ctx->buf_data = buf_data;

Wanted to write that there is missing
`if (ctx->user_bufs) return -EBUSY`

but apparently it was moved into io_buffers_map_alloc().
I'd really prefer to have it here.

>  
>  	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
>  		struct fixed_rsrc_table *table;
> @@ -8754,7 +8778,6 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
>  			break;
>  	}
>  
> -	ctx->buf_data = buf_data;
>  	if (ret) {
>  		io_sqe_buffers_unregister(ctx);
>  		return ret;
> @@ -9783,6 +9806,55 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
>  	return ret;
>  }
>  
> +static int io_attach_buf_data(struct io_ring_ctx *ctx,
> +			      struct io_uring_params *p)
> +{
> +	struct io_ring_ctx *ctx_attach;
> +	struct fd f;
> +
> +	f = fdget(p->wq_fd);
> +	if (!f.file)
> +		return -EBADF;
> +	if (f.file->f_op != &io_uring_fops) {
> +		fdput(f);
> +		return -EINVAL;
> +	}
> +
> +	ctx_attach = f.file->private_data;
> +	if (!ctx_attach->buf_data) {

It looks racy. What prevents it from being deleted while we're
working on it, e.g. by io_sqe_buffers_unregister?

> +		fdput(f);
> +		return -EINVAL;
> +	}
> +	ctx->buf_data = ctx_attach->buf_data;

Before updates, etc. (e.g. __io_sqe_buffers_update()) were synchronised
by uring_lock, now it's modified concurrently, that looks to be really
racy.

> +
> +	percpu_ref_get(&ctx->buf_data->refs);

Ok, now the original io_uring instance will wait until the attached
once get rid of their references. That's a versatile ground to have
in kernel deadlocks.

task1: uring1 = create()
task2: uring2 = create()
task1: uring3 = create(share=uring2);
task2: uring4 = create(share=uring1);

task1: io_sqe_buffers_unregister(uring1)
task2: io_sqe_buffers_unregister(uring2)

If I skimmed through the code right, that should hang unkillably.

> +	fdput(f);
> +	return 0;
> +}
> +
> +static int io_init_buf_data(struct io_ring_ctx *ctx, struct io_uring_params *p)
> +{
> +	if ((p->flags & (IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF)) ==
> +	    (IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF))
> +		return -EINVAL;
> +
> +	if (p->flags & IORING_SETUP_SHARE_BUF) {
> +		struct fixed_rsrc_data *buf_data;
> +
> +		buf_data = alloc_fixed_rsrc_data(ctx);
> +		if (IS_ERR(buf_data))
> +			return PTR_ERR(buf_data);
> +
> +		ctx->buf_data = buf_data;
> +		return 0;
> +	}
> +
> +	if (p->flags & IORING_SETUP_ATTACH_BUF)
> +		return io_attach_buf_data(ctx, p);
> +
> +	return 0;
> +}
> +
>  static int io_uring_create(unsigned entries, struct io_uring_params *p,
>  			   struct io_uring_params __user *params)
>  {
> @@ -9897,6 +9969,10 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
>  	if (ret)
>  		goto err;
>  
> +	ret = io_init_buf_data(ctx, p);
> +	if (ret)
> +		goto err;
> +
>  	ret = io_sq_offload_create(ctx, p);
>  	if (ret)
>  		goto err;
> @@ -9968,6 +10044,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
>  	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
>  			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
>  			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
> +			IORING_SETUP_SHARE_BUF | IORING_SETUP_ATTACH_BUF |
>  			IORING_SETUP_R_DISABLED))
>  		return -EINVAL;
>  
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 0d9ac12..2366126 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -98,6 +98,8 @@ enum {
>  #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
>  #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
>  #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
> +#define IORING_SETUP_SHARE_BUF	(1U << 7)	/* share buffer registration */
> +#define IORING_SETUP_ATTACH_BUF	(1U << 8)	/* attach buffer registration */
>  
>  enum {
>  	IORING_OP_NOP,
> 

-- 
Pavel Begunkov
