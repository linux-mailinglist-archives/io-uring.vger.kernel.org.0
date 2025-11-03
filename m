Return-Path: <io-uring+bounces-10325-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 84A28C2D87B
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 18:48:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id F152F4EE76A
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 17:47:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC92E280308;
	Mon,  3 Nov 2025 17:47:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Eibo1d5P"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FCFD26B973
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 17:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762192053; cv=none; b=sMa35UcMclXfRJj9D/BdYCrAEQFGvQ/z3IMayu8yQLUj63djDExwkWkSdcCiSOX0KA2LQUUycwKMo4QUdqiD1B08uQHDNJ+EjdfINHK7dIuW4yXkO42Kg8ksstGpBmXBQ/7Bosdsv/FUYs1geluyPUq71DS+kgYbhNt/qP5N8Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762192053; c=relaxed/simple;
	bh=bh0yAI4guRADKICExO+ozJyyCC7NK4Wn9YrjOgiy/s0=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=bxGKC263VqDsbVR1bjgMFLbbktwRDFo+//n0jmEi6RS2P7NVaisMfJ/fMk5FdKpSFenyC+B9zK/8ym3dzM8+d69fYgYIuMm3r6sjFY5MOPJrRY9W3HBsnRFRFD4uzhLopXf0Sn4eA24PG2+RQU9oVT+bx2ecqX+1JkMhR4MmVRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=Eibo1d5P; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-29599f08202so18838955ad.3
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 09:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1762192052; x=1762796852; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ALcsYF1OUvtb4WGfm5k6mvdAKsl5PnUMHIqpz80EbzE=;
        b=Eibo1d5PuX2TG8630QQflQQjhSAWR6tR1aOQNjKUqogU7yJTqOU0aevWoKIKysQuC8
         RkLfKjHBV4AHBAH/KmersDqp93I3FegQcUbWzXeyNDk6Nx0k8r3o9AujfbKBj5H0LYK/
         mdx/Y/MSjEblJ0aCPt54dXE5rqAzHoWn7or8ukev2MeB7ApgnhItjySAMsH1SqZhfuXJ
         gam/VdyXxUKS3SbhjzQZiqFd8tJPFxge579ut2GbeIfR4ecnJjCMTFvdRfaDlIsQ9eMj
         uuD8mWwZNUCIHY88Nm6zWc6i/W9Fiwmknq2bF0E/fkjnHzFvlNBvzNgekbVBmG/tbp5S
         JI9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762192052; x=1762796852;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ALcsYF1OUvtb4WGfm5k6mvdAKsl5PnUMHIqpz80EbzE=;
        b=SQWfcwfaoxej1+B5SF5nnW0ToYjv0cZJXevX42TJKPddZsrhGvJiVDo6ZUSG+859ir
         o7WpYcAs+XHpz8GJyVVZIXSaoJpUoBVHLHPK0vyZc1qUs+DOMsCV3x9ShJjl41Y79kLh
         70m5FbX7w8qMAFxLODMMt03YKcr5dNIK5bnABPw9OaWDKXgLNo6l+M1omKYSzjUQ6cPV
         +gbq917ErMrDcwsDUvqGdNgwbHzPRSsf/TTKb9Eg926Jcxjs3355/yfZVQhaFYrz0ORZ
         MOG3X+LYZanRhGSPDRC0XeXfhr7XjZPwa0pq1tReGQU1GZf7Ld0sMtG1jenpUP7sFVFu
         lWkA==
X-Forwarded-Encrypted: i=1; AJvYcCUmGekkRAQBAZe6O8Snmcj6uw5ajgcHLLPr1Jqs/cQGoyzKrXp9JsZWBVKqnToH2jEXKC3KJgY8ZA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx81m/fjjzZruKuXzQlJ+ITBCTTMR1J4+ft1tqWmhBuG9Dkd1Hj
	XoCfhRbDkI0Dz4v+2MBmJJl628D0sEE0WdqjFpYXCvAi9aTuCgLT2h+clpMqfm0A3II=
X-Gm-Gg: ASbGncstiSQWcy8LWyNnUc8ELQ5PCuxjgO87EQWkMQnO/28+0tmjq5fyn54cMnV00+p
	G4bglIXjb1A1Qnm5zAE+eq2oefWVRLeHbNXtiXrZ0Zu1vDCABhsjowoHOuAgKS9PfQdnON/HiK1
	uSQpPHDNi0to0w2LymawP4SngFTAxE++9ZnP3tcWyiqQpVR/h0lscsiVcDMf9s71wgGDUmgdJMT
	7/silQH/cZ9hhMIL2ShlwAhqJdHhB4TUBZz4a/JuYgC9b+MrLr3Mm0qdmWqopEyrWS2Bfqa/zvY
	wfBNwHLN5YsUsyvcVu/vMhOPeSuRBqgF3nAI666KLnFd7Nrum7XA+rILTTV4IAH6nVEW8lzP/FX
	/LB7lA7ShRDGCxy1E08pgHEaTpz6orRyCb+7keKAklcZuBtuxyEGB57DPbWJLv0YbL+xsF4cS8I
	M6Ic7s9im0hWbn/9CGGXB1n6laNfcstI3DK9z4Xot3FqJNqMFsFw==
X-Google-Smtp-Source: AGHT+IGNmQFBAmom+D+nA/CZ+73dSGWaWutPFAyoNpXlhYxDh2dnxcQekJr3lu/MmiZoAsEctjDvzQ==
X-Received: by 2002:a17:902:e74e:b0:295:8db9:3059 with SMTP id d9443c01a7336-2958db9335emr85842325ad.38.1762192051708;
        Mon, 03 Nov 2025 09:47:31 -0800 (PST)
Received: from [192.168.86.109] ([136.27.45.11])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2953f35bc28sm108579535ad.109.2025.11.03.09.47.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 09:47:30 -0800 (PST)
Message-ID: <c8d945a3-4b12-4c04-9c68-4c5ad6173af5@davidwei.uk>
Date: Mon, 3 Nov 2025 09:47:28 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Wei <dw@davidwei.uk>
Subject: Re: [PATCH v3 2/2] net: io_uring/zcrx: call
 netdev_queue_get_dma_dev() under instance lock
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
References: <20251101022449.1112313-1-dw@davidwei.uk>
 <20251101022449.1112313-3-dw@davidwei.uk>
 <c374df85-23ec-4324-b966-9f2b3a74489a@gmail.com>
Content-Language: en-US
In-Reply-To: <c374df85-23ec-4324-b966-9f2b3a74489a@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025-11-03 05:51, Pavel Begunkov wrote:
> On 11/1/25 02:24, David Wei wrote:
>> netdev ops must be called under instance lock or rtnl_lock, but
>> io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
>> Fix this by taking the instance lock using netdev_get_by_index_lock().
>>
>> Extended the instance lock section to include attaching a memory
>> provider. Could not move io_zcrx_create_area() outside, since the dmabuf
>> codepath IORING_ZCRX_AREA_DMABUF requires ifq->dev.
> 
> It's probably fine for now, but this nested waiting feels
> uncomfortable considering that it could be waiting for other
> devices to finish IO via dmabuf fences.
> 

Only the dmabuf path requires ifq->dev in io_zcrx_create_area(); I could
split this into two and then unlock netdev instance lock between holding
a ref and calling net_mp_open_rxq().

So the new ordering would be:

   1. io_zcrx_create_area() for !IORING_ZCRX_AREA_DMABUF
   2. netdev_get_by_index_lock(), hold netdev ref, unlock netdev
   3. io_zcrx_create_area() for IORING_ZCRX_AREA_DMABUF
   4. net_mp_open_rxq()

Jakub, do you see any problems in relocking?

