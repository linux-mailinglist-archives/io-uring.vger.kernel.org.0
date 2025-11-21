Return-Path: <io-uring+bounces-10722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B08FCC7A168
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 15:17:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 77F424F1A8F
	for <lists+io-uring@lfdr.de>; Fri, 21 Nov 2025 14:05:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15C0F348865;
	Fri, 21 Nov 2025 13:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="W/HjXEkd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2448314D31
	for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 13:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733587; cv=none; b=Crcb8KEU4h/0p632hTY28peoJNNUwaoWPfvlNuTNXdTgG2z5oDph8aCT4U/L1glOxGUalVf5Hr1LGDjYIXRr05xVnEmGufJO0zcqYu4bN7gxWIXKAUw7WxDXLZ5FXO/3sDj31BcOMfBycPXT6qNwWVdRYkzv78brmo9BXJ36PnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733587; c=relaxed/simple;
	bh=k9O/n6KiB6IuqNPJ+w4D24wu7X0pxrXXixl4hRmZKr0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=tTQViAf0Q2Z5hlpd1Ig/dTiwLCNeeI6xZLbK1hOrOWtchXSckrf3nO1p/zhVnBIOs5jHmIEB5AW4+cG9ApqgTWfh0fSM5iIt32puIH5S8PuwWlOP23ZJFhfPPNQCO0TCmG1BnFrCudsuO+gMey8ISSB6icBGUud+rWoQzNHN+qM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=W/HjXEkd; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-9491571438cso87686739f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Nov 2025 05:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763733580; x=1764338380; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LaN6U+hdfKSmLffkO2SeZ23OBfSypde4pzEWpJTI/60=;
        b=W/HjXEkd+hjzrb5ircOS8xYUu0zNYPSyP3ix+sUaz5zEsB67OQx0U4O5/DB54t/PqS
         nGfD4Yw1mZphW51BYb32L/N6+aBFOKoQPbiTTlGo2cEuXxFlf8PaLakSygjkJUqe5vab
         XkQN1fhXc80mZcoEmUTQ4X9jTTNcX2peHDMxB7qVI8j7U5CE/56v+BkDiwWGl5SO0aQz
         shNA2NErIYnyzh9wRRU1jAXSAyYxxm1bWWiPBL8KCzziPP2HqYsVyiC6H+joThSEKCLm
         Sp8E+3tX2jERWWDKgWOw4X/3z2PELXQxV7IpICyoKOP8WKWi0BWX8T6ZHDZSgpaEpSA5
         WF4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763733580; x=1764338380;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LaN6U+hdfKSmLffkO2SeZ23OBfSypde4pzEWpJTI/60=;
        b=med7AGxDu/0RAmWzno8k+XcHJcH1U6grFf66dL34Il7TWgM45DFu/MTuyYVBcdcrlD
         UVG6Njpzvmfrnl0iyBL/hMgejn2XlhyzsmgOpALq8CE2UHvvj8e2MOpmPsBBkcy6aLRv
         hNU3K29msrbHby7bH7P7wlB1V5g006PEaSUSk7QyMKCXuAsk6scKqzt0T7H7inmehtiF
         NVCguKmZaaU4HEALi8iAkz9+yczjQqFDPIGetlNok3eTXO2l7+riMNqr0bCpkzjge90l
         DsHakT3hspsKMSXV5SJmDdoJTyF3o0Im0ETiTgUGHMWHVdM/ygTjN9imaOwbccK5nDru
         YBaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUZdSmcoBeNjDFUFLdGT++yEiLTR6Pd1dh3OFvzXHIxAEhHVA1GwfdNm+7w5+lR48XPN8yeSrK7xQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1u1dpo/flw7LeWwzl0fA7qTyH+Z0spQ5kfGmo1U9jbeg2NbKM
	ZOBS9iRTlPKu41/UuQCpRye0+sWw3NQjtjmwY0MDgcMKjIvYYGq9iyhe1eJbebOL7WnPr1hJrM5
	KhMvl
X-Gm-Gg: ASbGncus0b+EaHqrJJIMgws4Z+WdM1Sm1fmEx9jB55kCrH4DL8j0IYsg/8rlPziAYrK
	4wmlKB9XAnfXvhxxjAKoQtUhLBvWV5cCl4bzow7+H1wphf/4M5T6CL1sqkjEdZuRs72Y5+oPCYQ
	PwQG+CXqMduV1BCKx/9g5L2nc8y0R3Hz4ZsjtBSv0zAafnqGeJIBeNa46hdoF88BfkR2PVBtE5x
	Bs/OhhWPChE9C1cYq4rfSyKHRKNTlTwAlYDO1LFsxYVC56X0CjYqDqM8uv9fYztZ6jkj7Es1wpX
	cqK3UtxdZH6b2yZwUwFZZ0cODTaKBuf/2qxbGB67fmopedgjzTk/q6H76XnlPPPSZCFMT7dzwh5
	Xi4y8EALd5F/zfhYYsjJs8lxeGrdmGYsqDqpvPiKdt3qkipAb6yD01vhGAAY447Qw/UbkbNHA8/
	txSes+yTOm
X-Google-Smtp-Source: AGHT+IHNGqDbsVPTxIZQxXMdTnYz8j9yMg2/XOqgov8n6jpoxDnP4/d0H08lOhePFRFMmzFnSJe4QA==
X-Received: by 2002:a05:6602:6d0e:b0:949:a0c:59d9 with SMTP id ca18e2360f4ac-949488f7c9dmr181984039f.5.1763733580342;
        Fri, 21 Nov 2025 05:59:40 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-949385ada00sm198712239f.3.2025.11.21.05.59.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Nov 2025 05:59:39 -0800 (PST)
Message-ID: <50ea34b3-580d-48d9-a806-256ab6135a02@kernel.dk>
Date: Fri, 21 Nov 2025 06:59:38 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/register: use correct location for
 io_rings_layout
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <64459921-de76-4e5c-8f2b-52e63461d3d4@kernel.dk>
 <7febd726-8744-4d3a-a282-86215d34892f@gmail.com>
 <335af53b-034e-4403-b5e9-5dab46064a1e@kernel.dk>
 <fa3ab544-e9fd-4746-993c-a4d446a4c19a@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <fa3ab544-e9fd-4746-993c-a4d446a4c19a@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/25 6:49 AM, Pavel Begunkov wrote:
> On 11/19/25 20:22, Jens Axboe wrote:
>> On 11/19/25 10:18 AM, Pavel Begunkov wrote:
>>> On 11/19/25 02:36, Jens Axboe wrote:
>>>> A previous consolidated the ring size etc calculations into
>>>> io_prepare_config(), but missed updating io_register_resize_rings()
>>>> correctly to use the calculated values. As a result, it ended up using
>>>> on-stack uninitialized values, and hence either failed validating the
>>>> size correctly, or just failed resizing because the sizes were random.
>>>>
>>>> This caused failures in the liburing regression tests:
>>>
>>> That made me wonder how it could possibly pass tests for me. I even
>>> made sure it was reaching the final return. Turns out the layout was
>>> 0 initialised, region creation fails with -EINVAL, and then the
>>> resizing test just silently skips sub-cases. It'd be great to have
>>> a "not supported, skip" message.
>>
>> Looks like the test runs into -EINVAL, then tries the DEFER case,
>> and then doesn't check for SKIP for that. And then it returns
>> success. I've added a commit for that now, so it'll return 77/SKIP
>> if it does skip.
>>
>> I try to avoid having tests be verbose, unless they fail. Otherwise
>> it's easy to lose information you actually want in the noise. But
>> it certainly should return T_EXIT_SKIP, when it skips!
> 
> Printing when tests are skipped was pretty useful because I
> expect a latest kernel (+configured for testing setup) to be
> to run all tests, and I'd find "test skipped" suspicious by
> default. Certainly a test infra problem, but at least it
> worked.

Depends on why they are skipped - lots of tests skip because they are
given an argument, and they don't support using an argument. When I run
tests I use a bunch of different files/devices, and then you get a lot
of:

Running test pipe.t                                                 0 sec [0]
Running test pipe.t /dev/sda                                        Skipped
Running test pipe.t /dev/nvme1n1                                    Skipped
Running test pipe.t /dev/dm-0                                       Skipped
[...]

for example. And those skips are not interesting at all. The ones that
skip because the kernel doesn't support them, those would be interesting
to dump at the bottom for a better overview.

> At some point it might be great to distinguish when it skips
> because of unsupported io_uring features from when some
> resources are not available.
> 
> On the topic, I've found this in the runner:
> 
> elif [ "${#SKIPPED[*]}" -ne 0 ] && [ -n "$TEST_GNU_EXITCODE" ]; then
>     exit 77
> else
>     echo "All tests passed"
>     exit 0
> fi
> 
> But not sure who would even define TEST_GNU_EXITCODE. It should
> be more helpful to always print skipped tests:
> 
> else
>     echo "Tests: skipped $SKIPPED"
>     echo "All tests passed"
>     exit 0
> fi

Yeah no idea who uses TEST_GNU_EXITCODE... I strongly suspect no one,
and we can just assume 77.

-- 
Jens Axboe

