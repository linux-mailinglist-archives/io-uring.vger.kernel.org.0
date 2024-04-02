Return-Path: <io-uring+bounces-1365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 628F1895BD9
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 20:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E43D31F22935
	for <lists+io-uring@lfdr.de>; Tue,  2 Apr 2024 18:40:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0731915A491;
	Tue,  2 Apr 2024 18:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oio+C70l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5688495
	for <io-uring@vger.kernel.org>; Tue,  2 Apr 2024 18:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712083218; cv=none; b=RyrfCzyUIlAjLcNrwzlwP5kXocUbEHE3JvSFOv2JBurL1aFbEGulSAbRcMOlrVcXx33Kxb9raCGi1WaPZzkgvQXyXb7e0apz85ngEoy78mHinORrLzkas/or0w/0ihnBHFa01zdUIUsa7a34hZZ+f2ngzyd5Tvosb8HCPTKCQIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712083218; c=relaxed/simple;
	bh=jnnl4RPfOuJywggY6ZWEBSIhQje75zTwGj7C2FspMhM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=vEKJFFfQjyONqlS0GYBsouzsOC+cMz3UZ5AyR7bIy1JD5GwsqQF86jsNtDT0zUi4BThLAfmLKK+N04wV9VhOm53e6Vt3JrLWOpI523eadNGbeAzkpate8ungVTPaNQ/XQFOFsXKggsmhcFo073UUo+D808C6GD+KimmWHbAwD6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oio+C70l; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a4e39f5030dso552782666b.0
        for <io-uring@vger.kernel.org>; Tue, 02 Apr 2024 11:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712083215; x=1712688015; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eBkBi9OtAN82Hn9rYcm9XGPxG5vY4rE4LFi9tywmGAs=;
        b=Oio+C70luABdpFqsj0EgrOQcq3UqyLXMVo7+O+TU9q5GwOQJCB45CbR2wj9bWmROvG
         MnHBSiYbs7EJ3a7VVmMOAtn6EIirsumxKs4WvJbRUgycsduQrsYtqBAGM+Ks58ev3ClU
         E64a5vv8SS3nWsaAyo5n8jdMQs/wbIA612mwTEfd12vbbThNaUwGpdy9g5PGuiZwzH/I
         SMqfgazNmT8MXGgnwJyg2Let33ZPlWAHDfOEZX8X/jKBztWpmqbIsPae4bdeuG0cla4c
         NNSrU5cNG6t/hqRMR4e7+RpGfO3zm8B44p0ObLOH6pYfRPY4z9QX9ry4RykTMhE4Ajhh
         aCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712083215; x=1712688015;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eBkBi9OtAN82Hn9rYcm9XGPxG5vY4rE4LFi9tywmGAs=;
        b=ZQPTivdiLn76AsJwxusOxOyThyykL2yqJm0HUqKhBvFMt5vSRcBMnNQIJvdYwNGmyb
         JRmyOZbkUxfBcPb5m8B/hVpQ+4dKyoIZn3Zyc+2EdNwkk6aofEhQnWiYYYObJGF291fB
         LjLgcy+jWAZBu5yjqVJIpmuYIRshGD2QgPIbztXsg+P5o45W6PZSsAA/xSfgPCbr73ho
         n1hrvrsHMC1Zuf1Me356GCxEDeuos3ags6oLtgVzq0qwP9k7hcRWIOthaD2MbRMTphO1
         Ytx8AfGbPJSpFIr4UecPyHwVj0Y1gfBcv3MZIhZPND+kb1YLqAIg9YpmNDfM4o6YtXoO
         +5hw==
X-Forwarded-Encrypted: i=1; AJvYcCWW3PhMiKSVu/zWUi1EULIERCpjFStQAsg3QzdFuHnGpMXfeLyRlYHtVDLSCLPGXJ2Ijry5GLTctpQKLx4wqi99ogQeLWJthaY=
X-Gm-Message-State: AOJu0YyyTu6R7DVAgFrirM0K2fegrHaRCXb45J+T9HcYmrgGRxU766Hk
	eg/pf5WDKYC2jUcN9potwBijKcbOC2N9jhJpvb2j6qM6Cd8Ydqim1DsYL1oW
X-Google-Smtp-Source: AGHT+IHUvAzmem5y24B2oXREjMVBwfYlcXzjisgSm/M7EflCGy3qex0Y1ERUF0Q9+gqhjipDf/n7lQ==
X-Received: by 2002:a17:906:a14d:b0:a4e:982e:7766 with SMTP id bu13-20020a170906a14d00b00a4e982e7766mr496239ejb.70.1712083212974;
        Tue, 02 Apr 2024 11:40:12 -0700 (PDT)
Received: from [192.168.42.163] ([148.252.147.117])
        by smtp.gmail.com with ESMTPSA id p6-20020a170906a00600b00a46d04b6117sm6856776ejy.64.2024.04.02.11.40.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 11:40:12 -0700 (PDT)
Message-ID: <d9f6917a-72ad-43a0-8f8b-117284b95656@gmail.com>
Date: Tue, 2 Apr 2024 19:40:07 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: kill dead code in io_req_complete_post
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <20240329154712.1936153-1-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240329154712.1936153-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/29/24 15:47, Ming Lei wrote:
> Since commit 8f6c829491fe ("io_uring: remove struct io_tw_state::locked"),
> io_req_complete_post() is only called from io-wq submit work, where the
> request reference is guaranteed to be grabbed and won't drop to zero
> in io_req_complete_post().
> 
> Kill the dead code, meantime add req_ref_put() to put the reference.

Interesting... a nice clean up. The assumption is too implicit to
my taste, but should be just fine if we add

if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_IOWQ)))
	return;

at the beginning of io_req_complete_post(), it's a slow path.
And with this change:

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> Cc: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   io_uring/io_uring.c | 37 ++-----------------------------------
>   io_uring/refs.h     |  7 +++++++
>   2 files changed, 9 insertions(+), 35 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 104899522bc5..ac2e5da4558a 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -929,7 +929,6 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>   static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> -	struct io_rsrc_node *rsrc_node = NULL;
>   
>   	/*
>   	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
> @@ -946,42 +945,10 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   		if (!io_fill_cqe_req(ctx, req))
>   			io_req_cqe_overflow(req);
>   	}
> -
> -	/*
> -	 * If we're the last reference to this request, add to our locked
> -	 * free_list cache.
> -	 */
> -	if (req_ref_put_and_test(req)) {
> -		if (req->flags & IO_REQ_LINK_FLAGS) {
> -			if (req->flags & IO_DISARM_MASK)
> -				io_disarm_next(req);
> -			if (req->link) {
> -				io_req_task_queue(req->link);
> -				req->link = NULL;
> -			}
> -		}
> -		io_put_kbuf_comp(req);
> -		if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
> -			io_clean_op(req);
> -		io_put_file(req);
> -
> -		rsrc_node = req->rsrc_node;
> -		/*
> -		 * Selected buffer deallocation in io_clean_op() assumes that
> -		 * we don't hold ->completion_lock. Clean them here to avoid
> -		 * deadlocks.
> -		 */
> -		io_put_task_remote(req->task);
> -		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
> -		ctx->locked_free_nr++;
> -	}
>   	io_cq_unlock_post(ctx);
>   
> -	if (rsrc_node) {
> -		io_ring_submit_lock(ctx, issue_flags);
> -		io_put_rsrc_node(ctx, rsrc_node);
> -		io_ring_submit_unlock(ctx, issue_flags);
> -	}
> +	/* called from io-wq submit work only, the ref won't drop to zero */
> +	req_ref_put(req);
>   }
>   
>   void io_req_defer_failed(struct io_kiocb *req, s32 res)
> diff --git a/io_uring/refs.h b/io_uring/refs.h
> index 1336de3f2a30..63982ead9f7d 100644
> --- a/io_uring/refs.h
> +++ b/io_uring/refs.h
> @@ -33,6 +33,13 @@ static inline void req_ref_get(struct io_kiocb *req)
>   	atomic_inc(&req->refs);
>   }
>   
> +static inline void req_ref_put(struct io_kiocb *req)
> +{
> +	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
> +	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
> +	atomic_dec(&req->refs);
> +}
> +
>   static inline void __io_req_set_refcount(struct io_kiocb *req, int nr)
>   {
>   	if (!(req->flags & REQ_F_REFCOUNT)) {

-- 
Pavel Begunkov

