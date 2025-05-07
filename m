Return-Path: <io-uring+bounces-7894-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6083CAAED76
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 22:52:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBCDB16EED5
	for <lists+io-uring@lfdr.de>; Wed,  7 May 2025 20:52:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D8E328FA84;
	Wed,  7 May 2025 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTCCkHSP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF1928A73E
	for <io-uring@vger.kernel.org>; Wed,  7 May 2025 20:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746651165; cv=none; b=GCxdNcvXy2RDXfhGf5R10Iah9RGH+WNC1y9Oln4D7T3yxRxnHQENXbtF2d7Iw7P1qhcdf9cl4A+x06sL5bu8oRrXCeAQT/89bBvFG5Azy1D28TbA1p0MtGrTKPzg0yC/5X0wHzILSn4TzwBpg3CDo6xNVHrvE/SlPXYHvHI90i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746651165; c=relaxed/simple;
	bh=oRq55MkAFubvehOIOGSlQOeuJikKU29ybyX86CAhtmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=PGTyohe4HZyJIgNej1L+RukpeKM8pEcDbjK2ZQIc2psjjqwM7Y0hQKKPjdywHTrJPKFz0TqEhyL/hWyCYogf/9GNva7IKuOkYCnJqLeO5huqzjCbsiFt4QrTW4pBz925Aq+BqVzXvOAQxb//GIsGkAlIjr+5TpoI/CgB31E/V8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jTCCkHSP; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cfdc2c8c9so1453195e9.2
        for <io-uring@vger.kernel.org>; Wed, 07 May 2025 13:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746651161; x=1747255961; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=asxCt7VnegRIfv8eHQt8YFqRKmMySMTPSLeSuIW795A=;
        b=jTCCkHSP1wmf4nHnfYsz3NmA9/DT+MnBCFQQSlxdcNtfA8eU0FbzkJNB7BkaZWNG4C
         EE2wmke4qVHHELdvCkaqYPrG8xqkKGwGazwV2cmOF+kID8B3nnTAlQuHmgA85J84nFCT
         ngRtTdz5dVCbrD4zr1JSsrZm4LoQQzfbFJQlZ00bdSDzkjs2A5pn8Gg6ymPKWgY41eFG
         wP2gcbZa/wnq1cG4XT0HZ8Bhbj7ZFmihc5oJas9RTYr51zl3Dfn2JH6Mz8nOOhXu78gi
         ogsdUr4rMufmpU4OZrbY5031Vw7hfyCfNSZSEUD7l4kd0PoqXOEfOanjb1S3CmnT3yIB
         Zz7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746651161; x=1747255961;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=asxCt7VnegRIfv8eHQt8YFqRKmMySMTPSLeSuIW795A=;
        b=ROvN35SWlKXzonypuV7RhBE6exeoRfAYSXYJqLx49md07PQolIKyegi2TUKQhVZCtS
         pC6lrxfOZv7dJSdy2Hab9xGH9yGpb4d4t4RiL03Endo/cAmerjdeaGKkMkKomEiv29A+
         T4DRVuWgL6uoelgRQrnkVmLDz+e4fT/MvIFGnBQRzZGnq0whi4ARZBE82vjONxLm404T
         TzRj/ckvQey0q6hPJ92jChegF7BD0csPuntE9g22TJN1piK/azhoA6eaCNT2+UQlnBII
         P+B0NPerCFJy32/JKHPPNy4V7mZMGrrxIe5hYKZ/6d210zwe1x143601WIi48Z4hGpDG
         9hmg==
X-Forwarded-Encrypted: i=1; AJvYcCUNAbrPVRXTvcUIQLDz8FqYsB0teTgjGMPqr2YeDk7cYb8+2RyCncxglhMg9LnfkY15YyPpEQ4rNw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJOupI0CJTes28TEICsNVF50gz+XquLPs+WuqHfgSmDbZO4wN3
	9XZlyBekt76Z6Pi2n03hnyPiCOLqzo3Os5YeJxfGi+pOc+kj/M2PB5qsvw==
X-Gm-Gg: ASbGncvAq8HdXQ+DhoMB2veBu1D9MjbQwzFh/OEZUNvX51QngPiZwssW3iWIDH9d+3C
	7D5j06RxhwRqzs0dKRF7heK2nYujCgKzy0jUGACV3fgZWWSeNMapv/wjl9jooH91E4q1PtgXmen
	wSZoenP/IU0nfAL/HJ8oL46U4/0mxoQrUUi2WUskOYySeJg2MJoS5Bsb9ROSMM9URshFoTG/xsx
	R4YeqI91swjOcV0+5ZiZpCpvhomWN9naq++SzuQDTwAWm9ggFYaH754bTnW9SxHL3vg5mJNPPyo
	fTHG7U8hVzv0s6FaV3Xn6LSfvxW9Jrvnw3VUjpQhgK+fMmE1hQ==
X-Google-Smtp-Source: AGHT+IGQix2Q3e4bWYCpchK6odroB3KgQblz8UvFqb4Vs6w0GLJP0VxE55wOkg1yAXemyeEIvC5v/g==
X-Received: by 2002:a05:600c:1e02:b0:43c:ee62:33f5 with SMTP id 5b1f17b1804b1-441d44dfe1bmr43737735e9.27.1746651160403;
        Wed, 07 May 2025 13:52:40 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.145.185])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a0b5b0d349sm3188350f8f.30.2025.05.07.13.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 May 2025 13:52:39 -0700 (PDT)
Message-ID: <1711744d-1dd1-4efc-87e2-6ddc1124a95e@gmail.com>
Date: Wed, 7 May 2025 21:53:55 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: use regular CQE posting for multishot
 termination
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <e837d840-4ff7-423a-a7a9-2196a7d44d26@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e837d840-4ff7-423a-a7a9-2196a7d44d26@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 19:08, Jens Axboe wrote:
> A previous patch avoided reordering of multiple multishot requests
> getting their CQEs potentiall reordered when one of them terminates, as
> that last termination CQE is posted as a deferred completion rather than
> directly as a CQE. This can reduce the efficiency of the batched
> posting, hence was not ideal.
> 
> Provide a basic helper that poll can use for this kind of termination,
> which does a normal CQE posting rather than a deferred one. With that,
> the work-around where io_req_post_cqe() needs to flush deferred
> completions can be removed.
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> ---
> 
> This removes the io_req_post_cqe() flushing, and instead puts the honus
> on the poll side to provide the ordering. I've verified that this also
> fixes the reported issue. The previous patch can be easily backported to
> stable, so makes sense to keep that one.

It still gives a bad feeling tbh, it's not a polling problem,
we're working around shortcomings of the incremental / bundled
uapi and/or design. Patching it in semi unrelated places will
defitely bite back.

Can it be fixed in relevant opcodes? So it stays close to
those who actually use it. And let me ask since I'm lost in
new features, can the uapi be fixed so that it doesn't
depend on request ordering?

> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 541e65a1eebf..505959fc2de0 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -848,14 +848,6 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>   	struct io_ring_ctx *ctx = req->ctx;
>   	bool posted;
>   
> -	/*
> -	 * If multishot has already posted deferred completions, ensure that
> -	 * those are flushed first before posting this one. If not, CQEs
> -	 * could get reordered.
> -	 */
> -	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
> -		__io_submit_flush_completions(ctx);
> -
>   	lockdep_assert(!io_wq_current_is_worker());
>   	lockdep_assert_held(&ctx->uring_lock);
>   
> @@ -871,6 +863,23 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>   	return posted;
>   }
>   
> +bool io_req_post_cqe_overflow(struct io_kiocb *req)

"overflow" here is rather confusing, it could mean lots of things.
Maybe some *_post_poll_complete for now?

> +{
> +	bool filled;
> +
> +	filled = io_req_post_cqe(req, req->cqe.res, req->cqe.flags);

posting and overflow must be under the same CQ critical section,
like io_cq_lock(). Just copy io_post_aux_cqe() and add
ctx->cq_extra--? Hopefully we'll remove the cq_extra ugliness
later and combine them after.

> +	if (unlikely(!filled)) {
> +		struct io_ring_ctx *ctx = req->ctx;
> +
> +		spin_lock(&ctx->completion_lock);
> +		filled = io_cqring_event_overflow(ctx, req->cqe.user_data,
> +					req->cqe.res, req->cqe.flags, 0, 0);
> +		spin_unlock(&ctx->completion_lock);
> +	}
> +
> +	return filled;
> +}
> +
>   static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> index e4050b2d0821..d2d4bf7c3b29 100644
> --- a/io_uring/io_uring.h
> +++ b/io_uring/io_uring.h
> @@ -82,6 +82,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res);
>   bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
>   void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
>   bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
> +bool io_req_post_cqe_overflow(struct io_kiocb *req);
>   void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
>   
>   struct file *io_file_get_normal(struct io_kiocb *req, int fd);
> diff --git a/io_uring/poll.c b/io_uring/poll.c
> index 8eb744eb9f4c..af8e3d4f6f1f 100644
> --- a/io_uring/poll.c
> +++ b/io_uring/poll.c
> @@ -312,6 +312,13 @@ static int io_poll_check_events(struct io_kiocb *req, io_tw_token_t tw)
>   	return IOU_POLL_NO_ACTION;
>   }
>   
> +static void io_poll_req_complete(struct io_kiocb *req, io_tw_token_t tw)
> +{
> +	if (io_req_post_cqe_overflow(req))
> +		req->flags |= REQ_F_CQE_SKIP;

Unconditional would be better. It'd still end up in attempting
to post, likely failing and reattemptng allocation just one
extra time, not like it gives any reliability. And if I'd be
choosing b/w dropping a completion or potentially getting a
botched completion as per the problem you tried, I say the
former is better.

> +	io_req_task_complete(req, tw);
> +}
> +
>   void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
>   {
>   	int ret;
> @@ -349,7 +356,7 @@ void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
>   		io_tw_lock(req->ctx, tw);
>   
>   		if (ret == IOU_POLL_REMOVE_POLL_USE_RES)
> -			io_req_task_complete(req, tw);
> +			io_poll_req_complete(req, tw);
>   		else if (ret == IOU_POLL_DONE || ret == IOU_POLL_REISSUE)
>   			io_req_task_submit(req, tw);
>   		else

-- 
Pavel Begunkov


