Return-Path: <io-uring+bounces-10967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 996E2CA5930
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 22:57:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 217BB308B3C3
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 21:57:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAAC02EC563;
	Thu,  4 Dec 2025 21:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NPPa0g4d"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA2125742F
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 21:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764885468; cv=none; b=qCaU2yv1GrfTmdQ5ePoo5jaKBsKr6GgOATwjEFvB6yB1f+oRZgFFgT305+DFdiwNxcCLpqAhpfUOxLiqJ1OMS7Sc/PJtWovBKaNjrtcrOu4ZpjMTccgsa+SFwBeAIwOUJEp0NoJiMn9KDenMV8/klJ7Uh1IOECB9n1dJGDQdLoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764885468; c=relaxed/simple;
	bh=hAao6Sspg0ZMi5IKMspwWPWxSyoBWlZMl0yhfTQsDk0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IyLEYdwLKyGkH0CwRKExpE8LVK4ZnjQgi3stMsUIwzptSMEd6p06tceUf7ucwqh+FIdEcctdt/RScCZc23O+Xg2HJZtkY86Mi/NzxAssR+CBdrZ6eb/iapoUpSbNn3ZRbCyndRjuFirlXFklClcjqf2cXRnkoaCfzhGwAi+gQmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NPPa0g4d; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b983fbc731bso128292a12.2
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 13:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764885466; x=1765490266; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsDCtE6tLRUGhRF1z1YiG6/esLImTKD99wVGP83kaqE=;
        b=NPPa0g4d92g8LLYk1mO/4Xw6PenkV7nShYAkOuB0CeNIYPH8Khpt/kuOnm3e1x+OjX
         OED6Us42LomfUFZoVgclicI4KmVnPA/2edQ7IaHpnfbLhg9uctRs2K4sU9rqgcxDwHoR
         mNxtlKViPeYCEEQSKTE5Bj8YhFIVWOo6TaJy6dC7L3sjR56SRx5zhGO1glBlZIYVLclh
         AOuIJepVzEowX06byvrtgXKh4B7Ljae2dkjZQC9chtvx0I35caBCCd89yg0BZhCnONCB
         IgjRubSfXIacI93GLxtsHPgV3YbMzoK2wxc65LKKt+KlK3Tp4E27P8S6geq85JLUIO/q
         cbAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764885466; x=1765490266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tsDCtE6tLRUGhRF1z1YiG6/esLImTKD99wVGP83kaqE=;
        b=T+VG0qL/+LqY0+CawqCcMRMrjPSKFmbCIu/u2iPkrlVy/L+Lc2a47/hSMp5cZxQ7mw
         +8dWFdJYkNoNaKPMqEV1OE1VzD32Am0NTvtaBhSggrOfhpf8f5QnWhdUbS0l0jzbs9m6
         +qCTTbOYPt7KX1ScPazp1fY67m/RBW6kR/4bOF2CKCFjFonPUTKDlLP9nYYkNv9xYhUu
         SgLknREIAWt7F35fY7Sm+O0EKpbIPKtmuvYTHAqRmBi6KrIIoigJzCXyWuRFIhvVeQam
         ED4FCQVH25/QzWzUqZBtU5uKbODgQ+RlpL/zWI3HzI1hYSKbeqPX+LwtfgIWxpMu7gkO
         NWHg==
X-Forwarded-Encrypted: i=1; AJvYcCW+SfjUpOwemHxGI15TPq6tR6md32hE7Ou9EaPCJ0TlJ3eq28m/JEKmrkAXzlSPuzDSvFU8VgdCyw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl55izyGKGH7KuJJzwwoU4nt9ReMpD6YFA71lJI3qx5EuTHg4i
	IFmIzdN134DfCaSCpps1H5WSjHuykVM+iB+otpGEbACpW56d5FXl05E4+YM6vv7CFDL7Z/XH+rs
	LqSehg6u1LYb08QZZLIV8sCdwLQgCM3W15coSVG39r7rklHTjKSZp
X-Gm-Gg: ASbGncuOu00Gb6J5dFRXgn42Quu799GMtMRs1k7jYnhpdCWGNuxyiuyDUJwYlJzzgj2
	ZuwH6hlh72Yr3/qIjH3AIgZ864v1wk14ToUwNpDZ2pKv6rJoztVa5roDkFMRgv4DAMctxV+hJth
	q7GCe73K9xm4/6DJ7TzOwzZcl9Hdb9kjUh022jxQR2lthE1rmZFydkXMWoRfiyCgMQHLAge6GyP
	hiIrjdfmNLswvQyOqbwQi3Xo5zIzBhx+S7tKQY9kSF8t0E3F3Q0hc5By4XE7pyiLqz7dpSa
X-Google-Smtp-Source: AGHT+IHzGh6ue1ISmfYVg1KvRCTjeVzzqsUEaYVmmzXIh45bwpQvBLxx3ZekqXYXiVSywJCD8aWgrvTId6zobtUbuY0=
X-Received: by 2002:a05:7022:405:b0:119:e56a:4fff with SMTP id
 a92af1059eb24-11df25c1a60mr4691237c88.4.1764885465413; Thu, 04 Dec 2025
 13:57:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-12-joannelkoong@gmail.com> <CADUfDZoHCf4qHE1i7S4-Ya9WgGY0q6SmN4NVRgeGu347oZ6zJA@mail.gmail.com>
 <CAJnrk1YPyfPXCggssz3qei3FBzbooSZP_VGZKJBDxxQdPZftwQ@mail.gmail.com>
In-Reply-To: <CAJnrk1YPyfPXCggssz3qei3FBzbooSZP_VGZKJBDxxQdPZftwQ@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 4 Dec 2025 13:57:33 -0800
X-Gm-Features: AWmQ_bmVsQfr98MJTzER5nv05FsSy9yVW7Bd0uco2mD75RiLvzc27D1OE-CydQ4
Message-ID: <CADUfDZr4CzmRe6q88Bh3rzfwWhF=snkqvEZuok9t9Ohwji-y0w@mail.gmail.com>
Subject: Re: [PATCH v1 11/30] io_uring/kbuf: return buffer id in buffer selection
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 11:22=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> On Wed, Dec 3, 2025 at 1:54=E2=80=AFPM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> > >
> > > Return the id of the selected buffer in io_buffer_select(). This is
> > > needed for kernel-managed buffer rings to later recycle the selected
> > > buffer.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  include/linux/io_uring/cmd.h   | 2 +-
> > >  include/linux/io_uring_types.h | 2 ++
> > >  io_uring/kbuf.c                | 7 +++++--
> > >  3 files changed, 8 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_=
types.h
> > > index e1a75cfe57d9..dcc95e73f12f 100644
> > > --- a/include/linux/io_uring_types.h
> > > +++ b/include/linux/io_uring_types.h
> > > @@ -109,6 +109,8 @@ struct io_br_sel {
> > >                 void *kaddr;
> > >         };
> > >         ssize_t val;
> > > +       /* id of the selected buffer */
> > > +       unsigned buf_id;
> >
> > Looks like this could be unioned with val? I think val's size can be
> > reduced to an int since only int values are assigned to it.
> >
>
> I'm not sure I see the advantage of this. imo I think it makes the
> interface a bit more confusing, as val also represents the error code
> and is logically its own separate entity from buf_id. I don't see the
> struct io_br_sel being stored anywhere where it seems important to
> save a few bytes, but maybe I'm missing something here.

Yeah, fair enough. Looks like it's only stored on the stack and
returned from functions. Splitting ssize_t val out of the union has
already increased its size beyond 16 bytes, so it was already too
large to fit in a register.

>
> > >  };
> > >
> > >
> > > diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > > index 8a94de6e530f..3ecb6494adea 100644
> > > --- a/io_uring/kbuf.c
> > > +++ b/io_uring/kbuf.c
> > > @@ -239,6 +239,7 @@ static struct io_br_sel io_ring_buffer_select(str=
uct io_kiocb *req, size_t *len,
> > >         req->flags |=3D REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
> > >         req->buf_index =3D buf->bid;
> > >         sel.buf_list =3D bl;
> > > +       sel.buf_id =3D buf->bid;
> >
> > This is userspace mapped, so probably should be using READ_ONCE() and
> > reusing the value between req->buf_index and buf->bid? Looks like an
> > existing bug that the reads of buf->bid and buf->addr aren't using
> > READ_ONCE().
>
> Agreed. I think that existing bug should be its own patch. Are you
> planning to submit that fix? since you found that bug, I think you
> should get the authorship for it, but if it's annoying for whatever
> reason and you prefer not to, I can roll that up into this patchset.
> EIther way, I'll rebase v2 on top of that and change this line to
> "sel.buf_id =3D req->buf_index".

Sure, happy to send a patch.

>
> >
> > >         if (bl->flags & IOBL_KERNEL_MANAGED)
> > >                 sel.kaddr =3D (void *)buf->addr;
> > >         else
> > > @@ -262,10 +263,12 @@ struct io_br_sel io_buffer_select(struct io_kio=
cb *req, size_t *len,
> > >
> > >         bl =3D io_buffer_get_list(ctx, buf_group);
> > >         if (likely(bl)) {
> > > -               if (bl->flags & IOBL_BUF_RING)
> > > +               if (bl->flags & IOBL_BUF_RING) {
> > >                         sel =3D io_ring_buffer_select(req, len, bl, i=
ssue_flags);
> > > -               else
> > > +               } else {
> > >                         sel.addr =3D io_provided_buffer_select(req, l=
en, bl);
> > > +                       sel.buf_id =3D req->buf_index;
> >
> > Could this cover both IOBL_BUF_RING and !IOBL_BUF_RING cases to avoid
> > the additional logic in io_ring_buffer_select()?
>
> Ah the next patch (patch 12/30: io_uring/kbuf: export
> io_ring_buffer_select() [1]) exports io_ring_buffer_select() to be
> directly called, so that was my motivation for having that sel.buf_id
> assignment logic in io_ring_buffer_select(). I should have swapped the
> ordering of those 2 patches to make that more clear, I'll do that for
> v2.

Makes sense. No need to switch the order of the patches.

Best,
Caleb

