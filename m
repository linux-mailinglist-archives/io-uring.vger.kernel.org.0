Return-Path: <io-uring+bounces-196-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CCE2E8012EA
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 19:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83255281E4F
	for <lists+io-uring@lfdr.de>; Fri,  1 Dec 2023 18:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 135A34F8BC;
	Fri,  1 Dec 2023 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gJh5Bp2G"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7571910D7
	for <io-uring@vger.kernel.org>; Fri,  1 Dec 2023 10:40:44 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-54c79cca895so4a12.0
        for <io-uring@vger.kernel.org>; Fri, 01 Dec 2023 10:40:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701456043; x=1702060843; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WkVHqNvonNn8A5RdXCNM0KGca3KT1K9/6epU/Ala7ns=;
        b=gJh5Bp2Gq+zevHlFu7FzvXMLs/Dr6P8fJ86RAC/FgyO8UzEXlxo3OY+HPn29N9cUDM
         I5Gryuusox6WflgyVQ92N7v2DHj1Xg6utmR6NCKn0gr353JVS7t5I6UBgQnZDib4o1Fi
         fMPGeHpCxOq1adthQw/URIRsEupe3BqbGUJhyFNUcqI//xtjXDd/HF2Fe8Odqj6xxe1m
         uhUVMsUugsdltseN4pY3aMz87z1t2QpRo03OYfAe9cs6KlWRZzgBPNLQrVAou9DIRAuy
         YYsFXM3CkHHGuszmOII0pAqWD/UJAVV1YwcoVtgxy4MU1dAL42q9YBZ39ZzhH+2f2nRR
         jx7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701456043; x=1702060843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WkVHqNvonNn8A5RdXCNM0KGca3KT1K9/6epU/Ala7ns=;
        b=jZZBd9OHrOagGwe7Hv0TiHEAbzEvaW6TtUwMujgy+k1vtm03Ax0bgBBYmcIMefrGpV
         qDK52WN/v1Jb99192ryN4Sw+1Sm45YqwJgA9LFB+Qn/FBvrrH9WSYAGinSa/HB3GaerX
         KZay2un7fpDsBFGY3Kj4nPHlZniZif9muHnHmAi5/UrHvKzGMgGysg5ds3X4SDx2TkhB
         cfySQhT6+z22vdRJ3wxpHI763xBJ+027RPwz2DTY8E4gJ7KGhOoufbs0vgOopS/Dbtli
         3EVodq/Qrucb0X6wKNLKC/5s6maOS2fwQ/tvO4R3wT2g+vdDyg6oACQewlqQeQh+kaqf
         06Zw==
X-Gm-Message-State: AOJu0YyaDR6o6E+5GenWcjgRIoXMqobg/HvGbxl6/rYjhdKQH3jXa+lz
	7A4s64yBMxvRojaSedessAJTgM1RHOmGE6tHffjB5g==
X-Google-Smtp-Source: AGHT+IHFucvwGuwgf6CWwT0KxM9o15mQSPjEtFtLdi2XRjUgtzKITMVco+W+TyDdXuCWjtgGx7pIOKvxPeuX3lZfkVw=
X-Received: by 2002:a50:aacf:0:b0:54b:321:ef1a with SMTP id
 r15-20020a50aacf000000b0054b0321ef1amr160337edc.6.1701456042587; Fri, 01 Dec
 2023 10:40:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAG48ez3xSoYb+45f1RLtktROJrpiDQ1otNvdR+YLQf7m+Krj5Q@mail.gmail.com>
 <811a97651e144b83a35fd7eb713aeeae@AcuMS.aculab.com>
In-Reply-To: <811a97651e144b83a35fd7eb713aeeae@AcuMS.aculab.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 1 Dec 2023 19:40:06 +0100
Message-ID: <CAG48ez1jT0T69t62wrduEWLSwY0UZpm0CwK4tC3uTPiWJ-powg@mail.gmail.com>
Subject: mutex/spinlock semantics [was: Re: io_uring: incorrect assumption
 about mutex behavior on unlock?]
To: David Laight <David.Laight@aculab.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, 
	Waiman Long <longman@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 1, 2023 at 7:30=E2=80=AFPM David Laight <David.Laight@aculab.co=
m> wrote:
>
> From: Jann Horn
> > Sent: 01 December 2023 16:41
> >
> > mutex_unlock() has a different API contract compared to spin_unlock().
> > spin_unlock() can be used to release ownership of an object, so that
> > as soon as the spinlock is unlocked, another task is allowed to free
> > the object containing the spinlock.
> > mutex_unlock() does not support this kind of usage: The caller of
> > mutex_unlock() must ensure that the mutex stays alive until
> > mutex_unlock() has returned.
>
> The problem sequence might be:
>         Thread A                Thread B
>         mutex_lock()
>                                 code to stop mutex being requested
>                                 ...
>                                 mutex_lock() - sleeps
>         mutex_unlock()...
>                 Waiters woken...
>                 isr and/or pre-empted
>                                 - wakes up
>                                 mutex_unlock()
>                                 free()
>                 ... more kernel code access the mutex
>                 BOOOM
>
> What happens in a PREEMPT_RT kernel where most of the spin_unlock()
> get replaced by mutex_unlock().
> Seems like they can potentially access a freed mutex?

RT spinlocks don't use mutexes, they use rtmutexes, and I think those
explicitly support this usecase. See the call path:

spin_unlock -> rt_spin_unlock -> rt_mutex_slowunlock

rt_mutex_slowunlock() has a comment, added in commit 27e35715df54
("rtmutex: Plug slow unlock race"):

         * We must be careful here if the fast path is enabled. If we
         * have no waiters queued we cannot set owner to NULL here
         * because of:
         *
         * foo->lock->owner =3D NULL;
         *                      rtmutex_lock(foo->lock);   <- fast path
         *                      free =3D atomic_dec_and_test(foo->refcnt);
         *                      rtmutex_unlock(foo->lock); <- fast path
         *                      if (free)
         *                              kfree(foo);
         * raw_spin_unlock(foo->lock->wait_lock);

That commit also explicitly refers to wanting to support this pattern
with spin_unlock() in the commit message.

