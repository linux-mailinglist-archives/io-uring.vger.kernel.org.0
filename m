Return-Path: <io-uring+bounces-4937-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0209E9D510A
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 17:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CCD41F2698A
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 16:57:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9076C14A4FB;
	Thu, 21 Nov 2024 16:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2dGVahQ2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB5F1A3BDE
	for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732208244; cv=none; b=mguIyzLKsyl/FmxHZz9in50qfFozseCozOweXySyeaoQ4qehYp9vFYXX60sjrrjyKjuHFUrztSUsTIBuyMtM5FjJ4JLuthhXN0aLsg0dI4oGhyG+io6EspT8gamalFNf1LNA4mMkTJV2ntk6bsFweYYsH0+l4akXuCexpYygtLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732208244; c=relaxed/simple;
	bh=po7QQ1Vqyx+dgY19xAxsBtP5Lzer1DDNcpG73ee0d+A=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=FVsYo+BJOhipnJIRQjhVoPZWDbCuHH/DnOofZpxp66zGXMUwkU4Fyu5FgRFddjF64EqiH+83rfc4bygsa96ajaBiQHe/VrCClMT2NGttCqLQePTtBGi7/vR3aFt+ZTjHYanmY2E55pV1S5Zj7+nMbQIk7ZT2J/QQZf33LvpBMRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2dGVahQ2; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5ebc9bda8c8so631112eaf.0
        for <io-uring@vger.kernel.org>; Thu, 21 Nov 2024 08:57:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732208241; x=1732813041; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YmKkDfSDqaJied9irZUQ9f1BsoRunpOmT+0wie8Oe+Y=;
        b=2dGVahQ2JuifIXCHIq5dYmLuGtUvjQMtaEdBkHO39f30dpRpUZPxEshS/ticAevSuO
         a6YTN7IPe4+W5Goq+ryiFBVLeW/xAsMVU3wii+xA0dTxfPvH+3OO60kFzOKNGW3zn5zq
         K7w66sJIo40Lu/KzZw6nTWKT7z5pbJyhE8HB1k4onUYK8c16lgsBRKpiIk4o7zuJbHge
         ce632cktZy00vCk4AF0bBRcKOUhpL7ol7GxPk7LFIfzPw1/Llk9cVAVWiIrhNLDMMM1m
         iTuTirDg4t810QT45qa+JO/55nYT1jrKPC/C1PghnmJK7zoa5AenplVQXd6Jpk9Og51B
         o29A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732208241; x=1732813041;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YmKkDfSDqaJied9irZUQ9f1BsoRunpOmT+0wie8Oe+Y=;
        b=eyI3Yf15VOESqTchOSDsE2SdImr69IvSdeOq5pU7gex3v7BNpXy4C7FapUFFcKvwmr
         ruWkUWwVjDjD1SyPg8iKy8tUUEwOlpBWtpx9mOgPTuAL3NRW+MEvFryqF06vq6LMsqEX
         /NYhuIMpwW0BsmozV4X4mpDu297z9iGioDDdTZLMAvtkWz0dfz5XwIbkke9OeKmK4KHU
         Tue7VyLnX3mL36XieCCCvxbVD6bHTQFW2Zw5rN84oUjQqK2ZG5MMhgR/jLzhejjNM60O
         iCuOqVSLLNpClTf1bh9vxwEgoB3rNdY0Mr1HKJuSvV9TDeeCf4/AwSER+0emZ4jPuBbw
         BkEg==
X-Forwarded-Encrypted: i=1; AJvYcCViHpj6ETFA1rfymG2mbKmTYif6DMeH/b3mWw9jIONS5qoJ9F77sX0ga/TMKfRd5bwxaD5PUdEsEw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyPZ5fjyXAy8AX4fRFCztWneasZ2/PamfGLWz50klAh/tE8w9mk
	pcl5Twtt3Yq1QJTB2pykKov0gICs83HdBwN08DDCX9nu7tNvY0f9OjVpQTsGEAA=
X-Gm-Gg: ASbGnctrwx/ESc//jb9tVOSWnReopu6fAfUQF8pWcHlaMMk0gaHmYEXqx1RT2l4Ij8Y
	wpKpFhoK/pbDhQr7CvslQvXX1BctDWiuU+/8b+jpizpZSVY/BjtLAAmVCSO0iwtsKUSZI4ikySV
	+rP7i25BkgmO1fQC6gOcyuguE0BbykavGGZvWXky0eM20nlcTCddmKQlLODG7Xv7GXMQQgjQEiD
	3bA3gPskBX0XUNHaRVvljDxuw7euDlTHy0vbEZ9HxGEeg==
X-Google-Smtp-Source: AGHT+IHPjkR5t+Jnb13tVLMnJUBIJCSSxemnmfmX4b7BLbidrCn0aGHMi/Vdx/D5LUCpozWc4zWEWA==
X-Received: by 2002:a05:6820:228e:b0:5ee:af1a:2ec5 with SMTP id 006d021491bc7-5eee8315990mr6003120eaf.5.1732208241119;
        Thu, 21 Nov 2024 08:57:21 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f069764b9bsm5041eaf.12.2024.11.21.08.57.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 08:57:20 -0800 (PST)
Message-ID: <80eeba88-2738-405e-b539-516d67f0dcd2@kernel.dk>
Date: Thu, 21 Nov 2024 09:57:19 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next v1 2/2] io_uring: limit local tw done
To: Pavel Begunkov <asml.silence@gmail.com>, David Wei <dw@davidwei.uk>,
 io-uring@vger.kernel.org
References: <20241120221452.3762588-1-dw@davidwei.uk>
 <20241120221452.3762588-3-dw@davidwei.uk>
 <f32b768f-e4a4-4b8c-a4f8-0cdf0a506713@gmail.com>
 <95470d11-c791-4b00-be95-45c2573c6b86@kernel.dk>
 <614ce5a4-d289-4c3a-be5b-236769566557@gmail.com>
 <b7170b8e-9346-465b-be60-402c8f125e54@kernel.dk>
 <66fa0bfd-13aa-4608-a390-17ea5f333940@gmail.com>
 <9859667c-0fbf-4aa5-9779-dae91a9c128b@kernel.dk>
 <3e6a574c-27ae-47f4-a3e3-2be2c385f89b@kernel.dk>
 <357a3a72-5918-44e1-b84f-54ae093cf419@gmail.com>
 <375a1b30-5e68-439d-be55-444eaa19d7ef@kernel.dk>
 <c2f80710-7253-4dfb-a275-6698f65ab25c@gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c2f80710-7253-4dfb-a275-6698f65ab25c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/21/24 9:43 AM, Pavel Begunkov wrote:
> On 11/21/24 16:20, Jens Axboe wrote:
>> On 11/21/24 9:18 AM, Pavel Begunkov wrote:
>>> On 11/21/24 15:22, Jens Axboe wrote:
>>>> On 11/21/24 8:15 AM, Jens Axboe wrote:
>>>>> I'd rather entertain NOT using llists for this in the first place, as it
>>>>> gets rid of the reversing which is the main cost here. That won't change
>>>>> the need for a retry list necessarily, as I think we'd be better off
>>>>> with a lockless retry list still. But at least it'd get rid of the
>>>>> reversing. Let me see if I can dig out that patch... Totally orthogonal
>>>>> to this topic, obviously.
>>>>
>>>> It's here:
>>>>
>>>> https://lore.kernel.org/io-uring/20240326184615.458820-3-axboe@kernel.dk/
>>>>
>>>> I did improve it further but never posted it again, fwiw.
>>>
>>> io_req_local_work_add() needs a smp_mb() after unlock, see comments,
>>> release/unlock doesn't do it.
>>
>> Yep, current version I have adds a smp_mb__after_unlock_lock() for that.
> 
> I don't think it'd be correct. unlock_lock AFAIK is specifically
> for unlock + lock, you have lock + unlock. And data you want to
> synchronise is modified after the lock part. That'd need upgrading
> the release semantics implied by the unlock to a full barrier.
> 
> I doubt there is a good way to optimise it. I doubt it'd give you
> anything even if you replace store_release in spin_unlock with xchg()
> and ignore the return, but you can probably ask Paul.

True, will just make it an smp_mb(), should be fine.

>> Will do some quick testing, but then also try the double cmpxchg on top
>> of that if supported.

This is a bit trickier, as we're not just updating the list first/last
entries... Not sure I see a good way to do this. Maybe I'm missing
something.

I did run a basic IRQ storage test as-is, and will compare that with the
llist stuff we have now. Just in terms of overhead. It's not quite a
networking test, but you do get the IRQ side and some burstiness in
terms of completions that way too, at high rates. So should be roughly
comparable.

-- 
Jens Axboe

