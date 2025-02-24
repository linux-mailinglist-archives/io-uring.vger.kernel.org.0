Return-Path: <io-uring+bounces-6689-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3642CA42850
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:52:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 949501898DC0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:52:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B0B2627F2;
	Mon, 24 Feb 2025 16:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RPy2ooSN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4606723BCE0
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 16:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740415966; cv=none; b=qhJCa2DfzXA8JivvekQkAuYobaf0lfk6h2CX3joIRrPwaJ2a/L6ZIPe1G0JK8a9AkVS5g2Qfg86GxGQFjqEylnwThIhm3ZdrOBd+Em1h/4IXWAWvN0daPD2BnV3ljPfchLBWmualxYFlS6FQ+0pgB/BY4Q2rRavfgAQllQ5kzLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740415966; c=relaxed/simple;
	bh=Mhg1fsSDNP/cSimsZd+Z9AFTlzJl5+hK/EXjLzBRG7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tI20h9KmWEPQZn3f0elAfukTkyU9Ff0TV8JUFKFNH0MM6meEQzrQT1KJ5TVzsnT+me9vWtsCLV7RIGh4pbDusn1A5Zgu2Xe+FR7plzn/W4HTOUm9DoSf17mgwcXxbPP5G7OxRDSTuS5CSAB+U8xlUX3IEYrDBl03LCd7Y5eQAoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RPy2ooSN; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-2fc92215d15so1308096a91.1
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 08:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740415963; x=1741020763; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G7qogzoZaYoz4rndpvXwwluJaM3ThK/28vCYcpdbTks=;
        b=RPy2ooSNrqK+W2lQDbNQM/X/L0wxrVktJqZZ5y9oZSQwXsix6M2hSntLOUMxznLby4
         /oUe8kZbEaHWG4+CRW2BFJBaSphOKlneZ5KHFo62UjSLgkvBRyqVGWXG8qHohQuEByW5
         NHxdVvzn7a4AJGY7Hf+iO+Et5lJM1LEJ0XqLV79c8n01ejYPh5nR7/nuBvSRNTbMXOU4
         GST7lh/nrVDaJWBxL9/ajvxbtD8J8iYq2FzNO8RZZIIPgopW18lGRZD68ddzyF+ztT9H
         Oaz3Ja84zAd/10Soh6MEvZYG8jOTkXoJxv8ToHVpOod/IP7X94unaupqeGcLz+TKAbwD
         BVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740415963; x=1741020763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G7qogzoZaYoz4rndpvXwwluJaM3ThK/28vCYcpdbTks=;
        b=FQUigKMuQvcAPl+n6BgwNhkp94ZUbBZuZfcO2+wEXk+NW5MFqN0KPEUpalnnnVzEtO
         wSZ5p6A/LxXKV+E/pem1tf9VOZDZGAQDfxbR1bjLZTrK4JSEf1aqRP/DkI5oHY34oY4e
         BKCSi1IV3ntX/H3NJII0DVcfsDE8AJ6WKA451Pg0lS19+7KDBwY2s9pM8gVMVAYKQkFp
         dJIIAXZHi6ZxghK+Z2Sny3U+tXomm9I8K2jPdhpsp5L2GWmwvZOZXzjeVZu8gCfdLs5e
         tbpvdYQpirC84nSDlYj75i120bs858OY5qpGVNuIbI0ou4s7Qx/7LUWgaeL7d0m3rmpA
         2emQ==
X-Gm-Message-State: AOJu0YwEqFhu/1Gz+Qeq0JjyI32VYJKw0afJrSvBYc5vB4Ph8wVZ3YvG
	ZrbPdBbTlNg0mEb6os94qSWilX41DwOpea4RdZf2qKrw02UE/Z9c1TqSOH7zYqErhk9jijtLQyv
	CaEaRMvDGbJzga8Lew3mPvHU1xnOV//UWcBn4B8b+X3PV7vk23yY=
X-Gm-Gg: ASbGncsnsp0DFIkx3LTXcbvbFnCf1TXY5+meRBj0XFvpL/O5xpvppBklIAXXkyD40Bj
	ZiWCmnPiGzIlMJwmq0CfgqwvbhoA/YBuc8NJ5YMJCFyfeNL+12W06zvnrZT3yxoVJJzLObv2+2i
	ttMjjPJww=
X-Google-Smtp-Source: AGHT+IEyvRXffgPlhA+mjac0zH6+JypRJI9BBdn1EwATcvPVWtA1MHRtpoRSPWTN3fbGJIYOvrYU3eG3dHkEiSOkbEg=
X-Received: by 2002:a17:90b:3a81:b0:2ee:b665:12ce with SMTP id
 98e67ed59e1d1-2fce789cc70mr9084536a91.1.1740415963686; Mon, 24 Feb 2025
 08:52:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1740412523.git.asml.silence@gmail.com> <2bedcfe941cd2b594c4ee1658276f5c1b008feb8.1740412523.git.asml.silence@gmail.com>
In-Reply-To: <2bedcfe941cd2b594c4ee1658276f5c1b008feb8.1740412523.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 24 Feb 2025 08:52:32 -0800
X-Gm-Features: AWEUYZl7brWB4760t9tKDB4355yb1I8pZKqzqvF4xNXwcYdPjq2cHgGWdesUYeo
Message-ID: <CADUfDZp7SWy_pcL+GL9SbFY-qMaNV+gja+gRiY=XeefDoZjnDQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] io_uring/rw: allocate async data in io_prep_rw()
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 8:07=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> io_prep_rw() relies on async_data being allocated in io_prep_rw_setup().
> Be a bit more explicit and move the allocation earlier into io_prep_rw()
> and don't hide it in a call chain.

Hmm, where is async_data currently used in io_prep_rw()? I don't see
any reference to async_data in io_prep_rw() until your patch 4,
"io_uring/rw: open code io_prep_rw_setup()". Would it make sense to
combine the 2 patches?

Best,
Caleb

>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/rw.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index 22612a956e75..7efc2337c5a0 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -203,9 +203,6 @@ static int io_prep_rw_setup(struct io_kiocb *req, int=
 ddir, bool do_import)
>  {
>         struct io_async_rw *rw;
>
> -       if (io_rw_alloc_async(req))
> -               return -ENOMEM;
> -
>         if (!do_import || io_do_buffer_select(req))
>                 return 0;
>
> @@ -262,6 +259,9 @@ static int io_prep_rw(struct io_kiocb *req, const str=
uct io_uring_sqe *sqe,
>         u64 attr_type_mask;
>         int ret;
>
> +       if (io_rw_alloc_async(req))
> +               return -ENOMEM;
> +
>         rw->kiocb.ki_pos =3D READ_ONCE(sqe->off);
>         /* used for fixed read/write too - just read unconditionally */
>         req->buf_index =3D READ_ONCE(sqe->buf_index);
> --
> 2.48.1
>
>

