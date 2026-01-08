Return-Path: <io-uring+bounces-11541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0FF53D06398
	for <lists+io-uring@lfdr.de>; Thu, 08 Jan 2026 22:16:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F3DF23026C34
	for <lists+io-uring@lfdr.de>; Thu,  8 Jan 2026 21:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC995335097;
	Thu,  8 Jan 2026 21:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="B8nSLmUF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360F433374B
	for <io-uring@vger.kernel.org>; Thu,  8 Jan 2026 21:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767906963; cv=none; b=Mcjc2DySUed1s7opMGB4M7GzaQSMWxfSrQjQzPqmIjAS0dw4+OZabyj0jd6tr4UDiWpOY93aFRsUklkiiIqM0Vz6EwaDajC9kWg/90HC2k6Ivr884z/tyo1297sXAJhpWCEmO0WiLG1AJiqpbcUA7SPfX4osaqKoN3+SRcUUfeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767906963; c=relaxed/simple;
	bh=mV91CFAv0CMSOutg1QJjMFiNx8DhGxn9z2yodT5pmqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jBWTeD48Slt9iK65Ahy1ir5uMbgtLrgHLNSSPCSJHKvDX4r4P3exAjj67tl9ANsNBIqH056KYDwV7enRYf2sP16yxeWbjZ+debLtlwF1DhSlnXdk3VwJurD3XYYgHF12yi/HcpiJXVuBNC6gfefnziwSvrEg8LjdyGKLzIJuYj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=B8nSLmUF; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-121b937a5bcso287168c88.1
        for <io-uring@vger.kernel.org>; Thu, 08 Jan 2026 13:15:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1767906953; x=1768511753; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/ChGGnn5MOpwMW/lLxgxacIyQ8mEa6RPzyNfni0oD2U=;
        b=B8nSLmUF4MXW+Qhn4FrT6ZOVk0x5qnJB1C0rT6uGgJCfmNOQ6rbIOdXhAWms00aeqC
         egSSNU1tDQmci3XsmEeRDIaQazFPSqZnA3uSQN32BHou5Ykh4Tvfs+Y13iwhiFa+Cwe/
         Oh+k+m29Hx5PKphSv0tACAMnjaWu2ZGBqIYHbDD+LGY06KyuHnPLLG5ewSj6fE6CWhKa
         rgXFadn43mxbikOET/prneMIKYr/sAxLjK5lenY+JyEYno5dY0JpFhGEO0nWL81l0tBj
         Sf0kBZ07ryCsuMUKFWmANzTKVMRsaSEhgezcLYP1CebtrjkWY47jVjiGeVBdBYtpaTiY
         WEKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767906953; x=1768511753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/ChGGnn5MOpwMW/lLxgxacIyQ8mEa6RPzyNfni0oD2U=;
        b=mdkQwFk5fJBOAZbAGqO1GLHb/VRmNiQ55SGel/Ld7/P1AH4D4MVfF4bbbNJLp8iVk+
         ZPZ2fRiMB62Iyj5b1q9nW++Liyqxre1246eEv+Q5jfIsZsUxLyHpn2j5SQghtDOd9xHJ
         irDvOKrtui7yMdl910egnc7fto4WsmAFgCKAW5S3q0HwRwdiVgkNbHZ6IqPdKOWfXo5T
         DUFoPh9ckvo6BwccM+tQJHOYlBMd3h58CywLrU+6xCaVV4PvFM7F/GjNOcXzqcbtOjJZ
         7oMA5K3R3M8uY7W8NnBBkOmv12BhQGRlo21jJjknLX7TkbDkPCdjl6oNOFqi7NqG+waW
         +/mQ==
X-Forwarded-Encrypted: i=1; AJvYcCVvRxgo/PBjxFNq8246BLup+R6Qr0g/0fSGtlKNpWfAdCIXsko0zUcehwZXpKf4WXgROOkJDQ2PQg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQJlSqkY1wE0Ys2Y4WKGRNDUASpEeKM9cCaWKP0tLBMUZB94j5
	b7M+gisRgepiOyD16FZxov4//vg0ob4wPfbqv7hXa5Bfe5Ua/ps59rid6pPsxnSYn0oScxVcvYz
	bMCH/dmF4ka9e96rST3fXKmoHScXTH/PP7sOedSqj+Xq5qdFj4S3o6SQ=
X-Gm-Gg: AY/fxX6itp3rvq3P1eBem57pt3EwvHCwO72xeQ2P3S48l2pnm9aqix0GRnmXBoYh5vP
	DNctitJ74jgyK2jj6rdNaVcEsEZ98guH1sbIF7aYgjOX6b6MZIP4R2D1C+eLgfzmYd25R0CWBhs
	VkgMWwA3HXZVae9mAxQcUwu3GVqBYXljHlxol079iqe7fd9TpZ1+roW2eO2Cq2ICnbZgKhXEPsV
	YrgnObu7rbGAPn5o7HPkFteF+ZowrAz1gBWvs3gbisCBxZqIRMZqJ/kN0Bq2iPOEMVAH5/i
X-Google-Smtp-Source: AGHT+IF/7lvTuj/WZa/hUrhY27uuuw0poyiBiwpamVWp4v7nAWgtk9QcslFI1lHmat73yl+L49APAIVkdOFHUTyZo3o=
X-Received: by 2002:a05:7022:b9b:b0:11b:acd7:4e48 with SMTP id
 a92af1059eb24-121f8af3392mr3766193c88.2.1767906952767; Thu, 08 Jan 2026
 13:15:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223003522.3055912-1-joannelkoong@gmail.com> <20251223003522.3055912-25-joannelkoong@gmail.com>
In-Reply-To: <20251223003522.3055912-25-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 8 Jan 2026 13:15:41 -0800
X-Gm-Features: AQt7F2ohLzc7jMiVTojPU_MUbmKgGFWmYdiFxJC5qXyrpOHxQxr_8NIE9y29P4E
Message-ID: <CADUfDZpbNHtT7pvnj8E-A+5_phNnCMieu4RghdVzM93d-6_vxg@mail.gmail.com>
Subject: Re: [PATCH v3 24/25] fuse: add zero-copy over io-uring
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, bschubert@ddn.com, 
	asml.silence@gmail.com, io-uring@vger.kernel.org, xiaobing.li@samsung.com, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 22, 2025 at 4:37=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Implement zero-copy data transfer for fuse over io-uring, eliminating
> memory copies between kernel and userspace for read/write operations.
>
> This is only allowed on privileged servers and requires the server to
> preregister the following:
> a) a sparse buffer corresponding to the queue depth
> b) a fixed buffer at index queue_depth (the tail of the buffers)
> c) a kernel-managed buffer ring
>
> The sparse buffer is where the client's pages reside. The fixed buffer
> at the tail is where the headers (struct fuse_uring_req_header) are
> placed. The kernel-managed buffer ring is where any non-zero-copied args
> reside (eg out headers).
>
> Benchmarks with bs=3D1M showed approximately the following differences in
> throughput:
> direct randreads: ~20% increase (~2100 MB/s -> ~2600 MB/s)
> buffered randreads: ~25% increase (~1900 MB/s -> 2400 MB/s)
> direct randwrites: no difference (~750 MB/s)
> buffered randwrites: ~10% increase (950 MB/s -> 1050 MB/s)
>
> The benchmark was run using fio on the passthrough_hp server:
> fio --name=3Dtest_run --ioengine=3Dsync --rw=3Drand{read,write} --bs=3D1M
> --size=3D1G --numjobs=3D2 --ramp_time=3D30 --group_reporting=3D1
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dev.c             |   7 +-
>  fs/fuse/dev_uring.c       | 176 +++++++++++++++++++++++++++++++-------
>  fs/fuse/dev_uring_i.h     |  11 +++
>  fs/fuse/fuse_dev_i.h      |   1 +
>  include/uapi/linux/fuse.h |   6 +-
>  5 files changed, 164 insertions(+), 37 deletions(-)
>
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index ceb5d6a553c0..0f7f2d8b3951 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1229,8 +1229,11 @@ int fuse_copy_args(struct fuse_copy_state *cs, uns=
igned numargs,
>
>         for (i =3D 0; !err && i < numargs; i++)  {
>                 struct fuse_arg *arg =3D &args[i];
> -               if (i =3D=3D numargs - 1 && argpages)
> -                       err =3D fuse_copy_folios(cs, arg->size, zeroing);
> +               if (i =3D=3D numargs - 1 && argpages) {
> +                       if (cs->skip_folio_copy)
> +                               return 0;
> +                       return fuse_copy_folios(cs, arg->size, zeroing);
> +               }
>                 else
>                         err =3D fuse_copy_one(cs, arg->value, arg->size);
>         }
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index e9905f09c3ad..d13fce2750e1 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -89,8 +89,14 @@ static void fuse_uring_flush_bg(struct fuse_ring_queue=
 *queue)
>         }
>  }
>
> +static bool can_zero_copy_req(struct fuse_ring_ent *ent, struct fuse_req=
 *req)
> +{
> +       return ent->queue->use_zero_copy &&
> +               (req->args->in_pages || req->args->out_pages);
> +}
> +
>  static void fuse_uring_req_end(struct fuse_ring_ent *ent, struct fuse_re=
q *req,
> -                              int error)
> +                              int error, unsigned issue_flags)
>  {
>         struct fuse_ring_queue *queue =3D ent->queue;
>         struct fuse_ring *ring =3D queue->ring;
> @@ -109,6 +115,12 @@ static void fuse_uring_req_end(struct fuse_ring_ent =
*ent, struct fuse_req *req,
>
>         spin_unlock(&queue->lock);
>
> +       if (ent->zero_copied) {
> +               WARN_ON_ONCE(io_buffer_unregister(ent->cmd, ent->fixed_bu=
f_id,

io_buffer_unregister() can fail if the registered buffer index has
been unregistered or updated with a userspace buffer since the call to
io_buffer_register_bvec(). So this WARN_ON_ONCE() can be triggered
from userspace. I think it would be preferable to ignore the error or
report it to the fuse server.

Best,
Caleb

> +                                                 issue_flags));
> +               ent->zero_copied =3D false;
> +       }
> +
>         if (error)
>                 req->out.h.error =3D error;
>
> @@ -282,6 +294,7 @@ static struct fuse_ring *fuse_uring_create(struct fus=
e_conn *fc)
>
>  static int fuse_uring_buf_ring_setup(struct io_uring_cmd *cmd,
>                                      struct fuse_ring_queue *queue,
> +                                    bool zero_copy,
>                                      unsigned int issue_flags)
>  {
>         int err;
> @@ -291,22 +304,39 @@ static int fuse_uring_buf_ring_setup(struct io_urin=
g_cmd *cmd,
>         if (err)
>                 return err;
>
> +       err =3D -EINVAL;
> +
>         if (!io_uring_cmd_is_kmbuf_ring(cmd, FUSE_URING_RINGBUF_GROUP,
> -                                       issue_flags)) {
> -               io_uring_cmd_buf_ring_unpin(cmd,
> -                                           FUSE_URING_RINGBUF_GROUP,
> -                                           issue_flags);
> -               return -EINVAL;
> +                                       issue_flags))
> +               goto error;
> +
> +       if (zero_copy) {
> +               const struct fuse_uring_cmd_req *cmd_req =3D
> +                       io_uring_sqe_cmd(cmd->sqe);
> +
> +               if (!capable(CAP_SYS_ADMIN))
> +                       goto error;
> +
> +               queue->use_zero_copy =3D true;
> +               queue->zero_copy_depth =3D READ_ONCE(cmd_req->init.queue_=
depth);
> +               if (!queue->zero_copy_depth)
> +                       goto error;
>         }
>
>         queue->use_bufring =3D true;
>
>         return 0;
> +
> +error:
> +       io_uring_cmd_buf_ring_unpin(cmd, FUSE_URING_RINGBUF_GROUP,
> +                                   issue_flags);
> +       return err;
>  }
>
>  static struct fuse_ring_queue *
>  fuse_uring_create_queue(struct io_uring_cmd *cmd, struct fuse_ring *ring=
,
> -                       int qid, bool use_bufring, unsigned int issue_fla=
gs)
> +                       int qid, bool use_bufring, bool zero_copy,
> +                       unsigned int issue_flags)
>  {
>         struct fuse_conn *fc =3D ring->fc;
>         struct fuse_ring_queue *queue;
> @@ -338,12 +368,13 @@ fuse_uring_create_queue(struct io_uring_cmd *cmd, s=
truct fuse_ring *ring,
>         fuse_pqueue_init(&queue->fpq);
>
>         if (use_bufring) {
> -               err =3D fuse_uring_buf_ring_setup(cmd, queue, issue_flags=
);
> -               if (err) {
> -                       kfree(pq);
> -                       kfree(queue);
> -                       return ERR_PTR(err);
> -               }
> +               err =3D fuse_uring_buf_ring_setup(cmd, queue, zero_copy,
> +                                               issue_flags);
> +               if (err)
> +                       goto cleanup;
> +       } else if (zero_copy) {
> +               err =3D -EINVAL;
> +               goto cleanup;
>         }
>
>         spin_lock(&fc->lock);
> @@ -361,6 +392,11 @@ fuse_uring_create_queue(struct io_uring_cmd *cmd, st=
ruct fuse_ring *ring,
>         spin_unlock(&fc->lock);
>
>         return queue;
> +
> +cleanup:
> +       kfree(pq);
> +       kfree(queue);
> +       return ERR_PTR(err);
>  }
>
>  static void fuse_uring_stop_fuse_req_end(struct fuse_req *req)
> @@ -768,6 +804,7 @@ static int setup_fuse_copy_state(struct fuse_copy_sta=
te *cs,
>                 cs->is_kaddr =3D true;
>                 cs->len =3D ent->payload_kvec.iov_len;
>                 cs->kaddr =3D ent->payload_kvec.iov_base;
> +               cs->skip_folio_copy =3D can_zero_copy_req(ent, req);
>         }
>
>         cs->is_uring =3D true;
> @@ -800,11 +837,53 @@ static int fuse_uring_copy_from_ring(struct fuse_ri=
ng *ring,
>         return err;
>  }
>
> +static int fuse_uring_set_up_zero_copy(struct fuse_ring_ent *ent,
> +                                      struct fuse_req *req,
> +                                      unsigned issue_flags)
> +{
> +       struct fuse_args_pages *ap;
> +       size_t total_bytes =3D 0;
> +       struct bio_vec *bvs;
> +       int err, ddir, i;
> +
> +       /* out_pages indicates a read, in_pages indicates a write */
> +       ddir =3D req->args->out_pages ? ITER_DEST : ITER_SOURCE;
> +
> +       ap =3D container_of(req->args, typeof(*ap), args);
> +
> +       /*
> +        * We can avoid having to allocate the bvs array when folios and
> +        * descriptors are internally represented by bvs in fuse
> +        */
> +       bvs =3D kcalloc(ap->num_folios, sizeof(*bvs), GFP_KERNEL_ACCOUNT)=
;
> +       if (!bvs)
> +               return -ENOMEM;
> +
> +       for (i =3D 0; i < ap->num_folios; i++) {
> +               total_bytes +=3D ap->descs[i].length;
> +               bvs[i].bv_page =3D folio_page(ap->folios[i], 0);
> +               bvs[i].bv_offset =3D ap->descs[i].offset;
> +               bvs[i].bv_len =3D ap->descs[i].length;
> +       }
> +
> +       err =3D io_buffer_register_bvec(ent->cmd, bvs, ap->num_folios,
> +                                     total_bytes, ddir, ent->fixed_buf_i=
d,
> +                                     issue_flags);
> +       kfree(bvs);
> +       if (err)
> +               return err;
> +
> +       ent->zero_copied =3D true;
> +
> +       return 0;
> +}
> +
>  /*
>   * Copy data from the req to the ring buffer
>   */
>  static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_r=
eq *req,
> -                                  struct fuse_ring_ent *ent)
> +                                  struct fuse_ring_ent *ent,
> +                                  unsigned int issue_flags)
>  {
>         struct fuse_copy_state cs;
>         struct fuse_args *args =3D req->args;
> @@ -837,6 +916,11 @@ static int fuse_uring_args_to_ring(struct fuse_ring =
*ring, struct fuse_req *req,
>                 num_args--;
>         }
>
> +       if (can_zero_copy_req(ent, req)) {
> +               err =3D fuse_uring_set_up_zero_copy(ent, req, issue_flags=
);
> +               if (err)
> +                       return err;
> +       }
>         /* copy the payload */
>         err =3D fuse_copy_args(&cs, num_args, args->in_pages,
>                              (struct fuse_arg *)in_args, 0);
> @@ -847,12 +931,17 @@ static int fuse_uring_args_to_ring(struct fuse_ring=
 *ring, struct fuse_req *req,
>         }
>
>         ent_in_out.payload_sz =3D cs.ring.copied_sz;
> +       if (cs.skip_folio_copy && args->in_pages)
> +               ent_in_out.payload_sz +=3D
> +                       args->in_args[args->in_numargs - 1].size;
> +
>         return copy_header_to_ring(ent, FUSE_URING_HEADER_RING_ENT,
>                                    &ent_in_out, sizeof(ent_in_out));
>  }
>
>  static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
> -                                  struct fuse_req *req)
> +                                  struct fuse_req *req,
> +                                  unsigned int issue_flags)
>  {
>         struct fuse_ring_queue *queue =3D ent->queue;
>         struct fuse_ring *ring =3D queue->ring;
> @@ -870,7 +959,7 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_e=
nt *ent,
>                 return err;
>
>         /* copy the request */
> -       err =3D fuse_uring_args_to_ring(ring, req, ent);
> +       err =3D fuse_uring_args_to_ring(ring, req, ent, issue_flags);
>         if (unlikely(err)) {
>                 pr_info_ratelimited("Copy to ring failed: %d\n", err);
>                 return err;
> @@ -881,11 +970,20 @@ static int fuse_uring_copy_to_ring(struct fuse_ring=
_ent *ent,
>                                    sizeof(req->in.h));
>  }
>
> -static bool fuse_uring_req_has_payload(struct fuse_req *req)
> +static bool fuse_uring_req_has_copyable_payload(struct fuse_ring_ent *en=
t,
> +                                               struct fuse_req *req)
>  {
>         struct fuse_args *args =3D req->args;
>
> -       return args->in_numargs > 1 || args->out_numargs;
> +       if (!can_zero_copy_req(ent, req))
> +               return args->in_numargs > 1 || args->out_numargs;
> +
> +       if ((args->in_numargs > 1) && (!args->in_pages || args->in_numarg=
s > 2))
> +               return true;
> +       if (args->out_numargs && (!args->out_pages || args->out_numargs >=
 1))
> +               return true;
> +
> +       return false;
>  }
>
>  static int fuse_uring_select_buffer(struct fuse_ring_ent *ent,
> @@ -946,7 +1044,7 @@ static int fuse_uring_next_req_update_buffer(struct =
fuse_ring_ent *ent,
>         ent->headers_iter.data_source =3D false;
>
>         buffer_selected =3D ent->payload_kvec.iov_base !=3D 0;
> -       has_payload =3D fuse_uring_req_has_payload(req);
> +       has_payload =3D fuse_uring_req_has_copyable_payload(ent, req);
>
>         if (has_payload && !buffer_selected)
>                 return fuse_uring_select_buffer(ent, issue_flags);
> @@ -972,22 +1070,23 @@ static int fuse_uring_prep_buffer(struct fuse_ring=
_ent *ent,
>         ent->headers_iter.data_source =3D false;
>
>         /* no payload to copy, can skip selecting a buffer */
> -       if (!fuse_uring_req_has_payload(req))
> +       if (!fuse_uring_req_has_copyable_payload(ent, req))
>                 return 0;
>
>         return fuse_uring_select_buffer(ent, issue_flags);
>  }
>
>  static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
> -                                  struct fuse_req *req)
> +                                  struct fuse_req *req,
> +                                  unsigned int issue_flags)
>  {
>         int err;
>
> -       err =3D fuse_uring_copy_to_ring(ent, req);
> +       err =3D fuse_uring_copy_to_ring(ent, req, issue_flags);
>         if (!err)
>                 set_bit(FR_SENT, &req->flags);
>         else
> -               fuse_uring_req_end(ent, req, err);
> +               fuse_uring_req_end(ent, req, err, issue_flags);
>
>         return err;
>  }
> @@ -1092,7 +1191,7 @@ static void fuse_uring_commit(struct fuse_ring_ent =
*ent, struct fuse_req *req,
>
>         err =3D fuse_uring_copy_from_ring(ring, req, ent);
>  out:
> -       fuse_uring_req_end(ent, req, err);
> +       fuse_uring_req_end(ent, req, err, issue_flags);
>  }
>
>  /*
> @@ -1115,7 +1214,7 @@ static bool fuse_uring_get_next_fuse_req(struct fus=
e_ring_ent *ent,
>         spin_unlock(&queue->lock);
>
>         if (req) {
> -               err =3D fuse_uring_prepare_send(ent, req);
> +               err =3D fuse_uring_prepare_send(ent, req, issue_flags);
>                 if (err)
>                         goto retry;
>         }
> @@ -1155,11 +1254,15 @@ static void fuse_uring_send(struct fuse_ring_ent =
*ent, struct io_uring_cmd *cmd,
>  static void fuse_uring_headers_cleanup(struct fuse_ring_ent *ent,
>                                        unsigned int issue_flags)
>  {
> +       u16 headers_index =3D FUSE_URING_FIXED_HEADERS_OFFSET;
> +
>         if (!ent->queue->use_bufring)
>                 return;
>
> -       WARN_ON_ONCE(io_uring_cmd_fixed_index_put(ent->cmd,
> -                                                 FUSE_URING_FIXED_HEADER=
S_OFFSET,
> +       if (ent->queue->use_zero_copy)
> +               headers_index +=3D ent->queue->zero_copy_depth;
> +
> +       WARN_ON_ONCE(io_uring_cmd_fixed_index_put(ent->cmd, headers_index=
,
>                                                   issue_flags));
>  }
>
> @@ -1167,6 +1270,7 @@ static int fuse_uring_headers_prep(struct fuse_ring=
_ent *ent, unsigned int dir,
>                                    unsigned int issue_flags)
>  {
>         size_t header_size =3D sizeof(struct fuse_uring_req_header);
> +       u16 headers_index =3D FUSE_URING_FIXED_HEADERS_OFFSET;
>         struct io_uring_cmd *cmd =3D ent->cmd;
>         unsigned int offset;
>         int err;
> @@ -1176,11 +1280,15 @@ static int fuse_uring_headers_prep(struct fuse_ri=
ng_ent *ent, unsigned int dir,
>
>         offset =3D ent->fixed_buf_id * header_size;
>
> -       err =3D io_uring_cmd_fixed_index_get(cmd, FUSE_URING_FIXED_HEADER=
S_OFFSET,
> -                                          offset, header_size, dir,
> +       if (ent->queue->use_zero_copy)
> +               headers_index +=3D ent->queue->zero_copy_depth;
> +
> +       err =3D io_uring_cmd_fixed_index_get(cmd, headers_index, offset,
> +                                          header_size, dir,
>                                            &ent->headers_iter, issue_flag=
s);
>
>         WARN_ON_ONCE(err);
> +
>         return err;
>  }
>
> @@ -1251,7 +1359,7 @@ static int fuse_uring_commit_fetch(struct io_uring_=
cmd *cmd, int issue_flags,
>
>         err =3D fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
>         if (err)
> -               fuse_uring_req_end(ent, req, err);
> +               fuse_uring_req_end(ent, req, err, issue_flags);
>         else
>                 fuse_uring_commit(ent, req, issue_flags);
>
> @@ -1413,6 +1521,7 @@ static int fuse_uring_register(struct io_uring_cmd =
*cmd,
>         const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe_cmd(cmd=
->sqe);
>         unsigned int init_flags =3D READ_ONCE(cmd_req->init.flags);
>         bool use_bufring =3D init_flags & FUSE_URING_BUF_RING;
> +       bool zero_copy =3D init_flags & FUSE_URING_ZERO_COPY;
>         struct fuse_ring *ring =3D smp_load_acquire(&fc->ring);
>         struct fuse_ring_queue *queue;
>         struct fuse_ring_ent *ent;
> @@ -1434,11 +1543,12 @@ static int fuse_uring_register(struct io_uring_cm=
d *cmd,
>         queue =3D ring->queues[qid];
>         if (!queue) {
>                 queue =3D fuse_uring_create_queue(cmd, ring, qid, use_buf=
ring,
> -                                               issue_flags);
> +                                               zero_copy, issue_flags);
>                 if (IS_ERR(queue))
>                         return PTR_ERR(queue);
>         } else {
> -               if (queue->use_bufring !=3D use_bufring)
> +               if ((queue->use_bufring !=3D use_bufring) ||
> +                   (queue->use_zero_copy !=3D zero_copy))
>                         return -EINVAL;
>         }
>
> @@ -1545,7 +1655,7 @@ static void fuse_uring_send_in_task(struct io_tw_re=
q tw_req, io_tw_token_t tw)
>                 if (fuse_uring_headers_prep(ent, ITER_DEST, issue_flags))
>                         return;
>
> -               if (fuse_uring_prepare_send(ent, ent->fuse_req))
> +               if (fuse_uring_prepare_send(ent, ent->fuse_req, issue_fla=
gs))
>                         send =3D fuse_uring_get_next_fuse_req(ent, queue,=
 issue_flags);
>                 fuse_uring_headers_cleanup(ent, issue_flags);
>                 if (!send)
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index eff14557066d..b24f89adabc1 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -57,6 +57,9 @@ struct fuse_ring_ent {
>                          */
>                         unsigned int ringbuf_buf_id;
>                         unsigned int fixed_buf_id;
> +
> +                       /* True if the request's pages are being zero-cop=
ied */
> +                       bool zero_copied;
>                 };
>         };
>
> @@ -123,6 +126,14 @@ struct fuse_ring_queue {
>
>         /* synchronized by the queue lock */
>         struct io_buffer_list *bufring;
> +
> +       /*
> +        * True if zero copy should be used for payloads. This is only en=
abled
> +        * on privileged servers. Kernel-managed ring buffers must be ena=
bled
> +        * in order to use zero copy.
> +        */
> +       bool use_zero_copy : 1;
> +       unsigned int zero_copy_depth;
>  };
>
>  /**
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index aa1d25421054..67b5bed451fe 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -39,6 +39,7 @@ struct fuse_copy_state {
>         bool is_uring:1;
>         /* if set, use kaddr; otherwise use pg */
>         bool is_kaddr:1;
> +       bool skip_folio_copy:1;
>         struct {
>                 unsigned int copied_sz; /* copied size into the user buff=
er */
>         } ring;
> diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
> index b49c8d3b9ab6..2c44219f0062 100644
> --- a/include/uapi/linux/fuse.h
> +++ b/include/uapi/linux/fuse.h
> @@ -242,7 +242,7 @@
>   *  - add FUSE_NOTIFY_PRUNE
>   *
>   *  7.46
> - *  - add fuse_uring_cmd_req init flags
> + *  - add fuse_uring_cmd_req init flags and queue_depth
>   */
>
>  #ifndef _LINUX_FUSE_H
> @@ -1299,6 +1299,7 @@ enum fuse_uring_cmd {
>
>  /* fuse_uring_cmd_req init flags */
>  #define FUSE_URING_BUF_RING    (1 << 0)
> +#define FUSE_URING_ZERO_COPY   (1 << 1)
>
>  /**
>   * In the 80B command area of the SQE.
> @@ -1315,10 +1316,11 @@ struct fuse_uring_cmd_req {
>         union {
>                 struct {
>                         uint16_t flags;
> +                       uint16_t queue_depth;
>                 } init;
>         };
>
> -       uint8_t padding[4];
> +       uint8_t padding[2];
>  };
>
>  #endif /* _LINUX_FUSE_H */
> --
> 2.47.3
>

