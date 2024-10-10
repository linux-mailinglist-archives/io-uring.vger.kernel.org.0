Return-Path: <io-uring+bounces-3567-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 949F2998F80
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 20:12:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4841B1F23C2D
	for <lists+io-uring@lfdr.de>; Thu, 10 Oct 2024 18:12:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF75D1C9B64;
	Thu, 10 Oct 2024 18:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dxaE3HBA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C4E19DF53
	for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 18:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728583919; cv=none; b=CKLZ1BAzFamnM90Cx9WBkzpEdgKN3IzbR1CqLJdVUzcbZppf+IOTei3QzkhMeRX38QXVFOZQu0NLXpb0tll4/GzbGqGimvwv36UzMloP9qbYJKtuPGCPDSEcfI3mHx/3BuFY61iFf4YvVT0eyTUa4B3zGqjhnRbcHGZj2ghGV3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728583919; c=relaxed/simple;
	bh=3bWMU9e+fC2FyjouFlvZ8jusiaIzuZ0pgurWY1hHAeU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=RdsGySgWxDBrlXUq0aejjze5gL8qnQJZi6mOBSfE95NyxyEHk5MUDkthrjOwV8J9OVv/8JikNO+rESceueQvzoi/YYDK/gBFzwY715Ii+SaGXABg7hPsB8IAslDHeCXubLiN+4dHuIbX6gFY+keQjoSiFeV7lSyPQne2LhNtv08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dxaE3HBA; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-835426c0fefso39104339f.1
        for <io-uring@vger.kernel.org>; Thu, 10 Oct 2024 11:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728583916; x=1729188716; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v+F0BsVfrw8m5gGuuX3A/23c5S/Zo9mD7HI9V9TN0us=;
        b=dxaE3HBAuI+r2EU60XfKgjDh45MKT3MvQMzP+8IAjIY5NF2an6zDYjwJFwnVrRl4Pe
         vM5UsERAUWg7DvyR9eMvmBPZ2QojGLkj4bkhDkJQGhVijn0wf8+6RvkWEVsRThD361g/
         rUJQGGdUgcvi3U8kqFsOpwtbbz7nOm1QqGWtFzSUN9fzQ2UB/7W2GT5I2tq3N2HaU3PV
         +eSWrEOh4U8W4xwjYErA4F36ISFIx6oUIuNbc2yiSVx/zfHOIMNuJgkuTU8ix6KRfZwz
         O775ZtFqsjHrxAvbX5HBqLMaqFcJMibyJ/ViZsBhAMWs2z121LoqU5+VHbQDGr9UaFCx
         bQWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728583916; x=1729188716;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v+F0BsVfrw8m5gGuuX3A/23c5S/Zo9mD7HI9V9TN0us=;
        b=Q/OSKaoyjEIzvf4M958ifBkfXmqa/8EoGIoFtV2fwkEFIXI9lB3Sf4/XdIZnlwqIrD
         YonGYcfN8+E8YLPEFoUkF6FS6iY/QPgOzVl9ciFv34NU9sGfowC8EurURprOTTzq/PXc
         W1qJF/yfl5YRkBr8GhsSfZuW/k8EOaBD1YN9wIhjcG/WzSvfK6JMrA1uDhXwYTlKptHI
         x24T6UlzslnRwJG6vJAoZ4qk9EYC7x0E9EFYAo7zEgTYpx5hPOEt09flMXYvI4yTd5p/
         /tdtP1VX02Q+enMO6N+jfT9wELa0cYQZwrGYFPga6BwbfbhF3DGTuoZB8T02OJDMzjXk
         QYqw==
X-Forwarded-Encrypted: i=1; AJvYcCUD6EZA8Iat9CueoinuL999MvyTBf1ZuBgG7GDKBAmCQvZt3Kh/jyu/rAurGUNWDPcVTrANcnuCzw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwmTZzwlWj1k2GUX7AGwTLxHjMzzeNlm6gcT6zY0R9NBZPYiHD4
	7Lh0SLyb3Gwtox6InYhSCKg5Gzm+lB463XovQfnMn19TIkwZUeF6McI+Jjq4iKc=
X-Google-Smtp-Source: AGHT+IGOV2UPuymvEgQ+6c1bH10cOMow3zjQBa5UHT+HcLNwzPNLPC4nhY84w0wxt2FwuHXhTxfzVQ==
X-Received: by 2002:a92:c24c:0:b0:3a0:9f36:6bf1 with SMTP id e9e14a558f8ab-3a3a71d1af6mr33081815ab.9.1728583916165;
        Thu, 10 Oct 2024 11:11:56 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbadaa91fbsm328259173.141.2024.10.10.11.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 11:11:55 -0700 (PDT)
Message-ID: <9bbab76f-70db-48ef-9dcc-7fedd75582cb@kernel.dk>
Date: Thu, 10 Oct 2024 12:11:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
From: Jens Axboe <axboe@kernel.dk>
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
 <2144827e-ad7e-4cea-8e38-05fb310a85f5@kernel.dk>
 <3b2646d6-6d52-4479-b082-eb6264e8d6f7@kernel.org>
 <57391bd9-e56e-427c-9ff0-04cb49d2c6d8@kernel.dk>
 <d0ba9ba9-8969-4bf6-a8c7-55628771c406@kernel.dk>
 <b8fd4a5b-a7eb-45a7-a2f4-fce3b149bd5b@kernel.dk>
 <7f8c6192-3652-4761-b2e3-8a4bddb71e29@kernel.dk>
Content-Language: en-US
In-Reply-To: <7f8c6192-3652-4761-b2e3-8a4bddb71e29@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/10/24 8:21 AM, Jens Axboe wrote:
> On 10/9/24 11:12 AM, Jens Axboe wrote:
>> On 10/9/24 10:53 AM, Jens Axboe wrote:
>>> On 10/9/24 10:50 AM, Jens Axboe wrote:
>>>> On 10/9/24 10:35 AM, David Ahern wrote:
>>>>> On 10/9/24 9:43 AM, Jens Axboe wrote:
>>>>>> Yep basically line rate, I get 97-98Gbps. I originally used a slower box
>>>>>> as the sender, but then you're capped on the non-zc sender being too
>>>>>> slow. The intel box does better, but it's still basically maxing out the
>>>>>> sender at this point. So yeah, with a faster (or more efficient sender),
>>>>>
>>>>> I am surprised by this comment. You should not see a Tx limited test
>>>>> (including CPU bound sender). Tx with ZC has been the easy option for a
>>>>> while now.
>>>>
>>>> I just set this up to test yesterday and just used default! I'm sure
>>>> there is a zc option, just not the default and hence it wasn't used.
>>>> I'll give it a spin, will be useful for 200G testing.
>>>
>>> I think we're talking past each other. Yes send with zerocopy is
>>> available for a while now, both with io_uring and just sendmsg(), but
>>> I'm using kperf for testing and it does not look like it supports it.
>>> Might have to add it... We'll see how far I can get without it.
>>
>> Stanislav pointed me at:
>>
>> https://github.com/facebookexperimental/kperf/pull/2
>>
>> which adds zc send. I ran a quick test, and it does reduce cpu
>> utilization on the sender from 100% to 95%. I'll keep poking...
> 
> Update on this - did more testing and the 100 -> 95 was a bit of a
> fluke, it's still maxed. So I added io_uring send and sendzc support to
> kperf, and I still saw the sendzc being maxed out sending at 100G rates
> with 100% cpu usage.
> 
> Poked a bit, and the reason is that it's all memcpy() off
> skb_orphan_frags_rx() -> skb_copy_ubufs(). At this point I asked Pavel
> as that made no sense to me, and turns out the kernel thinks there's a
> tap on the device. Maybe there is, haven't looked at that yet, but I
> just killed the orphaning and tested again.
> 
> This looks better, now I can get 100G line rate from a single thread
> using io_uring sendzc using only 30% of the single cpu/thread (including
> irq time). That is good news, as it unlocks being able to test > 100G as
> the sender is no longer the bottleneck.
> 
> Tap side still a mystery, but it unblocked testing. I'll figure that
> part out separately.

Further update - the above mystery was dhclient, thanks a lot to David
for being able to figure that out very quickly.

But the more interesting update - I got both links up on the receiving
side, providing 200G of bandwidth. I re-ran the test, with proper zero
copy running on the sending side, and io_uring zcrx on the receiver. The
receiver is two threads, BUT targeting the same queue on the two nics.
Both receiver threads bound to the same core (453 in this case). In
other words, single cpu thread is running all of both rx threads, napi
included.

Basic thread usage from top here:

10816 root      20   0  396640 393224      0 R  49.0   0.0   0:01.77 server
10818 root      20   0  396640 389128      0 R  49.0   0.0   0:01.76 server      

and I get 98.4Gbps and 98.6Gbps on the receiver side, which is basically
the combined link bw again. So 200G not enough to saturate a single cpu
thread.

-- 
Jens Axboe

