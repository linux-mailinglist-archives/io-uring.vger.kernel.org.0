Return-Path: <io-uring+bounces-5910-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7393FA13158
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 03:25:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 98B4F188843E
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 02:25:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641D926AEC;
	Thu, 16 Jan 2025 02:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ColN9/6k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC5EE555;
	Thu, 16 Jan 2025 02:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736994299; cv=none; b=CFqEBSLRhc9CahUX/fhDBKMCLdnlNMV9sN3zxsy9JEyPezZhcm160vw6uEV4FnySmWyuhT+MpgLLIfPH8yJ6mP5wk+Z0Yz8oxswMQ5SOcVWRNjRyEOCWUbmqwPPM30IOxSQGTd2SgUmktwNwXVcprvh9DFInzDRIa+kVz/qXVQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736994299; c=relaxed/simple;
	bh=vwpYd2eXbtBU1YrQ2svl4mdLNSZRUcxf0aW5ROWpoMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tql7LmRmTq4JlYFyxWSu9+yFIJPGyLsJMLjMyKgAloQN71mcI2ou+IV+RZx8N1pkYOOwYxhTGHStP9G1nNl/U+/PYouABy8ILRAs7UHTDefxeL9K0XjebDDe4+QMk20ps/+S1fC4OfrMWiLrPKoogU/w+vkJjN56vxqENhyWS6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ColN9/6k; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-aaef00ab172so68763666b.3;
        Wed, 15 Jan 2025 18:24:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736994296; x=1737599096; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F0LFhmNwHMqrg8NfAT/EcOH2HSozRC6x3BNH2LLYbIw=;
        b=ColN9/6ktzND2zzI6VzpXe9vcui3H+8gFBhIR8AFa/6uFwVyLaymaQik84TzhQDmQF
         e0PttuaNrv+ayAvbdkjfsZxc5XYAd9mSkqJEJkDPBozrRSVI15U46zKa2FfBrX2bXHNd
         DkBd89aVCzznCiZ+Xtk6a/9qXMmOi4qtjlvSgvvbnT1IgJrt5w8EakZGqtyPxuudLOPa
         dJ5ITw0TiT946NQBjB1FlwDnoaNYnG0OheRD+Pvjbqsav3aNjzgerlsL5SDQaVFIMjGq
         bHOyzZCuNWJxbBTKEKrDdcR72PCdCOeXg9EfIuiEtylkmvYDBoNYPsMlKtMEygUYNgcN
         5zbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736994296; x=1737599096;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F0LFhmNwHMqrg8NfAT/EcOH2HSozRC6x3BNH2LLYbIw=;
        b=SAZ5TMcQKn1ODD9wPgKO9PEjHOFqTHQzqariLycwgimNIC75IKfLk6Kt1BmUQt7brt
         QZ5b5egeTRzdhxtbSlS3rRJOM6vXycufdH9MnvODtOtRWlG3bN1pxEOlMsBEpuYThZTq
         3F54IPL4kFJc9F0kBpJGe+Zb6eCkYBfmN0I69BY5UZi+aLMGXBs5y8L61xX3QeC4sb/x
         KF2JRl32ZoSuXDFLobswkdw+0RQExq4fkLxisIeaG5gJKSSgJ2IJsaRR+bttrQQRR4O0
         /dqUsR62hqzWw9aQZi89q+bTTyhJLuvdNvomC+eAQvqothTToMxz7NC1JRBN/Oeqqj2G
         lv/w==
X-Forwarded-Encrypted: i=1; AJvYcCUHkP1kTNiO8b1RT+GVwFnkqtZPl9EFy8IdzpLxQQIe562zRBEk6ItNMjs6jcBdaoXMHRrWE+w=@vger.kernel.org
X-Gm-Message-State: AOJu0YwA+/B18HGXg9tP7RrKBCHdYluF9ADyg6E2xGvvLp9MFEMindF2
	ZYnHhBLwCL6k6pTnf22vTV0TjPJ1E4c0wHYmYk9BhlqokxbwO3DL
X-Gm-Gg: ASbGnctfbpkAw82W4cNHVpKxytBZaL8k5W+VZiv1B7AHhIQzIG9xi60uSKY3nSHC7cU
	GEi1nKkKTjOD59BBRq+lgah6d7A5QtSXaWfBmq6fwjI6VQ+eMIioyJUvf23SoWfUBbkGohzIRJ7
	erv46q5z6PaBuTTPCxJjjRe/nftyv47qS4fSyrNdg1CN5/TdYZW2fUcPtuOU3Wc5XnczCxJ2L5x
	1owtzEkQlepmis7dEQDlLYhawKBv6KDr0GVH4RL77ttVjIPh15I3Ot+X9yuLgntIQs=
X-Google-Smtp-Source: AGHT+IHs2Gh++VEyvkZgCLmyKQi9RalgCayA+AD/V+GZb6eMxeEu+jZUmsuTu+kKOTTXj/ELmHKQxg==
X-Received: by 2002:a05:6402:84f:b0:5d0:d3eb:a78f with SMTP id 4fb4d7f45d1cf-5d972d26e91mr78824892a12.0.1736994295875;
        Wed, 15 Jan 2025 18:24:55 -0800 (PST)
Received: from [192.168.8.100] ([148.252.147.234])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c905ec09sm835077366b.32.2025.01.15.18.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 18:24:55 -0800 (PST)
Message-ID: <e5620d54-377b-414d-8e6a-447cd9c51307@gmail.com>
Date: Thu, 16 Jan 2025 02:25:41 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v10 06/22] net: page_pool: create hooks for
 custom memory providers
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20250108220644.3528845-1-dw@davidwei.uk>
 <20250108220644.3528845-7-dw@davidwei.uk>
 <20250115164419.38837cd0@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20250115164419.38837cd0@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/25 00:44, Jakub Kicinski wrote:
> On Wed,  8 Jan 2025 14:06:27 -0800 David Wei wrote:
>> From: Jakub Kicinski <kuba@kernel.org>
>>
>> A spin off from the original page pool memory providers patch by Jakub,
>> which allows extending page pools with custom allocators. One of such
>> providers is devmem TCP, and the other is io_uring zerocopy added in
>> following patches.
>>
>> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> 
> Something odd with authorship here. You list me as author (From)
> but didn't add my SoB. Maybe add something like "Based on
> earlier work by Jakub" to the commit and reset the tags?

The intention was to change the author (failed) and put it as
suggested-by since you said before you don't care and changes pile
up, and even modification notes got deleted for unknown to me
reasons in v9. Based-on, Co-authored also sound good if you
have a preference.

> Or the Suggested-by is just for the warning on ops not being built in?
> 
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   include/net/page_pool/memory_provider.h | 20 ++++++++++++++++++++
>>   include/net/page_pool/types.h           |  4 ++++
>>   net/core/devmem.c                       | 15 ++++++++++++++-
>>   net/core/page_pool.c                    | 23 +++++++++++++++--------
>>   4 files changed, 53 insertions(+), 9 deletions(-)
>>   create mode 100644 include/net/page_pool/memory_provider.h
>>
>> diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
>> new file mode 100644
>> index 000000000000..79412a8714fa
>> --- /dev/null
>> +++ b/include/net/page_pool/memory_provider.h
>> @@ -0,0 +1,20 @@
>> +/* SPDX-License-Identifier: GPL-2.0
>> + *
>> + * page_pool/memory_provider.h
>> + *	Author:	Pavel Begunkov <asml.silence@gmail.com>
>> + *	Author:	David Wei <dw@davidwei.uk>
> 
> Not a customary thing in networking to list authors in comments.

I'm not used to that, but _all_ networking files I quickly looked
through before adding that had authors listed including some new
ones. Maybe I was just too lucky. I can kill it.

>> + */
>> +#ifndef _NET_PAGE_POOL_MEMORY_PROVIDER_H
>> +#define _NET_PAGE_POOL_MEMORY_PROVIDER_H
>> +
>> +#include <net/netmem.h>
>> +#include <net/page_pool/types.h>
> 
> No need? All you need is forward declarations for types at this stage.

That's getting extremely nit picky. I don't see why it's preferable
forward declaring all structures instead of including a "types.h"
file. Not like that matters or there is a dependency problem. Even
from your comments to v18, the list would likely need to grow with
an mp_params declaration.

  
>> +struct memory_provider_ops {
>> +	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
>> +	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
>> +	int (*init)(struct page_pool *pool);
>> +	void (*destroy)(struct page_pool *pool);
>> +};
>> +
>> +#endif
> 
> Rest LGTM.

-- 
Pavel Begunkov


