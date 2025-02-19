Return-Path: <io-uring+bounces-6556-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E5A74A3BDD0
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 13:10:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B47293A4ADB
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 12:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 667691C5F1B;
	Wed, 19 Feb 2025 12:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MZxdlBkd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9A31BEF75;
	Wed, 19 Feb 2025 12:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739967041; cv=none; b=AAz/uBcZ765tpgs/M96IQWc43/EEb4gbt94NL0q6/NNGmDYyN9kIMe99Xsuh/N0oYw0srPIS6TY7txd0wuRgvuaI0mxX5A1d1l1eaCikFb+ET1bou7hIzt7T194I1RfDdGF2k9R77o0COZfyqpZrCYpxEAuB88z+rdlAJLNBaR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739967041; c=relaxed/simple;
	bh=uelRPMspazvWIvQv03QR03hG1Wv8PBMAk9WL0BITQwY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JvdcqVcTDX3OhU3DRTqRJCqgkqH/9AuXJjy5BsndD0jhCh2NbpRH+k34nvcDIZ5woDBeGQeKrL1RRjw0jbm3hSHEzeMQ2ApxPjWZiOtfl8qV1Y+Od74NuscSSgP0T1rJrBuVltwIoSXt0PKSDd62XNB8dwynuA/X03n2By/auLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MZxdlBkd; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e04cb346eeso6846783a12.2;
        Wed, 19 Feb 2025 04:10:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739967038; x=1740571838; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qh3oxSLPnJCNWdMJZQBRKy79/s+ayH5Q/PT2U2DDC98=;
        b=MZxdlBkdDC6kMtD/IFp7ITGvCDN3GgHei9B3xfzAkAh2WdFmqMDpyqu4zOivDkQv1s
         WjOsedKJWNU4hBZL0ggVs2rRDGGSLpXBHsfBKj2aadgyQ5kjGoIp+x6mfnqlSuY6umt6
         gwtfa4xCorcS2uE9MDboX25EgAWG4eNLfDQBaQT1A4lYbT3Q3bpMJfpdo8ibdxij2z1r
         6DhVfVk+KGwq2CtX9aBCevFn4+hyLXpRVmvEm+9bStdiRC3ET7fVqWG5dL1xTBAJIr0q
         99Rwq5F7xAyLk++kk0HadnEqpIM83KUfg2UNbiu+dDw56Ak7TICyA4n5dvY2FceGPVOH
         jK2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739967038; x=1740571838;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qh3oxSLPnJCNWdMJZQBRKy79/s+ayH5Q/PT2U2DDC98=;
        b=P/kleY2G6ymjaEsYSKNiQ64oKC4Qtapag87o0teyeWdmUOL6uuc6N85wdxBMPb3cNU
         wbmSG5IlEW/sQK+HNB/mQ3KCEYlsclRr8RIcOnZL/x+Gj8D2bE0HRAOIuf5U7hNhaWmV
         bGjHniL5FMfnmNsWBQNe7c5TZwe9Y9MRLLRXHlD9JtYuMj+t5QjBEqz/rWK5yuAu6AXM
         gQXF44vGH3ChgAFyr1ZvBDrrCIXL7Msu2LF7mhEke8QzrezlWW7ZE+pYDw/2mLM1QkAy
         K6vzYCtXKR9Jm8f5ojxQ6s8CMkiF9UBzMPZk/U0rUMTHOQgQoL+BeEpJnxHYV7xvcutf
         eOfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQV/JC6Y0LOMfRur13kSttn9bRf5XX2XbpfR/UKyLCqx8ze0iO2XRsCxMz43z5nd4zNvVqm+/7@vger.kernel.org, AJvYcCVlHDlnJzHkg9Widh00f5VTf2lqW+JCF2rIR6sR9hb7f+u5nyyhEcmJNpQIpp2b7PQtEa2OnkzRWw==@vger.kernel.org, AJvYcCW2yKDytxkxwfYB5XIfcc3OsT5YNHKRpHFTQ4kKfdP34LZMeEA7fQ1LQzN8almbW7UIhV26F1cA5PjPRDX7@vger.kernel.org
X-Gm-Message-State: AOJu0YyK+yM5Lza3hyxnda4Fssjv+CTqhz1yaCTMddiLVnn8atu1061r
	t5Zf15HF4Ix4PDe56upgwpOPkdwIkrUMPfz7OyCEe16ou7DsLRrQGJeKhA==
X-Gm-Gg: ASbGncu3Ryd6wvL9l5otSEiimhU3P8t0NqEIeDwmgEyNpGJG9gszHlNivoa+wfbM7WW
	PbCTxBqLMHSqMD16/1w6bGbQ67uDdB8qwjHGKIjdvoLUD6Y7Bu+3rVHW1iBjd5sNODrc4CoCI/4
	46yoMUW3rbF1I2dhDbMCcV88d+EgunLDeN6bdR+zihGLci1bftMAkpqwHR8qSYizkKi3B2UAT2X
	Gyx/uWOiYKVYnrxA5W5A4BS5/lA6srBBfGzv5bwbabpVSRsAdIvSseVGUNVTTkIFDaGMPEDbV6T
	CaBT18KzbYc5DKc6yYEn8PttqdLC36DtCcFlmXB6QXIagUUg
X-Google-Smtp-Source: AGHT+IHfxb44RH4Wj3q0fMrF7BI/R26lMIEkt3vqPx1xOZNEZa3WThGYF/3yac+ALaedDF8YNDmVpQ==
X-Received: by 2002:a05:6402:2084:b0:5e0:8c55:532 with SMTP id 4fb4d7f45d1cf-5e08c55170bmr2068446a12.4.1739967036787;
        Wed, 19 Feb 2025 04:10:36 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:cfff])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dece1b4ed9sm10165964a12.10.2025.02.19.04.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 04:10:35 -0800 (PST)
Message-ID: <408e230c-d098-4ecf-a5b1-1fae9daadb93@gmail.com>
Date: Wed, 19 Feb 2025 12:11:40 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v5 00/27] io_uring zerocopy send
To: Jinjie Ruan <ruanjinjie@huawei.com>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski
 <kuba@kernel.org>, Jonathan Lemon <jonathan.lemon@gmail.com>,
 Willem de Bruijn <willemb@google.com>, Jens Axboe <axboe@kernel.dk>,
 David Ahern <dsahern@kernel.org>, kernel-team@fb.com
References: <cover.1657643355.git.asml.silence@gmail.com>
 <30ac5cb5-ee1f-66fc-641f-5f42140f0045@huawei.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <30ac5cb5-ee1f-66fc-641f-5f42140f0045@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/18/25 01:47, Jinjie Ruan wrote:
> On 2022/7/13 4:52, Pavel Begunkov wrote:
>> NOTE: Not to be picked directly. After getting necessary acks, I'll be
>>        working out merging with Jakub and Jens.
>>
>> The patchset implements io_uring zerocopy send. It works with both registered
>> and normal buffers, mixing is allowed but not recommended. Apart from usual
>> request completions, just as with MSG_ZEROCOPY, io_uring separately notifies
>> the userspace when buffers are freed and can be reused (see API design below),
>> which is delivered into io_uring's Completion Queue. Those "buffer-free"
>> notifications are not necessarily per request, but the userspace has control
>> over it and should explicitly attaching a number of requests to a single
>> notification. The series also adds some internal optimisations when used with
>> registered buffers like removing page referencing.
>>
>> >From the kernel networking perspective there are two main changes. The first
>> one is passing ubuf_info into the network layer from io_uring (inside of an
>> in kernel struct msghdr). This allows extra optimisations, e.g. ubuf_info
>> caching on the io_uring side, but also helps to avoid cross-referencing
>> and synchronisation problems. The second part is an optional optimisation
>> removing page referencing for requests with registered buffers.
>>
>> Benchmarking UDP with an optimised version of the selftest (see [1]), which
> 
> Hi, Pavel, I'm interested in zero copy sending of io_uring, but I can't
> reproduce its performance using zerocopy send selftest test case, such
> as "bash io_uring_zerocopy_tx.sh 6 udp -m 0/1/2/3 -n 64", even baseline
> performance may be the best.
> 
>                 MB/s
> NONZC         8379
> ZC            5910
> ZC_FIXED      6294
> MIXED         6350

It's using veth, and zerocopy is effectively disabled for most of
virtual devices, or to be specific "for paths that may loop packets
to receive sockets".

https://lore.kernel.org/netdev/20170803202945.70750-6-willemdebruijn.kernel@gmail.com/

So that's the worst of the two, it copies data but also incurs the
overhead for notifications. You can use a dummy device as a sink with
no receiver, but you'll get more realistic numbers if you use a real
device (that supports features required for zerocopy).

> And the zero-copy example in [1] does not seem to work because the
> kernel is modified by following commit:
> 
> https://lore.kernel.org/all/cover.1662027856.git.asml.silence@gmail.com/

The right version was merged long ago and sits in

liburing/examples/send-zerocopy.c

It's brushed up more than the selftest version, so I'd suggest using
that one. Arguments are a bit different, but it prints help.

./send-zerocopy -6 udp -D <ip> -t 10 -n 1 -l0 -b1 -d -z1

-- 
Pavel Begunkov


