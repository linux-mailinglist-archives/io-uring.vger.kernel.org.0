Return-Path: <io-uring+bounces-9765-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D99AEB55015
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 15:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7CD807A2063
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 13:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B4E73081A8;
	Fri, 12 Sep 2025 13:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="JS9cZqa1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17332EC55E
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 13:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757685248; cv=none; b=R2qjv9VnGLITOr8BjvX+GQxjnEWgHEN9GSRmoqyuw7LmYeQkZK+KgaNY2fCEpaHMJQgSDFcthSFKljbvQFJyHQykLIgpw3m4qZhfB58agVrUu9ukEShOQeuv1y2M83Y+c88/kvGE0LGgyeqBDF8pQH+GoFY5Te4foJChNq6TlJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757685248; c=relaxed/simple;
	bh=fYDxj4TQJQ7Wj2bc2QbChTPSUPWyqEK1EhkFoltlaI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lLuiVxxLhPbweN9fTQ+7TeTa4diERftiUbaqu39yJwTD+SSxoE6lnzz6z+Qt/uyas1VfEpdrAKr7+iEZTjyFTfEWW/gH4SfqWTPEFst/wRzOvl8A/Hzevx6t5kaRTCwOW/t3tOQ8VDhrKEB3mVrfuqpCuNgyad1fQ5VCe0gGyKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=JS9cZqa1; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-329a41dc2ebso1684440a91.3
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 06:54:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1757685246; x=1758290046; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NyJ2QrNSPpofXSwz4SHyhJQvRMiElOl6uxmOWE9Z9cc=;
        b=JS9cZqa1Ulqn2Ik57c4vcw5ZFjaUF0yxkfULdRafWjsQ9jhCsHkFAsD8HxjCEAy47p
         NrQigVfe+u1h9sC9R2sncPm+W5NThPvAHi/10En8UVjDBBIVGEnrh3cVkadyY/mHzL7Y
         iu+NJS3iwzRyyC40pMB32yPUX27wd34+UqRmCHyspxzkzT/S5LR/HrdA/AWq7Fl7zHO6
         chaeGHGyVH9K79eKyPxuuYKn9AgStEQHRJbmL0r+AHEfFhJ6bblTHQUKyk8Bwv82Z92T
         ea0fuNnfG4XFW326jHBhjpTfev8kIUpSY8onEFEmHxWOLshWBbmDCJObLh+3jvx/QD56
         EthQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757685246; x=1758290046;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NyJ2QrNSPpofXSwz4SHyhJQvRMiElOl6uxmOWE9Z9cc=;
        b=OM/7qd51HYI7iTNh7MJNwTaTIwrKDuDyCYWHA6i/dMda58xuQmyd4H/XZZTc7OY2z3
         IYKFOh1oTcUGksgY9FI6Rl7uQKtahAjYhdtJJuk+CAQulrKx7XgbX8MsslILEZI+Zxy9
         lmw4Ysr5IjeBrYGCCzikiOp7scTc2ug2SQL9Z+tDyTboACMqUA4ndOOJEOZObmDbk0K2
         WrjbszRlzHb3tCMW5dsqkaYbjxodAKFpS+C8qaRrNE6JGiNWblXql9x37cr1c1R7kLEZ
         y7jc2+9TD7HU5mPdyeuNc95SLiVM8VpjTpCx8KHopyOAJDdA+QPGxNegAHvbWmD7fdyu
         9t6w==
X-Gm-Message-State: AOJu0YyMi/1o/+pyDjBDzEMNuo66x7xRZwIK2QOeg4nn4kmN3fq9n1kY
	vTSP16oiqexJ4R1gd1cFnGuUa/hu3RVPeLjiTufKIIVGiyTIMOZMSTX6yM6LSdN9PcQ=
X-Gm-Gg: ASbGnctvt/xC6MSYeSJi5CnL1GqPSuhZE1ZGvV7+8qw6jNgIllINcOrluGE5r3Rng+L
	7nP6zjCi9aoT8be6raHqULLGFfKxzP09NH+o6g1YtM7WVfKN6OA4HurNugH5zp8Lc5BICtmOsmp
	du5DeHGDINpzruWQye8Zz7bpXI+fT0UaSa8PNDha+G1aoRB6UJHFTJezFrXR2v0h0ig0jQzLywo
	29z5PR0eJrAaENBEYA3kpQgVA3uTZ3vImbNhfjFibhGfDJARU8Zd1cZS7Juw0qCHa+8gbFFrcpi
	4afNl3zhgg46uyGSfNGTexhCco+PVZG1jw0aodYKLJcMvO889+W2dDd4uXQItuyn07u74I7EjDV
	pwp/reOmXrhU7ZOiLYDll020ouGgXGoMGWA+zNqhXnGZ/R8TOn9HKSbAUQw82bk8=
X-Google-Smtp-Source: AGHT+IGLna4QvgAwH+y9fiaoSNhZuY4/GpQUf8k/O/HrPL3FzcefwfbnWIwjuerIkhrw91ozq40o4Q==
X-Received: by 2002:a17:90b:1b50:b0:327:9735:542b with SMTP id 98e67ed59e1d1-32de4fad2bamr3187655a91.35.1757685245925;
        Fri, 12 Sep 2025 06:54:05 -0700 (PDT)
Received: from [10.254.128.3] ([139.177.225.240])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dfc974426sm68216a91.20.2025.09.12.06.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 06:54:05 -0700 (PDT)
Message-ID: <f18f6248-4774-47bf-91c6-159005593153@bytedance.com>
Date: Fri, 12 Sep 2025 21:54:00 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [External] Re: [PATCH net-next] io_uring/zcrx: fix ifq->if_rxq is
 -1, get dma_dev is NULL
To: Pavel Begunkov <asml.silence@gmail.com>, axboe@kernel.dk,
 almasrymina@google.com, kuba@kernel.org, dtatulea@nvidia.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangzhenze@bytedance.com, wangdongdong.6@bytedance.com
References: <20250912083930.16704-1-zhoufeng.zf@bytedance.com>
 <58ca289c-749f-4540-be15-7376d926d507@gmail.com>
From: Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <58ca289c-749f-4540-be15-7376d926d507@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

在 2025/9/12 20:40, Pavel Begunkov 写道:
> On 9/12/25 09:39, Feng zhou wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> ifq->if_rxq has not been assigned, is -1, the correct value is
>> in reg.if_rxq.
> 
> Good catch. Note that the blamed patch was merged via the net tree
> this time around to avoid conflicts, and the io_uring tree doesn't
> have it yet. You can repost it adding netdev@vger.kernel.org and
> the net maintainers to be merged via the net tree. Otherwise it'll
> have to wait until 6.18-rc1 is out

Thanks for reminding, will do.

> 
>> Fixes: 59b8b32ac8d469958936fcea781c7f58e3d64742 ("io_uring/zcrx: add 
>> support for custom DMA devices")
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>> ---
>>   io_uring/zcrx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>> index 319eddfd30e0..3639283c87ca 100644
>> --- a/io_uring/zcrx.c
>> +++ b/io_uring/zcrx.c
>> @@ -600,7 +600,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>>           goto err;
>>       }
>> -    ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, ifq->if_rxq);
>> +    ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, reg.if_rxq);
>>       if (!ifq->dev) {
>>           ret = -EOPNOTSUPP;
>>           goto err;
> 


