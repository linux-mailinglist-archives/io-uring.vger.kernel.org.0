Return-Path: <io-uring+bounces-5440-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BCAC9ECED1
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 15:42:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8A5B71882841
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 14:42:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332F2189B8B;
	Wed, 11 Dec 2024 14:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jTNESz1q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B72183CBB;
	Wed, 11 Dec 2024 14:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733928118; cv=none; b=R0iTQpdbHkuiDX8NwwqqG2nIk7fa1kitIsVAyxxUDqzHRNxQcJFYJPqpYisBH4KjP147ydtnW1OtkwKgdwcDDTqPznkMB4d8P5nyKyrBQGKgP3wGLW49x7ufl0d8QJ8LozWIpasEVgMCbIzpsPpKKLd+wgeK6IzcgY9hv2cRw0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733928118; c=relaxed/simple;
	bh=2zCr7zTEDvwh0hxmt8kosvt5S4x9iQ1y8ZMqi/6QkiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F1F68wBTuA7C60RMNf48csat8xX2sIGQHS/Vx2Wo9jm0J4QUlnxMG/DXBdPDk+oWzHf6vNUpElVxLJTrCh8Z8KUmx3zzzDAFBRqSR+5OgDulFTzRJHlIrg09fKYeq4VOsVyvR/M2732pCvvekSDax4kASPXKMk+z8GSDFQ0PK28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jTNESz1q; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso1051730666b.1;
        Wed, 11 Dec 2024 06:41:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733928114; x=1734532914; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hkbOevxvo+2AHuPTmTX9U9nsm+MQ6tjjMsdfgSE7Tcc=;
        b=jTNESz1qH5DQjCVmZbClCAxRR9xx05vTm6MhIgqKXWitDo8lFsdhbatqEUtRuZ8rso
         leYl8Uui6+RIh3ixmKb5jOJH/F4TcLR9qO/G4IhhWnOh+zg+1ReU5+iStrbYlBwng6yN
         jlp7g4rOs6oLfZAaPVm7S03z2AZpP7KKVNjJOcj6I312tNoH2ZXLHERcwzrWrSTpOuOA
         4t9E/X77bsS4CBkxRddZMZ5kdttmrUY1mK88snIHLIs2hsZ03oZjvEUfcUR3e0T8gCR9
         DdfN+ZNnKaLH4CzH5wy2Spm/YLpFQM4gwn7vBjD9UokK5CSOq2WRGymyvrom+nuN5dde
         OdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733928114; x=1734532914;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hkbOevxvo+2AHuPTmTX9U9nsm+MQ6tjjMsdfgSE7Tcc=;
        b=AeLiDcPg8T9cdKP2ukSdoDZoz/d3J8n3IBspE1n7MPXnvU08GOZdmIIKf8ix18VCze
         pvA67E8pm3emj6ysGXonF8iCV7cEDzCPqeFaro+rAhdOHtbaZqe+pinikcXEwScAB9TZ
         sx8NibjtZ7PS0eoZ+x82sEQJE4vU3LuPSqpX/sECpsEX7A+GFfUf4LjRzF5ZVXqSRoCu
         FzVU4GVIln3dkGZaCH3TksnPHmeU9thzCjBB4/o4ADEcGFjjXs5dmpQskXmwVhdV0RMc
         /8cACBvbR4VBYCScO7uZle0TWQg6Zu6L81tCSEEVd5EIz1GWInPB5a4SyF+IccWM9xJ6
         z5Qw==
X-Forwarded-Encrypted: i=1; AJvYcCWo6AevjN/fuOxD2wFGGg03GVtNNFh6Uq1aoxsPkban2iVv7mCC4fTeSe4CEZuDVq6zYkQK9LPU@vger.kernel.org, AJvYcCXTUlDNQRWBdce2IIYzSlnB0RlKFfz9vA2pj/dz20TOfr1vECwqiU8GNnGnQ4LIHzA8dxc4s378tA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsO0A9CG9bDVdmn4qFYfmKW0+grz+uVW5GcTGWDElNzOc79tT9
	q7WGHplk54/LG54jmRgopipe9iFtFbWQfDcWm6zR9FD3VwXlh18y
X-Gm-Gg: ASbGnctznvwYl9t9xFqLNF+cYq7o/Kzpgl8b5T0ABewiJgV5lWjGAARpbdlhfL+J2PQ
	6CEyJwzZGPx90KJYVj2p3Tb8KXI66HYJr7OypJAOgWgSrO39q9lmUWa+f+A8Wjz3DdhZ2bSpQdy
	Mg8Np/4zpZf+U9Xn9/XtDbXJg0CMM44V0/Nm6relS2RV4xZnIsZtFKJSVjK6e9wCBdv6jc1zv1q
	tvA4krmKXNZ2hxz6JrV1AJIRz7OZ6x9wcrx50VBZbnvTiOjruwEEFZ/JUJXTN4wIw==
X-Google-Smtp-Source: AGHT+IHzXL2ZE64atw/hBytgozJvn8AbubwyvuvtiJ1aQmZ4Fu5JuRqeu0RKShCtfuMflGASIzdrkw==
X-Received: by 2002:a17:906:2931:b0:aa6:29dc:11b with SMTP id a640c23a62f3a-aa6c1ae6a06mr6880966b.16.1733928113524;
        Wed, 11 Dec 2024 06:41:53 -0800 (PST)
Received: from [192.168.42.162] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa69964872asm365208866b.103.2024.12.11.06.41.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2024 06:41:53 -0800 (PST)
Message-ID: <95e02ca4-4f0d-4f74-a882-6c975b345daa@gmail.com>
Date: Wed, 11 Dec 2024 14:42:43 +0000
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
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20241210162412.6f04a505@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/11/24 00:24, Jakub Kicinski wrote:
> On Tue, 10 Dec 2024 04:45:23 +0000 Pavel Begunkov wrote:
>>> Can you say more about the IO_ZC_RX_UREF bias? net_iov is not the page
>>> struct, we can add more fields. In fact we have 8B of padding in it
>>> that can be allocated without growing the struct. So why play with
>>
>> I guess we can, though it's growing it for everyone not just
>> io_uring considering how indexing works, i.e. no embedding into
>> a larger struct.
> 
> Right but we literally have 8B of "padding". We only need 32b counter
> here, so there will still be 4B of unused space. Not to mention that
> net_iov is not cacheline aligned today. Space is not a concern.
> 
>>> biases? You can add a 32b atomic counter for how many refs have been
>>> handed out to the user.
>>
>> This set does it in a stupid way, but the bias allows to coalesce
>> operations with it into a single atomic. Regardless, it can be
>> placed separately, though we still need a good way to optimise
>> counting. Take a look at my reply with questions in the v7 thread,
>> I outlined what can work quite well in terms of performance but
>> needs a clear api for that from net/
> 
> I was thinking along the lines of transferring the ownership of
> the frags. But let's work on that as a follow up. Atomic add on

That's fine to leave it out for now and deal later, but what's
important for me when going through preliminary shittification of
the project is to have a way to optimise it after and a clear
understanding that it can't be left w/o it, and that there are
no strong opinions that would block it.

The current cache situation is too unfortunate, understandably so
with it being aliased to struct page. pp_ref_count is in the
same line with ->pp and others. Here an iov usually gets modified
by napi, then refcounted from syscall, after deferred skb put will
put it down back at napi context, and in some time after it gets
washed out from the cache, the user will finally return it back
to page pool.

> an exclusively owned cacheline is 2 cycles on AMD if I'm looking
> correctly.

Sounds too good to be true considering x86 implies a full barrier
for atomics. I wonder where the data comes from?

-- 
Pavel Begunkov


