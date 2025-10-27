Return-Path: <io-uring+bounces-10232-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD59AC0CEE9
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 11:21:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D94DB3BBD38
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 10:21:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 91166134BD;
	Mon, 27 Oct 2025 10:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S6I3Puzr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C74772E7641
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 10:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761560460; cv=none; b=Ajd0TSl0ag62uELBMxuJuNFMHadqafsJtxqBKoLUgxiFEJitQ934PP3sHZ14aiIXePnem/I/2Ts8ZBNk+LTDLwiKWK/9F/4Ecnz2U8cc5aWtfq57TSIz3WE5UcsEi8tBhe0wnNWNOk5a59M18VfJocVczk3QoNqKOqdMKSCLsis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761560460; c=relaxed/simple;
	bh=toQgS67ot2N3ttq9tOsTM0yxNbU2cTJE8tiKFXoCW4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=epiVaWT0ieFa24pniXazpJWtJNf5+oL6RB8F1jMKxpQSVyL0MxhEI7csJVYPuM4zWrnSM6SK781PHK3fMZdlEC0fQw9j11vtSdkbO/zGXqQ7yRSqq/1w/fY4lAn3yujV5FuGkm+IXf3RD3JyweJTJHl170eePAB08/fbD7E7B0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S6I3Puzr; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4710683a644so37023365e9.0
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 03:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761560457; x=1762165257; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JroMOoM6Bg6YWyT/VlU2qQEQ1ZsC7Sk0UZbauoAsOzA=;
        b=S6I3Puzr6O+/FgDsw6zpNGUJOUBuzHErG50AGavh3OrcLkhTKIV88lGc/qZjbrSZKs
         GQ8VN98sY0XeUBnwSJHAGw6jIDyyyVc49NUBD+HTek+orlVfhrxhZrGx/Yg+oDraKQ6j
         vezqrFgF9lHs4XS8G+RERkqa4qR0udR8bscYWg7j/Ie7P4TtcfeXIHiY9PWb3P/4YDEF
         r63+keE79RkEM+jR1e8QfPT4sSOvXoG+IIz+baATdsUcXQy9y6a8ccgw1isG+4qTc6su
         k525RfNFwh4k5ML4PGulfgPw57fB2xQXSLuiYwqRLmQh5dlA/u9C7+sCuQpHVyM9+5FR
         EQJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761560457; x=1762165257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JroMOoM6Bg6YWyT/VlU2qQEQ1ZsC7Sk0UZbauoAsOzA=;
        b=gzRLdmnGRYnCv8f5fY11cQq4IxEK2APscwMAkd9Nz4VfcwCHc65nsu8698YCl+3xgi
         etmPpaGQmtIOK3EGjSE76mZzTi2R8ZPEW2bPjWTLD2fg90JjjbEBqoHlc0Y+U/8hmE0p
         FJllPH1hC6xEOhE6WF4rYHTmgA/WMjvr9QLMz/Bj0Pmw+EkhY7WIsx6EuWEE/INDViu/
         2UF85wPk/Kp706VxP7UJegPxlErgIlbrlmtHbkAVggjt+Mi1s5h7wvhzVap16dtXDmqS
         yaFN5+cdlertSu3Kg1MZURYNZ39WNEbINKGLPYiWGN42XIbUMa9TsvRhDNSFVG1A1m2U
         BpxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDF+6dj5e9WddqNJDic07lbDJS6tcWI7nV36iHy/+4w9S3MbePkBEygP6kJkgarh7Nw6o7In0/OQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwOD4LEEPMkuxkTHvn0Hu8fZrpKN5cJbCytlV67LsyDERg6Oy5i
	qP4BSGR2rVLexxB8Xf8d5BcG0yGGK/DyVVXLzxed4CnBKfjY7Pce3q9QB8XuCA==
X-Gm-Gg: ASbGncs/r9jlSPio25R7pYq1KlI/hkteZzDqYz4wFIGxxWxSrXjjlJu0ThhNn7No1gb
	FgHYYiBhcw9be6oqTZd1OG8ZGgxryke/oyG85lw6Q6EJa9Wsy0fqlgX4lIGZEMJzzvW7K59noCQ
	bzo++I1dri3U+0ZqIOcp6087+0Bf/Rn/qDve+iFb/CMsud5eCuZGMF6ySQPVzfxJzp2V6c+AXnr
	a2NrfCMZnza3qeGBfBN1JQMBGo/rT8SSMCwDrOjvn6lGSHpVi2yo22ecXH3y/AvHNGCLnISX1Ad
	EftM0aUfDywL5FJ2+DLlGsmN+LEmIZybuZLxaJP5BM7F8KKfXsHg7mYeDvoE0U6+TFQZydYJrra
	BkEzi67TcJI3/ooBNs+EutLOLAFtBB5FSEOX9L79aA0TrILyrE46MdaTT3NX3l0VWRpisjWYZZw
	HUAuxfcpBUoCYzfMyfAiK6lKcvn9R5e6gYCjBP8QOn9Xw=
X-Google-Smtp-Source: AGHT+IHRe3YZsHwDWAV/oXn9xv2gNy0FhGVkettJ/O2VOfF8GFFc8cAZ+MBefybartISs6EDu7fJiA==
X-Received: by 2002:a05:600c:8717:b0:45f:29eb:2148 with SMTP id 5b1f17b1804b1-475d241e319mr84979845e9.7.1761560456942;
        Mon, 27 Oct 2025 03:20:56 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:8b1a])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952d5678sm13410422f8f.22.2025.10.27.03.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 03:20:56 -0700 (PDT)
Message-ID: <309cb5ce-b19a-47b8-ba82-e75f69fe5bb3@gmail.com>
Date: Mon, 27 Oct 2025 10:20:54 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] io_uring/zcrx: share an ifq between rings
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
References: <20251026173434.3669748-1-dw@davidwei.uk>
 <20251026173434.3669748-4-dw@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20251026173434.3669748-4-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/26/25 17:34, David Wei wrote:
> Add a way to share an ifq from a src ring that is real i.e. bound to a
> HW RX queue with other rings. This is done by passing a new flag
> IORING_ZCRX_IFQ_REG_SHARE in the registration struct
> io_uring_zcrx_ifq_reg, alongside the fd of the src ring and the ifq id
> to be shared.
> 
> To prevent the src ring or ifq from being cleaned up or freed while
> there are still shared ifqs, take the appropriate refs on the src ring
> (ctx->refs) and src ifq (ifq->refs).
> 
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>   include/uapi/linux/io_uring.h |  4 ++
>   io_uring/zcrx.c               | 74 ++++++++++++++++++++++++++++++++++-
>   2 files changed, 76 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> index 04797a9b76bc..4da4552a4215 100644
> --- a/include/uapi/linux/io_uring.h
> +++ b/include/uapi/linux/io_uring.h
> @@ -1063,6 +1063,10 @@ struct io_uring_zcrx_area_reg {
>   	__u64	__resv2[2];
>   };
>   
> +enum io_uring_zcrx_ifq_reg_flags {
> +	IORING_ZCRX_IFQ_REG_SHARE	= 1,
> +};
> +
>   /*
>    * Argument for IORING_REGISTER_ZCRX_IFQ
>    */
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 569cc0338acb..7418c959390a 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -22,10 +22,10 @@
>   #include <uapi/linux/io_uring.h>
>   
>   #include "io_uring.h"
> -#include "kbuf.h"
>   #include "memmap.h"
>   #include "zcrx.h"
>   #include "rsrc.h"
> +#include "register.h"
>   
>   #define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
>   
> @@ -541,6 +541,67 @@ struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
>   	return ifq ? &ifq->region : NULL;
>   }
>   
> +static int io_share_zcrx_ifq(struct io_ring_ctx *ctx,
> +			     struct io_uring_zcrx_ifq_reg __user *arg,
> +			     struct io_uring_zcrx_ifq_reg *reg)
> +{
> +	struct io_ring_ctx *src_ctx;
> +	struct io_zcrx_ifq *src_ifq;
> +	struct file *file;
> +	int src_fd, ret;
> +	u32 src_id, id;
> +
> +	src_fd = reg->if_idx;
> +	src_id = reg->if_rxq;
> +
> +	file = io_uring_register_get_file(src_fd, false);
> +	if (IS_ERR(file))
> +		return PTR_ERR(file);
> +
> +	src_ctx = file->private_data;
> +	if (src_ctx == ctx)
> +		return -EBADFD;
> +
> +	mutex_unlock(&ctx->uring_lock);
> +	io_lock_two_rings(ctx, src_ctx);
> +
> +	ret = -EINVAL;
> +	src_ifq = xa_load(&src_ctx->zcrx_ctxs, src_id);
> +	if (!src_ifq)
> +		goto err_unlock;
> +
> +	percpu_ref_get(&src_ctx->refs);
> +	refcount_inc(&src_ifq->refs);
> +
> +	scoped_guard(mutex, &ctx->mmap_lock) {
> +		ret = xa_alloc(&ctx->zcrx_ctxs, &id, NULL, xa_limit_31b, GFP_KERNEL);
> +		if (ret)
> +			goto err_unlock;
> +
> +		ret = -ENOMEM;
> +		if (xa_store(&ctx->zcrx_ctxs, id, src_ifq, GFP_KERNEL)) {
> +			xa_erase(&ctx->zcrx_ctxs, id);
> +			goto err_unlock;
> +		}

It's just xa_alloc(..., src_ifq, ...);

> +	}
> +
> +	reg->zcrx_id = id;
> +	if (copy_to_user(arg, reg, sizeof(*reg))) {
> +		ret = -EFAULT;
> +		goto err;
> +	}

Better to do that before publishing zcrx into ctx->zcrx_ctxs

> +	mutex_unlock(&src_ctx->uring_lock);
> +	fput(file);
> +	return 0;
> +err:
> +	scoped_guard(mutex, &ctx->mmap_lock)
> +		xa_erase(&ctx->zcrx_ctxs, id);
> +err_unlock:
> +	mutex_unlock(&src_ctx->uring_lock);
> +	fput(file);
> +	return ret;
> +}
> +
>   int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>   			  struct io_uring_zcrx_ifq_reg __user *arg)
>   {
> @@ -566,6 +627,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>   		return -EINVAL;
>   	if (copy_from_user(&reg, arg, sizeof(reg)))
>   		return -EFAULT;
> +	if (reg.flags & IORING_ZCRX_IFQ_REG_SHARE)
> +		return io_share_zcrx_ifq(ctx, arg, &reg);
>   	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
>   		return -EFAULT;
>   	if (!mem_is_zero(&reg.__resv, sizeof(reg.__resv)) ||
> @@ -663,7 +726,7 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
>   			if (ifq)
>   				xa_erase(&ctx->zcrx_ctxs, id);
>   		}
> -		if (!ifq)
> +		if (!ifq || ctx != ifq->ctx)
>   			break;
>   		io_zcrx_ifq_free(ifq);
>   	}
> @@ -734,6 +797,13 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>   		if (xa_get_mark(&ctx->zcrx_ctxs, index, XA_MARK_0))
>   			continue;
>   
> +		/*
> +		 * Only shared ifqs want to put ctx->refs on the owning ifq
> +		 * ring. This matches the get in io_share_zcrx_ifq().
> +		 */
> +		if (ctx != ifq->ctx)
> +			percpu_ref_put(&ifq->ctx->refs);

After you put this and ifq->refs below down, the zcrx object can get
destroyed, but this ctx might still have requests using the object.
Waiting on ctx refs would ensure requests are killed, but that'd
create a cycle.

> +
>   		/* Safe to clean up from any ring. */
>   		if (refcount_dec_and_test(&ifq->refs)) {
>   			io_zcrx_scrub(ifq);

-- 
Pavel Begunkov


