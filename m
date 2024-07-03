Return-Path: <io-uring+bounces-2437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C8ED9268C2
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 21:01:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDBBD1F2214E
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 19:00:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FA72178367;
	Wed,  3 Jul 2024 19:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="iC1YdN+4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B42C41E22
	for <io-uring@vger.kernel.org>; Wed,  3 Jul 2024 19:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720033256; cv=none; b=iBpsXksMdF0ZqdudTpc7yGp7xUv7Nk4M8o7ok7t5iC7n4dO60UT7wEgLjfDNYFgJxwXvV/yM9XBfTkOErn31K6JViaLtQ4+4O+5FFccXnHMMigdqUYGbOCuU8Wh5DWFcJg8XnH66CkqjntWGHY/7qRrwqv/gKcGTAsT+w2qFd00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720033256; c=relaxed/simple;
	bh=UYxPNFpMcGneQ/ECP3GOas6d4yYi/uC/3SPT66tF62M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qjZPf27YHqgq6EzmOauQuMKIgtIGWqqNzLRc1VrnO2RLPVBoLJC6ynDM/b+iC5Nq9gp7DN+8Q0VSN3JZplxN668fIiGdi0/3diHo1qHowDwTsNhWLuXSQawJFAX4SvBG6z9tc/HZMjOAWN16kcSay2qeGJkFb76ndpBSAzmJkbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=iC1YdN+4; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2ee77db6f97so30844401fa.2
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 12:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720033252; x=1720638052; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=AwbTD1jwFh01l2fYaG95Vp8QD2DPYGRJu95WiulxKsI=;
        b=iC1YdN+46N0nzCuhqPmjLYM5a/VWO7I2vT3QvE5YrQfTGoH4liZmc5J9MGr5ecFSoD
         Q5aU9Q2nzVQhP1JyugJFrEo47s+TmOylWR/GCNX7r77TIrssdEyzKVQQZZW0XM5k1cFQ
         TJ0VxFY7GIzZbdPkNfIxYYKO1fNeRBA31QafA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720033252; x=1720638052;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AwbTD1jwFh01l2fYaG95Vp8QD2DPYGRJu95WiulxKsI=;
        b=Taxcn01Bg/oUplmb+rOQUdeRa9rJVzxjJo3kjowCEoOfU93QGSzeDb9LyTl+G7f8Ms
         Z6wH639K/UYDD3RrGZLCn9OtC/5uSQlblTTxxm9swXU4nwvZ0mrbSGw6ZmddOLlXe4ue
         p/SNfcHub54s1HngzZFiDyv6ZzzSnELqMJvJEbCOp67iAWHJJSQwZzTmCTm/NSkZWM84
         1hwF3LWmbjoOH5VlkDWHPTGxSqgvNTHBopT/d+ku+fgVufUguVWnfK8aoj8gJd2M5iIk
         pC26Cm523SzhU0RqIUiQotLjOjleXuxb3M5SYun9ESmChUNjHcCirDyG5pc4szT+vuk1
         rQhg==
X-Forwarded-Encrypted: i=1; AJvYcCXzQf598NTJDTrbnwx28EDTloIPmliUqCprfVL1YYgomKnweIYRgaw/xTUP+akWi9WnEnirmn3c+iEG4hQQw/aYXwmpXVxsqLA=
X-Gm-Message-State: AOJu0YycO5+BVY9seU1pev9wgLKFne8Z4cdUboQGV6LoVbYWcQ0Uf+EQ
	jFUM2YLMlwzumcqGpMKPTHn2KJWp/2dnjUZriAO690cBACeXR1OhahWmfWfLl/MC1AOVGDkCHTz
	2eg4LxA==
X-Google-Smtp-Source: AGHT+IHOoQOkOIhhQ65VsEpAitWktZS0TlGiIruYuWyhcdD8UAID/ToLFjtsT6RRvpBYb635vD7EbQ==
X-Received: by 2002:a2e:bc88:0:b0:2ee:7a54:3b14 with SMTP id 38308e7fff4ca-2ee7a543b8dmr43739151fa.7.1720033251966;
        Wed, 03 Jul 2024 12:00:51 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ee53c1718asm19650521fa.42.2024.07.03.12.00.50
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 12:00:50 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2ee75ffce77so28440501fa.3
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 12:00:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWZRlOJzO/4RsuNV7kPqjz20UC/50O5ZyZha3aQWbTlR24M7ncKrv0C309+okB/3ZgAl+QtIOuXch2HwVrUSLpan/TLjc3rZEk=
X-Received: by 2002:a2e:a7c9:0:b0:2ec:56b9:258b with SMTP id
 38308e7fff4ca-2ee5e6f60femr110934241fa.33.1720033250138; Wed, 03 Jul 2024
 12:00:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
 <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com> <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
 <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
 <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
 <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com>
 <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
 <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
 <CAHk-=wii3qyMW+Ni=S6=cV=ddoWTX+qEkO6Ooxe0Ef2_rvo+kg@mail.gmail.com> <20240703-begossen-extrem-6ed55a165113@brauner>
In-Reply-To: <20240703-begossen-extrem-6ed55a165113@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jul 2024 12:00:33 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgCttiyp+3BBzhqKv+uXuUr-fzw2QbmH8kXwO+sB+FAaQ@mail.gmail.com>
Message-ID: <CAHk-=wgCttiyp+3BBzhqKv+uXuUr-fzw2QbmH8kXwO+sB+FAaQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Christian Brauner <brauner@kernel.org>
Cc: Xi Ruoyao <xry111@xry111.site>, libc-alpha@sourceware.org, 
	"Andreas K. Huettel" <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 11:14, Christian Brauner <brauner@kernel.org> wrote:
>
> In any case, which one of these does a new architecture have to add for
> reasonable backward compatibility:
>
> fstat()
> fstat64()
> fstatat64()
>
> lstat()
> lstat64()
>
> stat()
> stat64()
> statx()
>
> newstat()
> newlstat()
> newfstat()
> newfstatat()

Well, I do think that a *new* architecture should indeed add all of
those, but make the 'struct stat' for all of them be the same.

So then if people do the system call rewriting thing - or just do the
manual system call thing with

    syscall(__NR_xyz, ...)

it is all available, but it ends up being all the same code.

Wouldn't that be lovely?

Of course, I also happen to think that "new architecture" and "32-bit"
is just crazy to begin with, so honestly, I don't even care. 32-bit
architectures aren't really relevant for any new development, and I
think we should just codify that.

And on 64-bit architectures, the standard 'stat' works fine.

            Linus

