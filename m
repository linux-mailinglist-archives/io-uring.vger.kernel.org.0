Return-Path: <io-uring+bounces-9886-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 13A08BAEC85
	for <lists+io-uring@lfdr.de>; Wed, 01 Oct 2025 01:38:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B89543236BC
	for <lists+io-uring@lfdr.de>; Tue, 30 Sep 2025 23:38:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28F72BF013;
	Tue, 30 Sep 2025 23:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="X2jCJ8Wb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388A527F01D
	for <io-uring@vger.kernel.org>; Tue, 30 Sep 2025 23:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759275475; cv=none; b=ROlj14uu2hperXuB383sh2fm0HaYaxqIusIWYwYWp6MUA4Vjtsj0bIHycAl/POwRfG62VuoVkJDlHDYQMv/5YZh4DZtyoNttNABFXOxoHVKuac/q/qX6vz9m/zJwmy+yf6ojDOjAJ0Pydp94seVrNlRXrcsS75fNAdHE0rxekF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759275475; c=relaxed/simple;
	bh=b6o2r3/e/LkKSbrSbJ6OVlrY9A4CfSDLeOD/eiLbfhI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L7OZK2YmJP5gVWJgCr48NX2Kn03dk3wJnvTKbwM2SRr3nSBQ/ekug7piLJwGhEzUfzlCGC2pyzLJHeSIP2nSfIGTMS5XdoMgtJGTwW4gzLNbnxIfucpnFgaS5YUVDFf8aB95SN4nupUcZq4x0d321wNo7zxRu77ptlRQ2fUMdrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=X2jCJ8Wb; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2698d47e6e7so13271155ad.2
        for <io-uring@vger.kernel.org>; Tue, 30 Sep 2025 16:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1759275473; x=1759880273; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JsbciufhkClpBJseNV68RtSwfki2bKGrza79ICMIhO0=;
        b=X2jCJ8WbZGJST3xux3wtms9Pj5+0YkicTn/RE95yOul+7WflbJV8uzEVmQfPxaKFaJ
         IlUSo8V3w6838opF/uk7//5MPAn++KSJHEujk6XOftmvRD8pKEzdWkvmzVama/Ea0wn/
         xt4AMXcc2yzGAWHiMPy6S6hRBm3anXundcqDynxrXnDMIZpiE3d0gxe6/F8zFDPMRbV7
         UIazlkXshgl+vtTndoAo6KwrXhNNIJMzJVJVwtUdrU0tB4DqduHBxyEkWGj14aBxxUI5
         VTOkU1+iDjEcjUaRjJfd+GYd851gFjs5yFnmypBTkdlMk484q/rGJ4tPw4cOIgH/vUpo
         Zn9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759275473; x=1759880273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JsbciufhkClpBJseNV68RtSwfki2bKGrza79ICMIhO0=;
        b=oNxpkKOGPp3rXeeP9mT752SfsnrtRlsxexFnUZXd36b70umIQsZzDDcrmnsYAjGEvj
         ERIw0CUWZlBi55nC6ZKlPuZ4zyhwuiexUQ3NW8srBrHeZ4W4KJFaZLVKhV4/ckpxRP31
         ZfAirZTB5LUnhTLU7hiK6DPDh3z42hZnxpCFV5sdmKWU0qnpTkwoid21cWLPF7oQWRtn
         tPtzHEYwfTuJGf8Ch2Z2dTtq09hxXfox7hiAXm/naijwvznRRHaNsC1j1aO+tqZ+5x3w
         eH7mUfaD/8U0Y0CL9D/zJts/Aht0Vhmu6gUmp/M5nDnPyd9NBoits0IThdUuArExoCEl
         uBSA==
X-Forwarded-Encrypted: i=1; AJvYcCV/y2FqCv8d0ikrjB0uev/CG+JHnrVOkQtLVUaBOJek3JnbTH1BXbJ3UlUmuaGDgDhKjfuGfbi3ug==@vger.kernel.org
X-Gm-Message-State: AOJu0YyDVt1M8TjgAaqDce/4pSf50cPnuXjpWMP9PELnpqqOupV3073E
	9UqwOGU5xAvYIbxyvP3Hmnv+eHbBe5Y3QXYcd9ep6r76/8EMseMtJb6+VkkQQxKCAyHvDr1Ep7Z
	RVFKYRCUdGCxBVij7bfbU9kt5yWWdW3VFD1X6ETA7Gw==
X-Gm-Gg: ASbGnctof8PYXtsPjoiIU9k5Y+CvbIXCD6QwnGZlFz4hbKqaVVmrJeNqmQwWDydtsAs
	7o+n2V2AL2nH5qyua29qxW5y1fdWfjc5V4lbZ3KXN5ZdRrNFsD2JOQ//KVUie/xPAmJ9gfJf/cm
	AtBN0PQy1bdAULlJSgo5UCPUk4/rGY4zyGlxl2EZudOhGWlUTeoHkWiYKSDSzByOGl1YUISeOFm
	2mh/FbLgr7K7IIHUA+GT6QIBREhiF5CQl+VjEmakr/tNhGRFvxDewXrHVh+TMSk
X-Google-Smtp-Source: AGHT+IFxA1ICmRcmYFcSK20wVyrPLNrKfD89l6K05X78Yld+Jez3ZhnIRDB+f9g+51js+xx4XlzrlhHdk/eGVKEk/tI=
X-Received: by 2002:a17:902:d2ca:b0:269:96d2:9c96 with SMTP id
 d9443c01a7336-28e7ec6dfc1mr9754865ad.0.1759275473457; Tue, 30 Sep 2025
 16:37:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904170902.2624135-1-csander@purestorage.com>
 <175742490970.76494.10067269818248850302.b4-ty@kernel.dk> <fe312d71-c546-4250-a730-79c23a92e028@gmail.com>
 <5d41be18-d8a4-4060-aa04-8b9d03731586@kernel.dk>
In-Reply-To: <5d41be18-d8a4-4060-aa04-8b9d03731586@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 30 Sep 2025 16:37:41 -0700
X-Gm-Features: AS18NWD3Dy6n75NARcPZVICdMwcuOas11yrl7Wil2BmXbhmeKUGVSmajjc2Sskk
Message-ID: <CADUfDZp+FoFCMoi_PJGe7vnNUJ47uxfcQ7irLX9h61xOuWcjvA@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2025 at 8:36=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/10/25 5:57 AM, Pavel Begunkov wrote:
> > On 9/9/25 14:35, Jens Axboe wrote:
> >>
> >> On Thu, 04 Sep 2025 11:08:57 -0600, Caleb Sander Mateos wrote:
> >>> As far as I can tell, setting IORING_SETUP_SINGLE_ISSUER when creatin=
g
> >>> an io_uring doesn't actually enable any additional optimizations (asi=
de
> >>> from being a requirement for IORING_SETUP_DEFER_TASKRUN). This series
> >>> leverages IORING_SETUP_SINGLE_ISSUER's guarantee that only one task
> >>> submits SQEs to skip taking the uring_lock mutex in the submission an=
d
> >>> task work paths.
> >>>
> >>> [...]
> >>
> >> Applied, thanks!
> >>
> >> [1/5] io_uring: don't include filetable.h in io_uring.h
> >>        commit: 5d4c52bfa8cdc1dc1ff701246e662be3f43a3fe1
> >> [2/5] io_uring/rsrc: respect submitter_task in io_register_clone_buffe=
rs()
> >>        commit: 2f076a453f75de691a081c89bce31b530153d53b
> >> [3/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPO=
LL
> >>        commit: 6f5a203998fcf43df1d43f60657d264d1918cdcd
> >> [4/5] io_uring: factor out uring_lock helpers
> >>        commit: 7940a4f3394a6af801af3f2bcd1d491a71a7631d
> >> [5/5] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> >>        commit: 4cc292a0faf1f0755935aebc9b288ce578d0ced2
> >
> > FWIW, from a glance that should be quite broken, there is a bunch of
> > bits protected from parallel use by the lock. I described this
> > optimisation few years back around when first introduced SINGLE_ISSUER
> > and the DEFER_TASKRUN locking model, but to this day think it's not
> > worth it as it'll be a major pain for any future changes. It would've
> > been more feasible if links wasn't a thing. Though, none of it is
> > my problem anymore, and I'm not insisting.
>
> Hmm yes, was actually pondering this last night as well and was going
> to take a closer look today as I have a flight coming up. I'll leave
> them in there for now just to see if syzbot finds anything, and take
> that closer look and see if it's salvageable for now or if we just need
> a new revised take on this.

Hi Jens,
I'd love to understand the race condition concerns you have about not
holding the uring_lock during submission and task work. My limited
mental model of io_uring is that the io_ring_ctx is only accessed in
the context of the task that submitted work to it (during the
io_uring_enter() syscall or task work) or from some interrupt context
that reports a completed operation. Since it's not possible to block
on a mutex in interrupt context, the uring_lock couldn't be used to
synchronize anything running in interrupt context. And then all other
work would be running in the context of the single issuer task, which
couldn't race with itself. Perhaps io_uring worker threads complicate
this picture?
No urgency on this, but I would love to find a way forward here.
Acquiring and releasing the uring_lock is one of the single hottest
CPU instructions in some of our workloads even though each mutex is
accessed only on one CPU. If  uring_lock is necessary to prevent some
other critical sections from racing, perhaps there's an alternate way
to synchronize them (e.g. by deferring them to task work). Or if the
racing sections are specific to certain uses of io_uring, maybe we
could add a setup flag allowing an io_uring user to indicate that it
won't use those features.

Thanks,
Caleb

