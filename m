Return-Path: <io-uring+bounces-8092-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BB28CAC1E10
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 09:58:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6A31B1C02728
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 07:58:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC822DCBED;
	Fri, 23 May 2025 07:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="hFB2M3UN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B0C1D54F7
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 07:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747987068; cv=none; b=ug3yS+NRnz8yvXVE1j7NUL4kaBuwsNFwsh+TG7dHmTf3UcsjPLwaj0mRvlVgA0dYaqw5LyFYhhpvq1LwDxcr0fHmjRthni3+kApnFNhJQhqhtEqdOHAiz8pnBRLmPDuXpurxmzpJdoZfbWalgpPORzUafkyzOtn0FF2ytY0xKwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747987068; c=relaxed/simple;
	bh=kWFlhpsvbBWtw3ItLlvrZhTCAwhsnI+20C6m51jrORY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T7suTjTowTPtC0duLldf6iBKOm6FC0gktiCRYRUozn1cdTPXfjsgZ/iLn3SIgUULJyzelJibR/RBjLJngkoSXv/dcTZNMsyfSaqCjD3zNIogrF9nZLhoEIK4EgZQvMp1JTYx3+lRZBcjLYIFzqIlcqQe3aoNSRcQcTn7/uu/CUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=hFB2M3UN; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7303d9d5edeso3096793a34.1
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 00:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1747987065; x=1748591865; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=31+YwiD5hNniGustxo8e3/u0hByDwLmtuChBeJMjCto=;
        b=hFB2M3UNzyX/shd7LcIGrPIX5zGsE54tx2AuEdpBa1fMhwMcVX6oAP2t7ul2bWTXqo
         zNqvz7QjgebXaw4HcU+0nLph0IkKWqlYCClirlSQwgDhkhH/okymXRlhQEh1XsXbGXRC
         JxH9LyEBmlgRuIsfrW8VuWPeXBW0pPqd6Oo496a7RNGW+4Nme7HlwCuHgrDoynGJizpR
         4tyVNIqY8RHM63L8h+ZeGaFVAXLXFO5KNM/Xk+Fz9Y27DWAqGzJz3LdOUW7S2h8y7Lxi
         too3SxK0ge9xVoJ2wLbqsTbxG3g2e+Si9s/jPkC9IFtAXCiiNv8U+mEPSbsf2bE/l1Zq
         XLXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747987065; x=1748591865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=31+YwiD5hNniGustxo8e3/u0hByDwLmtuChBeJMjCto=;
        b=WFWhtKpmEPiEI+ti2pr5HfNN1DYB+KWia2f1HeXv2IBWSL/yMqTqT/y9GPWzw5QFgJ
         UgVe+44Xdo0xviTbvTBCqZ0ByIzZbhSflQKF3apRmO/Ntfd2xJFrhA/Ugzi/bKzR4daY
         OEYdDORlDkD6TQldVCBTSev5FbG9O6eDMrVNDwFYT6fSN4Rd1KN9xYaS2P6WupnC3pZs
         lhFPfnFYDAd9WiyNlWJrvq0G8i+W9iLH1kltpR0TGeZPA69JbVJUUjq0iQQARFHfbPax
         ZTWZysUkbte5n90wF7tp9FKxJOkxCiGu9lqHFUAlTAenPRWH/+wijCBufnSbWwod9S+U
         Pg1w==
X-Forwarded-Encrypted: i=1; AJvYcCX1B7CN4D+vSgLgKGslz+p357Cf9SUZhp8F+fV4AymwCSwSCClIqTir7Whkb3PpqA+KQu4jk15VVw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZn0InBhqSfH2x7h+NXgK0Xm0xWA5AyQ7f6RvISZSupuU7dHsR
	PckUZ5aeMfgj3+fuVQWq9KJpSALBPjNdH3bWQwEmveFD1jzczrN7ideNvGHhKt+sDpymsQbYfft
	7cqmpmxmPwhS3An0UU3ZTMikoVYNFt+m2P9FEk8sr/w==
X-Gm-Gg: ASbGncuE1XupIeCLBAAWHAYkN78IVSItJhKlW7OkBEfQ77HbdG0m4+FNdW8dnB+ZRRq
	XiSz+OWD2nMcIKZajS3OBk4KVHsuDHBs0FVfXbuR5q0kqieUA6S7QNucY5Ma+fxbgxt914tqpU9
	1oPCuPljXn27DjSvRzlAHcsvey7YzKpT3A2g==
X-Google-Smtp-Source: AGHT+IFew3VEkj5cATTk3wSeFy5HwSVDJboQ9VqjoRBM8NwPSUKuUHIUPDAJRr2Ds5F97I7xsSR3J1Z1yfzBoRZSvyQ=
X-Received: by 2002:a05:6871:2792:b0:2e3:d029:86e with SMTP id
 586e51a60fabf-2e3d029a1a8mr12866579fac.4.1747987065317; Fri, 23 May 2025
 00:57:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522090909.73212-1-changfengnan@bytedance.com>
 <b8cd8947-76fa-4863-a1f6-119c6d086196@kernel.dk> <CAPFOzZtxRYsCg1BVdpDUH=_bsLEQRvsp5+x-7Kpwow66poUVtA@mail.gmail.com>
 <356c5068-bd97-419a-884c-bcdb04ad6820@kernel.dk>
In-Reply-To: <356c5068-bd97-419a-884c-bcdb04ad6820@kernel.dk>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Fri, 23 May 2025 15:57:34 +0800
X-Gm-Features: AX0GCFsH6gS16VkNNmyRxSBdtbjbvvgqs2FDWv3beQ8pCrQdYG1yw1yQizwEVYc
Message-ID: <CAPFOzZtxXOQvC0wcNLaj-hZUOf2PWqon0uEvbQh7if7a7DdX=g@mail.gmail.com>
Subject: Re: [External] Re: [RFC PATCH] io_uring: fix io worker thread that
 keeps creating and destroying
To: Jens Axboe <axboe@kernel.dk>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, 
	Diangang Li <lidiangang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B45=E6=9C=8822=E6=97=A5=E5=
=91=A8=E5=9B=9B 22:29=E5=86=99=E9=81=93=EF=BC=9A
>
> On 5/22/25 6:01 AM, Fengnan Chang wrote:
> > Jens Axboe <axboe@kernel.dk> ?2025?5?22??? 19:35???
> >>
> >> On 5/22/25 3:09 AM, Fengnan Chang wrote:
> >>> When running fio with buffer io and stable iops, I observed that
> >>> part of io_worker threads keeps creating and destroying.
> >>> Using this command can reproduce:
> >>> fio --ioengine=3Dio_uring --rw=3Drandrw --bs=3D4k --direct=3D0 --size=
=3D100G
> >>> --iodepth=3D256 --filename=3D/data03/fio-rand-read --name=3Dtest
> >>> ps -L -p pid, you can see about 256 io_worker threads, and thread
> >>> id keeps changing.
> >>> And I do some debugging, most workers create happen in
> >>> create_worker_cb. In create_worker_cb, if all workers have gone to
> >>> sleep, and we have more work, we try to create new worker (let's
> >>> call it worker B) to handle it.  And when new work comes,
> >>> io_wq_enqueue will activate free worker (let's call it worker A) or
> >>> create new one. It may cause worker A and B compete for one work.
> >>> Since buffered write is hashed work, buffered write to a given file
> >>> is serialized, only one worker gets the work in the end, the other
> >>> worker goes to sleep. After repeating it many times, a lot of
> >>> io_worker threads created, handles a few works or even no work to
> >>> handle,and exit.
> >>> There are several solutions:
> >>> 1. Since all work is insert in io_wq_enqueue, io_wq_enqueue will
> >>> create worker too, remove create worker action in create_worker_cb
> >>> is fine, maybe affect performance?
> >>> 2. When wq->hash->map bit is set, insert hashed work item, new work
> >>> only put in wq->hash_tail, not link to work_list,
> >>> io_worker_handle_work need to check hash_tail after a whole dependent
> >>> link, io_acct_run_queue will return false when new work insert, no
> >>> new thread will be created either in io_wqe_dec_running.
> >>> 3. Check is there only one hash bucket in io_wqe_dec_running. If only
> >>> one hash bucket, don't create worker, io_wq_enqueue will handle it.
> >>
> >> Nice catch on this! Does indeed look like a problem. Not a huge fan of
> >> approach 3. Without having really looked into this yet, my initial ide=
a
> >> would've been to do some variant of solution 1 above. io_wq_enqueue()
> >> checks if we need to create a worker, which basically boils down to "d=
o
> >> we have a free worker right now". If we do not, we create one. But the
> >> question is really "do we need a new worker for this?", and if we're
> >> inserting hashed worked and we have existing hashed work for the SAME
> >> hash and it's busy, then the answer should be "no" as it'd be pointles=
s
> >> to create that worker.
> >
> > Agree
> >
> >>
> >> Would it be feasible to augment the check in there such that
> >> io_wq_enqueue() doesn't create a new worker for that case? And I guess=
 a
> >> followup question is, would that even be enough, do we always need to
> >> cover the io_wq_dec_running() running case as well as
> >> io_acct_run_queue() will return true as well since it doesn't know abo=
ut
> >> this either?
> > Yes?It is feasible to avoid creating a worker by adding some checks in
> > io_wq_enqueue. But what I have observed so far is most workers are
> > created in io_wq_dec_running (why no worker create in io_wq_enqueue?
> > I didn't figure it out now), it seems no need to check this
> > in io_wq_enqueue.  And cover io_wq_dec_running is necessary.
>
> The general concept for io-wq is that it's always assumed that a worker
> won't block, and if it does AND more work is available, at that point a
> new worker is created. io_wq_dec_running() is called by the scheduler
> when a worker is scheduled out, eg blocking, and then an extra worker is
> created at that point, if necessary.
>
> I wonder if we can get away with something like the below? Basically two
> things in there:
>
> 1) If a worker goes to sleep AND it doesn't have a current work
>    assigned, just ignore it. Really a separate change, but seems to
>    conceptually make sense - a new worker should only be created off
>    that path, if it's currenly handling a work item and goes to sleep.
>
> 2) If there is current work, defer if it's hashed and the next work item
>    in that list is also hashed and of the same value.
I like this change, this makes the logic clearer. This patch looks good,
I'll do more tests next week.

>
>
> diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
> index d52069b1177b..cd1fcb115739 100644
> --- a/io_uring/io-wq.c
> +++ b/io_uring/io-wq.c
> @@ -150,6 +150,16 @@ static bool io_acct_cancel_pending_work(struct io_wq=
 *wq,
>  static void create_worker_cb(struct callback_head *cb);
>  static void io_wq_cancel_tw_create(struct io_wq *wq);
>
> +static inline unsigned int __io_get_work_hash(unsigned int work_flags)
> +{
> +       return work_flags >> IO_WQ_HASH_SHIFT;
> +}
> +
> +static inline unsigned int io_get_work_hash(struct io_wq_work *work)
> +{
> +       return __io_get_work_hash(atomic_read(&work->flags));
> +}
> +
>  static bool io_worker_get(struct io_worker *worker)
>  {
>         return refcount_inc_not_zero(&worker->ref);
> @@ -409,6 +419,30 @@ static bool io_queue_worker_create(struct io_worker =
*worker,
>         return false;
>  }
>
> +/* Defer if current and next work are both hashed to the same chain */
> +static bool io_wq_hash_defer(struct io_wq_work *work, struct io_wq_acct =
*acct)
> +{
> +       unsigned int hash, work_flags;
> +       struct io_wq_work *next;
> +
> +       lockdep_assert_held(&acct->lock);
> +
> +       work_flags =3D atomic_read(&work->flags);
> +       if (!__io_wq_is_hashed(work_flags))
> +               return false;
> +
> +       /* should not happen, io_acct_run_queue() said we had work */
> +       if (wq_list_empty(&acct->work_list))
> +               return true;
> +
> +       hash =3D __io_get_work_hash(work_flags);
> +       next =3D container_of(acct->work_list.first, struct io_wq_work, l=
ist);
> +       work_flags =3D atomic_read(&next->flags);
> +       if (!__io_wq_is_hashed(work_flags))
> +               return false;
> +       return hash =3D=3D __io_get_work_hash(work_flags);
> +}
> +
>  static void io_wq_dec_running(struct io_worker *worker)
>  {
>         struct io_wq_acct *acct =3D io_wq_get_acct(worker);
> @@ -419,8 +453,14 @@ static void io_wq_dec_running(struct io_worker *work=
er)
>
>         if (!atomic_dec_and_test(&acct->nr_running))
>                 return;
> +       if (!worker->cur_work)
> +               return;
>         if (!io_acct_run_queue(acct))
>                 return;
> +       if (io_wq_hash_defer(worker->cur_work, acct)) {
> +               raw_spin_unlock(&acct->lock);
> +               return;
> +       }
>
>         raw_spin_unlock(&acct->lock);
>         atomic_inc(&acct->nr_running);
> @@ -454,16 +494,6 @@ static void __io_worker_idle(struct io_wq_acct *acct=
, struct io_worker *worker)
>         }
>  }
>
> -static inline unsigned int __io_get_work_hash(unsigned int work_flags)
> -{
> -       return work_flags >> IO_WQ_HASH_SHIFT;
> -}
> -
> -static inline unsigned int io_get_work_hash(struct io_wq_work *work)
> -{
> -       return __io_get_work_hash(atomic_read(&work->flags));
> -}
> -
>  static bool io_wait_on_hash(struct io_wq *wq, unsigned int hash)
>  {
>         bool ret =3D false;
>
> --
> Jens Axboe

