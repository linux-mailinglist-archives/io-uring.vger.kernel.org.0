Return-Path: <io-uring+bounces-1725-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B4448BB5AE
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 084B21F24E25
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE0A15B5B8;
	Fri,  3 May 2024 21:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ft2VMkuz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB495A110
	for <io-uring@vger.kernel.org>; Fri,  3 May 2024 21:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714771507; cv=none; b=ES+CoxV4P7+OkRr/iLLjbCedXKcoHBNqLwDBffg1DAA9AYay+oVSboa/mkXpqkKIsVheWVKHgTgVU8YWNvDlUGKAdtGWZR/3OX4VZ76or72CfPPUcXRJwsyQrJcRtUyYwbh0p1jZdYHE7FHBsLgWFIlATe4hly86H15PildRt7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714771507; c=relaxed/simple;
	bh=N4MV6W6kLCjF7hioiCGBWf5TZPj+wehXzH5NmRppkU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T/JMlZvekX8d/D57U+jKkFFLOUcTwRHZtVK/cl38dfSRe6RMJJT7D9/i20Ty+I2EDWZ4891iJ4P5NeIBej/IidbwSvtB8kdlu9DnCIPzCG8HpKr9m2l2XcOSK89iUYCQpBhzMT3OMqrBqSCRqS4d0DlCxogDmuIvPC6wM4e3PvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ft2VMkuz; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-2df83058d48so1242871fa.1
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 14:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714771504; x=1715376304; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fhxz4aHpmXZJ6K0C5hNTESMtOJDx3oTLGnKkbndye9Q=;
        b=ft2VMkuz+l7vHGHn5A9ijcLbpznRqGHogQhm0BybeprsfPPT4cJ2+FJo+mQyi3iWdh
         tbMhs0d7vkf0pNMC+oYWALBHIM/O7LqRTUvlhEVc3lKrrHE0fYuUEmrUM+0Oq57HqwEw
         eNVCy91hpg8JX4bBokZdO3f3cmT3v6+c90Xag=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714771504; x=1715376304;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fhxz4aHpmXZJ6K0C5hNTESMtOJDx3oTLGnKkbndye9Q=;
        b=M/jeQD/OU1UUVPGFF4RFlau9iqx37CzxxmHFBFYaj2CGCXqlWvtFH9WCV6DTNS21kO
         D/U9G0NhGRvRc3OFGMl77L9uaD5gFR4prAIzp1giywypW5eK2L5syfu8YoavtlW8rb1U
         71FGkBuuaWVzaSUZkac8j2vxvo8velIVz2gIJpLiLZjgyaEqMnpYNto49/v0GHsLFVCb
         TfMTayBqmN/edLlpqHKL9x3aFYcPFuAwvlSo46hipradbsNleB6OLeFtXZFozfX/gfP1
         Qm904ODPk7HDit/EWNolmqVkfqZzSxq/zhBhrWchhIJLyzBVSbmKh4eCqsAHMQQzuJoq
         tyGg==
X-Forwarded-Encrypted: i=1; AJvYcCVA/6chwt/a3POfpRk9CUoqVp7mxz8GZ89/121bb2mfKw7ynJq2PqlblW+mtppK9NLo03VeSOyVezuXMT/QdcPTdX1H4tSPqPM=
X-Gm-Message-State: AOJu0YxNVOXRIwDZW2Kpn/QUE+1E5fzI+k5o83y07IYO9UXxylBNdDw2
	ssALa2RaEhzvFzx3c4HZZVK8yDDbI3MTSOpKhZHABjAkYmQMjd5Xhdkbsei+Af/Ysu/Lzr7aQok
	3m2gEGw==
X-Google-Smtp-Source: AGHT+IEcVEeldxaVL2xl0QtiICGg8BErhjAeqLqSiitpE32pApp1Dn+VbiSe1PfXhCRcRE9tMlc+gw==
X-Received: by 2002:a2e:a6a1:0:b0:2e1:cb22:a4d with SMTP id q33-20020a2ea6a1000000b002e1cb220a4dmr2079361lje.36.1714771504253;
        Fri, 03 May 2024 14:25:04 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id d3-20020a2e96c3000000b002e1b7d2c506sm632030ljj.44.2024.05.03.14.25.02
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 May 2024 14:25:02 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2e20f2db068so1149141fa.2
        for <io-uring@vger.kernel.org>; Fri, 03 May 2024 14:25:02 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUfhM/yvoQpFfAw+eKolw1dOGZI2CO6aDvwyQluXB6PIJjNxk/Gk6xBuMm3GkbXCX7hQCVSQ/8kaFWPus2JowIxCaxT70L2JHU=
X-Received: by 2002:a19:381a:0:b0:51c:68a3:6f8e with SMTP id
 f26-20020a19381a000000b0051c68a36f8emr2449065lfa.31.1714771502428; Fri, 03
 May 2024 14:25:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0000000000002d631f0615918f1e@google.com> <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
 <202405031110.6F47982593@keescook> <64b51cc5-9f5b-4160-83f2-6d62175418a2@kernel.dk>
 <202405031207.9D62DA4973@keescook> <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>
 <202405031237.B6B8379@keescook> <202405031325.B8979870B@keescook> <20240503211109.GX2118490@ZenIV>
In-Reply-To: <20240503211109.GX2118490@ZenIV>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 3 May 2024 14:24:45 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj0de-P2Q=Gz2uyrWBHagT25arLbN0Lyg=U6fT7psKnQA@mail.gmail.com>
Message-ID: <CAHk-=wj0de-P2Q=Gz2uyrWBHagT25arLbN0Lyg=U6fT7psKnQA@mail.gmail.com>
Subject: Re: get_file() unsafe under epoll (was Re: [syzbot] [fs?] [io-uring?]
 general protection fault in __ep_remove)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>, 
	Bui Quang Minh <minhquangbui99@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, Laura Abbott <laura@labbott.name>
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 May 2024 at 14:11, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> What we need is
>         * promise that ep_item_poll() won't happen after eventpoll_release_file().
> AFAICS, we do have that.
>         * ->poll() not playing silly buggers.

No. That is not enough at all.

Because even with perfectly normal "->poll()", and even with the
ep_item_poll() happening *before* eventpoll_release_file(), you have
this trivial race:

  ep_item_poll()
     ->poll()

and *between* those two operations, another CPU does "close()", and
that causes eventpoll_release_file() to be called, and now f_count
goes down to zero while ->poll() is running.

So you do need to increment the file count around the ->poll() call, I feel.

Or, alternatively, you'd need to serialize with
eventpoll_release_file(), but that would need to be some sleeping lock
held over the ->poll() call.

> As it is, dma_buf ->poll() is very suspicious regardless of that
> mess - it can grab reference to file for unspecified interval.

I think that's actually much preferable to what epoll does, which is
to keep using files without having reference counts to them (and then
relying on magically not racing with eventpoll_release_file().

                Linus

