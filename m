Return-Path: <io-uring+bounces-11551-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3D143D06A92
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 01:56:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 1F8E6301B652
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 00:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF2671AF0AF;
	Fri,  9 Jan 2026 00:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cH/XF9pR"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5D81EFF9B
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 00:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767920188; cv=none; b=tEVgo+YGHbz6o6NDtIyf6PmECY8fuUHBlFEsSjl5m6wkNhIv8OUgluT38tzAozYL/hnUPNV+MomqKte/TOaFfVRf8zSJmP5TZp+TWGUk+ob7vBBbla1FF9PjW8wbaTsqN5gy+Xxh2vw/5GU9GOpJmpS1++VZbkK8q27h+FFzJsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767920188; c=relaxed/simple;
	bh=EBkF+Awm/Gqu1SEHLfbkX23E/zsPQLY0n8LirwtqHYE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VtZqeJYuad0oHD3JeEg5ShXu3SfbwWg42iaH+W7d5glEVNf050H7l+ygFj4hOVhsQajk2GXE1EkqUkpjd8rv1brHByWrE824srHyxn8K9waTpDRIdOqNrpIVWlXOg3K1tfXKDKK5Uo6rL/uhGbPScJmYYN6RVj64JE2CQwz2N1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cH/XF9pR; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4eda6a8cc12so41531711cf.0
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 16:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767920186; x=1768524986; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZ/0YYGMHBlLH0om92lw4uC68FUWffhQPiZKxR4SsLc=;
        b=cH/XF9pRww1CYO5Vsj5YbJPaux9wn3sg/Xi8v681S6EbXD6YXQ7ywqvTBuHNJD3ppY
         RID9Phewk7HGiwZBEfhotZaCHvfLXlNTARaQ7MkttkmyAcecohh6BLx8ri3KtOK1NKoC
         CrSZ17sqRJ4SylAmAQ4+9a4xJv3MF6DXnJVbrmgH/kpHN5z8cZ8GxZOAFYRv5XegVmq1
         TJ/c/TANwbtrlxpSI+UqDsBdcMDbgepEYZuOGJQmy0dbgOa7S3XZxwPD569u8vnUyN+9
         74TBqpkeRkze9ujIc2mgHRD+eCMO3PCLAwWEnUYaZXAAX0GYJ1+6dH+/ws0g/0B+Mzdp
         MAFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767920186; x=1768524986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nZ/0YYGMHBlLH0om92lw4uC68FUWffhQPiZKxR4SsLc=;
        b=hKW1txIh/495S/GsUi3nyiv7Eh6/eUWYqn0eRnbLWciSPTP2QyZ0iCvG56UljLyiDT
         7628BygIKmE6lT4JWIoMiebalCLZhauXfEpIylUIMzFe4b2dKB9l/jBjdRCZHzSXNKiB
         l4GjddqYMaoy8qB6yK2thLy4phPPWEKJ9MgZSUrQvZn/24wRoMqFUAU7uqZ6ibKK+7rL
         0DRynJe+bYCpnFpVaK07pFEkM9IOPuMw5f3QFbl8OAgNKUHoAJ0Yk55MrBRxOrq1/Nce
         HlRnC6McqaIKglQmFGycM3N9fUfM+oD6IA7lN67zhMvan9M4V0dkCo53Boys+bQ6Da+j
         FAgQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8o9o7nbQTQyLvnK/WJOtLPDF5CPLVywAurOpJNc5ZDst94aY6Sjb/eJyhJoVIM8Ry8P9rekyw4g==@vger.kernel.org
X-Gm-Message-State: AOJu0YyVgj2ssGbXTypzBpQjD5Ood93AXdhtjPzwSDWKdgUSesVKyBm9
	zoiarVWlZVnfeVd+2fYaP1hIpzm7izfiNYRzRIROjh+BCkgUCfnab0DtGd6FyTQ9GBG4I7JjmEk
	zpjOsFk+Z3pmtv+VwcUcChAbHrzWdvt0=
X-Gm-Gg: AY/fxX4AypvUzJnsBnfk7A6susvpXpPxdryNbiMprEZzpIXeDfWuvUeAgVjuOT3YcLD
	ajU3Y8OoZfXrc7lDq3ptU70bjDCO9cSoJEVBxedcoic1mKz9wQHhObeSFYz8JgbU8luthlpA39D
	OMMcdgjKnBw36B/KClhNVQcXxjxmmbKBovx45adC9AowZ6k4/7u9wQqOnsMYEfkmlbNPYUJoYDq
	IcgJ0ESdVfegIQnyWyBMDWBZlsQEO6nqo7lIaz99Cwos/4y042PfvBdRRukdmSD1QbiCQ==
X-Google-Smtp-Source: AGHT+IE94C+oU1bynUSZQ42aiUoed0EJgx76eNJo6jYvqsYd2ODpiOG2x3TpqgxZbyGy/A1cd8oCG19NtmxyD8rAgRk=
X-Received: by 2002:ac8:5902:0:b0:4eb:9df6:5d6f with SMTP id
 d75a77b69052e-4ffb4ab7c03mr125417781cf.74.1767920186142; Thu, 08 Jan 2026
 16:56:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-6-joannelkoong@gmail.com> <CADUfDZqAWCWchX=tqJxy5Hcz1z1s=TO12teuEiz67vXvxATtKQ@mail.gmail.com>
In-Reply-To: <CADUfDZqAWCWchX=tqJxy5Hcz1z1s=TO12teuEiz67vXvxATtKQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 8 Jan 2026 16:56:15 -0800
X-Gm-Features: AQt7F2oJUQO7xLzkBGXvISshFpEnsjM8troViowC22vKL3TlgssCuTmDs4iFn08
Message-ID: <CAJnrk1ZdVaRa857nqkrH-O5eoZvHJhPfikmZ9+XvzX7sxgtiew@mail.gmail.com>
Subject: Re: [PATCH v3 05/25] io_uring/kbuf: support kernel-managed buffer
 rings in buffer selection
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 3, 2026 at 2:46=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Dec 22, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Allow kernel-managed buffers to be selected. This requires modifying th=
e
> > io_br_sel struct to separate the fields for address and val, since a
> > kernel address cannot be distinguished from a negative val when error
> > checking.
> >
> > Auto-commit any selected kernel-managed buffer.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring_types.h |  8 ++++----
> >  io_uring/kbuf.c                | 15 ++++++++++++---
> >  2 files changed, 16 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_ty=
pes.h
> > index e1adb0d20a0a..36fac08db636 100644
> > --- a/include/linux/io_uring_types.h
> > +++ b/include/linux/io_uring_types.h
> > @@ -93,13 +93,13 @@ struct io_mapped_region {
> >   */
> >  struct io_br_sel {
> >         struct io_buffer_list *buf_list;
> > -       /*
> > -        * Some selection parts return the user address, others return =
an error.
> > -        */
> >         union {
> > +               /* for classic/ring provided buffers */
> >                 void __user *addr;
> > -               ssize_t val;
> > +               /* for kernel-managed buffers */
> > +               void *kaddr;
> >         };
> > +       ssize_t val;
> >  };
> >
> >
> > diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
> > index 68469efe5552..8f63924bc9f7 100644
> > --- a/io_uring/kbuf.c
> > +++ b/io_uring/kbuf.c
> > @@ -155,7 +155,8 @@ static int io_provided_buffers_select(struct io_kio=
cb *req, size_t *len,
> >         return 1;
> >  }
> >
> > -static bool io_should_commit(struct io_kiocb *req, unsigned int issue_=
flags)
> > +static bool io_should_commit(struct io_kiocb *req, struct io_buffer_li=
st *bl,
> > +                            unsigned int issue_flags)
> >  {
> >         /*
> >         * If we came in unlocked, we have no choice but to consume the
> > @@ -170,7 +171,11 @@ static bool io_should_commit(struct io_kiocb *req,=
 unsigned int issue_flags)
> >         if (issue_flags & IO_URING_F_UNLOCKED)
> >                 return true;
> >
> > -       /* uring_cmd commits kbuf upfront, no need to auto-commit */
> > +       /* kernel-managed buffers are auto-committed */
> > +       if (bl->flags & IOBL_KERNEL_MANAGED)
> > +               return true;
> > +
> > +       /* multishot uring_cmd commits kbuf upfront, no need to auto-co=
mmit */
> >         if (!io_file_can_poll(req) && req->opcode !=3D IORING_OP_URING_=
CMD)
> >                 return true;
> >         return false;
> > @@ -201,8 +206,12 @@ static struct io_br_sel io_ring_buffer_select(stru=
ct io_kiocb *req, size_t *len,
> >         req->buf_index =3D READ_ONCE(buf->bid);
> >         sel.buf_list =3D bl;
> >         sel.addr =3D u64_to_user_ptr(READ_ONCE(buf->addr));
>
> Drop this assignment as it's overwritten by the assignments below?

Ah yes, this is a duplicate. I'll remove this for v4.

Thanks,
Joanne
>
> Best,
> Caleb
>
> > +       if (bl->flags & IOBL_KERNEL_MANAGED)
> > +               sel.kaddr =3D (void *)(uintptr_t)buf->addr;
> > +       else
> > +               sel.addr =3D u64_to_user_ptr(READ_ONCE(buf->addr));
> >
> > -       if (io_should_commit(req, issue_flags)) {
> > +       if (io_should_commit(req, bl, issue_flags)) {
> >                 io_kbuf_commit(req, sel.buf_list, *len, 1);
> >                 sel.buf_list =3D NULL;
> >         }
> > --
> > 2.47.3
> >

