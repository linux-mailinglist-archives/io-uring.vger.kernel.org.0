Return-Path: <io-uring+bounces-11322-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 03399CE866E
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 01:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56B593012DD1
	for <lists+io-uring@lfdr.de>; Tue, 30 Dec 2025 00:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7EA2836A6;
	Tue, 30 Dec 2025 00:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a9tLM0hN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1666F27F171
	for <io-uring@vger.kernel.org>; Tue, 30 Dec 2025 00:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767054235; cv=none; b=qC3N56lNu+CjfukextLm4masH6yFQPXsooFVK8be03DN/UB2vzFOGqitc8ldd91ERmaWk+PyaSittMLOHfyFvETRcumMb/NpmEGFU66Ii5vBec1cVOOSjZ0Rw3rWBcUxQUl8hBRPvZVbt84Ml+EvVOBx8cszekzw0NOmjUt1DmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767054235; c=relaxed/simple;
	bh=iVH/CxM/QXNKRlsj+Gw1DBA7WGit8t/coTgw9urJ74c=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lrt9vG1nVPxmj188f73FV00unzAO8xaCAQUDhZxJfN3BelfOd5NJFOdMlZ4m4D+X3geTeZ5RU8/tHBcz5kWMQJDtHZszQ+8PX1Bn6We+fm6JA794pB8nLyX8+fpLUI5IxYN3JPP6TQHIQqDM2Udwu3nCoUIh71x3VAGK5gkHrTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a9tLM0hN; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7cc50eb0882so3511897a34.3
        for <io-uring@vger.kernel.org>; Mon, 29 Dec 2025 16:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767054231; x=1767659031; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+RDoRKokANdepIDhyxQyq4vbF925RrxH/Z+QkG4Gbo8=;
        b=a9tLM0hNjSSE91fzQ1QpeMvpOl0uo5IuX9aGYoC8QWvyBhpVcw0U4Es5coQNRx7Sqd
         /BgOYW+weO+IHSdWeykh1Ov5ULCUmZJ9SkOjiZOfkNSGsXP5feQdcyKET6lLMs8DPuHg
         EPUqToApjj1fz3C5rWvHQHCKK4GCVzO9wV3RqwlUmIfel2cWZvPsxgpdGzwX0OoChqEC
         TBePD7kEeGuoZbc5P2e6GxRgu/5qJq/xmbcAtqjlTco1Lwsi4MPb07bnb7FFae+4Urh9
         OEa2b/84kKxyomiFfpkPPtvk9YAxrfKBUMV26elVfR5xdSREkr7UQCizgAml83wy6ato
         QsFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767054231; x=1767659031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+RDoRKokANdepIDhyxQyq4vbF925RrxH/Z+QkG4Gbo8=;
        b=FKNRuL7xfKQJHS48JBcD7OOuqFEp/08eDdih32GZcD58x/EU4dcfnjqv/KlSpAuLD4
         qkV5X3oBi4jl9ZqX3AAzz2zbUNUlpDIom23SC5RbL620cLhIxzLerrI/Q0/TM+PuUxiC
         3FANqg4gLA1aJ4Qs4T3d/XKYzXFcr9d2kTG0PZ2wWeD8+mpQV6oxlZO6N2lTeTnKcSES
         qpmT1VUIyN7JO7H6u0ckt4Gnh3ndqKXqnY356lmEr5zdcHsWX2Hr/yhgdeVOKFd096Rd
         7c3F284rmpx9/DixOO/VWeIuwWQNJ8lJwSDeiIg/egNTC2OGxaEpk6AD6ggHCGBKGmpt
         CfGg==
X-Forwarded-Encrypted: i=1; AJvYcCVpP4Lb8Gni+5VBUkEOe9f0HWAqNFYKMbjO6XC4aF9z192CksdcH9mUBD62jkQviFtSeanJBRAI3Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YykDfPZxWDUWwIlk8kXwM0ygwM2Nw1JzsRsKEOQhKdx1NF3KWkE
	9M8QUC1LWcdX+tTcWRriN06YcFbJpCa0EUNU+Vt5spDZBOb94j0Nu4cVSrOLu+S42A552LBzi6x
	5q05C
X-Gm-Gg: AY/fxX5R5NNpTcLQA4MB3g+GeQoUacIJP2Gp4c2gUyB3PRkfGdj2NtCiGUXnxBykN9J
	qXi1g5Trls8aiLBfAz+VywGgVYiR+3Hk1EcSv1rtWtuT4KKy5rFDKx8Y+eZI2e0y7BOU90q3GiH
	kNMQ7HUZPDVHHNxo4DkjFaalPmGLQxf1beML45/hAVsfGIaCGIO/IzsFn2mt/zZ+zTSBIbsBA+t
	NGjiLmwU26rN9YrsX7GULAqW4uA8e5DwInhh4UNhTfHTQSXWIMW9VDQhNTki1GC7PMKCiHcE8Qv
	16Kf1RpchApQoeJp1J3AMnVM9n83b4J3FulX8L225diV4Gzj7qNXUy3HsuB1Bk7LvNKj5rjYn19
	9EBDjyUoI7sD6rkqauOnga44sTyYk1xpm2YIwq5bXG291T0KuydtkdNA/sgyTsLB5BwkfVlKmpQ
	LEwusvCALoMAC6OgLu1WY=
X-Google-Smtp-Source: AGHT+IF8d1u36Kgc5JwULmVoEra16HWhPwx2HAZ3cAPLcIvJC5K74+6HeI1Ad7eg+rTBQW6akrKe/Q==
X-Received: by 2002:a05:6830:923:b0:7c7:2d7d:5d0f with SMTP id 46e09a7af769-7cc66a4b655mr16035254a34.20.1767054230681;
        Mon, 29 Dec 2025 16:23:50 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3fdaac145bcsm17848811fac.22.2025.12.29.16.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 16:23:50 -0800 (PST)
Message-ID: <a8a832b9-bfa6-4c1e-bdcc-a89467add5d1@kernel.dk>
Date: Mon, 29 Dec 2025 17:23:49 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: make overflowing cqe subject to OOM
To: Alexandre Negrel <alexandre@negrel.dev>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251229201933.515797-1-alexandre@negrel.dev>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251229201933.515797-1-alexandre@negrel.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/29/25 1:19 PM, Alexandre Negrel wrote:
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 6cb24cdf8e68..5ff1a13fed1c 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -545,31 +545,12 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
>  		io_eventfd_signal(ctx, true);
>  }
>  
> -static inline void __io_cq_lock(struct io_ring_ctx *ctx)
> -{
> -	if (!ctx->lockless_cq)
> -		spin_lock(&ctx->completion_lock);
> -}
> -
>  static inline void io_cq_lock(struct io_ring_ctx *ctx)
>  	__acquires(ctx->completion_lock)
>  {
>  	spin_lock(&ctx->completion_lock);
>  }
>  
> -static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
> -{
> -	io_commit_cqring(ctx);
> -	if (!ctx->task_complete) {
> -		if (!ctx->lockless_cq)
> -			spin_unlock(&ctx->completion_lock);
> -		/* IOPOLL rings only need to wake up if it's also SQPOLL */
> -		if (!ctx->syscall_iopoll)
> -			io_cqring_wake(ctx);
> -	}
> -	io_commit_cqring_flush(ctx);
> -}
> -
>  static void io_cq_unlock_post(struct io_ring_ctx *ctx)
>  	__releases(ctx->completion_lock)
>  {
> @@ -1513,7 +1494,6 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>  	struct io_submit_state *state = &ctx->submit_state;
>  	struct io_wq_work_node *node;
>  
> -	__io_cq_lock(ctx);
>  	__wq_list_for_each(node, &state->compl_reqs) {
>  		struct io_kiocb *req = container_of(node, struct io_kiocb,
>  					    comp_list);
> @@ -1525,13 +1505,17 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>  		 */
>  		if (!(req->flags & (REQ_F_CQE_SKIP | REQ_F_REISSUE)) &&
>  		    unlikely(!io_fill_cqe_req(ctx, req))) {
> -			if (ctx->lockless_cq)
> -				io_cqe_overflow(ctx, &req->cqe, &req->big_cqe);
> -			else
> -				io_cqe_overflow_locked(ctx, &req->cqe, &req->big_cqe);
> +			io_cqe_overflow(ctx, &req->cqe, &req->big_cqe);
>  		}
>  	}
> -	__io_cq_unlock_post(ctx);
> +
> +	io_commit_cqring(ctx);
> +	if (!ctx->task_complete) {
> +		/* IOPOLL rings only need to wake up if it's also SQPOLL */
> +		if (!ctx->syscall_iopoll)
> +			io_cqring_wake(ctx);
> +	}
> +	io_commit_cqring_flush(ctx);
>  
>  	if (!wq_list_empty(&state->compl_reqs)) {
>  		io_free_batch_list(ctx, state->compl_reqs.first);

You seem to just remove the lock around posting CQEs, and hence then it
can use GFP_KERNEL? That's very broken... I'm assuming the issue here is
that memcg will look at __GFP_HIGH somehow and allow it to proceed?
Surely that should not stop OOM, just defer it?

In any case, then below should then do the same. Can you test?

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6cb24cdf8e68..709943fedaf4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -864,7 +864,7 @@ static __cold bool io_cqe_overflow_locked(struct io_ring_ctx *ctx,
 {
 	struct io_overflow_cqe *ocqe;
 
-	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_ATOMIC);
+	ocqe = io_alloc_ocqe(ctx, cqe, big_cqe, GFP_NOWAIT);
 	return io_cqring_add_overflow(ctx, ocqe);
 }
 

-- 
Jens Axboe

