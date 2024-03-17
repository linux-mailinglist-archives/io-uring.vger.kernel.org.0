Return-Path: <io-uring+bounces-1056-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 984BA87E07F
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 22:48:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3813F1F2103B
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 21:48:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF0141F941;
	Sun, 17 Mar 2024 21:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M1HiywTU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236AB1B7F7;
	Sun, 17 Mar 2024 21:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710712123; cv=none; b=RE0K8062mB7ffXAyjELXO3ThrN2ptBA39Yr5DRt7Yzdtd3BQ7IIezoSYpPerliH3ghvq8haA8bjYsbL751WLvvanI4vrktKREfHa/Wz/cLv2MoH9g2HjmLvf91AtwfoGnFJePhlLoE747f3cNmTwncyHd7HlXS5pbUHo10otQm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710712123; c=relaxed/simple;
	bh=539kVwokxj9LsZK9gw12ozKDeP71wWs+9mZAXpUMoWE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=e01cpRvf+DXMO4Uync8wpT7PQ0+lqxvhPZ5ZilnOGCZbleinxW7zYilBIyRo7dV0tSghbSdBiTPUnx/Cz/yf7lr87CJeNo5RSerR2Qtn9cZYBOaZXER2Z6zy9xJZkYHtjWmAW5LbSqVDUQs5DfBaVsunmVWA7xDx3XKwAbTayDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M1HiywTU; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5658082d2c4so4732996a12.1;
        Sun, 17 Mar 2024 14:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710712120; x=1711316920; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T8ZaChGSRyFZ7pp/EFtnSU9MPz8q9t4F+7RJSv79BW8=;
        b=M1HiywTUOGkLj6OFU8IiIO0Is/28qowLnEwFN2cCWEHtlBGIrqBTV3YF3Ok+RD5R5g
         lxt0nP9PEDOlVl71v7jyvjZoNso3TAnRXMUTCQFD2IF9DhMM7/hZnfsVIdRbP/q55uvS
         M4lsOojm57udu0XNUdRbdNr0fK1/G6Jw0puZaAWKSANf+YeRXdXwCL8UzsMRPdO3/egM
         r6vPrTvbZrDh6CDkeKowms9nH2Z/7F16reIycblSiE/4+X6XtbqwZ0Hkl7qL0dJurSSb
         MgqGcwI9ZrulNCeWYP04TgiKAslWOZ5LPrboo9HPLAAaKVA5OPQTkYAjDdkAItUteIpM
         2F8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710712120; x=1711316920;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T8ZaChGSRyFZ7pp/EFtnSU9MPz8q9t4F+7RJSv79BW8=;
        b=iyxFYscRCO2Ydru4h4ZF8eeuIXw/QZf9XcChN5tQjnoaDh9kiw7zC/MFisCKGFB+rB
         AOy2iq05pHkAmuHYXSP+CJ71Y3juh11tbSDaeFmBMKGFm0bZwLKQLhXkFnLiV+/zzMhh
         qEQ1Fa/xx61B8A+5ev+6dKdBjJMUfxB1cS7Km+k/UEEpjnknpdyXHJ0/Z8P1hSiM7Rs0
         RidcRW91CnZbU31A8M6R/rU7PL4Mcw8Y35i4pZ5hhWy++tL6InnJ1e6YPIKR7tYZGxue
         dqZdsHKwqpQy5up1rvXX5IxV7ILZSMW/VDAQIMlZPQ8X4te7cUpoS6kby+wAhc0bBm0D
         rxYw==
X-Forwarded-Encrypted: i=1; AJvYcCVb56JeEhtm4A4m7BgT6qYstAL4RVSX/bRzdHss6VLi0/1HwBbZBN3x78MNeuThQRez8MMKRfx45qm/0ebXdF4a6GdPaTgZc8xCdzc=
X-Gm-Message-State: AOJu0YxNzFbf+Ed77fASVkIBLlJChZmxChWvfW2LEC6d2TZYd9zDv/yw
	GHDd4yr1Rhj/j3OQ9jLozCXjKpP8tAIzlbaQaoA0EXRoAIz+dqjjmWjeq2sY
X-Google-Smtp-Source: AGHT+IFJkYz46ZuTd9/1gMfdtDbEULPkwqx9BSImJrBTnsiW7LBSEzw0zQ6Rq5zH4D8h87cdMYSBiQ==
X-Received: by 2002:a17:906:489:b0:a46:643d:5de6 with SMTP id f9-20020a170906048900b00a46643d5de6mr6585543eja.47.1710712120348;
        Sun, 17 Mar 2024 14:48:40 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id qw37-20020a1709066a2500b00a4131367204sm4101524ejc.80.2024.03.17.14.48.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 14:48:40 -0700 (PDT)
Message-ID: <2091c056-d5ed-44e3-a163-b95680cece27@gmail.com>
Date: Sun, 17 Mar 2024 21:47:23 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Cc: io-uring@vger.kernel.org, linux-block@vger.kernel.org,
 Kanchan Joshi <joshi.k@samsung.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
 <171054320158.386037.13510354610893597382.b4-ty@kernel.dk>
 <ZfWIFOkN/X9uyJJe@fedora> <29b950aa-d3c3-4237-a146-c6abd7b68b8f@gmail.com>
 <ZfWk9Pp0zJ1i1JAE@fedora> <1132db8f-829f-4ea8-bdee-8f592b5e3c19@gmail.com>
 <e25412ba-916c-4de7-8ed2-18268f656731@kernel.dk>
 <d3beeb72-c4cf-4fad-80bc-10ca1f035fff@gmail.com>
 <4787bb12-bb89-490a-9d30-40b4f54a19ad@kernel.dk>
 <6dea0285-254d-4985-982b-39f3897bf064@gmail.com>
In-Reply-To: <6dea0285-254d-4985-982b-39f3897bf064@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/24 21:34, Pavel Begunkov wrote:
> On 3/17/24 21:32, Jens Axboe wrote:
>> On 3/17/24 3:29 PM, Pavel Begunkov wrote:
>>> On 3/17/24 21:24, Jens Axboe wrote:
>>>> On 3/17/24 2:55 PM, Pavel Begunkov wrote:
>>>>> On 3/16/24 13:56, Ming Lei wrote:
>>>>>> On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
>>>>>>> On 3/16/24 11:52, Ming Lei wrote:
>>>>>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>>>>>
>>>>>> ...
>>>>>>
>>>>>>>> The following two error can be triggered with this patchset
>>>>>>>> when running some ublk stress test(io vs. deletion). And not see
>>>>>>>> such failures after reverting the 11 patches.
>>>>>>>
>>>>>>> I suppose it's with the fix from yesterday. How can I
>>>>>>> reproduce it, blktests?
>>>>>>
>>>>>> Yeah, it needs yesterday's fix.
>>>>>>
>>>>>> You may need to run this test multiple times for triggering the problem:
>>>>>
>>>>> Thanks for all the testing. I've tried it, all ublk/generic tests hang
>>>>> in userspace waiting for CQEs but no complaints from the kernel.
>>>>> However, it seems the branch is buggy even without my patches, I
>>>>> consistently (5-15 minutes of running in a slow VM) hit page underflow
>>>>> by running liburing tests. Not sure what is that yet, but might also
>>>>> be the reason.
>>>>
>>>> Hmm odd, there's nothing in there but your series and then the
>>>> io_uring-6.9 bits pulled in. Maybe it hit an unfortunate point in the
>>>> merge window -git cycle? Does it happen with io_uring-6.9 as well? I
>>>> haven't seen anything odd.
>>>
>>> Need to test io_uring-6.9. I actually checked the branch twice, both
>>> with the issue, and by full recompilation and config prompts I assumed
>>> you pulled something in between (maybe not).
>>>
>>> And yeah, I can't confirm it's specifically an io_uring bug, the
>>> stack trace is usually some unmap or task exit, sometimes it only
>>> shows when you try to shutdown the VM after tests.
>>
>> Funky. I just ran a bunch of loops of liburing tests and Ming's ublksrv
>> test case as well on io_uring-6.9 and it all worked fine. Trying
>> liburing tests on for-6.10/io_uring as well now, but didn't see anything
>> the other times I ran it. In any case, once you repost I'll rebase and
>> then let's see if it hits again.
>>
>> Did you run with KASAN enabled
> 
> Yes, it's a debug kernel, full on KASANs, lockdeps and so

And another note, I triggered it once (IIRC on shutdown) with ublk
tests only w/o liburing/tests, likely limits it to either the core
io_uring infra or non-io_uring bugs.

-- 
Pavel Begunkov

