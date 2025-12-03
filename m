Return-Path: <io-uring+bounces-10928-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 78429C9DC21
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 05:50:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD04A3A94FA
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 04:49:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99B831DE8AE;
	Wed,  3 Dec 2025 04:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZWHAzD1v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2864275111
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 04:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764737386; cv=none; b=sPNxU4xLZd5VltzllpCVVdiJWAz1NLtbOhPnKpl8L9bl5i6qBm9YjF1lX68boaQR/r7T3EmlJRwonEDUdjajq9+vtA52wRx/n/sxzAGLa5OGWZP7n012gv69UJHMAZYSeiQOPVyztdHxRCw4VcTsHnatriso16c6YwnGN6OJMm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764737386; c=relaxed/simple;
	bh=CtLMzO+EkIiDxmWvm4zrn7QDaX3JlLSeuGs+TDR8kIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eX9otXXW6KXOs+VxBmylK7+5duqcYK88Bp4hDrqDX+TV8zxiig5PSDfroYUMQZ1sdq93fvk5A4FRRsO07PboZ5yn7AYMM+wH7xWycndK7J3v77TNJ+r4A0xvGDsjWuOKXN1hvD4Zk3YztTf05y+5zM8r/X1mH6JPVM9OAlSZtPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZWHAzD1v; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7bb2fa942daso809578b3a.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 20:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764737384; x=1765342184; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JHkvJWNiDtqjeNJ3/XWKxN+DZ0F0cDp+uzwu4MUCaz4=;
        b=ZWHAzD1vQT46rR5Tq48yJmOFH3k8U3gPiF69d6t+ELnafKAlKDr9wNYrGnMhhmE0QB
         cNkCV4KqNDTsEzot3pC+2nJkTo7KUW4AUb3T78VD4p/3kA3y7j/hw751aTspIi7FqB4q
         Rqh6GHsQp+LMsmZF6QvuyY4i9wnW/F6YpOIDL1+wazTDebCOQ2D1znhQJbyggyDbCrCi
         7ZKOLNIG/b99/7K5BmMRclO48WKfJvJ20DUgfJCLmxdzJS1iyL3rrblySGS3zI8+PhLH
         ZjnvR0zubKPgloqJ6K3BFe2Kk4nL8VvRiNA5LRxD+h71Byem4lmIhXDr5REFMLvTzxU3
         5tEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764737384; x=1765342184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JHkvJWNiDtqjeNJ3/XWKxN+DZ0F0cDp+uzwu4MUCaz4=;
        b=uHoHd0RouXvQ6xAhlHv3c09V0ZmcqoyKG2o9MW84zbKanhe0QPWB4AeVjBbC+po53r
         a1slCPy2lyGFLALFCbQ//rSyWRsBJKmxFhU33LzhNcAs1/zSXHdpXvzmjrASNTwBFjFL
         Z/HMt8JopTC705IefZcrqMso6dpr4PD3DYm6V7RsNza2zdAwdlacP5auIDwjps720O65
         xPv25zEHVQtwh9f8nZmRa4pEDdIyaCWsqGNILuLmeenvas/ctx3+f85OLrxUiKPQrkpD
         7bZW+8k7R7Sz7ErSOb4NuF6cXj97M+gxtmMOcF51VrLuCtrd34l2RA7KjSDjfAn/8bmL
         ysrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUB9IUFb3ZDph+Y+Za7znMxbh6bRtR3EpVAPvan2RI3Dx1kV3Rl9Wx9PrtXFI/ML0XTGziuozjHwA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVQcSWJHOcz7q9YJUs7szqpiK2VuLCKO8f6/5lTBNPgj41Vhyx
	Op2Ky6tKbKridsBFxz+8DkEFAcxdGjAI6w3Y7ktsTOjjvYyc01OWdnkvKRIFxvefmp3OogVN7JG
	Adtt8BgoGWIooFPNyW11fjaplyXbgEfxbKPFDl0mzhA==
X-Gm-Gg: ASbGncs8u9axybDhNgQ+PJW07hKAEy7YZAIgtMfLhKiR8szLxU8yfo8Iv/GlRekL774
	29DNm7LguHNJtf55jnGSeC+jJ5g0q/60X8f4KRbOimbbezlGgLocMho/aH7TSqWRVcw0mpZhjnE
	xy6sTBcatzk5bXRHhmt+8fbCFAlAgDn9D1SFhSuRppLUktuJD9wLnya1mrlKstZJvipZcoAkO6A
	4+l80gOKnPCHxY88YABrhTWfFBeoqxUqNcexuJe42Eq/nAWjhU9DpBYIzCG2tbpfqORieOjQEwY
	K6Q0FxM=
X-Google-Smtp-Source: AGHT+IHSCCXVwcGWdcuTfOa+Rg9oh0WRs3Q67G1HVUduLRzeb9VcfO1tAQ8FrL7M2SaNH+c1wLRLp/skKBn1L6ybBTE=
X-Received: by 2002:a05:7022:41a6:b0:11b:ad6a:6e39 with SMTP id
 a92af1059eb24-11df0cf5ba4mr753384c88.5.1764737383828; Tue, 02 Dec 2025
 20:49:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com> <20251203003526.2889477-8-joannelkoong@gmail.com>
In-Reply-To: <20251203003526.2889477-8-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 2 Dec 2025 20:49:32 -0800
X-Gm-Features: AWmQ_bmWfayZBqik_nzKNaGHp6KRhV1hQNLbLfmY456BtQ9TBNyUXTNnHHIKlhI
Message-ID: <CADUfDZosVLf4vGm4_kNFReaNH3wSi2RoLXwZBc6TN0Jw__s1OQ@mail.gmail.com>
Subject: Re: [PATCH v1 07/30] io_uring/rsrc: add fixed buffer table pinning/unpinning
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> Add kernel APIs to pin and unpin the buffer table for fixed buffers,
> preventing userspace from unregistering or updating the fixed buffers
> table while it is pinned by the kernel.
>
> This has two advantages:
> a) Eliminating the overhead of having to fetch and construct an iter for
> a fixed buffer per every cmd. Instead, the caller can pin the buffer
> table, fetch/construct the iter once, and use that across cmds for
> however long it needs to until it is ready to unpin the buffer table.
>
> b) Allowing a fixed buffer lookup at any index. The buffer table must be
> pinned in order to allow this, otherwise we would have to keep track of
> all the nodes that have been looked up by the io_kiocb so that we can
> properly adjust the refcounts for those nodes. Ensuring that the buffer
> table must first be pinned before being able to fetch a buffer at any
> index makes things logistically a lot neater.

Why is it necessary to pin the entire buffer table rather than
specific entries? That's the purpose of the existing io_rsrc_node refs
field.

>
> This is a preparatory patch for fuse io-uring's usage of fixed buffers.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  include/linux/io_uring/buf.h   | 13 +++++++++++
>  include/linux/io_uring_types.h |  9 ++++++++
>  io_uring/rsrc.c                | 42 ++++++++++++++++++++++++++++++++++
>  3 files changed, 64 insertions(+)
>
> diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
> index 7a1cf197434d..c997c01c24c4 100644
> --- a/include/linux/io_uring/buf.h
> +++ b/include/linux/io_uring/buf.h
> @@ -9,6 +9,9 @@ int io_uring_buf_ring_pin(struct io_ring_ctx *ctx, unsign=
ed buf_group,
>                           unsigned issue_flags, struct io_buffer_list **b=
l);
>  int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx, unsigned buf_group,
>                             unsigned issue_flags);
> +
> +int io_uring_buf_table_pin(struct io_ring_ctx *ctx, unsigned issue_flags=
);
> +int io_uring_buf_table_unpin(struct io_ring_ctx *ctx, unsigned issue_fla=
gs);
>  #else
>  static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
>                                         unsigned buf_group,
> @@ -23,6 +26,16 @@ static inline int io_uring_buf_ring_unpin(struct io_ri=
ng_ctx *ctx,
>  {
>         return -EOPNOTSUPP;
>  }
> +static inline int io_uring_buf_table_pin(struct io_ring_ctx *ctx,
> +                                        unsigned issue_flags)
> +{
> +       return -EOPNOTSUPP;
> +}
> +static inline int io_uring_buf_table_unpin(struct io_ring_ctx *ctx,
> +                                          unsigned issue_flags)
> +{
> +       return -EOPNOTSUPP;
> +}
>  #endif /* CONFIG_IO_URING */
>
>  #endif /* _LINUX_IO_URING_BUF_H */
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 36fac08db636..e1a75cfe57d9 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -57,8 +57,17 @@ struct io_wq_work {
>         int cancel_seq;
>  };
>
> +/*
> + * struct io_rsrc_data flag values:
> + *
> + * IO_RSRC_DATA_PINNED: data is pinned and cannot be unregistered by use=
rspace
> + * until it has been unpinned. Currently this is only possible on buffer=
 tables.
> + */
> +#define IO_RSRC_DATA_PINNED            BIT(0)
> +
>  struct io_rsrc_data {
>         unsigned int                    nr;
> +       u8                              flags;
>         struct io_rsrc_node             **nodes;
>  };
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 3765a50329a8..67331cae0a5a 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -9,6 +9,7 @@
>  #include <linux/hugetlb.h>
>  #include <linux/compat.h>
>  #include <linux/io_uring.h>
> +#include <linux/io_uring/buf.h>
>  #include <linux/io_uring/cmd.h>
>
>  #include <uapi/linux/io_uring.h>
> @@ -304,6 +305,8 @@ static int __io_sqe_buffers_update(struct io_ring_ctx=
 *ctx,
>                 return -ENXIO;
>         if (up->offset + nr_args > ctx->buf_table.nr)
>                 return -EINVAL;
> +       if (ctx->buf_table.flags & IO_RSRC_DATA_PINNED)
> +               return -EBUSY;

IORING_REGISTER_CLONE_BUFFERS can also be used to unregister existing
buffers, so it may need the check too?

>
>         for (done =3D 0; done < nr_args; done++) {
>                 struct io_rsrc_node *node;
> @@ -615,6 +618,8 @@ int io_sqe_buffers_unregister(struct io_ring_ctx *ctx=
)
>  {
>         if (!ctx->buf_table.nr)
>                 return -ENXIO;
> +       if (ctx->buf_table.flags & IO_RSRC_DATA_PINNED)
> +               return -EBUSY;

io_buffer_unregister_bvec() can also be used to unregister ublk
zero-copy buffers (also under control of userspace), so it may need
the check too? But maybe fuse ensures that it never uses a ublk
zero-copy buffer?

Best,
Caleb

>         io_rsrc_data_free(ctx, &ctx->buf_table);
>         return 0;
>  }
> @@ -1580,3 +1585,40 @@ int io_prep_reg_iovec(struct io_kiocb *req, struct=
 iou_vec *iv,
>         req->flags |=3D REQ_F_IMPORT_BUFFER;
>         return 0;
>  }
> +
> +int io_uring_buf_table_pin(struct io_ring_ctx *ctx, unsigned issue_flags=
)
> +{
> +       struct io_rsrc_data *data;
> +       int err =3D 0;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       data =3D &ctx->buf_table;
> +       /* There was nothing registered. There is nothing to pin */
> +       if (!data->nr)
> +               err =3D -ENXIO;
> +       else
> +               data->flags |=3D IO_RSRC_DATA_PINNED;
> +
> +       io_ring_submit_unlock(ctx, issue_flags);
> +       return err;
> +}
> +EXPORT_SYMBOL_GPL(io_uring_buf_table_pin);
> +
> +int io_uring_buf_table_unpin(struct io_ring_ctx *ctx, unsigned issue_fla=
gs)
> +{
> +       struct io_rsrc_data *data;
> +       int err =3D 0;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       data =3D &ctx->buf_table;
> +       if (WARN_ON_ONCE(!(data->flags & IO_RSRC_DATA_PINNED)))
> +               err =3D -EINVAL;
> +       else
> +               data->flags &=3D ~IO_RSRC_DATA_PINNED;
> +
> +       io_ring_submit_unlock(ctx, issue_flags);
> +       return err;
> +}
> +EXPORT_SYMBOL_GPL(io_uring_buf_table_unpin);
> --
> 2.47.3
>

