Return-Path: <io-uring+bounces-7764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F318A9FE6B
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 02:40:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3D5F03B86BE
	for <lists+io-uring@lfdr.de>; Tue, 29 Apr 2025 00:39:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EB403594D;
	Tue, 29 Apr 2025 00:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="JXVgH9wN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18182C148
	for <io-uring@vger.kernel.org>; Tue, 29 Apr 2025 00:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745886958; cv=none; b=Ww6PfxKA8IQFY3tCize57U8mSVXDTvw9kvfmVra1c1azCCUC1j7ZkYE8tEUBHC7WxxopjggBgNAeprB46tqpabtadhhIsvC9ylXTtkztaK8EmTO0+DF9mjPZCCyBUuGndbICnzzHwtvUm2uqlZWUlOWpCR2ZuLxfe8DOekrNK0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745886958; c=relaxed/simple;
	bh=hlriETKPywQ4lm2IhqDv+f82EvFNtjDLDktv35zbVuc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lNfdUwu/HPLywn6VvdBheqBWraA5VUQ9eq0CFoaayKfRrLobDqBCOSmXOuF/JzNjc5JcyH6AvXYKwHHpuUnXgGbbui9anZb5m0jebSc7eHRne/k5A4kKZHErcb6Jtf5eRTtCBGbwkqRJ4LCnVn+2b4u9aJEEH8ap/rQ+3Pk9o+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=JXVgH9wN; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-225887c7265so10153395ad.0
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 17:35:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1745886955; x=1746491755; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=98KuHYnzK9c+R84afF4mdg8GOTv61ec0x6FgtcFCdME=;
        b=JXVgH9wNYPR+75yFFMMmIN6Jcw5CTZJkVwF8wsHiVvby7sRI34G4s4S1J9YNdzPGU4
         nCPzZ31kIN0I742GkTc4BTSBA4NpZExDtm3hjz3DGXsuXiRvaOwocO+lwQozdB4YSA8R
         ZJhLsuPRMCGS9+aEqUWKrgdUP9ygqReFgwes8VUyC1WugOq9j1NvUBeK/ehSuhNITv3o
         CR1cPWkGZ912thWxJHIFe/2c4R4Zr+dBEaqulx+Y5ihvwaMtRPQrNQxmt3Kk0FhfMyU8
         gIz9NoynpqGV6mHLXbFt59EJgB9YNyMtQrwsLMvxm59RDArKccd12EcCdOd9f+SQ2Vpe
         H/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745886955; x=1746491755;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=98KuHYnzK9c+R84afF4mdg8GOTv61ec0x6FgtcFCdME=;
        b=qCP81Hro6t/RGiP5SLMp4DFF5ep9nsoPz9cv9gCU2nQxZWa8m5vt8am1+TxPywHh6/
         ptpkIuVdYFAba5HD55A+lVdU8223uipbXQEEg5umocYZ7e2VQsyI++OaKl4LMjVrh0EG
         H37VbW4Pv+pP8+yH6tOrRwtqRPOZetlqu0lUWeevOohZkRvMJAZ4Qe+Fu9MiIQQnY6Qr
         Dw2pkx4rIjr9foB4gxPVqFbZ6twreQwR8k8AF+BU7moiHv80nM7RPO53n3QkFyVkVhpX
         totkykQOueRNI3KeV4V6grbHnupI1eTaNzvHHI+3gDkV7f72C5HdYPs4ihlJRJE/6XZL
         k5BA==
X-Forwarded-Encrypted: i=1; AJvYcCUlmRpWQs7e0LaH1Gcf5CBoUahbYHEGZgBLLfMNBiGalvfAK0fmn2olZkqdDtIbggGQ8YOK01D6Gw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxM4IvlYumXNacHFuHFanDNb8DoGjxIuWdC7bIOu5ZVV7zHXBHL
	g6/xLSyE7KedD0S8MfnMAdNy1sv5y2OuARrlhwiplGoUN6vV6iQREnuCKYa6m72nFQHQcezQafi
	MfSOt3+IbH1gM6ARtHNZCgkKHgY4zA85sJnUv1g==
X-Gm-Gg: ASbGncthM409Bxfnyv/KJ44ag2da0o2XrZ0EsXGHdhJUcubsmujj0KdiszqNID3+k9b
	mA3WTXsn5er+8KJHQpqZtVpUqA2cf8GcZh18slS7rQCSuNFUPeG2LARwQSM1bq4gM+vlebmrT71
	XV2FQp7JuhfRftkG0B2HYf
X-Google-Smtp-Source: AGHT+IE0zhbGbXkP+UezYyD7+iDKNF3A9vz9+JWeoiQM6usw95Cjrt/4f5fxft8Vmy7HU7S+q5/UVwzxiIjEbjAXna8=
X-Received: by 2002:a17:902:da86:b0:223:f903:aa86 with SMTP id
 d9443c01a7336-22dbf5e4295mr76492125ad.1.1745886955171; Mon, 28 Apr 2025
 17:35:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428094420.1584420-1-ming.lei@redhat.com> <20250428094420.1584420-2-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-2-ming.lei@redhat.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 28 Apr 2025 17:35:43 -0700
X-Gm-Features: ATxdqUEsul8w5GLeahegQfAq6MozEhB6YKKCmEV8fupBE_uoZCMKbPy84s3L-K4
Message-ID: <CADUfDZoRWvVQjPAeGzaXZBYC83iAErBO4W_JLn7zB3h37iw-mw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/7] io_uring: add 'struct io_buf_data' for
 register/unregister bvec buffer
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-block@vger.kernel.org, 
	Uday Shankar <ushankar@purestorage.com>, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2025 at 2:44=E2=80=AFAM Ming Lei <ming.lei@redhat.com> wrot=
e:
>
> Add 'struct io_buf_data' for register/unregister bvec buffer, and
> prepare for supporting to register buffer into one specified io_uring
> context by its FD.
>
> No functional change.

I'm not a big fan of this change. Passing the arguments by reference
instead of in registers makes io_buffer_register_bvec() more expensive
to call. And it's a strange API for io_buffer_unregister_bvec() to
take a full struct io_buf_data but only use the index field.

Best,
Caleb


>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/block/ublk_drv.c     | 13 ++++++++++---
>  include/linux/io_uring/cmd.h | 11 ++++++++---
>  io_uring/rsrc.c              | 12 ++++++++----
>  3 files changed, 26 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 0d82014679f8..ac56482b55f5 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -1925,6 +1925,10 @@ static int ublk_register_io_buf(struct io_uring_cm=
d *cmd,
>  {
>         struct ublk_device *ub =3D cmd->file->private_data;
>         const struct ublk_io *io =3D &ubq->ios[tag];
> +       struct io_buf_data data =3D {
> +               .index =3D index,
> +               .release =3D ublk_io_release,
> +       };
>         struct request *req;
>         int ret;
>
> @@ -1938,8 +1942,8 @@ static int ublk_register_io_buf(struct io_uring_cmd=
 *cmd,
>         if (!req)
>                 return -EINVAL;
>
> -       ret =3D io_buffer_register_bvec(cmd, req, ublk_io_release, index,
> -                                     issue_flags);
> +       data.rq =3D req;
> +       ret =3D io_buffer_register_bvec(cmd, &data, issue_flags);
>         if (ret) {
>                 ublk_put_req_ref(ubq, req);
>                 return ret;
> @@ -1953,6 +1957,9 @@ static int ublk_unregister_io_buf(struct io_uring_c=
md *cmd,
>                                   unsigned int index, unsigned int issue_=
flags)
>  {
>         const struct ublk_io *io =3D &ubq->ios[tag];
> +       struct io_buf_data data =3D {
> +               .index =3D index,
> +       };
>
>         if (!ublk_support_zero_copy(ubq))
>                 return -EINVAL;
> @@ -1960,7 +1967,7 @@ static int ublk_unregister_io_buf(struct io_uring_c=
md *cmd,
>         if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
>                 return -EINVAL;
>
> -       return io_buffer_unregister_bvec(cmd, index, issue_flags);
> +       return io_buffer_unregister_bvec(cmd, &data, issue_flags);
>  }
>
>  static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_queue *ubq,
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 0634a3de1782..78fa336a284b 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -23,6 +23,12 @@ struct io_uring_cmd_data {
>         void                    *op_data;
>  };
>
> +struct io_buf_data {
> +       unsigned short index;
> +       struct request *rq;
> +       void (*release)(void *);
> +};
> +
>  static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sq=
e)
>  {
>         return sqe->cmd;
> @@ -140,10 +146,9 @@ static inline struct io_uring_cmd_data *io_uring_cmd=
_get_async_data(struct io_ur
>         return cmd_to_io_kiocb(cmd)->async_data;
>  }
>
> -int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq=
,
> -                           void (*release)(void *), unsigned int index,
> +int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct io_buf_data=
 *data,
>                             unsigned int issue_flags);
> -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int ind=
ex,
> +int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, struct io_buf_da=
ta *data,
>                               unsigned int issue_flags);
>
>  #endif /* _LINUX_IO_URING_CMD_H */
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index b4c5f3ee8855..66d2c11e2f46 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -918,12 +918,14 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
, void __user *arg,
>         return ret;
>  }
>
> -int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq=
,
> -                           void (*release)(void *), unsigned int index,
> +int io_buffer_register_bvec(struct io_uring_cmd *cmd,
> +                           struct io_buf_data *buf,
>                             unsigned int issue_flags)
>  {
>         struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
>         struct io_rsrc_data *data =3D &ctx->buf_table;
> +       unsigned int index =3D buf->index;
> +       struct request *rq =3D buf->rq;
>         struct req_iterator rq_iter;
>         struct io_mapped_ubuf *imu;
>         struct io_rsrc_node *node;
> @@ -963,7 +965,7 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd,=
 struct request *rq,
>         imu->folio_shift =3D PAGE_SHIFT;
>         imu->nr_bvecs =3D nr_bvecs;
>         refcount_set(&imu->refs, 1);
> -       imu->release =3D release;
> +       imu->release =3D buf->release;
>         imu->priv =3D rq;
>         imu->is_kbuf =3D true;
>         imu->dir =3D 1 << rq_data_dir(rq);
> @@ -980,11 +982,13 @@ int io_buffer_register_bvec(struct io_uring_cmd *cm=
d, struct request *rq,
>  }
>  EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
>
> -int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int ind=
ex,
> +int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
> +                             struct io_buf_data *buf,
>                               unsigned int issue_flags)
>  {
>         struct io_ring_ctx *ctx =3D cmd_to_io_kiocb(cmd)->ctx;
>         struct io_rsrc_data *data =3D &ctx->buf_table;
> +       unsigned index =3D buf->index;
>         struct io_rsrc_node *node;
>         int ret =3D 0;
>
> --
> 2.47.0
>

