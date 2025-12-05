Return-Path: <io-uring+bounces-10984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 99494CA9A3A
	for <lists+io-uring@lfdr.de>; Sat, 06 Dec 2025 00:29:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8823A318D65E
	for <lists+io-uring@lfdr.de>; Fri,  5 Dec 2025 23:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78E972FFDC9;
	Fri,  5 Dec 2025 23:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pg6ecarF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793E129B8DD
	for <io-uring@vger.kernel.org>; Fri,  5 Dec 2025 23:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764977318; cv=none; b=LqOAhMPOsZfd/MSrkjJtMA///fv+Rtdgi/gUNWkda0sjzJyoi7YV0XEjyefouEppByEXRZlurutiMWjb7jwn5dT/CdNgLY0VzaeNKrpaXzjo3BTdVeLrFstYIpgrQzbntad6ecMf2NAgjeiGtbg0EivdpVVQ+dc1jXh+pl2n+PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764977318; c=relaxed/simple;
	bh=Z90VoTeUAdtCFcfScKtg62fwuhlURfr0B3vhl1oj69g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=isdbvB2fzhhzKvetfLTnXS5E8x6DYeHoWTuqJ23Hd/yX3cJQccLTTJziVp3KmTXY2b/NDmDp9qFTDTuBI/QrAktd3NAby+MOeKAggOYJDdF7DetJgzYPktNZ/eW2tm3Qg5JWH3KXHdFZbsPvaY6NiZh2ceHpphfqEyOlzs4O2cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pg6ecarF; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4ee14ba3d9cso24350591cf.1
        for <io-uring@vger.kernel.org>; Fri, 05 Dec 2025 15:28:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764977312; x=1765582112; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZntIJKUAXObju8s18woAqbYsOVOV+83j3OU8C8k2zhc=;
        b=Pg6ecarFGuS0rD8CYyN/qGS03ZL0iA3mJPhKDVZG6N1vPcPy3AdIjWBP0YEXVrd2Vn
         hwRXc4dlCGrba+GjqaSz2y8o1ZGssXyKfsMDqn4hp4M9mfmebkWfWAGvhMqrVM6quvBR
         q5B+WId3LS6LOIXCHFUSKOrSbab75Br2gFjnA4XPMVKZxYpgQAAMsPnXzlkF+CEjVDWY
         33h7okcD/7KwnA/wpW3u3fI/IKFd3P3lvU5+HzdARI0gTwtQmDkAeb1PZ5Uc81o3QgbF
         W08AK8rMDC+0MNlN8G5AxI9pOVARUlMc+5wvQRgKWxvk28Fr5DNtd6Ai8p7utdmi/kU7
         uQ5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764977312; x=1765582112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZntIJKUAXObju8s18woAqbYsOVOV+83j3OU8C8k2zhc=;
        b=eVb6SQWERmlXmxcD7tc/63sPdXOIhMR3yHHT9dVePGPleCEPT/OnPLyrdE4g15zwD/
         BGTDJfL0/I4g3lKBaoZgo7WannrZX7T6+yBBW6GQznTiCpLUM2xFSov/xjvBqoGH7iUS
         fv4Y23nXbkkcf1gfdIqjeqv7iCDRPA5g2fxqzr2es3vZqp3ao65J+7OGxqqHYzFEQK0D
         Vr8EWel0RT6DGs/8X7W9sm+XlPY8/yqXN3qbEE2/MOJ+HNkbmn+NVrXnLK69Warb456n
         /ipBOeGVTRzIHGRYeolrXI7UZwMpMEibd8NMfJicHaoslLhq09y4FskKoLnxrMaEZ58p
         1dkA==
X-Forwarded-Encrypted: i=1; AJvYcCUMOvWOwGGRkEQ0ITdIxVialPmROFJB0ws7ezb+lPRd4IpOd8X7bVQLCo5WBTOKcbDXY6WTOHXv7w==@vger.kernel.org
X-Gm-Message-State: AOJu0YwijjsQpMvYhzxeM//podaJZhbx2g3eWwKkdittHXj4b4DREAfW
	ZunGWm32Dg74ChQYs/c+BromK7CS7/TdWjfxzO6adf+5/+1B5ya0d0q1AFZBrRvdfi4TKEQaweH
	qe8+TApCh7Hv3F7buld+ajIdSNsc0cKs=
X-Gm-Gg: ASbGncuIjT66KZ5/6KJ/ub0P9a3hilytoNDIDCCgqnBR8n4CXAUhGWRhnMhBQimlfgp
	ctSTJGBOkOcS7Hogy/TwVIr4/uBtjMm2I1XP6n+bodZDNP6ngeWCcjoioFxoip4iBh6UfzPDyzs
	FFkH6PT7K3xg8X+EuUUNkYiDehxvqZF2FuuYMBIcRFkvoIgFjpqFTRwLuRPxuDjMaGfQz+xGxrF
	vNE2hOZJnOkbyfpTesagbIKrHmm5hlMu+FDYR9YvHR54KQNy0b0m6cTDGlWe9M2InsVCA==
X-Google-Smtp-Source: AGHT+IEHO/BbyvwXOm2Ad6NW0GPg9WjWd8aAwArvsDQjzJwIOr+XxxAV41Ns4Ichas3RvHPNKWaCRaMV0evnwufGIb8=
X-Received: by 2002:a05:622a:4c16:b0:4ee:418a:73cd with SMTP id
 d75a77b69052e-4f03fe2895cmr12857431cf.36.1764977312130; Fri, 05 Dec 2025
 15:28:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-10-joannelkoong@gmail.com> <CADUfDZoUMRu=t3ELJ6yGt2FbcgW=WzHa_=xc4BNtEmPpA67VHw@mail.gmail.com>
 <CAJnrk1a9oifzg+7gtzxux+A0smUE-Hi3sfWU-VpnXZgvKg1ymQ@mail.gmail.com> <CADUfDZoMNiJMoHJpKzF2E_xZ7U-2jitSfQJd=SZD57AxqN6O_Q@mail.gmail.com>
In-Reply-To: <CADUfDZoMNiJMoHJpKzF2E_xZ7U-2jitSfQJd=SZD57AxqN6O_Q@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 5 Dec 2025 15:28:21 -0800
X-Gm-Features: AWmQ_bk3JsZW9L6JFhEbJfFK7vovI6J03e6MDpVp2W0GjvO3-ZBO3PmowzI6Zv8
Message-ID: <CAJnrk1Z2dTPbWeTxZT2Nh0XZSBHnPopK9qcKVFnyzkcMckhVuw@mail.gmail.com>
Subject: Re: [PATCH v1 09/30] io_uring: add io_uring_cmd_import_fixed_index()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 5, 2025 at 8:56=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Thu, Dec 4, 2025 at 10:56=E2=80=AFAM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > On Wed, Dec 3, 2025 at 1:44=E2=80=AFPM Caleb Sander Mateos
> > <csander@purestorage.com> wrote:
> > >
> > > On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gma=
il.com> wrote:
> > > >
> > > > Add a new helper, io_uring_cmd_import_fixed_index(). This takes in =
a
> > > > buffer index. This requires the buffer table to have been pinned
> > > > beforehand. The caller is responsible for ensuring it does not use =
the
> > > > returned iter after the buffer table has been unpinned.
> > > >
> > > > This is a preparatory patch needed for fuse-over-io-uring support, =
as
> > > > the metadata for fuse requests will be stored at the last index, wh=
ich
> > > > will be different from the sqe's buffer index.
> > > >
> > > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > > ---
> > > >  include/linux/io_uring/cmd.h | 10 ++++++++++
> > > >  io_uring/rsrc.c              | 31 +++++++++++++++++++++++++++++++
> > > >  io_uring/rsrc.h              |  2 ++
> > > >  io_uring/uring_cmd.c         | 11 +++++++++++
> > > >  4 files changed, 54 insertions(+)
> > > >
> > > > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > > > index 67331cae0a5a..b6dd62118311 100644
> > > > --- a/io_uring/rsrc.c
> > > > +++ b/io_uring/rsrc.c
> > > > @@ -1156,6 +1156,37 @@ int io_import_reg_buf(struct io_kiocb *req, =
struct iov_iter *iter,
> > > >         return io_import_fixed(ddir, iter, node->buf, buf_addr, len=
);
> > > >  }
> > > >
> > > > +int io_import_reg_buf_index(struct io_kiocb *req, struct iov_iter =
*iter,
> > > > +                           u16 buf_index, int ddir, unsigned issue=
_flags)
> > > > +{
> > > > +       struct io_ring_ctx *ctx =3D req->ctx;
> > > > +       struct io_rsrc_node *node;
> > > > +       struct io_mapped_ubuf *imu;
> > > > +
> > > > +       io_ring_submit_lock(ctx, issue_flags);
> > > > +
> > > > +       if (buf_index >=3D req->ctx->buf_table.nr ||
> > >
> > > This condition is already checked in io_rsrc_node_lookup() below.
> >
> > I think we still need this check here to differentiate between -EINVAL
> > if buf_index is out of bounds and -EFAULT if the buf index was not out
> > of bounds but the lookup returned NULL.
>
> Is there a reason you prefer EINVAL over EFAULT? EFAULT seems
> consistent with the errors returned from registered buffer lookups in
> other cases.

To me -EINVAL makes sense because the error stems from the user
passing in an invalid argument (eg a buffer index that exceeds the
number of buffers registered to the table). The comment in
errno-base.h for EINVAL is "Invalid argument". The EFAULT use for the
other cases (eg io_import_reg_buf) makes sense because it might be the
case that for whatever reason the req->buf_index isn't found in the
table but isn't attributable to having passed in an invalid index.

Thanks,
Joanne

>
> Best,
> Caleb
>

