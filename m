Return-Path: <io-uring+bounces-5372-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 393F69EA320
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 00:50:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6A73281EEA
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 23:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1CC419D88F;
	Mon,  9 Dec 2024 23:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="DdBdyI+4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291D01E48A
	for <io-uring@vger.kernel.org>; Mon,  9 Dec 2024 23:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733788233; cv=none; b=RUmsbeIURQJL89Aq9l8FGdPjTAeIAFXVu5xbDsg5X2gpGh4TprM3i51VtCgvqVWfswoiPykbUZW6nzm2DZZK9OgAfoPXEHwtXpfxM35opXJaeTOph1rm3L6tIQ3QIVTCYa/iFfJq1w+H+aattNvH3NltVB1JcFTgTsJ54PtLunk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733788233; c=relaxed/simple;
	bh=MQ6BGMkiTZAjDeCz1zpPsWTpFJwiXq+uTUSr/QdtR2w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ze9uOk5HreqbTla2Mr+J3Axl6p8Vv6ZmYwJ1Nf/zXI4IpR9YYT755eZeiDZ63AoU2ugNlF2J2Mn9NwCg1HSghbSnEh8N/spT+L+RbX1P/m2uirCk/1pvvsi8Z56OrYGyyIU+w4YLOnw0PeJCUN9Yh/aIE8RQFkW0jYhBbTjHTWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=DdBdyI+4; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ee709715d9so3585208a91.3
        for <io-uring@vger.kernel.org>; Mon, 09 Dec 2024 15:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733788231; x=1734393031; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/d2FdrRp4xEcwuQRCr1uin+p1CVpDEnp1yj0gHgEBek=;
        b=DdBdyI+4KWHBMuREHH91F/hEbn1X3+hq1EasOjwYg69aP0T8rbt17FM6TxwAeoWuwp
         KvDxFI4qKeCB4/wKKCEW/TZDH5xuv8inejw5NqpO514qkcSSsGJmdVthOMS0AkojlbzH
         hbt5dH5T+6o3zgMiKxHNRNZj3AlSllk+6j+U4HhE/NKPPwvFyC5qwRVxDVaJrfd0iFI3
         Ofv042kL2Rxp0SkVVvT9UKDpandPUXTfbaZzYnO09/rRReySFG65MJED9A02/6KpbCmZ
         Ajn4Zp1qmiOR0cSEFYfxZ+ckn5gPHHo/RKzozosAHguDMD27MoTU4+BHezgsSe+vhYNX
         ilbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733788231; x=1734393031;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/d2FdrRp4xEcwuQRCr1uin+p1CVpDEnp1yj0gHgEBek=;
        b=iVDvuQrTDF5j48uPFDZ1Svht4fV3Olj9IYvpa0uiZj8yZ27A7o7jui4Oh2fZmxYRHS
         Lg3xXCaHC82pozmx0TYjn76Wxo2wEdnTDOlGQ2araxp+uzMUSS8X4Pu4szV7G0B6/bFn
         EguBQRsPHZNHstxDOWdsz7GHfhtABRUCmV49DXcx+pY2VC5Ekm1kI40iVaVjaazcNDuP
         f67g1Mem4Antrs2Msd2ydiuQ7UKbdjFBaWJiYrP5Rxr3Rs8JpUVRIdzxQnHIfzxE5Hxn
         ZrRoli3uAQd7jFbrhB00PXqB3ByiVLbgDqIJdeISFCmgsqDds0Lneo/CuHZrqCLsjdsZ
         SGlg==
X-Gm-Message-State: AOJu0Yw7lse/Nc/z8AKYyMe36/s9NNazrL9igqepDRvMHt1L2/Y1sEjU
	Ox89tnXhipWMV+zF610xJfW4yFPVvrgxbftoazryNy53jBAu3ohgndbH4P+g1G8=
X-Gm-Gg: ASbGncup0SqAk5L0TlG4AQJNi+vm+jMHemV2Urx8qW8w8cBvrcDXUFPoVzJcr8v53dc
	BK/d4UJqGXJ0+S40n+LeklAahmS7mZ8u8dO87dMamN6MapCbOkNkdlTCyFdXw76G4z3HpppyKjI
	m0PNjUCm0YZp0rlm7lJqqs7/DyxcqazRj2vKrN5HzowG8N40wvMFebdMfirp2wCbWRnBJUytq4i
	unLhujqBUdaatKLBmKfaiqU3W4QYFeg3rLdQe9ZUFfsK8Z3aYqCKyDh24Z3JKpJvr1vqTdZk5nk
	wnPpbT3z1g6xpyg=
X-Google-Smtp-Source: AGHT+IHvqU5pnkLyZyz2Esg/i0XdEZjhmzi7tZ11Jn/xVvlZMUV7WLcTQnNgJYfzKr2uxDkP6wyRvg==
X-Received: by 2002:a17:90b:1d52:b0:2ee:c797:e276 with SMTP id 98e67ed59e1d1-2efcef044b1mr3951123a91.0.1733788231391;
        Mon, 09 Dec 2024 15:50:31 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1256:1:80c:c984:f4f1:951f? ([2620:10d:c090:500::7:8c2b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef45ff77b9sm8543784a91.36.2024.12.09.15.50.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 15:50:30 -0800 (PST)
Message-ID: <5a72c16f-311e-46d9-baed-f0a25d2a3dff@davidwei.uk>
Date: Mon, 9 Dec 2024 15:50:27 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 09/17] io_uring/zcrx: add interface queue and
 refill queue
To: Simon Horman <horms@kernel.org>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-10-dw@davidwei.uk> <20241206160511.GY2581@kernel.org>
Content-Language: en-GB
From: David Wei <dw@davidwei.uk>
In-Reply-To: <20241206160511.GY2581@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-12-06 08:05, Simon Horman wrote:
> On Wed, Dec 04, 2024 at 09:21:48AM -0800, David Wei wrote:
>> From: David Wei <davidhwei@meta.com>
>>
>> Add a new object called an interface queue (ifq) that represents a net
>> rx queue that has been configured for zero copy. Each ifq is registered
>> using a new registration opcode IORING_REGISTER_ZCRX_IFQ.
>>
>> The refill queue is allocated by the kernel and mapped by userspace
>> using a new offset IORING_OFF_RQ_RING, in a similar fashion to the main
>> SQ/CQ. It is used by userspace to return buffers that it is done with,
>> which will then be re-used by the netdev again.
>>
>> The main CQ ring is used to notify userspace of received data by using
>> the upper 16 bytes of a big CQE as a new struct io_uring_zcrx_cqe. Each
>> entry contains the offset + len to the data.
>>
>> For now, each io_uring instance only has a single ifq.
>>
>> Signed-off-by: David Wei <dw@davidwei.uk>
> 
> ...
> 
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> 
> ...
> 
>> +int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>> +			  struct io_uring_zcrx_ifq_reg __user *arg)
>> +{
>> +	struct io_uring_zcrx_ifq_reg reg;
>> +	struct io_uring_region_desc rd;
>> +	struct io_zcrx_ifq *ifq;
>> +	size_t ring_sz, rqes_sz;
>> +	int ret;
>> +
>> +	/*
>> +	 * 1. Interface queue allocation.
>> +	 * 2. It can observe data destined for sockets of other tasks.
>> +	 */
>> +	if (!capable(CAP_NET_ADMIN))
>> +		return -EPERM;
>> +
>> +	/* mandatory io_uring features for zc rx */
>> +	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN &&
>> +	      ctx->flags & IORING_SETUP_CQE32))
>> +		return -EINVAL;
>> +	if (ctx->ifq)
>> +		return -EBUSY;
>> +	if (copy_from_user(&reg, arg, sizeof(reg)))
>> +		return -EFAULT;
>> +	if (copy_from_user(&rd, u64_to_user_ptr(reg.region_ptr), sizeof(rd)))
>> +		return -EFAULT;
>> +	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)))
>> +		return -EINVAL;
>> +	if (reg.if_rxq == -1 || !reg.rq_entries || reg.flags)
>> +		return -EINVAL;
>> +	if (reg.rq_entries > IO_RQ_MAX_ENTRIES) {
>> +		if (!(ctx->flags & IORING_SETUP_CLAMP))
>> +			return -EINVAL;
>> +		reg.rq_entries = IO_RQ_MAX_ENTRIES;
>> +	}
>> +	reg.rq_entries = roundup_pow_of_two(reg.rq_entries);
>> +
>> +	if (!reg.area_ptr)
>> +		return -EFAULT;
>> +
>> +	ifq = io_zcrx_ifq_alloc(ctx);
>> +	if (!ifq)
>> +		return -ENOMEM;
>> +
>> +	ret = io_allocate_rbuf_ring(ifq, &reg, &rd);
>> +	if (ret)
>> +		goto err;
>> +
>> +	ifq->rq_entries = reg.rq_entries;
>> +	ifq->if_rxq = reg.if_rxq;
>> +
>> +	ring_sz = sizeof(struct io_uring);
>> +	rqes_sz = sizeof(struct io_uring_zcrx_rqe) * ifq->rq_entries;
> 
> Hi David,
> 
> A minor nit from my side: rqes_sz is set but otherwise unused in this
> function. Perhaps it can be removed?
> 
> Flagged by W=1 builds.

Hi Simon, thanks for flagging this, I'll remove it in the next version.

