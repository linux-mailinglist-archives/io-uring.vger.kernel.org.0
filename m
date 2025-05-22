Return-Path: <io-uring+bounces-8078-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CBF5AC0E77
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 16:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F1036164BBA
	for <lists+io-uring@lfdr.de>; Thu, 22 May 2025 14:41:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA28528B516;
	Thu, 22 May 2025 14:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="IHbxfOAU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1893828A725
	for <io-uring@vger.kernel.org>; Thu, 22 May 2025 14:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747924863; cv=none; b=bwO1ybqFG2Sq+fBAtNcJBSsM0EUzLHlcCm7paMZMLi5ECDbc79HMvfnZk7xaHs1O1/nBtL1kTOnCSEUK3r9x841baksuPPAc3IH+s9R+QXlkt2+tpb9gjtN3Bv8d6mBKV2SI5hd0ntHIdxsoDWWL1X9Jrj03+l1j3MCtD3yNnj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747924863; c=relaxed/simple;
	bh=CvtkwnoCmGXSeC1cRLA8Mu3LLs/aDS0tUDFqfybmXSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uqKRRjz1lbg0uvTSGZ9I0Zlk8qryDv5L5ckdnLKd6eNNMsYQcCzccVKiOdQppfsMLYDFT99i3zbFJVGz3pbzX2yWJTYrfAyXWyvIwGt/RCQjCV4zeDig7MuWyn+zA8+7PiuGY8l0M7KA4KI2Jh62OHG8QzuX/9Sp/iJcHO3CvZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IHbxfOAU; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-22e17b7173bso5087985ad.3
        for <io-uring@vger.kernel.org>; Thu, 22 May 2025 07:41:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1747924860; x=1748529660; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nGzgwdt7v+xbDfDMVOWUlCaj1DQJ7m2YSSk5mQ/UorA=;
        b=IHbxfOAU3kKWYxJ++WovTzFROwhwz0GSrlnYlZf5D3/rIOB+1mrjABoqaPYwTw5s7a
         yWWcVk4/DuasWtRFswfknuXuGHcQO2K9elHhLob+k15TYEZY+9BwyZespjski9uzw8xS
         VEQ03pwfhzqbkKpNrTiGRpq4YqAtphmoQTO4ooD+vhR/vcVbOmWJ8fmG4JfkrzsL+Nhv
         UVEHFA2o73zY/x+buxdbgpHArCW5xbf4uCs4t36TmVc1quGKJJf+t3PhbqfROckxmBDB
         QRmLCypCKYw5tBoDL0MIXkStr21mP1+pTJUxk4LHHxJyALRVEflerLe5BWu4CBXXg4oS
         vE9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747924860; x=1748529660;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nGzgwdt7v+xbDfDMVOWUlCaj1DQJ7m2YSSk5mQ/UorA=;
        b=ssUbefgd6GJi94yO/GjIZUQIJJ11wlfq1lVzGIzjn7UFlvbUs6w0czBnIB4ZCsWQz+
         OeaMM+faErGvLWS9rd4eP1Nxh0DejPZJoOCXi1QOEDiIaXku193AGLNR2Rn4uGo/8U7v
         j/CcDU11pgh6fSQsuXGyNdREzE1DhMMKmxstNtOh3PXlKqJNPGYTc/ttbKmZyoiWoAFF
         74j3HhHPhIObzRsrNk1L+OoIbzxuQ96gWuCO9a4Kb36kc0pft3LTxk+hwF96DApdSZYs
         +2gjomdqcVFkp+xNDRVVP+Zf5YU2ItMhHuvGafzApmnHWrAEssGw8Qdf3HSOQForYoN4
         kLaQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwjU5objjG4XGkxGiEzzKXBywpNbWIEo/A/KU4N+euTI/fAcEpDlt8NmA4kf8vymYAO9DjVt1vTg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8bUjoWNbwd8+54trv6dRg0R9islTkNuezqRiNf1hMwrY+LF8q
	d0ybJ5FG6QgoOfFa2ti2YbQNeasT/ajbtaKnjNt5348ujvTuWG0mn2n8to+McK+a5NF1ifo/dID
	9o6jFAG2QPcppyh0hR0ZatZ+y4qIco/ZlDQHeQr8Z2g==
X-Gm-Gg: ASbGncu6D/iY7YWPYTPThlwcRlmCywkjNZ5e5b03JEIK2uNGV913jalp/+H0i38bb8T
	WLeGYU27DzwLmVrrKPdB30C+Av0nRwibKRm1FMOrYhc3dyrIakOfZy9+x32k+XnI9vCo8h5846D
	2Kwc2HgUO3ppTZOI/UL5vd+tkBBg9Uuv4=
X-Google-Smtp-Source: AGHT+IERLgDtN74rAEnE22DHeD0Z+GCxu9hFyAo8It691pNy17Y9eWyBuh8/aB4cCm5TLXuStkx4prxpgnoPpk6JccY=
X-Received: by 2002:a17:902:ce01:b0:215:b75f:a1d8 with SMTP id
 d9443c01a7336-231d43881e2mr140341885ad.2.1747924860282; Thu, 22 May 2025
 07:41:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250522135045.389102-1-ming.lei@redhat.com> <20250522135045.389102-3-ming.lei@redhat.com>
In-Reply-To: <20250522135045.389102-3-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 22 May 2025 07:40:48 -0700
X-Gm-Features: AX0GCFu1Jy5ltAjAEdEqwq6DBJ2dC3uKEtU34kB20PxLBUY0ZSrL0tMmPNtwBto
Message-ID: <CADUfDZr3W8dVwgBzHaFxv=vr52mGcimtc_urnTvCNoZ4Q9Ouaw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ublk: run auto buf unregister on same io_ring_ctx
 with register
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	Uday Shankar <ushankar@purestorage.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2025 at 6:51=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> UBLK_F_AUTO_BUF_REG requires that the buffer registered automatically
> is unregistered in same `io_ring_ctx`, so check it explicitly.
>
> Document this requirement for UBLK_F_AUTO_BUF_REG.
>
> Drop WARN_ON_ONCE() which is triggered from userspace code path.
>
> Fixes: 99c1e4eb6a3f ("ublk: register buffer to local io_uring with provid=
ed buf index via UBLK_F_AUTO_BUF_REG")
> Reported-by: Caleb Sander Mateos <csander@purestorage.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/block/ublk_drv.c      | 19 ++++++++++++++++---
>  include/uapi/linux/ublk_cmd.h |  6 +++++-
>  2 files changed, 21 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 180386c750f7..a56e07ee9d4b 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -84,6 +84,7 @@ struct ublk_rq_data {
>
>         /* for auto-unregister buffer in case of UBLK_F_AUTO_BUF_REG */
>         u16 buf_index;
> +       unsigned long buf_ctx_id;
>  };
>
>  struct ublk_uring_cmd_pdu {
> @@ -1211,6 +1212,8 @@ static bool ublk_auto_buf_reg(struct request *req, =
struct ublk_io *io,
>         }
>         /* one extra reference is dropped by ublk_io_release */
>         refcount_set(&data->ref, 2);
> +
> +       data->buf_ctx_id =3D io_uring_cmd_ctx_handle(io->cmd);
>         /* store buffer index in request payload */
>         data->buf_index =3D pdu->buf.index;
>         io->flags |=3D UBLK_IO_FLAG_AUTO_BUF_REG;
> @@ -2111,12 +2114,22 @@ static int ublk_commit_and_fetch(const struct ubl=
k_queue *ubq,
>         if (ublk_support_auto_buf_reg(ubq)) {
>                 int ret;
>
> +               /*
> +                * `UBLK_F_AUTO_BUF_REG` only works iff `UBLK_IO_FETCH_RE=
Q`
> +                * and `UBLK_IO_COMMIT_AND_FETCH_REQ` are issued from sam=
e
> +                * `io_ring_ctx`.
> +                *
> +                * If this uring_cmd's io_uring_ctx isn't same with the

nit: "io_ring_ctx"

> +                * one for registering the buffer, it is ublk server's
> +                * responsibility for unregistering the buffer, otherwise
> +                * this ublk request gets stuck.
> +                */
>                 if (io->flags & UBLK_IO_FLAG_AUTO_BUF_REG) {
>                         struct ublk_rq_data *data =3D blk_mq_rq_to_pdu(re=
q);
>
> -                       WARN_ON_ONCE(io_buffer_unregister_bvec(cmd,
> -                                               data->buf_index,
> -                                               issue_flags));
> +                       if (data->buf_ctx_id =3D=3D io_uring_cmd_ctx_hand=
le(cmd))
> +                               io_buffer_unregister_bvec(cmd, data->buf_=
index,
> +                                               issue_flags);
>                         io->flags &=3D ~UBLK_IO_FLAG_AUTO_BUF_REG;
>                 }
>
> diff --git a/include/uapi/linux/ublk_cmd.h b/include/uapi/linux/ublk_cmd.=
h
> index c4b9942697fc..5203963cd08a 100644
> --- a/include/uapi/linux/ublk_cmd.h
> +++ b/include/uapi/linux/ublk_cmd.h
> @@ -226,7 +226,11 @@
>   *
>   * For using this feature:
>   *
> - * - ublk server has to create sparse buffer table
> + * - ublk server has to create sparse buffer table on the same `io_ring_=
ctx`
> + *   for issuing `UBLK_IO_FETCH_REQ` and `UBLK_IO_COMMIT_AND_FETCH_REQ`.
> + *   If uring_cmd isn't issued on same `io_uring_ctx`, it is ublk server=
's

nit: "io_ring_ctx" here too

> + *   responsibility to unregister the buffer by issuing `IO_UNREGISTER_I=
O_BUF`
> + *   manually, otherwise this ublk request get stuck.

"get stuck" is a little vague. How about "won't complete"?

Other than that,

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

>   *
>   * - ublk server passes auto buf register data via uring_cmd's sqe->addr=
,
>   *   `struct ublk_auto_buf_reg` is populated from sqe->addr, please see
> --
> 2.47.0
>

