Return-Path: <io-uring+bounces-3505-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 18EC89973F4
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 20:02:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C271228326F
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:02:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 020F41E1034;
	Wed,  9 Oct 2024 18:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uPBZhbI9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406C11E0DAF
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728496927; cv=none; b=i84Pbi1PBrh/cSzFE9vDhUXj2Mi1ThbYa30cReTsYb1Te6RspP1DXBUdB0K0CkPmiAHdsxBQvSCK9PUw24WI9Fh7vN9m4i5GKi4Hz365TDnIatU5mzInn3G8+carAerlwdc9nmTIl3aruPriGsVHnRCewyIJMuAXMh9jksGjhnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728496927; c=relaxed/simple;
	bh=Qf9V8ZQyC/O6Sfiv4VMgBo0nGXgVGs4AOTjxhyCDUV8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WzNirdEGezuaQL6i86/d4I0DbCSdLerNIjtrx1uC5/rKxTs4/Q3WJjpKjNbvpevy9FANTp2VRnUmYCJGXCn2C6jq1mIm1ceX0PypVJIOyJG4eCYUmxIELCqrKCMoNYcLl7MCclEq+acsJULnWhDaLwsb9COUjB01MoQdzgEjmsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uPBZhbI9; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3a340f9dd8aso558545ab.2
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 11:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728496925; x=1729101725; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=71vyfRrMiXLC8TIrwltNXUxsnd4EZN2arRP0JW3TIvg=;
        b=uPBZhbI9+BytFh42cQIKVPCJPgWK2lsMVvcuJ2hi4SYgG3JqB2Aq0sTT9Nr1X05mV0
         sNBnCvClTHZkZbSfcvcqUfXyD0MEO+DJpZNMkpo9ohr30ELPuy3Ng5p30QKk8Gl8u5Zg
         aMq7D0dJj/O0R/Q2stcmaDRAQLNVaU7HUoZvOUGxHVKGG0M3M6/ogyqYXZmWtUB0M2m2
         DnEylDYJfuIjkjbu5tMQSiTXs7oXj2Ak0JCfGxJqcvuP0HTKBxY59iwJpsUTfUOnoYhX
         wZcAHbB3XeCM3A2peBxyxbLV83iXcm390rU+drVucKx2+aloAgDKQu7lUXv0WrYh0rXn
         bfhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728496925; x=1729101725;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=71vyfRrMiXLC8TIrwltNXUxsnd4EZN2arRP0JW3TIvg=;
        b=hgl49/p8Ph50F6VaTGet7eZSE960fWw6jEo9JarYokQYDkLIkbQ2MiD22jw1GU0w8T
         Q+ccjxre+mtHddS54W/Z4nxNMQ2KknNt1W0o5e8P2M0hcmB6dp+e9ZmuI5/Ru0KwZlnY
         r8LOqSSex71kK9q18itMbSsKF5ERXwCzE3XHLPRceeODNTaXGPcs59qFmuJ5hR7lAuTD
         Nqz/ctIxlk21nmHCTlgsiTeZcjhutSFuGb86HcBHI58mGna4FRxZdmYgai1O48RZI7KA
         TDzn2ixzGveZfWO8oLEGcFp4hLD4i6EWZMNyzzUUwfkl1CLfJ/Qx43rF6SHC3P3ZRckQ
         tbkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXn63UnXmOWU7klcauWGfiMHXnRydM0T62lgu6NQl3FQrh/P8CwGwbg/TTMvcHjW3Pqhl909Kb01w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNhCBpLld8tvPn/eEyqTpOKSoJBfiK7fasVCRxoBRynoHKrVIr
	8nvunarlk+L2eys9fHEDUqDgpkDiIF0I0XatbgoR6sWp9J4hv9aTseQAk2Nte6E=
X-Google-Smtp-Source: AGHT+IE8e4V2XSLVLdL3urDOS6/x7tgggWDr2jGGXIRFogF/XpIzTjTp/TQWMEXEjHXmxoEOuD4BBg==
X-Received: by 2002:a05:6e02:1c05:b0:3a0:a4ac:ee36 with SMTP id e9e14a558f8ab-3a397ced8bfmr37948725ab.5.1728496925143;
        Wed, 09 Oct 2024 11:02:05 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db88f661d3sm1355809173.177.2024.10.09.11.02.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 11:02:04 -0700 (PDT)
Message-ID: <f3b7b9c3-3cde-423f-b8a7-28cead30204e@kernel.dk>
Date: Wed, 9 Oct 2024 12:02:03 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 10/15] io_uring/zcrx: add io_zcrx_area
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-11-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241007221603.1703699-11-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/24 4:15 PM, David Wei wrote:
> +static int io_zcrx_create_area(struct io_ring_ctx *ctx,
> +			       struct io_zcrx_ifq *ifq,
> +			       struct io_zcrx_area **res,
> +			       struct io_uring_zcrx_area_reg *area_reg)
> +{
> +	struct io_zcrx_area *area;
> +	int i, ret, nr_pages;
> +	struct iovec iov;
> +
> +	if (area_reg->flags || area_reg->rq_area_token)
> +		return -EINVAL;
> +	if (area_reg->__resv1 || area_reg->__resv2[0] || area_reg->__resv2[1])
> +		return -EINVAL;
> +	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
> +		return -EINVAL;
> +
> +	iov.iov_base = u64_to_user_ptr(area_reg->addr);
> +	iov.iov_len = area_reg->len;
> +	ret = io_buffer_validate(&iov);
> +	if (ret)
> +		return ret;
> +
> +	ret = -ENOMEM;
> +	area = kzalloc(sizeof(*area), GFP_KERNEL);
> +	if (!area)
> +		goto err;

This should probably just be a:

	area = kzalloc(sizeof(*area), GFP_KERNEL);
	if (!area)
		return -ENOMEM;

Minor it...

> diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
> index 4ef94e19d36b..2fcbeb3d5501 100644
> --- a/io_uring/zcrx.h
> +++ b/io_uring/zcrx.h
> @@ -3,10 +3,26 @@
>  #define IOU_ZC_RX_H
>  
>  #include <linux/io_uring_types.h>
> +#include <net/page_pool/types.h>
> +
> +struct io_zcrx_area {
> +	struct net_iov_area	nia;
> +	struct io_zcrx_ifq	*ifq;
> +
> +	u16			area_id;
> +	struct page		**pages;
> +
> +	/* freelist */
> +	spinlock_t		freelist_lock ____cacheline_aligned_in_smp;
> +	u32			free_count;
> +	u32			*freelist;
> +};

I'm wondering if this really needs an aligned lock? Since it's only a
single structure, probably not a big deal. But unless there's evidence
to the contrary, might not be a bad idea to just kill that.

Apart from that, looks fine to me.

-- 
Jens Axboe

