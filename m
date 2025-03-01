Return-Path: <io-uring+bounces-6876-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 194A0A4A76E
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:30:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CECBF16B5EC
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BAB25D477;
	Sat,  1 Mar 2025 01:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="myZjqJDy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22B91401B;
	Sat,  1 Mar 2025 01:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740792599; cv=none; b=mQ8nPG0aPojBTC76x4yz8wTc+yqD624vBpyV7YPHoaHVzLHb0K1ukC3LCvbxy4KH/VjHMjSicUOCUpVOR2gezQ0mICO6zRjLLtd9JuQCDv1loQNkwp5YD67Pw8FnG6Y2jpaxMRbZCpu8FDZfP44X8C+xYYRKv0bwwXyAQTF1CV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740792599; c=relaxed/simple;
	bh=XoGiOBjFqoa9nH3IYLssRq9uTZ9z2zegaFE5so9AYDc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WMQXXT+gcj/bOw5djl3MR4/UpymvelvprM4ojBOFGVtf26QfmQ09ouPA5+Sm3B2oyvnS+B8lsN8wOJf1F71hNiei0+LezYTsMLZerY+J7wvBDnaEMapspaxshMtszasSWtAKgrTkz5voHN68neKvo8RtLh6E6B7Gi9OFwyMDQU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=myZjqJDy; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5dedae49c63so4926678a12.0;
        Fri, 28 Feb 2025 17:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740792596; x=1741397396; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gBsTEmm2NFXsGIm9VrQhE7SE/X550vg/x0Q06Ef4Uws=;
        b=myZjqJDy+9YrpwuMXzEwg65j+FcMQRLV3HjMU2AkoEGe5MMf23zjd8a9eh8938MGJ4
         JdhV1MmInPBIh0ANK6kRYoJ+IoZfN74YQyiktXutUTjDNEa8fF9+cCr8IpMt6jUvkTTE
         sZMv7HWttwrFr4QFB3GJ8Frxnkpp0tOhvL5WRVeaeckErOJK2dIOLm67CVARn5WmbP+Y
         v4l39qh3eJdTcaMYNM4BU+IjfefCIdtrXxXTEvehh9FZ4Phe3l5WE7Yoadm3ZsRKzqjt
         CByLE6u8VMVzpgDLn2o9iB7Z1U8ypXksIaAG/ZvTgFdMj97d6EiInZK8LHYM82c2Y5dL
         0jXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740792596; x=1741397396;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gBsTEmm2NFXsGIm9VrQhE7SE/X550vg/x0Q06Ef4Uws=;
        b=CCWuiailbszuOwr333cFl2eYGtNiotPowxHC0KgsHBH/00cl6xNwhA68lYNcFFDcA4
         KGU1tNougAcuGDsLN7/jNifPF8bdkrLh4mLzHAoeSKy2bN7MqmnxxO13Pn1lTHPlDBpL
         quk0bBYMIiLvyhhNIFgF9+n6uKRv5VpXeUT/qqMSN3VlPVnI6G8TN8zUJM4KL31HeXp4
         q6F4rRHnKcm0m/mvgKE1P1w7CbFcOuwWeoeZ5JYkR8sn8BIVM8k0fsipEpnEeNjZXQD3
         3ZeO5E4L8xe6K7STNwzdnqUg0k7y3U6BlYW7Ws0g0rxrYpa0TbFUHh08atJSxEFFFKVK
         8AwA==
X-Forwarded-Encrypted: i=1; AJvYcCWf98aT7HPRCpRscNOelZKAOxW23urakRoIxki79iIPXH3aEzO1jKoWGWx/IXMtmGE2LZwBMkDJW1WVNwU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyKJ9cE0QW8FQmh0rdSe/GjuPWpF9gEj0+gn7F7rWKawvkViugn
	J/UVnJVd7J//K7KnlcxzgWNG5Op3Lr1a6YGwGkZdrpWSBpN69+XZqb/6hA==
X-Gm-Gg: ASbGncstEi+T8sR/vkBLQXqD8JsQy7QPuA0AWOb1v69jza2ka84iqICx2Pecbv3eFmR
	dIh2R6X09gSF36szQUz6Dkl/O8eViqhXtwibbmiEohrRUhKosMZhgndhpg14od7QrPN5kFH1+cQ
	EnY2X+byUE0B7k3VdvOqIPQEnzL2oyDLXkWGcKfEXs6uOADLpuYyn0YK8BNIljFNez00PzvF88W
	BTaW6vmDIGkubkc3J/3+gOP0LsLmhCxktxZeMIQZ53mCt2jaBVwHXbNvV7kGUhFjcC8+xRuPiDh
	I37vgoi7kFltWvY5trIcgIP4Beq6m8gyST4ZPH9nyZuJBxUJIck/Jqg=
X-Google-Smtp-Source: AGHT+IHYUhXuWU0N5WG7qoHNGkQLKMFKP/jAELujC8+bQzMOfspfD43Bp9CcaJcdeNrMEAvpK1WUwA==
X-Received: by 2002:a17:907:94c8:b0:abe:dd15:77bd with SMTP id a640c23a62f3a-abf2682b22bmr631323966b.51.1740792595914;
        Fri, 28 Feb 2025 17:29:55 -0800 (PST)
Received: from [192.168.8.100] ([148.252.144.117])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf17fa4a4asm336579866b.92.2025.02.28.17.29.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 17:29:54 -0800 (PST)
Message-ID: <f74d6e16-29fb-4a9a-a6aa-9a7170c683ba@gmail.com>
Date: Sat, 1 Mar 2025 01:31:01 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring/rsrc: call io_free_node() on
 io_sqe_buffer_register() failure
To: Caleb Sander Mateos <csander@purestorage.com>,
 Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250228235916.670437-1-csander@purestorage.com>
 <20250228235916.670437-3-csander@purestorage.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250228235916.670437-3-csander@purestorage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/25 23:59, Caleb Sander Mateos wrote:
> io_sqe_buffer_register() currently calls io_put_rsrc_node() if it fails
> to fully set up the io_rsrc_node. io_put_rsrc_node() is more involved
> than necessary, since we already know the reference count will reach 0
> and no io_mapped_ubuf has been attached to the node yet.
> 
> So just call io_free_node() to release the node's memory. This also
> avoids the need to temporarily set the node's buf pointer to NULL.
> 
> Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> ---
>   io_uring/rsrc.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 748a09cfaeaa..398c6f427bcc 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -780,11 +780,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
>   		return NULL;
>   
>   	node = io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
>   	if (!node)
>   		return ERR_PTR(-ENOMEM);
> -	node->buf = NULL;

It's better to have it zeroed than set to a freed / invalid
value, it's a slow path.

-- 
Pavel Begunkov


