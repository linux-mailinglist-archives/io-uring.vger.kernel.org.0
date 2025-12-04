Return-Path: <io-uring+bounces-10962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B27FCA51B9
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 20:22:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 04EA13023544
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 19:22:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 527A52DECBA;
	Thu,  4 Dec 2025 19:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EPzlYjKf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F2F1B6527
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 19:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764876168; cv=none; b=cd1nn/akdcDH8QW13+MDxbpHDrirLRG4AHv+dMQMLV4mxmRz4H+BltbiRWPFbLs/8gh0n6I67DSOZZloARO17k97j01J5Eih/YOzAGwLVzzyyH4ZjkAiD9cTp5hFkUQV8U+lXaBddRGwOOon3avgEB2EF5/LI3hfMl8IsCYQezQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764876168; c=relaxed/simple;
	bh=mGOfBEPmG1Q3Rp35eCArNKy6bUbynQIeFUMWEaU4hYc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bWm+imSsloY3phRgiS6g1APD5vzF6B+VqLak91cIcomHWC5deEclSAXL54xMAsiaRMkNA6MF1K04AybPnfO8/MGjCYM1IAMbN12b6oRohEef/g4Adj/S/hSxCyigbvELDjw5CojMVJ2fo0Tp8t53ZCTuRqgn4NvwvrUe4Tab+DI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EPzlYjKf; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ee44df7750so10996281cf.3
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 11:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764876165; x=1765480965; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qRUfxBLVaD2BUiIJM9PrjNYt0vrl8q05tvZ2QQvcI7c=;
        b=EPzlYjKfs1hXLm78hOIohNcs6H7/TkDYvQaGz4hwWojD2/evPBzFcllL7ijTarSVm0
         Cn2J/tcUkDexJ8lj+S9mBvB4bKk6cPcWyr9tcOBke4Jwx1cpS/nRovqp3gPnau4ch86R
         uozZzG1a3MaAG1HjAGhyCCnne06VZYeIa+E2CSgFtjJbjg9eS9oGCqo2nBbMd/rT/c8G
         DyKzYZPf4AWB+3QUrgjO2kbYevLb6ROLvjTGi+bqUo4W9MtlS1R4TQUolhu+8Qm7vL/d
         XubGSM6vMQ9KQ0+U7gsXwVnOY41Tj8SAK1Bo7qmoYOSygZHNpRPg6GoUNodZ/X39Lymz
         JXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764876165; x=1765480965;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qRUfxBLVaD2BUiIJM9PrjNYt0vrl8q05tvZ2QQvcI7c=;
        b=Q/ADsKeuVfTT9pRovct76565MulPoGbzfNivqRoZU0EZOy4MHOU6ayWrDfitFu8CMs
         jiEymzt+2N0ZXha7eUMtKPuUprfb9otqVF3iBwpNE6rS1LHSUR68vYCxOI85/WPTtuEk
         bJXeU06ZSLmou58cSIqVhOzkS5U+eldxAp9wgHgYFNYtwoMBdRXkViDDSeOtOe/zm3GA
         UfOQtKkr712zkqDK7c66ribxHIlKRpeARNdIlDpSofA5dWXJ5c3OnrBMpKdmrUFcMCZV
         WsDFdZYwAc7cI8wXYKz00ZnRaSouCUbL7Yl/1aIQPnQJpGYzM9oJ6nu0ec9OVgHjL34c
         jyAg==
X-Forwarded-Encrypted: i=1; AJvYcCX7GFGetgmarVPXCteTZVKt4jYEBLPtZ9mj4oTkQwtbZ7wApLMKSir1kEDVmmQHtsCOWYCbTsmrUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzOd5GVGwUtjS/1aFGS/8l0tVJ2Zae5QQJC5mbViqOem7MfObwP
	L2wV5aYbRN8uEuBi6757GAvx6P6/g3CZmMltqcm3NRlwl4TLxuIuDGxzunnNfqMo6NCBGNSkPci
	AKkjkMnfrD+PKFsccuL10EIAMB8t7xjk=
X-Gm-Gg: ASbGncup+twr55/Ci0O36CHOoZ5nXIOqJsXO7N2HA2rMnuBUXmxbgO4Mvbj5bR3PwCq
	JuJgjwgIEws5+Lm/xfdB1q/hzPKpPOOxxW1UqBLVckaawt0WEG4ga/PF/yi6nSgzIyrWiLrnAWh
	SyY7wVLhn9H0Aos2Hg8Z/eRoBexolxyVkrXfRXoLWBMWrtaTVf4rs6ZJeH/vQ7dijwMUg8/9F45
	aJxDmLtATnIEKy8T8r/sH30XLp1cEu72nhC9Hx1w8/XA+SSBvVL3jT+1DqWUYIL289QE/I1boWf
	TDU5
X-Google-Smtp-Source: AGHT+IFPMbh323+JAvtLwyERQYu3+2/PbZpT5HWq8js0GyV+H7LZEZt4a7q3yAiXV9JX2fETPaDniXWoVq/0a+fgvQI=
X-Received: by 2002:a05:622a:2c2:b0:4ee:4a3a:bd0f with SMTP id
 d75a77b69052e-4f0176955f0mr94281971cf.69.1764876165408; Thu, 04 Dec 2025
 11:22:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-12-joannelkoong@gmail.com> <CADUfDZoHCf4qHE1i7S4-Ya9WgGY0q6SmN4NVRgeGu347oZ6zJA@mail.gmail.com>
In-Reply-To: <CADUfDZoHCf4qHE1i7S4-Ya9WgGY0q6SmN4NVRgeGu347oZ6zJA@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 4 Dec 2025 11:22:34 -0800
X-Gm-Features: AWmQ_ble_W30mrAwwzaBfd_EZgJctBffhWFoX0ouusrSPuhfTQBV9AthDu10r9Y
Message-ID: <CAJnrk1YPyfPXCggssz3qei3FBzbooSZP_VGZKJBDxxQdPZftwQ@mail.gmail.com>
Subject: Re: [PATCH v1 11/30] io_uring/kbuf: return buffer id in buffer selection
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 1:54=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > Return the id of the selected buffer in io_buffer_select(). This is
> > needed for kernel-managed buffer rings to later recycle the selected
> > buffer.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/cmd.h   | 2 +-
> >  include/linux/io_uring_types.h | 2 ++
> >  io_uring/kbuf.c                | 7 +++++--
> >  3 files changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_ty=
pes.h
> > index e1a75cfe57d9..dcc95e73f12f 100644
> > --- a/include/linux/io_uring_types.h
> > +++ b/include/linux/io_uring_types.h
> > @@ -109,6 +109,8 @@ struct io_br_sel {
> >                 void *kaddr;
> >         };
> >         ssize_t val;
> > +       /* id of the selected buffer */
> > +       unsigned buf_id;
>
> Looks like this could be unioned with val? I think val's size can be
> reduced to an int since only int values are assigned to it.
>

I'm not sure I see the advantage of this. imo I think it makes the
interface a bit more confusing, as val also represents the error code
and is logically its own separate entity from buf_id. I don't see the
struct io_br_sel being stored anywhere where it seems important to
save a few bytes, but maybe I'm missing something here.

> >  };
> >
> >
> > diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > index 8a94de6e530f..3ecb6494adea 100644
> > --- a/io_uring/kbuf.c
> > +++ b/io_uring/kbuf.c
> > @@ -239,6 +239,7 @@ static struct io_br_sel io_ring_buffer_select(struc=
t io_kiocb *req, size_t *len,
> >         req->flags |=3D REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
> >         req->buf_index =3D buf->bid;
> >         sel.buf_list =3D bl;
> > +       sel.buf_id =3D buf->bid;
>
> This is userspace mapped, so probably should be using READ_ONCE() and
> reusing the value between req->buf_index and buf->bid? Looks like an
> existing bug that the reads of buf->bid and buf->addr aren't using
> READ_ONCE().

Agreed. I think that existing bug should be its own patch. Are you
planning to submit that fix? since you found that bug, I think you
should get the authorship for it, but if it's annoying for whatever
reason and you prefer not to, I can roll that up into this patchset.
EIther way, I'll rebase v2 on top of that and change this line to
"sel.buf_id =3D req->buf_index".

>
> >         if (bl->flags & IOBL_KERNEL_MANAGED)
> >                 sel.kaddr =3D (void *)buf->addr;
> >         else
> > @@ -262,10 +263,12 @@ struct io_br_sel io_buffer_select(struct io_kiocb=
 *req, size_t *len,
> >
> >         bl =3D io_buffer_get_list(ctx, buf_group);
> >         if (likely(bl)) {
> > -               if (bl->flags & IOBL_BUF_RING)
> > +               if (bl->flags & IOBL_BUF_RING) {
> >                         sel =3D io_ring_buffer_select(req, len, bl, iss=
ue_flags);
> > -               else
> > +               } else {
> >                         sel.addr =3D io_provided_buffer_select(req, len=
, bl);
> > +                       sel.buf_id =3D req->buf_index;
>
> Could this cover both IOBL_BUF_RING and !IOBL_BUF_RING cases to avoid
> the additional logic in io_ring_buffer_select()?

Ah the next patch (patch 12/30: io_uring/kbuf: export
io_ring_buffer_select() [1]) exports io_ring_buffer_select() to be
directly called, so that was my motivation for having that sel.buf_id
assignment logic in io_ring_buffer_select(). I should have swapped the
ordering of those 2 patches to make that more clear, I'll do that for
v2.

[1] https://lore.kernel.org/linux-fsdevel/20251203003526.2889477-13-joannel=
koong@gmail.com/

Thanks,
Joanne

>
> Best,
> Caleb
>
> > +               }
> >         }
> >         io_ring_submit_unlock(req->ctx, issue_flags);
> >         return sel;
> > --
> > 2.47.3
> >

