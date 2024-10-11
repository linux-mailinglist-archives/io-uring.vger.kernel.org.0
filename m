Return-Path: <io-uring+bounces-3604-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B22E799AB1B
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 20:40:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5DB351F240C3
	for <lists+io-uring@lfdr.de>; Fri, 11 Oct 2024 18:40:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 436921C244B;
	Fri, 11 Oct 2024 18:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="x4DQO3Pz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE14A183CA5
	for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 18:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728671999; cv=none; b=Ba4GALuJpu3Tu8ObScvU+iMOMvZgOe6sRMIZiujn4mfe+Kl5KiwCCnr9s9wP+5WSjnz7b52j5HG6TmXt4zCO1DDT8S4rRbQORc8DBqJkjYQEXDoJ/RtgVVCUP+Kb197y1iCVuPrwUMNphNx7NrsWocdu+hX5Xmy0m9AEShMmiGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728671999; c=relaxed/simple;
	bh=i6aZOZlTYDoX08dXgpLG9/nvUSFL7gYkpA04ElZhh7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oxmZJb8u8ZwLr5suTPkws5YabEjZ/3cTC68QprTO0Ulbq+q5+vCL4YpQXPA8ygYIBa/qyemldmFuOKjIImuqFvDWiC321Otfmuf9RFSRB5/47pWd4JrH8vqdWyosrrj3kOIHjcvpX6kw91t5mCHmeHPZQNO9/xLMzLwTNPz+pDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=x4DQO3Pz; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a3b1aa0e80so8473405ab.1
        for <io-uring@vger.kernel.org>; Fri, 11 Oct 2024 11:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1728671995; x=1729276795; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iy1eLNek8lkP7BOoGAITRdzPSDFhIoUMOq1rP4nQUt0=;
        b=x4DQO3Pz6yKSalvyP0WMTOtYVPnAW9cAZGBfS5SosJYnH/JFsmIPKwC4hbpJkmXXp7
         KWXus4IkloKMJc2xpnojaBUT05jUa58FCyei6iLV364x2O3vcvOx1GmWcUgfuRHaXszH
         heL3UxXSS4RhfEhAeURFtI99Zg/WtkSBdJPj8vygFmEEOv7n9OHDqpHQxbbQqych+ktZ
         SSM3/tWXY/d7dCChf4aHJVwvnHxB5C0xo6xO9FEn/grgZ+NGHYj/YwxetIlVNSAQxUCZ
         WBbxbKW4otSjK6sEZ8KDjLI7RKAnEwkf8wNEiy+6WqPtUXx8JV5fSMpoIM9EDhVTHIPZ
         qRRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728671995; x=1729276795;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iy1eLNek8lkP7BOoGAITRdzPSDFhIoUMOq1rP4nQUt0=;
        b=N8sexb8OTVovdhI1i3noWNrWaDAy8HikrObqVM/IEjc/p3z13X6al5sKwSO62xrnw+
         p6EB3Gu6q+17woOsoeVDw75hslXuZyhZ23k2tEZDM+jZZg9E4Wt4ZA9ze06jVUYQQDCH
         L3wqn2W43wRW8WQqIeb6RM9a9lbm8Thrr3F6lxuqsk+aTGjcMAeCO9VgFv9y0Y3wLRx4
         5LgzQ3RAEvHOMB0ZejWu0YZWwBjvyPZ4ND3d0IlPIaVCh6ARNKO26bD79/l4h2xXqPTK
         iYFnEpT6KF6bQ/Pdua0nVjgBc+i+/UaEx37MgEHh/y466LkWeCkE2wqgIvS3TzVKSphI
         AkzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKt61aBBZRX3SEKsj7VYX6Cz2JPebSG9DqZU6ju2AZdBB5DYAF8K4uWlpdpJf7C1lY1cgLYFA/3A==@vger.kernel.org
X-Gm-Message-State: AOJu0YyX0QSLSm6ehGjBAp6bxeYra9jFuQXPw/5TkIRbyiA/9xS9lODa
	DNwpOf3edz9ZXGiDisdKhki/D0we1Oyc8zbJJMer07ZBQ7cfggpAV4fvZRsl+4c=
X-Google-Smtp-Source: AGHT+IEFRBZtM5+A4VFfCvuGNaNh6BxfatcHG3oMtJ6w3Z1Wafg5DUJehsAHcwsJx2WeO7ZBDe8S8Q==
X-Received: by 2002:a05:6e02:1809:b0:3a0:8d60:8ba4 with SMTP id e9e14a558f8ab-3a3b603df81mr28830175ab.16.1728671994905;
        Fri, 11 Oct 2024 11:39:54 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dbad9d51basm732738173.61.2024.10.11.11.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Oct 2024 11:39:54 -0700 (PDT)
Message-ID: <3766a6e2-c9da-4643-8333-4f152d955609@kernel.dk>
Date: Fri, 11 Oct 2024 12:39:53 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Large CQE for fuse headers
To: Bernd Schubert <bernd.schubert@fastmail.fm>, io-uring@vger.kernel.org
Cc: Pavel Begunkov <asml.silence@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Joanne Koong <joannelkoong@gmail.com>,
 Josef Bacik <josef@toxicpanda.com>
References: <d66377d6-9353-4a86-92cf-ccf2ea6c6a9d@fastmail.fm>
 <f83d5370-f026-4654-810a-199fb3e01038@kernel.dk>
 <aa99c09f-fa6f-4662-9da4-62a7d848d8b9@fastmail.fm>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <aa99c09f-fa6f-4662-9da4-62a7d848d8b9@fastmail.fm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/11/24 12:35 PM, Bernd Schubert wrote:
> On 10/11/24 19:57, Jens Axboe wrote:
>> On 10/10/24 2:56 PM, Bernd Schubert wrote:
>>> Hello,
>>>
>>> as discussed during LPC, we would like to have large CQE sizes, at least
>>> 256B. Ideally 256B for fuse, but CQE512 might be a bit too much...
>>>
>>> Pavel said that this should be ok, but it would be better to have the CQE
>>> size as function argument. 
>>> Could you give me some hints how this should look like and especially how
>>> we are going to communicate the CQE size to the kernel? I guess just adding
>>> IORING_SETUP_CQE256 / IORING_SETUP_CQE512 would be much easier.
>>
>> Not Pavel and unfortunately I could not be at that LPC discussion, but
>> yeah I don't see why not just adding the necessary SETUP arg for this
>> would not be the way to go. As long as they are power-of-2, then all
>> it'll impact on both the kernel and liburing side is what size shift to
>> use when iterating CQEs.
> 
> Thanks, Pavel also wanted power-of-2, although 512 is a bit much for fuse. 
> Well, maybe 256 will be sufficient. Going to look into adding that parameter
> during the next days.

We really have to keep it pow-of-2 just to avoid convoluting the logic
(and overhead) of iterating the CQ ring and CQEs. You can search for
IORING_SETUP_CQE32 in the kernel to see how it's just a shift, and ditto
on the liburing side.

Curious, what's all the space needed for?

>> Since this obviously means larger CQ rings, one nice side effect is that
>> since 6.10 we don't need contig pages to map any of the rings. So should
>> work just fine regardless of memory fragmentation, where previously that
>> would've been a concern.
>>
> 
> Out of interest, what is the change? Up to fuse-io-uring rfc2 I was
> vmalloced buffers for fuse that got mmaped - was working fine. Miklos just
> wants to avoid that kernel allocates large chunks of memory on behalf of
> users.

It was the change that got rid of remap_pfn_range() for mapping, and
switched to vm_insert_page(s) instead. Memory overhead should generally
not be too bad, it's all about sizing the rings appropriately. The much
bigger concern is needing contig memory, as that can become scarce after
longer uptimes, even with plenty of memory free. This is particularly
important if you need 512b CQEs, obviously.

-- 
Jens Axboe

