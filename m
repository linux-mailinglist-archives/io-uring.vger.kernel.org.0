Return-Path: <io-uring+bounces-3587-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D7C22999C92
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 08:23:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79F24281F96
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 06:23:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12EE2581;
	Fri, 11 Oct 2024 06:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="QgvWzgJj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 667A4207A19
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 06:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728627778; cv=none; b=Rxv4zmyTBSj6VKZFvIQ9G5/HXTHzyn0+gzZs0dX/8ifJpim+Cua/L3hXWbZ/4wDPkXYNt6rFD2y8hNB5AupYrhnAaZwr8idevsaXHfkw2GB4POt5LJztro6LWuGVSm78vjJ1GnALLmHUuWVTJD7OaLkdcXfA1LKBR01wAV5aYQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728627778; c=relaxed/simple;
	bh=eJZHEdn2bbLS4dTouTtin6kXD3fZPwAbdDk/Beh9mtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7lzUn9DjU50lrg2Euec+HdVI7TV046zMKbH4WO5ILHO3teXEkzEzFDNC1f+d6M0VehhKLeBp6/NTreYcwXZJGVaRYLns4xJCJteCJoc51wS0zMA1kjibskiPAaw6CvTprkygstk6wsvBx8bzf28w26ZnlQFyLmZRNrUSnFHjbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=QgvWzgJj; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20bb39d97d1so15879695ad.2
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 23:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728627776; x=1729232576; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OLnKZSpGQwYjJvZL07qO2xnKdETckcZUHAWnCgHoE8A=;
        b=QgvWzgJjUcGsc1+6Fjezw6aTd1yazDqIyy5KFMQa0P8aEN9xVOW9auTA/D86I1PW81
         NdamRkDQ+bzcubUDTM+DjTkohklJmXwlxMC2/AuPA7eacF243S/kvXpmOZ7bv6UT5UQ8
         ptnMPJOjHpAweFpjqXdMuTeNuyM7MsvkqM6wtMKB1sgh8+uyRrlWXZd84fi7i/scRWtq
         r22I3tyMasLhLm3ceAZNebgmUZ3W7eKB84ZWYyZ5BjiGZj36ZyCJst+eWo27ChjDbmos
         IDhzePnOrYWQkXwR7pxwqphmGrEP/ZwdsLNtUZv0Mdug1loWgjTIbJA+oQM0hsVIrsgT
         Pitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728627776; x=1729232576;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OLnKZSpGQwYjJvZL07qO2xnKdETckcZUHAWnCgHoE8A=;
        b=IPoHoApFLVxshGK/kEh4oAeBzvNa5x+b1ZgUEGRfVrPMHK+NC8zLLmqQ0jHIHDyIUc
         gg3DyvIUto/20AuiSMMDu/R9ruDFmpiT74s4n83e7ITr/C/4kPRx6jZpjngiLo0qC7gz
         gT/DA3+7NvzdL38i34bUWEhs55U8eBGut648laH9+OTHwplAXmXUsGFxMa4ZRkmvP7Aa
         o/yqEbzx1rXypeczTQjdE5uutqH9LMjn3gGkRNUepCInm45kFl4A/DUgtTYzowCRPWW8
         nl+VZrws7TSuVl1RsejdjJtq5Rc95Sx5rarUCO9mYWmNiccHqtw77ulCydcKqt37F+RY
         wAWA==
X-Gm-Message-State: AOJu0YwzcRoHXKzPiBtYkTReZaspXZwBlWajxYZvHEw2AlcRNMtmA+Dr
	nyv4Bng0tqkfoVXQETlgMmJ9X43Dz2bJl3pQOSGfNefovQgTqGRIm1SLPTOMgBA=
X-Google-Smtp-Source: AGHT+IFEJtutQAHOQMS2LkYd56ziyy8i/1/PLOgW9u2Uyvq27aqxLerZ7QHBVTQLu5li4wzHPSaImQ==
X-Received: by 2002:a17:902:e546:b0:20b:968e:2583 with SMTP id d9443c01a7336-20ca144e9a3mr20084405ad.2.1728627776631;
        Thu, 10 Oct 2024 23:22:56 -0700 (PDT)
Received: from ?IPV6:2620:10d:c085:21e1::116b? ([2620:10d:c090:400::5:ebf3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c213028sm17998745ad.208.2024.10.10.23.22.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 23:22:56 -0700 (PDT)
Message-ID: <e13c8d8b-eb66-4dd3-bfd4-8303393c592c@davidwei.uk>
Date: Thu, 10 Oct 2024 23:22:53 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 13/15] io_uring/zcrx: add copy fallback
Content-Language: en-GB
To: Pavel Begunkov <asml.silence@gmail.com>,
 Stanislav Fomichev <stfomichev@gmail.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <20241007221603.1703699-14-dw@davidwei.uk> <ZwVWrAeKsVj5gbXY@mini-arch>
 <6b57fb43-1271-4487-9342-5f82c972b9c5@davidwei.uk>
 <Zwavm2w30YAdoFsB@mini-arch> <f872e215-25af-4663-a18e-659803cc1ea6@gmail.com>
From: David Wei <dw@davidwei.uk>
In-Reply-To: <f872e215-25af-4663-a18e-659803cc1ea6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024-10-09 16:05, Pavel Begunkov wrote:
> On 10/9/24 17:30, Stanislav Fomichev wrote:
>> On 10/08, David Wei wrote:
>>> On 2024-10-08 08:58, Stanislav Fomichev wrote:
>>>> On 10/07, David Wei wrote:
>>>>> From: Pavel Begunkov <asml.silence@gmail.com>
>>>>>
>>>>> There are scenarios in which the zerocopy path might get a normal
>>>>> in-kernel buffer, it could be a mis-steered packet or simply the linear
>>>>> part of an skb. Another use case is to allow the driver to allocate
>>>>> kernel pages when it's out of zc buffers, which makes it more resilient
>>>>> to spikes in load and allow the user to choose the balance between the
>>>>> amount of memory provided and performance.
>>>>
>>>> Tangential: should there be some clear way for the users to discover that
>>>> (some counter of some entry on cq about copy fallback)?
>>>>
>>>> Or the expectation is that somebody will run bpftrace to diagnose
>>>> (supposedly) poor ZC performance when it falls back to copy?
>>>
>>> Yeah there definitely needs to be a way to notify the user that copy
>>> fallback happened. Right now I'm relying on bpftrace hooking into
>>> io_zcrx_copy_chunk(). Doing it per cqe (which is emitted per frag) is
>>> too much. I can think of two other options:
>>>
>>> 1. Send a final cqe at the end of a number of frag cqes with a count of
>>>     the number of copies.
>>> 2. Register a secondary area just for handling copies.
>>>
>>> Other suggestions are also very welcome.
>>
>> SG, thanks. Up to you and Pavel on the mechanism and whether to follow
>> up separately. Maybe even move this fallback (this patch) into that separate
>> series as well? Will be easier to review/accept the rest.
> 
> I think it's fine to leave it? It shouldn't be particularly
> interesting to the net folks to review, and without it any skb
> with the linear part would break it, but perhaps it's not such
> a concern for bnxt.
> 

My preference is to leave it. Actually from real workloads, fully
linearized skbs are not uncommon due to the minimum size for HDS to kick
in for bnxt. Taking this out would imo make this patchset functionally
broken. Since we're all in agreement here, let's defer the improvements
as a follow up.

