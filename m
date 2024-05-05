Return-Path: <io-uring+bounces-1765-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 50EED8BC39D
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 22:17:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 775A0B216D9
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 20:17:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D1BF76036;
	Sun,  5 May 2024 20:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b5h18K7m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8A5C757F3
	for <io-uring@vger.kernel.org>; Sun,  5 May 2024 20:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714940233; cv=none; b=KKeulVxKUy90jIDx4yWv+rvspCSG36wGTYBHuc7TV4I0cPLAM9vJu1mYbPJlEYcv66CpMZLuRBuHQcKwdfEJtX4OxwB2mEwX5Cz/Xir190HwPocgRDLCeZunnUtYFUfkc2bnoaO9RAjYYTcxCIVrayLULd/j0N609XZN1smCY9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714940233; c=relaxed/simple;
	bh=YVUUiZWgMhQe0Pv8Ng+UCkY3LYOanihQ0/5fJzF5CqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BjBmGU+r16icZU0LS9II7zZ82T0CzFpltVcy/wDtBIuZ3RcWLfi+dUcP3OXCs3NCjA+odIC5AtdqcHf6ZUyxqh6zj+w8RkFZNOiJNm67Of9dMIjU9MEfwaq9M7An8ywNf2y0F2VIOdToN4BiRRNbqAzL0WKRid6WOCcLWIY0UnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b5h18K7m; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52006fbae67so1629635e87.0
        for <io-uring@vger.kernel.org>; Sun, 05 May 2024 13:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714940230; x=1715545030; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=89jyKA3wApx9BQCfs5IiJWmwTiyjcjG5A1RQj5E06Fo=;
        b=b5h18K7m3n5CEV92Puk4rSxHAKhJuWHbsjJIAZRGzMvVH9DsE8uGKK1QPuoFjGB82o
         irx0kgv4Dt6l2g750MmxZdzYcXbhGS+v/AVLAaOkAjV5yH7+g/wxsYkAiaQjrND/CeB9
         iUDvijX//l6svzAkuN3CwdPhPetpXLFDDBHqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714940230; x=1715545030;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=89jyKA3wApx9BQCfs5IiJWmwTiyjcjG5A1RQj5E06Fo=;
        b=Z1DGjQMI8/oCmMM8N9UMAgjCknYfCFeEze8Cn77RAVpPI68sNlGSe2cmp1uEeMx1iQ
         KU1awD1o1kIXJiyey7ZVC2F/6arUKsGimkkMqLnFemYTXRTkYERlbrTXEfyr6JieHZUj
         qC7vbp+MCF84+HLSDsZdThlLq9xmb+zm/SpAshuy2MUkf7cHDb+P+yIjxSDLfxI84gGT
         cT6/dO9TGUDxjCtAqzf3tbkG/b/xhf/4GWRWUGrZWYEb8UdBvHn6QaQOiJszWZ/LKQUV
         UxItgH8O0cg4YzLSGip2JANb1FyzcCtUq9auEk0/XgxBfusyH3ElxRtveVyRUS/nSno6
         khGg==
X-Forwarded-Encrypted: i=1; AJvYcCW45aOn3JdVSylKeWD7NOZneVQmI2zuI3cpLNXhrpH9BXS4yZCiMu8djpKAX4it8pemUC9Ak1v8Mc1ex68BIYCKfBq4ZK0fuU8=
X-Gm-Message-State: AOJu0YzxOSGhV2hJBbmsK99VUY5OxBZElaWT3w8G+Y/oJTEIPHSY1jta
	83zQxFnE093b52qath+/v6zKq7j7VVmbT0V1JWY0ksPmWngKZA6XUyncK16KAP2vuSIyV7WUTwA
	qw1gwqw==
X-Google-Smtp-Source: AGHT+IFs5QqGzK6F/Med8cLDr+02aivWuumC8vixXFUW0sHF2i/QTNjZ4BJHaCU4jjL+fdzOAJ4KCw==
X-Received: by 2002:a05:6512:203:b0:517:8ad8:c64 with SMTP id a3-20020a056512020300b005178ad80c64mr5585331lfo.21.1714940229753;
        Sun, 05 May 2024 13:17:09 -0700 (PDT)
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com. [209.85.218.52])
        by smtp.gmail.com with ESMTPSA id q3-20020a1709060f8300b00a58a67afd2fsm4380981ejj.53.2024.05.05.13.17.08
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 May 2024 13:17:08 -0700 (PDT)
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a59ad344f7dso195738566b.0
        for <io-uring@vger.kernel.org>; Sun, 05 May 2024 13:17:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW+2WcvC+FaFGdPaxfdmafo3plVJnIq7eWZUmrHOFTQfT9VL5CJExxaYRU480Kj+dFFayN3WP99l2TYV6Gqfh4HzX0RuNfzf64=
X-Received: by 2002:a17:906:7188:b0:a59:cd18:92f5 with SMTP id
 h8-20020a170906718800b00a59cd1892f5mr599989ejk.11.1714940227970; Sun, 05 May
 2024 13:17:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>
 <20240505175556.1213266-2-torvalds@linux-foundation.org> <12120faf79614fc1b9df272394a71550@AcuMS.aculab.com>
In-Reply-To: <12120faf79614fc1b9df272394a71550@AcuMS.aculab.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 5 May 2024 13:16:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=whxLdB_P=nW1bmVKn1m2jdcZRgkMksfvA722toFpT554w@mail.gmail.com>
Message-ID: <CAHk-=whxLdB_P=nW1bmVKn1m2jdcZRgkMksfvA722toFpT554w@mail.gmail.com>
Subject: Re: [PATCH v2] epoll: be better about file lifetimes
To: David Laight <David.Laight@aculab.com>
Cc: "axboe@kernel.dk" <axboe@kernel.dk>, "brauner@kernel.org" <brauner@kernel.org>, 
	"christian.koenig@amd.com" <christian.koenig@amd.com>, 
	"dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, "jack@suse.cz" <jack@suse.cz>, 
	"keescook@chromium.org" <keescook@chromium.org>, "laura@labbott.name" <laura@labbott.name>, 
	"linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>, 
	"minhquangbui99@gmail.com" <minhquangbui99@gmail.com>, 
	"sumit.semwal@linaro.org" <sumit.semwal@linaro.org>, 
	"syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com" <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>, 
	"syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"

On Sun, 5 May 2024 at 13:02, David Laight <David.Laight@aculab.com> wrote:
>
> How much is the extra pair of atomics going to hurt performance?
> IIRC a lot of work was done to (try to) make epoll lockless.

If this makes people walk away from epoll, that would be absolutely
*lovely*. Maybe they'd start using io_uring instead, which has had its
problems, but is a lot more capable in the end.

Yes, doing things right is likely more expensive than doing things
wrong. Bugs are cheap. That doesn't make buggy code better.

Epoll really isn't important enough to screw over the VFS subsystem over.

I did point out elsewhere how this could be fixed by epoll() removing
the ep items at a different point:

  https://lore.kernel.org/all/CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com/

so if somebody actually wants to fix up epoll properly, that would
probably be great.

In fact, that model would allow epoll() to just keep a proper refcount
as an fd is added to the poll events, and would probably fix a lot of
nastiness. Right now those ep items stay around for basically random
amounts of time.

But maybe there are other ways to fix it. I don't think we have an
actual eventpoll maintainer any more, but what I'm *not* willing to
happen is eventpoll messing up other parts of the kernel. It was
always a ugly performance hack, and was only acceptable as such. "ugly
hack" is ok. "buggy ugly hack" is not.

              Linus

