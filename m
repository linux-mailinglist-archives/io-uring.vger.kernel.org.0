Return-Path: <io-uring+bounces-6142-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7B73A1DACD
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 17:49:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E1BA07A05D8
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 16:49:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768B413D52E;
	Mon, 27 Jan 2025 16:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ieN7g7Q9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB71C3D64;
	Mon, 27 Jan 2025 16:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737996549; cv=none; b=ADBpMjEL3Em6BRgvfVUDTbNT7flyQLChVYR8X9hZci0cowhDA7/RJpPwWAsj6V+xt4x7kUzbO+vmFyqUpQ/3Qz1W0xiQO3zJxWrw6XkIkeLyPKk7knqv6Q8+lHIWs3AXiySyk2AeIa0cbrh8/y5mjR79GGGXns0EqT65hnxU7FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737996549; c=relaxed/simple;
	bh=CP4nMDiVLFzgAGi8GSRGavI5/vsdfGJ85kCyOK0WRsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZHVGgy2wEUDZh9DvuX8FtuAM61ZgCy/b8FDR0uEvfAzuvpsUCxGJIfV/WRhtqNH3ANfzOlbYHI/g4Mbmpxwk/kKLFPBZecUlpPT+BhCmDx3J/HterC3kq1GX0GbGzBSQljYHrOHRJJFROh4Kk27jrSbQId4ccrZXkkrzbcAyIPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ieN7g7Q9; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5d0d32cd31aso6858069a12.0;
        Mon, 27 Jan 2025 08:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737996544; x=1738601344; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IRe+637ZNHriFl6/Rd/SrwbaBSpfvoTT2o0kmRNpJcI=;
        b=ieN7g7Q9uvVF0kI/g/MAJ5bRKeMIyB67MB4ed4Ry1WZ/Ag2Et9tKkKLlTC54IRZcTq
         bZAoQYG6zHnsfOx3BX7Xp3F82oYrx8HXjVUq2ERL64g2WE4xLLFOrZiLbTqglfvhjI4e
         5g4Pf4HNBeDbhzf3LrimjamN2bONjFg237owx0WROn7RmUuau0SG3HBhmKKoa32x4Hab
         20SVhaJ04fUBFLLCO9zQH5qxh5fQnkssiWH7UCiJMTa/KuNstJ9eQdUCaMydKbZXOisS
         R95LSXzPAvOKB1AVaX2PauDTZM3KiVexmsoRAyTaxnILj/1z84NA2YB9XCTwYFXWd++Y
         jRKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737996544; x=1738601344;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IRe+637ZNHriFl6/Rd/SrwbaBSpfvoTT2o0kmRNpJcI=;
        b=GwvBRnxkJl9k4oyGakbVseV91kO2gBh9jfSQJOWnf3zgnIsYZ6Wv/fXnTIyUPmeCm3
         oZgiC2j+Zzdzi831+O26/PRb+8hI/f/BTlmS374zwSGp5O+Qrg18eLPw+7XMIkjPeaBS
         hRHV932I2TreXZ5m9G5XKV6SXJ2RYcVbIpTWconOxckAZ4SeiAAHXvcaXrr8Bo6ALWFD
         FSHKkfRqNB0bdO0F5KhXkgVfNbakVGZfbOwJEC4zBYDPYX1HgMiz+3HgPjn6bchZmRVt
         o5TZEfyKshlRRoqIV1gVmf7avowwnT27MM/+Xh4JVsW2gdeqi71Iqi8m6Pw69r6rhsa5
         gfHg==
X-Forwarded-Encrypted: i=1; AJvYcCUv/wzvYjxIgVZDKOAdoCVFggx9q+5h6h4a6v+kdAuC+6IjptztRNVmzLd7d9NClFbB2lAoxv1u0Q==@vger.kernel.org, AJvYcCVIJZy2LSEtuT77tt0ZuztHMulU04TNSte4lRDSaDTnD3nMzFjSm7jLG72bQZFUBt6EGIK7sFfpE1DKsDpy@vger.kernel.org
X-Gm-Message-State: AOJu0YwEvH5cz4r0eWYl8K3rhbMoZqRiCnITgMFTZR7pwcqfqG5iUnGj
	3V/vm0fve4hNF6hz5zm1g8pS4Jgp5nqzmovNgwa1ARAfmzoU4lLx
X-Gm-Gg: ASbGnctlLKQJA5og0zvZuQgYbMIPhOpfe/L2vvafQvYG+OgRj5nLb/yQU7rKTOdkLKi
	z2Tqmbsn5U6VzRt9N1N5kYDZzanrRIT7XTc+z6j9uXuxuuoJPdU+1F0WSG3i7Jd2ZfkhK/Q+KQ7
	j00Aiv9NNxfqgg1uYMbZYBKJdanc5wTU72MnO7SV7Ss7DciiWHjSmJInLDPL5juxnlnbi5GGHCt
	CTrjb29DsFOCGLSw/snpUSpmrd4TmCIATWPdIgbWztHGSa3r/gtobRhin9Ze2J922U4QK89dSsK
	nCko+4xprDi6BQ==
X-Google-Smtp-Source: AGHT+IG9/ptK+rm2PinAsTT1t0HOwTwKdautVkiWPwuwkIqT3RwpHJCOzup4SQoT91pKvggDDJWOBw==
X-Received: by 2002:a05:6402:1ed1:b0:5db:f423:19cf with SMTP id 4fb4d7f45d1cf-5dbf4231ae1mr50265631a12.9.1737996543888;
        Mon, 27 Jan 2025 08:49:03 -0800 (PST)
Received: from [192.168.8.100] ([148.252.145.92])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc186285c6sm5733938a12.20.2025.01.27.08.49.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2025 08:49:03 -0800 (PST)
Message-ID: <117696e5-6649-4236-a06d-a860b29b3cba@gmail.com>
Date: Mon, 27 Jan 2025 16:49:26 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
To: Xan Charbonnet <xan@charbonnet.com>, Jens Axboe <axboe@kernel.dk>,
 Salvatore Bonaccorso <carnil@debian.org>
Cc: 1093243@bugs.debian.org, Bernhard Schmidt <berni@debian.org>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 regressions@lists.linux.dev
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
 <Z5MkJ5sV-PK1m6_H@eldamar.lan>
 <a29ad9ab-15c2-4788-a839-009ca6fdd00f@gmail.com>
 <df3b4c93-ea70-4b66-9bb5-b5cf6193190e@charbonnet.com>
 <8af1733b-95a8-4ac9-b931-6a403f5b1652@gmail.com>
 <Z5P5FNVjn9dq5AYL@eldamar.lan>
 <13ba3fc4-eea3-48b1-8076-6089aaa978fb@kernel.dk>
 <a2f5ea66-7506-4256-b69c-a2d6c2f72eb4@charbonnet.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a2f5ea66-7506-4256-b69c-a2d6c2f72eb4@charbonnet.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 1/26/25 22:48, Xan Charbonnet wrote:
> Since applying the final patch on Friday, I have seen no problems with either the backup snapshot or catching up with replication.  It sure seems like things are all fixed.  I haven't yet tried it on our production Galera cluster, but I expect to on Monday.

Great to hear that, thanks for the update. And I sent the fix,
hopefully it'll be merged for the nearest stable release.


> Here are Debian packages containing the modified kernel.  Use at your own risk of course.  Any feedback about how this works or doesn't work would be very helpful.
> 
> https://charbonnet.com/linux-image-6.1.0-29-with-proposed-1093243-fix_amd64.deb
> https://charbonnet.com/linux-image-6.1.0-30-with-proposed-1093243-fix_amd64.deb
> 
> 
> 
> 
> On 1/24/25 14:51, Jens Axboe wrote:
>> On 1/24/25 1:33 PM, Salvatore Bonaccorso wrote:
>>> Hi Pavel,
>>>
>>> On Fri, Jan 24, 2025 at 06:40:51PM +0000, Pavel Begunkov wrote:
>>>> On 1/24/25 16:30, Xan Charbonnet wrote:
>>>>> On 1/24/25 04:33, Pavel Begunkov wrote:
>>>>>> Thanks for narrowing it down. Xan, can you try this change please?
>>>>>> Waiters can miss wake ups without it, seems to match the description.
>>>>>>
>>>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>>>> index 9b58ba4616d40..e5a8ee944ef59 100644
>>>>>> --- a/io_uring/io_uring.c
>>>>>> +++ b/io_uring/io_uring.c
>>>>>> @@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
>>>>>>         io_commit_cqring(ctx);
>>>>>>         spin_unlock(&ctx->completion_lock);
>>>>>>         io_commit_cqring_flush(ctx);
>>>>>> -    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>>>>>> +    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
>>>>>> +        smp_mb();
>>>>>>             __io_cqring_wake(ctx);
>>>>>> +    }
>>>>>>     }
>>>>>>     void io_cq_unlock_post(struct io_ring_ctx *ctx)
>>>>>>
>>>>>
>>>>>
>>>>> Thanks Pavel!  Early results look very good for this change.  I'm now running 6.1.120 with your added smp_mb() call.  The backup process which had been quickly triggering the issue has been running longer than it ever did when it would ultimately fail.  So that's great!
>>>>>
>>>>> One sour note: overnight, replication hung on this machine, which is another failure that started happening with the jump from 6.1.119 to 6.1.123.  The machine was running 6.1.124 with the __io_cq_unlock_post_flush function removed completely.  That's the kernel we had celebrated yesterday for running the backup process successfully.
>>>>>
>>>>> So, we might have two separate issues to deal with, unfortunately.
>>>>
>>>> Possible, but it could also be a side effect of reverting the patch.
>>>> As usual, in most cases patches are ported either because they're
>>>> fixing sth or other fixes depend on it, and it's not yet apparent
>>>> to me what happened with this one.
>>>
>>> I researched bit the lists, and there was the inclusion request on the
>>> stable list itself. Looking into the io-uring list I found
>>> https://lore.kernel.org/io-uring/CADZouDRFJ9jtXHqkX-PTKeT=GxSwdMC42zEsAKR34psuG9tUMQ@mail.gmail.com/
>>> which I think was the trigger to later on include in fact the commit
>>> in 6.1.120.
>>
>> Yep indeed, was just looking for the backstory and that is why it got
>> backported. Just missed the fact that it should've been an
>> io_cqring_wake() rather than __io_cqring_wake()...
>>
> 

-- 
Pavel Begunkov


