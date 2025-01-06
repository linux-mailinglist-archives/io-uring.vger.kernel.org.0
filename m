Return-Path: <io-uring+bounces-5696-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C21EA03376
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 00:47:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EC7CC18857BC
	for <lists+io-uring@lfdr.de>; Mon,  6 Jan 2025 23:47:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88AA71E25FE;
	Mon,  6 Jan 2025 23:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ewFryt2j"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091DA1E282D;
	Mon,  6 Jan 2025 23:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736207225; cv=none; b=aBGRTwani9/S4qgPlpoj37Qa2ukJ/aEil1kNjoyMWiUHC+7vAUBGo04UuyetDOPI2HxLF5O+IdypKgO4lz3KlqjJg64BUpbLOpU611tvkqrvUMsIRQk1JDu1KUUEO84E4tJ/cqSOD1UYxGuFCC/ddYZZCASVYMLtpnwjEI8S6Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736207225; c=relaxed/simple;
	bh=8U9lISpVZZFt6AItURiuzRD1EFB9MLx27WcXGG44bBY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CanrHQaR1+BDWGSucRJPtf8FyhAD2qUKj1vf5oyO6X6/sfU/cm9bSc6MLyWVyqM6rckB7by9FaUU/J0Vc8pjGqTI9IwPwdUR/H/7qp/Yu529K1oB6nJcEiHwZZ2/NE8zUU/3xuFG5bczNqV97co3VtPp6XgmBt5Li1w8O7NIfqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ewFryt2j; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d7e3f1fdafso31390134a12.0;
        Mon, 06 Jan 2025 15:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736207221; x=1736812021; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/puNe9g0p4JrOJpzmZPpXJ/sZAJRKjRuYYZrciRcu8U=;
        b=ewFryt2jMUN8u9Zc5tdV9CMN+jRL67Nfp7I7FmwhbGQi+4dAaAiapCek87+3yz3x6h
         VcnYJDcCAAIB2My/HKvGJfG6pPpbvJxsip7BzxJ2aeKT/FO1XxJoPWqps8I7MVLxckt0
         3SV/nOiRpvG80AHoGniJVQAzll1KwHRg0v/UHrq2il5Mb1p8ZWPKEAn1ypSb3HyaF8Rj
         kqpL/OPUCSVYB7Qhjhb6xmUG5ZP5ZY0kJ/zQNOqYn7BmzHqq+Y/4H20kl47HbUqf5DrJ
         6a0egtReecaJdJHWjI9il8/lfs7LNCBEy8oQubKrgCaC3qzu1887ERYNS5mCIepPn4BS
         CXZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736207221; x=1736812021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/puNe9g0p4JrOJpzmZPpXJ/sZAJRKjRuYYZrciRcu8U=;
        b=HQzDvnWfz+CB9JMW7OPf0QzBriLJL71d4OKBIGsItsNLdL31lwlgy36jaLag7HP7zh
         0ZLNhIX78u33Zk6YG4HbLdL+yk4IV0NRaH4SFgGAac6d/w9MO3mn3groyRRZkwzyXxmX
         40ZXv9nYp2Kj7/C4TFEsg2q7q4cy9kr+p7sUxS/FrEEh5hW4AQrOe03SvY840CJ1BBKr
         LczLTzSVVTDLOjRu5atvb/uB5aTNvwbeOTVE1l9ZK4LVpbz7Vq0jW/3jizkeKB4QHNuO
         u2nexeFCEjSq1DKCBwsdb5P4raOLMToj8YVzHQBsv1U8HbHGJgPNKT2uNTuCOSV0tqs1
         gGag==
X-Forwarded-Encrypted: i=1; AJvYcCWNOaP1We6LmioRBegJ4BvH0+TSU3ZotZEV5HkMKUYbbESk55zhGAbww91jWkITatb1llsnzhNz@vger.kernel.org, AJvYcCX+2KPLisb3l7L5l1hJ8rClZ7KSng77YSL2I81n4psHTlEPb/y6M8B7uOG1qH38xibxTpYsHk+qNg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwbZ1SsulpF+xtm00cIT7H1J8blE/wRLzFDHfnlX+8KXhB7IUPM
	0asclVWTlNoC8Tttc3Shk6AR3gejaxAhIZ0VPrZtC0pL7ahy9BHl7khLqw==
X-Gm-Gg: ASbGncsfUsGsJ97BmY8CF51bvSf9LgAf7Ht1xHzGkMo3lW5MzTn1iKvcG6wCINJvaXE
	Sx3x3QDEUJnX4JfYMyWXMokT+8wE/kpyB1+kk9LDqzYyHcl3ph5nvQ9ngs226FDzKmfKAqQLsi/
	NTqnCoqo6H6hVrRPQqt/9FTTFjENuEu+aBLtRlbbgSrZKpzFxPfOjonhDt0/cjPQQ6m+h71FFXj
	TcGlKMFUUNsqhsVFYqqejc0Hu6z/9EaYsDQhlIn1jCPGFbVW0Un9pMKrboxTJRKBw==
X-Google-Smtp-Source: AGHT+IHqbJ6r9yeTwrO0m88YHjAANQ91mCSXgL4R35SRE10QT+i/+iEvdnRdye4v3wBycj0VpVIfzw==
X-Received: by 2002:a05:6402:34c1:b0:5d3:ba97:527e with SMTP id 4fb4d7f45d1cf-5d81de20416mr54309732a12.25.1736207221012;
        Mon, 06 Jan 2025 15:47:01 -0800 (PST)
Received: from [192.168.8.100] ([148.252.133.16])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d8baa29afasm13011792a12.59.2025.01.06.15.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 15:47:00 -0800 (PST)
Message-ID: <519aae24-db5c-4889-89bb-3629d15934d6@gmail.com>
Date: Mon, 6 Jan 2025 23:48:00 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v9 08/20] net: expose
 page_pool_{set,clear}_pp_info
To: Mina Almasry <almasrymina@google.com>
Cc: Jakub Kicinski <kuba@kernel.org>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
 <20241218003748.796939-9-dw@davidwei.uk> <20241220143158.11585b2d@kernel.org>
 <99969285-e3f9-4ec8-8caf-f29ae75eb814@gmail.com>
 <20241220182304.59753594@kernel.org>
 <bcf5a9e8-5014-44cc-85a0-2974e3039cb6@gmail.com>
 <CAHS8izOb59+Z4phe=nJNVOTjOy2HByuh4N-RBgJd5dvhLC9F0A@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izOb59+Z4phe=nJNVOTjOy2HByuh4N-RBgJd5dvhLC9F0A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/6/25 22:17, Mina Almasry wrote:
> On Thu, Jan 2, 2025 at 8:20 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>
>> On 12/21/24 02:23, Jakub Kicinski wrote:
>>> On Sat, 21 Dec 2024 01:07:44 +0000 Pavel Begunkov wrote:
>>>>>> Memory providers need to set page pool to its net_iovs on allocation, so
>>>>>> expose page_pool_{set,clear}_pp_info to providers outside net/.
>>>>>
>>>>> I'd really rather not expose such low level functions in a header
>>>>> included by every single user of the page pool API.
>>>>
>>>> Are you fine if it's exposed in a new header file?
>>>
>>> I guess.
>>>
>>> I'm uncomfortable with the "outside net/" phrasing of the commit
>>> message. Nothing outside net should used this stuff. Next we'll have
>>> a four letter subsystem abusing it and claiming that it's in a header
>>> so it's a public.
>>
>> By net/ I purely meant the folder, even though it also dictates
>> the available API. io_uring is outside, having some glue API
>> between them is the only way I can think of, even if it looks
>> different from the current series.
>>
>> Since there are strong opinions would make sense to shove it into
>> a new file and name helpers more appropriately, like net_mp_*.
>>
> 
> I guess I'm a bit sorry here because I think I suggested this
> approach. I think the root of the issue is that the io_uring memory

No worries, that wasn't the reason at all. It got split to
support multiple pools per provider because of intricacies of
the queue api.

In v10 {set,clear}_pp* it's wrapped into helpers, which hide
even more networking bits.

-- 
Pavel Begunkov


