Return-Path: <io-uring+bounces-7983-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 23BF2AB847C
	for <lists+io-uring@lfdr.de>; Thu, 15 May 2025 13:03:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 014237B4062
	for <lists+io-uring@lfdr.de>; Thu, 15 May 2025 11:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C37E41DFDE;
	Thu, 15 May 2025 11:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QEeDjuPW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6D6710E5
	for <io-uring@vger.kernel.org>; Thu, 15 May 2025 11:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747306997; cv=none; b=KU6r3Ydb+Mp9ia7c9HI1hI6TLrL18KYqY+mvNnk1N1dCuzDdZpoHs35BIqETSo5GPvMcEz53vFjaqpXw8AzPAjhGjBTfn8LXMp7JmWufbS592oyGbc8UHcJW8ho+9u4FoGMQSo84rQ+YCCYsyLojgYIdhwll0h3U9Ht8eUGoY14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747306997; c=relaxed/simple;
	bh=t2l2EMFKlYbv3BuzxpL6+3Kn0qXnc+XmAkFQZ7qAaDo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Ntt54OQe2cpxVyiCaeHE7hKX1azpeA0FO247nBcLz3zMlUASUz7iFQGuwEC+EeW/QNWUgsiRE81VooZajkiXxoLXcShisqu/EZog7i99LuLkMQ3yRQuxNZblcIxz/7ZzuloDwcvnDjKfnb5ooK3eTVoQUc8AOm5ZSrxkV7eEyio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QEeDjuPW; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5fc7edf00b2so1260885a12.2
        for <io-uring@vger.kernel.org>; Thu, 15 May 2025 04:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747306994; x=1747911794; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fecx1SDAXBqyFVl8AqUwcjJYWKjHadfw0ioVoKpw2iE=;
        b=QEeDjuPWxIYk5L/kq6jllrsdc/FvWvs6dl2Pc61T7WPLUACBY0dZnI2/O4kvLdyyc5
         hAmXVUdYhQqPpW0Tsx8PuniEh8fDI8Rklk1mXgkyR49RXugjdq2iPQlDxxGFySkoBNeb
         I3oXP2E3Y8mT8ng5gGTUzUnQM9nQv61+JcNDXWJrlkDQF5844u6OFXimGWxnxIHZyyw+
         PfFG8rjqbAcDC1oAgMmxp85BkFf+exbbumkw47bYOcYt/rNu8W/cRgeorETddFdqQfhN
         mkup3aXgx/RGgUyIhPWmPjNCkVKUNIFM+u25HTiwK+0BbXXM1dp+jBuNJEvesvzEYZYs
         ZErw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747306994; x=1747911794;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fecx1SDAXBqyFVl8AqUwcjJYWKjHadfw0ioVoKpw2iE=;
        b=fDX0yzoJMFFB0KvvIxVbf9VcroqFmD9k2TRVMgs/V9QMvKgvi0SlKi8I0E77NDzyi9
         fimGTL8x08hwP19Oh1mOjHx/EMPsjHemOSX5vTVQxPsPIzOYsLFiDWMILlsnmahwSRJq
         Md7mAljX2mgrmi0lPR8cxmIhjjh5mchcVvFRpZ+rNIQqMOiL6omonWX7mCOEU1lTNX3N
         U1v0BEsR5MPEFXIHynWHQ62r3tu+B2YmFcd56oyQmSCug7wQch+UKXWpu3NrKBUzI66d
         9WIMmINS/pEy/VQfc+1ctMiytlnIaH+F4c1hu8LKUMig8eKGFd47GbQZXqKdg1lOJwZx
         MsxA==
X-Forwarded-Encrypted: i=1; AJvYcCWM4/7AA2yWhx0dMEkRd84M01nfIvqxoG5Wcd4+OGR1xF57nR2x1MKDR1DiynBKbAHFZvCXSJGGuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5ruOjrsjhP+xr+DPwKjgjTm06xpJ1MeoW9n8tdS4FLSJaeZVg
	uv46Mo+kD4z+NyCsxlPQDIy4/Hm3MuFUd86gqu87pUKWBygcfkDYG4g86Q==
X-Gm-Gg: ASbGncs6jPgNBroDA6mZggqAoOK/uGysjM8wOqi5XVgE5GawxOXbFNtvla43+Unx+1B
	UyOplbt8mvteC1RNFDMGbFJpMQ42GK2PYrUR3DNpYGjoRFBOzavFVYVZEbqJX8Q6PGgFPJ7gPjS
	UtQZNnTSed94l282scbReY8fnKGv021RbrLA0/VGdKquxwVHg2bf1PrtIl8puQ1cIM0nu+m6klR
	vHMXhonL7RLnEnt7FoiOPxmlch+pvvHCMyg5UUiDOAEm5320+k4yPA+DdUPxBvKrRAt/p8OXoBT
	W82AyBxlIzfITaKIy35bjWjMM9b5tCFFfhZSLUIQ+zr+6Z18ByjNwBPifOg=
X-Google-Smtp-Source: AGHT+IHaram44B9i+SPDmtunStvu5hj0EyGFSZb3vrI3vKv8tEOB1dm/EyvzUTqoU7A3QDSO/Y9OLQ==
X-Received: by 2002:a05:6402:280e:b0:600:7c6:eb28 with SMTP id 4fb4d7f45d1cf-60007c6f198mr659460a12.3.1747306993651;
        Thu, 15 May 2025 04:03:13 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.234.72])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5fe854cc484sm5777973a12.73.2025.05.15.04.03.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 04:03:12 -0700 (PDT)
Message-ID: <f70222a4-b743-48a8-8ea9-c971e0dcf64f@gmail.com>
Date: Thu, 15 May 2025 12:04:32 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: move locking inside overflow posting
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1747209332.git.asml.silence@gmail.com>
 <56fb1f1b3977ae5eec732bd5d39635b69a056b3e.1747209332.git.asml.silence@gmail.com>
 <d6634082-86c0-4393-b270-ede60397695e@kernel.dk>
 <d63f55e8-7453-46fb-a85a-03e6de14402f@gmail.com>
 <6097e834-29a4-4e49-9c62-758e5b1a3884@kernel.dk>
 <a788a22f-0efd-4b78-94b5-c096b38c0e6c@gmail.com>
 <1644225f-36c9-4abf-8da3-cc853cdab0e8@kernel.dk>
 <a645a6a2-d722-4ef1-bdfd-3701ab315584@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a645a6a2-d722-4ef1-bdfd-3701ab315584@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/25 22:52, Jens Axboe wrote:
> Since sometimes it's easier to talk in code that in English, something
> like the below (just applied on top, and utterly untested) I think is
> much cleaner. Didn't spend a lot of time on it, I'm sure it could get
> condensed down some more with a helper or something. But it keeps the
> locking in the caller, while still allowing GFP_KERNEL alloc for
> lockless_cq.
> 
> Somewhat unrelated, but also fills in an io_cqe and passes in for the
> non-cqe32 parts, just for readability's sake.
> 
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index da1075b66a87..9b6d09633a29 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -744,44 +744,12 @@ static bool __io_cqring_event_overflow(struct io_ring_ctx *ctx,
>   	return true;
>   }
>   
> -static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, bool locked,
> -				     u64 user_data, s32 res, u32 cflags,
> -				     u64 extra1, u64 extra2)
> +static void io_cqring_event_overflow(struct io_ring_ctx *ctx,
> +				     struct io_overflow_cqe *ocqe)
>   {
> -	struct io_overflow_cqe *ocqe;
> -	size_t ocq_size = sizeof(struct io_overflow_cqe);
> -	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
> -	gfp_t gfp = GFP_KERNEL_ACCOUNT;
> -	bool queued;
> -
> -	io_lockdep_assert_cq_locked(ctx);
> -
> -	if (is_cqe32)
> -		ocq_size += sizeof(struct io_uring_cqe);
> -	if (locked)
> -		gfp = GFP_ATOMIC | __GFP_ACCOUNT;
> -
> -	ocqe = kmalloc(ocq_size, gfp);
> -	trace_io_uring_cqe_overflow(ctx, user_data, res, cflags, ocqe);
> -
> -	if (ocqe) {
> -		ocqe->cqe.user_data = user_data;
> -		ocqe->cqe.res = res;
> -		ocqe->cqe.flags = cflags;
> -		if (is_cqe32) {
> -			ocqe->cqe.big_cqe[0] = extra1;
> -			ocqe->cqe.big_cqe[1] = extra2;
> -		}
> -	}
> -
> -	if (locked) {
> -		queued = __io_cqring_event_overflow(ctx, ocqe);
> -	} else {
> -		spin_lock(&ctx->completion_lock);
> -		queued = __io_cqring_event_overflow(ctx, ocqe);
> -		spin_unlock(&ctx->completion_lock);
> -	}
> -	return queued;
> +	spin_lock(&ctx->completion_lock);
> +	__io_cqring_event_overflow(ctx, ocqe);
> +	spin_unlock(&ctx->completion_lock);
>   }
>   
>   /*
> @@ -842,15 +810,49 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
>   	return false;
>   }
>   
> +static struct io_overflow_cqe *io_get_ocqe(struct io_ring_ctx *ctx,
> +					   struct io_cqe *cqe, u64 extra1,
> +					   u64 extra2, gfp_t gfp)
> +{
> +	size_t ocq_size = sizeof(struct io_overflow_cqe);
> +	bool is_cqe32 = ctx->flags & IORING_SETUP_CQE32;
> +	struct io_overflow_cqe *ocqe;
> +
> +	if (is_cqe32)
> +		ocq_size += sizeof(struct io_uring_cqe);
> +
> +	ocqe = kmalloc(ocq_size, gfp);
> +	trace_io_uring_cqe_overflow(ctx, cqe->user_data, cqe->res, cqe->flags, ocqe);
> +	if (ocqe) {
> +		ocqe->cqe.user_data = cqe->user_data;
> +		ocqe->cqe.res = cqe->res;
> +		ocqe->cqe.flags = cqe->flags;
> +		if (is_cqe32) {
> +			ocqe->cqe.big_cqe[0] = extra1;
> +			ocqe->cqe.big_cqe[1] = extra2;
> +		}
> +	}
> +
> +	return ocqe;
> +}
> +
>   bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
>   {
>   	bool filled;
>   
>   	io_cq_lock(ctx);
>   	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
> -	if (!filled)
> -		filled = io_cqring_event_overflow(ctx, true,
> -						  user_data, res, cflags, 0, 0);
> +	if (unlikely(!filled)) {
> +		struct io_cqe cqe = {
> +			.user_data	= user_data,
> +			.res		= res,
> +			.flags		= cflags
> +		};
> +		struct io_overflow_cqe *ocqe;
> +
> +		ocqe = io_get_ocqe(ctx, &cqe, 0, 0, GFP_ATOMIC);
> +		filled = __io_cqring_event_overflow(ctx, ocqe);
> +	}
>   	io_cq_unlock_post(ctx);
>   	return filled;
>   }
> @@ -864,8 +866,17 @@ void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
>   	lockdep_assert_held(&ctx->uring_lock);
>   	lockdep_assert(ctx->lockless_cq);
>   
> -	if (!io_fill_cqe_aux(ctx, user_data, res, cflags))
> -		io_cqring_event_overflow(ctx, false, user_data, res, cflags, 0, 0);
> +	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
> +		struct io_cqe cqe = {
> +			.user_data	= user_data,
> +			.res		= res,
> +			.flags		= cflags
> +		};
> +		struct io_overflow_cqe *ocqe;
> +
> +		ocqe = io_get_ocqe(ctx, &cqe, 0, 0, GFP_KERNEL);
> +		io_cqring_event_overflow(ctx, ocqe);
> +	}
>   
>   	ctx->submit_state.cq_flush = true;
>   }
> @@ -1437,6 +1448,20 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
>   	} while (node);
>   }
>   
> +static __cold void io_cqe_overflow_fill(struct io_ring_ctx *ctx,
> +					struct io_kiocb *req)
> +{
> +	gfp_t gfp = ctx->lockless_cq ? GFP_KERNEL : GFP_ATOMIC;
> +	struct io_overflow_cqe *ocqe;
> +
> +	ocqe = io_get_ocqe(ctx, &req->cqe, req->big_cqe.extra1, req->big_cqe.extra2, gfp);
> +	if (ctx->lockless_cq)
> +		io_cqring_event_overflow(ctx, ocqe);
> +	else
> +		__io_cqring_event_overflow(ctx, ocqe);
> +	memset(&req->big_cqe, 0, sizeof(req->big_cqe));
> +}

Implicitly passing the locking state b/w functions is much worse. And
instead being contained in a single helper all callers need to care
about some allocator function, which doesn't help in making it cleaner
and also contributes to bloating. Let's just leave How it's already
in the tree.

-- 
Pavel Begunkov


