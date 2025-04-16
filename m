Return-Path: <io-uring+bounces-7483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61E4AA906F8
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 16:51:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EFE67ACD6E
	for <lists+io-uring@lfdr.de>; Wed, 16 Apr 2025 14:48:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F6911EF39B;
	Wed, 16 Apr 2025 14:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2DgFswpW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2257E110
	for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 14:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744814952; cv=none; b=pcKcolBa2uVtjVVxDIth6CI/TTr2GnhL5XjPa+tdH2Qv0eXESvcT+x80k+bbyxMI4NDq4j++rPYxbmuUJSWehYMrbgzpBOh2fuj6B51pwtgcxL011PQ29v5UjWxPbvKTfr+xFTITfnmljBB2sgiFvQhJL5vKu42wmVvLmAfecY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744814952; c=relaxed/simple;
	bh=SQ8+5p7Nlq1fOvBkIy/o1kBhFodGK97yw495ZecXZFM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=PBmGvIydF4gHx2Uhptr5PhUVURT3PKnzotfYTlXqfwAJX6qazbwqzvDgqZn3GJOZVb3BRyTB+veogCbQpWoxRS/KKZoabYFEqUnmGUXSPOJmTHG5au8BjVD7717VkYkIoQWvmta2Oy3Msu7v1IRnYM7y9cE8jStLv3J0DynyIXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2DgFswpW; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-86135ae2a29so604644839f.2
        for <io-uring@vger.kernel.org>; Wed, 16 Apr 2025 07:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1744814948; x=1745419748; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MAddcC1f4xDb/YfiGnMxU0srI5s/b5cLv3g1/6rru6M=;
        b=2DgFswpWsY+/3tF/DSNNhc964uj9kEJNS/Hly5mC+r3tZsXkp7VTZX8IKclpvEZn8E
         iszkWU9bU6sIljQD56/5R82yVvVaAQhsVhNucf5BiilU+5ffAVk+9qv4lOdeKQDRNQ9s
         /RGhA9bD4Tc8zBvwG8iJ5fediRwXVzkyJk9rGnKnM3wMpzA6I7pflB23aE4wXcWIbtpJ
         /x9tqxymZgDBMOw8yBo8o7JNAzaFTmfse7icN/A0iPLcDbMMDj4CBv1rPokXDURlwjEb
         y9lsrIirvEJvlxto/sTdXyY7+b9vjWvrizYWdm6QjCeT6h7tkqgCHK7LKqOHWPdAeARe
         /HMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744814948; x=1745419748;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MAddcC1f4xDb/YfiGnMxU0srI5s/b5cLv3g1/6rru6M=;
        b=TbqDZVw8+owfTy3tn1ERNHztpdl5YXzWnxXey1OxK/MpzhFygTIUNAeLhYhxmenbul
         v7z/aVdhu8rOOvoXBZmjQqgmlfSDA3Mos9+WAR1cgZGkODMaVhgJYsuoQok1XnzF4ArI
         e9wDDntcMci7wuy/nnIRStGJnQHTha8Mb6LS5gfaR2IxIaRN0rJuEliCnUh95gb73W3U
         fJ3j1GlTG8vKyIJAyHG9piXqKKz1ao7F3G21/6p56/ZkAT6Ki67hi929OG5B7ts/eg+A
         PFhWrpHEBmlBQMD+f5udtoO+ZoEHd54sFe4H1u1mbhbzUkMTM/pVA3mH2vIpvWXXbaO2
         Ly3g==
X-Forwarded-Encrypted: i=1; AJvYcCXtYlZPxRypPtDlb/QWxPxrJ7Lhz3RlZECTkfDtT3k1BN4lwnZb7H6q8EXSVYOVeoN05r0yXRbgPg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4oRhQTVc4u3cZ/cijjhVdGR3k2hjZSJDlfgrxXyMEHP0yhQta
	naDjzQX4i5Lo5zsELtg0Yj0FOPw2gz2AvpZyPAIfFDmQQuZ9dqrwxul7znIdGrQ=
X-Gm-Gg: ASbGnctQVXi9Y0PSiirN7H1Rmq1F1glIVJA8SVZT2j5ZVFgolOmcEPPJYm2iRs0PIcG
	3CxbSepMw1SpsXlatCAw14xWm9RvOBuCTZ8mXlhkPmZeDISxkXaKy9aNOW3AEFafwkGS8l0t93B
	wg6Xgypphfd3f19Ell/ddIjNbXHuPFopopfbu+FEc1S8aPeCm1wgrQyWZt2VLAkWbqG+7MYJZze
	dmKpx2GoeBJ+/QbDO5DaC1vFd0ZYVYroO47U1nBtVD4yAF4AyRSl8F8TUfvBrx+Pk+qkFB4KLGD
	8rd2fSERv3kmCTiQILt34mVcRUTRm3J4HJ+p
X-Google-Smtp-Source: AGHT+IE28GiU5e4LeBm4Ix2sbRDwdsdmtN0VHMhSjY11H/dWVE28Hy19YquGA/Fly88a1VUkrA0byw==
X-Received: by 2002:a05:6602:3a83:b0:861:c4cf:cae8 with SMTP id ca18e2360f4ac-861c4f641f4mr218897339f.2.1744814948691;
        Wed, 16 Apr 2025 07:49:08 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-861650858c0sm292564939f.0.2025.04.16.07.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Apr 2025 07:49:08 -0700 (PDT)
Message-ID: <f4da5d66-9ae4-4a61-8c6c-394009c12c4c@kernel.dk>
Date: Wed, 16 Apr 2025 08:49:07 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rsrc: send exact nr_segs for fixed buffer
From: Jens Axboe <axboe@kernel.dk>
To: Nitesh Shetty <nj.shetty@samsung.com>,
 Pavel Begunkov <asml.silence@gmail.com>
Cc: gost.dev@samsung.com, nitheshshetty@gmail.com, io-uring@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <CGME20250416055250epcas5p25fa8223a1bfeea5583ad8ba88c881a05@epcas5p2.samsung.com>
 <20250416054413.10431-1-nj.shetty@samsung.com>
 <4ed32b40-47ee-43f8-b3e3-88fdc6ca60fa@kernel.dk>
 <ee2850a5-6269-48c3-a843-4d87c9e107f8@kernel.dk>
Content-Language: en-US
In-Reply-To: <ee2850a5-6269-48c3-a843-4d87c9e107f8@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/16/25 8:43 AM, Jens Axboe wrote:
> On 4/16/25 8:19 AM, Jens Axboe wrote:
>> On 4/15/25 11:44 PM, Nitesh Shetty wrote:
>>> Sending exact nr_segs, avoids bio split check and processing in
>>> block layer, which takes around 5%[1] of overall CPU utilization.
>>>
>>> In our setup, we see overall improvement of IOPS from 7.15M to 7.65M [2]
>>> and 5% less CPU utilization.
>>>
>>> [1]
>>>      3.52%  io_uring         [kernel.kallsyms]     [k] bio_split_rw_at
>>>      1.42%  io_uring         [kernel.kallsyms]     [k] bio_split_rw
>>>      0.62%  io_uring         [kernel.kallsyms]     [k] bio_submit_split
>>>
>>> [2]
>>> sudo taskset -c 0,1 ./t/io_uring -b512 -d128 -c32 -s32 -p1 -F1 -B1 -n2
>>> -r4 /dev/nvme0n1 /dev/nvme1n1
>>
>> This must be a regression, do you know which block/io_uring side commit
>> caused the splits to be done for fixed buffers?
>>
>>> Signed-off-by: Nitesh Shetty <nj.shetty@samsung.com>
>>> ---
>>>  io_uring/rsrc.c | 3 +++
>>>  1 file changed, 3 insertions(+)
>>>
>>> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
>>> index b36c8825550e..6fd3a4a85a9c 100644
>>> --- a/io_uring/rsrc.c
>>> +++ b/io_uring/rsrc.c
>>> @@ -1096,6 +1096,9 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
>>>  			iter->iov_offset = offset & ((1UL << imu->folio_shift) - 1);
>>>  		}
>>>  	}
>>> +	iter->nr_segs = (iter->bvec->bv_offset + iter->iov_offset +
>>> +		iter->count + ((1UL << imu->folio_shift) - 1)) /
>>> +		(1UL << imu->folio_shift);
>>
>> 	iter->nr_segs = (iter->bvec->bv_offset + iter->iov_offset +
>> 		iter->count + ((1UL << imu->folio_shift) - 1)) >> imu->folio_shift;
>>
>> to avoid a division, seems worthwhile?
> 
> And we should be able to drop the ->nr_segs assignment in the above
> section as well with this change.
> 
> Tested on a box here, previously:
> 
> IOPS=99.19M, BW=48.43GiB/s, IOS/call=32/31
> IOPS=99.48M, BW=48.57GiB/s, IOS/call=32/32
> IOPS=99.43M, BW=48.55GiB/s, IOS/call=32/32
> IOPS=99.48M, BW=48.57GiB/s, IOS/call=31/31
> IOPS=99.49M, BW=48.58GiB/s, IOS/call=32/32
> 
> and with the fix:
> 
> IOPS=103.28M, BW=50.43GiB/s, IOS/call=32/31
> IOPS=103.18M, BW=50.38GiB/s, IOS/call=32/32
> IOPS=103.22M, BW=50.40GiB/s, IOS/call=32/31
> IOPS=103.18M, BW=50.38GiB/s, IOS/call=31/32
> IOPS=103.19M, BW=50.38GiB/s, IOS/call=31/32
> IOPS=103.12M, BW=50.35GiB/s, IOS/call=32/31
> 
> and I do indeed see the same ~4% time wasted on splits.

Applied this with a pre-patch to avoid overly long lines, and
with the redundant nr_segs removed and the division eliminated.
See here:

https://git.kernel.dk/cgit/linux/log/?h=io_uring-6.15

-- 
Jens Axboe

