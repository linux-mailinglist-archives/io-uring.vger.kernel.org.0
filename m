Return-Path: <io-uring+bounces-9902-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 832C1BBE3EF
	for <lists+io-uring@lfdr.de>; Mon, 06 Oct 2025 15:56:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 7A80C4ED5B7
	for <lists+io-uring@lfdr.de>; Mon,  6 Oct 2025 13:56:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2343E2D3750;
	Mon,  6 Oct 2025 13:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TAcdddkn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F272D3EDC
	for <io-uring@vger.kernel.org>; Mon,  6 Oct 2025 13:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759758981; cv=none; b=BtIhR9X1DaBeMYx24N0vVnmQNmJxHw0TLnZ2z0qqpUHg0YXkk5gKNXsxUWxAxVfCxTSLL9kggZhTHJDfmZcaR4zrcgWnByNksLK6RTX/nWsRPrhW5wMGN9xHsmW4fJXIPIIbn/IPGt6WiO9iq0FyLycHR3LOxgXZR28iybNW5k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759758981; c=relaxed/simple;
	bh=LHtVk1sb4nGUzM4ao+nUUGDUNkSTY3InHYtT4/ZYiRU=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TZtdquJoggzrCTqWH90cod4P0YCMqUx0kYHeBLV7pQRjHQfmDuL6aL5ZGFh1KaDR7mwfImx5AIKtljluabgh+7qJQC6AVVKs38rgkuWSSL2S4moJDi3fK6G5IQwHFC8cthIBZFlvVPKsM6NtCzaJtkr9GSgelF1EezTJmQzW9DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TAcdddkn; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-90a0b3ddebeso197944239f.0
        for <io-uring@vger.kernel.org>; Mon, 06 Oct 2025 06:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1759758978; x=1760363778; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mwYJNZr+gNvFkmJOE4Lj5NFOul5TMVX5VErELiclFic=;
        b=TAcdddkn1yXTJjPO8FfI33SG2NJyKgQFw2qlPEq9AVSLqlyMUZg591LSve6hcKIBzF
         hZRB1JPbxulGW+qcD5gB6Eq4jeJ5Lh06vldvLImaMOX4LVzfUwCAbyzEb3ZwRTDjCKHo
         78HGVxSq96Of7aAAV4naS0S7K0hd2sQFKgO8ASA6VZ6Nmykpv4BkmsOcbxjJGHydmXKo
         Qh1oVmiiFI3dBcgDGiyjauWgINQFJmZJocbyVehwAd+ZaqGivC3UHtGrwr+h1YPLadvu
         KAHjg6YUu/nMHO62atHiVQB4EHZuwuHYXuzt13syctlKGUpvGDdprtXuwzY/f3O0aDqo
         LsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759758978; x=1760363778;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mwYJNZr+gNvFkmJOE4Lj5NFOul5TMVX5VErELiclFic=;
        b=F/CTseDIRLYOARMYeNC1+j+Jhl0Or91eCeom4qtPWqGEPfTPhGdPCWVBvE740igVJO
         lvgJ4fs/ljspt4tdT8rosNzhAejQlYkyOCAcZH2xEw8j6Lus+Ttd1AHA3qd3Vr+XP32W
         U6+lcDMBkV5Ze7+tl10jzkS9TsgW49LpyON0q2fDWjFVUO3aFMCBk5RF9Pf5ZPEhgJnn
         d42dzxVsuTvu2c6CNOo5vV4OX8SDU1ZFnAdoWe8hR6KHxM5u2micUbywgb5SYJhf370C
         fmiqJVRry1sHy9iG4sMD1Okm3HqiSz86IiCSHaEtwgTOsOGZA9w3Rj80XA2h7Z78/GSp
         MGzA==
X-Forwarded-Encrypted: i=1; AJvYcCVSwmt2AL6EU/tmOcPqeF2iG9/YNlyCH7QmzmHbIGzruUNU+zRRwlFEf6FeYXrgEQfm2nXHr4xqJQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7h6WlHnvSnTUJYsg56Dehv3evJE+cPB3ndUhofTGMEvdoFtD9
	iib/hzgnYLH3MzW7EKALpqMG8nwXK37M3qv/0tfagZqsqLENPrySwF5bF23zj545wUIzz/+/z+L
	51kEd4g0=
X-Gm-Gg: ASbGnctqCOu8yNrLaTp+ousF5N89s4gs4fHsMMWXtXq5JMO/VVZL9uI4NDMHdw/Yumd
	ZM9CatyIRdBzJygq+dZFvixuvfw6r7xvkQXD88O85czZlrAzXHUVw+Uo25geOtGqsYG7ZphoEch
	9N9GQOTygUjjbnvt9/DLa1bUm09xMiP5tv3+ZTKoj2hFI2KGbSUWA/J+DrCuq43ukcqKEDGx2kQ
	999xsY8PjL74VDttCWXhAKSHO0iai637PN24MKYHGgImsnLNrvp7ny1Tw2YM1g1acNdpMzdqGk0
	agv6S3Uxtj2gs3dOrdF9PHI7B53+uaXaE61PUNjQQbcjWRSboNT5owP18i3sczsnd99I2VIaHJl
	NsaVnjFSqfPjdxLyMcAP/FpivnXgbhfnWjKh6rEHYibLZB8I6eLIvts0=
X-Google-Smtp-Source: AGHT+IGNI9WpfotmEqEi4cn4u4fwW+RtZ9+xoddCwAUhH532/xSGWnuU80Ji4TwGjgLyw/gamg00lg==
X-Received: by 2002:a05:6e02:174e:b0:428:c370:d972 with SMTP id e9e14a558f8ab-42e7acedb7dmr146330135ab.7.1759758977959;
        Mon, 06 Oct 2025 06:56:17 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-42d8b1f4bb9sm50630875ab.4.2025.10.06.06.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 06:56:16 -0700 (PDT)
Message-ID: <a25558b5-7730-432a-85cc-55fdc8dca0d3@kernel.dk>
Date: Mon, 6 Oct 2025 07:56:16 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CQE repeats the first item?
To: Jacob Thompson <jacobT@beta.pyu.ca>, io-uring@vger.kernel.org
References: <20251005202115.78998140681@vultr155>
 <ef3a1c2c-f356-4b17-b0bd-2c81acde1462@kernel.dk>
 <20251005215437.GA973@vultr155>
 <57de87e9-eac2-4f91-a2b4-bd76e4de7ece@kernel.dk>
 <20251006012503.GA849@vultr155>
 <d5f48608-5a19-434b-bb48-e60c91e01599@kernel.dk>
 <20251006020142.GA835@vultr155>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251006020142.GA835@vultr155>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/5/25 8:01 PM, Jacob Thompson wrote:
> On Sun, Oct 05, 2025 at 07:31:20PM -0600, Jens Axboe wrote:
>> On 10/5/25 7:25 PM, Jacob Thompson wrote:
>>> On Sun, Oct 05, 2025 at 07:09:53PM -0600, Jens Axboe wrote:
>>>> On 10/5/25 3:54 PM, Jacob Thompson wrote:
>>>>> On Sun, Oct 05, 2025 at 02:56:05PM -0600, Jens Axboe wrote:
>>>>>> On 10/5/25 2:21 PM, Jacob Thompson wrote:
>>>>>>> I'm doing something wrong and I wanted to know if anyone knows what I
>>>>>>> did wrong from the description I'm using syscalls to call
>>>>>>> io_uring_setup and io_uring_enter. I managed to submit 1 item without
>>>>>>> an issue but any more gets me the first item over and over again. In
>>>>>>> my test I did a memset -1 on cqes and sqes, I memset 0 the first ten
>>>>>>> sqes with different user_data (0x1234 + i), and I used the opcode
>>>>>>> IORING_OP_NOP. I called "io_uring_enter(fd, 10, 0,
>>>>>>> IORING_ENTER_SQ_WAKEUP, 0)" and looked at the cq. Item 11 has the
>>>>>>> user_data as '18446744073709551615' which is correct, but the first 10
>>>>>>> all has user_data be 0x1234 which is weird AF since only one item has
>>>>>>> that user_data and I submited 10 I considered maybe the debugger was
>>>>>>> giving me incorrect values so I tried printing the user data in a
>>>>>>> loop, I have no idea why the first one repeats 10 times. I only called
>>>>>>> enter once
>>>>>>>
>>>>>>> Id is 4660
>>>>>>> Id is 4660
>>>>>>> Id is 4660
>>>>>>> Id is 4660
>>>>>>> Id is 4660
>>>>>>> Id is 4660
>>>>>>> Id is 4660
>>>>>>> Id is 4660
>>>>>>> Id is 4660
>>>>>>> Id is 4660
>>>>>>> Id is 18446744073709551615
>>>>>>
>>>>>> You're presumably not updating your side of the CQ ring correctly, see
>>>>>> what liburing does when you call io_uring_cqe_seen(). If that's not it,
>>>>>> then you're probably mishandling something else and an example would be
>>>>>> useful as otherwise I'd just be guessing. There's really not much to go
>>>>>> from in this report.
>>>>>>
>>>>>> -- 
>>>>>> Jens Axboe
>>>>>
>>>>> I tried reproducing it in a smaller file. Assume I did everything wrong but somehow I seem to get results and they're not correct.
>>>>>
>>>>> The codebase I'd like to use this in has very little activity (could go seconds without a single syscall), then execute a few hundreds-thousand (which I like to be async).
>>>>> SQPOLL sounds like the one best for my usecase. You can see I updated the sq tail before enter and I used IORING_ENTER_SQ_WAKEUP + slept for a second.
>>>>> The sq tail isn't zero which means I have results? and you can see its 10 of the same user_data
>>>>>
>>>>> cq head is 0 enter result was 10
>>>>> 1234 0
>>>>> 1234 0
>>>>> 1234 0
>>>>> 1234 0
>>>>> 1234 0
>>>>> 1234 0
>>>>> 1234 0
>>>>> 1234 0
>>>>> 1234 0
>>>>> 1234 0
>>>>> FFFFFFFF -1
>>>>
>>>> I looked at your test code, and you're setting up 10 NOP requests with
>>>> userdata == 0x1234, and hence you get 10 completions with that userdata.
>>>> For some reason you iterate 11 CQEs, which means your last one is the one
>>>> that you already filled with -1.
>>>>
>>>> In other words, it very much looks like it's working as it should. Any
>>>> reason why you're using the raw interface rather than liburing? All of
>>>> this seems to be not understanding how the ring works, and liburing
>>>> helps isolate you from that. The SQ ring doesn't tell you anything about
>>>> whether you have results (CQEs?), the difference between the SQ head and
>>>> tail just tell you if there's something to submit. The CQ ring head and
>>>> tail would tell you if there are CQEs to reap or not.
>>>>
>>>> -- 
>>>> Jens Axboe
>>>
>>> You must be seeing something that I'm not. I had a +i in the line,
>>> should the user_data not increment every item? The line was
>>> 'sqes[i].user_data = 0x1234+i;'. The 11th iteration is intentional to
>>> see the value of the memset earlier.
>>
>> You're not using IORING_SETUP_NO_SQARRAY, hence it's submitting index 0
>> every time. In other words, you're submitting the same SQE 10 times, not
>> 10 different SQEs. That then yields 10 completions for an SQE with the
>> same userdata, and hence your CQEs all look identical.
>>
>> -- 
>> Jens Axboe
> 
> Thank you! When I read IORING_SETUP_NO_SQARRAY it went over my head
> and I thought it'd make sense later. I had no idea it would repeat 0
> ten times when I call enter once, that's counter-intuitive. 

It's not repeating 0 ten times, it's iterating the sqe indirection array
from 0..9, but each entry contains 0 as that is what it was memset too.
Hence it'll submit sqes[0] ten times. If you don't use
IORING_SETUP_NO_SQARRAY, then there's an indirection where when you ask
it to submit 10 requests and the SQ head is currently at 0, it'll index
sq->array[0..9] to find the sqes offset it should submit from. If you
use IORING_SETUP_NO_SQARRAY, then no such indirection exists, and when
you ask it to submit 0..9 then that'll be the direct offset from the SQ
head into the sqes array.

> A lot of examples I'm going through uses all sorts of flags that I'm
> not familiar with. Is there something other than the man pages that I
> should read? I saw IORING_SETUP_NO_SQARRAY in the lib and didn't think
> to turn on flags that I didn't understand.

io_uring_setup.2 should have all of these setup flags documented.

I'll ask again since you didn't answer - why aren't you just using
liburing? It'll handle all of these details for you, so you can focus on
just using the commands you need and not need to build your own
abstraction around how to handle the SQ and CQ rings manually.

-- 
Jens Axboe

