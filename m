Return-Path: <io-uring+bounces-5590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED469F9D97
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 02:04:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A04517A354C
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 01:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD79CEDE;
	Sat, 21 Dec 2024 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lcyeOyFd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037D9A59;
	Sat, 21 Dec 2024 01:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734743051; cv=none; b=t4xW/30/q+sifflSsHim2/Nsd994f/HNVZ6M7pGcul4DGcYxwpDdB+eQyCVByDimLqZ3vnTSVj04UGYNJ+M9c6UD0hroKS66G0BOATCTDsbv+MwrnOgdh2t6YLdWdj2mIorDJ+rG0cjI3C1IaV0NIes1PgpqFD68Je/Cqodx0ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734743051; c=relaxed/simple;
	bh=FE4cFtV7mkVd49+NP4x4VaXKkwT3bCtLRZ6J2QcQXdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gowvi/wMxOgJThRazhVvLsWFRAqvuPzQd/siLhBoohUfZDhhItYtwoBPE4y7eC0vQNigweFsWh4fbvCE6B1GnhG7kybDlYdZvwFze7FWoBSSPIzMTKLj+EJcU6PUQouu//Qz5lKsTBPHmPwwn6zXyczqYxZJXM2lWuHJS4QC3fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lcyeOyFd; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4361f664af5so26907785e9.1;
        Fri, 20 Dec 2024 17:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734743048; x=1735347848; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S6S2v61YVQHxebJr7FAINVLQDBq4kw9YOC0vK+fPA/g=;
        b=lcyeOyFd6bYCeiXHNSpmoplNoK79hQhkb1mucLO6s8uJOtOx6KOSv9OsSck31nr3x3
         xKifmtDCPrjnovOU+m9MT6Iny6MWYfCQ63jnUB+uDUYp+qc5JhUd3RBTOLu4vekL+BCX
         j7T1E6Mn8ZQrmYX4Xx8ucd7CpBPdVUJiuquos641wT9c1giimcDWoK+fEXufGwgo2cZ7
         eF3/oBzzkjObR3v2A56nggRA3YxtlinbpuV3kXIS/lQjT/52L5t3CWHtHZxbO7t5N7uK
         RdLUod29jG1u9oG+TxxVYrvugitz627HmCbfFkba+wd7fftFzWD7Gey020oyaQ9hK0Vy
         kCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734743048; x=1735347848;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S6S2v61YVQHxebJr7FAINVLQDBq4kw9YOC0vK+fPA/g=;
        b=qhJvn1dQMNOlH5GmSVWK/ojuaNBz+svQwMziOQUSyCylZ3bZhc722ArU532UUUf/XS
         YTdHEOIz28NAoQiY3vfCy/5XtMhMDJ7oquIxeQRqav3rT0mkYKkj2k6I0fMGxoC+aqso
         gGc1AyAbMfY53Y/wwH7+BU7ttX1fZAoPRBrQ2aKo47YuZhpolFLEMvn3RaDObw5ikd8f
         0PfPtrvaeSym4LqDBico6jIWRf7HY/qglxHQw4269rypBpI/QOt+V0br63qWCpu0FeLt
         G/UvXgKslrxjAieE7UiCqOifXm6q2OHickI5cSHGf6GcM9Rx1ZpGAGajdnM1vuPthpaq
         8l3g==
X-Forwarded-Encrypted: i=1; AJvYcCVTCuG5pq7z1hLQT6sGWVc1zQnUwkbWrNbFc+T+xS06eJYfUtFHtgneDMf5uiSGX64RSpkbCNs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzphP+GlChOC3Yo69xKaqniTfV3eRaP51rlG3f2BvKc034QgTz+
	VMYNtCojg38aKMQFxXWcAPkSq1XQGDean9VbmUvPHmgM0wKr5muB
X-Gm-Gg: ASbGncsMkEwF8uVdMUsqj+x1GziDqbF2VaXExjSnjvi5nd62QAN7jRpiaKtq3DK6gjA
	5grM8ufeFVtJFZE++emuyNryamNqhO8LRrA/kAoeCKcv0/oLU3aI33VyNNybebZoTG0PvsZlxwB
	5n2C9tGJAgAKYediknlxQc8Jq5UTBrAorb0lZe/RhgTPrDbQICi2gpZglSmlAICJ3xV4LtoLlgw
	uKidfsAHRrWuH3bfrbCiH7+0XWi/MKdgh1aOoJFImmy90O7l9qXjwPoNZw2kjpbJ4E=
X-Google-Smtp-Source: AGHT+IH/UGEwZOugdH5TueyEItPBEeHgb0roaMxj/EQ4f/WRYBNomz9qdyWFkuj0cNIK/5AzVwapmA==
X-Received: by 2002:a05:6000:4b10:b0:385:f470:c2c6 with SMTP id ffacd0b85a97d-38a221e21a9mr4808651f8f.11.1734743048070;
        Fri, 20 Dec 2024 17:04:08 -0800 (PST)
Received: from [192.168.42.184] ([185.69.144.186])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e278sm5347782f8f.75.2024.12.20.17.04.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Dec 2024 17:04:07 -0800 (PST)
Message-ID: <28993569-cfa7-40d4-b15a-5251073a0ae4@gmail.com>
Date: Sat, 21 Dec 2024 01:04:58 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 14/20] io_uring/zcrx: dma-map area for the
 device
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
 <20241218003748.796939-15-dw@davidwei.uk>
 <20241220143854.7dce75e4@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241220143854.7dce75e4@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/20/24 22:38, Jakub Kicinski wrote:
> On Tue, 17 Dec 2024 16:37:40 -0800 David Wei wrote:
>> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
>> index e4be227d3ad6..13d810a28ed6 100644
>> --- a/include/uapi/linux/netdev.h
>> +++ b/include/uapi/linux/netdev.h
> 
> The top of this file says:
> 
> /* Do not edit directly, auto-generated from: */
> /*	Documentation/netlink/specs/netdev.yaml */

Ok

>> +static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
>> +{
>> +	struct io_zcrx_area *area = ifq->area;
>> +
>> +	spin_lock_bh(&area->freelist_lock);
>> +	while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
>> +		struct net_iov *niov = __io_zcrx_get_free_niov(area);
>> +		netmem_ref netmem = net_iov_to_netmem(niov);
>> +
>> +		page_pool_set_pp_info(pp, netmem);
>> +		page_pool_mp_return_in_cache(pp, netmem);
>>
>> +		pp->pages_state_hold_cnt++;
> 
> But the kdoc on page_pool_mp_return_in_cache() says:
> 
> + * Return already allocated and accounted netmem to the page pool's allocation
>             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ok, I'll reword it

> 
>> +		trace_page_pool_state_hold(pp, netmem, pp->pages_state_hold_cnt);
>> +	}
>> +	spin_unlock_bh(&area->freelist_lock);
>> +}
> 
>> +	if (page_pool_unref_netmem(netmem, 1) == 0)
> 
> page_pool_unref_and_test()

That would make the series to depend on net-next, which would make
merging with io_uring trickier. I actually used page_pool_is_last_ref()
for a brief moment until it got renamed.

-- 
Pavel Begunkov


