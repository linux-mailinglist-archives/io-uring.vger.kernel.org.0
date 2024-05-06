Return-Path: <io-uring+bounces-1777-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FC888BD04E
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:30:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FAE8285C1F
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 14:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20B6113D608;
	Mon,  6 May 2024 14:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CDmUm03g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B9213D2BC;
	Mon,  6 May 2024 14:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715005791; cv=none; b=MsSBjz3HiZAlfroygYbKHzIJuMO35WdhcLstObn/rJxviWN0XhhGjDH0NPchFOjkKE63HdD9WjkJ1UcQS4tlU50FFGZH+7ibCQ8SUUuQL/NNqMHGd60U7z458za883mugwYN5P07n+UAJYqQZPE/EOqq9cDMbWqHIoTn456nbiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715005791; c=relaxed/simple;
	bh=yTlY3cXJWgxA77cPCojHL92hb0JWShOiyiNH6acL9vQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CltvTkmKdlcPNXwfS1KUJ63TrAuFQJE8Y89Yoqv9CaAqcTB6kNReajUtbCaLOHYAPaIBM/xeNPGbIlELlJ9BReb2npcDPfBJ9eED2bBIn+IwDT36jg5TujDMfyurR/BDFFGrps2wB25sKAEoFzwVI5Y/D2WnZ86oM5xsCOiDYg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CDmUm03g; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-41dc9f98e8dso24159865e9.1;
        Mon, 06 May 2024 07:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715005788; x=1715610588; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=P7R2UF48atqv/gEumi+l7V+7dd7ac8J8DMLbixRpr6s=;
        b=CDmUm03gDyBEmRV/wgQNUm07zfonxwQhKgLcCJNcO4yxPR1qE5g+j1w/u/Jem403Oe
         Zpvk2RPhGWcMVKF6jMKwpPiuuUeWOF4T00WWNzFj6goIdx2xczgC30e3uWgRPvnCFCO1
         I/bG4pXKB/3a3ALRwJMcPUAx04s/JZK9Mm9+11rPhzN9f5zopi5JxGIhWArvbjDe7g6r
         TkJVp7bjOGM5G4UBsHwCx85ffiUX6I3VXduSe3dHj9Fww/zWae0Xn6sWDbT8gIWd8tz6
         iyZ4uztzVVKdbXhgx8PQasShBSASyqmmXdMnf9yic3juzEFDO/orO5la75veKFPtXz0s
         YMWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715005788; x=1715610588;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P7R2UF48atqv/gEumi+l7V+7dd7ac8J8DMLbixRpr6s=;
        b=Pd9G5DmpTr7anUJHJ9qYpVyDUuL97hwEcrkG5TrUtWol3HB85dTp7aUSG7QcDZTE15
         85LyEgQrfqRyxK9Rf6q3CLGOLKsfhUwrGIvN8lgfVNz4F+TjWKkA+0u8qvVMz1nslsMr
         ZR0e/vXxeLBm+TWuDv6Z7NQHuoYVWT9WIOxlFDueYbQLrQDrMrB1eGexfPub6diGVAEd
         GR952/xBakEoU1YMI7HBmg2gniHvjXnwg5nsh2eL/KBbr/dPNvFLzhLWVeQhMRv1wqxr
         AoU8ShsJ4MOO3XqMWSEuAQEG5wVpWQNZfeJwD/KC2aI1u8xE2f0Uder+T+ejiqR5nexe
         NdFA==
X-Forwarded-Encrypted: i=1; AJvYcCWWIFQ+JSUQNy6OM8RR1b1Gm9nvgfr0wE2VqRbj0lywTvrLUYM2EIZO7WVah75ZsmXaM6nEThIQn2OjngecnICU1x+CeAM7n4AlYLXm19uYWVuuFVIeNy/7l6t5mzIgxbnI4rKtxTdt5vU6EcIsPDKX0BKhz7yXGuPRxxHxU75DCRAHIORGMM0JFSuWcYiGzxZcGBX8GlR63HQ1N4+HcYndH0Q=
X-Gm-Message-State: AOJu0YweweVxKcH+D0TxJ7bMBzTcDS6uBcQRw+yj6MhvSiTm98pEsBht
	SdFTrxx8eWkcpdM2tycqI+DnZ8/04H3F8Xa9PFvSj8gcdNHS1KkU
X-Google-Smtp-Source: AGHT+IH+uilrYBzdDMiE5k3XA1ozo74RVRh9CEWscdREfkRqL3c1m4xxcjh8Y/GbZ1wlL8KfoUDDPg==
X-Received: by 2002:adf:efc9:0:b0:34c:e6ca:b844 with SMTP id i9-20020adfefc9000000b0034ce6cab844mr8581498wrp.10.1715005787486;
        Mon, 06 May 2024 07:29:47 -0700 (PDT)
Received: from [192.168.178.25] ([185.254.126.157])
        by smtp.gmail.com with ESMTPSA id dn2-20020a0560000c0200b0034e14d59f07sm10890219wrb.73.2024.05.06.07.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 07:29:46 -0700 (PDT)
Message-ID: <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
Date: Mon, 6 May 2024 16:29:44 +0200
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
 Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org,
 axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
 io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name,
 linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
 minhquangbui99@gmail.com, sumit.semwal@linaro.org,
 syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>
In-Reply-To: <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Am 04.05.24 um 20:20 schrieb Linus Torvalds:
> On Sat, 4 May 2024 at 08:32, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> Lookie here, the fundamental issue is that epoll can call '->poll()'
>> on a file descriptor that is being closed concurrently.
> Thinking some more about this, and replying to myself...
>
> Actually, I wonder if we could *really* fix this by simply moving the
> eventpoll_release() to where it really belongs.
>
> If we did it in file_close_fd_locked(),  it would actually make a
> *lot* more sense. Particularly since eventpoll actually uses this:
>
>      struct epoll_filefd {
>          struct file *file;
>          int fd;
>      } __packed;
>
> ie it doesn't just use the 'struct file *', it uses the 'fd' itself
> (for ep_find()).
>
> (Strictly speaking, it should also have a pointer to the 'struct
> files_struct' to make the 'int fd' be meaningful).

While I completely agree on this I unfortunately have to ruin the idea.

Before we had KCMP some people relied on the strange behavior of 
eventpoll to compare struct files when the fd is the same.

I just recently suggested that solution to somebody at AMD as a 
workaround when KCMP is disabled because of security hardening and I'm 
pretty sure I've seen it somewhere else as well.

So when we change that it would break (undocumented?) UAPI behavior.

Regards,
Christian.

>
> IOW, eventpoll already considers the file _descriptor_ relevant, not
> just the file pointer, and that's destroyed at *close* time, not at
> 'fput()' time.
>
> Yeah, yeah, the locking situation in file_close_fd_locked() is a bit
> inconvenient, but if we can solve that, it would solve the problem in
> a fundamentally different way: remove the ep iterm before the
> file->f_count has actually been decremented, so the whole "race with
> fput()" would just go away entirely.
>
> I dunno. I think that would be the right thing to do, but I wouldn't
> be surprised if some disgusting eventpoll user then might depend on
> the current situation where the eventpoll thing stays around even
> after the close() if you have another copy of the file open.
>
>               Linus
> _______________________________________________
> Linaro-mm-sig mailing list -- linaro-mm-sig@lists.linaro.org
> To unsubscribe send an email to linaro-mm-sig-leave@lists.linaro.org


