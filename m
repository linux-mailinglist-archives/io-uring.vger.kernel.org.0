Return-Path: <io-uring+bounces-10944-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 962B4CA218A
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 02:25:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B77D6301E160
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 01:25:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BACC21E0AD;
	Thu,  4 Dec 2025 01:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="QFT4A8o2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374BE48CFC
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 01:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764811501; cv=none; b=BzMy5vc7rB4O79VF3Ph6pdsH2w1JtTszGJvGMYXuOjeoVIvvS9qKXxpYTKKaeSx9s62UgUNR/XuWtLgH/SrlGRjAQuNbqoAe9gGZyID4RdXjKQAnu/u9NqVS54pVmjWcaGJVV1A87Y9p1AW1z2E0vP1F6iq9MKYtGpvdoc19GJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764811501; c=relaxed/simple;
	bh=RKttnroyRy93FVhpyS9RK+n/P4PNhdGehK6Mu+dt5mo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jkmgzxoLrgjEZuZPDhuOAw88ZKkY7+iW1wc4vBgziM/gQbCLQDg1C/iNwYju742GumNAj0WDMBhpxmklaqEnYU9L/5CexFJ7uBJgYq/WrIuSZqgkQSe1coKBugaFRXNJLfCZ6dUvU9FiW0fTB/lIy8Ogi0I4JXht+3x8A50pVU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=QFT4A8o2; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-295351ad2f5so589655ad.3
        for <io-uring@vger.kernel.org>; Wed, 03 Dec 2025 17:24:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764811498; x=1765416298; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zZaVKELLuLVcmjlXCUl5k4A4mFIkKw5vH++/0YQ/cr8=;
        b=QFT4A8o2G03kAhyPsMi7bEgdF1uBv/zzLgwz+VdN5AXiRZ0Kh/H6CyawFnmFpERNrH
         I0fO+Aif+YxwVSZKsPKHSfBvIfWT4sQgUf5ybs1QxAkYQTtz7Px0qR9/gcWrTkSEfMBS
         Rls7M6tL4F3lnSJ91OBY61P06Ac65wW1R8xMD//FpBQRc4ZKsP8o6yWpFJkulkq4c3cn
         4HONIZgF7cFE8U0CinJLhtm7RSwfrwIfIpdeYbTkNLDcggJhOcrDOjZziYGrBVB91Fwr
         0/6KQPGcggYK9cOhHLWjIx1iKJkySX1ke8cY3rmBvBEI6yUjAtyMyLiDUxRbEVR21a0R
         rzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764811498; x=1765416298;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zZaVKELLuLVcmjlXCUl5k4A4mFIkKw5vH++/0YQ/cr8=;
        b=AG6YIbs+XsjvdE5vCHSdawTdFRVTiI6IUA5xg/kPPYFFJTg/Qk19jfmdhOTELNeXty
         0LhDXy+lKIQb4SowtQmEJeAxGJC5qMhjeu365ug8WrbaoX1OzufK/rdmVdPYA4LoXsyM
         RfQ71uYYiBAOFtqeEAn6Q0A4y4wkvD+O31fe5suDfGwGXs0aPigk87TDQDR3J4YSwZwU
         VoSJd1QSMvROn8d1AlklSJ2hTsJ6mriaQny4lscBX5i5YtAN0lcq57Sp4XkI9tu84zKD
         huFnVTGOCdkAUA9pMbwNj0kOVrDeUaQIzscAnVUnizKe7HXUlUm56d0q+JMhb21wHLxQ
         Zc3A==
X-Forwarded-Encrypted: i=1; AJvYcCWTeqHy/JGBl4m7RRJNPki/JCblrHbIXNYVHyX9ararkhYYlaGkTu2uzm5ECWHU9qeiUJeFc4+9sg==@vger.kernel.org
X-Gm-Message-State: AOJu0YymoY7YQcpFwbfG3Jy3JEt+4WchaMj5uWQhkhDX+moYEOTgklxc
	cXEJ7AZgd+ijrwJb4X/HRlakoqdZQY45C67pgZJbLXnN+vfdRziing2VvaUbYHrYcBZHPXEmeKW
	eKmx9ZkSMz8loEY5TXnWdw/hEGrWojMQV3ClEid2dwAC2y55Ri41P
X-Gm-Gg: ASbGnct0rCf3JT7zpjn+rwc/O1B3fNqAA0pAEuU8NqNazBR1C8fbeIpDVCPEVcntjKK
	HK4pkHmUuNjd1fp6WONiXHfqThrdWFVGd7Lep/4CxUTbICfSDr0jop2n3rnkU7rYEpwyGGxXt4t
	xPYvj2Lk5p3oPTvEfd88YCDlWf+RpoglLRhIOg7xxRsr5S1Dtf/JqusZBNbuXM1doUj9wzLGWmj
	wibQCMIHQm+e40kAXjDtx/dL5dE7IOR12kNPOvcGWVe4k/EARjqj5QrHbBzD4ldewO47mgOZ+LA
	a2BOZC0=
X-Google-Smtp-Source: AGHT+IHICHQPFcBj6QynH53qNyjidLtszbv4obWsI+Gcekp43kOLy1bpm5w6SbafMM9CJYPTst3yZebjt40LOVYOC6g=
X-Received: by 2002:a05:7022:49a:b0:11b:98e8:624e with SMTP id
 a92af1059eb24-11df25f6eb3mr2420243c88.4.1764811498175; Wed, 03 Dec 2025
 17:24:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-8-joannelkoong@gmail.com> <CADUfDZosVLf4vGm4_kNFReaNH3wSi2RoLXwZBc6TN0Jw__s1OQ@mail.gmail.com>
 <CAJnrk1Z_UZxmppmXXQr3joGzMSdU4ycnnGt=SacQT+6DbALDmA@mail.gmail.com>
In-Reply-To: <CAJnrk1Z_UZxmppmXXQr3joGzMSdU4ycnnGt=SacQT+6DbALDmA@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 3 Dec 2025 17:24:46 -0800
X-Gm-Features: AWmQ_bkRLC-KCE4g-zImgK3Mmwe0GWHt3524jeUGag5uMZDmIqDqXiiZ6tkBEZE
Message-ID: <CADUfDZov3Nk81k8cvdz1ZoXrbTDJfJryHjNza3ZUJyXtfE5YgQ@mail.gmail.com>
Subject: Re: [PATCH v1 07/30] io_uring/rsrc: add fixed buffer table pinning/unpinning
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 3, 2025 at 2:52=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> On Tue, Dec 2, 2025 at 8:49=E2=80=AFPM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail=
.com> wrote:
> > >
> > > Add kernel APIs to pin and unpin the buffer table for fixed buffers,
> > > preventing userspace from unregistering or updating the fixed buffers
> > > table while it is pinned by the kernel.
> > >
> > > This has two advantages:
> > > a) Eliminating the overhead of having to fetch and construct an iter =
for
> > > a fixed buffer per every cmd. Instead, the caller can pin the buffer
> > > table, fetch/construct the iter once, and use that across cmds for
> > > however long it needs to until it is ready to unpin the buffer table.
> > >
> > > b) Allowing a fixed buffer lookup at any index. The buffer table must=
 be
> > > pinned in order to allow this, otherwise we would have to keep track =
of
> > > all the nodes that have been looked up by the io_kiocb so that we can
> > > properly adjust the refcounts for those nodes. Ensuring that the buff=
er
> > > table must first be pinned before being able to fetch a buffer at any
> > > index makes things logistically a lot neater.
> >
> > Why is it necessary to pin the entire buffer table rather than
> > specific entries? That's the purpose of the existing io_rsrc_node refs
> > field.
>
> How would this work with userspace buffer unregistration (which works
> at the table level)? If buffer unregistration should still succeed
> then fuse would need a way to be notified that the buffer has been
> unregistered since the buffer belongs to userspace (eg it would be
> wrong if fuse continues using it even though fuse retains a refcount
> on it). If buffer unregistration should fail, then we would need to
> track this pinned state inside the node instead of relying just on the
> refs field, as buffers can be unregistered even if there are in-flight
> refs (eg we would need to differentiate the ref being from a pin vs
> from not a pin), and I think this would make unregistration more
> cumbersome as well (eg we would have to iterate through all the
> entries looking to see if any are pinned before iterating through them
> again to do the actual unregistration).

Not sure I would say buffer unregistration operates on the table as a
whole. Each registered buffer node is unregistered individually and
stores its own reference count. io_put_rsrc_node() will be called on
each buffer node in the table. However, io_put_rsrc_node() just
removes the one reference from the buffer node. If there are other
references on the buffer node (such as an inflight io_uring request
using it), io_free_rsrc_node() won't be called to free the buffer node
until all those references are dropped too. So fuse holding a
reference on the buffer node would allow it to be unregistered, but
prevent it from being freed until fuse dropped its reference.
I'm not sure I understand the problem with fuse continuing to hold
onto a registered buffer node after userspace has unregistered it from
the buffer table. (It looks like the buffer node in question is the
one at FUSE_URING_FIXED_HEADERS_INDEX?) Wouldn't pinning the buffer
table present similar issues? How would userspace get fuse to drop its
pin if it wants to modify the buffer registrations? I would imagine
the code path that calls io_uring_buf_table_unpin() currently could
instead call into io_put_rsrc_node() (maybe by completing an io_uring
request that has imported the registered buffer) to release its
reference on the buffer node. For ublk, userspace can request to stop
a ublk device or the kernel will do so automatically if userspace
drops its file handle (e.g. if the process exits), which will release
any io_uring resources the ublk device is using.

>
> >
> > >
> > > This is a preparatory patch for fuse io-uring's usage of fixed buffer=
s.
> > >
> > > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > > ---
> > >  include/linux/io_uring/buf.h   | 13 +++++++++++
> > >  include/linux/io_uring_types.h |  9 ++++++++
> > >  io_uring/rsrc.c                | 42 ++++++++++++++++++++++++++++++++=
++
> > >  3 files changed, 64 insertions(+)
> > >
> > > diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/bu=
f.h
> > > index 7a1cf197434d..c997c01c24c4 100644
> > > --- a/include/linux/io_uring/buf.h
> > > +++ b/include/linux/io_uring/buf.h
> > > @@ -9,6 +9,9 @@ int io_uring_buf_ring_pin(struct io_ring_ctx *ctx, un=
signed buf_group,
> > >                           unsigned issue_flags, struct io_buffer_list=
 **bl);
> > >  int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx, unsigned buf_gr=
oup,
> > >                             unsigned issue_flags);
> > > +
> > > +int io_uring_buf_table_pin(struct io_ring_ctx *ctx, unsigned issue_f=
lags);
> > > +int io_uring_buf_table_unpin(struct io_ring_ctx *ctx, unsigned issue=
_flags);
> > >  #else
> > >  static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
> > >                                         unsigned buf_group,
> > > @@ -23,6 +26,16 @@ static inline int io_uring_buf_ring_unpin(struct i=
o_ring_ctx *ctx,
> > >  {
> > >         return -EOPNOTSUPP;
> > >  }
> > > +static inline int io_uring_buf_table_pin(struct io_ring_ctx *ctx,
> > > +                                        unsigned issue_flags)
> > > +{
> > > +       return -EOPNOTSUPP;
> > > +}
> > > +static inline int io_uring_buf_table_unpin(struct io_ring_ctx *ctx,
> > > +                                          unsigned issue_flags)
> > > +{
> > > +       return -EOPNOTSUPP;
> > > +}
> > >  #endif /* CONFIG_IO_URING */
> > >
> > >  #endif /* _LINUX_IO_URING_BUF_H */
> > > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_=
types.h
> > > index 36fac08db636..e1a75cfe57d9 100644
> > > --- a/include/linux/io_uring_types.h
> > > +++ b/include/linux/io_uring_types.h
> > > @@ -57,8 +57,17 @@ struct io_wq_work {
> > >         int cancel_seq;
> > >  };
> > >
> > > +/*
> > > + * struct io_rsrc_data flag values:
> > > + *
> > > + * IO_RSRC_DATA_PINNED: data is pinned and cannot be unregistered by=
 userspace
> > > + * until it has been unpinned. Currently this is only possible on bu=
ffer tables.
> > > + */
> > > +#define IO_RSRC_DATA_PINNED            BIT(0)
> > > +
> > >  struct io_rsrc_data {
> > >         unsigned int                    nr;
> > > +       u8                              flags;
> > >         struct io_rsrc_node             **nodes;
> > >  };
> > >
> > > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > > index 3765a50329a8..67331cae0a5a 100644
> > > --- a/io_uring/rsrc.c
> > > +++ b/io_uring/rsrc.c
> > > @@ -9,6 +9,7 @@
> > >  #include <linux/hugetlb.h>
> > >  #include <linux/compat.h>
> > >  #include <linux/io_uring.h>
> > > +#include <linux/io_uring/buf.h>
> > >  #include <linux/io_uring/cmd.h>
> > >
> > >  #include <uapi/linux/io_uring.h>
> > > @@ -304,6 +305,8 @@ static int __io_sqe_buffers_update(struct io_ring=
_ctx *ctx,
> > >                 return -ENXIO;
> > >         if (up->offset + nr_args > ctx->buf_table.nr)
> > >                 return -EINVAL;
> > > +       if (ctx->buf_table.flags & IO_RSRC_DATA_PINNED)
> > > +               return -EBUSY;
> >
> > IORING_REGISTER_CLONE_BUFFERS can also be used to unregister existing
> > buffers, so it may need the check too?
>
> Ah I didn't realize this existed, thanks. imo I think it's okay to
> clone the buffers in a source ring's pinned buffer table to the
> destination ring (where the destination ring's buffer table is
> unpinned) since the clone acquires its own refcounts on the underlying
> nodes and the clone is its own entity. Do you think this makes sense
> or do you think it's better to just not allow this?

I think cloning buffers to unused buffer table slots on another ring
is fine (analogous to registering new buffers in unused slots). But
with IORING_REGISTER_DST_REPLACE set, it can also be used to
unregister whatever existing buffers happen to be registered in those
slots.

Best,
Caleb


>
> >
> > >
> > >         for (done =3D 0; done < nr_args; done++) {
> > >                 struct io_rsrc_node *node;
> > > @@ -615,6 +618,8 @@ int io_sqe_buffers_unregister(struct io_ring_ctx =
*ctx)
> > >  {
> > >         if (!ctx->buf_table.nr)
> > >                 return -ENXIO;
> > > +       if (ctx->buf_table.flags & IO_RSRC_DATA_PINNED)
> > > +               return -EBUSY;
> >
> > io_buffer_unregister_bvec() can also be used to unregister ublk
> > zero-copy buffers (also under control of userspace), so it may need
> > the check too? But maybe fuse ensures that it never uses a ublk
> > zero-copy buffer?
>
> fuse doesn't expose a way for userspace to unregister a zero-copy
> buffer, but thanks for considering this possibility.
>
> Thanks,
> Joanne
> >
> > Best,
> > Caleb

