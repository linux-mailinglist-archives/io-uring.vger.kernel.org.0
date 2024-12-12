Return-Path: <io-uring+bounces-5463-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BBFB9EE7F7
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 14:42:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E9F1A164EBC
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 13:42:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA39215765;
	Thu, 12 Dec 2024 13:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WZtJlYbo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB00F2153F1;
	Thu, 12 Dec 2024 13:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734010887; cv=none; b=G0WDeEw05+H2ZwEBP5BS122S73fQs8ZUM3z1JRwGi+j1hbJQE0VTm9+9mdN8qws8FZoxS7XZ1O7ucLOqxvGuT2t1Lvx4+swa32ZfBgRQvyY5T0CWipRyiUHHr8ESaaQwpBnnztuVe2T6SYIz93ixMvvN+xmgNjxrZIGNkPRF1s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734010887; c=relaxed/simple;
	bh=pUHmf0mhKLKJIZxGDFKwe5seyoskdqsOUhlUpkF+IWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C7muEplp7Zbo0kmPq0FSM40mdJeUuw2XnDUCGDstBDpC4MpG15rrvHZt8PtvY41sFdkADdlLDCSO2HkLLs1+TPJk7z8nbXBp+8G9OK5crbPzuM2uxkB9XuMz9Sn6RvUbfg8HYlXxHdZePsqRrd+Eyn02NMh5pT5TXMmV1WANicI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WZtJlYbo; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-aa543c4db92so120818566b.0;
        Thu, 12 Dec 2024 05:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734010884; x=1734615684; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Rm54dNiNnMXJQcokcYmdmvqL+ri2Vs23TwQuYYmFOo=;
        b=WZtJlYboVzr8dJneX2bI8SkJ9gtmyfpwbFj3AUIP6rQxiZOKmphuvLt+0IZR1IvMz2
         e30Bh5KmP19t/xr+z0MzZ3Ck3t7ob6jUvWaEGj4QGqgQdsy/tRn6fisIQYA8cP3KoQRq
         SetF9W89ID5SC3e5Pi6fI8GYLzQ2BxkGOGedaLamZbcAal/OXowgMnCVarVZgXD+DL2y
         rmjaQuZw+XLzQRU0hZT0GQMFS+v58hEtpJi44UG2CahuBC1anqR3o0qdJWMqZtzfgPM8
         PmDZaVJJHSV6GdCzjcCrZ/ZiBAz88BjsR1ywdUkNSOJ3o14Cfg7mp397FPu1fqpUco/a
         /+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734010884; x=1734615684;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Rm54dNiNnMXJQcokcYmdmvqL+ri2Vs23TwQuYYmFOo=;
        b=TK+7UDVBSR8SD5Wr3ZJKdb3iJYCBaIqc+h1aQxPJMTPKuSoEw62oN0Q6U3OJtVwOZo
         pNN8ubn3Z8yLZgjicfp32WDl5YLOz4GYbb1ShKdaamalxp8lHS0G4caxyBmTIjO58s0L
         pXzYwtr34W3CdgOCjHv2T4ejldE970lupoNUnZVL6rPT8wLp3Ua1CxCh0pDuHM0XrvR+
         P3yGyOIfOSZDl7FyyTG6pP+C6Ah5KRSNuI7WPtntKPRPc6iDvqlg9Z8qJpEw434MWXJ1
         qnxNH3in53GFZxy27QhLm0q/QogFc03HolZ3UYN5MyFh/fFlR+rGO53VVKYT24rY9R46
         wSXQ==
X-Forwarded-Encrypted: i=1; AJvYcCUywhJbuHI7d64WHvviYImdxXPXQyRTkf2e31gdseNMJLgCqrLAAx08rDU3dgnf7eY1ngrPSCDU@vger.kernel.org, AJvYcCX482f17GFrrLBo4kPVI1PpVMB8GYIMQlC2hb14SyiK9G6j882pfnBGWaFs7h00oQpvBtC4WzA63g==@vger.kernel.org
X-Gm-Message-State: AOJu0YydCgpWEAsK6JK/uw12cdRvyRLKAS4d9JN6tEUwV7pKZ786Oti7
	05wjQgu6Ml/gj7l/udHNXurk+sXrxsdER3WAmggerJdim86ieJpd
X-Gm-Gg: ASbGnctN3u7crclOP+GHOJrM+DhM+kaI27g5SMTINegXQ3ShRkBN7NN+S65wxXVv/rQ
	hh2VCXQNwD4ygCQmbc4zH9RAgSK16jAYrWmjUYw5UQlpvHoR9CXo9CDSqZftVRDT3fNHyJRfL0U
	y7QeAv2y0w0+IyHCsWQWqLps/p6+STtvKS0T9k8APnMpgzHqIwIn5AgMbjMi0uTWpb2jk+9+EYG
	bst1r/+bQbrs9KrMFybziA1IXVdTRha8F6kijFDmbISb3vWiB7RiRNZPj0JGVDaUgMF
X-Google-Smtp-Source: AGHT+IGemgtuoEeD3C7sXk9AMUM1jn3pxVyF2VKf7Qsis8sU3JYiuHM4ZSSya5VL9Kg8tY4f3+qPQQ==
X-Received: by 2002:a17:906:18b1:b0:aa6:a228:afaf with SMTP id a640c23a62f3a-aa6b13c34fdmr549251266b.52.1734010883723;
        Thu, 12 Dec 2024 05:41:23 -0800 (PST)
Received: from [192.168.42.180] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa698e922dasm487126066b.84.2024.12.12.05.41.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 05:41:23 -0800 (PST)
Message-ID: <0d7e9623-b3e4-4191-bb5e-456e1d665942@gmail.com>
Date: Thu, 12 Dec 2024 13:42:11 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v8 11/17] io_uring/zcrx: implement zerocopy
 receive pp memory provider
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
 <20241204172204.4180482-12-dw@davidwei.uk>
 <20241209200156.3aaa5e24@kernel.org>
 <aa20a0fd-75fb-4859-bd0e-74d0098daae8@gmail.com>
 <20241210162412.6f04a505@kernel.org>
 <95e02ca4-4f0d-4f74-a882-6c975b345daa@gmail.com>
 <20241211173855.461cb6ec@kernel.org>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241211173855.461cb6ec@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 01:38, Jakub Kicinski wrote:
> On Wed, 11 Dec 2024 14:42:43 +0000 Pavel Begunkov wrote:
>>> I was thinking along the lines of transferring the ownership of
>>> the frags. But let's work on that as a follow up. Atomic add on
>>
>> That's fine to leave it out for now and deal later, but what's
>> important for me when going through preliminary shittification of
>> the project is to have a way to optimise it after and a clear
>> understanding that it can't be left w/o it, and that there are
>> no strong opinions that would block it.
>>
>> The current cache situation is too unfortunate, understandably so
>> with it being aliased to struct page. pp_ref_count is in the
>> same line with ->pp and others. Here an iov usually gets modified
>> by napi, then refcounted from syscall, after deferred skb put will
>> put it down back at napi context, and in some time after it gets
>> washed out from the cache, the user will finally return it back
>> to page pool.
> 
> Let's not get distracted. It's very unusual to have arguments about
> microoptimizations before the initial version of the code is merged :|

I can't avoid it since one of the goals is to save cpu cycles,
and it's not that micro either, but I hear you.

>>> an exclusively owned cacheline is 2 cycles on AMD if I'm looking
>>> correctly.
>>
>> Sounds too good to be true considering x86 implies a full barrier
>> for atomics.
> 
> Right but two barriers back to back are hopefully similar impact as one.
> 
>> I wonder where the data comes from?
> 
> Agner's instruction tables. What source do you use?

Mostly observational and from scattered hw knowledge. Seems like
the table says that the best case chained latency is ~8 cycles
for zen4, pretty good!

-- 
Pavel Begunkov


