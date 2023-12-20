Return-Path: <io-uring+bounces-329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE1AC819660
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 02:35:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0DBAB1C256C3
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 01:35:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF1FC7472;
	Wed, 20 Dec 2023 01:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dLWT6olq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B4A1944F;
	Wed, 20 Dec 2023 01:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-552ff8d681aso476234a12.1;
        Tue, 19 Dec 2023 17:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703036058; x=1703640858; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=57+aXNB5qv8CyqsGF/pwPSACnmkkb/+RawJeybYNrq8=;
        b=dLWT6olqqU2r7RIzfwPewH9p3tFUqTEcUaFhTnBNmslN30IOVa1sYbahv7sHGs9Aac
         tq/h3X2plKL22Bkm8zKLhi55hpAx+mm3+GWHwhI+JrQzpP65yaq/YH/Z2KSFxruHIng3
         iMr1xBgInENr3PXixk4jrOIKApU5EfVK/9sSCp9hLn2x++fWwGhUYNTW7ZyOV40uw+CC
         2geSzihy3iyp7fQQddPxgDitVqZjitD67eXI3WhxjXV0S7BS8EsfPohIAas/lFjC8tBV
         m3Ux3lP/BGj9Pp1/WN8WN5mVoP7R9SmrbRiUmZbRUfdZYckqMHQJgNwSbM0U59QPu8wE
         dEEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703036058; x=1703640858;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=57+aXNB5qv8CyqsGF/pwPSACnmkkb/+RawJeybYNrq8=;
        b=Ragz3dpf6KAX/7v/PnVBoLIV2/uzT0YbZgtZqTFrDh8cfgrgKV63rOlEVJgUTJV4ZT
         DLk5Sx9SWiU62ilDg08Zbz2OuUYAC+JBwhlubmpJPqiHaKIQb12EZNQs2Y13dZ7e2AoO
         +wmJt7bJ7md3CTOnqOcf9ljQDii4LvtM8q58FkFybt+ZLRPpzEQrMhWIamXPofyBJ1Fu
         nt9Q8di1qd/l8jFMD1bIjy0yZltuQoe/lICDppANqbNS0UTxIsLM/Utx7KOS8y+lzoTj
         SI0Mp18C12dp8/+DUqwzRKS+j/ajG1VQBmCp5rCBz+DHuYcRohskHlmgwIDHgO7CZ1Cy
         OjAA==
X-Gm-Message-State: AOJu0YxeQPIH3b8G8gyg+7lK2kpoByvLJTlXHyMm5eR4u5oBpD+M6nmr
	koUjSynLQZNDFR6UpB3caXM=
X-Google-Smtp-Source: AGHT+IFybTgeqc/hNszCr+AqCku1bd7zLor/48SyYKManF9ycneV+WYReC14mM11xCiOjS0nhixlvw==
X-Received: by 2002:a17:906:6c85:b0:a23:3767:28ad with SMTP id s5-20020a1709066c8500b00a23376728admr1939124ejr.70.1703036058543;
        Tue, 19 Dec 2023 17:34:18 -0800 (PST)
Received: from [192.168.8.100] ([85.255.233.166])
        by smtp.gmail.com with ESMTPSA id fw17-20020a170906c95100b00a2375780143sm1468155ejb.159.2023.12.19.17.34.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 17:34:18 -0800 (PST)
Message-ID: <9f5ea0cb-215a-4b43-92dc-d306015c8c7a@gmail.com>
Date: Wed, 20 Dec 2023 01:29:08 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 02/20] tcp: don't allow non-devmem originated ppiov
Content-Language: en-US
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-3-dw@davidwei.uk>
 <CAHS8izO0ADnYqKczEkfNts2VLDfiYEkQ=AzJ-xzb+Kh2ZpFjbg@mail.gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izO0ADnYqKczEkfNts2VLDfiYEkQ=AzJ-xzb+Kh2ZpFjbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/19/23 23:24, Mina Almasry wrote:
> On Tue, Dec 19, 2023 at 1:04 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> NOT FOR UPSTREAM
>>
>> There will be more users of struct page_pool_iov, and ppiovs from one
>> subsystem must not be used by another. That should never happen for any
>> sane application, but we need to enforce it in case of bufs and/or
>> malicious users.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   net/ipv4/tcp.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index 33a8bb63fbf5..9c6b18eebb5b 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -2384,6 +2384,13 @@ static int tcp_recvmsg_devmem(const struct sock *sk, const struct sk_buff *skb,
>>                          }
>>
>>                          ppiov = skb_frag_page_pool_iov(frag);
>> +
>> +                       /* Disallow non devmem owned buffers */
>> +                       if (ppiov->pp->p.memory_provider != PP_MP_DMABUF_DEVMEM) {
>> +                               err = -ENODEV;
>> +                               goto out;
>> +                       }
>> +
> 
> Instead of this, I maybe recommend modifying the skb->dmabuf flag? My
> mental model is that flag means all the frags in the skb are

That's a good point, we need to separate them, and I have it in my
todo list.

> specifically dmabuf, not general ppiovs or net_iovs. Is it possible to
> add skb->io_uring or something?

->io_uring flag is not feasible, converting ->devmem into a type
{page,devmem,iouring} is better but not great either.

> If that bloats the skb headers, then maybe we need another place to
> put this flag. Maybe the [page_pool|net]_iov should declare whether
> it's dmabuf or otherwise, and we can check frag[0] and assume all

ppiov->pp should be enough, either not mixing buffers from different
pools or comparing pp->ops or some pp->type.

> frags are the same as frag0.

I think I like this one the most. I think David Ahern mentioned
before, but would be nice having it on per frag basis and kill
->devmem flag. That would still stop collapsing if frags are
from different pools or so.

> But IMO the page pool internals should not leak into the
> implementation of generic tcp stack functions.

-- 
Pavel Begunkov

