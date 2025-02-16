Return-Path: <io-uring+bounces-6476-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 87396A37815
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2025 23:44:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0493188D322
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2025 22:44:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 668A81A238B;
	Sun, 16 Feb 2025 22:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="gG3X4ZS+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732F117B421
	for <io-uring@vger.kernel.org>; Sun, 16 Feb 2025 22:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739745835; cv=none; b=f0cCA0YAKkQXBvR7J09O+m6yuAH0ZaQkxb7IK5szeCrXN9quauaHJewlB+Zkdm9GcT7qslhjxWgxeifwMaujRsERrgeYxzPJwM/mqN84Os3JBxb+Jd/b6TsQXawd7mtEqp+WZDE8Xjxx0gVmqx0ifwNKLqhv+OC8Ow8JwJOKklI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739745835; c=relaxed/simple;
	bh=+f079ju+RCKS/8B9RKXfxi8Zix6bSKSgHVs2wCddcJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qRL35jKkmSw7mQfyZu78e5ZFQgE+bABe+x+q1l0atL4DiVjlUiEeogax694oRbyuAg5ctPyAe+18e2/hVVY4rTbu6EJL9S1qeJBGI/yBPmxdYnNTUcel3jelRXQKIcRTOCmoP9avY8BfFtnxBch1wILO7CuMuolF4onQAq/WabQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=gG3X4ZS+; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2fbfa7100b0so937818a91.0
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2025 14:43:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739745832; x=1740350632; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VE4xXMoz0Ys7BYrnHZpYRJdnORPOyFq/c9xefI3cWTU=;
        b=gG3X4ZS+nmCo88qiFQJXi9Si2r7KmFvTfOPjfploU81E5iYvCWnPD+7FNe1Xa84YOT
         NTbjMQ+f01hNdRbRETOMYKQXC3ZsbjKjHSoKp8uKtz/5N0LGIXyf6nfXDzII4rtE2dOE
         wANp8cvrEXuBUG1vprPXgALoTVj6bNo0Op8G4drXbho1lg/HvFamZsIrvsgEQeke/WEU
         taG5bd34EgNKWtHTWD6DTB2fVQ3Re6mwPWgugjsWwg30xjn3r9FbX4g3WfZaIxGANd4r
         NGaFGGTwpIQl2bvG0akDbpBtF8aHsrk3uCg0bwtQ7U6D6+v+LKCv6FM2XoOwqAr3szCo
         cD4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739745832; x=1740350632;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VE4xXMoz0Ys7BYrnHZpYRJdnORPOyFq/c9xefI3cWTU=;
        b=nwEzTU5AV23nr0MarGRzaCi56AvCK2tLX6ebuU457C4uYFBYHOC+4ZGRs/ke50q0cO
         CVpnOCTCoN//MJ6eor0fIE3OaNCv9e48ogJWTwmlvOOi78sVk3tDP+6BMct1n1SJd/uJ
         G6F0mvw1+aWGKyJm3Opl6FcsH6WNBcI03KTyBWb8sDx37zU0vqtDuDHouK3sNhNSvqMc
         tkdbnnvmevf3e08iFuFtPXY1Bz/wUAYRvamq7VmYYemXsLH8rJi4h2dEU19LGocbtddy
         YA7IHc5lN8C7F4LVkFzkoif9TBXm28zkiDvkOI+xtAT7krt0ansa/wrjX7OWzaGHprG2
         bewQ==
X-Forwarded-Encrypted: i=1; AJvYcCUs0PYlITXKgLc3nSxZoQBQzTQ/RH258NGPUAZ1ZoG4ahIlnGq67ROxKXaplV2UElPr7IiKNiabHw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+fKF3Lr66WTKyk/Utk2gUn6ze+Hd3kO44mLr385zS+8TqpluS
	1IuYcKJXCy78MDiHINOSPTFHXltN/v/FReU2gBmEd7zlkkxv8efsA2ydEtZFUFdp1KWu8nzA8b7
	VzoNLo7AQZhUOAAlX/hzdeIN5XPzf9naCbm+zUA==
X-Gm-Gg: ASbGncvj78CIcZI3Te4NDFLc5vnIMrZylUwnrvtrprW8HtLWWur2gOxQn2F/b6hF15e
	KZDR2uePiRZL/s2SPKX5sotvG2662jS4asx7ApBHbhBgAf+f8b2uh63rOQHXJraesM4Fx71o=
X-Google-Smtp-Source: AGHT+IHz8RTxMUMjMChP3ve/ZdjRSw9H7HH2/mYpLVQiVrDLHqVtCN8qvE8gL+JS5KSR4QT6/NmmZ7N8HwZzkvIFB30=
X-Received: by 2002:a17:90b:510c:b0:2fc:25b3:6a7b with SMTP id
 98e67ed59e1d1-2fc411679ddmr4380284a91.6.1739745831511; Sun, 16 Feb 2025
 14:43:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214154348.2952692-1-kbusch@meta.com> <20250214154348.2952692-6-kbusch@meta.com>
 <CADUfDZpM-TXBYQy0B4xRnKjT=-OfX+AYo+6HGA7e7pyT39LxEA@mail.gmail.com>
In-Reply-To: <CADUfDZpM-TXBYQy0B4xRnKjT=-OfX+AYo+6HGA7e7pyT39LxEA@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Sun, 16 Feb 2025 14:43:40 -0800
X-Gm-Features: AWEUYZm3HqPAZf-PlzLHpptiLuK81jNLBto6Av57jEbNk1VFWMNUuSQ9GfTIrQc
Message-ID: <CADUfDZrfmpy3hxD5z0ADxCUkWPbU0aZDMiqpyPE+AZbeDSgZ=g@mail.gmail.com>
Subject: Re: [PATCHv3 5/5] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 14, 2025 at 6:22=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Fri, Feb 14, 2025 at 7:46=E2=80=AFAM Keith Busch <kbusch@meta.com> wro=
te:
> >
> > From: Keith Busch <kbusch@kernel.org>
> >
> > Frequent alloc/free cycles on these is pretty costly. Use an io cache t=
o
> > more efficiently reuse these buffers.
> >
> > Signed-off-by: Keith Busch <kbusch@kernel.org>
> > ---
> >  include/linux/io_uring_types.h |  18 +++---
> >  io_uring/filetable.c           |   2 +-
> >  io_uring/rsrc.c                | 114 +++++++++++++++++++++++++--------
> >  io_uring/rsrc.h                |   2 +-
> >  4 files changed, 99 insertions(+), 37 deletions(-)
> >
> > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_ty=
pes.h
> > index d8d717cce427f..ebaaa1c7e210f 100644
> > --- a/include/linux/io_uring_types.h
> > +++ b/include/linux/io_uring_types.h
> > @@ -67,8 +67,18 @@ struct io_file_table {
> >         unsigned int alloc_hint;
> >  };
> >
> > +struct io_alloc_cache {
> > +       void                    **entries;
> > +       unsigned int            nr_cached;
> > +       unsigned int            max_cached;
> > +       size_t                  elem_size;
> > +       unsigned int            init_clear;
> > +};
> > +
> >  struct io_buf_table {
> >         struct io_rsrc_data     data;
> > +       struct io_alloc_cache   node_cache;
> > +       struct io_alloc_cache   imu_cache;
> >  };
> >
> >  struct io_hash_bucket {
> > @@ -222,14 +232,6 @@ struct io_submit_state {
> >         struct blk_plug         plug;
> >  };
> >
> > -struct io_alloc_cache {
> > -       void                    **entries;
> > -       unsigned int            nr_cached;
> > -       unsigned int            max_cached;
> > -       unsigned int            elem_size;
> > -       unsigned int            init_clear;
> > -};
> > -
> >  struct io_ring_ctx {
> >         /* const or read-mostly hot data */
> >         struct {
> > diff --git a/io_uring/filetable.c b/io_uring/filetable.c
> > index dd8eeec97acf6..a21660e3145ab 100644
> > --- a/io_uring/filetable.c
> > +++ b/io_uring/filetable.c
> > @@ -68,7 +68,7 @@ static int io_install_fixed_file(struct io_ring_ctx *=
ctx, struct file *file,
> >         if (slot_index >=3D ctx->file_table.data.nr)
> >                 return -EINVAL;
> >
> > -       node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
> > +       node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
> >         if (!node)
> >                 return -ENOMEM;
> >
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index fd7a1b04db8b7..26ff9b5851d94 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -32,6 +32,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(st=
ruct io_ring_ctx *ctx,
> >  #define IORING_MAX_FIXED_FILES (1U << 20)
> >  #define IORING_MAX_REG_BUFFERS (1U << 14)
> >
> > +#define IO_CACHED_BVECS_SEGS   32
> > +
> >  int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
> >  {
> >         unsigned long page_limit, cur_pages, new_pages;
> > @@ -122,19 +124,33 @@ static void io_buffer_unmap(struct io_ring_ctx *c=
tx, struct io_rsrc_node *node)
> >         kvfree(imu);
> >  }
> >
> > -struct io_rsrc_node *io_rsrc_node_alloc(int type)
> > +
> > +struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int t=
ype)
>
> nit: extra blank line added here
>
> >  {
> >         struct io_rsrc_node *node;
> >
> > -       node =3D kzalloc(sizeof(*node), GFP_KERNEL);
> > +       if (type =3D=3D IORING_RSRC_FILE)
> > +               node =3D kmalloc(sizeof(*node), GFP_KERNEL);
> > +       else
> > +               node =3D io_cache_alloc(&ctx->buf_table.node_cache, GFP=
_KERNEL);
> >         if (node) {
> >                 node->type =3D type;
> >                 node->refs =3D 1;
> > +               node->tag =3D 0;
> > +               node->file_ptr =3D 0;
> >         }
> >         return node;
> >  }
> >
> > -__cold void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_=
data *data)
> > +static __cold void __io_rsrc_data_free(struct io_rsrc_data *data)
> > +{
> > +       kvfree(data->nodes);
> > +       data->nodes =3D NULL;
> > +       data->nr =3D 0;
> > +}
> > +
> > +__cold void io_rsrc_data_free(struct io_ring_ctx *ctx,
> > +                             struct io_rsrc_data *data)
> >  {
> >         if (!data->nr)
> >                 return;
> > @@ -142,9 +158,7 @@ __cold void io_rsrc_data_free(struct io_ring_ctx *c=
tx, struct io_rsrc_data *data
> >                 if (data->nodes[data->nr])
> >                         io_put_rsrc_node(ctx, data->nodes[data->nr]);
> >         }
> > -       kvfree(data->nodes);
> > -       data->nodes =3D NULL;
> > -       data->nr =3D 0;
> > +       __io_rsrc_data_free(data);
> >  }
> >
> >  __cold int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr)
> > @@ -158,6 +172,33 @@ __cold int io_rsrc_data_alloc(struct io_rsrc_data =
*data, unsigned nr)
> >         return -ENOMEM;
> >  }
> >
> > +static __cold int io_rsrc_buffer_alloc(struct io_buf_table *table, uns=
igned nr)
> > +{
> > +       const int imu_cache_size =3D struct_size_t(struct io_mapped_ubu=
f, bvec,
> > +                                                IO_CACHED_BVECS_SEGS);
> > +       int ret;
> > +
> > +       ret =3D io_rsrc_data_alloc(&table->data, nr);
> > +       if (ret)
> > +               return ret;
> > +
> > +       ret =3D io_alloc_cache_init(&table->node_cache, nr,
> > +                                 sizeof(struct io_rsrc_node), 0);
> > +       if (ret)
> > +               goto out_1;
> > +
> > +       ret =3D io_alloc_cache_init(&table->imu_cache, nr, imu_cache_si=
ze, 0);
> > +       if (ret)
> > +               goto out_2;
>
> io_alloc_cache_init() returns bool. Probably these cases should return
> -ENOMEM instead of 1?
>
> > +
> > +       return 0;
> > +out_2:
> > +       io_alloc_cache_free(&table->node_cache, kfree);
> > +out_1:
> > +       __io_rsrc_data_free(&table->data);
> > +       return ret;
> > +}
> > +
> >  static int __io_sqe_files_update(struct io_ring_ctx *ctx,
> >                                  struct io_uring_rsrc_update2 *up,
> >                                  unsigned nr_args)
> > @@ -207,7 +248,7 @@ static int __io_sqe_files_update(struct io_ring_ctx=
 *ctx,
> >                                 err =3D -EBADF;
> >                                 break;
> >                         }
> > -                       node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
> > +                       node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FI=
LE);
> >                         if (!node) {
> >                                 err =3D -ENOMEM;
> >                                 fput(file);
> > @@ -269,7 +310,7 @@ static int __io_sqe_buffers_update(struct io_ring_c=
tx *ctx,
> >                         }
> >                         node->tag =3D tag;
> >                 }
> > -               i =3D array_index_nospec(up->offset + done, ctx->buf_ta=
ble.nr);
> > +               i =3D array_index_nospec(up->offset + done, ctx->buf_ta=
ble.data.nr);
>
> Looks like this change belongs in the prior patch "io_uring: add
> abstraction for buf_table rsrc data"?
>
> >                 io_reset_rsrc_node(ctx, &ctx->buf_table.data, i);
> >                 ctx->buf_table.data.nodes[i] =3D node;
> >                 if (ctx->compat)
> > @@ -459,6 +500,8 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, str=
uct io_rsrc_node *node)
> >         case IORING_RSRC_BUFFER:
> >                 if (node->buf)
> >                         io_buffer_unmap(ctx, node);
> > +               if (io_alloc_cache_put(&ctx->buf_table.node_cache, node=
))
> > +                       return;
> >                 break;
> >         default:
> >                 WARN_ON_ONCE(1);
> > @@ -527,7 +570,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, =
void __user *arg,
> >                         goto fail;
> >                 }
> >                 ret =3D -ENOMEM;
> > -               node =3D io_rsrc_node_alloc(IORING_RSRC_FILE);
> > +               node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_FILE);
> >                 if (!node) {
> >                         fput(file);
> >                         goto fail;
> > @@ -547,11 +590,19 @@ int io_sqe_files_register(struct io_ring_ctx *ctx=
, void __user *arg,
> >         return ret;
> >  }
> >
> > +static void io_rsrc_buffer_free(struct io_ring_ctx *ctx,
> > +                               struct io_buf_table *table)
> > +{
> > +       io_rsrc_data_free(ctx, &table->data);
> > +       io_alloc_cache_free(&table->node_cache, kfree);
> > +       io_alloc_cache_free(&table->imu_cache, kfree);
> > +}
> > +
> >  int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
> >  {
> >         if (!ctx->buf_table.data.nr)
> >                 return -ENXIO;
> > -       io_rsrc_data_free(ctx, &ctx->buf_table.data);
> > +       io_rsrc_buffer_free(ctx, &ctx->buf_table);
> >         return 0;
> >  }
> >
> > @@ -716,6 +767,15 @@ bool io_check_coalesce_buffer(struct page **page_a=
rray, int nr_pages,
> >         return true;
> >  }
> >
> > +static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
> > +                                          int nr_bvecs)
> > +{
> > +       if (nr_bvecs <=3D IO_CACHED_BVECS_SEGS)
> > +               return io_cache_alloc(&ctx->buf_table.imu_cache, GFP_KE=
RNEL);
>
> If there is no entry available in the cache, this will heap-allocate
> one with enough space for all IO_CACHED_BVECS_SEGS bvecs. Consider
> using io_alloc_cache_get() instead of io_cache_alloc(), so the
> heap-allocated fallback uses the minimal size.
>
> Also, where are these allocations returned to the imu_cache? Looks
> like kvfree(imu) in io_buffer_unmap() and io_sqe_buffer_register()
> needs to try io_alloc_cache_put() first.

Another issue I see is that io_alloc_cache elements are allocated with
kmalloc(), so they can't be freed with kvfree(). When the imu is
freed, we could check nr_bvecs <=3D IO_CACHED_BVECS_SEGS to tell whether
to call io_alloc_cache_put() (with a fallback to kfree()) or kvfree().

>
> Best,
> Caleb
>
> > +       return kvmalloc(struct_size_t(struct io_mapped_ubuf, bvec, nr_b=
vecs),
> > +                       GFP_KERNEL);
> > +}
> > +
> >  static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx =
*ctx,
> >                                                    struct iovec *iov,
> >                                                    struct page **last_h=
page)
> > @@ -732,7 +792,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(=
struct io_ring_ctx *ctx,
> >         if (!iov->iov_base)
> >                 return NULL;
> >
> > -       node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
> > +       node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
> >         if (!node)
> >                 return ERR_PTR(-ENOMEM);
> >         node->buf =3D NULL;
> > @@ -752,7 +812,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(=
struct io_ring_ctx *ctx,
> >                         coalesced =3D io_coalesce_buffer(&pages, &nr_pa=
ges, &data);
> >         }
> >
> > -       imu =3D kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
> > +       imu =3D io_alloc_imu(ctx, nr_pages);
> >         if (!imu)
> >                 goto done;
> >
> > @@ -800,9 +860,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx=
, void __user *arg,
> >                             unsigned int nr_args, u64 __user *tags)
> >  {
> >         struct page *last_hpage =3D NULL;
> > -       struct io_rsrc_data data;
> >         struct iovec fast_iov, *iov =3D &fast_iov;
> >         const struct iovec __user *uvec;
> > +       struct io_buf_table table;
> >         int i, ret;
> >
> >         BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >=3D (1u << 16));
> > @@ -811,13 +871,14 @@ int io_sqe_buffers_register(struct io_ring_ctx *c=
tx, void __user *arg,
> >                 return -EBUSY;
> >         if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
> >                 return -EINVAL;
> > -       ret =3D io_rsrc_data_alloc(&data, nr_args);
> > +       ret =3D io_rsrc_buffer_alloc(&table, nr_args);
> >         if (ret)
> >                 return ret;
> >
> >         if (!arg)
> >                 memset(iov, 0, sizeof(*iov));
> >
> > +       ctx->buf_table =3D table;
> >         for (i =3D 0; i < nr_args; i++) {
> >                 struct io_rsrc_node *node;
> >                 u64 tag =3D 0;
> > @@ -857,10 +918,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ct=
x, void __user *arg,
> >                         }
> >                         node->tag =3D tag;
> >                 }
> > -               data.nodes[i] =3D node;
> > +               table.data.nodes[i] =3D node;
> >         }
> > -
> > -       ctx->buf_table.data =3D data;
>
> Is it necessary to move this assignment? I found the existing location
> easier to reason about, since the assignment of ctx->buf_table
> represents a transfer of ownership from the local variable.
>
> >         if (ret)
> >                 io_sqe_buffers_unregister(ctx);
> >         return ret;
> > @@ -891,14 +950,15 @@ int io_buffer_register_bvec(struct io_ring_ctx *c=
tx, struct request *rq,
> >                 goto unlock;
> >         }
> >
> > -       node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
> > +       node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
> >         if (!node) {
> >                 ret =3D -ENOMEM;
> >                 goto unlock;
> >         }
> >
> >         nr_bvecs =3D blk_rq_nr_phys_segments(rq);
> > -       imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
> > +
> > +       imu =3D io_alloc_imu(ctx, nr_bvecs);
> >         if (!imu) {
> >                 kfree(node);
> >                 ret =3D -ENOMEM;
> > @@ -1028,7 +1088,7 @@ static void lock_two_rings(struct io_ring_ctx *ct=
x1, struct io_ring_ctx *ctx2)
> >  static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ct=
x *src_ctx,
> >                             struct io_uring_clone_buffers *arg)
> >  {
> > -       struct io_rsrc_data data;
> > +       struct io_buf_table table;
> >         int i, ret, off, nr;
> >         unsigned int nbufs;
> >
> > @@ -1059,7 +1119,7 @@ static int io_clone_buffers(struct io_ring_ctx *c=
tx, struct io_ring_ctx *src_ctx
> >         if (check_add_overflow(arg->nr, arg->dst_off, &nbufs))
> >                 return -EOVERFLOW;
> >
> > -       ret =3D io_rsrc_data_alloc(&data, max(nbufs, ctx->buf_table.dat=
a.nr));
> > +       ret =3D io_rsrc_buffer_alloc(&table, max(nbufs, ctx->buf_table.=
data.nr));
> >         if (ret)
> >                 return ret;
> >
> > @@ -1068,7 +1128,7 @@ static int io_clone_buffers(struct io_ring_ctx *c=
tx, struct io_ring_ctx *src_ctx
> >                 struct io_rsrc_node *src_node =3D ctx->buf_table.data.n=
odes[i];
> >
> >                 if (src_node) {
> > -                       data.nodes[i] =3D src_node;
> > +                       table.data.nodes[i] =3D src_node;
> >                         src_node->refs++;
> >                 }
> >         }
> > @@ -1098,7 +1158,7 @@ static int io_clone_buffers(struct io_ring_ctx *c=
tx, struct io_ring_ctx *src_ctx
> >                 if (!src_node) {
> >                         dst_node =3D NULL;
> >                 } else {
> > -                       dst_node =3D io_rsrc_node_alloc(IORING_RSRC_BUF=
FER);
> > +                       dst_node =3D io_rsrc_node_alloc(ctx, IORING_RSR=
C_BUFFER);
> >                         if (!dst_node) {
> >                                 ret =3D -ENOMEM;
> >                                 goto out_free;
> > @@ -1107,12 +1167,12 @@ static int io_clone_buffers(struct io_ring_ctx =
*ctx, struct io_ring_ctx *src_ctx
> >                         refcount_inc(&src_node->buf->refs);
> >                         dst_node->buf =3D src_node->buf;
> >                 }
> > -               data.nodes[off++] =3D dst_node;
> > +               table.data.nodes[off++] =3D dst_node;
> >                 i++;
> >         }
> >
> >         /*
> > -        * If asked for replace, put the old table. data->nodes[] holds=
 both
> > +        * If asked for replace, put the old table. table.data->nodes[]=
 holds both
> >          * old and new nodes at this point.
> >          */
> >         if (arg->flags & IORING_REGISTER_DST_REPLACE)
> > @@ -1125,10 +1185,10 @@ static int io_clone_buffers(struct io_ring_ctx =
*ctx, struct io_ring_ctx *src_ctx
> >          * entry).
> >          */
> >         WARN_ON_ONCE(ctx->buf_table.data.nr);
> > -       ctx->buf_table.data =3D data;
> > +       ctx->buf_table =3D table;
> >         return 0;
> >  out_free:
> > -       io_rsrc_data_free(ctx, &data);
> > +       io_rsrc_buffer_free(ctx, &table);
> >         return ret;
> >  }
> >
> > diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> > index 2e8d1862caefc..c5bdac558a2b4 100644
> > --- a/io_uring/rsrc.h
> > +++ b/io_uring/rsrc.h
> > @@ -47,7 +47,7 @@ struct io_imu_folio_data {
> >         unsigned int    nr_folios;
> >  };
> >
> > -struct io_rsrc_node *io_rsrc_node_alloc(int type);
> > +struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int t=
ype);
> >  void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *n=
ode);
> >  void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *d=
ata);
> >  int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
> > --
> > 2.43.5
> >
> >

