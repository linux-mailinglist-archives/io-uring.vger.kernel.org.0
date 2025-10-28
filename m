Return-Path: <io-uring+bounces-10279-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 254FFC176E6
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 00:57:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E5F2A1C66F51
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 23:57:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26BE02D9EE2;
	Tue, 28 Oct 2025 23:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WtDj0tyA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2113F2FF177
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 23:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761695830; cv=none; b=BS7AayAFuqrc4prXzIXU0q4Y/cya1DttYyhp9qycC4rtcH/a9UPvUhQa+jhdgAxqgi/1fXse8Q2dlg9WI/fh3d7Nww+A3i3kUfFXjf9fKoIefpgzJ/JiD8cv8uTLwirlir6zgGy/V8Mb0FCR21qJgrSCln8z5HbNfOO29E3BHTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761695830; c=relaxed/simple;
	bh=SSBqmFnlbcRMLkRZItOud7lNsftNyIyG863Lx97ywZ0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OzxDJH81MhYrHZ5Edo5W7hmu40IJCAKt5Mf5b8HvFIh+M5qsGP1GogahLwQJPV1+Uohh2fXfgJZVwkjD2qn+udfkX9CQ4szxNyqpx0hAPwPUJazYhSLSRrixhIwbCpAjw5A557RitXWREhm7KfzFki4Ix/JCJ6Wi4+nXTFnydTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WtDj0tyA; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4eba313770dso42168421cf.3
        for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 16:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761695826; x=1762300626; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9P3KXH28+P2sUxOoB9xNAbrRMw1fKd/W0fh4PdN5P44=;
        b=WtDj0tyAeJ227S5dSZVxWFQY0rR8+hOpKZ4iEBEDzJOjfw91PMThWStHu03ib8KKSU
         sAVM/lKuUGOyI05y2t5orhD86yKZDxx27bEEEfA5UOPkiCh3cK71E3Nu3M0dBNUYxzJU
         5txbSr9Y9VGXDfLEtDid2EIGPn2DpNpvjVib+DVW4p/u/t2Srm3Oa8UEOSa7BLS/nBmj
         Q79l4EtUlUKRgr6Zxmaw7f9dys3nRR6C2ESG9ByB3VknGrpOSS8NiKdpPr7i0VVyibYD
         uQVy03GjUnQYaSratawZgRrgn3Vnrt6SiOQJkxT9iukWVE9Nrg7MzWOKy5hXyCegp4WK
         re6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761695826; x=1762300626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9P3KXH28+P2sUxOoB9xNAbrRMw1fKd/W0fh4PdN5P44=;
        b=Sv8QjIaXY1XDJKQEe5nHnirNNc8di2ua310qfW/bbTMbgMgw6VOfw9qZWR6eNpcIH+
         sOhOvQvpEbNrcCnqciFu3CIuQb4svmDgAsineyguqvjh/gUy+w87nEBi+0gTZS2rkiP9
         es24soXq8zo2Foek+x2VXbZ/I2IewivGIqDvqNPXMHgloIv8uGL1hWLk36+f1wTmU9UG
         B3TUJcbMSAaT34Li58eLUHEOz81kRdmDjHfdhm7npjtxBH4dc0zMv/aixqDGhMnX7UBo
         AYiV9y02qqFG02rLE57BN2j1Oyaszdxw6xu0okjBpxvX7fKtBgPVyGKawY5y1tNwKgLT
         XCUA==
X-Forwarded-Encrypted: i=1; AJvYcCXoUSFSFWS6lWeWj0dgdj2GYy0IHcfQVUCLvqjNGTOe2ONryYUs9C1vqc7vpfIMOJlgsVhk67NNWQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxt4ZO8XbWPEwXTfXUUIkVhLuh+pt/xnTvEUM0FiJnCuJTDUTdx
	8yPlaP0Gocjvf1GB/Ts256QiLxpy0orkG6g7e2knwvsz5JSznfPikr/xnbmTuEeS+xGKn4WKINm
	Ro1vA7DILv8yjH7UFOIxsDoqUlSntsKU=
X-Gm-Gg: ASbGncteijE5uXa/oO1Ys9u+BecXQ2ieY5ExdNNR+JvkAJ5gQAIwxtvJxmxzpCIzp6f
	J/ik+46LdKF5Wv82GhIOeg2PbkRT5mbNgvvMphVKbDdW8WqGUNlxOAlGDjH6p9r9Z/EtZvdLWeX
	V7jpi6cOoyPdjIymQYps4ENwf+VVwONK/RfIY/uRO/bZ45CFDMLRJwZoh7z47qOzjkls00nNYgN
	C6ZuQNiXpomy7nj2Eky8zbaELh1WaU0DoNmpHqZkZf3tExWtJVa4rMc+Q7ewwMDaXavjzA67EhT
	AwVkaUFTrfAnZXaPEcf63DcQmA==
X-Google-Smtp-Source: AGHT+IHcxIfHspRESo9ht0schK7MqyLXj7zV8TOjSAIKwQYKIElXGJyXJ/SVc3zYnmNLzGdQdINZ+ni+pcxP6gJPP7U=
X-Received: by 2002:a05:622a:198a:b0:4eb:a82b:bc2e with SMTP id
 d75a77b69052e-4ed15c3636amr16667391cf.58.1761695825949; Tue, 28 Oct 2025
 16:57:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
 <20251027222808.2332692-9-joannelkoong@gmail.com> <CADUfDZrhAORbO5dz41F-bFWxNJAoYGX2JsHgPugi3JZVoWcYvg@mail.gmail.com>
In-Reply-To: <CADUfDZrhAORbO5dz41F-bFWxNJAoYGX2JsHgPugi3JZVoWcYvg@mail.gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 28 Oct 2025 16:56:54 -0700
X-Gm-Features: AWmQ_blHcYDfyZ9MpgpToJDBtJQEAg4vnLYuDh5rpQgnk1DeAorszuqLuw644HA
Message-ID: <CAJnrk1ZuxeZ__7PmzSO=KA-NjxZhq2V-QFg8U1JS2d5KmDwHvw@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] fuse: support io-uring registered buffers
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	xiaobing.li@samsung.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 6:42=E2=80=AFPM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Mon, Oct 27, 2025 at 3:29=E2=80=AFPM Joanne Koong <joannelkoong@gmail.=
com> wrote:
> >
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
> > @@ -580,6 +580,22 @@ static int fuse_uring_out_header_has_err(struct fu=
se_out_header *oh,
> >         return err;
> >  }
> >
> > +static void *get_kernel_ring_header(struct fuse_ring_ent *ent,
> > +                                   enum fuse_uring_header_type type)
> > +{
> > +       switch (type) {
> > +       case FUSE_URING_HEADER_IN_OUT:
> > +               return &ent->headers->in_out;
> > +       case FUSE_URING_HEADER_OP:
> > +               return &ent->headers->op_in;
> > +       case FUSE_URING_HEADER_RING_ENT:
> > +               return &ent->headers->ring_ent_in_out;
> > +       }
> > +
> > +       WARN_ON_ONCE(1);
> > +       return NULL;
> > +}
> > +
> >  static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
> >                                          enum fuse_uring_header_type ty=
pe)
> >  {
> > @@ -600,16 +616,22 @@ static int copy_header_to_ring(struct fuse_ring_e=
nt *ent,
> >                                enum fuse_uring_header_type type,
> >                                const void *header, size_t header_size)
> >  {
> > -       void __user *ring =3D get_user_ring_header(ent, type);
> > +       if (ent->fixed_buffer) {
> > +               void *ring =3D get_kernel_ring_header(ent, type);
> >
> > -       if (!ring)
> > -               return -EINVAL;
> > +               if (!ring)
> > +                       return -EINVAL;
> > +               memcpy(ring, header, header_size);
> > +       } else {
> > +               void __user *ring =3D get_user_ring_header(ent, type);
> >
> > -       if (copy_to_user(ring, header, header_size)) {
> > -               pr_info_ratelimited("Copying header to ring failed.\n")=
;
> > -               return -EFAULT;
> > +               if (!ring)
> > +                       return -EINVAL;
> > +               if (copy_to_user(ring, header, header_size)) {
> > +                       pr_info_ratelimited("Copying header to ring fai=
led.\n");
> > +                       return -EFAULT;
> > +               }
> >         }
> > -
> >         return 0;
> >  }
> >
> > @@ -617,14 +639,21 @@ static int copy_header_from_ring(struct fuse_ring=
_ent *ent,
> >                                  enum fuse_uring_header_type type,
> >                                  void *header, size_t header_size)
> >  {
> > -       const void __user *ring =3D get_user_ring_header(ent, type);
> > +       if (ent->fixed_buffer) {
> > +               const void *ring =3D get_kernel_ring_header(ent, type);
> >
> > -       if (!ring)
> > -               return -EINVAL;
> > +               if (!ring)
> > +                       return -EINVAL;
> > +               memcpy(header, ring, header_size);
> > +       } else {
> > +               const void __user *ring =3D get_user_ring_header(ent, t=
ype);
> >
> > -       if (copy_from_user(header, ring, header_size)) {
> > -               pr_info_ratelimited("Copying header from ring failed.\n=
");
> > -               return -EFAULT;
> > +               if (!ring)
> > +                       return -EINVAL;
> > +               if (copy_from_user(header, ring, header_size)) {
> > +                       pr_info_ratelimited("Copying header from ring f=
ailed.\n");
> > +                       return -EFAULT;
> > +               }
> >         }
> >
> >         return 0;
> > @@ -637,11 +666,15 @@ static int setup_fuse_copy_state(struct fuse_ring=
 *ring, struct fuse_req *req,
> >  {
> >         int err;
> >
> > -       err =3D import_ubuf(rw, ent->user_payload, ring->max_payload_sz=
,
> > -                         iter);
> > -       if (err) {
> > -               pr_info_ratelimited("fuse: Import of user buffer failed=
\n");
> > -               return err;
> > +       if (ent->fixed_buffer) {
> > +               *iter =3D ent->payload_iter;
> > +       } else {
> > +               err =3D import_ubuf(rw, ent->user_payload, ring->max_pa=
yload_sz,
> > +                                 iter);
> > +               if (err) {
> > +                       pr_info_ratelimited("fuse: Import of user buffe=
r failed\n");
> > +                       return err;
> > +               }
> >         }
> >
> >         fuse_copy_init(cs, rw =3D=3D ITER_DEST, iter);
> > @@ -754,6 +787,62 @@ static int fuse_uring_copy_to_ring(struct fuse_rin=
g_ent *ent,
> >                                    sizeof(req->in.h));
> >  }
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
> > +       size_t header_size =3D sizeof(struct fuse_uring_req_header);
> > +       struct iov_iter iter;
> > +       struct page *header_page;
> > +       size_t count, start;
> > +       ssize_t copied;
> > +       int err;
> > +
> > +       if (!ent->fixed_buffer)
> > +               return 0;
> > +
> > +       err =3D io_uring_cmd_import_fixed_full(ITER_DEST, &iter, ent->c=
md, 0);
> > +       if (err)
> > +               return err;
> > +
> > +       count =3D iov_iter_count(&iter);
> > +       if (count < header_size || count & (PAGE_SIZE - 1))
> > +               return -EINVAL;
> > +
> > +       /* Adjust the payload iter to protect the header from any overw=
rites */
> > +       ent->payload_iter =3D iter;
> > +       iov_iter_truncate(&ent->payload_iter, count - header_size);
> > +
> > +       /* Set up the headers */
> > +       iov_iter_advance(&iter, count - header_size);
> > +       copied =3D iov_iter_get_pages2(&iter, &header_page, header_size=
, 1, &start);
> > +       if (copied < header_size)
> > +               return -EFAULT;
> > +       ent->headers =3D kmap_local_page(header_page) + start;
> > +
> > +       /*
> > +        * We can release the acquired reference on the header page imm=
ediately
> > +        * since the page is pinned and io_uring_cmd_import_fixed_full(=
)
> > +        * prevents it from being unpinned while we are using it.
> > +        */
> > +       put_page(header_page);
> > +
> > +       return 0;
> > +}
> > +
> > +static void fuse_uring_unmap_buffer(struct fuse_ring_ent *ent)
> > +{
> > +       if (ent->fixed_buffer)
> > +               kunmap_local(ent->headers);
> > +}
> > +
> >  static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
> >                                    struct fuse_req *req)
> >  {
> > @@ -932,6 +1021,7 @@ static int fuse_uring_commit_fetch(struct io_uring=
_cmd *cmd, int issue_flags,
> >         unsigned int qid =3D READ_ONCE(cmd_req->qid);
> >         struct fuse_pqueue *fpq;
> >         struct fuse_req *req;
> > +       bool next_req;
> >
> >         err =3D -ENOTCONN;
> >         if (!ring)
> > @@ -982,6 +1072,13 @@ static int fuse_uring_commit_fetch(struct io_urin=
g_cmd *cmd, int issue_flags,
> >
> >         /* without the queue lock, as other locks are taken */
> >         fuse_uring_prepare_cancel(cmd, issue_flags, ent);
> > +
> > +       err =3D fuse_uring_map_buffer(ent);
> > +       if (err) {
> > +               fuse_uring_req_end(ent, req, err);
> > +               return err;
> > +       }
> > +
> >         fuse_uring_commit(ent, req, issue_flags);
> >
> >         /*
> > @@ -990,7 +1087,9 @@ static int fuse_uring_commit_fetch(struct io_uring=
_cmd *cmd, int issue_flags,
> >          * and fetching is done in one step vs legacy fuse, which has s=
eparated
> >          * read (fetch request) and write (commit result).
> >          */
> > -       if (fuse_uring_get_next_fuse_req(ent, queue))
> > +       next_req =3D fuse_uring_get_next_fuse_req(ent, queue);
> > +       fuse_uring_unmap_buffer(ent);
> > +       if (next_req)
> >                 fuse_uring_send(ent, cmd, 0, issue_flags);
> >         return 0;
> >  }
> > @@ -1086,39 +1185,49 @@ fuse_uring_create_ring_ent(struct io_uring_cmd =
*cmd,
> >         struct iovec iov[FUSE_URING_IOV_SEGS];
> >         int err;
> >
> > +       err =3D -ENOMEM;
> > +       ent =3D kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
> > +       if (!ent)
> > +               return ERR_PTR(err);
> > +
> > +       INIT_LIST_HEAD(&ent->list);
> > +
> > +       ent->queue =3D queue;
> > +
> > +       if (READ_ONCE(cmd->sqe->uring_cmd_flags) & IORING_URING_CMD_FIX=
ED) {
>
> Just use cmd->flags. That avoids having to deal with any possibility
> of userspace changing sqe-> uring_cmd_flags between the multiple loads
> of it.

Awesome, I'll switch this to just use cmd->flags.

Thank you for looking at the patches.
>
> > +               ent->fixed_buffer =3D true;
> > +               atomic_inc(&ring->queue_refs);
> > +               return ent;
> > +       }
> > +
> >         err =3D fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
> >         if (err) {
> >                 pr_info_ratelimited("Failed to get iovec from sqe, err=
=3D%d\n",
> >                                     err);
> > -               return ERR_PTR(err);
> > +               goto error;
> >         }
> >
> >         err =3D -EINVAL;
> >         if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
> >                 pr_info_ratelimited("Invalid header len %zu\n", iov[0].=
iov_len);
> > -               return ERR_PTR(err);
> > +               goto error;
> >         }
> >
> >         payload_size =3D iov[1].iov_len;
> >         if (payload_size < ring->max_payload_sz) {
> >                 pr_info_ratelimited("Invalid req payload len %zu\n",
> >                                     payload_size);
> > -               return ERR_PTR(err);
> > +               goto error;
> >         }
> > -
> > -       err =3D -ENOMEM;
> > -       ent =3D kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
> > -       if (!ent)
> > -               return ERR_PTR(err);
> > -
> > -       INIT_LIST_HEAD(&ent->list);
> > -
> > -       ent->queue =3D queue;
> >         ent->user_headers =3D iov[0].iov_base;
> >         ent->user_payload =3D iov[1].iov_base;
> >
> >         atomic_inc(&ring->queue_refs);
> >         return ent;
> > +
> > +error:
> > +       kfree(ent);
> > +       return ERR_PTR(err);
> >  }
> >
> >  /*
> > @@ -1249,20 +1358,29 @@ static void fuse_uring_send_in_task(struct io_u=
ring_cmd *cmd,
> >  {
> >         struct fuse_ring_ent *ent =3D uring_cmd_to_ring_ent(cmd);
> >         struct fuse_ring_queue *queue =3D ent->queue;
> > +       bool send_ent =3D true;
> >         int err;
> >
> > -       if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
> > -               err =3D fuse_uring_prepare_send(ent, ent->fuse_req);
> > -               if (err) {
> > -                       if (!fuse_uring_get_next_fuse_req(ent, queue))
> > -                               return;
> > -                       err =3D 0;
> > -               }
> > -       } else {
> > -               err =3D -ECANCELED;
> > +       if (issue_flags & IO_URING_F_TASK_DEAD) {
> > +               fuse_uring_send(ent, cmd, -ECANCELED, issue_flags);
> > +               return;
> > +       }
> > +
> > +       err =3D fuse_uring_map_buffer(ent);
> > +       if (err) {
> > +               fuse_uring_req_end(ent, ent->fuse_req, err);
> > +               return;
> > +       }
> > +
> > +       err =3D fuse_uring_prepare_send(ent, ent->fuse_req);
> > +       if (err) {
> > +               send_ent =3D fuse_uring_get_next_fuse_req(ent, queue);
> > +               err =3D 0;
> >         }
> > +       fuse_uring_unmap_buffer(ent);
> >
> > -       fuse_uring_send(ent, cmd, err, issue_flags);
> > +       if (send_ent)
> > +               fuse_uring_send(ent, cmd, err, issue_flags);
> >  }
> >
> >  static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ri=
ng *ring)
> > diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> > index 381fd0b8156a..fe14acccd6a6 100644
> > --- a/fs/fuse/dev_uring_i.h
> > +++ b/fs/fuse/dev_uring_i.h
> > @@ -7,6 +7,7 @@
> >  #ifndef _FS_FUSE_DEV_URING_I_H
> >  #define _FS_FUSE_DEV_URING_I_H
> >
> > +#include <linux/uio.h>
> >  #include "fuse_i.h"
> >
> >  #ifdef CONFIG_FUSE_IO_URING
> > @@ -38,9 +39,29 @@ enum fuse_ring_req_state {
> >
> >  /** A fuse ring entry, part of the ring queue */
> >  struct fuse_ring_ent {
> > -       /* userspace buffer */
> > -       struct fuse_uring_req_header __user *user_headers;
> > -       void __user *user_payload;
> > +       /*
> > +        * If true, the buffer was pre-registered by the daemon and the
> > +        * pages backing it are pinned in kernel memory. The fixed buff=
er layout
> > +        * is: [payload][header at end]. Use payload_iter and headers f=
or
> > +        * copying to/from the ring.
> > +        *
> > +        * Otherwise, use user_headers and user_payload which point to =
userspace
> > +        * addresses representing the ring memory.
> > +        */
> > +       bool fixed_buffer;
>
> Could use cmd->flags instead of adding this field. It's an extra
> indirection vs. space tradeoff, I guess.
>
> Best,
> Caleb
>
> > +
> > +       union {
> > +               /* fixed_buffer =3D=3D false */
> > +               struct {
> > +                       struct fuse_uring_req_header __user *user_heade=
rs;
> > +                       void __user *user_payload;
> > +               };
> > +               /* fixed_buffer =3D=3D true */
> > +               struct {
> > +                       struct fuse_uring_req_header *headers;
> > +                       struct iov_iter payload_iter;
> > +               };
> > +       };
> >
> >         /* the ring queue that owns the request */
> >         struct fuse_ring_queue *queue;
> > --
> > 2.47.3
> >

