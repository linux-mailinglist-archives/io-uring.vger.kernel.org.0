Return-Path: <io-uring+bounces-10942-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 70330CA1DEA
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 23:53:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 8FD943004182
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 22:52:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C10102E5402;
	Wed,  3 Dec 2025 22:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WsRoChwn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8E42E1EFC
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 22:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764802366; cv=none; b=W8UviTwAidpp3iZ9OmUJBnWN5/E8q53+7avE/iaFTl84NC9fO5GJttBj3gib20geCu89UOxVtrEed/qLIPHi4ohLVRo0wKw3U2slABC/MLt8bzsBNq+dON+t0zoZGGNlR9m9guf6ySfHvr9bM6xAkU4Wtwma+yMQrBAooLfZCSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764802366; c=relaxed/simple;
	bh=xD/y9rTqW7FOq0zXkysWuwtb/3dwkSfCEND/7hNno40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RQ/j8jH7xbVZu3t7aMDk67PGC2EzkVPZ196/9MvXxQ0Ovz8m6yR2fXNmQkX+/PRttyLSJ5XgC7IAgvvzDFFS2p/3ViffnQPNS7+lQGdGEhpiMPvaEMA4YTnEjXJh8fzMTCo3cL1AE9xrVq4XRE7iN5fBAU0CLo4iTbhb1oBT57Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WsRoChwn; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee0084fd98so2727211cf.3
        for <io-uring@vger.kernel.org>; Wed, 03 Dec 2025 14:52:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764802363; x=1765407163; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYwZHp6xN+Kb+RCgLITCny8q0HDg4zkT+XXUSIUsDd0=;
        b=WsRoChwnhNALm9sBARO9r5Ug4xYd/J6Kwi1cEa1xovZGCgNK82Iw8WkuW1UC54GAPV
         4ZKsG2pbaWQ/DFdyc8ih/cffYlvEKRqIHg7EEsde7XLfvhNMGI6BMhHDieygf1NmbAsw
         +hXZNJRBBat0kQwSTBxRb/YSScnUO+vfJ2P99tCVpZVzP+s6clC8vv0xEvQ/9fUfA8UV
         9BmMHJtKLgMgw016Jih1TZM6TCaRcpAX71+ID/q/NTdCCDv+7oGPJr4PT7heulDBfpvM
         KqaY3EFnxpRz4i3yp+kV7N4dX4I6uXxkGzXgJf4AUO9Etxpdri+eBuQEgwAwLWFcSULw
         YeZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764802363; x=1765407163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iYwZHp6xN+Kb+RCgLITCny8q0HDg4zkT+XXUSIUsDd0=;
        b=uaNOpHAiBprsHyrgmFeZdfTxrxIaTOyX4FE3idUwDJJ10gGc1OOjdQ8P9l9L5zYHQa
         l7A3/mc/L4DM/2gDWP7DR0IKMFLvUlrU5HSB2XGKiy/u5x41bbLz2kfH0Xtp2vcDGNVw
         nQVWj7oFqukHDfIj4i52HZEsbSkPDrd+yZsmUXcfiIwgBXwePAZYZvY/3Z1bF48p8Doi
         XjuOtgwePXvbJZBaFFETmogVSZXVc8RZhNCwq3DHQdrYskIGpOXpa841IVfE4jx64/P2
         rmPb3pRle0cYphKvR/wHXkXcGtjosaCcErDuzFsdpNKi8He1Gw3pfLnscQny5VMhQ5RP
         vewA==
X-Forwarded-Encrypted: i=1; AJvYcCUZ0X26rCjcFtGhDr/i4DB5rCpPdCFU+SZPw/Ii88kgFc+wtfgspSKmuA8TW9nZ4UmFfZAB3BnYGw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxmlgJiAQlMfdaYgjb3JENTRNSVA+zEHRf/6//ONGRO/7PWHhYh
	MY8TNnXWAazYPuY2D4HHTkVYkNOLcgJ0oXJ+Rdqxx8KkxQvirIteA2c/AxlnTDpu1BkRc+KyhIU
	M05JaM5B702nMkdq2kmm7X89ZL+e76Kc=
X-Gm-Gg: ASbGncvxLZw+MTSTymf+ZSFw1KWMx1bJhWj9nbwADEW0O9jfmOU8O3B64VBAXL66cmK
	TiwxmDv1aEn8WnP4QgnUfAIW4v9Orh4i2VocU0NqkED98lpZ38S8+QW0H852faZAylW7GqOLAlo
	rRrY0zzYQE2HKXeVbBcClQTcw+/fQPrFJpMUqi4QHAsj1BjSZHZPwtLvG2JnDIr/YbUWR+QiTXc
	lCNkh7Teo/3D49jOzWRivmalI09
X-Google-Smtp-Source: AGHT+IGMGSt9GgtX7sGpQCeplNEuqdHqOsZZDxI7bTTCpuxbZ7j301jZEIYOtQqu9qUH5HDmvMZlDWyAT2yC4prwydc=
X-Received: by 2002:a05:622a:150:b0:4ee:22d6:1cff with SMTP id
 d75a77b69052e-4f0175a11efmr60258841cf.36.1764802362821; Wed, 03 Dec 2025
 14:52:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
 <20251203003526.2889477-8-joannelkoong@gmail.com> <CADUfDZosVLf4vGm4_kNFReaNH3wSi2RoLXwZBc6TN0Jw__s1OQ@mail.gmail.com>
In-Reply-To: <CADUfDZosVLf4vGm4_kNFReaNH3wSi2RoLXwZBc6TN0Jw__s1OQ@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 3 Dec 2025 14:52:31 -0800
X-Gm-Features: AWmQ_bnnveyjpDJqoUAeH_E_k_Dk96RMOGshqJVNwpOuDwC0Y4xd0jY6dHME5x4
Message-ID: <CAJnrk1Z_UZxmppmXXQr3joGzMSdU4ycnnGt=SacQT+6DbALDmA@mail.gmail.com>
Subject: Re: [PATCH v1 07/30] io_uring/rsrc: add fixed buffer table pinning/unpinning
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 8:49=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Tue, Dec 2, 2025 at 4:36=E2=80=AFPM Joanne Koong <joannelkoong@gmail.c=
om> wrote:
> >
> > Add kernel APIs to pin and unpin the buffer table for fixed buffers,
> > preventing userspace from unregistering or updating the fixed buffers
> > table while it is pinned by the kernel.
> >
> > This has two advantages:
> > a) Eliminating the overhead of having to fetch and construct an iter fo=
r
> > a fixed buffer per every cmd. Instead, the caller can pin the buffer
> > table, fetch/construct the iter once, and use that across cmds for
> > however long it needs to until it is ready to unpin the buffer table.
> >
> > b) Allowing a fixed buffer lookup at any index. The buffer table must b=
e
> > pinned in order to allow this, otherwise we would have to keep track of
> > all the nodes that have been looked up by the io_kiocb so that we can
> > properly adjust the refcounts for those nodes. Ensuring that the buffer
> > table must first be pinned before being able to fetch a buffer at any
> > index makes things logistically a lot neater.
>
> Why is it necessary to pin the entire buffer table rather than
> specific entries? That's the purpose of the existing io_rsrc_node refs
> field.

How would this work with userspace buffer unregistration (which works
at the table level)? If buffer unregistration should still succeed
then fuse would need a way to be notified that the buffer has been
unregistered since the buffer belongs to userspace (eg it would be
wrong if fuse continues using it even though fuse retains a refcount
on it). If buffer unregistration should fail, then we would need to
track this pinned state inside the node instead of relying just on the
refs field, as buffers can be unregistered even if there are in-flight
refs (eg we would need to differentiate the ref being from a pin vs
from not a pin), and I think this would make unregistration more
cumbersome as well (eg we would have to iterate through all the
entries looking to see if any are pinned before iterating through them
again to do the actual unregistration).

>
> >
> > This is a preparatory patch for fuse io-uring's usage of fixed buffers.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  include/linux/io_uring/buf.h   | 13 +++++++++++
> >  include/linux/io_uring_types.h |  9 ++++++++
> >  io_uring/rsrc.c                | 42 ++++++++++++++++++++++++++++++++++
> >  3 files changed, 64 insertions(+)
> >
> > diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.=
h
> > index 7a1cf197434d..c997c01c24c4 100644
> > --- a/include/linux/io_uring/buf.h
> > +++ b/include/linux/io_uring/buf.h
> > @@ -9,6 +9,9 @@ int io_uring_buf_ring_pin(struct io_ring_ctx *ctx, unsi=
gned buf_group,
> >                           unsigned issue_flags, struct io_buffer_list *=
*bl);
> >  int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx, unsigned buf_grou=
p,
> >                             unsigned issue_flags);
> > +
> > +int io_uring_buf_table_pin(struct io_ring_ctx *ctx, unsigned issue_fla=
gs);
> > +int io_uring_buf_table_unpin(struct io_ring_ctx *ctx, unsigned issue_f=
lags);
> >  #else
> >  static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
> >                                         unsigned buf_group,
> > @@ -23,6 +26,16 @@ static inline int io_uring_buf_ring_unpin(struct io_=
ring_ctx *ctx,
> >  {
> >         return -EOPNOTSUPP;
> >  }
> > +static inline int io_uring_buf_table_pin(struct io_ring_ctx *ctx,
> > +                                        unsigned issue_flags)
> > +{
> > +       return -EOPNOTSUPP;
> > +}
> > +static inline int io_uring_buf_table_unpin(struct io_ring_ctx *ctx,
> > +                                          unsigned issue_flags)
> > +{
> > +       return -EOPNOTSUPP;
> > +}
> >  #endif /* CONFIG_IO_URING */
> >
> >  #endif /* _LINUX_IO_URING_BUF_H */
> > diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_ty=
pes.h
> > index 36fac08db636..e1a75cfe57d9 100644
> > --- a/include/linux/io_uring_types.h
> > +++ b/include/linux/io_uring_types.h
> > @@ -57,8 +57,17 @@ struct io_wq_work {
> >         int cancel_seq;
> >  };
> >
> > +/*
> > + * struct io_rsrc_data flag values:
> > + *
> > + * IO_RSRC_DATA_PINNED: data is pinned and cannot be unregistered by u=
serspace
> > + * until it has been unpinned. Currently this is only possible on buff=
er tables.
> > + */
> > +#define IO_RSRC_DATA_PINNED            BIT(0)
> > +
> >  struct io_rsrc_data {
> >         unsigned int                    nr;
> > +       u8                              flags;
> >         struct io_rsrc_node             **nodes;
> >  };
> >
> > diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
> > index 3765a50329a8..67331cae0a5a 100644
> > --- a/io_uring/rsrc.c
> > +++ b/io_uring/rsrc.c
> > @@ -9,6 +9,7 @@
> >  #include <linux/hugetlb.h>
> >  #include <linux/compat.h>
> >  #include <linux/io_uring.h>
> > +#include <linux/io_uring/buf.h>
> >  #include <linux/io_uring/cmd.h>
> >
> >  #include <uapi/linux/io_uring.h>
> > @@ -304,6 +305,8 @@ static int __io_sqe_buffers_update(struct io_ring_c=
tx *ctx,
> >                 return -ENXIO;
> >         if (up->offset + nr_args > ctx->buf_table.nr)
> >                 return -EINVAL;
> > +       if (ctx->buf_table.flags & IO_RSRC_DATA_PINNED)
> > +               return -EBUSY;
>
> IORING_REGISTER_CLONE_BUFFERS can also be used to unregister existing
> buffers, so it may need the check too?

Ah I didn't realize this existed, thanks. imo I think it's okay to
clone the buffers in a source ring's pinned buffer table to the
destination ring (where the destination ring's buffer table is
unpinned) since the clone acquires its own refcounts on the underlying
nodes and the clone is its own entity. Do you think this makes sense
or do you think it's better to just not allow this?

>
> >
> >         for (done =3D 0; done < nr_args; done++) {
> >                 struct io_rsrc_node *node;
> > @@ -615,6 +618,8 @@ int io_sqe_buffers_unregister(struct io_ring_ctx *c=
tx)
> >  {
> >         if (!ctx->buf_table.nr)
> >                 return -ENXIO;
> > +       if (ctx->buf_table.flags & IO_RSRC_DATA_PINNED)
> > +               return -EBUSY;
>
> io_buffer_unregister_bvec() can also be used to unregister ublk
> zero-copy buffers (also under control of userspace), so it may need
> the check too? But maybe fuse ensures that it never uses a ublk
> zero-copy buffer?

fuse doesn't expose a way for userspace to unregister a zero-copy
buffer, but thanks for considering this possibility.

Thanks,
Joanne
>
> Best,
> Caleb

