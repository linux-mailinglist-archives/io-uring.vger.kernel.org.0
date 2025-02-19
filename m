Return-Path: <io-uring+bounces-6544-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D00D3A3AF2A
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 02:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 42EE47A594A
	for <lists+io-uring@lfdr.de>; Wed, 19 Feb 2025 01:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA89916F271;
	Wed, 19 Feb 2025 01:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KvMkFIH7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A23715A85E
	for <io-uring@vger.kernel.org>; Wed, 19 Feb 2025 01:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739930083; cv=none; b=ToaKW/0v8n3COpydaJbBTxjKAEeI07TjWeFVUdbMbE+HuOhlLlcoIANsWKlReJ6cQQ/GiCcT7LeYNpXyNttwkR/OYiW/TvbNuLCZkqoraAO6ILb3i1YNPdjkIlbNwNJu4+8QNFljCD7LCspRkdtJmZIdiGTBt0D1j6LJfTws90Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739930083; c=relaxed/simple;
	bh=8/hfXO449WSDVbol+F/ESurvbzf3WmqNj2Id0qu6zZU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FG8cwzzXN4+Cc92oShyIQgbKnVPuqNMTeAlqOzcuXvNIhorH7KK9MhM7LY8pWX8l1NJmv5AhGU34ABCvrRc++lZl4vcZ/yhYYNdEhniLzmvTSYm+4YLKMtEjMYTv45oHqcMRSJvtFyX7OHziBNRvd+NWwgaDXltOtYHuVyPWV5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KvMkFIH7; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2fbfa7100b0so1483767a91.0
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 17:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739930081; x=1740534881; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ecHf4Kg+nvRXPelHPpLQjLKqrLarenTbPMDdtNWdGg=;
        b=KvMkFIH7vbWZ7RGAOid3Z6siXZBnss6opmidT3FzTQCabMxWImWfalhxSW0eUXZKUb
         1ejL5fj+D7X+wQly3EEn61gsnzl/nT/kKWox2F1gnU+WOXSTj2N/PI+zDqTLFXbtXFFF
         XSblnOAxj7qdRYNmym4lx0xPKez8v3u2oshMX7R+593JF6ZEx/1YytP/XwSruM0a4yXh
         0Mqv2W8Qz2usmnlLLVnlNsPFxbTEXxnJdIMn1pOmKyRVAz+8FjaXQzkbyCoB2e8lo52B
         IiTsoT3S1ZQhB0ZzhBmhJ7JFzDcf+Cg5ugZG6POrt3JpBpnae23PVs0OAtRbqsdGBYnS
         e50Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739930081; x=1740534881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ecHf4Kg+nvRXPelHPpLQjLKqrLarenTbPMDdtNWdGg=;
        b=GZT2LBLjDuNJfbaDEIWPMVY8rPHy/XKTgWPvc+RjpiQvEYpW5YDJ5Fsg4vfE4v6Du6
         qk3lCRNKjQQP4z3T0LHGB0G6s6CePj3cT44DO60qr1hicDtUun0QtCrV/8pK4djKJLw+
         RQ+OaL5luIsxhkqWUcS0np6CLPaGfTni7N68KzleW603bP2DJPR71v69CRMlJkdeOL7r
         BhxrQw+QZlkmbEjV8KKkn6DNQnNijkvGYzTCt7R6HvdC3dWh9AUO3GrvNvmyLFwbc+t3
         YpJe5q3B4nyDtj9yvvspYH4zPiEYDb4L0QLxS8L0qwY7XqWfSE49XI9Rz+D5DIOemqo8
         4bQg==
X-Forwarded-Encrypted: i=1; AJvYcCXr7GrnD6zar3tvZYZKaFZXLS1CXN3KU0SAIJyYCqnR4+FDB3W8WZvs0hrO0mS/xMDRlmchhfxlPw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxqIm6XJ264uXt6EJZeNq6hxqkYr7AObGKZy/Wxo/xkU6HX/xL0
	N69sIFRU0prfr1jidSaFt6SdQTGXFOxgrarZbHxyFFkzvDxnn0124z/wg5E/RQvMfP7HjO33EvA
	a9FUKpJwZA3h8l+GGrfA0BxpTSH78UY0rMEI/WA==
X-Gm-Gg: ASbGnct+l3v3zR0reqVNL2wYAqaNAvsz06XHIR5jtL7/ygcHkUkwLEIqwnhUZNlbOE4
	Soyz6CyoVvk4vZRMx1bR7Jf+qScBMQfRGm3U7KP+FALBkWyIYta+VCWxw41SOUyQMHVDs6zM=
X-Google-Smtp-Source: AGHT+IEwbg5bOHfptE2y67+mZSB25ezntxcVOFwyaLv8PZNgvjDQhvnAwD2wd1IHYXW/VmO474O7Flv3pi2Oy3hu0k8=
X-Received: by 2002:a17:90b:2d85:b0:2ee:e518:c1d4 with SMTP id
 98e67ed59e1d1-2fc40d157e2mr9899598a91.1.1739930080582; Tue, 18 Feb 2025
 17:54:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250218224229.837848-1-kbusch@meta.com> <20250218224229.837848-3-kbusch@meta.com>
In-Reply-To: <20250218224229.837848-3-kbusch@meta.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 18 Feb 2025 17:54:28 -0800
X-Gm-Features: AWEUYZlHnLF1HwvHKvRMkYz96-1KPkahdCn4g4Jndu12xS43JhKpnZtHmXzQUA4
Message-ID: <CADUfDZr=8VPEtftPtqaQdr5hjsM4w_iADEAL6Xp06kk42nZfVg@mail.gmail.com>
Subject: Re: [PATCHv4 2/5] io_uring: add support for kernel registered bvecs
To: Keith Busch <kbusch@meta.com>
Cc: ming.lei@redhat.com, asml.silence@gmail.com, axboe@kernel.dk, 
	linux-block@vger.kernel.org, io-uring@vger.kernel.org, bernd@bsbernd.com, 
	Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025 at 2:42=E2=80=AFPM Keith Busch <kbusch@meta.com> wrote=
:
>
> From: Keith Busch <kbusch@kernel.org>
>
> Provide an interface for the kernel to leverage the existing
> pre-registered buffers that io_uring provides. User space can reference
> these later to achieve zero-copy IO.
>
> User space must register an empty fixed buffer table with io_uring in
> order for the kernel to make use of it.
>
> Signed-off-by: Keith Busch <kbusch@kernel.org>
> ---
>  include/linux/io_uring.h       |   1 +
>  include/linux/io_uring_types.h |   6 ++
>  io_uring/rsrc.c                | 115 ++++++++++++++++++++++++++++++---
>  io_uring/rsrc.h                |   4 ++
>  4 files changed, 118 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> index 85fe4e6b275c7..b5637a2aae340 100644
> --- a/include/linux/io_uring.h
> +++ b/include/linux/io_uring.h
> @@ -5,6 +5,7 @@
>  #include <linux/sched.h>
>  #include <linux/xarray.h>
>  #include <uapi/linux/io_uring.h>
> +#include <linux/blk-mq.h>

Should this be added to the header file that declares
io_buffer_register_bvec() instead?

>
>  #if defined(CONFIG_IO_URING)
>  void __io_uring_cancel(bool cancel_all);
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 0bcaefc4ffe02..2aed51e8c79ee 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -709,4 +709,10 @@ static inline bool io_ctx_cqe32(struct io_ring_ctx *=
ctx)
>         return ctx->flags & IORING_SETUP_CQE32;
>  }
>
> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
> +                           void (*release)(void *), unsigned int index,
> +                           unsigned int issue_flags);
> +void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int ind=
ex,
> +                              unsigned int issue_flags);

Hmm, io_uring_types.h seems like a strange place for these. The rest
of this file consists of types and inline functions. Maybe
io_uring/rsrc.h would make more sense?

> +
>  #endif
> diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> index 20b884c84e55f..88bcacc77b72e 100644
> --- a/io_uring/rsrc.c
> +++ b/io_uring/rsrc.c
> @@ -103,19 +103,23 @@ int io_buffer_validate(struct iovec *iov)
>
>  static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node=
 *node)
>  {
> -       unsigned int i;
> +       struct io_mapped_ubuf *imu =3D node->buf;
>
> -       if (node->buf) {
> -               struct io_mapped_ubuf *imu =3D node->buf;
> +       if (!refcount_dec_and_test(&imu->refs))
> +               return;
> +
> +       if (imu->release) {
> +               imu->release(imu->priv);
> +       } else {
> +               unsigned int i;
>
> -               if (!refcount_dec_and_test(&imu->refs))
> -                       return;
>                 for (i =3D 0; i < imu->nr_bvecs; i++)
>                         unpin_user_page(imu->bvec[i].bv_page);
>                 if (imu->acct_pages)
>                         io_unaccount_mem(ctx, imu->acct_pages);
> -               kvfree(imu);
>         }
> +
> +       kvfree(imu);
>  }
>
>  struct io_rsrc_node *io_rsrc_node_alloc(int type)
> @@ -764,6 +768,10 @@ static struct io_rsrc_node *io_sqe_buffer_register(s=
truct io_ring_ctx *ctx,
>         imu->len =3D iov->iov_len;
>         imu->nr_bvecs =3D nr_pages;
>         imu->folio_shift =3D PAGE_SHIFT;
> +       imu->release =3D NULL;
> +       imu->priv =3D NULL;
> +       imu->readable =3D true;
> +       imu->writeable =3D true;
>         if (coalesced)
>                 imu->folio_shift =3D data.folio_shift;
>         refcount_set(&imu->refs, 1);
> @@ -860,6 +868,87 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx,=
 void __user *arg,
>         return ret;
>  }
>
> +int io_buffer_register_bvec(struct io_ring_ctx *ctx, struct request *rq,
> +                           void (*release)(void *), unsigned int index,
> +                           unsigned int issue_flags)
> +{
> +       struct io_rsrc_data *data =3D &ctx->buf_table;
> +       struct req_iterator rq_iter;
> +       struct io_mapped_ubuf *imu;
> +       struct io_rsrc_node *node;
> +       struct bio_vec bv, *bvec;
> +       int ret =3D 0;
> +       u16 nr_bvecs;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       if (io_rsrc_node_lookup(data, index)) {
> +               ret =3D -EBUSY;
> +               goto unlock;
> +       }
> +
> +       node =3D io_rsrc_node_alloc(IORING_RSRC_BUFFER);
> +       if (!node) {
> +               ret =3D -ENOMEM;
> +               goto unlock;
> +       }
> +
> +       nr_bvecs =3D blk_rq_nr_phys_segments(rq);
> +       imu =3D kvmalloc(struct_size(imu, bvec, nr_bvecs), GFP_KERNEL);
> +       if (!imu) {
> +               kfree(node);
> +               ret =3D -ENOMEM;
> +               goto unlock;
> +       }
> +
> +       imu->ubuf =3D 0;
> +       imu->len =3D blk_rq_bytes(rq);
> +       imu->acct_pages =3D 0;
> +       imu->folio_shift =3D PAGE_SHIFT;
> +       imu->nr_bvecs =3D nr_bvecs;
> +       refcount_set(&imu->refs, 1);
> +       imu->release =3D release;
> +       imu->priv =3D rq;
> +
> +       if (rq_data_dir(rq))

Check rq_data_dir(rq) =3D=3D WRITE instead to avoid depending on the value
of READ/WRITE?

> +               imu->writeable =3D true;
> +       else
> +               imu->readable =3D true;
> +
> +       bvec =3D imu->bvec;
> +       rq_for_each_bvec(bv, rq, rq_iter)
> +               *bvec++ =3D bv;
> +
> +       node->buf =3D imu;
> +       data->nodes[index] =3D node;
> +unlock:
> +       io_ring_submit_unlock(ctx, issue_flags);
> +       return ret;
> +}
> +EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
> +
> +void io_buffer_unregister_bvec(struct io_ring_ctx *ctx, unsigned int ind=
ex,
> +                              unsigned int issue_flags)
> +{
> +       struct io_rsrc_data *data =3D &ctx->buf_table;
> +       struct io_rsrc_node *node;
> +
> +       io_ring_submit_lock(ctx, issue_flags);
> +
> +       if (!data->nr)
> +               goto unlock;
> +
> +       node =3D io_rsrc_node_lookup(data, index);
> +       if (!node || !node->buf->release)
> +               goto unlock;

Still think the data->nr check is unnecessary, since
io_rsrc_node_lookup() would return NULL in that case.

> +
> +       io_put_rsrc_node(ctx, node);
> +       data->nodes[index] =3D NULL;
> +unlock:
> +       io_ring_submit_unlock(ctx, issue_flags);
> +}
> +EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
> +
>  int io_import_fixed(int ddir, struct iov_iter *iter,
>                            struct io_mapped_ubuf *imu,
>                            u64 buf_addr, size_t len)
> @@ -874,6 +963,9 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>         /* not inside the mapped region */
>         if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->=
len)))
>                 return -EFAULT;
> +       if ((ddir =3D=3D READ && !imu->readable) ||
> +           (ddir =3D=3D WRITE && !imu->writeable))
> +               return -EFAULT;

This could be made less branchy by storing a bitmask of allowed data
transfer directions instead of 2 bool fields. Then this could just be:
if (!(imu->ddirs >> ddir & 1)
        return -EFAULT;

Best,
Caleb

>
>         /*
>          * Might not be a start of buffer, set size appropriately
> @@ -886,8 +978,8 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>                 /*
>                  * Don't use iov_iter_advance() here, as it's really slow=
 for
>                  * using the latter parts of a big fixed buffer - it iter=
ates
> -                * over each segment manually. We can cheat a bit here, b=
ecause
> -                * we know that:
> +                * over each segment manually. We can cheat a bit here fo=
r user
> +                * registered nodes, because we know that:
>                  *
>                  * 1) it's a BVEC iter, we set it up
>                  * 2) all bvecs are the same in size, except potentially =
the
> @@ -901,8 +993,15 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
>                  */
>                 const struct bio_vec *bvec =3D imu->bvec;
>
> +               /*
> +                * Kernel buffer bvecs, on the other hand, don't necessar=
ily
> +                * have the size property of user registered ones, so we =
have
> +                * to use the slow iter advance.
> +                */
>                 if (offset < bvec->bv_len) {
>                         iter->iov_offset =3D offset;
> +               } else if (imu->release) {
> +                       iov_iter_advance(iter, offset);
>                 } else {
>                         unsigned long seg_skip;
>
> diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
> index abf86b5b86140..81c31b93d4f7b 100644
> --- a/io_uring/rsrc.h
> +++ b/io_uring/rsrc.h
> @@ -33,6 +33,10 @@ struct io_mapped_ubuf {
>         unsigned int    folio_shift;
>         refcount_t      refs;
>         unsigned long   acct_pages;
> +       void            (*release)(void *);
> +       void            *priv;
> +       bool            readable;
> +       bool            writeable;
>         struct bio_vec  bvec[] __counted_by(nr_bvecs);
>  };
>
> --
> 2.43.5
>

