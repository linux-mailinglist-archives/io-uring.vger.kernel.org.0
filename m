Return-Path: <io-uring+bounces-2861-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B8139590B3
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 00:52:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9D211F21754
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 22:52:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58C4F1C7B6B;
	Tue, 20 Aug 2024 22:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="K/x+V5SB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAD00165EE1
	for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 22:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724194324; cv=none; b=hRo6vUdkFALOqmeoJLySwYZ9xjaf7vWTlWDL79O3+1U4QBvTrbqbLHVhH0VMWYedGKVnuStnCzMB3k/Bbex3+bm/+N8tnIuXdkQ5bsPgnzYuFCS77+mbcPwLsrNJ8LzEAfTLRvMCH95h7gG9LGJSiM+d4jMeUlPkPrhD6iujdbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724194324; c=relaxed/simple;
	bh=qjn3zzoC1aHUQBtMqtGnN/6aknmctnAZbAdoKeDBlFc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=HxNFfASxaRteVmj0HMzFm8faUhVWWqbdnOvixml+zZ9+oN0h+Xi0GjBGCGlFCbQKNleHu4WGl8I6cH2xad346J7a/bflwmwe5Sq+/32pOUOVHvyAtKL++mwAx0pmJCa1RsPED68C2dOngFRgm1MxWeIxsi0dVMhaCG0NegNhrsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=K/x+V5SB; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-201f7fb09f6so43622945ad.2
        for <io-uring@vger.kernel.org>; Tue, 20 Aug 2024 15:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724194320; x=1724799120; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KUfgNZWJe4doc8gBuXS6/WoSPSlJuLVYsHszXOnFxEg=;
        b=K/x+V5SBXgUXwmqRlG4TcVA0QWAfvZlWJVMNEqtH2jqGLColxAeVrUS7wIQ1PEcJ9N
         ZbdLR3QzEzh7/UzCJjy2WeNf404oqZK5ksvr5l14GkB5RyxHiuehgsNqwk43MQvppkon
         pZQq0+OBBz/xbTFTjssoZTAsk0ugyYRSAKz/dHTj6COB9XL01BIEMBDX89ENbdp0iOal
         O/Qo1jeDwb54hVa0iFbydYFmCTb7RwYp9p2dw2wzbPmyorC8JcSShZtOx1w/rR7g3dPJ
         b0rGtEDb8XMO61Ur0E99xF7O9h8993renw66efpzK03RdTFUXXwFAdOKVb3VcM3XvHVa
         Up4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724194320; x=1724799120;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KUfgNZWJe4doc8gBuXS6/WoSPSlJuLVYsHszXOnFxEg=;
        b=wC8uuGTmNMS+nHhjsV1kf8JMLdrV9ZIyT4ou8MtMEHq0csTnaZCsR4ORbIU+iq7hzj
         b24q1Wvv3D+p1XXzViGOuA2u1SGZBeCaVH/QoHID2q9vWYR00YdIDhK1YEcWAFWj5kGM
         TgYywgBxjs64W1vgWZZ9SU+AirQ020ufpLZMPHdUfL8rwu8Hofxt8x/rDJvm/QZKhy82
         i0k1+W9j68BKK7mlxf7HM7HEu09n8tTx2hrchPdAksnPALwt/L+kxLN9IXiZl9j76PdP
         otXd2gnoOnhmmmMkXotm0sOXai3so5iGA5nUdQuHIDt4XMRD+3MtbWwWps2GcenZvb1v
         nnbw==
X-Forwarded-Encrypted: i=1; AJvYcCW/VsgQ8o/PK26TLrN2anIGm+hj8ws8Z3LwqpkqkOvLrul0S9a7RGlDLOaEZ13l05IHMQHhEzHCDg==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo1/nNaOCCz6YLL9GJF6m+lDAuA+KFhHULPyUyOGuwFBjf5wry
	e0qQJCpVyFk8UDaeCuamocR40/brHArSo38yOAk8HSJm4nEeFiy1eIHnHHF4m5o=
X-Google-Smtp-Source: AGHT+IFMbhtzIdAV0j5HvT/zkG3HpKAhVsgn890YdVT6whzfQHT/gIn31xQykN1PTHZElsMCc0KYhg==
X-Received: by 2002:a17:902:ce91:b0:1fd:ae10:722b with SMTP id d9443c01a7336-203681b9e79mr5738365ad.63.1724194319909;
        Tue, 20 Aug 2024 15:51:59 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f0375654sm82492945ad.141.2024.08.20.15.51.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Aug 2024 15:51:59 -0700 (PDT)
Message-ID: <f3561ab8-281e-42e1-b146-197b731c90c1@kernel.dk>
Date: Tue, 20 Aug 2024 16:51:58 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] io_uring: implement our own schedule timeout handling
From: Jens Axboe <axboe@kernel.dk>
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
 <53474dc7-f4ee-4f21-a556-789c23df526e@kernel.dk>
Content-Language: en-US
In-Reply-To: <53474dc7-f4ee-4f21-a556-789c23df526e@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 4:19 PM, Jens Axboe wrote:
> On 8/20/24 4:14 PM, David Wei wrote:
>> On 2024-08-20 15:13, Pavel Begunkov wrote:
>>>>>>> On 8/20/24 2:08 PM, David Wei wrote:
>>>>>> To rephase the question, why is the original code calling
>>>>>> schedule_hrtimeout_range_clock() not needing to differentiate behaviour
>>>>>> between defer taskrun and not?
>>>>>
>>>>> Because that part is the same, the task schedules out and goes to sleep.
>>>>> That has always been the same regardless of how the ring is setup. Only
>>>>> difference is that DEFER_TASKRUN doesn't add itself to ctx->wait, and
>>>>> hence cannot be woken by a wake_up(ctx->wait). We have to wake the task
>>>>> manually.
>>>>>
>>>>
>>>> io_cqring_timer_wakeup() is the timer expired callback which calls
>>>> wake_up_process() or io_cqring_wake() depending on DEFER_TASKRUN.
>>>>
>>>> The original code calling schedule_hrtimeout_range_clock() uses
>>>> hrtimer_sleeper instead, which has a default timer expired callback set
>>>> to hrtimer_wakeup().
>>>>
>>>> hrtimer_wakeup() only calls wake_up_process().
>>>>
>>>> My question is: why this asymmetry? Why does the new custom callback
>>>> require io_cqring_wake()?
>>>
>>> That's what I'm saying, it doesn't need and doesn't really want it.
>>> From the correctness point of view, it's ok since we wake up a
>>> (unnecessarily) larger set of tasks.
>>>
>>
>> Yeah your explanation that came in while I was writing the email
>> answered it, thanks Pavel.
> 
> Hah and now I see what you meant - yeah we can just remove the
> distinction. I didn't see anything in testing, but I also didn't have
> multiple tasks waiting on a ring, nor would you. So it doesn't really
> matter, but I'll clean it up so there's no confusion.

Actually probably better to just leave it as-is, as we'd otherwise need
to store a task in io_wait_queue. Which we of course could, and would
remove a branch in there...

-- 
Jens Axboe


