Return-Path: <io-uring+bounces-3863-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 776F49A6F71
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 18:30:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 01FC81F21FF4
	for <lists+io-uring@lfdr.de>; Mon, 21 Oct 2024 16:30:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1799D1E00A1;
	Mon, 21 Oct 2024 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="A9WQkMeK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91801E410E
	for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 16:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729528194; cv=none; b=BeJ4otnv2mcxHsfkPSUc7/R9nY/Vu4qlM3UWXxnk7E/xGdSGtiaMBirH78+yFLM/u8MPBXyx1Q6Z1h2M2GC5Rmq5Kuz/FpzFpQEjfgmrSE/YpDWQ5HMLVV1ZfGDPEYsMJ80YG/QiLuvPd91yD7RXVvQubjR/DbHxnQ11H3GkXtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729528194; c=relaxed/simple;
	bh=rAW3crsY0Q2t/2QQ33fUHXBxnBiPahgRhnKxHx+LOHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mthZ0f65BMvv0k6HSyyjrfKYWv52ulECn3PU4+qzKgtIxZzRBp8PfRHPvYAUEn0PL0pqVyQuOBrTk2Kf4gTnCscJFWWza151QDNqWGC7tNLwyvdkT7w0DIZC+kJcNLHsaUaqW0/btQc7U4eHQKvZdOjt64dr7mDKbZRB7NdTJwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=A9WQkMeK; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-83ab9445254so137558539f.0
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 09:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729528191; x=1730132991; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mapVLM0am5qDLkHJ+55nJBbAeli7XgLZzqMXCAm1BqY=;
        b=A9WQkMeK3kdPiaXMpY/J3/BvnAEcB8bTfq6tY9p9nAPqhwogN29wWZfOwzcB34qei3
         iUiGYBTPeXeYqydsc/vqHplj6I8MyfTFBIajhCzml0mRTKucN4G5jJkjL75x1rnfI0wt
         DHNri8MBCaMb4w2Y4XEEdz0T1024E/yoaxfRm3015/VTatCCvfXQ8fxRXQHseLBeDZRj
         TGdvsP4dpDPoJ/2QhlHFawOgXvzcEz0ZzB/wcx+YOOiUjtBMUSKBNd8Kzo2vyl0pwxCj
         txrf9nBkWfjOvkqtw4NKb3LTgvUSaRcr92Y2jhOpCbMBlP9+2lZfM2dHJHj1LPhSdjdv
         PZ8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729528191; x=1730132991;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mapVLM0am5qDLkHJ+55nJBbAeli7XgLZzqMXCAm1BqY=;
        b=sh75yUZDV/qPoLhf+QX7j41o3tfW7wBrTUqUGgYgV+CN0+0D/1ckn2H/FzRAemG5AG
         +/iJ9NoPzX7DqFMOtNJb74QnOzJQyr2zx92ZI7KZu6D7KP+IMWuoiCagY+SarpapzcQf
         S2nsSYzmBfQpYe9kqSvMmI/KkVY6T13X6Wb/prmSgwu4OeaulXod4p/2VKVYAuedFo5Z
         Hmtvd++mxyb5oIgzcJSCCT+KKd6mEWAGeS2NB4pRyw19ZYFcER1SQeoZg/f/OQ+ksOxe
         69uCB7DacL2xflS0TQKkkr2x+y/DkTDRZ/wN7/zj/wINmCnIi5Zm1CjVX10iFyz3rSaf
         lLOw==
X-Forwarded-Encrypted: i=1; AJvYcCUu7NElCUVC4t7yCyk4x6edfU/79yvo3T2vClhVRBIzWTZLgBjqIDT5T3Gfp3zW9Co4cj92zZGg6w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyvPZ8d+EfolPJFecsLwt+9aLVADqMB1LNDVFvjCprx3svWNnE1
	5PeD1m2+NAUCeYzcB51NwSG/ryfHnBJZUYV6x3bm7SSjvgOgjZm/pEqIUoxvE6Y=
X-Google-Smtp-Source: AGHT+IFMr2rfQejlChYoU5CGZn9QBVZS8wpg7RfINN66ckGb2iJslDRdY7eRWwuCWSodwSSIEzB2TQ==
X-Received: by 2002:a05:6602:3410:b0:83a:a305:d9f3 with SMTP id ca18e2360f4ac-83aba645c6bmr108767839f.12.1729528190416;
        Mon, 21 Oct 2024 09:29:50 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6090b5sm1088983173.89.2024.10.21.09.29.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Oct 2024 09:29:49 -0700 (PDT)
Message-ID: <b2810a26-7f03-45c5-9354-c8ab21ae411e@kernel.dk>
Date: Mon, 21 Oct 2024 10:29:48 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 10/15] io_uring/zcrx: add io_zcrx_area
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241016185252.3746190-1-dw@davidwei.uk>
 <20241016185252.3746190-11-dw@davidwei.uk>
 <3aebbd91-6f2f-4c8c-82db-4d09e39e7946@kernel.dk>
 <433d21ff-6d7f-4123-8b11-c5d3c9a9deb1@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <433d21ff-6d7f-4123-8b11-c5d3c9a9deb1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/24 10:28 AM, Pavel Begunkov wrote:
> On 10/21/24 16:35, Jens Axboe wrote:
>> On 10/16/24 12:52 PM, David Wei wrote:
>>> +static int io_zcrx_create_area(struct io_ring_ctx *ctx,
>>> +                   struct io_zcrx_ifq *ifq,
>>> +                   struct io_zcrx_area **res,
>>> +                   struct io_uring_zcrx_area_reg *area_reg)
>>> +{
>>> +    struct io_zcrx_area *area;
>>> +    int i, ret, nr_pages;
>>> +    struct iovec iov;
>>> +
>>> +    if (area_reg->flags || area_reg->rq_area_token)
>>> +        return -EINVAL;
>>> +    if (area_reg->__resv1 || area_reg->__resv2[0] || area_reg->__resv2[1])
>>> +        return -EINVAL;
>>> +    if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
>>> +        return -EINVAL;
>>> +
>>> +    iov.iov_base = u64_to_user_ptr(area_reg->addr);
>>> +    iov.iov_len = area_reg->len;
>>> +    ret = io_buffer_validate(&iov);
>>> +    if (ret)
>>> +        return ret;
>>> +
>>> +    ret = -ENOMEM;
>>> +    area = kzalloc(sizeof(*area), GFP_KERNEL);
>>> +    if (!area)
>>> +        goto err;
>>> +
>>> +    area->pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
>>> +                   &nr_pages);
>>> +    if (IS_ERR(area->pages)) {
>>> +        ret = PTR_ERR(area->pages);
>>> +        area->pages = NULL;
>>> +        goto err;
>>> +    }
>>> +    area->nia.num_niovs = nr_pages;
>>> +
>>> +    area->nia.niovs = kvmalloc_array(nr_pages, sizeof(area->nia.niovs[0]),
>>> +                     GFP_KERNEL | __GFP_ZERO);
>>> +    if (!area->nia.niovs)
>>> +        goto err;
>>> +
>>> +    area->freelist = kvmalloc_array(nr_pages, sizeof(area->freelist[0]),
>>> +                    GFP_KERNEL | __GFP_ZERO);
>>> +    if (!area->freelist)
>>> +        goto err;
>>> +
>>> +    for (i = 0; i < nr_pages; i++) {
>>> +        area->freelist[i] = i;
>>> +    }
>>> +
>>> +    area->free_count = nr_pages;
>>> +    area->ifq = ifq;
>>> +    /* we're only supporting one area per ifq for now */
>>> +    area->area_id = 0;
>>> +    area_reg->rq_area_token = (u64)area->area_id << IORING_ZCRX_AREA_SHIFT;
>>> +    spin_lock_init(&area->freelist_lock);
>>> +    *res = area;
>>> +    return 0;
>>> +err:
>>> +    if (area)
>>> +        io_zcrx_free_area(area);
>>> +    return ret;
>>> +}
>>
>> Minor nit, but I think this would be nicer returning area and just using
>> ERR_PTR() for the errors.
> 
> I'd rather avoid it. Too often null vs IS_ERR checking gets
> messed up down the road and the compiler doesn't help with it
> at all.

The main issue imho is when people mix NULL and ERR_PTR, the pure "valid
pointer or non-null error pointer" seem to be OK in terms of
maintainability. But like I said, not a huge deal, and it's not hot path
material so doesn't matter in terms of that.

> Not related to the patch, but would be nice to have a type safer
> way for that, e.g. returning some new type not directly
> cast'able to the pointer.

Definitely, room for improvement in the infrastructure for this.

-- 
Jens Axboe

