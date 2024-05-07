Return-Path: <io-uring+bounces-1812-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CB1B58BEABB
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 19:45:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 872B6286076
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 17:45:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE26016C849;
	Tue,  7 May 2024 17:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YWis6Nuk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174A5165FCF;
	Tue,  7 May 2024 17:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715103908; cv=none; b=cWPs+Wo/U8UVspkKJbOuNEymw92P27p0rsUKLPaxoXSqSajxLhIF6YaJY6cu79ErAP9uyu6cmmjZxnX0d7amxsZYmpEYNeF5OdNaLsuPxUjLQoWy91qKZmTlM+ikmIOeHxV2EGdcuiZj0lNPm8C9Ar+iL+gcc6G62Z9X4zUqd8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715103908; c=relaxed/simple;
	bh=Umv70e0c6nv8fGGaeErTB90Fn15g5pIK9CSartcaWHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=pEwHLdyhiXz/ksGGnJRGN/Ma0Ufo1bfG2GCaNKZpzDj80uE3DI+66agA39nnhC8kDAqDwol6e1vAN79FQOPsSOZCLpmsXUzaMQhZ+7wfaB3aI9W6D5J1fChCFQMpEHjVxZXdZB61Pb+vOmnhlLVCSpUjcOzseIVlr5BF52pPcDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YWis6Nuk; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-41b79451153so27918995e9.2;
        Tue, 07 May 2024 10:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715103905; x=1715708705; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z39aNp6ho/cansGz6z4As7qPLlCotOLLvlN9d9rLPQI=;
        b=YWis6NukXYhibzoqhRIV43bGUst5Jax//GdGntfRqalyjxvff+CtK0oXTRlsQSbZKp
         LsE43eZIIUkvCIu7Yh2UCeBTYa5ia2C+2hKWIkm60bkEBidO4GttRuwTj48WP0kuGBMi
         LxewzZGdrEhk5Y53fAC1vI14XWPMkKMaN0rGCEp8tMix/F+uXObBi0K1gIaEMF12qTtY
         zNvSS+nYjf66S3l0BRTCXXkmEPMizcriljHobEhf7WGC23K2CkSpCU344KzWXe4ipdlV
         VBsyRyYA6Z4bvErsZEAQp1xCTaUgJLd0GZBZyn1Vp4QZ7DB36HAfh0k2P5ZtyXIWZQ+Q
         RH9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715103905; x=1715708705;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z39aNp6ho/cansGz6z4As7qPLlCotOLLvlN9d9rLPQI=;
        b=FBbuWDqTOnLaRQWSmeZuX5flKFK8innoGy3ulUrC+IbtSBrQOnkj6ZgxjAV83hdqwN
         gM7nKgLYdkErOI9JIOjm+Y1l3vY5o5p7dTUX67n74Lhq+MusEUDcDUIVGh1m+GW1d8Lj
         FQd8Jd58oYc/jyW4BEpDA+EhKAlrzHBJxtaCfMgvlqK9ePNkhHDTpkObYXi5mjI1MwLh
         WxYFWHr9TsiurdU8jwimY3Xx8jiJfvxVuFN/NZrpZemPhN5YG6gKtiuPZjjihyrGXtoW
         64WTAWVQgck8wwno17SU2AbH22IS9zOC+KYrJhAG1gr6ncnTou2PGiZrMZC9ZRtGd6h6
         YqXg==
X-Forwarded-Encrypted: i=1; AJvYcCXClNEhaL/8uwpvhUt5O0lyRdbJWI6tEyI9U7dctLxHNtKJOAQJY3RpCJwmVb96oE5BmYyYOHHTZpBhU/YslMh5dSae6eF4qM4gI8tGkpYPhnquIWcfYD2V5TsoaTPi82JOgLaod8Cynv8g0CHdLWFLdlA/lIsChqW5rw559Ex7FL5woFaXrHkl0CZK0TlmegCjc4Pd9F2CBgl5H/KfQ7Tky9M=
X-Gm-Message-State: AOJu0YwVnNnINz/Kshlm/ySz1r2posjyb3vu85jdcnGLcM58Q5e779tf
	E3iR7jGreHcLsVVcYX8Le3DU/P25QwAV4P3FHOMcSTZ9qaBiHZ25
X-Google-Smtp-Source: AGHT+IEeIO2faXt4HPtaKPSv53LPLgfetsgWUZ2rrUB+vNo+nARJS5K74POuW8sS151Q2FCZsZtlxw==
X-Received: by 2002:a05:600c:458d:b0:41c:503:9a01 with SMTP id 5b1f17b1804b1-41f71ecb256mr3191275e9.25.1715103905216;
        Tue, 07 May 2024 10:45:05 -0700 (PDT)
Received: from [10.254.108.81] (munvpn.amd.com. [165.204.72.6])
        by smtp.gmail.com with ESMTPSA id l8-20020a05600c4f0800b0041bfa349cadsm23910612wmq.16.2024.05.07.10.45.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 10:45:04 -0700 (PDT)
Message-ID: <d68417df-1493-421a-8558-879abe36d6fa@gmail.com>
Date: Tue, 7 May 2024 19:45:02 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better about
 file lifetimes
To: Linus Torvalds <torvalds@linux-foundation.org>,
 Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 keescook@chromium.org, axboe@kernel.dk, christian.koenig@amd.com,
 dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org, jack@suse.cz,
 laura@labbott.name, linaro-mm-sig@lists.linaro.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, minhquangbui99@gmail.com,
 sumit.semwal@linaro.org,
 syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
 <ZjoKX4nmrRdevyxm@phenom.ffwll.local>
 <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>
In-Reply-To: <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 07.05.24 um 18:46 schrieb Linus Torvalds:
> On Tue, 7 May 2024 at 04:03, Daniel Vetter <daniel@ffwll.ch> wrote:
>> It's really annoying that on some distros/builds we don't have that, and
>> for gpu driver stack reasons we _really_ need to know whether a fd is the
>> same as another, due to some messy uniqueness requirements on buffer
>> objects various drivers have.
> It's sad that such a simple thing would require two other horrid
> models (EPOLL or KCMP).
>
> There'[s a reason that KCMP is a config option - *some* of that is
> horrible code - but the "compare file descriptors for equality" is not
> that reason.
>
> Note that KCMP really is a broken mess. It's also a potential security
> hole, even for the simple things, because of how it ends up comparing
> kernel pointers (ie it doesn't just say "same file descriptor", it
> gives an ordering of them, so you can use KCMP to sort things in
> kernel space).
>
> And yes, it orders them after obfuscating the pointer, but it's still
> not something I would consider sane as a baseline interface. It was
> designed for checkpoint-restore, it's the wrong thing to use for some
> "are these file descriptors the same".
>
> The same argument goes for using EPOLL for that. Disgusting hack.
>
> Just what are the requirements for the GPU stack? Is one of the file
> descriptors "trusted", IOW, you know what kind it is?
>
> Because dammit, it's *so* easy to do. You could just add a core DRM
> ioctl for it. Literally just
>
>          struct fd f1 = fdget(fd1);
>          struct fd f2 = fdget(fd2);
>          int same;
>
>          same = f1.file && f1.file == f2.file;
>          fdput(fd1);
>          fdput(fd2);
>          return same;
>
> where the only question is if you also woudl want to deal with O_PATH
> fd's, in which case the "fdget()" would be "fdget_raw()".
>
> Honestly, adding some DRM ioctl for this sounds hacky, but it sounds
> less hacky than relying on EPOLL or KCMP.
>
> I'd be perfectly ok with adding a generic "FISAME" VFS level ioctl
> too, if this is possibly a more common thing. and not just DRM wants
> it.
>
> Would something like that work for you?

Well the generic approach yes, the DRM specific one maybe. IIRC we need 
to be able to compare both DRM as well as DMA-buf file descriptors.

The basic problem userspace tries to solve is that drivers might get the 
same fd through two different code paths.

For example application using OpenGL/Vulkan for rendering and VA-API for 
video decoding/encoding at the same time.

Both APIs get a fd which identifies the device to use. It can be the 
same, but it doesn't have to.

If it's the same device driver connection (or in kernel speak underlying 
struct file) then you can optimize away importing and exporting of 
buffers for example.

Additional to that it makes cgroup accounting much easier because you 
don't count things twice because they are shared etc...

Regards,
Christian.

>
>                   Linus


