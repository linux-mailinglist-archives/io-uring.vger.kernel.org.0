Return-Path: <io-uring+bounces-3833-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D9969A4707
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 21:34:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C5151C20C47
	for <lists+io-uring@lfdr.de>; Fri, 18 Oct 2024 19:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5385D17E015;
	Fri, 18 Oct 2024 19:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UdxVjwNA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7C4757F3
	for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 19:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729280051; cv=none; b=eqZTW+x3lB6e4+GFL4pQ3HZWAFvdvWf6ocxnu6uW+EVWE2ROM8VRHFaidNxRD6t15xpAqZ/Ji1lUVvCpeFiRbVS2xdZ33rf5S672+hwkjALPUNCS5aYeVv2ZQNb0IhLYdUtdgbeCYkC0owTqcGPZ9JU8/lSMh/hu0s5J1L0TpoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729280051; c=relaxed/simple;
	bh=bhgixIJUxp6gvX/z7IKrZWXYe9b06adrUhE2/3+FOx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dlERCkQXkh/9TVr2QrizyfiEJNIMnCh7z66pe6ik9b4TmXHZGx23qq7x6TlwMcippTq2tX2X75xjIGPk6b9xC2O4EeBKZubJMXrQNDJLrsbr0NLVDtWgmImE1hF+8HOob1HExigDUuM2+Wd8QZPRFz/n4SufqqchRpwzMeQuNLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UdxVjwNA; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a99c0beaaa2so394405166b.1
        for <io-uring@vger.kernel.org>; Fri, 18 Oct 2024 12:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729280047; x=1729884847; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WEwXk/yBj3sfyc9p/8LTjU4QNIeRICrgt8jgXQGKOQI=;
        b=UdxVjwNATxKQxJTNZwGE52b3uY3AvB6uDsc+4/MVSv3O6uYmMOgViw0+MJ0FepzBLI
         UMEA6HXh5eNMYV8glFrSLubwnfLphzmVoBJu1bmaLMnupRp1EVqGFSEhjZk+4wV75UKp
         gGABjN0XeEGSrB9+FfPTKc1B2Gn19q03ZZsiAHDSfaytYVzSOf9d3iL7TnxCkut26n/G
         zXMSnm85JIE6firmUrtxS+1Wkd3nTRaWMI3ndDIVHWXGzqaYyYnTthsrCYVlkr8OEfZK
         zsRyok4h7y5UG9ZxiQttYc+C+gEwUarW0ii+4tmlcfgA9bKdg7EXlV4QSlmM18HoSUIm
         rItQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729280047; x=1729884847;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WEwXk/yBj3sfyc9p/8LTjU4QNIeRICrgt8jgXQGKOQI=;
        b=GTCWXKTfoecFyPcg0rTxIqAIWDik21wUJUO4wzsz3f3WXidyBgIJ1x8MzVA3Cc/HaN
         GZTRX91mjpapGuLoB348gUxBMabNmEEaHV5DZ6fc3VMnSbmEwAtuniKhDhlypsUQ7A+e
         LR44jW3GxIcxFnhz9SdZLoe5u9rBN7zYZt7snUgMXQiIHHReFrIGPAA1XIMKamZrQ7yp
         YuOMfFUDsLQ935z7hxjDiLach81tk1kUgWW7/pcDH/VD0NhnjYI1NbCMpLJdWeFAl2zZ
         UiA48/JNbvbn6/VJwvqJBIWSOEBh5m87X39N9ysRFkXcNZK62bqjIseHKKLfbiCXlUHf
         vRqw==
X-Forwarded-Encrypted: i=1; AJvYcCURWkFoIGCUXCODeImv172NASDATwqxcLmeQtlnwIWBEU8YvZNwkj6TsHzTZvUKyVISe1EMv2W+PQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaOkmYQJsbaNZOcvh6IYr5PS3FR16GRyYCNP+EFH6rGpTx5a6X
	7LEPVyRBAaD/3MaHKhM/pFSUX0oC+CjfC7ryyiJqwTmB3meL5J0m
X-Google-Smtp-Source: AGHT+IFNbAKGnY3QHbUoEuUTvTvpEbaMYF95FkFJO2OcKFvephaGG4aJCLSSZuKaA8Jk8P268kr+eA==
X-Received: by 2002:a17:907:94d4:b0:a99:f56e:ce40 with SMTP id a640c23a62f3a-a9a69c9e9c1mr347479866b.47.1729280047175;
        Fri, 18 Oct 2024 12:34:07 -0700 (PDT)
Received: from [192.168.42.145] ([85.255.237.171])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a68bf4342sm130262366b.152.2024.10.18.12.34.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Oct 2024 12:34:06 -0700 (PDT)
Message-ID: <19d5a8bd-60cd-496f-a7ba-ffde5dd2e906@gmail.com>
Date: Fri, 18 Oct 2024 20:34:25 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] io_uring/uring_cmd: get rid of using req->imu
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20241018183948.464779-1-axboe@kernel.dk>
 <20241018183948.464779-2-axboe@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241018183948.464779-2-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/18/24 19:38, Jens Axboe wrote:
> It's pretty pointless to use io_kiocb as intermediate storage for this,
> so split the validity check and the actual usage.

The table is uring_lock protected, if we don't resolve in advance
we should take care of locking when importing.

Another concern is adding a gap b/w setting a rsrc node and looking
up a buffer. That should be fine, but worth mentioning that when
you grab a rsrc node it also prevent destruction of all objects that
are created after this point.

  
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>   io_uring/uring_cmd.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 39c3c816ec78..cc8bb5550ff5 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -211,11 +211,10 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>   		struct io_ring_ctx *ctx = req->ctx;
>   		u16 index;
>   
> -		req->buf_index = READ_ONCE(sqe->buf_index);
> +		index = READ_ONCE(sqe->buf_index);
> +		req->buf_index = array_index_nospec(index, ctx->nr_user_bufs);
>   		if (unlikely(req->buf_index >= ctx->nr_user_bufs))
>   			return -EFAULT;

The rsrc should hold the table destruction, but it feels like it
should better move where importing happens.


> -		index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
> -		req->imu = ctx->user_bufs[index];
>   		io_req_set_rsrc_node(req, ctx, 0);
>   	}
>   	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
> @@ -272,8 +271,10 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
>   			      struct iov_iter *iter, void *ioucmd)
>   {
>   	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
> +	struct io_mapped_ubuf *imu;
>   
> -	return io_import_fixed(rw, iter, req->imu, ubuf, len);
> +	imu = req->ctx->user_bufs[req->buf_index];
> +	return io_import_fixed(rw, iter, imu, ubuf, len);
>   }
>   EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
>   

-- 
Pavel Begunkov

