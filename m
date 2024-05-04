Return-Path: <io-uring+bounces-1752-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BCA98BBCD2
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 17:40:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A0F52282A58
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 15:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744A641C71;
	Sat,  4 May 2024 15:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="HWYpKkor"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58F83D388
	for <io-uring@vger.kernel.org>; Sat,  4 May 2024 15:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714837246; cv=none; b=CQ8d4VEDSq9msZ7ZCUXH68QsCSx8R8jH0uz9MWhTFTPkrSQmzqsJtEt1Z34Ir0OesekiRb5jYuR7SIqSiIR6ppexge5RNB0ZkgrdEfXv/15rUkNWywmvu2hAv//0Sx3QGg28zvifpekCHBwfg+Z3O8Ge30wlRFBhpEgaRGu/qsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714837246; c=relaxed/simple;
	bh=+wl7Si+XKc7WGkikTFO8826D1qbowNHEhUrycKotHDY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H2opA8mp4asQKeBkgeu3wpSDidSu9g2UhBaGYEiuHm5nUScZD9tb+FGpeZ5j+HEW5wTX3qM8VxTrjht1tyT4PmQRIaQcJ/B6KCHKPURjfL4tl+Eia8usEQVpKaQTwbceQAU6ufdpJhGkhCXh3DIu/9DCCGLi/N6mk/M9OrwZqXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=HWYpKkor; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a59a64db066so126020766b.3
        for <io-uring@vger.kernel.org>; Sat, 04 May 2024 08:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714837243; x=1715442043; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=PFxw8P3AYgeC7IB6rTn+68WOAU10n6cRPv/6X7o+SOY=;
        b=HWYpKkor+X0OlBZ+pN69qc1p+9D286NR/kjb9Eut9WyLQcVKAOVM+kjWJolAyRIjnb
         EleZB/FacFvDmPO7B6sIPd5rt4NS4hLPAbwx/r0yyPImDmy+aY8X2i+CokrQrNVi9S9s
         PrkfUJUNyE7Febc1tcRFEVT+pa1I32u++fKWc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714837243; x=1715442043;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PFxw8P3AYgeC7IB6rTn+68WOAU10n6cRPv/6X7o+SOY=;
        b=BasAfo9KNhgSTV0o1Pa9bZnupLe/kXe9NGUshcxxNXKGEZ3RTsc5HiJxf+CehR0IuX
         MsNTbA/+XBUMMex9spra4qxUsatjeyvvs+uF3ftlfEsJd+jQS+emZHUDE/Hh/l9fc5LK
         F0o35/cdWnEmfFI6JK055BS+wtX0q1AJ8ZDp4xbnVwKJIyQSe3hhkuGQNBRoq38kQW1K
         xXFJIXkLwq5rHYlGDzpqi3G1Lht1i9CrnM4TbXr7l+vZqZSGAFPZrpCfFVwxk3YBvP/Z
         eSM51krZnjJmCfOZfemPC1SkdMhnbzhXBR90njDtedIBzgF165C0LF1ZJl8g+jAixrfk
         DWag==
X-Forwarded-Encrypted: i=1; AJvYcCVxMLPPOcO/44fZ2sxEQ2rsz/XfZlkmzYb8xTwIN1m0M74pRnvNwrVg3qbcQAEdOQ3PLyLH/9kgU/X4Iog+nD33fuDO5vAcgGk=
X-Gm-Message-State: AOJu0Yy2NPOF+zmtlH4mX1byV/TLJ/yD5nrlpKWyIKcsKwLs53xQ+dYg
	dDrurS9FRk7nHYHweH6AUvva9sMNIhbfn6Hwh48izcsrYE1LrCMmQdXQrZrM5NrkV0eloo/3DCO
	1mO2vVQ==
X-Google-Smtp-Source: AGHT+IFagEwx5iONFymeu/xv7WxEiQoHhWcLQ0k/+3MvN2l1l3pu1ddGVvvhQaZ5CmO5gkKY5o3kHQ==
X-Received: by 2002:a17:906:110c:b0:a55:55b3:e899 with SMTP id h12-20020a170906110c00b00a5555b3e899mr3766544eja.63.1714837243044;
        Sat, 04 May 2024 08:40:43 -0700 (PDT)
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com. [209.85.218.53])
        by smtp.gmail.com with ESMTPSA id uj4-20020a170907c98400b00a599f876c28sm1356777ejc.38.2024.05.04.08.40.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 May 2024 08:40:42 -0700 (PDT)
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a59a9d66a51so91468166b.2
        for <io-uring@vger.kernel.org>; Sat, 04 May 2024 08:40:42 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWSQl2HzH1yYyxCFQibikVnyB0tLZcG3atfgADCN8oTdtBMlR7P1IOSi2kQwEUIY3hZICcATtTIbyEVDYgU/Wudbzb8Ga4JwGE=
X-Received: by 2002:a17:906:cf83:b0:a55:75f6:ce0f with SMTP id
 um3-20020a170906cf8300b00a5575f6ce0fmr3540131ejb.13.1714837242162; Sat, 04
 May 2024 08:40:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202405031110.6F47982593@keescook> <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV> <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner> <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
In-Reply-To: <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 4 May 2024 08:40:25 -0700
X-Gmail-Original-Message-ID: <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
Message-ID: <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
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

On Sat, 4 May 2024 at 08:32, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Now, during this TOTALLY INNOCENT sock_poll(), in another thread, the
> file closing completes, eventpoll_release() finishes [..]

Actually, Al is right that ep_item_poll() should be holding the
ep->mtx, so eventpoll_release() -> eventpoll_release_file_file() ->
mutex_lock(&ep->mtx) should block and the file doesn't actually get
released.

So I guess the sock_poll() issue cannot happen. It does need some
poll() function that does 'fget()', and believes that it works.

But because the f_count has already gone down to zero, fget() doesn't
work, and doesn't keep the file around, and you have the bug.

The cases that do fget() in poll() are probably race, but they aren't
buggy. epoll is buggy.

So my example wasn't going to work, but the argument isn't really any
different, it's just a much more limited case that breaks.

And maybe it's even *only* dma-buf that does that fget() in its
->poll() function. Even *then* it's not a dma-buf.c bug.

               Linus

