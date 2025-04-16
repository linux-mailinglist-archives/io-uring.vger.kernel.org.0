Return-Path: <io-uring+bounces-7503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 742DAA90D8D
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 23:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E656B3BCF48
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 21:01:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3293122259F;
	Wed, 16 Apr 2025 21:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N/YMDSWa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5A91FF1B0;
	Wed, 16 Apr 2025 21:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744837317; cv=none; b=IA7rfGiUcBO6W3Du/s05oXdBy5n5bbPnBQOkwq00hI5uCoAmZkHcaTawn1Prblc7K0qU0tjuf4SYytJEQIRGdIq3ibX+d3M5biRYcC5iWPvSKvtPcjyGUi02Dg/hKavglxlRZ+Ihf6mGLSJ/zQ8IvHiX6lQcMPK/f/s4/wBDQtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744837317; c=relaxed/simple;
	bh=mm5+kRtKM3HwFh5K9w5YPFs7l1qjfw0zRXKiAmUuWrs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AKJiCky6kfpcFCcVIaVGCk6YrjOm3DyEXAvGXrYF2cc4rlEtCxnLZKzC57lxw6D+tJfXq3bRZxRBjO8DYCY2+yfzr7ktGgKeYXapslEdqmgDtLAv40JbClOJJ39xVNXkKZqE5E+bp7kKGJyO2m7/2iTjpaM5c4hS4Ig3/Oq9+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N/YMDSWa; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-acb415dd8faso9296566b.2;
        Wed, 16 Apr 2025 14:01:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744837313; x=1745442113; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JOYwvvuCDia3QJExuOBDXaJY3wMxoNsv3XIzMuiakGU=;
        b=N/YMDSWa7HOLwdK/Pe/aLOQ7z4IuEmYM3pawsL+kqPHLJYJYEt8kjlnG8JX/uBOYDF
         jeYGP1nQWcDlmxTg4J6uWK/OnCpnUAerCECrN3nQx/4Qaoqvhs5Ho8k8rEGbi6W6RcRZ
         fU5rX32ZIRU0TX++jg4fRQT5YnN5LIRJOWXQvG1jlyEQlqs8JssRAzLtPri0E3wbbqkP
         uF39hoZNn1xYSP6U5g/Rs7Mvl3L5iYP4GmaQ83KmamflnT8NQArT/fpEnKkkZ0DsJyfw
         axI7YFEfPqmqrNw5LlKrswUXEJZbmIeGouD0E18eLFYNrXav28jpRd7XqMSjG/OSsRBx
         +1JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744837313; x=1745442113;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JOYwvvuCDia3QJExuOBDXaJY3wMxoNsv3XIzMuiakGU=;
        b=w2UGRO1XI+ARNiwY2Mcn1i+l1vHJCoK0aHCrG5uYNc8fP4WE9nv4lYzcaNJPi6GZVf
         YhgiNetGgpNxRTtHAZAA6aHirkVgnUQrK+zpwDaWIneS0b00IypJoJ5xdoopzlR1L6l0
         vLIT4OXuSyD8N9Z9ULPB2vYm3TPbkcdzYRGgvtZy25SzE6SSSIxNwACL+V3Coo9WcGFr
         OyWZ7yZJm87fwjgjBGojDNlZebIHje8YIfaMWumMdtHd/Q4C+okW6lrvJtlrjrGwfSv2
         pD8YVzdcm4oOfZ6UfMGtAEU+5EJTOiTqkjiwGt9W4zZchKsqKB+N9Gk56P67XdfRk61D
         q/mg==
X-Forwarded-Encrypted: i=1; AJvYcCUC5+agKWNbg1r1SJWiOPtvH0j17ZkgjSLSCER2JC46S1F4JkSxZhsJB403t9tM1W4qcMx62JyKKQ==@vger.kernel.org, AJvYcCVf2GhZOxz627egHk0JvvlVVxLlDHOpZjGTRSdCWPKRAn2KwaSx0poZI+iDShE9q3H6k4hqd9eFbgKuUcsK@vger.kernel.org
X-Gm-Message-State: AOJu0YzWEqsrEiauGsGu9dNpJ2dBhYhbMBZy2nfIfcwNK2cf1j8Vytqn
	nSfV65R8DYjj0fNkZazrxqpCWP9a0uhybbibfYttyYMzeN18HlVD
X-Gm-Gg: ASbGncu8aasKB/XCBsq6P4nPhMrE8gxZgpRD5GUtRj22jy4R5YGddtoxnu3aCkyJZEz
	mzOmizAnGRxmX7xRF6OAev2wGLRpzuTSLWSC6zOFDKpjuahZQ+wwZYf95PvvEoTRt987S2nThMl
	VeEV+OvHYMWRhMLoJcQ1PrqHdv1WZDhGtUVC7GDoA5SkvMy2SulxyqABMV6r0llOavFUB71AiWy
	QT2g+0DGpK7gNxlaTsCSKB5Wm2NKXMPidYr0N/sQrB3LXgD4Pi8kscmevbYKzvjvZw7loF9DdgH
	Dwgwh3/zDm6ezAW+aApPb0f7kVvmRizXlOKL1sDQAhtCwRrfuA==
X-Google-Smtp-Source: AGHT+IHrKIupm4roHsJdzolZQuWNJRCMSOmiR9EcK4+TnD3wVBb7bCv2339KBUD+ZVJCqbMhklZ2cw==
X-Received: by 2002:a17:907:2d8a:b0:acb:32c5:43ff with SMTP id a640c23a62f3a-acb42570c1dmr349227766b.0.1744837313179;
        Wed, 16 Apr 2025 14:01:53 -0700 (PDT)
Received: from [192.168.8.100] ([148.252.144.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb3cd6351dsm185095266b.21.2025.04.16.14.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 14:01:52 -0700 (PDT)
Message-ID: <951a5f20-2ec4-40c3-8014-69cd6f4b9f0f@gmail.com>
Date: Wed, 16 Apr 2025 22:03:09 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Jens Axboe <axboe@kernel.dk>, Nitesh Shetty <nitheshshetty@gmail.com>
Cc: Nitesh Shetty <nj.shetty@samsung.com>, gost.dev@samsung.com,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
 <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
 <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk>
 <40a0bbd6-10c7-45bd-9129-51c1ea99a063@kernel.dk>
 <CAOSviJ3MNDOYJzJFjQDCjc04pGsktQ5vjQvDotqYoRwC2Wf=HQ@mail.gmail.com>
 <c9838a68-7443-40d8-a1b7-492a12e6f9dc@kernel.dk>
 <a2e8ba49-7d6f-4619-81a8-5a00b9352e9a@gmail.com>
 <a263d544-f153-4918-acea-5ce9db6d0d60@kernel.dk>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <a263d544-f153-4918-acea-5ce9db6d0d60@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/25 21:30, Jens Axboe wrote:
> On 4/16/25 2:29 PM, Pavel Begunkov wrote:
>> On 4/16/25 21:01, Jens Axboe wrote:
>>> On 4/16/25 1:57 PM, Nitesh Shetty wrote:
>> ...
>>>>>                   /*
>>>>> @@ -1073,7 +1075,6 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>>                    * since we can just skip the first segment, which may not
>>>>>                    * be folio_size aligned.
>>>>>                    */
>>>>> -               const struct bio_vec *bvec = imu->bvec;
>>>>>
>>>>>                   /*
>>>>>                    * Kernel buffer bvecs, on the other hand, don't necessarily
>>>>> @@ -1099,6 +1100,27 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>>>                   }
>>>>>           }
>>>>>
>>>>> +       /*
>>>>> +        * Offset trimmed front segments too, if any, now trim the tail.
>>>>> +        * For is_kbuf we'll iterate them as they may be different sizes,
>>>>> +        * otherwise we can just do straight up math.
>>>>> +        */
>>>>> +       if (len + offset < imu->len) {
>>>>> +               bvec = iter->bvec;
>>>>> +               if (imu->is_kbuf) {
>>>>> +                       while (len > bvec->bv_len) {
>>>>> +                               len -= bvec->bv_len;
>>>>> +                               bvec++;
>>>>> +                       }
>>>>> +                       iter->nr_segs = bvec - iter->bvec;
>>>>> +               } else {
>>>>> +                       size_t vec_len;
>>>>> +
>>>>> +                       vec_len = bvec->bv_offset + iter->iov_offset +
>>>>> +                                       iter->count + ((1UL << folio_shift) - 1);
>>>>> +                       iter->nr_segs = vec_len >> folio_shift;
>>>>> +               }
>>>>> +       }
>>>>>           return 0;
>>>>>    }
>>>> This might not be needed for is_kbuf , as they already update nr_seg
>>>> inside iov_iter_advance.
>>>
>>> How so? If 'offset' is true, then yes it'd skip the front, but it
>>> doesn't skip the end part. And if 'offset' is 0, then no advancing is
>>> done in the first place - which does make sense, as it's just advancing
>>> from the front.
>>>
>>>> How about changing something like this ?
>>>
>>> You can't hide this in the if (offset) section...
>>
>> Should we just make it saner first? Sth like these 3 completely
>> untested commits
>>
>> https://github.com/isilence/linux/commits/rsrc-import-cleanup/
>>
>> And then it'll become
>>
>> nr_segs = ALIGN(offset + len, 1UL << folio_shift);
> 
> Let's please do that, certainly an improvement. Care to send this out? I
> can toss them at the testing. And we'd still need that last patch to

I need to test it first, perhaps tomorrow

> ensure the segment count is correct. Honestly somewhat surprised that

Right, I can pick up the Nitesh's patch to that.

> the only odd fallout of that is (needlessly) hitting the bio split path.

It's perfectly correct from the iter standpoint, AFAIK, length
and nr of segments don't have to match. Though I am surprised
it causes perf issues in the split path.

Btw, where exactly does it stumble in there? I'd assume we don't
need to do the segment correction for kbuf as the bio splitting
can do it (and probably does) in exactly the same way?

-- 
Pavel Begunkov


