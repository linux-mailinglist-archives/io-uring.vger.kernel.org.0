Return-Path: <io-uring+bounces-2737-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DF7C94FBA2
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 04:09:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D221F1F21E7E
	for <lists+io-uring@lfdr.de>; Tue, 13 Aug 2024 02:09:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE4D6AB8;
	Tue, 13 Aug 2024 02:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="C3NCF45k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE8E17588
	for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 02:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723514976; cv=none; b=oMNx8Yl5BHOH9FcpW5hpj///iy+YqZ0eosuP+sJAz5uiiURSipwK2xC7svfXDzOYUdBNxxvFNcOKeC7Ia56jposId3z9qdaeGhNBCAkp8jZWLx14IpM4H5jqE4yC7xbXh52Q1BOsL5I0zCAzGzOlwjMD5RkKlx89vT/62OKLBC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723514976; c=relaxed/simple;
	bh=eGP2gZg5E9T11l9O6PmnURJPC9eJl+HRjyXJdEavFiU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hsRZPSO9w/XuQTj/G3Qfpwv5DXNnEhMrMgemnIEuJWwHlnBKXuDyUgilYYQrKySOO/lEa20W4fPWLyOdzwPm6aOq/AY+fvZWZ9fOkKRk1Sjtm9Ctb9wUbzigokde4Ghr6WsUENij2ZMp9z5uidkUjvrRGDREHHDG7au/l4XwbXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=C3NCF45k; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2cb77ecd7a2so936234a91.1
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 19:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723514971; x=1724119771; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M4XCxFgjMdE6cYqmWfbX8hf488/P1ImmiPJMG5j8bck=;
        b=C3NCF45kSwE0m5KE3yCeMOzBOyRc1G5GD/CxpYM0falygDVsIclJFxfezefbmwYprD
         xPV1PH+SH2wlxzB5l7T/4oYGStF6995Fa7L6R6GcBBE/UGaOFPMeBT5eaQp74us96UN0
         yPmWCe1h7juJCALC2RnRnoYcxVL9dfs+i59zzbXGmGS6sMJw0BE4Q9gdN39eGLB0KwSX
         ItX6L7KuBQ1+4mnFGzi9kMMcF9g/JB/pudoVTBqmKCiX9/NoY+02GQdPKpPNXRgHbCTo
         Hnstrgp5nC1ILls8kGQBBQPOodR2B56kAgst+l8HcN9EjB8w1PluN4wjDTodKbrdsCA6
         OckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723514971; x=1724119771;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M4XCxFgjMdE6cYqmWfbX8hf488/P1ImmiPJMG5j8bck=;
        b=WquGppCyJ5cE1qFzDnTYPvW5x9FeZ9/0auewWMH7SDvcjheRoJMyL7KnFl3/yPcHM0
         Dx9uAHSPC9pvBANxDouS7i9W1OnJNxHHQXp0Q48k8rTdVguELXMwmnr14vVCa+3abjaN
         jFCDCI/T27KVZHLLOJ2c0/1asSzXpW1wIrnR74km7SPdQZZOvsX5EEQlAC2Rh1EHBeaE
         3+siCsYOUZynona/y9h2kjMaINnuCFrL7Yy707zHJkNUzp9uud+RfxjjE9TNzrIk5d+3
         SsMTpA10/LS7BujAmiy2iBz7Ly9TEF9ZFbFGA3m7mJUqQA2HwPcIYRCgLVgKx+peRcSW
         IJcA==
X-Forwarded-Encrypted: i=1; AJvYcCWUpNxyu01W0bK3+Ir179vMIBeajvVfQol6aeZj6rpMybvVoaeGUvgpHHnu78ZaswLwfqGa2bvlow==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyx3noqmgfUG7AM9qjZsWreaZgp2/9jGT3ZFtuJvfKBVE3FKnLi
	Ts3slHYxvtXU8eHrGmo40Tp1y7F0PO1pgQoNKte1b7JErSoLHVTEK+kj76cRIcI27v4B9gijdNS
	k
X-Google-Smtp-Source: AGHT+IGRXPhF7IvjEXjk4+MlAMrfvPT1oRYFwMU1Pto11hIRmFyeVxj2lzcwgAefaBn6Bnu27DAJXA==
X-Received: by 2002:a17:902:f0cb:b0:1fb:1cc3:647b with SMTP id d9443c01a7336-201cdae175fmr5068535ad.5.1723514971504;
        Mon, 12 Aug 2024 19:09:31 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1304a9sm3198055ad.58.2024.08.12.19.09.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Aug 2024 19:09:30 -0700 (PDT)
Message-ID: <666bd7b9-a927-40eb-858b-20dc194639ab@kernel.dk>
Date: Mon, 12 Aug 2024 20:09:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/4] clodkid and abs mode CQ wait timeouts
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc: Lewis Baker <lewissbaker@gmail.com>
References: <cover.1723039801.git.asml.silence@gmail.com>
 <98f30ada-e6a9-4a44-ac93-49665041c1ff@kernel.dk>
 <6ad98d50-75f4-4f7d-9062-75bfbf0ec75d@kernel.dk>
 <61b2c7c1-7607-4bd9-b430-b190b6166117@gmail.com>
 <78d5648d-7698-44b9-ab66-6ef1edee40ad@kernel.dk>
 <0b661e9c-1625-4153-93b8-d0e03fea81dd@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <0b661e9c-1625-4153-93b8-d0e03fea81dd@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/12/24 7:32 PM, Pavel Begunkov wrote:
> On 8/13/24 01:59, Jens Axboe wrote:
>> On 8/12/24 6:50 PM, Pavel Begunkov wrote:
>>> On 8/12/24 19:30, Jens Axboe wrote:
>>>> On 8/12/24 12:13 PM, Jens Axboe wrote:
>>>>> On 8/7/24 8:18 AM, Pavel Begunkov wrote:
>>>>>> Patch 3 allows the user to pass IORING_ENTER_ABS_TIMER while waiting
>>>>>> for completions, which makes the kernel to interpret the passed timespec
>>>>>> not as a relative time to wait but rather an absolute timeout.
>>>>>>
>>>>>> Patch 4 adds a way to set a clock id to use for CQ waiting.
>>>>>>
>>>>>> Tests: https://github.com/isilence/liburing.git abs-timeout
>>>>>
>>>>> Looks good to me - was going to ask about tests, but I see you have those
>>>>> already! Thanks.
>>>>
>>>> Took a look at the test, also looks good to me. But we need the man
>>>> pages updated, or nobody will ever know this thing exists.
>>>
>>> If we go into that topic, people not so often read manuals
>>> to learn new features, a semi formal tutorial would be much
>>> more useful, I believe.
>>>
>>> Regardless, I can update mans before sending the tests, I was
>>> waiting if anyone have feedback / opinions on the api.
>>
>> I regularly get people sending corrections or questions after having
>> read man pages, so I'd have to disagree. In any case, if there's one
> 
> That doesn't necessarily mean they've learned about the feature from
> the man page. In my experience, people google a problem, find some
> clue like a name of the feature they need and then go to a manual
> (or other source) to learn more.
> 
> Which is why I'm not saying that man pages don't have a purpose, on
> the contrary, but there are often more convenient ways of discovering
> in the long run.

In my experience, you google if you have very little clue what you're
doing, to hopefully learn. And you use a man page, if whatever API you're
using has good man pages, if you're just curius about a specific
function. There's definitely a place for both.

None of that changes the fact that the liburing man pages should
_always_ document all of the API.

>> spot that SHOULD have the documentation, it's the man pages. Definitely
>> any addition should be added there too.
>>
>> I'd love for the man pages to have more section 7 additions, like one on
>> fixed buffers and things like that, so that it would be THE spot to get
>> to know about these features. Tutorials always useful (even if they tend
>> often age poorly), but that should be an addition to the man pages, not
> 
> "tutorials" could be different, they can be kept in the repo and
> up to date. bpftrace manual IMHO is a good example, it's more
> 'leisurely' readable, whereas manual pages need to be descriptive
> and hence verbose to cover all edge cases and conditions.
> 
> https://github.com/bpftrace/bpftrace/blob/master/man/adoc/bpftrace.adoc

Yeah that'd be fine too, the closer to the repo, the better. And maybe
that can replace section 7 man pages, we are sorely missing some
descriptions of idiomatic usage of various features. That kind of thing
is hard to learn in a man page.

-- 
Jens Axboe


