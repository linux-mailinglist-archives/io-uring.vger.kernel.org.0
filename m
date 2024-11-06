Return-Path: <io-uring+bounces-4487-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FC459BEFDA
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 15:11:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BBF2C1F22088
	for <lists+io-uring@lfdr.de>; Wed,  6 Nov 2024 14:11:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F79E1F9EB6;
	Wed,  6 Nov 2024 14:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n67AyePp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C35B11F9ABD
	for <io-uring@vger.kernel.org>; Wed,  6 Nov 2024 14:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730902301; cv=none; b=i9nDj7dXm7p7L8A7M3fx16qkPQH7eDXMoH4sa1Jf/quOUhm8NgL1pZRxRj+bvxGXbu0K/9wtg7PBMubrSxIOsT6EfmDLzXYGeo4pei5ofoxFYNB9vENti6gkyvRZw9IiqMWHtRrI/grYol5F2LNGjdBvfQv31qeMcAUas8aOetw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730902301; c=relaxed/simple;
	bh=0XcMLKxlQrw5C+8/ecJTcOYO4V8xUwsJw8tuO2G/QIM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mHwFFIJB7a3Hrwpd/vpXCd0oExUlNhcEUjntN5cdod7JHlVS6C4/l9mhrORaX2wElb6C6z39s24flmL2eT3SLW23Y1PNP6Caq6QkuuYqGOe7ZpH9CTDQrv8mowuMYFFsInbMuVEf75QwcgZhfsFNRg3ln5zxvrBo3AGtpHXPThs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n67AyePp; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-83ab94452a7so284199439f.3
        for <io-uring@vger.kernel.org>; Wed, 06 Nov 2024 06:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730902298; x=1731507098; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/v3+1CD1zkiIKugXAd7QtzaltBjAUDdyHcQ+nF9s83k=;
        b=n67AyePpwD1hIgQ8eiOMA3gRccdgeNeisAtYdlsdz3PlLfbnbBXv/NfMuTvZGyIPVw
         UVQ7pAz4r0vIpLuHDN6pfd4mWvxsL77ZzXpiBDsvvlErDG0i4Jz7/tbME45NJ5XNrbLo
         fCM+LWZs8qqYAFFooZ/TyqiRpO96iWYhrV5EcEaxozNr7+2RoUWcwaFIOodDJy6N70CL
         IWNxQSLIWxeXz2TEiwRGg6fBx/IJekMcNrwH+L7Jiopgd16Ln2DwqW82zPfu3BlkNbdu
         DY57XdjVXK8ADJYzVg3a9CNVyBNbZKzVsB0vB7+CTb5DvirGoZM92t+kgD0Q2SGgQV+s
         4B7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730902298; x=1731507098;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/v3+1CD1zkiIKugXAd7QtzaltBjAUDdyHcQ+nF9s83k=;
        b=QUx18Sltg2NCODiX9o7dEG4xfnCRElhKxT7fFlZylLZSfmUZWxYjntcHb0ZOCsY1IL
         1VFoxnMmlFfAefHlKMNMA+LTSrEt2i6OgQwIY38yZjP7QlZGKP/w9zjsXx9QPCruR9qU
         fbR5zOJQl0tw1FxPpd3NwSEoeMxXZs/6FqglP+FpCoXP7FlTpbBZ8alLFI2TW06psqhu
         VXwYUXAQ2svgLNHv/J/AOykaOeaXOtE15LuA5WsAYQCnBu8qPV+i43VF2PSVoT2pYkky
         LV+i5UjWIrI3CFQqRzJyCbX2qpt2HdAbXisEFwqeTmpnbpZ0WT88dihLcfm8zA8Tw8He
         qooQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDuQ+beMEbN3zRxsGSMjCdxOmo5I39PELCzpygSs/8nV4Co+8DLs36gVh1LNkwIJhZOryXyoi04A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyQmrpObesvrN+l5P8Km328IESHS65gurt81aYwVzH0KuYcc1gr
	Y9BxiKLWlX7Kv2AYj/xwiqPchjhKG70yGCvjdzCNvXtsChsIpa/w+HGkQMsB0KM=
X-Google-Smtp-Source: AGHT+IE2d4o3hCxgkh0OwFEymLimuz4K+2YCjShLapsO4FRw+4RpGbBWdXRFnZNBEzOVy1jWbcvTBw==
X-Received: by 2002:a05:6602:3427:b0:83b:2da6:239a with SMTP id ca18e2360f4ac-83b567a0614mr2568382039f.15.1730902295867;
        Wed, 06 Nov 2024 06:11:35 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-83b67c7d81dsm319718539f.37.2024.11.06.06.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 06:11:34 -0800 (PST)
Message-ID: <f4bfc61b-9fe6-466a-a943-7143ed1ec804@kernel.dk>
Date: Wed, 6 Nov 2024 07:11:33 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Stable backport (was "Re: PROBLEM: io_uring hang causing
 uninterruptible sleep state on 6.6.59")
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Keith Busch <kbusch@kernel.org>,
 Andrew Marshall <andrew@johnandrewmarshall.com>, io-uring@vger.kernel.org,
 stable <stable@vger.kernel.org>
References: <3d913aef-8c44-4f50-9bdf-7d9051b08941@app.fastmail.com>
 <cc8b92ba-2daa-49e3-abe6-39e7d79f213d@kernel.dk>
 <ZygO7O1Pm5lYbNkP@kbusch-mbp>
 <25c4c665-1a33-456c-93c7-8b7b56c0e6db@kernel.dk>
 <c34e6c38-ca47-439a-baf1-3489c05a65a8@kernel.dk>
 <2024110620-stretch-custodian-0e7d@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2024110620-stretch-custodian-0e7d@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/24 11:05 PM, Greg Kroah-Hartman wrote:
> On Sun, Nov 03, 2024 at 07:38:30PM -0700, Jens Axboe wrote:
>> On 11/3/24 5:06 PM, Jens Axboe wrote:
>>> On 11/3/24 5:01 PM, Keith Busch wrote:
>>>> On Sun, Nov 03, 2024 at 04:53:27PM -0700, Jens Axboe wrote:
>>>>> On 11/3/24 4:47 PM, Andrew Marshall wrote:
>>>>>> I identified f4ce3b5d26ce149e77e6b8e8f2058aa80e5b034e as the likely
>>>>>> problematic commit simply by browsing git log. As indicated above;
>>>>>> reverting that atop 6.6.59 results in success. Since it is passing on
>>>>>> 6.11.6, I suspect there is some missing backport to 6.6.x, or some
>>>>>> other semantic merge conflict. Unfortunately I do not have a compact,
>>>>>> minimal reproducer, but can provide my large one (it is testing a
>>>>>> larger build process in a VM) if needed?there are some additional
>>>>>> details in the above-linked downstream bug report, though. I hope that
>>>>>> having identified the problematic commit is enough for someone with
>>>>>> more context to go off of. Happy to provide more information if
>>>>>> needed.
>>>>>
>>>>> Don't worry about not having a reproducer, having the backport commit
>>>>> pin pointed will do just fine. I'll take a look at this.
>>>>
>>>> I think stable is missing:
>>>>
>>>>   6b231248e97fc3 ("io_uring: consolidate overflow flushing")
>>>
>>> I think you need to go back further than that, this one already
>>> unconditionally holds ->uring_lock around overflow flushing...
>>
>> Took a look, it's this one:
>>
>> commit 8d09a88ef9d3cb7d21d45c39b7b7c31298d23998
>> Author: Pavel Begunkov <asml.silence@gmail.com>
>> Date:   Wed Apr 10 02:26:54 2024 +0100
>>
>>     io_uring: always lock __io_cqring_overflow_flush
>>
>> Greg/stable, can you pick this one for 6.6-stable? It picks
>> cleanly.
>>
>> For 6.1, which is the other stable of that age that has the backport,
>> the attached patch will do the trick.
>>
>> With that, I believe it should be sorted. Hopefully that can make
>> 6.6.60 and 6.1.116.
> 
> Now queued up, thanks.

Thanks Greg!

-- 
Jens Axboe

