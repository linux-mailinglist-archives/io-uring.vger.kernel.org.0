Return-Path: <io-uring+bounces-10152-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 9ECEABFEFC9
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 05:23:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5EAA54E5688
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 03:23:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEAB9225417;
	Thu, 23 Oct 2025 03:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="HV0/rREZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AABA20C023
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 03:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761189795; cv=none; b=jdSK5ZV7QYXzNWncugiFN9YIOZttwrd0GlQFghpbdN5Fc+ZIf3LUkHvtJdGRg9c8++e+w5ghUqCUNYmflAA9UQ8qMz0epheKQ3HtRXh/uqwwvEEbhPtGm77H+vElZpaDFuv3pllpg3KqhgPVZFRraiIgvniYAzLT56SGvuonYpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761189795; c=relaxed/simple;
	bh=5ooQFgEnbkpKQKepouEBUAxbJBTvFAKItHTY7UHp5WY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=djIh4TyYXnAiM0Oetp0S3mUiOkLel2jajp97f7swt9YoK66rqHhZAddklHcPrh1sN1zbSFo+aZaFZLPsbML5OCUDXk6itDdJKxkCaOHHzGnyhv5l/e/mL7lkt3gr9XNmL+t/p+HxErI8Ymt9qsh4QAWowRBmGhaWe70oiVbQaEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=HV0/rREZ; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-26808b24a00so523275ad.1
        for <io-uring@vger.kernel.org>; Wed, 22 Oct 2025 20:23:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1761189790; x=1761794590; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GhclVAvnu3R6gsvMTS7s6+xi3KwvsVE28EWdmZoGZKM=;
        b=HV0/rREZSh7pqgzW/sX7pn9S8ovoUaHoHFssfJWxJIGBjO1d8eJf2P3TD5P5qqwNwS
         pkPOC7iIVJbfI5/fEvp/JCPqMfgucHZWqVGLXy2dbPPCtxIgoWYtNoXIls3K8X7UCsyP
         9efuxtjTzGW2/bDFlhy7DCdS0sxUnKI6LpmLpCVZK/XBytsJnJLMZVbRmmu/MmWOk1GV
         t0lHyi9vLQkOtljvhHGcTnoKVrMwy0JX23t/cxFtVhAYqmqOJJ4O/UvS4mBSZKBbLwSi
         yNXfoPQX1WqYWUaIN/XPFS6fdRjrcdPSFX/2PVBW1puZWYDh3Qbw87mwLg+le0RluzDN
         GOoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761189790; x=1761794590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GhclVAvnu3R6gsvMTS7s6+xi3KwvsVE28EWdmZoGZKM=;
        b=AUEmsu2nGhuOYJX5oEkLees8apxDySktGr58upR7sOFNst9ymTrLCt1c9dRUHAQQR8
         hXe1gQoCg1Q2mNI1Y2kX6zQ15mi5C+kTLjphvkgBYMALEVbz4RFq93443So5wk+v2MX4
         774kds2DTFalHGy57jmCUKV8gsWplfUI8f5yx0Y9hYtR6smE16fJ5F8qzbbj9LswNdYm
         Nb1fXGam4sB+F/DI9pyMcwy2/u0FglE8PckkDF1A1vtELm2VT/lfnb6ZPS4h2qNUur4m
         bJEOtSB85dSgrmfToWbstTfT5mpVwZSjmncVwjxNsSpzzwqXoXt/TVHRJ2qJQv2nZ2p3
         DhwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcEYvlSY+NPrL/Wsb8zpy+Yrhcyx9b6gHYT9lB0xRTNUNpkwf9zs5D/uXupPDsgT2Xo3m39p98hQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzqYgYAH6CeGr6exIqE5vhXlkjt+1ZjkgibXGVmC75s1gZ4xpoM
	KvT/39dyyPRPKTYh5lV8pdbq46FYq+2NH4bk7cnoAvMQR2DsrBFQJhBFK/vrmJdnrNqkGB12jsO
	dO72yo7uiqLy3T8YjSrDWkqrxCrSiyi8n7PQLJ2GMgw==
X-Gm-Gg: ASbGncv+lD5OO0DNgMwTOQQPaaF1dsRFgTxIqCnnBaAe76cmnUyeC4/hi+qFoGJ2Plj
	XdwM0HtMDbVzXeYpfVGRyIDHLGI49ZLBCYftTwGE+nUELgTIrSr3IMAR0t14qLoVIbwCJS8x3ed
	HKsnw5pwR/pZjYQwZ7IADqRersRVHAeGMkk4yM0A6wU6BEp+G/kIjfoQZycJOfYz8s3Q043J6Fw
	oQYqFvgVZk/D0BLDu+Tta9lFmu9sUHjq4n1uCuqkj6q/2QcF9UYKqmW1JlRxl04azC73fMDEeb2
	S6Tz5AIle/cCPsFCW+ZsxBUPAKYu
X-Google-Smtp-Source: AGHT+IHOIKqx0R/rd2/GkuZMPuWtPAcLvCAbWS1q4cyPUnnloAXML47LtYGlzdlqf0BkoNHTAPa5FcQOPsWbrOe3QxQ=
X-Received: by 2002:a17:902:f787:b0:290:aaff:344e with SMTP id
 d9443c01a7336-292d3e447f2mr66306035ad.2.1761189790024; Wed, 22 Oct 2025
 20:23:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251022202021.3649586-1-joannelkoong@gmail.com> <20251022202021.3649586-3-joannelkoong@gmail.com>
In-Reply-To: <20251022202021.3649586-3-joannelkoong@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Wed, 22 Oct 2025 20:22:58 -0700
X-Gm-Features: AS18NWCEBOr7uFvdHgM_47u6XwIg0kKFTtDJwk5m6hzGPH1sqd6VTWR6LzyQpUk
Message-ID: <CADUfDZrt82mx1UGXXPRsyFUxwiOtiQtuRXOkGi7fyLEBXYz6HQ@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] fuse: support io-uring registered buffers
To: Joanne Koong <joannelkoong@gmail.com>
Cc: miklos@szeredi.hu, axboe@kernel.dk, linux-fsdevel@vger.kernel.org, 
	bschubert@ddn.com, asml.silence@gmail.com, io-uring@vger.kernel.org, 
	xiaobing.li@samsung.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2025 at 1:23=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
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
>  fs/fuse/dev_uring.c   | 216 ++++++++++++++++++++++++++++++++++++++----
>  fs/fuse/dev_uring_i.h |  17 +++-
>  2 files changed, 213 insertions(+), 20 deletions(-)
>
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index f6b12aebb8bb..c4dd4d168b61 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -574,6 +574,37 @@ static int fuse_uring_out_header_has_err(struct fuse=
_out_header *oh,
>         return err;
>  }
>
> +static int fuse_uring_copy_from_ring_fixed_buf(struct fuse_ring *ring,
> +                                              struct fuse_req *req,
> +                                              struct fuse_ring_ent *ent)
> +{
> +       struct fuse_copy_state cs;
> +       struct fuse_args *args =3D req->args;
> +       struct iov_iter payload_iter;
> +       struct iov_iter headers_iter;
> +       struct fuse_uring_ent_in_out ring_in_out;
> +       size_t copied;
> +
> +       payload_iter =3D ent->fixed_buffer.payload_iter;
> +       payload_iter.data_source =3D ITER_SOURCE;
> +       headers_iter =3D ent->fixed_buffer.headers_iter;
> +       headers_iter.data_source =3D ITER_SOURCE;
> +
> +       iov_iter_advance(&headers_iter, offsetof(struct fuse_uring_req_he=
ader,
> +                                                ring_ent_in_out));
> +
> +       copied =3D copy_from_iter(&ring_in_out, sizeof(ring_in_out),
> +                               &headers_iter);
> +       if (copied !=3D sizeof(ring_in_out))
> +               return -EFAULT;
> +
> +       fuse_copy_init(&cs, false, &payload_iter);
> +       cs.is_uring =3D true;
> +       cs.req =3D req;
> +
> +       return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
> +}
> +
>  static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
>                                      struct fuse_req *req,
>                                      struct fuse_ring_ent *ent)
> @@ -584,12 +615,12 @@ static int fuse_uring_copy_from_ring(struct fuse_ri=
ng *ring,
>         int err;
>         struct fuse_uring_ent_in_out ring_in_out;
>
> -       err =3D copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_o=
ut,
> +       err =3D copy_from_user(&ring_in_out, &ent->user.headers->ring_ent=
_in_out,
>                              sizeof(ring_in_out));
>         if (err)
>                 return -EFAULT;
>
> -       err =3D import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_=
sz,
> +       err =3D import_ubuf(ITER_SOURCE, ent->user.payload, ring->max_pay=
load_sz,
>                           &iter);
>         if (err)
>                 return err;
> @@ -601,6 +632,79 @@ static int fuse_uring_copy_from_ring(struct fuse_rin=
g *ring,
>         return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
>  }
>
> +static int fuse_uring_args_to_ring_fixed_buf(struct fuse_ring *ring,
> +                                            struct fuse_req *req,
> +                                            struct fuse_ring_ent *ent)
> +{
> +       struct fuse_copy_state cs;
> +       struct fuse_args *args =3D req->args;
> +       struct fuse_in_arg *in_args =3D args->in_args;
> +       int num_args =3D args->in_numargs;
> +       struct iov_iter payload_iter;
> +       struct iov_iter headers_iter;
> +       struct fuse_uring_ent_in_out ent_in_out =3D {
> +               .flags =3D 0,
> +               .commit_id =3D req->in.h.unique,
> +       };
> +       size_t copied;
> +       bool advanced_headers =3D false;
> +       int err;
> +
> +       payload_iter =3D ent->fixed_buffer.payload_iter;
> +       payload_iter.data_source =3D ITER_DEST;
> +
> +       headers_iter =3D ent->fixed_buffer.headers_iter;
> +       headers_iter.data_source =3D ITER_DEST;
> +
> +       fuse_copy_init(&cs, true, &payload_iter);
> +       cs.is_uring =3D true;
> +       cs.req =3D req;
> +
> +       if (num_args > 0) {
> +               /*
> +                * Expectation is that the first argument is the per op h=
eader.
> +                * Some op code have that as zero size.
> +                */
> +               if (args->in_args[0].size > 0) {
> +                       iov_iter_advance(&headers_iter,
> +                                        offsetof(struct fuse_uring_req_h=
eader,
> +                                                 op_in));
> +                       copied =3D copy_to_iter(in_args->value, in_args->=
size,
> +                                             &headers_iter);
> +                       if (copied !=3D in_args->size) {
> +                               pr_info_ratelimited(
> +                                       "Copying the header failed.\n");
> +                               return -EFAULT;
> +                       }
> +
> +                       iov_iter_advance(&headers_iter,
> +                                        FUSE_URING_OP_IN_OUT_SZ - in_arg=
s->size);
> +                       advanced_headers =3D true;
> +               }
> +               in_args++;
> +               num_args--;
> +       }
> +       if (!advanced_headers)
> +               iov_iter_advance(&headers_iter,
> +                                offsetof(struct fuse_uring_req_header,
> +                                         ring_ent_in_out));
> +
> +       /* copy the payload */
> +       err =3D fuse_copy_args(&cs, num_args, args->in_pages,
> +                            (struct fuse_arg *)in_args, 0);
> +       if (err) {
> +               pr_info_ratelimited("%s fuse_copy_args failed\n", __func_=
_);
> +               return err;
> +       }
> +
> +       ent_in_out.payload_sz =3D cs.ring.copied_sz;
> +       copied =3D copy_to_iter(&ent_in_out, sizeof(ent_in_out), &headers=
_iter);
> +       if (copied !=3D sizeof(ent_in_out))
> +               return -EFAULT;
> +
> +       return 0;
> +}
> +
>   /*
>    * Copy data from the req to the ring buffer
>    */
> @@ -618,7 +722,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *=
ring, struct fuse_req *req,
>                 .commit_id =3D req->in.h.unique,
>         };
>
> -       err =3D import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz=
, &iter);
> +       err =3D import_ubuf(ITER_DEST, ent->user.payload, ring->max_paylo=
ad_sz, &iter);
>         if (err) {
>                 pr_info_ratelimited("fuse: Import of user buffer failed\n=
");
>                 return err;
> @@ -634,7 +738,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *=
ring, struct fuse_req *req,
>                  * Some op code have that as zero size.
>                  */
>                 if (args->in_args[0].size > 0) {
> -                       err =3D copy_to_user(&ent->headers->op_in, in_arg=
s->value,
> +                       err =3D copy_to_user(&ent->user.headers->op_in, i=
n_args->value,
>                                            in_args->size);
>                         if (err) {
>                                 pr_info_ratelimited(
> @@ -655,7 +759,7 @@ static int fuse_uring_args_to_ring(struct fuse_ring *=
ring, struct fuse_req *req,
>         }
>
>         ent_in_out.payload_sz =3D cs.ring.copied_sz;
> -       err =3D copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
> +       err =3D copy_to_user(&ent->user.headers->ring_ent_in_out, &ent_in=
_out,
>                            sizeof(ent_in_out));
>         return err ? -EFAULT : 0;
>  }
> @@ -679,18 +783,31 @@ static int fuse_uring_copy_to_ring(struct fuse_ring=
_ent *ent,
>                 return err;
>
>         /* copy the request */
> -       err =3D fuse_uring_args_to_ring(ring, req, ent);
> +       if (ent->is_fixed_buffer)
> +               err =3D fuse_uring_args_to_ring_fixed_buf(ring, req, ent)=
;
> +       else
> +               err =3D fuse_uring_args_to_ring(ring, req, ent);
>         if (unlikely(err)) {
>                 pr_info_ratelimited("Copy to ring failed: %d\n", err);
>                 return err;
>         }
>
>         /* copy fuse_in_header */
> -       err =3D copy_to_user(&ent->headers->in_out, &req->in.h,
> -                          sizeof(req->in.h));
> -       if (err) {
> -               err =3D -EFAULT;
> -               return err;
> +       if (ent->is_fixed_buffer) {
> +               struct iov_iter headers_iter =3D ent->fixed_buffer.header=
s_iter;
> +               size_t copied;
> +
> +               headers_iter.data_source =3D ITER_DEST;
> +               copied =3D copy_to_iter(&req->in.h, sizeof(req->in.h),
> +                                     &headers_iter);
> +
> +               if (copied !=3D sizeof(req->in.h))
> +                       return -EFAULT;
> +       } else {
> +               err =3D copy_to_user(&ent->user.headers->in_out, &req->in=
.h,
> +                                  sizeof(req->in.h));
> +               if (err)
> +                       return -EFAULT;
>         }
>
>         return 0;
> @@ -815,8 +932,18 @@ static void fuse_uring_commit(struct fuse_ring_ent *=
ent, struct fuse_req *req,
>         struct fuse_conn *fc =3D ring->fc;
>         ssize_t err =3D 0;
>
> -       err =3D copy_from_user(&req->out.h, &ent->headers->in_out,
> -                            sizeof(req->out.h));
> +       if (ent->is_fixed_buffer) {
> +               struct iov_iter headers_iter =3D ent->fixed_buffer.header=
s_iter;
> +               size_t copied;
> +
> +               headers_iter.data_source =3D ITER_SOURCE;
> +               copied =3D copy_from_iter(&req->out.h, sizeof(req->out.h)=
, &headers_iter);
> +               if (copied !=3D sizeof(req->out.h))
> +                       err =3D -EFAULT;
> +       } else {
> +               err =3D copy_from_user(&req->out.h, &ent->user.headers->i=
n_out,
> +                                    sizeof(req->out.h));
> +       }
>         if (err) {
>                 req->out.h.error =3D -EFAULT;
>                 goto out;
> @@ -828,7 +955,11 @@ static void fuse_uring_commit(struct fuse_ring_ent *=
ent, struct fuse_req *req,
>                 goto out;
>         }
>
> -       err =3D fuse_uring_copy_from_ring(ring, req, ent);
> +       if (ent->is_fixed_buffer)
> +               err =3D fuse_uring_copy_from_ring_fixed_buf(ring, req, en=
t);
> +       else
> +               err =3D fuse_uring_copy_from_ring(ring, req, ent);
> +
>  out:
>         fuse_uring_req_end(ent, req, err);
>  }
> @@ -1027,6 +1158,52 @@ static int fuse_uring_get_iovec_from_sqe(const str=
uct io_uring_sqe *sqe,
>         return 0;
>  }
>
> +static struct fuse_ring_ent *
> +fuse_uring_create_ring_ent_fixed_buf(struct io_uring_cmd *cmd,
> +                                    struct fuse_ring_queue *queue)
> +{
> +       struct fuse_ring *ring =3D queue->ring;
> +       struct fuse_ring_ent *ent;
> +       unsigned payload_size, len;
> +       u64 ubuf;
> +       int err;
> +
> +       err =3D -ENOMEM;
> +       ent =3D kzalloc(sizeof(*ent), GFP_KERNEL_ACCOUNT);
> +       if (!ent)
> +               return ERR_PTR(err);
> +
> +       INIT_LIST_HEAD(&ent->list);
> +
> +       ent->queue =3D queue;
> +       ent->is_fixed_buffer =3D true;
> +
> +       err =3D io_uring_cmd_get_buffer_info(cmd, &ubuf, &len);
> +       if (err)
> +               goto error;
> +
> +       payload_size =3D len - sizeof(struct fuse_uring_req_header);
> +       err =3D io_uring_cmd_import_fixed(ubuf, payload_size, ITER_DEST,
> +                                       &ent->fixed_buffer.payload_iter, =
cmd, 0);

It feels a bit awkward to look up the userspace address from the
registered buffer node just to pass it to io_uring_cmd_import_fixed(),
which will subtract it off. Not to mention, there's a race here in the
IO_URING_F_UNLOCKED case where the registered buffer can be updated
between the io_uring_cmd_get_buffer_info() and
io_uring_cmd_import_fixed() calls, so ubuf could be stale. Maybe it
would make sense to introduce a helper for importing an iterator
relative to the start of a registered buffer instead of using an
absolute address? (Named "io_uring_cmd_import_fixed_relative()" or
something?) Then we could get rid of io_uring_cmd_get_buffer_info()
entirely.

Best,
Caleb

> +       if (err)
> +               goto error;
> +
> +       err =3D io_uring_cmd_import_fixed(ubuf + payload_size,
> +                                       sizeof(struct fuse_uring_req_head=
er),
> +                                       ITER_DEST,
> +                                       &ent->fixed_buffer.headers_iter, =
cmd, 0);
> +       if (err)
> +               goto error;
> +
> +       atomic_inc(&ring->queue_refs);
> +
> +       return ent;
> +
> +error:
> +       kfree(ent);
> +       return ERR_PTR(err);
> +}
> +
>  static struct fuse_ring_ent *
>  fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
>                            struct fuse_ring_queue *queue)
> @@ -1065,8 +1242,8 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd=
,
>         INIT_LIST_HEAD(&ent->list);
>
>         ent->queue =3D queue;
> -       ent->headers =3D iov[0].iov_base;
> -       ent->payload =3D iov[1].iov_base;
> +       ent->user.headers =3D iov[0].iov_base;
> +       ent->user.payload =3D iov[1].iov_base;
>
>         atomic_inc(&ring->queue_refs);
>         return ent;
> @@ -1085,6 +1262,8 @@ static int fuse_uring_register(struct io_uring_cmd =
*cmd,
>         struct fuse_ring_ent *ent;
>         int err;
>         unsigned int qid =3D READ_ONCE(cmd_req->qid);
> +       bool is_fixed_buffer =3D
> +               cmd->sqe->uring_cmd_flags & IORING_URING_CMD_FIXED;
>
>         err =3D -ENOMEM;
>         if (!ring) {
> @@ -1110,7 +1289,10 @@ static int fuse_uring_register(struct io_uring_cmd=
 *cmd,
>          * case of entry errors below, will be done at ring destruction t=
ime.
>          */
>
> -       ent =3D fuse_uring_create_ring_ent(cmd, queue);
> +       if (is_fixed_buffer)
> +               ent =3D fuse_uring_create_ring_ent_fixed_buf(cmd, queue);
> +       else
> +               ent =3D fuse_uring_create_ring_ent(cmd, queue);
>         if (IS_ERR(ent))
>                 return PTR_ERR(ent);
>
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index 51a563922ce1..748c87e325f5 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -38,9 +38,20 @@ enum fuse_ring_req_state {
>
>  /** A fuse ring entry, part of the ring queue */
>  struct fuse_ring_ent {
> -       /* userspace buffer */
> -       struct fuse_uring_req_header __user *headers;
> -       void __user *payload;
> +       /* True if daemon has registered its buffers ahead of time */
> +       bool is_fixed_buffer;
> +       union {
> +               /* userspace buffer */
> +               struct {
> +                       struct fuse_uring_req_header __user *headers;
> +                       void __user *payload;
> +               } user;
> +
> +               struct {
> +                       struct iov_iter payload_iter;
> +                       struct iov_iter headers_iter;
> +               } fixed_buffer;
> +       };
>
>         /* the ring queue that owns the request */
>         struct fuse_ring_queue *queue;
> --
> 2.47.3
>
>

