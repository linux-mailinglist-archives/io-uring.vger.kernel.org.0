Return-Path: <io-uring+bounces-7712-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87D74A9B309
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 17:53:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDBE517BF85
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 15:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC4FA1C8621;
	Thu, 24 Apr 2025 15:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E/HyI6ik"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ACF27BF9B;
	Thu, 24 Apr 2025 15:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745509918; cv=none; b=ZEkl3ZBLlpn0ERUupfxxpybKVglMbFzlGK9yBUfZa40JffQ1w7Ww+OkvJalZmuY4MQt2lFe3/R5Lj0HZZRn/axWK9qnndLUfp0v2Su3Aea/mxeCpS5Cmde0txf9tQPAb/Gd/z6UmtKQ4voz9TeWGHM+1peuKREZHqHG3CcEv9sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745509918; c=relaxed/simple;
	bh=UUS2CpCf+wFg/VS7Ww7nDSjeKSbHn5zDmmVibeywhkg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fsyfmNcsaPq+4VuM5pKTAdQiayV0wrfWrHq8ujnx4g+GRsCbh7sE1f36Xef2h2BytSiRi090z6NiTrbp2m09mbTzmqUZM81NrEQ9nfd9i5GqGBQcBEzdxAMv7iY2srXFzj2GUPVd6ZprGlhE61X08B4a0l4Tjj4tFcMtF1B9yL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E/HyI6ik; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-2c7f876b321so360373fac.1;
        Thu, 24 Apr 2025 08:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745509916; x=1746114716; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XdQtNzKuShUDMjNR2bXSL9wLmA61bL7syi+/zL+gQm4=;
        b=E/HyI6ikvhfCsWYoLJ2Papt3sA+KPSdPsH85KkBG0KIszoorB13OnjuK39sR0eAlUF
         qxEixUg5dGllWxsmm/XtZ8jh0UoZQqhW4RfVHh9zZZz8/oTSslWAbPSnDeN6IMQW+4sg
         UowgcrNOl3JFprbeIHtQa4+mmpAJeTVfwAe20I3TQ8Ubd3qFKvmwh2CV00y3CQdLydE/
         6U00jChnyLZHAeNrq7MR0njZtJYFIF9M34Ja2t1PMI6WvdIwDtgekYRLRXxZjrsIHoGo
         KweXRqG9vuT6DIpwqDYi5omxCNBpi/Vsszx2wsHriU/SHi9cn/K6hNmhU+BWiifaTwEm
         Tc5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745509916; x=1746114716;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XdQtNzKuShUDMjNR2bXSL9wLmA61bL7syi+/zL+gQm4=;
        b=fjV/89N89ieR45N36JxoPSlbeumbG/ITe5vVFQ9aKjLpAb4zV0rgH+YXTffnXHBbwf
         ClUDq6EgMGvSGe+b1/kh5h7rKcC2l+u2veNb1X2ZHTpwq7CecbfsUwq29sKwLbWAGzTx
         1IzbN5bION64T7ihTclnYa/+I8DUC6UGTUp52X8yLDyL5j8DPQZ4vfCZwbmCV09jTFEQ
         PDNPYV4xUgdQ9hmCxE3mF/WFLNcG43JwRO8FcO7D8DhFEimZSxlRLeFTb8ELxpDhCjp5
         rqqJhIDZAdLGw6jQVR6zyFg1/Ji8wRUhNSI0LqTdnTrvAOnuavqsVvzcd7PioUIUoJYp
         49qQ==
X-Forwarded-Encrypted: i=1; AJvYcCVtAoXP2Bazv7sEeHUPzVAjAYkFOUEubcYcrcadUeUDduDU/0hdvyWIqwSzZqs4+hOVC8ajrzAVaImto+l1@vger.kernel.org, AJvYcCWqxvWXRw/tKmlhSZHEW/uQM8pjmj7PMSeQfi2pKttmQgAYC77yfYW3YWEGT5Ae9dpxQS4mzeZcEw==@vger.kernel.org, AJvYcCXRPHld5MGRYTJ9a4M3kAl7bgdvLdC0iacTiDd+LJXGb1FPY+2J0HSGjvBfQ65UG/de6ZX7wVOGyc6mE3jgYQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzbFriC/40yepGuNWqgv0BxsOFIrFy6Pa3x1m+QHHtCxwPeRHeW
	kouuIWyfc1KDzqNQ93r8OznkKxRctcEQe/2oc8QCMCNZ2Oi0xlcGja07zrHXUZiu2LNLMMQwKyh
	oJyAqjW3vxmJjvvQoIp4drgnRRYY=
X-Gm-Gg: ASbGnctppu0Uu4YDVINjKjG6t77y8SaNpACtbVbIHY9llzZLxt9U+nxUWwCqXnwqTMs
	sNQI4C9XAAx5S2dyVQrsLIh+DfMt3ACpwVu5AgU84xwdUto9V+lL50Y9cNHjzQpaIQ574rpV5Bm
	TbFCQO3c5I7eKFX44gm20eoaY=
X-Google-Smtp-Source: AGHT+IEy3LkES11D0FSg2kVcEOvymyrRXJM3cmutJBvoQQi6r8APkqvxnavi1IF3y6ntmIVBeMG1p+uppWv0fpFNyqo=
X-Received: by 2002:a05:6870:80cb:b0:2d8:957a:5176 with SMTP id
 586e51a60fabf-2d994154d14mr207023fac.5.1745509915594; Thu, 24 Apr 2025
 08:51:55 -0700 (PDT)
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
 <5c20b5ca-ce41-43c4-870a-c50206ab058d@kernel.dk> <CANHzP_u2SA3uSoG-4LQ-e9BvW6t-Zo1wn8qnKM0xYGoekL74bA@mail.gmail.com>
 <1ed67bb5-5d3d-4af8-b5a7-4f644186708b@kernel.dk> <CANHzP_vi1SaC+jP_UZqsjFA=Gu=Q3ST0XR_ECm=4O-5G8Jmqqg@mail.gmail.com>
 <fdcb66e3-e99a-49f9-8874-00110b06bb3d@kernel.dk>
In-Reply-To: <fdcb66e3-e99a-49f9-8874-00110b06bb3d@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Thu, 24 Apr 2025 23:51:42 +0800
X-Gm-Features: ATxdqUF4IfbaOT1v-BFzWeGT5-1nonybxlASGLo3cp33mnyxTu1ThjM9BkIJOmQ
Message-ID: <CANHzP_vws+MPqt4u3pvWebM_ZObz_FZ2P2Zz20fPpWon8Kxxhg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B44=E6=9C=8824=E6=97=A5=E5=
=91=A8=E5=9B=9B 23:21=E5=86=99=E9=81=93=EF=BC=9A
>
> On 4/24/25 9:12 AM, ??? wrote:
> > Jens Axboe <axboe@kernel.dk> ?2025?4?24??? 22:53???
> >>
> >> On 4/24/25 8:45 AM, ??? wrote:
> >>> Jens Axboe <axboe@kernel.dk> ?2025?4?24??? 22:13???
> >>>>
> >>>> On 4/24/25 8:08 AM, ??? wrote:
> >>>>> Jens Axboe <axboe@kernel.dk> ?2025?4?24??? 06:58???
> >>>>>>
> >>>>>> On 4/23/25 9:55 AM, Jens Axboe wrote:
> >>>>>>> Something like this, perhaps - it'll ensure that io-wq workers ge=
t a
> >>>>>>> chance to flush out pending work, which should prevent the loopin=
g. I've
> >>>>>>> attached a basic test case. It'll issue a write that will fault, =
and
> >>>>>>> then try and cancel that as a way to trigger the TIF_NOTIFY_SIGNA=
L based
> >>>>>>> looping.
> >>>>>>
> >>>>>> Something that may actually work - use TASK_UNINTERRUPTIBLE IFF
> >>>>>> signal_pending() is true AND the fault has already been tried once
> >>>>>> before. If that's the case, rather than just call schedule() with
> >>>>>> TASK_INTERRUPTIBLE, use TASK_UNINTERRUPTIBLE and schedule_timeout(=
) with
> >>>>>> a suitable timeout length that prevents the annoying parts busy lo=
oping.
> >>>>>> I used HZ / 10.
> >>>>>>
> >>>>>> I don't see how to fix userfaultfd for this case, either using io_=
uring
> >>>>>> or normal write(2). Normal syscalls can pass back -ERESTARTSYS and=
 get
> >>>>>> it retried, but there's no way to do that from inside fault handli=
ng. So
> >>>>>> I think we just have to be nicer about it.
> >>>>>>
> >>>>>> Andrew, as the userfaultfd maintainer, what do you think?
> >>>>>>
> >>>>>> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> >>>>>> index d80f94346199..1016268c7b51 100644
> >>>>>> --- a/fs/userfaultfd.c
> >>>>>> +++ b/fs/userfaultfd.c
> >>>>>> @@ -334,15 +334,29 @@ static inline bool userfaultfd_must_wait(str=
uct userfaultfd_ctx *ctx,
> >>>>>>         return ret;
> >>>>>>  }
> >>>>>>
> >>>>>> -static inline unsigned int userfaultfd_get_blocking_state(unsigne=
d int flags)
> >>>>>> +struct userfault_wait {
> >>>>>> +       unsigned int task_state;
> >>>>>> +       bool timeout;
> >>>>>> +};
> >>>>>> +
> >>>>>> +static struct userfault_wait userfaultfd_get_blocking_state(unsig=
ned int flags)
> >>>>>>  {
> >>>>>> +       /*
> >>>>>> +        * If the fault has already been tried AND there's a signa=
l pending
> >>>>>> +        * for this task, use TASK_UNINTERRUPTIBLE with a small ti=
meout.
> >>>>>> +        * This prevents busy looping where schedule() otherwise d=
oes nothing
> >>>>>> +        * for TASK_INTERRUPTIBLE when the task has a signal pendi=
ng.
> >>>>>> +        */
> >>>>>> +       if ((flags & FAULT_FLAG_TRIED) && signal_pending(current))
> >>>>>> +               return (struct userfault_wait) { TASK_UNINTERRUPTI=
BLE, true };
> >>>>>> +
> >>>>>>         if (flags & FAULT_FLAG_INTERRUPTIBLE)
> >>>>>> -               return TASK_INTERRUPTIBLE;
> >>>>>> +               return (struct userfault_wait) { TASK_INTERRUPTIBL=
E, false };
> >>>>>>
> >>>>>>         if (flags & FAULT_FLAG_KILLABLE)
> >>>>>> -               return TASK_KILLABLE;
> >>>>>> +               return (struct userfault_wait) { TASK_KILLABLE, fa=
lse };
> >>>>>>
> >>>>>> -       return TASK_UNINTERRUPTIBLE;
> >>>>>> +       return (struct userfault_wait) { TASK_UNINTERRUPTIBLE, fal=
se };
> >>>>>>  }
> >>>>>>
> >>>>>>  /*
> >>>>>> @@ -368,7 +382,7 @@ vm_fault_t handle_userfault(struct vm_fault *v=
mf, unsigned long reason)
> >>>>>>         struct userfaultfd_wait_queue uwq;
> >>>>>>         vm_fault_t ret =3D VM_FAULT_SIGBUS;
> >>>>>>         bool must_wait;
> >>>>>> -       unsigned int blocking_state;
> >>>>>> +       struct userfault_wait wait_mode;
> >>>>>>
> >>>>>>         /*
> >>>>>>          * We don't do userfault handling for the final child pid =
update
> >>>>>> @@ -466,7 +480,7 @@ vm_fault_t handle_userfault(struct vm_fault *v=
mf, unsigned long reason)
> >>>>>>         uwq.ctx =3D ctx;
> >>>>>>         uwq.waken =3D false;
> >>>>>>
> >>>>>> -       blocking_state =3D userfaultfd_get_blocking_state(vmf->fla=
gs);
> >>>>>> +       wait_mode =3D userfaultfd_get_blocking_state(vmf->flags);
> >>>>>>
> >>>>>>          /*
> >>>>>>           * Take the vma lock now, in order to safely call
> >>>>>> @@ -488,7 +502,7 @@ vm_fault_t handle_userfault(struct vm_fault *v=
mf, unsigned long reason)
> >>>>>>          * following the spin_unlock to happen before the list_add=
 in
> >>>>>>          * __add_wait_queue.
> >>>>>>          */
> >>>>>> -       set_current_state(blocking_state);
> >>>>>> +       set_current_state(wait_mode.task_state);
> >>>>>>         spin_unlock_irq(&ctx->fault_pending_wqh.lock);
> >>>>>>
> >>>>>>         if (!is_vm_hugetlb_page(vma))
> >>>>>> @@ -501,7 +515,11 @@ vm_fault_t handle_userfault(struct vm_fault *=
vmf, unsigned long reason)
> >>>>>>
> >>>>>>         if (likely(must_wait && !READ_ONCE(ctx->released))) {
> >>>>>>                 wake_up_poll(&ctx->fd_wqh, EPOLLIN);
> >>>>>> -               schedule();
> >>>>>> +               /* See comment in userfaultfd_get_blocking_state()=
 */
> >>>>>> +               if (!wait_mode.timeout)
> >>>>>> +                       schedule();
> >>>>>> +               else
> >>>>>> +                       schedule_timeout(HZ / 10);
> >>>>>>         }
> >>>>>>
> >>>>>>         __set_current_state(TASK_RUNNING);
> >>>>>>
> >>>>>> --
> >>>>>> Jens Axboe
> >>>>> I guess the previous io_work_fault patch might have already address=
ed
> >>>>> the issue sufficiently. The later patch that adds a timeout for
> >>>>> userfaultfd might
> >>>>
> >>>> That one isn't guaranteed to be safe, as it's not necessarily a safe
> >>>> context to prune the conditions that lead to a busy loop rather than=
 the
> >>>> normal "schedule until the condition is resolved". Running task_work
> >>>> should only be done at the outermost point in the kernel, where the =
task
> >>>> state is known sane in terms of what locks etc are being held. For s=
ome
> >>>> conditions the patch will work just fine, but it's not guaranteed to=
 be
> >>>> the case.
> >>>>
> >>>>> not be necessary  wouldn?t returning after a timeout just cause the
> >>>>> same fault to repeat indefinitely again? Regardless of whether the
> >>>>> thread is in UN or IN state, the expected behavior should be to wai=
t
> >>>>> until the page is filled or the uffd resource is released to be wok=
en
> >>>>> up, which seems like the correct logic.
> >>>>
> >>>> Right, it'll just sleep timeout for a bit as not to be a 100% busy l=
oop.
> >>>> That's unfortunately the best we can do for this case... The expecte=
d
> >>>> behavior is indeed to schedule until we get woken, however that just
> >>>> doesn't work if there are signals pending, or other conditions that =
lead
> >>>> to TASK_INTERRUPTIBLE + schedule() being a no-op.
> >>>>
> >>>> --
> >>>> Jens Axboe
> >>> In my testing, clearing the NOTIFY flag in the original io_work_fault
> >>> ensures that the next schedule correctly waits. However, adding a
> >>
> >> That's symptom fixing again - the NOTIFY flag is the thing that trigge=
rs
> >> for io_uring, but any legitimate signal (or task_work added with
> >> signaling) will cause the same issue.
> >>
> >>> timeout causes the issue to return to multiple faults again.
> >>> Also, after clearing the NOTIFY flag in handle_userfault,
> >>> it?s possible that some task work hasn?t been executed.
> >>> But if task_work_run isn?t added back, tasks might get lost?
> >>> It seems like there isn?t an appropriate place to add it back.
> >>> So, do you suggest adjusting the fault frequency in userfaultfd
> >>> to make it more rhythmic to alleviate the issue?
> >>
> >> The task_work is still there, you just removed the notification
> >> mechanism that tells the kernel that there's task_work there. For this
> >> particular case, you could re-set TIF_NOTIFY_SIGNAL at the end after
> >> schedule(), but again it'd only fix that specific one case, not the
> >> generic issue.
> >>
> >> What's the objection to the sleep approach? If the task is woken by th=
e
> >> fault being filled, it'll still wake on time, no delay. If not, then i=
t
> >> prevents a busy loop, which is counterproductive.
> >>
> >> --
> >> Jens Axboe
> > OK Thanks .and i?m curious about what exactly is meant by a
> > 'specific one case 'and what qualifies as a 'generic issue' with re-set
> > TIF_NOTIFY_SIGNAL.
>
> I already outlined that in earlier replies, find the email that states
> the various conditions that can lead to schedule() w/TASK_INTERRUPTIBLE
> to return immediately rather than sleeping. TIF_NOTIFY_SIGNAL is _one_
> such condition, it's not _all_ conditions.
>
> > So, in your final opinion, do you think the code in io_uring is not
> > suitable for modification, should focus on making adjustments in
> > userfaultfd to mitigate the issue?
>
> The problem isn't in io_uring in the first place, you just happened to
> trip over it via that path. I even sent out a test case that
> demonstrates how to trigger this without io_uring as well. I'm a bit
> puzzled as to why all of this isn't clear already.
>
> --
> Jens Axboe
Thank you. I think the final solution for my scenario might involve the
user-space monitoring of the uffd business thread to ensure that it can
unregister the uffd memory, allowing the fault process to exit the loop
in IOU via an error return, which would further help exit the VM
process's D state.

