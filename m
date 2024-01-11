Return-Path: <io-uring+bounces-390-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE4782AFBA
	for <lists+io-uring@lfdr.de>; Thu, 11 Jan 2024 14:33:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 649F0B27051
	for <lists+io-uring@lfdr.de>; Thu, 11 Jan 2024 13:33:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E5F12E636;
	Thu, 11 Jan 2024 13:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WKt+oERI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FF6418025;
	Thu, 11 Jan 2024 13:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40e5508ecb9so27530295e9.3;
        Thu, 11 Jan 2024 05:33:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704979994; x=1705584794; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kqv14WwxifVHNlqdhovpqHWgWDrzlQ4xda+DlJ6GdOU=;
        b=WKt+oERII353qHUrYUk4OR2WWkBEAR+0vMXSgXkghBwwKhWIgKOb1U2JsnH8wrayAt
         UJHaKA1zJNBoTAx+xRcU/gzKjGtLUOLcZCiVpE2W7sgDx84sescH1wMjUu+2R/2A7jG9
         I6bwa2FyQ01XNyWMTYFu1uI+JQupRNLTzRIvXobabUjKlLRx+W+yncCui0BMKN0MHKGN
         h3KwON/OZz3EN90Cb6SDyDWLiYPul1Vitbw7zg+J57D/Oj/mGevjJQI0pVmSM1isuR2N
         Ys0PSY+TQbl+LhSYE3+31DFmXzWBbNxx29LdJSgtl1f4uxHmGp2/LaZvYh6Akl4nU0TR
         fw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704979994; x=1705584794;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kqv14WwxifVHNlqdhovpqHWgWDrzlQ4xda+DlJ6GdOU=;
        b=nq5ByiAKGT9XDUmAlzjMcmMW2lSSX2Q8ROhyrKK74y622PjlEQ0EAv1mQl0mUJmIBy
         tOnr1hyu0X2JxUf1lTxExrUr0Qs42f14S0bOtqUdrAiFCyTz9YTZ3pL80hzh8ABHq3YZ
         9P/meFgS3qMs3nxlJ6CkM7c6vcOAJeiFLMibBhCbu8EHk3J/PxSdzppGmgM03a7FBOEP
         Tr5ZkKGOIAh6SXgUzxtB4qnSVGigcfLY8g4jjJdwV4ZytEyxopymiXlOf9K3u6E/+uXY
         S3kdo4JuM7j6dDXqikuc7vejmxot8oS8N5XaTc6Fj7DzS0/gOu/hVxxxR62oBQlmJh3C
         y5lw==
X-Gm-Message-State: AOJu0YydEzOpBsPNENv0Z9A+lfVtFxPIljqm6C6AfsqWrobi0VZzh+O3
	5LsxuiFtdIKp3OX2UKjtbE9hohNRbDQ=
X-Google-Smtp-Source: AGHT+IHPJRETdyfUs2HnpRsF0j1ujPvPBeHr8hNSwOvWB+y9FP26oq/F4PeoGR5FgUp5JfUTs6X8VQ==
X-Received: by 2002:a05:600c:1f17:b0:40d:8726:100a with SMTP id bd23-20020a05600c1f1700b0040d8726100amr509023wmb.22.1704979994520;
        Thu, 11 Jan 2024 05:33:14 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::1:18af])
        by smtp.gmail.com with ESMTPSA id v21-20020a05600c445500b0040e3bdff98asm5767226wmn.23.2024.01.11.05.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jan 2024 05:33:14 -0800 (PST)
Message-ID: <4b1deeeb-b5fd-481d-99b5-7d29c0edce2d@gmail.com>
Date: Thu, 11 Jan 2024 13:23:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] io_uring: Improve exception handling in
 io_ring_ctx_alloc()
Content-Language: en-US
To: Markus Elfring <Markus.Elfring@web.de>, io-uring@vger.kernel.org,
 kernel-janitors@vger.kernel.org, Gabriel Krisman Bertazi <krisman@suse.de>,
 Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <6cbcf640-55e5-2f11-4a09-716fe681c0d2@web.de>
 <aa867594-e79d-6d08-a08e-8c9e952b4724@web.de>
 <878r4xnn52.fsf@mailhost.krisman.be>
 <b9c9ba9f-459e-40b5-ae4b-703dcc03871d@web.de>
 <49ecda98-770d-455e-acd7-12d810280fdd@web.de>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <49ecda98-770d-455e-acd7-12d810280fdd@web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/10/24 20:50, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 10 Jan 2024 21:15:48 +0100
> 
> The label “err” was used to jump to a kfree() call despite of
> the detail in the implementation of the function “io_ring_ctx_alloc”
> that it was determined already that a corresponding variable contained
> a null pointer because of a failed memory allocation.

It's _much_ simpler the way it currently is, compare it with maintaining
a bunch of labels. That is the advantage of being able to distinguish
un-allocated state like NULL, just kfree them and don't care about
jumping to a wrong one or keeping them in order.

  
> 1. Thus use more appropriate labels instead.
> 
> 2. Reorder jump targets at the end.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
> 
> See also:
> https://wiki.sei.cmu.edu/confluence/display/c/MEM12-C.+Consider+using+a+goto+chain+when+leaving+a+function+on+error+when+using+and+releasing+resources
> 
> 
>   io_uring/io_uring.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index c9a63c39cdd0..7727cdd505ae 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -295,12 +295,14 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	hash_bits = ilog2(p->cq_entries) - 5;
>   	hash_bits = clamp(hash_bits, 1, 8);
>   	if (io_alloc_hash_table(&ctx->cancel_table, hash_bits))
> -		goto err;
> +		goto destroy_io_bl_xa;
> +
>   	if (io_alloc_hash_table(&ctx->cancel_table_locked, hash_bits))
> -		goto err;
> +		goto free_cancel_table_hbs;
> +
>   	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
>   			    0, GFP_KERNEL))
> -		goto err;
> +		goto free_cancel_table_locked_hbs;
> 
>   	ctx->flags = p->flags;
>   	init_waitqueue_head(&ctx->sqo_sq_wait);
> @@ -341,9 +343,12 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
>   	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
>   	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
>   	return ctx;
> -err:
> -	kfree(ctx->cancel_table.hbs);
> +
> +free_cancel_table_locked_hbs:
>   	kfree(ctx->cancel_table_locked.hbs);
> +free_cancel_table_hbs:
> +	kfree(ctx->cancel_table.hbs);
> +destroy_io_bl_xa:
>   	xa_destroy(&ctx->io_bl_xa);
>   	kfree(ctx);
>   	return NULL;
> --
> 2.43.0
> 

-- 
Pavel Begunkov

