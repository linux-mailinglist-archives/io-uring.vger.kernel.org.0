Return-Path: <io-uring+bounces-10074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 45953BF55C2
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 10:50:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F2B3E3A3C17
	for <lists+io-uring@lfdr.de>; Tue, 21 Oct 2025 08:50:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47D682874FF;
	Tue, 21 Oct 2025 08:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="M4aPpy71"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273EF252906
	for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 08:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036647; cv=none; b=Ad3dH9M0A5pVL9+6s1IRSJrPIRWsEB4k4caugxn7nzRJ5Ap6F/n9diq6KXwZRw3Mhrh8N81KXCwSHw4Ci5kdbXR61QcQgVkwNPDwcte3bRc6fqalcEyKLgSKByNAuV/2VDQkzWdcrQ/2tgUPbGDQzQO/ajtTL5loglyS5CLuLZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036647; c=relaxed/simple;
	bh=bGpPFMTH5utmH1Vtx3F70kOOCOlcRfrfPriYIS3t0vw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dyDzvFEoUr+9IsxopRdS9Ye1Kukc6ujfcKttoX537bBVoSVv/E7P0xbYdmgOzziwwF2QWwXphuA9CEGPxq9CJIJbQwYdRADnjqDGuG0Xom5lVSn44jT9i5QQxN4VnRD4Cus9FgrPeLIc4x4V4tAw6wldV3LEjKWE49otBRSt1aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=M4aPpy71; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-394587df7c4so2359905fac.2
        for <io-uring@vger.kernel.org>; Tue, 21 Oct 2025 01:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1761036644; x=1761641444; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z+cZFLIJD4Vf59TC8ob3K5QRan43EWnB93evF3HPxHU=;
        b=M4aPpy71byrtqcOR4V52j2wTHkSKoV0AbEojwL5QXWUGj+s0XSuB9L3po0aj6jXmSM
         4X/599PFVX3Q7KL8eM+BR7Fx/xu5naO0k6s+5SKOlLPGjnhupZIBZgFE8DKxs8iZ6c3C
         cztQYUDc28besoMcrG6BOdipy46HW7AX4tSN7DIrI6zTnWQIX2ajsKy0YogtAmxDwwvP
         lreoOixoame+CpI877sXai/rQ063GQjSTnMwG+2KomzfiOZ0Ju8v/21eZHVMfGzWFw/o
         fKfyapU5eK1qm4yA8ta99vvEQ3LGPlSoupUZ81sk2Y6NyXLfC7Zk+qqs0sS8QGbNaVcG
         QSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036644; x=1761641444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z+cZFLIJD4Vf59TC8ob3K5QRan43EWnB93evF3HPxHU=;
        b=piBA5wm6i324E5vWe6uNtSP9tt1Ffx8BfumqunsmfNEW9QEv9Ktrltd+iPmUjt9awq
         u6noqGCG0Xj0mdkCV/JtyA3dS6INGUpmUS3MdUSwLJ/lAkhgTvN8E+idiNsVIuXvuVwO
         KHWX/iWgPTgTwOJMzxY6ETKLiplAuH9D0wBg63HdcLuoTPK1rznKrotS2G+MPSqJ8aq9
         Rt67TyVIhX48jgkB7B5prnpug3sYMLZ7jhuVnn/0xBMHNPJEGZi/maSUBa+CkpFFBlcD
         j6xrxgS8VQh4I5L+c5OVHOolpB3qMFW3vJklcp83MMKO4KKUl5AHi7XxdWQrcx9phhfD
         WzFQ==
X-Forwarded-Encrypted: i=1; AJvYcCXykdqKHdT1i12cdOeVPum29EAKRtpgjyKlLqLYw1TFYFfroygB7Gy4D8RBS0qPr0XSzBgE1QKhMw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzpnxmvdsZx+A2UzCgwRnlrS42EUgTqwmNZFmdhP7R+wB2bE4vW
	WhrMboBKmDlF82YLUtUBNzrHjHA9KsPD5rS+UOtK1teN1dyJoMNcVhI2pM2rDvt0RFgnpGXPS6b
	HqxpqoTk2Sr61gPsvUNJNQOidIq5NmBkERR6a0sfUAA==
X-Gm-Gg: ASbGncukrWgt7GZoX77prQ/GQ+lbUMk5Lz+odXdcfpQsg9XUGuIO9p2qGonbyFToGnx
	f+ylp6F8DepMbeAO2sd7sIlI4cRlvnaEbtMHxM0BTRZXWK32wsR1VT2MhwAlOv4mVsL6a6zIZNW
	mOwGZiDIrz98ZSOtBCQb1XljbzcTn1sMGpQbBJo9w6ZlLuYDXh9CnC0ZD83JUXTT93j/Ny3DWy6
	8S+s8hyhKTYKs0KW7oWuFJG1CF/u1T+zM8b/e2/RDhlb4f6kDRK0CGR/ur7nw==
X-Google-Smtp-Source: AGHT+IG04VZh/SDP8rU/p0I1SBXoVMcos8aAxHkbij6nJeaWaUPBRQLM+5I2B+OEyQCHr4qSMMe/52PPeiiu3ivkENU=
X-Received: by 2002:a05:6871:7429:b0:3c9:7571:caf5 with SMTP id
 586e51a60fabf-3c98cf9509emr5742247fac.17.1761036644041; Tue, 21 Oct 2025
 01:50:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251020113031.2135-1-changfengnan@bytedance.com> <87ldl539hi.fsf@mailhost.krisman.be>
In-Reply-To: <87ldl539hi.fsf@mailhost.krisman.be>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Tue, 21 Oct 2025 16:50:33 +0800
X-Gm-Features: AS18NWClGK7Fa4W7fvaSOPQrWuUUIIDskQeWVHuvXagdQMUjU2pHaQSNl_6f0G4
Message-ID: <CAPFOzZsYa=x9hS1uw8dLNZjvdiDwtNHzi1BUThOjwT+uJ6XMpQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v2] io_uring: add IORING_SETUP_SQTHREAD_STATS
 flag to enable sqthread stats collection
To: Gabriel Krisman Bertazi <krisman@suse.de>
Cc: axboe@kernel.dk, xiaobing.li@samsung.com, asml.silence@gmail.com, 
	io-uring@vger.kernel.org, Diangang Li <lidiangang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Gabriel Krisman Bertazi <krisman@suse.de> =E4=BA=8E2025=E5=B9=B410=E6=9C=88=
20=E6=97=A5=E5=91=A8=E4=B8=80 22:59=E5=86=99=E9=81=93=EF=BC=9A
>
> Fengnan Chang <changfengnan@bytedance.com> writes:
>
> > In previous versions, getrusage was always called in sqrthread
> > to count work time, but this could incur some overhead.
> > This patch turn off stats by default, and introduces a new flag
> > IORING_SETUP_SQTHREAD_STATS that allows user to enable the
> > collection of statistics in the sqthread.
> >
> > ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 ./testfile
> > IOPS base: 570K, patch: 590K
> >
> > ./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 /dev/nvme1n1
> > IOPS base: 826K, patch: 889K
> >
> > Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
> > Reviewed-by: Diangang Li <lidiangang@bytedance.com>
> > ---
> >  include/uapi/linux/io_uring.h |  5 +++++
> >  io_uring/fdinfo.c             | 15 ++++++++++-----
> >  io_uring/io_uring.h           |  3 ++-
> >  io_uring/sqpoll.c             | 10 +++++++---
> >  io_uring/sqpoll.h             |  1 +
> >  5 files changed, 25 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_urin=
g.h
> > index 263bed13473e..8c5cb9533950 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -231,6 +231,11 @@ enum io_uring_sqe_flags_bit {
> >   */
> >  #define IORING_SETUP_CQE_MIXED               (1U << 18)
> >
> > +/*
> > + * Enable SQPOLL thread stats collection
> > + */
> > +#define IORING_SETUP_SQTHREAD_STATS  (1U << 19)
> > +
> >  enum io_uring_op {
> >       IORING_OP_NOP,
> >       IORING_OP_READV,
> > diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
> > index ff3364531c77..4c532e414255 100644
> > --- a/io_uring/fdinfo.c
> > +++ b/io_uring/fdinfo.c
> > @@ -154,13 +154,16 @@ static void __io_uring_show_fdinfo(struct io_ring=
_ctx *ctx, struct seq_file *m)
> >               if (tsk) {
> >                       get_task_struct(tsk);
> >                       rcu_read_unlock();
> > -                     getrusage(tsk, RUSAGE_SELF, &sq_usage);
> > +                     if (sq->enable_work_time_stat)
> > +                             getrusage(tsk, RUSAGE_SELF, &sq_usage);
> >                       put_task_struct(tsk);
>
> If the usage statistics are disabled, you don't need to acquire and drop
> the task_struct reference any longer.  you can move the get/put_task_stru=
ct
> into the if.

I'll fix this in next version.

>
> >                       sq_pid =3D sq->task_pid;
> >                       sq_cpu =3D sq->sq_cpu;
> > -                     sq_total_time =3D (sq_usage.ru_stime.tv_sec * 100=
0000
> > +                     if (sq->enable_work_time_stat) {
> > +                             sq_total_time =3D (sq_usage.ru_stime.tv_s=
ec * 1000000
> >                                        + sq_usage.ru_stime.tv_usec);
> > -                     sq_work_time =3D sq->work_time;
> > +                             sq_work_time =3D sq->work_time;
> > +                     }
> >               } else {
> >                       rcu_read_unlock();
> >               }
> > @@ -168,8 +171,10 @@ static void __io_uring_show_fdinfo(struct io_ring_=
ctx *ctx, struct seq_file *m)
> >
> >       seq_printf(m, "SqThread:\t%d\n", sq_pid);
> >       seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
> > -     seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
> > -     seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
> > +     if (ctx->flags & IORING_SETUP_SQTHREAD_STATS) {
> > +             seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
> > +             seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
> > +     }
>
> It works, but it is weird that you gate the writing of sq_total_time on
> (sq->enable_work_time_stat) and then, the display of it on (ctx->flags &
> IORING_SETUP_SQTHREAD_STATS).  Since a sqpoll can attend to more than
> one ctx, I'd just check ctx->flags & IORING_SETUP_SQTHREAD_STATS
> in both places in this function.
Yeh, there's a bit of a problem here, I was going to use check
ctx->flags & IORING_SETUP_SQTHREAD_STATS, but in io_sq_thread, getrusage
is try to account multi ctx, and can't get ctx before getrusage, so I use
enable_work_time_stat, and I missed something. I would like to use
enable_work_time_stat in both places in this function.

>
> >       seq_printf(m, "UserFiles:\t%u\n", ctx->file_table.data.nr);
> >       for (i =3D 0; i < ctx->file_table.data.nr; i++) {
> >               struct file *f =3D NULL;
> > diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
> > index 46d9141d772a..949dc7cba111 100644
> > --- a/io_uring/io_uring.h
> > +++ b/io_uring/io_uring.h
> > @@ -54,7 +54,8 @@
> >                       IORING_SETUP_REGISTERED_FD_ONLY |\
> >                       IORING_SETUP_NO_SQARRAY |\
> >                       IORING_SETUP_HYBRID_IOPOLL |\
> > -                     IORING_SETUP_CQE_MIXED)
> > +                     IORING_SETUP_CQE_MIXED |\
> > +                     IORING_SETUP_SQTHREAD_STATS)
> >
> >  #define IORING_ENTER_FLAGS (IORING_ENTER_GETEVENTS |\
> >                       IORING_ENTER_SQ_WAKEUP |\
> > diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
> > index a3f11349ce06..46bcd4854abc 100644
> > --- a/io_uring/sqpoll.c
> > +++ b/io_uring/sqpoll.c
> > @@ -161,6 +161,7 @@ static struct io_sq_data *io_get_sq_data(struct io_=
uring_params *p,
> >       mutex_init(&sqd->lock);
> >       init_waitqueue_head(&sqd->wait);
> >       init_completion(&sqd->exited);
> > +     sqd->enable_work_time_stat =3D false;
> >       return sqd;
> >  }
> >
> > @@ -317,7 +318,8 @@ static int io_sq_thread(void *data)
> >               }
> >
> >               cap_entries =3D !list_is_singular(&sqd->ctx_list);
> > -             getrusage(current, RUSAGE_SELF, &start);
> > +             if (sqd->enable_work_time_stat)
> > +                     getrusage(current, RUSAGE_SELF, &start);
> >               list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
> >                       int ret =3D __io_sq_thread(ctx, cap_entries);
> >
> > @@ -333,7 +335,8 @@ static int io_sq_thread(void *data)
> >
> >               if (sqt_spin || !time_after(jiffies, timeout)) {
> >                       if (sqt_spin) {
> > -                             io_sq_update_worktime(sqd, &start);
> > +                             if (sqd->enable_work_time_stat)
> > +                                     io_sq_update_worktime(sqd, &start=
);
> >                               timeout =3D jiffies + sqd->sq_thread_idle=
;
> >                       }
> >                       if (unlikely(need_resched())) {
> > @@ -445,7 +448,8 @@ __cold int io_sq_offload_create(struct io_ring_ctx =
*ctx,
> >                       ret =3D PTR_ERR(sqd);
> >                       goto err;
> >               }
> > -
> > +             if (ctx->flags & IORING_SETUP_SQTHREAD_STATS)
> > +                     sqd->enable_work_time_stat =3D true;
> >               ctx->sq_creds =3D get_current_cred();
> >               ctx->sq_data =3D sqd;
> >               ctx->sq_thread_idle =3D msecs_to_jiffies(p->sq_thread_idl=
e);
> > diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
> > index b83dcdec9765..55f2e4d46d54 100644
> > --- a/io_uring/sqpoll.h
> > +++ b/io_uring/sqpoll.h
> > @@ -19,6 +19,7 @@ struct io_sq_data {
> >       u64                     work_time;
> >       unsigned long           state;
> >       struct completion       exited;
> > +     bool                    enable_work_time_stat;
> >  };
> >
> >  int io_sq_offload_create(struct io_ring_ctx *ctx, struct io_uring_para=
ms *p);
>
> --
> Gabriel Krisman Bertazi

