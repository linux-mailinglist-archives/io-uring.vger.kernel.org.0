Return-Path: <io-uring+bounces-6527-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8740DA3AB75
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 23:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 48CC33A6B10
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 22:06:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4804B1D0F5A;
	Tue, 18 Feb 2025 22:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="zqrVF1Iy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE91E1C701B
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 22:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739916415; cv=none; b=CyWHfOioKcwv3JahvuccOKYecSEvdP7SJr2b2SGwdyOJGWJexOG/ubUOZ6MEFb8Qu+pGZOjpXdF/cEylAsNJm9mWf8ybxFP83CDV+lBkhE5kSTfeSian4vfB8ihdy+hLH9EuT47RM/oeHfhMAYFsLe55KPw5zDGndD6zrsYvXJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739916415; c=relaxed/simple;
	bh=AJbD0VhEqktAJuSbrw8sGimzHBizOzGrTkKzm+Z1J4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iYeX3Wk0pkPuqPrgSrcFYCB1mtLadnZ+81bbQnDZjfKxkkEV7YjV/NCtZMEVLb2cL4NW7WkfjVBv8Ji25xkdCdO6ri+pa7fm5mThbl36XcNwHWoA/48skT3/U+ur3NP5oDnmP2d5+3wq0XZHQPzROmfzq3ejRYyl/qJMIcSbbsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=zqrVF1Iy; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-220e83d65e5so96582395ad.1
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 14:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739916413; x=1740521213; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vtN7DCDXT4P0ZtMj21KzNqzVT5mPv1hMJBMgdgryY0s=;
        b=zqrVF1IySSBpyOhu/0aSPsfuiveXWPCbp9G5ROC/M3SefVPTfYT/+tv+JwAnM79zrm
         SMlqZoTYC6+zxVfLC2ISPsKCXGyoLw4nGHqjKg28eaPAcggu7ZssduFck99rbkw7iN4+
         zEqf82TRLzk+dQZRYh/0tqKo4Y+/V6UWMWC0aXLe9u3m4Cfb8dH9EeArtTOBY0VsP+ob
         iuQlchvBghOQWYzzrpqbkDpV2e9XuqDovxO8qyc1J8M1ln/neonmLkmCU54tOl+Vr5dG
         DllySkkDVYXsUNjdhpSpj8XUrmjnUf4/SCyK0aRrzuY9Dj3NvOo5G5YB8g9nHnDQzE85
         1isA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739916413; x=1740521213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vtN7DCDXT4P0ZtMj21KzNqzVT5mPv1hMJBMgdgryY0s=;
        b=ad2LB6a5LhUpIPO/cXBpOOXzxqjsRL4z9o+p6mGznB1DuElR27TwpzzAExgmQfSAyf
         tXVUB1DiBEcgW/zJzV0JAX9HRTZyTk6s3Xa7qO8j+NFBPiH+cLxZcrPB/FPPPpaD5+/W
         /L28Q+i0y4bkgZdahZFfXrY4Ou2iENlGsx3Ybj6OALleamifGdFIcOPflwobwcGPBO7T
         iJmbhbII+J+IDY0hUZ+9HtOW+EpgwfpRIMOOz726hrk1H7ptz5xdskjBpfHiIlCbAaPQ
         Gp1ONgn5beD+Nv+S/4cbiNBXzchF3wgKKu5ayE32JmCrWnopn4mXYBRg4h4esA/7wrrd
         RH6w==
X-Forwarded-Encrypted: i=1; AJvYcCVVn0iUL/4fckvgHPlOU79SaSKqnqd8gV0AX0Podu/x4mEEjf5EkHsrPPnIoUAgMxLwLNOAri6Gpw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4x55J4Ac09whoNzEj8lIvau2PjGUPrj61QIXKEuEC+c9ZjrYm
	84x38meR7GUumxwxAr8xwJjrD44lXpT7puWyeJvESM33GAeClsf84EzXj5fYzq0=
X-Gm-Gg: ASbGncvQPeDFi1BYSYd6xsH1PHCGzQN1k33bz/wjjJ3lOZW7k7robiSsjoI9pgAwByJ
	bAgFgr210cMOPuUkA1v6aYSBqZk6Ri8K1ghZjiold1AyAjquJs1NRPhfF0ikCv7h66rdGTlXTSH
	FLgGhlMioYaR9tdE0S19o6g+pgAMujkeTK/2+90fKy4dzu4mflwPFk72SvxxIo+9gRoCaeojCjD
	UrjDqDJOHkHLbn3ml7rVuMrELKJPzq40Z0pGx4MGFvqzzVGCrtbMZb8wjLaeEe7GarVIAxKPeH0
	yYDVaiqtc9lT4y+8zjPeQwQS+UW8z7s8nGtk23exSKDF9IuArsCz7Q==
X-Google-Smtp-Source: AGHT+IG/A/bMTekzmDbdpz3xMBmnVuelBTlzZd10/URTHLkaDPvfz+k5BsAxJxaQjCKm2JetrQ5V7g==
X-Received: by 2002:a05:6a00:10c3:b0:730:9567:c3d4 with SMTP id d2e1a72fcca58-7329de4f102mr1773986b3a.3.1739916413194;
        Tue, 18 Feb 2025 14:06:53 -0800 (PST)
Received: from ?IPV6:2a03:83e0:1156:1:18cb:90d0:372a:99ae? ([2620:10d:c090:500::7:d699])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73242546177sm10599035b3a.5.2025.02.18.14.06.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2025 14:06:52 -0800 (PST)
Message-ID: <5eac0173-c75e-40b3-a1bd-7cedf86237df@davidwei.uk>
Date: Tue, 18 Feb 2025 14:06:50 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/11] io_uring/zcrx: set pp memory provider for an rx
 queue
Content-Language: en-GB
To: Kees Bakker <kees@ijzerbout.nl>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>, lizetao <lizetao1@huawei.com>
References: <20250215000947.789731-1-dw@davidwei.uk>
 <20250215000947.789731-8-dw@davidwei.uk>
 <cc1b81b3-f02c-46d0-b4be-34bba23d20c7@ijzerbout.nl>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <cc1b81b3-f02c-46d0-b4be-34bba23d20c7@ijzerbout.nl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-02-18 11:40, Kees Bakker wrote:
> Op 15-02-2025 om 01:09 schreef David Wei:
>> Set the page pool memory provider for the rx queue configured for zero
>> copy to io_uring. Then the rx queue is reset using
>> netdev_rx_queue_restart() and netdev core + page pool will take care of
>> filling the rx queue from the io_uring zero copy memory provider.
>>
>> For now, there is only one ifq so its destruction happens implicitly
>> during io_uring cleanup.
>>
>> Reviewed-by: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   io_uring/zcrx.c | 49 +++++++++++++++++++++++++++++++++++++++++--------
>>   1 file changed, 41 insertions(+), 8 deletions(-)
>>
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index 8833879d94ba..7d24fc98b306 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> [...]
>> @@ -444,6 +475,8 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>>         if (ctx->ifq)
>>           io_zcrx_scrub(ctx->ifq);
>> +
>> +    io_close_queue(ctx->ifq);
> If ctx->ifq is NULL (which seems to be not unlikely given the if statement above)
> then you'll get a NULL pointer dereference in io_close_queue().

The only caller of io_shutdown_zcrx_ifqs() is io_ring_exit_work() which
checks for ctx->ifq first. That does mean the ctx->ifq check is
redundant in this function though.

>>   }
>>     static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
> 

