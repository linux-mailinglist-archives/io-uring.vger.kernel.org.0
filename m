Return-Path: <io-uring+bounces-3488-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 22124997083
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:07:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF4051F21633
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:07:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A34F61FB3F9;
	Wed,  9 Oct 2024 15:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="o3ioEtHr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2921E04BC
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 15:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728488640; cv=none; b=T7cJ9d68uUwwsu5KKRC7fADktW9ThQPpAh85p0qppSfHFP74a3pF+1GqnVQYN1yjuB6LgeYfO7GBKsdqiTBxDNr/RycspDYWONmj0f8ZIShyrpFVHBRMYrG1sKgzqzFnQYmIzbbNBuc4Q5JA4ZZCxwMB6Cki2ImHVCTpJar6oqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728488640; c=relaxed/simple;
	bh=+dPTyHZ7xWPO2OXlyf8gYxdODQHxdbuxkfl3bmskjjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bVvgI6TfEcM0aZZMjFpHNKfM8hmKSKNMVIuYkiTTHWcq9NKC3loDNSjUcY3h7EJwqEBRcib2kRylpxL/AGmpa+THWXIITW+KPztxG2gZcNtqzdheZt1k6e8d7LtjCmTwk0BuRZvdbwWVRl3COYbFrxGMQdJmd0KV2PYeHmNsAU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=o3ioEtHr; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-82cf3286261so260882939f.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 08:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728488637; x=1729093437; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+pWT4XdkGymjBMFALAcO1+UWkw4U1Rus/WqwCMqO8uY=;
        b=o3ioEtHrZ80bXll9DeVFMaXqV8GXaQ21WO5+IKEkoTxGYgj2kEOJsZcEnV2zL7fOnX
         iFmyS/zRam4uau7kngJMW9INXvh6tYbA4mDGHlkSCDEexcismvARL4I+sRsJd1LYhrZz
         GrbrsWXxTKuz6gbEwLMcNe1l2fNHLAIs3ay51v6Sz9dAGB5A+k9cgbY3M5o2a7wFA8qf
         2WM6Objwrm5UM4f9HDyP4jsfMpCHx7JKLWR+2yBcOpPO6g8151UzgXbb+ulKmcurRfd2
         hQtlyHYYYeCFBkpySI7dsr1xclHilhOQaiM6vw/5vHZG3bRVn9yvugouof9DL8wyIz6/
         V0lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728488637; x=1729093437;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+pWT4XdkGymjBMFALAcO1+UWkw4U1Rus/WqwCMqO8uY=;
        b=Zo3/yyjOkdRtoi7BAfBAIc9LXtYl+buVC6Ycya62CDtogAKBNBzpQI7h+i7BULVrhe
         72jRLDA5lWk+D3zSrTBXtB1qV9C9yB2yI9B3Oo1hSuBDpYlowTuKiTL2FHCcwgXIPz94
         bRT+htacxLtd98zastthLpQyeAOShIfpNXUJld/qT3JXqI60DPRiLzHcd8E6PQuoaxXw
         1ky6k7iX1KyYcmXHPeBCRCi+3OoR8C1DwpiqQiqw8iK11J+UrGLIv8DIF8z0o+0fljan
         4N5LqT7Ar1+vNE5fT2W3ZrHVixeDGXKAssiHNw8P4T3QQnguuZrAB0O3lkCyAVdQGTk1
         QFkA==
X-Forwarded-Encrypted: i=1; AJvYcCXiOrIXA7MP0ew/Jc2ms9Ad/xx6jRWU5VkWWPIdYjub/ufTiTKG3EiMNnwQQYfF2t/pkacSy18dww==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1eVcxXOayF+WpLezBNlADJejH9Wht23QlL4s5jjyxEUCEOA4i
	vGcIPVdVG12/LKqx99qP0p/b8jdJ0WU0oo8mMu3LfLXAv/Qj7tzgV9eBNfcrNV0=
X-Google-Smtp-Source: AGHT+IErIIr4wPlQFrZzsnhru5PNlkPfP6bOKBipcqNGKjvMFCSINtKRFUCiLKezGy7OcuyCJnRrlA==
X-Received: by 2002:a05:6602:2c0a:b0:82d:9b0:ecb7 with SMTP id ca18e2360f4ac-8353d47c5e9mr340456339f.3.1728488637187;
        Wed, 09 Oct 2024 08:43:57 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db86b66c6csm1418933173.44.2024.10.09.08.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 08:43:56 -0700 (PDT)
Message-ID: <2144827e-ad7e-4cea-8e38-05fb310a85f5@kernel.dk>
Date: Wed, 9 Oct 2024 09:43:55 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: David Ahern <dsahern@kernel.org>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <2e475d9f-8d39-43f4-adc5-501897c951a8@kernel.dk>
 <93036b67-018a-44fb-8d12-7328c58be3c4@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <93036b67-018a-44fb-8d12-7328c58be3c4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 9:38 AM, David Ahern wrote:
> On 10/9/24 9:27 AM, Jens Axboe wrote:
>> On 10/7/24 4:15 PM, David Wei wrote:
>>> ===========
>>> Performance
>>> ===========
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
>>> epoll
>>> 82.2 Gbps
>>>
>>> io_uring
>>> 116.2 Gbps (+41%)
>>>
>>> Pinned to _same_ core:
>>>
>>> epoll
>>> 62.6 Gbps
>>>
>>> io_uring
>>> 80.9 Gbps (+29%)
>>
>> I'll review the io_uring bits in detail, but I did take a quick look and
>> overall it looks really nice.
>>
>> I decided to give this a spin, as I noticed that Broadcom now has a
>> 230.x firmware release out that supports this. Hence no dependencies on
>> that anymore, outside of some pain getting the fw updated. Here are my
>> test setup details:
>>
>> Receiver:
>> AMD EPYC 9754 (recei
>> Broadcom P2100G
>> -git + this series + the bnxt series referenced
>>
>> Sender:
>> Intel(R) Xeon(R) Platinum 8458P
>> Broadcom P2100G
>> -git
>>
>> Test:
>> kperf with David's patches to support io_uring zc. Eg single flow TCP,
>> just testing bandwidth. A single cpu/thread being used on both the
>> receiver and sender side.
>>
>> non-zc
>> 60.9 Gbps
>>
>> io_uring + zc
>> 97.1 Gbps
> 
> so line rate? Did you look at whether there is cpu to spare? meaning it
> will report higher speeds with a 200G setup?

Yep basically line rate, I get 97-98Gbps. I originally used a slower box
as the sender, but then you're capped on the non-zc sender being too
slow. The intel box does better, but it's still basically maxing out the
sender at this point. So yeah, with a faster (or more efficient sender),
I have no doubts this will go much higher per thread, if the link bw was
there. When I looked at CPU usage for the receiver, the thread itself is
using ~30% CPU. And then there's some softirq/irq time outside of that,
but that should ammortize with higher bps rates too I'd expect.

My nic does have 2 100G ports, so might warrant a bit more testing...

-- 
Jens Axboe

