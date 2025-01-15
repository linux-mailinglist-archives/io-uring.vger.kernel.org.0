Return-Path: <io-uring+bounces-5893-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 72632A12C80
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 21:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B3BE97A11A4
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 20:22:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 021871D90B6;
	Wed, 15 Jan 2025 20:22:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="et7ZIgVI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866421D61AA
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 20:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736972549; cv=none; b=rXCciBrCjJZybXGMfZTSSRLtx1sxPzLuSN9evAfdRVc3crRFQSZdLZwTh3wbuAzLrpoJ46Gq6iH++0Pc5RYu5yj2wWRkZ6/cujLhYhXqhy7KVQaQ7nkHsTx+U6oo6vhrmRYoqQ2DQJuxKTLhyQMcljdJhU/l0zXR2Voq3KC6u8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736972549; c=relaxed/simple;
	bh=13oZQi6dLeR2GoSpWGONnBYJcIWxqqrQizTU+Cdu2hI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W8c/27vusFrH5WuiThYdeW0Zo4Bo4SbPFFCz/BXqAkQV9VFuQjbLmotaiXeaUQJmVv4olD/v985b/jrgS7eaYXmgtGQb3ozkUNFQIcQ4YrCrRUfQIv+fbqOdArPM4mudr3yfe9iwBNMKe8X5AYrFZMs1mh9TwT0WhoL1GjfL5zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=et7ZIgVI; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3ce7a33ea70so493005ab.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 12:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736972546; x=1737577346; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cSs6O6uTl4l4jvf5B67dE4FbYVG5+Y6HQw+ET+q/aSs=;
        b=et7ZIgVIsdq7fOzk6jaFK2zjvtv/M9r6G4ylGCikMr/9kJmKfen40VPYgiK/BM5rv4
         MeGm/anCm2lyM5QO61A+VM4Tgao8yJnMRfqbCb0luFwaJpuVNHduJGNpqfhOtFppqiZ4
         mvC7kzBmdMv7lnxWw57MLvXFvSEPveI3X771B2nrXIBTGhq3GIv+2tfGDX3nAOxzCgle
         w6EKrAyU9SiQexhjUBncmZVV+xpXoie6BdfWq8+KLpF0x+VmPEEIZuyK/VIImaxenqvS
         OOYr+NWsMajGdVsGyegjrzvzchgxadFR/8NX1XOd2i1YoRj6xqdSxAENjxa1p2OpnVTl
         wq+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736972546; x=1737577346;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cSs6O6uTl4l4jvf5B67dE4FbYVG5+Y6HQw+ET+q/aSs=;
        b=mNIhYiXMFzSxTdtpjrbJEtv3jcvKlZ7BnjFMBF2vOEKIVaBPZhK3FhDv7fQj257MJx
         cWf/Ezes5WtOs/Pzf/0seutwETiaK1OcnXQ9Ku+n55dwB40lTweYTWTWg+vLtfMWGWTV
         sygU+HtnUX5wOTEteoHmsKBTh+PMs9A+dGU2wnOqWR6+5/IA0Xn43Tj4lTWZYfRIxbmN
         zeluiEJOo8Rg9rPSj6SWxd05k3gIrB4scWBzi5v+nZxiHLF++uNN5xqQsrJNu/mEuvC/
         XSifkWnYH8leuxqm3hpzar0aUuQH3oUWYrfFQotlp2+oq38f5vrqiOwKxcuY/U/x+0Bm
         wTAA==
X-Forwarded-Encrypted: i=1; AJvYcCXcDqqOrzcm6MJNpIMh8u/l2rHryRFRKuowxTZfu2W+lmB7YcceHYqUvKvNhu7ZYbnL+/iXU3OhEQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb00YoepyFp9lWKrz6ELE+i8AaPAj59CbF4SeMwFnH22L5Z3/5
	8q8h57IrLG12o0yoh1iqmCqwbi+r6AuJnEVbaxCet9yqvwNwBU4KvHssYBjZYDMW63jIhcJWOgf
	i
X-Gm-Gg: ASbGncs1RbhIUS77MTwq5IvPX7NHcHgJ9MC0s/dole01OWBpHV9QSNmdL3fja8Q5JRp
	SQiOeWqTcUqA2+UxNAKl1UMujX7J4vnG2oK5WlAx7qeP0a8oU0n+qZ1bX/jD3dBE+/NYnvYT9vq
	K03ZsaYAZd+s7VvhuN1/GQbdoj5hkPlMQkVpQugFlIQb4S+YpBtPEHT4Vw5wGahuqIbSOmYAFg+
	n9UZiOOylZm65txqwq3KQARrZ0qDVT+67Ak6QPI0am+uIQ2lFXe
X-Google-Smtp-Source: AGHT+IEIYNHFe0dnFnsdi96aS+Hl7Cb1CL8pnjN83JI2gZtIH54NDhTLow6ZYK60NqpDokRxwt3HGg==
X-Received: by 2002:a05:6e02:9c:b0:3ce:7ac0:64ce with SMTP id e9e14a558f8ab-3ce7ac065ffmr86282835ab.18.1736972546525;
        Wed, 15 Jan 2025 12:22:26 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce4adb3dc4sm41568725ab.22.2025.01.15.12.22.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 12:22:25 -0800 (PST)
Message-ID: <10e131e4-6333-4d5c-9088-8e0b8e867060@kernel.dk>
Date: Wed, 15 Jan 2025 13:22:25 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: Simplify buffer cloning by locking both
 rings
To: Jann Horn <jannh@google.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250115-uring-clone-refactor-v1-1-b2d951577201@google.com>
 <2439336d-b6ae-4d08-a1e8-2372fc6df383@kernel.dk>
 <CAG48ez3RG5iDrK4UWCjBWw9FTPCQK8NXK1wADo_VWWBatVpXBw@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez3RG5iDrK4UWCjBWw9FTPCQK8NXK1wADo_VWWBatVpXBw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/15/25 1:20 PM, Jann Horn wrote:
> On Wed, Jan 15, 2025 at 6:18?PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 1/15/25 9:25 AM, Jann Horn wrote:
>>> The locking in the buffer cloning code is somewhat complex because it goes
>>> back and forth between locking the source ring and the destination ring.
>>>
>>> Make it easier to reason about by locking both rings at the same time.
>>> To avoid ABBA deadlocks, lock the rings in ascending kernel address order,
>>> just like in lock_two_nondirectories().
>>>
>>> Signed-off-by: Jann Horn <jannh@google.com>
>>> ---
>>> Just an idea for how I think io_clone_buffers() could be changed so it
>>> becomes slightly easier to reason about.
>>> I left the out_unlock jump label with its current name for now, though
>>> I guess that should probably be adjusted.
>>
>> Looks pretty clean to me, and does make it easier to reason about. Only
>> thing that stuck out to me was:
>>
>>> @@ -1067,7 +1060,18 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
>>>       file = io_uring_register_get_file(buf.src_fd, registered_src);
>>>       if (IS_ERR(file))
>>>               return PTR_ERR(file);
>>> -     ret = io_clone_buffers(ctx, file->private_data, &buf);
>>> +     src_ctx = file->private_data;
>>> +     if (src_ctx == ctx) {
>>> +             ret = -ELOOP;
>>> +             goto out_put;
>>> +     }
>>
>> which is a change, as previously it would've been legal to do something ala:
>>
>> struct io_uring ring;
>> struct iovec vecs[2];
>>
>> vecs[0] = real_buffer;
>> vecs[1] = sparse_buffer;
>>
>> io_uring_register_buffers(&ring, vecs, 2);
>>
>> io_uring_clone_buffers_offset(&ring, &ring, 1, 0, 1, IORING_REGISTER_DST_REPLACE);
>>
>> and clone vecs[0] into slot 1. With the patch, that'll return -ELOOP instead.
>>
>> Maybe something like the below incremental, to just make the unlock +
>> double lock depending on whether they are different or not? And also
>> cleaning up the label naming at the same time.
> 
> Yeah, looks good to me. If nobody else has review feedback, do you
> want to fold that in locally? If there's more feedback, I'll fold that
> incremental into my v2.

If you want to send off a v2, just fold it in. That would be the most
appropriate imho, rather than me modifying your patch :)

-- 
Jens Axboe

