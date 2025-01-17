Return-Path: <io-uring+bounces-5976-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D8D8A153AF
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:06:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3D871167957
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:05:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50D8919B5B1;
	Fri, 17 Jan 2025 16:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eUS6f46v"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6716A19C56D
	for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 16:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737129923; cv=none; b=Ybq1icAI2dK4sLgpBNy5fNunfDMykKkx7vi/5Y7a9HuZqEP3GU7Jh4Rq3YCjcCT0Kz5cRBZ6FuRnmdhXCW5W6KtOgBd4vZSE5a74s74v6ela1aCpWoE4sVTpHKJAeIN0nUu+gQf6foha/Bdm2AUzBSBsoyalOsJPHRpN6c4pTSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737129923; c=relaxed/simple;
	bh=wy06xOeMzXK3wadS3i63kPM89++ahvtQfL7/0Ozreyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sOjU/73Ucc8eNwKs+MsMUNqT9ilUdc2imW0MmJaNRApiRD7+B5RlIfSf59xRUQ2UgWYENCGib+fmX+SbtqceTuA4NkxCCJlG2CiHv5efoi2wRj/PrS/dHIIou2S1Sio56aWLvDlxP6MI2KRdaXBWjYLMhApRYkEunov4gdoj+Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eUS6f46v; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1737129920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wHsWaaOnX2c6yotAQbLl567h0Yv+ErdqwoVzXqTf/7c=;
	b=eUS6f46v/UiR67moPdYZ6RchxlpQEesEu+vn4Oz5NDDZjviSFWl2U5QjJiXsu9YODJfrGH
	ZyPtN17qA0xlWh2lGFjQXFO7uaxE492HivnPDUpmk9ukUyui8xyKXOjOy4+HnyiES5KDyH
	4HMM/hoJO2HmJnBnTxgzZNjoU70SAr4=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-RbVsHVz0OUKaLK5lGw1nsg-1; Fri, 17 Jan 2025 11:05:19 -0500
X-MC-Unique: RbVsHVz0OUKaLK5lGw1nsg-1
X-Mimecast-MFC-AGG-ID: RbVsHVz0OUKaLK5lGw1nsg
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43623bf2a83so16403925e9.0
        for <io-uring@vger.kernel.org>; Fri, 17 Jan 2025 08:05:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737129918; x=1737734718;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wHsWaaOnX2c6yotAQbLl567h0Yv+ErdqwoVzXqTf/7c=;
        b=IR3GtETwRPtjyp4mF2wy9dYX3kXRW8PprflsNc5Acruq7/wxew83/icE6/CSKopC/d
         Gzvuk//jQn7itaiNSq2wefNHSgdMqBMt2lwrzWABsUaFwJB+TTiiJcoJgltgrgaVoX0i
         pzieF3XQTv8t5g73e82/0rhtirHq+7b68b6V3TMVzetEOEKIH8XgG7Tycl561ZNMO/EJ
         7v6GEaluYB2CFX2pmuZtoiipNadJ70z2HPsd4mUKHYlQrVEEsDDXLMEoZMKtJsdWVGMG
         K7OYUJGyLFdSySLsjp8gwU6DhO/i41WVBZz+nxDA4feEKfPFX6lZyWAFc1+Y3TYT4aLl
         83wQ==
X-Forwarded-Encrypted: i=1; AJvYcCX50I6QxuAcJetFNbEYbOmc0oB7Kpv801Ex2MuiUToFNxctSqkLQ+C5v/8xLkQW3DV8+ootsc7ysQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyrUeJF+c+Ja4XiGxBCnTGgkxXFwWT6L9O4rDl/hT/qQ8w7BgvV
	StmIL0hRQflntt9DDdXBTLOK3YT8rs/K6Ye2SBL58ZI1N4P/eXcrk4nceE2o/rM7+KvYAgEp8zP
	mCN3y+aU+f+t6bscXMHJlD+5PqUMFAjcDuF2NOS6ZiXnmDvPambKJSgPX
X-Gm-Gg: ASbGncueAXK7vRWhs1Td90ciNgRpoCFzOOvzTngk9W2jYIMBbt6npQg8DrWD2W60vje
	vUKnEV67ta1vmmGs6nAPZHNwM2ii2vvQfmUurZB6Ey0D7cVmwapl4Kcs0p8mYW5EI0qZllmOlWT
	CSRe6K6zuhiDhs84hGO++FRSYVbe0Vur4icXnca7hvaoyBwVaSphqvgxvDAVGWGfn/VHPgJenEj
	eu5K0EirIjnpwjbkKpISUohsVuNgOZ0BVLIofc+MYKGtvNHOihTKx2qIjq9gg2ZqfPQGDeke2g6
	zKOXc5WX2ac=
X-Received: by 2002:a05:600c:871a:b0:436:e751:e445 with SMTP id 5b1f17b1804b1-438913c15b0mr38197695e9.5.1737129917941;
        Fri, 17 Jan 2025 08:05:17 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0d42rEQIGnkhAPcw/Veub5FwU4g1DViZXIDG9aBfKC46ng0B5r5Qngxma92dAVdxJIaqNgg==
X-Received: by 2002:a05:600c:871a:b0:436:e751:e445 with SMTP id 5b1f17b1804b1-438913c15b0mr38197045e9.5.1737129917520;
        Fri, 17 Jan 2025 08:05:17 -0800 (PST)
Received: from [192.168.88.253] (146-241-15-169.dyn.eolo.it. [146.241.15.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43890462195sm37454405e9.30.2025.01.17.08.05.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jan 2025 08:05:16 -0800 (PST)
Message-ID: <c25f6c3f-e576-4c56-ba4b-328dfecbfb35@redhat.com>
Date: Fri, 17 Jan 2025 17:05:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v11 00/21] io_uring zero copy rx
To: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
References: <20250116231704.2402455-1-dw@davidwei.uk>
 <406fcbd2-55af-4919-abee-7cd80fb449d3@redhat.com>
 <ce9caef4-0d95-4e81-bdb8-536236377f81@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <ce9caef4-0d95-4e81-bdb8-536236377f81@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/17/25 3:42 PM, Pavel Begunkov wrote:
> On 1/17/25 14:28, Paolo Abeni wrote:
>> On 1/17/25 12:16 AM, David Wei wrote:
>>> This patchset adds support for zero copy rx into userspace pages using
>>> io_uring, eliminating a kernel to user copy.
>>>
>>> We configure a page pool that a driver uses to fill a hw rx queue to
>>> hand out user pages instead of kernel pages. Any data that ends up
>>> hitting this hw rx queue will thus be dma'd into userspace memory
>>> directly, without needing to be bounced through kernel memory. 'Reading'
>>> data out of a socket instead becomes a _notification_ mechanism, where
>>> the kernel tells userspace where the data is. The overall approach is
>>> similar to the devmem TCP proposal.
>>>
>>> This relies on hw header/data split, flow steering ad RSS to ensure
>>> packet headers remain in kernel memory and only desired flows hit a hw
>>> rx queue configured for zero copy. Configuring this is outside of the
>>> scope of this patchset.
>>>
>>> We share netdev core infra with devmem TCP. The main difference is that
>>> io_uring is used for the uAPI and the lifetime of all objects are bound
>>> to an io_uring instance. Data is 'read' using a new io_uring request
>>> type. When done, data is returned via a new shared refill queue. A zero
>>> copy page pool refills a hw rx queue from this refill queue directly. Of
>>> course, the lifetime of these data buffers are managed by io_uring
>>> rather than the networking stack, with different refcounting rules.
>>>
>>> This patchset is the first step adding basic zero copy support. We will
>>> extend this iteratively with new features e.g. dynamically allocated
>>> zero copy areas, THP support, dmabuf support, improved copy fallback,
>>> general optimisations and more.
>>>
>>> In terms of netdev support, we're first targeting Broadcom bnxt. Patches
>>> aren't included since Taehee Yoo has already sent a more comprehensive
>>> patchset adding support in [1]. Google gve should already support this,
>>> and Mellanox mlx5 support is WIP pending driver changes.
>>>
>>> ===========
>>> Performance
>>> ===========
>>>
>>> Note: Comparison with epoll + TCP_ZEROCOPY_RECEIVE isn't done yet.
>>>
>>> Test setup:
>>> * AMD EPYC 9454
>>> * Broadcom BCM957508 200G
>>> * Kernel v6.11 base [2]
>>> * liburing fork [3]
>>> * kperf fork [4]
>>> * 4K MTU
>>> * Single TCP flow
>>>
>>> With application thread + net rx softirq pinned to _different_ cores:
>>>
>>> +-------------------------------+
>>> | epoll     | io_uring          |
>>> |-----------|-------------------|
>>> | 82.2 Gbps | 116.2 Gbps (+41%) |
>>> +-------------------------------+
>>>
>>> Pinned to _same_ core:
>>>
>>> +-------------------------------+
>>> | epoll     | io_uring          |
>>> |-----------|-------------------|
>>> | 62.6 Gbps | 80.9 Gbps (+29%)  |
>>> +-------------------------------+
>>>
>>> =====
>>> Links
>>> =====
>>>
>>> Broadcom bnxt support:
>>> [1]: https://lore.kernel.org/netdev/20241003160620.1521626-8-ap420073@gmail.com/
>>>
>>> Linux kernel branch:
>>> [2]: https://github.com/spikeh/linux.git zcrx/v9
>>>
>>> liburing for testing:
>>> [3]: https://github.com/isilence/liburing.git zcrx/next
>>>
>>> kperf for testing:
>>> [4]: https://git.kernel.dk/kperf.git
>>
>> We are getting very close to the merge window. In order to get this
>> series merged before such deadline the point raised by Jakub on this
>> version must me resolved, the next iteration should land to the ML
>> before the end of the current working day and the series must apply
>> cleanly to net-next, so that it can be processed by our CI.
> 
> Sounds good, thanks Paolo.
> 
> Since the merging is not trivial, I'll send a PR for the net/
> patches instead of reposting the entire thing, if that sounds right
> to you. The rest will be handled on the io_uring side.

I agree it is the more straight-forward path. @Jakub: do you see any
problem with the above?

/P



