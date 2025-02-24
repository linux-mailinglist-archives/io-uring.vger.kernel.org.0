Return-Path: <io-uring+bounces-6688-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 59360A4284C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 17:52:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A53973B34F0
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 16:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 769C81514CC;
	Mon, 24 Feb 2025 16:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PAjgJkxh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72207157465
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 16:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740415709; cv=none; b=VG1vNnVdTEEYrEvsQ0Lg709S+9BJuY2ap4ITVZLWGVvhteWus2F5MKJYknPj5sbab/v0UVcvMWHsg1OVGbbZ0TO6CuQazjkwPVmtzb+ytgymUnuGX1awXQ1jRIMsIvyfILRFtnKml9E9xGjCfa6QyqpMvCR4IO1R/KYJP210k1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740415709; c=relaxed/simple;
	bh=ETl9xd9JLoxlq8Fh4NYTQRZPEQF2mzafk1TB8PreTZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q/o1ALAzbV285m893ZHKMs8yNScQU9EzQOoowupO21e7GVk3R17rb5ado2KzNRGyOhbg75bYnnNPpFngrdME7EpcXGDB0WFGYg4r1/NZbFeiNxRXx57g0OQ9aEVIiMqdkKSNyfKhG33m9KMsCrdIlCWNqqcKcQYmKAKpoJ9CshI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PAjgJkxh; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-2fc29ac55b5so1210367a91.2
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 08:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740415706; x=1741020506; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OzxRSqCq0VanQpDk8jh61vyKMLAdTqvlSskV5R98TeA=;
        b=PAjgJkxhTDEYYSuQFWufyz/QmW0GAuJidclaef0vCJI9LyQHt1mynncI2iF4HkhmyK
         eQL2jXe55qf6Ik3+/d/zWr0IL1mNes21xJ9aTuQaOLb7j2iVJpGB8xpfFVTCM2p1zfR4
         EwFoW6H5lhpySUutcPYmT+LQijNHw7iS11OhGKGYc1++GbLg4Vj2Dne+MLcpBy7rom3u
         AyIT2sVwN4dwhh4xap3zxeoRWdKlzqYq9pBpZzHnR5rgoKYcDXteqOrvlydGxd1S661t
         7ddlmPQj5+nWCqVDDCvUenSGKswS89Sih+H3aKAt1a1oPPxF9ay6wJpUOVZmB+PgIyvq
         eXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740415706; x=1741020506;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OzxRSqCq0VanQpDk8jh61vyKMLAdTqvlSskV5R98TeA=;
        b=AJT46AA3QV4FpO1PLDClUi49LgwYRqQcxs5eDwcSjy9VhUgyofi5A9wZasCeIEWQn7
         bUgtsENlmu4rZaD8DMPSeNRSiz7qx8nPB+tjzOjmIenutIGzhDYgU2gIironTxNFBcJN
         FxNSXlL4xl4sJzKL9pTNtG29tmGe4m/lwEWDPPO/2J0P5u2/s9VlMSCMNwPHQBihPhxT
         //ZUC97n5k4C4XdT5Soq1XquOj4bmBVe0777spKTotbWyVGgX2C9Kq/yYMLj26LO79fZ
         r2ad9bWIkEbAgKkCBOVp/V07r9xLglUwRfNZnWnhKWH2irPAcR2t0L0v46VkV0mnOxXr
         RkAQ==
X-Gm-Message-State: AOJu0Yww1bNJ7xs3W3Jyatj9Np/BfFm0eGY/eJY28EOJgg7INuOgfybt
	PEw+Xl2Vrrhdfhqffa42bssGpvCeSef7Yv4s/GOSNq+1ohw5jRVd0Fc6yloKrJbjhr0ifLT3uDy
	FRvpK0lv+eGHdajFYRALe5svB4gGWivfkAILfopXiN+XhSI0sD3U=
X-Gm-Gg: ASbGncvUMRhelAxUbBoq3X4PKv1BLaHh3feOdUA8GdmeJ6N58jCj/LHRZBxFUgL1gs8
	dEnHsTceC+WRYAy14sdz7eXKsjKZjx44oeHne/xJVscux2KRxCa3bZqHpBPFU5VL7H/tly5a7cb
	q1WeO1BB8=
X-Google-Smtp-Source: AGHT+IF+GWk85+h1pEAslTc+4sxHVC3Pug0HhgZTj58Y8in1WmpQ0GGS6SglfEEa+yrsaiP+Ne4qrd1prtzcnS6+e2s=
X-Received: by 2002:a17:90b:4c0a:b0:2ee:b665:12c2 with SMTP id
 98e67ed59e1d1-2fce769a322mr9033194a91.2.1740415706493; Mon, 24 Feb 2025
 08:48:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1740412523.git.asml.silence@gmail.com> <5cf589c0efb611bfe32fc3b69b47d2b067fc8a65.1740412523.git.asml.silence@gmail.com>
In-Reply-To: <5cf589c0efb611bfe32fc3b69b47d2b067fc8a65.1740412523.git.asml.silence@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 24 Feb 2025 08:48:14 -0800
X-Gm-Features: AWEUYZknNO2iaDCaqdhThZ303_PELLCL9ScQHtmcHJCWihbe8pY6POY796y2qTE
Message-ID: <CADUfDZp5FJ52F4SUejCcXO4YzM8r411_MwT3sRRTWQBeo89pmQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] io_uring/rw: extract helper for iovec import
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 24, 2025 at 8:07=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> Split out a helper out of __io_import_rw_buffer() that handles vectored
> buffers. I'll need it for registered vectored buffers, but it also looks
> cleaner, especially with parameters being properly named.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  io_uring/rw.c | 57 ++++++++++++++++++++++++++++-----------------------
>  1 file changed, 31 insertions(+), 26 deletions(-)
>
> diff --git a/io_uring/rw.c b/io_uring/rw.c
> index e636be4850a7..0e0d2a19f21d 100644
> --- a/io_uring/rw.c
> +++ b/io_uring/rw.c
> @@ -76,41 +76,23 @@ static int io_iov_buffer_select_prep(struct io_kiocb =
*req)
>         return 0;
>  }
>
> -static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
> -                            struct io_async_rw *io,
> -                            unsigned int issue_flags)
> +static int io_import_vec(int ddir, struct io_kiocb *req,
> +                        struct io_async_rw *io, void __user *uvec,
> +                        size_t uvec_segs)

Could use a more specific type for uvec:  const struct iovec __user *uvec?

>  {
> -       const struct io_issue_def *def =3D &io_issue_defs[req->opcode];
> -       struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
> +       int ret, nr_segs;
>         struct iovec *iov;
> -       void __user *buf;
> -       int nr_segs, ret;
> -       size_t sqe_len;
> -
> -       buf =3D u64_to_user_ptr(rw->addr);
> -       sqe_len =3D rw->len;
> -
> -       if (!def->vectored || req->flags & REQ_F_BUFFER_SELECT) {
> -               if (io_do_buffer_select(req)) {
> -                       buf =3D io_buffer_select(req, &sqe_len, issue_fla=
gs);
> -                       if (!buf)
> -                               return -ENOBUFS;
> -                       rw->addr =3D (unsigned long) buf;
> -                       rw->len =3D sqe_len;
> -               }
> -
> -               return import_ubuf(ddir, buf, sqe_len, &io->iter);
> -       }
>
>         if (io->free_iovec) {
>                 nr_segs =3D io->free_iov_nr;
>                 iov =3D io->free_iovec;
>         } else {
> -               iov =3D &io->fast_iov;
>                 nr_segs =3D 1;
> +               iov =3D &io->fast_iov;
>         }
> -       ret =3D __import_iovec(ddir, buf, sqe_len, nr_segs, &iov, &io->it=
er,
> -                               io_is_compat(req->ctx));
> +
> +       ret =3D __import_iovec(ddir, uvec, uvec_segs, nr_segs, &iov, &io-=
>iter,
> +                            io_is_compat(req->ctx));
>         if (unlikely(ret < 0))
>                 return ret;
>         if (iov) {
> @@ -122,6 +104,29 @@ static int __io_import_rw_buffer(int ddir, struct io=
_kiocb *req,
>         return 0;
>  }
>
> +static int __io_import_rw_buffer(int ddir, struct io_kiocb *req,
> +                            struct io_async_rw *io,
> +                            unsigned int issue_flags)
> +{
> +       const struct io_issue_def *def =3D &io_issue_defs[req->opcode];
> +       struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
> +       void __user *buf =3D u64_to_user_ptr(rw->addr);
> +       size_t sqe_len =3D rw->len;
> +
> +       if (!def->vectored || req->flags & REQ_F_BUFFER_SELECT) {
> +               if (io_do_buffer_select(req)) {
> +                       buf =3D io_buffer_select(req, &sqe_len, issue_fla=
gs);
> +                       if (!buf)
> +                               return -ENOBUFS;
> +                       rw->addr =3D (unsigned long) buf;
> +                       rw->len =3D sqe_len;
> +               }
> +               return import_ubuf(ddir, buf, sqe_len, &io->iter);
> +       }
> +
> +       return io_import_vec(ddir, req, io, buf, sqe_len);

nit: an early return for the vectored case could reduce indentation here.

Best,
Caleb

> +}
> +
>  static inline int io_import_rw_buffer(int rw, struct io_kiocb *req,
>                                       struct io_async_rw *io,
>                                       unsigned int issue_flags)
> --
> 2.48.1
>
>

