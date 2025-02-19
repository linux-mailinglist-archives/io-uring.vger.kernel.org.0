Return-Path: <io-uring+bounces-6550-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 01612A3B055
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 05:22:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7C481892173
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 04:23:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0A931A314B;
	Wed, 19 Feb 2025 04:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Q7Ce1Hek"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EE25A4D5
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 04:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739938971; cv=none; b=oSd015I4bGGH+fFfDPi5u2jk+qUussnehYMr2lGo3X0WJsRqlZMyxKpGiXLhVYcfpEO30jk3rbdAv4jHyP7M6StQhN6De/a7Y2LrWP7ZSDhDABaw1aEp9rmO143ef9F8ffwdZlug4dJRxLmTasg6G8mJbSVvJgcmSxwCryLoYxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739938971; c=relaxed/simple;
	bh=v3NGXi6gDscAvVjpowK4da7TyjLNMAf7uTMEvZ2ZCy4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D9trlwykHIyOCWpbOhBpl6JhF6I47EuPQ2U63kM/2Jz01C3BIhGUyMeysfbBCCbeQnvb9PesNwZWKoexctsEUkNK8BJM1Zx6tEAPQhkuuOWaSLLXo7a7DrOpwaN6FHl1sr/okzBs193mc+ZMj71+H5IW0I0glP7eXg790zwXnpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Q7Ce1Hek; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2fbfa7100b0so1503634a91.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 20:22:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739938969; x=1740543769; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4DwEN6OwZn+jA2I0ifFTaP270joWmbYUWwwkASL4K14=;
        b=Q7Ce1HekSegHZ4vg/26Fq3IXwYuk7Cyp5ywool4ea9ZTBYNbYzLRqmvST7I1u7/1zP
         qHOLMDcbQ+lTnp/5rxTdqLRvMFXrIFVhUcdhSFBeSynzXh4Q4cT+xEOK8HsaQ3GPdeiO
         3KtlEAmywKA39P68AZ7dietiCM3xvs5bg5jfqEVaA9ofcbbuYG9837Y2sAu1rOI7jeFa
         2lRJTBkQ8Rx+2yxDU2E2qX86uD8azklCcUywboDXlNZX4NP6fyOkHeGiZpOG1QaF+WQF
         xsbTvSqtwaNv96dntk99tArKq3tehYjFfigPE3O7pLHXe8fPo3gySIEml5HRbesBKmfk
         iBCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739938969; x=1740543769;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4DwEN6OwZn+jA2I0ifFTaP270joWmbYUWwwkASL4K14=;
        b=cJRPLGyDz6lfgfm6utljRETQ3UhgsTl/dGPTJS2DMC3Sg7fXc+dfgfIbnP4ORUc3qC
         dCtmA8+c4QHWjbMNVHJslZb6kVSh/PBA0fCF6N6GVZlpaIro66skjHMhgxGmkgKo7ACa
         T34evdLgrtf148XvM3HfsOLTXO4/JxiVTKtqiJ9yzHjk6DLQ+1PVRdvlcsGiMKToXFgx
         oJgwee5e1qmalyPifSKpNkblj0E5mHAFyLvHXnMKmmefh02tczJAcGaGKJTr6HZXB/yy
         7t/NXD6GxilFoBF1ohfIhC6TwC5hiR8N8NaTyzCd0+uJDBcUnRKk1DoQod9zUBRa4qLX
         npXg==
X-Forwarded-Encrypted: i=1; AJvYcCXrIDs2VeeUc3t3IqVw8en6rCbMFh6MYONUh6zwi4aYk220VWtv1kOZXfQXPc+/j/7FY9AWVN73IQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxDS4vCmZZcBXE4En1W81daJQf77YqDYgOpm8XaxbK0cJtGGaUB
	//xldagQWdevsGZOeGakKZXSPQLGrEyKlCoaGWvGD1SnKNCGuSgSLiVGyGiRyqheuvg/ubaN7n1
	jKTrj6SdeT1mKwGDjfbXb38M5Frx3uPkTY7bEhg==
X-Gm-Gg: ASbGncubboeX4RaOQcafUg99Uj4THvyqmix7TYgJo6BND0idTy3rJksA15kwz8pULo+
	F52xP0Q81xcTCE2iqKfTg7inWW8ivtG12N/zGLbCIXF4EIhwOi6GBwBCx8ssPT9cfe+t2EIY=
X-Google-Smtp-Source: AGHT+IGT04Pru+cfwjjPXwRCSaBVEvCK0c2hxW7uhO5NhWw3VT2/HEI4oyAjLYphMYwsFQgDDfAXo8u9vwp56lBscrk=
X-Received: by 2002:a17:90b:4b4e:b0:2ea:c2d3:a079 with SMTP id
 98e67ed59e1d1-2fc41044975mr9589750a91.3.1739938968728; Tue, 18 Feb 2025
 20:22:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218224229.837848-1-kbusch@meta.com> <20250218224229.837848-6-kbusch@meta.com>
In-Reply-To: <20250218224229.837848-6-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 18 Feb 2025 20:22:36 -0800
X-Gm-Features: AWEUYZkRt9Mp1TI95iMshNGwjFDvGg48QFpOHgogYaErS5hd0uPkbLX6FAlifjA
Message-ID: <CADUfDZq5CDOZyyfjOgW_JE_A_GWLscZkbJDgQ-UKTbFC66FjKA@mail.gmail.com>
Subject: Re: [PATCHv4 5/5] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025 at 2:43=E2=80=AFPM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Frequent alloc/free cycles on these is pretty costly. Use an io cache to
> more efficiently reuse these buffers.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/linux/io_uring_types.h |  18 ++---
>  io_uring/filetable.c           |   2 +-
>  io_uring/rsrc.c                | 120 +++++++++++++++++++++++++--------
>  io_uring/rsrc.h                |   2 +-
>  4 files changed, 104 insertions(+), 38 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 810d1dccd27b1..bbfb651506522 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -69,8 +69,18 @@ struct io_file_table {
>         unsigned int alloc_hint;
>  };
>
> +struct io_alloc_cache {
> +       void                    **entries;
> +       unsigned int            nr_cached;
> +       unsigned int            max_cached;
> +       size_t                  elem_size;

Is growing this field from unsigned to size_t really necessary? It
probably doesn't make sense to be caching allocations > 4 GB.

> +       unsigned int            init_clear;
> +};
> +
>  struct io_buf_table {
>         struct io_rsrc_data     data;
> +       struct io_alloc_cache   node_cache;
> +       struct io_alloc_cache   imu_cache;
>  };
>
>  struct io_hash_bucket {
> @@ -224,14 +234,6 @@ struct io_submit_state {
>         struct blk_plug         plug;
>  };
>
> -struct io_alloc_cache {
> -       void                    **entries;
> -       unsigned int            nr_cached;
> -       unsigned int            max_cached;
> -       unsigned int            elem_size;
> -       unsigned int            init_clear;
> -};
> -
>  struct io_ring_ctx {
>         /* const or read-mostly hot data */
>         struct {
> diff --git a/io_uring/filetable.c b/io_uring/filetable.c
> index dd8eeec97acf6..a21660e3145ab 100644
> --- a/io_uring/filetable.c
> +++ b/io_uring/filetable.c
> @@ -68,7 +68,7 @@ static int io_install_fixed_file(struct io_ring_ctx *ct=
x, struct file *file,
>         if (slot_index >=3D ctx->file_table.data.nr)
>                 return -EINVAL;
>
> -       node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
> +       node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
>         if (!node)
>                 return -ENOMEM;
>
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 261b5535f46c6..d5cac3a234316 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -32,6 +32,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(stru=
ct io_ring_ctx *ctx,
>  #define IORING_MAX_FIXED_FILES (1U << 20)
>  #define IORING_MAX_REG_BUFFERS (1U << 14)
>
> +#define IO_CACHED_BVECS_SEGS   32
> +
>  int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
>  {
>         unsigned long page_limit, cur_pages, new_pages;
> @@ -101,6 +103,22 @@ int io_buffer_validate(struct iovec *iov)
>         return 0;
>  }
>
> +static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
> +                                          int nr_bvecs)

Pass nr_bvecs as unsigned to avoid sign-extension in struct_size_t()?

> +{
> +       if (nr_bvecs <=3D IO_CACHED_BVECS_SEGS)
> +               return io_cache_alloc(&ctx->buf_table.imu_cache, GFP_KERN=
EL);
> +       return kvmalloc(struct_size_t(struct io_mapped_ubuf, bvec, nr_bve=
cs),
> +                       GFP_KERNEL);
> +}
> +
> +static void io_free_imu(struct io_ring_ctx *ctx, struct io_mapped_ubuf *=
imu)
> +{
> +       if (imu->nr_bvecs > IO_CACHED_BVECS_SEGS ||
> +           !io_alloc_cache_put(&ctx->buf_table.imu_cache, imu))
> +               kvfree(imu);
> +}
> +
>  static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node=
 *node)
>  {
>         struct io_mapped_ubuf *imu =3D node->buf;
> @@ -119,22 +137,35 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx=
, struct io_rsrc_node *node)
>                         io_unaccount_mem(ctx, imu->acct_pages);
>         }
>
> -       kvfree(imu);
> +       io_free_imu(ctx, imu);
>  }
>
> -struct io_rsrc_node *io_rsrc_node_alloc(int type)
> +struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int typ=
e)
>  {
>         struct io_rsrc_node *node;
>
> -       node =3D kzalloc(sizeof(*node), GFP_KERNEL);
> +       if (type =3D=3D IORING_RSRC_FILE)
> +               node =3D kmalloc(sizeof(*node), GFP_KERNEL);
> +       else
> +               node =3D io_cache_alloc(&ctx->buf_table.node_cache, GFP_K=
ERNEL);
>         if (node) {
>                 node->type =3D type;
>                 node->refs =3D 1;
> +               node->tag =3D 0;
> +               node->file_ptr =3D 0;
>         }
>         return node;
>  }
>
> -__cold void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_da=
ta *data)
> +static __cold void __io_rsrc_data_free(struct io_rsrc_data *data)
> +{
> +       kvfree(data->nodes);
> +       data->nodes =3D NULL;
> +       data->nr =3D 0;
> +}
> +
> +__cold void io_rsrc_data_free(struct io_ring_ctx *ctx,
> +                             struct io_rsrc_data *data)
>  {
>         if (!data->nr)
>                 return;
> @@ -142,9 +173,7 @@ __cold void io_rsrc_data_free(struct io_ring_ctx *ctx=
, struct io_rsrc_data *data
>                 if (data->nodes[data->nr])
>                         io_put_rsrc_node(ctx, data->nodes[data->nr]);
>         }
> -       kvfree(data->nodes);
> -       data->nodes =3D NULL;
> -       data->nr =3D 0;
> +       __io_rsrc_data_free(data);
>  }
>
>  __cold int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr)
> @@ -158,6 +187,31 @@ __cold int io_rsrc_data_alloc(struct io_rsrc_data *d=
ata, unsigned nr)
>         return -ENOMEM;
>  }
>
> +static __cold int io_rsrc_buffer_alloc(struct io_buf_table *table, unsig=
ned nr)
> +{
> +       const int imu_cache_size =3D struct_size_t(struct io_mapped_ubuf,=
 bvec,
> +                                                IO_CACHED_BVECS_SEGS);
> +       const int node_size =3D sizeof(struct io_rsrc_node);
> +       int ret;
> +
> +       ret =3D io_rsrc_data_alloc(&table->data, nr);
> +       if (ret)
> +               return ret;
> +
> +       if (io_alloc_cache_init(&table->node_cache, nr, node_size, 0))
> +               goto free_data;
> +
> +       if (io_alloc_cache_init(&table->imu_cache, nr, imu_cache_size, 0)=
)
> +               goto free_cache;
> +
> +       return 0;
> +free_cache:
> +       io_alloc_cache_free(&table->node_cache, kfree);
> +free_data:
> +       __io_rsrc_data_free(&table->data);
> +       return -ENOMEM;
> +}
> +
>  static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>                                  struct io_uring_rsrc_update2 *up,
>                                  unsigned nr_args)
> @@ -207,7 +261,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *=
ctx,
>                                 err =3D -EBADF;
>                                 break;
>                         }
> -                       node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
> +                       node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE=
);
>                         if (!node) {
>                                 err =3D -ENOMEM;
>                                 fput(file);
> @@ -459,6 +513,8 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struc=
t io_rsrc_node *node)
>         case IORING_RSRC_BUFFER:
>                 if (node->buf)
>                         io_buffer_unmap(ctx, node);
> +               if (io_alloc_cache_put(&ctx->buf_table.node_cache, node))
> +                       return;
>                 break;
>         default:
>                 WARN_ON_ONCE(1);
> @@ -527,7 +583,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, vo=
id __user *arg,
>                         goto fail;
>                 }
>                 ret =3D -ENOMEM;
> -               node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
> +               node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
>                 if (!node) {
>                         fput(file);
>                         goto fail;
> @@ -547,11 +603,19 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, =
void __user *arg,
>         return ret;
>  }
>
> +static void io_rsrc_buffer_free(struct io_ring_ctx *ctx,
> +                               struct io_buf_table *table)
> +{
> +       io_rsrc_data_free(ctx, &table->data);
> +       io_alloc_cache_free(&table->node_cache, kfree);
> +       io_alloc_cache_free(&table->imu_cache, kfree);
> +}
> +
>  int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
>  {
>         if (!ctx->buf_table.data.nr)
>                 return -ENXIO;
> -       io_rsrc_data_free(ctx, &ctx->buf_table.data);
> +       io_rsrc_buffer_free(ctx, &ctx->buf_table);
>         return 0;
>  }
>
> @@ -732,7 +796,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
>         if (!iov->iov_base)
>                 return NULL;
>
> -       node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
> +       node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
>         if (!node)
>                 return ERR_PTR(-ENOMEM);
>         node->buf =3D NULL;
> @@ -752,7 +816,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
>                         coalesced =3D io_coalesce_buffer(&pages, &nr_page=
s, &data);
>         }
>
> -       imu =3D kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
> +       imu =3D io_alloc_imu(ctx, nr_pages);
>         if (!imu)
>                 goto done;
>
> @@ -789,7 +853,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
>         }
>  done:
>         if (ret) {
> -               kvfree(imu);
> +               io_free_imu(ctx, imu);
>                 if (node)
>                         io_put_rsrc_node(ctx, node);
>                 node =3D ERR_PTR(ret);
> @@ -802,9 +866,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
void __user *arg,
>                             unsigned int nr_args, u64 __user *tags)
>  {
>         struct page *last_hpage =3D NULL;
> -       struct io_rsrc_data data;
>         struct iovec fast_iov, *iov =3D &fast_iov;
>         const struct iovec __user *uvec;
> +       struct io_buf_table table;
>         int i, ret;
>
>         BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >=3D (1u << 16));
> @@ -813,13 +877,14 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
, void __user *arg,
>                 return -EBUSY;
>         if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
>                 return -EINVAL;
> -       ret =3D io_rsrc_data_alloc(&data, nr_args);
> +       ret =3D io_rsrc_buffer_alloc(&table, nr_args);
>         if (ret)
>                 return ret;
>
>         if (!arg)
>                 memset(iov, 0, sizeof(*iov));
>
> +       ctx->buf_table =3D table;
>         for (i =3D 0; i < nr_args; i++) {
>                 struct io_rsrc_node *node;
>                 u64 tag =3D 0;
> @@ -859,10 +924,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
 void __user *arg,
>                         }
>                         node->tag =3D tag;
>                 }
> -               data.nodes[i] =3D node;
> +               table.data.nodes[i] =3D node;
>         }
> -
> -       ctx->buf_table.data =3D data;

Still don't see the need to move this assignment. Is there a reason
you prefer setting ctx->buf_table before initializing its nodes? I
find the existing code easier to follow, where the table is moved to
ctx->buf_table after filling it in. It's also consistent with
io_clone_buffers().

>         if (ret)
>                 io_sqe_buffers_unregister(ctx);
>         return ret;
> @@ -887,14 +950,15 @@ int io_buffer_register_bvec(struct io_ring_ctx *ctx=
, struct request *rq,
>                 goto unlock;
>         }
>
> -       node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
> +       node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
>         if (!node) {
>                 ret =3D -ENOMEM;
>                 goto unlock;
>         }
>
>         nr_bvecs =3D blk_rq_nr_phys_segments(rq);
> -       imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
> +
> +       imu =3D io_alloc_imu(ctx, nr_bvecs);

nit: probably don't need to add a blank line here

Best,
Caleb

>         if (!imu) {
>                 kfree(node);
>                 ret =3D -ENOMEM;
> @@ -1031,7 +1095,7 @@ static void lock_two_rings(struct io_ring_ctx *ctx1=
, struct io_ring_ctx *ctx2)
>  static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx =
*src_ctx,
>                             struct io_uring_clone_buffers *arg)
>  {
> -       struct io_rsrc_data data;
> +       struct io_buf_table table;
>         int i, ret, off, nr;
>         unsigned int nbufs;
>
> @@ -1062,7 +1126,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
>         if (check_add_overflow(arg->nr, arg->dst_off, &nbufs))
>                 return -EOVERFLOW;
>
> -       ret =3D io_rsrc_data_alloc(&data, max(nbufs, ctx->buf_table.data.=
nr));
> +       ret =3D io_rsrc_buffer_alloc(&table, max(nbufs, ctx->buf_table.da=
ta.nr));
>         if (ret)
>                 return ret;
>
> @@ -1071,7 +1135,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
>                 struct io_rsrc_node *src_node =3D ctx->buf_table.data.nod=
es[i];
>
>                 if (src_node) {
> -                       data.nodes[i] =3D src_node;
> +                       table.data.nodes[i] =3D src_node;
>                         src_node->refs++;
>                 }
>         }
> @@ -1101,7 +1165,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
, struct io_ring_ctx *src_ctx
>                 if (!src_node) {
>                         dst_node =3D NULL;
>                 } else {
> -                       dst_node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFE=
R);
> +                       dst_node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_=
BUFFER);
>                         if (!dst_node) {
>                                 ret =3D -ENOMEM;
>                                 goto out_free;
> @@ -1110,12 +1174,12 @@ static int io_clone_buffers(struct io_ring_ctx *c=
tx, struct io_ring_ctx *src_ctx
>                         refcount_inc(&src_node->buf->refs);
>                         dst_node->buf =3D src_node->buf;
>                 }
> -               data.nodes[off++] =3D dst_node;
> +               table.data.nodes[off++] =3D dst_node;
>                 i++;
>         }
>
>         /*
> -        * If asked for replace, put the old table. data->nodes[] holds b=
oth
> +        * If asked for replace, put the old table. table.data->nodes[] h=
olds both
>          * old and new nodes at this point.
>          */
>         if (arg->flags & IORING_REGISTER_DST_REPLACE)
> @@ -1128,10 +1192,10 @@ static int io_clone_buffers(struct io_ring_ctx *c=
tx, struct io_ring_ctx *src_ctx
>          * entry).
>          */
>         WARN_ON_ONCE(ctx->buf_table.data.nr);
> -       ctx->buf_table.data =3D data;
> +       ctx->buf_table =3D table;
>         return 0;
>  out_free:
> -       io_rsrc_data_free(ctx, &data);
> +       io_rsrc_buffer_free(ctx, &table);
>         return ret;
>  }
>
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index 81c31b93d4f7b..69cc212ad0c7c 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -49,7 +49,7 @@ struct io_imu_folio_data {
>         unsigned int    nr_folios;
>  };
>
> -struct io_rsrc_node *io_rsrc_node_alloc(int type);
> +struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int typ=
e);
>  void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *nod=
e);
>  void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *dat=
a);
>  int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
> --
> 2.43.5
>

