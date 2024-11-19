Return-Path: <io-uring+bounces-4803-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A25049D1D68
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 02:37:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50D041F21E58
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 01:37:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699D7175B1;
	Tue, 19 Nov 2024 01:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eyvpTtws"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8A45E57D
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 01:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731980251; cv=none; b=iLZLSiFJFq1uwerz+CBWMnn3sUAU/3W/w7E0QbCZkm4aqNN8C+yAKeN/0Ld4r7rOa1442jSpGjiu1S1U382CzDZnIBQ93tefIx6dCpXCQGimx3glPRpHQwb39fIgCMSmKh4cYiOfTHodwYc04/ga5UIuzCeORIihSndYZKNrCW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731980251; c=relaxed/simple;
	bh=ASzHljDeAvhqPFCFjuBEjJ0kizyV8lvSVU1NLUsBNGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=plZHBsRkxrawa74V8gDA/FaF6iM8YGZZ5aRSTd4+Q6W3Rq0y+uyPlvpxtTX+H7W4D7/OuFfuk/aZ2kAyJVDFowFZ9FQXDtclnBBhaow9bHUGh61FMt2nGEdqUhbmS+UuHpK8Z9r67MMux1XYZ9tNdmSRy4uD1KQlhoO5HVDtXdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eyvpTtws; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-5cfaa02c716so433238a12.3
        for <io-uring@vger.kernel.org>; Mon, 18 Nov 2024 17:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731980248; x=1732585048; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LknFIxvgRueSdNPGP77r/r2k7CK5OUWVVpNjfrzA4qQ=;
        b=eyvpTtwsBlZ/8KZY+6HlB1XzaVx4F0p+CY9UZQMoRDyy8pyZHPdaPcRLUOYEsLYbAO
         Pg2F1eaiE95RIkmbJAQezrOB2ZMxhpFvXaFaINMo6T46uj/uEBWxq9XjKLgGDc0xJVID
         nbLDjGd2BQmiAGvLjnoAuvUFcvYAq1jCtOg2VWqVASFkRR4Qvhd2VqqNwkF0b4Q8uiFz
         AAA2GcrJajp2H6N/gKVZ6GyDHLDYnZRuRTQXd5o0mWJhsn6JZnKzuR4koSJkQ/Hdi/YM
         9pawzsZ4kpzOxbgQmzUvvIu7PXLiBeIkEz7kDuvBkBzajlbd9mN09+AxK9TzSWKQeeLC
         wxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731980248; x=1732585048;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LknFIxvgRueSdNPGP77r/r2k7CK5OUWVVpNjfrzA4qQ=;
        b=OjQ9UdVbHyI/9PHYqMaG8f1DVdDUvpGGp3MDXrYNC6Ta+omQNxlLnkV8v5Vn4oTt5/
         Uc30NxIf4Bq9FVEKEQS7h7WSu2sMt/m/uvorMrd3rQgOSW604sSwnBgQjRnbmDgtITnV
         E705UrKAkfS5b05121yl+LWXdeWJAPl1M88TtXComXmvk0YqFSiiOOr1PmMDOlTYYvd6
         dBlayvZtNUpowRoNtAmZw4TBWVddbiFtj3gCo/WtuDesGuwVkkRHnbDVQEOC3vyWIXeE
         R5AoODnoIHgKuTGggZwRfLpEC3zgC7XMgYV5LplroMQUcTypGtCeDWu0ga4DcRyoq7Rq
         QUzg==
X-Gm-Message-State: AOJu0YyVrazi2V1HnB2/n9M2RYKSeMDrlR1Wt0/95KZoyvIjDGfNEFPt
	hyYK5QCcL1wrPEVNCeojeYh6nBwYtAWMDPLQn+YokIvz2d+h0ifBxnWrkA==
X-Google-Smtp-Source: AGHT+IFnPIJauLN0VRcmFd3FYnv5c7iJpmr2Kc7+YtWMtdcCPR9e7jFufFhQiXSQ9oDD45Tnr/vRdg==
X-Received: by 2002:a05:6402:40ca:b0:5cf:a1c1:5289 with SMTP id 4fb4d7f45d1cf-5cfa1c154f1mr7282206a12.21.1731980247257;
        Mon, 18 Nov 2024 17:37:27 -0800 (PST)
Received: from [192.168.42.163] ([148.252.141.248])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cf79b9faf4sm4930534a12.33.2024.11.18.17.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2024 17:37:26 -0800 (PST)
Message-ID: <2189835b-b686-409f-8f4d-bc2ef944ba79@gmail.com>
Date: Tue, 19 Nov 2024 01:38:14 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] io_uring: prevent reg-wait speculations
To: io-uring@vger.kernel.org
Cc: jannh@google.com
References: <fd36cd900023955c763bd424c0895ae5828f68a0.1731979403.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <fd36cd900023955c763bd424c0895ae5828f68a0.1731979403.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/24 01:29, Pavel Begunkov wrote:
> With *ENTER_EXT_ARG_REG instead of passing a user pointer with arguments
> for the waiting loop the user can specify an offset into a pre-mapped
> region of memory, in which case the
> [offset, offset + sizeof(io_uring_reg_wait)) will be intepreted as the
> argument.

Jann, do mind taking a look? I hope there is some clever trick with
masks we can use instead of the barrier, it seems expensive.

The byte offset user pases is 0 based and we add it to the base
kernel address:

if (unlikely(check_add_overflow(offset, sizeof(struct ...), &end) ||
	     end > ctx->cq_wait_size))
	return ERR_PTR(-EFAULT);

barrier_nospec();
return ctx->cq_wait_arg + offset;

Here in particular we know the structure size, but I also wonder how
to do it right if size is variable.


> As we address a kernel array using a user given index, it'd be a subject
> to speculation type of exploits.
> 
> Fixes: d617b3147d54c ("io_uring: restore back registered wait arguments")
> Fixes: aa00f67adc2c0 ("io_uring: add support for fixed wait regions")
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   io_uring/io_uring.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index da8fd460977b..3a3e4fca1545 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3207,6 +3207,7 @@ static struct io_uring_reg_wait *io_get_ext_arg_reg(struct io_ring_ctx *ctx,
>   		     end > ctx->cq_wait_size))
>   		return ERR_PTR(-EFAULT);
>   
> +	barrier_nospec();
>   	return ctx->cq_wait_arg + offset;
>   }
>   

-- 
Pavel Begunkov

