Return-Path: <io-uring+bounces-7706-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A113A9B030
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 16:09:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 373AC1B84701
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 14:09:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF5DA19ABAC;
	Thu, 24 Apr 2025 14:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U5luU2fa"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3610518A959;
	Thu, 24 Apr 2025 14:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745503745; cv=none; b=W919jNXEdQLeksipV7YQRQQwDfbP/H3FsZgGYP+m0WhmgymrX5qcClNX9dR31KGwoktMYVwrCPwoddaeTmeCNbV5oVk0AYFpWMvx9K493IrVtPmKb7KeT/0zXTThe8J9EsANtSs8CPNn2E2MO36Foy/+T38Jn5Nq70L8soOBuPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745503745; c=relaxed/simple;
	bh=up1Um3M3kGiHu6p/+D24TGU7LMGvU4eXrXsB4JFc960=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NXYulkzplR7qNak3p9dW89CgGLUv8KQ4k0pfNIMmcu7JeVuUsazrj02dQfzJ9chUTxjVMSFf8UhEis0SO0jCi2b5b1O5Ne40ihAqgqDp69NaGTUV6ghOaPFpwBvbGT9PgSuliyD0OQjOnQTm7uUhmPcqYNQSml4F6fPX3n+RBTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U5luU2fa; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-601b6146b9cso602319eaf.0;
        Thu, 24 Apr 2025 07:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745503743; x=1746108543; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2CAkVkU/OxnMww8X2FpR50DRF3NZTt9BRpF414jxVPw=;
        b=U5luU2fa3aCLzRWLcYctPoqbTvi2CyxGQh6SS5sggzDK3aUXj17vgVKJjHYMCJh3UB
         jMbZrivhsyWpcgdDWicu+r2FPx+lVshXBRkQdacg6LBh2g5fInXa2QNQ/Tk/h8G0A9JY
         flM2pOc4g6GCGolIyxPk7HC7Fk3CEOHBQLwxg3lO48Z2IroimsopHzv4IscaVnoVe0E1
         9rSd8N2B+mnphkQxHKgz6mWrb8bdO2joYN+keHD2gsJD4qOEcVYkANjONsdPjxA7rXeQ
         H308rSb3W5UIPnB+psgoW+PCrXhwRr8QnRqAVURGczYISLmnvQ0ypU6l45Zx9MOJe1qr
         oFaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745503743; x=1746108543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2CAkVkU/OxnMww8X2FpR50DRF3NZTt9BRpF414jxVPw=;
        b=qUaZpWzTi+iBJGBdWDHHLo478e/Ys6hvDMN2SWPGaWTomDX+SPZ2pAzIuN1HXKa2Be
         yWakeA5FhnMPUcC4FOk5tUrfQdespcr+Cb1pwV98Rs0FvYGIyLW+1vFzUpSVl5mT/Gle
         9yCQ65lzvkAT8LXutQGLmKpoK76JcuU6Ymt80Sj34J+S0H2xhSv31C63JraLbJifQdlU
         rYc40Z1zJoO1nZBTi6j5eJqD5SmEkN6Z7LMYcl25G7UguNR6WlaQIgmiMsUBeO6R2foR
         TxpMUtIgCMPjKq/cK0sbrFnFteiiXTfVrOAPiuBZVnI8+uRkHhiZSKM1FTfeOtC5fkO/
         G5FA==
X-Forwarded-Encrypted: i=1; AJvYcCVqGxnxoT8ZUtOgzjuKnhSyCPGmYSiO9dpP0rBU9gxQrasoR66QK0dFgFf5ehzaieSUWYxbF7RgMN/H8BFC@vger.kernel.org, AJvYcCWav7sMFLSoLS1ij0XHFNpHr3lD+mVcNflpeQuW8/ELz1p413P5rYv1PKUb6e5aC91Uvm4rTayonFL/5oWh6Q==@vger.kernel.org, AJvYcCXL2onAFG9GVmA1meHP+GjCQ6NXNYRf3xh+Zz+NoMwxJKuHN9p/JSdDy9us0m2khln2BCiYnMwyLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxfXK/c7Indnf3pm0g1l0YHVGfI0UKmJ02XI9anWuLk4+eW1+mM
	towqNFY4ixxWk/GnUZLfGl/G42FjeOIfigqYjegvdc02/VZZUO9ILCVOjnfqb1QfgUaLIdpxxEb
	GIlhbl9w1BOpc97Xeqkk6ndy4Lkc=
X-Gm-Gg: ASbGncu+so+hcCSJ8CBmNFLJsUXXRRW9ihUCBiWZ4Mn/s4mSCFe4hPP2VSxJwjUVxJb
	3OolO/uCck5E/sW71X5oWVwmkavaeAlbTU7f9rXSIOG+I1y8vnVAfNJjsJT13ZlWmW1EmkFZ7WD
	5tNop96f1hs6OGErsi/HcRNiw=
X-Google-Smtp-Source: AGHT+IH33bg6O/Rlzqan9kyG0UjeT6AF4yJ5sNzMyKR5fDnkXrMhiDWqYuid7ea+COTDLkcFINWneffryByzL7tziFc=
X-Received: by 2002:a05:6870:808d:b0:2d5:4f4:e24d with SMTP id
 586e51a60fabf-2d96e2203f8mr1857960fac.6.1745503742322; Thu, 24 Apr 2025
 07:09:02 -0700 (PDT)
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
 <cac3a5c9-e798-47f2-81ff-3c6003c6d8bb@kernel.dk>
In-Reply-To: <cac3a5c9-e798-47f2-81ff-3c6003c6d8bb@kernel.dk>
From: =?UTF-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Date: Thu, 24 Apr 2025 22:08:50 +0800
X-Gm-Features: ATxdqUFf6_g9o4TAG75rI3AXOHGexfQMUN56anr7lPfaQPN_FZU4nYJA67nCd1Y
Message-ID: <CANHzP_uJft1FPJ0W++0Zp5rUjayaULEdpAQRn1VuuqDVq3DmJA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] io_uring: Add new functions to handle user fault scenarios
To: Jens Axboe <axboe@kernel.dk>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	akpm@linux-foundation.org, peterx@redhat.com, asml.silence@gmail.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B44=E6=9C=8824=E6=97=A5=E5=
=91=A8=E5=9B=9B 06:58=E5=86=99=E9=81=93=EF=BC=9A
>
> On 4/23/25 9:55 AM, Jens Axboe wrote:
> > Something like this, perhaps - it'll ensure that io-wq workers get a
> > chance to flush out pending work, which should prevent the looping. I'v=
e
> > attached a basic test case. It'll issue a write that will fault, and
> > then try and cancel that as a way to trigger the TIF_NOTIFY_SIGNAL base=
d
> > looping.
>
> Something that may actually work - use TASK_UNINTERRUPTIBLE IFF
> signal_pending() is true AND the fault has already been tried once
> before. If that's the case, rather than just call schedule() with
> TASK_INTERRUPTIBLE, use TASK_UNINTERRUPTIBLE and schedule_timeout() with
> a suitable timeout length that prevents the annoying parts busy looping.
> I used HZ / 10.
>
> I don't see how to fix userfaultfd for this case, either using io_uring
> or normal write(2). Normal syscalls can pass back -ERESTARTSYS and get
> it retried, but there's no way to do that from inside fault handling. So
> I think we just have to be nicer about it.
>
> Andrew, as the userfaultfd maintainer, what do you think?
>
> diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> index d80f94346199..1016268c7b51 100644
> --- a/fs/userfaultfd.c
> +++ b/fs/userfaultfd.c
> @@ -334,15 +334,29 @@ static inline bool userfaultfd_must_wait(struct use=
rfaultfd_ctx *ctx,
>         return ret;
>  }
>
> -static inline unsigned int userfaultfd_get_blocking_state(unsigned int f=
lags)
> +struct userfault_wait {
> +       unsigned int task_state;
> +       bool timeout;
> +};
> +
> +static struct userfault_wait userfaultfd_get_blocking_state(unsigned int=
 flags)
>  {
> +       /*
> +        * If the fault has already been tried AND there's a signal pendi=
ng
> +        * for this task, use TASK_UNINTERRUPTIBLE with a small timeout.
> +        * This prevents busy looping where schedule() otherwise does not=
hing
> +        * for TASK_INTERRUPTIBLE when the task has a signal pending.
> +        */
> +       if ((flags & FAULT_FLAG_TRIED) && signal_pending(current))
> +               return (struct userfault_wait) { TASK_UNINTERRUPTIBLE, tr=
ue };
> +
>         if (flags & FAULT_FLAG_INTERRUPTIBLE)
> -               return TASK_INTERRUPTIBLE;
> +               return (struct userfault_wait) { TASK_INTERRUPTIBLE, fals=
e };
>
>         if (flags & FAULT_FLAG_KILLABLE)
> -               return TASK_KILLABLE;
> +               return (struct userfault_wait) { TASK_KILLABLE, false };
>
> -       return TASK_UNINTERRUPTIBLE;
> +       return (struct userfault_wait) { TASK_UNINTERRUPTIBLE, false };
>  }
>
>  /*
> @@ -368,7 +382,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, uns=
igned long reason)
>         struct userfaultfd_wait_queue uwq;
>         vm_fault_t ret =3D VM_FAULT_SIGBUS;
>         bool must_wait;
> -       unsigned int blocking_state;
> +       struct userfault_wait wait_mode;
>
>         /*
>          * We don't do userfault handling for the final child pid update
> @@ -466,7 +480,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, uns=
igned long reason)
>         uwq.ctx =3D ctx;
>         uwq.waken =3D false;
>
> -       blocking_state =3D userfaultfd_get_blocking_state(vmf->flags);
> +       wait_mode =3D userfaultfd_get_blocking_state(vmf->flags);
>
>          /*
>           * Take the vma lock now, in order to safely call
> @@ -488,7 +502,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, uns=
igned long reason)
>          * following the spin_unlock to happen before the list_add in
>          * __add_wait_queue.
>          */
> -       set_current_state(blocking_state);
> +       set_current_state(wait_mode.task_state);
>         spin_unlock_irq(&ctx->fault_pending_wqh.lock);
>
>         if (!is_vm_hugetlb_page(vma))
> @@ -501,7 +515,11 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, un=
signed long reason)
>
>         if (likely(must_wait && !READ_ONCE(ctx->released))) {
>                 wake_up_poll(&ctx->fd_wqh, EPOLLIN);
> -               schedule();
> +               /* See comment in userfaultfd_get_blocking_state() */
> +               if (!wait_mode.timeout)
> +                       schedule();
> +               else
> +                       schedule_timeout(HZ / 10);
>         }
>
>         __set_current_state(TASK_RUNNING);
>
> --
> Jens Axboe
I guess the previous io_work_fault patch might have already addressed the
issue sufficiently. The later patch that adds a timeout for userfaultfd mig=
ht
not be necessary  wouldn=E2=80=99t returning after a timeout just cause the=
 same
fault to repeat indefinitely again? Regardless of whether the thread is in
UN or IN state, the expected behavior should be to wait until the page is
filled or the uffd resource is released to be woken up,
which seems like the correct logic.

