Return-Path: <io-uring+bounces-2596-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69DC094101E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 13:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F2B21F2490E
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 11:00:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 959C0198E88;
	Tue, 30 Jul 2024 11:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hV0gUfqf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AC3198E70
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 11:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722337212; cv=none; b=IabjffGu1ws1vXeQmsIvaPOGZJQXlSjJfkX3LMVTrJCHowSddSVaVJr3JV80LOeehEi0rXUJxq+n6R2d4j2NATG55yNmz2ERyh1n+FVhFI1fsGsO7Zd+iBBSzk4MFulQ46DYWaLjwo24HB901A1Ar+9lkYnWy6wL7Wj9H+dm2G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722337212; c=relaxed/simple;
	bh=QD6spo+bFLPighUtW51gXlag/RhYg6a6i3f7wy17nH4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ULP66UkwRX5AezwEdgxqcX3yOBGapKzUj9JeMB4v1R9yrkwWDbpzkQclVSQRKiNB7Ay/Gq9yWzV/pS9epArgA/FT3Xwe6UO1hNdg0fhgZ6ydj4kadMMZoZMcIAUW+HFFkGTdEq9e/lU5H01KFR6ie7dulwRhxPT9u6en7a7sjbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hV0gUfqf; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4280c55e488so16805965e9.0
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 04:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722337208; x=1722942008; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mQCFipYtY8/hj0e/9Abpi/TJp5VX9Qu+dTTpHsBiojY=;
        b=hV0gUfqfBH9KqiSXov+ZWSwT1CSlKL52UOBZLg6yPrLGObvPGyADSSDgp8CyCXlq7r
         CwfRIsHm6h/u4bqvrSXpQcM+6BZ/9rWcScTflnKIztNiOPodYUQEYLkpHeMeILhd3MnE
         7eq1p81uH6xBLZzmT3jgWHaSRf8eYolFrXJWZOLql244UTNSJ5rXvwMEqrJULM0HU3+R
         aA0lKEMcRIwfpXHFeHLg3scM/JrD57KRg9IFX1Bxli85PUbhwMixIyJfGt/NgZXFLLXh
         tWt3SvhOOnG9g0Kjb4AqFTuyYOFsh2TAV089BW5YfBWJ3Fw8om3PUCf3nY8CK/bPDd9L
         LKYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722337208; x=1722942008;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQCFipYtY8/hj0e/9Abpi/TJp5VX9Qu+dTTpHsBiojY=;
        b=XhUIfUR8CRz2oRBsFkU6FlAdhv3528XfOgmvrB06GtaKgnBJGuWKqGPqDg3bWmKLQq
         2lfbRtx5eSLHr4LrK3DvFj7v0XmHofQuerqA4+b+6PnYDCxROKzqNY8KK8aNpItYaKXo
         CyxgMxRaYf7aYPTmLaD4ORxPGSmosrAjLQjVaiQ8Ffm9eUtb01ORopBWp/kGsj1/KFB9
         wI5vTDg6SwBiSdtktlOhV9Xk/FYs9VnODC0JdbRhRJA/T3aMaEZF3+2121sVh9vpjmVV
         U9ldjvJvua1sgCxBkuBp9MYKYbsg3+IiBT+W5S7vbCe8TxaGVP+yyTwS8EnSrLTv8VtX
         Wq8w==
X-Forwarded-Encrypted: i=1; AJvYcCVaWQe/hGVO6DHJXTJNpMJ5FLTL3sC1qcxeh+mbAPBLCG6FhyJRra08DJdVfGE49VdPQzCmUOhF14R1F67IbtyzAWky/1blp/Y=
X-Gm-Message-State: AOJu0YznB1vSLg1nmwkmOt+66HrxNN/R/PYsovd5B5zaoVaW/89qWG83
	IvWk2rqRTwbRET/gxbL0N35WOayfdxaOs/FbgKi7GBikPMo6qTSh
X-Google-Smtp-Source: AGHT+IFXJYXz8aXQeSOtpyfbkMj8K/nb93coyh9ncEH2XAkdHayRKE9mVmdqLir4Uy1zFzpuSkCX8w==
X-Received: by 2002:a05:600c:3b17:b0:426:5e32:4857 with SMTP id 5b1f17b1804b1-4282439538cmr11094765e9.0.1722337207695;
        Tue, 30 Jul 2024 04:00:07 -0700 (PDT)
Received: from [192.168.42.104] (82-132-222-76.dab.02.net. [82.132.222.76])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4280574a8a2sm214922735e9.23.2024.07.30.04.00.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jul 2024 04:00:07 -0700 (PDT)
Message-ID: <5972ec07-bb9c-43a7-871c-81241a31bb70@gmail.com>
Date: Tue, 30 Jul 2024 12:00:37 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: remove unused local list heads in NAPI
 functions
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <0a0ae3e955aed0f3e3d29882fb3d3cb575e0009b.1722294947.git.olivier@trillion01.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <0a0ae3e955aed0f3e3d29882fb3d3cb575e0009b.1722294947.git.olivier@trillion01.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/24 00:13, Olivier Langlois wrote:
> remove 2 unused local variables

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>


> Signed-off-by: Olivier Langlois <olivier@trillion01.com>
> ---
>   io_uring/napi.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/io_uring/napi.c b/io_uring/napi.c
> index 4fd6bb331e1e..a3dc3762008f 100644
> --- a/io_uring/napi.c
> +++ b/io_uring/napi.c
> @@ -205,7 +205,6 @@ void io_napi_init(struct io_ring_ctx *ctx)
>   void io_napi_free(struct io_ring_ctx *ctx)
>   {
>   	struct io_napi_entry *e;
> -	LIST_HEAD(napi_list);
>   	unsigned int i;
>   
>   	spin_lock(&ctx->napi_lock);
> @@ -315,7 +314,6 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
>    */
>   int io_napi_sqpoll_busy_poll(struct io_ring_ctx *ctx)
>   {
> -	LIST_HEAD(napi_list);
>   	bool is_stale = false;
>   
>   	if (!READ_ONCE(ctx->napi_busy_poll_dt))

-- 
Pavel Begunkov

