Return-Path: <io-uring+bounces-1809-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FB478BE9A5
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 18:49:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D0B231F213A8
	for <lists+io-uring@lfdr.de>; Tue,  7 May 2024 16:49:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB25316C684;
	Tue,  7 May 2024 16:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cQ+n6tQ0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B054F16C69C
	for <io-uring@vger.kernel.org>; Tue,  7 May 2024 16:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715100413; cv=none; b=F4eJG3/aECcx3K9fRtxxtH0l9ys+m7ZHDLShQWAST6HxsoS2O4kmUNHOM5u65vXQZsGmBhCJM7XWrp9jKBHn63iDfeENU/w15gNvytwKuUyIbci8H/VIqnZxL9K7owiJOKzx+GoSftoskse/ufosHBF2pffLNjl5uEZh5yOx6gQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715100413; c=relaxed/simple;
	bh=VcUsDxZUpDGF/2Z4CuONrG7q84Dnoj3KVEQQuxcgc5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=ghDzE3QE6BF9ejeLcTKMAbI1QiOoJVZt0CKFNqcRZ7DUjjedfmxYgbY5Cwa6SH/mtZ0xYMqEw4vIv6bVYVDkRtmMBnCBQ/zfCSw1Cqs2zhMqM1dfuXqwHyNgXDGtuF3mcoNIoOXsfFu3n/+QGyDZ8kwXPGWNqpKaHHMwrDri6o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cQ+n6tQ0; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a59a0168c75so874830166b.1
        for <io-uring@vger.kernel.org>; Tue, 07 May 2024 09:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715100410; x=1715705210; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x+/m+VOoT4mV8mZDo3MLSD/vsCL7+IgmGDq9kgXSLzI=;
        b=cQ+n6tQ0C/iwgjO1DCCkyO6Zli2FF54s75zk7WPwgFKsMQN1BdMdnSIST4IQdqWRfp
         iY9JdHQL2svDWbeyB5KQxLJgdCi4UbSqqmv33aZGGRYbQVJGsGYVCaPM88WMc1JAusM0
         tL/pikxtX6xM8b6Rj1UzOrKSMP6s8+fFBSV9g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715100410; x=1715705210;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x+/m+VOoT4mV8mZDo3MLSD/vsCL7+IgmGDq9kgXSLzI=;
        b=QXiIKyc0Mm77Vo4nq4P3RPn0RzwKZTQ+7iwW+GHO+W4jagS4i6eCO3LoKxy6GdaPmj
         qFxhKwAwWWRx5eRmzXpvnJhbzalSQAN9mN+lxPCOaN/XXeGqdsx7CbzM0wDwSMGV+HRZ
         LS3Z9bx2Mdm2QLBWfC3pELVoMvTV2qXtOakN4hBh22nkvvkH+51R6CPdRO63+Ohc7E6K
         xfV/mFMyi+BaJ7jx39Ru3/jA0s+HFjOxx9nQvMG4RQswpjTc78vuTAqMOP8Pf+TxsYBc
         y3PCfA2dW0bn9x60ThWtcnRQRpTiWMiEYYaWuCvblHNg7CQf9SF8Yxu8MvL6oXxp464t
         o7GQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8t4n59lWCF6i3b3GXFvxKBPbyll/bd1vWXxIcR9kfjJAEV8L4kZNxJHelAXpMTaMzKMxYFC7j3o/0FjafDRrLPVAeRmNWFk8=
X-Gm-Message-State: AOJu0Yw8PNfwj8E/46MHMxG0B0OSjUfW1mx2R8NYt5tnYJ6LKjHoRuqc
	jAhVh5jZeWKWemfv+n2OmSclvyLBydh4y/4iMt2iQLA+GojyBUefoejtvv149jZkSUOcUNDmGTK
	gmQmOmw==
X-Google-Smtp-Source: AGHT+IEkaxu6tV0BL3AfOiQeqnSR2gCOr1dinm2og2Zw0QJvWi2/TpCxhV5XhSR9Dpijbyu8tChpEw==
X-Received: by 2002:a17:906:7f0d:b0:a59:c319:f1e3 with SMTP id a640c23a62f3a-a59fb94ba87mr2205166b.12.1715100408920;
        Tue, 07 May 2024 09:46:48 -0700 (PDT)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id rh12-20020a17090720ec00b00a59a0cbf048sm4892005ejb.13.2024.05.07.09.46.48
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 May 2024 09:46:48 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a59b58fe083so536195866b.0
        for <io-uring@vger.kernel.org>; Tue, 07 May 2024 09:46:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWNMV5Tg22ag7/h8vhOldltwvnwpExn5dxK5xFVr4wxU6Wc2yb+yYt50dZ8pBpcwMfhXvItv8kjp0zWzuJ4XyIKKYmTBG7zh+8=
X-Received: by 2002:a17:906:d148:b0:a59:b099:1544 with SMTP id
 a640c23a62f3a-a59fb96bda9mr1610066b.42.1715100407952; Tue, 07 May 2024
 09:46:47 -0700 (PDT)
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
In-Reply-To: <ZjoKX4nmrRdevyxm@phenom.ffwll.local>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 7 May 2024 09:46:31 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com>
Message-ID: <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better about
 file lifetimes
To: =?UTF-8?Q?Christian_K=C3=B6nig?= <ckoenig.leichtzumerken@gmail.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, axboe@kernel.dk, 
	christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, 
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Tue, 7 May 2024 at 04:03, Daniel Vetter <daniel@ffwll.ch> wrote:
>
> It's really annoying that on some distros/builds we don't have that, and
> for gpu driver stack reasons we _really_ need to know whether a fd is the
> same as another, due to some messy uniqueness requirements on buffer
> objects various drivers have.

It's sad that such a simple thing would require two other horrid
models (EPOLL or KCMP).

There'[s a reason that KCMP is a config option - *some* of that is
horrible code - but the "compare file descriptors for equality" is not
that reason.

Note that KCMP really is a broken mess. It's also a potential security
hole, even for the simple things, because of how it ends up comparing
kernel pointers (ie it doesn't just say "same file descriptor", it
gives an ordering of them, so you can use KCMP to sort things in
kernel space).

And yes, it orders them after obfuscating the pointer, but it's still
not something I would consider sane as a baseline interface. It was
designed for checkpoint-restore, it's the wrong thing to use for some
"are these file descriptors the same".

The same argument goes for using EPOLL for that. Disgusting hack.

Just what are the requirements for the GPU stack? Is one of the file
descriptors "trusted", IOW, you know what kind it is?

Because dammit, it's *so* easy to do. You could just add a core DRM
ioctl for it. Literally just

        struct fd f1 = fdget(fd1);
        struct fd f2 = fdget(fd2);
        int same;

        same = f1.file && f1.file == f2.file;
        fdput(fd1);
        fdput(fd2);
        return same;

where the only question is if you also woudl want to deal with O_PATH
fd's, in which case the "fdget()" would be "fdget_raw()".

Honestly, adding some DRM ioctl for this sounds hacky, but it sounds
less hacky than relying on EPOLL or KCMP.

I'd be perfectly ok with adding a generic "FISAME" VFS level ioctl
too, if this is possibly a more common thing. and not just DRM wants
it.

Would something like that work for you?

                 Linus

