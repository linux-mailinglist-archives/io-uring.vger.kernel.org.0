Return-Path: <io-uring+bounces-6898-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9E7E5A4A82C
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 03:40:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF24E189D139
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31BF51B423C;
	Sat,  1 Mar 2025 02:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vMyUBXUl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DAC1AF0D7
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 02:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740796804; cv=none; b=h+62ta+QKS5N/oehr1GSGxvXee2F+4EBHaFLCXI/Xf9zdseuJOaN+PW0Hc/40d0Q5mfiq4NpxEMR+cwFb0+u6p/XxQjZ65mcq6G7W3qkJpHCuxf7h2ff6D8jTjuZ6XpkFoqrVeFTFPUMRBvmemdqWR4eS1lmUTEy+4fNNi4/Dt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740796804; c=relaxed/simple;
	bh=Mu0AqRTs71+O4ZL7Ejz5NC8MISRenfVb8w/b/9DUVpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rYKqsZBUbZ8aqysRS6bjp5TwKbRp36UXmfQ4LXj1Qdc0YZlI05h2X2R+Vl9KGVcUo+AwEKmhpZD1WjRvpE4oR+liwozdpaPCTAwmE/dJP5Tkg2LjB2/K+JRYrNUqhT+D2mJgYx6i/TwD/kQa6jomZGsw+G7Wptecj3cyJjF/+tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vMyUBXUl; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e60cc2bf4bfso117290276.2
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 18:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1740796800; x=1741401600; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mTT8WGltm4Dm/gCHQDcFN8Fg2LvBIpXMtNhU/3XIc/I=;
        b=vMyUBXUlDcvGZcPhWWyTCDCJZmiQR5ske+ARPaNNh9cBMLc9v4Mrhvd1p55XAOf0cI
         GTUFg2PBnB9Mt3Wlnt7EkFaFHI/xmOjmPYOmDLU6d0vsNd0UdPXeBPMwPx7II6jiJEci
         kHnJRB7QcJWetHsXp2dpuVKPQtGAE+omiHA++jqXtk+jE8WDU1EoQ5Wev9F4Jw7sNXlI
         QPmZnq4c+MePDvonjlEMYMnaD5J599N37LrkLc/g2YPCJ3hveFFJIaJj2Eqg8lb/X+13
         80x6O89O1aD347hgJZxxaBdongCiAhkYoW5RxMmygoAvePLkfVJUNyDxIOTV5Wqy9H3c
         4Ltw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740796800; x=1741401600;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mTT8WGltm4Dm/gCHQDcFN8Fg2LvBIpXMtNhU/3XIc/I=;
        b=pHarpq+AFKcFjpIUhrNNfygefhfp/XA1ihgH9mGKO0WhMU73abwlUzmmr3qdz3M5VX
         WOK3BVGjMcbrEU3C5uvCoRGTKvJ50cNZOho9o79kgRLO3dNMoqozxhvrNjApEFzH7E/U
         Ixhp0cZv+5T0Ur6aSDCqFLTCJIDWW1So1q6YKcdhBnkI5qOsKvjgx6Mgy95395RusTRd
         XfNZod45u1mQy3IkpxVQfG0xsNRDTqh/sSB2X4SJXdOmfZSLULSpV+ngswMlK74Yy5f+
         tSlAUEnkwihZKIdTgy8m9Zw3Nm498jrdb0AJS1YqKfZb+uNtlZdmgy1UwvICgMYoF328
         aGlQ==
X-Gm-Message-State: AOJu0YzUAx9x9GC7Fi4TXkYTIyjh4bSYXskZ1dBmpelVhc3UQvd1HQ/j
	vu0Q8A/cXqi1j3OPCEPp2iQ77B/QTfed3n3OoesYrvTPYcBgGQbqlBKWI9j4XpY=
X-Gm-Gg: ASbGnctQ53XjUYfuUmBmxeFwMAvwcz0TEXHMAnZCpZ8Rl40NoZRFOi41t6mBr8Q8ohi
	bgORH340cqrwq6pLA37ZrBc0JqB5wUqasiQDlJEnPFQdhVxg+mYzOTAmztCrse1mSmP9b0lfJNH
	V9GA5ZKqAreKJo+uz5bm87DFNuPN9fWwHsBzWpalPS8eIIQMoB4Hm6CC1Ms7PzF3mluYKtdF4Vv
	W/YjcHkjwSvXziPeb1UtHtfHcmKfCKVYIY0GlzzdYIO1hKYVp6PrVsj3A1PjldPkatbGMcs2MzG
	0M4BuHrhS1s2/+BV4lqMU8gLTETHqdDYdiD2s2QtIUl9
X-Google-Smtp-Source: AGHT+IFYDOUnqgJ1t5zIgrLUj/0oAAoKCElY94mw9gYV/2yrxIPC9Q7QtmZFVjioz3HiwDarrlr9DQ==
X-Received: by 2002:a05:6902:2210:b0:e60:9821:32 with SMTP id 3f1490d57ef6-e60b2e9cb54mr6490919276.20.1740796800361;
        Fri, 28 Feb 2025 18:40:00 -0800 (PST)
Received: from [192.168.21.25] ([207.222.175.10])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e60a3ab1265sm1430507276.57.2025.02.28.18.39.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Feb 2025 18:39:59 -0800 (PST)
Message-ID: <8d7b4723-a5b0-49ce-8f9b-32bb1acb3592@kernel.dk>
Date: Fri, 28 Feb 2025 19:39:59 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] io_uring/nop: use io_find_buf_node()
To: Pavel Begunkov <asml.silence@gmail.com>,
 Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250301001610.678223-1-csander@purestorage.com>
 <20250301001610.678223-2-csander@purestorage.com>
 <d4271290-2abb-49ee-a99a-bc8bb6dde558@gmail.com>
 <e84d5e50-617b-421e-bed6-628cacc28cf9@gmail.com>
 <524be10f-c873-40f1-91b7-ae597dadcca0@kernel.dk>
 <cc3a3a35-ab5d-45ac-9f0e-963632c872e4@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <cc3a3a35-ab5d-45ac-9f0e-963632c872e4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/28/25 7:36 PM, Pavel Begunkov wrote:
> On 3/1/25 02:21, Jens Axboe wrote:
>> On 2/28/25 7:15 PM, Pavel Begunkov wrote:
>>> On 3/1/25 01:41, Pavel Begunkov wrote:
>>>> On 3/1/25 00:16, Caleb Sander Mateos wrote:
>>>>> Call io_find_buf_node() to avoid duplicating it in io_nop().
>>>>
>>>> IORING_NOP_FIXED_BUFFER interface looks odd, instead of pretending
>>>> to use a buffer, it basically pokes directly into internal infra,
>>>> it's not something userspace should be able to do.
>>>>
>>>> Jens, did use it anywhere? It's new, I'd rather kill it or align with
>>>> how requests consume buffers, i.e. addr+len, and then do
>>>> io_import_reg_buf() instead. That'd break the api though, but would
>>>> anyone care?
>>>
>>> 3rd option is to ignore the flag and let the req succeed.
>>
>> Honestly what is the problem here? NOP isn't doing anything that
>> other commands types can't or aren't already. So no, it should stay,
> 
> It completely ignores any checking and buffer importing stopping
> half way at looking at nodes, the behaviour other requests don't
> do. We can also add a request that take a lock and releases it
> back because other requests do that as well but as a part of some
> useful sequence of actions.

Let's not resort to hyperbole - it's useful to be able to test (and
hence quantify) provided buffer usage. I used it while doing the
resource node rework. We also have a NOP opcode to be able to test
generic overhead for that very reason. For testing _io_uring_
infrastructure it was already useful for me. Of course we should not add
random things that test things like lock acquire and release, that's not
the scope of NOP.

Sure you could add import as well, but a) nop doesn't touch the data,
and b) that's largely testing generic kernel infrastructure as well.

The whole point of NOP is to be able to test io_uring infrastructure.

-- 
Jens Axboe

