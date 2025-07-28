Return-Path: <io-uring+bounces-8837-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CCD7B141C9
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 20:17:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59A053A4722
	for <lists+io-uring@lfdr.de>; Mon, 28 Jul 2025 18:16:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5CCC221554;
	Mon, 28 Jul 2025 18:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cw4QNghP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6862F56;
	Mon, 28 Jul 2025 18:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753726640; cv=none; b=DVfyFQWIqPhbMHmIk3Yod/CmX6bCX9asSDAY/OkHgJRpWKnggWqwlqNP2uKY3NFiMIdcWqHbdUeR5uXWiKMCrtVNblUplsYp4OySL6K377bo3SfE3zhPJxLq2/FqYi1MYXWJM030QSbnnCWk8yMqgPMmaRxjUyO37nNAeK193m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753726640; c=relaxed/simple;
	bh=TRlcp29tKY28nIj+hTT79+v9Dl8LDFo3Vdxp9T4j89s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OMOjm+l/NF9Jr+ocddqqG7u9SKDNiV5q5fttBMlmjp2eG+39PHEcuCWBuiPJh30N2HHy8E/Xn5R4mpbYsbOWStqve23Fqc20cWrX4VntDlhg1p8mTncNzuhafJSEXEcFGupC6H9T564heXVggRaGTR0fIJ/9v95OteW6IOTUQH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cw4QNghP; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-615398dc162so2416002a12.3;
        Mon, 28 Jul 2025 11:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753726636; x=1754331436; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q6am9svNPMFaFOvHK6tcGYyPzKRHFdk8/gHXe9Iltns=;
        b=Cw4QNghP0EgV8FvOjcSL0IxjOSpQRgWOUdjvoxh3/ss7VrhSl2aEkz8aMVnBR1Hqhb
         WletPtWBTJOLPhmPtCnemNVaBpWCTk0ekDsYivkoPUf2gI9r4C8x8D6llof1gKYnABiZ
         ht3q4YheozdkfjxOWsJo/Qz31RL4HPvod5iHF7Dv9Hmh1az4De65lD3TujIDmxFMN+OI
         pNunw1lBsot+BTYdqNTjmOD7yRCWAx+GQP6YvbS4PcAAt/8iiaSq1OBqpu+L8vDqQ//2
         mmneAWvrtDMOEIcBnZSnU/TFwf1haVgX1yDY3xMaBbm0FjsG+ZUOpsf5GDvYG3k62nyE
         YLyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753726636; x=1754331436;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q6am9svNPMFaFOvHK6tcGYyPzKRHFdk8/gHXe9Iltns=;
        b=eHsNIiZbQsKnydSgynXgHxOU6KQm4t05uPfaQi31H4huth5iVfUVwxZhmPr5tXE9CK
         4A0FE/GQZfqKsSBtSWJarDT6AUCychEV/N8AHI+2yslqA42Zy0XbTN5O6S4ifSCqpJSK
         fMGqMADSQc7d5NigNfDiQrOUgxYFcBkIfZO9zItL6VGSzELSZPm/GNtQncjfS6cXvt4J
         k8AxtfrJiHtjNbPhEPUwyY93vVJKLZUFo6qRvdsV3JT//DAwsW6VVX6xhnM2IDrRwPCr
         m4SgtDjNYlSxjZBbtLipe2sDNNdZxTA72Y4EdVmMTJwv+Zsrnz0lqctG0GYv3Qba6p4A
         4yew==
X-Forwarded-Encrypted: i=1; AJvYcCUseqzc9cF9zOVRHfJrixNofNBobX7B1KeZyb/KBy3kgW/rTCXLbsd36hHBBhI5QZjM+0uXmXphAQ==@vger.kernel.org, AJvYcCVDNG6LSLIzbgkRFzjw9QnppFnMdLCiqMSvB8n5vGor/ezqKoMcCLBptmjsGwQM8IAlh9WfiseZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcz7lR/imMew9/gw2xCGqvAoXr8XHF1mqTno+rW7HdJ21NUgfX
	/2R7kmjpi6KjPbNwqBsq7U3pIosnPHA+Pzz09ok19jLwJma2O7MvBAaZ
X-Gm-Gg: ASbGnctPmRtnHHZ/ieGfXMrXZqaAYfHxX2isZpKRfDxWHUc0dFJlTl17jaY6ldMS8pp
	yGLB57RcrwynSznAjngjlnqTlRPGuEM/PVHESKSkp6bLz4e7D/luUxF6rvwL5apCg2wEjJwNZtw
	ivgSEQlqho0W430YXxtVJVwIQVoej7VGtgs0ZrCZ6r2C4O0yzKbuYaLmHP91z47b7PcLajI3TiU
	4tONgp+uTgI9gF+Kf5QAsiEtPkNliyBx19/l3z0itL7qMEI1wxFbUnTD5YgekJYbhZJ7V+qnyPz
	WsgTSEsUFzP1K9KMYHt38Dq/XqPgkHnAZbwQGX+iRoRdIcCfjDHfeDYl7BNEyAjthemXjCELwOC
	nizqfuC9kp80BurRG24dFZpC+GqQ6O7U=
X-Google-Smtp-Source: AGHT+IEDgsU92hiiVLNCDKRPZu/vPotdNBmh6IX3+DhxcI8KD3CHZON8pXYt5ynzn9LnskyN/PnyjA==
X-Received: by 2002:a05:6402:2106:b0:615:63b8:dc9a with SMTP id 4fb4d7f45d1cf-61563b8ffbemr586618a12.14.1753726635506;
        Mon, 28 Jul 2025 11:17:15 -0700 (PDT)
Received: from [192.168.8.100] ([185.69.144.164])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615673975fcsm23356a12.65.2025.07.28.11.17.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Jul 2025 11:17:14 -0700 (PDT)
Message-ID: <df74d6e8-41cc-4840-8aca-ad7e57d387ce@gmail.com>
Date: Mon, 28 Jul 2025 19:18:36 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 00/22] Large rx buffer support for zcrx
To: Stanislav Fomichev <stfomichev@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Willem de Bruijn <willemb@google.com>, Paolo Abeni <pabeni@redhat.com>,
 andrew+netdev@lunn.ch, horms@kernel.org, davem@davemloft.net,
 sdf@fomichev.me, almasrymina@google.com, dw@davidwei.uk,
 michael.chan@broadcom.com, dtatulea@nvidia.com, ap420073@gmail.com
References: <cover.1753694913.git.asml.silence@gmail.com>
 <aIevvoYj7BcURD3F@mini-arch>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aIevvoYj7BcURD3F@mini-arch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/28/25 18:13, Stanislav Fomichev wrote:
> On 07/28, Pavel Begunkov wrote:
>> This series implements large rx buffer support for io_uring/zcrx on
>> top of Jakub's queue configuration changes, but it can also be used
>> by other memory providers. Large rx buffers can be drastically
>> beneficial with high-end hw-gro enabled cards that can coalesce traffic
>> into larger pages, reducing the number of frags traversing the network
>> stack and resuling in larger contiguous chunks of data for the
>> userspace. Benchamrks showed up to ~30% improvement in CPU util.
>>
>> For example, for 200Gbit broadcom NIC, 4K vs 32K buffers, and napi and
>> userspace pinned to the same CPU:
>>
>> packets=23987040 (MB=2745098), rps=199559 (MB/s=22837)
>> CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
>>    0    1.53    0.00   27.78    2.72    1.31   66.45    0.22
>> packets=24078368 (MB=2755550), rps=200319 (MB/s=22924)
>> CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
>>    0    0.69    0.00    8.26   31.65    1.83   57.00    0.57
>>
>> And for napi and userspace on different CPUs:
>>
>> packets=10725082 (MB=1227388), rps=198285 (MB/s=22692)
>> CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
>>    0    0.10    0.00    0.50    0.00    0.50   74.50    24.40
>>    1    4.51    0.00   44.33   47.22    2.08    1.85    0.00
>> packets=14026235 (MB=1605175), rps=198388 (MB/s=22703)
>> CPU    %usr   %nice    %sys %iowait    %irq   %soft   %idle
>>    0    0.10    0.00    0.70    0.00    1.00   43.78   54.42
>>    1    1.09    0.00   31.95   62.91    1.42    2.63    0.00
>>
>> Patch 19 allows to pass queue config from a memory provider. The
>> zcrx changes are contained in a single patch as I already queued
>> most of work making it size agnostic into my zcrx branch. The
>> uAPI is simple and imperative, it'll use the exact value (if)
>> specified by the user. In the future we might extend it to
>> "choose the best size in a given range".
>>
>> The rest (first 20) patches are from Jakub's series implementing
>> per queue configuration. Quoting Jakub:
>>
>> "... The direct motivation for the series is that zero-copy Rx queues would
>> like to use larger Rx buffers. Most modern high-speed NICs support HW-GRO,
>> and can coalesce payloads into pages much larger than than the MTU.
>> Enabling larger buffers globally is a bit precarious as it exposes us
>> to potentially very inefficient memory use. Also allocating large
>> buffers may not be easy or cheap under load. Zero-copy queues service
>> only select traffic and have pre-allocated memory so the concerns don't
>> apply as much.
>>
>> The per-queue config has to address 3 problems:
>> - user API
>> - driver API
>> - memory provider API
>>
>> For user API the main question is whether we expose the config via
>> ethtool or netdev nl. I picked the latter - via queue GET/SET, rather
>> than extending the ethtool RINGS_GET API. I worry slightly that queue
>> GET/SET will turn in a monster like SETLINK. OTOH the only per-queue
>> settings we have in ethtool which are not going via RINGS_SET is
>> IRQ coalescing.
>>
>> My goal for the driver API was to avoid complexity in the drivers.
>> The queue management API has gained two ops, responsible for preparing
>> configuration for a given queue, and validating whether the config
>> is supported. The validating is used both for NIC-wide and per-queue
>> changes. Queue alloc/start ops have a new "config" argument which
>> contains the current config for a given queue (we use queue restart
>> to apply per-queue settings). Outside of queue reset paths drivers
>> can call netdev_queue_config() which returns the config for an arbitrary
>> queue. Long story short I anticipate it to be used during ndo_open.
>>
>> In the core I extended struct netdev_config with per queue settings.
>> All in all this isn't too far from what was there in my "queue API
>> prototype" a few years ago ..."
> 
> Supporting big buffers is the right direction, but I have the same
> feedback: 

Let me actually check the feedback for the queue config RFC...

it would be nice to fit a cohesive story for the devmem as well.

Only the last patch is zcrx specific, the rest is agnostic,
devmem can absolutely reuse that. I don't think there are any
issues wiring up devmem?

> We should also aim for another use-case where we allocate page pool
> chunks from the huge page(s), 

Separate huge page pool is a bit beyond the scope of this series.

this should push the perf even more.

And not sure about "even more" is from, you can already
register a huge page with zcrx, and this will allow to chunk
them to 32K or so for hardware. Is it in terms of applicability
or you have some perf optimisation ideas?

> We need some way to express these things from the UAPI point of view.

Can you elaborate?

> Flipping the rx-buf-len value seems too fragile - there needs to be
> something to request 32K chunks only for devmem case, not for the (default)
> CPU memory. And the queues should go back to default 4K pages when the dmabuf
> is detached from the queue.

That's what the per-queue config is solving. It's not default, zcrx
configures it only for the specific queue it allocated, and the value
is cleared on restart in netdev_rx_queue_restart(), if not even too
aggressively. Maybe I should just stash it into mp_params to make
sure it's not cleared if a provider is still attached on a spurious
restart.

-- 
Pavel Begunkov


