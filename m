Return-Path: <io-uring+bounces-4338-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 708739B99E9
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 22:12:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CD640B20F0D
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72E161E2007;
	Fri,  1 Nov 2024 21:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cPYxpX49"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3722C1581F8;
	Fri,  1 Nov 2024 21:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730495545; cv=none; b=PoEdQ568V2MFsH2SFAugQvmFHT/ZI6Chcsb2Jt70qi88EyQIkAejsbqS9bfy2QiykXn2N9kKpOgPKUX7ApA227eOXJ3QUpLk6ZOP+ZYTNjFoZj6FKp/TICfDzOCjUC7Ip+5ZZJLQqt60w7KJe4imEVOLxNrc5c3csv2rAbixqOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730495545; c=relaxed/simple;
	bh=Ru1KvS3Sk+MBS/O+iEglJ7NvPCLg6ZXFJLeesuESTXY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VYWfuBktGIRQpcPHQmjIIN8b81LiqmlDm8F5wQHwS/1B6pmORBJeDpAyaArb4EvlM6T3svdBjgaEus16nEGRMI74xEehArtLpCXDMWPOZmzrAzuWvRbFPhyPVEGopbOiZ7Vo4V9q/LlxTagTxNYPf6kijm9GdEDuNY4uyrXj/Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cPYxpX49; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43167ff0f91so20721195e9.1;
        Fri, 01 Nov 2024 14:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730495540; x=1731100340; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LjT6Pgpy+3O5LZfi7jNdeVPoHv2yeKj92Pn8fqzrz1g=;
        b=cPYxpX49v5zI0EDvvTtjnsDnnm/uq7Vr9/lP8niqO/6RRuf1M0gNfjpQthJcmO1XCp
         C5OX2MCXZlTEoDW9yERK4mMlMzgfgsBH1FoDtHaJKlz2eAKOC1xfGzCqNjxkmUpLLkIU
         Vr9r/72wA54U4cVR9SAgDbeYdT59JNAcJ0Pzq23wWP+EU5gt6vNhHZ/D5TrZ9XeGk1Od
         RepxYbSrBfVQeT9Qjh4rhFuTboeyFGOL2zE8fh4DhcUIFlqAzhw0Edq72HzViyG9YGeI
         YvmqEpmTJVHP22XB+r3Xkay941Rl1tJ2EGiEDNKfg6GQ8jMxFMBTDkcYyqXyMb3o9CzD
         Tr7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730495540; x=1731100340;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LjT6Pgpy+3O5LZfi7jNdeVPoHv2yeKj92Pn8fqzrz1g=;
        b=EzoGvtgAM0DBUyBmBhtbk5gdKqB8ctTgGL3FWONf1HNgdq9lJca7ydPlaKulV/I7ns
         qpyTjlRG2Engr+zO9sAagplEV6XPsKcUwyw+mTCmIzPqrRZETZQstRFvfS3NYqU9ygO3
         Kr/49mE3Cm7Wp0Z3hJYzTGycRw84YCg71jmjUn8x0SWM/wC3H5gOKEO33FLo6mn3jFRh
         o1EiFr38yFwLpvHx9MfsT4vmnBpjHt0tBYh/o5vc8FNRB5s0ptlgQqcg5ItIaQNj231o
         aAHeuaHOEksTwbcIx9mCa/mbGhKF16AP5r0JmDEzzsmf//VyA52fT16tPiP1E0i9ddfG
         oPuA==
X-Forwarded-Encrypted: i=1; AJvYcCUn39PRuuGu6fvm/kbyKL8owyXANNNNBsugtQ8ELrWJ10A+woYd2lRQeaFE2B63DZMasLtjVk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHiz9PRLkprtDrRvigsvXO67ghYDidTNwUlnAab1orMQwfDd3d
	355Mz+9gMT6Di6enhdTyFMY5S7dimhSxfmiN+ckKdaQhhZop743+
X-Google-Smtp-Source: AGHT+IFsZdTAVog9wwckfTgLY1nZSNDsHl49MGGbToIgfbmQErRF39q+AaifIgrYBJ0iRWauFyfauw==
X-Received: by 2002:a05:6000:1867:b0:37d:4d80:34ae with SMTP id ffacd0b85a97d-381be7adff4mr7252066f8f.4.1730495540285;
        Fri, 01 Nov 2024 14:12:20 -0700 (PDT)
Received: from [192.168.42.19] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-381c113e771sm6205169f8f.81.2024.11.01.14.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 14:12:19 -0700 (PDT)
Message-ID: <169c530c-0c00-4677-979f-4a998e336e0b@gmail.com>
Date: Fri, 1 Nov 2024 21:12:31 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 13/15] io_uring/zcrx: set pp memory provider for an rx
 queue
To: Jens Axboe <axboe@kernel.dk>, Mina Almasry <almasrymina@google.com>,
 David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-14-dw@davidwei.uk>
 <CAHS8izMFV=1oRR6Tq-BVJxCL3hbEjNa0CBzWmWxbnk_0MZOs6w@mail.gmail.com>
 <ae63ef86-9dba-4360-bdbf-9ac5ae04adbf@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ae63ef86-9dba-4360-bdbf-9ac5ae04adbf@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/24 20:35, Jens Axboe wrote:
> On 11/1/24 2:16 PM, Mina Almasry wrote:
>> On Tue, Oct 29, 2024 at 4:06?PM David Wei <dw@davidwei.uk> wrote:
>>>
>>> From: David Wei <davidhwei@meta.com>
>>>
>>> Set the page pool memory provider for the rx queue configured for zero
>>> copy to io_uring. Then the rx queue is reset using
>>> netdev_rx_queue_restart() and netdev core + page pool will take care of
>>> filling the rx queue from the io_uring zero copy memory provider.
>>>
>>> For now, there is only one ifq so its destruction happens implicitly
>>> during io_uring cleanup.
>>>
>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>> ---
>>>   io_uring/zcrx.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++--
>>>   io_uring/zcrx.h |  2 ++
>>>   2 files changed, 86 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
>>> index 477b0d1b7b91..3f4625730dbd 100644
>>> --- a/io_uring/zcrx.c
>>> +++ b/io_uring/zcrx.c
>>> @@ -8,6 +8,7 @@
>>>   #include <net/page_pool/helpers.h>
>>>   #include <net/page_pool/memory_provider.h>
>>>   #include <trace/events/page_pool.h>
>>> +#include <net/netdev_rx_queue.h>
>>>   #include <net/tcp.h>
>>>   #include <net/rps.h>
>>>
>>> @@ -36,6 +37,65 @@ static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *nio
>>>          return container_of(owner, struct io_zcrx_area, nia);
>>>   }
>>>
>>> +static int io_open_zc_rxq(struct io_zcrx_ifq *ifq, unsigned ifq_idx)
>>> +{
>>> +       struct netdev_rx_queue *rxq;
>>> +       struct net_device *dev = ifq->dev;
>>> +       int ret;
>>> +
>>> +       ASSERT_RTNL();
>>> +
>>> +       if (ifq_idx >= dev->num_rx_queues)
>>> +               return -EINVAL;
>>> +       ifq_idx = array_index_nospec(ifq_idx, dev->num_rx_queues);
>>> +
>>> +       rxq = __netif_get_rx_queue(ifq->dev, ifq_idx);
>>> +       if (rxq->mp_params.mp_priv)
>>> +               return -EEXIST;
>>> +
>>> +       ifq->if_rxq = ifq_idx;
>>> +       rxq->mp_params.mp_ops = &io_uring_pp_zc_ops;
>>> +       rxq->mp_params.mp_priv = ifq;
>>> +       ret = netdev_rx_queue_restart(ifq->dev, ifq->if_rxq);
>>> +       if (ret)
>>> +               goto fail;
>>> +       return 0;
>>> +fail:
>>> +       rxq->mp_params.mp_ops = NULL;
>>> +       rxq->mp_params.mp_priv = NULL;
>>> +       ifq->if_rxq = -1;
>>> +       return ret;
>>> +}
>>> +
>>
>> I don't see a CAP_NET_ADMIN check. Likely I missed it. Is that done
>> somewhere? Binding user memory to an rx queue needs to be a privileged
>> operation.
> 
> There's only one caller of this, and it literally has a CAP_NET_ADMIN at
> the very top. Patch 9 adds the registration.

Right, Patch 9/15, checked very early before creating any objects.

-- 
Pavel Begunkov

