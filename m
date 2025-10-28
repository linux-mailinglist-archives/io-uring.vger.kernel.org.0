Return-Path: <io-uring+bounces-10261-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AD9EC12934
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 02:42:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 92A113483E4
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 01:42:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06F1246786;
	Tue, 28 Oct 2025 01:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Yad/B2Wt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCDD137932
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 01:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761615745; cv=none; b=F/zhMctWHhVN3/Np9gVARrkgMaqqQ4ilEUXoCLKw+Uc2ELycqjQQtw1z8opolKNPo3mB3h/uw61P1UWHfLaX4znOl+slWeb6aPVOabuj3pnXokzmfajE10ZY83XifBdSzpMyb3jxEYSkPX0YjBkt+jIBKViHtw8j6IAyD4Pnwac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761615745; c=relaxed/simple;
	bh=G2Av2hPaaotcqN3f4CBmf4krVac8uYQlBJ8vtO77oGg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KxMy/WcIALIlN/l8OO9ogLLnSOjSj362nQpv19DtpBdnkVGfSQlXBZPhoLxeGs3K0TCjFs7Qe7kuqi68fKr5rNETsa1DxddAAkwl5w5zurIzAlrq9wIhHgtUGUi3/hcwfOW+uFWAvQ7JSh3cm90gXrenqdjMxzsXsKrn3JeoUUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Yad/B2Wt; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29498a10972so3062925ad.0
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 18:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761615743; x=1762220543; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AjRDu2cRp4IpAzclxg6KyeZUjym5TIt86oGJKi1MNpg=;
        b=Yad/B2WtLn7D6PMf95E/umDbYQoUs+SwKuqlhCTMOUH8eDTryGKEOUK9mNL/Lf2A8B
         VBHS+vPRE7s330pDu9jQtypiL/I1qF+whq2z8iMv8suE3pAi5s7XwCcGRxc0rGjkFoD8
         CG6gWj9meCVIRGq8WuMn3F+Ykz7eEoMDGPltVRGaYzumHN4F3+dJe7mzW51ivy+DSKrW
         ME57TgN5kkVQLfFu9cHXk95pbymCpKIJQd/udbquhHD17Hl8eEpiGHcTGGd7mMRNYxAa
         UkYvmNtSkyVyYfA3lNzZDUqIaNtko4/2EbL7k6sv3eeQ7zmkfsTaamU+90PAAFUeuaHy
         QIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761615743; x=1762220543;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AjRDu2cRp4IpAzclxg6KyeZUjym5TIt86oGJKi1MNpg=;
        b=wLOSqP3yWtQmkcN2HoeDExiJlsCKrrvxSFrwBIcIae4+YZMM1ay1ZaGCUehFyGlZV6
         kn/uEg28xiwMLnLZG72TI9ZhJRNd129vci/q/QbVopAyGYvxtlVU+6dva7n8H/zt9fI/
         3lkiEk0EZLdVlugLwCqFYJ5v+BfsdqpLFhPz3PTDggwVhroTCJBikT2E55NtEM7XpZF3
         IBymaiHcMWWBpn+F+qxXWrnq+VrtK+S4+JcJxOB+9MhKm3FhowF0YUxIltVtUDVXXq+r
         G1xFosgEsclNxhrYiJJeDjLmg+UBHv0W0uSBEALOsSwtcW8wJlJq93bIpfXMmmr5H2wQ
         dPBw==
X-Forwarded-Encrypted: i=1; AJvYcCXi/gt6t0hWlkO4ifZc4TRLEieUHM9EIazHqavAh9V0Vzgb3MLgWjQTZWcssADE5sgYW/r/TeUv+A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/gkYK3XFVu4oT9GVSr+hnOXeIC9irWNNoRpF4/uuO30nudYN4
	n7HqFz0rEDz5LJL4G78GZ1c0kql2Ajl2o6lgTG4aMvJQ8We1aUgkc5166+Q1AiYD0OUQ6res+i6
	qRsY4KkvJ3e4bX97rQjbVyJrPuu2fGx11WP33aMWTNA==
X-Gm-Gg: ASbGncuw8NvZpZdAv5CtDMzAWnqIVtyOm7pAaI/DnXUxP8Q1ZS7Gx+dnaXRGSdNjF58
	rzojvlZRVuGZlYzPUTp+/r1/GCGLcbffT8zyE7d9VUxNtieaXnmeFRegRFTlDFxLB/RQUOjV9Sd
	+lKP8O0naBSqhXaOk70i/jh5/PWFHGh3Km8ehUUNBi0GGE8YBOltV+vIJLPdDodOJNwFGCstv7x
	m7sBJlXmysyKUs9kjkx4ZogtBTQSQa6e0KSwNnQ0PYVBmUlPellvjgToVOOsTB/UDWKArrQQYpT
	4+UsN0D5y1fru/C8Qg==
X-Google-Smtp-Source: AGHT+IEBX1y1mlE4xxhB1OqvbfqoX98ZqVTaU1MV8uuu+QiOICjea0IUzDBTFuJpb3OK1spgS242cb6mpNuGQA4vWYY=
X-Received: by 2002:a17:903:2f0d:b0:290:ccf2:9371 with SMTP id
 d9443c01a7336-294caca9e03mr12186075ad.0.1761615743186; Mon, 27 Oct 2025
 18:42:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com> <20251027222808.2332692-9-joannelkoong@gmail.com>
In-Reply-To: <20251027222808.2332692-9-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 27 Oct 2025 18:42:10 -0700
X-Gm-Features: AWmQ_bn7s74qxTzblM6bfbouy7RTwN343Re89JlMJyiQ3G9fTj0k0NdfATvKBNw
Message-ID: <CADUfDZrhAORbO5dz41F-bFWxNJAoYGX2JsHgPugi3JZVoWcYvg@mail.gmail.com>
Subject: Re: [PATCH v2 8/8] fuse: support io-uring registered buffers
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	xiaobing.li@samsung.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 3:29=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Add support for io-uring registered buffers for fuse daemons
> communicating through the io-uring interface. Daemons may register
> buffers ahead of time, which will eliminate the overhead of
> pinning/unpinning user pages and translating virtual addresses for every
> server-kernel interaction.
>
> To support page-aligned payloads, the buffer is structured such that the
> payload is at the front of the buffer and the fuse_uring_req_header is
> offset from the end of the buffer.
>
> To be backwards compatible, fuse uring still needs to support non-registe=
red
> buffers as well.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dev_uring.c   | 200 +++++++++++++++++++++++++++++++++---------
>  fs/fuse/dev_uring_i.h |  27 +++++-
>  2 files changed, 183 insertions(+), 44 deletions(-)
>
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index c6b22b14b354..f501bc81f331 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -580,6 +580,22 @@ static int fuse_uring_out_header_has_err(struct fuse=
_out_header *oh,
>         return err;
>  }
>
> +static void *get_kernel_ring_header(struct fuse_ring_ent *ent,
> +                                   enum fuse_uring_header_type type)
> +{
> +       switch (type) {
> +       case FUSE_URING_HEADER_IN_OUT:
> +               return &ent->headers->in_out;
> +       case FUSE_URING_HEADER_OP:
> +               return &ent->headers->op_in;
> +       case FUSE_URING_HEADER_RING_ENT:
> +               return &ent->headers->ring_ent_in_out;
> +       }
> +
> +       WARN_ON_ONCE(1);
> +       return NULL;
> +}
> +
>  static void __user *get_user_ring_header(struct fuse_ring_ent *ent,
>                                          enum fuse_uring_header_type type=
)
>  {
> @@ -600,16 +616,22 @@ static int copy_header_to_ring(struct fuse_ring_ent=
 *ent,
>                                enum fuse_uring_header_type type,
>                                const void *header, size_t header_size)
>  {
> -       void __user *ring =3D get_user_ring_header(ent, type);
> +       if (ent->fixed_buffer) {
> +               void *ring =3D get_kernel_ring_header(ent, type);
>
> -       if (!ring)
> -               return -EINVAL;
> +               if (!ring)
> +                       return -EINVAL;
> +               memcpy(ring, header, header_size);
> +       } else {
> +               void __user *ring =3D get_user_ring_header(ent, type);
>
> -       if (copy_to_user(ring, header, header_size)) {
> -               pr_info_ratelimited("Copying header to ring failed.\n");
> -               return -EFAULT;
> +               if (!ring)
> +                       return -EINVAL;
> +               if (copy_to_user(ring, header, header_size)) {
> +                       pr_info_ratelimited("Copying header to ring faile=
d.\n");
> +                       return -EFAULT;
> +               }
>         }
> -
>         return 0;
>  }
>
> @@ -617,14 +639,21 @@ static int copy_header_from_ring(struct fuse_ring_e=
nt *ent,
>                                  enum fuse_uring_header_type type,
>                                  void *header, size_t header_size)
>  {
> -       const void __user *ring =3D get_user_ring_header(ent, type);
> +       if (ent->fixed_buffer) {
> +               const void *ring =3D get_kernel_ring_header(ent, type);
>
> -       if (!ring)
> -               return -EINVAL;
> +               if (!ring)
> +                       return -EINVAL;
> +               memcpy(header, ring, header_size);
> +       } else {
> +               const void __user *ring =3D get_user_ring_header(ent, typ=
e);
>
> -       if (copy_from_user(header, ring, header_size)) {
> -               pr_info_ratelimited("Copying header from ring failed.\n")=
;
> -               return -EFAULT;
> +               if (!ring)
> +                       return -EINVAL;
> +               if (copy_from_user(header, ring, header_size)) {
> +                       pr_info_ratelimited("Copying header from ring fai=
led.\n");
> +                       return -EFAULT;
> +               }
>         }
>
>         return 0;
> @@ -637,11 +666,15 @@ static int setup_fuse_copy_state(struct fuse_ring *=
ring, struct fuse_req *req,
>  {
>         int err;
>
> -       err =3D import_ubuf(rw, ent->user_payload, ring->max_payload_sz,
> -                         iter);
> -       if (err) {
> -               pr_info_ratelimited("fuse: Import of user buffer failed\n=
");
> -               return err;
> +       if (ent->fixed_buffer) {
> +               *iter =3D ent->payload_iter;
> +       } else {
> +               err =3D import_ubuf(rw, ent->user_payload, ring->max_payl=
oad_sz,
> +                                 iter);
> +               if (err) {
> +                       pr_info_ratelimited("fuse: Import of user buffer =
failed\n");
> +                       return err;
> +               }
>         }
>
>         fuse_copy_init(cs, rw =3D=3D ITER_DEST, iter);
> @@ -754,6 +787,62 @@ static int fuse_uring_copy_to_ring(struct fuse_ring_=
ent *ent,
>                                    sizeof(req->in.h));
>  }
>
> +/*
> + * Prepare fixed buffer for access. Sets up the payload iter and kmaps t=
he
> + * header.
> + *
> + * Callers must call fuse_uring_unmap_buffer() in the same scope to rele=
ase the
> + * header mapping.
> + *
> + * For non-fixed buffers, this is a no-op.
> + */
> +static int fuse_uring_map_buffer(struct fuse_ring_ent *ent)
> +{
> +       size_t header_size =3D sizeof(struct fuse_uring_req_header);
> +       struct iov_iter iter;
> +       struct page *header_page;
> +       size_t count, start;
> +       ssize_t copied;
> +       int err;
> +
> +       if (!ent->fixed_buffer)
> +               return 0;
> +
> +       err =3D io_uring_cmd_import_fixed_full(ITER_DEST, &iter, ent->cmd=
, 0);
> +       if (err)
> +               return err;
> +
> +       count =3D iov_iter_count(&iter);
> +       if (count < header_size || count & (PAGE_SIZE - 1))
> +               return -EINVAL;
> +
> +       /* Adjust the payload iter to protect the header from any overwri=
tes */
> +       ent->payload_iter =3D iter;
> +       iov_iter_truncate(&ent->payload_iter, count - header_size);
> +
> +       /* Set up the headers */
> +       iov_iter_advance(&iter, count - header_size);
> +       copied =3D iov_iter_get_pages2(&iter, &header_page, header_size, =
1, &start);
> +       if (copied < header_size)
> +               return -EFAULT;
> +       ent->headers =3D kmap_local_page(header_page) + start;
> +
> +       /*
> +        * We can release the acquired reference on the header page immed=
iately
> +        * since the page is pinned and io_uring_cmd_import_fixed_full()
> +        * prevents it from being unpinned while we are using it.
> +        */
> +       put_page(header_page);
> +
> +       return 0;
> +}
> +
> +static void fuse_uring_unmap_buffer(struct fuse_ring_ent *ent)
> +{
> +       if (ent->fixed_buffer)
> +               kunmap_local(ent->headers);
> +}
> +
>  static int fuse_uring_prepare_send(struct fuse_ring_ent *ent,
>                                    struct fuse_req *req)
>  {
> @@ -932,6 +1021,7 @@ static int fuse_uring_commit_fetch(struct io_uring_c=
md *cmd, int issue_flags,
>         unsigned int qid =3D READ_ONCE(cmd_req->qid);
>         struct fuse_pqueue *fpq;
>         struct fuse_req *req;
> +       bool next_req;
>
>         err =3D -ENOTCONN;
>         if (!ring)
> @@ -982,6 +1072,13 @@ static int fuse_uring_commit_fetch(struct io_uring_=
cmd *cmd, int issue_flags,
>
>         /* without the queue lock, as other locks are taken */
>         fuse_uring_prepare_cancel(cmd, issue_flags, ent);
> +
> +       err =3D fuse_uring_map_buffer(ent);
> +       if (err) {
> +               fuse_uring_req_end(ent, req, err);
> +               return err;
> +       }
> +
>         fuse_uring_commit(ent, req, issue_flags);
>
>         /*
> @@ -990,7 +1087,9 @@ static int fuse_uring_commit_fetch(struct io_uring_c=
md *cmd, int issue_flags,
>          * and fetching is done in one step vs legacy fuse, which has sep=
arated
>          * read (fetch request) and write (commit result).
>          */
> -       if (fuse_uring_get_next_fuse_req(ent, queue))
> +       next_req =3D fuse_uring_get_next_fuse_req(ent, queue);
> +       fuse_uring_unmap_buffer(ent);
> +       if (next_req)
>                 fuse_uring_send(ent, cmd, 0, issue_flags);
>         return 0;
>  }
> @@ -1086,39 +1185,49 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *c=
md,
>         struct iovec iov[FUSE_URING_IOV_SEGS];
>         int err;
>
> +       err =3D -ENOMEM;
> +       ent =3D kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
> +       if (!ent)
> +               return ERR_PTR(err);
> +
> +       INIT_LIST_HEAD(&ent->list);
> +
> +       ent->queue =3D queue;
> +
> +       if (READ_ONCE(cmd->sqe->uring_cmd_flags) & IORING_URING_CMD_FIXED=
) {

Just use cmd->flags. That avoids having to deal with any possibility
of userspace changing sqe-> uring_cmd_flags between the multiple loads
of it.

> +               ent->fixed_buffer =3D true;
> +               atomic_inc(&ring->queue_refs);
> +               return ent;
> +       }
> +
>         err =3D fuse_uring_get_iovec_from_sqe(cmd->sqe, iov);
>         if (err) {
>                 pr_info_ratelimited("Failed to get iovec from sqe, err=3D=
%d\n",
>                                     err);
> -               return ERR_PTR(err);
> +               goto error;
>         }
>
>         err =3D -EINVAL;
>         if (iov[0].iov_len < sizeof(struct fuse_uring_req_header)) {
>                 pr_info_ratelimited("Invalid header len %zu\n", iov[0].io=
v_len);
> -               return ERR_PTR(err);
> +               goto error;
>         }
>
>         payload_size =3D iov[1].iov_len;
>         if (payload_size < ring->max_payload_sz) {
>                 pr_info_ratelimited("Invalid req payload len %zu\n",
>                                     payload_size);
> -               return ERR_PTR(err);
> +               goto error;
>         }
> -
> -       err =3D -ENOMEM;
> -       ent =3D kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
> -       if (!ent)
> -               return ERR_PTR(err);
> -
> -       INIT_LIST_HEAD(&ent->list);
> -
> -       ent->queue =3D queue;
>         ent->user_headers =3D iov[0].iov_base;
>         ent->user_payload =3D iov[1].iov_base;
>
>         atomic_inc(&ring->queue_refs);
>         return ent;
> +
> +error:
> +       kfree(ent);
> +       return ERR_PTR(err);
>  }
>
>  /*
> @@ -1249,20 +1358,29 @@ static void fuse_uring_send_in_task(struct io_uri=
ng_cmd *cmd,
>  {
>         struct fuse_ring_ent *ent =3D uring_cmd_to_ring_ent(cmd);
>         struct fuse_ring_queue *queue =3D ent->queue;
> +       bool send_ent =3D true;
>         int err;
>
> -       if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
> -               err =3D fuse_uring_prepare_send(ent, ent->fuse_req);
> -               if (err) {
> -                       if (!fuse_uring_get_next_fuse_req(ent, queue))
> -                               return;
> -                       err =3D 0;
> -               }
> -       } else {
> -               err =3D -ECANCELED;
> +       if (issue_flags & IO_URING_F_TASK_DEAD) {
> +               fuse_uring_send(ent, cmd, -ECANCELED, issue_flags);
> +               return;
> +       }
> +
> +       err =3D fuse_uring_map_buffer(ent);
> +       if (err) {
> +               fuse_uring_req_end(ent, ent->fuse_req, err);
> +               return;
> +       }
> +
> +       err =3D fuse_uring_prepare_send(ent, ent->fuse_req);
> +       if (err) {
> +               send_ent =3D fuse_uring_get_next_fuse_req(ent, queue);
> +               err =3D 0;
>         }
> +       fuse_uring_unmap_buffer(ent);
>
> -       fuse_uring_send(ent, cmd, err, issue_flags);
> +       if (send_ent)
> +               fuse_uring_send(ent, cmd, err, issue_flags);
>  }
>
>  static struct fuse_ring_queue *fuse_uring_task_to_queue(struct fuse_ring=
 *ring)
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index 381fd0b8156a..fe14acccd6a6 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -7,6 +7,7 @@
>  #ifndef _FS_FUSE_DEV_URING_I_H
>  #define _FS_FUSE_DEV_URING_I_H
>
> +#include <linux/uio.h>
>  #include "fuse_i.h"
>
>  #ifdef CONFIG_FUSE_IO_URING
> @@ -38,9 +39,29 @@ enum fuse_ring_req_state {
>
>  /** A fuse ring entry, part of the ring queue */
>  struct fuse_ring_ent {
> -       /* userspace buffer */
> -       struct fuse_uring_req_header __user *user_headers;
> -       void __user *user_payload;
> +       /*
> +        * If true, the buffer was pre-registered by the daemon and the
> +        * pages backing it are pinned in kernel memory. The fixed buffer=
 layout
> +        * is: [payload][header at end]. Use payload_iter and headers for
> +        * copying to/from the ring.
> +        *
> +        * Otherwise, use user_headers and user_payload which point to us=
erspace
> +        * addresses representing the ring memory.
> +        */
> +       bool fixed_buffer;

Could use cmd->flags instead of adding this field. It's an extra
indirection vs. space tradeoff, I guess.

Best,
Caleb

> +
> +       union {
> +               /* fixed_buffer =3D=3D false */
> +               struct {
> +                       struct fuse_uring_req_header __user *user_headers=
;
> +                       void __user *user_payload;
> +               };
> +               /* fixed_buffer =3D=3D true */
> +               struct {
> +                       struct fuse_uring_req_header *headers;
> +                       struct iov_iter payload_iter;
> +               };
> +       };
>
>         /* the ring queue that owns the request */
>         struct fuse_ring_queue *queue;
> --
> 2.47.3
>

