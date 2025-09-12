Return-Path: <io-uring+bounces-9764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 62BD6B54E44
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 14:42:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EEEF618853CF
	for <lists+io-uring@lfdr.de>; Fri, 12 Sep 2025 12:39:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2406B2E8DFC;
	Fri, 12 Sep 2025 12:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NPTY7oBk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6759B28751A
	for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 12:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757680719; cv=none; b=lqyKZfkya8DO0Xf31Id3lb+jnpiXz0Vd44sSBtfvVGybYnDjAX3duMKgm5w/y95y5cyKeKRpaGk+5QN+fIkg57XyjPcOZUxtL7byWZw06wfCKihr61z1tLVRvj0bnMh5xFcI0XdoBN98hKb3wN4ICJeQB0sJeHlKyd4q/5yOvfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757680719; c=relaxed/simple;
	bh=vlZU6mwycI3sYqwmq03oUvOqfxP28cDyni6GsHHu81c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PadxDLGZ5DNyuFGCBjj1hRftR9E0eHTkbBtORqEPEXh4GyxSz66U/8VYPjwV/J62X24J7xEPNg7Sbkbmu5YDsV0peHWWjztr37eXRSRguo7EEtykoklYQeYX+VGNO7aK2uibZUspTNL7oczhVBpJAm6yp+bsl2soq/49Fmx2Jq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NPTY7oBk; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45cb659e858so13690465e9.2
        for <io-uring@vger.kernel.org>; Fri, 12 Sep 2025 05:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757680715; x=1758285515; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fAnrydUexcyAjL7DssRTYDuSCNo/x9rFYwKFSV6SRH8=;
        b=NPTY7oBkYzwhiYRuoLICk6C8XKJ/xMxizVKuM/svqMXVkgXyjO5MR3ZNuW8XoCgWbT
         USMHLllzBUzBMt06E6FGD735FNnMC8VggXvU9eyr8ehG/PYfb+gN12GfxrsFgIatp1ic
         hcDZCaQ5wGsuAlkklen+pL0i6LCgW7SCwv+LhyTHNlrhtqPfnHzy6wrRt7pG44dKd2+b
         NWhMXsvAq/NewSr63/mZSj78dXw+BidQqs2iOsFH5WkNXLxJcrf2I/u1Y/f0g4X5rB+A
         RiiGAdcNMtpnQHLjQd08KFObei04gV3dCYf4VeWGCHoUivKTgDttNjhsZEtHK57KlZJ1
         cydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757680715; x=1758285515;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fAnrydUexcyAjL7DssRTYDuSCNo/x9rFYwKFSV6SRH8=;
        b=TAqwGhxEro1u4kPm7BPRjewVvUGS3qjO5z7hyHczF5j2bCCnSGSyY6+O3l6pCehvWU
         /gbQu5aeSJXNlWO4h2JdrV+jvRmD2bnXPzpG6EsIhPPButR07yvhqBTpDdC+m5VnnJvV
         dcZaowUo6hOnAiuvA+dWZlLIzKyMN0qGirv6SixGf752XyXTJSuQGjN+h3suJsoBEjlu
         wbNbK8//S//UKU4MLAydE4gyq/0TFCd/0thAEvr4Z35o5+kPgh9AeJ2Wga2TnL2YOpGN
         2w/wJS6GsmcapdOXckVlWP1L2qLcUAQhKorrszxUFeTNIbXTgDuXUQbkod8z1QsGtnQp
         MH+g==
X-Gm-Message-State: AOJu0YxyqdIJb6mgjWB5FDUpHGtKem1W/gk5bLxPCRjV764HhNmNc3MO
	IHJwbVEGE6UtBgAz50fmDPDkN8wnYABikWFsM4biVHIbOghEATlMG3uAf0263A==
X-Gm-Gg: ASbGnctQ891N1POml786E6jRR7t3z9taccRsIzRbBnqrYjK86fO3UtDDmzHJBvyjO7W
	UPwd8P1/Pt4cct73We+qktApyDXHEb2Sdl6RBeMmfj+d2IkhWEEaSqhJzRBhLNkXSlWaRIgieN+
	oeMWsaKxbv+NlrGd/y/kihgHmXF3DALyjDtaEQVpwzACiCtKR7i0ks7DvXygnpMwGkq50jZFO5A
	1LkHpmm+u40FGaSbeuDU/Z7egobKHT9VAC9RXAmbICDQBCaCyYzOCvKsKcnfiJWvwBT1AAQCNA2
	W030SRUC0N+Z20BgjT7t3CO+yoFIgHOKt3rWfHoFhnBvVlVxDPcrxzgvoHrRjnqrgWF3dJtMezR
	81p3nczj2xB7D6KAAlvSwtbA8dQ+Gt5Mpahwuw/90ZO7GXLCM7DxCU0LCg6w3e4AfUw==
X-Google-Smtp-Source: AGHT+IFWxDz1WpfOR9wcxxeAHVv8OxZAheEP90QH0SyYPYpZEU+CfRw1UPv58VbrLJGV5nmhjNdmmw==
X-Received: by 2002:a05:600c:1c13:b0:45d:db2a:ce30 with SMTP id 5b1f17b1804b1-45f25971c61mr4461155e9.0.1757680714973;
        Fri, 12 Sep 2025 05:38:34 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:5f19])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037c3ee8sm65173895e9.18.2025.09.12.05.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 05:38:34 -0700 (PDT)
Message-ID: <58ca289c-749f-4540-be15-7376d926d507@gmail.com>
Date: Fri, 12 Sep 2025 13:40:06 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next] io_uring/zcrx: fix ifq->if_rxq is -1, get
 dma_dev is NULL
To: Feng zhou <zhoufeng.zf@bytedance.com>, axboe@kernel.dk,
 almasrymina@google.com, kuba@kernel.org, dtatulea@nvidia.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangzhenze@bytedance.com, wangdongdong.6@bytedance.com
References: <20250912083930.16704-1-zhoufeng.zf@bytedance.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250912083930.16704-1-zhoufeng.zf@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/12/25 09:39, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> ifq->if_rxq has not been assigned, is -1, the correct value is
> in reg.if_rxq.

Good catch. Note that the blamed patch was merged via the net tree
this time around to avoid conflicts, and the io_uring tree doesn't
have it yet. You can repost it adding netdev@vger.kernel.org and
the net maintainers to be merged via the net tree. Otherwise it'll
have to wait until 6.18-rc1 is out

> Fixes: 59b8b32ac8d469958936fcea781c7f58e3d64742 ("io_uring/zcrx: add support for custom DMA devices")
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>   io_uring/zcrx.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 319eddfd30e0..3639283c87ca 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -600,7 +600,7 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>   		goto err;
>   	}
>   
> -	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, ifq->if_rxq);
> +	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, reg.if_rxq);
>   	if (!ifq->dev) {
>   		ret = -EOPNOTSUPP;
>   		goto err;

-- 
Pavel Begunkov


