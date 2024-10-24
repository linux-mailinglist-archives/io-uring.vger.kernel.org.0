Return-Path: <io-uring+bounces-4011-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E7F829AF3B0
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 22:33:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 979F9282A25
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 20:33:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 019B6156C74;
	Thu, 24 Oct 2024 20:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kOXAYslI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE9F022B678
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 20:33:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729801996; cv=none; b=Scmv3c+Pf4C/oU29/zX62FZdOy2Z98hHW0yYd7IN+MyDdz8Qse/i1/K7KAkQrstOi1smA8bcyZCxmaem4Q8l+8LlLQrVVO7YTEtG8F4EjTOJgoFk4Hw5mxry3o4wpO3pDglb/UKn9u5gpyRKsNckkeyTJLSWwRQEnJ+1MD1i5a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729801996; c=relaxed/simple;
	bh=iUEGGEyartdExcsFCQleYeHMWXCfTQ+aAEwoOX5fQxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C8XffO6bWd55Pp7hR65z+EDHDdGbaOzJJcEp1ohx8c754APbAqUwg6Qn+KbYr3GwlbuUseCE4QOaZVbF+Yjna5obLLX/efH+ZpFYwMBUqIh6Navt1/vLNVI3evfnxVRVuef+DRHSXY4yC2WwelnksP1dbmXihpkZB3BMLi/N4F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kOXAYslI; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43150ea2db6so67365e9.0
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 13:33:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1729801992; x=1730406792; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k1Wi0mui0bqpk2smasaoHeXFjBTYf6PVWsVRefdMKhs=;
        b=kOXAYslIympUyifMR+nrVF4ZmdgLF+PCnaq10Am7llqSoGmqDkutoJwiU5ueTdTpaO
         EkZK2uOm+7AYIyGvaXOvRUSnEd9MjnuESWVrtPR2Zv6FSzsV0510Vp3x6WC7usFqgwcN
         NEBwpCa+/3h0zf+JPeEU9e98G1SgjSdD+SYkhRBsStywVSEh5GL8bHEdbRU3Qeoa35VL
         g7xiB2rRAt1VicdV49F8viH+zVFauyPdd0hYOClT4WbSuS/7U5Gb1RGbEmnvy0gUdMu0
         7T5BeSFKNPbXm1j2/UOjjvVWKDIXaipeZh+E7gsYPO53LET8LFn1I+F2B5Bgx5ekIHmC
         BsbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729801992; x=1730406792;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k1Wi0mui0bqpk2smasaoHeXFjBTYf6PVWsVRefdMKhs=;
        b=JdKJUEbH0wnzmVO6SCKT5qDISVlzLIfH0hte4CzWAufAhTggz76zc6S7D1tVV9KYlk
         xxw8+lpko7AkAFbx01qpFJjz6biYXGEr7o17i2YXJRQeQ/masGA+L+mGkxV+sLPlsPVC
         Bm8avT4kEyj9c734GuFERFdcBomrz3SbllP2O2pdN8oo70FfwtFjwawWhLujRMcHb6Xj
         YPbSP+dnSzA4KQZ1RqJ49hHznMWS2ejjAGFwqQzeqHRVo3HAbEFDZ1bx74/48JansIB6
         tR6/VfBIwOC+XFR5wmNIPcBSnep/Tr/j0DnyBgnO7f5Hhl2nruQASqiRjFmgCePoRoft
         b3rA==
X-Gm-Message-State: AOJu0Yz3zR2LB3MiFKLLox7EvsRInm+JGHJP1rOdyPcF2qxE2BDVcziV
	bm+MRpyf7suGeTkox+9ZsniuNv1djNmrHzK2W2L/yyEP3nwvTATYbQD08WX8pvLLFew4xVMQi3B
	QfGluHV8/yxB4sSk/WkYByjH5ZNgdY6I9/ntUEwMk/eOUl5NFNrhC
X-Google-Smtp-Source: AGHT+IGLJbBI/q/QnqvG8KKpv7nXpVRcXzJSdnAWwJ0y71m9REhL9DwgW8Er6OLQBPAL0vPoRCRUAHj6KgHZjYKcksk=
X-Received: by 2002:a05:600c:8719:b0:42c:acd7:b59b with SMTP id
 5b1f17b1804b1-431920e5745mr1063615e9.6.1729801991565; Thu, 24 Oct 2024
 13:33:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241024170829.1266002-1-axboe@kernel.dk> <20241024170829.1266002-5-axboe@kernel.dk>
 <CAG48ez3kqabFd3F6r8H7eRnwKg7GZj_bRu5CoNAjKgWr9k=GZw@mail.gmail.com>
 <aaa3a0f3-a4f8-4e99-8143-1f81a5e39604@kernel.dk> <CAG48ez3KJwLr8REE8hPebWtkAF6ybEGQtRnEXYYKKJKbbDYbSg@mail.gmail.com>
 <1384e3fe-d6e9-4d43-b992-9c389422feaa@kernel.dk> <CAG48ez2iUrx7SauNXL3wAHHr7ceEv8zGNcaAiv+u2T8_cDO7HA@mail.gmail.com>
 <a55927a1-fa68-474c-a55b-9def6197fc93@kernel.dk>
In-Reply-To: <a55927a1-fa68-474c-a55b-9def6197fc93@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Thu, 24 Oct 2024 22:32:33 +0200
Message-ID: <CAG48ez2MJDzx4e8r6AQJMVr9C8BC+-k1OoK8as0S7RD3vh8f6A@mail.gmail.com>
Subject: Re: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 24, 2024 at 10:25=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
> On 10/24/24 2:08 PM, Jann Horn wrote:
> > On Thu, Oct 24, 2024 at 9:59?PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 10/24/24 1:53 PM, Jann Horn wrote:
> >>> On Thu, Oct 24, 2024 at 9:50?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 10/24/24 12:13 PM, Jann Horn wrote:
> >>>>> On Thu, Oct 24, 2024 at 7:08?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>> Add IORING_REGISTER_RESIZE_RINGS, which allows an application to r=
esize
> >>>>>> the existing rings. It takes a struct io_uring_params argument, th=
e same
> >>>>>> one which is used to setup the ring initially, and resizes rings
> >>>>>> according to the sizes given.
> >>>>> [...]
> >>>>>> +        * We'll do the swap. Clear out existing mappings to preve=
nt mmap
> >>>>>> +        * from seeing them, as we'll unmap them. Any attempt to m=
map existing
> >>>>>> +        * rings beyond this point will fail. Not that it could pr=
oceed at this
> >>>>>> +        * point anyway, as we'll hold the mmap_sem until we've do=
ne the swap.
> >>>>>> +        * Likewise, hold the completion * lock over the duration =
of the actual
> >>>>>> +        * swap.
> >>>>>> +        */
> >>>>>> +       mmap_write_lock(current->mm);
> >>>>>
> >>>>> Why does the mmap lock for current->mm suffice here? I see nothing =
in
> >>>>> io_uring_mmap() that limits mmap() to tasks with the same mm_struct=
.
> >>>>
> >>>> Ehm does ->mmap() not hold ->mmap_sem already? I was under that
> >>>> understanding. Obviously if it doesn't, then yeah this won't be enou=
gh.
> >>>> Checked, and it does.
> >>>>
> >>>> Ah I see what you mean now, task with different mm. But how would th=
at
> >>>> come about? The io_uring fd is CLOEXEC, and it can't get passed.
> >>>
> >>> Yeah, that's what I meant, tasks with different mm. I think there are
> >>> a few ways to get the io_uring fd into a different task, the ones I
> >>> can immediately think of:
> >>>
> >>>  - O_CLOEXEC only applies on execve(), fork() should still inherit th=
e fd
> >>>  - O_CLOEXEC can be cleared via fcntl()
> >>>  - you can use clone() to create two tasks that share FD tables
> >>> without sharing an mm
> >>
> >> OK good catch, yes then it won't be enough. Might just make sense to
> >> exclude mmap separately, then. Thanks, I'll work on that for v4!
> >
> > Yeah, that sounds reasonable to me.
>
> Something like this should do it, it's really just replacing mmap_sem
> with a ring private lock. And since the ordering already had to deal
> with uring_lock vs mmap_sem ABBA issues, this should slot straight in as
> well.

Looks good to me at a glance.

