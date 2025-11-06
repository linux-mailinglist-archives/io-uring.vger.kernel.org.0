Return-Path: <io-uring+bounces-10428-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BCDC3DBC0
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 00:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D892C4E0120
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 23:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F7A7350D74;
	Thu,  6 Nov 2025 23:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wb+5BokU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCE5306B1A
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 23:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762470602; cv=none; b=IEfBhieOJAw33FDdjdSriixsW/4++AC2skwRYxhu9JvyJqsU64cfZ5xucIns1FNCT7QNKbr052wX9OdDE6V29cmzv+gxRssme9Wr5FMlGx5QJrX/nxiIc7j0DYFgUc/w8bVrzGPY74bGtplK4q1dwUMerhY7bB1gunGcT4MSNRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762470602; c=relaxed/simple;
	bh=n7JqdJN3gpe7HNJnotoXOgVUcOWeuEm30bSwulUPMkE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F1fHq7QZaRBMpDHKVAZUjt3L2VbztKe7ecZTXADLbxHBNrhoq5G/CI1rLxSTYPu6bPhwRGVglCn/P9DWHLDhT2L1wqupWGPndVcSFuOf76OKjFOxe/mxCKTTydGHX3+R7L/57jOYyLOe7oEfpYmNCZvxqRTfdo25o/fFxlZ4uAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wb+5BokU; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4e89de04d62so1385961cf.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 15:10:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762470599; x=1763075399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AHczQmclgS/+tkZTXLYiv1vB4NjNd67X8R6/+BUyaqQ=;
        b=Wb+5BokU3cegusvs/AjtTnvQQwb7JzJfDRCisXAIGof/8Ed6sA7SY5Jsqyoq/C9Eto
         zyaP3kzSlaJrQM2UxHHUd0HzibgNvMe5Pry6Xycxj8TddPZojpw4qfo7YsKnbI+PPuav
         yiECbQg/LsQ3URXlidFatG0q5iDfoRfvCbE+x2Thcb4bMFUKJkDAbyk4ga+h9U7zg60Y
         TYzd/Zi/x6kP9SB2xUOPcZpnLe3qYjfMTUeMJqqRFQB3UB1/V9KOvoQh923uSHeQZlD5
         BbsOhlOLRzwHIMDJYSqM0m/Z6Vn/mGhTe3MV5FEurpGkVxb5DRMN72ESA0HqZwKj5Nh0
         Pu1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762470599; x=1763075399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AHczQmclgS/+tkZTXLYiv1vB4NjNd67X8R6/+BUyaqQ=;
        b=EcTnT2My2ljE/ETa08YUYc9HF01TuKNJXFMevvHOXmsV+q03N1oBOZSakXvC3Q4/s7
         Ej70t+QerDQmcDt8J5i/vSOs7fatzeWuRYPcLIHHhYiKNJHJMckaJ+II5uZHIXqFRPh6
         dR8a1bn7dYkN+0aCljrhSF7FGFvAzxc+8QdiBEbHB3O00e0ooGUlXpYALbCcqWssKbzY
         jvQt4j7LotpmOssu13XlfheHAdSrMi8pqWakpt4Lnk0vv9fLzgu1H2Pq9aaQkPMFGRCN
         rYjFVs9XqC6fYZCN0MXPnvRRM4LN15e9ONQxAM/UqRoA172mmN8r/d0ytDdgZXF3hSeW
         jpBg==
X-Forwarded-Encrypted: i=1; AJvYcCUsGNdvlDPKdkcy2C4r+3yzrnZsIWBqrbR3N4xsMyxvZbdyPLPP/9yW39p88EDY0okg1EgEwvDDow==@vger.kernel.org
X-Gm-Message-State: AOJu0YykZmnV2kCBvoItzi5Xt6eA+THTStqRo0n4yTzqPnnU0ElmhtJR
	DfJTzPQiKucgk18wf9ni4rQY4c8ZI7z3OhdTEMZu5L0s3n6zFecQHYdSGG3PwXwa4qW8TJElmgb
	qSs+UBJS7kSxgr6hjtHKE89u3EcanuBc=
X-Gm-Gg: ASbGncsgFxtamNuQLbrTPNG9OqEayxSkv9InNXAT0wfEjNqs+gfmAeS4LECxM6ak2ni
	4aQoBP6pO+0Ib23/aW+R5TzuXyctkPa+jNgOmQTQO5h8DvFidI0xbBx/q0fjbjwRoReXv/HhwJp
	8vxZvhcWUMTrpDkDWCGYpUNBTDjIHRd1TRYPM54DKQOnpTOm1Gd2JAdZcF09EcCBcnxEit8+vCs
	vgZ6bw3WmCkwO99uWtNF2rlVyiQ+x+h+wGOZ2JCFn5Ubx4NbMnYUeKK6ig7g4OQBN4S15UaCwEi
	HHo24ExYjnmyRTjHk6LyAavzfQ==
X-Google-Smtp-Source: AGHT+IE7zx/lNOuzvh+WJIIb+A5DylQyCNxvT3Ad2RYJg7b7gKruXyyfSGF0E2baUuCazA7mQ2JAgrOcXJZEE3/AN8o=
X-Received: by 2002:a05:622a:58a:b0:4ed:6cac:d1b9 with SMTP id
 d75a77b69052e-4ed94a66c44mr13867571cf.63.1762470599221; Thu, 06 Nov 2025
 15:09:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-9-joannelkoong@gmail.com> <a335fd2c-03ca-4201-abcf-74809b84c426@bsbernd.com>
In-Reply-To: <a335fd2c-03ca-4201-abcf-74809b84c426@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 6 Nov 2025 15:09:48 -0800
X-Gm-Features: AWmQ_bke2NRXNF9swgCVLPdBnODqUTELjGRMQZZGgEqm5ZtMMRcDBkK5Ad4ePls
Message-ID: <CAJnrk1YPEDUbOu2N0EjfrkwK3Ge2XrNeaCY0YKL+E1t7Z8Xtvg@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] fuse: support io-uring registered buffers
To: Bernd Schubert <bernd@bsbernd.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	xiaobing.li@samsung.com, csander@purestorage.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 11:48=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
> On 10/27/25 23:28, Joanne Koong wrote:
> > Add support for io-uring registered buffers for fuse daemons
> > communicating through the io-uring interface. Daemons may register
> > buffers ahead of time, which will eliminate the overhead of
> > pinning/unpinning user pages and translating virtual addresses for ever=
y
> > server-kernel interaction.
> >
> > To support page-aligned payloads, the buffer is structured such that th=
e
> > payload is at the front of the buffer and the fuse_uring_req_header is
> > offset from the end of the buffer.
> >
> > To be backwards compatible, fuse uring still needs to support non-regis=
tered
> > buffers as well.
> >
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  fs/fuse/dev_uring.c   | 200 +++++++++++++++++++++++++++++++++---------
> >  fs/fuse/dev_uring_i.h |  27 +++++-
> >  2 files changed, 183 insertions(+), 44 deletions(-)
> >
> > diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> > index c6b22b14b354..f501bc81f331 100644
> > --- a/fs/fuse/dev_uring.c
> > +++ b/fs/fuse/dev_uring.c
> >
> > +/*
> > + * Prepare fixed buffer for access. Sets up the payload iter and kmaps=
 the
> > + * header.
> > + *
> > + * Callers must call fuse_uring_unmap_buffer() in the same scope to re=
lease the
> > + * header mapping.
> > + *
> > + * For non-fixed buffers, this is a no-op.
> > + */
> > +static int fuse_uring_map_buffer(struct fuse_ring_ent *ent)
> > +{
> > +     size_t header_size =3D sizeof(struct fuse_uring_req_header);
> > +     struct iov_iter iter;
> > +     struct page *header_page;
> > +     size_t count, start;
> > +     ssize_t copied;
> > +     int err;
> > +
> > +     if (!ent->fixed_buffer)
> > +             return 0;
> > +
> > +     err =3D io_uring_cmd_import_fixed_full(ITER_DEST, &iter, ent->cmd=
, 0);
>
> This seems to be a rather expensive call, especially as it gets
> called twice (during submit and fetch).
> Wouldn't be there be a possibility to check if the user buffer changed
> and then keep the existing iter? I think Caleb had a similar idea
> in patch 1/8.

I think the best approach is to get rid of the call entirely by
returning -EBUSY to the server if it tries unregistering the buffers
while a connection is still alive. Then we would just have to set this
up once at registration time, and use that for the lifetime of the
connection. The discussion about this with Pavel is in [1] - I'm
planning to do this as a separate follow-up.

[1] https://lore.kernel.org/linux-fsdevel/9f0debb1-ce0e-4085-a3fe-0da7a8fd7=
6a6@gmail.com/

>
> > +     if (err)
> > +             return err;
> > +
> > +     count =3D iov_iter_count(&iter);
> > +     if (count < header_size || count & (PAGE_SIZE - 1))
> > +             return -EINVAL;
>
> || !PAGE_ALIGNED(count)) ?

Nice, I didn't realize this macro existed. Thanks.

>
> > +
> > +     /* Adjust the payload iter to protect the header from any overwri=
tes */
> > +     ent->payload_iter =3D iter;
> > +     iov_iter_truncate(&ent->payload_iter, count - header_size);
> > +
> > +     /* Set up the headers */
> > +     iov_iter_advance(&iter, count - header_size);
> > +     copied =3D iov_iter_get_pages2(&iter, &header_page, header_size, =
1, &start);
>
> The iter is later used for the payload, but I miss a reset? iov_iter_reve=
rt()?

This iter is separate from the payload iter and doesn't affect the
payload iter's values because the "ent->payload_iter =3D iter;"
assignment above shallow copies that out first.

>
> > +     if (copied < header_size)
> > +             return -EFAULT;
> > +     ent->headers =3D kmap_local_page(header_page) + start;
>
> My plan for the alternative pinning patch (with io-uring) was to let the
> header be shared by multiple entries. Current libfuse master handles
> a fixed page size buffer for the payload (prepared page pinning - I
> didn't expect I was blocked for 9 months on other work), missing is to
> share it between ring entries.
> I think this wouldn't work with registered buffer approach - it
> always needs one full page?

I've been working on the patches for zero-copy and that has required
the design for registered buffers in this patch to change, namely that
the payload and the headers must be separated out. For v3, I have them
separate now.
>
> I would also like to discuss dynamic multiple payload sizes per queue.
> For example to have something like
>
> 256 x 4K
> 8 x 128K
> 4 x 1M

I think zero-copy might obviate the need for this. The way I have it
right now, it uses sparse buffers for payloads, which prevents the
server from needing to allocate the 1M buffer per ent. I'm hoping to
send out the patches for this as part of v3 at the end of next week or
next next week.

Thanks,
joanne

>
> I think there are currently two ways to do that
>
> 1) Sort entries into pools
> 2) Sort buffers into pools and let entries use these. Here the header
> would be fixed and payload would come from a pool.
>
> With the appraoch to have payload and header in one buffer we couldn't
> use 2). Using 1) should be fine, though.
>
> >
> >  /*
> > @@ -1249,20 +1358,29 @@ static void fuse_uring_send_in_task(struct io_u=
ring_cmd *cmd,
> >  {
> >       struct fuse_ring_ent *ent =3D uring_cmd_to_ring_ent(cmd);
> >       struct fuse_ring_queue *queue =3D ent->queue;
> > +     bool send_ent =3D true;
> >       int err;
> >
> > -     if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
> > -             err =3D fuse_uring_prepare_send(ent, ent->fuse_req);
> > -             if (err) {
> > -                     if (!fuse_uring_get_next_fuse_req(ent, queue))
> > -                             return;
> > -                     err =3D 0;
> > -             }
> > -     } else {
> > -             err =3D -ECANCELED;
> > +     if (issue_flags & IO_URING_F_TASK_DEAD) {
> > +             fuse_uring_send(ent, cmd, -ECANCELED, issue_flags);
> > +             return;
> > +     }
> > +
> > +     err =3D fuse_uring_map_buffer(ent);
> > +     if (err) {
> > +             fuse_uring_req_end(ent, ent->fuse_req, err);
> > +             return;
>
> I think this needs to abort the connection now. There could be multiple
> commands on the queue and they would be stuck now and there is no
> notification to fuse server either.

This approach makes sense to me and makes things a bit simpler. I'll
add this to v3.

Thanks,
Joanne

