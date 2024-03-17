Return-Path: <io-uring+bounces-1060-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2CC487E10F
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:18:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA2671C203AC
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 23:18:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FF6C21106;
	Sun, 17 Mar 2024 23:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LvBFhXsm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980861E865;
	Sun, 17 Mar 2024 23:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710717509; cv=none; b=MQbZfDMW7ZkRD84uFCQdLlYzJpQZDePaL8QMz0FIbQkEnalSaPwTwq7jN7WneZIBLXt1tjb7VH+UwhSc90sj3uIHhvYNttjB1ZkSsIcHaSpQpYm9ZdAWD4Q0bdd1LlgUuOjZR+ct8clZ+6Drk9IOpty3aEePdVpMP1Oe8CEMWgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710717509; c=relaxed/simple;
	bh=t+9lHfW4GY51D0s16r+COHTr0Wq4brtXJw0s11XnBF0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TfBExi5KMMYC1ZZ681odnFNSowC8AEkqjtdlNZGcjXpT5hYXXLmuT/YYxRniZ2WT48CsinhTVSRZgT1331xtxI1ygGAfLesNKM1C4Q4Xcl1QTH7laQGBgnBLQtb5RdKo464oQVhllqPibblQnw9Q/9TUzNCwxFk15LholKipFLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LvBFhXsm; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a46a7b8e07fso166139566b.2;
        Sun, 17 Mar 2024 16:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710717506; x=1711322306; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZmIir/0Sj+vqC7nqRh/sdFxUgY87CYVS6jyHEBfp/Pw=;
        b=LvBFhXsmASoPoxnT4h1LrD9rqkbnAggTlBSrqxg7zaCnylG6OzIOvipSXENNpa6YQl
         24ESPY706O5maEW2Of1AOY0nrstKhSv0F71t8Mu+CGxxiUnIlLupAjFFOU+NgXI31Mqz
         Kmkp44wxPbDlUGY+uZ1N96pzf/d6FK/DE5H17iMMU2rJO841V5obC+NPyH2MmBhwArqK
         xr8Ly13wU7qsHrxJqRqWam2/oNOS9Tcyr043ooTQhkOEXpS1DUnk2FP6xPtG2igCNuww
         dbhfmTklxmpV+XwZQlL2prRcF9+FkQ6RDQPiHnPc/6yLXlvvMAIx2iURTkqcPz0LHz9j
         OzZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710717506; x=1711322306;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZmIir/0Sj+vqC7nqRh/sdFxUgY87CYVS6jyHEBfp/Pw=;
        b=hgvLR8VOtmzqOJf2eAOjxHlGiB3NgXRx673ymMlyhPsPo/sGt9ZIfpGyHWLB/VClEo
         l3IPjsBPrn3dP/VLKPYv0PRK/7zKkI2rlM/dFNWQJMSmV6CDgiB0VG6CwpXMkqnpT7qf
         njkRqGJxu5exWHHrDpNJb9WTGNdwm0+CxS/xYpxmTJWdtnd1mrJtXj+F4bAYkdgZJqpp
         xz3+0hjdHYfrwNE7e8W7WIO2d2KW/48hTgqrboJpPuHSXYoQkQcx4Cd4hz6gR/dggeVr
         T5rxZ9tgtJGoyKTpni4EslA7q7J0i9+MZzjVd5y1VK8UHtJm0NIOTDuh/3nurMZqwK09
         c+uw==
X-Forwarded-Encrypted: i=1; AJvYcCUHKwCUR6eR8S1tB8fFblzsUS0CFWu+hCLVfSHd73lX1NywTgAFAfb2+khGOokfcA3/jMKnRa7T8KQaC7L1PNv6aISkIyR71x854+s=
X-Gm-Message-State: AOJu0YyTZpzW/QcSAI8fFHizzNHvRv4OWs6YPFgLU6dHYUrZiWYiGjlY
	p7I4L9tS8stLse/R69B42IA2Ob3E4Xav03ny1M1KsNW/f1/gypODsqHUQR8g
X-Google-Smtp-Source: AGHT+IGfiR15obBoP4havGKDS+Z+h43Ox1Kd/T44lBvuVQA9Joz2VS9URFl2jH+bzipQ8Z66VfQWiw==
X-Received: by 2002:a17:907:1707:b0:a46:7dc1:e4d1 with SMTP id le7-20020a170907170700b00a467dc1e4d1mr6647937ejc.73.1710717505671;
        Sun, 17 Mar 2024 16:18:25 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id st6-20020a170907c08600b00a46af639a77sm1368669ejc.172.2024.03.17.16.18.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 16:18:25 -0700 (PDT)
Message-ID: <07c027c1-4702-4d09-bf2f-88ff1958fdb4@gmail.com>
Date: Sun, 17 Mar 2024 23:16:59 +0000
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
 <d3beeb72-c4cf-4fad-80bc-10ca1f035fff@gmail.com>
 <4787bb12-bb89-490a-9d30-40b4f54a19ad@kernel.dk>
 <6dea0285-254d-4985-982b-39f3897bf064@gmail.com>
 <2091c056-d5ed-44e3-a163-b95680cece27@gmail.com>
 <d016a590-d7a9-405f-a2e4-d7c4ffa80fce@kernel.dk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <d016a590-d7a9-405f-a2e4-d7c4ffa80fce@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/24 21:51, Jens Axboe wrote:
> On 3/17/24 3:47 PM, Pavel Begunkov wrote:
>> On 3/17/24 21:34, Pavel Begunkov wrote:
>>> On 3/17/24 21:32, Jens Axboe wrote:
>>>> On 3/17/24 3:29 PM, Pavel Begunkov wrote:
>>>>> On 3/17/24 21:24, Jens Axboe wrote:
>>>>>> On 3/17/24 2:55 PM, Pavel Begunkov wrote:
>>>>>>> On 3/16/24 13:56, Ming Lei wrote:
>>>>>>>> On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
>>>>>>>>> On 3/16/24 11:52, Ming Lei wrote:
>>>>>>>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>>>>>>>
>>>>>>>> ...
>>>>>>>>
>>>>>>>>>> The following two error can be triggered with this patchset
>>>>>>>>>> when running some ublk stress test(io vs. deletion). And not see
>>>>>>>>>> such failures after reverting the 11 patches.
>>>>>>>>>
>>>>>>>>> I suppose it's with the fix from yesterday. How can I
>>>>>>>>> reproduce it, blktests?
>>>>>>>>
>>>>>>>> Yeah, it needs yesterday's fix.
>>>>>>>>
>>>>>>>> You may need to run this test multiple times for triggering the problem:
>>>>>>>
>>>>>>> Thanks for all the testing. I've tried it, all ublk/generic tests hang
>>>>>>> in userspace waiting for CQEs but no complaints from the kernel.
>>>>>>> However, it seems the branch is buggy even without my patches, I
>>>>>>> consistently (5-15 minutes of running in a slow VM) hit page underflow
>>>>>>> by running liburing tests. Not sure what is that yet, but might also
>>>>>>> be the reason.
>>>>>>
>>>>>> Hmm odd, there's nothing in there but your series and then the
>>>>>> io_uring-6.9 bits pulled in. Maybe it hit an unfortunate point in the
>>>>>> merge window -git cycle? Does it happen with io_uring-6.9 as well? I
>>>>>> haven't seen anything odd.
>>>>>
>>>>> Need to test io_uring-6.9. I actually checked the branch twice, both
>>>>> with the issue, and by full recompilation and config prompts I assumed
>>>>> you pulled something in between (maybe not).
>>>>>
>>>>> And yeah, I can't confirm it's specifically an io_uring bug, the
>>>>> stack trace is usually some unmap or task exit, sometimes it only
>>>>> shows when you try to shutdown the VM after tests.
>>>>
>>>> Funky. I just ran a bunch of loops of liburing tests and Ming's ublksrv
>>>> test case as well on io_uring-6.9 and it all worked fine. Trying
>>>> liburing tests on for-6.10/io_uring as well now, but didn't see anything
>>>> the other times I ran it. In any case, once you repost I'll rebase and
>>>> then let's see if it hits again.
>>>>
>>>> Did you run with KASAN enabled
>>>
>>> Yes, it's a debug kernel, full on KASANs, lockdeps and so
>>
>> And another note, I triggered it once (IIRC on shutdown) with ublk
>> tests only w/o liburing/tests, likely limits it to either the core
>> io_uring infra or non-io_uring bugs.
> 
> Been running on for-6.10/io_uring, and the only odd thing I see is that
> the test output tends to stall here:

can't trigger with io_uring-5.9, which makes sense because the
patchset was done on top of it and tested w/o problems.

-- 
Pavel Begunkov

