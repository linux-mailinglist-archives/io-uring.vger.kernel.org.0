Return-Path: <io-uring+bounces-7710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B2CA9A9B1D6
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 17:13:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE9277B0DEC
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 15:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 215611A5BAC;
	Thu, 24 Apr 2025 15:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ckz4KqBF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF0E14F9EB;
	Thu, 24 Apr 2025 15:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745507587; cv=none; b=Dkh7gWSt1gXQPy2g/fSuAdGkl0uPPVfGiMoraefA+LpMJ8OX6GfcOTtIYV8egyGRMBmrrFC8AKA31H6NnW7ZykoZC775xJBoUW/6F5aEOplY5TQdD8dGEEbc/Zzcmd57pZHEw8dC1ZLbV8GyJNFPxWlN1Dkj4+aTBs3uUjf9Y0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745507587; c=relaxed/simple;
	bh=70q7tfyal5Fg27W2t3bj1Es+zzGTOt7F2uFS8C5Zrr0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z172zL5wyI5aO/bvoN5B3Uva0VGGATW16W+wgMo30CXnmSATXLHLfgSC+jEWagV2Q5N8eq2ZePwmau7En+8e39vGduLE3yIlq09hPoJksT/8Z00mtvofqYXiO1JkMCrlwnTLBuWoZ01ED94kQNxJN6k4f8tvmd9hbHq3fuRRxh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ckz4KqBF; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2c12b7af278so864745fac.0;
        Thu, 24 Apr 2025 08:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745507584; x=1746112384; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJQwgudwUlt+h9dEjDjiK4usQBmjK0EIPccbWAz3KNk=;
        b=Ckz4KqBFUUwPWBPVnUTYti+H67dbe0HexsSbqg+p771q9RMSsddvuiT4gm7UUFNT+N
         nEBVRL53f5hLKxJgWtIuuZTGsfU7R0GwXHizGydCQpo9NDDK77FbQ17Y5FXp7KrFccu2
         YzxcnJYW6QjD/hhz0UH+t6iukt95NC/+Iz5DUGNfiihhXzY+L+4Qh7tLK6lNa6RbtmZx
         PCOisBTaseJhD6iBR3nY6wtj2LXgLUcB/KO/WSa2KcPHAB3qnVKbfxSVoYxaV8anuEoO
         2VszgE5CUxR/zE7QQSLtaFNS0z9qgOtb6JUPWDMEcCntARe5hq8EajqH7ot7AKa774U3
         9oWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745507584; x=1746112384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RJQwgudwUlt+h9dEjDjiK4usQBmjK0EIPccbWAz3KNk=;
        b=FLkQvwZsO+HxtCRcirW+zgdcRr/iYhakCdWDF05qaph796PxaXc6+2sYRUHWUtki/0
         4KgPDgWU5QdziQJUAvmg9EbLtxzLdFzNOJBFSrPPevmD8Jlh/OPdNl5IM72jEIFP2Vfi
         f7+vkBayOCpUl6F8TXUajS+fx9qXyi3HkHzMqlBnga0tJ8gn5FQlg8ndwf4Z/X1nbkiS
         LS17rPumUz6bXGhAtvfepfhhcoYPQUgpzaIF48oEFytJqTAgwyo6ZKMyQ88e0SGicF49
         LjtsO2Euy3PbjumkWAQBqiUNhCotUp+x5p2RqQckRN9LlWIG0AP/PBksntjwtjCZCs+l
         nVZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfeaMyuS7f+TExDjghixqVVrKyVhrTrdQdbox6C8QBrCRiIxWYb6Gk4sipujr0lP/l34cPA/eOwg==@vger.kernel.org, AJvYcCVsqtGMkFG8Qs/ClyGtVi25o7nBhBYdMLTsOOBES5A+62mo8yNW7VCCKuPQMd/xeYPa+fbyRSmaTRxZBPbqUQ==@vger.kernel.org, AJvYcCWhfwKPWoVs+70Zec/rBp237tdj9jl0WRIv3pk91qgB6Q65ODac9bCbx4RAMAUnylR7KGM45f3dYuHHj8gm@vger.kernel.org
X-Gm-Message-State: AOJu0Yzg/mez1PMGv3vtys1BrW0p9Tog3Xu1gB3FEXNAmr7rfp9x5dvk
	5KhSZlRuO7hqYOX1YHk9w1SRXMlIyh2xMxg1cMwXSkTByY/pwRqtNHQO2MSHcmPPdB20hWdeJ5/
	+S1cKX79N82s9Cz7Yh/PWLunJ+N4=
X-Gm-Gg: ASbGncsiT5ztLutCg4xPsf6JbKls/hqe+ks39qLDPZYtyCsi2JKQq0UMtsK8Wcv0CEZ
	4Y36DjNmr8+LKykWJLzqbut48aHyasvXHQAaJhH8L5aPSlDRTjiEmIIvVcJB1fP2IJstZWANJbH
	TM+SFGhXuuHPNWzBx6EnbDNrQ=
X-Google-Smtp-Source: AGHT+IEPbj1NyCGg1IYiplR7XlzA2UlL86knW/idvppbgEbTo86Bg3TpcVscvkDRGjFGBed26A2/pMD3d16tSdCnn8I=
X-Received: by 2002:a05:6870:e99a:b0:2d4:f2da:9bb8 with SMTP id
 586e51a60fabf-2d97311dbb3mr1584506fac.1.1745507583922; Thu, 24 Apr 2025
 08:13:03 -0700 (PDT)
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
 <1ed67bb5-5d3d-4af8-b5a7-4f644186708b@kernel.dk>
In-Reply-To: <1ed67bb5-5d3d-4af8-b5a7-4f644186708b@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Thu, 24 Apr 2025 23:12:49 +0800
X-Gm-Features: ATxdqUHe5gwFojH5W1zzXhzHzgiZG4lIpiDsVFZLaTqhcnSH7zbPMgWC8Xwren8
Message-ID: <CANHzP_vi1SaC+jP_UZqsjFA=Gu=Q3ST0XR_ECm=4O-5G8Jmqqg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B44=E6=9C=8824=E6=97=A5=E5=
=91=A8=E5=9B=9B 22:53=E5=86=99=E9=81=93=EF=BC=9A
>
> On 4/24/25 8:45 AM, ??? wrote:
> > Jens Axboe <axboe@kernel.dk> ?2025?4?24??? 22:13???
> >>
> >> On 4/24/25 8:08 AM, ??? wrote:
> >>> Jens Axboe <axboe@kernel.dk> ?2025?4?24??? 06:58???
> >>>>
> >>>> On 4/23/25 9:55 AM, Jens Axboe wrote:
> >>>>> Something like this, perhaps - it'll ensure that io-wq workers get =
a
> >>>>> chance to flush out pending work, which should prevent the looping.=
 I've
> >>>>> attached a basic test case. It'll issue a write that will fault, an=
d
> >>>>> then try and cancel that as a way to trigger the TIF_NOTIFY_SIGNAL =
based
> >>>>> looping.
> >>>>
> >>>> Something that may actually work - use TASK_UNINTERRUPTIBLE IFF
> >>>> signal_pending() is true AND the fault has already been tried once
> >>>> before. If that's the case, rather than just call schedule() with
> >>>> TASK_INTERRUPTIBLE, use TASK_UNINTERRUPTIBLE and schedule_timeout() =
with
> >>>> a suitable timeout length that prevents the annoying parts busy loop=
ing.
> >>>> I used HZ / 10.
> >>>>
> >>>> I don't see how to fix userfaultfd for this case, either using io_ur=
ing
> >>>> or normal write(2). Normal syscalls can pass back -ERESTARTSYS and g=
et
> >>>> it retried, but there's no way to do that from inside fault handling=
. So
> >>>> I think we just have to be nicer about it.
> >>>>
> >>>> Andrew, as the userfaultfd maintainer, what do you think?
> >>>>
> >>>> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> >>>> index d80f94346199..1016268c7b51 100644
> >>>> --- a/fs/userfaultfd.c
> >>>> +++ b/fs/userfaultfd.c
> >>>> @@ -334,15 +334,29 @@ static inline bool userfaultfd_must_wait(struc=
t userfaultfd_ctx *ctx,
> >>>>         return ret;
> >>>>  }
> >>>>
> >>>> -static inline unsigned int userfaultfd_get_blocking_state(unsigned =
int flags)
> >>>> +struct userfault_wait {
> >>>> +       unsigned int task_state;
> >>>> +       bool timeout;
> >>>> +};
> >>>> +
> >>>> +static struct userfault_wait userfaultfd_get_blocking_state(unsigne=
d int flags)
> >>>>  {
> >>>> +       /*
> >>>> +        * If the fault has already been tried AND there's a signal =
pending
> >>>> +        * for this task, use TASK_UNINTERRUPTIBLE with a small time=
out.
> >>>> +        * This prevents busy looping where schedule() otherwise doe=
s nothing
> >>>> +        * for TASK_INTERRUPTIBLE when the task has a signal pending=
.
> >>>> +        */
> >>>> +       if ((flags & FAULT_FLAG_TRIED) && signal_pending(current))
> >>>> +               return (struct userfault_wait) { TASK_UNINTERRUPTIBL=
E, true };
> >>>> +
> >>>>         if (flags & FAULT_FLAG_INTERRUPTIBLE)
> >>>> -               return TASK_INTERRUPTIBLE;
> >>>> +               return (struct userfault_wait) { TASK_INTERRUPTIBLE,=
 false };
> >>>>
> >>>>         if (flags & FAULT_FLAG_KILLABLE)
> >>>> -               return TASK_KILLABLE;
> >>>> +               return (struct userfault_wait) { TASK_KILLABLE, fals=
e };
> >>>>
> >>>> -       return TASK_UNINTERRUPTIBLE;
> >>>> +       return (struct userfault_wait) { TASK_UNINTERRUPTIBLE, false=
 };
> >>>>  }
> >>>>
> >>>>  /*
> >>>> @@ -368,7 +382,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf=
, unsigned long reason)
> >>>>         struct userfaultfd_wait_queue uwq;
> >>>>         vm_fault_t ret =3D VM_FAULT_SIGBUS;
> >>>>         bool must_wait;
> >>>> -       unsigned int blocking_state;
> >>>> +       struct userfault_wait wait_mode;
> >>>>
> >>>>         /*
> >>>>          * We don't do userfault handling for the final child pid up=
date
> >>>> @@ -466,7 +480,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf=
, unsigned long reason)
> >>>>         uwq.ctx =3D ctx;
> >>>>         uwq.waken =3D false;
> >>>>
> >>>> -       blocking_state =3D userfaultfd_get_blocking_state(vmf->flags=
);
> >>>> +       wait_mode =3D userfaultfd_get_blocking_state(vmf->flags);
> >>>>
> >>>>          /*
> >>>>           * Take the vma lock now, in order to safely call
> >>>> @@ -488,7 +502,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf=
, unsigned long reason)
> >>>>          * following the spin_unlock to happen before the list_add i=
n
> >>>>          * __add_wait_queue.
> >>>>          */
> >>>> -       set_current_state(blocking_state);
> >>>> +       set_current_state(wait_mode.task_state);
> >>>>         spin_unlock_irq(&ctx->fault_pending_wqh.lock);
> >>>>
> >>>>         if (!is_vm_hugetlb_page(vma))
> >>>> @@ -501,7 +515,11 @@ vm_fault_t handle_userfault(struct vm_fault *vm=
f, unsigned long reason)
> >>>>
> >>>>         if (likely(must_wait && !READ_ONCE(ctx->released))) {
> >>>>                 wake_up_poll(&ctx->fd_wqh, EPOLLIN);
> >>>> -               schedule();
> >>>> +               /* See comment in userfaultfd_get_blocking_state() *=
/
> >>>> +               if (!wait_mode.timeout)
> >>>> +                       schedule();
> >>>> +               else
> >>>> +                       schedule_timeout(HZ / 10);
> >>>>         }
> >>>>
> >>>>         __set_current_state(TASK_RUNNING);
> >>>>
> >>>> --
> >>>> Jens Axboe
> >>> I guess the previous io_work_fault patch might have already addressed
> >>> the issue sufficiently. The later patch that adds a timeout for
> >>> userfaultfd might
> >>
> >> That one isn't guaranteed to be safe, as it's not necessarily a safe
> >> context to prune the conditions that lead to a busy loop rather than t=
he
> >> normal "schedule until the condition is resolved". Running task_work
> >> should only be done at the outermost point in the kernel, where the ta=
sk
> >> state is known sane in terms of what locks etc are being held. For som=
e
> >> conditions the patch will work just fine, but it's not guaranteed to b=
e
> >> the case.
> >>
> >>> not be necessary  wouldn?t returning after a timeout just cause the
> >>> same fault to repeat indefinitely again? Regardless of whether the
> >>> thread is in UN or IN state, the expected behavior should be to wait
> >>> until the page is filled or the uffd resource is released to be woken
> >>> up, which seems like the correct logic.
> >>
> >> Right, it'll just sleep timeout for a bit as not to be a 100% busy loo=
p.
> >> That's unfortunately the best we can do for this case... The expected
> >> behavior is indeed to schedule until we get woken, however that just
> >> doesn't work if there are signals pending, or other conditions that le=
ad
> >> to TASK_INTERRUPTIBLE + schedule() being a no-op.
> >>
> >> --
> >> Jens Axboe
> > In my testing, clearing the NOTIFY flag in the original io_work_fault
> > ensures that the next schedule correctly waits. However, adding a
>
> That's symptom fixing again - the NOTIFY flag is the thing that triggers
> for io_uring, but any legitimate signal (or task_work added with
> signaling) will cause the same issue.
>
> > timeout causes the issue to return to multiple faults again.
> > Also, after clearing the NOTIFY flag in handle_userfault,
> > it?s possible that some task work hasn?t been executed.
> > But if task_work_run isn?t added back, tasks might get lost?
> > It seems like there isn?t an appropriate place to add it back.
> > So, do you suggest adjusting the fault frequency in userfaultfd
> > to make it more rhythmic to alleviate the issue?
>
> The task_work is still there, you just removed the notification
> mechanism that tells the kernel that there's task_work there. For this
> particular case, you could re-set TIF_NOTIFY_SIGNAL at the end after
> schedule(), but again it'd only fix that specific one case, not the
> generic issue.
>
> What's the objection to the sleep approach? If the task is woken by the
> fault being filled, it'll still wake on time, no delay. If not, then it
> prevents a busy loop, which is counterproductive.
>
> --
> Jens Axboe
OK Thanks .and i=E2=80=99m curious about what exactly is meant by a
'specific one case 'and what qualifies as a 'generic issue' with re-set
TIF_NOTIFY_SIGNAL.
So, in your final opinion, do you think the code in io_uring is not suitabl=
e
for modification, should focus on making adjustments in userfaultfd to
mitigate the issue?

