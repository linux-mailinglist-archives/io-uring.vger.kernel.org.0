Return-Path: <io-uring+bounces-6788-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2A8A45F55
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 13:35:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6383C7A157D
	for <lists+io-uring@lfdr.de>; Wed, 26 Feb 2025 12:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21AF7219304;
	Wed, 26 Feb 2025 12:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XHOZ+uud"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2508C2192FF;
	Wed, 26 Feb 2025 12:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740573148; cv=none; b=TUPSpsn0/6hVoZgjPSdTYu77qnEPjfa0djsvAdCiO1O008ZbapYxxK5lEeiNUvfQI9p50N8QkOYnvvzBunkStlyqV4qtil1vINMpZ7NQG66YdCIQpuPEVgM/GQQJFIKWfkoH0zO6vcpC6inY2nI8GgLcn5JGBt/oDXjokgAJ6ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740573148; c=relaxed/simple;
	bh=+19bA/k+yDxHE7L7igYi0u9cuiES9RzhOod9ze8yMjQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f3Eaksj8s/V+QcdK/ykxi/tEsYv2i+D/EYbjKyOhP3CTC6YqWiqazcGmgp0FVa049NYXxJJDdPCND+ZHEvgW1bOcNIB9brmuksr1mhWGNvRw0UDWeP1NVBmlMKfre8bG6k/G6ehbu9q+faGlvQKsT3jYZ9sSwGiC/HzZ9wSNJeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XHOZ+uud; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-abb9709b5b5so1226191466b.2;
        Wed, 26 Feb 2025 04:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740573144; x=1741177944; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RCR+RwatVKn87ok7pB6TBCSxW6auxGHtyVpuY7aiEe4=;
        b=XHOZ+uudReT7sPBgFGcTozDM4vkiah77sYzF8sqWRA1cmpgphT6IP+MbQGDAgo0h/O
         kw0q02PA97uLzL41+z6Um3H2TfUMLdb8wvMoDw+CH2meeZ1YWpmkzVH3Wcv5eyiSFQ2o
         VN47Dri21dsR9OxfULTw0yrtGqJyCclsF4kmx8UaH5VoLHF87b8E+AAXLVYpiaF8JvLP
         cKnRW6b48irBF52q9A1BAGykqZucNUUAAPQz/fieIkykLm6cpuImMV3srO/JW5haPr4r
         +ey0J4DOif7mvstHtQnHO2Wkf/3m6OFqidEZtNbTycRaWlD+xDCX3dsWcShvcZoQ/7kA
         HaOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740573144; x=1741177944;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RCR+RwatVKn87ok7pB6TBCSxW6auxGHtyVpuY7aiEe4=;
        b=L+oUrECC7iAIpUsdTjsgJMpSTcZPEe/0ODoPkJUQTDrhN459Kj4D/IDlrk1zTDr7ZN
         um7uveW1iFLMG8IweKhCa2pr4z2pQVbFbLLrugV7jlf+Q8ZhynT4PmlrbkD7FNaKgIfL
         fO+Mj7kEF5EJYTWYBXZsl8W3807Pa3MOC/vFZ01XSBiPd3VMnHApf+/uX63O2pZfvofy
         VYPXrqmB9KtZzwmQQ6mfvrEKzWJJbC59mXpEGY3Z+gbNHqVWFpQvX2cfxjRwRs30REOp
         KIYEAMpZ1cQu8U0jQjKkyIqaHTPKHGgqkn9BSOoSaWDGTYVylAPeNCF/cOyk3WZR9lpr
         n18g==
X-Forwarded-Encrypted: i=1; AJvYcCUjLfWJpRGRh/oOSlcC9Ka5WHqpiOFyfDM5b0sJB/3XsiOxxbYRAF6EpOTCEP3xW2qQXwBKQKEl8Kj2@vger.kernel.org, AJvYcCVpt7X2/LgfCGjWOTVEkWMF726NHyQtkiM+H1+HHm5yOlEgR4y85yLSYx5FVF8T8HjH0kpRwlU0uXbDLIYQ@vger.kernel.org
X-Gm-Message-State: AOJu0YzyxaIyfrVLwxt9DQh8jFMM/hE/xwybemaSDwtk2ThE67W2EZzm
	nrV7H8QBZLlFzsGs+9p9WBByknAVZlyH5NbvxZcg8Bxaj9kAKpCB
X-Gm-Gg: ASbGncv73B85wM4CarAe1eJ+yZ1rRNf+Yxiye227mntsyQYrmBEbPWiZiVD4imI4ZqB
	46le+C0FVmwUev+AS/TglICtBHYogHmFqph1sBUbthGFrwez7w/T+/FvPZb5M6wjlLwvo89MVy1
	Vkag2iSgWxguzso6dc5300Zr6ankp8OgUbsPb5XQvJsQefxIADYgwxclp3UUM2ZwCheAL0XR0Tn
	YTLKPLtnZfSQJSeTcy33Im4K1egwOquY4CoE6KJ4w3TmbXCZRdOnd1k9QIFIGpLPKn/7+VP2fZ5
	rrRKg7BxoFYZXn7P+H1WLafypSCqSR83JmNUySEPE228zSVH04BzaWSf9g0=
X-Google-Smtp-Source: AGHT+IE2GLV5GfCIbE+t6XuZP/5xXdzaXqzsF1704wtdqZOizRzM+e1C7CRQYvBdT3FvqQCIpBjRbA==
X-Received: by 2002:a17:907:3f1c:b0:abe:c811:455c with SMTP id a640c23a62f3a-abed0c67b51mr908046966b.12.1740573144097;
        Wed, 26 Feb 2025 04:32:24 -0800 (PST)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:7b07])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed204625dsm315773266b.125.2025.02.26.04.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2025 04:32:23 -0800 (PST)
Message-ID: <7b440d54-b519-4995-9f5f-f3e636c6d477@gmail.com>
Date: Wed, 26 Feb 2025 12:33:21 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] iomap: propagate nowait to block layer
To: Dave Chinner <david@fromorbit.com>
Cc: io-uring@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
 linux-xfs@vger.kernel.org, wu lei <uwydoc@gmail.com>
References: <ca8f7e4efb902ee6500ab5b1fafd67acb3224c45.1740533564.git.asml.silence@gmail.com>
 <Z76eEu4vxwFIWKj7@dread.disaster.area>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <Z76eEu4vxwFIWKj7@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 04:52, Dave Chinner wrote:
> On Wed, Feb 26, 2025 at 01:33:58AM +0000, Pavel Begunkov wrote:
>> There are reports of high io_uring submission latency for ext4 and xfs,
>> which is due to iomap not propagating nowait flag to the block layer
>> resulting in waiting for IO during tag allocation.
>>
>> Cc: stable@vger.kernel.org
>> Link: https://github.com/axboe/liburing/issues/826#issuecomment-2674131870
>> Reported-by: wu lei <uwydoc@gmail.com>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   fs/iomap/direct-io.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
>> index b521eb15759e..25c5e87dbd94 100644
>> --- a/fs/iomap/direct-io.c
>> +++ b/fs/iomap/direct-io.c
>> @@ -81,6 +81,9 @@ static void iomap_dio_submit_bio(const struct iomap_iter *iter,
>>   		WRITE_ONCE(iocb->private, bio);
>>   	}
>>   
>> +	if (iocb->ki_flags & IOCB_NOWAIT)
>> +		bio->bi_opf |= REQ_NOWAIT;
> 
> ISTR that this was omitted on purpose because REQ_NOWAIT doesn't
> work in the way iomap filesystems expect IO to behave.
> 
> I think it has to do with large direct IOs that require multiple
> calls to submit_bio(). Each bio that is allocated and submitted
> takes a reference to the iomap_dio object, and the iomap_dio is not
> completed until that reference count goes to zero.
> 
> hence if we have submitted a series of bios in a IOCB_NOWAIT DIO
> and then the next bio submission in the DIO triggers a REQ_NOWAIT
> condition, that bio is marked with a BLK_STS_AGAIN and completed.
> This error is then caught by the iomap dio bio completion function,
> recorded in the iomap_dio structure, but because there is still
> bios in flight, the iomap_dio ref count does not fall to zero and so
> the DIO itself is not completed.
> 
> Then submission loops again, sees dio->error is set and aborts
> submission. Because this is AIO, and the iomap_dio refcount is
> non-zero at this point, __iomap_dio_rw() returns -EIOCBQUEUED.
> It does not return the -EAGAIN state that was reported to bio
> completion because the overall DIO has not yet been completed
> and all the IO completion status gathered.
> 
> Hence when the in flight async bios actually complete, they drop the
> iomap dio reference count to zero, iomap_dio_complete() is called,
> and the BLK_STS_AGAIN error is gathered from the previous submission
> failure. This then calls AIO completion, and reports a -EAGAIN error
> to the AIO/io_uring completion code.
> 
> IOWs, -EAGAIN is *not reported to the IO submitter* that needs
> this information to defer and resubmit the IO - it is reported to IO
> completion where it is completely useless and, most likely, not in a
> context that can resubmit the IO.
> 
> Put simply: any code that submits multiple bios (either individually
> or as a bio chain) for a single high level IO can not use REQ_NOWAIT
> reliably for async IO submission.

I know the issue, but admittedly forgot about it here, thanks for
reminding! Considering that attempts to change the situation failed
some years ago and I haven't heard about it after, I don't think
it'll going to change any time soon.

So how about to follow what the block layer does and disable multi
bio nowait submissions for async IO?

if (!iocb_is_sync(iocb)) {
	if (multi_bio)
		return -EAGAIN;
	bio_opf |= REQ_NOWAIT;
}

Is there anything else but io_uring and AIO that can issue async
IO though this path?

> We have similar limitations on IO polling (IOCB_HIPRI) in iomap, but
> I'm not sure if REQ_NOWAIT can be handled the same way. i.e. only
> setting REQ_NOWAIT on the first bio means that the second+ bio can
> still block and cause latency issues.
> 
> So, yeah, fixing this source of latency is not as simple as just
> setting REQ_NOWAIT. I don't know if there is a better solution that
> what we currently have, but causing large AIO DIOs to
> randomly fail with EAGAIN reported at IO completion (with the likely
> result of unexpected data corruption) is far worse behaviour that
> occasionally having to deal with a long IO submission latency.

By the end of the day, it's waiting for IO, the first and very thing
the user don't want to see for async IO, and that's pretty much what
makes AIO borderline unusable. We just can't have it for an asynchronous
interface. If we can't fix it up here, the only other option I see
is to push all such io_uring requests to a slow path where we can
block, and that'd be quite a large regression.

-- 
Pavel Begunkov


