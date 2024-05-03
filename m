Return-Path: <io-uring+bounces-1738-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B3D7D8BB812
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 01:16:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4B90A1F21432
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2362083A1E;
	Fri,  3 May 2024 23:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SkbmRUnH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 343735A4D1
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 23:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714778196; cv=none; b=QDYSq2CCc5LJGjoPRzXTl5bn3TSHRJnXmmf/l5zI1IWXjHyvRLTIeoaTqEjs0ixP8LSex6xWdLp8qV1rkWIr5NWQWBJFprdgvnbjWXiKD1RTP15l2XMuU78jPrr3YYPj68qQq8JrHOcemuYJoeBwEkb88np+mN/Y6MtkDdu3JJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714778196; c=relaxed/simple;
	bh=10Im6Ev0hm6GCexrKsrsuAqt7UP5HFJ90hGsgvNShJo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mpzbZ/trUjir9le3I7Rayu7OZ0KZ2nSTnE3jxMO+80SOA1eePuI9gIOB9ZocMGBDNkpd7XgjzQJr6Wxi6ZoYOt/CxmQVJDmAbCJ1HqFuEHdjLotGdxx6x52YxKeskW/en0+iad5rXSQt1cQtdKdJoUdKpSFd42eS/QYepqC2/kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SkbmRUnH; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a598e483ad1so26423966b.1
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 16:16:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714778192; x=1715382992; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=cGG/rn4AzL6EAyTxraRF01dNEmbt6QApJhVwyWVeemo=;
        b=SkbmRUnHnf5SNIXEFlHD03edue6CNKGc7IAHBcHf8wyW6hBzbqutO4DOFiCZt4+UNm
         ZswFDydX3YZATn5j8RwngOhdnozLfRn32BHbz/pYxwrTozR/D4r99Z0uTj9Yl4zHIkdd
         4lFgMwWo6FNQkPxz8z/QgHwsAO8mA07RWNy54=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714778192; x=1715382992;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cGG/rn4AzL6EAyTxraRF01dNEmbt6QApJhVwyWVeemo=;
        b=BYd4JEn8EMryOhFqauEfgTMKF6CmqB/YSUlnGOlp5JOgnqmo8R27OoTF2M9JMltqI9
         PvpDB1IHy3MYOT1JqXr2OfavvkuTXQdMGkWbWxXfwmpYqUmVrnC4/jmYErHogwcVUS2s
         FzZLRuHc5hgsj//12my5a+BgH+tlrHx7IRHx8E40z7FXSf25vjLZ6oZKWusnXssyNM3F
         ldenvdOA0Fiu5tgdw5COxH0jdnLlnyCa4LlPyHYNmi3CQjZhwzYXGYKPihcTJ4LxtFb3
         2ioi8ZcSBjYUPjIKG9QSeLH3Iv8HY6lQitSyBF7iKvk3M4nJNZmabrTQkjjsQ7r8mwbZ
         a3og==
X-Forwarded-Encrypted: i=1; AJvYcCWGuuh5q9RXBiqUi0dDsh/kv+h+gPUp+EqdRzyFtSX5XLBEGV7gfIMMlO2UT4XD0gZ/C+hIXgHPYGPeGYcviojJW/u9K/xc3oU=
X-Gm-Message-State: AOJu0YyaFhJy7Fq5J10qnB7pcpr3UXMVnoH0kqZY5bFAtx42+Q0ph+/L
	c9FFJsaNkbgvbHN6Xb5cXqr8+g2WP1NvrUI/AshFuKZ0Et3/onPryc5K21cw+1NlpBKGVz9gtvb
	iHpTcWw==
X-Google-Smtp-Source: AGHT+IEdfwj+Qz23q2KP5tHaC92jckay0m8zb6Da6bIZBGl4gbXlNoWqEV+d+oyPaGdL+Vxo/xvBVQ==
X-Received: by 2002:a17:906:3e02:b0:a55:adec:7139 with SMTP id k2-20020a1709063e0200b00a55adec7139mr2218824eji.60.1714778192620;
        Fri, 03 May 2024 16:16:32 -0700 (PDT)
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com. [209.85.218.47])
        by smtp.gmail.com with ESMTPSA id gh13-20020a170906e08d00b00a58bf434876sm2238311ejb.58.2024.05.03.16.16.32
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 16:16:32 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a599a298990so27258566b.2
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 16:16:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVGiSrxbF0UK2zjm1Hv2V+XjcHkKumW8B5REJOJJI5CEa2619WR9BjRcsGAYfCAmmKOIGX65rFZZHvMF1OU1uTO+qP5+k4y5xw=
X-Received: by 2002:a17:906:52c1:b0:a59:2e45:f528 with SMTP id
 w1-20020a17090652c100b00a592e45f528mr2851931ejn.38.1714778191864; Fri, 03 May
 2024 16:16:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202405031110.6F47982593@keescook> <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV> <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240503214531.GB2118490@ZenIV> <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
 <20240503220145.GD2118490@ZenIV> <20240503220744.GE2118490@ZenIV>
In-Reply-To: <20240503220744.GE2118490@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 May 2024 16:16:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=whULchE1i5LA2Fa=ZndSAzPXGWh_e5+a=YV3qT1BEST7w@mail.gmail.com>
Message-ID: <CAHk-=whULchE1i5LA2Fa=ZndSAzPXGWh_e5+a=YV3qT1BEST7w@mail.gmail.com>
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: keescook@chromium.org, axboe@kernel.dk, brauner@kernel.org, 
	christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, 
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 May 2024 at 15:07, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Suppose your program calls select() on a pipe and dmabuf, sees data to be read
> from pipe, reads it, closes both pipe and dmabuf and exits.
>
> Would you expect that dmabuf file would stick around for hell knows how long
> after that?  I would certainly be very surprised by running into that...

Why?

That's the _point_ of refcounts. They make the thing they refcount
stay around until it's no longer referenced.

Now, I agree that dmabuf's are a bit odd in how they use a 'struct
file' *as* their refcount, but hey, it's a specialty use. Unusual
perhaps, but not exactly wrong.

I suspect that if you saw a dmabuf just have its own 'refcount_t' and
stay around until it was done, you wouldn't bat an eye at it, and it's
really just the "it uses a struct file for counting" that you are
reacting to.

                Linus

