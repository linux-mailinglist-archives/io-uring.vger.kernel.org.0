Return-Path: <io-uring+bounces-8258-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81BB0AD0787
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 19:32:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE07F3A5977
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 17:31:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F37D7D07D;
	Fri,  6 Jun 2025 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Fzp+7/V9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA60B381C4
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 17:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749231132; cv=none; b=DTYnpQ1lW5wLvWwZz43910e2YxguiznAAAZGVauaClxUwre+/Ril2rec4IbACqUIWNEIWZ/a2cuWGVDPTavYKd4J3NRskn3JTM/DEx1in4cYgcgPrFLXfPRB6yk4QGytXpAvt4Xcb7dqaP1nrU/hhD0xAUuFV7LeyP8FqagPzsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749231132; c=relaxed/simple;
	bh=qErB2FJ9SwmhtFt0pyKGt3xydAJzP447bhNG0ujauRQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OH43mS+t2+ACYrfPxhcWc+ooQ69Eh/ObjWOjQFOH85JAOxEg0VFx1OJ2N3gv4StLGhlymMdis9P7nMz+di5BfD6Op30hE3MVFZD3GqtbICE3zqVIYz63KqWtf7z2TlobQlb/nmnjHOzhZTk6wkk6ozsAwE0bSrKe8enYBx+Cy/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Fzp+7/V9; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b2ef619e80eso192553a12.2
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 10:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749231130; x=1749835930; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=foZAkxwtAax3ghRf87ZmhtF3B5SlHHXs9qOuA6L40KY=;
        b=Fzp+7/V9SQFj2VcImQ/9OvkuJwoPYVLZ0H2E3a4A99EriMqfa2ko+kHEC8AzysEstM
         vUMztLURclgL24AXcWtNkgEmibjPzV9vp0aJ0K0GHLYQtb5jVOPj6GF+3hdoYYtVYWLl
         u3KlIpkJ501T6dKoJDTgixGDvbmqkgrXg5Dp92xUkbJPBmHtrEjw7h6m5TSIzyqP9WD4
         JPsNRL0Yt0wx4ztrX32BH3vMjdV286Ah/XXZL4azt6yo77ysMBzWO3N0GFuXib6eW82P
         0LCmYjImr6ZF/zFXVuPKJrGagAQq54xTZKa6ldeN5Y6sF18BlAqkldfsJw1s0Lct7EX2
         Zskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749231130; x=1749835930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=foZAkxwtAax3ghRf87ZmhtF3B5SlHHXs9qOuA6L40KY=;
        b=UIOuW+NwLFE2+2rrKL2vKPOiJuRY/I4NvttTevuFiuTAwT4cYAnHc3toOcxFRr4xUi
         OHzCAgrdPAxDX4B4n+QQHYGHkezFWENhfVCTh3We/WwpzyisNCSfSdo/lcTRv9FnKyGU
         05COT6tMkD536o17rI0laxbqobhsl8cS5aZqVS4TSPpujPmZervV4NhhadFBw9TcttDK
         2lx2dygyRh5f82DGOYhMvesRRZfm0Vr1+LvSZispgskOic73ekVnjyDfHmtqHgN1Soov
         wS0C9sKKpUcGg33IT/q6XrFIkd9prOLNadEcY6HoDORXkHk+cP+kHN69rTYFnoD0Tux3
         4idg==
X-Gm-Message-State: AOJu0Yw1cWKlNFpWaljmZ+8gWCrxFGsk8abM6p9MVysN1Kx6AlZJQGho
	ug836IowttGmrRM8JvFL48NCh+wn1vjwXywFXv93lVgmBEpj8SM0P86eO3F14NTzVQ1FiEEfnxr
	R9CZ7XcE57uqh0INQbexsbLPOzoM1vXbzcC3l7cWvXHZHS5AFrHR+
X-Gm-Gg: ASbGnctmNJf8wefuoIcr2BTrCqhaWCeMXDeYsl8YuWLBYIP4JvxpN3tB5/UfPoqWVJJ
	5Zu45waFZD/53BaDIpn2mtd13p+OwmpqU11Ed281QPi+4mvzmabZKgMV8c7NLLvhbr+zuPAtT5M
	6axqwNj5RyQS9iHa6YTSkrpe0G8K5bvT+T
X-Google-Smtp-Source: AGHT+IFn4YwWGB7YLzgEp4JcODIwwmcD2bS/x1COI9zRmJz34V6wPOpi+wHohPv2eeO1DnJW9mz3BO9yX0nQP7FSMiA=
X-Received: by 2002:a17:90b:2247:b0:30a:80bc:ad4 with SMTP id
 98e67ed59e1d1-31346af79bdmr2560805a91.0.1749231129922; Fri, 06 Jun 2025
 10:32:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250605194728.145287-1-axboe@kernel.dk> <20250605194728.145287-2-axboe@kernel.dk>
In-Reply-To: <20250605194728.145287-2-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 6 Jun 2025 10:31:58 -0700
X-Gm-Features: AX0GCFu8LKt_prCvmgUqKTgyI7AfsN_BifgCWX5FRwEtw-phssMpnM59YOf7A6A
Message-ID: <CADUfDZpeHidaeQ482gFt8n2gPVXYY0aZKvch6Di=NbZxZm28_A@mail.gmail.com>
Subject: Re: [PATCH 1/4] io_uring: add IO_URING_F_INLINE issue flag
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 5, 2025 at 12:47=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> Set when the execution of the request is done inline from the system
> call itself. Any deferred issue will never have this flag set.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h | 2 ++
>  io_uring/io_uring.c            | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 2922635986f5..054c43c02c96 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -26,6 +26,8 @@ enum io_uring_cmd_flags {
>         IO_URING_F_MULTISHOT            =3D 4,
>         /* executed by io-wq */
>         IO_URING_F_IOWQ                 =3D 8,
> +       /* executed inline from syscall */
> +       IO_URING_F_INLINE               =3D 16,
>         /* int's last bit, sign checks are usually faster than a bit test=
 */
>         IO_URING_F_NONBLOCK             =3D INT_MIN,
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index cf759c172083..079a95e1bd82 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -1962,7 +1962,8 @@ static inline void io_queue_sqe(struct io_kiocb *re=
q)
>  {
>         int ret;
>
> -       ret =3D io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE=
_DEFER);
> +       ret =3D io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE=
_DEFER|
> +                               IO_URING_F_INLINE);

Isn't io_queue_sqe() also called from io_req_task_submit(), which is
an io_req_tw_func_t callback? Task work runs after the SQ slots have
already been returned to userspace, right? Before the unconditional
memcpy() was added, we had observed requests in linked chains with
corrupted SQEs due to the async task work issue.

As is, it looks like IO_URING_F_INLINE is just the inverse of
IO_URING_F_IOWQ, so it may not be necessary to add a new flag. But I
can see how core io_uring might add additional async issue cases in
the future.

Best,
Caleb



>
>         /*
>          * We async punt it if the file wasn't marked NOWAIT, or if the f=
ile
> --
> 2.49.0
>

