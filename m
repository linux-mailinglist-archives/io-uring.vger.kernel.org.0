Return-Path: <io-uring+bounces-1620-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CD5C8B0B3C
	for <lists+io-uring@lfdr.de>; Wed, 24 Apr 2024 15:40:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE3171C2029D
	for <lists+io-uring@lfdr.de>; Wed, 24 Apr 2024 13:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65AEC157482;
	Wed, 24 Apr 2024 13:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="n0P2cfJa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEDC15CD53
	for <io-uring@vger.kernel.org>; Wed, 24 Apr 2024 13:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713965821; cv=none; b=IwMtVrt2QJD1nf4VV6/1BK8ulXl1H88KsEhQy/b3VAbR9KhhgHrGmr9CmmG9hl7XAdCMTppaJYySglHH6vXCiuWz47l8S9A5TQWNH8myg98k/IlwyY1uMzE9UpCQa9nu4Ghz1b+uzd2GWBm0R7JE6HUe5PE+cEeVoQ67/eEviXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713965821; c=relaxed/simple;
	bh=vOer0e2HuO+Y+T2qAlYxbMI0oDUwHy+iQhTLzBpXI1Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RfIGbYd/5Th1pgoje/07nVH32mMO/aFcQDn4X7bfQBM9TN/XFp1tvh1J4uAIymj/mbZMxuMTObXUvJwrma1OfCsI4RwD8Vzy9CFL4lFat5HSXy+JcTu0CykxMSBpEQKBGDfucqNFMiIW4jiXTs+vBubia8JJWdAaDxeYSxCIqzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=n0P2cfJa; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7d9c78cf6c8so28628939f.2
        for <io-uring@vger.kernel.org>; Wed, 24 Apr 2024 06:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713965816; x=1714570616; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JH82b164A2HMYTRKzYj02bdqGM5tc07tRyBiwlqikC0=;
        b=n0P2cfJa8JWraWbKRBFUiwC+JrlxXjOfJL59JYDgo0MpV2AsYn/EZ1X5SeFQZDbV7m
         o9FiDVMiYT1wwhXiuv3xPA+pSZxC+7pt9L/34ZEue+BuFAv8FitNBJXKld/du3iqlQlA
         zbDKtAb50Ec4u+3PvBaA/9Qbod7gcHgijPDbZdasu8/8foLj3LUT08sSF43XPpypqpqo
         M9LZXJRRcS/SbImykCILXXEJXtOaxlhG8i8boy5z6uuZtdL0Z9zBT+WcgjBYxKf/B9fi
         FPgqu774iIqoHTkqoyR48cKBPxs0qJlgkPUacPxaQqlnKOLCvMhXkpW2+odDCd6C32Z5
         Turg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713965816; x=1714570616;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JH82b164A2HMYTRKzYj02bdqGM5tc07tRyBiwlqikC0=;
        b=L7yOcL4eZ4b6bBYpZGPb6uRExkfGCuOxzUy4z0Dhj/cPObfTb6jIMmhpgpcJ6rvZqM
         Lfh8Oac0jci7AacvVRghPYbwXDWa3oq1smeb267MaicY7SziNlaQx2jf1Q6NPGhwVO+S
         J1zl2+w+MlLGW4OJdnkfW+2obrqpVMfzxWMAl34WDHs8VHdUXDcbSHOdLqGHPDN0bmLg
         sPy2gx4vsEKJxnzjHvsiyNHcEpndk9dOI229rPmCt68qqMOYBXiBsE9RZsZ52ncBCLqF
         kN7FLDZXGB29sASVDtzyOKSvIfzZAXhyqpZunIngJStCSCa5GnZziV8oNYaqlVwFqzy7
         ZsdQ==
X-Gm-Message-State: AOJu0YyyNpkBBnPAFdT15XwSU4Vz2o1YFpHqjvG7PKls0grZlrmKThwB
	Vq94n4oW53gIme7Zlq8Jvf+XWXHPjXu1zFeOBe8zf2/G+BNotdgxk61kTpryfb8=
X-Google-Smtp-Source: AGHT+IF1oXhiZzoqasabnbSsDisPj2lEkCYsIzKwkRORErELcw3+2zbE7U5dSN3mOD4RKe5cQ/+IMw==
X-Received: by 2002:a05:6e02:214a:b0:36b:2a68:d7ee with SMTP id d10-20020a056e02214a00b0036b2a68d7eemr2926697ilv.1.1713965815850;
        Wed, 24 Apr 2024 06:36:55 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l6-20020a056638144600b004851b247113sm2428547jad.3.2024.04.24.06.36.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 06:36:55 -0700 (PDT)
Message-ID: <58d1a95d-066d-4620-950a-fdd70780afad@kernel.dk>
Date: Wed, 24 Apr 2024 07:36:54 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/rw: ensure retry isn't lost for write
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, Anuj Gupta <anuj20.g@samsung.com>
Cc: io-uring@vger.kernel.org, anuj1072538@gmail.com
References: <CGME20240422134215epcas5p4b5dcd1a5cd0308be5e43f691d7f92947@epcas5p4.samsung.com>
 <20240422133517.2588-1-anuj20.g@samsung.com>
 <be81e7b5-06b4-463e-85cf-acee80c452d4@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <be81e7b5-06b4-463e-85cf-acee80c452d4@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/23/24 8:00 AM, Pavel Begunkov wrote:
> On 4/22/24 14:35, Anuj Gupta wrote:
>> In case of write, the iov_iter gets updated before retry kicks in.
>> Restore the iov_iter before retrying. It can be reproduced by issuing
>> a write greater than device limit.
>>
>> Fixes: df604d2ad480 (io_uring/rw: ensure retry condition isn't lost)
>>
>> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
>> ---
>>   io_uring/rw.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/io_uring/rw.c b/io_uring/rw.c
>> index 4fed829fe97c..9fadb29ec34f 100644
>> --- a/io_uring/rw.c
>> +++ b/io_uring/rw.c
>> @@ -1035,8 +1035,10 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
>>       else
>>           ret2 = -EINVAL;
>>   -    if (req->flags & REQ_F_REISSUE)
>> +    if (req->flags & REQ_F_REISSUE) {
>> +        iov_iter_restore(&io->iter, &io->iter_state);
>>           return IOU_ISSUE_SKIP_COMPLETE;
> 
> That's races with resubmission of the request, if it can happen from
> io-wq that'd corrupt the iter. Nor I believe that the fix that this
> patch fixes is correct, see
> 
> https://lore.kernel.org/linux-block/Zh505790%2FoufXqMn@fedora/T/#mb24d3dca84eb2d83878ea218cb0efaae34c9f026
> 
> Jens, I'd suggest to revert "io_uring/rw: ensure retry condition
> isn't lost". I don't think we can sanely reissue from the callback
> unless there are better ownership rules over kiocb and iter, e.g.
> never touch the iter after calling the kiocb's callback.

It is a problem, but I don't believe it's a new one. If we revert the
existing fix, then we'll have to deal with the failure to end the IO due
to the (now) missing same thread group check, though. Which should be
doable, but would be nice to get this cleaned and cleared up once and
for all.

-- 
Jens Axboe


