Return-Path: <io-uring+bounces-8114-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C224AC3E5D
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 13:14:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A5E0176FF9
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 11:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E256B1F8937;
	Mon, 26 May 2025 11:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="hiBGbtDl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f42.google.com (mail-oa1-f42.google.com [209.85.160.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27EC1F8EEC
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 11:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748258079; cv=none; b=EVQ+ZHUL54w1a/Hpz/f86bXbYyP3k+eEenPI9YyaPkOtYIxuin87YujOA+URoCK/t1PJeiXfaenenUeq9dANyyqYtiyKD9mgQRi63cJtS9rJo5eP8uIYxL0l2V8eNJ6tAA9gEQsc+0+IIDYL3ZYpAHrbr/bIUbor0j61GiFVGC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748258079; c=relaxed/simple;
	bh=I0vbLiqkEOkXlTz6U+TCuXNNcqaRZnKxw00XjsZWs5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nyQXYhByqjIQfK6TfN4R6WfMk8CehZr+FYwqFug3YyorM+QEasd1rPMlSCd/gAxib6Lv1df8xKc0BvR7ak20U39LpLoaqLia7DUb3IdJVF8ssLWndFkHiIOOu+9vOWOrQpsvmRr3mO/4BIeu1FzTTfEUQyHkg6+Z0zUzuV2mfSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=hiBGbtDl; arc=none smtp.client-ip=209.85.160.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-oa1-f42.google.com with SMTP id 586e51a60fabf-2c2504fa876so700190fac.0
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 04:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1748258076; x=1748862876; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w7BQnDkafYW9TLsu7y6gHJgQ8MUwXK8+Ykk6TXJ6LaM=;
        b=hiBGbtDloGCRADwxZj47BhjRmMhIDcj2u8/9L6JBO3BkR4+j7fKF7lrYAyVw63gYxB
         KXseqi7JWYMvg41k3odaEVGe5iq9noO26wf78gO+XjT082+c8XbAT6fWaBdMKyeN7KVv
         TxayD1fNfw39VGm4NmHnBZkt3bxzGlAXUHbmGyxjWjvlMAsoqqkGg0aJrAomWKnsk5k2
         RTOdZ3ZL0fX7QVV7f2n0JTlCXEZyH611iiJmvcgXc2aCb6LcmZZNytuKPHqHcJ0VrMsw
         6pRXdPFhpO6Nx7wKgEQqBpsv9BTg0XYPFa0VUhM8zbgC76QKG/WN7fEr6CNVFTxPuoiX
         nDxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748258076; x=1748862876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w7BQnDkafYW9TLsu7y6gHJgQ8MUwXK8+Ykk6TXJ6LaM=;
        b=oREvw4xXGWkMq28WZp662MKgsiKyqhXAgsF3k5eSr/mxAeCcKusq++oALGFmuBYK7E
         LG5hv+cenSBOcX6tiIBnvP0YgSqF4WCqsHJovXdsOfo/Nd2kxaOfwZUtomsOzZ6ifhoy
         gIBKPoxzGBNjA8d57A2ThLSke1q5zosKH0SkTQ6LTMzQ56RRD2ETEyh11MEgmSbcURq5
         rWcU+w7B9PQQCzEJPaWAVLCzRoyok6cXKw34c+fpQ5/2vtnOSV6vlmTwOlLHp8DtxWVQ
         BizyBX0dtI6MqpuDz7BXgsYQd23xp+PLpPR0ZvfgGUrP+bSjIyThI/iJku39z9MIB+hP
         L8Ow==
X-Forwarded-Encrypted: i=1; AJvYcCWxnV5OfoTroLvEqJqOp7Hv5BdJojxpzrfKXJeX7fQ/q0j1/8g+JcYAP8GIDau7dNu97BHXYBX0cQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJqMFL5ghpAGogDz8khZ5qMPt66YP/xnGW4kmAjuynmHy7C8Mb
	Co4Mf8mlqI63+9QKZzrhwzIfmifv18CJenI1+44hzzy72wdUAS9B707z8LxfFQUXTkX+QUD8vhu
	7LQR9Fc9LnrAaKR2Nq9nGhnPI4biG+UK2VGuu2H5WKA==
X-Gm-Gg: ASbGncsi4DZZwRmj9J4X7L1K1kXHrRSqReRLSAraI7QDyVCIWC/cqE9A2K7l/lpYbrN
	1IOjxiH8VOxPl9//r2P85cc5NMY2A7Y2rd98eAhud7+dJ6n70ENOhJnehKkij9CxdNHnlp1uWWF
	PrFKU9ZQuRqxeMf21QWuSP8O+wL0tifYRJYw==
X-Google-Smtp-Source: AGHT+IF407VHXOCsHlXJ+nkC1Qyj41H0Zr28GeK7Dt44B4dqVzIkVoTXAdyp6PZqiMeyyK0GCVvUoLtHOQg6Jpc/aX8=
X-Received: by 2002:a05:6870:3c0c:b0:2d5:1725:f529 with SMTP id
 586e51a60fabf-2e862053d36mr4695933fac.27.1748258076559; Mon, 26 May 2025
 04:14:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522090909.73212-1-changfengnan@bytedance.com>
 <b8cd8947-76fa-4863-a1f6-119c6d086196@kernel.dk> <CAPFOzZtxRYsCg1BVdpDUH=_bsLEQRvsp5+x-7Kpwow66poUVtA@mail.gmail.com>
 <356c5068-bd97-419a-884c-bcdb04ad6820@kernel.dk> <CAPFOzZtxXOQvC0wcNLaj-hZUOf2PWqon0uEvbQh7if7a7DdX=g@mail.gmail.com>
 <7bf620dc-1b5c-4401-a03c-16978de0598a@kernel.dk>
In-Reply-To: <7bf620dc-1b5c-4401-a03c-16978de0598a@kernel.dk>
From: Fengnan Chang <changfengnan@bytedance.com>
Date: Mon, 26 May 2025 19:14:25 +0800
X-Gm-Features: AX0GCFvKQtkF9UDot9Kipbk79Lf5w7PjjF8CWQzzwA3pUZyy5FGzudcIKQRg86A
Message-ID: <CAPFOzZvajLPeCk7OOWoww8XdtA3mSkT+hkuMomBt=5pqMZ29SQ@mail.gmail.com>
Subject: Re: [External] Re: [RFC PATCH] io_uring: fix io worker thread that
 keeps creating and destroying
To: Jens Axboe <axboe@kernel.dk>
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org, 
	Diangang Li <lidiangang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B45=E6=9C=8823=E6=97=A5=E5=
=91=A8=E4=BA=94 23:20=E5=86=99=E9=81=93=EF=BC=9A
>
> On 5/23/25 1:57 AM, Fengnan Chang wrote:
> > Jens Axboe <axboe@kernel.dk> ?2025?5?22??? 22:29???
> >>
> >> On 5/22/25 6:01 AM, Fengnan Chang wrote:
> >>> Jens Axboe <axboe@kernel.dk> ?2025?5?22??? 19:35???
> >>>>
> >>>> On 5/22/25 3:09 AM, Fengnan Chang wrote:
> >>>>> When running fio with buffer io and stable iops, I observed that
> >>>>> part of io_worker threads keeps creating and destroying.
> >>>>> Using this command can reproduce:
> >>>>> fio --ioengine=3Dio_uring --rw=3Drandrw --bs=3D4k --direct=3D0 --si=
ze=3D100G
> >>>>> --iodepth=3D256 --filename=3D/data03/fio-rand-read --name=3Dtest
> >>>>> ps -L -p pid, you can see about 256 io_worker threads, and thread
> >>>>> id keeps changing.
> >>>>> And I do some debugging, most workers create happen in
> >>>>> create_worker_cb. In create_worker_cb, if all workers have gone to
> >>>>> sleep, and we have more work, we try to create new worker (let's
> >>>>> call it worker B) to handle it.  And when new work comes,
> >>>>> io_wq_enqueue will activate free worker (let's call it worker A) or
> >>>>> create new one. It may cause worker A and B compete for one work.
> >>>>> Since buffered write is hashed work, buffered write to a given file
> >>>>> is serialized, only one worker gets the work in the end, the other
> >>>>> worker goes to sleep. After repeating it many times, a lot of
> >>>>> io_worker threads created, handles a few works or even no work to
> >>>>> handle,and exit.
> >>>>> There are several solutions:
> >>>>> 1. Since all work is insert in io_wq_enqueue, io_wq_enqueue will
> >>>>> create worker too, remove create worker action in create_worker_cb
> >>>>> is fine, maybe affect performance?
> >>>>> 2. When wq->hash->map bit is set, insert hashed work item, new work
> >>>>> only put in wq->hash_tail, not link to work_list,
> >>>>> io_worker_handle_work need to check hash_tail after a whole depende=
nt
> >>>>> link, io_acct_run_queue will return false when new work insert, no
> >>>>> new thread will be created either in io_wqe_dec_running.
> >>>>> 3. Check is there only one hash bucket in io_wqe_dec_running. If on=
ly
> >>>>> one hash bucket, don't create worker, io_wq_enqueue will handle it.
> >>>>
> >>>> Nice catch on this! Does indeed look like a problem. Not a huge fan =
of
> >>>> approach 3. Without having really looked into this yet, my initial i=
dea
> >>>> would've been to do some variant of solution 1 above. io_wq_enqueue(=
)
> >>>> checks if we need to create a worker, which basically boils down to =
"do
> >>>> we have a free worker right now". If we do not, we create one. But t=
he
> >>>> question is really "do we need a new worker for this?", and if we're
> >>>> inserting hashed worked and we have existing hashed work for the SAM=
E
> >>>> hash and it's busy, then the answer should be "no" as it'd be pointl=
ess
> >>>> to create that worker.
> >>>
> >>> Agree
> >>>
> >>>>
> >>>> Would it be feasible to augment the check in there such that
> >>>> io_wq_enqueue() doesn't create a new worker for that case? And I gue=
ss a
> >>>> followup question is, would that even be enough, do we always need t=
o
> >>>> cover the io_wq_dec_running() running case as well as
> >>>> io_acct_run_queue() will return true as well since it doesn't know a=
bout
> >>>> this either?
> >>> Yes?It is feasible to avoid creating a worker by adding some checks i=
n
> >>> io_wq_enqueue. But what I have observed so far is most workers are
> >>> created in io_wq_dec_running (why no worker create in io_wq_enqueue?
> >>> I didn't figure it out now), it seems no need to check this
> >>> in io_wq_enqueue.  And cover io_wq_dec_running is necessary.
> >>
> >> The general concept for io-wq is that it's always assumed that a worke=
r
> >> won't block, and if it does AND more work is available, at that point =
a
> >> new worker is created. io_wq_dec_running() is called by the scheduler
> >> when a worker is scheduled out, eg blocking, and then an extra worker =
is
> >> created at that point, if necessary.
> >>
> >> I wonder if we can get away with something like the below? Basically t=
wo
> >> things in there:
> >>
> >> 1) If a worker goes to sleep AND it doesn't have a current work
> >>    assigned, just ignore it. Really a separate change, but seems to
> >>    conceptually make sense - a new worker should only be created off
> >>    that path, if it's currenly handling a work item and goes to sleep.
> >>
> >> 2) If there is current work, defer if it's hashed and the next work it=
em
> >>    in that list is also hashed and of the same value.
> > I like this change, this makes the logic clearer. This patch looks good=
,
> > I'll do more tests next week.
>
> Thanks for taking a look - I've posted it as a 3 patch series, as 1+2
> above are really two separate things that need sorting imho. I've queued
> it up for the next kernel release, so please do test next week when you
> have time.

I have completed the test and the results are good.
But I still have a concern. When using one uring queue to buffer write
multiple files, previously there were multiple workers working, this
change will make only one worker working, which will reduce some
concurrency and may cause performance degradation.
But I didn't find it in the actual test, so my worry may be unnecessary.

>
> --
> Jens Axboe

