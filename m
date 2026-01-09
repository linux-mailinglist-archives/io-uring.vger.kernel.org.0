Return-Path: <io-uring+bounces-11553-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DE91CD06ADC
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 02:07:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E0C533027816
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 01:07:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A988D1DE885;
	Fri,  9 Jan 2026 01:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BhppVu5D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180F3146588
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 01:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767920841; cv=none; b=gPfjc8Jw6zCo802SbZkCX5IkW6z0r2p5wPtLfXiqotgx+PsnWd5M4qio6AE1IhyHFGCNI0r5lEQnCIuZeGNlCkBZ7KBcyojUUxvmBr9GxgnvgZI+vZB+ad7wzo8SH8JVCMxUQ+zq58ZM5uXYpI/wHkEB2cI5qY4QKb5NuwuiE4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767920841; c=relaxed/simple;
	bh=cPwGCp046vgnz9li0QypCY9lKN+OYWmF9pomQJQU/Fo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/h9N6A8Eo+eU2y9Hapb1MBQNJ84iBR4skDfhu2hZvfsHnBW902fqumLHgXsud8UVRHvJjOcjm9CnkLM+pXE8JZPGQ9IZWI7mJ6LYargX1gUseg6E/4ozFFTudXg/DaQTBg2OjTqdxw1JAWl+aSjY452vFKhp5EMexYaiaUFNWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BhppVu5D; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ffb41c1efaso17941351cf.0
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 17:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767920839; x=1768525639; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUY6QZ6/qc1SNBM9OMRZTNYPdWEGtr5HxrTpsqE3o1w=;
        b=BhppVu5D29+nGmeVlVsstNB2PW1kQu4f0g4pmSrg73Q+S0qXzRtOOdmnIqfpe9jHVh
         vnIh9hcrJAfsj65AplkHkIjJkqEOeap/IF7tl2yuF9uDelCC08RW58aGZ3msldYdNhZF
         +TvIo200BVb9UU1cNMmcxsyV1Iv6m43n/9blV2bMryFoBZMrC0Id66FUILFcEGVgszDw
         w5kmj+HNlh7J4mz1mN/wkIRAnPjvMhzYAltW8k3WjzNH1ceLtUx8u9iiU6ugkpPwYsoS
         ACVOZV/D6FRkKvCsWOdFhWCoKaJvyh7tTNfpAWvP9KHIwAtNph2Yq3nCe8b5g6b/EUoB
         Ucwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767920839; x=1768525639;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TUY6QZ6/qc1SNBM9OMRZTNYPdWEGtr5HxrTpsqE3o1w=;
        b=w1c/qESR7WHw/JDFp/MHA0JRkFsYnP2qfoh5uzGYLfdcTcCt2X6t7DuwiPpwiyzKaH
         nLrHSBG1AZxJOLPPJ0opBgr1sWSRtnyrhWEm9P3zUah2I5BTeaGAPxMzz9F2IfacK9GJ
         MIuSCYF8yLDR2qx/uYH1MmRGe2X6EZaQgpBNmT15J60BD5U/4nOVt/arBX2UG9hpZy2N
         avhVEVJPNufgTOEnwqlUbXPDtg9CmrLEvzUZmLjbXP/vJYau6A8xmd6tqjr+b4K3p8YO
         cVwJMU2KGbusCX51xWl+T58v5CLJCRKOiUg+YqC4ahwreZkkH+g/t7PBQNKuLBe2aUsW
         HxOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVassyv7srHkpW6oP9lALbl77+SLAqpFY50LSyPvzTq1dMZEJ2bWd8xM5PhKvfIv91m0/NfyCg2/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+XIHnm0zfQoRmQLAiJf/BUjw135DJ+BjU4aDNZ5nBVXc2yWhz
	T5nJWf66SX1tkUq2w5Fw9Dp5J6ktWUvGvJqHY5gWlDL0Ce5ibcbIG+MOTHKUtuiMGA7lHX7gcI4
	1q2091lA3WyYfFjbd5d/7T9J2/ne5h2c=
X-Gm-Gg: AY/fxX4X6kxulrIJx19FfWjJS89dICdMIYBCn/SKQJcIa9ZISwwcH/8GtRU0JpSY3MM
	BMNsQ0EedBmuRWR59phXsrFXg8OUNLODb89V1HakaAwEGRP8p8PTKTgml2y0V5zrUarZpMLZMjj
	6JS3EMhiBIh2cT4/W3okVx3ENdSTFX7oEAVWGTirATxjbMswd7q0nQfd1QDRb9QPkWDISIv1ea4
	vIxYcf5BIHAC4XT0vRdudWCeoRKxTm5w5XW0W5ooZIaJ3eqpsg0dwsAn/yI2IYKSgn1NQ==
X-Google-Smtp-Source: AGHT+IGprYMyTKH2BtDLeCae5BovOomShXAo76wqEIXsalKIeWb37V0t18kfBmCMD7vtX1CCFr1larq8MjtKaw2CNsU=
X-Received: by 2002:ac8:7f86:0:b0:4ee:2984:7d93 with SMTP id
 d75a77b69052e-4ffb47d6c3dmr100857941cf.17.1767920839131; Thu, 08 Jan 2026
 17:07:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-8-joannelkoong@gmail.com> <CADUfDZqOsoBGAfkyj1BO2MqyjMxVnYxfim-szAXNsGwW29XrYA@mail.gmail.com>
In-Reply-To: <CADUfDZqOsoBGAfkyj1BO2MqyjMxVnYxfim-szAXNsGwW29XrYA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 8 Jan 2026 17:07:08 -0800
X-Gm-Features: AQt7F2qoMY6Kn7ekvWBZ4c-8Hi5uTVikWoZuD06fU-MrD7-vchbJINS7aDHKGGU
Message-ID: <CAJnrk1a904pJ_XjUtACBxQiYJ1whMWpxPG64=R_i1od6c-PQTA@mail.gmail.com>
Subject: Re: [PATCH v3 07/25] io_uring/kbuf: add recycling for kernel managed
 buffer rings
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 12:37=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Add an interface for buffers to be recycled back into a kernel-managed
> > buffer ring.
> >
> > This is a preparatory patch for fuse over io-uring.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/cmd.h | 13 +++++++++++
> >  io_uring/kbuf.c              | 42 ++++++++++++++++++++++++++++++++++++
> >  io_uring/kbuf.h              |  3 +++
> >  io_uring/uring_cmd.c         | 11 ++++++++++
> >  4 files changed, 69 insertions(+)
> >
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.=
h
> > index 424f071f42e5..7169a2a9a744 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -88,6 +88,11 @@ int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *i=
oucmd, unsigned buf_group,
> >                               unsigned issue_flags, struct io_buffer_li=
st **bl);
> >  int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned =
buf_group,
> >                                 unsigned issue_flags);
> > +
> > +int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *cmd,
> > +                                 unsigned int buf_group, u64 addr,
> > +                                 unsigned int len, unsigned int bid,
> > +                                 unsigned int issue_flags);
> >  #else
> >  static inline int
> >  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > @@ -143,6 +148,14 @@ static inline int io_uring_cmd_buf_ring_unpin(stru=
ct io_uring_cmd *ioucmd,
> >  {
> >         return -EOPNOTSUPP;
> >  }
> > +static inline int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *c=
md,
> > +                                               unsigned int buf_group,
> > +                                               u64 addr, unsigned int =
len,
> > +                                               unsigned int bid,
> > +                                               unsigned int issue_flag=
s)
> > +{
> > +       return -EOPNOTSUPP;
> > +}
> >  #endif
> >
> >  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_r=
eq tw_req)
> > diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > index 03e05bab023a..f12d000b71c5 100644
> > --- a/io_uring/kbuf.c
> > +++ b/io_uring/kbuf.c
> > @@ -101,6 +101,48 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
> >         req->kbuf =3D NULL;
> >  }
> >
> > +int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr=
,
> > +                    unsigned int len, unsigned int bid,
> > +                    unsigned int issue_flags)
> > +{
> > +       struct io_ring_ctx *ctx =3D req->ctx;
> > +       struct io_uring_buf_ring *br;
> > +       struct io_uring_buf *buf;
> > +       struct io_buffer_list *bl;
> > +       int ret =3D -EINVAL;
> > +
> > +       if (WARN_ON_ONCE(req->flags & REQ_F_BUFFERS_COMMIT))
> > +               return ret;
> > +
> > +       io_ring_submit_lock(ctx, issue_flags);
> > +
> > +       bl =3D io_buffer_get_list(ctx, bgid);
> > +
> > +       if (WARN_ON_ONCE(!(bl->flags & IOBL_BUF_RING)) ||
> > +           WARN_ON_ONCE(!(bl->flags & IOBL_KERNEL_MANAGED)))
> > +               goto done;
> > +
> > +       br =3D bl->buf_ring;
> > +
> > +       if (WARN_ON_ONCE((br->tail - bl->head) >=3D bl->nr_entries))
> > +               goto done;
> > +
> > +       buf =3D &br->bufs[(br->tail) & bl->mask];
> > +
> > +       buf->addr =3D addr;
> > +       buf->len =3D len;
> > +       buf->bid =3D bid;
> > +
> > +       req->flags &=3D ~REQ_F_BUFFER_RING;
> > +
> > +       br->tail++;
> > +       ret =3D 0;
> > +
> > +done:
> > +       io_ring_submit_unlock(ctx, issue_flags);
> > +       return ret;
> > +}
> > +
> >  bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags=
)
> >  {
> >         struct io_ring_ctx *ctx =3D req->ctx;
> > diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
> > index c4368f35cf11..4d8b7491628e 100644
> > --- a/io_uring/kbuf.h
> > +++ b/io_uring/kbuf.h
> > @@ -146,4 +146,7 @@ int io_kbuf_ring_pin(struct io_kiocb *req, unsigned=
 buf_group,
> >                      unsigned issue_flags, struct io_buffer_list **bl);
> >  int io_kbuf_ring_unpin(struct io_kiocb *req, unsigned buf_group,
> >                        unsigned issue_flags);
> > +int io_kmbuf_recycle(struct io_kiocb *req, unsigned int bgid, u64 addr=
,
> > +                    unsigned int len, unsigned int bid,
> > +                    unsigned int issue_flags);
> >  #endif
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 8ac79ead4158..b6b675010bfd 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -416,3 +416,14 @@ int io_uring_cmd_buf_ring_unpin(struct io_uring_cm=
d *ioucmd, unsigned buf_group,
> >         return io_kbuf_ring_unpin(req, buf_group, issue_flags);
> >  }
> >  EXPORT_SYMBOL_GPL(io_uring_cmd_buf_ring_unpin);
> > +
> > +int io_uring_cmd_kmbuffer_recycle(struct io_uring_cmd *ioucmd,
> > +                                 unsigned int buf_group, u64 addr,
> > +                                 unsigned int len, unsigned int bid,
> > +                                 unsigned int issue_flags)
> > +{
> > +       struct io_kiocb *req =3D cmd_to_io_kiocb(ioucmd);
> > +
> > +       return io_kmbuf_recycle(req, buf_group, addr, len, bid, issue_f=
lags);
>
> Total nit, but is there a reason for the inconsistency between
> "kmbuffer" and "kmbuf"? I would prefer to use a single name for the
> concept.

Ah totally valid question. I'll stick with the kmbuf naming convention
and rename this for v4.

Thanks for taking a look at this patchset series.
>
> Best,
> Caleb
>
> > +}
> > +EXPORT_SYMBOL_GPL(io_uring_cmd_kmbuffer_recycle);
> > --
> > 2.47.3
> >

