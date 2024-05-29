Return-Path: <io-uring+bounces-1988-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A93E8D2A9E
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 04:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3B8F28BC33
	for <lists+io-uring@lfdr.de>; Wed, 29 May 2024 02:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8824126AF3;
	Wed, 29 May 2024 02:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Veqgv97x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B321C22324
	for <io-uring@vger.kernel.org>; Wed, 29 May 2024 02:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716948514; cv=none; b=uwpUG40sGFQsmtGs4Ynk66rCv/7mF69OvzQ8FVbEd5xzI+0lxui1tMRkIz3XiSAAqlEMQWmqVWapoBEhlPS7RqvUc+N6MSTeXQNURH8XX6XhO52TVFKtlHJec0sP2iyqmxzyr94JYwM7nWUBXoiWUdCCLIl1XWRWKnymQWxn728=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716948514; c=relaxed/simple;
	bh=LLoMpH87JqRvLlzqYPKlyFw1scL/zH94dfbC5hwEBm4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=fCUgZvbWHBDzvzrvOXCC/SEbO64O7pEd+gkRzEpp1tP7ldCw52wHcQ+gxZejOs5W4zijkQFNvKPAQeTFrzQNiagjmDdZh1qGRqQOPaF8WYINGPALQbPheVNY0csRiYfOqJrdtG2PHSbJqFzwbkn03yhbCjy/Qrgp6LvcriiD+I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Veqgv97x; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-420180b5922so18397255e9.2
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 19:08:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716948511; x=1717553311; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pXeRolhEMYQGyFLhhACwrXclQ+H5xVryCSsk6H/uRXk=;
        b=Veqgv97xiYwdH61MFwNf44jj4cYm4hDwfCLj749LnUnIfahZ3/TOBxUwAvrgZdqZ3B
         vCH4R9EKF6vu3NzH/QYUz2qBHy7mj13DLPOHUMsK9GEibxKt8rqKGCn7cOqgKVWPORJ/
         po1T+BP2M28Uas/t1CUWd8lF7ssBYb/rZr5l1tkgW0dUO2b47+kja8SNB8eKdwvjtYBe
         i3UjLP5+BYvGWdtiTnfvszncl269/I82q8PtHtMwS3uoGBcETwRksII6v66siUXo94xR
         M7mlckQbKdRGfeapGT3PDmv94lfZlN5G0DTp5TNWdU6EICpicitq5VamRIlnyRIOf4xf
         a8OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716948511; x=1717553311;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pXeRolhEMYQGyFLhhACwrXclQ+H5xVryCSsk6H/uRXk=;
        b=R3lwomJ5BPYFkvRMASYvqZo6bdPnoNc4mc158SCOfD8eA+Rra7XOY2t5IAsBpkm+iX
         mjoa6FQ8msJsxZ3tWNcT1Pt4JE0cays8ecEZcL91K98AQs+PZejpse/q8o+ruL+QG4wD
         PNunjWHAdy5byyIq3XnQu00dpJUWG5j66ZJ9DW4V/xwhfYByehVhAr7HnWe7F20aPuCC
         T/lw0vo2hIrWcpU/2XDZ4nHhztqtnJerVWHuTHvL/okgWcwL+hrv6GYa0j+yfGGDX++x
         Wmn4acuh+U40kzNUQOnyeOi7d+9HxGtt2tjTRQpTjUAjB2qUywWZ2G3aWDtTADVtq3vX
         5hyw==
X-Forwarded-Encrypted: i=1; AJvYcCW7T0wDCQFWV0IT/b7MkrS6p1v73HMQ7sNUYnUPBjO4U9WqpnmY9NfeyrmOMs/eGBpZsA7zQoziIcnw1yrxBxz3PeDL77r+OLY=
X-Gm-Message-State: AOJu0YzN/c3tZ/EzUHKB10gG4UIR0sAKTTW5AoYr1D132w3stFFIXXLv
	zkzuPZ0qK7jum9l5rpXvIb80HNChQ1xZ7Icc2ftdVSK05DmyqNbq
X-Google-Smtp-Source: AGHT+IFUwAUcZ7yj0LF5Y6jN1k8ExlOFxJ29eLJz2qRq09EjTbguf5DdYtwOmnHjfqSb+BKDjDGpOw==
X-Received: by 2002:a05:600c:4450:b0:41a:47db:290c with SMTP id 5b1f17b1804b1-42108a3a5b5mr134403015e9.5.1716948510831;
        Tue, 28 May 2024 19:08:30 -0700 (PDT)
Received: from [192.168.42.154] ([185.69.144.120])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-421089ae96bsm162024685e9.35.2024.05.28.19.08.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 19:08:30 -0700 (PDT)
Message-ID: <377bad85-032d-4906-9142-d7be5cae9dcb@gmail.com>
Date: Wed, 29 May 2024 03:08:33 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
 <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
 <d3d8363e-280d-41f4-94ac-8b7bb0ce16a9@gmail.com>
 <35a9b48d-7269-417b-a312-6a9d637cfd72@kernel.dk>
 <d86d292a-4ef2-41a3-8f54-c3a1ff0caad7@kernel.dk>
 <6ceed652-a81a-485f-8e6e-d653932bb86d@kernel.dk>
 <18a96f04-bb30-4bd8-82ca-e72f1c954dac@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <18a96f04-bb30-4bd8-82ca-e72f1c954dac@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/29/24 02:35, Jens Axboe wrote:
> On 5/28/24 5:04 PM, Jens Axboe wrote:
>> On 5/28/24 12:31 PM, Jens Axboe wrote:
>>> I suspect a bug in the previous patches, because this is what the
>>> forward port looks like. First, for reference, the current results:
>>
>> Got it sorted, and pinned sender and receiver on CPUs to avoid the
>> variation. It looks like this with the task_work approach that I sent
>> out as v1:
>>
>> Latencies for: Sender
>>      percentiles (nsec):
>>       |  1.0000th=[ 2160],  5.0000th=[ 2672], 10.0000th=[ 2768],
>>       | 20.0000th=[ 3568], 30.0000th=[ 3568], 40.0000th=[ 3600],
>>       | 50.0000th=[ 3600], 60.0000th=[ 3600], 70.0000th=[ 3632],
>>       | 80.0000th=[ 3632], 90.0000th=[ 3664], 95.0000th=[ 3696],
>>       | 99.0000th=[ 4832], 99.5000th=[15168], 99.9000th=[16192],
>>       | 99.9500th=[16320], 99.9900th=[18304]
>> Latencies for: Receiver
>>      percentiles (nsec):
>>       |  1.0000th=[ 1528],  5.0000th=[ 1576], 10.0000th=[ 1656],
>>       | 20.0000th=[ 2040], 30.0000th=[ 2064], 40.0000th=[ 2064],
>>       | 50.0000th=[ 2064], 60.0000th=[ 2064], 70.0000th=[ 2096],
>>       | 80.0000th=[ 2096], 90.0000th=[ 2128], 95.0000th=[ 2160],
>>       | 99.0000th=[ 3472], 99.5000th=[14784], 99.9000th=[15168],
>>       | 99.9500th=[15424], 99.9900th=[17280]
>>
>> and here's the exact same test run on the current patches:
>>
>> Latencies for: Sender
>>      percentiles (nsec):
>>       |  1.0000th=[  362],  5.0000th=[  362], 10.0000th=[  370],
>>       | 20.0000th=[  370], 30.0000th=[  370], 40.0000th=[  370],
>>       | 50.0000th=[  374], 60.0000th=[  382], 70.0000th=[  382],
>>       | 80.0000th=[  382], 90.0000th=[  382], 95.0000th=[  390],
>>       | 99.0000th=[  402], 99.5000th=[  430], 99.9000th=[  900],
>>       | 99.9500th=[  972], 99.9900th=[ 1432]
>> Latencies for: Receiver
>>      percentiles (nsec):
>>       |  1.0000th=[ 1528],  5.0000th=[ 1544], 10.0000th=[ 1560],
>>       | 20.0000th=[ 1576], 30.0000th=[ 1592], 40.0000th=[ 1592],
>>       | 50.0000th=[ 1592], 60.0000th=[ 1608], 70.0000th=[ 1608],
>>       | 80.0000th=[ 1640], 90.0000th=[ 1672], 95.0000th=[ 1688],
>>       | 99.0000th=[ 1848], 99.5000th=[ 2128], 99.9000th=[14272],
>>       | 99.9500th=[14784], 99.9900th=[73216]
>>
>> I'll try and augment the test app to do proper rated submissions, so I
>> can ramp up the rates a bit and see what happens.
> 
> And the final one, with the rated sends sorted out. One key observation
> is that v1 trails the current edition, it just can't keep up as the rate
> is increased. If we cap the rate at at what should be 33K messages per
> second, v1 gets ~28K messages and has the following latency profile (for
> a 3 second run)

Do you see where the receiver latency comes from? The wakeups are
quite similar in nature, assuming it's all wait(nr=1) and CPUs
are not 100% consumed. The hop back spoils scheduling timing?


> Latencies for: Receiver (msg=83863)
>      percentiles (nsec):
>       |  1.0000th=[  1208],  5.0000th=[  1336], 10.0000th=[  1400],
>       | 20.0000th=[  1768], 30.0000th=[  1912], 40.0000th=[  1976],
>       | 50.0000th=[  2040], 60.0000th=[  2160], 70.0000th=[  2256],
>       | 80.0000th=[  2480], 90.0000th=[  2736], 95.0000th=[  3024],
>       | 99.0000th=[  4080], 99.5000th=[  4896], 99.9000th=[  9664],
>       | 99.9500th=[ 17024], 99.9900th=[218112]
> Latencies for: Sender (msg=83863)
>      percentiles (nsec):
>       |  1.0000th=[  1928],  5.0000th=[  2064], 10.0000th=[  2160],
>       | 20.0000th=[  2608], 30.0000th=[  2672], 40.0000th=[  2736],
>       | 50.0000th=[  2864], 60.0000th=[  2960], 70.0000th=[  3152],
>       | 80.0000th=[  3408], 90.0000th=[  4128], 95.0000th=[  4576],
>       | 99.0000th=[  5920], 99.5000th=[  6752], 99.9000th=[ 13376],
>       | 99.9500th=[ 22912], 99.9900th=[261120]
> 
> and the current edition does:
> 
> Latencies for: Sender (msg=94488)
>      percentiles (nsec):
>       |  1.0000th=[  181],  5.0000th=[  191], 10.0000th=[  201],
>       | 20.0000th=[  215], 30.0000th=[  225], 40.0000th=[  235],
>       | 50.0000th=[  262], 60.0000th=[  306], 70.0000th=[  430],
>       | 80.0000th=[ 1004], 90.0000th=[ 2480], 95.0000th=[ 3632],
>       | 99.0000th=[ 8096], 99.5000th=[12352], 99.9000th=[18048],
>       | 99.9500th=[19584], 99.9900th=[23680]
> Latencies for: Receiver (msg=94488)
>      percentiles (nsec):
>       |  1.0000th=[  342],  5.0000th=[  398], 10.0000th=[  482],
>       | 20.0000th=[  652], 30.0000th=[  812], 40.0000th=[  972],
>       | 50.0000th=[ 1240], 60.0000th=[ 1640], 70.0000th=[ 1944],
>       | 80.0000th=[ 2448], 90.0000th=[ 3248], 95.0000th=[ 5216],
>       | 99.0000th=[10304], 99.5000th=[12352], 99.9000th=[18048],
>       | 99.9500th=[19840], 99.9900th=[23168]
> 
> If we cap it where v1 keeps up, at 13K messages per second, v1 does:
> 
> Latencies for: Receiver (msg=38820)
>      percentiles (nsec):
>       |  1.0000th=[ 1160],  5.0000th=[ 1256], 10.0000th=[ 1352],
>       | 20.0000th=[ 1688], 30.0000th=[ 1928], 40.0000th=[ 1976],
>       | 50.0000th=[ 2064], 60.0000th=[ 2384], 70.0000th=[ 2480],
>       | 80.0000th=[ 2768], 90.0000th=[ 3280], 95.0000th=[ 3472],
>       | 99.0000th=[ 4192], 99.5000th=[ 4512], 99.9000th=[ 6624],
>       | 99.9500th=[ 8768], 99.9900th=[14272]
> Latencies for: Sender (msg=38820)
>      percentiles (nsec):
>       |  1.0000th=[ 1848],  5.0000th=[ 1928], 10.0000th=[ 2040],
>       | 20.0000th=[ 2608], 30.0000th=[ 2640], 40.0000th=[ 2736],
>       | 50.0000th=[ 3024], 60.0000th=[ 3120], 70.0000th=[ 3376],
>       | 80.0000th=[ 3824], 90.0000th=[ 4512], 95.0000th=[ 4768],
>       | 99.0000th=[ 5536], 99.5000th=[ 6048], 99.9000th=[ 9024],
>       | 99.9500th=[10304], 99.9900th=[23424]
> 
> and v2 does:
> 
> Latencies for: Sender (msg=39005)
>      percentiles (nsec):
>       |  1.0000th=[  191],  5.0000th=[  211], 10.0000th=[  262],
>       | 20.0000th=[  342], 30.0000th=[  382], 40.0000th=[  402],
>       | 50.0000th=[  450], 60.0000th=[  532], 70.0000th=[ 1080],
>       | 80.0000th=[ 1848], 90.0000th=[ 4768], 95.0000th=[10944],
>       | 99.0000th=[16512], 99.5000th=[18304], 99.9000th=[22400],
>       | 99.9500th=[26496], 99.9900th=[41728]
> Latencies for: Receiver (msg=39005)
>      percentiles (nsec):
>       |  1.0000th=[  410],  5.0000th=[  604], 10.0000th=[  700],
>       | 20.0000th=[  900], 30.0000th=[ 1128], 40.0000th=[ 1320],
>       | 50.0000th=[ 1672], 60.0000th=[ 2256], 70.0000th=[ 2736],
>       | 80.0000th=[ 3760], 90.0000th=[ 5408], 95.0000th=[11072],
>       | 99.0000th=[18304], 99.5000th=[20096], 99.9000th=[24704],
>       | 99.9500th=[27520], 99.9900th=[35584]
> 

-- 
Pavel Begunkov

