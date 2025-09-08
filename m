Return-Path: <io-uring+bounces-9653-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D16AB49804
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 20:15:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D95D31BC38BF
	for <lists+io-uring@lfdr.de>; Mon,  8 Sep 2025 18:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38053314A63;
	Mon,  8 Sep 2025 18:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="O3M0zof+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6E23148D6
	for <io-uring@vger.kernel.org>; Mon,  8 Sep 2025 18:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757355132; cv=none; b=uKdUExdkl9TSzVsNe1YQe6jlf8KQ+fBaNUsCb/Q/yIvhl4LKk24yHSzEfmIgkFpaLbZdS3EYG6x2aVEeZbB5JdTgennUzopan/JMUZTzOI3Vlo5u02eVqqbScZEtzuMHD+5Pl58PAxbr2NGHrmekKuhdY1w0UEKuXka7EPQ179o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757355132; c=relaxed/simple;
	bh=H/p5xIJk8lmI/VqBNq2hGyqsRtnDqgWEJ++nq6tiL6E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Up+Js2iZbPNoUweS06HwfrdutKPRkZxIPqlw8vSfqG5rM/KysUaVTbhtDnyWTUlxuI6S9aheS0hJXf0echfizfo2N3S65SEqZ3rMsgpCJOFn6QC1/wMciw2p5tycEysYExZUwjV6penZaPg3WH7EXSVMWgM/Lo/PPeqydS1bWn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=O3M0zof+; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-248f2da72edso8859705ad.2
        for <io-uring@vger.kernel.org>; Mon, 08 Sep 2025 11:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757355130; x=1757959930; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ojzCABYGnMlZKVB/RdZnSfkc0o7nxef4JjZwU842o9o=;
        b=O3M0zof+x+BCYjs9ZjSp4VVIPor0ngzVoFcOtksC9lIW+cZJAPPvk1GrAYf4MXxMJU
         lWE544ynO8q6OfD7LoQmjAFPqHjuv09I8NtpOsUShLfHZXXs5bj2Wd7bXTtk99XBqacU
         xBOi7fmch+4tdQ8jbCr7Bbqj4rO8slUaMhYWWscV66eZQ70nIXNF46msJzgSwoP5OFyZ
         fd1XAwy/nWPTqiF5kmjiIAVcIEG/yAfmdTRKNlsIisaKyUFcxSuNZgbjNXIAD2cN4xRN
         OGqBa9Z24RXCrAYRcIkrcR4NsW1MK7AZl4TEXudNId3lF+XLDCFpICF3Er1AgrByF3+c
         Ckug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757355130; x=1757959930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ojzCABYGnMlZKVB/RdZnSfkc0o7nxef4JjZwU842o9o=;
        b=wNa8eoAe1/chFNYXLkEqh/Ej3VhnfZihXDaB0+/LMnz+uyeeHbIBOPWI70Gjcq/4M8
         6rzdhwoxtBpzHmpf2zXaQ7uLg4C2IxOCpDfezaL2mhxTGeh7IvByIIzQ0GLWvppQFiQg
         rXcxVpWn+A65YXXlHRIc4om7s+oQsRiVaLpXlqUZ95Mv8NdlY9LxpbOAl4Q1a3IqOMj0
         BTJnjn3a7ay5i3Q6L0qct58a6FYiFCeL+CgjttRnS2ScwcmKvFFw2QoicTwWsEcmfZZT
         AHNI+p4JjtxeMJAWgo5KPM1d8mMP+ez+iCvu9Rw5vI9fPf6PnfGyvi+sGLI/Y/8jer0K
         yqpg==
X-Gm-Message-State: AOJu0YwRXku1eHSiXguNdfVohDBtQrqAnatP1nZYRL9jiRwEJ0nMzNN7
	M9ZCibuE5gy87pUBwGMTs8RvcrnpyLZMSuerrbOBa83ReUeE5vmMLxctFzt6IO0Y+mI0drzhq+j
	6uXIaQf6UG/j3efbwwvN/r/7lj4eJiU6xfLrhhykC0E2xLDbM8+jz+xQASg==
X-Gm-Gg: ASbGncul5Vzc6v/iMi7EqPbRNIoxAIU4900DpKsphO97j8xC2J/hdR83JTfdgBSf7os
	faTXw0JxsgmP/6G3zsCusYiARvSgkuw3cW8t8CMrh8QUdYQhZ1szWSL8LZR45UEWwX4+93gFNDZ
	Gw4IhFVSYuWyths0NRTu86gyRZnXblfbYVonDF0oYxlQM0nH6aLYOa0TSm6yDgZxSUE726eeC0A
	6X8rDPPiV9DdtHsmPKs5m8=
X-Google-Smtp-Source: AGHT+IGnaZQfRuThACjFkGL0OJplq2Sfcwtm084uzB80qdvnK8daKvu2HoJr1/1nhn8lVjDgbUhm7SfE4r4NCZxQwv4=
X-Received: by 2002:a17:903:2442:b0:24e:4248:3d9b with SMTP id
 d9443c01a7336-2517121749dmr52692415ad.4.1757355129582; Mon, 08 Sep 2025
 11:12:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250904170902.2624135-1-csander@purestorage.com>
 <20250904170902.2624135-4-csander@purestorage.com> <07806298-f9d3-4ca6-8ce5-4088c9f0ea2c@kernel.dk>
In-Reply-To: <07806298-f9d3-4ca6-8ce5-4088c9f0ea2c@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 8 Sep 2025 11:11:58 -0700
X-Gm-Features: Ac12FXzi6ulJPkC8TSbiAM575fdZmfp3Iycust3u0vCQfoJDgKjsl5wGiRdKjZA
Message-ID: <CADUfDZovKhJvF+zaVukM75KLSUsCwUDRoMybMKLpHioPpcfJCw@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 8, 2025 at 7:13=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/4/25 11:09 AM, Caleb Sander Mateos wrote:
> > IORING_SETUP_SINGLE_ISSUER doesn't currently enable any optimizations,
> > but it will soon be used to avoid taking io_ring_ctx's uring_lock when
> > submitting from the single issuer task. If the IORING_SETUP_SQPOLL flag
> > is set, the SQ thread is the sole task issuing SQEs. However, other
> > tasks may make io_uring_register() syscalls, which must be synchronized
> > with SQE submission. So it wouldn't be safe to skip the uring_lock
> > around the SQ thread's submission even if IORING_SETUP_SINGLE_ISSUER is
> > set. Therefore, clear IORING_SETUP_SINGLE_ISSUER from the io_ring_ctx
> > flags if IORING_SETUP_SQPOLL is set.
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > ---
> >  io_uring/io_uring.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index 42f6bfbb99d3..c7af9dc3d95a 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -3724,10 +3724,19 @@ static int io_uring_sanitise_params(struct io_u=
ring_params *p)
> >        */
> >       if ((flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)) =3D=3D
> >           (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED))
> >               return -EINVAL;
> >
> > +     /*
> > +      * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQEs,
> > +      * but other threads may call io_uring_register() concurrently.
> > +      * We still need uring_lock to synchronize these io_ring_ctx acce=
sses,
> > +      * so disable the single issuer optimizations.
> > +      */
> > +     if (flags & IORING_SETUP_SQPOLL)
> > +             p->flags &=3D ~IORING_SETUP_SINGLE_ISSUER;
> > +
>
> As mentioned I think this is fine. Just for posterity, one solution
> here would be to require that the task doing eg io_uring_register() on a
> setup with SINGLE_ISSUER|SQPOLL would be required to park and unpark the
> SQ thread before doing what it needs to do. That should get us most/all
> of the way there to enabling it with SQPOLL as well.

Right, though that may make io_uring_register() significantly slower
and disruptive to the I/O path. Another option would be to proxy all
registrations to the SQ thread via task_work. I think leaving the
current behavior as-is makes the most sense to avoid any regressions.
If someone is interested in optimizing the IORING_SETUP_SQPOLL &&
IORING_SETUP_SINGLE_ISSUER use case, they're more than welcome to!

I appreciate your feedback on the series. Do you have any other thoughts on=
 it?

Best,
Caleb

