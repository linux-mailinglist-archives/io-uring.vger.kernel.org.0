Return-Path: <io-uring+bounces-2858-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C243D959063
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:19:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E762284847
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:19:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB64B18C01C;
	Tue, 20 Aug 2024 22:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Zn1pG4c6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8787814D444
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724192380; cv=none; b=i/IAnmDszdM68gqaoPzhZpFbA0SCG8DEbEDLfua77Nt3s9lbI9Zl8/q1kTMLzwGvWo/wZt4ghwndzopY75IYsHCmfOUMMMBllsF928J4KFWBAdXlTsZxXqpkyD7o5aAu+sxkq55ZvBqcvh5iMRkFrxhx/Ql+yJ6itdU2l3XiNqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724192380; c=relaxed/simple;
	bh=IgUE14Iui2IBY5fvwUcdKLW2UTDFp5BiyAmmJ70ukK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=laOTg/uepEhQah5S6aQ47x1Nj1KxZSEa4LLXpnVauGEhRaE6AxzN8wmLOotRBw73jfDOFhPWOVu9CY88To3iBhxve9SZIyH50sQ53gX8hslndvjxkLiIdAhhiXY3/80F83ismdeaYc2QK/nFSkmKt9ydCEkTs5R0u8dsCwQsu0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Zn1pG4c6; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-7c691c8f8dcso4033900a12.1
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:19:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724192377; x=1724797177; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JmY7zOv9iDQf86ZkJ0w3RBxIVOM+BRXCMM/BvTC1yVM=;
        b=Zn1pG4c6CVTH/PMSxa2H4B8CR2eSv5FV4axziKmfZW4aMiTAA5G86T0/3Y+7RnTwrD
         8q+ZsxicrP/vK4VLFvtlK9gtUCMUIwAJ7NiBwB1qz6wCcE8Hh1bSEllD1N7l06Ef6W/a
         iBHdJ21UkS2N02wXLRNSdOTLt/nr7h2gxTi7me2jB29l37kXiw+o55waP1x8Fp4K4E7z
         jLURp1gnfxsNKZYLfDwmiavqD6/NSWSJaCmZqR+YQg1Uy2IUe8Bw5idj3E+H1lHkgHmy
         NgL6KK7Si/XJ/VCQffGIAY1T2g4oh93qjt/HqXCNwmi59N3j8PbDY+nqyV1m+E0yXK5G
         26CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724192377; x=1724797177;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JmY7zOv9iDQf86ZkJ0w3RBxIVOM+BRXCMM/BvTC1yVM=;
        b=uFqpaQy+Y6C5rFkJKonkN9ONgsxb39NVZSmDTR1SbEQwglsgGCWQxUfkY0WBS+hKdr
         5qe3CjA0XQlVFkEa7CzpqMYSKmYsR/swuzPkt6dHNYmDkg4HrAl7q8paE8D5CZiw6vS3
         kx49en9w9HdztWveJ01X3gVXPkngUK13ZrC2tsUNcChlKhROByIDtnTxOYTgAl3AHKd7
         6zHCp8U82pnWpC6W5bahcjK1fCPN3US23yOnOlaYkE4x2+2aAz8e7TfPKjvvdPWDjn3/
         jaTExS5yVFIJln0ixMvglVHl/yRKcEkBbPaAFe8IAHhTl3CtdB4jhZx018CunXrqtN3o
         ouDQ==
X-Forwarded-Encrypted: i=1; AJvYcCX79xU0fuZiZ80F/fFEIL1gs8B1ffzHlUTGOUm03ZoezkSLbkVXTaShTC68u/in9q9uQcqsW2UgHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwkOrwOsmq13Yha0Nc3Rpw1g4oUmJaS08Ej1CqE4AKATJ2prMzj
	rpI1y9lLblpXaOXJLzxL0WB1H+9Zcb3Mklzu/Qa30urcox0pKVYU24ZaG45F8Xg=
X-Google-Smtp-Source: AGHT+IGXREiHQPTeV0KUI9sNNeB5VeROC7PEZHaRgd11un7ZQcxUMPgQEG5DxKP86kRhTNsG1Du/hg==
X-Received: by 2002:a17:90a:70f:b0:2c4:e333:35e5 with SMTP id 98e67ed59e1d1-2d5ea4c4893mr373422a91.36.1724192376787;
        Tue, 20 Aug 2024 15:19:36 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d5ebb9a002sm117201a91.51.2024.08.20.15.19.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:19:35 -0700 (PDT)
Message-ID: <53474dc7-f4ee-4f21-a556-789c23df526e@kernel.dk>
Date: Tue, 20 Aug 2024 16:19:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
To: David Wei <dw@davidwei.uk>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
References: <20240819233042.230956-1-axboe@kernel.dk>
 <20240819233042.230956-4-axboe@kernel.dk>
 <58a42e82-3742-4439-998e-c9389c5849bc@davidwei.uk>
 <cb79d5dd-3ff2-4cc3-ae0e-24c03d2729b3@kernel.dk>
 <d1116971-a2f7-430d-97d8-03440befd38a@davidwei.uk>
 <a3285bfe-ddcb-4521-940c-2e59f774ec70@kernel.dk>
 <48359591-314d-42b0-8332-58f9f6041330@davidwei.uk>
 <4b0ed07b-1cb0-4564-9d13-44a7e6680190@gmail.com>
 <344d1781-0004-4623-9eb4-2c2f479267f4@davidwei.uk>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <344d1781-0004-4623-9eb4-2c2f479267f4@davidwei.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 4:14 PM, David Wei wrote:
> On 2024-08-20 15:13, Pavel Begunkov wrote:
>>>>>> On 8/20/24 2:08 PM, David Wei wrote:
>>>>> To rephase the question, why is the original code calling
>>>>> schedule_hrtimeout_range_clock() not needing to differentiate behaviour
>>>>> between defer taskrun and not?
>>>>
>>>> Because that part is the same, the task schedules out and goes to sleep.
>>>> That has always been the same regardless of how the ring is setup. Only
>>>> difference is that DEFER_TASKRUN doesn't add itself to ctx->wait, and
>>>> hence cannot be woken by a wake_up(ctx->wait). We have to wake the task
>>>> manually.
>>>>
>>>
>>> io_cqring_timer_wakeup() is the timer expired callback which calls
>>> wake_up_process() or io_cqring_wake() depending on DEFER_TASKRUN.
>>>
>>> The original code calling schedule_hrtimeout_range_clock() uses
>>> hrtimer_sleeper instead, which has a default timer expired callback set
>>> to hrtimer_wakeup().
>>>
>>> hrtimer_wakeup() only calls wake_up_process().
>>>
>>> My question is: why this asymmetry? Why does the new custom callback
>>> require io_cqring_wake()?
>>
>> That's what I'm saying, it doesn't need and doesn't really want it.
>> From the correctness point of view, it's ok since we wake up a
>> (unnecessarily) larger set of tasks.
>>
> 
> Yeah your explanation that came in while I was writing the email
> answered it, thanks Pavel.

Hah and now I see what you meant - yeah we can just remove the
distinction. I didn't see anything in testing, but I also didn't have
multiple tasks waiting on a ring, nor would you. So it doesn't really
matter, but I'll clean it up so there's no confusion.

-- 
Jens Axboe


