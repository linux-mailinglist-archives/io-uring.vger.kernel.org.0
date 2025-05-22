Return-Path: <io-uring+bounces-8072-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5026CAC0AFE
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 14:01:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F11B44E763B
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 12:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 190032135CB;
	Thu, 22 May 2025 12:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="OHAMAG4C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B5C1DF965
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 12:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747915290; cv=none; b=XxHQQb0mOJ8ywSRZQdQhZS86DFly/+E9seocGJ1rCuywfFuUC/8vhjdIDZzyq7c9JCTFK5tlS9ZNxgAUqDR07g3n361FQqLPuGKEbUuwB3RRx7JjzOROqDsV+bHiC4rN39y6RkWOPBMH6IgCb/dzY88q451eVqmGcD8ZFKgWgl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747915290; c=relaxed/simple;
	bh=GhZeLzoJWGZOm4BxuopAfxvdhO/uvdoahziCxijPIuY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Cr4EPN8osbZb/0nRG162/CPGlS4Mh4qlA+7c9vhNwuZ3eQ6kjFkfdzaPpqS+JOyz5vvbXV3eUkr/NlFbsN0H/TcCsxQs7UnBfcT2WJg0wngg78+dmvHlsKmV7nfL4PE282UGZbt6agnoEPMYw8dSFm2tGGUQhw6AKhvbuBr2dU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=OHAMAG4C; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2d9b61e02d1so2311450fac.2
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 05:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1747915286; x=1748520086; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YyggFob9sRNy2t1hj1Lm94WDKgJBKbM3Y6yGvQfBdLg=;
        b=OHAMAG4CKroqku6RXDBc5Oo7mvaKPemxM68CabRVYIKcwt3EqTgY02jDWA+pReDS7A
         F23xcMPLCFDETiCiUP5KRa122Yw5qxA55m4to/iH3yDkBWE3bGveJpHbZoi6o6qjam0G
         NywXLi6XUCMSCn+Qc8RWkDVFFxiABxa96q1w43vhaxclP2yIili6CIS3ZA5hSgGDc6LL
         7r/eAiJj749bIMUKIOEW+38CTnNWGPxp3H7zlp9MobGOS87VLJkIlJCZLpJpqEBGIxSk
         dHncvClGsGyptVQgjkQYMw5ZqhL7aar0LTmD7B72LPV8VnLSvugPs5qQgO9L5SG3d340
         rIqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747915286; x=1748520086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YyggFob9sRNy2t1hj1Lm94WDKgJBKbM3Y6yGvQfBdLg=;
        b=pVEyFvUMjjuPrK3RzOohbo6ZoLQIj7y7GlGOyrTkLcBX1O3WDViU668HMHvN2DOE+4
         F/ZnY1ZgdwY91DTM1Ndjy+JTBjnOM/zsB9vvzj52IOgUiS25gJ4t+iulEPOK0NL5Wy7L
         8YVlrRKt7hWV74mCiStC1l15jj1IusNyG6PL3e6UZbBYIS3yO2NZlzGkV8TcUeaFsdCa
         I9UfF6Tdzrikd9wdPvfCDpYivhAmJkC2tb2sHqffQd3sbD4UuT4sLkBfxrKz2ObZOGUL
         tqLRtYCw3FB4emE5H01JzCa+5nVwMOf3SHcVwmtot355NeTctrZuooXi7PkDJ5/+95Rr
         E6ww==
X-Forwarded-Encrypted: i=1; AJvYcCWu2oGELA5aBa7w0QBfLdpAMlKqsqlzU5Xgpkq8iWQ7Apu7LCCywpgfI6wxN3w8xb3mIck8rDpVyA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyV19QJVwJgefKaOoasX1KisnaXFxQ8i9RR5YPhP3X2wnt9hLtC
	h7yebQtL5wWlILQupR+8Xr3C2Dp4lUodTzYrPiTSfoRLujrBN7ZRvI0gNdwbm3zqmM0YMPoJwE7
	7kPRYBPtTzKK7SwJw7ZRXU+ND68HmIEJ7Db9fnjoCwg==
X-Gm-Gg: ASbGncvIblt221xgpg+h71poOwyh7C/Qd/U7EtBQ5/1WCntUz0mMpZccqtmi2xqDDWU
	4V0m+e4TKsxUWLer86Lnki0EfwyzLPFxz6SQYAlO9idtXrNOg6uvg/mIRL83CPB8ffv+st2z18B
	wFe9W5Mlj9gHE7KSqnPpnwkgFZG/MWZXkxVw==
X-Google-Smtp-Source: AGHT+IFZCV3fiex3dmkpEIFMAOP3bcBdEagCKtrfBKS55Q+LQM9dxgKAfurTsiezOnGMt5mEvHiLemDEEH1dBT49AYk=
X-Received: by 2002:a05:6870:e416:b0:2d5:817a:9dfa with SMTP id
 586e51a60fabf-2e3c85e8ee3mr11980543fac.38.1747915286097; Thu, 22 May 2025
 05:01:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522090909.73212-1-changfengnan@bytedance.com> <b8cd8947-76fa-4863-a1f6-119c6d086196@kernel.dk>
In-Reply-To: <b8cd8947-76fa-4863-a1f6-119c6d086196@kernel.dk>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Thu, 22 May 2025 20:01:15 +0800
X-Gm-Features: AX0GCFvKIcfUEvqZXX7L5pb2ygk7SBUe8zwkr1Cd4tUrDSXoUdS4Zp8q3LS6ikw
Message-ID: <CAPFOzZtxRYsCg1BVdpDUH=_bsLEQRvsp5+x-7Kpwow66poUVtA@mail.gmail.com>
Subject: Re: [External] Re: [RFC PATCH] io_uring: fix io worker thread that
 keeps creating and destroying
To: Jens Axboe <axboe@kernel.dk>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, 
	Diangang Li <lidiangang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B45=E6=9C=8822=E6=97=A5=E5=
=91=A8=E5=9B=9B 19:35=E5=86=99=E9=81=93=EF=BC=9A
>
> On 5/22/25 3:09 AM, Fengnan Chang wrote:
> > When running fio with buffer io and stable iops, I observed that
> > part of io_worker threads keeps creating and destroying.
> > Using this command can reproduce:
> > fio --ioengine=3Dio_uring --rw=3Drandrw --bs=3D4k --direct=3D0 --size=
=3D100G
> > --iodepth=3D256 --filename=3D/data03/fio-rand-read --name=3Dtest
> > ps -L -p pid, you can see about 256 io_worker threads, and thread
> > id keeps changing.
> > And I do some debugging, most workers create happen in
> > create_worker_cb. In create_worker_cb, if all workers have gone to
> > sleep, and we have more work, we try to create new worker (let's
> > call it worker B) to handle it.  And when new work comes,
> > io_wq_enqueue will activate free worker (let's call it worker A) or
> > create new one. It may cause worker A and B compete for one work.
> > Since buffered write is hashed work, buffered write to a given file
> > is serialized, only one worker gets the work in the end, the other
> > worker goes to sleep. After repeating it many times, a lot of
> > io_worker threads created, handles a few works or even no work to
> > handle,and exit.
> > There are several solutions:
> > 1. Since all work is insert in io_wq_enqueue, io_wq_enqueue will
> > create worker too, remove create worker action in create_worker_cb
> > is fine, maybe affect performance?
> > 2. When wq->hash->map bit is set, insert hashed work item, new work
> > only put in wq->hash_tail, not link to work_list,
> > io_worker_handle_work need to check hash_tail after a whole dependent
> > link, io_acct_run_queue will return false when new work insert, no
> > new thread will be created either in io_wqe_dec_running.
> > 3. Check is there only one hash bucket in io_wqe_dec_running. If only
> > one hash bucket, don't create worker, io_wq_enqueue will handle it.
>
> Nice catch on this! Does indeed look like a problem. Not a huge fan of
> approach 3. Without having really looked into this yet, my initial idea
> would've been to do some variant of solution 1 above. io_wq_enqueue()
> checks if we need to create a worker, which basically boils down to "do
> we have a free worker right now". If we do not, we create one. But the
> question is really "do we need a new worker for this?", and if we're
> inserting hashed worked and we have existing hashed work for the SAME
> hash and it's busy, then the answer should be "no" as it'd be pointless
> to create that worker.

Agree

>
> Would it be feasible to augment the check in there such that
> io_wq_enqueue() doesn't create a new worker for that case? And I guess a
> followup question is, would that even be enough, do we always need to
> cover the io_wq_dec_running() running case as well as
> io_acct_run_queue() will return true as well since it doesn't know about
> this either?
Yes=EF=BC=8CIt is feasible to avoid creating a worker by adding some checks=
 in
io_wq_enqueue. But what I have observed so far is most workers are
created in io_wq_dec_running (why no worker create in io_wq_enqueue?
I didn't figure it out now), it seems no need to check this
in io_wq_enqueue.  And cover io_wq_dec_running is necessary.

>
> I'll take a closer look at this later today, but figured I'd shoot some
> questions your way first...
>
> --
> Jens Axboe

