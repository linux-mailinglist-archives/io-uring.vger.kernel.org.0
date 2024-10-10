Return-Path: <io-uring+bounces-3570-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 599D69991AF
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 21:05:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A0161C23BA9
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 19:05:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB65818E02D;
	Thu, 10 Oct 2024 18:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LvROmFas"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34F119CD1B;
	Thu, 10 Oct 2024 18:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728586593; cv=none; b=LkU9764lX/PtvLKqQkJ/eWtVWuWVJfAtMQe7DDQgEq3SVGe8Jo21xipsu0buj0lwU1KeT+Emph6YoQjnrFMebrSxRGg7XMJiPws+Id+D4n7Xm06/ZpXH7hnKgkZYjVsnyeoY3bxqa57Q+NCaCLCsrCAxv29PRwDUg7T12Abz/l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728586593; c=relaxed/simple;
	bh=DShGqDbna5jw6iH3SmgN2X/XDmZWaz4uUzW8R6IdXus=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DViJ0A8hm4CLFAAfXCjZw8MeM9VNq5NN1v8yPabHU8d/Yz6GFMyWe31YA1ON0KmA1Zfvn/MR7Gfm3pgirXTm8wgcdC7xTetZMzRheG/uw844O8hzeejPt//Pujnikula+Y7tldAP2/FJ3s1OEHK3Xs05XtSF1+TqnIPEfCgNsJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LvROmFas; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2fb2f4b282cso1881811fa.2;
        Thu, 10 Oct 2024 11:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728586590; x=1729191390; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YOoqt3SzjBQgpsIKWRZ4l0Y3knuV1eGfkQz04nzTz9k=;
        b=LvROmFasYmsn+2b4zTYlzccKKucougJBY1MELqD7ku0mt/1Oa4UJ0zL6WX2EmbIy9b
         D2uPtSR8UkUDJi1THdv1lyC2FMZqO5lxl1hCnzOvOKAkOOimPFO3fj9yDL01j9D8ZPKk
         ewhCuIqlV6UmM2F05PTauD0yRp672le1/NhPhVMYinqmBP6qgzC5wMS5VqW+cIGi7Kqs
         jZlGyUF8gj/Ver2kQqkHcQ9q7gaC+Nw+fufQHEwo/ZwFpRRLCjNo7hH7+Xzpr0U7aQ9/
         9HvOOS0DsQHOgWo6e1+ndcrv8oJ/M2E38I+/WDu8mW8PgQ1nYnhEw8I5TCk4/TF4GZ1S
         MHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728586590; x=1729191390;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YOoqt3SzjBQgpsIKWRZ4l0Y3knuV1eGfkQz04nzTz9k=;
        b=sHjDfXrg0L3gsCLqHsXb7LW93b7kVJyoF2mv4eOv+ju+lMLUcwLBgF5rTsc+u6FuRh
         VM00N1MYv1igqi7vcGRKYaGFIe52+xExteRVekMdDLdSlj+nVThZ560QosVp0IZLSKqK
         mg8wCpSkVoBZvN2qtnmHXWkzKiZnX1ioDL/nhQ6gCeBBdE/VKKy9PzQRY2BIjDqqfMVB
         NVAJjoXJpHle+uxnSfdDDSXvklxKiRSneiZoMpdjr94OIF32BSQeQMXL5VzOup3SZgnV
         ZFE+G5uxJoEXizEULFBYistfUf3zfwcRMZ66KuGhQt6oKEKmW+7vZWtysSmSZyySYiwu
         l2xA==
X-Forwarded-Encrypted: i=1; AJvYcCUHNqSu8ujEfAX/GwBBlGhsdeC8qMViwT6WvJ8CsXy37iCU99ZOmkFhUvimgoXHMEgEIcXKnEPM@vger.kernel.org, AJvYcCWxwaD/PeumKADn4txroD6P6JaNFmaNVwMKx+2YaxyPrmp0kIw/IVWEf1MYJORwPP6rdu9StQeUIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxcEA8yCE8ar0RboqFimiexuJmGt7ZdulE3FlRe5UUjuxwKTfhm
	og/Trsf6uScRlw67Zau33nV5263ietRWs+GurdzyhCTXyqCqzw68
X-Google-Smtp-Source: AGHT+IEyShYJV6lRfcFYMwYvVWw2WHFcx7g3WhxAaQO3kv9S0E6ishVh6w2uHfpmcMHZUhVb82IE8A==
X-Received: by 2002:a2e:702:0:b0:2fb:2b5d:215d with SMTP id 38308e7fff4ca-2fb2b5d2206mr7146121fa.7.1728586589309;
        Thu, 10 Oct 2024 11:56:29 -0700 (PDT)
Received: from [192.168.42.219] ([148.252.140.94])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b6bd057sm2169418f8f.35.2024.10.10.11.56.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 11:56:28 -0700 (PDT)
Message-ID: <d7915d17-9ee2-4486-8d39-f9ccaa53fc13@gmail.com>
Date: Thu, 10 Oct 2024 19:57:04 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/15] net: devmem: pull struct definitions out of
 ifdef
To: Mina Almasry <almasrymina@google.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-2-dw@davidwei.uk>
 <CAHS8izMHmG8-Go6k63UaCtwvEcp=D73Ja0XfrTjNp_b5TUmUFA@mail.gmail.com>
 <ed21bca5-5087-4eff-814c-39180078a700@gmail.com>
 <CAHS8izNGdFTr789fFhV_NvYK0ORKPwn_KHu0CeaZp_xhg9PgCA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izNGdFTr789fFhV_NvYK0ORKPwn_KHu0CeaZp_xhg9PgCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/10/24 19:01, Mina Almasry wrote:
> On Wed, Oct 9, 2024 at 4:16 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 10/9/24 21:17, Mina Almasry wrote:
>>> On Mon, Oct 7, 2024 at 3:16 PM David Wei <dw@davidwei.uk> wrote:
>>>>
>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>
>>>> Don't hide structure definitions under conditional compilation, it only
>>>> makes messier and harder to maintain. Move struct
>>>> dmabuf_genpool_chunk_owner definition out of CONFIG_NET_DEVMEM ifdef
>>>> together with a bunch of trivial inlined helpers using the structure.
>>>>
>>>
>>> To be honest I think the way it is is better? Having the struct
>>> defined but always not set (because the code to set it is always
>>> compiled out) seem worse to me.
>>>
>>> Is there a strong reason to have this? Otherwise maybe drop this?
>> I can drop it if there are strong opinions on that, but I'm
>> allergic to ifdef hell and just trying to help to avoid it becoming
>> so. I even believe it's considered a bad pattern (is it?).
>>
>> As for a more technical description "why", it reduces the line count
>> and you don't need to duplicate functions. It's always annoying
>> making sure the prototypes stay same, but this way it's always
>> compiled and syntactically checked. And when refactoring anything
>> like the next patch does, you only need to change one function
>> but not both. Do you find that convincing?
>>
> 
> To be honest the tradeoff wins in the other direction for me. The
> extra boiler plate is not that bad, and we can be sure that any code

We can count how often people break builds because a change
was compiled just with one configuration in mind. Unfortunately,
I did it myself a fair share of times, and there is enough of
build robot reports like that. It's not just about boiler plate
but rather overall maintainability.

> that touches net_devmem_dmabuf_binding will get a valid internals
> since it won't compile if the feature is disabled. This could be
> critical and could be preventing bugs.

I don't see the concern, if devmem is compiled out there wouldn't
be a devmem provider to even create it, and you don't need to
worry. If you think someone would create a binding without a devmem,
then I don't believe it'd be enough to hide a struct definition
to prevent that in the first place.

I think the maintainers can tell whichever way they think is
better, I can drop the patch, even though I think it's much
better with it.

-- 
Pavel Begunkov

