Return-Path: <io-uring+bounces-10306-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25CC7C22BD9
	for <lists+io-uring@lfdr.de>; Fri, 31 Oct 2025 00:53:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B7433BE5AA
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 23:53:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 830C62E5B2A;
	Thu, 30 Oct 2025 23:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IStahIlX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7E02DF151
	for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 23:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761868391; cv=none; b=qK4WzgYla3WSBrL6TfzHcW2oTdkU4UhH8/0IQH5ftB43VnY6/F/t8wAHzy9EkV6QFCenSRNez1Q8mieUM08XwwU6eYSHPbFv2Xuf+vl5sKVV/eDVhHOc23TYWHY1wMtF9GAPDMvdaQ3LTO3x8/avYPU5wxaYSEkMKE6IPBThA60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761868391; c=relaxed/simple;
	bh=xTk/GU04YLlMtQDSeE9nbkamaVNp82KSu6W4S/54nj4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CUPBr2nRjEyKROk7aYE2of4LFL+wMlgf2v99o2cXKrCHBaRBURWBJ7gCesquMowtnVmvXX9oBoqo/+EbJkPuVPwQVj9sOx5nefXsM1rb+edsDCjZz3CzTuiSz3wZDE4JCD3OG4avOd1W0YZUIA2nmGpw17BJD/c+bwFLUCV2cD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IStahIlX; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4e4d9fc4316so17896911cf.2
        for <io-uring@vger.kernel.org>; Thu, 30 Oct 2025 16:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761868387; x=1762473187; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n04BbQqZoGGFXMsbAC0Hpl5TUalT5+1j+0kTZUYMnJI=;
        b=IStahIlXnR+onyyzWCjgl5Nnw0Rwo2gj3FuKU4RngZpyeF2x0AXg81iDgI56fbptpP
         Q0IZy3ay/xDXvr7auhTGYDixLBC9B+C1UrqJwOIWPBoLtWHPf7CnqhUDK6gSPo/1HxOh
         wCGbxWL46Q5Br/rRLKVDJc2YxKhUhBNQblzfzZrtlo1tKGU2hS4chM4v2eg/GORt4VQ1
         xwcmpBTMxTd3DKu3QJpghssrvigkRxMsGuU/d3u1OJ67JO/Zan89wV1rBTX5SEQySFT/
         yQJMXMmJIzIZpmL4aDC2S6N+yhJwPbTlbD4JQRs+e5Fpb8u0mKdk5TyN3HFg+NGMcHZ9
         fI2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761868387; x=1762473187;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n04BbQqZoGGFXMsbAC0Hpl5TUalT5+1j+0kTZUYMnJI=;
        b=o9C92KDA+f85Rsx2z914UneZnzmgFnfirU1xURcF2decGAL2F0T9I6q6n+8pNtniPM
         p009NYhOGTxrw4iB9bYBBYUN3JJSb1owpZpmVDHQr0Yn5rGo+qMfXyn+Jrg11TrKkZaj
         c3O1LeBSMIWzWHei6kkXBdEIKUrhrh3MDyUyh+TiAo4qrE6peoc+/vD31qYXSPOPWGgi
         gKN5e5x9I6wkex39eYG5jQ1+g3tCt8VyNrxpcj2/U5ziEnqcCJV84qjhGRucBGRTVHcQ
         NwQAw59lWN5s46Ps8HpO11jhuAUARc89+tStzwoqhJvhGnR+iQGYYYhEalHdQdhqydH2
         AN1Q==
X-Forwarded-Encrypted: i=1; AJvYcCVXadUJrDiCVA4KH6+di3ZdYFao9MysuIly+wINwDXAY71xJAos/+Dyh0KiZflkpo9F3vaGEPqj/w==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4+LjyhuWMz2TbcR0g2HBOcFSZAox3/dnodFkoqT4V2k5qbLdx
	jiuOqRF1siiTx6O47gebLY6IPMlUL4Sl/qQdLgzKIvK3uwhkoxPTIKqYXo+6zZHfXqLt4hHjiBh
	9eskJe04Y/XvpiqR1JWZUT9ic+iT/8oc=
X-Gm-Gg: ASbGncvTCUFOEZoS9E7I5JJQNLM6xte1TkQ8IepHFbXUDb37cjg5TG0kTpXSPjbmHwQ
	nCczxkh/dvzVBPHrJ4lP0UZi56zKuykV32pKUNHcGy7Xb8kN2zjyF6wMA8jB+AZepR+AZTib6mj
	j6/waOGj3Rr/hgghlhKTCtyF3Zjod7HsvkT4yupvfsFv4PJuaUu1X3mcZuCQh4CbGrWKIm+/WDJ
	y1tRv+lpMIbZkm5f7cEADe0N0vfgcF6FbBgXnxm0z1rLBvw3MuXUtTilNI+BeQL6EDOne6pVjwd
	mVSkrsg+ILF+ZEeJsKNEMaAOGg==
X-Google-Smtp-Source: AGHT+IGk9SMa7VU9vBFH92+Hgv/+/zZz4U8VKXx0ZUb2Qh95rxnUPcLcpxuN/1CnSy1MEG8DRVR6GEi32xjUag0Rjm8=
X-Received: by 2002:a05:622a:2618:b0:4e8:acc0:1e8f with SMTP id
 d75a77b69052e-4ed30f8b05amr20375501cf.47.1761868387528; Thu, 30 Oct 2025
 16:53:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-4-joannelkoong@gmail.com> <49d00ff4-1f8a-4f84-b237-3c8e0a6ad9c2@ddn.com>
In-Reply-To: <49d00ff4-1f8a-4f84-b237-3c8e0a6ad9c2@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 30 Oct 2025 16:52:56 -0700
X-Gm-Features: AWmQ_bkD36B7WSOJCHrliTY9xrzbBqWH_DNKI1TfkSb9mOw2yBP0jPiWmZ9bzqM
Message-ID: <CAJnrk1Z475GVKaogV94zTHuDWS+kdv=V3tNXeYuL0gE3WVN4mA@mail.gmail.com>
Subject: Re: [PATCH v2 3/8] fuse: refactor io-uring header copying to ring
To: Bernd Schubert <bschubert@ddn.com>
Cc: "miklos@szeredi.hu" <miklos@szeredi.hu>, "axboe@kernel.dk" <axboe@kernel.dk>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"asml.silence@gmail.com" <asml.silence@gmail.com>, 
	"io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, 
	"xiaobing.li@samsung.com" <xiaobing.li@samsung.com>, 
	"csander@purestorage.com" <csander@purestorage.com>, "kernel-team@meta.com" <kernel-team@meta.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2025 at 4:15=E2=80=AFPM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
> On 10/27/25 23:28, Joanne Koong wrote:
> > Move header copying to ring logic into a new copy_header_to_ring()
> > function. This consolidates error handling.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/dev_uring.c | 38 ++++++++++++++++++++------------------
> >  1 file changed, 20 insertions(+), 18 deletions(-)
> >
> > diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> > index 415924b346c0..e94af90d4d46 100644
> > --- a/fs/fuse/dev_uring.c
> > +++ b/fs/fuse/dev_uring.c
> > @@ -574,6 +574,17 @@ static int fuse_uring_out_header_has_err(struct fu=
se_out_header *oh,
> >       return err;
> >  }
> >
> > +static int copy_header_to_ring(void __user *ring, const void *header,
> > +                            size_t header_size)
> > +{
> > +     if (copy_to_user(ring, header, header_size)) {
> > +             pr_info_ratelimited("Copying header to ring failed.\n");
> > +             return -EFAULT;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> >  static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
> >                                    struct fuse_req *req,
> >                                    struct fuse_ring_ent *ent)
> > @@ -634,13 +645,11 @@ static int fuse_uring_args_to_ring(struct fuse_ri=
ng *ring, struct fuse_req *req,
> >                * Some op code have that as zero size.
> >                */
> >               if (args->in_args[0].size > 0) {
> > -                     err =3D copy_to_user(&ent->headers->op_in, in_arg=
s->value,
> > -                                        in_args->size);
> > -                     if (err) {
> > -                             pr_info_ratelimited(
> > -                                     "Copying the header failed.\n");
> > -                             return -EFAULT;
> > -                     }
> > +                     err =3D copy_header_to_ring(&ent->headers->op_in,
> > +                                               in_args->value,
> > +                                               in_args->size);
> > +                     if (err)
> > +                             return err;
> >               }
> >               in_args++;
> >               num_args--;
> > @@ -655,9 +664,8 @@ static int fuse_uring_args_to_ring(struct fuse_ring=
 *ring, struct fuse_req *req,
> >       }
> >
> >       ent_in_out.payload_sz =3D cs.ring.copied_sz;
> > -     err =3D copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
> > -                        sizeof(ent_in_out));
> > -     return err ? -EFAULT : 0;
> > +     return copy_header_to_ring(&ent->headers->ring_ent_in_out, &ent_i=
n_out,
> > +                                sizeof(ent_in_out));
> >  }
> >
> >  static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
> > @@ -686,14 +694,8 @@ static int fuse_uring_copy_to_ring(struct fuse_rin=
g_ent *ent,
> >       }
> >
> >       /* copy fuse_in_header */
> > -     err =3D copy_to_user(&ent->headers->in_out, &req->in.h,
> > -                        sizeof(req->in.h));
> > -     if (err) {
> > -             err =3D -EFAULT;
> > -             return err;
> > -     }
> > -
> > -     return 0;
> > +     return copy_header_to_ring(&ent->headers->in_out, &req->in.h,
> > +                                sizeof(req->in.h));
> >  }
>
> This will give Miklos a bit headache, because of a merge conflict with
>
> https://lore.kernel.org/r/20251021-io-uring-fixes-copy-finish-v1-1-913ecf=
8aa945@ddn.com
>
> Any chance you could rebase your series on this patch?

Definitely, I will do that for v3. I saw that you submitted a bunch of
io-uring patches earlier last week alongside this one -  I haven't
gotten around to reviewing those but I will do so.

Thanks,
Joanne
>
> Thanks,
> Bernd
>
> >
> >  static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
>
>

