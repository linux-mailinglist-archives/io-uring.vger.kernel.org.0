Return-Path: <io-uring+bounces-5391-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB8129EA72F
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 05:31:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91DBC282C5D
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05EB5469D;
	Tue, 10 Dec 2024 04:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZCqk2uH+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ACEE23312A;
	Tue, 10 Dec 2024 04:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733805064; cv=none; b=CB26ftcXQV1SmQshjFpjpbtb1cSkC+J4PmzJ4jWolRzfyGaqq5oWCmN6n9SdLNHWcVuU3NSlAG/+MxqUwSZyrHbJ/uAZMexS36xAmjGnGQrU6P7d/Yb02gWXITgSmfwyHzGS8JI3hQNc44mjWHL9GT8533SpvKMPosSa5G0uU8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733805064; c=relaxed/simple;
	bh=ctTwwcQOXwuEeNt5euPI8vBE9ESKk8c9sMIe+dsUHZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MM7laEbQEBnlp+vL56eYAi4a9QKAWw1BXOEnsXrO3Mef19REJ1B5VWwQZN/1HlwQdWsbyls1Gjab4eXtNQcfd/btM5gUH/ybKcMzOZuP7+bhMRD/8+pY32yd8Uxdka0ji3mdH7wRpWzsQwkF8PebE3TGrOuLfxZYRBuUmq4SM8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZCqk2uH+; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-434a852bb6eso49252225e9.3;
        Mon, 09 Dec 2024 20:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733805061; x=1734409861; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WETHc3iF2jDd4buPcVUjs5gPlV9HluEncdO+m92JpMo=;
        b=ZCqk2uH+8NZe2Syya/PSGWs3EGcjZk6usE2h18pLsZr5XVOwLjD+A18SuOMgb4GGCC
         Y6OF9Vrty3zZsNdg7OF0AE2QoYqAbSEWY8V2Fb4tr/0rOqy+7l9HIPX9cI9ZR3D/RCJz
         FU1sfZ6L+CcxGzzXm6oD5a5/yiGE8g3ERSCkKDdjaGIsyQgw+tvgSAK9kMVF5MjH+C92
         X7IydI6nVd7abJi0zd+q38PIBXaPqpPXasl7XEh4Weu0BRJtPYtjySbEDzk9asAJXdBv
         TlNiZHyRuDOLV+mhFClrp92G4fkC+vL0zGYpUIYqdsovihgXu84XFgejjH8oJ+njxoH4
         vinA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733805061; x=1734409861;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WETHc3iF2jDd4buPcVUjs5gPlV9HluEncdO+m92JpMo=;
        b=kDWwmcYMCrG9Yw96yKMwVc4yXtm4Eg6P7nFwEI5uPfjOSvmMXeFxn+A9qsr+UCHixg
         4tMwtN7DCD4870nfdH29AiXDz59lPXvx4erE0gv1FwUaZM8ONIGPVRny7fgGvTCNQ5ET
         +93V2g3Yf1vAXJZCcZ++Q01ePoH3bqA6Hvb7D+CYh99s9j2n6yl+Bu9AUCECO+3vFmca
         ZrrP3Ml52ji8v0BpOBwFh6SjoY9lt9DQfsufPxCDEeoaFQUOZXRpsa7bTtY8r23OnDoh
         feQT771OiAMc0GQDQoqRzbhRzWGUJj08weNVh5W9WiehXlDE2s2n9myGzqNsSEkmIVSL
         SqxQ==
X-Forwarded-Encrypted: i=1; AJvYcCX++b/PpgzIpiV19wxrnRPavh6ojQ5MUzFNfkm3Ip/rajyI03M8q2VYgly0lO3OmnRYmKUBlaI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxjZbndg7P2SqavVtANbWmnkhSh5acRMpr2KrvhzuH0PA75Mg/W
	qdS29MoDoTmi28BXzj11LIvSQCRatbiZZA0FHX9J1P09yJIzWMLZ
X-Gm-Gg: ASbGncuidtcSxdSWBPWKK2ewYdL3Wm6TZDxDVf3vXKrY+jCGGk3tQcU135gWB3LLyLu
	nQ2Kav9EXBzbDeixJ652RxfIO9BB0z5nc0m4Z1jV719Ut6pEEnrvGsVw+n0zMEac5Dkvr2YI/g5
	1QN1XRo+H6pCSRPkSupDahNYde2yi5jF+0fWlb78u3bzC+8F73npl2Q6wZ2ZG0ceKW/ilKzCfgp
	Y7v+upos700ndesiXnn7O7GR+cHssr7jEgwrecfoOzIek3SSPEgIvahtL2b9qs=
X-Google-Smtp-Source: AGHT+IH24x1Hypc8JMW8MQrh2Q6Zwi2lIAIWVniZRU6Hh9LeUvahZd0IDtN+R0lgZZ8CVBUvIPaJxg==
X-Received: by 2002:a05:600c:3b87:b0:434:ff30:a159 with SMTP id 5b1f17b1804b1-434ffe9e71cmr27168475e9.0.1733805061448;
        Mon, 09 Dec 2024 20:31:01 -0800 (PST)
Received: from [192.168.42.90] ([85.255.235.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-434da119a96sm180327165e9.40.2024.12.09.20.31.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 20:31:01 -0800 (PST)
Message-ID: <fc1715f6-c123-43c6-9562-f84c7aab4ed2@gmail.com>
Date: Tue, 10 Dec 2024 04:31:53 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 07/17] net: page_pool: introduce
 page_pool_mp_return_in_cache
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-8-dw@davidwei.uk>
 <20241209194057.161e9183@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209194057.161e9183@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/10/24 03:40, Jakub Kicinski wrote:
> On Wed,  4 Dec 2024 09:21:46 -0800 David Wei wrote:
>> +/*
>> + * page_pool_mp_return_in_cache() - return a netmem to the allocation cache.
>> + * @pool:	pool from which pages were allocated
>> + * @netmem:	netmem to return
>> + *
>> + * Return already allocated and accounted netmem to the page pool's allocation
>> + * cache. The function doesn't provide synchronisation and must only be called
>> + * from the napi context.
> 
> NAPI is irrelevant, this helper, IIUC, has to be called down the call
> chain from mp_ops->alloc().
> 
>> + */
>> +void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref netmem)
>> +{
>> +	if (WARN_ON_ONCE(pool->alloc.count >= PP_ALLOC_CACHE_REFILL))
>> +		return;
> 
> I'd
> 
> 	return false;
> 
> without a warning.
> 
>> +	page_pool_dma_sync_for_device(pool, netmem, -1);
>> +	page_pool_fragment_netmem(netmem, 1);
>> +	pool->alloc.cache[pool->alloc.count++] = netmem;
> 
> and here:
> 
> 	return true;
> 
> this say mps can use return value as a stop condition in a do {} while()
> loop, without having to duplicate the check.
> 
> 	do {
> 		netmem = alloc...
> 		... logic;
> 	} while (page_pool_mp_alloc_refill(pp, netmem));
> 
> 	/* last netmem didn't fit in the cache */
> 	return netmem;

That last netmem is a problem. Returning it is not a bad option,
but it doesn't feel right. Providers should rather converge to
one way of returning buffers and batching here is needed.

I'd rather prefer this one then

while (pp_has_space()) {
	netmem = alloc();
	pp_push(netmem);
}

Any thoughts on that?

-- 
Pavel Begunkov


