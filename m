Return-Path: <io-uring+bounces-11035-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BE480CBA507
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 06:24:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 462CD3017660
	for <lists+io-uring@lfdr.de>; Sat, 13 Dec 2025 05:24:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA2E8C8CE;
	Sat, 13 Dec 2025 05:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M79Xklev"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211C142048
	for <io-uring@vger.kernel.org>; Sat, 13 Dec 2025 05:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765603474; cv=none; b=rR6LJmhcYOrFAveWPAC6uerAwGiVhEjwCAO5KrY0SDSBP683DD9by8Gps6T1Xk0MjnX9e7Tpi1+gAa0u6kNhVJ79IfMsnXsOJg7j6VnZJ/QoejG0p59nQbrn6LSuncuXO5iD+3g7LXpi0I5w+edMOs2TZ6KgdwO7cXzDz6HVXyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765603474; c=relaxed/simple;
	bh=p0ihfBKxNQ/dXhNYmbPH0tkoC0aKhxRkFsz1VwGN8k0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GmNpWw8VvkFoyZnTyrBSQtfkI19rNdtdqOIIJTQKNKuqanu5gKIoAYIe2gpIjmJKN4v/LGKNnOeYmf3KW4DKFBH8/9I6LSEhVdpSMmqT6JgzCNmkhjlXU1hzZMRIfndpv473MecvL6ysM4xXBdV8q4D66hZPTNaNJxGJOY9iPWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M79Xklev; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ee1879e6d9so20781301cf.1
        for <io-uring@vger.kernel.org>; Fri, 12 Dec 2025 21:24:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765603471; x=1766208271; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VigbIS//R0nyPsPtEYVz7fs0H7aC/NGMCSfIuBXsJFE=;
        b=M79XklevIm4TLubkNTTaBmgfcu3uf5qiyyG4yIsv2KKJdtn4IJO9Q8k3L+R4X6MI/S
         2mIEO6ToLDR8y8uWCeubpUnQSpXwoSut9X7OTQeG7rXpuJO+BG0hlO7KrZ2fb98qX0OS
         JAWdj8g8APT8Nv1fFHb3QMTyUrOR7Yv7b6oheQsn1FmMnguABVIzH3eWVa3NFk0wCma0
         TKqIdEuj3VUrafI4emIsTW32GCTTE6hjZwfVIGudd4BlTrR7XXltSQBgQIgFxRNorTCy
         xaBTcLsrtGvHqy9wyZqEyRBEAdDy/JG4A7RnfwrVN3V/QWADaRv+Uo9hJQ9/i/Lokct5
         qZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765603471; x=1766208271;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VigbIS//R0nyPsPtEYVz7fs0H7aC/NGMCSfIuBXsJFE=;
        b=sULMkTPqHYktOd7Fv6XeBl/MKOu8DT/l3EeYnSpOq5fjyzwzhoEWfqlBN/wCjwp7vY
         g88UAkDUHItG3FizndfTkUlRGDKe13vLzbGlPZeTwajYGdVlHmR3PZrzbUp0dcycAO13
         hF1TLqESS6SoZmy17/hK6raHpFoDEw7AroqzyNLvG74PUmwceEu5/T53GuD8ry1eHrue
         gRiw2eSETtF63GYknsWiASrqK4Med3w0p9IarYNhAaSgSsZz+qt6XxfiXMJLGrtAsDe6
         sY7iiTPPAzOAgv5f4LnsMqZyx8PGaFfxKrOt2kF64f37Db0U9dvaedCWOVIdOl6mDKTy
         3YQg==
X-Forwarded-Encrypted: i=1; AJvYcCXjxu6tY2yTqwJ3x06YRCBhwDcOnI4wLJaBVwHLU5X4W5QBaIarv9xiofMhNJsFYCrk6/Lyzd3YVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwqWHofFIPhPurKK/y4mEFHYeKlPCucbjoH6RdwrvRt+++zUxbQ
	Ev/u/Cg/i/6TdtSPtfDc4I73uROjXsG/7NklMf3T9rwPuP8InZfw92POSASt1bQXZxuVSkghiVZ
	CqwLWsY4ecpHTylwi2Vzf9KOXlkbgZR8=
X-Gm-Gg: AY/fxX4xZpZowewFxeRlyR8veQyBRlvs4xyNs62C2IFowpVYh0+4Q05aitYrM+m3xM5
	TPcFoR9EKVQNWxMNSdSKXAZzy9p71B9S/nWVGmz345BCaOa5RRkHpMykQpMSLglbhDU/kL9SeFn
	vi5X/7HDB/4Re7NjZHE7ctfWu/8E7f/ko+IqoepMxOtjqclL5YNEQDE6Q38D8R5PyQ0piEo3Rgw
	prrjkCyWEhfpUUpWfAGbjjRNRkrQBnSYkxpuWfreV1SXFi0oZi1ybPCH867V3ZlPOYbG+dN
X-Google-Smtp-Source: AGHT+IHhDtD3F9EABMpYjCF7m0D2s3ELlaiM8QN37aYREirOU5MLzVFhcMGb/KS/rXYL0pcXq4l730TrnQe9Kgaz+zc=
X-Received: by 2002:a05:622a:1ba4:b0:4ee:bbb:ba73 with SMTP id
 d75a77b69052e-4f1d05aed1cmr59523021cf.42.1765603470984; Fri, 12 Dec 2025
 21:24:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-24-joannelkoong@gmail.com> <CADUfDZp9u8D8shxK1BQ=O4cMWeE7w4wrvfY7Xdr0=_vAEgvJZQ@mail.gmail.com>
In-Reply-To: <CADUfDZp9u8D8shxK1BQ=O4cMWeE7w4wrvfY7Xdr0=_vAEgvJZQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Sat, 13 Dec 2025 14:24:20 +0900
X-Gm-Features: AQt7F2ohupli07-5KesmF7RsP6qotGpWTyRpcfAdEw7wUe9fk0muRX8oZBj-_DM
Message-ID: <CAJnrk1ZKX+0Zph-aEOnRL0MmCxyEvt4u6EOUyiHVOhv98wUU8A@mail.gmail.com>
Subject: Re: [PATCH v1 23/30] io_uring/rsrc: split io_buffer_register_request()
 logic
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 7, 2025 at 5:42=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Tue, Dec 2, 2025 at 4:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > Split the main initialization logic in io_buffer_register_request() int=
o
> > a helper function.
> >
> > This is a preparatory patch for supporting kernel-populated buffers in
> > fuse io-uring, which will be reusing this logic.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  io_uring/rsrc.c | 80 +++++++++++++++++++++++++++++--------------------
> >  1 file changed, 48 insertions(+), 32 deletions(-)
> >
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 59cafe63d187..18abba6f6b86 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -941,63 +941,79 @@ int io_sqe_buffers_register(struct io_ring_ctx *c=
tx, void __user *arg,
> >         return ret;
> >  }
> >
> > -int io_buffer_register_request(struct io_ring_ctx *ctx, struct request=
 *rq,
> > -                              void (*release)(void *), unsigned int in=
dex,
> > -                              unsigned int issue_flags)
> > +static int io_buffer_init(struct io_ring_ctx *ctx, unsigned int nr_bve=
cs,
>
> Consider adding "kernel" somewhere in the name to distinguish this
> from the userspace registered buffer initialization

I can rename this to io_kernel_buffer_init().

>
> > +                         unsigned int total_bytes, u8 dir,
> > +                         void (*release)(void *), void *priv,
> > +                         unsigned int index)
> >  {
> >         struct io_rsrc_data *data =3D &ctx->buf_table;
> > -       struct req_iterator rq_iter;
> >         struct io_mapped_ubuf *imu;
> >         struct io_rsrc_node *node;
> > -       struct bio_vec bv;
> > -       unsigned int nr_bvecs =3D 0;
> > -       int ret =3D 0;
> >
> > -       io_ring_submit_lock(ctx, issue_flags);
> > -       if (index >=3D data->nr) {
> > -               ret =3D -EINVAL;
> > -               goto unlock;
> > -       }
> > +       if (index >=3D data->nr)
> > +               return -EINVAL;
> >         index =3D array_index_nospec(index, data->nr);
> >
> > -       if (data->nodes[index]) {
> > -               ret =3D -EBUSY;
> > -               goto unlock;
> > -       }
> > +       if (data->nodes[index])
> > +               return -EBUSY;
> >
> >         node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
> > -       if (!node) {
> > -               ret =3D -ENOMEM;
> > -               goto unlock;
> > -       }
> > +       if (!node)
> > +               return -ENOMEM;
> >
> > -       /*
> > -        * blk_rq_nr_phys_segments() may overestimate the number of bve=
cs
> > -        * but avoids needing to iterate over the bvecs
> > -        */
> > -       imu =3D io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
> > +       imu =3D io_alloc_imu(ctx, nr_bvecs);
> >         if (!imu) {
> >                 kfree(node);
> > -               ret =3D -ENOMEM;
> > -               goto unlock;
> > +               return -ENOMEM;
> >         }
> >
> >         imu->ubuf =3D 0;
> > -       imu->len =3D blk_rq_bytes(rq);
> > +       imu->len =3D total_bytes;
> >         imu->acct_pages =3D 0;
> >         imu->folio_shift =3D PAGE_SHIFT;
> > +       imu->nr_bvecs =3D nr_bvecs;
> >         refcount_set(&imu->refs, 1);
> >         imu->release =3D release;
> > -       imu->priv =3D rq;
> > +       imu->priv =3D priv;
> >         imu->is_kbuf =3D true;
> > -       imu->dir =3D 1 << rq_data_dir(rq);
> > +       imu->dir =3D 1 << dir;
> > +
> > +       node->buf =3D imu;
> > +       data->nodes[index] =3D node;
> > +
> > +       return 0;
> > +}
> > +
> > +int io_buffer_register_request(struct io_ring_ctx *ctx, struct request=
 *rq,
> > +                              void (*release)(void *), unsigned int in=
dex,
> > +                              unsigned int issue_flags)
> > +{
> > +       struct req_iterator rq_iter;
> > +       struct io_mapped_ubuf *imu;
> > +       struct bio_vec bv;
> > +       unsigned int nr_bvecs;
> > +       unsigned int total_bytes;
> > +       int ret;
> > +
> > +       io_ring_submit_lock(ctx, issue_flags);
> > +
> > +       /*
> > +        * blk_rq_nr_phys_segments() may overestimate the number of bve=
cs
> > +        * but avoids needing to iterate over the bvecs
> > +        */
> > +       nr_bvecs =3D blk_rq_nr_phys_segments(rq);
> > +       total_bytes =3D blk_rq_bytes(rq);
>
> These could be initialized before io_ring_submit_lock()
>
> > +       ret =3D io_buffer_init(ctx, nr_bvecs, total_bytes, rq_data_dir(=
rq), release, rq,
> > +                            index);
> > +       if (ret)
> > +               goto unlock;
> >
> > +       imu =3D ctx->buf_table.nodes[index]->buf;
>
> It would be nice to avoid all these additional dereferences. Could
> io_buffer_init() return the struct io_mapped_ubuf *, using ERR_PTR()
> to return any error code?

I'll make this change for v2.

Thanks,
Joanne
>
> Best,
> Caleb

