Return-Path: <io-uring+bounces-6919-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBD9A4CF5D
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 00:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 57A2B172AE8
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 23:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2629E1E835C;
	Mon,  3 Mar 2025 23:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="bARvnnnC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1594E22FAC3
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 23:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741045036; cv=none; b=V7ooeUwnMenwWGDlgtlXNq0WTzuGROnEJBmmuX2qpYNPJJHiPJp1evR1KQ32eBZzcXsXx9ak5RnQbVh0Hbf0mL+RFSJNiG/CtUaE4A7k0cmdQaAVsdL8pR93Srwkc+t70ny5bgmBmP/OfMcg8ED28T/hHeX6XlIjFJnlo7Vgvv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741045036; c=relaxed/simple;
	bh=85IzurSl1UUxr5hAV9ss36BN+cpZOlSKZ9j7GD4uRCg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jwh+8DsZmWmCguzM+nO542/eXMk4EGoTKCwmJkL6iQhA/g66T/CzrJ7yz2+dgqgOZN0H0HuxAdvZ2A402Zd0Jm48sGhu0LzZXATy/dzSeIuymQluifIaPbft5QsDYnYpF7Ujj9lI4EfHbKsL/5L489oHwyNOFv2z6G4awUDH90o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=bARvnnnC; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2fe99d5f1e8so1220922a91.1
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 15:37:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1741045033; x=1741649833; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BhSuJhrpHLK55PpSu/y6zlagEkDrQeTZXejW5Sk9fc4=;
        b=bARvnnnC+hv2Gf8zgw3xyxdQJdIRHgZv+Wpf67rVdsQnFI4jWPv8xu+Iz1I7kmgk+B
         ZJOBRYONxbF0MQxZ/SP1mcRwHOc6nLSbg6KsHCWbL7fiqpEmXsy/Q3bVnjqETVZjWhsQ
         Ak0Wrgt51evzuBgvSiYEH90kAX0lW/guDwpPCxZ6WRzRZpR5y7c/Tmyxr4ymC+StRXkA
         XDTSJ4BTs3Y+H63+zYObZGJBOIIrNelId1Qcyl0vDqK9pFo9yAdT3kaiET3OsRntx/+j
         FqRM+iCHbpRE7IA9LwRa4MGaSF69VSlHg2ZBI1jKVodLcOYDTFXpykJ1rlYJDX34psLv
         907Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741045033; x=1741649833;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BhSuJhrpHLK55PpSu/y6zlagEkDrQeTZXejW5Sk9fc4=;
        b=FExQcWTc+96u3r1F3+bjpDuw/LUHNwWfwrKxcM30Du7q7Y5XAIhAGFa3lv7SkH0BSm
         3e9MGg+OPV0NU8mi5ELfL2BqVxtsar2imbqThrokyRR1MP2Xdfv9l/UqR/WqOR/XTMEP
         Wo0WQixfDoZ8+GTuQUNPDOtEdEBD6OHey/fOZ9qn+Mi7f/kJcToIhMhV8ELlv8iG6ByK
         yMrR6Xd61V09XEYMcmx1kvpJkqBf+9LpNsA9vVR6CV8mwZVPNb+Ztcd4SPCR9tZ5ZaGt
         k5NJ1+RmdGNjeWVcA+4HGmFSplPCx2ZYt52Y0H0SDMCcdBzdyihzjg4LpjtAEcMDR0UV
         Naew==
X-Gm-Message-State: AOJu0YyepR4WX0Oq2jTg2SI0NC/qrXahlFu1MnObNq37/XsFrw+IlfbY
	yUP80lQXDI2CQ28662NCxCFGn/WgPecyYwZE9Xe4GPpz51BlgJOBrI0cvJJa5oJwIsXgBKN1+uj
	REU+5Eb8n6W9pIp0OHVeXfFwSL0TVMXt7XXe+Vw==
X-Gm-Gg: ASbGncscxaCtDVZ6M8r4l4K7sfJagh5dUcRZ3rIG0HdV+yz8ueEAuAhbPMlTBJio4TC
	SqGo9cDROBfJjfk7tmLLX4JR90XWAUpZHWHL1jSyNRlk07TA0c8KJl3HwE9nYaM/mRi9WCjDuan
	V5wqhOsZvARIU2LW7ucf3W3Nhk
X-Google-Smtp-Source: AGHT+IERh7r0Fuubr1sdam9/uHsE6LS5P4S/8U5Aur/+F2lvUZAXvBjrxshtZlD1DkQM/QdenY7cfnje29OOgytaFvE=
X-Received: by 2002:a17:90b:1d85:b0:2fe:8fa0:e7a1 with SMTP id
 98e67ed59e1d1-2ff352683a5mr367547a91.2.1741045033157; Mon, 03 Mar 2025
 15:37:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1741014186.git.asml.silence@gmail.com> <444a0ab0c3dc6320c5604a06284923a7abefa145.1741014186.git.asml.silence@gmail.com>
 <CADUfDZrNCzE=X5tSOsa9rBqop-TW3Kw9oHj8u+YDxYJXGyw5uA@mail.gmail.com>
In-Reply-To: <CADUfDZrNCzE=X5tSOsa9rBqop-TW3Kw9oHj8u+YDxYJXGyw5uA@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 3 Mar 2025 15:37:01 -0800
X-Gm-Features: AQ5f1Jq-lwZSQf3PpB8H1Q1zrBXhNh4luku_yDCTonFEtVAyGm27rWC3kHs8qMw
Message-ID: <CADUfDZqay=jFXAPT+GWKn4qzsywWdfT6ryovTY=WubiOWwjqkg@mail.gmail.com>
Subject: Re: [PATCH 3/8] io_uring/rw: implement vectored registered rw
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Andres Freund <andres@anarazel.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 3:01=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Mar 3, 2025 at 7:50=E2=80=AFAM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
> >
> > Implement registered buffer vectored reads with new opcodes
> > IORING_OP_WRITEV_FIXED and IORING_OP_READV_FIXED.
> >
> > Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> > ---
> >  include/uapi/linux/io_uring.h |  2 ++
> >  io_uring/opdef.c              | 39 +++++++++++++++++++++++++++
> >  io_uring/rw.c                 | 51 +++++++++++++++++++++++++++++++++++
> >  io_uring/rw.h                 |  2 ++
> >  4 files changed, 94 insertions(+)
> >
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_urin=
g.h
> > index 1e02e94bc26d..9dd384b369ee 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -280,6 +280,8 @@ enum io_uring_op {
> >         IORING_OP_BIND,
> >         IORING_OP_LISTEN,
> >         IORING_OP_RECV_ZC,
> > +       IORING_OP_READV_FIXED,
> > +       IORING_OP_WRITEV_FIXED,
> >
> >         /* this goes last, obviously */
> >         IORING_OP_LAST,
> > diff --git a/io_uring/opdef.c b/io_uring/opdef.c
> > index 9511262c513e..6655d2cbf74d 100644
> > --- a/io_uring/opdef.c
> > +++ b/io_uring/opdef.c
> > @@ -529,6 +529,35 @@ const struct io_issue_def io_issue_defs[] =3D {
> >                 .prep                   =3D io_eopnotsupp_prep,
> >  #endif
> >         },
> > +       [IORING_OP_READV_FIXED] =3D {
> > +               .needs_file             =3D 1,
> > +               .unbound_nonreg_file    =3D 1,
> > +               .pollin                 =3D 1,
> > +               .plug                   =3D 1,
> > +               .audit_skip             =3D 1,
> > +               .ioprio                 =3D 1,
> > +               .iopoll                 =3D 1,
> > +               .iopoll_queue           =3D 1,
> > +               .vectored               =3D 1,
> > +               .async_size             =3D sizeof(struct io_async_rw),
> > +               .prep                   =3D io_prep_readv_fixed,
> > +               .issue                  =3D io_read,
> > +       },
> > +       [IORING_OP_WRITEV_FIXED] =3D {
> > +               .needs_file             =3D 1,
> > +               .hash_reg_file          =3D 1,
> > +               .unbound_nonreg_file    =3D 1,
> > +               .pollout                =3D 1,
> > +               .plug                   =3D 1,
> > +               .audit_skip             =3D 1,
> > +               .ioprio                 =3D 1,
> > +               .iopoll                 =3D 1,
> > +               .iopoll_queue           =3D 1,
> > +               .vectored               =3D 1,
> > +               .async_size             =3D sizeof(struct io_async_rw),
> > +               .prep                   =3D io_prep_writev_fixed,
> > +               .issue                  =3D io_write,
> > +       },
> >  };
> >
> >  const struct io_cold_def io_cold_defs[] =3D {
> > @@ -761,6 +790,16 @@ const struct io_cold_def io_cold_defs[] =3D {
> >         [IORING_OP_RECV_ZC] =3D {
> >                 .name                   =3D "RECV_ZC",
> >         },
> > +       [IORING_OP_READV_FIXED] =3D {
> > +               .name                   =3D "READV_FIXED",
> > +               .cleanup                =3D io_readv_writev_cleanup,
> > +               .fail                   =3D io_rw_fail,
> > +       },
> > +       [IORING_OP_WRITEV_FIXED] =3D {
> > +               .name                   =3D "WRITEV_FIXED",
> > +               .cleanup                =3D io_readv_writev_cleanup,
> > +               .fail                   =3D io_rw_fail,
> > +       },
> >  };
> >
> >  const char *io_uring_get_opcode(u8 opcode)
> > diff --git a/io_uring/rw.c b/io_uring/rw.c
> > index ad7f647d48e9..4c4229f41aaa 100644
> > --- a/io_uring/rw.c
> > +++ b/io_uring/rw.c
> > @@ -381,6 +381,57 @@ int io_prep_write_fixed(struct io_kiocb *req, cons=
t struct io_uring_sqe *sqe)
> >         return __io_prep_rw(req, sqe, ITER_SOURCE);
> >  }
> >
> > +static int io_rw_prep_reg_vec(struct io_kiocb *req, int ddir)
> > +{
> > +       struct io_rw *rw =3D io_kiocb_to_cmd(req, struct io_rw);
> > +       struct io_async_rw *io =3D req->async_data;
> > +       const struct iovec __user *uvec;
> > +       size_t uvec_segs =3D rw->len;
> > +       struct iovec *iov;
> > +       int iovec_off, ret;
> > +       void *res;
> > +
> > +       if (uvec_segs > io->vec.nr) {
> > +               ret =3D io_vec_realloc(&io->vec, uvec_segs);
> > +               if (ret)
> > +                       return ret;
> > +               req->flags |=3D REQ_F_NEED_CLEANUP;
> > +       }
> > +       /* pad iovec to the right */
> > +       iovec_off =3D io->vec.nr - uvec_segs;
> > +       iov =3D io->vec.iovec + iovec_off;
> > +       uvec =3D u64_to_user_ptr(rw->addr);
> > +       res =3D iovec_from_user(uvec, uvec_segs, uvec_segs, iov,
> > +                             io_is_compat(req->ctx));
> > +       if (IS_ERR(res))
> > +               return PTR_ERR(res);
> > +
> > +       ret =3D io_import_reg_vec(ddir, &io->iter, req, &io->vec,
> > +                               uvec_segs, iovec_off, 0);
>
> So the iovecs are being imported at prep time rather than issue time?
> I suppose since only user registered buffers are allowed and not
> kernel bvecs, you aren't concerned about interactions with the ublk
> bvec register/unregister operations? I think in principle the
> difference between prep and issue time is still observable if the same
> registered buffer index is being used alternately for user and kernel
> registered buffers.

Never mind, I see you change this in the next patch.

Best,
Caleb

