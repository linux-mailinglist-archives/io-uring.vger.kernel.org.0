Return-Path: <io-uring+bounces-3611-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC9DC99AE6C
	for <lists+io-uring@lfdr.de>; Sat, 12 Oct 2024 00:02:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF9172877BC
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 22:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7664E1CB509;
	Fri, 11 Oct 2024 22:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LyD7loEo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2677F9;
	Fri, 11 Oct 2024 22:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728684144; cv=none; b=ZkbQEr4r0SUHB6sgvgize/D1GsNqXW+/FSEu/aLdeYf3Jnhv2NU+zZHNtb+2IlGkJJXoyYDKTCYyeUXsEMm7uB7/SgoMtW3lL+yXCDJhbW+yBdrBLWvML5XriOmkFxoBfM+5opX/w3PgmXUk3CjgF1YN4K3xhTR9AubF4KaQer8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728684144; c=relaxed/simple;
	bh=bgNYNmsflmWvAGLUvqWN3OoCog44ijpeG3esEhF/BUs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GkDOutRHfrS6KjGyT1b1zd5Dro3iPFt4U49hIBl1JtGj9ktsoCh6nMI7+aFY6OEH2f+hvIrM3vDViD9l85uHMPp9nd2c7OWmeMaeP8TrWGxan26iUG/qWnngJmR3eRJnpb7eEsrbnvlS/dxldKTheCIFlk8KhEkuxvuJ2yZJT6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LyD7loEo; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a99650da839so411865066b.2;
        Fri, 11 Oct 2024 15:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728684141; x=1729288941; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1kWUCwLnYbZlauyEs9Wnez5KPziLHEMtLzqhUZDiV3U=;
        b=LyD7loEoa2ZMqPKTWxCe+HvDDnGN/6ptAWrijILpTbF6swaYj7qGa0LsAoKN7hUyD2
         zIzwWhyQcgsXGCB9VSZ6nCfngxnKnyL8HMcP2LEy0HWLVkbs2ha7r05jeAyc+VlwqPSA
         O+epfB99dEtV1uf2fooEq2SEX/sSQaS5JaTXyvFS5iDXqyuZ5S2J8QCed+syoDWQ8qXv
         qCxmAsWjqE8iKeF0njKLoMcpHWtIFWRUUfGVScqIcP+uy4NIxRtwDG1HXZhviVCD1C50
         mQdSZS3rypYhQkJ61xQ9EIA8hhFaKsVH8PtNAz9R8lwYwWWbuaHxS0zF2Qa1+cCVaZkT
         /C2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728684141; x=1729288941;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1kWUCwLnYbZlauyEs9Wnez5KPziLHEMtLzqhUZDiV3U=;
        b=TvrviG2LLKWht1WwkK9iJquUgbXPlzkjXseU58LxiduVZa1mHYP+dRCQsKtLfFqwSN
         s8fEn8e2WX34lXLa7Id8MMpIC8IJYUQ2eHUrWuPLkD6DzHgcQ+ofHFcscBlja89zIW29
         kZBmqeKu9xSz9PMPfCr3nOWmzrc74hVKaFFic5b8DnfrJ4WbVkuvk2HhW9bF9FbZpumE
         5iX0CKvhRW2kCy2TTNwUhqu5RNsag7/iyheoNBi1TbB2h7CYb1q2EiZ5/LcIErUQ5lzr
         2yzQRDxPhZIiuoaJPQ/htrStuCpO9e+we/zM7ivRQBa+yr/Gem1FhZJrtgQ1OHl8vycl
         WHnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVC1sdeJ+a+VZPcTSJyExwdtgRQYBnnrqcrMC8Sd+USlVGmUN4Hrz815nG287W404BDhsEDG/A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLhN7EE43IMyxXwcW9hJz4Ffh6nxwlB5PGA071RKmAIMXEMoh8
	isecyO/QQZfgHsNhI79MGBv2NxJDZT2WEz+dUzZrySv6H/p/ZaQ1
X-Google-Smtp-Source: AGHT+IENrLEGrfXplxgzPrLujFuIjCYP3tylt9fhO6wqNjcBzi5l8LxiTGPwJ6Q6RjaOxpo3OBaepg==
X-Received: by 2002:a17:906:fe4b:b0:a99:8abf:3610 with SMTP id a640c23a62f3a-a99e3b30f48mr82456666b.14.1728684140695;
        Fri, 11 Oct 2024 15:02:20 -0700 (PDT)
Received: from [192.168.42.194] ([85.255.233.136])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99a80dc524sm259482366b.148.2024.10.11.15.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 15:02:20 -0700 (PDT)
Message-ID: <7d321d9e-48bb-4e5f-bca5-6a6c940e3a9a@gmail.com>
Date: Fri, 11 Oct 2024 23:02:52 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 03/15] net: generalise net_iov chunk owners
To: David Wei <dw@davidwei.uk>, Stanislav Fomichev <stfomichev@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-4-dw@davidwei.uk> <ZwVT8AnAq_uERzvB@mini-arch>
 <ade753dd-caab-4151-af30-39de9080f69b@gmail.com> <ZwavJuVI-6d9ZSuh@mini-arch>
 <b2aa16ac-a5fe-4bab-a047-8f38086f4d43@davidwei.uk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <b2aa16ac-a5fe-4bab-a047-8f38086f4d43@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/24 19:44, David Wei wrote:
> On 2024-10-09 09:28, Stanislav Fomichev wrote:
>> On 10/08, Pavel Begunkov wrote:
>>> On 10/8/24 16:46, Stanislav Fomichev wrote:
>>>> On 10/07, David Wei wrote:
>>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>>
>>>>> Currently net_iov stores a pointer to struct dmabuf_genpool_chunk_owner,
>>>>> which serves as a useful abstraction to share data and provide a
>>>>> context. However, it's too devmem specific, and we want to reuse it for
>>>>> other memory providers, and for that we need to decouple net_iov from
>>>>> devmem. Make net_iov to point to a new base structure called
>>>>> net_iov_area, which dmabuf_genpool_chunk_owner extends.
>>>>>
>>>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>>>> Signed-off-by: David Wei <dw@davidwei.uk>
>>>>> ---
>>>>>    include/net/netmem.h | 21 ++++++++++++++++++++-
>>>>>    net/core/devmem.c    | 25 +++++++++++++------------
>>>>>    net/core/devmem.h    | 25 +++++++++----------------
>>>>>    3 files changed, 42 insertions(+), 29 deletions(-)
>>>>>
>>>>> diff --git a/include/net/netmem.h b/include/net/netmem.h
>>>>> index 8a6e20be4b9d..3795ded30d2c 100644
>>>>> --- a/include/net/netmem.h
>>>>> +++ b/include/net/netmem.h
>>>>> @@ -24,11 +24,20 @@ struct net_iov {
>>>>>    	unsigned long __unused_padding;
>>>>>    	unsigned long pp_magic;
>>>>>    	struct page_pool *pp;
>>>>> -	struct dmabuf_genpool_chunk_owner *owner;
>>>>> +	struct net_iov_area *owner;
>>>>
>>>> Any reason not to use dmabuf_genpool_chunk_owner as is (or rename it
>>>> to net_iov_area to generalize) with the fields that you don't need
>>>> set to 0/NULL? container_of makes everything harder to follow :-(
>>>
>>> It can be that, but then io_uring would have a (null) pointer to
>>> struct net_devmem_dmabuf_binding it knows nothing about and other
>>> fields devmem might add in the future. Also, it reduces the
>>> temptation for the common code to make assumptions about the origin
>>> of the area / pp memory provider. IOW, I think it's cleaner
>>> when separated like in this patch.
>>
>> Ack, let's see whether other people find any issues with this approach.
>> For me, it makes the devmem parts harder to read, so my preference
>> is on dropping this patch and keeping owner=null on your side.
> 
> I don't mind at this point which approach to take right now. I would
> prefer keeping dmabuf_genpool_chunk_owner today even if it results in a
> nullptr in io_uring's case. Once there are more memory providers in the
> future, I think it'll be clearer what sort of abstraction we might need
> here.

That's the thing about abstractions, if we say that devmem is the
only first class citizen for net_iov and everything else by definition
is 2nd class that should strictly follow devmem TCP patterns, and/or
that struct dmabuf_genpool_chunk_owner is an integral part of net_iov
and should be reused by everyone, then preserving the current state
of the chunk owner is likely the right long term approach. If not, and
net_iov is actually a generic piece of infrastructure, then IMHO there
is no place for devmem sticking out of every bit single bit of it, with
structures that are devmem specific and can even be not defined without
devmem TCP enabled (fwiw, which is not an actual problem for
compilation, juts oddness).

This patch is one way to do it. The other way assumed is to
convert that binding pointer field to a type-less / void *
context / private pointer, but that seems worse. The difference
starts and the chunk owners, i.e. io_uring's area has to extend
the structure, and we'd still need to cast both that private filed
and the chunk owner / area (with container_of), + a couple more
reasons on top.

-- 
Pavel Begunkov

