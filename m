Return-Path: <io-uring+bounces-5695-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 741C0A0335C
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 00:38:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 52F581640F9
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 23:38:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ABD71DF977;
	Mon,  6 Jan 2025 23:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bDQcNc59"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B285B3B1A2;
	Mon,  6 Jan 2025 23:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736206691; cv=none; b=NhOKfaIWh8a57/GGAEUM95fynMNAMPeWOLFfovUSmG5UWLDR/1iEjaQwnFMcAE8tPspgrYxCzbODTtL/VwIIuz8yfAkF4afZA9qri8G+ro6Ij6W5jC6lQI0j0qYgNXAKjKgLAu8BpQLAM6tC5h7eJ/awoBQCPHFgii3X1cfgRn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736206691; c=relaxed/simple;
	bh=yNYmrF55fFKtWQliTDZr5S6mp6THiuw9HOF1C3hRjJ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DByU/rn5KshelBbEh+uL/lowiDXX5+09IjLIfq6ieT8efeJaoxE+28VsUYCu8FKNODExPGenY1+/37IYuRD4Gi+4lE7r3ypr8KTKUfzaWHFGguoJsSTpi2b1Xz6JjU+0ur0RiE+MXVY3XKYEStwll8hbjJ1SkuTeLboRl8bzzPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bDQcNc59; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d3d479b1e6so21429585a12.2;
        Mon, 06 Jan 2025 15:38:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736206688; x=1736811488; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ora6OTvGot/U6MvuYpkhLt150204kkyPWjg+Ma8PbBE=;
        b=bDQcNc59+eHZ7uCMElNZZpji7xcL+oJ7ZAGZ+oNMoQTaWR+WzGuu7lNUkOmZmnN3yS
         q3LCgqmZawQ1SGvxQsJS0iGPoekWKFDcq4DQgDtrWzsTgvw4n+a5LiT8SDNygQMU8Slu
         XfpvwCuHO6fxiqan5fM/w4WhsGNWEWj7cjbZ7+O0wyza/FIZS0fnCu9qnQarLYSxJDAJ
         TToeMgggYj3D9ahxAkKfDsxrlIbUHbEe5O7anQCwE1r2ExZrc3k5pns02TuvTjPMRbn2
         pi65mL230NYLKMe4gdzRKOiiY5u+8r1VkMYj+roQmqVFHUHzcMaauvExDPouMuZwn0NY
         QP0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736206688; x=1736811488;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ora6OTvGot/U6MvuYpkhLt150204kkyPWjg+Ma8PbBE=;
        b=uejznrbf3Nuk6ynMVXvCfFGYY7xxpwIQqgpw5iGifX7xsnCGJPAofTcHjftYSELc+N
         pTdNo1MEF3sJmDbvghHFcy/sxSdezBbtPZooX2Xg1GRMUtw8DY+fIKsus0SjEBnrZfGz
         vFj/fYm6tvSxP+DAv/lrlToVvSCkeGMPBRBPpMMYiXmcpePx4hJmxAxffZR+jM6L6X7H
         6RGn3NoU33KA8tT4KIoII0BUjU1q0/6nZJavgiXz1cpzV/oQP+yAMruFIO4s8kgyV8Qx
         9UsU6POv2h49I2EubU9uabCNgT8ofa854MsNOJSMzQSuPADJMuB6a4PBeFKUJaY72sOZ
         U6dQ==
X-Forwarded-Encrypted: i=1; AJvYcCXofZAMflrs6omApfhmwh22DMXI+TmWTv9ngXOKTzdSqeig1LML5qg92wnIxzOEVMwuVlrjuis=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyiqtjkq0Fd84iiJxgLO4kMDuzQacrrPK9o7sfhWNexSaFzotuJ
	Cn4Soe6beaOamsj4i4j5fFFObCITPoK3M/gJePcinMAGpVO+vaSH
X-Gm-Gg: ASbGncvIUbSOe4fuD0WAdHbS29sRFlteTYLYhZjyPgr5esPm3d0FC1dLqhxP80vT8YK
	ZTjNWp13rpTKBmxggjTlKp9qwh6OiXpDoCpWmWIEG3KL5eCcQSGvBW+9+oxgD8JerzAjam50NZN
	wSLXra4zTxxwjN2u8FYu1HO1nCe99L5LLJL/Ldnej/ojUw2ODngkXQ599ugh2XrdwCRh90y4k66
	V/c5bf7/gHP+9xsnxxr+gioMxzTJiHyr/CGGxmh9b37Dx8XpR2JaDyAHyt8dUSfoA==
X-Google-Smtp-Source: AGHT+IFShVWrnXnXiKnohEeciHWB9uFatRwrv0bRgvvaK5UkvStIKUb8lJTdllrz8GEUHU5+JKX7kw==
X-Received: by 2002:a05:6402:2087:b0:5d3:da65:ff26 with SMTP id 4fb4d7f45d1cf-5d81de1c939mr130866540a12.31.1736206687765;
        Mon, 06 Jan 2025 15:38:07 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.16])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80679f128sm23400110a12.44.2025.01.06.15.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 15:38:07 -0800 (PST)
Message-ID: <960effc4-6cb4-40a3-a980-3a15b44cefad@gmail.com>
Date: Mon, 6 Jan 2025 23:39:06 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 06/20] net: page_pool: add a mp hook to
 unregister_netdevice*
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
 <20241218003748.796939-7-dw@davidwei.uk>
 <CAHS8izOg0V5kGq8gsGLC=6t+1VWfk1we_R9gecC+WbOJAdeXgw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izOg0V5kGq8gsGLC=6t+1VWfk1we_R9gecC+WbOJAdeXgw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 21:44, Mina Almasry wrote:
...
>> diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
>> index a473ea0c48c4..140fec6857c6 100644
>> --- a/include/net/page_pool/types.h
>> +++ b/include/net/page_pool/types.h
>> @@ -152,12 +152,15 @@ struct page_pool_stats {
>>    */
>>   #define PAGE_POOL_FRAG_GROUP_ALIGN     (4 * sizeof(long))
>>
>> +struct netdev_rx_queue;
>> +
>>   struct memory_provider_ops {
>>          netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
>>          bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
>>          int (*init)(struct page_pool *pool);
>>          void (*destroy)(struct page_pool *pool);
>>          int (*nl_report)(const struct page_pool *pool, struct sk_buff *rsp);
>> +       void (*uninstall)(void *mp_priv, struct netdev_rx_queue *rxq);
> 
> nit: the other params take struct page_pool *pool as input, and find
> the mp_priv in there if they need, it may be nice for consistency to
> continue to pass the entire pool to these ops.

I think so as well, but there is simply no page pool to pass
from where it's called.

> AFAIU this is the first added non-mandatory op, right? Please specify
> it as so, maybe something like:
> 
> /* optional: called when the memory provider is uninstalled from the
> netdev_rx_queue due to the interface going down or otherwise. The
> memory provider may perform whatever cleanup necessary here if it
> needs to. */
> 
>>   };
>>
>>   struct pp_memory_provider_params {
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index c7f3dea3e0eb..aa082770ab1c 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -11464,6 +11464,19 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
>>   }
>>   EXPORT_SYMBOL(unregister_netdevice_queue);
>>
>> +static void dev_memory_provider_uninstall(struct net_device *dev)
>> +{
>> +       unsigned int i;
>> +
>> +       for (i = 0; i < dev->real_num_rx_queues; i++) {
>> +               struct netdev_rx_queue *rxq = &dev->_rx[i];
>> +               struct pp_memory_provider_params *p = &rxq->mp_params;
>> +
>> +               if (p->mp_ops && p->mp_ops->uninstall)
> 
> Previous versions of the code checked p->mp_priv to check if the queue
> is mp enabled or not, I guess you check mp_ops and that is set/cleared

The patchset converts it all to mp_ops (v9 missed one place), which is the
right thing to do as only ops are typed and strictly defined.

-- 
Pavel Begunkov


