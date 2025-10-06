Return-Path: <io-uring+bounces-9904-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE02FBBFA14
	for <lists+io-uring@lfdr.de>; Mon, 06 Oct 2025 23:58:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE5811899322
	for <lists+io-uring@lfdr.de>; Mon,  6 Oct 2025 21:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E94AE7E0E4;
	Mon,  6 Oct 2025 21:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xnazlz+k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81EB8F4A
	for <io-uring@vger.kernel.org>; Mon,  6 Oct 2025 21:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759787910; cv=none; b=fc0ksytZgWWpyajnNfotdBwounBwZkAzMshMbnxPx5PsIhJdCnF56L1jekM4lFz8SJB26UbWn2oMATGPIi3+IxIqspBIl9ghSpfsgt18MgOKUIgFpALpJrBw5Vp5m6H/AHOlJmUkueZIUNYwOIpUSp7XzIQCD5AzTXSjsdPOcJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759787910; c=relaxed/simple;
	bh=f3vdNb+AXKZSkIcRwuFKr81eOad27kpQZN+s2lSJT78=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=lCzJChxdU7Fg0VlgcG0Ke8Df2u/E7/bQc00hsvr78NokRbxEpIkUvQpniE+8kB/wscC1Mda4AVMYlmgrcJNLi4Sm8Y3aeknMiXXUudYJK96pimmGmm73JYUaGkPU+46rUhITg9RZ3erhh/VvmOU3s0uihRiZG3/tERDsfWp4oUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xnazlz+k; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-911520e43edso221429639f.0
        for <io-uring@vger.kernel.org>; Mon, 06 Oct 2025 14:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759787905; x=1760392705; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=n6EVL03ARU3rLYNBU3JmIvIpqg3yDnF28g1FR7KLJlE=;
        b=xnazlz+kn39kdO/ZegtNZLDiieEH8TS19HkECBKKqP2kbvbXOKaxOT60WkMHvaph08
         r9GVJ4Hubb4qXQPtIpKeXmq4Al7lky8ReFgc2PTgHyDi181L0ukAtvLGcdaWATtKeQhD
         Rsc+2UvuypSXROSKvYmU1mlHuKPA5ELW3WVVbowwOtRwMqb+nneaOOGiZ7eiFt3T/AdS
         YlzZ0LzIm5xt5DL7PWrp4ZN5DyJja+xGyl0PBuS4VlUCo+bZeB/o6IcejPlAW8Lggn9K
         mMkgKxV2GX1ZWkBPkMvMONSMEt0SRjA2jKJCSaqRFvTdDteH3sWJdrOPVqpNDwNICF3e
         o8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759787905; x=1760392705;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n6EVL03ARU3rLYNBU3JmIvIpqg3yDnF28g1FR7KLJlE=;
        b=a4YDTL+Az5rpLbhA/3wNuCnQQTc+mhbgJA7ZpYiBMzYJJ3oY5J+oo1697A/KaO9mzG
         kp+VU9WytI84vBmELYTu9r/NVB9V/Pr9wxj1rd4wNGfLHbn4hIFZ8jRj3Jt6AcJRRjl3
         KUlt7J2necCuYMSsPfQjEe13Rp5dwoywpcb4NVv9bC3Lp8RdzbmVEpUjexB+DZNjPEXl
         +SE1VkW2gI0aM0YvCy2hup2XK0NUw35lL+EkHl9vzFScX/fA8FYCACqP5/mU16Ozw3yU
         bgfRpONeiHB/JAjlQrABusB0KbXeH5yHTG8VBgCOeIAn8PvwyIQjQzsSRe5UecorSAub
         7EPw==
X-Forwarded-Encrypted: i=1; AJvYcCUafib1tyD8mW81DNlwW6Ev2hm1PL0p6YPZawCtM1z/88s+9+mpoYmMw5ziRQ69DTeZCzV43LKsEw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyj+JR5G0xQJXmu4BrsAu1VTxMsC1XK5QZUr8ob19mC4e45ghNU
	HGp9AyGcRDQvBPJkmPgKwOE8LhEJngNv7izhfF5U6VfHnBxEBd3xTPqCChkU+WF1pQezavFlgO1
	FWnRQkL4=
X-Gm-Gg: ASbGncuQnt3GXTf9d/IFTCasi1yVuTGwC+zPbXqZG30tfdKqDT1T0usn/8EOEc++bps
	/AAxuz0OG8MtxYgzsCW6DHUSS73KuqmGP9jNZHmiYzlBE07U1t/7lR+jUF+VWv0FEvbyEYYirV6
	GZxEzTADLo/0SaAtbrjxKuQvTjOljhi6pPn0EEAwyZrNqR09D6nF8wnNnvGl1WzsK+nJJvsE4Yv
	cRwgOm0HNzfTav/nwLVY0/+gaB/lfgbhbSKS9noCkdyxVJ5aLUDiG00jP4jDWUpJE3JMc3gmrlj
	UsEJeUWfkLDcKlgpGI41TXzcaXpHNz0/2T1rfcnxnQAiX7FnsZVKq1k4F3lZ34oqAaZlw8LrAXd
	+JFeYdujy/COfc2QONQ2pPYKSEoSJjb+ikT71F1SNct8t
X-Google-Smtp-Source: AGHT+IFjnhSB4U6y8RzFAhLYmkI9w722xWLmw/cENWOs/s6jYbOM8dfzNvU4AY84wiMnDjOjUwXBsQ==
X-Received: by 2002:a05:6602:154d:b0:91e:c3a4:537d with SMTP id ca18e2360f4ac-93b96a96b9fmr1890186839f.13.1759787904629;
        Mon, 06 Oct 2025 14:58:24 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-57b5ea30208sm5356596173.25.2025.10.06.14.58.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 14:58:24 -0700 (PDT)
Message-ID: <ae8568c5-faa4-4f14-a690-9048819d65cd@kernel.dk>
Date: Mon, 6 Oct 2025 15:58:23 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CQE repeats the first item?
To: Jacob Thompson <jacobT@beta.pyu.ca>, io-uring@vger.kernel.org
References: <20251005202115.78998140681@vultr155>
 <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
 <20251005215437.GA973@vultr155>
 <57de87e9-eac2-4f91-a2b4-bd76e4de7ece@kernel.dk>
 <20251006012503.GA849@vultr155>
 <d5f48608-5a19-434b-bb48-e60c91e01599@kernel.dk>
 <20251006020142.GA835@vultr155>
 <a25558b5-7730-432a-85cc-55fdc8dca0d3@kernel.dk>
 <20251006214553.GA868@vultr155>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251006214553.GA868@vultr155>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/6/25 3:45 PM, Jacob Thompson wrote:
> On Mon, Oct 06, 2025 at 07:56:16AM -0600, Jens Axboe wrote:
>> io_uring_setup.2 should have all of these setup flags documented.
>>
>> I'll ask again since you didn't answer - why aren't you just using
>> liburing? It'll handle all of these details for you, so you can focus on
>> just using the commands you need and not need to build your own
>> abstraction around how to handle the SQ and CQ rings manually.
>>
>> -- 
>> Jens Axboe
> 
> I read through liburing, boss wants me to understand everything about
> io_uring and wants an in house solution and for me to optimize it.

Ok I take it back, boss sounds reasonable then ;-)

> I was able to write a test that submitted more than 2^32 entries and
> it ran correctly. I think I'm off to a good start now

Good!

-- 
Jens Axboe

