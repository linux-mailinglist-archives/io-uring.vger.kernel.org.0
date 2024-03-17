Return-Path: <io-uring+bounces-1053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E8FF87E05D
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 22:31:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 347E11F21CD0
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 21:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A4E51C6BC;
	Sun, 17 Mar 2024 21:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GDhjDwiq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C802110B;
	Sun, 17 Mar 2024 21:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710711054; cv=none; b=gmaNo/u19CO9YwT13LHW75sQxhUBSV8BlJo+5rKW6NQUInqFwENG4Lt3gdsJsBM2/ynYI3+aAwg07aN9Q6m0VtqoKou73640RgIgkZATNDYti9lD8nUcNbvkODr1uhKiWhVPioBwFR8LkUXUT4cF59TlOIurLzpk5w/4S7zsr08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710711054; c=relaxed/simple;
	bh=yainoJ+DFm4cFTZ3zcyPaZnslmd6nyH+Tsa/F+hQZSQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eH3zDI9EDNXqXseY9XeHpzBtgTeL+EZZ3uXOoBJVK2Auq44an0Y11jdn+RLP+C5QbQVFl88ZMm488fPypqlxZwa6sHS8+rrzSKdyO/qyLBAOqdpGmIdCrGgWnIPxk2sDQ5QutHtwkgIdJu7Isur8gJXkJdlYyyGBTcU0BCc4J8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GDhjDwiq; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-563bb51c36eso4249612a12.2;
        Sun, 17 Mar 2024 14:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710711051; x=1711315851; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3stFoDmp42R9F9k9PUHLs67FXoP8Mpgc0WG8W+sMe08=;
        b=GDhjDwiqEsNoQVDfby93+63ko0/iez7fBq5yEqwudXkvoR8DSjytgfvVCvXIWV+zKp
         +qdCT8rzVCEgDApED9x9UKYNMCQ4TZ2cNQ9kaA+OA9rqtpAfGirt2f8XLM1r8MzC3Ot8
         7/Pz67etdjIwR/41WASVcHI4U4aBxG94F4WSK88li5EfneSpm0yntWk+6gRgl6z9j06P
         H0+bqb3NvecArg2rRxDByr/grw607imNwcVhli7+Mr1lHU4FOSCdnAlQCf4jsCz1doe2
         UzFQn98VJ0EbP/x+J7kKaEADvr1pYkeyMO92zKYZRTP1p3DKNf8wWpP+NNHzRZEKQsmO
         QSMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710711051; x=1711315851;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3stFoDmp42R9F9k9PUHLs67FXoP8Mpgc0WG8W+sMe08=;
        b=s7F9hpDqXXrbCa6XpLd6koRViCRqDOSw1zQfjSEL/wruoFJw+SQyDXR788pxugS3Qm
         EUAdxItIUCvxg/6IxYYaW+uhaZbysgimtCnM5OnJuI0qhUwQcpej8lLfvVwZqNwkS0LA
         Sb6Q3dysCqWm+CZoLSlyXGsxIW96NBHF796Txc1CKI59Xgn1p7CTpCEvs9vKt2zc29by
         wj13dWhvEuRZs6XVheHPxhhUhtcI0HTafEjVvstBh+SGA4ohma5MX7iHxAPJf1O/ngQ1
         PDGDxZPKlJHy+TLXxrYi+7opl1bxGZhGUNzD8p6Mi3sGpzjXgdpJjgYwtKQHt5E6i19N
         Ymvw==
X-Forwarded-Encrypted: i=1; AJvYcCUkU4fGvbK4uPlOq7bxCV0NA4dpPV+vIXnlBAvyt4PnrpeQXGCDxSoKfLRJu6qp2Xa/F8RWuFErCKWKRWNl4/oLhh1qmUXh0/H3Hb0=
X-Gm-Message-State: AOJu0YwFQRO+g6Jy8nQUquGZyzspbAnewOzwdEoG33p5HGdrMlUQR+w7
	xVhNHt7y29BrpyoiWl1f72RHcEJBuo7XTunJ/7PhKZLN7seX4I+S
X-Google-Smtp-Source: AGHT+IG5DQ2BvucpPPiC1qgOgFzad/bR8tAhqrkNWNyiahPep0Fd8a+pguEATqh/z6q+mibJGMWjZw==
X-Received: by 2002:a05:6402:2ca:b0:568:b95f:5398 with SMTP id b10-20020a05640202ca00b00568b95f5398mr3666841edx.38.1710711050434;
        Sun, 17 Mar 2024 14:30:50 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id m24-20020aa7d358000000b0056729e902f7sm3909772edr.56.2024.03.17.14.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 14:30:50 -0700 (PDT)
Message-ID: <d3beeb72-c4cf-4fad-80bc-10ca1f035fff@gmail.com>
Date: Sun, 17 Mar 2024 21:29:35 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfWIFOkN/X9uyJJe@fedora> <29b950aa-d3c3-4237-a146-c6abd7b68b8f@gmail.com>
 <ZfWk9Pp0zJ1i1JAE@fedora> <1132db8f-829f-4ea8-bdee-8f592b5e3c19@gmail.com>
 <e25412ba-916c-4de7-8ed2-18268f656731@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <e25412ba-916c-4de7-8ed2-18268f656731@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/24 21:24, Jens Axboe wrote:
> On 3/17/24 2:55 PM, Pavel Begunkov wrote:
>> On 3/16/24 13:56, Ming Lei wrote:
>>> On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
>>>> On 3/16/24 11:52, Ming Lei wrote:
>>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>>
>>> ...
>>>
>>>>> The following two error can be triggered with this patchset
>>>>> when running some ublk stress test(io vs. deletion). And not see
>>>>> such failures after reverting the 11 patches.
>>>>
>>>> I suppose it's with the fix from yesterday. How can I
>>>> reproduce it, blktests?
>>>
>>> Yeah, it needs yesterday's fix.
>>>
>>> You may need to run this test multiple times for triggering the problem:
>>
>> Thanks for all the testing. I've tried it, all ublk/generic tests hang
>> in userspace waiting for CQEs but no complaints from the kernel.
>> However, it seems the branch is buggy even without my patches, I
>> consistently (5-15 minutes of running in a slow VM) hit page underflow
>> by running liburing tests. Not sure what is that yet, but might also
>> be the reason.
> 
> Hmm odd, there's nothing in there but your series and then the
> io_uring-6.9 bits pulled in. Maybe it hit an unfortunate point in the
> merge window -git cycle? Does it happen with io_uring-6.9 as well? I
> haven't seen anything odd.

Need to test io_uring-6.9. I actually checked the branch twice, both
with the issue, and by full recompilation and config prompts I assumed
you pulled something in between (maybe not).

And yeah, I can't confirm it's specifically an io_uring bug, the
stack trace is usually some unmap or task exit, sometimes it only
shows when you try to shutdown the VM after tests.

>> I'll repost it with the locking fix for reference, would make more
>> sense retesting ublk after figuring out what's up with the branch.
> 
> Yep if you repost it with the fix, I'll rebase for-6.10/io_uring.
> 

-- 
Pavel Begunkov

