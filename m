Return-Path: <io-uring+bounces-10431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E370C3DD07
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 00:24:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EE82534C672
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 23:24:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0958E2DA776;
	Thu,  6 Nov 2025 23:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kmsuvfvO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5CA33C51A
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 23:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762471468; cv=none; b=FJk7hAA1sG7t4mSrB92q3CZy3TFDxJ324e0CkKwmk133PFCVvOveGknR21QB8uMYWKB/mKx1W6f0t9GafBX0cL1+x0rFBKO1GgIRpyCTS4UKgtMJO3q4ft0uadahKmOCfTE374fLHre10P8jtT9PPG60vwRgZ7VqjInwM/M9GRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762471468; c=relaxed/simple;
	bh=+j05ki7IseEfEF/jzjfiDt0usdVQN8AwiRQz5Tp2JJI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=DgzV5Ra9NfvpC262WvShQT+U9uxI42ztZ0SQqAS4Yfn/TGJH9IgB7Oylfp6/lv+pitUM/o2vRV8Y0Iw6JAlhgWYWPYdDZ3uF9OG+q8m1CRYERqDck4bMHX0iauBskLjEfqpVIT45qO2ehyrxW8SQph+C4fQjhvKL3xCLyC+ISUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kmsuvfvO; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-880499b2bc7so1535466d6.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 15:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762471466; x=1763076266; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=X8pvNvD2mmpd2lZCRo9yHX+vSYWBJNH1pQ9qYEQvK/M=;
        b=kmsuvfvODCQZRjBLzrDf5vQT7Xrh308mLB6Xn9YErBX2kZ8/Bepneq4kLeZrczilh6
         X2vqs2EfWlJVNvpp5npHREo4n36w7wGY4AQnHXXeubhss/7oD8zO50RRm/uKF6Cqj8mY
         hcdIQhqIvOFvzmoHN+LsscG+67zteoG5Fk+Rbn+jJaNFDn8Flr79aVebf0Hk4fp7ed/i
         rc27bRXoaqAKcbFH0qV89U7lisRhePGTaz7CxEaucUZY01HI6aByJdxcFyVD28eYcTEd
         pDhVHukgs0zNuWjD6kTuDgqM6P3vQ10VR9/8ZzoX31TEKauVUBtP4y+wn0Ps5+vwtpx6
         73Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762471466; x=1763076266;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X8pvNvD2mmpd2lZCRo9yHX+vSYWBJNH1pQ9qYEQvK/M=;
        b=DPLi3VVqeAShl4ot1nIE+jbeHzelbdwjN69uPPKeOJr4WK0N4Ky0gwxqoPZ8knMEB1
         QxjF4j0jux6LRz0PYIEOvS5KfpyQG1UBDEr7GTQ+H1iAq1MsrdvWkpAzhXWVwvWTAPcv
         NkYl5l27zx2zklw7eyg28lo2zW2U8RvN6z+vhhZr0WyrB9ReWpwfl/lEQ3iSCEW3mswC
         vhKvDFbSZ2ArfAUe8TOggiYhmV8b0VSLJnWKz7z2eteklQ0QQily+8XOEeac9ys2/7+n
         bffjol64zOdpRmTx+FTcb1AYes/59sUOrz1Tm10v0tMz1v+1mMvHpkmJ/9elpVfcRhh+
         0fCg==
X-Forwarded-Encrypted: i=1; AJvYcCVrIaWSToYVQh3SM7AQ+X/f1ZKnrA6+ThoBmLke6Nsiu2+Dwg2YR3E1Gq1XW31eqc2Aogbh4mG4xA==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywbsbij36GM9iMF7zg05uF5+lm2PXJuS9XbetBhKVvckkhHfux7
	TvG6k6db3rPW+IcmHlmznCbtCPwbrMG+nB5pdd+IWI/fBnHoRTCK6BAeWIn2Y4AI+vNSKqZXa0G
	4wk2h
X-Gm-Gg: ASbGncvrBCp1jetMb82OC7j8agZ6WsYEsBkxa6Ep+W26BF+1GjD2hXygRi6Mmv/NOd2
	vNvn/48ASG5f0GLyCN1zQK8H/mozVqC15PMaFFuTMOx6NXeCoVGCm4FFBN3wk8fKZR6zmaitT7o
	6At+HqxMuKuEdAY3rF+8JEFmt24gWUciLQm9QJSIgXGVxXhDUWyGVfx2C/LCgiJC+yv7jRwX3kI
	TpilXFMYsLC0/nJxffkFslWrSnje0a/LJgAOPF2tLNEBaPykWxVvNSRE2Yi+eGyHbbB0DzNja7n
	wzrbKFMKbstGibtmLmyKCyIVOasywQ6nQ4SOL1Xs1zoci41l2ABnZ6evJ3/YlJ9rO5sgavuqI87
	Kk+CR4iNEY7JtsgNWqzPHFI4Ct9/t3+A6pzF150HXb7RcNBiATSPzQzUk6Sl8l/9B2KomlvSh
X-Google-Smtp-Source: AGHT+IHyNHww5rt6jLKflfTLiu788dt039OhRzFnLiItUeoeQa1B3aqh+ffJh/3L0s25zTW3GQmi2w==
X-Received: by 2002:ad4:5b82:0:b0:768:f173:a0a1 with SMTP id 6a1803df08f44-88176754708mr17897716d6.42.1762471465645;
        Thu, 06 Nov 2025 15:24:25 -0800 (PST)
Received: from [10.0.0.167] ([216.235.231.34])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88082a4af81sm28051776d6.61.2025.11.06.15.24.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Nov 2025 15:24:24 -0800 (PST)
Message-ID: <991b21db-22d1-4cc2-84cc-19a6a2c94123@kernel.dk>
Date: Thu, 6 Nov 2025 16:24:24 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET 0/2] Add support for IORING_CQE_F_SOCK_FULL
To: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <20251105193639.235441-1-axboe@kernel.dk>
 <c5390f95-22f6-4b21-b1b1-bad44d5fc1e5@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c5390f95-22f6-4b21-b1b1-bad44d5fc1e5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/6/25 5:19 AM, Pavel Begunkov wrote:
> On 11/5/25 19:30, Jens Axboe wrote:
>> Hi,
>>
>> It can be useful for userspace to know if a send request had to go
>> through poll to complete, as that generally means that the socket was
>> out of space. On the send side, this is pretty trivial to support - we
>> just need to check if the request needed to go through poll to complete.
>>
>> This reuses the IORING_CQE_F_SOCK_NONEMPTY flag value, which is only
>> valid for recv operations. As IORING_CQE_F_SOCK_FULL only applies on
>> sends, there's no need for separate values for this flag.
>>
>> Based on an earlier patchset, which utilized REQ_F_POLL_ARMED instead
>> and handled patch 1 a bit differently.
> 
> FWIW, same comments as last time. REQ_F_POLL_TRIGGERED is set not
> in the right place. And, with how tcp manages wait queues, you won't
> be able to use it well for any throttling, as the user will get the
> flagged CQE long time after, when the queue is already half empty.

I'll take a closer look when I'm back, on the road until Monday...

-- 
Jens Axboe


