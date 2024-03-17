Return-Path: <io-uring+bounces-1058-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5236387E090
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 23:07:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CDB721F21535
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 22:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDA2520B3E;
	Sun, 17 Mar 2024 22:07:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2lpWsWEm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320AE1F61C
	for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 22:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710713264; cv=none; b=qYwHo7G6xBisEd52oc7dowVhOXADq0mOtbQfvZp1o3MyiSJRrKstDXlmD3xQ+MeqrCgI912KAqM6mT83peDFGNPreS98km4Q7y6CkDkVZCG3OL/mSJeprquyhU6GcHeNerLWIWfDqc80XHVdh1yFREsIAWubRYclfp3XESNqmqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710713264; c=relaxed/simple;
	bh=wG6E+aC1mJvNsCQWiDSFF1BoJzlOrUQqIOT4so6R+Vw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=TfpDoCgJIXz13jWBcA+pnHMch21opK5yqMkspxexwxRF7xpKB4KL1ESS3kFKN0n+QCMX6jgAQ24yIYLsvsV5w5eQfXBnIC8Ix0g8UwX0zMlAU/lzDLUju5tKU9gsxZOvGWgm0YcOLoC3+qPub/DKrycYQ/UtYpHG58waJ/wDyTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2lpWsWEm; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-29c572d4b84so1353691a91.1
        for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 15:07:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710713261; x=1711318061; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A4TFtBiEUAjdt5sqTy/pdL9GbBoMU2xSFnWyrN2Tn5s=;
        b=2lpWsWEmyMXQfwivh9cbe9T3XL2AsoA2pyUa2IPqGAEuE0kGpP8YMBXMXdIo401WO+
         ioESmHt+IZgZtFczAMAnx4DRtQUBcLJVd/mS4SHKlotdlXeLdztjzsloP85OJP7mxRPp
         hcscFRrE7p+AjYUK4avNoBP0EOx+6w5QTqLewF3NbldIssK7syesmuTm+415Fh/Y4vvv
         NXUvaYRnMDdYH6dmxBinf8Abq2Kmb1t/45ZDb0i97+DSZcOWlRDaBA/MvcFhIzTkGzZu
         7Sop//Dmid81i8IW2xoNlXfbIE4YJ1tJ2i4niBrjXmZkYfM46wYPmfKK9XQ8qXejImaf
         o0sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710713261; x=1711318061;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A4TFtBiEUAjdt5sqTy/pdL9GbBoMU2xSFnWyrN2Tn5s=;
        b=mYMO8UmIxpDDGDTKyyrc03TjY1IvFBLmXIviylKNo4APMoJQF8DQ1xj4o4L13XcFSt
         jXLt3ZdtLnPBDq4Rsvmde7pob3OIMGrX5eb/ElCcGVJicZcUZUlAA95HBJXxbnsF9ym9
         PPd5fS9bX7a+lr3ubx2Qa0w42s80cW4ukptH2m2fqnkORrBouBc9OC5S2ST1aOI4iltw
         BkDFLv4SMzSFAFzy1Rm3uoG4icdJGB55uMnWK/LIgvnUCkptlBz4Q5rwbCdCvvNGBe4T
         Q6z1r0957X02uH5MZ7SxdtgLuZ43/qXIUt+TfEnDwfmRbb9vdC6uBNg/USmobsaqS3UM
         76Sg==
X-Gm-Message-State: AOJu0YyLYEc092nJP9HBRzZk6ydqNDNUrXrCssiIn7o4dRRtKfw7sYv9
	XzeVaOBGxl30RqDwW2bsLMkwWgp1wsW3O2S/wBErZOj9s5XSlMGqqAr6PhPZeUs=
X-Google-Smtp-Source: AGHT+IGyKOX+IIcJQ1uGd26tsDU+iPkeX2FU6z/8z+1d2Mg+6Wfx3A0TbCnxQUGoUOyF93LPWsTrvg==
X-Received: by 2002:a17:902:dac8:b0:1dd:528e:9b8 with SMTP id q8-20020a170902dac800b001dd528e09b8mr13492530plx.5.1710713261450;
        Sun, 17 Mar 2024 15:07:41 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090301c500b001dcc7795524sm295404plh.24.2024.03.17.15.07.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 15:07:40 -0700 (PDT)
Message-ID: <4c47f80f-df74-4b27-b1e7-ce30d5c959f9@kernel.dk>
Date: Sun, 17 Mar 2024 16:07:39 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>, Ming Lei <ming.lei@redhat.com>
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
In-Reply-To: <d016a590-d7a9-405f-a2e4-d7c4ffa80fce@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/24 3:51 PM, Jens Axboe wrote:
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
> 
> Running test read-before-exit.t
> 
> which then either leads to a connection disconnect from my ssh into that
> vm, or just a long delay and then it picks up again. This did not happen
> with io_uring-6.9.
> 
> Maybe related? At least it's something new. Just checked again, and yeah
> it seems to totally lock up the vm while that is running. Will try a
> quick bisect of that series.

Seems to be triggered by the top of branch patch in there, my poll and
timeout special casing. While the above test case runs with that commit,
it'll freeze the host.

-- 
Jens Axboe


