Return-Path: <io-uring+bounces-4926-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C4BC9D4F47
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 15:57:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23D66286869
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 14:57:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0572E136E09;
	Thu, 21 Nov 2024 14:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HcG9xyZ5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C431ABEB4
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 14:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732201059; cv=none; b=Oyv6Qr4SdiBERPom3CfkkyJIpLXk2mqJhdaULKbNgASWpxdg3TzdVs0R4htcvd6oscd/0Y/L9XzZ6PsVQhEPuTCAl7VLx+XmAq6uLc9Q+DwOre83w+MPUu/iEDNm34oUBs4XZObxN3hVGu3DbHYXVb2BcfeA7H5PLYkzPNFMeA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732201059; c=relaxed/simple;
	bh=H8/hSRqz9GxuO4mwjo3lB35nSTFQJN78cJT2HN4Amz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DqHDDPwuquPp9eFEc4zm2RsgqW76Cj87CWCzLCgtBgsDvp9onF2HmyVUkYaRIRofMQDF5Aj2xA9tPXEQW8875dbMfPTR2Xh+NG1N/56uSGa8nOCm9f1u5Xk3oBYN5+wVDN+pe1lB2uhFOVaQ89pk14Ts6jnMLrlOVBhxj295KBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HcG9xyZ5; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a9ed0ec0e92so133287866b.0
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 06:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732201056; x=1732805856; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OmusdlryyoU/G/frOUHjQcMEBLliQf4PZNosXwES9tg=;
        b=HcG9xyZ5KIQTgQl6Z50rkTRs9Q7GFDXED90YbzQzH5hHaN1D8v6QmEPvXzM/IyeQ8/
         DOkBztCfJAzsj2fT2Nva0dEwTLCe3AJ/oQJIkfE+FMDNrkZO3K6rGuUCySA84bwZ6Rjs
         ltMTX/JqK54X1WGL+6ogFWlyVoY2o1bvgcsQJdI8Fns7gb3c8DAJa6VXGPxSV8zi7FeW
         KYPTawe3FA4IJI7dydVMusyDx5l5canpas/6vQjX55wLMP3Zptmu1PjEyKjW1rLBi+Va
         Nt6mNcqoxRbE2Age8EK1TUt/m+3MNiPrXcNu/LymVCIbWPpalxZr4iYDADPbWGTTTB7k
         IG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732201056; x=1732805856;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OmusdlryyoU/G/frOUHjQcMEBLliQf4PZNosXwES9tg=;
        b=A1ffsWsgXGcAD7Dlrt0ZStGRl6ekhlGu5ZuGlwpMaHFo9YXhv6Yf/VlUVIB1pevPk0
         PbxZRJCF/o9FboPqJeci7ZZcF+2bd3XsAV3cMYC7MC+PmZCSJhFBHdYkFqzqOAYoNXCR
         AWf2d3YmvUrtNJcapP8RrF5v1Rm6thOMKubpN+61p/atnkaOy3zAxUEd37QXCMrqx3Ap
         QUDhjJ0fqlMx5x9NGWE01H/I6ey/ZbJ4/DM7gaaf6HFSSrtBC5NAwfg9qM9jA5T617YQ
         XMnw8yUgn3GFdOQ0CKcEMRTOFEL745qita0mx00jsxky1gRmIF73PSoxqCInnPIoSR4B
         by6g==
X-Forwarded-Encrypted: i=1; AJvYcCVcrR0Mw3oUdXUCdnJlGBe+nwlHqnhaAhbLaxtJ2aszuiAvCEWiz3+OdYTw0fBjNmFR5iD1FfS10g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyrjHmrzSTzXBcXZvAESfMnwFNwJxImJbcd4xMo/XriMmhocF0R
	8zHE8wZwHd9mMWrIj2lJNscz3dfxsKoddjoM8GlmbXLuUJQ1QMMEd+syNw==
X-Gm-Gg: ASbGncsmWs3b1/uGT0m2GzENAEr41kX6YJil//1dw46Dy4Ibq47YdLQBhvpVysAChlF
	aL9W7M8e6wxVK9r48cRPP7K809UVoyUb0VmUMHqnI7Cyr1E3HTJQSweFc7Vb97qhet3l2pDzybV
	Snviy1TUl5HgSkU2aiPuxeCJmxj20zK3O6ska3F2HiEQBhXVJcsOzvvjC0rWXuwCfhU+dy545yc
	ogjohxkjaCCMPf6eJtgFkNqGF1FSAZdSs0o4CdN80/dJx7iQELsNZDBN1E+/Q==
X-Google-Smtp-Source: AGHT+IH/xDSexPNwcvgB5yusThYxeBuMpi7bK0dID8Wla7S9cudzCC+ZaA1TMJ3N9Wcog7B+KUfQMA==
X-Received: by 2002:a17:907:869f:b0:a9e:b150:a99d with SMTP id a640c23a62f3a-aa4dd548243mr577281466b.5.1732201056259;
        Thu, 21 Nov 2024 06:57:36 -0800 (PST)
Received: from [192.168.42.120] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f42d33e9sm89318866b.94.2024.11.21.06.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 06:57:35 -0800 (PST)
Message-ID: <cf1648f0-28fd-43c9-9e12-6dbcb38f38ce@gmail.com>
Date: Thu, 21 Nov 2024 14:58:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Jens Axboe <axboe@kernel.dk>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <4d71017c-8a88-40bb-a643-0efb92413d3d@davidwei.uk>
 <1d98f35c-d338-4852-ac8c-b5262c0020ac@gmail.com>
 <7e7243ae-db29-4a96-aece-d66897080a41@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <7e7243ae-db29-4a96-aece-d66897080a41@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/21/24 14:34, Jens Axboe wrote:
> On 11/21/24 7:29 AM, Pavel Begunkov wrote:
>> On 11/21/24 00:52, David Wei wrote:
>>> On 2024-11-20 15:56, Pavel Begunkov wrote:
>>>> On 11/20/24 22:14, David Wei wrote:
...
>>> There is a Memcache-like workload that has load shedding based on the
>>> time spent doing work. With epoll, the work of reading sockets and
>>> processing a request is done by user, which can decide after some amount
>>> of time to drop the remaining work if it takes too long. With io_uring,
>>> the work of reading sockets is done eagerly inside of task work. If
>>> there is a burst of work, then so much time is spent in task work
>>> reading from sockets that, by the time control returns to user the
>>> timeout has already elapsed.
>>
>> Interesting, it also sounds like instead of an arbitrary 20 we
>> might want the user to feed it to us. Might be easier to do it
>> with the bpf toy not to carve another argument.
> 
> David and I did discuss that, and I was not in favor of having an extra
> argument. We really just need some kind of limit to prevent it
> over-running. Arguably that should always be min_events, which we
> already have, but that kind of runs afoul of applications just doing
> io_uring_wait_cqe() and hence asking for 1. That's why the hand wavy
> number exists, which is really no different than other hand wavy numbers
> we have to limit running of "something" - eg other kinds of retries.
> 
> Adding another argument to this just again doubles wait logic complexity
> in terms of the API. If it's needed down the line for whatever reason,
> then yeah we can certainly do it, probably via the wait regions. But
> adding it to the generic wait path would be a mistake imho.

Right, I don't like the idea of a wait argument either, messy and
too advanced of a tuning for it. BPF would be fine as it could be
made as a hint and easily removed if needed. It could also be a per
ring REGISTER based hint, a bit worse but with the same deprecation
argument. Obviously would need a good user / use case first.

> I also strongly suggest this is the last we'll ever hear of this, and
> for that reason alone I don't think it's worth any kind of extra
> arguments or added complexity.

-- 
Pavel Begunkov

