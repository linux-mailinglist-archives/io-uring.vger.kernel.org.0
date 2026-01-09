Return-Path: <io-uring+bounces-11552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 350E2D06ACB
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 02:05:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8D0C1300D915
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 01:05:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5254418CBE1;
	Fri,  9 Jan 2026 01:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y1ls4t3o"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99814F5E0
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 01:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767920713; cv=none; b=rbIyidd9vqlDHgC3HonPt0UTCylA23eeseLHabFPqP0bjcvKboRsvsBzJV1m6iiCghUEfAupjCJ4W0K3R7olSoVXbiGvKN7VnIHLuFHFm2VnME1WqtmTc3s+WfkryK9pR0WOSYgrcMYPyIsgRnlxoV7d8c8hhqlJ9QygBRMNOVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767920713; c=relaxed/simple;
	bh=7gFn/kbffC2b2K7ZKbv+EphI6b1weHTRTlcBs50nkEk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jfjjfucMB/5hcvVcZNtaQcqc+elQC5UGaoGeKRkFe3Qc+oQ2EeznqpNrGDWPi+DL5DZewI7RtVrhAp3ytabyIT82e0fVy/36GsTylsCnE2RP3mQCYulT5+r9YKldrz/cZKR64yW/uwkSPECf9ZHVOTuxoYFpUO8hoNyEQmfFE/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y1ls4t3o; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4f822b2df7aso49636291cf.2
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 17:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767920711; x=1768525511; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8PRD3yO3JctHHM7B943g2Ei/qmzsZxkR5OBbWUkzXtY=;
        b=Y1ls4t3oSkXQyZdmxivWtpcFNH8PQiusTBER8lL0A1WzlauFA+96b5IqyGoXPt5/iC
         NAz0kRPgKnrj/n3GJtaw9bjrI6Pj08h69dT81Ry8SAn3DF7irjAyYwno3xabTq7NxxP3
         vxWOT00NWDLJz1JhbAJElrdpIkO2nIskFbcJgZOJ1lI/UD2i8sP+rmJBGZ+tR26TOwWL
         HAfF7dw3c9Zau3bNgl/EowImXaf7qXU8+jThjY4hb2SZE88c52hX0WL8pRgov21QbiRs
         Xb3kwgEDk7wDNp0dDNqFzOkpTnDhNlnwnsi1QyyhW+2nGY1jRERoJCLlhBX/4jYvJz2N
         5FLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767920711; x=1768525511;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8PRD3yO3JctHHM7B943g2Ei/qmzsZxkR5OBbWUkzXtY=;
        b=PmcViYM5IvMnItzT7p1EZUdHsAFlrp9V+j/R2YtGiIywHduLOUFmOs0F4K8S5mKasj
         GE4vRu6cvA5bhSeI2ZOe5p6JDQUi6v8Teka8g5EKXHfBBv5NRtJNiIncBRaFC3GdgQ5i
         MzfkKz55qxyRiQnpsHzUXwKRLm4OkE1d7TIhl41XgczDS8dDoPzYvQrFD91jJ1qkpK+T
         3yJ3WBUYD4HicZgmQI25DGdbHIivhMgSCiZ8+/mACtGG5J9f7E8M7EU5gTQ8Nnynj+aJ
         7oqToDXMeo/ELCGo/QgYhUVhpz9bh61iIM1OjAz9Wam4iqTfJcKYtHTXSaiBpJZgrdTV
         nsPw==
X-Forwarded-Encrypted: i=1; AJvYcCUuvyNjH4ZD0FRxiJWX/uL5L18P+Xae+rkbZzUcKVlHe0Vwb5EMskbhtdrMXK3SkBprfTnQgKVruA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDCfwvccdOgHnUYxfH61J5Ub9ZNI+kOWath9kMty2QPk5qq6y+
	Ql1RZIlYvEdw9YsI2VakZEHnaiFyx9yTryhew5450AWAqh9oGVClrdTnKdyitMrwCTGGcgc7rM2
	xgv25xTSyDH3yC5F+KVOzvnQAmgL6Dak=
X-Gm-Gg: AY/fxX638z16EA6CRZWs3a+EWQ9CifEsrs4uQpjvi1QzbS6EcL1PdQ7gji7exTl8HN7
	U929FecWugAXrJRIi32IJFewOZ/buG8Aiz4jv4mlZ7QeQy539BVFo14wAmfaJR65pfUhgAVi0fB
	1EY5nwa6dosLjPQMq9qL5yMZuSi0CVdxkdhALtHd7j0M+oGgcQtbc/X3cCre+hHf68fetB7ZKyP
	w92ngIPBFd6BrMgBsRArn2jtJXMQ8vrqjc/IHB+QtEaucJgUFE9cSvMUXZzWD/7Cn0PUViZEUcJ
	PB7F
X-Google-Smtp-Source: AGHT+IGNtKMMEcsVpub3pvnWl8mPBBVsnyogUJq8Km7gtnKFPujIzli01C84cufrl8ktpDilL5lamsD9MkT/ULCSDEA=
X-Received: by 2002:a05:622a:590c:b0:4ee:28b8:f110 with SMTP id
 d75a77b69052e-4ffb48d42e1mr125642041cf.29.1767920710614; Thu, 08 Jan 2026
 17:05:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-7-joannelkoong@gmail.com> <CADUfDZqKu0AN_Ci5fKZEgLzOCMgjtAVhfMbyO6KkX3PYfs4Xcw@mail.gmail.com>
In-Reply-To: <CADUfDZqKu0AN_Ci5fKZEgLzOCMgjtAVhfMbyO6KkX3PYfs4Xcw@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 8 Jan 2026 17:04:59 -0800
X-Gm-Features: AQt7F2rWX2duJBYoOYNh_tJvoRawqhCbXGahMmtFCnOn0ZcTRvBmI8rSmnsfwMM
Message-ID: <CAJnrk1aYSUbnv1VvY01MjpDpvNRmz24tz4nj66sZXF4o8R6a_g@mail.gmail.com>
Subject: Re: [PATCH v3 06/25] io_uring/kbuf: add buffer ring pinning/unpinning
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 11:18=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Add kernel APIs to pin and unpin buffer rings, preventing userspace fro=
m
> > unregistering a buffer ring while it is pinned by the kernel.
> >
> > This provides a mechanism for kernel subsystems to safely access buffer
> > ring contents while ensuring the buffer ring remains valid. A pinned
> > buffer ring cannot be unregistered until explicitly unpinned. On the
> > userspace side, trying to unregister a pinned buffer will return -EBUSY=
.
> >
> > This is a preparatory change for upcoming fuse usage of kernel-managed
> > buffer rings. It is necessary for fuse to pin the buffer ring because
> > fuse may need to select a buffer in atomic contexts, which it can only
> > do so by using the underlying buffer list pointer.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/cmd.h | 17 +++++++++++++
> >  io_uring/kbuf.c              | 46 ++++++++++++++++++++++++++++++++++++
> >  io_uring/kbuf.h              | 10 ++++++++
> >  io_uring/uring_cmd.c         | 18 ++++++++++++++
> >  4 files changed, 91 insertions(+)
> >
> > diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.=
h
> > index 375fd048c4cb..424f071f42e5 100644
> > --- a/include/linux/io_uring/cmd.h
> > +++ b/include/linux/io_uring/cmd.h
> > @@ -84,6 +84,10 @@ struct io_br_sel io_uring_cmd_buffer_select(struct i=
o_uring_cmd *ioucmd,
> >  bool io_uring_mshot_cmd_post_cqe(struct io_uring_cmd *ioucmd,
> >                                  struct io_br_sel *sel, unsigned int is=
sue_flags);
> >
> > +int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *ioucmd, unsigned bu=
f_group,
> > +                             unsigned issue_flags, struct io_buffer_li=
st **bl);
> > +int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *ioucmd, unsigned =
buf_group,
> > +                               unsigned issue_flags);
> >  #else
> >  static inline int
> >  io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
> > @@ -126,6 +130,19 @@ static inline bool io_uring_mshot_cmd_post_cqe(str=
uct io_uring_cmd *ioucmd,
> >  {
> >         return true;
> >  }
> > +static inline int io_uring_cmd_buf_ring_pin(struct io_uring_cmd *ioucm=
d,
> > +                                           unsigned buf_group,
> > +                                           unsigned issue_flags,
> > +                                           struct io_buffer_list **bl)
> > +{
> > +       return -EOPNOTSUPP;
> > +}
> > +static inline int io_uring_cmd_buf_ring_unpin(struct io_uring_cmd *iou=
cmd,
> > +                                             unsigned buf_group,
> > +                                             unsigned issue_flags)
> > +{
> > +       return -EOPNOTSUPP;
> > +}
> >  #endif
> >
> >  static inline struct io_uring_cmd *io_uring_cmd_from_tw(struct io_tw_r=
eq tw_req)
> > diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > index 8f63924bc9f7..03e05bab023a 100644
> > --- a/io_uring/kbuf.c
> > +++ b/io_uring/kbuf.c
> > @@ -238,6 +238,50 @@ struct io_br_sel io_buffer_select(struct io_kiocb =
*req, size_t *len,
> >         return sel;
> >  }
> >
> > +int io_kbuf_ring_pin(struct io_kiocb *req, unsigned buf_group,
> > +                    unsigned issue_flags, struct io_buffer_list **bl)
> > +{
> > +       struct io_buffer_list *buffer_list;
> > +       struct io_ring_ctx *ctx =3D req->ctx;
>
> Would it make sense to take struct io_ring_ctx *ctx instead of struct
> io_kiocb *req since this doesn't otherwise use the req? Same comment
> for several of the other kbuf_ring helpers (io_kbuf_ring_unpin(),
> io_reg_buf_index_get(), io_reg_buf_index_put(), io_is_kmbuf_ring()).
>

I think this makes sense and is a good idea. I'll make this change for v4.

Thanks,
Joanne

> Best,
> Caleb
>

