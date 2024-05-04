Return-Path: <io-uring+bounces-1754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 033428BBD94
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 20:20:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 87F811F21A3A
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 18:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83AB371B30;
	Sat,  4 May 2024 18:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Wc0pulwu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA3B25FB9A
	for <io-uring@vger.kernel.org>; Sat,  4 May 2024 18:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714846843; cv=none; b=YmaS0F629fPuofktg6KDUpdS/yU4xXyhi0C9J+5b9HqEuiwxtTkllpGbq0cueoPiCAlA2v+hLAKmjXJ/b5ZDffIbEk9pMp1rzkoJpIiw+Bi0e88Eb3lPJUppt+rynQK0zaYQF12gHFJdli6r/eApHjqokS+VdgJA5DPYKOE+E7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714846843; c=relaxed/simple;
	bh=rAIZu+79Hh8VYj6yqYqrrAzdBZ74FGbLE5oKNi+7r5w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WEqU6e0ts46yKpKEYGCRfYOCuHNDdz1L7IBYLa0Qws8NdBTpa3/hXuVicmjdhDDFAEloM3sC9ZEI8Vi+wlQdMJ2CNMPifA+4RIwm+c6GgD+UtvbVRd2AL6b67ypbQPawRAffuC2qEgkETi3prPyuUaRV1SK/F1xdHliODFNnqqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Wc0pulwu; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a59afce5a70so71044066b.3
        for <io-uring@vger.kernel.org>; Sat, 04 May 2024 11:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1714846840; x=1715451640; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TbTAb0O3vIVxVEVAX+Kz3ISBhu7sYKvIouph0u6S16I=;
        b=Wc0pulwuFuYqLkVN8EBjCsAzlb5rNkEWGbvBUzAJWJqiykGiFmiuBI/b9qCCtky7iz
         xyMvgD+XcTH+QOBjnki3IFxFQC3BZCBJemate6AvSmkzpbSgfjRE32oeX3Jnv4VYW8Wh
         CF3x2DTn1BiDi3TWNl4FGqLhh16aMlDRLKD0k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714846840; x=1715451640;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TbTAb0O3vIVxVEVAX+Kz3ISBhu7sYKvIouph0u6S16I=;
        b=F0YDOxC33N9GBATuYsyCyx5rytJR2XWC0N4nMbzse+iPNgRBf33Y2Za5v4IVdLT+Md
         VJgppV+TwPDLPH12URh3m/bnM65as7nN6fzJGcOW9F1axSJYbVUP/yfCeAOFCmHKHYEZ
         EkNDidgPtfQIbjUhfCTRxcucHe3COTQaO8SPR95kyy9NK8tmxZNLgkNhuhdK9WB5k1SU
         bntjxtHpVG5EJ/AfnrXua1dO2MB/4sss/3P+zanAXx4Ldd9WaJBEIPTr2+8NFI1J9EmT
         aSJJwmyQzhBreXhXz23twWPhybJjGm7N46BdH188fd92ogvEEejnRLZVsbCvNMkMdeFI
         Mo1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVwJBZqyl36KzcdXTaE/VpY6zAhlo4OTnYgAMUo9oRtYF7daEAikk6GGfYsAMooY2VP8peT5MoeJoS+uzmvqLAOvtCvKWtXfQI=
X-Gm-Message-State: AOJu0YypzgY07zUWSgCsWQ1yMzni5zkppiDvZGJ/1zv+t+tn3RhkG2QI
	lYZLdua2ms28WP76gjM8PMonw2eYzxhFevTifOCX17JPzUziSobDeJIz7rrAi7B3dXgaijJVQvR
	wybeUHw==
X-Google-Smtp-Source: AGHT+IHj+nvHOdKX1iFI302RxLrfunet+pTtc2Uk53WzMCHPyNWC0aJnmoOWYLAvmJLrD1MEgjbxfg==
X-Received: by 2002:a50:d71a:0:b0:572:9f60:783d with SMTP id t26-20020a50d71a000000b005729f60783dmr3750492edi.36.1714846839865;
        Sat, 04 May 2024 11:20:39 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id en18-20020a056402529200b005721b7bfea2sm3111846edb.22.2024.05.04.11.20.38
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 May 2024 11:20:38 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a59a0e4b773so145006266b.2
        for <io-uring@vger.kernel.org>; Sat, 04 May 2024 11:20:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUYdA2HkOIJlGx+cBx8VVgEmTOOgscZ6s3dRdviEjxNdl7kCkBXH7xBjwDaMpLxKreCxFYohUtE9gs3eHWH1RSk1Sd848lJrtU=
X-Received: by 2002:a17:906:e90:b0:a52:1e53:febf with SMTP id
 p16-20020a1709060e9000b00a521e53febfmr3945377ejf.69.1714846838331; Sat, 04
 May 2024 11:20:38 -0700 (PDT)
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
Date: Sat, 4 May 2024 11:20:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
Message-ID: <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
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
> Lookie here, the fundamental issue is that epoll can call '->poll()'
> on a file descriptor that is being closed concurrently.

Thinking some more about this, and replying to myself...

Actually, I wonder if we could *really* fix this by simply moving the
eventpoll_release() to where it really belongs.

If we did it in file_close_fd_locked(),  it would actually make a
*lot* more sense. Particularly since eventpoll actually uses this:

    struct epoll_filefd {
        struct file *file;
        int fd;
    } __packed;

ie it doesn't just use the 'struct file *', it uses the 'fd' itself
(for ep_find()).

(Strictly speaking, it should also have a pointer to the 'struct
files_struct' to make the 'int fd' be meaningful).

IOW, eventpoll already considers the file _descriptor_ relevant, not
just the file pointer, and that's destroyed at *close* time, not at
'fput()' time.

Yeah, yeah, the locking situation in file_close_fd_locked() is a bit
inconvenient, but if we can solve that, it would solve the problem in
a fundamentally different way: remove the ep iterm before the
file->f_count has actually been decremented, so the whole "race with
fput()" would just go away entirely.

I dunno. I think that would be the right thing to do, but I wouldn't
be surprised if some disgusting eventpoll user then might depend on
the current situation where the eventpoll thing stays around even
after the close() if you have another copy of the file open.

             Linus

