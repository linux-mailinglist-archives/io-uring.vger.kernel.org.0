Return-Path: <io-uring+bounces-1055-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B302E87E068
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 22:36:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1F1971F21EEE
	for <lists+io-uring@lfdr.de>; Sun, 17 Mar 2024 21:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E3491C6BC;
	Sun, 17 Mar 2024 21:36:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DgM4XYG5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B121F21345;
	Sun, 17 Mar 2024 21:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710711364; cv=none; b=BqQA3fhyiOYuV9oi2o5YXXkTe2kKecX2HHCRudQZHq5EhGdsotmjv8DZwioVocQYbaHRf2jPBkA6PsnzUuCuWCZIekwW9wPCo266VGBlTQozhjMO89o6r185VfhnHbCxqzVXKG4Qhjk7lhg/MV2N7lFqRMl+j0aKkc5jnyRcMBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710711364; c=relaxed/simple;
	bh=T2vucFIna7OCbzpU13th+is/7PIi3PsIKeZ/PNgkwk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kRu9AI7JauF0TIq5ptIxFNgBQ/wN/kHbONBC7I+WqRWQ/eXQ2AkTQbGxj0rLIRfkavOQBlIXFMya2vLJ8583mhGY+KzCiz0bCgqtgLkuDZvi64A5SMSf3WGbtZCIUqAtZzrZtnEWd9BEHcqzIdStOJqDhybwV935MnNWKVXGkIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DgM4XYG5; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a46805cd977so341975466b.0;
        Sun, 17 Mar 2024 14:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710711361; x=1711316161; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5j/xzgAgUsQh1o7BgyqmtZcXvdnxs0+nKwK1/4wXzrw=;
        b=DgM4XYG5RWUT2bLvIRLHF9sk/PTcsd+Aw2FCfSgyhstTpJXni6IsEL5VMpC9Pt2vKi
         enNoKsnv/r/UaaBhnrQVkFWJu5vR3Dc/0HaThqnpxQs0ufaPGu4fYW9P716W5dVV9Y/0
         YZUOR9ylTaqKI58UxO8wVrGgCa7My++uuxxxDwU+9b3zmx6LRlooDXnijQKCjXgl3QiC
         j7LYAdnJei/1XCcFg8IgaYu/iIIfdkXQhJrAK35aQ3O3vt2UxS7Q2x8whlH1SMTPAoiX
         xg7hAK3ZqQdL5dexpLozwn+hamMkv1nDB96X2tT/wQL8+Qse8a9axdalbXvL2FpcxFZo
         +W3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710711361; x=1711316161;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5j/xzgAgUsQh1o7BgyqmtZcXvdnxs0+nKwK1/4wXzrw=;
        b=JSqvN/mSfbU5NGvTxUbgVHFspJ49vqudF86faPoPpC/0zeOXznXmUr76f/420RULUC
         B922tc/JEEFYKlThe33YcC6Rk9jC/bYJiAhGt0Ge1v3NmUnAHaLZhTg//9H5pYKoQEMb
         2Nz6clB0MyeL/ZQth3PfKn15v4AlGDTaFOWr2y+zeAtc9/3a+zooqmlZmRmCKz7VyK62
         aKaa3HM62mVRdoLuQH9I368M2HUZkSGW5h6s26boQUH24FGS/AClM3CQxzjbMf7FIp2o
         B+My/JzC1ykUeeF80lx5glYPa8gRsEYmPphFkdzKeZCDCUZ6XzTaEdLHSkP0nEX7meqS
         GSjA==
X-Forwarded-Encrypted: i=1; AJvYcCXiyoQgU6L+KejyABtzVZrVeAcYL6bdi8wU+LBnpiBpZM3c/NU7hLYrH8gA7npkXaqfAX//GY1NZ9kuzBGxINQ4PPvFveKTFplCVDQ=
X-Gm-Message-State: AOJu0YxyJhEwCeLw9q6L+2RjFGQZS1DtgZ4roZJZSa6LznC9ejSxGDth
	apIeYf3WkTnLTYLYQrJHRvCbAHQq64/i8dzae1mEStEe4/AhHq+MUC8OjofZ
X-Google-Smtp-Source: AGHT+IF8DS295/79hZmLSNTYz+gyv8VHIA+lU55O7F6sT7bo2/GvELoIeMMv792HS4e+C6tTzbpiyg==
X-Received: by 2002:a17:906:bc94:b0:a46:bba6:b06a with SMTP id lv20-20020a170906bc9400b00a46bba6b06amr1095433ejb.12.1710711361015;
        Sun, 17 Mar 2024 14:36:01 -0700 (PDT)
Received: from [192.168.8.100] ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id wp12-20020a170907060c00b00a3edb758561sm4098340ejb.129.2024.03.17.14.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Mar 2024 14:36:00 -0700 (PDT)
Message-ID: <6dea0285-254d-4985-982b-39f3897bf064@gmail.com>
Date: Sun, 17 Mar 2024 21:34:45 +0000
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
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4787bb12-bb89-490a-9d30-40b4f54a19ad@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/17/24 21:32, Jens Axboe wrote:
> On 3/17/24 3:29 PM, Pavel Begunkov wrote:
>> On 3/17/24 21:24, Jens Axboe wrote:
>>> On 3/17/24 2:55 PM, Pavel Begunkov wrote:
>>>> On 3/16/24 13:56, Ming Lei wrote:
>>>>> On Sat, Mar 16, 2024 at 01:27:17PM +0000, Pavel Begunkov wrote:
>>>>>> On 3/16/24 11:52, Ming Lei wrote:
>>>>>>> On Fri, Mar 15, 2024 at 04:53:21PM -0600, Jens Axboe wrote:
>>>>>
>>>>> ...
>>>>>
>>>>>>> The following two error can be triggered with this patchset
>>>>>>> when running some ublk stress test(io vs. deletion). And not see
>>>>>>> such failures after reverting the 11 patches.
>>>>>>
>>>>>> I suppose it's with the fix from yesterday. How can I
>>>>>> reproduce it, blktests?
>>>>>
>>>>> Yeah, it needs yesterday's fix.
>>>>>
>>>>> You may need to run this test multiple times for triggering the problem:
>>>>
>>>> Thanks for all the testing. I've tried it, all ublk/generic tests hang
>>>> in userspace waiting for CQEs but no complaints from the kernel.
>>>> However, it seems the branch is buggy even without my patches, I
>>>> consistently (5-15 minutes of running in a slow VM) hit page underflow
>>>> by running liburing tests. Not sure what is that yet, but might also
>>>> be the reason.
>>>
>>> Hmm odd, there's nothing in there but your series and then the
>>> io_uring-6.9 bits pulled in. Maybe it hit an unfortunate point in the
>>> merge window -git cycle? Does it happen with io_uring-6.9 as well? I
>>> haven't seen anything odd.
>>
>> Need to test io_uring-6.9. I actually checked the branch twice, both
>> with the issue, and by full recompilation and config prompts I assumed
>> you pulled something in between (maybe not).
>>
>> And yeah, I can't confirm it's specifically an io_uring bug, the
>> stack trace is usually some unmap or task exit, sometimes it only
>> shows when you try to shutdown the VM after tests.
> 
> Funky. I just ran a bunch of loops of liburing tests and Ming's ublksrv
> test case as well on io_uring-6.9 and it all worked fine. Trying
> liburing tests on for-6.10/io_uring as well now, but didn't see anything
> the other times I ran it. In any case, once you repost I'll rebase and
> then let's see if it hits again.
> 
> Did you run with KASAN enabled

Yes, it's a debug kernel, full on KASANs, lockdeps and so

-- 
Pavel Begunkov

