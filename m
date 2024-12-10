Return-Path: <io-uring+bounces-5383-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A7109EA6D1
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:52:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3DDA42883AD
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 03:52:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3271D1D7E30;
	Tue, 10 Dec 2024 03:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F0n1DZZP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547F01D79A3;
	Tue, 10 Dec 2024 03:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733802768; cv=none; b=miT5en1qGUnUi9kkGhYf5nEMIoZofANahQg1hEHzNdkR10STraEVv07kP57NthoWleOuNKIijqQ7j7Y3GlvhhPVSZSMq7GscLSbmmEw1rcLb5N6pqWauQuzKGVTRsT4B1/d8r/VSMZWyZ/q31nQn/9co7j4HdQQjT+eLmtP66nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733802768; c=relaxed/simple;
	bh=XZ6ScXxWnl2WaDG4UPWByyY+o5DwfM11U/1ZHSL7+S0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uObew7gT0+fJvb+lNkGnhT4MzYo2/V9hrhE+Xd73401zbGF1giQr7vBhmFaY9rjE16jyPB9z6LWfbc+squ5p3CPYwoJoNlLlqxQqWP4DGEEqjgdMFpgmtEhwZ302SK6ShKcHEJCJy/D7W1Caj0eL9dAMe25qoYa6pm67vkHytHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F0n1DZZP; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-435f8f29f8aso372835e9.2;
        Mon, 09 Dec 2024 19:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733802764; x=1734407564; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P61awexX3RFX1H0e5AdL0bd1ytHb5TPFMma2YEVPNBU=;
        b=F0n1DZZPflUPe/Jitq5uC+vsIIsa51dR/w7oBff3cjmQ9tWLtGRjsrMOEeDo3GEC/X
         WfzB+p6IQYboHmz+Je6m/7y03U0oXpBy9XHmDa26aa5MPQQpzZ5N+4uyVvB7sYISYUQW
         G70YRHXQBu1ngyDfjewosUUmxiZdeEYgLWKBFVwe8AJVbU+mAhCFFBfqIlkN8WcaIztb
         mvYoy/uvxq4zFg4PiHNQjwN52x66w+z/zh4rQuCR32GiP3ARxo/K07KkuGaQ2eg5MdRi
         8RJmbfKv2WwqkARu8CZtG8N6N1Vxyk64yCacRDSh24zu9beKnOC9FFeFc/CAgHAHdnqG
         4HKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733802764; x=1734407564;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P61awexX3RFX1H0e5AdL0bd1ytHb5TPFMma2YEVPNBU=;
        b=myQq/eMvfk8DsZk1ld0hFhSr9YupPtV0ZBw7RsQasuIiNm2f2VtvgrrLzwSH7arc5F
         YDTfcsinsovSCgOnosmOWolSztsz/D8C/R6Q0g8yPfKro9yUcLNHLcrlQ+0tlfdWG+pg
         JTQq5WM4hGzQZjzHNEOXfrBRKdLcZQnvE2/k4sGCYIznLabzoeC4OPlloP4OiPOkcjTP
         BfrSSqvi1n7HB8A+n622KNExUj59yMQI8f6ilXtf0+GQx5wN0UM1Pc3CZIuRThVeGiPY
         UDqgADtGFWrWoRGmUgdeYLXMlvQClGyKpKqgoha5pOP5P5b6arhLk3Pk/999xP4bofaH
         hmsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsDxUOaAr4+35FpQ+378leXVgVJ+8y1U4qUU8A7xaXmZGWAY5fM6TQZl+TE/cTl2VmUTKzlLs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx79GTO9klCho6I3Xd7nJwOJbz3PrNC34ky29I/gGeCx5LmsTkO
	YbqONQhX68KeOdpbG3P/5E75JEkxM9rWYcgW6ZNWFUAhmJ1FdvZL
X-Gm-Gg: ASbGncs2l8AUCifxnE5ir3QMCNJT3rGwD78ZAoP9mNtuQJjo+6h2WqPgCLFKf0GmZWS
	8hG9ZbaQDU3Q4Iu/a3BLnKusoJMErjJSilBH37H52YoR6LNk/myqigPWWfTmpELHqRtkkUT78X3
	rJDZESM8YA2J7ZY0dPm0FWxvoyBonyT4J/qYWnObnrW8vhMOCw7VXNEUepAsZnNj2APjW89EdrN
	MEvWv1p8Dne7QvTnRDRc+XYSELcFf3HxLOwlvhfuxFv0rmsL2hhiNXTsevX6yg=
X-Google-Smtp-Source: AGHT+IGGGzNVmZRlxflSSn+0JQ0xMAX7wzoYLeOoMIPYi0cvSFLcVxabxC/uMSeQboIel6TVrMvMyQ==
X-Received: by 2002:a05:600c:870b:b0:434:f131:1e64 with SMTP id 5b1f17b1804b1-434f1312144mr68106905e9.9.1733802764318;
        Mon, 09 Dec 2024 19:52:44 -0800 (PST)
Received: from [192.168.42.90] ([85.255.235.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38621909739sm14601748f8f.66.2024.12.09.19.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 19:52:43 -0800 (PST)
Message-ID: <12cb04de-dfbe-4247-b1d6-8e6feae640d8@gmail.com>
Date: Tue, 10 Dec 2024 03:53:36 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 04/17] net: prepare for non devmem TCP memory
 providers
To: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-5-dw@davidwei.uk>
 <20241209191526.063d6797@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241209191526.063d6797@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/10/24 03:15, Jakub Kicinski wrote:
> On Wed,  4 Dec 2024 09:21:43 -0800 David Wei wrote:
>> +EXPORT_SYMBOL_GPL(net_is_devmem_page_pool_ops);
> 
> Export doesn't seem necessary, no module should need this right?

I remembered TCP can be modularised, but seems CONFIG_INET is
bool. Then yeah, can be killed.

  
>> @@ -316,10 +322,10 @@ void dev_dmabuf_uninstall(struct net_device *dev)
>>   	unsigned int i;
>>   
>>   	for (i = 0; i < dev->real_num_rx_queues; i++) {
>> -		binding = dev->_rx[i].mp_params.mp_priv;
>> -		if (!binding)
>> +		if (dev->_rx[i].mp_params.mp_ops != &dmabuf_devmem_ops)
>>   			continue;
>>   
>> +		binding = dev->_rx[i].mp_params.mp_priv;
>>   		xa_for_each(&binding->bound_rxqs, xa_idx, rxq)
>>   			if (rxq == &dev->_rx[i]) {
>>   				xa_erase(&binding->bound_rxqs, xa_idx);
> 
> Maybe add an op to mp_ops for queue unbinding?
> Having an op struct and yet running code under if (ops == X) seems odd.

ok

>> -	if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
>> -		goto err_cancel;
>> +	if (net_is_devmem_page_pool_ops(pool->mp_ops)) {
>> +		binding = pool->mp_priv;
>> +		if (nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
>> +			goto err_cancel;
> 
> ditto, all mps should show up in page pool info. Even if it's just
> an empty nest for now, waiting for attributes to be added later.
> 
>> +	}
>>   
>>   	genlmsg_end(rsp, hdr);
>>   
>> @@ -353,16 +356,16 @@ void page_pool_unlist(struct page_pool *pool)
>>   int page_pool_check_memory_provider(struct net_device *dev,
>>   				    struct netdev_rx_queue *rxq)
>>   {
>> -	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
>> +	void *mp_priv = rxq->mp_params.mp_priv;
>>   	struct page_pool *pool;
>>   	struct hlist_node *n;
>>   
>> -	if (!binding)
>> +	if (!mp_priv)
>>   		return 0;
>>   
>>   	mutex_lock(&page_pools_lock);
>>   	hlist_for_each_entry_safe(pool, n, &dev->page_pools, user.list) {
>> -		if (pool->mp_priv != binding)
>> +		if (pool->mp_priv != mp_priv)
>>   			continue;
>>   
>>   		if (pool->slow.queue_idx == get_netdev_rx_queue_index(rxq)) {
> 
> appears to be unrelated

The entire chunk? It removes the type, nobody should be blindly casting
it to devmem specific binding even if it's not referenced, otherwise it
gets pretty ugly pretty fast. E.g. people might assume that it's always
the right type to cast to.

>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index b872de9a8271..f22005c70fd3 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -277,6 +277,7 @@
>>   #include <net/ip.h>
>>   #include <net/sock.h>
>>   #include <net/rstreason.h>
>> +#include <net/page_pool/types.h>
> 
> types.h being needed to call a helper is unusual

it's in devmem.h, so types.h shouldn't be needed indeed


-- 
Pavel Begunkov


