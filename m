Return-Path: <io-uring+bounces-1763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 663FC8BC385
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 22:12:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A3011C20FD4
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 20:12:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2597D74427;
	Sun,  5 May 2024 20:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hXkF74EB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 719937317C
	for <io-uring@vger.kernel.org>; Sun,  5 May 2024 20:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714939876; cv=none; b=TBFStHqS2/ALg5AOv5QJsR/mZqltTtJKhBPAvSof3fQwpVzSchkxsvYsahG2rFMFigatgk3pPHCXvh5hKy+N+nDtRiT5Kp1/iKpBFjPv3HtQ1TmkDd4uf5N+Z2ELwH5b/UvZbhrjV0Lj9hJt5KAMZ1F7tix40P0Sbc3MvHrgWS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714939876; c=relaxed/simple;
	bh=wWs9rnVSNPVg9flRopfXNHpvrjJqY4eLW8+/eL6ffhw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vo2MT73u5c6V0Y9J7vH7OAqZFzxNuZhd63+qdqceACe4E0on9XkvTdrizNidVwlhu7KTw4zckHwn2UC1vkW1cZ2DE3rCP91XwIA1tbWFGxuYPP8pg+pRlFHIBiOTSxlXe9TpJkugO7bMAXxnA1x0n4U7tz1YsL5KDd2gVno6Ei0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hXkF74EB; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2e2c70f0c97so15199851fa.0
        for <io-uring@vger.kernel.org>; Sun, 05 May 2024 13:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714939871; x=1715544671; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EHEpVJVmF2eGrGo8U8tgs6RR34ElBujEmi1VC80nQxg=;
        b=hXkF74EBghsN0wCeX6L5o1JtGK7+0vpbciSyp3JquYmcwrf8l9GpgHjln6BLVhtpmr
         6zVGlT+NZCVyDjK7c/6AIRrXUiAMP2KiXNS692RM8TNYWuL4KWNjAWdb+Uo9YF7cyJoc
         gQj92xGfC9LvVvROPFyutXPbiJrQtpHXcvIr4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714939871; x=1715544671;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EHEpVJVmF2eGrGo8U8tgs6RR34ElBujEmi1VC80nQxg=;
        b=ubFtK6b40EGPZBuHLwPPgDYgLzCr4rXA0M/VxJiHG+YDn3c4r96gsQgM6fYuhr2IWw
         J1V7NysEnByYgk34EXO+aXBxXJlFjOiLe+Bh61TqlvceGJZJtMxnKAynrg8LOOJ+MFtL
         qJiylvwSRZnO1o/Mt5uXs8WNX5c/uot36oXNHimCVmVvSshbWtlNH8Uh7hiANUFiiAxX
         IweSvpO1Wb7PSWj8RjVhzfbAD747KDuBtKnQ1Jkr/s9eIRqQAk5ZspLO0GKAnGCZhz/M
         tSVWzB8g5zpT0wel3uUiA2wMt/tIGA3NqTyASql73OIAQ36eesGh9rkKEREUCIlACfmo
         za2A==
X-Forwarded-Encrypted: i=1; AJvYcCWVNdhmERLd1CglZztNldxHC3jfe7PHBmdP0HCOW+GqVpUYyVVZNGAYO7ZJC3MUoE7Fv2kjcPzj2z1iKSIZrdvp6WxJhCyMZzk=
X-Gm-Message-State: AOJu0YwWCMB1a32ESpyobOfEsWZ6b6k4AKO5LSBbzrwFGFLvOD2THsqS
	8vFU5V+4oKSGNhpKuBa03+M2vU+Bj0DIiPRGkG4BBixIj57qMwlC+3AponyqKg0TT6JGe/HUHD1
	gRvbCTw==
X-Google-Smtp-Source: AGHT+IFmmfj5TLR83XpwCqXzrhblkljIXZa1ZQOkDE0H8BPenuu3eYiBK60v3HiwjaRAYZyCjtZjyQ==
X-Received: by 2002:a05:651c:10a2:b0:2e0:eb96:7b53 with SMTP id k2-20020a05651c10a200b002e0eb967b53mr5205389ljn.44.1714939871304;
        Sun, 05 May 2024 13:11:11 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id d17-20020a2eb051000000b002d8e9a37bfdsm1281030ljl.113.2024.05.05.13.11.10
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 May 2024 13:11:11 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-51f4d2676d1so1331341e87.3
        for <io-uring@vger.kernel.org>; Sun, 05 May 2024 13:11:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV1LWdcGh9ZdkfgPmgqnXbFC86KTaPbCH9zRdowvNit5QQ/Y3ncrS//iB3hiahFucw6Qmur74RcfOI+ZEbhPys0MaM4spGOTPU=
X-Received: by 2002:a05:6512:202c:b0:518:c057:6ab1 with SMTP id
 s12-20020a056512202c00b00518c0576ab1mr4629192lfs.66.1714939404009; Sun, 05
 May 2024 13:03:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202405031110.6F47982593@keescook> <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV> <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner> <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
 <CAHk-=whrSSNYVzTHNFDNGag_xcKuv=RaQUX8+n29kkic39DRuQ@mail.gmail.com> <20240505194603.GH2118490@ZenIV>
In-Reply-To: <20240505194603.GH2118490@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 5 May 2024 13:03:07 -0700
X-Gmail-Original-Message-ID: <CAHk-=wipanX2KYbWvO5=5Zv9O3r8kA-tqBid0g3mLTCt_wt8OA@mail.gmail.com>
Message-ID: <CAHk-=wipanX2KYbWvO5=5Zv9O3r8kA-tqBid0g3mLTCt_wt8OA@mail.gmail.com>
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>, keescook@chromium.org, axboe@kernel.dk, 
	christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, 
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Sun, 5 May 2024 at 12:46, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> I've no problem with having epoll grab a reference, but if we make that
> a universal requirement ->poll() instances can rely upon,

Al, we're note "making that a requirement".

It always has been.

Otgherwise, the docs should have shouted out DAMN LOUDLY that you
can't rely on all the normal refcounting of 'struct file' THAT EVERY
SINGLE NORMAL VFS FUNCTION CAN.

Lookie herte: epoll is unimportant and irrelevant garbage compared to
something fundamental like "read()", and what does read() do?

It does this:

        struct fd f = fdget_pos(fd);

        if (f.file) {
                ...

which is being DAMN CAREFUL to make sure that the file has the proper
refcounts before it then calls "vfs_read()". There's a lot of very
careful and subtle code in fdget_pos() to make this all proper, and
that even if the file is closed by another thread concurrently, we
*always* have a refcount to it, and it's always live over the whole
'vfs_read()' sequence.

'vfs_poll()' is NOT DIFFERENT in this regard. Not at all.

Now, you have two choices that are intellectually honest:

 - admit that epoll() - which is a hell of a lot less important -
should spend a small fraction of that effort on making its vfs_poll()
use sane

 - say that all this fdget_pos() care is uncalled for in the read()
path, and we should make all the filesystem .read() functions be aware
that the file pointer they get may be garbage, and they should use
get_file_active() to make sure every 'struct file *' use they have is
safe?

because if your choice is that "epoll can do whatever the f*&k it
wants", then it's in clear violation of all the effort we go to in a
MUCH MORE IMPORTANT code path, and is clearly not consistent or
logical.

Neither you nor Christian have explained why you think it's ok for
that epoll() garbage to magically violate all our regular rules.

Your claim that those regular rules are some new conditional
requirement that we'd be imposing. NO. They are the rules that
*anybody* who gets a 'struct file *' pointer should always be able to
rely on by default: it's damn well a ref-counted thing, and the caller
holds the refcount.

The exceptional case is exactly the other way around: if you do random
crap with unrefcounted poitners, it's *your* problem, and *you* are
the one who has to be careful. Not some unrelated poor driver that
didn't know about your f*&k-up.

Dammit, epoll is CLEARLY BUGGY. It's passing off random kernel
pointers without holding a refcount to them. THAT'S A BUG.

And fixing that bug is *not* somehow changing existing rules as you
are trying to claim. No. It's just fixing a bug.

So stop claiming that this is some "new requirement". It is absolutely
nothing of the sort. epoll() actively MISUSED file pointer, because
file pointers are fundamentally refcounted (as are pretty much all
sane kernel interfaces).

                Linus

