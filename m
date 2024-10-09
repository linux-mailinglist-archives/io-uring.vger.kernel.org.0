Return-Path: <io-uring+bounces-3486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6556996FCE
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 17:35:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 12ACBB20C6C
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 15:35:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF31C198A01;
	Wed,  9 Oct 2024 15:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LawUZK5R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2865C1A0BFA
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 15:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728487631; cv=none; b=B6M+PInViW1BcI3WLEcqxnLMrULK3vfsCF5xIUaqQLDX2EBgn69U0ppzQVpkPzLth60ZT2AvLFMhoXwIQmeZdvnqLRf/rIBU6NwfcMknN9wpO7BG+MRPCo99x2hvOVn/rmchpL6cilH9AnFOebwj2kAvCljyCUrBWwlT94W2EeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728487631; c=relaxed/simple;
	bh=nHhYT90i9k8z39HqFNoz3Vmu86He0hEF2pqu8ZMAp8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KifhFxf2Kt+vU5rpWXlMjudVeVB3hQ3jafe26Y8o5Ny9jD8KoK/5+ibGo3mhseA9gZhbanYmmepOWVloQHtMlf/IituzrqPQRVwjRyyPbqJoe32TnQEAUMUlaqaS0sjygCUqHvsfgag+kym7028oQBrScfjKz1OXcOJo8dYcXAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LawUZK5R; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a3525ba6aaso21473015ab.2
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 08:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728487629; x=1729092429; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PTyFpPeleynuNWUtVcj5JZexBLSzJgt3M7J02jY/6wo=;
        b=LawUZK5R0Nqaz1BQan+UifF9U8sIFM9HWDUeO62t/Wsu9ORd2fIn0YJkIz4cnIg3eq
         WJXRcet2kJDeIhHacSdjObJWwoGhJJmc7DLvB9L9HmG/bfkIpKsV8ZpdlgPUwT6YKr11
         5TDLeHEdHx8zTjnVTniDcrjQneGHTMDawQuj0eKskq2igWYBQX4f1c5tIsZrrq4S1mtD
         5fN2dKQvVUdpLJ+ZXbjZycXzuOL0Uh4CaNzK1TUC2g5lLdq7pv1Nc1rPUbYGjh225Iic
         w8cXWXHg8NbYHJoPcgcXE1d0qfbFFsrCyAM8+86juOlcLWSonPQucciUwWDOBHBVpyUR
         ln9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728487629; x=1729092429;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PTyFpPeleynuNWUtVcj5JZexBLSzJgt3M7J02jY/6wo=;
        b=f/4L6AyZGy32Ob0Z3mphLBf8uFHF3g3kL0v5+yEPz7fScp9tzq1AJrEmdyIQI83JRn
         dWxyd80FU/9N24rzCvgglOdjwrksob0+gmjZNdDZyTnctVgqJEc/8fzg92XEauYV2H5V
         IsfDGoFdj/Er2tdCL07T6RhKuvP56nHZ8bk7RR7YrnGxciAaG1ZieKrz1grFlaBr79lC
         vVhvgaY2Vni+ojnbKNSLYC/HffW3wyamu1NdMchmdbPLXy4SFO4oeOP10pEeCqOwBTiZ
         LaG0xv/Kg/QMugm0d0CIFFa9ucaAD4gtxFqbqhu109EjT02HqqgPkbFzBoBF/GQ7XEQz
         dCyw==
X-Forwarded-Encrypted: i=1; AJvYcCXFiX0WbjVFNA988AA3aNT0Vy4C+DriLzMJ17c1iLfvsS2e/hLpWtJzmMUeXokOUAHa0pCwGmhNOg==@vger.kernel.org
X-Gm-Message-State: AOJu0YznKtfYMQLSTRQ4qHkDyiZKuu9qf2uAaYeMjyRCn7LqyjO9x86O
	Q3PKuduxLIz3Q0pjjY+38a1xWj2HVllyfbYO8KJTQSXaOdM44hiB7NqLl9OXDwE=
X-Google-Smtp-Source: AGHT+IESb0NCNYTlclocLPr5eVXgtgLbfc8mN+fnubYvs85sTWJT+ORAWc5diDFcdiNtnTrA+1HhzQ==
X-Received: by 2002:a92:ca4a:0:b0:3a0:97df:997e with SMTP id e9e14a558f8ab-3a397d0d0efmr29017595ab.14.1728487629165;
        Wed, 09 Oct 2024 08:27:09 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a39fe90428sm2390635ab.32.2024.10.09.08.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 08:27:08 -0700 (PDT)
Message-ID: <2e475d9f-8d39-43f4-adc5-501897c951a8@kernel.dk>
Date: Wed, 9 Oct 2024 09:27:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 00/15] io_uring zero copy rx
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jakub Kicinski
 <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20241007221603.1703699-1-dw@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/7/24 4:15 PM, David Wei wrote:
> ===========
> Performance
> ===========
> 
> Test setup:
> * AMD EPYC 9454
> * Broadcom BCM957508 200G
> * Kernel v6.11 base [2]
> * liburing fork [3]
> * kperf fork [4]
> * 4K MTU
> * Single TCP flow
> 
> With application thread + net rx softirq pinned to _different_ cores:
> 
> epoll
> 82.2 Gbps
> 
> io_uring
> 116.2 Gbps (+41%)
> 
> Pinned to _same_ core:
> 
> epoll
> 62.6 Gbps
> 
> io_uring
> 80.9 Gbps (+29%)

I'll review the io_uring bits in detail, but I did take a quick look and
overall it looks really nice.

I decided to give this a spin, as I noticed that Broadcom now has a
230.x firmware release out that supports this. Hence no dependencies on
that anymore, outside of some pain getting the fw updated. Here are my
test setup details:

Receiver:
AMD EPYC 9754 (recei
Broadcom P2100G
-git + this series + the bnxt series referenced

Sender:
Intel(R) Xeon(R) Platinum 8458P
Broadcom P2100G
-git

Test:
kperf with David's patches to support io_uring zc. Eg single flow TCP,
just testing bandwidth. A single cpu/thread being used on both the
receiver and sender side.

non-zc
60.9 Gbps

io_uring + zc
97.1 Gbps

or +59% faster. There's quite a bit of IRQ side work, I'm guessing I
might need to tune it a bit. But it Works For Me, and the results look
really nice.

I did run into an issue with the bnxt driver defaulting to shared tx/rx
queues, and it not working for me in that configuration. Once I disabled
that, it worked fine. This may or may not be an issue with the flow rule
to direct the traffic, the driver queue start, or something else. Don't
know for sure, will need to check with the driver folks. Once sorted, I
didn't see any issues with the code in the patchset.

-- 
Jens Axboe

