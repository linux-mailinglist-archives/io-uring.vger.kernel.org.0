Return-Path: <io-uring+bounces-8289-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5479AD28FA
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 23:54:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8ECEA16C317
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 21:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8DF321FF49;
	Mon,  9 Jun 2025 21:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ITtbS+Zp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D95121CC41
	for <io-uring@vger.kernel.org>; Mon,  9 Jun 2025 21:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749506092; cv=none; b=YLVC+a1++QFZZRF2jzkEkX9r4ts3AzC0rXjCHG4E0u70VjlKXVse+1+u7/1lfsJi8X18/kMH2SzzAKqJwLq8D7o4WymTBramchAIg+c7+0xfdxZaeqb/hsiVZRY5H8Rz57VILPvTozOHabBuewyo7/D1NXBxkCUW87nAbk1LDM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749506092; c=relaxed/simple;
	bh=FXvZYGnpBRWiC+BZdUGBgJW5/cAH5AvB+czy0gmqWzY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nzdf8JcLjnw0KRHmPhUufk/Ln5dTzoUuIWnzYsQUlxVmun8QtNlV27r7dPlGQ+63exQZevkSuG8zxAxRmwlUJUbdcQ039oOHfnSfiKGcJ3QMG3teQ0uufIeiSqxijP8lWc/TWiDJgR83ki3IQmQUX83sc072FjxMKygSSrYOt9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ITtbS+Zp; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3138e64fc73so162893a91.2
        for <io-uring@vger.kernel.org>; Mon, 09 Jun 2025 14:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1749506090; x=1750110890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+jXZ/rWd3I4eXunvBN93R0nGdH8A+7n112+qksGtxOs=;
        b=ITtbS+ZpK57CV5e9b3sIRF1s1P0WYkBAZgqVYQ2hGVl1rUKpQXnNUSax6Cf+HLHDDT
         CP+EMq7JFIvRpx3Jh4+/SSCodEKvUJWCp3L9hKmQvTcLGniUx55cOwwj0IvvBlv7mmB/
         TAqrstLjQxj1+Ebi9wP9pOIOx9JKpBovylQU/FUozzjGyP6q2WFuoE52em2H7F+F+osW
         F+r88IzZxstfPs8zXfs1D0vblmR+WqbzgawA86x7sSiCq0zXmcVMQ7lll1iX3bL0lO3I
         1RRv8wk3yjBTjEZsoNfkbN8t+bomg/j6GP0x0a4XYFH9COkr6OXqXagbYUsN3hXLuYX1
         NBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749506090; x=1750110890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+jXZ/rWd3I4eXunvBN93R0nGdH8A+7n112+qksGtxOs=;
        b=GMBTPYJtfMfWoL4kkV+Pkehk1ct8+FHZxIoF8285VK10/qKMXzQdK9jabrvpmiyBJq
         UK5F91hrHT7d2SwJRsCYtUPBWv5swlMj6uS2wXkO2MLD0V5O4FIwi+xZUrN4E/RMM1sK
         FUxF6NAVkzIA2tMG1hlUcj8qOce5l3SEyuwLjVppXiecieSGyeB+c+XJRgxyTRwpyqqY
         4lNEHjEqTtA6/9wqKb48qUwhyCPLUV8mN03Z83vstRU6YlFBcU5H9Zngvsf+UITlKDIm
         A3jH9+WxevmdCDcag74BXbJmfFs8JENZzFFP7q2jY5Zvn9DIIJMKsO1L45XdHTal+rN0
         RSoA==
X-Gm-Message-State: AOJu0YzbQMPKfq0N/gVgP4PdFJe6eNsG1ydIO/JPzA6WmoIYG2+IS3ds
	Xnt1nryAfSh7JjDp87+Z3ro/vosUEdx5EpZewxYGOGNhgfWFuRwUyBAmoB4Wagq+pzftrJsbD8M
	TzCuOEYAwZoeiTUM5Vb7bOpfz26nBoQ9794g+U0Oopw==
X-Gm-Gg: ASbGncsXqQj/qXIhwVkHlYRcX5qBCD3Qd/xiJhsDk7BL6T99M00A0VuVW/QNRjbvM6N
	sxurPQrV3Uca8zvWgTEu5VGGridCKDFoTzCth4uqLcRgvkuqrbxAvQqx23+HPifuIFP3V715pVF
	7LhKWccnPHUC3yDgUlQDls3YzgwORcTVFdeViQDDS59yk=
X-Google-Smtp-Source: AGHT+IHcNd2kQp5nuxwGNeL7uX5Ry7YGiq2pDNNWPjobeMERp8CDV1vSx3qxR0vxNyf60tVeJixigV777Pv6ajSVaMg=
X-Received: by 2002:a17:90b:2886:b0:312:e9d:4001 with SMTP id
 98e67ed59e1d1-3134e4531e8mr7598360a91.8.1749506090273; Mon, 09 Jun 2025
 14:54:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609173904.62854-1-axboe@kernel.dk> <20250609173904.62854-5-axboe@kernel.dk>
In-Reply-To: <20250609173904.62854-5-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 9 Jun 2025 14:54:38 -0700
X-Gm-Features: AX0GCFupnQST321d5uVl_KXMnOUAB87ilepT9G3y0gI64sXso1Baowc6b-sN4Ts
Message-ID: <CADUfDZr=EhcUuJuMC5-VW0hVCNUNwtjNbb19fkApdD7j2aSGMQ@mail.gmail.com>
Subject: Re: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid
 unnecessary copies
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 9, 2025 at 10:39=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> uring_cmd currently copies the full SQE at prep time, just in case it
> needs it to be stable. However, for inline completions or requests that
> get queued up on the device side, there's no need to ever copy the SQE.
> This is particularly important, as various use cases of uring_cmd will
> be using 128b sized SQEs.
>
> Opt in to using ->sqe_copy() to let the core of io_uring decide when to
> copy SQEs. This callback will only be called if it is safe to do so.
>
> Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  io_uring/opdef.c     |  1 +
>  io_uring/uring_cmd.c | 21 ++++++++++++---------
>  io_uring/uring_cmd.h |  1 +
>  3 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> index 6e0882b051f9..287f9a23b816 100644
> --- a/io_uring/opdef.c
> +++ b/io_uring/opdef.c
> @@ -759,6 +759,7 @@ const struct io_cold_def io_cold_defs[] =3D {
>         },
>         [IORING_OP_URING_CMD] =3D {
>                 .name                   =3D "URING_CMD",
> +               .sqe_copy               =3D io_uring_cmd_sqe_copy,
>                 .cleanup                =3D io_uring_cmd_cleanup,
>         },
>         [IORING_OP_SEND_ZC] =3D {
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index e204f4941d72..a99dc2f9c4b5 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -205,17 +205,20 @@ int io_uring_cmd_prep(struct io_kiocb *req, const s=
truct io_uring_sqe *sqe)
>         if (!ac)
>                 return -ENOMEM;
>         ac->data.op_data =3D NULL;
> +       ioucmd->sqe =3D sqe;
> +       return 0;
> +}
> +
> +void io_uring_cmd_sqe_copy(struct io_kiocb *req)
> +{
> +       struct io_uring_cmd *ioucmd =3D io_kiocb_to_cmd(req, struct io_ur=
ing_cmd);
> +       struct io_async_cmd *ac =3D req->async_data;
>
> -       /*
> -        * Unconditionally cache the SQE for now - this is only needed fo=
r
> -        * requests that go async, but prep handlers must ensure that any
> -        * sqe data is stable beyond prep. Since uring_cmd is special in
> -        * that it doesn't read in per-op data, play it safe and ensure t=
hat
> -        * any SQE data is stable beyond prep. This can later get relaxed=
.
> -        */
> -       memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
> +       /* already copied, nothing to do */
> +       if (ioucmd->sqe =3D=3D ac->sqes)

REQ_F_SQE_COPY should prevent this from ever happening, right? Could
we make it a WARN_ON()? Or drop it entirely?

Best,
Caleb


> +               return;
> +       memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
>         ioucmd->sqe =3D ac->sqes;
> -       return 0;
>  }
>
>  int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
> diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
> index e6a5142c890e..a6dad47afc6b 100644
> --- a/io_uring/uring_cmd.h
> +++ b/io_uring/uring_cmd.h
> @@ -11,6 +11,7 @@ struct io_async_cmd {
>
>  int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
>  int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *s=
qe);
> +void io_uring_cmd_sqe_copy(struct io_kiocb *req);
>  void io_uring_cmd_cleanup(struct io_kiocb *req);
>
>  bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> --
> 2.49.0
>

