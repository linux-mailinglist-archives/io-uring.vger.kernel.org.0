Return-Path: <io-uring+bounces-6120-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 091E4A1BDA4
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 21:51:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 753837A361F
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 20:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4AEB1DB933;
	Fri, 24 Jan 2025 20:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="H4NNKTlm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 790061DB366
	for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 20:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737751897; cv=none; b=t5Y8tFeolsCyGp8Zz5qiGryZIELK4Khf1hMpfdxMeKQGQFZbNO7JWZQbEWL5sf2TxWBxT8d0F9tqRCBi+jBDA9tdTFTJN1C3unFHeGOEU+gWovjy8QubH/JKUGht7afHcV1CrDoplXSIOXNH4HNtDDIMk0BnXjijbkS7uuU1iHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737751897; c=relaxed/simple;
	bh=KIdqUxQ/TeBsrZa+YNOxUuG6i684VFDu6KajdTLBNXE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ti6vUqG7LYX+xJRNv+M6fkxlDcU1Y0M7xnzvQr6k6qJFMhvsYV8FqjrmSKa43jGu56+sJiPRBGjVN3vGBQa0WbYfz4XsPK7dWeiSYDhdeNRYRqF9M63IL4TUOyTFHdZZn+SWwqB7lHwwIhHlu4oaOQ/3MwtbzZ/pyYxRV6jjQuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=H4NNKTlm; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-84ceaf2667aso169985239f.3
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 12:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737751894; x=1738356694; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=piCoSIefp0mhGxpiCOEP0Otj5ta/B/7ZE/GZR6dGe8k=;
        b=H4NNKTlmJhi6Ksv3wk3VMfiVb4OSU6p+QPR9/bJU4jyd49lM1En8I6P5O4UY0sJTtj
         6GqvDaWfm4MYScVY7y1/Is76+POELqk7pE2qIRHV+CQ+nnRrHF1D+Ybi14e8hCKYgcSE
         /ZDWnbe9rOSloLsXYPfcVZfiKlcqIXiM7n0HL/Jfx7/zen92QVgY8WbaDk5oFTGW0Drg
         WJuJYmpOoXR285/k9XcEjBV2lyxbxRfsN8xKNXnr2nEDtSyUv5GwKVPNbyC85qYUbiRW
         1pQSTpKF8yonFsLp+ymbUzt3UlB1GjZV2tx+M1U1dTD0LimDav2NfgCbNL6eRaxNmW27
         tfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737751894; x=1738356694;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=piCoSIefp0mhGxpiCOEP0Otj5ta/B/7ZE/GZR6dGe8k=;
        b=oTdlXvgeRO9CYrNd2B1FZ8joyuHujmpVMN3tTFqzZdBdL4iHgljNtK8noSLycvSzWb
         OarhfWoQYAMLvNGltQ98otQ6ysoQOFuNLeN3sx3tZnQ1S9IRt/BgYx6xY6BIzOg9BrBi
         +mtwN7VXelUWZbfrOdzEKxP7obTAxBSE8D4vp53nN3+JEmlhdqBtS8n41zd/L8v5D6Om
         H7KiautmF0QsDbO7Q3CFxH+MDlq2KTiabalcK8Dv3+1oGWMdoF1EMkQaAq/wmV221moM
         7sgcCfg8AyNBXjYwZ+jhX4ShhsCbLVHDgKEXF2GJ2mPgUJl1NU55WyTE+q9N/wCmlAbA
         QzFg==
X-Forwarded-Encrypted: i=1; AJvYcCWkZUKFvww2I+ZWZGmINqIRJwpBBBRtIaEx6TFMSLQ7oQS9h3a+erJOr/A/Zya/eTus9eAIEubrnA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwaFbJdgm8UczOAGrOyRN0JcL3Yox2nYl3D6Ome4pfkxmYGmWmT
	MLdTaETnu/ZalMwix8AKQ97UJu51siU1ZZgJoNhUDH0xlFuAvHIFGdZpahSYOEc=
X-Gm-Gg: ASbGncvzFVyKyEv7P321Lz58+NcPky8YgfK7y+qj/twvw/8o8FQhWDAVkiTh+PgRml/
	8QxDG8/sNQosrm5cnQjfNG/ZG8ofIXadR8hYoLMNSkeIpl7IL1pJjWPK/LK8eWQRTwgbPXaxTag
	HfbyzEg1HIbdwTbuwNPVIy3HcH0tGCefP6jvIrGwGUtZy1+Gu7fV72boaRULBeJ6WC/LEdni4wY
	c9qHmBAbxQsALjECN4O1S+a6UjNJd0nS7zxldGbiGPEajCVJd9UBseq1nHBIEwWwgGaQsTTgFM4
	IQ==
X-Google-Smtp-Source: AGHT+IFAQ2V0tUehGHsduBzV1CBK9BUXzGuNC88ilzYl7uiRcSbenuJl8iISOcgvGQGRcykqUgXddg==
X-Received: by 2002:a05:6602:6d8d:b0:841:8d66:8aea with SMTP id ca18e2360f4ac-851b617219bmr2503664939f.2.1737751894515;
        Fri, 24 Jan 2025 12:51:34 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1da2db34sm849968173.36.2025.01.24.12.51.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 12:51:33 -0800 (PST)
Message-ID: <13ba3fc4-eea3-48b1-8076-6089aaa978fb@kernel.dk>
Date: Fri, 24 Jan 2025 13:51:33 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug#1093243: Upgrade to 6.1.123 kernel causes mariadb hangs
To: Salvatore Bonaccorso <carnil@debian.org>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: Xan Charbonnet <xan@charbonnet.com>, 1093243@bugs.debian.org,
 Bernhard Schmidt <berni@debian.org>, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev
References: <173706089225.4380.9492796104667651797.reportbug@backup22.biblionix.com>
 <dde09d65-8912-47e4-a1bb-d198e0bf380b@charbonnet.com>
 <Z5KrQktoX4f2ysXI@eldamar.lan>
 <fa3b4143-f55d-4bd0-a87f-7014b0fad377@gmail.com>
 <Z5MkJ5sV-PK1m6_H@eldamar.lan>
 <a29ad9ab-15c2-4788-a839-009ca6fdd00f@gmail.com>
 <df3b4c93-ea70-4b66-9bb5-b5cf6193190e@charbonnet.com>
 <8af1733b-95a8-4ac9-b931-6a403f5b1652@gmail.com>
 <Z5P5FNVjn9dq5AYL@eldamar.lan>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <Z5P5FNVjn9dq5AYL@eldamar.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/24/25 1:33 PM, Salvatore Bonaccorso wrote:
> Hi Pavel,
> 
> On Fri, Jan 24, 2025 at 06:40:51PM +0000, Pavel Begunkov wrote:
>> On 1/24/25 16:30, Xan Charbonnet wrote:
>>> On 1/24/25 04:33, Pavel Begunkov wrote:
>>>> Thanks for narrowing it down. Xan, can you try this change please?
>>>> Waiters can miss wake ups without it, seems to match the description.
>>>>
>>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>>> index 9b58ba4616d40..e5a8ee944ef59 100644
>>>> --- a/io_uring/io_uring.c
>>>> +++ b/io_uring/io_uring.c
>>>> @@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
>>>>        io_commit_cqring(ctx);
>>>>        spin_unlock(&ctx->completion_lock);
>>>>        io_commit_cqring_flush(ctx);
>>>> -    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>>>> +    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
>>>> +        smp_mb();
>>>>            __io_cqring_wake(ctx);
>>>> +    }
>>>>    }
>>>>    void io_cq_unlock_post(struct io_ring_ctx *ctx)
>>>>
>>>
>>>
>>> Thanks Pavel!  Early results look very good for this change.  I'm now running 6.1.120 with your added smp_mb() call.  The backup process which had been quickly triggering the issue has been running longer than it ever did when it would ultimately fail.  So that's great!
>>>
>>> One sour note: overnight, replication hung on this machine, which is another failure that started happening with the jump from 6.1.119 to 6.1.123.  The machine was running 6.1.124 with the __io_cq_unlock_post_flush function removed completely.  That's the kernel we had celebrated yesterday for running the backup process successfully.
>>>
>>> So, we might have two separate issues to deal with, unfortunately.
>>
>> Possible, but it could also be a side effect of reverting the patch.
>> As usual, in most cases patches are ported either because they're
>> fixing sth or other fixes depend on it, and it's not yet apparent
>> to me what happened with this one.
> 
> I researched bit the lists, and there was the inclusion request on the
> stable list itself. Looking into the io-uring list I found
> https://lore.kernel.org/io-uring/CADZouDRFJ9jtXHqkX-PTKeT=GxSwdMC42zEsAKR34psuG9tUMQ@mail.gmail.com/
> which I think was the trigger to later on include in fact the commit
> in 6.1.120. 

Yep indeed, was just looking for the backstory and that is why it got
backported. Just missed the fact that it should've been an
io_cqring_wake() rather than __io_cqring_wake()...

-- 
Jens Axboe

