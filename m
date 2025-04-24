Return-Path: <io-uring+bounces-7708-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA1BA9B15B
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 16:45:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8877B7A562B
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 14:44:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC811581EE;
	Thu, 24 Apr 2025 14:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NLzHX6a2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868AE4315C;
	Thu, 24 Apr 2025 14:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745505917; cv=none; b=hxJjByaUbmqlosU3eVCt9ROml/wEcMRhbUKWoY+CArzpdfWJyn4NnYqzp3C/kAu0QBX+oIXIcKCGWkUrN1rr7NaQ00zRFQxtFJGFDOH4Iui3IelCFC/zUlKSB5VOjTELkTlDgQu8jhTL6yK83ZOZ6JGunzVaKJfVUPq3lbun5z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745505917; c=relaxed/simple;
	bh=e/pV65hErRueNpRvdOmYqfYxpkH23pEZFx4z5Jq351U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KGo2RTQtYjZALQUm3b6JmOimNLKS47TEssZ/+0g5myX7H6BeK64utvYDRxvFWw+1u2iNTwhZIEyXB6aSGbwzGFJyozT3RYXMghVWUmCL3+ctLzxdKwB+FigXRKRYEx/0cvrGqPv+Iyl53x521I0B4wWNBGGIYAtda5S4x08XdL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NLzHX6a2; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6062e41916dso651600eaf.1;
        Thu, 24 Apr 2025 07:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745505914; x=1746110714; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ivYN5mDklFLzKiOVUifLYvXVJ3uDlc8wINIXNGqMTP8=;
        b=NLzHX6a26jZjg+vQMGWAAQ36ub9zGvqfNnum34mB3SNF9mW6hL16WN1iXaOUOsJFx1
         N01UcyNXKux+12uMGgkqfReo2NzDNosJHI5Qybq0OdS/KE6Q0nSJegG4A2e/MEKJL30Q
         5BsHJfWtac2flm6bP+NuHQZw45Xgk55tw+6QMEjRMLjvCjFzKqrItFpsrHkcSZ7hay2F
         Y0USNQQyj0bnROwFSfua0y1xCDojUNjTSv2qYWV7TFIdu/0mqWSagRaFPnhkPAmKp6sh
         4ST/pRRBtkkSScikZpAYhgPVyv5hboGY4j8fJvnFBQTtDHFLdpRPPuL0BAeD4z2kGTwk
         980g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745505914; x=1746110714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ivYN5mDklFLzKiOVUifLYvXVJ3uDlc8wINIXNGqMTP8=;
        b=mwBntbSftTkeBHA62uWqD2EMn5k+09O0dDLBTKAzmylkxWhVZfMLf+ULiJHp3TI1xL
         y225rwdVnITcpWB7JQ+05VSU3CuVATaDXnP/T0NDND05VdFZhspV/BDfDFAz03gqcHpH
         BrjOil864QiMRKAVfUmLP/rLB3MjqIp33FhU8mXEuHObHL1UevbCMy4uqmmzyfLKBa/G
         0nEhrF++D4x+fZe4Lr2+XFrSxvQqBbaOIzZhA3shz8yT57825Hg7NsRwM8KhB8kslcT9
         fIOBXk/A73iXOe151eWvbBFOshu8BiTkO1kspfXcv32/oREHAZ0mwfearUDjM3FKj0Hp
         vKwA==
X-Forwarded-Encrypted: i=1; AJvYcCUaCFfL5fmnGN+vXiSP4YMX+enp/k9+UsI7ygNCIjEp9fGo2PCk19gFbPJ1lVBgPdjtOovUSc0hp9tSzuSmHw==@vger.kernel.org, AJvYcCVPC8X4a8b/hvUB2bU5gU2kUymHITb6BCeryJJjB0EuapwiEnuxbx6Ygcz/suyJ5qZ23Fk7PoNC0KfQR1tu@vger.kernel.org, AJvYcCXVqd0GrWk4BwDL6Ccq7M/JaolC+wIEgiRlX54O+0XuuVR2nj6/tH1WsCymy3dkK6hSAjyli+2foA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwG37aBG6x/JiiB9crAK15GEoTElPCNAf1HYNh5fQ0WLNjDh6b1
	pYL1ySKzBMGbUqDOKsXsB3/zP35npsM0vu19ojc8JvQszVJAMjLE+FrnALFYXusF32OtS/2ZPD6
	QlZUThiiHnsHZ+zHaRWQoxDL8OqE=
X-Gm-Gg: ASbGncsK7frwcMBzkZ6cOjfhdFhXlrsNTXZ9e2AIXfkFMBjcOpC9Yg6kD0sUbkqWeZF
	4aXF7NmG3joYmrd4LF8hPhq1hOpk4g3Kl94NIbVyuAqyv1R/9AsKJ/nVmDpqffU98sxHA6CD7MW
	kdfnUy3sM1WlWqpbIj1PDK+xVbK/cjJIaSVQ==
X-Google-Smtp-Source: AGHT+IFQSaMuNjk+yxCa9qzVf4T3bP4fN/vKiQkFhG6TF8LpTaQahDSpm6uB6amyKRxrxFgXnFNjb4mL7e265AZNAH8=
X-Received: by 2002:a05:6870:238d:b0:296:b568:7901 with SMTP id
 586e51a60fabf-2d96e311871mr1601156fac.16.1745505914450; Thu, 24 Apr 2025
 07:45:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250422162913.1242057-1-qq282012236@gmail.com>
 <20250422162913.1242057-2-qq282012236@gmail.com> <14195206-47b1-4483-996d-3315aa7c33aa@kernel.dk>
 <CANHzP_uW4+-M1yTg-GPdPzYWAmvqP5vh6+s1uBhrMZ3eBusLug@mail.gmail.com>
 <b61ac651-fafe-449a-82ed-7239123844e1@kernel.dk> <CANHzP_tLV29_uk2gcRAjT9sJNVPH3rMyVuQP07q+c_TWWgsfDg@mail.gmail.com>
 <7bea9c74-7551-4312-bece-86c4ad5c982f@kernel.dk> <52d55891-36e3-43e7-9726-a2cd113f5327@kernel.dk>
 <cac3a5c9-e798-47f2-81ff-3c6003c6d8bb@kernel.dk> <CANHzP_uJft1FPJ0W++0Zp5rUjayaULEdpAQRn1VuuqDVq3DmJA@mail.gmail.com>
 <5c20b5ca-ce41-43c4-870a-c50206ab058d@kernel.dk>
In-Reply-To: <5c20b5ca-ce41-43c4-870a-c50206ab058d@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Thu, 24 Apr 2025 22:45:01 +0800
X-Gm-Features: ATxdqUHq0xvp_kAPKUb6ho_n4ukUomRbsXEEodCWwwWOleA8px4xCz-CIo3C81w
Message-ID: <CANHzP_u2SA3uSoG-4LQ-e9BvW6t-Zo1wn8qnKM0xYGoekL74bA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B44=E6=9C=8824=E6=97=A5=E5=
=91=A8=E5=9B=9B 22:13=E5=86=99=E9=81=93=EF=BC=9A
>
> On 4/24/25 8:08 AM, ??? wrote:
> > Jens Axboe <axboe@kernel.dk> ?2025?4?24??? 06:58???
> >>
> >> On 4/23/25 9:55 AM, Jens Axboe wrote:
> >>> Something like this, perhaps - it'll ensure that io-wq workers get a
> >>> chance to flush out pending work, which should prevent the looping. I=
've
> >>> attached a basic test case. It'll issue a write that will fault, and
> >>> then try and cancel that as a way to trigger the TIF_NOTIFY_SIGNAL ba=
sed
> >>> looping.
> >>
> >> Something that may actually work - use TASK_UNINTERRUPTIBLE IFF
> >> signal_pending() is true AND the fault has already been tried once
> >> before. If that's the case, rather than just call schedule() with
> >> TASK_INTERRUPTIBLE, use TASK_UNINTERRUPTIBLE and schedule_timeout() wi=
th
> >> a suitable timeout length that prevents the annoying parts busy loopin=
g.
> >> I used HZ / 10.
> >>
> >> I don't see how to fix userfaultfd for this case, either using io_urin=
g
> >> or normal write(2). Normal syscalls can pass back -ERESTARTSYS and get
> >> it retried, but there's no way to do that from inside fault handling. =
So
> >> I think we just have to be nicer about it.
> >>
> >> Andrew, as the userfaultfd maintainer, what do you think?
> >>
> >> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> >> index d80f94346199..1016268c7b51 100644
> >> --- a/fs/userfaultfd.c
> >> +++ b/fs/userfaultfd.c
> >> @@ -334,15 +334,29 @@ static inline bool userfaultfd_must_wait(struct =
userfaultfd_ctx *ctx,
> >>         return ret;
> >>  }
> >>
> >> -static inline unsigned int userfaultfd_get_blocking_state(unsigned in=
t flags)
> >> +struct userfault_wait {
> >> +       unsigned int task_state;
> >> +       bool timeout;
> >> +};
> >> +
> >> +static struct userfault_wait userfaultfd_get_blocking_state(unsigned =
int flags)
> >>  {
> >> +       /*
> >> +        * If the fault has already been tried AND there's a signal pe=
nding
> >> +        * for this task, use TASK_UNINTERRUPTIBLE with a small timeou=
t.
> >> +        * This prevents busy looping where schedule() otherwise does =
nothing
> >> +        * for TASK_INTERRUPTIBLE when the task has a signal pending.
> >> +        */
> >> +       if ((flags & FAULT_FLAG_TRIED) && signal_pending(current))
> >> +               return (struct userfault_wait) { TASK_UNINTERRUPTIBLE,=
 true };
> >> +
> >>         if (flags & FAULT_FLAG_INTERRUPTIBLE)
> >> -               return TASK_INTERRUPTIBLE;
> >> +               return (struct userfault_wait) { TASK_INTERRUPTIBLE, f=
alse };
> >>
> >>         if (flags & FAULT_FLAG_KILLABLE)
> >> -               return TASK_KILLABLE;
> >> +               return (struct userfault_wait) { TASK_KILLABLE, false =
};
> >>
> >> -       return TASK_UNINTERRUPTIBLE;
> >> +       return (struct userfault_wait) { TASK_UNINTERRUPTIBLE, false }=
;
> >>  }
> >>
> >>  /*
> >> @@ -368,7 +382,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, =
unsigned long reason)
> >>         struct userfaultfd_wait_queue uwq;
> >>         vm_fault_t ret =3D VM_FAULT_SIGBUS;
> >>         bool must_wait;
> >> -       unsigned int blocking_state;
> >> +       struct userfault_wait wait_mode;
> >>
> >>         /*
> >>          * We don't do userfault handling for the final child pid upda=
te
> >> @@ -466,7 +480,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, =
unsigned long reason)
> >>         uwq.ctx =3D ctx;
> >>         uwq.waken =3D false;
> >>
> >> -       blocking_state =3D userfaultfd_get_blocking_state(vmf->flags);
> >> +       wait_mode =3D userfaultfd_get_blocking_state(vmf->flags);
> >>
> >>          /*
> >>           * Take the vma lock now, in order to safely call
> >> @@ -488,7 +502,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, =
unsigned long reason)
> >>          * following the spin_unlock to happen before the list_add in
> >>          * __add_wait_queue.
> >>          */
> >> -       set_current_state(blocking_state);
> >> +       set_current_state(wait_mode.task_state);
> >>         spin_unlock_irq(&ctx->fault_pending_wqh.lock);
> >>
> >>         if (!is_vm_hugetlb_page(vma))
> >> @@ -501,7 +515,11 @@ vm_fault_t handle_userfault(struct vm_fault *vmf,=
 unsigned long reason)
> >>
> >>         if (likely(must_wait && !READ_ONCE(ctx->released))) {
> >>                 wake_up_poll(&ctx->fd_wqh, EPOLLIN);
> >> -               schedule();
> >> +               /* See comment in userfaultfd_get_blocking_state() */
> >> +               if (!wait_mode.timeout)
> >> +                       schedule();
> >> +               else
> >> +                       schedule_timeout(HZ / 10);
> >>         }
> >>
> >>         __set_current_state(TASK_RUNNING);
> >>
> >> --
> >> Jens Axboe
> > I guess the previous io_work_fault patch might have already addressed
> > the issue sufficiently. The later patch that adds a timeout for
> > userfaultfd might
>
> That one isn't guaranteed to be safe, as it's not necessarily a safe
> context to prune the conditions that lead to a busy loop rather than the
> normal "schedule until the condition is resolved". Running task_work
> should only be done at the outermost point in the kernel, where the task
> state is known sane in terms of what locks etc are being held. For some
> conditions the patch will work just fine, but it's not guaranteed to be
> the case.
>
> > not be necessary  wouldn?t returning after a timeout just cause the
> > same fault to repeat indefinitely again? Regardless of whether the
> > thread is in UN or IN state, the expected behavior should be to wait
> > until the page is filled or the uffd resource is released to be woken
> > up, which seems like the correct logic.
>
> Right, it'll just sleep timeout for a bit as not to be a 100% busy loop.
> That's unfortunately the best we can do for this case... The expected
> behavior is indeed to schedule until we get woken, however that just
> doesn't work if there are signals pending, or other conditions that lead
> to TASK_INTERRUPTIBLE + schedule() being a no-op.
>
> --
> Jens Axboe
In my testing, clearing the NOTIFY flag in the original io_work_fault
ensures that the next schedule correctly waits. However, adding a
timeout causes the issue to return to multiple faults again.
Also, after clearing the NOTIFY flag in handle_userfault,
it=E2=80=99s possible that some task work hasn=E2=80=99t been executed.
But if task_work_run isn=E2=80=99t added back, tasks might get lost?
It seems like there isn=E2=80=99t an appropriate place to add it back.
So, do you suggest adjusting the fault frequency in userfaultfd
to make it more rhythmic to alleviate the issue?

