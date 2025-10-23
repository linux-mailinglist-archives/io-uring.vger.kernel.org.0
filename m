Return-Path: <io-uring+bounces-10151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 86ACCBFEFB8
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 05:17:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8D0364E2680
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 03:17:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BBD035B149;
	Thu, 23 Oct 2025 03:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="XzYsMEYl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926F91A267
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 03:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761189435; cv=none; b=cVICeRi4Cng1ubcHnwFu2k/Z+1asLKae3jLPFpxV0x5B6zLf95AuSCVcGQPFu0uFC0KmbUfB+4t17Uf9L0yoX9T0yJOnCvfsf/CZ1OQEfSBZh97nzQyyCyIgcS4KZycDMguqAlwChhRiTMnShjqWM5JYFkGnlzQ3CvL/AJNShfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761189435; c=relaxed/simple;
	bh=iOXht9vrOqUArHzYFYQePWrdvzIabF6CulOPl8EPWJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S77CoenYS77XFrpyiLLg58/8kPp16bOKlqmCLgUmWkzaaJsUthWy030ask80U6rOtRFVsR9P5bCICcdt2fDeVwjh6zyBtjjNphtd6558yc4z/q2wli09HyuhMMw/W5pib1ykShHuzi4s0/EBUP+X5PyLluPusQGq8UY+5Qc7vBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=XzYsMEYl; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-290af0e154fso456655ad.3
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 20:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761189431; x=1761794231; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EsQKop5qY8J1CPJSUCMvyRajEHIdK46Cg/9v4FNyufE=;
        b=XzYsMEYlphtOlsXRFf6CO2yexDq9vJs1i57UuGxxfT2ddmD88tyJdAGvmYuPfknJIl
         sW3Kl2OOGrdRafkAa0ZboVYyTJ0sygMQbCNwGBtpdkUzzF+eMMrR6igkydwCg41aoFs8
         FuGbMFyDcWR5XpvzLZH7uUt86WKgCB0Ot9/X0wQNSJ+ChYZEHEWR7r+QZypF6r5gag49
         IiQYVVu70isQwxtIrgTO/qIlFpJYRv+nA3w+659GnKr4epoWinoOrjPqy6a3cFhNX8/m
         O+xINaatseqmZ/u+7bGVTd3nSmufsksogRpv3c9wjzoAXpFDU7TBneFOPzVyJvZu74Hp
         UXXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761189431; x=1761794231;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EsQKop5qY8J1CPJSUCMvyRajEHIdK46Cg/9v4FNyufE=;
        b=C/OUiMi+ppedDHRgIEaAnQjpD1jI0TQ2H7vs20pgjod66f67wSSCjvulepyzE/fbQZ
         PMSvmNEnP7WQjebdJRIpDP7CZI2n0zsfoxFzm7Rpj4PvqeTUcKH4A8Cpllr0xfVnAeEs
         mJE2TfNZL1uPTfAYM7VVEV4HwWDySLmVodtvJdR6fqfRTi4Z375z5g/yzuVIibNZXnT5
         JIISLNaJEwwVVwErVrnBG6V9NdYpywhCPIPA3KcgDdqnk1guJ15LcqqX3PYFnFPRIbXe
         pfEiHX1yJRWzm8hfrPoX2KxjCf9q+V/Bv2XkJrhx8qdcubi0za38GZNTx8w2vQpCv4Ht
         Y9Qw==
X-Forwarded-Encrypted: i=1; AJvYcCWAEXHhcrny+yBUZUCxUL8sU8nNGF77k1/TNgY+9eFxSe8EuYFug7r8wmntnVU337nIG+9CPiY+Qg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyxyTNDmwpfkLxZ5V/O5ArlRHbTQp1PgTUlF9plHnzavBmvY14B
	+Bb5ejB+HXh484aDDiXq2epCEAXt9UatSagzjVAhsWGUVao5lxGQIEY39pJjgpzp8D/9ietbVXf
	KqWsH2G9OJP/OKR6v0tyZNY4jkxA+iUZmpi6g9zxQAQ==
X-Gm-Gg: ASbGncuGO8Ea2zri99Us/mf9XVHbRbAwP+VEmT6+79Q8FkXihkosvNcnLbyP6Cbqq34
	LvZnYSUhfuxmLeBHS0pMFYD6rkmsETUqDfOQjPCMjEj+3t0OzEBfk1FnyI+8MHBhJV7ecQ5BLkq
	NvVpWhJYcaLtFwBOgmQVLNk3xGCj1T0h8KF2QYvW/EzFMTwniXK/CsbMDihWfq78uJsM7YrMypW
	q3Tp4UVvh05bR366h2mpJxmijzhzmzob9i+hY06x44QwM2ez4UaCnI5e2zejGEMNe5wFyvsSkJq
	hF0Q+BXwZ9XC1+UpUQ==
X-Google-Smtp-Source: AGHT+IF2gr3tjOA3w9b81IEdkti0qDz4SfOy+px6OWbFNwx5WuFkZ5mmJ80dGJ7Bisfb2N5IIMQQ6bJEoIVubhYB4Ak=
X-Received: by 2002:a17:902:fc85:b0:290:af0d:9381 with SMTP id
 d9443c01a7336-292d3facdd0mr63010925ad.7.1761189430734; Wed, 22 Oct 2025
 20:17:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251022202021.3649586-1-joannelkoong@gmail.com> <20251022202021.3649586-2-joannelkoong@gmail.com>
In-Reply-To: <20251022202021.3649586-2-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 22 Oct 2025 20:16:58 -0700
X-Gm-Features: AS18NWBh4u1l8Qi-V8ty85RFAm-ErpQlPDvQ8UmqI6Xjl_gqZb0DRiqRRfOiLVY
Message-ID: <CADUfDZoeyDg2F1aSOTqg_7wANxH_LUuSGjiA5=-Auf5TDdj8AQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] io-uring: add io_uring_cmd_get_buffer_info()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	xiaobing.li@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2025 at 1:23=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Add io_uring_cmd_get_buffer_info() to fetch buffer information that will
> be necessary for constructing an iov iter for it.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/cmd.h |  2 ++
>  io_uring/rsrc.c              | 21 +++++++++++++++++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 7509025b4071..a92e810f37f9 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -177,4 +177,6 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd,=
 struct request *rq,
>  int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int ind=
ex,
>                               unsigned int issue_flags);
>
> +int io_uring_cmd_get_buffer_info(struct io_uring_cmd *cmd, u64 *ubuf,
> +                                unsigned int *len);
>  #endif /* _LINUX_IO_URING_CMD_H */
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index d787c16dc1c3..8554cdad8abc 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1569,3 +1569,24 @@ int io_prep_reg_iovec(struct io_kiocb *req, struct=
 iou_vec *iv,
>         req->flags |=3D REQ_F_IMPORT_BUFFER;
>         return 0;
>  }
> +
> +int io_uring_cmd_get_buffer_info(struct io_uring_cmd *cmd, u64 *ubuf,
> +                                unsigned int *len)
> +{
> +       struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
> +       struct io_rsrc_data *data =3D &ctx->buf_table;
> +       struct io_mapped_ubuf *imu;
> +       unsigned int buf_index;
> +
> +       if (!data->nr)
> +               return -EINVAL;
> +
> +       buf_index =3D cmd->sqe->buf_index;

This is reading userspace-mapped memory, it should use READ_ONCE().
But why not just use cmd_to_io_kiocb(cmd)->buf_index? That's already
sampled from the SQE in io_uring_cmd_prep() if the
IORING_URING_CMD_FIXED flag is set. And it seems like the fuse
uring_cmd implementation requires that flag to be set.

> +       imu =3D data->nodes[buf_index]->buf;

Needs a bounds check?

> +
> +       *ubuf =3D imu->ubuf;
> +       *len =3D imu->len;

This wouldn't be valid for kernel registered buffers (those registered
with io_buffer_register_bvec()). Either reject those or return a more
general representation of the registered buffer memory (e.g. an
iterator)?

Best,
Caleb

> +
> +       return 0;
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_get_buffer_info);
> --
> 2.47.3
>
>

