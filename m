Return-Path: <io-uring+bounces-507-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 17BF9844638
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 18:32:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 96A531F286CD
	for <lists+io-uring@lfdr.de>; Wed, 31 Jan 2024 17:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA97312DD92;
	Wed, 31 Jan 2024 17:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WUQzqWy8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C98312CD86
	for <io-uring@vger.kernel.org>; Wed, 31 Jan 2024 17:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706722345; cv=none; b=En9+53npuL2QkfKg+t1DxijRgywAdVLZtAQwD5bw9R5iO2WMhCypDbQIE4J4OQIwgKfn5KEEXBbqRAzLPVOXa9Ab0j1gD03QrHVPgRfzVycfYMwj+mcnNv+pw1nzGe20vOoXJtsJGM9/ROVukL9UkE5z8NoTDLw6addQ3wCWU2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706722345; c=relaxed/simple;
	bh=0SaEVWhdhnGSv4Ep5v6y8nuokjxY9B/sJClkXqIqLRc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZtlBavO8rWe/KeMdyZ6N9+7XMTLAvuLWbyMD5mezytpSq0pODCckX8Co45MN1Sfdfs/MxCDJRuk3GzQyZiUUDE4R+fQDotRu7eZtbYVK783A9HllZcYJxbeLrfSCfOdT2rS2FquA9tF7v3lcsRm0UWpi90o/izO92NEwLJsTCno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WUQzqWy8; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7bff8f21b74so307739f.0
        for <io-uring@vger.kernel.org>; Wed, 31 Jan 2024 09:32:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706722341; x=1707327141; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2gQfzZoAy+pSKd15cnbfx2mz7HpIq3ATBZhOepN8vPM=;
        b=WUQzqWy8uI3hfOuxuYjmrPM7w//1wN1pVmCgjrXoqIDffKgtq5pV0bIMhCAiTBlYeU
         m/jkgGs77MlKaGgkD9UWCzr+cHwp62Gcs2+rIWDPzTLmeA2VRCexuWfgfm5jlHA7h4z+
         vt/08lbDVzijMupVDrtpCfNWm5HLH3nuR7FlbTqwmkExOGP6FlgD+H7vbdNHVBj/1i9s
         J2h8Ujm0qIAfO8CrO++s2FFALuREixSebEqlhiY3qis3I5Y4+G/RQopcKqP+NgghuJWY
         Nc/6eVnHZeChccxv7OlaP0GVAXRemqWw5G3R1tHNMXg9DpPmV0JZW1/A3H/3td1R5HZh
         r4Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706722341; x=1707327141;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2gQfzZoAy+pSKd15cnbfx2mz7HpIq3ATBZhOepN8vPM=;
        b=H8yxfAL4R5RLbkwrMMxFGrVaPwiBJ3AJdG5WLsRH0z9uq+mz0/2way5IeSb1nTUhR5
         CU0Dxm9AgBEfBasXMTjy6wwR4PSK4keVSVGeZc4QTZCJM5q0DDigqd0BxgdVfeq32jgM
         yZ8KbSQy+1PfrYYqOMBFXyTmIykC/7Rf1GgqcXhhwZBeVDJA709xAeDAJY6OlMQya7S+
         ntC6xmHT611at1+I8y6HjH7O6F8KVhKZNxDoNgjoREib1gB5rz4Z3QfSkMd8OV6lzi+E
         lplQyKjBSps1BDoitG+StZbebwPz2LtoZwpK9ewnafCtpOFvK9u4zBBVrinxUwr+MH21
         zhrg==
X-Forwarded-Encrypted: i=0; AJvYcCUHc4nZBYI4Hs13yyKKNimfFNhjyGSBUHKVIe+6PqV/kKAmbbk9dwPnlSfm7ctF3Y9tLjR7w/6de9K2jC5AmvzhHysxGGuWDdM=
X-Gm-Message-State: AOJu0Yy+bw7nsl7E0RHZ/mEjWQt4mKmo1EuyMpH6eT+jWzFK27aAQ00/
	IbMRQjFJIT4Ee2g1rn+NEF5i3gq66lvYSBaS7zx5Gk8XP7oOCmuQ0nHUNAbQ34w=
X-Google-Smtp-Source: AGHT+IGpVlFwH9/Hc19GfXukqJyhsC2B8IO3awxEE50EnH41fCkfDZI9YyKSAs4LKgpcCNWqGTbEhA==
X-Received: by 2002:a05:6602:2bd7:b0:7bc:207d:5178 with SMTP id s23-20020a0566022bd700b007bc207d5178mr251240iov.2.1706722341153;
        Wed, 31 Jan 2024 09:32:21 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id f35-20020a0284a6000000b0046e9a5435a7sm2998801jai.138.2024.01.31.09.32.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 Jan 2024 09:32:20 -0800 (PST)
Message-ID: <b6dc538a-01eb-4f87-a9d4-dea17235ff85@kernel.dk>
Date: Wed, 31 Jan 2024 10:32:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v15 0/7] io_uring: add napi busy polling support
Content-Language: en-US
To: Olivier Langlois <olivier@trillion01.com>,
 Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com
Cc: ammarfaizi2@gnuweeb.org, netdev@vger.kernel.org, kuba@kernel.org
References: <20230608163839.2891748-1-shr@devkernel.io>
 <58bde897e724efd7771229734d8ad2fb58b3ca48.camel@trillion01.com>
 <2b238cec-ab1b-4160-8fb0-ad199e1d0306@kernel.dk>
 <45a21ffe4878d77acba01ec43005c80a83f0e31a.camel@trillion01.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <45a21ffe4878d77acba01ec43005c80a83f0e31a.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/31/24 10:22 AM, Olivier Langlois wrote:
> On Tue, 2024-01-30 at 15:59 -0700, Jens Axboe wrote:
>> On 1/30/24 2:20 PM, Olivier Langlois wrote:
>>> Hi,
>>>
>>> I was wondering what did happen to this patch submission...
>>>
>>> It seems like Stefan did put a lot of effort in addressing every
>>> reported issue for several weeks/months...
>>>
>>> and then nothing... as if this patch has never been reviewed by
>>> anyone...
>>>
>>> has it been decided to not integrate NAPI busy looping in io_uring
>>> privately finally?
>>
>> It's really just waiting for testing, I want to ensure it's working
>> as
>> we want it to before committing. But the production bits I wanted to
>> test on have been dragging out, hence I have not made any moves
>> towards
>> merging this for upstream just yet.
>>
>> FWIW, I have been maintaining the patchset, you can find the current
>> series here:
>>
>> https://git.kernel.dk/cgit/linux/log/?h=io_uring-napi
>>
> 
> test setup:
> -----------
> - kernel 6.7.2 with Jens patchset applied (It did almost work as-is
> except for modifs in io_uring/register.c that was in
> io_uring/io_uring.c in 6.7.2)
> - liburing 2.5 patched with Stefan patch after having carefully make
> sure that IORING_REGISTER_NAPI,IORING_UNREGISTER_NAPI values match the
> ones found in the kernel. (It was originally 26,27 and it is now 27,28)
> - 3 threads each having their own private io_uring ring.
> 
> thread 1:
> - use SQ_POLL kernel thread
> - reads data stream from 15-20 TCP connections
> - enable NAPI busy polling by calling io_uring_register_napi()
> 
> [2024-01-31 08:59:55] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 3(fd 43), napi_id:31
> [2024-01-31 08:59:55] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 8(fd 38), napi_id:30
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 10(fd 36), napi_id:25
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 14(fd 32), napi_id:25
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 12(fd 34), napi_id:28
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 2(fd 44), napi_id:31
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 16(fd 30), napi_id:31
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 9(fd 37), napi_id:31
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 20(fd 26), napi_id:31
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 1(fd 45), napi_id:30
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 6(fd 40), napi_id:28
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 13(fd 33), napi_id:25
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 22(fd 22), napi_id:25
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 7(fd 39), napi_id:30
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 18(fd 28), napi_id:28
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 19(fd 27), napi_id:25
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1028
> LWS_CALLBACK_CLIENT_ESTABLISHED client 23(fd 21), napi_id:31
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 4(fd 42), napi_id:31
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 5(fd 41), napi_id:25
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 21(fd 24), napi_id:31
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 17(fd 29), napi_id:30
> [2024-01-31 08:59:56] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 15(fd 31), napi_id:28
> [2024-01-31 08:59:57] INFO WSBASE/client_established 1010
> LWS_CALLBACK_CLIENT_ESTABLISHED client 11(fd 35), napi_id:30
> [2024-01-31 09:00:14] INFO WSBASE/client_established 1031
> LWS_CALLBACK_CLIENT_ESTABLISHED client 24(fd 25), napi_id:30
> 
> thread 2:
> - No SQ_POLL
> - reads data stream from 1 TCP socket
> - enable NAPI busy polling by calling io_uring_register_napi()
> 
> [2024-01-31 09:01:45] INFO WSBASE/client_established 1031
> LWS_CALLBACK_CLIENT_ESTABLISHED client 25(fd 23), napi_id:31
> 
> thread 3:
> - No SQ_POLL
> - No NAPI busy polling
> - read data stream from 1 TCP socket
> 
> Outcome:
> --------
> 
> I did not measure latency to make sure that NAPI polling was effective
> but I did ensure the stability of running the patchset by letting the
> program run for 5+ hours non stop without experiencing any glitches

Thanks for testing!

Any chance that you could run some tests with and without NAPI that help
validate that it actually works? That part is what I'm most interested
in, not too worried about the stability of it as I have scrutinized it
pretty close already.

-- 
Jens Axboe


