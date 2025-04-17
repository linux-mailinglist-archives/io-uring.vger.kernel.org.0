Return-Path: <io-uring+bounces-7518-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B891A91E50
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 15:42:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BCF064481DD
	for <lists+io-uring@lfdr.de>; Thu, 17 Apr 2025 13:41:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E207124C066;
	Thu, 17 Apr 2025 13:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="h5XwhY5O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FB224E00C
	for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 13:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744897301; cv=none; b=BChHdS2WcgDGQo3orTH/bxOL6QJsJm1okGqQNTg+uL6bnKQ+4q4YlKTrBCO/kI9+r9UKH9URKpxZz/A4V23RItQ1sWDShYizw3NvL/PrZ+UFL5RgVlJ3Zm6bSg2+YhSwnPIPT+RmsDesbjtJBnhVaKGZnZO05iWNmVaZdluNbbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744897301; c=relaxed/simple;
	bh=5T1FimlqfOeiYm2xwGr8p0rs0pYvNsxl8eXMaCC2gCM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XIDtc7zC6o7n2Ud2gt9xLVjO6M7S+k/Vzpw/k9FpnqGU9pyLIDO2mp0tT+kGk3/xtsAGe41FGm0AFfFrKCxvTrMPb/xaWZaGyEx5RH+8PJ211u7WioJK3/LlkuHUnjYYedFAS/hKeN7dSMYx6Gz9NBdQqgVlfhzdK/MvhjRC4u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=h5XwhY5O; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3d7f4cb7636so2634065ab.3
        for <io-uring@vger.kernel.org>; Thu, 17 Apr 2025 06:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744897297; x=1745502097; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gEPdpS+I+Pev129FckpjFhosgLt+W9Wfr0FE6sJJnmw=;
        b=h5XwhY5OYJr6Sz7jlcWvuGiUjQlp0Hp4IL6+EtWdoZ+uvNyox++IMygC+IxnmTnv2C
         1OpDBsFUDp3RowLzRWUh8WoK9l2+oPtTOM+v4aYOUJEH6JVDhoDAzj+7E/sRDB0KeUMC
         0230/1wz/XteT4gOMOqJRHJ3NuQd2I9k/V0DNO28GNs05GqrCn53nUPmt49dQJmzswcx
         cbYLEi9yTbPLSBxf3KbKbz7VQbfJNKOiXN0D90DwetfdUNLDUe7dwH0AqvE154bITaZH
         MDpk95jIfRjwrlXeksUmY5eEpbXgSmT7FqEf6sgs3BMEELdiCB/HQOj7AYTGP17QVxov
         J+zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744897297; x=1745502097;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gEPdpS+I+Pev129FckpjFhosgLt+W9Wfr0FE6sJJnmw=;
        b=JaGqcRhv9DNYuWQr+XAxiwqEbV3GtnJbM6PpmvmvdenkjR/TQowtXFveTh3QHEyjey
         QlrKMeFK9NOeQb4cItZLVCv5ic2zXwPTb8cwrXGI1wUvAYHkxMpC+jkfsns+oGFijSfc
         +VsOcdKt8ooMlVRP/q5+YVjtL2tsYhNb9VcQoGWmjn0YuVfCh76BFZMJEXSsNE+YT7fj
         j+YtajB3sqwo8I+/OU3uvG/POSsqoKfkARMBTwsp5npGo2dKNedwoAtoy6J+/mN2qPcl
         MUgOGO+QjvfYFXnIcDL8C3HxCGYrakA72lpFNW+6jDRFTKAFBAeCxQE8KIvmIe7KvT93
         mTpQ==
X-Gm-Message-State: AOJu0YwK/nS4idIR4IywGNdcqs8TP+QgDYVqzqmTVFNChkeeanP4MudB
	CykJJOP+60IyFNYY6NhZ54p69I5UOoaVYTc4hscrCs1WJUGYqQm2nwzJN5T8NBI=
X-Gm-Gg: ASbGncspONUovouuP+7Al/OmYT3nnkh46ZNnL+Vw3X+ql3lUSpDZ9ibaCMNDvAyzXh3
	4CeHSXaV+QMFzh3U9T8jbO5DaP47j5dPmfmjO5Cuf90Y1IQ0sxGp1rNafNNU7JKRqX4rkmA3F+K
	CtlwQ36Xmw4yDkfRSZdmzeyTI2fh36FoIaW9+JXszxWLeNfqEi03sxS4FFLEoyhOxy0w/DdcTOr
	LGcz8R5dxA0yEidr//kqwhRLcPu7cj4HIixsgHsmFW+FbWWNEgclBrEfA7efwAd9BFOErasN+07
	DJmFHcHlCWdJcwyIg8fupPrKlAjfNxWs1JIoNA==
X-Google-Smtp-Source: AGHT+IFYk37NvODMOIWMq9RjEmJpt7N0ML/V5MeV97fnL7M8kzjc3UZ2kkfUk2iOSHT4OYm16ezhjw==
X-Received: by 2002:a05:6e02:461b:b0:3d8:1b0b:c92b with SMTP id e9e14a558f8ab-3d81b0bca6dmr32518535ab.2.1744897297594;
        Thu, 17 Apr 2025 06:41:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d8145208b3sm8100155ab.45.2025.04.17.06.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Apr 2025 06:41:37 -0700 (PDT)
Message-ID: <603628d3-78ec-47a3-804a-ee6dc93639fd@kernel.dk>
Date: Thu, 17 Apr 2025 07:41:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Pavel Begunkov <asml.silence@gmail.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Cc: io-uring@vger.kernel.org
References: <cover.1744882081.git.asml.silence@gmail.com>
 <7a1a49a8d053bd617c244291d63dbfbc07afde36.1744882081.git.asml.silence@gmail.com>
 <d699cc5b-acc9-4e47-90a4-2a36dc047dc5@gmail.com>
 <CGME20250417103133epcas5p32c1e004e7f8a5135c4c7e3662b087470@epcas5p3.samsung.com>
 <20250417102307.y2f6ac2cfw5uxfpk@ubuntu>
 <20250417115016.d7kw4gch7mig6bje@ubuntu>
 <ca357dbb-cc51-487c-919e-c71d3856f915@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ca357dbb-cc51-487c-919e-c71d3856f915@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/17/25 6:56 AM, Pavel Begunkov wrote:
> On 4/17/25 12:50, Nitesh Shetty wrote:
>> On 17/04/25 03:53PM, Nitesh Shetty wrote:
>>> On 17/04/25 10:34AM, Pavel Begunkov wrote:
>>>> On 4/17/25 10:32, Pavel Begunkov wrote:
>>>>> From: Nitesh Shetty <nj.shetty@samsung.com>
>>>> ...
>>>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>>>> index 5cf854318b1d..4099b8225670 100644
>>>>> --- a/io_uring/rsrc.c
>>>>> +++ b/io_uring/rsrc.c
>>>>> @@ -1037,6 +1037,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>>                u64 buf_addr, size_t len)
>>>>> {
>>>>>     const struct bio_vec *bvec;
>>>>> +    size_t folio_mask;
>>>>>     unsigned nr_segs;
>>>>>     size_t offset;
>>>>>     int ret;
>>>>> @@ -1067,6 +1068,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>>      * 2) all bvecs are the same in size, except potentially the
>>>>>      *    first and last bvec
>>>>>      */
>>>>> +    folio_mask = (1UL << imu->folio_shift) - 1;
>>>>>     bvec = imu->bvec;
>>>>>     if (offset >= bvec->bv_len) {
>>>>>         unsigned long seg_skip;
>>>>> @@ -1075,10 +1077,10 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>>         offset -= bvec->bv_len;
>>>>>         seg_skip = 1 + (offset >> imu->folio_shift);
>>>>>         bvec += seg_skip;
>>>>> -        offset &= (1UL << imu->folio_shift) - 1;
>>>>> +        offset &= folio_mask;
>>>>>     }
>>>>> -    nr_segs = imu->nr_bvecs - (bvec - imu->bvec);
>>>>> +    nr_segs = (offset + len + folio_mask) >> imu->folio_shift;
>>>>
>>>> Nitesh, let me know if you're happy with this version.
>>>>
>>> This looks great to me, I tested this series and see the
>>> improvement in IOPS from 7.15 to 7.65M here.
>>>
>>
>> There is corner case where this might not work,
>> This happens when there is a first bvec has non zero offset.
>> Let's say bv_offset = 256, len = 512, iov_offset = 3584 (512*7, 8th IO),
>> here we expect IO to have 2 segments with present codebase, but this
>> patch set produces 1 segment.
>>
>> So having a fix like this solves the issue,
>> +    nr_segs = (offset + len + bvec->bv_offset + folio_mask) >> imu->folio_shift;
> 
> Ah yes, looks like the right fix up. We can make it nicer, but
> that's for later. It'd also be great to have a test for it.
> 
> 
>> Note:
>> I am investigating whether this is a valid case or not, because having a
>> 512 byte IO with 256 byte alignment feel odd. So have sent one patch for
> 
> Block might filter it out, but for example net/ doesn't care,
> fs as well. IIUC what you mean, either way we definitely should
> correct that.

I just tested it, and yes it certainly blows up... Can also confirm that
the corrected nr_segs calculation does the right thing, doesn't end up
underestimating the segment count by 1 in that case.

I'll turn the test case into something we can add to liburing, and fold
in that change.

-- 
Jens Axboe

