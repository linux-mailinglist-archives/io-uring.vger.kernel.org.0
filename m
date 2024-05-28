Return-Path: <io-uring+bounces-1983-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E5F108D2350
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 20:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 523001F23722
	for <lists+io-uring@lfdr.de>; Tue, 28 May 2024 18:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA9F21E861;
	Tue, 28 May 2024 18:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MfdjkopZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F898175AB
	for <io-uring@vger.kernel.org>; Tue, 28 May 2024 18:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716921074; cv=none; b=tvnCVRgeovTBl/qXzDtXmeGHoO6VJ6NIIGFLpvQ3sfq/n2t0X8J59wOPBK0nJIX0w/DQhuLA2K/O72CNowXXvRFhAipq9OVenz235z5eZJpO9xvkB4LHWcc2BZE5MJ+RCnczGFHugWaMZb0AYqzRhpzNAzKqcYyLHCj0I7M5oPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716921074; c=relaxed/simple;
	bh=7P5z87uunQPhkSI4FyAKEKk4tJBGkg8yfzUJ1fmDRQk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=MCzAT4n0IKXB6SVwVDe+s5s92VoK75KdDnWVGPKCqLxhKFI/7oEpWWEcc+cWcToTSO5EcIqjvjuP1uH81WfmU2R/60yDH48qpl7CGFR3IRAiSBVTBfhxOJnMg9J9i82c4xp2WADZsHMaofr7JeZb1RQnFv2hxv9UTSZazBhLL28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MfdjkopZ; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5b97f09cde3so196323eaf.0
        for <io-uring@vger.kernel.org>; Tue, 28 May 2024 11:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1716921070; x=1717525870; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=byqfuFeA+CxmJfcjghViFapreBAQQHvR7moNVtlkczE=;
        b=MfdjkopZOhfzQIeLRkS0Gw4OAke4zApuxrDfqHCBVbhAnoD5EXh5u5B9OtY9WJLOBQ
         h2MMnttP9xm6JIYiW1lLpvZWvX+cgtA1aF+udYBm3hj0VGI8trdehPJjWh0ULWVJ39UI
         OXhGzrE8BzNX9x6ll9L/GURyZJOJ56qI3ELmcoQAmP/V+QMO3iH//GVJtDNyaQFNvwPS
         4EyFTD0k/RiFaI3T8VB71DQv4rj1u3TO3/lCqs88k1K/jstnpjxLRF7UdjDW8aQfTWC7
         rfUk/FE17P8Ib7bJCHqpHCLnCypV+Lrfo9dHGVjYeFENcEdNIlakWgZsTjtSbCELppIj
         Ac8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716921070; x=1717525870;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=byqfuFeA+CxmJfcjghViFapreBAQQHvR7moNVtlkczE=;
        b=bkk30MNwLw6cFbHG6FVH6SFo+hlT2GMSUZotT1Y+2YY9S/n6uL3nd+bmOy+ve27ur4
         Tqi8IX7iySrQWiktvHNl//dfeBDlvIthOUIryou1X0p4G42f15kuJieMqV2QOWGp4rDg
         yrXpXsIAX5E8lP1YTEE+lxzAWcpXdo9PYrEI6LOCJz1greGN/T5n/Rth9OAvPbYzx0fU
         ELL3wY1RNaMzDRmkv8XoKWpff5DmizlQcceXY8+Bh2ghRb5WZDLRa0VHm2WFLZwIa2Vd
         9hvQdWy6nfBFaW9cQKEn1srVUAZZRdbTOqbVxlUZs0UeKLWbu2MA/FpkgLMOOScL5vTr
         3cfw==
X-Forwarded-Encrypted: i=1; AJvYcCVDeC9mGu4pevtB39Eth/MzmNAMJ9LOCUMJIbuT7pB2yvoJvHhpseknOOrph8z+pwOASxQpGEMDAH0ZstSeRXiem6mps/evMRo=
X-Gm-Message-State: AOJu0Yz5jVX2KPNhhvUA0qJW87KyMc/wZS1eEEiard9i8y1Fkx8Z5jyg
	gu0UFu3kB39SzJUBkwhBTSP6n2iK1lX6A6T23H4MxHEyH+2SkNivTB+ZjLEG6TU=
X-Google-Smtp-Source: AGHT+IHitKB802KqgLJjnT3czz4+ppSo8zeze3FZuSM80RKwVJAzfl1AFD+tT3gmPbJQmEdncKYb3g==
X-Received: by 2002:a54:4507:0:b0:3d1:d35b:8174 with SMTP id 5614622812f47-3d1d35b826amr919211b6e.2.1716921070158;
        Tue, 28 May 2024 11:31:10 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b36dd0c3sm1441565b6e.28.2024.05.28.11.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 May 2024 11:31:09 -0700 (PDT)
Message-ID: <d86d292a-4ef2-41a3-8f54-c3a1ff0caad7@kernel.dk>
Date: Tue, 28 May 2024 12:31:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/3] Improve MSG_RING SINGLE_ISSUER performance
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240524230501.20178-1-axboe@kernel.dk>
 <3571192b-238b-47a3-948d-1ecff5748c01@gmail.com>
 <94e3df4c-2dd3-4b8d-a65f-0db030276007@kernel.dk>
 <d3d8363e-280d-41f4-94ac-8b7bb0ce16a9@gmail.com>
 <35a9b48d-7269-417b-a312-6a9d637cfd72@kernel.dk>
Content-Language: en-US
In-Reply-To: <35a9b48d-7269-417b-a312-6a9d637cfd72@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/28/24 12:07 PM, Jens Axboe wrote:
> On 5/28/24 10:50 AM, Pavel Begunkov wrote:
>> On 5/28/24 15:34, Jens Axboe wrote:
>>> On 5/28/24 7:31 AM, Pavel Begunkov wrote:
>>>> On 5/24/24 23:58, Jens Axboe wrote:
>>>>> Hi,
>>>>>
>>>>> A ring setup with with IORING_SETUP_SINGLE_ISSUER, which is required to
>>>>
>>>> IORING_SETUP_SINGLE_ISSUER has nothing to do with it, it's
>>>> specifically an IORING_SETUP_DEFER_TASKRUN optimisation.
>>>
>>> Right, I should change that in the commit message. It's task_complete
>>> driving it, which is tied to DEFER_TASKRUN.
>>>
>>>>> use IORING_SETUP_DEFER_TASKRUN, will need two round trips through
>>>>> generic task_work. This isn't ideal. This patchset attempts to rectify
>>>>> that, taking a new approach rather than trying to use the io_uring
>>>>> task_work infrastructure to handle it as in previous postings.
>>>>
>>>> Not sure why you'd want to piggyback onto overflows, it's not
>>>> such a well made and reliable infra, whereas the DEFER_TASKRUN
>>>> part of the task_work approach was fine.
>>>
>>> It's not right now, because it's really a "don't get into this
>>> condition, if you do, things are slower". And this series doesn't really
>>> change that, and honestly it doesn't even need to. It's still way better
>>> than what we had before in terms of DEFER_TASKRUN and messages.
>>
>> Better than how it is now or comparing to the previous attempt?
>> I think the one using io_uring's tw infra was better, which is
>> where all wake ups and optimisations currently consolidate.
> 
> Better than both - I haven't tested with the previous version, but I can
> certainly do that. The reason why I think it'll be better is that it
> avoids the double roundtrips. Yes v1 was using normal task_work which is
> better, but it didn't solve what I think is the fundamental issue here.
> 
> I'll forward port it and give it a spin, then we'll know.

I suspect a bug in the previous patches, because this is what the
forward port looks like. First, for reference, the current results:

init_flags=3000
Wait on startup
3767: my fd 3, other 4
3768: my fd 4, other 3
Latencies for: Sender
    percentiles (nsec):
     |  1.0000th=[  740],  5.0000th=[  748], 10.0000th=[  756],
     | 20.0000th=[  764], 30.0000th=[  764], 40.0000th=[  772],
     | 50.0000th=[  772], 60.0000th=[  780], 70.0000th=[  780],
     | 80.0000th=[  860], 90.0000th=[  892], 95.0000th=[  900],
     | 99.0000th=[ 1224], 99.5000th=[ 1368], 99.9000th=[ 1656],
     | 99.9500th=[ 1976], 99.9900th=[ 3408]
Latencies for: Receiver
    percentiles (nsec):
     |  1.0000th=[ 2736],  5.0000th=[ 2736], 10.0000th=[ 2768],
     | 20.0000th=[ 2800], 30.0000th=[ 2800], 40.0000th=[ 2800],
     | 50.0000th=[ 2832], 60.0000th=[ 2832], 70.0000th=[ 2896],
     | 80.0000th=[ 2928], 90.0000th=[ 3024], 95.0000th=[ 3120],
     | 99.0000th=[ 4080], 99.5000th=[15424], 99.9000th=[18560],
     | 99.9500th=[21632], 99.9900th=[58624]

and here's with io_uring-msg_ring.1, which is just a straight forward
forward port of the previous patches on the same base as v2:

init_flags=3000
Wait on startup
4097: my fd 4, other 3
4096: my fd 3, other 4
Latencies for: Receiver
    percentiles (nsec):
     |  1.0000th=[ 5920],  5.0000th=[ 5920], 10.0000th=[ 5984],
     | 20.0000th=[ 5984], 30.0000th=[ 6048], 40.0000th=[ 6048],
     | 50.0000th=[ 6112], 60.0000th=[ 6304], 70.0000th=[ 6368],
     | 80.0000th=[ 6560], 90.0000th=[ 6880], 95.0000th=[ 7072],
     | 99.0000th=[ 7456], 99.5000th=[ 7712], 99.9000th=[ 8640],
     | 99.9500th=[10432], 99.9900th=[26240]
Latencies for: Sender
    percentiles (nsec):
     |  1.0000th=[ 9536],  5.0000th=[ 9664], 10.0000th=[ 9664],
     | 20.0000th=[ 9920], 30.0000th=[ 9920], 40.0000th=[10048],
     | 50.0000th=[10176], 60.0000th=[10304], 70.0000th=[10432],
     | 80.0000th=[10688], 90.0000th=[10944], 95.0000th=[11328],
     | 99.0000th=[11840], 99.5000th=[12096], 99.9000th=[13888],
     | 99.9500th=[15424], 99.9900th=[34560]

-- 
Jens Axboe


