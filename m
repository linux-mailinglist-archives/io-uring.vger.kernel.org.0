Return-Path: <io-uring+bounces-1795-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F1E68BD48A
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 20:24:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 918CC1C20FE0
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 18:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85F7F15887C;
	Mon,  6 May 2024 18:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FSQQ8hK8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B1DE13D50E
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 18:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715019856; cv=none; b=AK9A3cYn8/x/TPK8FX/l0EdJmAuFjimuZB1Jz2A/KCy9v17bL8ZnjQKCVHCsgvmz5P/lizHjLSwdpLt0Trx9V5mhj919RwpGExGTXSSQPZJh7850VsEPvm0qxebLkCKJuaEhfAGC6wpBiLFDUq4HXmKjvHu7GBOf06KxQq0n7Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715019856; c=relaxed/simple;
	bh=J58UG9l/MEB8rWLccvOKjiXOqbcr3dWlMVB6Uc18RIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QrZDihkHyKlKc+0fYDejN9gn/ZDVjEfFhZMgPwrCpa4Ul7kTqr0LqszKGZ5QUW/vwwG251m+ihhoVq7bSG4+ObGTi3/7XKgpNSzc6NoK9YPAgqEGVRNyafgXHiWuIiaL0cG/+hq8HZ9zMrfa6SRRgqzJnLfHEoBH/2HZwD8u0AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FSQQ8hK8; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2e1d6166521so36994401fa.1
        for <io-uring@vger.kernel.org>; Mon, 06 May 2024 11:24:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1715019852; x=1715624652; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6q7UkdOxzhbeF8E3EB8/oVmwWLDDbJfhhsW1gzY2H6M=;
        b=FSQQ8hK8xCfSnpR670cc+msmXUM5l24Okj6CwA4GSlRJDuA3WqYqL1nGDsWAJuRkDE
         NRqeQ1t/njV9Wd4RCGSARV9Yx7jMaZoqtp+rxaGjr9DyU7k5oiSd2Tc8/frEuFp4k7Ue
         5nJ1m8ueZKiBpHNbJncQeF6mU4uoPz7RR86Zo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715019852; x=1715624652;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6q7UkdOxzhbeF8E3EB8/oVmwWLDDbJfhhsW1gzY2H6M=;
        b=bazBVq/Jf+S+QRQC+2QxOFbk1ew72GfUyQ7FV4ld9QEoRjYG0nNUHftFO/kpVMWgti
         dvKhlSfKl8LqkgQsnZ6gSgSICk6RcA7rWHcqiW4iRFQ0wTvclsSGHFmugmYEg6gi2TqW
         X/DyAxFJgm6yphzspoaQW2ja7J9b1iTjtxJ4ZkSF1ZYubMbm7TjGXAXuY3hEjXESudhb
         yjPAgZ7GrYBnr6E4eActcDfFSPImpwYzuldU/KgjgLMk2PLzMO/ahvZaYUqax+sCj+Xo
         7ANVHGG/4boUgigZiJZ92ZUiulJTRrhUPoNgB+3M8VA4IPYn2VvUFJLGx1LmMDPFjU1u
         gzXw==
X-Forwarded-Encrypted: i=1; AJvYcCU2ozfM2UQ8K3Naditb0a5vrXcNvqhkuOYrZ2WuN3heWh9vkKUENmDoJkv/eICa1Y9m7pLz72qJ73RSPw3v/bbf58MHLQG5s/4=
X-Gm-Message-State: AOJu0YzSCBQIykY6FHaQytArc2ztMWyWYaa8N44yXPFGL1yUxtxFcq0j
	y0xUxxu7nljL5lIt/v1TmqwtyrvF56+xTlR6MHObw1HYTBdtZCMtmMv7GYyIdj8AUzQCs8HmzYO
	VX10oPg==
X-Google-Smtp-Source: AGHT+IGxVq7sckXi2Kr9hT3dfTHtRF9IT8m4ZNNw5OdkT4T242cwLNXTVg9LI/JTD216wuqEgiNTQA==
X-Received: by 2002:a2e:9257:0:b0:2e2:2986:72da with SMTP id 38308e7fff4ca-2e3d9459b51mr1400991fa.7.1715019852323;
        Mon, 06 May 2024 11:24:12 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id s7-20020a2e81c7000000b002e1bc0bcfc0sm1705059ljg.52.2024.05.06.11.24.11
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 May 2024 11:24:12 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2e2b468ea12so21080291fa.1
        for <io-uring@vger.kernel.org>; Mon, 06 May 2024 11:24:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVpTKieidT5C+7T2KY/G0PKfi8/CAP6Cqn7Z7W47OXQLQO4U2ToV7JEqTgxqHXaUDkS4L16qJXwdEo0G7kIDpXlYAIqH8warek=
X-Received: by 2002:a17:906:e49:b0:a59:91a0:df46 with SMTP id
 a640c23a62f3a-a59e4e862d2mr29381966b.31.1715019487019; Mon, 06 May 2024
 11:18:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000002d631f0615918f1e@google.com> <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
 <202405031110.6F47982593@keescook> <64b51cc5-9f5b-4160-83f2-6d62175418a2@kernel.dk>
 <202405031207.9D62DA4973@keescook> <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>
 <202405031237.B6B8379@keescook> <202405031325.B8979870B@keescook>
 <20240503211109.GX2118490@ZenIV> <CAHk-=wj0de-P2Q=Gz2uyrWBHagT25arLbN0Lyg=U6fT7psKnQA@mail.gmail.com>
 <501ead34-d79f-442e-9b9a-ecd694b3015c@samba.org>
In-Reply-To: <501ead34-d79f-442e-9b9a-ecd694b3015c@samba.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 6 May 2024 11:17:50 -0700
X-Gmail-Original-Message-ID: <CAHk-=whBVkwFryz5-DOAxNKYOy5RwPpQkZHQSs1Oe806Xo6yeg@mail.gmail.com>
Message-ID: <CAHk-=whBVkwFryz5-DOAxNKYOy5RwPpQkZHQSs1Oe806Xo6yeg@mail.gmail.com>
Subject: Re: get_file() unsafe under epoll (was Re: [syzbot] [fs?] [io-uring?]
 general protection fault in __ep_remove)
To: Stefan Metzmacher <metze@samba.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, 
	Jens Axboe <axboe@kernel.dk>, Bui Quang Minh <minhquangbui99@gmail.com>, 
	Christian Brauner <brauner@kernel.org>, 
	syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, Laura Abbott <laura@labbott.name>
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 May 2024 at 10:46, Stefan Metzmacher <metze@samba.org> wrote:
>
> I think it's a very important detail that epoll does not take
> real references. Otherwise an application level 'close()' on a socket
> would not trigger a tcp disconnect, when an fd is still registered with
> epoll.

Yes, exactly.

epoll() ends up actually wanting the lifetime of the ep item be the
lifetime of the file _descriptor_, not the lifetime of the file
itself.

We approximate that - badly - with epoll not taking a reference on the
file pointer, and then at final fput() it tears things down.

But that has two real issues, and one of them is that "oh, now epoll
has file pointers that are actually dead" that caused this thread.

The other issue is that "approximates" thing, where it means that
duplicating the file pointer (dup*() and fork() end unix socket file
sending etc) will not mean that the epoll ref is also out of sync with
the lifetime of the file descriptor.

That's why I suggested that "clean up epoll references at
file_close_fd() time instead:

  https://lore.kernel.org/all/CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com/

because it would actually really *fix* the lifetime issue of ep items.

In the process, it would make it possible to actually take a f_count
reference at EPOLL_CTL_ADD time, since now the lifetime of the EP
wouldn't be tied to the lifetime of the 'struct file *' pointer, it
would be properly tied to the lifetime of the actual file descriptor
that you are adding.

So it would be a huge conceptual cleanup too.

(Of course - at that point EPOLL_CTL_ADD still doesn't actually _need_
a reference to the file, since the file being open in itself is
already that reference - but the point here being that there would
*be* a reference that the epoll code would effectively have, and you'd
never be in the situation we were in where there would be stale "dead"
file pointers that just haven't gone through the cleanup yet).

But I'd rather not touch the epoll code more than I have to.

Which is why I applied the minimal patch for just "refcount over
vfs_poll()", and am just mentioning my suggestion in the hope that
some eager beaver would like to see how painful it would do to make
the bigger surgery...

                   Linus

