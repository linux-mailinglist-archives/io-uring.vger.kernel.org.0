Return-Path: <io-uring+bounces-3489-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 322E89970A8
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:09:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 60D451C223A8
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96DBB1FEFCC;
	Wed,  9 Oct 2024 15:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D+EKtPko"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC7B11E3785;
	Wed,  9 Oct 2024 15:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728488923; cv=none; b=ctXADWoc2Zwlt3L81Xj+w7sWM9pT8xnZ95OmAG0BUiSNf5Jfx9yqv+dmhuiZpvgaQXWvaiH0GX1mALyOaoZBUnmZhK4eu7b6quKrMbDrhj8zjloyoDTTlJY2VX+UNPT+ESjdhFCPGPGg2cAaotDC28AzFZL19MbP0GketzLab8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728488923; c=relaxed/simple;
	bh=6b8EWqfhSQ5fIsChz+WeIWfdrVd+3oueFzHlJM+yBKU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jNlqZu/L7yiqFhAKVfFiCExG9bSRHBoM5mBe7AbQTPNhKcOxkzWI6X6s60HCgu2UHa3Rsk+kSK304NBZeraq2XJVC62WMkSMSxzjOYZsbX1lvPJlWiYJCEXkfxTh2Azto2/KUe6hx7aSM01DPo7nFMoSgeeMAdL23cltWdoYcAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D+EKtPko; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5c883459b19so8073911a12.2;
        Wed, 09 Oct 2024 08:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728488920; x=1729093720; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YMu97ltrz8SFa/aUx13TOcNs42PL+PI3/Iq9gxA++E0=;
        b=D+EKtPko0p479XAmcOjz0pK5kAv0+uCvGY/9GzluxN900mxOp2Ny1sPifhF7dYSKlv
         hymAoSRX0fq5HzkzAIosRAPTOAtPC2abPGkAv/uZAxo7AVp7F2GTB4+d+J+I9Yw4OEMn
         dSPrHdF01o+MCptEQy3gFhJq2Tg5zOMcx4uS1cPPzgcoQvs3t+Cs/PCveYHylJcl5Si/
         mTWz11+r6eokhK2MH1VfYDIK4yTEFamQ71DARBYyegaG+KB4IFa1Por+IEFRd7pUIfse
         7k1ULg1N3yFR2VBUb5G3GY2ZujU8KE/y0PcHgzasRWjwp+v2YGR7zcewN2k0myuRfvqJ
         01qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728488920; x=1729093720;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YMu97ltrz8SFa/aUx13TOcNs42PL+PI3/Iq9gxA++E0=;
        b=haNU0LZ6z1YAf+klhlLviJfuFf1IJHruCwg+x/LAdLTr+4tc0V6+8CpLQd/dRt8Hf9
         T0BwFQ3dwf3M9YRW8J5LhEA5iU0ysMsZ/23jobZfbQYN64vPbdn8a95dKYZv6tgE9Pse
         sB9Uxx7x8UVMREVBbzSxqZIVkcUP1TU6k+vgpsQy0dtiI98UvItwyToiNHDifffSIHjV
         QhODPSteczYarMaungxWkGtPDIN85yiILeGRAMbtGJpZ0L812zvWgN0xDhdxQHu6IFu2
         B8hn2v9BjUbZ6lirye2+Q8I5k5AUDAAUrOUUGdRClGHh8lZE5b7cxtUg3AimRvg783dd
         1mGg==
X-Forwarded-Encrypted: i=1; AJvYcCUR2a2hs9DbK/nUhQkpAMGXcUzV+IYYEWJhcJOT79WEW1XwqGWDjlLv+bi3VKE80Y+9kVRop2Sh@vger.kernel.org, AJvYcCVChZM3r16JMHG9g+JL+GafStiCtiebEYaCnOp+i4thrQ4/erlMzbSsfKMBaEUxCsWBj1iNiLH93w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+RxOCpRI/lj6aK66ImC2qkFbllaQlGMgma4pPzLglfSYGyy72
	QlY1KP6zT8buHyhXs2pj2Sca1EeAIauLAOcHAKoCg5IM5t9iCtp0
X-Google-Smtp-Source: AGHT+IFXaIn07s5pLz/32OnTbCvKlGoEepJyxvzKBx+XTEVtyOUf6rE335wZoOy7eascGatrvIkE3g==
X-Received: by 2002:a05:6402:50d3:b0:5a2:68a2:ae57 with SMTP id 4fb4d7f45d1cf-5c91d6869e8mr1825715a12.31.1728488919823;
        Wed, 09 Oct 2024 08:48:39 -0700 (PDT)
Received: from [192.168.42.207] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5c8e05bd3a5sm5583803a12.41.2024.10.09.08.48.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 08:48:39 -0700 (PDT)
Message-ID: <b57dd3b9-b607-46ab-a2d0-98aedb2772f7@gmail.com>
Date: Wed, 9 Oct 2024 16:49:15 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: Jens Axboe <axboe@kernel.dk>, David Ahern <dsahern@kernel.org>,
 David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
 <2e475d9f-8d39-43f4-adc5-501897c951a8@kernel.dk>
 <93036b67-018a-44fb-8d12-7328c58be3c4@kernel.org>
 <2144827e-ad7e-4cea-8e38-05fb310a85f5@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <2144827e-ad7e-4cea-8e38-05fb310a85f5@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 16:43, Jens Axboe wrote:
> On 10/9/24 9:38 AM, David Ahern wrote:
>> On 10/9/24 9:27 AM, Jens Axboe wrote:
>>> On 10/7/24 4:15 PM, David Wei wrote:
>>>> ===========
>>>> Performance
>>>> ===========
>>>>
>>>> Test setup:
>>>> * AMD EPYC 9454
>>>> * Broadcom BCM957508 200G
>>>> * Kernel v6.11 base [2]
>>>> * liburing fork [3]
>>>> * kperf fork [4]
>>>> * 4K MTU
>>>> * Single TCP flow
>>>>
>>>> With application thread + net rx softirq pinned to _different_ cores:
>>>>
>>>> epoll
>>>> 82.2 Gbps
>>>>
>>>> io_uring
>>>> 116.2 Gbps (+41%)
>>>>
>>>> Pinned to _same_ core:
>>>>
>>>> epoll
>>>> 62.6 Gbps
>>>>
>>>> io_uring
>>>> 80.9 Gbps (+29%)
>>>
>>> I'll review the io_uring bits in detail, but I did take a quick look and
>>> overall it looks really nice.
>>>
>>> I decided to give this a spin, as I noticed that Broadcom now has a
>>> 230.x firmware release out that supports this. Hence no dependencies on
>>> that anymore, outside of some pain getting the fw updated. Here are my
>>> test setup details:
>>>
>>> Receiver:
>>> AMD EPYC 9754 (recei
>>> Broadcom P2100G
>>> -git + this series + the bnxt series referenced
>>>
>>> Sender:
>>> Intel(R) Xeon(R) Platinum 8458P
>>> Broadcom P2100G
>>> -git
>>>
>>> Test:
>>> kperf with David's patches to support io_uring zc. Eg single flow TCP,
>>> just testing bandwidth. A single cpu/thread being used on both the
>>> receiver and sender side.
>>>
>>> non-zc
>>> 60.9 Gbps
>>>
>>> io_uring + zc
>>> 97.1 Gbps
>>
>> so line rate? Did you look at whether there is cpu to spare? meaning it
>> will report higher speeds with a 200G setup?
> 
> Yep basically line rate, I get 97-98Gbps. I originally used a slower box
> as the sender, but then you're capped on the non-zc sender being too
> slow. The intel box does better, but it's still basically maxing out the
> sender at this point. So yeah, with a faster (or more efficient sender),
> I have no doubts this will go much higher per thread, if the link bw was
> there. When I looked at CPU usage for the receiver, the thread itself is
> using ~30% CPU. And then there's some softirq/irq time outside of that,
> but that should ammortize with higher bps rates too I'd expect.
> 
> My nic does have 2 100G ports, so might warrant a bit more testing...
If you haven't done it already, I'd also pin softirq processing to
the same CPU as the app so we measure the full stack. kperf has an
option IIRC.

-- 
Pavel Begunkov

