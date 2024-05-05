Return-Path: <io-uring+bounces-1756-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A5F28BC28E
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 18:46:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 248EE1C209DF
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 16:46:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2179437141;
	Sun,  5 May 2024 16:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jh0m25dd"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 251971E52A
	for <io-uring@vger.kernel.org>; Sun,  5 May 2024 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714927588; cv=none; b=i6V38/ZfqEE6pQwQWFSPV4kJEZvAGB5tmf5fQcb2j4XdbeXW9xQ+n/Y76qIQ1mDwtJQer64z1twlebJZYkEt/ZqKSjxAZCLRs2Db4DgiTmzlxDIY0xQIxqnYyNW8srOf6krolDutTkBi50+Ij2Mr3GMvwNzVjdO1tuzPTjWE3Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714927588; c=relaxed/simple;
	bh=CLhNByDrSyy3KlkeokG4swipYxw1p9LkQ6WM4wj072Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ui1HaqqxnTt3u3uHJN6zWMlVxb/WyRtHrw665z5DlaaS4sm1g+KF7GaUqyHYM7iioNItGzjp8H4s3Qke3wxS3CzYZ7CXCsVJbaC4xGL/+6rFBJAY+qZrQJTD88VnVsPTQJkaaNAIX2e+gAJIvqj4y/4BOleMf6EEKdGXPWXCF/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jh0m25dd; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a59b81d087aso171537366b.3
        for <io-uring@vger.kernel.org>; Sun, 05 May 2024 09:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714927584; x=1715532384; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aYdtp3YANTth8Vi9S+yHKBJaPcPwhcLOgY9vMAI/QdY=;
        b=Jh0m25ddNdP2B2AMRer6g2SsW4aWlFV4wvbACB4nQ9lt2L9qHjX30wG6XAmXRJqb9b
         cnDKyodeqsI4AtByabWH8SPehOzuKTxu659W1aKn8zxvej/pit6U6xPJg7vIiRNCPxJT
         Pmhip1fNYVkrmjHVLDxwcOUHdbIpck4jh1lVc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714927584; x=1715532384;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aYdtp3YANTth8Vi9S+yHKBJaPcPwhcLOgY9vMAI/QdY=;
        b=A/o0METYS1A9xJNmlj8byKFDrdvF4ksvXyFGT6YZZTU4AB44icW3Zewfw9xI+DUB6k
         FtWXpruQZtCTi+ux1InAcQpRyff3BHV+Yyd1iCDgEBkBoXLbh7yKbQJonJc9FngM9Yeo
         OC/1L7gOOcdWoH+v4JBZXuMpYYWFgP91Ju8JyVV9S9eKFFoi8+5lDf6OdkIBiHdEHWUg
         COdzDbxekQ3pu/ulgW8VIhXxvQImrOoaVyYs+LXtAagiBwDl7UoQLrx8aOoC0wa97Lss
         PMvdFJ0PqRnIs/7JlOe4sVLjWBblSaDFYVIVqnFQnP+IDMUrddq0CwyOS0lfoQO23zum
         L7hw==
X-Forwarded-Encrypted: i=1; AJvYcCVvQphsVpqvT5zShzs7U/wIvbXxaXaANv+NCnJpyevK5r6dinN9yVY0vJsTq9VrGnFvqWkvzARWwTUHSw1Y8tHzQqKUyJ20HC0=
X-Gm-Message-State: AOJu0YzQ2pdxU4RfFcz7IGCFiRAL96kgIbQa9i5RbMVMpo5nRbTBVOQN
	c0uMzIFcaKRxeKmPHSlBN5sdGatw5Z/PtGmOm6QAPfClVr824jhz/w4OEfUCPqRcCp/8ibEAXIv
	ZTmMvnA==
X-Google-Smtp-Source: AGHT+IGHj3Ol+fin1RvhRuyT7z24bxw4fHGOdEIxOTHSWXXe/nSQlHql4DuyRVLpxOHsvjuVotypGA==
X-Received: by 2002:a17:906:4948:b0:a59:a18e:3fd4 with SMTP id f8-20020a170906494800b00a59a18e3fd4mr4385089ejt.31.1714927584378;
        Sun, 05 May 2024 09:46:24 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id jl24-20020a17090775d800b00a599acaff03sm2888640ejc.19.2024.05.05.09.46.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 May 2024 09:46:23 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a5200afe39eso281494166b.1
        for <io-uring@vger.kernel.org>; Sun, 05 May 2024 09:46:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVA1L0XcidfDRAU50DT7STUvBUFUQsMUEMA/dbNFkObkv8aD3YK6/WTLEzGn2sorDA5HgtLyDVPk6W8c8Z19di8cGzUa8Lcug8=
X-Received: by 2002:a17:907:3f9a:b0:a59:c5c2:a31c with SMTP id
 hr26-20020a1709073f9a00b00a59c5c2a31cmr2077374ejc.33.1714927582181; Sun, 05
 May 2024 09:46:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202405031110.6F47982593@keescook> <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV> <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner> <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com> <20240505-gelehnt-anfahren-8250b487da2c@brauner>
In-Reply-To: <20240505-gelehnt-anfahren-8250b487da2c@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 5 May 2024 09:46:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>
Message-ID: <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
To: Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, axboe@kernel.dk, 
	christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, 
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Sun, 5 May 2024 at 03:50, Christian Brauner <brauner@kernel.org> wrote:
>
> And I agree with you that for some instances it's valid to take another
> reference to a file from f_op->poll() but then they need to use
> get_file_active() imho and simply handle the case where f_count is zero.

I think this is

 (a) practically impossible to find (since most f_count updates are in
various random helpers)

 (b) not tenable in the first place, since *EVERYBODY* does a f_count
update as part of the bog-standard pollwait

So (b) means that the notion of "warn if somebody increments f_count
from zero" is broken to begin with - but it's doubly broken because it
wouldn't find anything *anyway*, since this never happens in any
normal situation.

And (a) means that any non-automatic finding of this is practically impossible.

> And we need to document that in Documentation/filesystems/file.rst or
> locking.rst.

WHY?

Why cannot you and Al just admit that the problem is in epoll. Always
has been, always will be.

The fact is, it's not dma-buf that is violating any rules. It's epoll.
It's calling out to random driver functions with a file pointer that
is no longer valid.

It really is that simple.

I don't see why you are arguing for "unknown number of drivers - we
know at least *one* - have to be fixed for a bug that is in epoll".

If it was *easy* to fix, and if it was *easy* to validate, then  sure.
But that just isn't the case.

In contrast, in epoll it's *trivial* to fix the one case where it does
a VFS call-out, and just say "you have to follow the rules".

So explain to me again why you want to mess up the driver interface
and everybody who has a '.poll()' function, and not just fix the ONE
clearly buggy piece of code.

Because dammit,. epoll is clearly buggy. It's not enough to say "the
file allocation isn't going away", and claim that that means that it's
not buggy - when the file IS NO LONGER VALID!

                      Linus

