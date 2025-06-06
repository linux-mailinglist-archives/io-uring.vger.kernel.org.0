Return-Path: <io-uring+bounces-8259-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6282FAD078A
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 19:33:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B98BE189239C
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 17:33:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 140DE1DF24F;
	Fri,  6 Jun 2025 17:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RBfOROOz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496267D07D
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 17:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749231183; cv=none; b=tffM6upcyGjngxTTjOzB0+UPWhBNGxA4kyzaGv+1D55L2618Zx6Ef7Cm/+qJTgU0DPcOp9TbrkGTkXoHofEna5mn8WkPhkhT90q5xXQVB6A1OLsReCnueVZWn5tTG30xdTSj1saivZeA0pJ4WLLvqJre83gGfVSUH56G+PFfWr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749231183; c=relaxed/simple;
	bh=bVcGPCF2hiNNYGYvSARyotVAHxAwXOUJBYMF6VEezQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NjsHxgm+uY96GbUP1Sm2+SsD3BjdNiV6h4h1LFCA973Z3Hmdaj7kefvwp9T2MZ0MjPkFbcWGFrqo7+ih6TVunvRpfFNgwoOlsue72BzFakSGvjXO58Dn5CLQdQdnaQQjthqgMpyoqhYRbXiQUIfVL1wWWsXmLfZcCRaVqd0PYMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RBfOROOz; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-8731c3473c3so71001939f.1
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 10:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749231178; x=1749835978; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sg+1sAEfNUIUrxIXEISfwd06tDg16yw657LVwR0SXCY=;
        b=RBfOROOzit1bE4AkdkWs2RVlEYPN7q+9frBnqa559/+E/og349/LymUIJmNyXUEA1c
         kwr6zlbmNhwWslUCv51/QoKSoDNXT2t8vYAr7y3eGy5eDLuZOD7MPfMpcdTSXDjvpHid
         Q/oncUCsnJ5mIkqqFClYHQG05g7qR+RHVWqjM85NXS3nUkhAgMuDISsbJhFJcX3JEYaG
         NDWIXiXgpsgqoaY9D2D4CwAZUa8AKeUmadLOPX/BYWf8/adn1/0xCthPJKmr8EjJ5Ba2
         5RY1j9tuy9V/5EuQIAqW3CD00Lw7eFAYD1cOZeWC588Ptsu13c0YcKWlUNKGBVdYz2uF
         140w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749231178; x=1749835978;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sg+1sAEfNUIUrxIXEISfwd06tDg16yw657LVwR0SXCY=;
        b=jr3sv1qjX8t0C34WJoxotc6VSF1SZDY9/uCMZlDa29SCOXYC7M1pYdlbbnvpEX/OKL
         ZpiYNsa+as3AmY2ypzKu1qZoBSTyTqCwaU5Z10D3Fz/g/P74INGtMJp3bRjOFXqtiB56
         AA3Aap9XLwB9cUdxv7yOtgF+kvCSzc2JmykwiZ/hXyjrn3+s7t0jfu6/NTMWkdQ6wM9j
         6v6Ho6W90ms4zXvbodkB6ZNOOiml4LkRdlGoeoYaLqFk6nC3IfJML0SEYkH1rQYEuy/L
         jsQrX2x3cte8Uv8ZLXRFaVrbvsRs7W58gMxo+1ivdDuQqfx+TZIBmRkj0sEmUjZ9NziF
         qebQ==
X-Gm-Message-State: AOJu0YyBMnjWlJkVYkaCg+A0UJAURO3CU+PubOv8r1IfmnOIk60VtGU3
	r87PE3pccpzHkbG+xsfyVL5eUq3JrEa1J17sKjmdCUjf8+FFKOuECUX7YQJaNDRT4RabXnjr4g9
	GwExn
X-Gm-Gg: ASbGncvts9zejghECC+phRkeqRuRU2OIgKcZXuJEbTtymvlw4KMEydBxC6BG2DbqMif
	CM6hchlpsSQ6nQz0ZxUeK+wgxLhqVw4Kl9YZ9g4rHhzZm07FVKkjuZ3fwqpT3Cj87qGkns37AzR
	Hma4j3hb0132C0WkxIW+YA+j/h/2kKwy26xyvdg78+fNn27yyT8VbUiL58AjCB5bssY1PspolhC
	9of8ij4Jj3L2nPs3bwnXALIUfAIsDrVm+IfuqnlJaAjftUoyqAaPerQPGvHjvHxD9yEc1BWC98z
	ExwxNkVMLqNJffKW9kgPt3Mpns2fVDnUruPXQvapuRYXw3UZ
X-Google-Smtp-Source: AGHT+IHg4GJYBsymaE3LAXWQFIKqaaW2znn5jsWEjCdCg75RqFnl4bqmzdpSNr9L58Ht2WdugT/Vgg==
X-Received: by 2002:a05:6e02:5e0a:b0:3dd:ceb0:f603 with SMTP id e9e14a558f8ab-3ddceb0f61dmr32919005ab.2.1749231178370;
        Fri, 06 Jun 2025 10:32:58 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-500df5865acsm536560173.71.2025.06.06.10.32.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jun 2025 10:32:57 -0700 (PDT)
Message-ID: <453b9f15-f047-464f-9602-c3fd99df89c3@kernel.dk>
Date: Fri, 6 Jun 2025 11:32:57 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHSET RFC v2 0/4] uring_cmd copy avoidance
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: io-uring@vger.kernel.org
References: <20250605194728.145287-1-axboe@kernel.dk>
 <CADUfDZrSAUYtd2988vSUryNt2voSUbngXtBcAU3Cb+JqYuuxTg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CADUfDZrSAUYtd2988vSUryNt2voSUbngXtBcAU3Cb+JqYuuxTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/25 11:29 AM, Caleb Sander Mateos wrote:
> On Thu, Jun 5, 2025 at 12:47?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Hi,
>>
>> Currently uring_cmd unconditionally copies the SQE at prep time, as it
>> has no other choice - the SQE data must remain stable after submit.
>> This can lead to excessive memory bandwidth being used for that copy,
>> as passthrough will often use 128b SQEs, and efficiency concerns as
>> those copies will potentially use quite a lot of CPU cycles as well.
>>
>> As a quick test, running the current -git kernel on a box with 23
>> NVMe drives doing passthrough IO, memcpy() is the highest cycle user
>> at 9.05%, which is all off the uring_cmd prep path. The test case is
>> a 512b random read, which runs at 91-92M IOPS.
>>
>> With these patches, memcpy() is gone from the profiles, and it runs
>> at 98-99M IOPS, or about 7-8% faster.
>>
>> Before:
>>
>> IOPS=91.12M, BW=44.49GiB/s, IOS/call=32/32
>> IOPS=91.16M, BW=44.51GiB/s, IOS/call=32/32
>> IOPS=91.18M, BW=44.52GiB/s, IOS/call=31/32
>> IOPS=91.92M, BW=44.88GiB/s, IOS/call=32/32
>> IOPS=91.88M, BW=44.86GiB/s, IOS/call=32/32
>> IOPS=91.82M, BW=44.83GiB/s, IOS/call=32/31
>> IOPS=91.52M, BW=44.69GiB/s, IOS/call=32/32
>>
>> with the top perf report -g --no-children being:
>>
>> +    9.07%  io_uring  [kernel.kallsyms]  [k] memcpy
>>
>> and after:
>>
>> # bash run-peak-pass.sh
>> [...]
>> IOPS=99.30M, BW=48.49GiB/s, IOS/call=32/32
>> IOPS=99.27M, BW=48.47GiB/s, IOS/call=31/32
>> IOPS=99.60M, BW=48.63GiB/s, IOS/call=32/32
>> IOPS=99.68M, BW=48.67GiB/s, IOS/call=32/31
>> IOPS=99.80M, BW=48.73GiB/s, IOS/call=31/32
>> IOPS=99.84M, BW=48.75GiB/s, IOS/call=32/32
>>
>> with memcpy not even in profiles. If you do the actual math of 100M
>> requests per second, and 128b of copying per IOP, then it's almost
>> 12GB/sec of reduced memory bandwidth.
>>
>> Even for lower IOPS production testing, Caleb reports that memcpy()
>> overhead is in the realm of 1.1% of CPU time.
>>
>> v2 of this patchset takes a different approach than v1 did - rather
>> than have the core mark a request as being potentially issued
>> out-of-line, this one adds an io_cold_def ->sqe_copy() helper, and
>> puts the onus on io_uring core to call it appropriately. Outside of
>> that, it also adds an IO_URING_F_INLINE flag so that the copy helper
>> _knows_ if it may sanely copy the SQE, or whether there's a bug in
>> the core and it should just be ended with -EFAULT. Where possible,
>> the actual SQE is also passed in.
> 
> I like the ->sqe_copy() approach. I'm not totally convinced the
> complexity of computing and checking IO_URING_F_INLINE is worth it for
> what's effectively an assertion, but I'm not strongly opposed to it
> either.

It's no extra overhead on the normal issue side, as the mask isn't
conditional. For now it's just belt and suspenders, down the line we can
relax (and remove) some of this on the uring_cmd side.

-- 
Jens Axboe

