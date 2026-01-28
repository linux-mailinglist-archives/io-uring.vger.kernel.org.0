Return-Path: <io-uring+bounces-11961-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHfjKSpXeWlIwgEAu9opvQ
	(envelope-from <io-uring+bounces-11961-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 01:24:10 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BECA39BA30
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 01:24:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0E4D93003734
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 00:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34D041DE8BF;
	Wed, 28 Jan 2026 00:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NRzZEruv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A383C1DE2A5
	for <io-uring@vger.kernel.org>; Wed, 28 Jan 2026 00:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769559844; cv=pass; b=M/rSNCFz7KrP5XnZr+qD4EiOsQEIf2QLBv3oFFgq7n3Mfn2w0l1R47PUcFRlJssILy/9jiMvzaOlCXpuWPE+WzfX87J0opRyTfdY8zkXMZpAQt8N+DI+gBy2jzOtdoij2GkS2bmRNrkffVVIVQyYfmumNzbTXJTqBflHsfAfHb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769559844; c=relaxed/simple;
	bh=0GspXgWsHUw0HtKJEjHl03JT3ieeDCqtlNN1s+BpAS8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sh9V5kKfMXbiFfKmdQwBprUzdsbsbdSemCb8pODCuyrc1Mf8tlv6wfenj3xrP0L/4jOG9ke3w+zGxCfmU+7qGbjUvRintrbCQI2TNwrTPtlGvLi8wB9ZGrr7TeNP7CRSMhiTyNBRhL1TYrWHLcTnNreIOAV1lhW1EVWRlfR8juc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NRzZEruv; arc=pass smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-50145d27b4cso67268081cf.2
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 16:24:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769559841; cv=none;
        d=google.com; s=arc-20240605;
        b=CfNVXC0O4h4P8NcMsV7XwsCHE3c/eg+FBoCGA//v0xLbvm5NoxPzSSICf3rLvP6l1X
         myPR6Ur8DkChdNydEbOZ/wSy0imT2hkq8ez78kJt7+Irq+x0UregRodI0JXR82Y1VgQf
         YaExeQDbMUA4q2pA45zvyKFdOk64/6/FKkQ0asPKBrJUrFBUZ+fjfukW1plu0ELcTRbm
         N2hy9JQc019CWRkl41Re6NOSLu7Us96qhqZq/w7DxjzVie6W3nkJAJJ6f+3EGM0QxuTP
         pTtljRnQdh76TSoZCnfkGAyd9Mu/ndxXvG0fijXk6uiJpWd6v+0EWcrhe9gfdtxRcwpq
         oEsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1EjESLmOpCL5ig1bPZ18vIZ3pfdUDJZgNOcnQHoP2QM=;
        fh=bodE7otOlrGm0xdFnbvjOELtQlblnLtP4ctRv1/UzAs=;
        b=lABiWRejUSyRMyfFoe7mq5+dZX/aTDM5HIcuJ4Lrh4IpH8TzFHwDj/Uj7KBLYzYHl9
         tQYGwzHqC71Lf3n/k5MvETvDgfaQ6QQwgN+OCJFu6k+jLueAnMJFm1brzYrXLJnoTYYW
         DQjGhY/v9Af4P7Kw4HwQ0qM4yJgne4AdCjcKiu/ct1nW5Q7/XCA+f+mHUIxWNNxIA/G4
         0Uhd35FXcFn6KfAYj5MOZZko9WAIJahei7SPIeym83wk30OM8RAxtU2UBUb+OdZxU7i8
         M/57CIr+2Q+8l1V1CcVyH/A5sasEkOhkX0s9Zx5R+P1YtB122HBTDxPgS1CERWcVDArF
         GP/Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769559841; x=1770164641; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1EjESLmOpCL5ig1bPZ18vIZ3pfdUDJZgNOcnQHoP2QM=;
        b=NRzZEruvbrWr/HHcOCLclGvKEX2UQjRgs2ke6BcRzEMnhUDsdwa9Dzlgi/rc7IKvFw
         eVVLN+0IjXRQkMO/mb0XpInnb0X2tDyb1XM1v7ef+nckU9oNn+v7T9B+cypmw9/Cds/F
         sLrylNrtXI+ljgJJblfIew3xgnNpqCYfiHFX2Db5jd/tHwxGw2U0L66WMK8mFWw+xbPi
         UFvLjWhq+r/Q/BHI+mNnQNwTrsE6/212iv0bFm/KZ0pG+2tdDfrSoXM7E3PFOF5YwsRL
         TTNsogpxlKUY90yTA3X9quzCoMNsgxidBIu63u4Q7jCrjgqzE6hcwF05sGL2oT4cx8UP
         O3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769559841; x=1770164641;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1EjESLmOpCL5ig1bPZ18vIZ3pfdUDJZgNOcnQHoP2QM=;
        b=Opd+A1oY3g3IZFyuIEMxFkcDBKobd/CjicOCH7dw3dSQo/Owe5CUeW62L/YldJlHaG
         UmnTYhGiLf+1WMUFYWXtVsamqesKw56umyT/n6kjC8zBIZ4g/3z91GNiFD/RPcCtaiwm
         J2dnoHO7Wzbg5ie49n9x9yS1iW9cs8k3CLtZ+FFjQQTUVfhJwrJbEuYwNw1QgWpDJwcf
         yRCaoMDjQ+1kX1/G26u96bwfgVvmvHeXoJSy08H6kKEF9DO/M7P0e79KqMEX6KNcOv0y
         98jg+q2RgT63C0+mn/KqjqngLKP2tpqGTGmE7Ua2+CikA3OMcnPzMG4yWl8SkWKm0K9N
         Hk6Q==
X-Forwarded-Encrypted: i=1; AJvYcCXi5SGCZGLPanOYm/qj/n2mIFhdWiU5cr7r/nGIw+Igxdf721JQydrE5xC0K0DwR7nwSHYlzTrgsw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiwWwzeiKOy9ZMt1qfyO61fA6K7RAx5jgq0PFgNCqnbP8fuLI0
	1PkVoKg/fBHEJh3G6cxhgQRAzzzGb40cOir7eorX9HLKraF/j9r6zIdUoCGsSkSroDwVv6aikwH
	M8EHPZ6BqAtg/3nkcpojGa0aXqRm/ZsA=
X-Gm-Gg: AZuq6aKsPv4O0AohXKML/SjKM1NvkGRa/ofGk9nqvtD4SDHLl+7mmaAsHEJGZVZRDdZ
	RxjFpTnXoay0fmLoMtl1U7SXc33HrXVZd7ax/RveT34sUjcmeUa/gLccilGkzlVkaRrw/ECl4BF
	eZQXAdsrVDcIMYxqsuneaBLDtXgNZdUZ5HjxTqIP+cKuq7BrnlG1NCYTUGpoYvemgBsD416jozu
	ZfN5H70/7/bS9T7dXf+9duNQsIl/mSUrddsH+o9TcFmPDPf3mRVPxk3ru7/j76xGYP+hg==
X-Received: by 2002:a05:622a:188e:b0:4f4:bfc8:b7be with SMTP id
 d75a77b69052e-5032f742fe3mr41527551cf.12.1769559841448; Tue, 27 Jan 2026
 16:24:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-19-joannelkoong@gmail.com> <68b3ff9d-ebcf-45c9-a50a-b5a59d332f4c@ddn.com>
In-Reply-To: <68b3ff9d-ebcf-45c9-a50a-b5a59d332f4c@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 27 Jan 2026 16:23:50 -0800
X-Gm-Features: AZwV_QixoyPCKDZ9lsSn6AbAznznwN4XRB9QfPbQSHTxY-QSZMbMl5eRsC76f9M
Message-ID: <CAJnrk1bn6A2i4Kr-W=VTUVqeewhR-eVNZXoQtDi8v4=Qyme6DQ@mail.gmail.com>
Subject: Re: [PATCH v4 18/25] fuse: support buffer copying for kernel addresses
To: Bernd Schubert <bschubert@ddn.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, csander@purestorage.com, 
	krisman@suse.de, io-uring@vger.kernel.org, asml.silence@gmail.com, 
	xiaobing.li@samsung.com, safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11961-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,ddn.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: BECA39BA30
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 3:40=E2=80=AFPM Bernd Schubert <bschubert@ddn.com> =
wrote:
>
> On 1/17/26 00:30, Joanne Koong wrote:
> > This is a preparatory patch needed to support kernel-managed ring
> > buffers in fuse-over-io-uring. For kernel-managed ring buffers, we get
> > the vmapped address of the buffer which we can directly use.
> >
> > Currently, buffer copying in fuse only supports extracting underlying
> > pages from an iov iter and kmapping them. This commit allows buffer
> > copying to work directly on a kaddr.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/dev.c        | 23 +++++++++++++++++------
> >  fs/fuse/fuse_dev_i.h |  7 ++++++-
> >  2 files changed, 23 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> > index 6d59cbc877c6..ceb5d6a553c0 100644
> > --- a/fs/fuse/dev.c
> > +++ b/fs/fuse/dev.c
> > @@ -848,6 +848,9 @@ void fuse_copy_init(struct fuse_copy_state *cs, boo=
l write,
> >  /* Unmap and put previous page of userspace buffer */
> >  void fuse_copy_finish(struct fuse_copy_state *cs)
> >  {
> > +     if (cs->is_kaddr)
> > +             return;
> > +
> >       if (cs->currbuf) {
> >               struct pipe_buffer *buf =3D cs->currbuf;
> >
> > @@ -873,6 +876,9 @@ static int fuse_copy_fill(struct fuse_copy_state *c=
s)
> >       struct page *page;
> >       int err;
> >
> > +     if (cs->is_kaddr)
> > +             return 0;
> > +
> >       err =3D unlock_request(cs->req);
> >       if (err)
> >               return err;
> > @@ -931,15 +937,20 @@ static int fuse_copy_do(struct fuse_copy_state *c=
s, void **val, unsigned *size)
> >  {
> >       unsigned ncpy =3D min(*size, cs->len);
> >       if (val) {
> > -             void *pgaddr =3D kmap_local_page(cs->pg);
> > -             void *buf =3D pgaddr + cs->offset;
> > +             void *pgaddr, *buf;
> > +             if (!cs->is_kaddr) {
> > +                     pgaddr =3D kmap_local_page(cs->pg);
> > +                     buf =3D pgaddr + cs->offset;
> > +             } else {
> > +                     buf =3D cs->kaddr + cs->offset;
> > +             }
> >
> >               if (cs->write)
> >                       memcpy(buf, *val, ncpy);
> >               else
> >                       memcpy(*val, buf, ncpy);
> > -
> > -             kunmap_local(pgaddr);
> > +             if (!cs->is_kaddr)
> > +                     kunmap_local(pgaddr);
> >               *val +=3D ncpy;
> >       }
> >       *size -=3D ncpy;
> > @@ -1127,7 +1138,7 @@ static int fuse_copy_folio(struct fuse_copy_state=
 *cs, struct folio **foliop,
> >       }
> >
> >       while (count) {
> > -             if (cs->write && cs->pipebufs && folio) {
> > +             if (cs->write && cs->pipebufs && folio && !cs->is_kaddr) =
{
> >                       /*
> >                        * Can't control lifetime of pipe buffers, so alw=
ays
> >                        * copy user pages.
> > @@ -1139,7 +1150,7 @@ static int fuse_copy_folio(struct fuse_copy_state=
 *cs, struct folio **foliop,
> >                       } else {
> >                               return fuse_ref_folio(cs, folio, offset, =
count);
> >                       }
> > -             } else if (!cs->len) {
> > +             } else if (!cs->len && !cs->is_kaddr) {
> >                       if (cs->move_folios && folio &&
> >                           offset =3D=3D 0 && count =3D=3D size) {
> >                               err =3D fuse_try_move_folio(cs, foliop);
> > diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> > index 134bf44aff0d..aa1d25421054 100644
> > --- a/fs/fuse/fuse_dev_i.h
> > +++ b/fs/fuse/fuse_dev_i.h
> > @@ -28,12 +28,17 @@ struct fuse_copy_state {
> >       struct pipe_buffer *currbuf;
> >       struct pipe_inode_info *pipe;
> >       unsigned long nr_segs;
> > -     struct page *pg;
> > +     union {
> > +             struct page *pg;
> > +             void *kaddr;
> > +     };
> >       unsigned int len;
> >       unsigned int offset;
> >       bool write:1;
> >       bool move_folios:1;
> >       bool is_uring:1;
> > +     /* if set, use kaddr; otherwise use pg */
> > +     bool is_kaddr:1;
> >       struct {
> >               unsigned int copied_sz; /* copied size into the user buff=
er */
> >       } ring;
>
>
> I'm confused here, how cs->len will get initialized. So far that was
> done from fuse_copy_fill?

With kaddrs, cs->len is initialized when the copy state is set up (in
setup_fuse_copy_state()) before we do any copying to/from the ring.
The changes for that are in the later patch that adds the ringbuffer
logic ("fuse: add io-uring kernel-managed buffer ring"). The kaddr and
len correspond to the address and length of the buffer that was
selected from the ring buffer (in fuse_uring_select_buffer()).

Thanks,
Joanne
>
>
> Thanks,
> Bernd
>
>

