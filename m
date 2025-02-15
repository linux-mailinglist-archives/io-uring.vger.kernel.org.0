Return-Path: <io-uring+bounces-6468-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A41A36B6C
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 03:22:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 813447A4A7C
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 02:21:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6F978F4B;
	Sat, 15 Feb 2025 02:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="aj1pwhWv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D251D531
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 02:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739586145; cv=none; b=Sj/HBA4pYMHriHupTyCXuGJtnEZ3OxjT2L2FFcNxQhwOXjyoSBoh8FBZXytX40gRTQPV+7g2Lp+sBpjReK7o0/6FqLMJlpeW3MVi3PBJzXEveqMwzih1UImu5kTo1oIYz7aahSi7O9iLKLTMXwku4r5F5BHuYkxhBwAxk5lMAFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739586145; c=relaxed/simple;
	bh=5RCFYzPPLj4Vg0m/j0f20CqaaUsfzcWT/8z+8L0PAXM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eDDjyKtFxvZ2OQ9ycVPq8lCLfhCkuYBIcvy64uYbwo5NHQbjjBW14yDSrgpdrnmiJ+X1Q2nS7sa/5Ky+06Zzd14nHoroCfPeAyq8M0+g54t2HLLJ28vE5Cb48JfaiYY/ha0CDcfu+D5kRkmscj4kXidwH/SjmbTGoNqlJm7XftA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=aj1pwhWv; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2f9f90103bbso580915a91.3
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 18:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739586141; x=1740190941; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4eeleZF5aBDyTAVl8DCTY5WX2WRgbuuQE7ZJ38ADXMU=;
        b=aj1pwhWvQWjOX9JdUB0Iom80Om7iq+vbeE14ctzAADD62dr6rfcteRt380VBJ1q/rL
         htheh+CCEYxn+NzwOOCA7kPB05awqBw0LVYIsWrHkoGKepvRHYCS3li9xwOlwRGGH4KD
         Qk3Y3eY1t5/9WgnSUV/Azn46uw3wP8AOAILJEMN96lVGrszfaBgMjidJatqy62AR1lks
         Ob/A2GpoxGJ7Wf9DNT/anQweuo1+OVRgRnqdCMM0eBugUqhLw0oCRsCXURDSFAeKYF8W
         saz3plxTZSjRugOpjB9ECPS3E+2meYspZ1PwyKRGT8RshBlFvtY+Oz6F1fcOW232AdKe
         LDjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739586141; x=1740190941;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4eeleZF5aBDyTAVl8DCTY5WX2WRgbuuQE7ZJ38ADXMU=;
        b=YpJG0epgcu9/BN+RIkbSbI38KdrpkvQ7Q7JockMrAgB452iV/H2vL6k0XU25unuRUB
         BYSy6s2TwJUFP4rPUP+5toFCT0Jqy7RgEa4rvouoJ3HtcNt8qyb26rlWaKu/XVzoy5zq
         Ekm6KmTL4vcDYD99ZZL3ANNZLxr0VwnPDliVcqEkv0WYH1W3ZzhyR/fbSgRCyYigTg0+
         ZQV0RhMvY67dqTD094QN7Js8/5zXsHdYsHAmzBUyRUyOzyxuUqnIR4MN5x5/12spOhIl
         qDf8uWfJzJ1QGO+mNt7v8+ypO1HiR7zzXZr6UReROCfNEjPi+Jdoor/ku7kj8aDS+CB0
         LdhA==
X-Forwarded-Encrypted: i=1; AJvYcCX3FTp1gZ7tYl/cwo8iUD1ACz00lSJ2Oy/nGxFBk2N11yIbYpVcUB8+gsRgK0eUxC+t0VDUJokgCQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxa1/7vusmB+zH42joR1pQ1XzUBHAQZYwYAJsCrygkez/43uFQ0
	D5JBRnOKry7ayltK+bVcbksR2YH00/QGY/Plm7ifcbNk38NpsVhimRysTDBZGFom/nFpcTx90tG
	jn7su6kMXG6WtqsGB4y5yyRoh1/awqa0lY8hZBg==
X-Gm-Gg: ASbGncuJCc3atbgyu1n16yFMycVSbtCU167ZlwhMkyQ42XOTi3JEAwIlbq077JfFj1C
	sHwnf4dOhhoxLyhP+1qX04JUvlEx2VVoSAMYu+VDaOTBMoQAtLmbXxNgJS5L42enj7crsM2c=
X-Google-Smtp-Source: AGHT+IHRm2tXtTDjx4Vb1b70ipUoEAuhUM3M+i8YDQdxMz2kv5wCv8LLZyoXBd1GeTVUtjXpKdcTN3xOLmWXr/goae0=
X-Received: by 2002:a17:90b:4cc3:b0:2ee:c059:7de6 with SMTP id
 98e67ed59e1d1-2fc40d12454mr828105a91.2.1739586141324; Fri, 14 Feb 2025
 18:22:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214154348.2952692-1-kbusch@meta.com> <20250214154348.2952692-6-kbusch@meta.com>
In-Reply-To: <20250214154348.2952692-6-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 14 Feb 2025 18:22:09 -0800
X-Gm-Features: AWEUYZnC5KhyJ17cRsCiEHnQ7nQpRGs-AjnOOMaMOs535bvGm_cA8JzwCZ0Ll7w
Message-ID: <CADUfDZpM-TXBYQy0B4xRnKjT=-OfX+AYo+6HGA7e7pyT39LxEA@mail.gmail.com>
Subject: Re: [PATCHv3 5/5] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 7:46=E2=80=AFAM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Frequent alloc/free cycles on these is pretty costly. Use an io cache to
> more efficiently reuse these buffers.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/linux/io_uring_types.h |  18 +++---
>  io_uring/filetable.c           |   2 +-
>  io_uring/rsrc.c                | 114 +++++++++++++++++++++++++--------
>  io_uring/rsrc.h                |   2 +-
>  4 files changed, 99 insertions(+), 37 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index d8d717cce427f..ebaaa1c7e210f 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -67,8 +67,18 @@ struct io_file_table {
>         unsigned int alloc_hint;
>  };
>
> +struct io_alloc_cache {
> +       void                    **entries;
> +       unsigned int            nr_cached;
> +       unsigned int            max_cached;
> +       size_t                  elem_size;
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
> @@ -222,14 +232,6 @@ struct io_submit_state {
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
> index fd7a1b04db8b7..26ff9b5851d94 100644
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
> @@ -122,19 +124,33 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx=
, struct io_rsrc_node *node)
>         kvfree(imu);
>  }
>
> -struct io_rsrc_node *io_rsrc_node_alloc(int type)
> +
> +struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int typ=
e)

nit: extra blank line added here

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
> @@ -142,9 +158,7 @@ __cold void io_rsrc_data_free(struct io_ring_ctx *ctx=
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
> @@ -158,6 +172,33 @@ __cold int io_rsrc_data_alloc(struct io_rsrc_data *d=
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
> +       int ret;
> +
> +       ret =3D io_rsrc_data_alloc(&table->data, nr);
> +       if (ret)
> +               return ret;
> +
> +       ret =3D io_alloc_cache_init(&table->node_cache, nr,
> +                                 sizeof(struct io_rsrc_node), 0);
> +       if (ret)
> +               goto out_1;
> +
> +       ret =3D io_alloc_cache_init(&table->imu_cache, nr, imu_cache_size=
, 0);
> +       if (ret)
> +               goto out_2;

io_alloc_cache_init() returns bool. Probably these cases should return
-ENOMEM instead of 1?

> +
> +       return 0;
> +out_2:
> +       io_alloc_cache_free(&table->node_cache, kfree);
> +out_1:
> +       __io_rsrc_data_free(&table->data);
> +       return ret;
> +}
> +
>  static int __io_sqe_files_update(struct io_ring_ctx *ctx,
>                                  struct io_uring_rsrc_update2 *up,
>                                  unsigned nr_args)
> @@ -207,7 +248,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *=
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
> @@ -269,7 +310,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx=
 *ctx,
>                         }
>                         node->tag =3D tag;
>                 }
> -               i =3D array_index_nospec(up->offset + done, ctx->buf_tabl=
e.nr);
> +               i =3D array_index_nospec(up->offset + done, ctx->buf_tabl=
e.data.nr);

Looks like this change belongs in the prior patch "io_uring: add
abstraction for buf_table rsrc data"?

>                 io_reset_rsrc_node(ctx, &ctx->buf_table.data, i);
>                 ctx->buf_table.data.nodes[i] =3D node;
>                 if (ctx->compat)
> @@ -459,6 +500,8 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struc=
t io_rsrc_node *node)
>         case IORING_RSRC_BUFFER:
>                 if (node->buf)
>                         io_buffer_unmap(ctx, node);
> +               if (io_alloc_cache_put(&ctx->buf_table.node_cache, node))
> +                       return;
>                 break;
>         default:
>                 WARN_ON_ONCE(1);
> @@ -527,7 +570,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, vo=
id __user *arg,
>                         goto fail;
>                 }
>                 ret =3D -ENOMEM;
> -               node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
> +               node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
>                 if (!node) {
>                         fput(file);
>                         goto fail;
> @@ -547,11 +590,19 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, =
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
> @@ -716,6 +767,15 @@ bool io_check_coalesce_buffer(struct page **page_arr=
ay, int nr_pages,
>         return true;
>  }
>
> +static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
> +                                          int nr_bvecs)
> +{
> +       if (nr_bvecs <=3D IO_CACHED_BVECS_SEGS)
> +               return io_cache_alloc(&ctx->buf_table.imu_cache, GFP_KERN=
EL);

If there is no entry available in the cache, this will heap-allocate
one with enough space for all IO_CACHED_BVECS_SEGS bvecs. Consider
using io_alloc_cache_get() instead of io_cache_alloc(), so the
heap-allocated fallback uses the minimal size.

Also, where are these allocations returned to the imu_cache? Looks
like kvfree(imu) in io_buffer_unmap() and io_sqe_buffer_register()
needs to try io_alloc_cache_put() first.

Best,
Caleb

> +       return kvmalloc(struct_size_t(struct io_mapped_ubuf, bvec, nr_bve=
cs),
> +                       GFP_KERNEL);
> +}
> +
>  static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *c=
tx,
>                                                    struct iovec *iov,
>                                                    struct page **last_hpa=
ge)
> @@ -732,7 +792,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
>         if (!iov->iov_base)
>                 return NULL;
>
> -       node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
> +       node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
>         if (!node)
>                 return ERR_PTR(-ENOMEM);
>         node->buf =3D NULL;
> @@ -752,7 +812,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
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
> @@ -800,9 +860,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, =
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
> @@ -811,13 +871,14 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
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
> @@ -857,10 +918,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
 void __user *arg,
>                         }
>                         node->tag =3D tag;
>                 }
> -               data.nodes[i] =3D node;
> +               table.data.nodes[i] =3D node;
>         }
> -
> -       ctx->buf_table.data =3D data;

Is it necessary to move this assignment? I found the existing location
easier to reason about, since the assignment of ctx->buf_table
represents a transfer of ownership from the local variable.

>         if (ret)
>                 io_sqe_buffers_unregister(ctx);
>         return ret;
> @@ -891,14 +950,15 @@ int io_buffer_register_bvec(struct io_ring_ctx *ctx=
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
>         if (!imu) {
>                 kfree(node);
>                 ret =3D -ENOMEM;
> @@ -1028,7 +1088,7 @@ static void lock_two_rings(struct io_ring_ctx *ctx1=
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
> @@ -1059,7 +1119,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
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
> @@ -1068,7 +1128,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
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
> @@ -1098,7 +1158,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx=
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
> @@ -1107,12 +1167,12 @@ static int io_clone_buffers(struct io_ring_ctx *c=
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
> @@ -1125,10 +1185,10 @@ static int io_clone_buffers(struct io_ring_ctx *c=
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
> index 2e8d1862caefc..c5bdac558a2b4 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -47,7 +47,7 @@ struct io_imu_folio_data {
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
>

