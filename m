Return-Path: <io-uring+bounces-3594-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5779099A64E
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 16:28:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0795E286880
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 14:28:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93A18219C87;
	Fri, 11 Oct 2024 14:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b="mgAWZOdK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE983218D91
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 14:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728656895; cv=none; b=lEoBvze256wPFI3o7NE8GWRfhKC7gWgeGUkyt3iktq6RJGmzBC0srn5fsJSpC1b8+lMfXKPYZOE0gtkMS7bGWdqzmBPObev3p3cOfO6BuL+Bph20z6Z1tcfmN2phMUDXFRn4iX+pwRf6kN9UUEpyjApMN3gjRzgK2P9qTy1twSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728656895; c=relaxed/simple;
	bh=dZ2uJBuBtTGAw2QAlPejjh+gQEDHGouBsp+uBPMgULQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HCIuJAEM9vs9r9HNh8W+whDjMhfWaubB47UflMKI/UZS8tJ/XdU/D8O3a9/FYHdvlVaZYI0JyguSRmr9Yh1vjwkbouy+vAPYj++Km/fGdGFz/QIWYjnSzzB49rGEPT88nHQghqrABf8Lp3SkgT0GWoX46Gd9GsYwdnXiWiKs1gM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com; spf=none smtp.mailfrom=mojatatu.com; dkim=pass (2048-bit key) header.d=mojatatu-com.20230601.gappssmtp.com header.i=@mojatatu-com.20230601.gappssmtp.com header.b=mgAWZOdK; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=mojatatu.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mojatatu.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-20c544d345cso15323185ad.1
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 07:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1728656893; x=1729261693; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KBZQ+2J87sYav7kebav8OyZqDFhTRod6WA3hieQG8as=;
        b=mgAWZOdKyCyZWUx5X3j7fGcx9gicg3nXuaGwPWhJ7UKQnWjBFqicLaPqmou4hw8vGy
         FIAmpkzXwKCx/Hx5bGDILwl9z+P8EZQDsIwO6Aw+ETNIdF2AXNbqRVMOyBJxeoElKg25
         GFwgZQBm6Aq4PkVWoAdViWztQ6FjgmR1xuWtZ2XGGkIJGbpGmB6Ql7YHOFZWVmFdSOmy
         78Qq6zp7+UM1S0/1/6jlqTYDGTT/xst3YdxTqFDS4oAzXFpnRxWfX13cPhM2VuSvSB62
         ml5WMURIRj5QY7feCoqmfxr2Qe8635D3dW5fPoTJD3zE44ZK4uOja31mybC4FgnNtJNg
         jBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728656893; x=1729261693;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KBZQ+2J87sYav7kebav8OyZqDFhTRod6WA3hieQG8as=;
        b=VIz3oY87qzZ4RPa8JKre4Z5Ocf6HmaosrdElkHzU5DK4TUw3U2PISybmOZ9ew4I/al
         CdbtXeZT0PSaNH1m0Lg/URxQFoelTplBEV6+RWIUR3jCDPzviTwcnWHE1MZgcDG3aVVN
         s0KTEb0UDfuoCFrR9US3L4VDx+RC3pJOcUPCae6a8QfgxjePTEvE4tnsHSNxAK1W5RpI
         cR32vARMxnN74tKtxxat2KFE6NjX6m7DDOMrTP01QLeQWLPMaeWeCbReOrOXLapeeKlh
         Skhbim1mJGsVw83yXgELXAw7mD5tnkyY8FtxBEE5XsR/Crga5hy+GvXS8ooJwSpo3Y4y
         xvxA==
X-Gm-Message-State: AOJu0YzEW2aVM9Oxi0ahIN/F1/ZPhX0bTd2MSoZO4xMbSGrm4OnjXo+X
	4MijsUCxAD9/3EHpXWY4l1x+VicEepsDUMc1hBKuG4kExCTFD5Tu7SGchDCc8w==
X-Google-Smtp-Source: AGHT+IFpARG86PhhEVo6F/Tdu/AM2ZhKscV8jOqr4HoNjHDI+Ipqgu3Uc83GD/Wl5uxNiWS2KH90lw==
X-Received: by 2002:a17:902:f54f:b0:20c:62af:a0f0 with SMTP id d9443c01a7336-20c80460de8mr127023015ad.7.1728656893153;
        Fri, 11 Oct 2024 07:28:13 -0700 (PDT)
Received: from [192.168.50.25] ([179.218.14.134])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8badc3bdsm24008755ad.61.2024.10.11.07.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 07:28:12 -0700 (PDT)
Message-ID: <d8e729ed-0bc8-4094-ad22-36c6312def25@mojatatu.com>
Date: Fri, 11 Oct 2024 11:28:07 -0300
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: David Wei <dw@davidwei.uk>, Mina Almasry <almasrymina@google.com>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <CAHS8izOv9cB60oUbxz_52BMGi7T4_u9rzTOCb23LGvZOX0QXqg@mail.gmail.com>
 <2b23d0ba-493b-48ba-beca-adc1d1e0be61@mojatatu.com>
 <2ff04413-9826-4696-9c8a-7a40cd886aae@davidwei.uk>
Content-Language: en-US, en-GB
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <2ff04413-9826-4696-9c8a-7a40cd886aae@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/10/2024 21:35, David Wei wrote:
> On 2024-10-09 11:21, Pedro Tammela wrote:
>> On 09/10/2024 13:55, Mina Almasry wrote:
>>> [...]
>>>
>>> If not, I would like to see a comparison between TCP RX zerocopy and
>>> this new io-uring zerocopy. For Google for example we use the TCP RX
>>> zerocopy, I would like to see perf numbers possibly motivating us to
>>> move to this new thing.
>>>
>>> [1] https://lwn.net/Articles/752046/
>>>
>>
>> Hi!
>>
>>  From my own testing, the TCP RX Zerocopy is quite heavy on the page unmapping side. Since the io_uring implementation is expected to be lighter (see patch 11), I would expect a simple comparison to show better numbers for io_uring.
> 
> Hi Pedro, I will add TCP_ZEROCOPY_RECEIVE to kperf and compare in the
> next patchset.
> 
>>
>> To be fair to the existing implementation, it would then be needed to be paired with some 'real' computation, but that varies a lot. As we presented in netdevconf this year, HW-GRO eventually was the best option for us (no app changes, etc...) but still a case by case decision.
> 
> Why is there a need to add some computation to the benchmarks? A
> benchmark is meant to be just that - a simple comparison that just looks
> at the overheads of the stack.

For the use case we saw, streaming lots of data with zc, the RX pages 
would linger for a reasonable time
in processing and the unmap cost amortized in the hotpath.
Which was not considered in our simple benchmark.

So for Mina's case, I guess the only way to know for sure if it's worth 
is to implement the io_uring approach and compare.

> Real workloads are complex, I don't see> this feature as a universal win in all cases, but very workload and
> userspace architecture dependent.

100% agree here, that's our experience so far as well.
Just wanted to share this sentiment in my previous email.

I personally believe the io_uring approach will encompass more use cases 
than the existing implementation.

> 
> As for HW-GRO, whynotboth.jpg?

For us the cost of changing the apps/services to accomodate rx zc was 
prohibitive for now,
which lead us to stick with HW-GRO.

IIRC, you mentioned in netdevconf Meta uses a library for RPC, but we 
don't have this luxury :/




