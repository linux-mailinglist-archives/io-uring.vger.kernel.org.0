Return-Path: <io-uring+bounces-11044-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A3471CBF309
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 18:16:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 021873026206
	for <lists+io-uring@lfdr.de>; Mon, 15 Dec 2025 17:10:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C78E33F369;
	Mon, 15 Dec 2025 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="BmiTTWlC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07B1330B04
	for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765818575; cv=none; b=h+rn+a6UrGQ8umPjCrR8SUYthOH8Nafc3J+VmJhYc1uWp3YQd28YTh52eQ5LLEQxXs+IVAntOTTiTiOCFUPNZR3eGrQ1I4DL4/FMoG7qCAf0+Uk8z6y2Rewys3GyHIoAI0tdV+WBojTb+dFT3jRFy8dP/vuHkNiaVNH7xeDW6ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765818575; c=relaxed/simple;
	bh=EcLUN7JsuZp7IcMNJG274sRBHNSkKP3j5R3furYhVP0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P7/prpgNQuRC1cFCCvgKjIo93KzdX/iqBKuIdjc2O9qK+94c9l8bIPPV+8Pxdn22MwsaI5h4Vh2kwmQmm2V/cyBgv4YdZVNn9FbhD8MYbQUX6Z88ULjjItDSn6zNv5gaTtTONKdRyfxSuKMkytNOb4D2xZy4aKa78Xu0qJh5YaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=BmiTTWlC; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7ab689d3fa0so233340b3a.0
        for <io-uring@vger.kernel.org>; Mon, 15 Dec 2025 09:09:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1765818570; x=1766423370; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ASVvbfD82BAL0H1TKwt6lpQuFeFB3qVzeqINvcQI01o=;
        b=BmiTTWlCnffKlzzgdIbd1cT//WPSNybkhLcgt5aGUN3ZeVb2Uw2gC/GaGIHvEj6b7H
         0omRCVajqmDG9MaHmtERqNo2DhE4FH91kV/DL9BMugjMt9Ke3LmHPS/TJjnB0l+A/uH2
         ipAzXQk2MqB6FoPG/hIm1EJkVQRmOkTG06ZwyON6ZQPJkz/qRUzKW6Ejfhj9DCka+o1M
         pNs9uw3qRt+j+HlGekUDvZZOu7NyEUq/eXJqwTRdB2vUMN0X4G57s6qC+lYL/0B8nUAz
         m7w4cOus4fBDXWi38rtHSZVG/kXu8a6Mczc7tTU0AE8gRbJ+01dBYwox2nfSpMKxXJdQ
         7cDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765818570; x=1766423370;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ASVvbfD82BAL0H1TKwt6lpQuFeFB3qVzeqINvcQI01o=;
        b=qv3OmdohqfmZ5CKvZ1lP8X02kc8PMaj2Z/BdVJEEfAMgULLl+wTV4SvlgAZDRk0/52
         LwZKact2Mpptt1pX89zQNwB1X5h+Esgdenli/oYKoXQTsNv7L/V0iKw699JbzmTgn/NP
         2OhAukdOpWRTsFZvEBA2oFZM3prHpLTXHXOs4Lg+BRZE0B68DH6os9Tmm4eKWEP94Xzl
         TOl+CmCaZq86xREvL/Qn+QkLelODPpt9WVve/eH2A3JVUigllw8Zwbwxbs/9hBdKzjmp
         XDUgOcLcZo7f4a0CbT2UYTaN/YnpnnnHqnVopM9bAQ9pLtmWbOGL5Dt0Pl3ZiuQHrE0y
         AKDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr2GJE3bmnQvaRD5f0+oDnau9Sz5TpOWXNDvnKvhQC9816SAFViduHd6c/JeOETfNLv4Qk2SCWJA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyocmYOIw6vuk8V3Oo4+V+EF0p8KG9w4zoeqlAyiHvYDWpwgXr3
	1kyA0nwBsHtIiSTm95qqxLxYXHYiCU/TQ5N+arZ+Pmj3M1/WY0P3y6DevKKWM7ME/noREczV8m2
	PK14gDgj5/PqBxe8SXYEapU7LY0H9MGw2yQAfTdlXug==
X-Gm-Gg: AY/fxX6fvN71e+QXxSasrFAR6eqsvkB14uoPJH4hrc2MAxi9al4+tc49rP8JaKE5rO/
	1VmXDzb68VlWOA7BriRh+nK7pHhYbkuL/h1OdTitbZ1h5HzrkAjYOILJM5MSZ/IYRR1+GrCKDZd
	WH4P5DpEFUPgcphzhh46zSseYquwkddvqqSVHN2iD+h0CnhCQoWmMjuz9t9yhnQCnosF+BlTuug
	Dvr9lCEbgaOr5kdjh9JtU6nOpRomrb/Op4WO3mOkO+jL3zsEmuyLZjfpahAD+T1OLx8+2/+
X-Google-Smtp-Source: AGHT+IFAqA4DZWkfxFs7HDuQy/beTvT/9R8F/vzjf8WRuDj3pqoLZEG3Ynp2bNIFaQ/hH8W0/m7XZc3gfoRsz9HC97k=
X-Received: by 2002:a05:7022:b8a:b0:11b:acd7:4e48 with SMTP id
 a92af1059eb24-11f34bd3b7bmr5659494c88.2.1765818570356; Mon, 15 Dec 2025
 09:09:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-24-joannelkoong@gmail.com> <CADUfDZp9u8D8shxK1BQ=O4cMWeE7w4wrvfY7Xdr0=_vAEgvJZQ@mail.gmail.com>
 <CAJnrk1ZKX+0Zph-aEOnRL0MmCxyEvt4u6EOUyiHVOhv98wUU8A@mail.gmail.com>
In-Reply-To: <CAJnrk1ZKX+0Zph-aEOnRL0MmCxyEvt4u6EOUyiHVOhv98wUU8A@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Dec 2025 09:09:18 -0800
X-Gm-Features: AQt7F2o6V9vQv6iy3w5K0zgefvD2AAxYh1f0UEk1VHO2v_l5z2UZUqonvq5ymWg
Message-ID: <CADUfDZqNqqwfKVNx4M+jjfovTb8Vy5ohFQdRB39_tN+B2_ZhBw@mail.gmail.com>
Subject: Re: [PATCH v1 23/30] io_uring/rsrc: split io_buffer_register_request()
 logic
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 12, 2025 at 9:24=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Sun, Dec 7, 2025 at 5:42=E2=80=AFPM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Tue, Dec 2, 2025 at 4:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> > >
> > > Split the main initialization logic in io_buffer_register_request() i=
nto
> > > a helper function.
> > >
> > > This is a preparatory patch for supporting kernel-populated buffers i=
n
> > > fuse io-uring, which will be reusing this logic.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  io_uring/rsrc.c | 80 +++++++++++++++++++++++++++++------------------=
--
> > >  1 file changed, 48 insertions(+), 32 deletions(-)
> > >
> > > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > > index 59cafe63d187..18abba6f6b86 100644
> > > --- a/io_uring/rsrc.c
> > > +++ b/io_uring/rsrc.c
> > > @@ -941,63 +941,79 @@ int io_sqe_buffers_register(struct io_ring_ctx =
*ctx, void __user *arg,
> > >         return ret;
> > >  }
> > >
> > > -int io_buffer_register_request(struct io_ring_ctx *ctx, struct reque=
st *rq,
> > > -                              void (*release)(void *), unsigned int =
index,
> > > -                              unsigned int issue_flags)
> > > +static int io_buffer_init(struct io_ring_ctx *ctx, unsigned int nr_b=
vecs,
> >
> > Consider adding "kernel" somewhere in the name to distinguish this
> > from the userspace registered buffer initialization
>
> I can rename this to io_kernel_buffer_init().

Sounds good.

Thanks,
Caleb

>
> >
> > > +                         unsigned int total_bytes, u8 dir,
> > > +                         void (*release)(void *), void *priv,
> > > +                         unsigned int index)
> > >  {
> > >         struct io_rsrc_data *data =3D &ctx->buf_table;
> > > -       struct req_iterator rq_iter;
> > >         struct io_mapped_ubuf *imu;
> > >         struct io_rsrc_node *node;
> > > -       struct bio_vec bv;
> > > -       unsigned int nr_bvecs =3D 0;
> > > -       int ret =3D 0;
> > >
> > > -       io_ring_submit_lock(ctx, issue_flags);
> > > -       if (index >=3D data->nr) {
> > > -               ret =3D -EINVAL;
> > > -               goto unlock;
> > > -       }
> > > +       if (index >=3D data->nr)
> > > +               return -EINVAL;
> > >         index =3D array_index_nospec(index, data->nr);
> > >
> > > -       if (data->nodes[index]) {
> > > -               ret =3D -EBUSY;
> > > -               goto unlock;
> > > -       }
> > > +       if (data->nodes[index])
> > > +               return -EBUSY;
> > >
> > >         node =3D io_rsrc_node_alloc(ctx, IORING_RSRC_BUFFER);
> > > -       if (!node) {
> > > -               ret =3D -ENOMEM;
> > > -               goto unlock;
> > > -       }
> > > +       if (!node)
> > > +               return -ENOMEM;
> > >
> > > -       /*
> > > -        * blk_rq_nr_phys_segments() may overestimate the number of b=
vecs
> > > -        * but avoids needing to iterate over the bvecs
> > > -        */
> > > -       imu =3D io_alloc_imu(ctx, blk_rq_nr_phys_segments(rq));
> > > +       imu =3D io_alloc_imu(ctx, nr_bvecs);
> > >         if (!imu) {
> > >                 kfree(node);
> > > -               ret =3D -ENOMEM;
> > > -               goto unlock;
> > > +               return -ENOMEM;
> > >         }
> > >
> > >         imu->ubuf =3D 0;
> > > -       imu->len =3D blk_rq_bytes(rq);
> > > +       imu->len =3D total_bytes;
> > >         imu->acct_pages =3D 0;
> > >         imu->folio_shift =3D PAGE_SHIFT;
> > > +       imu->nr_bvecs =3D nr_bvecs;
> > >         refcount_set(&imu->refs, 1);
> > >         imu->release =3D release;
> > > -       imu->priv =3D rq;
> > > +       imu->priv =3D priv;
> > >         imu->is_kbuf =3D true;
> > > -       imu->dir =3D 1 << rq_data_dir(rq);
> > > +       imu->dir =3D 1 << dir;
> > > +
> > > +       node->buf =3D imu;
> > > +       data->nodes[index] =3D node;
> > > +
> > > +       return 0;
> > > +}
> > > +
> > > +int io_buffer_register_request(struct io_ring_ctx *ctx, struct reque=
st *rq,
> > > +                              void (*release)(void *), unsigned int =
index,
> > > +                              unsigned int issue_flags)
> > > +{
> > > +       struct req_iterator rq_iter;
> > > +       struct io_mapped_ubuf *imu;
> > > +       struct bio_vec bv;
> > > +       unsigned int nr_bvecs;
> > > +       unsigned int total_bytes;
> > > +       int ret;
> > > +
> > > +       io_ring_submit_lock(ctx, issue_flags);
> > > +
> > > +       /*
> > > +        * blk_rq_nr_phys_segments() may overestimate the number of b=
vecs
> > > +        * but avoids needing to iterate over the bvecs
> > > +        */
> > > +       nr_bvecs =3D blk_rq_nr_phys_segments(rq);
> > > +       total_bytes =3D blk_rq_bytes(rq);
> >
> > These could be initialized before io_ring_submit_lock()
> >
> > > +       ret =3D io_buffer_init(ctx, nr_bvecs, total_bytes, rq_data_di=
r(rq), release, rq,
> > > +                            index);
> > > +       if (ret)
> > > +               goto unlock;
> > >
> > > +       imu =3D ctx->buf_table.nodes[index]->buf;
> >
> > It would be nice to avoid all these additional dereferences. Could
> > io_buffer_init() return the struct io_mapped_ubuf *, using ERR_PTR()
> > to return any error code?
>
> I'll make this change for v2.
>
> Thanks,
> Joanne
> >
> > Best,
> > Caleb

