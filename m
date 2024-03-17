Return-Path: <io-uring+bounces-1057-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE55987E082
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 22:52:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2188A281EA3
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 21:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77FC4208CA;
	Sun, 17 Mar 2024 21:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3EPj3O4R"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0063E208B0
	for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 21:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710712324; cv=none; b=ngAfMcCTRVi0/6yWK6584bY2/YdQVwCHA+LCBogiNlB0ck/YF6wYxYV/wWg1WzKSsSKzI6HScKxyAgGfzkII8iJ2Y/tv47w9Gm+hxer3WSyzLs0hYETGkeNksWAtVAn08YSYhQORJ86rv+HDKxd2qCYma8Qp6qC+FD70MKT0CgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710712324; c=relaxed/simple;
	bh=zKBUpHk5bWXvJRePfbV651VJYwToszSEK9Lh9+OLuAQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G8KqL1zCuIOi9kR4M1OVa83YTZ4f+ISVzXCDBeUTtY3k4b1IA4KyJ5Pa/WVOlurCYZGTJse0epMrmLHyOqS584vo9aj+SpzmJCEo0YGkFIqTjiSmDb3RXdV1X0qW+76F70G/ONv/PgArhbAF6E/WZkQFKg+PNF9MSHxaKXXgZSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3EPj3O4R; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6e6c18e9635so1011551b3a.1
        for <io-uring@vger.kernel.org>; Sun, 17 Mar 2024 14:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710712321; x=1711317121; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PBnt+HOAql+ufONh4WXcHV16Lv/ThthsNQoPCaP5aMY=;
        b=3EPj3O4RcMkWbE+GqFNCvKk1vLGCbR0QD0EmivSec8r5/Eb+zZnw+hda7v+HxYKHMP
         HEIVRp7kAsBjC5yQp1xwqSELl4RR5gHcRls+Heg/ECfjs6zToDDPJYUEp9jkCoCyFISC
         UGC7G5XlmYA54jGqa5OPs+IOvRIpOo4UC0nLJW9xbbTeHq48PSYuevasyvvqa87PfIIR
         UeIJqiycj68QyB6PKPOIQmogMdUyXMh2b+CvtJZwULc6Ms7vH18KPyCP/MuXA+SrYoQg
         w7/5cHEEmmKkVeFXEW5Ol/50pkotKeIxUM3Wk1xBZceuLA4cp/z/+dfQt+aCFmvN79jh
         c19A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710712321; x=1711317121;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PBnt+HOAql+ufONh4WXcHV16Lv/ThthsNQoPCaP5aMY=;
        b=xDudnjejyNfMvOljrvA7igplQJ52a3Q7mU9kuv8k9S10QS+dEoQeFpaah5mf2jU7He
         IuJT9C2ztwrwUuE6W6pPiyp5073fwaaGjfpfv46XcnVJFk9u9YWBMmE68tOeC595tHdA
         Crzxb6/Reqyofbxaueeatuj4pAnb88W7hQQo8ABdNmd/aJ2MZg1ngpve1uw8Y6c3LtD4
         jpB1MGPDEoyDAImuaUXVDHxp41UEaQknJbHk4i/BWb3TLRRQjJ60E7SGScC04Qos2O8g
         IrqqFgSA/Nqtsq4OWAAF7+bgwpklDlcJPk/EqYoDH+VIeXLlvep6QGwBYKMzv6M3PVxP
         p2Lw==
X-Gm-Message-State: AOJu0YwBQOfoDtNr5A+D3I1QjTCgrgNGIBqkNQjoXcEYCHxvvRLG60ow
	4QYabHB/bI72vYUUBvOhrnn2voYFkAehIQw2Fuc5HdW5GlGq6k0QFFlbPLhubjk=
X-Google-Smtp-Source: AGHT+IE6YC2xT2ib8I4FptydreuHGEEgOPQZUY7GeARIgn8xImBxXsROZSt0aCaeU7FWQ729kw9FHA==
X-Received: by 2002:a62:cd4e:0:b0:6e7:256b:d47 with SMTP id o75-20020a62cd4e000000b006e7256b0d47mr1997763pfg.0.1710712321173;
        Sun, 17 Mar 2024 14:52:01 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id h3-20020a654043000000b005dc49afed53sm5040795pgp.55.2024.03.17.14.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 14:52:00 -0700 (PDT)
Message-ID: <d016a590-d7a9-405f-a2e4-d7c4ffa80fce@kernel.dk>
Date: Sun, 17 Mar 2024 15:51:59 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (subset) [PATCH 00/11] remove aux CQE caches
Content-Language: en-US
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
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2091c056-d5ed-44e3-a163-b95680cece27@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/17/24 3:47 PM, Pavel Begunkov wrote:
> On 3/17/24 21:34, Pavel Begunkov wrote:
>> On 3/17/24 21:32, Jens Axboe wrote:
>>> On 3/17/24 3:29 PM, Pavel Begunkov wrote:
>>>> On 3/17/24 21:24, Jens Axboe wrote:
>>>>> On 3/17/24 2:55 PM, Pavel Begunkov wrote:
>>>>>> On 3/16/24 13:56, Ming Lei wrote:
>>>>>>> On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
>>>>>>>> On 3/16/24 11:52, Ming Lei wrote:
>>>>>>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>>>>>>
>>>>>>> ...
>>>>>>>
>>>>>>>>> The following two error can be triggered with this patchset
>>>>>>>>> when running some ublk stress test(io vs. deletion). And not see
>>>>>>>>> such failures after reverting the 11 patches.
>>>>>>>>
>>>>>>>> I suppose it's with the fix from yesterday. How can I
>>>>>>>> reproduce it, blktests?
>>>>>>>
>>>>>>> Yeah, it needs yesterday's fix.
>>>>>>>
>>>>>>> You may need to run this test multiple times for triggering the problem:
>>>>>>
>>>>>> Thanks for all the testing. I've tried it, all ublk/generic tests hang
>>>>>> in userspace waiting for CQEs but no complaints from the kernel.
>>>>>> However, it seems the branch is buggy even without my patches, I
>>>>>> consistently (5-15 minutes of running in a slow VM) hit page underflow
>>>>>> by running liburing tests. Not sure what is that yet, but might also
>>>>>> be the reason.
>>>>>
>>>>> Hmm odd, there's nothing in there but your series and then the
>>>>> io_uring-6.9 bits pulled in. Maybe it hit an unfortunate point in the
>>>>> merge window -git cycle? Does it happen with io_uring-6.9 as well? I
>>>>> haven't seen anything odd.
>>>>
>>>> Need to test io_uring-6.9. I actually checked the branch twice, both
>>>> with the issue, and by full recompilation and config prompts I assumed
>>>> you pulled something in between (maybe not).
>>>>
>>>> And yeah, I can't confirm it's specifically an io_uring bug, the
>>>> stack trace is usually some unmap or task exit, sometimes it only
>>>> shows when you try to shutdown the VM after tests.
>>>
>>> Funky. I just ran a bunch of loops of liburing tests and Ming's ublksrv
>>> test case as well on io_uring-6.9 and it all worked fine. Trying
>>> liburing tests on for-6.10/io_uring as well now, but didn't see anything
>>> the other times I ran it. In any case, once you repost I'll rebase and
>>> then let's see if it hits again.
>>>
>>> Did you run with KASAN enabled
>>
>> Yes, it's a debug kernel, full on KASANs, lockdeps and so
> 
> And another note, I triggered it once (IIRC on shutdown) with ublk
> tests only w/o liburing/tests, likely limits it to either the core
> io_uring infra or non-io_uring bugs.

Been running on for-6.10/io_uring, and the only odd thing I see is that
the test output tends to stall here:

Running test read-before-exit.t

which then either leads to a connection disconnect from my ssh into that
vm, or just a long delay and then it picks up again. This did not happen
with io_uring-6.9.

Maybe related? At least it's something new. Just checked again, and yeah
it seems to totally lock up the vm while that is running. Will try a
quick bisect of that series.

-- 
Jens Axboe


