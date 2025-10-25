Return-Path: <io-uring+bounces-10215-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 94597C0A120
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 01:41:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A19514E601D
	for <lists+io-uring@lfdr.de>; Sat, 25 Oct 2025 23:41:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC5882E5B1D;
	Sat, 25 Oct 2025 23:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="V5QiEJRy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172362E3AE3
	for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 23:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761435679; cv=none; b=hsviTpQFc5CLDosnoKteWL/qeVEw4cfe5SsKRfutDRquPaYk51WS6lFLzNxlGHSFxOX5I6C5vLijGOm0YtTtfOJEqHPpCx2INO5qj2P69lizYiYXi6yqins7/W1pHEeihwxM8roKuu+aKKanNynWVEwy0gcUUoPSk8ChMfUrvMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761435679; c=relaxed/simple;
	bh=UWwXy6UzhIRLinQQbmwb1KG/M2Yo7LauXWQNdG35s04=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pAuu3fH2mnDTDhQ3G4gdtIUe5lEyWg3RaccJtqw7HgCBJWu/7EF+xR/9TD3dI/jDSk1V3zCrYBtVB73/t2RlAjiM6ArXc6RxIiFXO/MV3NlGtb7dYlSs5MrZgWlduxk8q2ncgBtJF98YpevffDzg7Csaug47BUG6CuNc3i5LYlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=V5QiEJRy; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-9379a062ca8so141880439f.2
        for <io-uring@vger.kernel.org>; Sat, 25 Oct 2025 16:41:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1761435677; x=1762040477; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U+1U0oWnvhmV3gcT58peg4jR0wCVhjayAqtKoI/J3O8=;
        b=V5QiEJRyTQ4qVEUcp/DLt9gynTeF/fqc1LAyGNVPl2ZKlDY5BRFCMT4cc/B3QX0/mf
         3vgNPoYf3kRUo8udXEY43114NUnjV3NO3jx458+7W5oTuRoQBpPISJPhRfgaWVCJBDlU
         t9EuyXo1Bn4/hJ2qpCx4/8eD31gYfMEH2sNmzdUUWBxIWmXxoxtbRSi6pTSMr1a4X4i+
         9KYBbA6EEOcsr/WhbWL7SekaNHuMGf8LDWVIljP5tyyy3/hckDGvmEXd1qAA0fnCyo10
         wcweBFmoxVKYAfBUOuRg9j7v1+Pn2x426ZVOtvU8CtkEKr7l5c1/LbwKpxkneZc/cu5y
         cuBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761435677; x=1762040477;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U+1U0oWnvhmV3gcT58peg4jR0wCVhjayAqtKoI/J3O8=;
        b=Eie2rTmSBwUSqgtXL/O/jt9eFIEEKnHDpeRe9yT0A/hCYmhSqsUHSiivM61i3E3vYv
         Z8AYy9s9DfaPQl83wu+eVKr95vmaqxj+azedvYPoE4nFQJLlQxTIExWpapghxXTffa2X
         P39DGLgLYoFxDSX67i4P48pob1/3hfCz0xslnB1AxLcohtzVYfmvwIzC3wcWuBO9IZq/
         Iht+MfrHAh8NpFqBItRyLljfKvpW7dZP9oQTIqzjB34vfUdWG5/lFLNLv+sw7q9rhOHK
         C3qYdjR4ye+Ci+hgr97KFxCKYXHlGSgoLR/vgPDlLGCDLqNp2Y/pUWri60Vo3p/2sSoG
         3zQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVllATOkK+t7o92ZXkPH+qVVPiXuMr5iffsxplc4hKZg2/YVs+fPooHjSgBwRfJ+WmpPF6g6FAqKA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz06KmaAVSUaOiOT3klywOFB46doSSrAg6/Ax5ZZIzoASeeDvan
	4dZTqYBaFv6FqhQorU07BXUhQo2NogUIgY4PE3k+mkN3oCRIIA5k8KcrYzXX90gMn1w=
X-Gm-Gg: ASbGncsBcdnijRI3l9SHJKC7Q/g7M+XS7A7FOYumm2GPuYPDjuFqKDAn/nS+HAdhF70
	13IA/X822C9qjZNCEy6nfHto1byX5rg9LepcH9/IwC455FQQBv36FRhvLHO9ArDCfuDValIjgqm
	tbRdyxoqlDInXMjytjB9FSqNOg1BzZYyuuYsmbif1xsgqIET+UG6sFZEfTfIvsi3rp4GFXRxmou
	T8bAAKBaBSxzboNSwfLg1p5xbPz1AnVM/1l6XMg4X6t6/9KL2Vz4yIJCAzk9rZoqfI9XUBpOK3Y
	oHG/+U19tqL/f00WOkUOeJYo7TNBqJjD+tb1Ga3UaBNo+UULXYDAm8wk1i90VkSSx0BP1Uqk1BJ
	seZmT6B9F+vYdWazwaN9iSKlTEQXCgWh7fgnykjsXoPM+3x7uss+n4CU6N6jb/gBUEhKzKQWcOg
	==
X-Google-Smtp-Source: AGHT+IFpdI2tMF+arhoPCj90UOHrR1Z3J5OwTfJEWoq7vT59d1IQXp8f5M40xtA+2iJq460pdjdcYA==
X-Received: by 2002:a05:6602:1651:b0:940:d1b4:1089 with SMTP id ca18e2360f4ac-940d1b41221mr3943054439f.1.1761435677214;
        Sat, 25 Oct 2025 16:41:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5aea9e35f77sm1280344173.55.2025.10.25.16.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Oct 2025 16:41:16 -0700 (PDT)
Message-ID: <f1fa5543-c637-435d-a189-5d942b1c7ebc@kernel.dk>
Date: Sat, 25 Oct 2025 17:41:15 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/5] io_uring/zcrx: share an ifq between rings
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>
References: <20251025191504.3024224-1-dw@davidwei.uk>
 <20251025191504.3024224-4-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251025191504.3024224-4-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/25/25 1:15 PM, David Wei wrote:
> @@ -541,6 +541,74 @@ struct io_mapped_region *io_zcrx_get_region(struct io_ring_ctx *ctx,
>  	return ifq ? &ifq->region : NULL;
>  }
>  
> +static int io_proxy_zcrx_ifq(struct io_ring_ctx *ctx,
> +			     struct io_uring_zcrx_ifq_reg __user *arg,
> +			     struct io_uring_zcrx_ifq_reg *reg)
> +{
> +	struct io_zcrx_ifq *ifq, *src_ifq;
> +	struct io_ring_ctx *src_ctx;
> +	struct file *file;
> +	int src_fd, ret;
> +	u32 src_id, id;
> +
> +	src_fd = reg->if_idx;
> +	src_id = reg->if_rxq;
> +
> +	file = io_uring_register_get_file(src_fd, false);
> +	if (IS_ERR(file))
> +		return PTR_ERR(file);
> +
> +	src_ctx = file->private_data;
> +	if (src_ctx == ctx)
> +		return -EBADFD;
> +
> +	mutex_unlock(&ctx->uring_lock);
> +	io_lock_two_rings(ctx, src_ctx);
> +
> +	ret = -EINVAL;
> +	src_ifq = xa_load(&src_ctx->zcrx_ctxs, src_id);
> +	if (!src_ifq || src_ifq->proxy)
> +		goto err_unlock;
> +
> +	percpu_ref_get(&src_ctx->refs);
> +	refcount_inc(&src_ifq->refs);
> +
> +	ifq = kzalloc(sizeof(*ifq), GFP_KERNEL);

This still needs a:

	if (!ifq)
		handle error

addition, like mentioned for v1. Would probably make sense to just
assume that everything is honky dory and allocate it upfront/early, and
just kill it in the error path. Would probably help remove one of the
goto labels.

> +	ifq->proxy = src_ifq;

For this, since the ifq is shared and reference counted, why don't they
just point at the same memory here? Would avoid having this ->proxy
thing and just skipping to that in other spots where the actual
io_zcrx_ifq is required?

-- 
Jens Axboe

