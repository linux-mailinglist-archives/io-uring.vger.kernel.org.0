Return-Path: <io-uring+bounces-6122-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F2ACA1BDD8
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 22:23:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4785B3AE5BD
	for <lists+io-uring@lfdr.de>; Fri, 24 Jan 2025 21:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E34321DC996;
	Fri, 24 Jan 2025 21:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JXa6Foa7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DC411DC98D
	for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 21:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737753831; cv=none; b=B7YFcRMonClnEHQ08vR29UGfI0CkJGNvIdiQNtkg7tjqAflszcfGTVSaeWzq7xRID6PVHy7l3g8OC4Pjb6AiPz1RNPZaHuVn6W9jcDM2HsiwgEHubEVIDPuPkvkXTXRuZovaphCF8FeloLmVZjrtEEmwCuPHF4uMK29xRjU4KsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737753831; c=relaxed/simple;
	bh=rQIc2KQEjTVWIrmJToHxIfBXM7cYL7IfGQsszIxoXyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hw58853obu32B89pgSkd6Ub6IILy6XVgJmXwskLqxa3Qf3/xiN8w8lqoiaHK0/tfl+c6NCYnS3S0lAydHkQ4DQcnEvYHpY5S4RvSjrGobbXxDOElB6nsvFVmUHeyxOW0f8IAOnGRMTo0S6dsRmIWUrbw34L8gyqGFkV3p/1qNmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JXa6Foa7; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3cfc1ff581dso5514455ab.3
        for <io-uring@vger.kernel.org>; Fri, 24 Jan 2025 13:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737753828; x=1738358628; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tFE/86LlpI8R5Z4Y+XyrjI15dIwEYCPt4gXhui4nwQA=;
        b=JXa6Foa7BOk1q3CbRnC2SvbYjvMnKhqPyeu3dKP7DMu5dInA8K5A18rF3Q1kKPyUuA
         Ttx9pnUbc5XUGZDpD6Sh8IH+NBtX3Xw54ZUUmnB52aGUuTFO2c96zSmHbUuzzDAITVJ9
         F6UWSfsZAYafJZZs5REG3tcBflH034MjA6vX3ySuX/SDKe0i1zRPRy1NQJ6nd++wYcBZ
         d7LJEcxbdepk/t/T2T3CZA1H7qupljTXLR1g43BIKpS1BYfyNboRgkWV3oFDCbWhiikt
         ZFUU1mJPV8rku1cCnmg0pH2238RwyJISf6pO5G0Bv3JzLvEi7j8kM6qHWFcWgGH5rPHT
         smxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737753828; x=1738358628;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tFE/86LlpI8R5Z4Y+XyrjI15dIwEYCPt4gXhui4nwQA=;
        b=oqC3fghXnvSM89CmIfCMCsgmuqzu2X/Xbg7IWvlnBhfZdSELe6/8ab3M5TsA20J2As
         SoVWq5y53rEx0YEEHpfKp6TJSoQr10jI644l6Nd2AvU4yFh8upBk3h5unRvNwBit+Rxe
         7R9eCBPpFJR8rkAh+L072Qvn923txsM0coSrWX0rdgBw8tLHgeqD8zz0iYRwNe09j5Mh
         lStPuD6at40AcL5yUkrs6m95rWVmv5akxV9QaG1d+kYJxkeTYk/VgVD/icQXrObqYf2+
         TCPmQfFVmkNzjgRmdy/kmtvOlnzKwohQs5H/Qg35vpwPus+tVhol0YlIsVvFuxcwlo4Q
         oi2w==
X-Forwarded-Encrypted: i=1; AJvYcCVY3U6oyNgQgpjLzUjaU9V/1I3qw437HooWPuybKJIGgCcOKWK1Sy2TKfAox3Opj9u/srqTt/Ii/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5ujD2/qMdJadq577V6gcQeqwfLphvzu8d17+UaVIb013S45TX
	r+/kCdefjVVdT8/KgaZ85CsuLjazyfSZHxG2nxlhrDM7aq+IUCr1Pgs7/raZmlw=
X-Gm-Gg: ASbGncv2eQQY2lvOD5bK4ndavKfUNOQsvoOpruXPX4y8+EA64qFqzWvw90VhXXtLLzX
	pmHNPuemUmaAsmOmsXFLtRXur/OUUyH3AYBzbjC2/oRo3LoQuzflI3+X0AWjdxpquBfX4+MiDKT
	nH8Cic7JyRDbUW0oRM5zF1l4IWXGJr4EMdhoVw5baiIHIaH0TyMiy+d9ADmn7HYVjjJHcVYGr/C
	vzkFHRCb9UVKsvLeEALfimDs16NgOgjJb8YyFz3GIkIBfZnYknFQJOtI6vzMSYdv7Rx+63vcK4v
	ZQ==
X-Google-Smtp-Source: AGHT+IE2wUO3cR2PbEkPM3r4ze97FP3yesKSEAHuxMfW+jXFJwBMIVoLTOyB7iMDWxKFazVpPEvp2w==
X-Received: by 2002:a05:6e02:19c8:b0:3cf:c82f:586c with SMTP id e9e14a558f8ab-3cfc82f591dmr35855075ab.4.1737753826436;
        Fri, 24 Jan 2025 13:23:46 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1da0397bsm866293173.1.2025.01.24.13.23.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jan 2025 13:23:45 -0800 (PST)
Message-ID: <7a9a4b5a-93c6-4b63-aa32-83e9a2642511@kernel.dk>
Date: Fri, 24 Jan 2025 14:23:45 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH stable-6.1 1/1] io_uring: fix waiters missing wake ups
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
 stable@vger.kernel.org
Cc: Xan Charbonnet <xan@charbonnet.com>,
 Salvatore Bonaccorso <carnil@debian.org>
References: <760086647776a5aebfa77cfff728837d476a4fd8.1737718881.git.asml.silence@gmail.com>
 <721da692-bd23-4a73-94df-1170e3d379be@kernel.dk>
 <de8f5241-e508-4c30-b807-f16fd1cdbe9f@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <de8f5241-e508-4c30-b807-f16fd1cdbe9f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/24/25 2:23 PM, Pavel Begunkov wrote:
> On 1/24/25 20:47, Jens Axboe wrote:
>> On 1/24/25 11:53 AM, Pavel Begunkov wrote:
>>> [ upstream commit 3181e22fb79910c7071e84a43af93ac89e8a7106 ]
>>>
>>> There are reports of mariadb hangs, which is caused by a missing
>>> barrier in the waking code resulting in waiters losing events.
>>>
>>> The problem was introduced in a backport
>>> 3ab9326f93ec4 ("io_uring: wake up optimisations"),
>>> and the change restores the barrier present in the original commit
>>> 3ab9326f93ec4 ("io_uring: wake up optimisations")
>>>
>>> Reported by: Xan Charbonnet <xan@charbonnet.com>
>>> Fixes: 3ab9326f93ec4 ("io_uring: wake up optimisations")
>>> Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1093243#99
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
>>>   io_uring/io_uring.c | 4 +++-
>>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>>> index 9b58ba4616d40..e5a8ee944ef59 100644
>>> --- a/io_uring/io_uring.c
>>> +++ b/io_uring/io_uring.c
>>> @@ -592,8 +592,10 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
>>>       io_commit_cqring(ctx);
>>>       spin_unlock(&ctx->completion_lock);
>>>       io_commit_cqring_flush(ctx);
>>> -    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
>>> +    if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
>>> +        smp_mb();
>>>           __io_cqring_wake(ctx);
>>> +    }
>>>   }
>>
>> We could probably just s/__io_cqring_wake/io_cqring_wake here to get
>> the same effect. Not that it really matters, it's just simpler.
> 
> Right, I noticed but am keeping it closer to the original
> in case we'd need to port more in the future.

Yep that's fine, let's just go with this one as-is.

-- 
Jens Axboe


