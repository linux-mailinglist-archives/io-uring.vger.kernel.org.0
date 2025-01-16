Return-Path: <io-uring+bounces-5922-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BCCFFA13FB8
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 17:44:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FDE2188CD43
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 16:45:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D132522D4C0;
	Thu, 16 Jan 2025 16:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jwRS4EBc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DBA71990D8;
	Thu, 16 Jan 2025 16:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737045894; cv=none; b=myyrVT7ViIWPWCAUTxWW0GtEg6X/GZjfrKL0POXk8NG7u42vj2NkKpuDKjjjJ78ZjxXY+2Msn6z7oCkGwdygPsD+Ccnz+wU4aqvT4OG3g8eRQWsW53NtzwXi9UQVkpqFHKr1k4sDFOfJQ95Fw5JrCRSXj37MI8UjOoUMd98Rbbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737045894; c=relaxed/simple;
	bh=tox6Ar5HL8lvRU7cT31jjqDkKKairDF9IGLSjPZ831k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dl/Bry2b4NrKM99CH9P+AdWaRenlutdclKbMQHtICwUu7L4q9W3yLCe8p6eWIihsvAAACNPk5wl5ctQf+YpRiuIooZ8sYK1oiYQLwtw5/Ph+aEahjmRo3ljcjP0MfVO6T7mbY+MqYR0gVMLgi+HnSLQU4YNGey8fanjPbDwCdnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jwRS4EBc; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5d0d32cd31aso1726596a12.0;
        Thu, 16 Jan 2025 08:44:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737045891; x=1737650691; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RE+IiV3HU8MH/xkQ3tba7/HX1i0y7TVxzdgeTqYaBoE=;
        b=jwRS4EBcVQu7MB0nHzV6HeufXvjKx13SQeQL74NXo437tsHcTpd1NncXVwVmNFGkGJ
         IMf0+NzU5oWUSrmnPhd0+zhCcLm2GoDnJkn3V2pKb3g/ZHxOKW0YOJ/mUZT3Fd9SvCAf
         4tduIrH2pfk4QIhYbi+/PjUQ0g7ADvuLBSwhOW8IFZnfWU8YUxTv2whyuxc6gd7rNn4t
         uGRvnLR2LmfisOCLJTV80w8uy0DUbXvqQS5RuysRdV5aAhxzClnZsBlCYpMC4Df201pL
         2fJXn8znrEgFWdm5B0Md4Jh0lsB5s+E/yhsA3IIQQ1k45iv7ItgNlSpVLWMAC/kcUFzS
         vWUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737045891; x=1737650691;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RE+IiV3HU8MH/xkQ3tba7/HX1i0y7TVxzdgeTqYaBoE=;
        b=gqPUnPk+xt3F2vpZhMXhikBiFgScf9UIvhlpzosERwZnIlbBvclpO/VEDPCS9AI7N6
         zIG6ggk3UvVnWjvR08HCKirBruROag3kx1+d5GOBs6RpclIkGV1aObRzAYM6kF9wuxIm
         uLrz4g4FpxAeRQrW/KLCyIl13WWKS0mcJiGt84IDNlDhgC0Yfb6ejEWg1WDyUeBV9V90
         7bSHsLa6QbQMIlM3jcycPqbceL/F6Empx701vRCvX0He+fimM9cgXWIsraKhEjRotVgS
         7VyrAJsf6D15Gb8sHk0vi5zAc3hf5dGI6pKORohZAAqYBYDDtG54aMKew/FgbxqNEKIw
         Y8DQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZccVVshori0rhFsg6HOUE0UYh58MTGCsa3FnSu3sKMBCG+fR2eY4mCxC8mDHrdTzJeis3JjnX5w==@vger.kernel.org, AJvYcCWqeoowesM9fjCTPSNizxb39kRfT+YoKUY99o6y/kHWkhSvCWNe2dYU4LIxkkvCiFznwjXBeuPd@vger.kernel.org
X-Gm-Message-State: AOJu0YwGROxCBtRj2NbFvk8CzBCNNF5L665VjXgITiNW5vEm9wZnE5eM
	BGZ2gGh4yWFvFj99WGo+nVaHOFEJCMql+dwYCcS9YCnGJWdDyqdcr508iUMA
X-Gm-Gg: ASbGnct9Rrkjr1BmLxv+PlQng68EbYd/sY9B3/IqyrWjyIwccjHNaKDlAaVIcH0jTeM
	UBIUB3Yy/ZEy/9DfodUXRcmTwTUeMtNL1AWkDuw+CJLoTWLOUDaDXrdgZqmw+NxVRBfi7JeS8+b
	6kE//Cmzb++BsCrvH9HxbX8ZJR+7cryWmAVp6jlpmp9GRlMo+YTj3Jh3zgUvhVUkGIOGD+oWfGn
	u+3Zh8jWc2kSXej1RfpAUipxsDh2/tA8asnbYiKx1yROCSVuvC8Mh7p3dGu20ESndA=
X-Google-Smtp-Source: AGHT+IHHOehLbvBUE6PUtN51oCA4keMG1l5PQdxUpK5y3hlozelijT3o6ObRH8jlVMLPAEkW5wzc5g==
X-Received: by 2002:a05:6402:1e8a:b0:5da:1219:c81 with SMTP id 4fb4d7f45d1cf-5da12191004mr16249363a12.16.1737045891080;
        Thu, 16 Jan 2025 08:44:51 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f2918fsm19464666b.91.2025.01.16.08.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jan 2025 08:44:50 -0800 (PST)
Message-ID: <9f2261cf-554f-4e87-8fce-8794da24d13e@gmail.com>
Date: Thu, 16 Jan 2025 16:45:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 01/22] net: make page_pool_ref_netmem work
 with net iovs
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-2-dw@davidwei.uk>
 <20250115163019.3e810c0d@kernel.org>
 <52fffbfb-dadb-48fe-84e4-8296b18fd22e@gmail.com>
 <20250115184850.4d30e408@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250115184850.4d30e408@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/25 02:48, Jakub Kicinski wrote:
> On Thu, 16 Jan 2025 02:12:06 +0000 Pavel Begunkov wrote:
>> On 1/16/25 00:30, Jakub Kicinski wrote:
>>> On Wed,  8 Jan 2025 14:06:22 -0800 David Wei wrote:
>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>
>>>> page_pool_ref_netmem() should work with either netmem representation, but
>>>> currently it casts to a page with netmem_to_page(), which will fail with
>>>> net iovs. Use netmem_get_pp_ref_count_ref() instead.
>>>
>>> This is a fix, right? If we try to coalesce a cloned netmem skb
>>> we'll crash.
>>
>> True, I missed it it's actually used.
> 
> I'll add:
> 
> Fixes: 8ab79ed50cf1 ("page_pool: devmem support")
> 
> and we'll send it to Linus tomorrow. Hope that's okay.

Sounds good to me

-- 
Pavel Begunkov


