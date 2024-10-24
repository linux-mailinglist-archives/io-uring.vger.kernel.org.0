Return-Path: <io-uring+bounces-4008-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A48D9AF32A
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 21:59:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DC6411F2182F
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:59:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EC9D1AB6CC;
	Thu, 24 Oct 2024 19:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="UxUoZmpP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE0817333D
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 19:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729799978; cv=none; b=jxhLoC/WCs3dRM4me9S9V9EDCVKHd12haYPHmzgNs2URmqlFl7pUHYy/JfajzkOhMECgQxrUOBaeKe0PrppOyaF/niikAmaFynjumqSYAJ30uOEuzanmRSUwtNcPSaey+UXKR4xTm4KVntmtoiq5d/5ZwALmm8WyY1ia1WsvnV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729799978; c=relaxed/simple;
	bh=uRQyGavTq51O4q1N/Nc4y8ulVvCMnPegKNYRjTd52Ck=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bElYtwm6NMpDALwrly9oJ86e5l7qlrTZQeGamjXMpjG2+1t2/Gje1lw4Y6LqtMAG1BJo5r5iNUGkScnN2Bm0BgbBnIyUL2CW3XRZAXIIgrn8Vy7IZGwghz1vFdsANj3tV1vp40y5wylVldDurk1DtNGPjLWFgKVs8H/mJxOfTTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=UxUoZmpP; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a3b7d95a11so4936135ab.2
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 12:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729799975; x=1730404775; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WqNQxPV8HusSw3eO39xbm77NcBgiOg0V0d5zUy9p86E=;
        b=UxUoZmpP3tyaghOcsCr8PXRuMjVuBoo6nhIDFRXVHYBUKaqZkhBJ/sR+n5keS4CW/Q
         UbOTAmgijFeADZervxbkPix3IM1py9pAQBEg1BLRhJym/ySKrFE/3G7g7XljDfKGSMNx
         L+8iGfezWwim6sH2lBJXmQuzKLcMcXRhiDVabqavh/q6aEX9VtbyEOSHL7/Jb9V51nfb
         55aUbaPfLGAFzbiagcsg/XQnU4iXXizZxZALcpgRwLsw+wNvtEKIsuVWZUZMwAeAC6rE
         aWe9DHemiTjzJfTAxL8z1XNsTus3EgMnWZbGNF844zwqetd3/lqn80FMG93UVESGkoix
         dZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729799975; x=1730404775;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WqNQxPV8HusSw3eO39xbm77NcBgiOg0V0d5zUy9p86E=;
        b=ea4bDd3ToPSRY9WeXX794gdCtwv0f9oCxSv5UiiV58lD6sEr4N7JjTdiV8pNFvBSur
         jJgcmLcutKJ6go6Opfhrfoz5DHgirKb7UdSbvMNj9e3AxlzUGa/zguB1m/5Zd1HRQhBp
         rp4MQDX1cFPTCp7TOZ14SkdmyZVyuPx87lnzc9RIS0H/l9y2whgEznlI30t8Qf43PCgk
         6oZ0D3YnKJM7iAvdQ8kePwv8EcPwEXh3OeDfH9grilYEiiVZP84Ga9besSv5Hn+CYpZh
         SFEr01SFLQhUrQ+mGYdTVYL1D53qg0Lx2MegNE1rMhqAuHdq8kE6bXv8c+hpspWi66Ko
         dIjw==
X-Gm-Message-State: AOJu0YxRPc8rOkSAnmkTWXXyrmRNpJhWCfBbho+Q6pgdaqkZ3SZbWPuQ
	4+ofPSg95RHkhINyqtNFBW2e6XOUKvUUmHwYbYD8JC3SUZdNa+DuY9GkbSpiN7lMtVK17ccDNHe
	W
X-Google-Smtp-Source: AGHT+IFrSMeoSv0cCUR8FtFr7R4hsc8/U7DYnNFRBer9JGeUujDLsElma3eYRO/4yPIF6VRsVw9wdg==
X-Received: by 2002:a05:6e02:1fec:b0:3a0:b471:9651 with SMTP id e9e14a558f8ab-3a4de826f4dmr39977705ab.24.1729799974791;
        Thu, 24 Oct 2024 12:59:34 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400aaf56fsm32220945ab.33.2024.10.24.12.59.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Oct 2024 12:59:34 -0700 (PDT)
Message-ID: <1384e3fe-d6e9-4d43-b992-9c389422feaa@kernel.dk>
Date: Thu, 24 Oct 2024 13:59:33 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
To: Jann Horn <jannh@google.com>
Cc: io-uring@vger.kernel.org
References: <20241024170829.1266002-1-axboe@kernel.dk>
 <20241024170829.1266002-5-axboe@kernel.dk>
 <CAG48ez3kqabFd3F6r8H7eRnwKg7GZj_bRu5CoNAjKgWr9k=GZw@mail.gmail.com>
 <aaa3a0f3-a4f8-4e99-8143-1f81a5e39604@kernel.dk>
 <CAG48ez3KJwLr8REE8hPebWtkAF6ybEGQtRnEXYYKKJKbbDYbSg@mail.gmail.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAG48ez3KJwLr8REE8hPebWtkAF6ybEGQtRnEXYYKKJKbbDYbSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/24/24 1:53 PM, Jann Horn wrote:
> On Thu, Oct 24, 2024 at 9:50?PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 10/24/24 12:13 PM, Jann Horn wrote:
>>> On Thu, Oct 24, 2024 at 7:08?PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> Add IORING_REGISTER_RESIZE_RINGS, which allows an application to resize
>>>> the existing rings. It takes a struct io_uring_params argument, the same
>>>> one which is used to setup the ring initially, and resizes rings
>>>> according to the sizes given.
>>> [...]
>>>> +        * We'll do the swap. Clear out existing mappings to prevent mmap
>>>> +        * from seeing them, as we'll unmap them. Any attempt to mmap existing
>>>> +        * rings beyond this point will fail. Not that it could proceed at this
>>>> +        * point anyway, as we'll hold the mmap_sem until we've done the swap.
>>>> +        * Likewise, hold the completion * lock over the duration of the actual
>>>> +        * swap.
>>>> +        */
>>>> +       mmap_write_lock(current->mm);
>>>
>>> Why does the mmap lock for current->mm suffice here? I see nothing in
>>> io_uring_mmap() that limits mmap() to tasks with the same mm_struct.
>>
>> Ehm does ->mmap() not hold ->mmap_sem already? I was under that
>> understanding. Obviously if it doesn't, then yeah this won't be enough.
>> Checked, and it does.
>>
>> Ah I see what you mean now, task with different mm. But how would that
>> come about? The io_uring fd is CLOEXEC, and it can't get passed.
> 
> Yeah, that's what I meant, tasks with different mm. I think there are
> a few ways to get the io_uring fd into a different task, the ones I
> can immediately think of:
> 
>  - O_CLOEXEC only applies on execve(), fork() should still inherit the fd
>  - O_CLOEXEC can be cleared via fcntl()
>  - you can use clone() to create two tasks that share FD tables
> without sharing an mm

OK good catch, yes then it won't be enough. Might just make sense to
exclude mmap separately, then. Thanks, I'll work on that for v4!
Probably trivial enough with just a separate mutex that's held over
mmap, and that register grabs too. Basically replacing mmap_write_lock()
on the resize side with ctx->mmap_lock, and grabbing that over
validate/mmap on the io_uring mmap side. Need to ponder the implications
of that in terms of how the locks nest, as you'd have mmap_sem ->
ctx->mmap_lock, but the other way around for resizing. But that should
just be for the pinning parts, which is why it does the mmap_sem
grabbing where it does right now.

-- 
Jens Axboe

