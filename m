Return-Path: <io-uring+bounces-5348-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88A129E9CFD
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 18:24:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18BE71669C5
	for <lists+io-uring@lfdr.de>; Mon,  9 Dec 2024 17:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE748155325;
	Mon,  9 Dec 2024 17:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fj2K67J0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EB2153BEE;
	Mon,  9 Dec 2024 17:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733765041; cv=none; b=e9v/8tNCt/seNxo7z1GQSUjq7oPTYTX8s02M1Vojbu0QD6ETZa768tfzXHEe/exU9lSPZShIILUQEx5QUVp9Hu9ELNJDdJW7aGmb7FEApieqHOXmJy/shNboxdW3hhQrnxaIO2zFTRa4Uv3t/1a4DWddMegJO/jt+6ka5e6ClIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733765041; c=relaxed/simple;
	bh=Ran93Djr5Ll1LM1y75Npe22RSbCwnFOABEYu3gAJxgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BL7rRexWWtf6Ex75mmj/C1U0hwo6IzmhhydtIVIoQlLiuQUTxGvxEB6aa1wrtWnLNemX7ejatAL2n2At4NKDVtNHrFFjgDQWmkcn2YYgOwm0v+xfkb5Ng5JnqWaTC0RTMN5kEmDa6Vd6h/Kie8Jd8qEQwlNkdQ0AIbxXSE8Jmc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fj2K67J0; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d3e6f6cf69so3196857a12.1;
        Mon, 09 Dec 2024 09:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733765038; x=1734369838; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QRvjM8wWy5ND+Jnmvo7xP/iefj/vWYMFntiDdt24YKU=;
        b=Fj2K67J0tfqTfToclnFm9T8i42XUmJcNhASPMae40ZQyMCHnpk0faltDAEvJu73jJt
         WZS+AY2nF9+EpfDR+Q2FEyMsgEAlinNJlf1FeJyK6wYu929Ry+x7Q1oie2J4Cc/f6jAW
         5HY+lWdb/+PpGqjhRL+UWyuQYJnMKzfNsnBda47srzKEKRekatDHFcTk6PcczjE5pern
         1geeegyFL0sgFVpap+UMa+opARo+M9jKooQp9LI8WrZDMfJjuCEYjrEZGg6t/CZFZD0S
         dPumEWedePhW1JsirCkE7DHyFfmKTmBg403F3pJGeyamV1lB+cYrDm6r4/QvbVEvjxFC
         QCOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733765038; x=1734369838;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QRvjM8wWy5ND+Jnmvo7xP/iefj/vWYMFntiDdt24YKU=;
        b=NzUnHxyVzuuMwoOXJt5NEHSxJjycs2YJIzEaEaq5SiOO0i3mKqkHkp98JV4yuHobY3
         pseVkRBr3aoJ69Ux4FLdP4D5ZVuh/lVbwqYWpXpnSmfhWQ1Adfc9UD5GWRdYEZHv7vi9
         38TexpN7iKLzDfPMxUGUSwR118sMmqGiN8bIaahr2ySl8GGYlOC9r9L+xjFNAemsjtbW
         caYjJgvGpJQCb5UektOh2R7uQm5Sv7uqi4C3oKpnGwDzmGi8DvYA0HD0qXrNSPGQ5uf0
         4O1lh0lNbaMFi3sBH0JdGB+yWtvViGpChvSak3br0wQIiPLfBqcVQUwjvBZvsQ4fNNRl
         S6Vg==
X-Forwarded-Encrypted: i=1; AJvYcCX78gTpbumg5BYhsXeM1x83LvEcv7kK4tqdGXwQh/zdDQ3xLmLCXhK3EwxPhQgHLUwr4CDx08s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwL6ofekjeJIwgRKvlfdHAu8G8m9YzJk/FeK3ZGxi5q9dC+jzuK
	LfzCaamXIz0bEeX1sb3gpUtvnTxCtErnNPBcO+HfZqEVOhqJIQfQ7m/76A==
X-Gm-Gg: ASbGncs1A8v5Lk4e3pOv44tGjhxZB3a56TgZ5Oy6FYdJ7RiV0cAGihG4DUUJPz+Pwtq
	R02jatNsceIFlrndNA4nafy0BMPRDCsJx9WuBlmp4ceNzTETwfmxnCCf0guIrgQc7E+tGV2esBs
	02d3ZSgEAEJwvU270r8/PZMG+laoI/ubK0ZsZnIrRuWodC8vjejYZ4vWaaKot44CaH1JFI2nzEi
	omzOEVmr8DE3nSL9CHJHV0lB25in2lmQWJwdnlRH47dfYwY8CXD62qQkm6X
X-Google-Smtp-Source: AGHT+IEAKQYSVmLDkiUbDaGhV99DvpUQ5J4Vgthg8dw/ZKNxyrXjrg4XHBUkXJGXe+ayPXvnY10V5Q==
X-Received: by 2002:a17:907:7708:b0:aa6:8fed:7c14 with SMTP id a640c23a62f3a-aa68fed7dcfmr323134066b.17.1733765037931;
        Mon, 09 Dec 2024 09:23:57 -0800 (PST)
Received: from [192.168.42.75] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa67117df90sm309997666b.170.2024.12.09.09.23.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Dec 2024 09:23:57 -0800 (PST)
Message-ID: <8a17ffe7-b2ce-4316-8243-512dd40522cc@gmail.com>
Date: Mon, 9 Dec 2024 17:24:52 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 05/17] net: page_pool: add ->scrub mem
 provider callback
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-6-dw@davidwei.uk>
 <CAHS8izPQQwpHTwJqTL+6cvo04sC1WEhcY7WuA_Umquk4oRCGag@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPQQwpHTwJqTL+6cvo04sC1WEhcY7WuA_Umquk4oRCGag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/9/24 17:08, Mina Almasry wrote:
> On Wed, Dec 4, 2024 at 9:22 AM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> Some page pool memory providers like io_uring need to catch the point
>> when the page pool is asked to be destroyed. ->destroy is not enough
>> because it relies on the page pool to wait for its buffers first, but
>> for that to happen a provider might need to react, e.g. to collect all
>> buffers that are currently given to the user space.
>>
>> Add a new provider's scrub callback serving the purpose and called off
>> the pp's generic (cold) scrubbing path, i.e. page_pool_scrub().
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: David Wei <dw@davidwei.uk>
> 
> I think after numerous previous discussions on this op, I guess I
> finally see the point.
> 
> AFAIU on destruction tho io_uring instance will destroy the page_pool,
> but we need to drop the user reference in the memory region. So the
> io_uring instance will destroy the pool, then the scrub callback tells
> io_uring that the pool is being destroyed, which drops the user
> references.
> 
> I would have preferred if io_uring drops the user references before
> destroying the pool, which I think would have accomplished the same
> thing without adding a memory provider callback that is a bit specific
> to this use case, but I guess it's all the same.

For unrelated reasons I moved it to a later stage to io_uring code,
so pool->mp_ops->scrub is no more. v8 is just weird, I think David
sent an old branch because Jakub asked or so.

> Reviewed-by: Mina Almasry <almasrymina@google.com>

-- 
Pavel Begunkov


