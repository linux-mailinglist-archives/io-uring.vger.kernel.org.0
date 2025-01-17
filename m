Return-Path: <io-uring+bounces-5992-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88842A159DE
	for <lists+io-uring@lfdr.de>; Sat, 18 Jan 2025 00:20:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9A15168BB0
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 23:20:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AFD61ABECA;
	Fri, 17 Jan 2025 23:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUkiL3Ho"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C69613B2A9;
	Fri, 17 Jan 2025 23:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737156020; cv=none; b=NIZvBLiwCLNr3x4SzpOItQuheOSecKGYy1DaYrd3yHiPU80xf0zVJUCXyTxe4zES11F3QQLnKB63vH5F/KvrfSIDeg3Qg/skwk1pTkVj1zzCua2gMq1jmEGCKDV9Mz4e5W+oUX8rkYd8lsTRj7wobFiaazlZHr2ueNwJgPmx9+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737156020; c=relaxed/simple;
	bh=cwqXrM87Y52GNegmWv4acFjPYnKB0Mc5ugVW3/jtJj8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DubV+QP7bCTe8EFMRgcffu/SRUMZJV2QBdBtwypMT52vXECdPqsVvmQQvrwWnOE9azD4H7QBZ+x/iGAu8ocsPl9RmpKXizQ/MiOktnF76WfdLEfUYGlXDN2gmiNJ8+3ilsrLU+4rYwu4SyIL6YLH6sftVuGI7tmc8TsYXpVm5jw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SUkiL3Ho; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4363ae65100so28049225e9.0;
        Fri, 17 Jan 2025 15:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737156016; x=1737760816; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ku1yk6FP1LtN7qGO6ZCJBmeakwiQptzKOPlKjKosyDw=;
        b=SUkiL3HoInj/CjDIwpOHgzN/Bb3jN0UzE/68bzjjxip5MesMTsHt6LgcaeoqTh8Ejr
         Op6/MEhO1piz/kvIhnFsbYcJvCgbI7UK7ZWRE+sWBqGAk3jiTNKd+H2aTR8UPCTBZlaL
         pPwxMlqPLWG5S3m4mfBZVfMfmBII3jKaYab6mSzzvrL3vRrWGjoShxWxl8I8JSMls1Il
         9UQfWQDh23JrJhoTkoMxHlMmocG0Q8k69QpDriQPRboRZCwS2Y+OF35/R5TC8k39c83E
         45Gkn/iP6ifhdJQGCkxqxp18c7Jhc+xHPLxVKPZzngKlryTszV4TQEkv0MSAMe92h5PQ
         TNdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737156016; x=1737760816;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ku1yk6FP1LtN7qGO6ZCJBmeakwiQptzKOPlKjKosyDw=;
        b=L2EFJOln2Rqt7MvdRxO3q00gdhrO9YPAADisDtK+3xggc9f3tHwVedEDptjRnYXTvl
         fUrss4bYme7TKsz+lOoy5YZTC92maheh3iG9Nkt+boBAbuKtnqfsKqt+s3p+mUmoJ342
         QajnS/MHKy3R0EMh9HIqLfGnfSBhVZC5t13fb+6uDSsNEUxmtxYGbkBYIsQbgjx2+BpZ
         4aXyWyzk6IznRtv7Xu5iAa1zpw62zACuKZki2Ir9fkK8MoYPbT1Www28JGL1kCbxTqb+
         ChBkty46DURCcxJXZEJLsHqBZIOeILCxjz6dXa37Z2OeflVIz5LWHzH+/E++ndxdrG2e
         VVwA==
X-Forwarded-Encrypted: i=1; AJvYcCV2fZD21v/zV3spMVnDhlTmBo+v5YjgB9uUzoPN2IPAVtLXMNaNKs2fKTDpTBNSusbDK0cafJd+@vger.kernel.org, AJvYcCXYNkfRiw18/7u0VmmrsoDD92GyUwW/OmGpRs8SboH5VmcdtwxFeOiiH2JNbGO/9EsrjppMRMjKDQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzRbItOKEv+yEzUnRGPkbbXmFlpuMH269ck+QhO6vGCDVlxBONm
	ptiplGqdBsr5npbuQnD1jZvf7Xvx5uYwxnr/8VmCk5A+cV4uyL+3
X-Gm-Gg: ASbGncvxwqO7P7zaDRW5tEksmZ8s4wJb1SGf95xyTe2RC00cMho558rIAw3riKT/at1
	e1gNvzCMlrLOI+LfnnXBTGXEsR22PugdkZOkd37RPGOPqDbVnnz6s9vHIt5q9+1BXYd6xalPcxM
	gzNXgNZPQB39GBAtG35VZpfbFx+5QAtdDHCFtyBWDGkuSoDhTOZOd8NX66vB5DoYS29ORRuti1E
	7Y68PHT8+gsGmVhPiqZrA+u4EhRVt0aVf7wLjq2aB77dKSam2Ec6neg0s2UguEyEO7ElIsF0oGW
	9Q==
X-Google-Smtp-Source: AGHT+IGWwzQoAOmKe8zx7tySLcevTiaWAtEpVULyWdj7gLYboetswyQkdB33dHv+c6tMw6u2hAgTWQ==
X-Received: by 2002:a05:600c:4710:b0:431:557e:b40c with SMTP id 5b1f17b1804b1-438914532admr41715045e9.27.1737156016262;
        Fri, 17 Jan 2025 15:20:16 -0800 (PST)
Received: from [192.168.8.100] ([85.255.237.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c752935csm106630805e9.26.2025.01.17.15.20.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 15:20:15 -0800 (PST)
Message-ID: <0d851165-dfe3-491a-be8b-77d01ee00de4@gmail.com>
Date: Fri, 17 Jan 2025 23:20:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 10/21] net: add helpers for setting a memory
 provider on an rx queue
To: Jakub Kicinski <kuba@kernel.org>, Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <20250116231704.2402455-11-dw@davidwei.uk>
 <20250116182558.4c7b66f6@kernel.org>
 <939728a0-b479-4b60-ad0e-9778e2a41551@gmail.com>
 <20250117141136.6b9a0cf2@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250117141136.6b9a0cf2@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/17/25 22:11, Jakub Kicinski wrote:
> On Fri, 17 Jan 2025 02:47:15 +0000 Pavel Begunkov wrote:
>>>> +	rxq = __netif_get_rx_queue(dev, ifq_idx);
>>>
>>> I think there's a small race between io_uring closing and the netdev
>>> unregister. We can try to uninstall twice, let's put
>>
>> They're gated by checking ifq->netdev in io_uring code, which is
>> cleared by them under a spin. So either io_uring does
>> __net_mp_close_rxq() and ->uninstall does nothing, or vise versa.
> 
> True, so not twice, but the race is there. It's not correct to call
> ops of a device which has already been unregistered.

Ok, from what you're saying it's regardless of the netdev still
having refs lingering. In this case it was better a version ago
where io_uring was just taking the rtnl lock, which protects
against concurrent unregistration while io_uring is checking
netdev.

Does your patch below covers that? Or does it have to be resolved
in this set? I assume you're going to queue it as a fix.

  
> Mina, did we consider that the device may be closed when the provider
> is being bound? Perhaps that's what you meant when you were reviewing
> the netdevsim patches!
> 
> Do we need something like this?
> 
> ---->8------------
> 
> From: Jakub Kicinski <kuba@kernel.org>
> Subject: net: devmem: don't call queue stop / start when the interface is down
> 
> We seem to be missing a netif_running() check from the devmem
> installation path. Starting a queue on a stopped device makes
> no sense. We still want to be able to allocate the memory, just
> to test that the device is indeed setting up the page pools
> in a memory provider compatible way.
> 
> Fixes: 7c88f86576f3 ("netdev: add netdev_rx_queue_restart()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>   include/net/netdev_queues.h |  4 ++++
>   net/core/netdev_rx_queue.c  | 16 ++++++++++------
>   2 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/include/net/netdev_queues.h b/include/net/netdev_queues.h
> index 5ca019d294ca..9296efeab4c0 100644
> --- a/include/net/netdev_queues.h
> +++ b/include/net/netdev_queues.h
> @@ -107,6 +107,10 @@ struct netdev_stat_ops {
>    *
>    * @ndo_queue_stop:	Stop the RX queue at the specified index. The stopped
>    *			queue's memory is written at the specified address.
> + *
> + * Note that @ndo_queue_mem_alloc and @ndo_queue_mem_free may be called while
> + * the interface is closed. @ndo_queue_start and @ndo_queue_stop will only
> + * be called for an interface which is open.
>    */
>   struct netdev_queue_mgmt_ops {
>   	size_t			ndo_queue_mem_size;
> diff --git a/net/core/netdev_rx_queue.c b/net/core/netdev_rx_queue.c
> index b02b28d2ae44..9b9c2589150a 100644
> --- a/net/core/netdev_rx_queue.c
> +++ b/net/core/netdev_rx_queue.c
> @@ -38,13 +38,17 @@ int netdev_rx_queue_restart(struct net_device *dev, unsigned int rxq_idx)
>   	if (err)
>   		goto err_free_new_queue_mem;
>   
> -	err = qops->ndo_queue_stop(dev, old_mem, rxq_idx);
> -	if (err)
> -		goto err_free_new_queue_mem;
> +	if (netif_running(dev)) {
> +		err = qops->ndo_queue_stop(dev, old_mem, rxq_idx);
> +		if (err)
> +			goto err_free_new_queue_mem;
>   
> -	err = qops->ndo_queue_start(dev, new_mem, rxq_idx);
> -	if (err)
> -		goto err_start_queue;
> +		err = qops->ndo_queue_start(dev, new_mem, rxq_idx);
> +		if (err)
> +			goto err_start_queue;
> +	} else {
> +		swap(new_mem, old_mem);
> +	}
>   
>   	qops->ndo_queue_mem_free(dev, old_mem);
>   

-- 
Pavel Begunkov


