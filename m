Return-Path: <io-uring+bounces-2770-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3D2951BD2
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 15:28:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9CB0BB23869
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 13:28:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D8281B1431;
	Wed, 14 Aug 2024 13:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oe9fH6tD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CA41B012D
	for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 13:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723642094; cv=none; b=u50fPNfFwxXnnkoJ1B8tuHc9fi0jCBh6YxGAANlystK5491mX/PMY3bhmKYrAHDNPu3Bicabn8kmNFaXeUh3HijVvAWL4FOv3PyTFfN46qckV1816WVDi5H/DmhOesRKuJ6CfTE81mZbsz7+rMm/shyZ/f2Hx+vCyLrY/hQK0Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723642094; c=relaxed/simple;
	bh=66uMW4iMJRLmL3axBkcp08W0WBMwdrCkyAEjca6evu0=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=pOdR81hH+hjjonQFghFUf6mTIEeLA2rqv2vg2WXHrv4snY0IxNVwBgqBMAZ0P9kOsmiqOgWT4kW+bEpcxgXlTfutgBbuHr3DNFqkr6n3YQBWw5ukRPYV5fdFn8f7qCvaHq8fndFJnKyW7/jh+H09XwiRJFmUm2qHqwPD/uhuug8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oe9fH6tD; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a7ab5fc975dso550336566b.1
        for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 06:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723642092; x=1724246892; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I3w8IJQHg61O2rXntmWDSow6vs749S+mGWVB3tux9QY=;
        b=Oe9fH6tDFUnV1tLR2V1zf1anbBpCH5J7CezRiNFqxWcA2SXvbIGvAYbM6gMdmRT0Cd
         H6HupSpNzNX6DM1kxlNsHRX8QbWy5ckL324cMWoNugBPFi7FBOS3GaqqDIoyuz0rAdnC
         P/RdG6rsj9sPU+czpYMkvuNPozCwlFoLsQXOU4fXfpC88XH7s7P7+5DTbC9VTs2C3E1d
         EPExsYpUgmFTnCyhEPlpmd1yABk2lfjUgu2WzUlHaQzAfs810oDD16FMQKIsTB6f0Et/
         4Vtn86b9R96GiMjfxyiKhSLWn88OOMZSFNFt8QKWkR3tL/bLH7+chRGCee0F/eJTVYvM
         YQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723642092; x=1724246892;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I3w8IJQHg61O2rXntmWDSow6vs749S+mGWVB3tux9QY=;
        b=NhHpsYjZNLZXYSxF+n2W/HrpTo1n2TXRqdTIjg7McRy9Fn2L4msXlIYSaNtluNez+3
         51H9Q2YJr2CewGnVH7O3xWQ5p4Ys5ql/RhkloL09kUVWO8Bx4CuVI/A9xkTAPiuWugIC
         Ho3oY+9w//vNa2kxfxtbAvSMXxJORRDe5Je27sqMWa2dbbqwrII3SShM/1AUgK48i/xW
         WysI30vxOcQ7sB4CUMyy+eIdi9kZ4Lrz1LvcsCodQkHod5RQ60FNaxL/nvKoggNbYhlK
         185g60MQBEwWhYZEOxSszfwKSVOFgc/9nTdL9o13varZqk7YcskpMLPzYEpk/N37vRPn
         9bOw==
X-Forwarded-Encrypted: i=1; AJvYcCXJaqYv4OU7iCbJG41XBnUjdhhwr5gW9LsBWi27nzDyr0wmmvgq5hhRfO9YUCy9RNTp5t2r3WoLjpb++lgzxIf8Ww3fkzyAHII=
X-Gm-Message-State: AOJu0YwfODURWAUOK7ApoeLc2HNV26gSTm48/h7yhdYD91gtlLUtAsSU
	1vMpEImS8OQOEFENL1J0Dnxs4XT2mAsHqytZvHJoyby8o+SmYSZL
X-Google-Smtp-Source: AGHT+IHn6My0CY/XoEOaFYcgBa0LBkv3hxdGVA5YC2a/y3Lw1jayp5wgZecvhQqvNOBvqlh+HLjPog==
X-Received: by 2002:a17:906:d7cc:b0:a72:69e8:f039 with SMTP id a640c23a62f3a-a8366bfc066mr174877666b.12.1723642091269;
        Wed, 14 Aug 2024 06:28:11 -0700 (PDT)
Received: from [192.168.42.53] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a80f414e2efsm172418266b.174.2024.08.14.06.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2024 06:28:10 -0700 (PDT)
Message-ID: <6b5c16bd-8b18-459c-9c7f-f97365a06de8@gmail.com>
Date: Wed, 14 Aug 2024 14:28:47 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] abstract napi tracking strategy
From: Pavel Begunkov <asml.silence@gmail.com>
To: Olivier Langlois <olivier@trillion01.com>, Jens Axboe <axboe@kernel.dk>,
 io-uring@vger.kernel.org
References: <cover.1723567469.git.olivier@trillion01.com>
 <c614ee28-eeb2-43bd-ae06-cdde9fd6fee2@kernel.dk>
 <a818bc04dfdcdbacf7cc6bf90c03b8a81d051328.camel@trillion01.com>
 <70c5f2ff-d134-4e90-8e3d-e9f06ba8f407@gmail.com>
Content-Language: en-US
In-Reply-To: <70c5f2ff-d134-4e90-8e3d-e9f06ba8f407@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/24 23:36, Pavel Begunkov wrote:
> On 8/13/24 22:25, Olivier Langlois wrote:
>> On Tue, 2024-08-13 at 12:33 -0600, Jens Axboe wrote:
>>> On 8/13/24 10:44 AM, Olivier Langlois wrote:
>>>> the actual napi tracking strategy is inducing a non-negligeable
>>>> overhead.
>>>> Everytime a multishot poll is triggered or any poll armed, if the
>>>> napi is
>>>> enabled on the ring a lookup is performed to either add a new napi
>>>> id into
>>>> the napi_list or its timeout value is updated.
>>>>
>>>> For many scenarios, this is overkill as the napi id list will be
>>>> pretty
>>>> much static most of the time. To address this common scenario, a
>>>> new
>>>> abstraction has been created following the common Linux kernel
>>>> idiom of
>>>> creating an abstract interface with a struct filled with function
>>>> pointers.
>>>>
>>>> Creating an alternate napi tracking strategy is therefore made in 2
>>>> phases.
>>>>
>>>> 1. Introduce the io_napi_tracking_ops interface
>>>> 2. Implement a static napi tracking by defining a new
>>>> io_napi_tracking_ops
>>>
>>> I don't think we should create ops for this, unless there's a strict
>>> need to do so. Indirect function calls aren't cheap, and the CPU side
>>> mitigations for security issues made them worse.
>>>
>>> You're not wrong that ops is not an uncommon idiom in the kernel, but
>>> it's a lot less prevalent as a solution than it used to. Exactly
>>> because
>>> of the above reasons.
>>>
>> ok. Do you have a reference explaining this?
>> and what type of construct would you use instead?
>>
>> AFAIK, a big performance killer is the branch mispredictions coming
>> from big switch/case or if/else if/else blocks and it was precisely the
>> reason why you removed the big switch/case io_uring was having with
>> function pointers in io_issue_def...
> 
> Compilers can optimise switch-case very well, look up what jump
> tables is, often works even better than indirect functions even
> without mitigations. And it wasn't converted because of performance,
> it was a nice efficient jump table before.

Correction, switches were optimisable until -fno-jump-tables was
added because of speculations, makes it equal with indirect calls,
and otherwise there were usually retpolined making it equal to
indirect calls.

-- 
Pavel Begunkov

