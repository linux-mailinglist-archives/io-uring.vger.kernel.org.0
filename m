Return-Path: <io-uring+bounces-6413-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 99A4AA349FD
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 17:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84FE116D7A1
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 16:30:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CF9D221553;
	Thu, 13 Feb 2025 16:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cAWwJz5L"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A679B20100E
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 16:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739463579; cv=none; b=EKKWw9XwYWMywTk3qABuGKr3d1r7cG5kLxEjHQ41PmYMUykP5J9DCPTxcdO3YNr/V96s0sp12EFyxnvPaTC/JrawjPIOvmjx47Am5AqtUd1UCDj6ludlN5NxXZQ9RlrsXNUQ3swY49EB56GNISWj2I1a/8IXFqw4056Gl+eWDTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739463579; c=relaxed/simple;
	bh=iOi5qlrBwoMulV1hfBYQjEnk32anslsQ//vzWLPee0Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W4h6NQGLykpkSminH8ddBrf7jhjNVo38pyikWHvnvg3mgTyB5Fj3YlPsPDlrDZrB+jtFJj28LpPvtw7ZZtCfnLc2wDQdc9j8TLnuMRqf9iDlusqc4O7vVwbLjZ1BKMqM1cTZqePMKKsVv39aEkVwoqsgvymhTwiYZ9UrlbsP7Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cAWwJz5L; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8552ae0fc4dso79854039f.1
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 08:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1739463575; x=1740068375; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tQp9s79b+Ezmj7SlPyq7hDlYPzpnj/bbH3ubw6dgFng=;
        b=cAWwJz5LmTfRgunzYnQyU1wpSt1CB5jTQiwIGwrZtk5Q5RZ/cPIZ6GTBlIRGZLVp+K
         +ppREYv81KhYsWmVSaixiZXcOgsB43FFcovYzgiEAMuxiTVom3fQblNKDroGpzq8n5Ht
         HyFIfktnMP/hEwVFfEWI2IPCXJnGLljdw9jJg4JoRiyiIYDKeZfozcgPIXsQRleC4bvP
         X8Z4F6gROyujqJXL8VCKOLJywifYoU+a0j02zlkfvh2PjdyVe7IQdofSaKHoS0PmqRdu
         pcTx7tFtbep3Fn5P3Ivl781nJGQWOEkl2cwc7JU+gKIJGJ7kbWfrT4rESYdBVo/YEi8X
         bfjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739463575; x=1740068375;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tQp9s79b+Ezmj7SlPyq7hDlYPzpnj/bbH3ubw6dgFng=;
        b=kDj+Dqgh/kM2y0xVlTZbGjuQqyYeHtcKJtexDmWhRQ7kJ1Tqe6rBQRA0e7lKuZrZtr
         UweHOElpDS/CrewWegWAS9+cCkJb9hl3SFspVIj/1TXZTHD7Aiaq6Rx2CZRMT3+8SrUN
         jhJRESlje6DOiIFscDkT3A/BESqpUBxZfVZGQPURuVV6cSjcDuJTpIEFjE8HF03Xkkuj
         36JURR7MdPIBSYLvxxXAApb/gx3FDfT2QvV5P5w09UmPliz3jGhYrqunaM2Hcz8mvykT
         KOeZ3RB6aWxeKndC5/ypS1uAkS2wMvlRzzQJSZQxEeL52ANW0TC7QGT99U5di21ANs7M
         m3JA==
X-Gm-Message-State: AOJu0Yy35CN5/s1WHdO/fpkF44pSJpYAV4fTwKrjsMQE+zgmprXiYejA
	2lMketjYFzyqNf/2Vpi6NmQF3XE/MOpOvsrwaq4FbUNgMA0LAmawQgQYjvf5Atw=
X-Gm-Gg: ASbGnctPDne86xGrt5fzy0urJ+i1/gVLtM5kPiYlo7OhUD4YrY8DfwBFqWO3dDVfhgw
	/dV/DioDjd2nR/bWuh8LHohPzL0Cd1HlGXy7BSsh/hE+Ai1ZYc3lHgRXMzE6izFlNwnUiHatU9e
	lWcqMoRJYTIxX66W54/qBSRP+5FDwIiJ7EFJIBKJ33IYToISS66vCvAWX5ESoiFNHGaT+m0Ugjs
	JwkAe+SWOybx5c94U9LWurLZKcHK3DInrZm/SKLbc/dlTkbP6uFU0Bcl5dIp8FYF9mAcPp2MTIT
	EuaSNH/dkJg=
X-Google-Smtp-Source: AGHT+IGd6ZATMuwdQYR+X9hp9KOQ+aOcRJXis4hdScRTs5lXXUUNPC3B5PICPfFlUVUUld+bOxVDxw==
X-Received: by 2002:a05:6602:6b19:b0:84f:5547:8398 with SMTP id ca18e2360f4ac-85557a194fcmr647999639f.11.1739463574201;
        Thu, 13 Feb 2025 08:19:34 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ed281498e3sm379124173.27.2025.02.13.08.19.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Feb 2025 08:19:33 -0800 (PST)
Message-ID: <da9bab97-b880-48e7-a5c5-9050aa009fc1@kernel.dk>
Date: Thu, 13 Feb 2025 09:19:33 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/uring_cmd: unconditionally copy SQEs at prep
 time
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring <io-uring@vger.kernel.org>
References: <9698ab08-3f36-42f1-b412-e2190d2e5b6b@kernel.dk>
 <CADUfDZo-mqM_PwoPK3_JX14QY3sQfVXnSwD=+30tdcAiD9fTJg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZo-mqM_PwoPK3_JX14QY3sQfVXnSwD=+30tdcAiD9fTJg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/13/25 9:16 AM, Caleb Sander Mateos wrote:
> On Thu, Feb 13, 2025 at 7:30?AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> This isn't generally necessary, but conditions have been observed where
>> SQE data is accessed from the original SQE after prep has been done and
>> outside of the initial issue. Opcode prep handlers must ensure that any
>> SQE related data is stable beyond the prep phase, but uring_cmd is a bit
>> special in how it handles the SQE which makes it susceptible to reading
>> stale data. If the application has reused the SQE before the original
>> completes, then that can lead to data corruption.
>>
>> Down the line we can relax this again once uring_cmd has been sanitized
>> a bit, and avoid unnecessarily copying the SQE.
>>
>> Reported-by: Caleb Sander Mateos <csander@purestorage.com>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>
>> ---
>>
>> Let's just do the unconditional copy for now. I kept it on top of the
>> other patches deliberately, as they tell a story of how we got there.
>> This will 100% cover all cases, obviously, and then we can focus on
>> future work on avoiding the copy when unnecessary without having any
>> rush on that front.
> 
> Thanks, we appreciate you quickly addressing the corruption issue.
> 
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
> 
>>
>> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
>> index 8af7780407b7..b78d050aaa3f 100644
>> --- a/io_uring/uring_cmd.c
>> +++ b/io_uring/uring_cmd.c
>> @@ -186,9 +186,14 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
>>         cache->op_data = NULL;
>>
>>         ioucmd->sqe = sqe;
>> -       /* defer memcpy until we need it */
>> -       if (unlikely(req->flags & REQ_F_FORCE_ASYNC))
>> -               io_uring_cmd_cache_sqes(req);
>> +       /*
>> +        * Unconditionally cache the SQE for now - this is only needed for
>> +        * requests that go async, but prep handlers must ensure that any
>> +        * sqe data is stable beyond prep. Since uring_cmd is special in
>> +        * that it doesn't read in per-op data, play it safe and ensure that
>> +        * any SQE data is stable beyond prep. This can later get relaxed.
>> +        */
>> +       io_uring_cmd_cache_sqes(req);
> 
> If you wanted to micro-optimize this, you could probably avoid the
> double store to ioucmd->sqe (ioucmd->sqe = sqe above and ioucmd->sqe =
> cache->sqes in io_uring_cmd_cache_sqes()). Because of the intervening
> memcpy(), the compiler probably won't be able to eliminate the first
> store. Before my change, ioucmd->sqe was only assigned once in
> io_uring_cmd_prep_setup(). You could pass sqe into
> io_uring_cmd_cache_sqes() instead of obtaining it from ioucmd->sqe.
> The cost of an additional (cached) store is probably negligible,
> though, so I am fine with the patch as is.

I did ponder that (passing in the sqe and storing once), but didn't
figure it'd be worthwhile to do. But on second thought, maybe we just do
it, passing in the sqe and letting it be assigned in there. I'll send
out a v2.

-- 
Jens Axboe

