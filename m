Return-Path: <io-uring+bounces-3855-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E44809A6E4B
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 17:35:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4C33282D7F
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 15:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1CD2E1C3F0E;
	Mon, 21 Oct 2024 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GpFzOkUj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D0AE1C3F02
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 15:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729524931; cv=none; b=Jz8gM6aTt8SA4zqzbf0v/jQJbIIN3wN5OK6/isAvDGbOE+62hPgKwJ3HCDZD731XLeTLhMhXwK+AuC8CIOt4TJL1s2KfiYhmJS4EjYtEI96f8JgRCToJjZBaYJxwjKWY3D8fgOe0WekmHQCvZ5OK+9AeDJ8Tr0FerjuMljugq8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729524931; c=relaxed/simple;
	bh=S3cnEiKuSXDoDPWcsKn3JHJUkNp9+UlxxK4fNUsaiVs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FqsQi4Gap7n9fduFJgjrh0Z2Mj/dC2mw/Gx7W188YE3CnHhWzGz6ZMzTBASb58qAAKTXsUSmz7it1GNgCq/eCaaW/+bi75gIKyhwgn+X6yqD4cNNEUzvpCym6vNZYy3yNEcwGpSzOY9z6XiuLOeImrEOffx+naWxrQxIczW0x+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GpFzOkUj; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a3b63596e0so13393965ab.0
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 08:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729524928; x=1730129728; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KyCrG1BXzXCwPHMGuiXYVs/HDSOGt/9byltcE0gxiPg=;
        b=GpFzOkUjjhKxESS4EHrzA2DfWP0kWOrZhtDb80Pfd5TENDWUt7Y8YOm78YzrBqmp2u
         ouDDiGrpTYrOqdDPIkmdAQ5PrPntSJFMNBjIq2HL7hbSoEYyYD6MIbAZkttODfTVCL2u
         SxLKiG7KoNKofj1dVRCuAJUyhbthkDOtJg/AtfeQpkUv9s9T9gVJ3goZKvIl7nK7hJxm
         +vvXozLfv5U7W89HxtijKml6YYHxuXurAGHmYUyxEW3ODmNWtcAshBBLeKKIT6JbPu1K
         KfyuzJSFtMuSpKp8LHo6oHiUqXtAtXwD2e4tfvSVr5CT3RjGlR26v+ao/hISC313ZGTY
         7AvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729524928; x=1730129728;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KyCrG1BXzXCwPHMGuiXYVs/HDSOGt/9byltcE0gxiPg=;
        b=Ov+hZ33FGo2jinr2poc7DhB/lakHeM2ffiY2zRf42WzL7HGmIHKC3kXRwsadUc/D8X
         Sy6dzwjTx3wnp3zTuVzcXem/AhcHtOmylCD/HP7WQeuE8oIAjaCDwqK0Gk4jcdEp3qQo
         qco1n3c7k5ILGtDTf6oRj22nDByyqxFgkp5Hff1Vk8F8NxWMjDILngvPXIKr3NaCTCSv
         lgWyuM3LtL3Wja8Oz2X3ahTAeEND4qgEXqbti5Xj/K1H02cbOxLO/QDST6hw6p3hP5t0
         Idu0k/gQTgMHpPrVXGNg/pPSGrVqq/dLx5gcO0CKpET74Iyw5d2OaD5SxtV30Np/2N9H
         aXyg==
X-Forwarded-Encrypted: i=1; AJvYcCXj1zOvQtHKEGoizhtR6voKQPjqJYLW/sWiplnYDWg48HgmcniBYf0nCAmnbk1ikQfF0VJo1apDVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwYGxHK0GWgdN3p8K2mVFlXZulWp7mp1ceueatBbITTPcn1h3fD
	UiIvoPUuu8ZtFi8yBE78rM8OsecgdDNNvNVWcU/WgANoqEpuvgJzSP+zbxtDhWs=
X-Google-Smtp-Source: AGHT+IHjjsjV6Hvo9fVu9LoWE/+ASFLQTTdX9GhzG00bjcTZgOJOifnxEQxa33cxgijQgsWue3nSbg==
X-Received: by 2002:a05:6e02:12c5:b0:3a0:9f36:6bf1 with SMTP id e9e14a558f8ab-3a4cc28d350mr72255ab.9.1729524927705;
        Mon, 21 Oct 2024 08:35:27 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400a7bdb8sm11907715ab.5.2024.10.21.08.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 08:35:27 -0700 (PDT)
Message-ID: <3aebbd91-6f2f-4c8c-82db-4d09e39e7946@kernel.dk>
Date: Mon, 21 Oct 2024 09:35:26 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/15] io_uring/zcrx: add io_zcrx_area
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-11-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241016185252.3746190-11-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/24 12:52 PM, David Wei wrote:
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
> +
> +	area->pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
> +				   &nr_pages);
> +	if (IS_ERR(area->pages)) {
> +		ret = PTR_ERR(area->pages);
> +		area->pages = NULL;
> +		goto err;
> +	}
> +	area->nia.num_niovs = nr_pages;
> +
> +	area->nia.niovs = kvmalloc_array(nr_pages, sizeof(area->nia.niovs[0]),
> +					 GFP_KERNEL | __GFP_ZERO);
> +	if (!area->nia.niovs)
> +		goto err;
> +
> +	area->freelist = kvmalloc_array(nr_pages, sizeof(area->freelist[0]),
> +					GFP_KERNEL | __GFP_ZERO);
> +	if (!area->freelist)
> +		goto err;
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		area->freelist[i] = i;
> +	}
> +
> +	area->free_count = nr_pages;
> +	area->ifq = ifq;
> +	/* we're only supporting one area per ifq for now */
> +	area->area_id = 0;
> +	area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
> +	spin_lock_init(&area->freelist_lock);
> +	*res = area;
> +	return 0;
> +err:
> +	if (area)
> +		io_zcrx_free_area(area);
> +	return ret;
> +}

Minor nit, but I think this would be nicer returning area and just using
ERR_PTR() for the errors.

Outside of that:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

