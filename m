Return-Path: <io-uring+bounces-7979-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3C3BAB75DD
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 21:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 56CEB1BA5342
	for <lists+io-uring@lfdr.de>; Wed, 14 May 2025 19:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EDC8191F98;
	Wed, 14 May 2025 19:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UQElAzQA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBCD28D82E
	for <io-uring@vger.kernel.org>; Wed, 14 May 2025 19:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747250736; cv=none; b=ZZ6NbJEJ4qlzXsRGgyAUrWgAU5rQ6aDdaOdDRXzj/Qx+WJNeFp2H0NmxXkGXZIJIKqo8vYDEKdQUsTedLl0a2usCItAo8yQb/3DtLyT+c4pYh9Qi03t+dRaZVWg+/onxblriQIEclxyXTzjRqHFRxMzhkxFEhGmhyL1v3FnNEw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747250736; c=relaxed/simple;
	bh=0maiJKG/vWGnoA2CSCMz+bGmtCVvPctuM3ZSJVzUddo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=QLleK5qCTRGU3rM8GPjdshvdMc2/qbf4BIUeWcOH7Q7aKBCkD9PiVYyUcsavbXgqACz1Ul2vVasGZz8QEfFQnrOqRYp+psmrrxGJC+AQovQkOKEdFhR2qe9r/Gqg49BPRMj/laVFCrpYMjelAuudow2cKRAcWDIf1U1ISpWnOy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UQElAzQA; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-8647e143f28so6611039f.1
        for <io-uring@vger.kernel.org>; Wed, 14 May 2025 12:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747250731; x=1747855531; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bSm2klEAuDv868oGRm19UVqe97WtES1lrT7ZAki026M=;
        b=UQElAzQA3XhP/BNF20kP349ceQpvmR+5wB4onaa80axomsOuIxQmb2nVQfDjk43edY
         kJV361fTL8jKWs1CBdtOG4Q1w7p9dc1Ke5+coTpxSXuMYs2OEbdf3fe7Jzkwbt+L91th
         cBq8a4S6VbBzU8sbJV3w02P2d7AXyqxE6rHXnyozJRRTJLwzBQNre99CUipoa9meFyZt
         BoGejQpAS4nXTgOQNXynOXJXP7021aWoL35gRsGPaxRmY+QVb9OsYSZMuGBFuIL+5132
         pBulLXpLWrLxl9/xrJ568nCDXfFDE4eSkHloEry1Ngdp7Fw9bRegUK/o2f98mYOadIkY
         Kwtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747250731; x=1747855531;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bSm2klEAuDv868oGRm19UVqe97WtES1lrT7ZAki026M=;
        b=xAvhEd1C6GyQCWby6RthW/I79SA0PsTkkOW8jxWIvJcCzX1PowxB6SIMN+ToTV8kMy
         wrgtWxZu+tYlgfmN/2b7iIfK/bdQuBbaia5oKItGQ1w2aBf8ph6PKawwpZbFAll0kiqR
         IAqnuXS7hHX9VLf34D8Cwjn43iylp9m87B7J9VeEbj/qgG5GWMkOAoP4o3DiKqsFqq0+
         mTJKm2tXvMZCOAoVKeC9jLZzKPgCptkSr7TU+TwZPh0JOM3a/GcAZLnq5XxJ7Jpq8r7X
         9ro5SJTSUgdIeZdwVJr95B+QGtr0tLmSMzpqV0OXT6If/LiH3lRTMahSdHxzbIdRSujR
         NCfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmR+s2z+uKDW3QLUWmHtvoIhM5i23lcNOYrUySE4NR4V/igp12NSFkxxa94Ak71Nurr9fYTPpHTA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz03sjLV5R186Vio94uof8iNTBzk8EmOYpDDi0fR+mhN/l3m5Jc
	MTb4n+S139G+xc5I75aVva00ZDSaWOSTLKoRpb17BWcMWhDgEpMl5yzWDMQqXf8=
X-Gm-Gg: ASbGncvf/VJHGf5HVx02shy6L9ZzgiD+pi1yXhq1KFTmTdPla9a47wOO4TuXTIYszzR
	L3p37ZIHZbKVn3nraEBW+GefKmvA6mtTOgMgPhnc+LCnJtaap20dpqEqY6qgC0jQnnu8wYifyEM
	/FDslp+DJRZd5tWi+1o25zSNDeaeZT0nQ2fiw5N/vjoILSxWmdmvLm8peaQSz9wm0KVYNGnvpb1
	R1G6Ncj2yrC4ZEwU7KKGbCNkPC62W6HDljTjDljNZZzFHF+DIylrH82Pr0/LI99GKOqdTksdsmr
	F8DNtLNoN6KCOPu74sLoiLZnrmtCU0s/evdBqnZkVEMawCU=
X-Google-Smtp-Source: AGHT+IEBMSBrUOD9UJ+JGUYVG7rElRMQbQ2WNweHcyCMq1/THGi4HhaimO3bT4Ne9pZo/SrJjkCAeA==
X-Received: by 2002:a05:6602:36c4:b0:85d:f316:fabc with SMTP id ca18e2360f4ac-86a08de8a01mr641369839f.8.1747250730756;
        Wed, 14 May 2025 12:25:30 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fa2268628dsm2667838173.144.2025.05.14.12.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 May 2025 12:25:30 -0700 (PDT)
Message-ID: <6097e834-29a4-4e49-9c62-758e5b1a3884@kernel.dk>
Date: Wed, 14 May 2025 13:25:29 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] io_uring: move locking inside overflow posting
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1747209332.git.asml.silence@gmail.com>
 <56fb1f1b3977ae5eec732bd5d39635b69a056b3e.1747209332.git.asml.silence@gmail.com>
 <d6634082-86c0-4393-b270-ede60397695e@kernel.dk>
 <d63f55e8-7453-46fb-a85a-03e6de14402f@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d63f55e8-7453-46fb-a85a-03e6de14402f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/14/25 11:18 AM, Pavel Begunkov wrote:
> On 5/14/25 17:42, Jens Axboe wrote:
>> On 5/14/25 2:07 AM, Pavel Begunkov wrote:
> ...>> +static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, bool locked,
>>> +                     u64 user_data, s32 res, u32 cflags,
>>> +                     u64 extra1, u64 extra2)
>>> +{
>>> +    bool queued;
>>> +
>>> +    if (locked) {
>>> +        queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
>>> +                            extra1, extra2);
>>> +    } else {
>>> +        spin_lock(&ctx->completion_lock);
>>> +        queued = __io_cqring_event_overflow(ctx, user_data, res, cflags,
>>> +                            extra1, extra2);
>>> +        spin_unlock(&ctx->completion_lock);
>>> +    }
>>> +    return queued;
>>> +}
>>
>> Really not a fan of passing in locking state and having a split helper
>> like that.
> 
> I'd agree in general, but it's the same thing that's already in
> __io_submit_flush_completions(), just with a named argument
> instead of backflipping on ctx->lockless_cq.

And I honestly _greatly_ prefer that to passing in some random bool
where you have to go find the function to even see what it does...

>> It's also pretty unwieldy with 7 arguments.
> 
> It's 6 vs 7, not much difference, and the real problem here is
> passing all cqe parts as separate arguments, which this series
> doesn't touch.

It's 6 you're passing on, it's 7 for the overflow helper.

>> Overall, why do we care about atomic vs non-atomic allocations for
>> overflows? If you're hitting overflow, you've messed up... And if it's
> 
> Not really, it's not far fetched to overflow with multishots unless
> you're overallocating CQ quite a bit, especially if traffic is not so
> homogeneous and has spikes. Expensive and should be minimised b/c of
> that, but it's still reasonably possible in a well structured app.

It's still possible, but it should be a fairly rare occurence after all.

>> about cost, gfp atomic alloc will be predictable, vs GFP_KERNEL which
>> can be a lot more involved.
> 
> Not the cost but reliability. If overflowing fails, the userspace can't
> reasonably do anything to recover, so either terminate or leak. And
> it's taking the atomic reserves from those who actually need it
> like irq.

I don't really disagree on that part, GFP_ATOMIC is only really used
because of the locking, as this series deals with. Just saying that
it'll make overflow jitter more pronounced, potentially, though not
something I'm worried about. I'd much rather handle that sanely instead
of passing in locking state. At least a gfp_t argument is immediately
apparent what it does.

-- 
Jens Axboe

