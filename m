Return-Path: <io-uring+bounces-11057-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 83379CC09B2
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 03:30:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B3BA3013EEA
	for <lists+io-uring@lfdr.de>; Tue, 16 Dec 2025 02:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2DDB2E9730;
	Tue, 16 Dec 2025 02:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="bGIvkICK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D950298CDC
	for <io-uring@vger.kernel.org>; Tue, 16 Dec 2025 02:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765852210; cv=none; b=F7jTLzMr3oqbD6gw4jmwQnEY0CJwFJV0h5YgHjdCY93HWWXT5PDNgXX6JQ5MU+NkZVS6azBJmnQIApKsRV48f7sQjRw8vO/3Dn1El3v4dEYs8843BP0EiKK6wXTg/eY43+z14qgpZL/aFqkk29whUP66vEi7hs0Rm10BtsqCpKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765852210; c=relaxed/simple;
	bh=av7HsDMJCFH0/JcF6iiDV38WSkiY0kPOfCBqfHPoSYY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FkFU+kB+Ac+Jjn/lrTlInHYbHdJv/F6dcxjkig8FudbBXwAHOSeGCG/4lIUxjAdWCdlCeedQZu0vrja1n0jtOVvZO6V1CY0gmmmwwVFZ+mpP/KoUFcZ9soIEPZgjwNb4kyOe6DM/1gStadxJueYD9TbArv55csjleKo1i2svvg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bGIvkICK; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a08c65fceeso4959055ad.2
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 18:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765852207; x=1766457007; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F06E9mL+JSW5/EbrGKINfEcidqEzevYRu/rTewDHlvM=;
        b=bGIvkICKhCSUMwlpC83rnNeW5Ffow0QPR+AmJNnw7szXNOMAamtxUM4C/le7svvGS3
         rxypGbTnODWvhYIFlA9iOeq+da927L9VZ9Q570G4EKTsshifTWuyaO9JJBWjhxA1uXgd
         rkTwUA2mLzd52kWQsFRdj5hIkd02J7x8NuCB2yP6x7BB2t1+Fufen7PxUytHqh3ZUJPP
         gNQdfvKQFMuEhxgdTVjD7/D6ZrI/Jox/3usQmexfe96GNULyhZnpTQldpJ/qqfPlg65f
         /0nIBxPUkvnIoZN3geuEpnLqK5JiSqc74a7Z3KXRksA8eDmMI4vv0u7wCeiKK3xZ+92N
         ZcCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765852207; x=1766457007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F06E9mL+JSW5/EbrGKINfEcidqEzevYRu/rTewDHlvM=;
        b=h4LLW3HT3oVEmIt5Ia0v0u1mHhhJFqy1nyqjlWd7vakHihA3qK4HfP6R8S9FR5loLb
         /Bhb2auOCddcGvORlzG9FHt9USOZhwCNIUqtEk84u9ccD9q8wJjbjDOUwHlkQvumS2il
         Dt9ARKJh8GUu5uuTpXSLJMTYhKUth3NJ2mMPKTD9Gm8yWfalmHhRe4Y9nReUfsIB+SKN
         6APSm+fM9TMRyvdviuPqYn17dl9dyLeoLXKZGckS7zSW13HQc6djDma3lqEIxLC2vsId
         yWiQcH7IeRgmzcPaaPKG34+cHhnVMNFGsSZftSYgnO4WH7npbb7+2QUXleuTfUTIEK98
         ZJHw==
X-Forwarded-Encrypted: i=1; AJvYcCU08RkY+nLm6zBzmLOSwbsapuoB8Gu7fUKnOi/Sy8ccie/Wf2d0saTjZLtgNTiXZIvbzw2Nh5YVAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQpwCTFCXUEGcwaEJQabwlJPLlole7zmqvUhqg9/+8T36nYQgE
	nlUzALR/7fRhnVUx8+QYoxsKDRjiJy08jA2QBarWLcXaPGUm7J+S5EKJPV3LNWVR0L+ldbWC/y2
	qtiLqmUjlY61KlrEk/7KmVEuXudujyq9rIkkOfU0g2A==
X-Gm-Gg: AY/fxX7Z/lJ2wZtHSdDUsAfsOV0QKY5ZetUlTqTLjs09r6JdvTOcED3ZAfaL6eSgJ7F
	/Xvkw6ddrK77lWnneCsa5ts22ccydQnOU8XCbKZRQc0FiLT5gIFU3k5eZNo3j7bb01VYpwar49b
	ekKVWSWPLevMyOFmae7nYHcY8w5HbjbU5mywZdxOcynZIaf8kPtdrfH+67akHSVkF1j27aQmohi
	jlQrPkRBIMS6f93G/7lKJRRnYGKklFuxk1dfW1ERt7t8CZ6+hgeKK3IzyOOBkXo8pJSn+zG
X-Google-Smtp-Source: AGHT+IHsskY0E6SwsH4c6CYS3ufb3YIHa+c5mL2i2bSZkeq6WbZbEzk7jR94HfhUAfnBFymaznWMK0GJuWX5lwrNWg0=
X-Received: by 2002:a05:7022:2395:b0:119:e56b:c3f5 with SMTP id
 a92af1059eb24-11f34c52737mr5751476c88.5.1765852206992; Mon, 15 Dec 2025
 18:30:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215200909.3505001-1-csander@purestorage.com>
 <20251215200909.3505001-3-csander@purestorage.com> <CAJnrk1YiZ6NuUavG86ZGpZ0nz8+fqi_SYkqx=UQWdWhTPj7mWQ@mail.gmail.com>
In-Reply-To: <CAJnrk1YiZ6NuUavG86ZGpZ0nz8+fqi_SYkqx=UQWdWhTPj7mWQ@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Dec 2025 18:29:55 -0800
X-Gm-Features: AQt7F2r_Z78NcnaQ7VuCa82yMmbSVIB6dI25ObekLCS424pY7hdhzHXxMyFUbiM
Message-ID: <CADUfDZr+vUSuxKGCDX+NeqNE+amRXiwDdX3WckmTzosDJnCYVw@mail.gmail.com>
Subject: Re: [PATCH v5 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING_SETUP_SQPOLL
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 15, 2025 at 4:50=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Tue, Dec 16, 2025 at 4:10=E2=80=AFAM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > IORING_SETUP_SINGLE_ISSUER doesn't currently enable any optimizations,
> > but it will soon be used to avoid taking io_ring_ctx's uring_lock when
> > submitting from the single issuer task. If the IORING_SETUP_SQPOLL flag
> > is set, the SQ thread is the sole task issuing SQEs. However, other
> > tasks may make io_uring_register() syscalls, which must be synchronized
> > with SQE submission. So it wouldn't be safe to skip the uring_lock
> > around the SQ thread's submission even if IORING_SETUP_SINGLE_ISSUER is
> > set. Therefore, clear IORING_SETUP_SINGLE_ISSUER from the io_ring_ctx
> > flags if IORING_SETUP_SQPOLL is set.
>
> If i'm understanding this correctly, these params are set by the user
> and passed through the "struct io_uring_params" arg to the
> io_uring_setup() syscall. Do you think it makes sense to return

Yes, that is correct.

> -EINVAL if the user sets both IORING_SETUP_SQPOLL and
> IORING_SETUP_SINGLE_ISSUER? That seems clearer to me than silently

We can't break existing userspace applications that are setting both
flags. It may not be a recommendation combination, but it is currently
valid. (It enforces that a single thread is making io_uring_enter() +
io_uring_register() syscalls for io_uring, but the kernel SQ thread is
the one actually issuing the io_uring requests.)

Best,
Caleb

> unsetting IORING_SETUP_SINGLE_ISSUER where the user may set
> IORING_SETUP_SINGLE_ISSUER expecting certain optimizations but be
> unaware that IORING_SETUP_SQPOLL effectively overrides it.
>
> Thanks,
> Joanne
>
> >
> > Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
> > ---
> >  io_uring/io_uring.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index 761b9612c5b6..44ff5756b328 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -3478,10 +3478,19 @@ static int io_uring_sanitise_params(struct io_u=
ring_params *p)
> >          */
> >         if ((flags & (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED)) =3D=
=3D
> >             (IORING_SETUP_SQE128|IORING_SETUP_SQE_MIXED))
> >                 return -EINVAL;
> >
> > +       /*
> > +        * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQE=
s,
> > +        * but other threads may call io_uring_register() concurrently.
> > +        * We still need ctx uring lock to synchronize these io_ring_ct=
x
> > +        * accesses, so disable the single issuer optimizations.
> > +        */
> > +       if (flags & IORING_SETUP_SQPOLL)
> > +               p->flags &=3D ~IORING_SETUP_SINGLE_ISSUER;
> > +
> >         return 0;
> >  }
> >
> >  static int io_uring_fill_params(struct io_uring_params *p)
> >  {
> > --
> > 2.45.2
> >

