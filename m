Return-Path: <io-uring+bounces-1438-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C84F089B422
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 23:47:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5F391C20A76
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 21:47:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13A36107A6;
	Sun,  7 Apr 2024 21:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OMgYE3tn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0926D2582
	for <io-uring@vger.kernel.org>; Sun,  7 Apr 2024 21:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712526419; cv=none; b=iEhlEF+IPnf7qtUTAQp0ltkI5T3gkzzvvCTOiVtqkOSEKzlHizF9aLky4C/0uOUt9kSbq7+eo0lS/ug6NAEyFW/OUZG511JiANr252KDV2Sqo1lWE6x574V//RsPEQEAkaWA3tjp1ncf0ZbQ09jE3gsyPyBi6bAhtucnX6GFgxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712526419; c=relaxed/simple;
	bh=U71zs8qFTYW9Ccg0eg/RUlPL0r+pU/NRYZJIbhplLmE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=I40mtD7ZeYjrYhM1Ctoxjb2zSU4osrRmhV97I117viHEQqpmwxfhCRhz9SaFfpkGrCuTi16etc5HwQSrbOmS+STuGpG1uGRXxDJnHpphDfUxhtnbGAgRk3csJdOJd3nELj2VRaSxdhd58whq/wAuACY3R2rry8NciGMB4O2rXyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OMgYE3tn; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so86326639f.1
        for <io-uring@vger.kernel.org>; Sun, 07 Apr 2024 14:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712526414; x=1713131214; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZR5Nu8Ce/vHDu1Y8+Fh5OH2QX14f/yOrHbnRnFt9PMg=;
        b=OMgYE3tn+kkxDjAQhRL8fKPZ3jI44GPfRFv2HTHP0yJf4G4VYWjvDkg0O3i1qgNCuh
         ZuHfq4uYRqtVycIvTBhvZVrg1jtFYW06wyO3UbFh7DQUWSS0SA0PWtLuEP8sJ0imh5gt
         13PpSx2lY0onQQ19OJzaam+6XiqG7gED6sblJtLa80qWOewDOIZAnu7ah803Q3J7YiZ3
         dSH7lJyyjDVKC8S1MyBRKmzTWPU2x6wf5z2P+sV6DxtOP79q7c3ULuaeFi8F4Op6TYzx
         PufCpidO8F+Ly2Mt4fOCJs1f6igZqIwjagyqQ0n6OdbKKv+UETMV0nJAaNrDpLFRt0n8
         89jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712526414; x=1713131214;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZR5Nu8Ce/vHDu1Y8+Fh5OH2QX14f/yOrHbnRnFt9PMg=;
        b=r9JsEAdHc96vjVVtM0dbpQhZUk0UdLYMqXiNPN34RH7sPMFWHNVH0hAMU1q+mD1xM1
         5i6D2mLhH3Uk5sBefRLA9/Hpo7C3j3csQFZXq/SK697LeirbwyGtyTfxIxlCvLAyLrjx
         K+r08q5cKFzPPOttUMGQLYP/PSkDk5H67JQ+w8bdGw5C603dDy0PjGW1TeOZEtdSp2eU
         JJQcBIxr5UB1Ox594Aq1hUNo+LRFaWMHejstZRDLdE3QMgkskFJbSONAU6Pw7pPS9shC
         W4pNdcr4qPnJbLXZ4rfG+abGkNccYAndtMWImABv4CDPxc+V/EbIz5vdSuRRC16rCg5I
         e4kA==
X-Forwarded-Encrypted: i=1; AJvYcCUVQQEu7pi18/wqO6TapIDfLH5BzLCTfVwjR/8UTJbqrsplL/tmGxnmmG6wSLh/hMmNGxY9m4jLwz2R8uXL4K09+ycr3BqVks0=
X-Gm-Message-State: AOJu0YwOVrwLHxG2/zehl+AKKCPdABsn0G+AeomjKSwgFDxHs76z1czT
	GLkxjMygWNV7oZx4/zY8ukjQyRXF5uz0d0+ufhaAUaXHAGZyt8l86BPc5mAA9Ts=
X-Google-Smtp-Source: AGHT+IHJ2R/8d7EYoRdbwVGIazDzHGkziVwHFrpmuwKOwWUx6fchZZ3X6B05yrDvza0ZuYf9S3XJ8w==
X-Received: by 2002:a05:6602:1644:b0:7d5:cc9e:9d96 with SMTP id y4-20020a056602164400b007d5cc9e9d96mr4767136iow.1.1712526413867;
        Sun, 07 Apr 2024 14:46:53 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h10-20020a5e974a000000b007cc6af6686esm1842874ioq.30.2024.04.07.14.46.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Apr 2024 14:46:53 -0700 (PDT)
Message-ID: <c15e7779-a187-451f-aec4-952799c72f90@kernel.dk>
Date: Sun, 7 Apr 2024 15:46:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 16/17] io_uring: drop ->prep_async()
Content-Language: en-US
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20240320225750.1769647-1-axboe@kernel.dk>
 <20240320225750.1769647-17-axboe@kernel.dk>
 <86c8ac48-805b-4cb4-be05-0e3149990ff7@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <86c8ac48-805b-4cb4-be05-0e3149990ff7@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/6/24 2:54 PM, Pavel Begunkov wrote:
> On 3/20/24 22:55, Jens Axboe wrote:
>> It's now unused, drop the code related to it. This includes the
>> io_issue_defs->manual alloc field.
>>
>> While in there, and since ->async_size is now being used a bit more
>> frequently and in the issue path, move it to io_issue_defs[].
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
> ...
>> @@ -252,6 +260,7 @@ const struct io_issue_def io_issue_defs[] = {
>>           .ioprio            = 1,
>>           .iopoll            = 1,
>>           .iopoll_queue        = 1,
>> +        .async_size        = sizeof(struct io_async_rw),
>>           .prep            = io_prep_write,
>>           .issue            = io_write,
>>       },
>> @@ -272,8 +281,9 @@ const struct io_issue_def io_issue_defs[] = {
>>           .pollout        = 1,
>>           .audit_skip        = 1,
>>           .ioprio            = 1,
>> -        .manual_alloc        = 1,
>> +        .buffer_select        = 1,
> 
> This does not belong to this series

Indeed, thanks for catching that. I'll reshuffle the 6.10 branch once
the next -rc is tagged.

-- 
Jens Axboe


