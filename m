Return-Path: <io-uring+bounces-7009-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D591A56D9D
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:26:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E6D33B04B2
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2222423C8B3;
	Fri,  7 Mar 2025 16:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IAlipBYq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6362723BD02;
	Fri,  7 Mar 2025 16:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741364752; cv=none; b=Kl+yfNypMcJQP7I0f+RtTLXys0KkzfodczNUM+CwcknV86iu2ZOOLD/GupdshWiN3WkniH3S3iA9KBJsPp0g6WbbYT5nT9D5wgV43IenxRd+/PJHOYmJJx/2Ewf+7ftyMVRRcGIpKyokC4bECKZLWo1/3PFsV2/BalDdDszFhoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741364752; c=relaxed/simple;
	bh=bLEfmUnYNuOKOir0zwg7RD98ImRY/iPqh1hUnJg6QLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QclNLe6knHFh8c5hWyaukxe+WfirLnqzlbIf/XJ9w15GqU0O0ykOrTigdDuzG37cDam1gqyBA4GDsujlfTR+mAhfL1qLRUPPiwRA948rovJgvtSoai8VoE4wDfNVtAu5uyPoycCJl5ltUZpMhMZ1Qz4nNWgd7FNpoQiziZitPJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IAlipBYq; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ac25d2b2354so120963766b.1;
        Fri, 07 Mar 2025 08:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741364748; x=1741969548; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xyXC2Sh42QbvTTRE57F/uGSMIYA6cEPlzGInM+uXOOM=;
        b=IAlipBYqcpEiD2rOV16UtXn8wi9yxfBmsO7YO0h9zdyvuPtT/0DZuvERdfKNAIy3Gj
         2MCl7CPdltVZO08VkI+gsyQCStk5nTHBDskomDsomfzLmUwQgp3EYCIgtJpqJulMBFDY
         etGDc8CP6w5COt/A86VStf/I3/IKwEnZlIZ86fCOL5BEQ0SPfXSxaHJCWSvbccBMreKR
         4Rd2lySC0veq23vMVo9nvJTz9BbDNgW08cfRGg0zsRy5/BWImk29S0DjB4XFDoqX2kI9
         S9CUuhg1epK40Rq0/1opsACkltpgCS4WFq0H4gsDf3Wub9eYXr7/z6pKImMK7NJ3bTN1
         lntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741364748; x=1741969548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xyXC2Sh42QbvTTRE57F/uGSMIYA6cEPlzGInM+uXOOM=;
        b=ZHwpkxTM79HXLAegic30IbNy0V6vtRVDo+zRb4AsVEuZcJ0WFgWytgHloq0mGA/1fT
         TfiTfIWvolzijkag+1EB5iBJAA8OQw7GOojBNndUHbCZQS1SppJlyAvqw3QJLT2h2P5O
         qtfk8tJNdHai9zmSPe6bavG4P0+QeD/XtYXOfxuC9g3Y7y7Os2dfpRMYvZHx2h74sjUM
         CyloMcq4iKNNxSeZ7VDnc6FxA9V2yzJD57J3FKWbflKtvyEGuq/Th88Urt4INdNVRLP0
         9nfhUgMO0aqY16qTu9pB4zrpSVoD5IVWvs8kw6SNUDz/DMhvxl+ZKRZGTFA6RVGU9W3H
         whoA==
X-Forwarded-Encrypted: i=1; AJvYcCUT7Zc4JdqjebPPQonJPVaLkuPoYo2fpcuZAfhuKmlV6cUXjKhgbllQr6rqQKQmGWpUAsXnFfxCZ9jc7naa@vger.kernel.org, AJvYcCVdeFqNNbEe0R33+YV5c/LfEKPXX+I4MAuWaXl7/wUFVQ3P2kiFJqnv9cn6IevF0G1Tk33iBX8o6Gp1M9wcdw==@vger.kernel.org, AJvYcCVntLeZErOHftHEqJk59S6amvXyPi17bmIRxR365OkJN6t6hbM7wY3nhrD0Cv7o9YDkaCJNgRWXQxk=@vger.kernel.org, AJvYcCX5w1fYkVN5/xBisKPm1juuyVPToKwyo8OUgjSvgcAROASlhqdm9mV8HYp7+9nRahogzsTwmA==@vger.kernel.org
X-Gm-Message-State: AOJu0YypjPMZedRajUMSIgLBtOWTsC1GaWO7EHKUhKhYl6vhO0eU2lRs
	c8Fj11ZfPjEo2cLS+iUtzCPos40WyqU+l8Tp4nzXyitwlQF/WJEeSqqCNj0CDj3dK0RQShzuR6k
	EnMAfchp0EfPEWeYR9HC0OYTClHA=
X-Gm-Gg: ASbGncu5axZoxEjYcW7AHVk9G/dN82adO56SQ9UVo+QcRqYoTGZovsURukcbgGUZD1B
	P4l64MqALf/G0VhFwrY1ZRolus9NyFlvbhNt4VfKB9fQdO9NkOWnCIpbfPXk5kIhoJc8DQ6bL9J
	o5f/077f3Tk5YAGho+zpgy+tAlUg==
X-Google-Smtp-Source: AGHT+IFyk5AjAbGX5OADjJOFlBdjXEEnxRYCDBfTgu6O+wiPq8nXmZeAZ70ogJHY2HczgCPYOu0pd8eT+1y8jOaMeE8=
X-Received: by 2002:a17:907:1b0a:b0:ac2:4bf1:44bc with SMTP id
 a640c23a62f3a-ac252fa0593mr565079066b.41.1741364748454; Fri, 07 Mar 2025
 08:25:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307161155.760949-1-mjguzik@gmail.com> <fa3bbf2c-8079-4bdf-b106-a0641069080b@kernel.dk>
In-Reply-To: <fa3bbf2c-8079-4bdf-b106-a0641069080b@kernel.dk>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Mar 2025 17:25:35 +0100
X-Gm-Features: AQ5f1JpjGPiVDiXqTcVQRZTTG-h3s6L-x9oqKZfDDolU5_EACBqCpkQTanLjvJY
Message-ID: <CAGudoHGina_OHsbP_oz5UAtXKoKQqhv-tB6Ok63rRQHThPuy+Q@mail.gmail.com>
Subject: Re: [PATCH] fs: support filename refcount without atomics
To: Jens Axboe <axboe@kernel.dk>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 5:18=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> > +static inline void makeatomicname(struct filename *name)
> > +{
> > +     VFS_BUG_ON(IS_ERR_OR_NULL(name));
> > +     /*
> > +      * The name can legitimately already be atomic if it was cached b=
y audit.
> > +      * If switching the refcount to atomic, we need not to know we ar=
e the
> > +      * only non-atomic user.
> > +      */
> > +     VFS_BUG_ON(name->owner !=3D current && !name->is_atomic);
> > +     /*
> > +      * Don't bother branching, this is a store to an already dirtied =
cacheline.
> > +      */
> > +     name->is_atomic =3D true;
> > +}
>
> Should this not depend on audit being enabled? io_uring without audit is
> fine.
>

I thought about it, but then I got worried about transitions from
disabled to enabled -- will they suddenly start looking here? Should
this test for audit_enabled, audit_dummy_context() or something else?
I did not want to bother analyzing this.

I'll note though this would be an optimization on top of the current
code, so I don't think it *blocks* the patch.

--=20
Mateusz Guzik <mjguzik gmail.com>

