Return-Path: <io-uring+bounces-1819-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 870A38BF5C3
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 07:55:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D3FF285E36
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 05:55:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E718E175BF;
	Wed,  8 May 2024 05:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TyI3Q/ax"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE4514AB0;
	Wed,  8 May 2024 05:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715147713; cv=none; b=qLgYvedKfO+uDb9jYN4fHylA7vjKeIi8LZilJPc1xAyn1IOgNv6FtFr7/MxHQAsK2kYQdZV+nvzbkmkXPF8jKsxBZyFd7w6ofnDcYcFMp5LqFhnr17eFum499KoE+2c2PKvcaTloyOWPtlK9yOvWPKUhQ6ixpEnikJCHP96IeIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715147713; c=relaxed/simple;
	bh=lO89aVQfFs/6jUDErPkGkXAH9K4sksZShIR9DhCcgkI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e8ERk4tuTpXzhE1rxChbn9HTVjBW6sAzcLAoqwDNp+LahrWhXC9o6/SiW/MzOT9SLaaHQedggA3+j4son6fVBJrHgv1vrHOZOmqK4iDeu8kEzYMwxprbexTWF4perfXpnfBnjoNMUvWA7rdZDYRKD2wrmSK0uPy9bvIwWe+QJ2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TyI3Q/ax; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-34da04e44a2so2220844f8f.1;
        Tue, 07 May 2024 22:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715147710; x=1715752510; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2kECfVH61gVXoLyEKuVmIWZjf9iy/udsb4pKdELyNgI=;
        b=TyI3Q/axaPMnsKWjrLW1k5s+i7XNf++8A5vw98l7hRFVSEHJclBPqXh3gF2ae4iN8y
         X6llgcEJpqI+aVujppjMwj4twoMI5TtXBxQMV2J0nnX2wObShvSYk/wPLINjMsSCZIy0
         lRPlrtQZB5OdN8TbbIeT5injUDcAkYp7zFa/pJEcWzZZbTFrtkMRd1OCIX8ILuLs9ys6
         IMEATsFeifo/PK2wiORJY3VsCwtM78LIUKvdCEnrtjNbDxiKnuGpcTkz2Dxkgy/zbCgW
         hHf4TZ8LsDwzCLNSP8hAXuoHvasnwemDFCeRLoOuk0X31x1H7Zz1jRFYceZtiExDRe3A
         zpbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715147710; x=1715752510;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2kECfVH61gVXoLyEKuVmIWZjf9iy/udsb4pKdELyNgI=;
        b=aZuA6OsLh1yxlQBhwiEJbnzz8Q3CC/ef0ClhaR/hzZQqLcVSgN3lNCZjZmZoDfOpM7
         JSwnWX9KEDFkHtemw6L9rvCi5KGyozGgiYkE3uCAUQRUv3Q6dxy/C8ZE1J43V2pcL8AE
         5Q4gZdrcS2oiUO5lXW4hpMtJjYskoz2lqs+Iwid/LDQsGAZyi+23vng08/RK6IkgHVAj
         h/ic733Mo1rE/CIY3TzUGLoOh8pOb/Q75jV1VCqQvsz1BNrONfodtViSlFcBNyizIVjy
         x60WHrptoNYwmRmAaZzjSolRWiAioegqzFIVTLfOly7z8OEir0zddSK5dU230p3M1U8F
         wUQQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1A/o+3RGzPCNj1u5vkAz6k2z0VU3LrjfCmua/6s++RXjGrUbrvzSXwW7I+tzZtW5v74eZmxqO8QHq3/uqDFAbGTlVjomFzWzE7rnGsxO1no5QF/57Tas58ZC9ONhMRQ766G0xMmDtTfHN4puQGdqdtbQdefnqWSWNs5JIGFoDPrYdnJ/mn4VMJ8cV8jqSPhnB+jfRQVAqsei22XZwPmI6uE4=
X-Gm-Message-State: AOJu0Yyy5ToTFjfHvkWiPD20ZN5dhpEpHL5YHMXJ0fos+0bQK6e3iW8F
	QAhTILDBkfPZlTREGOx6+3CpEfvxN+lcI0/pil2nPq2vedUD/KX8
X-Google-Smtp-Source: AGHT+IGmRYQwYE5GKCP4nHrkMb9CRMRKCaP4q6oTy76fGgGdxl/Be2mRpgRLYl8OhhNTkkldystArg==
X-Received: by 2002:adf:f0c8:0:b0:34e:3cb3:6085 with SMTP id ffacd0b85a97d-34fca81043amr1370408f8f.62.1715147710492;
        Tue, 07 May 2024 22:55:10 -0700 (PDT)
Received: from [10.254.108.81] (munvpn.amd.com. [165.204.72.6])
        by smtp.gmail.com with ESMTPSA id w6-20020adfcd06000000b0034dcb22d82fsm14415768wrm.20.2024.05.07.22.55.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 22:55:10 -0700 (PDT)
Message-ID: <040b32b8-c4df-4121-bb0d-f0c6ee9e123d@gmail.com>
Date: Wed, 8 May 2024 07:55:08 +0200
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
 Daniel Vetter <daniel@ffwll.ch>
Cc: Simon Ser <contact@emersion.fr>,
 Pekka Paalanen <pekka.paalanen@collabora.com>,
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
 <CAKMK7uGzhAHHkWj0N33NB3OXMFtNHv7=h=P-bdtYkw=Ja9kwHw@mail.gmail.com>
 <CAHk-=whFyOn4vp7+++MTOd1Y3wgVFxRoVdSuPmN1_b6q_Jjkxg@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>
In-Reply-To: <CAHk-=whFyOn4vp7+++MTOd1Y3wgVFxRoVdSuPmN1_b6q_Jjkxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 07.05.24 um 21:07 schrieb Linus Torvalds:
> On Tue, 7 May 2024 at 11:04, Daniel Vetter <daniel@ffwll.ch> wrote:
>> On Tue, May 07, 2024 at 09:46:31AM -0700, Linus Torvalds wrote:
>>
>>> I'd be perfectly ok with adding a generic "FISAME" VFS level ioctl
>>> too, if this is possibly a more common thing. and not just DRM wants
>>> it.
>>>
>>> Would something like that work for you?
>> Yes.
>>
>> Adding Simon and Pekka as two of the usual suspects for this kind of
>> stuff. Also example code (the int return value is just so that callers know
>> when kcmp isn't available, they all only care about equality):
>>
>> https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/src/util/os_file.c#L239
> That example thing shows that we shouldn't make it a FISAME ioctl - we
> should make it a fcntl() instead, and it would just be a companion to
> F_DUPFD.
>
> Doesn't that strike everybody as a *much* cleaner interface? I think
> F_ISDUP would work very naturally indeed with F_DUPFD.
>
> Yes? No?

Sounds absolutely sane to me.

Christian.

>
>                         Linus


