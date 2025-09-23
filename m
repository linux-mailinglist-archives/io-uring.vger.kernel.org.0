Return-Path: <io-uring+bounces-9866-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C9EAB952A2
	for <lists+io-uring@lfdr.de>; Tue, 23 Sep 2025 11:11:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EC42B7B1008
	for <lists+io-uring@lfdr.de>; Tue, 23 Sep 2025 09:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7F132038E;
	Tue, 23 Sep 2025 09:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fcNKe71C"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f68.google.com (mail-ed1-f68.google.com [209.85.208.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0FC31DD87
	for <io-uring@vger.kernel.org>; Tue, 23 Sep 2025 09:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758618653; cv=none; b=i23jMphUiGihLV/zByxEYKSdr56lb9265kneqWkexbBiaIfi5CyTZEs5K9HE/Ms6TyT76ZX3ACX0LVq9PQwW6wjzyq5VOKDpYZ2USmyMhgk9AKQJet4pIZ7+5o9EhJS0BYjR47kLD1yHRMEmqenULo7dG2naJpmDyFFkluY54Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758618653; c=relaxed/simple;
	bh=VYLe1NIdSocytpQsqIe44RRwBrvi8DHYsXwSATgRZxs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=htjuNetz7AlFGMcjfdoYN5czwO40NNUqzS8kZcjA3sQsEu57NEis9GFHZkybFFOrJot2stgGDxthD3nFMXNDqPGE8DiZcv3i3gSvSxFDmDvVHHjjZRkhOfUVy9Y5S7gxnrYn0sEj76nghF56ypO1i4iRwE61uaQlo0fRGqkG7ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fcNKe71C; arc=none smtp.client-ip=209.85.208.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f68.google.com with SMTP id 4fb4d7f45d1cf-62ad0c9cf8bso684369a12.0
        for <io-uring@vger.kernel.org>; Tue, 23 Sep 2025 02:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758618650; x=1759223450; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qeGswIB7JTA/r3S3+GTL3v5BpUBkDFFt06D87rwuzYk=;
        b=fcNKe71C+FdvQkjg6Ji5p3HyQ7l+5k0vlwP/7twWww5hCHVbtyEvDrILH81gYllWxy
         Lm52rmCX+LTxXzzv20b+POQRZDO8pMIdPSMXH/y4c+g/KsYI7hG8iRsZZj7FvbFD1N8X
         zMuJgsr9PLqos0Bc4NKOAFXefd/tUC4e6wrf/VL0UolUUwi3AOWlfp3DKScpsrDqWmZ1
         LwpYFj8UAesuKK/XAxxTR4zn6C38sl5HI5P2455WS5zatOcPG6AJ6M6JWuCkV7BfNFaN
         68cQMDd7gre7KoAyyXVebKhq7/S9Mva4kYz2WXNiNc/H2/lTxkjsd9+6GwGKhGgDWezg
         lD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758618650; x=1759223450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qeGswIB7JTA/r3S3+GTL3v5BpUBkDFFt06D87rwuzYk=;
        b=SwHxH+J5f2Ei92PGOG3obaZJya05VV/41Zo6ZXgvoxtI/TEIWC5HClkjARQM46A2bV
         hS4ALLPmWI/C5NhYrdbtKY66vmUJC192xQwDrZl3FnHR0KeMt0TyFFRh9HjWPBBzUIco
         WJIyi02ShTZo+ORgB9txGA+Xp8j31BPUMC9RYg8T4IYMvcYSewFolO+J/H4BcwpYiTkk
         tgUSnt3sXowm83T1dsjpdUjS7rHBKoq2aza78QnQaDbq61WL3yIj1D1vtFx4sNJIoe46
         f4QKyBTh2yIfTXjzz65HMBiRJZyojegY9licGjEdn+9Ff/ElksVIlCHtanH9fSkhxDD9
         Ewpw==
X-Gm-Message-State: AOJu0YzOCZSgrl18OxtzO3qATfz37Q/soWU+i0vVNfvFAKi3u7rm0A3M
	gu4bielKofxpQR6L68bKovsUtICpAOoQhJyxBlyM1HL2eDC92QcRcezDTHTHeX3z+EWBJ4xq4ID
	KNLngnMtz9Ex+EQ6MGgQ5RLYtPeMxYdG2eiQLsLViRFuF
X-Gm-Gg: ASbGncsNWBKKlc8vNfQGkOrf/BdY2o7b/jWSHuRipfXoPWtMQdWuc3+Do0JIW35+GBZ
	xsnxhGhTEcg5ABGHl6iGz+QR47CiDtt1Eg0BQQwzd9CreLmwfwLoHU96M8XmkGCugfJs0APoKEK
	tITzifZH4z8cir5d6cVggJ1jdrQvpHrn+RoZmTSeY+12YokNztfdpDWfUm4dvA1J6gLb/SK/jSZ
	7xXRBc=
X-Google-Smtp-Source: AGHT+IE4Jt7k2k4sg+HmRWSa90wKrJ0pXPA5vfzS6cisXP6TeP7zjrzajrRwQ1rclcbLmNr1zSYoKCaZmIE0A+gYC/o=
X-Received: by 2002:a05:6402:4406:b0:62f:4a8e:b1 with SMTP id
 4fb4d7f45d1cf-6346780f842mr949890a12.8.1758618649472; Tue, 23 Sep 2025
 02:10:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADPKJ-7cb9fcPbP3gDNauc22nSbqmddhYzmKeVSiLpkc_u88KA@mail.gmail.com>
 <b0b0db4c-ac91-482a-85a4-2acd2884e5ae@kernel.dk>
In-Reply-To: <b0b0db4c-ac91-482a-85a4-2acd2884e5ae@kernel.dk>
From: clingfei <clf700383@gmail.com>
Date: Tue, 23 Sep 2025 17:10:38 +0800
X-Gm-Features: AS18NWA6ywd6FK-cz0okTXiY-QFtePe9Lecdkf5G1aXsKWQVoQPfW3HAo_jUQf8
Message-ID: <CADPKJ-78+=j_HkUcJt2k6Xsn-fjs8=xT97j+coWNAEzTFvHr6g@mail.gmail.com>
Subject: Re: [PATCH] io_uring/rsrc: remove unnecessary check on resv2
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Jens Axboe <axboe@kernel.dk> =E4=BA=8E2025=E5=B9=B49=E6=9C=8823=E6=97=A5=E5=
=91=A8=E4=BA=8C 16:50=E5=86=99=E9=81=93=EF=BC=9A
>
> On 9/23/25 2:41 AM, clingfei wrote:
> > From b52509776e0f7f9ea703d0551ccaeeaa49ab6440 Mon Sep 17 00:00:00 2001
> > From: clingfei <clf700383@gmail.com>
> > Date: Tue, 23 Sep 2025 16:30:30 +0800
> > Subject: [PATCH] io_uring/rsrc: remove unnecessary check on resv2
> >
> > The memset sets the up.resv2 to be 0,
> > and the copy_from_user does not touch it,
> > thus up.resv2 will always be false.
>
> Please wrap commit messages at around ~72 chars.
>
> > Signed-off-by: clingfei <clf700383@gmail.com>
> > ---
> >  io_uring/rsrc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index f75f5e43fa4a..7006b3ca5404 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -372,7 +372,7 @@ int io_register_files_update(struct io_ring_ctx
> > *ctx, void __user *arg,
> >     memset(&up, 0, sizeof(up));
> >     if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
> >         return -EFAULT;
> > -   if (up.resv || up.resv2)
> > +   if (up.resv)
> >         return -EINVAL;
> >     return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_arg=
s);
> >  }
>
> White space damaged patch, but more importantly, I don't think this is
> worth adding. Yes it'll never overwrite resv2 because of the different
> sizes. Curious how you ran into this?
>
> --
> Jens Axboe

During my review of the io_uring code, I noticed that
sizeof(io_uring_rsrc_update) is used to initialize a struct
io_uring_rsrc_update2. My initial suspicion was that this might be an
error, but upon closer inspection, I verified that this usage is
intentional and correct.

