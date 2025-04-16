Return-Path: <io-uring+bounces-7485-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 84E2FA90759
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 17:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9C011440906
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 15:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 259EA1F12F2;
	Wed, 16 Apr 2025 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="luvrRmTW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45DE635962
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744816042; cv=none; b=MuAIg0OsCh9u3nhjs0YegUDJ/w0JBTYk5ub/8DOUrAMekX+2kITxrdfCj5h40NVP0yIGWdrQT71TjZCCFaUTeoLywoq1X1AQIkf8KVArh5rL+K3eULoimk0bReeRsl3gqot/Tf1eROY6bx/BfkviFELrcqFVm9fuSfXXCAGwXsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744816042; c=relaxed/simple;
	bh=xydEv1bJS8nBM6VoPoPvUsURJKyB/Zca26umfk5kWjM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EdqCYXMPbH6Ec096CMJ5QIDn+Ki4k2bGIkh61OFtavKJXXYFevcltgd/Z5aibmntRPELBdnRrP4xKxPnJAElU/xD1CW2LqyjrK6P0HtzRdoxY7pSoGEcG3PRvoBnVaaIAhAgFd+vvKwIfeEKts2KPk6HPNdLtt3e0mVUwaUIm+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=luvrRmTW; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3d6d162e516so52446705ab.1
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 08:07:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744816038; x=1745420838; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uSiz4ta79sjKF4kdwzdjhicKXhB4rJNdion/ll08cgM=;
        b=luvrRmTW1ax0ITztpQatJNCGdU8WMDFJkKEIQPpXA5kWbTyOtMA6lX1Obb3BacsCbm
         Tlkj+co6su9D3PWSiKvzkdIIrbPtCoVlEqM7N2X26nbr1RgvM3/OhTT/NpyIavuPZL2k
         /DSaeVYc8NDx9HcwSFCYoiYDMkWBkRbUtTL+z5RJvzDWrJJ9qJA5JskvkJ9WG2PtIdj+
         4BEzXeBOSsbU+zdHoYBLWSX59W3qMesue4hjOX9yjjgjs+4awHdAxNgXOXR2bdvDUuAr
         1vem8v1HCqVKT0pO0AQD6k3qQGQ9q9zdYXwnmFaL4jwJ8a7ULmJ7kqkx5lXKZ4CZ3qB8
         3vGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744816038; x=1745420838;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uSiz4ta79sjKF4kdwzdjhicKXhB4rJNdion/ll08cgM=;
        b=DpueH2yTJXyOPAavcdlbQdltWS9QiTMm+VBlo9ad8+PAAPy4V4hxHSAJRxkrGUoViM
         O2Cx+BJxxYflm+afnWgh+WUESCYj/YkYGk6U1kKDrc2LB3Lve1o+Owk4FCHaJOO57GTe
         FkHzo6AABADASUmreT/uCzOVHS7g517XMKae5YqSItyoLPBhrHkVyVuhlaZURABNUBE7
         rgzViLz4GUlIZXNm+1oB1In5aXHAtDnAAfI4Wy7mKgTt7Hy3Rpg6F/ZkBmCvdT+0eXC4
         eYNoxs1ZuIE1OouBeKLyIXEv2pulfPZYFLOAPL4DqTTpsPA5K1psGuQMnMm7l7z3A+1N
         sreA==
X-Forwarded-Encrypted: i=1; AJvYcCUMQt1pT0mKR8CRnntc9bpjlgjUfKg+v1MxD6IfA+Xjo8o2qRNQTmV1MpzVinPVSB+y+2tEqJZP2A==@vger.kernel.org
X-Gm-Message-State: AOJu0YxXZmtCbj9+hv+lXbKf0iKAQI1+S3ZKlfKGpmA0E5bP1fw8dB7y
	M1RkHroFKz5ELrw8O0YAiuJE06dpBlZF5dT4zXqZ8tGR9JLr1fJcihjYzhCW2GM=
X-Gm-Gg: ASbGncv+hBuCvdHg0K+wSjfgAXPNomNhMJTubu2YdO9KDdE3ykjWC0nQswoQIEcZZ8O
	gaUC03X83FcY/v/yOUcQK/CQfCvggT6vARYs/I9JEhwP8UU/e7t4Min23pp+qdXGPhvcUmvmhKJ
	I0fiGQq1JWsoIVXSWoEWTPDWCj5aQ/X+uoT+xw/j0TSKpOBoZYP1Q8htTptJVZ0oCJmkGq9+FF7
	GIEMZz7NqRVSSZ/fgKIy+UkC0APg21pyi9vw++Hk/Z+w2gKU1pifUr7yWZevRFZ6URamwpBKbj8
	7DtdyPdll5H1x6I4eQrVUR0NGZxMPDdxJEZJjTenyZFeo6A=
X-Google-Smtp-Source: AGHT+IEiQF0hJJBv4FKHVHSG0TYD0Ys3nz+ZNjCcYIevxZBop88KC6KOO3PSA/ty3Te7NQIFJkQtZw==
X-Received: by 2002:a05:6e02:216b:b0:3d6:d162:be54 with SMTP id e9e14a558f8ab-3d815b5e1dfmr19479345ab.14.1744816038264;
        Wed, 16 Apr 2025 08:07:18 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e01512sm3601391173.102.2025.04.16.08.07.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 08:07:17 -0700 (PDT)
Message-ID: <37c982b5-92e1-4253-b8ac-d446a9a7d932@kernel.dk>
Date: Wed, 16 Apr 2025 09:07:17 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
To: Pavel Begunkov <asml.silence@gmail.com>,
 Nitesh Shetty <nj.shetty@samsung.com>
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
 <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <98f08b07-c8de-4489-9686-241c0aab6acc@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/25 9:03 AM, Pavel Begunkov wrote:
> On 4/16/25 06:44, Nitesh Shetty wrote:
>> Sending exact nr_segs, avoids bio split check and processing in
>> block layer, which takes around 5%[1] of overall CPU utilization.
>>
>> In our setup, we see overall improvement of IOPS from 7.15M to 7.65M [2]
>> and 5% less CPU utilization.
>>
>> [1]
>>       3.52%  io_uring         [kernel.kallsyms]     [k] bio_split_rw_at
>>       1.42%  io_uring         [kernel.kallsyms]     [k] bio_split_rw
>>       0.62%  io_uring         [kernel.kallsyms]     [k] bio_submit_split
>>
>> [2]
>> sudo taskset -c 0,1 ./t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2
>> -r4 /dev/nvme0n1 /dev/nvme1n1
>>
>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>> ---
>>   io_uring/rsrc.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>> index b36c8825550e..6fd3a4a85a9c 100644
>> --- a/io_uring/rsrc.c
>> +++ b/io_uring/rsrc.c
>> @@ -1096,6 +1096,9 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>               iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
>>           }
>>       }
>> +    iter->nr_segs = (iter->bvec->bv_offset + iter->iov_offset +
>> +        iter->count + ((1UL << imu->folio_shift) - 1)) /
>> +        (1UL << imu->folio_shift);
> 
> That's not going to work with ->is_kbuf as the segments are not uniform in
> size.

Oops yes good point.

> And can we make it saner? Split it into several statements, add variables
> for folio size and so, or maybe just use ALIGN. If moved above, you
> probably don't even need to recalc
> 
> iter->bvec->bv_offset + iter->iov_offset

Agree, was trying to do that with the shift at least, but seems like
there is indeed room for further improvements here in terms of
readability.

-- 
Jens Axboe

