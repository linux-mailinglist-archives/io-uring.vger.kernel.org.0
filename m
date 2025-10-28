Return-Path: <io-uring+bounces-10260-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E8D13C128FB
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 02:34:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F64D1891D5B
	for <lists+io-uring@lfdr.de>; Tue, 28 Oct 2025 01:33:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0EA3233722;
	Tue, 28 Oct 2025 01:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="KS4E3dWp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B2B22A4D6
	for <io-uring@vger.kernel.org>; Tue, 28 Oct 2025 01:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761615158; cv=none; b=tigdkBkRZLeUI7aKegxQzIYPrF5+2FYerhYvp7ea0jHZS29jNpLHWgJ/fZ6jteSr2KPcOKzy1vuajHvqpPYt9Outk7WHr9SWioIY4TAJc9yECHmkbx91d49xeZej8sadqN1d5JE9wa6OhIsQ8JUFu/s4YyzUzKeYW5pxPcye2UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761615158; c=relaxed/simple;
	bh=embTwQX0k21T7N8HinCC/b6kFM7V4c3PcsyGhJuW0bw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c1klNGc/4j4keaJTgRUNGVM6YGs6oJyx0wsfvi1OGSOR4x9t1aHnVZhGXXI+0sPu9ft9Boxd1iPpJlfSBAX8HMQMgEiDfop1mHoUPL9dshkVgVGcd+ndf2bT5Lq/p+g6v3UgyHkjmvLzQEW6VYOJlx+SSACJ6A3TSMxSiPsM7r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=KS4E3dWp; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-29245cb814cso11838295ad.1
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 18:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761615156; x=1762219956; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n9gSOYnkXKUlhWSDTrVpHaUu7DyF1KD8cylIiDbq9fg=;
        b=KS4E3dWp5QpI0LR9v0YagnE/WPSeI0lrqV5GuHYiumAt0xvvNL5CsLbKN5fIbWKmKn
         j/2FJiL33JZeoYInIib4tRAOSXzLeg3+ATYH3FPQxgzmNEIU9JghjrSxFUj7x1RwwzLk
         tvOTSg4BGcg1n0HUf4pT43+gg0ASHW1cfHk2O8+JVSB284yu0/B8Fc6gRfqsLEbSHeAi
         3B2mdHKmh/ndZvljM7QJRM4V76huNdHMrvDk+Oka3KUlyBeistcRBRgAex2GpBtOuWI+
         3AFzOZSX43FZdNHzNhELpaaegjR64rs+hcEdDBWxNdCTJMhR1F0nTnzTrTM7pdDs+5Ib
         auVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761615156; x=1762219956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n9gSOYnkXKUlhWSDTrVpHaUu7DyF1KD8cylIiDbq9fg=;
        b=Y6E5vXsn11lWnRuKQpaeol+O9W/BXhjX5I5Z8uQrfw6nIV5DMwRg2v5rX9f0NORMqS
         P/biydilTIoiXd94pWVhd/DRGVlUlx5tZ88+ARiGUyCxSS1Ozv4prWM7dR5Gi1yoOvQO
         QIn0R7M5M/zFMpYmg5ZHG/KJUWmwStg85VyJZYrGJKoTWa7hcJPqujRWljanzbWF0Ysi
         /k8tTvPdDQJmW8HSnFZKzmtOQlQb+R8NnCVBfIY7BmAzfrDo6S5hJYS4RVRL+oim9eVF
         SqkuhXqTbesCW31sTFGGlwtdKEjbJ+T5w5DfLCXush0SGlUAgwZbTwSHGNzgU94Un+Zv
         bCQA==
X-Forwarded-Encrypted: i=1; AJvYcCV3EZzWE8KrZ5zgQ41gSUtm/hyVAh7iKkPeaNAgOEjHo9KiGEzz3BkLUutPGKs9HHY0tWrBlVtiKw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy7NvrPDgTzxNq7lJ42J/Bb/lHLmxsBYXhTITojAZF2+x4iRw1/
	2TZoOwtYUT4BvRV2BkiowuZGpcikCsjc0PcWN5GclzmamuAO9ecFjkTCsiuFWxNNPFXp7xfkFmH
	Fos8ZLzHRuFcau4PEpjG9dWYKxNZDkbBGlO8OKwotKQ==
X-Gm-Gg: ASbGnct/N66hz9A7g3eW4uClWzcgG6e16rVTbBuhEkArDtLo9YUyW9lqk0h1D55satl
	q85TmrpuUH6v6lzOgkcq239lDLgSqJ39h7RTOLvzgqvRGvNRfsSZfgYvJ3wAs8qplEupbOIC1Im
	SDgJWA8YkCY36M2o7xh09XZwbpxLjTTop4RqOtb5XVrJGhbjsInKPiDSbX3hPLJb6fz/ZAtpjX1
	+Yo9W/lmoDvUnbb2cR3AT3LplRJo3sPkZ13XJw2Kgn2+PRYXGaysN76pgHObf/M7SCPAnjH6Pms
	TTREnmuKIiaXZBcr41Q/YN5nSKiP
X-Google-Smtp-Source: AGHT+IFLmH8BeH1RyRrnUlnHPBSZW9FHMoth+WgrfqmO75KackNkc8/6brrv81X+qCIhwvf5zXoKJMLO9SrWCXRmJ78=
X-Received: by 2002:a17:903:46c6:b0:273:a653:bacf with SMTP id
 d9443c01a7336-294cac8d9d4mr12538205ad.0.1761615156306; Mon, 27 Oct 2025
 18:32:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251027222808.2332692-1-joannelkoong@gmail.com> <20251027222808.2332692-7-joannelkoong@gmail.com>
In-Reply-To: <20251027222808.2332692-7-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 27 Oct 2025 18:32:24 -0700
X-Gm-Features: AWmQ_bmj6baCCxcxfyZ4b_l8c5GmBHntJO0HBey2LghUZl67kGQYxIdcVt9HNwE
Message-ID: <CADUfDZozW7s87j5AgKCHdZKwtR20kwj4L68D5kusbo9GPefHfg@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] fuse: add user_ prefix to userspace headers and
 payload fields
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	xiaobing.li@samsung.com, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2025 at 3:29=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Rename the headers and payload fields to user_headers and user_payload.
> This makes it explicit that these pointers reference userspace addresses
> and prepares for upcoming fixed buffer support, where there will be
> separate fields for kernel-space pointers to the payload and headers.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dev_uring.c   | 17 ++++++++---------
>  fs/fuse/dev_uring_i.h |  4 ++--
>  2 files changed, 10 insertions(+), 11 deletions(-)
>
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index d96368e93e8d..c814b571494f 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -585,11 +585,11 @@ static void __user *get_user_ring_header(struct fus=
e_ring_ent *ent,
>  {
>         switch (type) {
>         case FUSE_URING_HEADER_IN_OUT:
> -               return &ent->headers->in_out;
> +               return &ent->user_headers->in_out;
>         case FUSE_URING_HEADER_OP:
> -               return &ent->headers->op_in;
> +               return &ent->user_headers->op_in;
>         case FUSE_URING_HEADER_RING_ENT:
> -               return &ent->headers->ring_ent_in_out;
> +               return &ent->user_headers->ring_ent_in_out;
>         }
>
>         WARN_ON_ONCE(1);
> @@ -645,7 +645,7 @@ static int fuse_uring_copy_from_ring(struct fuse_ring=
 *ring,
>         if (err)
>                 return err;
>
> -       err =3D import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_=
sz,
> +       err =3D import_ubuf(ITER_SOURCE, ent->user_payload, ring->max_pay=
load_sz,
>                           &iter);
>         if (err)
>                 return err;
> @@ -674,7 +674,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *=
ring, struct fuse_req *req,
>                 .commit_id =3D req->in.h.unique,
>         };
>
> -       err =3D import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz=
, &iter);
> +       err =3D import_ubuf(ITER_DEST, ent->user_payload, ring->max_paylo=
ad_sz, &iter);
>         if (err) {
>                 pr_info_ratelimited("fuse: Import of user buffer failed\n=
");
>                 return err;
> @@ -710,8 +710,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *=
ring, struct fuse_req *req,
>
>         ent_in_out.payload_sz =3D cs.ring.copied_sz;
>         return copy_header_to_ring(ent, FUSE_URING_HEADER_RING_ENT,
> -                                  &ent_in_out,
> -                                  sizeof(ent_in_out));
> +                                  &ent_in_out, sizeof(ent_in_out));

nit: looks like an unnecessary formatting change here. Either drop it
or move it to the earlier commit that added these lines?

Best,
Caleb

>  }
>
>  static int fuse_uring_copy_to_ring(struct fuse_ring_ent *ent,
> @@ -1104,8 +1103,8 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd=
,
>         INIT_LIST_HEAD(&ent->list);
>
>         ent->queue =3D queue;
> -       ent->headers =3D iov[0].iov_base;
> -       ent->payload =3D iov[1].iov_base;
> +       ent->user_headers =3D iov[0].iov_base;
> +       ent->user_payload =3D iov[1].iov_base;
>
>         atomic_inc(&ring->queue_refs);
>         return ent;
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index 51a563922ce1..381fd0b8156a 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -39,8 +39,8 @@ enum fuse_ring_req_state {
>  /** A fuse ring entry, part of the ring queue */
>  struct fuse_ring_ent {
>         /* userspace buffer */
> -       struct fuse_uring_req_header __user *headers;
> -       void __user *payload;
> +       struct fuse_uring_req_header __user *user_headers;
> +       void __user *user_payload;
>
>         /* the ring queue that owns the request */
>         struct fuse_ring_queue *queue;
> --
> 2.47.3
>

