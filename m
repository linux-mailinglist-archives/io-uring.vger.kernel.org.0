Return-Path: <io-uring+bounces-11546-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 67B0ED06972
	for <lists+io-uring@lfdr.de>; Fri, 09 Jan 2026 01:07:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 56733302A94B
	for <lists+io-uring@lfdr.de>; Fri,  9 Jan 2026 00:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52FE2946A;
	Fri,  9 Jan 2026 00:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OScpBk39"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53475500945
	for <io-uring@vger.kernel.org>; Fri,  9 Jan 2026 00:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767917252; cv=none; b=mlSu1/oGQnQg/T7a2gQoE/0SLamMbwiSVspnDp4KzNjuLxPGFIjh0dX5iVJCdkTJDtzd73//lEudyoi8no7NrG5c59FxZG3DP524wRPccVdionQ6r+SsLUc8qjxM5BSJvfW7VGtwytY+tfQ3veZFw/jHc/vb1OSsaKrZTE73gYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767917252; c=relaxed/simple;
	bh=At+ejiUVooGrDxCu7H9tDtKCxVkgAhpAMSZ/XVnNRH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dIYhxts6D/g+rj5Ln+KR3hKGq049b+rabmnkfSfBb4NZhBgS+BoCK1B3YKMoQiCbXWy6ZwPdIaxnFJPOutW+6cA7BenNRwykX4ZIQtEEmfhPGYW/YTIgwPB4trSQjz56el45MUysAltDPGZ6nSs7uZ0sC8wtNuXrmKoZWiafa+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OScpBk39; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4f4a88e75a5so35870081cf.0
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 16:07:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767917248; x=1768522048; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mwcHH9y0yBhD7jk8OUEheUU1VNvpy74uQAsTiO0wLZw=;
        b=OScpBk39KtESYlUHQSkkwzMaG+U06j7sJn3qtB565ezxRtcXvYK/SizKE6ft+Z4sui
         Jp/yyJmgR4bJHSgga8wce2VRrSzJjvEjBOm7j/OJ8eoRc8hbo/GtCX/qY6IejlKg4aKT
         q6cHMXvkW8MgGxXBsxxIgNQ9Q1v5z7lt/yLLJQWY9Yc13WkAIkKo3XXsLMPHYnLUo3YH
         ioNL0o75T7/iaYwqc5FUalvK8kdhDSscGkzwZyPWlMvi8yImNmDRclUFc9HQgylLuVG/
         n8Fij3I+gDAvBEQQZQ6eES76+q7YGUsAoCDnQXh98xTL2ljkzTzFqeA8frvbET1oQjJ7
         A0Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767917248; x=1768522048;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mwcHH9y0yBhD7jk8OUEheUU1VNvpy74uQAsTiO0wLZw=;
        b=Oc/Lon5ABvwNQluj6WS++6b7DJXmyXv5SSqTXvZp0eLUdF85VxHYnW6Jo5qCcJWFw+
         G/CQZOv2eJJqfNArGry0kr8ijyJyhZx4chYcHWU1zR3Qtbsry/oUi5uSTnZ/z5lMY6ED
         859sr9Nnlb8Nv1EzmsrRC7+zrRvnPSSSCjMA6c+AZeQWk2pyITBbgYdwN94YxSdQ6DMk
         LRnWLZsiMup7s0+C34JhvEe8tgoaa5f3Z3mz3nzA9DwqScwQo3zb6mXbZAkM2yt4bn/9
         fMN4gt29tXmZ9HuzVVoDRnJENQ9kZSQmW3gfdmjxKDJ/Ir6NYB56bXzE+VFYX+q4HMjj
         KqzQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfgY8r5PA29rk+vUdgAxgOONc/GLAuqfMyEdtN8FH3iAmF+upsEPbjaSik5YSMVD7rcJC3UBWXtw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0eSp9yyA3/bUGa1OEA0NryNseMPSYTQsSCDfXa1+3X9fdcq0s
	+IsS0yNLfAinziqT0tqjUsNwmsHkxxp9HQsFKUnD7dROG+KbQPwx2MJxYuLOrf+PnDVcZbukwRv
	TzclcyuMlEVZlVH49cAklRfpE6EPUeEI=
X-Gm-Gg: AY/fxX4dCcItJKc1vyiZEa0SGVFTrEv5FjmxnaW9KgiGGkyxvPTw7+aCWjAgj8seOjP
	s8YEQexPSaPbdChtuZSsbbKRGPmaOBRgUs/XedL6S7b/ydhCtM170kYHpBVscMeOLuePMw3ZJSv
	bNp9pNPdg8iO8brdSN3cIMyt7qfukHHe0rzDmWJIS52Dz3+CjaeBfgJhDJg60qlyHUUIz+QhhBF
	WiHec6nXH2GX/ZnryAj/LH6rhXzfN52OahFxVC/fG5wM4HCBfd8JgYrzwpCERH7wMU1eA==
X-Google-Smtp-Source: AGHT+IFTYUm8TBceK9AEALjEwyZjb5Ut5LIBeavM//pAxXT9DFybKze1RR/noQoH4SgtuTVmLdr2SsdEJwT6JgLYpKk=
X-Received: by 2002:a05:622a:4ccd:b0:4ee:4a3a:bd00 with SMTP id
 d75a77b69052e-4ffb4a26f43mr112332621cf.71.1767917247775; Thu, 08 Jan 2026
 16:07:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
 <20251223003522.3055912-25-joannelkoong@gmail.com> <CADUfDZpbNHtT7pvnj8E-A+5_phNnCMieu4RghdVzM93d-6_vxg@mail.gmail.com>
In-Reply-To: <CADUfDZpbNHtT7pvnj8E-A+5_phNnCMieu4RghdVzM93d-6_vxg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 8 Jan 2026 16:07:15 -0800
X-Gm-Features: AQt7F2qjPAgCG3Ln_ZTHShPRrioe3v7M09o9oZXMt6pLnMdHbfEXRGtKcs3LrCY
Message-ID: <CAJnrk1aC=mOexGtv=K2DenWCiBJnAbMfKxQGA-TY32YfxnMbXw@mail.gmail.com>
Subject: Re: [PATCH v3 24/25] fuse: add zero-copy over io-uring
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 1:15=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Dec 22, 2025 at 4:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
> > Implement zero-copy data transfer for fuse over io-uring, eliminating
> > memory copies between kernel and userspace for read/write operations.
> >
> > This is only allowed on privileged servers and requires the server to
> > preregister the following:
> > a) a sparse buffer corresponding to the queue depth
> > b) a fixed buffer at index queue_depth (the tail of the buffers)
> > c) a kernel-managed buffer ring
> >
> > The sparse buffer is where the client's pages reside. The fixed buffer
> > at the tail is where the headers (struct fuse_uring_req_header) are
> > placed. The kernel-managed buffer ring is where any non-zero-copied arg=
s
> > reside (eg out headers).
> >
> > Benchmarks with bs=3D1M showed approximately the following differences =
in
> > throughput:
> > direct randreads: ~20% increase (~2100 MB/s -> ~2600 MB/s)
> > buffered randreads: ~25% increase (~1900 MB/s -> 2400 MB/s)
> > direct randwrites: no difference (~750 MB/s)
> > buffered randwrites: ~10% increase (950 MB/s -> 1050 MB/s)
> >
> > The benchmark was run using fio on the passthrough_hp server:
> > fio --name=3Dtest_run --ioengine=3Dsync --rw=3Drand{read,write} --bs=3D=
1M
> > --size=3D1G --numjobs=3D2 --ramp_time=3D30 --group_reporting=3D1
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/dev.c             |   7 +-
> >  fs/fuse/dev_uring.c       | 176 +++++++++++++++++++++++++++++++-------
> >  fs/fuse/dev_uring_i.h     |  11 +++
> >  fs/fuse/fuse_dev_i.h      |   1 +
> >  include/uapi/linux/fuse.h |   6 +-
> >  5 files changed, 164 insertions(+), 37 deletions(-)
> >
> > diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> > index ceb5d6a553c0..0f7f2d8b3951 100644
> > --- a/fs/fuse/dev.c
> > +++ b/fs/fuse/dev.c
> > @@ -1229,8 +1229,11 @@ int fuse_copy_args(struct fuse_copy_state *cs, u=
nsigned numargs,
> >
> >         for (i =3D 0; !err && i < numargs; i++)  {
> >                 struct fuse_arg *arg =3D &args[i];
> > -               if (i =3D=3D numargs - 1 && argpages)
> > -                       err =3D fuse_copy_folios(cs, arg->size, zeroing=
);
> > +               if (i =3D=3D numargs - 1 && argpages) {
> > +                       if (cs->skip_folio_copy)
> > +                               return 0;
> > +                       return fuse_copy_folios(cs, arg->size, zeroing)=
;
> > +               }
> >                 else
> >                         err =3D fuse_copy_one(cs, arg->value, arg->size=
);
> >         }
> > diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> > index e9905f09c3ad..d13fce2750e1 100644
> > --- a/fs/fuse/dev_uring.c
> > +++ b/fs/fuse/dev_uring.c
> > @@ -89,8 +89,14 @@ static void fuse_uring_flush_bg(struct fuse_ring_que=
ue *queue)
> >         }
> >  }
> >
> > +static bool can_zero_copy_req(struct fuse_ring_ent *ent, struct fuse_r=
eq *req)
> > +{
> > +       return ent->queue->use_zero_copy &&
> > +               (req->args->in_pages || req->args->out_pages);
> > +}
> > +
> >  static void fuse_uring_req_end(struct fuse_ring_ent *ent, struct fuse_=
req *req,
> > -                              int error)
> > +                              int error, unsigned issue_flags)
> >  {
> >         struct fuse_ring_queue *queue =3D ent->queue;
> >         struct fuse_ring *ring =3D queue->ring;
> > @@ -109,6 +115,12 @@ static void fuse_uring_req_end(struct fuse_ring_en=
t *ent, struct fuse_req *req,
> >
> >         spin_unlock(&queue->lock);
> >
> > +       if (ent->zero_copied) {
> > +               WARN_ON_ONCE(io_buffer_unregister(ent->cmd, ent->fixed_=
buf_id,
>
> io_buffer_unregister() can fail if the registered buffer index has
> been unregistered or updated with a userspace buffer since the call to
> io_buffer_register_bvec(). So this WARN_ON_ONCE() can be triggered
> from userspace. I think it would be preferable to ignore the error or
> report it to the fuse server.

Sounds good, this was a remnant from when registered buffers had been
pinned. I'll remove this WARN_ON in v4.

Thanks,
Joanne
>
> Best,
> Caleb
>

