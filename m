Return-Path: <io-uring+bounces-10939-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 42842CA1B49
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 22:44:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBB8D300A1C2
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 21:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86AED2D836D;
	Wed,  3 Dec 2025 21:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="RyXLNLdC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A3F2D8DC2
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 21:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764798251; cv=none; b=RXEnaWf48sZJn4PWfHBQ8salOl/qG7W8Yps+SXJVWx/izkNP7f/qfuRAOVcuxO+pQeCVLpvtPuQ+TafQk7lKwPWdcOQQPe34JtyxF5eA0/lIxvJ83HTeweadPxEORYGH9PaLQcC2BZgAuqEoEwJ16DPImbDFYySG0Co1YqkQeyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764798251; c=relaxed/simple;
	bh=78WDTHPziqgIAar/wHrHN1w3bbfBF3IBRQ79sIJ/AXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jZYAaXhE386RUIj8sAQy+pRdWz9rdYNyzlcngW6d4ocPX6WpTy3rav3C77Xd4sXYQqUujzrLQviBHYeSIhLwDpKmi2fB+mi1Ab5NKM5urxiSbjSLe32zIGzduiHO2dl362fZlbwmNost0XQDr6aWpd0xHGEoQRMsDYHE6VQyY0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=RyXLNLdC; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7ba92341f07so27665b3a.1
        for <io-uring@vger.kernel.org>; Wed, 03 Dec 2025 13:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764798246; x=1765403046; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSQ2B+EvgOAZgpUFpH97jmB2MRKv2wrPc2kdi9xRuF0=;
        b=RyXLNLdCEnsMlg+UgjXT2bKsH+8VrmcnsQuTosnMjVmtBqgJix/9ixE8R5Z/lXvfP/
         5rpGxjqW1An0svUIl2eaMIMDWQ6wxKit65iIb+JiHD9D7Rs+9PpcZLhd2OgM/6KEqPxN
         20VZX4KY5/4/tCiy7+u5h8mSmsm3GE3h/ZvPi0LU5f3cR3Qhs41qrm94QUK/N+/SpVjO
         wTDv/3n7z+MXpb0jRdEhFRO/+PbNSuaAXs8YW0prlogsjwshxUZ6GXC6i4u36VupRr+E
         JBufIm/mIL2KZsYj+BZ1Em/gafepNjaX95FTYeeQfCk+RWNi7Km3jW6YrQxJjunyB8MX
         8OFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764798246; x=1765403046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jSQ2B+EvgOAZgpUFpH97jmB2MRKv2wrPc2kdi9xRuF0=;
        b=o6zV2VmvXEyhvFR5Lj+4wDLoubp7/rU0DhfSyfzw0ia+hS64jFTnW+mhfcWwhFRlSZ
         AY3I2jelLnv3KMEG066I8hCmAzHoiioPueNrG3agLIebBm+7uzKFY9Wgje9y1CqM0CaU
         fn4iPkAb+zI2mF6xh85RafXUg+q9tStOO/wZvPw3NBOrLd0fjZWNacG/NKJ6qwX6GS48
         qy7inaT9m3Qv582DX8cSNmk/5RD3rk9Z4/9loPOIm5uB1dt4Lj7BfCXd+AgfAZB6sHa7
         49ckcV6l6+vS8M9ZiIdFiUZEYAuCZgtFnEDjIfpo88xqFfGR2Dpe6oiKuXU6rydWn12D
         l7sw==
X-Forwarded-Encrypted: i=1; AJvYcCX+ZXDFTzX75K1sz8ENfKF7oljSezljgH34/2s99a5mxz9JUlu3PwaDWZxI/KNb2yS334ZqbakAYw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwGJ2QsE7l2SdL/UmMTLRSejVuzc+ekmyGlou7AurdBTmFd0qrc
	bDb/7ouyTbV2Ur+Ut2/jprvmAc8ALVIOMfHxWd75GGd7n0i2JuHfmmGdPLX/9ezgE7IN/pQOGuJ
	0E/4SJrtDAbGQWZCgHo2O4XNI+n2ahs1udW8i4HUoNg==
X-Gm-Gg: ASbGncs6RUtQaFUwrAjxBTtY07jLKZKUsn3Lv9LrbXgaqjIuvvgdFWU4w7ynOxiDox2
	446aQHdvVKtK5ImlYT7R1MUQfDQJLOCoShrirFe3mMdkvqtANp1Y2fbfG3lwRCsgvtOCNB/56MI
	1DnSNdYvzi3XkOtb1wwp/L3onpsHGmCe7/yDVQQ+gqNXBvoJYdRFHJy+ulLegK4MkTHaP+Yh+hf
	jjsTjY6XvycR04U3zIli28vh4BvA9FZNuujQ4EQElDfNZ6s+2syVwRaJcB2eRIb96FNRtvB
X-Google-Smtp-Source: AGHT+IE20CYyGAR5v0h/yQFIdx4Qx3ZP/MUwY9b4OGw/7t2vSH7pKBOaWaDIZLGDaP+QFHr/pNQt3wMx1YD2wCTs8Yo=
X-Received: by 2002:a05:7022:60e:b0:119:e55a:95a0 with SMTP id
 a92af1059eb24-11df253961amr2193775c88.2.1764798246052; Wed, 03 Dec 2025
 13:44:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com> <20251203003526.2889477-10-joannelkoong@gmail.com>
In-Reply-To: <20251203003526.2889477-10-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 3 Dec 2025 13:43:54 -0800
X-Gm-Features: AWmQ_bnsHZMq_qwEDoEGIyPnjyE0jifVT3RWQd1upIX0Hm5uLcNgqmdyo6aqb-0
Message-ID: <CADUfDZoUMRu=t3ELJ6yGt2FbcgW=WzHa_=xc4BNtEmPpA67VHw@mail.gmail.com>
Subject: Re: [PATCH v1 09/30] io_uring: add io_uring_cmd_import_fixed_index()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> Add a new helper, io_uring_cmd_import_fixed_index(). This takes in a
> buffer index. This requires the buffer table to have been pinned
> beforehand. The caller is responsible for ensuring it does not use the
> returned iter after the buffer table has been unpinned.
>
> This is a preparatory patch needed for fuse-over-io-uring support, as
> the metadata for fuse requests will be stored at the last index, which
> will be different from the sqe's buffer index.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/cmd.h | 10 ++++++++++
>  io_uring/rsrc.c              | 31 +++++++++++++++++++++++++++++++
>  io_uring/rsrc.h              |  2 ++
>  io_uring/uring_cmd.c         | 11 +++++++++++
>  4 files changed, 54 insertions(+)
>
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 375fd048c4cb..a4b5eae2e5d1 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -44,6 +44,9 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *=
ioucmd,
>                                   size_t uvec_segs,
>                                   int ddir, struct iov_iter *iter,
>                                   unsigned issue_flags);
> +int io_uring_cmd_import_fixed_index(struct io_uring_cmd *ioucmd, u16 buf=
_index,
> +                                   int ddir, struct iov_iter *iter,
> +                                   unsigned int issue_flags);
>
>  /*
>   * Completes the request, i.e. posts an io_uring CQE and deallocates @io=
ucmd
> @@ -100,6 +103,13 @@ static inline int io_uring_cmd_import_fixed_vec(stru=
ct io_uring_cmd *ioucmd,
>  {
>         return -EOPNOTSUPP;
>  }
> +static inline int io_uring_cmd_import_fixed_index(struct io_uring_cmd *i=
oucmd,
> +                                                 u16 buf_index, int ddir=
,
> +                                                 struct iov_iter *iter,
> +                                                 unsigned int issue_flag=
s)
> +{
> +       return -EOPNOTSUPP;
> +}
>  static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret=
,
>                 u64 ret2, unsigned issue_flags, bool is_cqe32)
>  {
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 67331cae0a5a..b6dd62118311 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -1156,6 +1156,37 @@ int io_import_reg_buf(struct io_kiocb *req, struct=
 iov_iter *iter,
>         return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
>  }
>
> +int io_import_reg_buf_index(struct io_kiocb *req, struct iov_iter *iter,
> +                           u16 buf_index, int ddir, unsigned issue_flags=
)
> +{
> +       struct io_ring_ctx *ctx =3D req->ctx;
> +       struct io_rsrc_node *node;
> +       struct io_mapped_ubuf *imu;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       if (buf_index >=3D req->ctx->buf_table.nr ||

This condition is already checked in io_rsrc_node_lookup() below.

> +           !(ctx->buf_table.flags & IO_RSRC_DATA_PINNED)) {
> +               io_ring_submit_unlock(ctx, issue_flags);
> +               return -EINVAL;
> +       }
> +
> +       /*
> +        * We don't have to grab the reference on the node because the bu=
ffer
> +        * table is pinned. The caller is responsible for ensuring the it=
er
> +        * isn't used after the buffer table has been unpinned.
> +        */
> +       node =3D io_rsrc_node_lookup(&ctx->buf_table, buf_index);
> +       io_ring_submit_unlock(ctx, issue_flags);
> +
> +       if (!node || !node->buf)
> +               return -EFAULT;
> +
> +       imu =3D node->buf;
> +
> +       return io_import_fixed(ddir, iter, imu, imu->ubuf, imu->len);
> +}
> +
>  /* Lock two rings at once. The rings must be different! */
>  static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx =
*ctx2)
>  {
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index d603f6a47f5e..658934f4d3ff 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -64,6 +64,8 @@ struct io_rsrc_node *io_find_buf_node(struct io_kiocb *=
req,
>  int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
>                         u64 buf_addr, size_t len, int ddir,
>                         unsigned issue_flags);
> +int io_import_reg_buf_index(struct io_kiocb *req, struct iov_iter *iter,
> +                           u16 buf_index, int ddir, unsigned issue_flags=
);
>  int io_import_reg_vec(int ddir, struct iov_iter *iter,
>                         struct io_kiocb *req, struct iou_vec *vec,
>                         unsigned nr_iovs, unsigned issue_flags);
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 197474911f04..e077eba00efe 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -314,6 +314,17 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cm=
d *ioucmd,
>  }
>  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
>
> +int io_uring_cmd_import_fixed_index(struct io_uring_cmd *ioucmd, u16 buf=
_index,
> +                                   int ddir, struct iov_iter *iter,
> +                                   unsigned int issue_flags)
> +{
> +       struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> +
> +       return io_import_reg_buf_index(req, iter, buf_index, ddir,
> +                                      issue_flags);
> +}

Probably would make sense to make this an inline function, since it
immediately defers to io_import_reg_buf_index().

Best,
Caleb

> +EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_index);
> +
>  void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
>  {
>         struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> --
> 2.47.3
>

