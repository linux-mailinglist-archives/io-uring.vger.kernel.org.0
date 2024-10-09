Return-Path: <io-uring+bounces-3498-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3C6599724B
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 18:51:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84E7A283241
	for <lists+io-uring@lfdr.de>; Wed,  9 Oct 2024 16:50:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E011974FA;
	Wed,  9 Oct 2024 16:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SsNFYJwZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213F922098
	for <io-uring@vger.kernel.org>; Wed,  9 Oct 2024 16:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728492659; cv=none; b=MkaT9bAawS9uzRp+V/nncqDa+iQK4celVkLVTt6ivA4nujnYR/N9A974u2jVn7s5y56QjWDsYhhgBLqsHI77lrLZ/FKjpQOd/F/C9Mxbi/IpX6PeT7s69hOGu9Vx7FHeL25udLt6DP8sD/nogvfap6LtlrKlh7NosJRWqq8zPIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728492659; c=relaxed/simple;
	bh=CQviehjtQ5nEQzFt58WbT2dVDLCdAJCkIVZbfOTz3sE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FeRiRbbdhbLgG46HlwSSUQUlcpGG4F14nSNyCA5qLwI8pH3kLSMsP3c6MCke2r14HQQyD/+zvvmGIabIZUCFNIZaZyOpMLYs2o0fVY8gDKMmNjsJaZY7JolfTlS6k92ISaeqo20cTP0QEufbzuDbgKU5PMb4ewXUPWJN3yniRY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SsNFYJwZ; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-82aa6be8457so1570439f.0
        for <io-uring@vger.kernel.org>; Wed, 09 Oct 2024 09:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728492656; x=1729097456; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bPL1Ys3vx6T6pnpmpv603BOiuuGPyjBegqS4Kd9aWbw=;
        b=SsNFYJwZvxnu4NJA15w2HC9r9piS/NU9/rn/c+71r1xE6/O8DWXGwlZ3DYu1ebIdFa
         Xlv8DbZko7SWHlETOAhbDlvlqYZ3AcDCoFXaQxIHtOwrefhNn9nHD/ugklRxNwdgQy9x
         bi5PxL+fQFpxA7GX1q+AslETlj0aHYS4l7J+Taq+gFrBpJXg4x4Rb3DewRCYVqP8FJ9M
         ml0fpY17eTcz8HjVAvyOwGRvdjaW4+AWXwlf5bP/3L5speURbR9jnIyG2szrqEmWtb0k
         LK4/jkbjgBevkrhD9LhruiqJBDnElJ17loLQeav9bbXyaisiVu1ERc9oU0wtsyT2sxFG
         DjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728492656; x=1729097456;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bPL1Ys3vx6T6pnpmpv603BOiuuGPyjBegqS4Kd9aWbw=;
        b=K6skEC0Ohp9yXA7bVI20gcobsP5dPl/rt7QLh4N+cagAm7/xRgTNNsywBLiZUEEu9A
         oBFskw25deQiAgKzpGHbjU1mKIokMD95Uz6yoxkw9M88SrFij7a8BeHbHM7RFnhX5z/z
         jRq3qH8OrW6SiocNDtuSS/TUfZDaZxZFIQfYPlLY/7elRsNlEV8SuIAm5olD+AQXtT/q
         u8BanxNf8DmnMhAlVzIoK+7IdLADY9UxvXwCHS2UXseAxjA/ld1u3OTljBZOAAdltcP/
         toxHNOEdaa0yHCIps3022KqRPpgI6GPsG2ZLYeGxCPV6Z8Yp1TbROAbbPn/RAud4uGKO
         EMqA==
X-Forwarded-Encrypted: i=1; AJvYcCXpyk7NYNT1EADxjnrj3Dhp6jXjguJUdUBdh8WnH3ZkL5jJyRrNhlaS1H0Ly5yGPPlBPCJvb4c7fQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxha1JXjNDhk32hCcM9RYFP7zov6dnQUHPtx58GP/1BhO74cyyk
	2oiDWyO1myGnPxYXJRWCIhvNcqeZMk2ZfvJgOJufnweCWJ/Fx7lOvMl1lDjgal0=
X-Google-Smtp-Source: AGHT+IEI9ELr8BJEpGt8uuBM9sh/6If6LKEijwCEnE5nkrowIyU9/NFEHb08ujsx0PO7XoUyLdarmw==
X-Received: by 2002:a5e:de42:0:b0:81f:8665:da0a with SMTP id ca18e2360f4ac-835485d9ed1mr23571739f.1.1728492656250;
        Wed, 09 Oct 2024 09:50:56 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db6eb557a6sm2118223173.50.2024.10.09.09.50.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 09:50:55 -0700 (PDT)
Message-ID: <57391bd9-e56e-427c-9ff0-04cb49d2c6d8@kernel.dk>
Date: Wed, 9 Oct 2024 10:50:54 -0600
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
 <2144827e-ad7e-4cea-8e38-05fb310a85f5@kernel.dk>
 <3b2646d6-6d52-4479-b082-eb6264e8d6f7@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3b2646d6-6d52-4479-b082-eb6264e8d6f7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 10:35 AM, David Ahern wrote:
> On 10/9/24 9:43 AM, Jens Axboe wrote:
>> Yep basically line rate, I get 97-98Gbps. I originally used a slower box
>> as the sender, but then you're capped on the non-zc sender being too
>> slow. The intel box does better, but it's still basically maxing out the
>> sender at this point. So yeah, with a faster (or more efficient sender),
> 
> I am surprised by this comment. You should not see a Tx limited test
> (including CPU bound sender). Tx with ZC has been the easy option for a
> while now.

I just set this up to test yesterday and just used default! I'm sure
there is a zc option, just not the default and hence it wasn't used.
I'll give it a spin, will be useful for 200G testing.

>> I have no doubts this will go much higher per thread, if the link bw was
>> there. When I looked at CPU usage for the receiver, the thread itself is
>> using ~30% CPU. And then there's some softirq/irq time outside of that,
>> but that should ammortize with higher bps rates too I'd expect.
>>
>> My nic does have 2 100G ports, so might warrant a bit more testing...
>>
> 
> It would be good to see what the next bottleneck is for io_uring with ZC
> Rx path. My expectation is that a 200G link is a means to show you (ie.,
> you will not hit 200G so cpu monitoring, perf-top, etc will show the
> limiter).

I'm pretty familiar with profiling ;-)

I'll see if I can get the 200G test setup and then I'll report back what
I get.

-- 
Jens Axboe

