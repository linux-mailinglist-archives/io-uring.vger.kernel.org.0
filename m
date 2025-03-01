Return-Path: <io-uring+bounces-6878-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CA9BA4A7A1
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 02:42:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D6F06189CACC
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 01:42:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B981B95B;
	Sat,  1 Mar 2025 01:42:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="b0NGipAu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79EC53595A
	for <io-uring@vger.kernel.org>; Sat,  1 Mar 2025 01:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740793344; cv=none; b=iO6A8WNnvb3j6v7lU/8Fh0VdZ4McXGRRr2KJqdYxb8aIqF9fvlfw03LQJr2dOBvg5qrxhgdIAhSunDlBweO30RmtbLmKazbrn+iHsRaKcb3VdjtgpTRXrtojt54hrSt0PClAfyBCWIDRbZKba3/PE4TglKsUcqhr0rk3tLvZ5NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740793344; c=relaxed/simple;
	bh=VAzuMq1SPRjyoldnXde+s+9Rp1P0nDMAYp/ojV8Rxc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R0TXY879uffxtPjz9wa6iWwkZnnH8sRqbEkNaBjBrzK093x8dIkBeOGJEti3xo0ye/5fzE33hhNsTz3bRd7MixZfAZpF/RL7VG4Gy4wOCm2u15ECJ69GLmdMS+4h0jAaKoxm1xzv6G5s8P6Epu7fvB31/qz1rjWBEi+Ds5wOT8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=b0NGipAu; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22367eba6f5so4734615ad.2
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 17:42:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740793342; x=1741398142; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=74uaVyaOSVBrK4gUrHFd0M9UxA7zU4hXqBqpVw5WXpk=;
        b=b0NGipAuno0vNQGpALklJYUrRYmryLrtUifk4mpIv6raHhJ4RfAodRUBJDJJzcLIOZ
         i/1UvKxPCPmpRYCsoawdmKqt/jUhZRDPTecbFnXBkOMJ+o7WhKX4dWM4gx5ozOHFQ7bW
         Q2vyCU3K1UthKMeoSEtLbd8zI8pC627k0MMEdttpE5gkhNORzyp1jr/cl5rEWR9qfknk
         KzJir8c72OnrCID1vG7ClWCizElhh/DyC808S/8/LowSKAJ9wFtQxzsQlAPtbZKRapBc
         tpG5vqPL/3wSvtwpfSD1BiKBalWixhIlBUBBtvOe8QaN3o5CiKPLwhoQAHx3W+4e9P7u
         Z4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740793342; x=1741398142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=74uaVyaOSVBrK4gUrHFd0M9UxA7zU4hXqBqpVw5WXpk=;
        b=tMxM+fzCqXaV1Ry/a4w5xjw9H6qrD76HE6coJdD8vztGaSMocAnCMS0JiMOO9j7Jiv
         zphuaa47xOl4th2xGykRHEttUDhqc/4Yp0we2QZOmNaVUHcKz2PT4RgGfWedWg58Wf70
         Cb3jwrQR5gf3zx4rn0QyYySMOlXfv4RwN80T44qhEmJN0NQPXIRBFbKD7+difmXiCVXS
         JuyIkgjAROzAIGuHVrJjYQ5vfByZzu1jGOJZRMfnAYlGuzR2cGi7o0tIW0C/RUrchm0b
         U01njsZGie6J+4mFHbCHmMC2ZBo5OpDE5LYuFwRWnTk3k3WMlwiOM3t7LfQET9RNb657
         OGEg==
X-Forwarded-Encrypted: i=1; AJvYcCVbomwCjEeOxkh7ZFHu8LZ1rYjBPhcz1yMqFuil4DOvhaMcD1+EiKVNaoFmx+tsXSCpoUfk/pTO9A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwPj7GboLT/tdVAwr4OuzWw+dvwWW9iJCJS7D5J0E/ITnvZiVY5
	UMD0KOnFkRBxRlw01xldG0Z81T7VByJBhQ+GGNAcXgK+GtPqRkX5bXS1zMuqRi5OK7QJ9TK99Ci
	VQ7XbelrbtF01HBh/b94+pANsW4znJq8MGbw4uQ==
X-Gm-Gg: ASbGnctJdvPxH8gGopTw5GT4mex87zJptib/uZi85ab3okYe9xcizeYButxJ27Eu9Ig
	XnUIY4PKH49Ka9FNhg9CcKNHY4aX6dkGllNrWS922ruk61b83tN3IeQ9KqPrB6QpV2EUZSTXhW+
	ZFIRaxHkAmPOYF8qOvrjBuV5Ga
X-Google-Smtp-Source: AGHT+IEAtn4ng06+iBZXjhmClYZvydtClSNiTwqIhpfZuR+T41xP/35RMQgG4DOrnNTX2o7FSqR5dbDbzlaC7G1dWuE=
X-Received: by 2002:a17:902:ecd0:b0:215:9a73:6c4f with SMTP id
 d9443c01a7336-22368f76e6bmr32961005ad.6.1740793341694; Fri, 28 Feb 2025
 17:42:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250228223057.615284-1-csander@purestorage.com> <6272ce74-cd1e-4386-ac84-2ca7df5dab33@gmail.com>
In-Reply-To: <6272ce74-cd1e-4386-ac84-2ca7df5dab33@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 28 Feb 2025 17:42:10 -0800
X-Gm-Features: AQ5f1Jo10AbYOywMpLOwf2-W01i8JH0UAgg3J7GDhKn__uCMLxZsp8qb_zri38A
Message-ID: <CADUfDZpmnj8wCjaQcDTTT_rNhsegs0NFk6w393e+JsTg4MN+bQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: use rq_data_dir() to compute bvec dir
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2025 at 5:23=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 2/28/25 22:30, Caleb Sander Mateos wrote:
> > The macro rq_data_dir() already computes a request's data direction.
> > Use it in place of the if-else to set imu->dir.
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > ---
> >   io_uring/rsrc.c | 6 +-----
> >   1 file changed, 1 insertion(+), 5 deletions(-)
> >
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 45bfb37bca1e..3107a03d56b8 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -957,15 +957,11 @@ int io_buffer_register_bvec(struct io_uring_cmd *=
cmd, struct request *rq,
> >       imu->nr_bvecs =3D nr_bvecs;
> >       refcount_set(&imu->refs, 1);
> >       imu->release =3D release;
> >       imu->priv =3D rq;
> >       imu->is_kbuf =3D true;
> > -
> > -     if (op_is_write(req_op(rq)))
> > -             imu->dir =3D IO_IMU_SOURCE;
> > -     else
> > -             imu->dir =3D IO_IMU_DEST;
> > +     imu->dir =3D 1 << rq_data_dir(rq);
>
> rq_data_dir returns READ/WRITE, which should be fine, but it'd
> be nicer to be more explicit unless it's already enforced
> somewhere else
>
> BUILD_BUG_ON(WRITE =3D=3D  ITER_SOURCE);
> ditto for READ

The definitions of ITER_SOURCE and ITER_DEST seem pretty clear that
they are aliases for WRITE/READ:
#define ITER_SOURCE 1 // =3D=3D WRITE
#define ITER_DEST 0 // =3D=3D READ

So I assume other code is already relying on this equivalence.

Best,
Caleb

