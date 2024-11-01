Return-Path: <io-uring+bounces-4320-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 641A29B96B4
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:41:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6C8E81C21BBB
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 17:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD8581CC897;
	Fri,  1 Nov 2024 17:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dHaLX6On"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFF301AC884;
	Fri,  1 Nov 2024 17:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730482863; cv=none; b=fV0DMJKeVS7vgxYhnkWphKMAJh/9Mn/VUNk3Nrs30vfvLxpE2eL8RDNMerl/cMArfEl4MDs5Gf2VLvFvGualunTZbK+2pfkQ54LLuH3BPb2sY4EMkbF3w30EABqdjc9ILEu8WJTLpV4Z2Kd1NELoZUfAmKQ2nm6jJin+sn86lbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730482863; c=relaxed/simple;
	bh=q+mSis0eJrpzcfbXQ4vOMDEyoAC5gFQlxWK7wgJPFbM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vBtqvsNNhmwkHo4wJW6kEaBjNWmOkOWTXKTC0FGRjm/df3AL+P8FLyS7A+T5R8AtejVz5atjPBeZ8rYPdMZyPC2t2XSnCVNJMs0M8LvxJ5vJtNc6Um96lAdxrLOUKmkP2Xn+CAvj14m8xFcMSU6oK6kQo41/63OXP3CZKuPuQF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dHaLX6On; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-37d41894a32so1235599f8f.1;
        Fri, 01 Nov 2024 10:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730482860; x=1731087660; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iTwsd4RDo3jFbS015Dfc+aEcibnzb1LuBrWGUJngbOM=;
        b=dHaLX6On8sZUSRc3VOlga/UXKVMewDsmBbZRmCa32MO3hvdrKGAV8K+BdgY3zn+lqV
         qyKnxNLJA26ApsgEhlfBwO6XPrhke7x4KhVCiFWZea2OD1FRAqXNtwhEx6QEp4IiNmIH
         mfgqhphwqm9dE3775viOp/xHPnv5MJJ/AwtA75FEkcGg5yNbOYNPwH9UiGn0CuYLO/MF
         VBuDVCnC7OaFJ+laTq6yFDwly96s9E5kRGi+G4eMl2zVd7pBbIhQqNSxuo7FD/lkJ68W
         35WF6PdIgAysuV7qsStPkPN4qUVO9hn2d1v5DMnW1lgSz75w9Sn/QZumR+AqDuCGMQSw
         cNQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730482860; x=1731087660;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iTwsd4RDo3jFbS015Dfc+aEcibnzb1LuBrWGUJngbOM=;
        b=FpLE8jZLBLO3RzXdK24KIwyeTkSb53WscpvGTTtZghlsGiQiISs+pbCCj3sYXVa+Xy
         jr1iJTRIn4/I/ZgezIXCCgJVO1T2D2QTtWtYqp97JZN8OOuQoBzHuslIohv9pU80tl1n
         VlsFNUDYgyWZNZ2J7Hn6wOsHVRHMKau5q2HBZtvT7fGmKud8LQqUrScL3n6UcQe78Sld
         ESEGVyIKN+6W69vgSiIW82dERe5iB7FCxD6tDpoLiy91A2V4Fx//sUNpQRMCfz/WztiR
         GAh+LSf1yqZanbdo4xeSMu/rHfuPXt8pjD3APcglL3hCkN6+lapHytLKIzxYMDi2oa6e
         MfNw==
X-Forwarded-Encrypted: i=1; AJvYcCXIm28U8LBjcbTqM23whj0gW8XxRXklK+HMUREA6bZOKa9OyTvL7/dIiJKrCZZzzvzD4aaw2zk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCrp9R5GD7NEo64wwCqDimdhlg53E0he4+KEFgvWxMCQV3EM4T
	GyQal/qhxSJg3LkbQJNqd2a3C7MH9RIhNNDG4zFOHQm2aAcyJ4xD
X-Google-Smtp-Source: AGHT+IHb1gtgC+CA86ED+yRUNLH0wa8osL8Mxswo6TjQAAakiOk8u0P57fXFQrku88HxGB0JeZofZA==
X-Received: by 2002:a05:6000:1f8c:b0:37d:3780:31d2 with SMTP id ffacd0b85a97d-381c79b88cemr4080615f8f.15.1730482860039;
        Fri, 01 Nov 2024 10:41:00 -0700 (PDT)
Received: from [192.168.42.19] ([85.255.236.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4327d6848b5sm68485835e9.32.2024.11.01.10.40.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2024 10:40:59 -0700 (PDT)
Message-ID: <5b928f0e-f3f8-4eaa-b750-e3f445d2fa46@gmail.com>
Date: Fri, 1 Nov 2024 17:41:05 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/15] net: prepare for non devmem TCP memory providers
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241029230521.2385749-1-dw@davidwei.uk>
 <20241029230521.2385749-5-dw@davidwei.uk>
 <CAHS8izPZ3bzmPx=geE0Nb0q8kG8fvzsGT2YgohoFJbSz2r21Zw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPZ3bzmPx=geE0Nb0q8kG8fvzsGT2YgohoFJbSz2r21Zw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/1/24 17:09, Mina Almasry wrote:
> On Tue, Oct 29, 2024 at 4:06 PM David Wei <dw@davidwei.uk> wrote:
...
>> +
>>   static void net_devmem_dmabuf_free_chunk_owner(struct gen_pool *genpool,
>>                                                 struct gen_pool_chunk *chunk,
>>                                                 void *not_used)
>> @@ -316,10 +322,10 @@ void dev_dmabuf_uninstall(struct net_device *dev)
>>          unsigned int i;
>>
>>          for (i = 0; i < dev->real_num_rx_queues; i++) {
>> -               binding = dev->_rx[i].mp_params.mp_priv;
>> -               if (!binding)
>> +               if (dev->_rx[i].mp_params.mp_ops != &dmabuf_devmem_ops)
>>                          continue;
>>
> 
> Use the net_is_devmem_page_pool_ops helper here?

It could, but the function is there primarily for outside users to
avoid ifdefs and build problems. I don't think it worth reiteration?
I'll change if there is a next version.

...
>> @@ -244,8 +244,11 @@ page_pool_nl_fill(struct sk_buff *rsp, const struct page_pool *pool,
>>                           pool->user.detach_time))
>>                  goto err_cancel;
>>
>> -       if (binding && nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
>> -               goto err_cancel;
>> +       if (net_is_devmem_page_pool_ops(pool->mp_ops)) {
>> +               binding = pool->mp_priv;
>> +               if (nla_put_u32(rsp, NETDEV_A_PAGE_POOL_DMABUF, binding->id))
>> +                       goto err_cancel;
>> +       }
> 
> Worthy of note is that I think Jakub asked for this introspection, and
> likely you should also add similar introspection. I.e. page_pool

I think we can patch it up after merging the series? Depends what Jakub
thinks. In any case, I can't parse io_uring ops here until a later patch
adding those ops, so it'd be a new patch if it's a part of this series.

> dumping should likely be improved to dump that it's bound to io_uring
> memory. Not sure what io_uring memory 'id' equivalent would be, if
> any.

I don't think io_uring have any id to give. What is it for in the
first place? Do you give it to netlink to communicate with devmem
TCP or something similar?

>>          genlmsg_end(rsp, hdr);
>>
>> @@ -353,16 +356,16 @@ void page_pool_unlist(struct page_pool *pool)
>>   int page_pool_check_memory_provider(struct net_device *dev,
>>                                      struct netdev_rx_queue *rxq)
...
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index e928efc22f80..31e01da61c12 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -277,6 +277,7 @@
>>   #include <net/ip.h>
>>   #include <net/sock.h>
>>   #include <net/rstreason.h>
>> +#include <net/page_pool/types.h>
>>
>>   #include <linux/uaccess.h>
>>   #include <asm/ioctls.h>
>> @@ -2476,6 +2477,11 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
>>                          }
>>
>>                          niov = skb_frag_net_iov(frag);
>> +                       if (net_is_devmem_page_pool_ops(niov->pp->mp_ops)) {
>> +                               err = -ENODEV;
>> +                               goto out;
>> +                       }
>> +
> 
> I think this check needs to go in the caller. Currently the caller
> assumes that if !skb_frags_readable(), then the frag is dma-buf, and

io_uring originated netmem that are marked unreadable as well
and so will end up in tcp_recvmsg_dmabuf(), then we reject and
fail since they should not be fed to devmem TCP. It should be
fine from correctness perspective.

We need to check frags, and that's the place where we iterate
frags. Another option is to add a loop in tcp_recvmsg_locked
walking over all frags of an skb and doing the checks, but
that's an unnecessary performance burden to devmem.

> calls tcp_recvmsg_dmabuf on it. The caller needs to check that the
> frag is specifically a dma-buf frag now.
> 
> Can io_uring frags somehow end up in tcp_recvmsg_locked? You're still
> using the tcp stack with io_uring ZC right? So I suspect they might?

All of them are using the same socket rx queue, so yes, any of them
can see any type of packet non net_iov / pages

-- 
Pavel Begunkov

