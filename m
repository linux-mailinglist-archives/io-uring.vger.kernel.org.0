Return-Path: <io-uring+bounces-2755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A06E950F3C
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 23:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5ADA81C21EDA
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 21:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 055DD1A76D5;
	Tue, 13 Aug 2024 21:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="A/EWZb7x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40E217B515
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 21:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723585462; cv=none; b=kOw/XySTaKULqN580koPAr5K1jH7ql1TYswqLEVDalFeF608QnzIVc5hCuyPSqVCYUH/kM8+CB4+I/wuQlcwcpYeYdG9EpdNqU/KsVCCX5bv2UlIX2MfsEI5qyvIf1C1iNJi2FqPbfEANM0jLyFdPv5MZ7dWQiR4GBo+YQefdRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723585462; c=relaxed/simple;
	bh=+B4wtB95QbdgVPDLKPM4U9tx/eHc/6xjSc5kS2n94zU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=YskX0ROB1e+LBaNnDdnd43+1/AQ5n1cSUxa5qiwj8gnwr1DUcjDYlWb+ZRNf/SuAuK4THZhWPqLosRgcudBSMzBI8teO+wi2ovKVYu0P0woGEzYeNZqWsQjyejx7QzETV0T9tilUhXXzgvH2vfdr69ltdpEjGgjom07Y37WAnuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=A/EWZb7x; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-1fc5bc8d23cso1145ad.1
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 14:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723585459; x=1724190259; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LXSshmFqns50e/s/0Tl0n/zhamdRbHDTDdcg4MUSaeE=;
        b=A/EWZb7xlMK7dsZuhJKnG1kw1cB/WDTGxUPhB7GJXQByuTfvRcAtUNVDjrG3z6nF/y
         P9zO/CsCySCrfiTJkVc7lHAu6g2QaNOUIaJynCPKu5fWCfZno1OZ4wMJx/CxaqH0B0QB
         yq/x3FgpNktF+vGZqOtzfYV1kogUgdURgAJatDpdmpCcbWMlcYt78nn/Za6Y26z08T8Y
         xsUMfdhmRFP6altH53bCHbMDQEACXu4kqA4L176IfUzuFqiwW2b8KME8VhUs+hxeiLXG
         orc28pq/R98FGqKy5AA6VOAyfr1uoYheY6bWA8MPUD9osHd/75tBshezD+pmdOJJVT+D
         VxHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723585459; x=1724190259;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LXSshmFqns50e/s/0Tl0n/zhamdRbHDTDdcg4MUSaeE=;
        b=q7yiEyMuKl0lU1Revs5f5c7hQ25FFlJUoO3A2PO6idXrBrByMuluE9VfSOM5EK/IZY
         SXb+dSg/CgoImORoU73F4glpW7fjr0GDocoo7oP0sZmkWDvcO3sAY4ymJkflkBg41Yp0
         mZDVeBJJemZ0Qbp45pAw4QhdOAzkPoo20g/gOn7JCuSCQ1ImJeCNSRVR2d12p8fiyA6p
         rdaSJGtkjDt5Z5OyUg/Gc/rklSJsW3HK6FYETwhumlHIXNc3V8/fuixibWJDXKfj/PVl
         iv2zs/3fJP5rC/zEgSc5Z1qCL310ZB1toGwl5NH6efNhFOrWIPhkjt2vO/S5oSAFTT1L
         itYw==
X-Forwarded-Encrypted: i=1; AJvYcCVUCgs8MLdz0GzXR3Nn5pX3fbC+Uvt8L9kO9+NMt8SO7Y5Ak8oTWrqmOp8FkAjfdaeUf4w4lh5qgRZhySPXaeMdAhMNafPgysw=
X-Gm-Message-State: AOJu0Yw/9q9IjfuDEuldlpRQH2QmPIR9tCc2YfK96Fr14M1og7e9LPPz
	K3x7rNcB+/QFQO8cQ4kxJuq/H0MKHjbLZ3D9u/3yxgIOS/NmBwZzEN7WFfu4Aek=
X-Google-Smtp-Source: AGHT+IG4w0rQxA+WhxbyvTEM+ZaYGXGUjHVm9eXYUy8TW9/eEJkcmGz5HAVa/MBfoT7bvoGj7jOzbg==
X-Received: by 2002:a17:903:244d:b0:1fc:6028:b028 with SMTP id d9443c01a7336-201d64d8b12mr5899115ad.9.1723585458610;
        Tue, 13 Aug 2024 14:44:18 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1a9264sm18006295ad.178.2024.08.13.14.44.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 14:44:18 -0700 (PDT)
Message-ID: <631b17e3-0c95-4313-9a07-418cd1a248b7@kernel.dk>
Date: Tue, 13 Aug 2024 15:44:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] abstract napi tracking strategy
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1723567469.git.olivier@trillion01.com>
 <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
 <a818bc04dfdcdbacf7cc6bf90c03b8a81d051328.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a818bc04dfdcdbacf7cc6bf90c03b8a81d051328.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/24 3:25 PM, Olivier Langlois wrote:
> On Tue, 2024-08-13 at 12:33 -0600, Jens Axboe wrote:
>> On 8/13/24 10:44 AM, Olivier Langlois wrote:
>>> the actual napi tracking strategy is inducing a non-negligeable
>>> overhead.
>>> Everytime a multishot poll is triggered or any poll armed, if the
>>> napi is
>>> enabled on the ring a lookup is performed to either add a new napi
>>> id into
>>> the napi_list or its timeout value is updated.
>>>
>>> For many scenarios, this is overkill as the napi id list will be
>>> pretty
>>> much static most of the time. To address this common scenario, a
>>> new
>>> abstraction has been created following the common Linux kernel
>>> idiom of
>>> creating an abstract interface with a struct filled with function
>>> pointers.
>>>
>>> Creating an alternate napi tracking strategy is therefore made in 2
>>> phases.
>>>
>>> 1. Introduce the io_napi_tracking_ops interface
>>> 2. Implement a static napi tracking by defining a new
>>> io_napi_tracking_ops
>>
>> I don't think we should create ops for this, unless there's a strict
>> need to do so. Indirect function calls aren't cheap, and the CPU side
>> mitigations for security issues made them worse.
>>
>> You're not wrong that ops is not an uncommon idiom in the kernel, but
>> it's a lot less prevalent as a solution than it used to. Exactly
>> because
>> of the above reasons.
>>
> ok. Do you have a reference explaining this?
> and what type of construct would you use instead?

See all the spectre nonsense, and the mitigations that followed from
that.

> AFAIK, a big performance killer is the branch mispredictions coming
> from big switch/case or if/else if/else blocks and it was precisely the
> reason why you removed the big switch/case io_uring was having with
> function pointers in io_issue_def...

For sure, which is why io_uring itself ended up using indirect function
calls, because the table just became unwieldy. But that's a different
case from adding it for just a single case, or two. For those, branch
prediction should be fine, as it would always have the same outcome.

> I consumme an enormous amount of programming learning material daily
> and this is the first time that I am hearing this.

The kernel and backend programming are a bit different in that regard,
for better or for worse.

> If there was a performance concern about this type of construct and
> considering that my main programming language is C++, I am bit
> surprised that I have not seen anything about some problems with C++
> vtbls...

It's definitely slower than a direct function call, regardless of
whether this is in the kernel or not. Can be mitigated by having the
common case be predicted with a branch. See INDIRECT_CALL_*() in the
kernel.

> but oh well, I am learning new stuff everyday, so please share the
> references you have about the topic so that I can perfect my knowledge.

I think lwn had a recent thing on indirect function calls as it pertains
to the security modules, I'd check that first. But the spectre thing
above is likely all you need!

-- 
Jens Axboe


