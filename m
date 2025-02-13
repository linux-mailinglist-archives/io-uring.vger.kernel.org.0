Return-Path: <io-uring+bounces-6400-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A9FCA334BA
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 02:32:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 923431888494
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 01:32:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA53A73451;
	Thu, 13 Feb 2025 01:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V2wvvURU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5B71A29A;
	Thu, 13 Feb 2025 01:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739410346; cv=none; b=KEsO/dPyEz0T2uZFBKdmD18dZCs7/8kTzQmm5yVC1b4vXPRphNcwdqSm5yKb3+Jz8J1tvvUMK1N2RcF0JPJyQHzZveQm2qtksjoL/Bzxgkn7uhIeKnRsCV1NFSl/DJbDggUSJRkPYdxSL28SfpyxWrRDFBPzlfyMXd4KqF0HJz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739410346; c=relaxed/simple;
	bh=eYq5snAc4CPbq5X0MsD3NF+O7tI+AMGOUfSTDvyNMB0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dovC69yJXHMyjZqJkj4yXM4L6Zpl2JH9UGAj+KsLrK/S4oFWPnD3VnGbVy6jI8sdmx/dPqScyYVSnkw9yUqcZBiA3EZNNxusEFcROkQB9Doqbq9JjCHeOOedtKxNTRBYRIrzLs24jq3AOygac/BNULQPs5PIZUc0BjH8tMHh5N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V2wvvURU; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43690d4605dso2094345e9.0;
        Wed, 12 Feb 2025 17:32:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739410343; x=1740015143; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N3Jv5E/SftioBqYWCKDATR4YbuubJCF8OC6e7DGYQD0=;
        b=V2wvvURUU7XpkQmzv9Chmg0gUl+TPqgHRMADyn5y9v94sxevKjNPIABK4n4T6P0qDA
         ilUGjaK1pZuEqKxXQ1FgBIAfiTWWBNB6bs3pjI1fCJPo7Y+qiNX4v0xx67Z4AUeVdCek
         BIx3gT4GTjSVc4onCuIYqZCycHskYudBCTfD83yzk0iCVqiYOO4QzzYDK/2xtL1ob6zR
         0NsMElB4yjAko4efTLfJVhTaQZCqphx0aLpFeDNXvBcYIZR07E2qD8N8G9kjJ+hBL34V
         /vGi+VRsnCMJLZIwLuOZhLeLmMOrsgnG6UfOV9hWgUwD58AAB3LyD3ztvjhh39BexX2F
         3sPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739410343; x=1740015143;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N3Jv5E/SftioBqYWCKDATR4YbuubJCF8OC6e7DGYQD0=;
        b=HDsLc5eIJqQkzQ9jONQ94zzKR6aEp2jms+/eBWGZtxwf6CnrR/ycCtUo1meWWM6AkK
         sMhXpts1VtKHzu2oJIvKhJj8oyIvjKzCxB489pZipck8LvIsSOhs1gjxRd/6MJOZzNVW
         FMXiS4mMwe29GDldYCXXcOgazJPBVkPkpK4FXDQF1N4LNUaoDZy8qTiTBNN0bn+GrYU1
         l+9YwIJbQ//8g9NnSese+r2L9Vl+Ph7E90rAU5Ch6+4xSzaE9Od18v3RxBTHjdAJViwq
         ITyW5G1g3fmPrg7fixmQ2z/zhGrvLPtAgmSP6NirZKrWLbpjPzUqj2HaXrdchiM7ULA7
         Ku0w==
X-Forwarded-Encrypted: i=1; AJvYcCVSRIwQkLUz4GiBofv31Av1wWRHZEkO1kI4SFkAcDZs6AjRM9WXpBYZDeF8dZD8qBZJ1f4CXBcFRA==@vger.kernel.org, AJvYcCVXlkC4+MSR4uBySpkyATw9VgZZ8PQm97U0/j+TYosgUCrSkMGlXhDXptAWTyVocPkFJ0gNvWTDN0fh16I=@vger.kernel.org
X-Gm-Message-State: AOJu0YwynSdHAbelcwWuc1SXcxUPuATm8kRN59VzBb7XMJnKMFIa/k9D
	f9VW2r6I7gHwP3sf6Gq3yev47o/YNIm4hkUExB+AVP/IawwYYeh+
X-Gm-Gg: ASbGncum80CGDXnWiIYo/RROt95ic//rvsshvCfBOwrjm20w8UXiWs4wXrPjtbF3KDe
	yUg7b3wbs+C1wIMIM/A6z48RuSa/68RtnyIQ6ziEbBQMc63gct4icjIp+EIfgYlIHCgqkBUhNBo
	UY3bXr4s+iaKf6MBNaJdq3sP8in8Q5CetParnR+NHsVEimHYzA0yILQMDpu/8SKGBMgC55r6I06
	bnSzMOa+NHcT3B/r2FXLMeKFQTjr5xtpQV/tljQjHKSMD7I3IeX8qO0yXbAVCJ/4+LcGUEDCr6M
	TKPPlU6MO8zXlSNJxnytS6Cx
X-Google-Smtp-Source: AGHT+IHE5u4jdA3FAmPDgh0PpcOP0wC616gNleVa5ZNnYGJcFngxIjt/7xRarpEnN16Y8mfVAk5DoA==
X-Received: by 2002:a05:600c:3b9d:b0:434:f5c0:328d with SMTP id 5b1f17b1804b1-439601a11bbmr13499245e9.23.1739410343104;
        Wed, 12 Feb 2025 17:32:23 -0800 (PST)
Received: from [192.168.8.100] ([148.252.128.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a06d22csm34531135e9.22.2025.02.12.17.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 17:32:21 -0800 (PST)
Message-ID: <3aa45001-1d38-45a2-8541-d7a7e36a75ce@gmail.com>
Date: Thu, 13 Feb 2025 01:33:21 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 3/6] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, Keith Busch <kbusch@kernel.org>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-4-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250211005646.222452-4-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/11/25 00:56, Keith Busch wrote:
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
>   include/linux/io_uring.h       |   1 +
>   include/linux/io_uring_types.h |   4 ++
>   io_uring/rsrc.c                | 100 +++++++++++++++++++++++++++++++--
>   io_uring/rsrc.h                |   1 +
>   4 files changed, 100 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 85fe4e6b275c7..b5637a2aae340 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -5,6 +5,7 @@
>   #include <linux/sched.h>
>   #include <linux/xarray.h>
>   #include <uapi/linux/io_uring.h>
> +#include <linux/blk-mq.h>
>   
>   #if defined(CONFIG_IO_URING)
>   void __io_uring_cancel(bool cancel_all);
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index e2fef264ff8b8..99aac2d52fbae 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -693,4 +693,8 @@ static inline bool io_ctx_cqe32(struct io_ring_ctx *ctx)
>   	return ctx->flags & IORING_SETUP_CQE32;
>   }
>   
> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
> +			    void (*release)(void *), unsigned int index);
> +void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int tag);
> +
>   #endif
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 30f08cf13ef60..14efec8587888 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -110,8 +110,9 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
>   
>   		if (!refcount_dec_and_test(&imu->refs))
>   			return;
> -		for (i = 0; i < imu->nr_bvecs; i++)
> -			unpin_user_page(imu->bvec[i].bv_page);
> +		if (node->type == IORING_RSRC_BUFFER)
> +			for (i = 0; i < imu->nr_bvecs; i++)
> +				unpin_user_page(imu->bvec[i].bv_page);
>   		if (imu->acct_pages)
>   			io_unaccount_mem(ctx, imu->acct_pages);
>   		kvfree(imu);
> @@ -240,6 +241,13 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
>   		struct io_rsrc_node *node;
>   		u64 tag = 0;
>   
> +		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
> +		node = io_rsrc_node_lookup(&ctx->buf_table, i);
> +		if (node && node->type != IORING_RSRC_BUFFER) {

Please drop the special rule. It's handled, so if the user wants
to do it, it can be allowed in a generic way.

> +			err = -EBUSY;
> +			break;
> +		}
> +
...
> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
> +			    void (*release)(void *), unsigned int index)
> +{
> +	struct io_rsrc_data *data = &ctx->buf_table;
> +	struct req_iterator rq_iter;
> +	struct io_mapped_ubuf *imu;
> +	struct io_rsrc_node *node;
> +	struct bio_vec bv;
> +	u16 nr_bvecs;
> +	int i = 0;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	if (!data->nr)
> +		return -EINVAL;
> +	if (index >= data->nr)
> +		return -EINVAL;

array_index_nospec

> +
> +	node = data->nodes[index];
> +	if (node)
> +		return -EBUSY;
...> +void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int index)
> +{
> +	struct io_rsrc_data *data = &ctx->buf_table;
> +	struct io_rsrc_node *node;
> +
> +	lockdep_assert_held(&ctx->uring_lock);
> +
> +	if (!data->nr)
> +		return;
> +	if (index >= data->nr)
> +		return;

array_index_nospec

> +
> +	node = data->nodes[index];
> +	if (!node || !node->buf)

How can node->buf be NULL?

> +		return;
> +	if (node->type != IORING_RSRC_KBUFFER)
> +		return;
> +	io_reset_rsrc_node(ctx, data, index);
> +}
> +EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
...> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index a3826ab84e666..8147dfc26f737 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -13,6 +13,7 @@
>   enum {
>   	IORING_RSRC_FILE		= 0,
>   	IORING_RSRC_BUFFER		= 1,
> +	IORING_RSRC_KBUFFER		= 2,

nit: you don't even need it, just check for presence of the
callback in io_buffer_unmap()

-- 
Pavel Begunkov


