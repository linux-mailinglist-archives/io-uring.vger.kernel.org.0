Return-Path: <io-uring+bounces-4612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B7F659C45BA
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 20:20:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 46B91B281A3
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 19:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FB491AA7B1;
	Mon, 11 Nov 2024 19:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="MUB5VFPA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 974F71AAE2C
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 19:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731351719; cv=none; b=rvjPyXp0di9qPwTfLZixzpgdDfEWTMoOPoR80Y2fUlkqD8BWjEJcoXpDD6Gwb36V232fvIiClTv2NKbmMwQDGhmCyTJ/Ftya7/npEJZ8zpkiG07h+GzISnfqNJJtBBLh0Zf/xxTmTKbsT39TszyIFI3vHGH5sDHY+wuM/qXTQhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731351719; c=relaxed/simple;
	bh=2qosowZfcXDZCQRMkI6UwmSNo6ohP8VZN5R7DrJlFrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RTF8YC+My+3vq2/jtsVB0wr5xCB+l6x60IgaVbKiBFQACIx4EeIBI3IDAHBxkO0NKjwEo/GjRQrXKRMjUmfji1IhvCzodkjKlk0iuNVRg4xcfQgpKU7Ffz1oIISCxDNBOt+oo4RUleKAcuz5eNRtRUDxV9yq0ld7NoSR1sdDm4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=MUB5VFPA; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-720aa3dbda5so3425406b3a.1
        for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 11:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1731351717; x=1731956517; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4Fx+fECUJWCJb9xT8zwLAOIoRx4ZLPc3YkncvkxByPk=;
        b=MUB5VFPAg5RF3ZzilAfFt0QzYRzHIRaCSjkN6KKZVWwaGq1GJ3rDjsZ3spZohtmMEZ
         l9MaW55ZNbxMDS98/NGqJV63y5yEjfnWH/fjjnAqNQbSyaGOu2R5nzlyjX0QmeiWn0jG
         exYwhDfb98Xn8P76DQdvSlFBCb1/sgSjMfYqZtI4PWdERTuV8HWY8csP1O7O9gO5Icez
         ESUzGvdMcgBx+10QQ+Qg0XPWD9ACiVWpK4sTjGJCenMIK/3dYcYHEwfj7ZKBlclo4NSo
         tDNhdbgzeyRdnfCaVQaGon63N/QWCFG4Z83d8WE61wbuqD9xaErhZ3Y69T3bNtCeqBd9
         ZqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731351717; x=1731956517;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Fx+fECUJWCJb9xT8zwLAOIoRx4ZLPc3YkncvkxByPk=;
        b=tpGZ7fmF0mPmivMCdoB/oUDGGByN38qHXhcM1Epws7kw7/pztGRSu5JTXKewGyDyrj
         RJs1OobBALO0BYvpHBffXA7xun9wHsuW0u+C1+jWiBDXyqe7CmdyZuopRdE2mBwHNDK9
         aZBZS2TfOeBMXw2BWKxer0Nxm0+FBJSwNb6AZ6FdMj08zr/APZmWU5Mw1mUyYDls1Byr
         d4Y4PC8aoQOtBPeIyf7PLU3jz1pQ81A7+G6QbYi8ftfbByyRhJ6/9MCbuedhik5rMiYR
         K0OhoKRDKwVKpYS7v/kzFlt7KdloVVoWGT9n3E6pHLVsyckYuy6Ae5ZQCu9CGVBUCZlU
         QXHA==
X-Gm-Message-State: AOJu0YxeyszHwlonR33UMkicCH7kaFq+lkANtdWKVUqlWkcwVRB3KTwU
	UEnpH9JaAD6f3EOF+/523EMhbSQbPaPMMzuDc1I9bIDCpxewRG1hmWQRKwWUbbU=
X-Google-Smtp-Source: AGHT+IErj9+5S/yu4Q2E9UF7dfrHFqpLoYiCuUvaB22Y2hbBR7G78N6zo/2+qQ8WYOq9BLhByaoNkg==
X-Received: by 2002:a05:6a00:3a2a:b0:71e:4ee1:6d78 with SMTP id d2e1a72fcca58-7244a4fde5fmr56522b3a.1.1731351716847;
        Mon, 11 Nov 2024 11:01:56 -0800 (PST)
Received: from [192.168.1.10] (71-212-14-56.tukw.qwest.net. [71.212.14.56])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f41f4895fesm8820361a12.12.2024.11.11.11.01.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2024 11:01:56 -0800 (PST)
Message-ID: <c5213478-a6ec-431e-b11b-cc8271a84d59@davidwei.uk>
Date: Mon, 11 Nov 2024 11:01:55 -0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 04/15] net: prepare for non devmem TCP memory providers
Content-Language: en-GB
To: Mina Almasry <almasrymina@google.com>,
 Pavel Begunkov <asml.silence@gmail.com>
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
 <5b928f0e-f3f8-4eaa-b750-e3f445d2fa46@gmail.com>
 <CAHS8izMTuEMS2hyHs0cit0Wvo3DcuHxReE1WS-crJ8zDTs=_Wg@mail.gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <CAHS8izMTuEMS2hyHs0cit0Wvo3DcuHxReE1WS-crJ8zDTs=_Wg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2024-11-04 05:20, Mina Almasry wrote:
> On Fri, Nov 1, 2024 at 10:41 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> ...
>>>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>>>> index e928efc22f80..31e01da61c12 100644
>>>> --- a/net/ipv4/tcp.c
>>>> +++ b/net/ipv4/tcp.c
>>>> @@ -277,6 +277,7 @@
>>>>   #include <net/ip.h>
>>>>   #include <net/sock.h>
>>>>   #include <net/rstreason.h>
>>>> +#include <net/page_pool/types.h>
>>>>
>>>>   #include <linux/uaccess.h>
>>>>   #include <asm/ioctls.h>
>>>> @@ -2476,6 +2477,11 @@ static int tcp_recvmsg_dmabuf(struct sock *sk, const struct sk_buff *skb,
>>>>                          }
>>>>
>>>>                          niov = skb_frag_net_iov(frag);
>>>> +                       if (net_is_devmem_page_pool_ops(niov->pp->mp_ops)) {
>>>> +                               err = -ENODEV;
>>>> +                               goto out;
>>>> +                       }
>>>> +
>>>
>>> I think this check needs to go in the caller. Currently the caller
>>> assumes that if !skb_frags_readable(), then the frag is dma-buf, and
>>
>> io_uring originated netmem that are marked unreadable as well
>> and so will end up in tcp_recvmsg_dmabuf(), then we reject and
>> fail since they should not be fed to devmem TCP. It should be
>> fine from correctness perspective.
>>
>> We need to check frags, and that's the place where we iterate
>> frags. Another option is to add a loop in tcp_recvmsg_locked
>> walking over all frags of an skb and doing the checks, but
>> that's an unnecessary performance burden to devmem.
>>
> 
> Checking each frag in tcp_recvmsg_dmabuf (and the equivalent io_uring
> function) is not ideal really. Especially when you're dereferencing
> nio->pp to do the check which IIUC will pull a cache line not normally
> needed in this code path and may have a performance impact.

This check is needed currently because the curent assumption in core
netdev code is that !skb_frags_readable() means devmem TCP. Longer term,
we need to figure out how to distinguish skb frag providers in both code
and Netlink introspection.

Since your concerns here are primarily around performance rather than
correctness, I suggest we defer this as a follow up series.

> 
> We currently have a check in __skb_fill_netmem_desc() that makes sure
> all frags added to an skb are pages or dmabuf. I think we need to
> improve it to make sure all frags added to an skb are of the same type
> (pages, dmabuf, iouring). sending it to skb_copy_datagram_msg or
> tcp_recvmsg_dmabuf or error.

It should not be possible for drivers to fill in an skb with frags from
different providers. A provider can only change upon a queue reset.

> 
> I also I'm not sure dereferencing ->pp to check the frag type is ever
> OK in such a fast path when ->pp is not usually needed until the skb
> is freed? You may have to add a flag to the niov to indicate what type
> it is, or change the skb->unreadable flag to a u8 that determines if
> it's pages/io_uring/dmabuf.
> 
> 

