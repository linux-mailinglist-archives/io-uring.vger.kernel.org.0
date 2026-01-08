Return-Path: <io-uring+bounces-11530-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 08360D05B64
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 20:03:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 48AB33007650
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 19:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31036301704;
	Thu,  8 Jan 2026 19:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JS4XXrRX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95E7D2FFF8E
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 19:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767898961; cv=pass; b=nNtpza7VRlqlvoGrZIkeSEYtASUIPvDU/ywerAkImX932ySG5lXeS0DwM75lQXUBmbacqM27x/EcGwKG+ruGdg9TsswQjjjYYNi3O7jPU2ZfVd1bgai+4+H8MQIa3WEF5T1i5chNG8vxZxDA0eG2C7aK42+yDUFhmOu62pzT0po=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767898961; c=relaxed/simple;
	bh=uTnlkJcTXfbxmoeXZPMMV0ilZuDMNeE7cbSS3em9Bms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eC4lDfb0bjArZrwXAauM/2kcQnOAU/Xa3BgY2GtFecweGS67fhuA6INJaFYd0PIJYQzh0Pxv5xahlSpNwqesK4aWLU+vM4kzfzvr+AagnVwRuBzI0/uENRTmNsdZrzoSEA3xerU4ohQxxj41qG/2fnEcX76iu+S75zoM58oZ3aw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JS4XXrRX; arc=pass smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2ac37f8898eso59123eec.0
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 11:02:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767898959; cv=none;
        d=google.com; s=arc-20240605;
        b=GzmZsqecj+FGLVSPUYYj+VAKWAGF9R3ze5gbvMiFT83cLPWjeotcV92+LigKeU+Gd3
         lytW04IP3Gl3MF4J/JsxLDrG/aOks8pOKEs/ZKe1oGexieoCuT9MvkTEzwoaqoLrOoHQ
         B9buPWbHbMl6sw+Iq++eC78G2s30TVpV9m+418ZKinwkgm9vecwpJUoj6EwAfFwoTf/9
         F8sp9Ssdqf6/iDlP04LgDADRd6jT7Vd6gBVDqSdT6dVwLiOF3r373FuFD7vqB2ZHMnKY
         TmfA3B2OSbSvR0AEJ0mbuMqYgH/xZgDYg4EMecbXvJK0SpbqBGGbx7d1bxf8I/0iFDY9
         xhgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7IyVFd6dArUXwo/V61zioGhyNew1+apjCmiH8MfjSwg=;
        fh=STi+Nc7jvsMM/tHxJgPdo/YCZyluWyp3x7OABUQRBcI=;
        b=UHK9u19zWcUgcbz14pqX6b/WHOMHOyboxf+YOAcNQfnzRKTtPwL9ZcMojFsOKh7KMi
         D4Hw+rdA/mdabvDV4+htnbLhNTxSOJ0BeG12UyFw+il8cj9driSZWGm5K0dQ4ui+84zF
         FEXRtiUw+okPCOFvjd/EMYDCloQZk5imYSkZv1178H5ngbwtJaz7fQqG1YZL4xmljzbO
         4vyVq1RZ/a//OsJ0XygBRAmY6On8cXjhGa5Bpu0iQ+P6ILY15fU3mlPW2gmOX0k0Fm+Y
         9oH167X027k5oh99Iu3EqF0JcA7+APZAsv2wMc0xrGVGhN8F34K+oJi2bURmz7hXZj/o
         GmBw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767898959; x=1768503759; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7IyVFd6dArUXwo/V61zioGhyNew1+apjCmiH8MfjSwg=;
        b=JS4XXrRXr9Ac0NEKAhCAEyfOIqG9qdE6E4C4ZU8ir7tV6CaMx1XX6Ve2lwNX+fVyjv
         xPjlHQ8fpsFbvcJzgy2xIOWyTaRfHFiYnbS1YbawNvie2O/yillbJuUKfVzcIQz5gWfb
         QGlk4FV00jFc64E+rPEZbqgy6lg6RCR/IEe5kgILD7pH5Yrgezb7L1qVLzyT6On2uH6S
         BQaghjswuXFmK1hvYj6D/jgVIRSM9E9LUpUPAtcb5cUQSyjVW/4043x0z7bx520KrhZq
         oyQnNKHKbkFVPSlutsbKVfNQ2qmJTy7jApTeb6ijbEUsHz3dmIisL82Ey97nAmA9Oayq
         aKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767898959; x=1768503759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7IyVFd6dArUXwo/V61zioGhyNew1+apjCmiH8MfjSwg=;
        b=nWGUc45JKu/1VlRgYjR5tXzDQKJIdufV8jXmiqRD8hiBmD0v9gAVTC2MX0B+P6YYcy
         IYLtejU88yXSYi4edF31KvgCvDvdffWPwbvKFXXU2xUGxmDJ7VOEtcWbkHAkKtr8Xacr
         3yPdP3WG+byQD3MyOF4xEx2BK+b+AOa3/sWzVdVhCCaFHuQxU7trduRkoIprbfmED+9Q
         QXXTByQKqHrnAzRDezbNGLWpv4KXVz4WOJmqQ6SK4ACTGnSnERWb1iTwq0X4733Q0GwL
         sMKTsY9317LsXfZxAV3o4JTyoxsoCMtUWJRxXe1DzQmRjg+q+HmlJlXMb8Rvt4hiP0eP
         hvAg==
X-Forwarded-Encrypted: i=1; AJvYcCVw8TuHHJZYlHtJBYwF12bKF+YeMr3BoM+KXLqMZxVBJqwEAr8soykIOapNe/jC8MkCtDIM+ovfYg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzgZer//IH7tS7g+NLH2sYenQfR+AI/xI8DUs4BNSH3vM/SASHI
	XvNBttsOtZ24c/FAHNczX0MkDvIF+Wx1qXZPpBGABxZ1gJYrwyDSkMPfQjpp+RBJMz6cpyhcFwh
	0Ejh+IQG0Q2sVpEkysbwtp3WXcaFXPTumfjUx0nDAHw==
X-Gm-Gg: AY/fxX7zX20GSnQV+I13AfgdpN5nn5OqyQc1Pg2JbfMrrHKopGnUqSx1rUD2WwKvLEZ
	drwuj+W73npTxcMwq64VncFr5wVjb07v36Er+vHxPi0gJbYGhg5MdzsI1KZ/NcXXojLu0PKryzU
	m4BBEsrTbKXZYs6alUTR8uFgKluMKIwB1re03MkduNvgCwErk5U8E6ZtvgajnYpUjsKmBqzr1JU
	Qpy9PNjLakx2VZ7UlP5d2Sez6PeCwpbH+a2bdbLnxpzkp3Q1ju3Q4tlhn1KFVk1pC5ifstv
X-Google-Smtp-Source: AGHT+IFi0zwOLqLd5/lph2wRASewlLfwejDQ39CW9qrkROJvcezR3Nocd3ITIblcrMsqrPYLJtoXFpAt4MfZkawIgMY=
X-Received: by 2002:a05:7022:b9e:b0:122:8d:39d8 with SMTP id
 a92af1059eb24-122008d3f76mr1267185c88.6.1767898958376; Thu, 08 Jan 2026
 11:02:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com> <20251223003522.3055912-9-joannelkoong@gmail.com>
In-Reply-To: <20251223003522.3055912-9-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 8 Jan 2026 11:02:26 -0800
X-Gm-Features: AQt7F2oEuvySb3d5I4mYqr14hwu_6_mSCZqy4snetF24vEzcoCm0AkgZQrSQoJA
Message-ID: <CADUfDZpdNNYdNnrPWviGYPViQ6O_S4S0hB7Hg56+wnQDgnXwAQ@mail.gmail.com>
Subject: Re: [PATCH v3 08/25] io_uring: add io_uring_cmd_fixed_index_get() and io_uring_cmd_fixed_index_put()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Add two new helpers, io_uring_cmd_fixed_index_get() and
> io_uring_cmd_fixed_index_put(). io_uring_cmd_fixed_index_get()
> constructs an iter for a fixed buffer at a given index and acquires a
> refcount on the underlying node. io_uring_cmd_fixed_index_put()
> decrements this refcount. The caller is responsible for ensuring
> io_uring_cmd_fixed_index_put() is properly called for releasing the
> refcount after it is done using the iter it obtained through
> io_uring_cmd_fixed_index_get().
>
> This is a preparatory patch needed for fuse-over-io-uring support, as
> the metadata for fuse requests will be stored at the last index, which
> will be different from the buf index set on the sqe.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/cmd.h | 20 +++++++++++
>  io_uring/rsrc.c              | 65 ++++++++++++++++++++++++++++++++++++
>  io_uring/rsrc.h              |  5 +++
>  io_uring/uring_cmd.c         | 21 ++++++++++++
>  4 files changed, 111 insertions(+)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 7169a2a9a744..2988592e045c 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -44,6 +44,12 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd =
*ioucmd,
>                                   size_t uvec_segs,
>                                   int ddir, struct iov_iter *iter,
>                                   unsigned issue_flags);
> +int io_uring_cmd_fixed_index_get(struct io_uring_cmd *ioucmd, u16 buf_in=
dex,
> +                                unsigned int off, size_t len, int ddir,
> +                                struct iov_iter *iter,
> +                                unsigned int issue_flags);
> +int io_uring_cmd_fixed_index_put(struct io_uring_cmd *ioucmd, u16 buf_in=
dex,
> +                                unsigned int issue_flags);
>
>  /*
>   * Completes the request, i.e. posts an io_uring CQE and deallocates @io=
ucmd
> @@ -109,6 +115,20 @@ static inline int io_uring_cmd_import_fixed_vec(stru=
ct io_uring_cmd *ioucmd,
>  {
>         return -EOPNOTSUPP;
>  }
> +static inline int io_uring_cmd_fixed_index_get(struct io_uring_cmd *iouc=
md,
> +                                              u16 buf_index, unsigned in=
t off,
> +                                              size_t len, int ddir,
> +                                              struct iov_iter *iter,
> +                                              unsigned int issue_flags)
> +{
> +       return -EOPNOTSUPP;
> +}
> +static inline int io_uring_cmd_fixed_index_put(struct io_uring_cmd *iouc=
md,
> +                                              u16 buf_index,
> +                                              unsigned int issue_flags)
> +{
> +       return -EOPNOTSUPP;
> +}
>  static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret=
,
>                 u64 ret2, unsigned issue_flags, bool is_cqe32)
>  {
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index a63474b331bf..a141aaeb099d 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1151,6 +1151,71 @@ int io_import_reg_buf(struct io_kiocb *req, struct=
 iov_iter *iter,
>         return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
>  }
>
> +int io_reg_buf_index_get(struct io_kiocb *req, struct iov_iter *iter,
> +                        u16 buf_index, unsigned int off, size_t len,
> +                        int ddir, unsigned issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D req->ctx;
> +       struct io_rsrc_node *node;
> +       struct io_mapped_ubuf *imu;
> +       u64 addr;
> +       int err;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       node =3D io_rsrc_node_lookup(&ctx->buf_table, buf_index);
> +       if (!node) {
> +               io_ring_submit_unlock(ctx, issue_flags);
> +               return -EINVAL;
> +       }
> +
> +       node->refs++;
> +
> +       io_ring_submit_unlock(ctx, issue_flags);
> +
> +       imu =3D node->buf;
> +       if (!imu) {
> +               err =3D -EFAULT;
> +               goto error;
> +       }
> +
> +       if (check_add_overflow(imu->ubuf, off, &addr)) {
> +               err =3D -EINVAL;
> +               goto error;
> +       }
> +
> +       err =3D io_import_fixed(ddir, iter, imu, addr, len);
> +       if (err)
> +               goto error;
> +
> +       return 0;
> +
> +error:
> +       io_reg_buf_index_put(req, buf_index, issue_flags);
> +       return err;
> +}
> +
> +int io_reg_buf_index_put(struct io_kiocb *req, u16 buf_index,
> +                        unsigned issue_flags)
> +{
> +       struct io_ring_ctx *ctx =3D req->ctx;
> +       struct io_rsrc_node *node;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       node =3D io_rsrc_node_lookup(&ctx->buf_table, buf_index);

Hmm, I don't think it's safe to assume this node looked up by
buf_index matches the one obtained in io_reg_buf_index_get(). Since
the uring_lock is released between io_reg_buf_index_get() and
io_reg_buf_index_put(), an intervening IORING_REGISTER_BUFFERS_UPDATE
operation may modify the node at buf_index in the buf_table. That
could result in a reference decrement on the wrong node, resulting in
the new node being freed while still in use.
Can we return the struct io_rsrc_node * from io_reg_buf_index_get()
and pass it to io_reg_buf_index_put() in place of buf_index?

Thanks,
Caleb

> +       if (WARN_ON_ONCE(!node)) {
> +               io_ring_submit_unlock(ctx, issue_flags);
> +               return -EFAULT;
> +       }
> +
> +       io_put_rsrc_node(ctx, node);
> +
> +       io_ring_submit_unlock(ctx, issue_flags);
> +
> +       return 0;
> +}
> +
>  /* Lock two rings at once. The rings must be different! */
>  static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx =
*ctx2)
>  {
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index d603f6a47f5e..16f4bab9582b 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -64,6 +64,11 @@ struct io_rsrc_node *io_find_buf_node(struct io_kiocb =
*req,
>  int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
>                         u64 buf_addr, size_t len, int ddir,
>                         unsigned issue_flags);
> +int io_reg_buf_index_get(struct io_kiocb *req, struct iov_iter *iter,
> +                        u16 buf_index, unsigned int off, size_t len,
> +                        int ddir, unsigned issue_flags);
> +int io_reg_buf_index_put(struct io_kiocb *req, u16 buf_index,
> +                        unsigned issue_flags);
>  int io_import_reg_vec(int ddir, struct iov_iter *iter,
>                         struct io_kiocb *req, struct iou_vec *vec,
>                         unsigned nr_iovs, unsigned issue_flags);
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index b6b675010bfd..ee95d1102505 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -314,6 +314,27 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cm=
d *ioucmd,
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
>
> +int io_uring_cmd_fixed_index_get(struct io_uring_cmd *ioucmd, u16 buf_in=
dex,
> +                                unsigned int off, size_t len, int ddir,
> +                                struct iov_iter *iter,
> +                                unsigned int issue_flags)
> +{
> +       struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> +
> +       return io_reg_buf_index_get(req, iter, buf_index, off, len, ddir,
> +                                   issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_fixed_index_get);
> +
> +int io_uring_cmd_fixed_index_put(struct io_uring_cmd *ioucmd, u16 buf_in=
dex,
> +                                unsigned int issue_flags)
> +{
> +       struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> +
> +       return io_reg_buf_index_put(req, buf_index, issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_uring_cmd_fixed_index_put);
> +
>  void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
>  {
>         struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> --
> 2.47.3
>

