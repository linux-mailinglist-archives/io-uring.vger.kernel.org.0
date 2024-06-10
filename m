Return-Path: <io-uring+bounces-2143-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDF80901933
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 03:18:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AAEC2817D6
	for <lists+io-uring@lfdr.de>; Mon, 10 Jun 2024 01:18:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6F4180C;
	Mon, 10 Jun 2024 01:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P4ZcgY9O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8A023B0;
	Mon, 10 Jun 2024 01:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717982317; cv=none; b=h7639iiMLZ5EibuJP1t3fj1JacUSp1CXLEbMEv6ZmJ4Qz2fj3IzfLZz1tEc0whGxp20thIaz3xGlXFhogxtpPXUTYfpwoLO13j5TqgEjyYKHECLLWzuKEAuBE8iTLgYOE9SQhszbaIwy9U+lbnwZBGNPGdlEEqM0Q1tBRW1yR7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717982317; c=relaxed/simple;
	bh=ByD3s5btSWDsik1GMxVscEZtVLiiCnI8JkEqxrQ5+Z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FyHaX2esL32pmXXQVw/kxQeZbDYmGomhsbk+PA33azoPacB5znRJXS7h727l0LWoT0mKOigfN/iNfN5WVtflNF25IvnECgxhZWexAJn32eLoCpRbZCFTa+ewgGRQZk97i5SYsD9HAsaitLNCwQoeQMbkCl2RwkOaYXNnWpu0+Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P4ZcgY9O; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4217d808034so8125965e9.3;
        Sun, 09 Jun 2024 18:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717982314; x=1718587114; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YsrbQb70cZrlZvh6PN2a1bLRC/067K+UAQBrrlcdguI=;
        b=P4ZcgY9O1KKITjyjXDVaSvQl9gS6/cpcYI8Tnc/W8vtjqf+liW77Tyy6TfCf1ddM9+
         YM5HkAtBbYXPrJ/jlNRkfA9KJ5BY7DCc5KBoa26MhMIqCoH+XUns7p69cBVX0n5Eq+k2
         xfigAIkOOZt5YwsmnMiQvQCz/ZVVurGv4NxGAeb0++AinvZPqU6cI8YfbwGhDPH5FbyN
         bxwPmz5nACIj4CIVCmF9HgYW5FMtLIh0iYlA4+p3DKMjuBanrxJbu1FeeeWUIQva39eT
         ENJE4k4y1iRGYIf9zTi8PVkgtvlX4VaMteJkl7jTwrq0pQ6XjJ+3gVRBml+xK7ei0JpI
         6ziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717982314; x=1718587114;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YsrbQb70cZrlZvh6PN2a1bLRC/067K+UAQBrrlcdguI=;
        b=mxsFSf3Ts2e8Q98Ay5sPf0ZisQ0MaGECfQu5XXCtaza560zmrGJgi0T1V0aaakiMHt
         lX8KV7w5xR0N21+TP7sjHjfJeiqUK/pF7vA6gm0+m1Qk/JPDt1w9dK/7YI1rHzBX9Zzw
         Dq/w1bXL8usoz0XRXMCQd60jGijkQKlmsrYDVlAT82drO8dZjIgXFWkibQf5F5OunviK
         CDepheVyBO/a1p+QTl3TQIC1DKSigu41i6p2jrDNPR1xWNqWgwWq6y2QVkTJI/U3pNmf
         v3XV+tjym4NKKpUGjA3TRL9/B2JWK6YhOur7IVPMbiwyoQ5pFeXm0Hy+5c3+2RCa353q
         3eGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUduq8Rv+34Jl3c3Nae8wv8JGyQ9Gbvd6qyUSYrXcS3k8PAjsQvIrKhOHnjxIn3mj2HU11XHJdOFz5aAwvMegvakTu2Hoy2lrQ=
X-Gm-Message-State: AOJu0YwT3NnJyUZ1EpZv/X6O8av6qvBz++aSuHzVLI3t33WY+TyRad1r
	vFotOlIfxwMHWe03d1gKvLqs01j/okuAP9DaxTbaO2BnuerUdpzfTKT2cFjT
X-Google-Smtp-Source: AGHT+IE5bGsQHF5DelfF/fobINZCbVepTLh4PBP8jbypvcZoMKy3gNLQfmPo/UJMGECZD3soCl0KpA==
X-Received: by 2002:a05:600c:458e:b0:41c:97e:2100 with SMTP id 5b1f17b1804b1-421649ea496mr65779655e9.3.1717982314196;
        Sun, 09 Jun 2024 18:18:34 -0700 (PDT)
Received: from [192.168.42.136] ([148.252.129.53])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42175e30fbbsm57307365e9.0.2024.06.09.18.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jun 2024 18:18:33 -0700 (PDT)
Message-ID: <10b4dc44-d7dc-4858-abb9-2837fc688f44@gmail.com>
Date: Mon, 10 Jun 2024 02:18:34 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 3/9] io_uring: add helper of io_req_commit_cqe()
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240511001214.173711-1-ming.lei@redhat.com>
 <20240511001214.173711-4-ming.lei@redhat.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20240511001214.173711-4-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/11/24 01:12, Ming Lei wrote:
> Add helper of io_req_commit_cqe() which can be used in posting CQE
> from both __io_submit_flush_completions() and io_req_complete_post().

Please drop this patch and inline further changes into this
two callers. There are different locking rules, different
hotness, and should better be left duplicated until cleaned
up in a proper way.


> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   io_uring/io_uring.c | 34 ++++++++++++++++++++--------------
>   1 file changed, 20 insertions(+), 14 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index d3b9988cdae4..e4be930e0f1e 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -910,6 +910,22 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
>   	return posted;
>   }
>   
> +static __always_inline void io_req_commit_cqe(struct io_kiocb *req,
> +		bool lockless_cq)
> +{
> +	struct io_ring_ctx *ctx = req->ctx;
> +
> +	if (unlikely(!io_fill_cqe_req(ctx, req))) {
> +		if (lockless_cq) {
> +			spin_lock(&ctx->completion_lock);
> +			io_req_cqe_overflow(req);
> +			spin_unlock(&ctx->completion_lock);
> +		} else {
> +			io_req_cqe_overflow(req);
> +		}
> +	}
> +}
> +
>   static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   {
>   	struct io_ring_ctx *ctx = req->ctx;
> @@ -932,10 +948,8 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
>   	}
>   
>   	io_cq_lock(ctx);
> -	if (!(req->flags & REQ_F_CQE_SKIP)) {
> -		if (!io_fill_cqe_req(ctx, req))
> -			io_req_cqe_overflow(req);
> -	}
> +	if (!(req->flags & REQ_F_CQE_SKIP))
> +		io_req_commit_cqe(req, false);
>   	io_cq_unlock_post(ctx);
>   
>   	/*
> @@ -1454,16 +1468,8 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
>   		struct io_kiocb *req = container_of(node, struct io_kiocb,
>   					    comp_list);
>   
> -		if (!(req->flags & REQ_F_CQE_SKIP) &&
> -		    unlikely(!io_fill_cqe_req(ctx, req))) {
> -			if (ctx->lockless_cq) {
> -				spin_lock(&ctx->completion_lock);
> -				io_req_cqe_overflow(req);
> -				spin_unlock(&ctx->completion_lock);
> -			} else {
> -				io_req_cqe_overflow(req);
> -			}
> -		}
> +		if (!(req->flags & REQ_F_CQE_SKIP))
> +			io_req_commit_cqe(req, ctx->lockless_cq);
>   	}
>   	__io_cq_unlock_post(ctx);
>   

-- 
Pavel Begunkov

