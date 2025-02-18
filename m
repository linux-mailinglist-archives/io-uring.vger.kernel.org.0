Return-Path: <io-uring+bounces-6516-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13A53A3A88A
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 21:21:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05F583ACBA0
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 20:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F161B5ED1;
	Tue, 18 Feb 2025 20:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="XgH0y1qs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDB41B0439
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 20:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739910060; cv=none; b=S0Vi2DTYSrlUULqjdPngLdXEZr4sCMuzR/sq6F5q2LO5jY6ilAcFv8EGPrtXbv5DbnO45/LcCZTGMoQ9n1P8rfoXH9mRhuuxrN3VeFZAdzZXCBjF4Qf++aUzT8LuofrJ5420WX1H7doQkijzAWEsOloEe8Dk0ekO5Uu8DxKAz+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739910060; c=relaxed/simple;
	bh=idQR6FMP0hjSHldh+8eNgRaRntbDdUsf2KfANjgGpZ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wv4H/ltSR/WDHxliGTO89ZZdHgCuPDFktvIBFVRLIeyCMNdkTMMhk9WJ1XwEd9Frt8eGxGS0jmvbUfeGwzK3VCS9KvaXY+w4KHaDNFR5A6W1sHSkYA4KilWC1cRn6zNnvxW9bJ8H4cKj/2IDKFU8CxzmSAc/HyOcjlT80lgXa/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=XgH0y1qs; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2fa8c788c74so1235601a91.2
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 12:20:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739910058; x=1740514858; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rDL5ENmYEobOBOGopXLnOpJxyEOQbkaeafJSwgvXG9c=;
        b=XgH0y1qsmDPH4+mLUGINeUVHRIrZq0QXqUROBMsdK8TZB2Tsdu0XsvxfHK1FOF02lQ
         tQVmLhfpj/my6mUds/l4RhLN0eisw6G5GfSItfwVHqYA2Pu+k/9blzrO6tI7n1r6QkDo
         L8SWcqPIwQDYF9gMFkiCQa8IoKAVSNRjS6L/5nFmNbKEWwB6QKxeIK8H6h2Gr18T0k57
         ZXCbHLxw9/eTRfDVnOvJvbkkUUvcaJcPBaPQm8Wt4WcnD9DOxLZNlfHRy8PuNZYPVpvS
         pvOtAEJ9uUS1Qf8+aIogZf/O4mN3BjLxxuR+Htyp5hSePoFTXt/iFWAFI9aD2oqbDMxK
         Crdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739910058; x=1740514858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rDL5ENmYEobOBOGopXLnOpJxyEOQbkaeafJSwgvXG9c=;
        b=CkrEyHVwKfMHPtK0M/XLs+9jqXv2BwISbVDRAxYV8/UMFy3KYPJt+D5ZieCLDbd3lA
         nLcwdWIykrbF1FhknsnJAMXs4xLT9Q4wruR+CpYwkJsYohk2DziWjtBC2D43SNog8MDm
         CXcRsjP3TvwEXgmRavbn+Z+gVt72MciJQe6gpO35m7u6F5zdgr0lEUGNmiP5pWz8Fuif
         9LkHZjnqj2OHkzXmrtyGW8cbFLSIb9yAlHJvku55uDziLLJ0NxmjWHPGP7OhtVoPzT9P
         E5KbLa+5DTlILcX3HtE6R9/PJFxlJsKQKTBF9EJz3Gxy/dWVxDbK0itwf6hZaea5iZiT
         NZEA==
X-Forwarded-Encrypted: i=1; AJvYcCXs0EKy/DYBryDLPEwtE9yXAk5snV5VUOheV1RWhFUxjZuAQ1U2HTcZ3pxRaKpkmkOoj2JxwrJFpw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMKgWpSCgZCsZSyk9tvZg52Y8dMURfQCFclpDv5CzpKqFOG/xl
	qK7YzePjjBHZ+t8EWQV4++d/llD0F/WYi9v4jEfOxM6UMK0ZZw8yEuBCg3bp4bt2gq0+YPy+qoX
	6gLzxjxoQXDFvk2dT2Z3kIVE+NCpVRR9x+qrHBw==
X-Gm-Gg: ASbGncsRMq92Jz2z8wA6K3VDAoTzPlfb2/kgHUs45xX2omxs2uLV7OFPdvP4/OSwZxj
	BtbfZnsVgZOC8AURldWnxwed+LrhiVjsmA3/driQt5vtFWxF8RXCW9aZnKt4lWPTCjTfrTNs=
X-Google-Smtp-Source: AGHT+IFzRM9dWI1Dt58bvoJ1SBUSqteELCYJZmXQVmxaJVUkNCmh+yI5Ky9C4ckh4BV7j2wfD7QAXk6K064Fw2GTSEE=
X-Received: by 2002:a17:90b:33c6:b0:2f4:465d:5c91 with SMTP id
 98e67ed59e1d1-2fc41174806mr9071194a91.8.1739910057970; Tue, 18 Feb 2025
 12:20:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214154348.2952692-1-kbusch@meta.com> <20250214154348.2952692-3-kbusch@meta.com>
 <CADUfDZpbb0mtGSRSqcepXnM9sijP6-3WAZnzUJrDGbC0AuXTrg@mail.gmail.com> <Z7TmrB4_aBnZdFbo@kbusch-mbp>
In-Reply-To: <Z7TmrB4_aBnZdFbo@kbusch-mbp>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 18 Feb 2025 12:20:46 -0800
X-Gm-Features: AWEUYZlQ5seoUzPfhkm2G3v0L4jrKcOJ-d0Fq30l0zSfFPjJJDR9eBYRJ3c3ezY
Message-ID: <CADUfDZorM+T+-Pk4hbsFk_+kJFYMAEaAkLompYdM2UWFucOWsA@mail.gmail.com>
Subject: Re: [PATCHv3 2/5] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, asml.silence@gmail.com, 
	axboe@kernel.dk, linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025 at 11:59=E2=80=AFAM Keith Busch <kbusch@kernel.org> wr=
ote:
>
> On Fri, Feb 14, 2025 at 12:38:54PM -0800, Caleb Sander Mateos wrote:
> > On Fri, Feb 14, 2025 at 7:45=E2=80=AFAM Keith Busch <kbusch@meta.com> w=
rote:
> > > +
> > > +       nr_bvecs =3D blk_rq_nr_phys_segments(rq);
> >
> > Is this guaranteed to match the number of bvecs in the request?
>
> Yes.
>
> > Wouldn't the number of physical segments depend on how the block
> > device splits the bvecs?
>
> Also yes.
>
> >lo_rw_aio() uses rq_for_each_bvec() to count
> > the number of bvecs, for example.
>
> Hm, that seems unnecessary. The request's nr_phys_segments is
> initialized to the number of bvecs rather than page segments, so it can
> be used instead of recounting them from a given struct request.
>
> The initial number of physical segments for a request is set in
> bio_split_rw_at(), which uses bio_for_each_bvec(). That's what
> rq_for_each_bvec would use, too. The same is used for any bio's that get
> merged into the bio.

Okay, thanks for verifying!

Best,
Caleb

