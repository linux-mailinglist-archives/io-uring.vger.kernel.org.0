Return-Path: <io-uring+bounces-10427-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D6AC5C3D89E
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 23:02:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CEFFB4E1ECE
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 22:02:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F21A2F5A34;
	Thu,  6 Nov 2025 22:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KKlAVkBp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F5E296BC8
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 22:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762466526; cv=none; b=eDfbj/Wm7TJR6yv3p767yyAzomVAfMBwvYuCr0G83nGC3JVW3SKML66LUli+y8MbzRDSp2a3RNj7l/j/h+WgWjiuJRNEv1IXygRjfG//w6D0Sr5Ir8+ew7pwSPyX2C8ksRPGk38USNH0MjTgd/xSAACjNkX2wKjk/2DMja/3hMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762466526; c=relaxed/simple;
	bh=mrsa0f5Qc7bK2Lms5hMsEQaTFhm8qXq++RH5qRXimgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jX9QtlNjb2emJvQ89SNpQihaOOZOLhCpS3ooW7fx4il0tRNl8B1vs+2lgJex8wJSTMnXh/tQylT/8yyTaMh6KYKJNCvNgohmiUr6/lQvYQNflCU/HgmeLQlDT3YZctBAJ3BbO08WG4Zxntn6ktdyYFiU1XAmbVaENtYqMjsT524=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KKlAVkBp; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-5dbae7f85a3so54463137.3
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 14:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762466524; x=1763071324; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6INUOA0K2Lpi4SpJZChX5AXaiVPcqyJDA2BrZOyVDK4=;
        b=KKlAVkBpDE70JsMzCNFDmom0szikiu37mv2zFQF+blGTwRFh7FUqcEPtEmSzQt6OIz
         ZX1OPlD4b1LgGAh8uPWD85uemrRmIFL4anmyYZG9P+ZwmeiRlJB5GdC46wZ6fhlLM2l2
         XRKVYFhEg9CimvcRWuAURqYZl0O20saTQjyFefLmSYX2hzLty3JUFDL2NtEw1CoTXRFw
         tD2UB2R1Rzd4fD3e46LrpJhiVUeqiYvOH5SoEcAoGVX2IL3l3vTUGooBioYeF58j3Wez
         HsfY2aoBV4qkiIHikTQL3LOMjKF4n30+xgSHkGOXJIogvyOa0mYFDQxVp4VlaIlISYuY
         s50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762466524; x=1763071324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6INUOA0K2Lpi4SpJZChX5AXaiVPcqyJDA2BrZOyVDK4=;
        b=OAR0Ktpp1lq2yAWCbxWnhXBTS8jQ0dJkm/8/rSU5V+wBSK0anzWZ8byxBa4rzn9nB/
         APh0UBfaGESHZnDs1bjtQajHbn17Xx8690M9GAVjrnpSh7SZDHIiczkACuhWLHvyaUhJ
         MnNuO/mGtBTODfwP1HvuFNpzmgZvcFhFxYAVpaE1+ldR6ex8Cm/seUsyHYwN8SIJbENY
         HFMHreTJJnD1RPIB/VDNRZRMdEdqa2qDa54PSiXXEyjssCUcdlrHdNeTt0vqpGFUHllg
         amDDd+HbYUVp7T1katFZgQ/DSRCL4hyHc4+wIyC/BALUJ3W/EN6QL9S5V9ecod8TTlDN
         dxRw==
X-Forwarded-Encrypted: i=1; AJvYcCWLj7VBTJQarHx5Q/zYOri3r2F9QYxhvinRFb2/fcV1nG7HyhPtmD8ZHdFJhrZ7OuYqnkE6jkBPuQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOUXbxyi7Flr+CPf0Haz9I1m7dd2sBIoZ74F0zDfYxY1xtJLBp
	mGE8UL/mU7f6H5IGCDS0FYBU8RvYXrXtBhh6nDhP3op3Plb1Wma8ceOqZeeL8nBqlWvYYeHhNnh
	UXmBhZQ9ZZnnCwixvg0etDr3tgHDdryk=
X-Gm-Gg: ASbGncs/aUDsh9DFWdQ9xgK4kvgmeoWx7PoJyGlgfhjIJUbsZJCLQL9SOPc0tquRM9p
	VkELz1nHZph8YMhmX5Zwzz4LKp/7ir/SrqYXsZTMB4998qiTRxuIx3DxOCiQtymgTDvkzXDGytq
	ycqaZc7l8JCp2LklxixWPKbqbyoXZ42PZwRedH61zRfMsy3EqnWEhbAtjUcIs/X+CV7CaHRhr64
	OcKsSHENOj2ZmYAcT34RAe6kwaP7Rm8wqUXbgtQL2yBNOBRJgF+Gkt9HIpJthMn3j5SEZLS7AJj
	v0a1ohZQAbnUbXQ=
X-Google-Smtp-Source: AGHT+IH67bXGQ9AWgEOqCzuZoVhl46p0WlyB0LGf2+8GipzKWVLXlViWXbfoLz7RtP+8mcfTZY95Wk7QcNRei+5uj4I=
X-Received: by 2002:a05:6102:41a8:b0:5d3:fecb:e4e8 with SMTP id
 ada2fe7eead31-5ddb20e6e72mr377504137.5.1762466523533; Thu, 06 Nov 2025
 14:02:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-8-joannelkoong@gmail.com> <0e77afcc-b9a7-46f6-8aad-9731dc840008@ddn.com>
In-Reply-To: <0e77afcc-b9a7-46f6-8aad-9731dc840008@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 6 Nov 2025 14:01:52 -0800
X-Gm-Features: AWmQ_bmJ-gGSjlIn96rgezHC0epAiVYIqmVrBpowJdzaDmOhFFTnNXS2G7z0FVY
Message-ID: <CAJnrk1ZENK5Zp+r5eqm_ZAQySvTcn-6R1dUkmDHXMbw6F170BA@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] fuse: refactor setting up copy state for payload copying
To: Bernd Schubert <bschubert@ddn.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, "axboe@kernel.dk" <axboe@kernel.dk>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"asml.silence@gmail.com" <asml.silence@gmail.com>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, 
	"xiaobing.li@samsung.com" <xiaobing.li@samsung.com>, 
	"csander@purestorage.com" <csander@purestorage.com>, "kernel-team@meta.com" <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 8:53=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> w=
rote:
>
> On 10/27/25 23:28, Joanne Koong wrote:
> > Add a new helper function setup_fuse_copy_state() to contain the logic
> > for setting up the copy state for payload copying.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/dev_uring.c | 39 +++++++++++++++++++++++++--------------
> >  1 file changed, 25 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> > index c814b571494f..c6b22b14b354 100644
> > --- a/fs/fuse/dev_uring.c
> > +++ b/fs/fuse/dev_uring.c
> > @@ -630,6 +630,28 @@ static int copy_header_from_ring(struct fuse_ring_=
ent *ent,
> >       return 0;
> >  }
> >
> > +static int setup_fuse_copy_state(struct fuse_ring *ring, struct fuse_r=
eq *req,
> > +                              struct fuse_ring_ent* ent, int rw,
> > +                              struct iov_iter *iter,
> > +                              struct fuse_copy_state *cs)
>
> Maybe 'struct fuse_copy_state *cs' as first argument? Just a suggestion a=
nd would
> good if it wouldn't end up in the middle when there are more arguments ad=
ded at some
> point.
>
I like your suggestion a lot, I think that makes it clearer to read
too :) I'll reorder this to be the first arg. Thanks!

