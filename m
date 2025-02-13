Return-Path: <io-uring+bounces-6399-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 53764A334B5
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 02:30:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D971618882E8
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 01:30:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 923811A29A;
	Thu, 13 Feb 2025 01:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b2UUFdOH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C570E8633F;
	Thu, 13 Feb 2025 01:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739410212; cv=none; b=areQkjjcjf5MHOYkeTiN0Sy28Y9ft7jlAHPXkv9CoEmEUSBZ2oV19fv+31X+KkC8cDlbFSFVHELjq6N4tsSbq6SEI/0xC7eiVgtE7r3vdTLbZFP0kW212+9NlOM8/+AdZ+/uo+BYeIqHc3rcgTTBva1wBPyIGhgS67PnprsTB7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739410212; c=relaxed/simple;
	bh=1oP8+yiNpuNsGHFWFMJieA9478TEX9lWpwyfOO3av1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZxiNG59NR324CwN3GHvlb3+vASI/sy/+OCPTmNU5FIeFiF62FdVBxKz5nf3AC+cJFvMspp2BPg0LdGatdD2BC03wszI5+9Xb5oR5uS11tF8Fm8raT7EOZocilkUblh2RWQUf06f2B/M7E6nDZNFg/JgYrm9JT4LTXMgmFF2olws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b2UUFdOH; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43948f77f1aso2063775e9.0;
        Wed, 12 Feb 2025 17:30:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739410209; x=1740015009; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xkj3Jhs/LiPOwY1FdTT3veaDmNAKq4KIcT+mS0wK9c0=;
        b=b2UUFdOHa0Z5V9Vv1uGfGdCmAigHbI0muTEo+nUSELZkXSzc3AOqkHTHcGnI7loXRG
         KJEu8DLU73HJPBE3MPIOB841SrpmfQJQCr9euWi5u06uSEM71JNMLETL1jm1v5b/66/g
         9oAXIPPbkcILTCpmvT6ZOc8gGlz8IQCO5sHPRfCzlqbMwN5JwhdaNEZW9FQh319c2uic
         4qp9nbJC4KtRMRazkVTU6Y6P7NtXnmrNOwVxhxyopLFozo4D/eUgayidQK4an1RH65FZ
         PFuyCcHN5+g9LrxnwM5uPuLvRgGtF0xEKqP8/eTuK+G5yZ7El3CKZDhsp6hJilSkR3va
         ZzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739410209; x=1740015009;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xkj3Jhs/LiPOwY1FdTT3veaDmNAKq4KIcT+mS0wK9c0=;
        b=w2eWKN57Lm5dTmLFTccjXA9HVpMk6LkxpYmChFOtyMevCGjLHQHxRbXzOhCsaBJftN
         19fvzPMbD5slrH3A16jZ6fP5t1lSE5ioEnVTJ098K+Oau7rxNoBGIS/tT9PkjmxnPryz
         ibvjMXLVNQHPLuiujKus2hgKsBuXyGp9FSh19iGcMkdIoTkouQ7RTtxuBJwQadD5Y7vO
         5RH2XpX3gTmY1fnyDXi/io2F63vf/hI0PWK2bOrUvZCeQb6ybDlRG+BrWou4+oF+RK32
         wQEAR7cfeq4NeJRB0OG7/hheHcexYzsnrbY95JTl284xU+IA2gKqy1uEk7/UVd1qVm1c
         ytzA==
X-Forwarded-Encrypted: i=1; AJvYcCWSy9qSOo8b+I+N0enUu1pJxMcdykgywzkvo34bop4qcALDcohC/seXirdZ1Ym70P9XC/C2rk73+A==@vger.kernel.org, AJvYcCXU1677U4td2yxGiMc7P40pN61IhFhfMXsvE1NzIny34JZ/ax1+2rsJlvTtSn8ytLZdk2XdRUe5pQVHzJE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbvN6g9S7qUzOK1nDIQDGT6w2ZpuL0w9oK0J6R1e8GxnDoONO/
	aCWGAyKaciFngsfctp1OzBRwj8+fZ9NAd9gAyuvAHOo/7VG1egtC
X-Gm-Gg: ASbGnctw2cxlhvGJd6ZoFT04j3X1SJpd8YKXndWMUTe0k9XM3H5s65DWbmOAgTO309Y
	tnTENwOvGagqtEghh8ZP0tdPUP9wl/MhSiR6tsXpYtEPO0rXu+c9NWcRBqiVPtukhQb0hIvADGz
	xcM6yYibnLh26GBmzGIMk7zPyXvC1p6N1XHJuvcruy8lr60cpARV8t0kjEpDLfdOD4nHCtIb0/m
	fLA8JoUHV7yY/vAtnmsys/sIyx6zXRbHmb36l53/hQ2DDqPvbU7UFpYgWTaOKoCf/VRDmX18h/4
	3R5U8aVnRlVfXgfCDxARrl+K
X-Google-Smtp-Source: AGHT+IFh5G9l2WtNhBe+LDmw1hg+lh/Obv3A3yT9Fue2r//FfZruq9M3Jf8jjNP5AyidOiSsq+juDA==
X-Received: by 2002:a05:600c:3485:b0:439:3e90:c535 with SMTP id 5b1f17b1804b1-439600fed0fmr16888215e9.0.1739410208772;
        Wed, 12 Feb 2025 17:30:08 -0800 (PST)
Received: from [192.168.8.100] ([148.252.128.10])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258ddbbdsm442629f8f.37.2025.02.12.17.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2025 17:30:08 -0800 (PST)
Message-ID: <d24b097b-efea-4780-af67-e7a96eb1d784@gmail.com>
Date: Thu, 13 Feb 2025 01:31:07 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 2/6] io_uring: create resource release callback
To: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, axboe@kernel.dk,
 linux-block@vger.kernel.org, io-uring@vger.kernel.org
Cc: bernd@bsbernd.com, Keith Busch <kbusch@kernel.org>
References: <20250211005646.222452-1-kbusch@meta.com>
 <20250211005646.222452-3-kbusch@meta.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250211005646.222452-3-kbusch@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/11/25 00:56, Keith Busch wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> When a registered resource is about to be freed, check if it has
> registered a release function, and call it if so. This is preparing for
> resources that are related to an external component.
> 
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>   io_uring/rsrc.c | 2 ++
>   io_uring/rsrc.h | 3 +++
>   2 files changed, 5 insertions(+)
> 
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 4d0e1c06c8bc6..30f08cf13ef60 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -455,6 +455,8 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
>   	case IORING_RSRC_BUFFER:
>   		if (node->buf)
>   			io_buffer_unmap(ctx, node);
> +		if (node->release)
> +			node->release(node->priv);
>   		break;
>   	default:
>   		WARN_ON_ONCE(1);
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index abd0d5d42c3e1..a3826ab84e666 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -24,6 +24,9 @@ struct io_rsrc_node {
>   		unsigned long file_ptr;
>   		struct io_mapped_ubuf *buf;
>   	};
> +
> +	void (*release)(void *);
> +	void *priv;

Nodes are more generic than buffers. Unless we want to reuse it
for files, and I very much doubt that, it should move into
io_mapped_ubuf.

>   };
>   
>   struct io_mapped_ubuf {

-- 
Pavel Begunkov


