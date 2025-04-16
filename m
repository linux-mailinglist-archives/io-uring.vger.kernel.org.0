Return-Path: <io-uring+bounces-7497-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AD514A90CB6
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 22:02:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC5B119067B8
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 20:02:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF13922157E;
	Wed, 16 Apr 2025 20:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OXsnUBuh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821A23595A
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 20:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744833714; cv=none; b=YMVKJDfBJKOCx01q8DpXyBVjSeE6sDr3VX1mQ2Ul2h/iNbNL+jmDP2R4CwnV6nE+jOuzm9GimzhxJ5oXEl/xEVIfnwUPsfX9CTFWqWhSakG+2pfUTMMIHyGDHBU1U+YYsbuK/ceIRf7ueI+nTCkQY3qxT+igNDJuV5ijdye6F3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744833714; c=relaxed/simple;
	bh=rFDjUwNZy/0tHJwORZ2KTo+nGRXXyrMB9U7pNZUu5h0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IQGRCpGbDXMei2AR28eICRcbooi5B1Mj8lzKMnC6Dr+LTCKjETmqr2hHrXilhpobNI0eW3wyAwl0BpPE/09Wjg4qJkQ21by/pH7+BzGtSkO0cVp4+NVZSk3Ym2vEGZ+d34wpnIao1+muA6gEx8PBQ0cPLY++zITwOxyjhun/Xrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OXsnUBuh; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-85e73562577so2750039f.0
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 13:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744833709; x=1745438509; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j9CX3O2Ld6+1i6wlJXOkLkxs/SwIku7oh1b53HECV1E=;
        b=OXsnUBuhVcxKt3JUmub1W/U+BAbfh/SsM8gZeB5Xf2Tn1Trg2KJ99qEhorgzo4XrBP
         KGmC/SckIJaeUjjQaPPxyMAkKLaUXuM8RYmFHWy3RzPx0nKs7vSe0YOMv/vYhPYfL8Ny
         4y9WbieW0UW1KGNdE3WJ2dqU2ZW6sU2lzZtTJc8yLisjKD22BVujWJuFAkhzbt8bSxoh
         wK82RLIWHepY4I3NomaPiFXjsQylBjHbncoENNG7o+T4rZ/wNyMm2N5Wd0lDd6rFy7CE
         H3dUTmaH04uAIfd2xuXqk8NLz8n/19cfuW5g5TSIwl6vVecxgFHdh3mlLO3N6lUconyA
         hHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744833709; x=1745438509;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j9CX3O2Ld6+1i6wlJXOkLkxs/SwIku7oh1b53HECV1E=;
        b=mMurnGOrJu5aHAYaNS+MMZ1YrYBQCNWZtcolVd56GnyjjWgdlXrCNTlAv5ml3aj4J4
         vJKIzxJsYF0oml+uPbVk8x2araRR3T5DyYX/J/t00VbI62hK2ygL79cBpj4YsoUe0j0l
         S6oSTDwg8534Nrlmzn4RLc8oqexc4GvSU7jEK1XhbtDXMhSi4KZrbpBG4+AZ6h3lmdpC
         w6Ohfzm8+tUmHQ+ua+6ZjvXBK30rhW3dzwhAbsm9VgmXJKCjfHS7iZMy2ib+AJE6yn1K
         Tedvsxnx/+/E8M2IcMfR3eyeMffOGsK6AdNW15wWlc9hl36xTt2NRhgjzEt6nHM51IcN
         8ThA==
X-Forwarded-Encrypted: i=1; AJvYcCUV6eVybsbQ9x9pZXwrVMHFOFQFov2wx+DXGmIt2WUhGZBeyLjZpDvirjsUQxPkQbzupP8O/GwEYA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxx1aiz/TXE25sEK5guU7j/GL0SuqpOObkc4d5ScUT5ptXHlqsu
	Z/jHeAj9Mh9xxJPMFcipZA6dl7pQNpsYS1KK8fqNoLt097VS4FkbpwmozYrRhD0=
X-Gm-Gg: ASbGncuIVcykIzbCJjoXWIeL3MrmE6qpAfnfvlFSJRz7kTTF3sjzj1LTsOBQWpOF8Sb
	VZMlTn8+WzK2ngmOFFjMlfM2FNI66spSGdhtUrYu8yQoBhdrSNX0kZaMunnBe8HGHW9GC0wM1ZY
	RwfxwcdgWJdrlz9U2Z19H2inwdp6Us0yHH0Vt15WmBO5+WSz6pPVaNEz5JXgXLooKuXelsf8Ylh
	J4zkYEPTb0KNr6QrEpHRkczqAyQpwv9alJf2hnSIQlK5SBX5Q+Zs1cYFJxZFB6oab8W5kQnoKxU
	Oma3Q2AzoqRSMFVxv3DOtbDr9dIsJeS5yXfV
X-Google-Smtp-Source: AGHT+IEdcdvkE/9Ugh/JicvB5T0eXnJR6x1vsGt3rzT593K+QpUSGn2agISksX8oNok35ovQMnhcWQ==
X-Received: by 2002:a05:6602:4889:b0:861:88d1:bfac with SMTP id ca18e2360f4ac-861c4f6dcc8mr340927239f.2.1744833709505;
        Wed, 16 Apr 2025 13:01:49 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505cf8386sm3794024173.7.2025.04.16.13.01.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 13:01:48 -0700 (PDT)
Message-ID: <c9838a68-7443-40d8-a1b7-492a12e6f9dc@kernel.dk>
Date: Wed, 16 Apr 2025 14:01:47 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Nitesh Shetty <nitheshshetty@gmail.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
 <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
 <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk>
 <40a0bbd6-10c7-45bd-9129-51c1ea99a063@kernel.dk>
 <CAOSviJ3MNDOYJzJFjQDCjc04pGsktQ5vjQvDotqYoRwC2Wf=HQ@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CAOSviJ3MNDOYJzJFjQDCjc04pGsktQ5vjQvDotqYoRwC2Wf=HQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/25 1:57 PM, Nitesh Shetty wrote:
> On Wed, Apr 16, 2025 at 11:55?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 4/16/25 9:07 AM, Jens Axboe wrote:
>>> On 4/16/25 9:03 AM, Pavel Begunkov wrote:
>>>> On 4/16/25 06:44, Nitesh Shetty wrote:
>>>>> Sending exact nr_segs, avoids bio split check and processing in
>>>>> block layer, which takes around 5%[1] of overall CPU utilization.
>>>>>
>>>>> In our setup, we see overall improvement of IOPS from 7.15M to 7.65M [2]
>>>>> and 5% less CPU utilization.
>>>>>
>>>>> [1]
>>>>>       3.52%  io_uring         [kernel.kallsyms]     [k] bio_split_rw_at
>>>>>       1.42%  io_uring         [kernel.kallsyms]     [k] bio_split_rw
>>>>>       0.62%  io_uring         [kernel.kallsyms]     [k] bio_submit_split
>>>>>
>>>>> [2]
>>>>> sudo taskset -c 0,1 ./t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2
>>>>> -r4 /dev/nvme0n1 /dev/nvme1n1
>>>>>
>>>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>>>> ---
>>>>>   io_uring/rsrc.c | 3 +++
>>>>>   1 file changed, 3 insertions(+)
>>>>>
>>>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>>>> index b36c8825550e..6fd3a4a85a9c 100644
>>>>> --- a/io_uring/rsrc.c
>>>>> +++ b/io_uring/rsrc.c
>>>>> @@ -1096,6 +1096,9 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>>               iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
>>>>>           }
>>>>>       }
>>>>> +    iter->nr_segs = (iter->bvec->bv_offset + iter->iov_offset +
>>>>> +        iter->count + ((1UL << imu->folio_shift) - 1)) /
>>>>> +        (1UL << imu->folio_shift);
>>>>
>>>> That's not going to work with ->is_kbuf as the segments are not uniform in
>>>> size.
>>>
>>> Oops yes good point.
>>
>> How about something like this? Trims superflous end segments, if they
>> exist. The 'offset' section already trimmed the front parts. For
>> !is_kbuf that should be simple math, like in Nitesh's patch. For
>> is_kbuf, iterate them.
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index bef66e733a77..e482ea1e22a9 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -1036,6 +1036,7 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>                            struct io_mapped_ubuf *imu,
>>                            u64 buf_addr, size_t len)
>>  {
>> +       const struct bio_vec *bvec;
>>         unsigned int folio_shift;
>>         size_t offset;
>>         int ret;
>> @@ -1052,9 +1053,10 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>          * Might not be a start of buffer, set size appropriately
>>          * and advance us to the beginning.
>>          */
>> +       bvec = imu->bvec;
>>         offset = buf_addr - imu->ubuf;
>>         folio_shift = imu->folio_shift;
>> -       iov_iter_bvec(iter, ddir, imu->bvec, imu->nr_bvecs, offset + len);
>> +       iov_iter_bvec(iter, ddir, bvec, imu->nr_bvecs, offset + len);
>>
>>         if (offset) {
>>                 /*
>> @@ -1073,7 +1075,6 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>                  * since we can just skip the first segment, which may not
>>                  * be folio_size aligned.
>>                  */
>> -               const struct bio_vec *bvec = imu->bvec;
>>
>>                 /*
>>                  * Kernel buffer bvecs, on the other hand, don't necessarily
>> @@ -1099,6 +1100,27 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>                 }
>>         }
>>
>> +       /*
>> +        * Offset trimmed front segments too, if any, now trim the tail.
>> +        * For is_kbuf we'll iterate them as they may be different sizes,
>> +        * otherwise we can just do straight up math.
>> +        */
>> +       if (len + offset < imu->len) {
>> +               bvec = iter->bvec;
>> +               if (imu->is_kbuf) {
>> +                       while (len > bvec->bv_len) {
>> +                               len -= bvec->bv_len;
>> +                               bvec++;
>> +                       }
>> +                       iter->nr_segs = bvec - iter->bvec;
>> +               } else {
>> +                       size_t vec_len;
>> +
>> +                       vec_len = bvec->bv_offset + iter->iov_offset +
>> +                                       iter->count + ((1UL << folio_shift) - 1);
>> +                       iter->nr_segs = vec_len >> folio_shift;
>> +               }
>> +       }
>>         return 0;
>>  }
> This might not be needed for is_kbuf , as they already update nr_seg
> inside iov_iter_advance.

How so? If 'offset' is true, then yes it'd skip the front, but it
doesn't skip the end part. And if 'offset' is 0, then no advancing is
done in the first place - which does make sense, as it's just advancing
from the front.

> How about changing something like this ?

You can't hide this in the if (offset) section...

-- 
Jens Axboe

