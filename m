Return-Path: <io-uring+bounces-1814-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C7F8BEC40
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 21:07:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EBD891C21A95
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 19:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EB1116D9A7;
	Tue,  7 May 2024 19:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="DFUwi571"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8C314E2EF
	for <io-uring@vger.kernel.org>; Tue,  7 May 2024 19:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715108851; cv=none; b=uOj1aD7b0nwwuDh2bmwTrpqzWIvNyPxWIXc4rrDU7kXWtdQhUm+ATSVvEcm/B4avMi/jteloS+l0AB/18Sa+IgtLYo8LmSWwGDigVJhOTz/pGBBk0KoZZq8R775FFoReRarBw+CVMFbY1/jV2BTxwCD2rnvvl2JmSCQAnummWjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715108851; c=relaxed/simple;
	bh=pui840tsR5Yet33PCWgvY2wZoLY0nvaSbhvNkKxiwJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sb7pRYo/7sYjj1eVcWrzic0veyiMhLUm6ZFUUSUxKx7cF5cGUzTyNQr3vxl/p45wvOmfrWb9n6nh0y9UTNiKrkmo1H4039m6onUxlH+LitMIEg3kEiZOI+cAB/lWt0h8qlBx3iun9/WEjly3Jcd6aQp3z5rWMBiYG6rAlYCwRDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=DFUwi571; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a59a5f81af4so918581966b.3
        for <io-uring@vger.kernel.org>; Tue, 07 May 2024 12:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715108848; x=1715713648; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JwU1IWNzhlSP5EH9iyMHaFmRpSbbE8IFJCVgZMlAkcM=;
        b=DFUwi571hMybU1SwqwwPzNd8bQCjuiUB4OnZhMGkTqj/h1M2JrfFlye5c3fPt8sSMa
         56bEzZxMn21nPIiO2CmFrwljmDAScNRWYGg8dzSueW+f+Rmc0UUGBDtWkQz1/9WRqYTP
         wO1aLH8edV8HeIUdW22yvJ+T5YneqENlhPIRk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715108848; x=1715713648;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JwU1IWNzhlSP5EH9iyMHaFmRpSbbE8IFJCVgZMlAkcM=;
        b=FWqgupVgjYn03UOTEUsWIcH1h6UuYUmwZrWY+sRlhFTD/fdtf71cbqvz5mCkCYBs20
         d8OrBNPtNoeH2trqH4XfR63flcnPnR+a4ZnTeEnJVtvpmfaUUpXIotf5mAXuONk3pbEa
         pgj32cv3v5pF+dE52jSviB0aXj1jOGdFIEP2pQXCgJ/6eInTnIAOiNAvRIPKU6s3hJsF
         K0BoxGo5dvedmxsYsE7gGZLyHXWKC90mhR4XDjE2RCfi2pcE54Ju3XJ7JRbxiw8e2QsL
         U+5PXtzy4GUIHC5lmMhKmS429elNsyY7d5hYun8Cmux0fmdyn3G14lUUOIyXjqFvEupN
         SuuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKxSPpg+xthcXlYemnXDBMWGjuomK2YB62Xz/eee6p3+KbxQXHFOlQSrPoqPUgnhUUGNj14o4sU/Ei7OMLc5MrSm9vygUZFCc=
X-Gm-Message-State: AOJu0YxB7YnJ3YgMj/SdMUxxswgSXDeE6pNtl5KJS29A8DUDI03mOvd1
	vzeFbZiZbkgFl7xy2NKb4pJpXEGe8ROgDMIy8lVdhbvcxbAaTvXcE33qjum3i5GUFi7wiOQZfzc
	y2Rsuug==
X-Google-Smtp-Source: AGHT+IE88nYmrmlOCZB+cfgviGHNHPAtyTco74g0cZjrjOyqFLxuepOUujtROkZe+GlC2hngYP87aw==
X-Received: by 2002:a17:906:abd3:b0:a59:bb61:8edd with SMTP id a640c23a62f3a-a59fb9f212fmr20453766b.72.1715108848033;
        Tue, 07 May 2024 12:07:28 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id mt20-20020a170907619400b00a59a4261b84sm4834931ejc.141.2024.05.07.12.07.27
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 12:07:27 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a59b178b75bso630041466b.0
        for <io-uring@vger.kernel.org>; Tue, 07 May 2024 12:07:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWCyK3m98gTB1LX1lTgCJQkPSZ6nQqzCrWggzW4uy0lUHrzls/bNQCo/1CICBn/TCLlW54dAfey9384Ks9uE23ZgjWZnVbUZiQ=
X-Received: by 2002:a17:906:1957:b0:a59:a977:a157 with SMTP id
 a640c23a62f3a-a59fb9f209dmr23097766b.73.1715108847432; Tue, 07 May 2024
 12:07:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202405031110.6F47982593@keescook> <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV> <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner> <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com> <ZjoKX4nmrRdevyxm@phenom.ffwll.local>
 <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com> <CAKMK7uGzhAHHkWj0N33NB3OXMFtNHv7=h=P-bdtYkw=Ja9kwHw@mail.gmail.com>
In-Reply-To: <CAKMK7uGzhAHHkWj0N33NB3OXMFtNHv7=h=P-bdtYkw=Ja9kwHw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 May 2024 12:07:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=whFyOn4vp7+++MTOd1Y3wgVFxRoVdSuPmN1_b6q_Jjkxg@mail.gmail.com>
Message-ID: <CAHk-=whFyOn4vp7+++MTOd1Y3wgVFxRoVdSuPmN1_b6q_Jjkxg@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better about
 file lifetimes
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Simon Ser <contact@emersion.fr>, Pekka Paalanen <pekka.paalanen@collabora.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>, 
	Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, 
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 7 May 2024 at 11:04, Daniel Vetter <daniel@ffwll.ch> wrote:
>
> On Tue, May 07, 2024 at 09:46:31AM -0700, Linus Torvalds wrote:
>
> > I'd be perfectly ok with adding a generic "FISAME" VFS level ioctl
> > too, if this is possibly a more common thing. and not just DRM wants
> > it.
> >
> > Would something like that work for you?
>
> Yes.
>
> Adding Simon and Pekka as two of the usual suspects for this kind of
> stuff. Also example code (the int return value is just so that callers know
> when kcmp isn't available, they all only care about equality):
>
> https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/src/util/os_file.c#L239

That example thing shows that we shouldn't make it a FISAME ioctl - we
should make it a fcntl() instead, and it would just be a companion to
F_DUPFD.

Doesn't that strike everybody as a *much* cleaner interface? I think
F_ISDUP would work very naturally indeed with F_DUPFD.

Yes? No?

                       Linus

