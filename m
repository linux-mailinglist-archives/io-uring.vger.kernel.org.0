Return-Path: <io-uring+bounces-1753-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8C018BBCE7
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 17:54:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42834281C27
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 15:54:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4B564CE13;
	Sat,  4 May 2024 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="W1qCv1iK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5473D971
	for <io-uring@vger.kernel.org>; Sat,  4 May 2024 15:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714838047; cv=none; b=ccAj1Q7Gw5qeM9vf8C1OK7iqRfKD3DPuMSv24dTq+4gAudKPfKX42j52zPqWvAO8CAWLDJxd4go93MwmmM4zLbnuskd2xR5W0l5ZklJgJnoXYjx4EYBgmp6pxJL6hTtOYGK90iXzh4Ke6PQ99mdBfuSASxZmdLgpiXoo4KRV1lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714838047; c=relaxed/simple;
	bh=/aq2jAO4DmSNrNoBrUEE3/qpOKGIfIhWERou7A/I/9o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dunwrkzOPaQmvdOIuds0koCfS+UkTq9i5sKO5WscVJdX9+q44u78zLiZDiyAkghcjnl7cr+wAu0NzEHosu2R6vmZ6nJLpVjHQNPq/8vQMIyxM3X6RCUfz9P+I97M4Ut3S3xD3Diiw1R4mEygq8B+VJBJD4BaA1QgBoExaCzIIWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=W1qCv1iK; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a59a17fcc6bso124462566b.1
        for <io-uring@vger.kernel.org>; Sat, 04 May 2024 08:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714838044; x=1715442844; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kZo6ArVOf5NVi3NAdVYQGqHRs84wzKq7YB5CfjfJdNw=;
        b=W1qCv1iK4D5rv6qfvJNHUlTcCzPfQu9ig1Ns3K6JzG1tm4P3Sww43b+o5WEkGlIqhG
         GvCiBIfWqW6CaiBkXf3ioUD209kz7+/oWK1D+8kuRy+trp+BVOuy/nycTQYlyCTqJfNq
         DqvV1G8przttRIjyNUEA2VgkmtTUVHC4VBaAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714838044; x=1715442844;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kZo6ArVOf5NVi3NAdVYQGqHRs84wzKq7YB5CfjfJdNw=;
        b=JqeSAKeyhmG++g3o7zBfBfMKNbdZA5gkCfOy3L3Zi1Sx/zHAwqxDrCW652A0mn20a+
         6uKq+S61F4xbWxB/Y77YUrJKQ3UecYYKFOjT02fyZ80b7F4gUBI3c+p9dMnmoxykKdhu
         3DCyolZqu9gKXGcNnzcrE9SUU8BdBmRYhcYQud1z52qpB1J6IydR/W26LLeiKzK1oz+F
         ukSai3LppF7djdEtX1Fij1a7L78RIzd0aAeSAXQuGaHER1QkdxrwNNS8rgupu30fODFT
         thPUmqOlH8nU9CXxYjeEPTDNeLybQH8xf/TpxB5VKT9z7qpchL7aFBUrVucjgErhDKU0
         4QCg==
X-Forwarded-Encrypted: i=1; AJvYcCWBB/Ld1Ew8bx+jO6WSbH7NeVd4ZJ59Aiz4JqO+MFkBWEcvlxaDT37BG8XXzVRYc/5yJxaP0/DCXCABn+CuaChd9Z3bj5qh8FE=
X-Gm-Message-State: AOJu0YwkRQyGTjHnem1NQb7mGOTbEzEuImyHi4RFuosx00zuw9WGdWIo
	CaHKOpT9Lk7p7VL0RdUDqncYxyGYcrkLPykpy2eCyvH+7zedXqaESZ/EogpZ3uKcHg+B5Fn3aiL
	k+jIxnQ==
X-Google-Smtp-Source: AGHT+IH4I1HXAmG+FtPHthWTUzr+y7TRqdUMkV7bBF/p5j206WVzBWx+cXJNIXhYGGxI+YcpOPugGg==
X-Received: by 2002:a17:906:f348:b0:a59:a282:5dbb with SMTP id hg8-20020a170906f34800b00a59a2825dbbmr1515535ejb.49.1714838044399;
        Sat, 04 May 2024 08:54:04 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id p22-20020a1709060e9600b00a5887833da8sm3023835ejf.81.2024.05.04.08.54.04
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 May 2024 08:54:04 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a59a0e4b773so128276566b.2
        for <io-uring@vger.kernel.org>; Sat, 04 May 2024 08:54:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWQHMBkffN7/3cf2AaJQiKUmatdceuAd0UJrIQ2tfo+kRXeLlVez0NIJ/J+KyyMFo6/g4RYXJIz5II5cyqN4av/WkX7T5Hqs4A=
X-Received: by 2002:a17:906:a842:b0:a58:5ee1:db43 with SMTP id
 dx2-20020a170906a84200b00a585ee1db43mr3389515ejb.23.1714838043724; Sat, 04
 May 2024 08:54:03 -0700 (PDT)
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
In-Reply-To: <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 4 May 2024 08:53:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=whrSSNYVzTHNFDNGag_xcKuv=RaQUX8+n29kkic39DRuQ@mail.gmail.com>
Message-ID: <CAHk-=whrSSNYVzTHNFDNGag_xcKuv=RaQUX8+n29kkic39DRuQ@mail.gmail.com>
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

On Sat, 4 May 2024 at 08:40, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> And maybe it's even *only* dma-buf that does that fget() in its
> ->poll() function. Even *then* it's not a dma-buf.c bug.

They all do in the sense that they do

  poll_wait
    -> __pollwait
     -> get_file (*boom*)

but the boom is very small because the poll_wait() will be undone by
poll_freewait(), and normally poll/select has held the file count
elevated.

Except for epoll. Which leaves those pollwait entries around until
it's done - but again will be held up on the ep->mtx before it does
so.

So everybody does some f_count games, but possibly dma-buf is the only
one that ends up expecting to hold on to the f_count for longer
periods.

             Linus

