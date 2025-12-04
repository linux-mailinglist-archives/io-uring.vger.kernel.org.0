Return-Path: <io-uring+bounces-10960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C1697CA5052
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 19:58:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9BDE530A8B11
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 18:56:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D7034B437;
	Thu,  4 Dec 2025 18:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OVo7CJag"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84DC9340D9D
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 18:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764874604; cv=none; b=hDnE5o3OkEmNwyQ0Gwvji6T4mQ6GEnDtoxuPOVNxsJOpcn01jDLRJz/1d81ROD5BFQw/R0yDDHav1MceksEgaTpiCKyHaerheJJQf6ZKjLKwvfUo2SUndmBFU6DWoet1jLNB9l9LNBtuG6iYUA/d+h1QCpnVaKf4UC4abgnAkiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764874604; c=relaxed/simple;
	bh=hSwqPbD2kHCWf6inzxJ0VscnmiAZiUEKTCPr4rImvCk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cCIudZVKQIgHL7aymQeMB0TEU/tqoPSU8FbmqM9oCOgb+MTm8XvVlm5ZXpT7KnWyfZtPXIDTT19oNgRlXyIpowewRGLxYqj3bGdOcITDAfpMluNalBnQy4Fl7vm0CbUq/jSqSmwdZ11clm2BWYYh+aplHKv77fkn8v5izQACxJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OVo7CJag; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4ee1fca7a16so11077421cf.3
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 10:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764874600; x=1765479400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKmZ/MxYEUYy3Wqdh5Nd1000hi3s02/BzHgESZBhMu4=;
        b=OVo7CJags6dVl07/Ci5UhAqvXOc0dlQIMDZT/h/RbhkPF/DSmDodvZXImqSELEEHfb
         +T2Xe8ktaHPWtMoY/JqaYAj4fZIwB6yjoA/vEv/h9UynnGeOnLp0NpKE6arSWRi9a8qd
         BITXZ3M7A/u8tBD3Lo/LoNoulkXwqIkwYfXopgeNkJLVTbejKjI90G6TyGSdv0HkfLQr
         gT9ZzOFhRHe35iqxygOvmi4fo1WO2tym9W5CvGDiAWCvXITrz5KbMmW0Aa0Md2dzvvJx
         Wo6DXUtY/theZgb/7loWA+BPwM6uP1xNkTzdT4t02jKlRr9r+ktHTGvReuifnZqPJME/
         i7EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764874600; x=1765479400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vKmZ/MxYEUYy3Wqdh5Nd1000hi3s02/BzHgESZBhMu4=;
        b=mb7OJHGz2EPq39LvYVBPuwFLsM13N80GfxiLoXBQRAm7+8SS2EB/yxPFGFkzRXMDL2
         eHY+qFmt4m3SdfioTIrL//8Ley6/SJ54aB4eZ0r3vB21kzDJaXYRIJy/a0mKsl+VNjUA
         aIp2nrBatCSDrucx4+eRF5qx+ZXcLkDnIJt0B5pU6TmqhJ/c5UdLYRkbCqegXf1/+lW4
         H/gOnKH8Q7pXzEa8XA+KR0yYrvw9j5Ub0PO9Osil5ylSq0PSKRDUjZpqPGXHR09+qc4S
         xBvpei+MTrIKxJQ7FyDsheUr4v0Uw/0UaRXfa2NCpZneqjRC9tLl7/9JDrcnln6de61O
         /8lw==
X-Forwarded-Encrypted: i=1; AJvYcCWzb6ogIhgaRKq4jwL1obteLP+rweooEwXiLu3c0jva0b8d6Jvr2uW282r87ouXZhq2kXH/EK5DEA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxABnZRJl+mOwKVnlr7WEks9n3LoSJh94d7d9OPxMW3aX1bgr1O
	6Mz8yQPpdMTe8EyRrHLU+YZK4HdSbYhK8syIlXiJYseyoNV0vLRazyKrbAjEuRJo0TX+aMPDF8d
	nSKc3pJOziZocZadRLFp0uAyDvL/bACE=
X-Gm-Gg: ASbGncvlWlBapa8G2aN8hmr0TztPfKdcB8fnbj1fnJeD0WSs5q/7GJ+w+5sYRLcKyBq
	iqz/Ic0Cm4Xnj1BgMPL8mciYGYSmPWJ+vJ37z5AgnvfvzauUt8/lVxHuP7nAKgyP+we51jFjUHw
	ductUvj0iUiE845YKfkuCwOOVEY1JUT8U7KMSR1DAWu895uJ/zdy5geU3Vdf9XIpfIeuMUMAwlU
	lQUDJ+rDO7N/E916ruGD1fe4ZYAOXixeW+/ZkHoq6IEmEOD7uYDmDhkls8XCcmrU8phlA==
X-Google-Smtp-Source: AGHT+IHLW/zcnGq940PEU+RoJ9BFVyBYL3toajj4uowSqWQF+PzgyutFaO63GH017Z5pDzF5nq8YpwObVSwzKYMH294=
X-Received: by 2002:ac8:5d91:0:b0:4ee:22d6:1d01 with SMTP id
 d75a77b69052e-4f0239f8bf3mr62067991cf.33.1764874600381; Thu, 04 Dec 2025
 10:56:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-10-joannelkoong@gmail.com> <CADUfDZoUMRu=t3ELJ6yGt2FbcgW=WzHa_=xc4BNtEmPpA67VHw@mail.gmail.com>
In-Reply-To: <CADUfDZoUMRu=t3ELJ6yGt2FbcgW=WzHa_=xc4BNtEmPpA67VHw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 4 Dec 2025 10:56:29 -0800
X-Gm-Features: AWmQ_bmS9_si_R5q2nzHNaeDA5veD-ndRT9THEsOwQr4usrizEazAMNSmQY6thE
Message-ID: <CAJnrk1a9oifzg+7gtzxux+A0smUE-Hi3sfWU-VpnXZgvKg1ymQ@mail.gmail.com>
Subject: Re: [PATCH v1 09/30] io_uring: add io_uring_cmd_import_fixed_index()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 1:44=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > Add a new helper, io_uring_cmd_import_fixed_index(). This takes in a
> > buffer index. This requires the buffer table to have been pinned
> > beforehand. The caller is responsible for ensuring it does not use the
> > returned iter after the buffer table has been unpinned.
> >
> > This is a preparatory patch needed for fuse-over-io-uring support, as
> > the metadata for fuse requests will be stored at the last index, which
> > will be different from the sqe's buffer index.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/cmd.h | 10 ++++++++++
> >  io_uring/rsrc.c              | 31 +++++++++++++++++++++++++++++++
> >  io_uring/rsrc.h              |  2 ++
> >  io_uring/uring_cmd.c         | 11 +++++++++++
> >  4 files changed, 54 insertions(+)
> >
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 67331cae0a5a..b6dd62118311 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -1156,6 +1156,37 @@ int io_import_reg_buf(struct io_kiocb *req, stru=
ct iov_iter *iter,
> >         return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
> >  }
> >
> > +int io_import_reg_buf_index(struct io_kiocb *req, struct iov_iter *ite=
r,
> > +                           u16 buf_index, int ddir, unsigned issue_fla=
gs)
> > +{
> > +       struct io_ring_ctx *ctx =3D req->ctx;
> > +       struct io_rsrc_node *node;
> > +       struct io_mapped_ubuf *imu;
> > +
> > +       io_ring_submit_lock(ctx, issue_flags);
> > +
> > +       if (buf_index >=3D req->ctx->buf_table.nr ||
>
> This condition is already checked in io_rsrc_node_lookup() below.

I think we still need this check here to differentiate between -EINVAL
if buf_index is out of bounds and -EFAULT if the buf index was not out
of bounds but the lookup returned NULL.

>
> > +           !(ctx->buf_table.flags & IO_RSRC_DATA_PINNED)) {
> > +               io_ring_submit_unlock(ctx, issue_flags);
> > +               return -EINVAL;
> > +       }
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 197474911f04..e077eba00efe 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -314,6 +314,17 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_=
cmd *ioucmd,
> >  }
> >  EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
> >
> > +int io_uring_cmd_import_fixed_index(struct io_uring_cmd *ioucmd, u16 b=
uf_index,
> > +                                   int ddir, struct iov_iter *iter,
> > +                                   unsigned int issue_flags)
> > +{
> > +       struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> > +
> > +       return io_import_reg_buf_index(req, iter, buf_index, ddir,
> > +                                      issue_flags);
> > +}
>
> Probably would make sense to make this an inline function, since it
> immediately defers to io_import_reg_buf_index().

That makes sense to me, I'll make this change for v2.

Thanks,
Joanne

>
> Best,
> Caleb

