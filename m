Return-Path: <io-uring+bounces-4401-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F0EB9BB495
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 13:23:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8440F1F2104B
	for <lists+io-uring@lfdr.de>; Mon,  4 Nov 2024 12:23:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF1D31B219A;
	Mon,  4 Nov 2024 12:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DDeL8W8a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26881B0F2B;
	Mon,  4 Nov 2024 12:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730722983; cv=none; b=MkX6JcAFMghbgIJSzUFIhK5oGt6UyhrTu2jc+idGCXSnAVqEoMhpgL0+OHenGiV28RCXmg0Bdqpzk8WcjGv/+ldS+ZXMmtXvuh+PrH/0qlXppY0gYwCeNMrIELv+1Y+FobHrrramp/MDuoWPrE7unnuvRSDVG5eg6FeUCcqCx9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730722983; c=relaxed/simple;
	bh=UNB5dAGqZBZMKtij4B7IaVvStzBIeAGWY8rbC2gJgno=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G+rYqONyKmxxVmTwO66CgcSaHlbXKLYaVVMgIWMzbVoxjOAZaE07ynVwvuX5c0Z2mM0fXvgu7kLmw29UNHEkBXinoziLnsdnsCP0TmKIyMQUMA9ToDxmkzI6F0rGef8m2tRfJZo11Z+RLVzldzKPDaGSW3MWc7CupkEwrqFJo4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DDeL8W8a; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-a9aa8895facso752796866b.2;
        Mon, 04 Nov 2024 04:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1730722980; x=1731327780; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p6Tl7EKZ/k0uMg7GseFNiZxjC4umBMtaB6MbOBSq7F8=;
        b=DDeL8W8aLBdl93cdlH7EHLKTcOmIEkl8RSh7nc5B2gBsz7QJm++fQtaQZz6jbSeDsh
         7UZlPkepFU0ZA7BZXbAYqVQexon5VIDgeQql182EV07qHGNgeUb26hrJsB+BGLfU7Xwn
         GmPoaCSZJa3jHbypW88AlCljHpcw7oyQIsHNJslmk75KSj24ydyOPNJZMluV6noO1fw9
         xWyrntlZsnbVdatCx4OBp9QccCYP6cBeLMTMlF1iYRRCKeZwdmI6S7SD19NmsxWfQe5l
         Z0AXuX5pwXU09qQzVY22fSwtvLlMBPJj+Il/lE++GcqlX3QP+ONedtokd91hJ8O06Ftq
         6VUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730722980; x=1731327780;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p6Tl7EKZ/k0uMg7GseFNiZxjC4umBMtaB6MbOBSq7F8=;
        b=WnashLwnSPH1kk7j7atgIIT2PvKywLDJWHkH7aLBRAbezVuCNAC/+ItgHYX/bLqShQ
         VbnauF+acWy3NIA57MxjhTb3/mDFp1w6c4LncMaG4U7qH+EZvgVnOdoD4OajCyjBsq5b
         7/t2uO70Utg2x5q20v+GGJD6nUQ+IunPsNXvMSa/9zfQUHHZ/HnhNsNmce26NjZG5Myp
         4wV3qjnHYPj2hLuOY1BF8q8DFDE3fo4knI4q1DMA/RJUcGHMnFyhl8Umx6YXljkobBLZ
         NVmqoBR2K2rXBOENVXnkstV5gNAnkC7sbHN0hL8pYvsZiYQUycW5o7e9TGIS2Y1lTMZU
         Uetw==
X-Forwarded-Encrypted: i=1; AJvYcCVb0xGQ7tQCDZy/wTAw0dR6bPRiEMM2b1ZzB9gVuOvMimEaPWeX3gUbty8J/LHNcGphsv8VEgFozg==@vger.kernel.org, AJvYcCVu0LriU5qjzuObBfl0adijJ+ififeZyxPmcYmjGYx5HHc57mjtVeEg0gtvISqUsFcRc+xoILKvEE2iyiY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5iE3wD8aO3vOwFsKbN/rkZ41+uVNQJEbyyrl9WuZ2hVqEfTTF
	ithJqyhr4L4gVURrSHRgOw9bsAcn2q17c8chw6TBo9BoZFYpPQKJmAOESQ==
X-Google-Smtp-Source: AGHT+IFVsrfdy7L7/lgOtsNNxxO99riTrwuc8748ExSDguZwZvdfGHkqb2/grLnVG1D8SDZB7zgJFQ==
X-Received: by 2002:a17:907:7216:b0:a99:ef65:58d0 with SMTP id a640c23a62f3a-a9de6440cbbmr3261830066b.65.1730722978377;
        Mon, 04 Nov 2024 04:22:58 -0800 (PST)
Received: from [192.168.42.177] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9e56681a76sm547039066b.199.2024.11.04.04.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2024 04:22:57 -0800 (PST)
Message-ID: <74d8d323-789c-4b4d-8ce6-ada6a567b552@gmail.com>
Date: Mon, 4 Nov 2024 12:23:04 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V8 5/7] io_uring: support leased group buffer with
 REQ_F_GROUP_KBUF
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
 linux-block@vger.kernel.org, Uday Shankar <ushankar@purestorage.com>,
 Akilesh Kailash <akailash@google.com>
References: <20241025122247.3709133-6-ming.lei@redhat.com>
 <4576f723-5694-40b5-a656-abd1c8d05d62@gmail.com> <ZyGBlWUt02xJRQii@fedora>
 <bbf2612e-e029-460f-91cf-e1b00de3e656@gmail.com> <ZyGURQ-LgIY9DOmh@fedora>
 <40107636-651f-47ea-8086-58953351c462@gmail.com> <ZyQpH8ttWAhS9C5G@fedora>
 <4802ef4c-84ca-4588-aa34-6f1ffa31ac49@gmail.com> <ZygSWB08t1PPyPyv@fedora>
 <0cd7e62b-3e5d-46f2-926b-5e3c3f65c7dd@gmail.com> <ZyghmwcI1U4WizyX@fedora>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <ZyghmwcI1U4WizyX@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/4/24 01:21, Ming Lei wrote:
> On Mon, Nov 04, 2024 at 01:08:04AM +0000, Pavel Begunkov wrote:
>> On 11/4/24 00:16, Ming Lei wrote:
...
>>>>>>>> I agree, it's not hot, it's a failure path, and the recv side
>>>>>>>> is of medium hotness, but the main concern is that the feature
>>>>>>>> is too actively leaking into other requests.
>>>>>>> The point is that if you'd like to support kernel buffer. If yes, this
>>>>>>> kind of change can't be avoided.
>>>>>>
>>>>>> There is no guarantee with the patchset that there will be any IO done
>>>>>> with that buffer, e.g. place a nop into the group, and even then you
>>>>>
>>>>> Yes, here it depends on user. In case of ublk, the application has to be
>>>>> trusted, and the situation is same with other user-emulated storage, such
>>>>> as qemu.
>>>>>
>>>>>> have offsets and length, so it's not clear what the zeroying is supposed
>>>>>> to achieve.
>>>>>
>>>>> The buffer may bee one page cache page, if it isn't initialized
>>>>> completely, kernel data may be leaked to userspace via mmap.
>>>>>
>>>>>> Either the buffer comes fully "initialised", i.e. free of
>>>>>> kernel private data, or we need to track what parts of the buffer were
>>>>>> used.
>>>>>
>>>>> That is why the only workable way is to zero the remainder in
>>>>> consumer of OP, imo.
>>>>
>>>> If it can leak kernel data in some way, I'm afraid zeroing of the
>>>> remainder alone won't be enough to prevent it, e.g. the recv/read
>>>> len doesn't have to match the buffer size.
>>>
>>> The leased kernel buffer size is fixed, and the recv/read len is known
>>> in case of short read/recv, the remainder part is known too, so can you
>>> explain why zeroing remainder alone isn't enough?
>>
>> "The buffer may bee one page cache page, if it isn't initialized
>> completely, kernel data may be leaked to userspace via mmap."
>>
>> I don't know the exact path you meant in this sentence, but let's
>> take an example:
>>
>> 1. The leaser, e.g. ublk cmd, allocates an uninitialised page and
>> leases it to io_uring.
>>
>> 2. User space (e.g. ublk user space impl) does some IO to fill
>> the buffer, but it's buggy or malicious and fills only half of
>> the buffer:
>>
>> recv(leased_buffer, offset=0, len = 2K);
>>
>> So, one half is filled with data, the other half is still not
>> initialsed.
> 
> io_req_zero_remained() is added in this patch and called after the
> half is done for both io_read() and net recv().

It zeroes what's left of the current request, but requests
don't have to cover the entire buffer.

>> 3. The lease ends, and we copy full 4K back to user space with the
>> unitialised chunk.
>>
>> You can correct me on ublk specifics, I assume 3. is not a copy and
>> the user in 3 is the one using a ublk block device, but the point I'm
>> making is that if something similar is possible, then just zeroing is not
>> enough, the user can skip the step filling the buffer. If it can't leak
> 
> Can you explain how user skips the step given read IO is member of one group?

(2) Illustrates it, it can also be a nop with no read/recv

>> any private data, then the buffer should've already been initialised by
>> the time it was lease. Initialised is in the sense that it contains no
> 
> For block IO the practice is to zero the remainder after short read, please
> see example of loop, lo_complete_rq() & lo_read_simple().

It's more important for me to understand what it tries to fix, whether
we can leak kernel data without the patch, and whether it can be exploited
even with the change. We can then decide if it's nicer to zero or not.

I can also ask it in a different way, can you tell is there some security
concern if there is no zeroing? And if so, can you describe what's the exact
way it can be triggered?

-- 
Pavel Begunkov

