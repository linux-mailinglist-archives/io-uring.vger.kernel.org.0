Return-Path: <io-uring+bounces-6034-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6AC2A188B0
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 01:04:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4AA4A7A23EC
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 00:04:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C2DE182;
	Wed, 22 Jan 2025 00:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IA1d5JHE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE7B2F36;
	Wed, 22 Jan 2025 00:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737504264; cv=none; b=JafxKmaW9LQMNvgW3sCu5Kl0DndCfvA0t6XekZIo+ZTDLcBdZK1p82CcsXS/MC/EPaqf/oLhFEx+g7YjhfTmo2OIzTooxJUlZnYaDxau6IONcv855QwDw0IS5sYCpf3r+UV9H5s/cOpZj0HHqzRTq0dTTRw4wZuW1gUlgbo9bz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737504264; c=relaxed/simple;
	bh=hMw6CZgZ+WGK71MTiYeaMfPU7vefrlpezmfB1CzbSYY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j7EHVYdKXx1voQjOeHc+pxYqrX3xVbETcGJXa9T88F1GdgzT7soFzGNt/lIpXK73LGSgr8Qj8/74HQsIqVol02a2qNM/+zOGMPCZlcwio8+XiEm1yC7x5rqDWdrD517na7DARM9siOWXa7XeCYSj0KfXNNdials31auNXfOVMDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IA1d5JHE; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-46e28597955so25940701cf.0;
        Tue, 21 Jan 2025 16:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737504260; x=1738109060; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z2zWg2BXpmre0WdmaW62ieGkSusb8U3Do53rJ2x//9U=;
        b=IA1d5JHEnigCEXQ8tOG+jyoRSufde7UcjLkB32m9P3jMdXuc36+ybF4fmWPc/pxoZY
         ZizBLmPFZhso0bg2goPHBtH8Vu2Xqb+FHEWBJ6PMbeeNqJ0MhJLXdSizcN/d7RclznUF
         mok+CZlNdaqutwX6xrlELMOqXHGFxR0HYL5D7WOFiaE0C5zNKfYrq8e3mNa9xRU8Q+ON
         HbvnnwPvuLhDvEcM+Vi77pfyA8CRR7uKEs4s7ZwcRZsmj5Ryub7Mp6YLYhFbTOsAhoVW
         F59Ea+NG14BM+t2RPkRmJcrNrWGvXh9I51kvDNdFKlScm48rU7es+IFf0r842LCsnDoV
         qiTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737504260; x=1738109060;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z2zWg2BXpmre0WdmaW62ieGkSusb8U3Do53rJ2x//9U=;
        b=dtmt6mwYpohCpg9nAmSSUC85NiGThCFAHUAiffmbjMzl55iIgkMocO3ntN5jleEEF2
         rLZs8MuTsQKfePeJS4Yf+GhB8h2gP0iGrGcr5ASLoUkvTpoNDEdJT+ILyE5OBacxp3ns
         4Yy8PNszY8GBM4JRVn8Q2/k3FOrMO9S7IeJMeqN2nko4e7PW9l00hj+I7GzfYNE0kFP0
         rn2w1Ao3acNaynqMI63Dj4eD4SaFYWSqGnuejFOeEggNyOm4a6Xh7aXzGbQc7FHycyP0
         hT4KQIDrNB2ZckskInkdXQlO6U/urDrFUFFMmpFbNYV1WYF2jAK1r5QtZXqpsNR7Oz2N
         a8eg==
X-Forwarded-Encrypted: i=1; AJvYcCUI/2qem1bntJiwkayOMtGZLoJ5vQ+p8T9JDQnHZNwfb8ZcC+CJA2mHAmw7eoXVKH30QJfvWEd/aw==@vger.kernel.org, AJvYcCVho8g2SXyWX5z/0lQ9dd0IpZ8q909n/uV5u1NWKgQddcGUBYHJDgWtPqgg4Vv+WUltVPYnb6GnXVqYpBxyOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyAaKz2ysKYs7xWPCxDxAZlVUREdUzReac9WUs2Aci47Pk6P4AG
	S2ve1Fys9CElgZrczrZq9dwnVf6xyJqC2pEBfTF2AlXx1Gkd6lv2khfLpTjeudnpeeegDuHZ1rG
	vzLptUFJqJ4sbdfnBvWAqurS2HgU=
X-Gm-Gg: ASbGncuup+xSul6TtER01tRHFg9n+THUUeU5T6vDLF6TdcaBlqseY3kqNMdh0lVZ6B2
	AoiyyVuXPHebjq7w9hfCE2lKMNtnaPG6SqbzlPPJnXFlcyeLnCNIW
X-Google-Smtp-Source: AGHT+IEjBX06GTi7ovm1U+KfQxNlnH8CbAF1wAaOWkgeWtDZgMAIBM1e8OXxgtDkB/0FJmah4Nrd6vZu+oquVSRyu+w=
X-Received: by 2002:a05:622a:24b:b0:461:7467:e9f1 with SMTP id
 d75a77b69052e-46e12a977a2mr280767541cf.26.1737504260346; Tue, 21 Jan 2025
 16:04:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
 <CAJnrk1afYmo+GNRb=OF7CUQzY5ocEus0h=93ax8usA9oa_qM4Q@mail.gmail.com> <eafad58d-07ec-4e7f-9482-26f313f066cc@bsbernd.com>
In-Reply-To: <eafad58d-07ec-4e7f-9482-26f313f066cc@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 21 Jan 2025 16:04:09 -0800
X-Gm-Features: AbW1kvaCgI2-xc8eF3djJpN_jMZ392KVuGEbZo7goHmH2MxMhTy9c1E0xiexJyM
Message-ID: <CAJnrk1asVwkm8kG-Rfmgi-gPXjYxA8HcA_vauqVi+zjuPNtaJQ@mail.gmail.com>
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 19, 2025 at 4:33=E2=80=AFPM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
> Hi Joanne,
>
> sorry for my late reply, I was occupied all week.
>
> On 1/13/25 23:44, Joanne Koong wrote:
> > On Mon, Jan 6, 2025 at 4:25=E2=80=AFPM Bernd Schubert <bschubert@ddn.co=
m> wrote:
> >>
> >> This adds support for fuse request completion through ring SQEs
> >> (FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
> >> the ring entry it becomes available for new fuse requests.
> >> Handling of requests through the ring (SQE/CQE handling)
> >> is complete now.
> >>
> >> Fuse request data are copied through the mmaped ring buffer,
> >> there is no support for any zero copy yet.
> >>
> >> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> >> ---
> >>  fs/fuse/dev_uring.c   | 450 +++++++++++++++++++++++++++++++++++++++++=
+++++++++
> >>  fs/fuse/dev_uring_i.h |  12 ++
> >>  fs/fuse/fuse_i.h      |   4 +
> >>  3 files changed, 466 insertions(+)
> >>
> >> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> >> index b44ba4033615e01041313c040035b6da6af0ee17..f44e66a7ea577390da87e9=
ac7d118a9416898c28 100644
> >> --- a/fs/fuse/dev_uring.c
> >> +++ b/fs/fuse/dev_uring.c
> >> @@ -26,6 +26,19 @@ bool fuse_uring_enabled(void)
> >>         return enable_uring;
> >>  }
> >>
> >> +static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool s=
et_err,
> >> +                              int error)
> >> +{
> >> +       struct fuse_req *req =3D ring_ent->fuse_req;
> >> +
> >> +       if (set_err)
> >> +               req->out.h.error =3D error;
> >
> > I think we could get away with not having the "bool set_err" as an
> > argument if we do "if (error)" directly. AFAICT, we can use the value
> > of error directly since  it always returns zero on success and any
> > non-zero value is considered an error.
>
> I had done this because of fuse_uring_commit()
>
>
>         err =3D fuse_uring_out_header_has_err(&req->out.h, req, fc);
>         if (err) {
>                 /* req->out.h.error already set */
>                 goto out;
>         }
>
>
> In fuse_uring_out_header_has_err() the header might already have the
> error code, but there are other errors as well. Well, setting an
> existing error code saves us a few lines and conditions, so you are
> probably right and I removed that argument now.
>
>
> >
> >> +
> >> +       clear_bit(FR_SENT, &req->flags);
> >> +       fuse_request_end(ring_ent->fuse_req);
> >> +       ring_ent->fuse_req =3D NULL;
> >> +}
> >> +
> >>  void fuse_uring_destruct(struct fuse_conn *fc)
> >>  {
> >>         struct fuse_ring *ring =3D fc->ring;
> >> @@ -41,8 +54,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
> >>                         continue;
> >>
> >>                 WARN_ON(!list_empty(&queue->ent_avail_queue));
> >> +               WARN_ON(!list_empty(&queue->ent_w_req_queue));
> >>                 WARN_ON(!list_empty(&queue->ent_commit_queue));
> >> +               WARN_ON(!list_empty(&queue->ent_in_userspace));
> >>
> >> +               kfree(queue->fpq.processing);
> >>                 kfree(queue);
> >>                 ring->queues[qid] =3D NULL;
> >>         }
> >> @@ -101,20 +117,34 @@ static struct fuse_ring_queue *fuse_uring_create=
_queue(struct fuse_ring *ring,
> >>  {
> >>         struct fuse_conn *fc =3D ring->fc;
> >>         struct fuse_ring_queue *queue;
> >> +       struct list_head *pq;
> >>
> >>         queue =3D kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
> >>         if (!queue)
> >>                 return NULL;
> >> +       pq =3D kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GF=
P_KERNEL);
> >> +       if (!pq) {
> >> +               kfree(queue);
> >> +               return NULL;
> >> +       }
> >> +
> >>         queue->qid =3D qid;
> >>         queue->ring =3D ring;
> >>         spin_lock_init(&queue->lock);
> >>
> >>         INIT_LIST_HEAD(&queue->ent_avail_queue);
> >>         INIT_LIST_HEAD(&queue->ent_commit_queue);
> >> +       INIT_LIST_HEAD(&queue->ent_w_req_queue);
> >> +       INIT_LIST_HEAD(&queue->ent_in_userspace);
> >> +       INIT_LIST_HEAD(&queue->fuse_req_queue);
> >> +
> >> +       queue->fpq.processing =3D pq;
> >> +       fuse_pqueue_init(&queue->fpq);
> >>
> >>         spin_lock(&fc->lock);
> >>         if (ring->queues[qid]) {
> >>                 spin_unlock(&fc->lock);
> >> +               kfree(queue->fpq.processing);
> >>                 kfree(queue);
> >>                 return ring->queues[qid];
> >>         }
> >> @@ -128,6 +158,214 @@ static struct fuse_ring_queue *fuse_uring_create=
_queue(struct fuse_ring *ring,
> >>         return queue;
> >>  }
> >>
> >> +/*
> >> + * Checks for errors and stores it into the request
> >> + */
> >> +static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
> >> +                                        struct fuse_req *req,
> >> +                                        struct fuse_conn *fc)
> >> +{
> >> +       int err;
> >> +
> >> +       err =3D -EINVAL;
> >> +       if (oh->unique =3D=3D 0) {
> >> +               /* Not supportd through io-uring yet */
> >> +               pr_warn_once("notify through fuse-io-uring not support=
ed\n");
> >> +               goto seterr;
> >> +       }
> >> +
> >> +       err =3D -EINVAL;
> >> +       if (oh->error <=3D -ERESTARTSYS || oh->error > 0)
> >> +               goto seterr;
> >> +
> >> +       if (oh->error) {
> >> +               err =3D oh->error;
> >> +               goto err;
> >> +       }
> >> +
> >> +       err =3D -ENOENT;
> >> +       if ((oh->unique & ~FUSE_INT_REQ_BIT) !=3D req->in.h.unique) {
> >> +               pr_warn_ratelimited("unique mismatch, expected: %llu g=
ot %llu\n",
> >> +                                   req->in.h.unique,
> >> +                                   oh->unique & ~FUSE_INT_REQ_BIT);
> >> +               goto seterr;
> >> +       }
> >> +
> >> +       /*
> >> +        * Is it an interrupt reply ID?
> >> +        * XXX: Not supported through fuse-io-uring yet, it should not=
 even
> >> +        *      find the request - should not happen.
> >> +        */
> >> +       WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
> >> +
> >> +       return 0;
> >> +
> >> +seterr:
> >> +       oh->error =3D err;
> >> +err:
> >> +       return err;
> >> +}
> >> +
> >> +static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
> >> +                                    struct fuse_req *req,
> >> +                                    struct fuse_ring_ent *ent)
> >> +{
> >> +       struct fuse_copy_state cs;
> >> +       struct fuse_args *args =3D req->args;
> >> +       struct iov_iter iter;
> >> +       int err, res;
> >> +       struct fuse_uring_ent_in_out ring_in_out;
> >> +
> >> +       res =3D copy_from_user(&ring_in_out, &ent->headers->ring_ent_i=
n_out,
> >> +                            sizeof(ring_in_out));
> >> +       if (res)
> >> +               return -EFAULT;
> >> +
> >> +       err =3D import_ubuf(ITER_SOURCE, ent->payload, ring->max_paylo=
ad_sz,
> >> +                         &iter);
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       fuse_copy_init(&cs, 0, &iter);
> >> +       cs.is_uring =3D 1;
> >> +       cs.req =3D req;
> >> +
> >> +       return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
> >> +}
> >> +
> >> + /*
> >> +  * Copy data from the req to the ring buffer
> >> +  */
> >> +static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fus=
e_req *req,
> >> +                                  struct fuse_ring_ent *ent)
> >> +{
> >> +       struct fuse_copy_state cs;
> >> +       struct fuse_args *args =3D req->args;
> >> +       struct fuse_in_arg *in_args =3D args->in_args;
> >> +       int num_args =3D args->in_numargs;
> >> +       int err, res;
> >> +       struct iov_iter iter;
> >> +       struct fuse_uring_ent_in_out ent_in_out =3D {
> >> +               .flags =3D 0,
> >> +               .commit_id =3D ent->commit_id,
> >> +       };
> >> +
> >> +       if (WARN_ON(ent_in_out.commit_id =3D=3D 0))
> >> +               return -EINVAL;
> >> +
> >> +       err =3D import_ubuf(ITER_DEST, ent->payload, ring->max_payload=
_sz, &iter);
> >> +       if (err) {
> >> +               pr_info_ratelimited("fuse: Import of user buffer faile=
d\n");
> >> +               return err;
> >> +       }
> >> +
> >> +       fuse_copy_init(&cs, 1, &iter);
> >> +       cs.is_uring =3D 1;
> >> +       cs.req =3D req;
> >> +
> >> +       if (num_args > 0) {
> >> +               /*
> >> +                * Expectation is that the first argument is the per o=
p header.
> >> +                * Some op code have that as zero.
> >> +                */
> >> +               if (args->in_args[0].size > 0) {
> >> +                       res =3D copy_to_user(&ent->headers->op_in, in_=
args->value,
> >> +                                          in_args->size);
> >> +                       err =3D res > 0 ? -EFAULT : res;
> >> +                       if (err) {
> >> +                               pr_info_ratelimited(
> >> +                                       "Copying the header failed.\n"=
);
> >> +                               return err;
> >> +                       }
> >> +               }
> >> +               in_args++;
> >> +               num_args--;
> >> +       }
> >> +
> >> +       /* copy the payload */
> >> +       err =3D fuse_copy_args(&cs, num_args, args->in_pages,
> >> +                            (struct fuse_arg *)in_args, 0);
> >> +       if (err) {
> >> +               pr_info_ratelimited("%s fuse_copy_args failed\n", __fu=
nc__);
> >> +               return err;
> >> +       }
> >> +
> >> +       ent_in_out.payload_sz =3D cs.ring.copied_sz;
> >> +       res =3D copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_o=
ut,
> >> +                          sizeof(ent_in_out));
> >> +       err =3D res > 0 ? -EFAULT : res;
> >> +       if (err)
> >> +               return err;
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +static int
> >> +fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
> >> +{
> >> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> >> +       struct fuse_ring *ring =3D queue->ring;
> >> +       struct fuse_req *req =3D ring_ent->fuse_req;
> >> +       int err, res;
> >> +
> >> +       err =3D -EIO;
> >> +       if (WARN_ON(ring_ent->state !=3D FRRS_FUSE_REQ)) {
> >> +               pr_err("qid=3D%d ring-req=3D%p invalid state %d on sen=
d\n",
> >> +                      queue->qid, ring_ent, ring_ent->state);
> >> +               err =3D -EIO;
> >> +               goto err;
> >> +       }
> >> +
> >> +       /* copy the request */
> >> +       err =3D fuse_uring_copy_to_ring(ring, req, ring_ent);
> >> +       if (unlikely(err)) {
> >> +               pr_info_ratelimited("Copy to ring failed: %d\n", err);
> >> +               goto err;
> >> +       }
> >> +
> >> +       /* copy fuse_in_header */
> >> +       res =3D copy_to_user(&ring_ent->headers->in_out, &req->in.h,
> >> +                          sizeof(req->in.h));
> >> +       err =3D res > 0 ? -EFAULT : res;
> >> +       if (err)
> >> +               goto err;
> >> +
> >> +       set_bit(FR_SENT, &req->flags);
> >> +       return 0;
> >> +
> >> +err:
> >> +       fuse_uring_req_end(ring_ent, true, err);
> >> +       return err;
> >> +}
> >> +
> >> +/*
> >> + * Write data to the ring buffer and send the request to userspace,
> >> + * userspace will read it
> >> + * This is comparable with classical read(/dev/fuse)
> >> + */
> >> +static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_en=
t,
> >> +                                       unsigned int issue_flags)
> >> +{
> >> +       int err =3D 0;
> >> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> >> +
> >> +       err =3D fuse_uring_prepare_send(ring_ent);
> >> +       if (err)
> >> +               goto err;
> >> +
> >> +       spin_lock(&queue->lock);
> >> +       ring_ent->state =3D FRRS_USERSPACE;
> >> +       list_move(&ring_ent->list, &queue->ent_in_userspace);
> >> +       spin_unlock(&queue->lock);
> >> +
> >> +       io_uring_cmd_done(ring_ent->cmd, 0, 0, issue_flags);
> >> +       ring_ent->cmd =3D NULL;
> >> +       return 0;
> >> +
> >> +err:
> >> +       return err;
> >> +}
> >> +
> >>  /*
> >>   * Make a ring entry available for fuse_req assignment
> >>   */
> >> @@ -138,6 +376,210 @@ static void fuse_uring_ent_avail(struct fuse_rin=
g_ent *ring_ent,
> >>         ring_ent->state =3D FRRS_AVAILABLE;
> >>  }
> >>
> >> +/* Used to find the request on SQE commit */
> >> +static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent,
> >> +                                struct fuse_req *req)
> >> +{
> >> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> >> +       struct fuse_pqueue *fpq =3D &queue->fpq;
> >> +       unsigned int hash;
> >> +
> >> +       /* commit_id is the unique id of the request */
> >> +       ring_ent->commit_id =3D req->in.h.unique;
> >> +
> >> +       req->ring_entry =3D ring_ent;
> >> +       hash =3D fuse_req_hash(ring_ent->commit_id);
> >> +       list_move_tail(&req->list, &fpq->processing[hash]);
> >> +}
> >> +
> >> +/*
> >> + * Assign a fuse queue entry to the given entry
> >> + */
> >> +static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ring=
_ent,
> >> +                                          struct fuse_req *req)
> >> +{
> >> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> >> +
> >> +       lockdep_assert_held(&queue->lock);
> >> +
> >> +       if (WARN_ON_ONCE(ring_ent->state !=3D FRRS_AVAILABLE &&
> >> +                        ring_ent->state !=3D FRRS_COMMIT)) {
> >> +               pr_warn("%s qid=3D%d state=3D%d\n", __func__, ring_ent=
->queue->qid,
> >> +                       ring_ent->state);
> >> +       }
> >> +       list_del_init(&req->list);
> >> +       clear_bit(FR_PENDING, &req->flags);
> >> +       ring_ent->fuse_req =3D req;
> >> +       ring_ent->state =3D FRRS_FUSE_REQ;
> >> +       list_move(&ring_ent->list, &queue->ent_w_req_queue);
> >> +       fuse_uring_add_to_pq(ring_ent, req);
> >> +}
> >> +
> >> +/*
> >> + * Release the ring entry and fetch the next fuse request if availabl=
e
> >> + *
> >> + * @return true if a new request has been fetched
> >> + */
> >> +static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ring_ent)
> >> +       __must_hold(&queue->lock)
> >> +{
> >> +       struct fuse_req *req;
> >> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> >> +       struct list_head *req_queue =3D &queue->fuse_req_queue;
> >> +
> >> +       lockdep_assert_held(&queue->lock);
> >> +
> >> +       /* get and assign the next entry while it is still holding the=
 lock */
> >> +       req =3D list_first_entry_or_null(req_queue, struct fuse_req, l=
ist);
> >> +       if (req) {
> >> +               fuse_uring_add_req_to_ring_ent(ring_ent, req);
> >> +               return true;
> >> +       }
> >> +
> >> +       return false;
> >> +}
> >> +
> >> +/*
> >> + * Read data from the ring buffer, which user space has written to
> >> + * This is comparible with handling of classical write(/dev/fuse).
> >> + * Also make the ring request available again for new fuse requests.
> >> + */
> >> +static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
> >> +                             unsigned int issue_flags)
> >> +{
> >> +       struct fuse_ring *ring =3D ring_ent->queue->ring;
> >> +       struct fuse_conn *fc =3D ring->fc;
> >> +       struct fuse_req *req =3D ring_ent->fuse_req;
> >> +       ssize_t err =3D 0;
> >> +       bool set_err =3D false;
> >> +
> >> +       err =3D copy_from_user(&req->out.h, &ring_ent->headers->in_out=
,
> >> +                            sizeof(req->out.h));
> >> +       if (err) {
> >> +               req->out.h.error =3D err;
> >> +               goto out;
> >> +       }
> >> +
> >> +       err =3D fuse_uring_out_header_has_err(&req->out.h, req, fc);
> >> +       if (err) {
> >> +               /* req->out.h.error already set */
> >> +               goto out;
> >> +       }
> >> +
> >> +       err =3D fuse_uring_copy_from_ring(ring, req, ring_ent);
> >> +       if (err)
> >> +               set_err =3D true;
> >> +
> >> +out:
> >> +       fuse_uring_req_end(ring_ent, set_err, err);
> >> +}
> >> +
> >> +/*
> >> + * Get the next fuse req and send it
> >> + */
> >> +static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
> >> +                                    struct fuse_ring_queue *queue,
> >> +                                    unsigned int issue_flags)
> >> +{
> >> +       int err;
> >> +       bool has_next;
> >> +
> >> +retry:
> >> +       spin_lock(&queue->lock);
> >> +       fuse_uring_ent_avail(ring_ent, queue);
> >> +       has_next =3D fuse_uring_ent_assign_req(ring_ent);
> >> +       spin_unlock(&queue->lock);
> >> +
> >> +       if (has_next) {
> >> +               err =3D fuse_uring_send_next_to_ring(ring_ent, issue_f=
lags);
> >> +               if (err)
> >> +                       goto retry;
> >> +       }
> >> +}
> >> +
> >> +static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
> >> +{
> >> +       struct fuse_ring_queue *queue =3D ent->queue;
> >> +
> >> +       lockdep_assert_held(&queue->lock);
> >> +
> >> +       if (WARN_ON_ONCE(ent->state !=3D FRRS_USERSPACE))
> >> +               return -EIO;
> >> +
> >> +       ent->state =3D FRRS_COMMIT;
> >> +       list_move(&ent->list, &queue->ent_commit_queue);
> >> +
> >> +       return 0;
> >> +}
> >> +
> >> +/* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
> >> +static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issu=
e_flags,
> >> +                                  struct fuse_conn *fc)
> >> +{
> >> +       const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe_cmd(=
cmd->sqe);
> >> +       struct fuse_ring_ent *ring_ent;
> >> +       int err;
> >> +       struct fuse_ring *ring =3D fc->ring;
> >> +       struct fuse_ring_queue *queue;
> >> +       uint64_t commit_id =3D READ_ONCE(cmd_req->commit_id);
> >> +       unsigned int qid =3D READ_ONCE(cmd_req->qid);
> >> +       struct fuse_pqueue *fpq;
> >> +       struct fuse_req *req;
> >> +
> >> +       err =3D -ENOTCONN;
> >> +       if (!ring)
> >> +               return err;
> >> +
> >> +       if (qid >=3D ring->nr_queues)
> >> +               return -EINVAL;
> >> +
> >> +       queue =3D ring->queues[qid];
> >> +       if (!queue)
> >> +               return err;
> >> +       fpq =3D &queue->fpq;
> >> +
> >> +       spin_lock(&queue->lock);
> >> +       /* Find a request based on the unique ID of the fuse request
> >> +        * This should get revised, as it needs a hash calculation and=
 list
> >> +        * search. And full struct fuse_pqueue is needed (memory overh=
ead).
> >> +        * As well as the link from req to ring_ent.
> >> +        */
> >
> > imo, the hash calculation and list search seems ok. I can't think of a
> > more optimal way of doing it. Instead of using the full struct
> > fuse_pqueue, I think we could just have the "struct list_head
> > *processing" defined inside "struct fuse_ring_queue" and change
> > fuse_request_find() to take in a list_head. I don't think we need a
> > dedicated spinlock for the list either. We can just reuse queue->lock,
> > as that's (currently) always held already when the processing list is
> > accessed.
>
>
> Please see the attached patch, which uses xarray. Totally untested, thoug=
h.
> I actually found an issue while writing this patch - FR_PENDING was clear=
ed
> without holding fiq->lock, but that is important for request_wait_answer(=
).
> If something removes req from the list, we entirely loose the ring entry =
-
> can never be used anymore. Personally I think the attached patch is safer=
.
>
>
> >
> >
> >> +       req =3D fuse_request_find(fpq, commit_id);
> >> +       err =3D -ENOENT;
> >> +       if (!req) {
> >> +               pr_info("qid=3D%d commit_id %llu not found\n", queue->=
qid,
> >> +                       commit_id);
> >> +               spin_unlock(&queue->lock);
> >> +               return err;
> >> +       }
> >> +       list_del_init(&req->list);
> >> +       ring_ent =3D req->ring_entry;
> >> +       req->ring_entry =3D NULL;
> >
> > Do we need to set this to NULL, given that the request will be cleaned
> > up later in fuse_uring_req_end() anyways?
>
> It is not explicitly set to NULL in that function. Would you mind to keep
> it safe?
>
> >
> >> +
> >> +       err =3D fuse_ring_ent_set_commit(ring_ent);
> >> +       if (err !=3D 0) {
> >> +               pr_info_ratelimited("qid=3D%d commit_id %llu state %d"=
,
> >> +                                   queue->qid, commit_id, ring_ent->s=
tate);
> >> +               spin_unlock(&queue->lock);
> >> +               return err;
> >> +       }
> >> +
> >> +       ring_ent->cmd =3D cmd;
> >> +       spin_unlock(&queue->lock);
> >> +
> >> +       /* without the queue lock, as other locks are taken */
> >> +       fuse_uring_commit(ring_ent, issue_flags);
> >> +
> >> +       /*
> >> +        * Fetching the next request is absolutely required as queued
> >> +        * fuse requests would otherwise not get processed - committin=
g
> >> +        * and fetching is done in one step vs legacy fuse, which has =
separated
> >> +        * read (fetch request) and write (commit result).
> >> +        */
> >> +       fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
> >
> > If there's no request ready to read next, then no request will be
> > fetched and this will return. However, as I understand it, once the
> > uring is registered, userspace should only be interacting with the
> > uring via FUSE_IO_URING_CMD_COMMIT_AND_FETCH. However for the case
> > where no request was ready to read, it seems like userspace would have
> > nothing to commit when it wants to fetch the next request?
>
> We have
>
> FUSE_IO_URING_CMD_REGISTER
> FUSE_IO_URING_CMD_COMMIT_AND_FETCH
>
>
> After _CMD_REGISTER the corresponding ring-entry is ready to get fuse
> requests and waiting. After it gets a request assigned and handles it
> by fuse server the _COMMIT_AND_FETCH scheme applies. Did you possibly
> miss that _CMD_REGISTER will already have it waiting?
>

Sorry for the late reply. After _CMD_REGISTER and _COMMIT_AND_FETCH,
it seems possible that there is no fuse request waiting until a later
time? This is the scenario I'm envisioning:
a) uring registers successfully and fetches request through _CMD_REGISTER
b) server replies to request and fetches new request through _COMMIT_AND_FE=
TCH
c) server replies to request, tries to fetch new request but no
request is ready, through _COMMIT_AND_FETCH

maybe I'm missing something in my reading of the code, but how will
the server then fetch the next request once the request is ready? It
will have to commit something in order to fetch it since there's only
_COMMIT_AND_FETCH which requires a commit, no?


Thanks,
Joanne

>
> >
> > A more general question though: I imagine the most common use case
> > from the server side is waiting / polling until there is a request to
> > fetch. Could we not just do that here in the kernel instead with
> > adding a waitqueue mechanism and having fuse_uring_next_fuse_req()
> > only return when there is a request available? It seems like that
> > would reduce the amount of overhead instead of doing the
> > waiting/checking from the server side?
>
> The io-uring interface says that we should return -EIOCBQUEUED. If we
> would wait here, other SQEs that are submitted in parallel by
> fuse-server couldn't be handled anymore, as we wouldn't return
> to io-uring (all of this is in io-uring task context).
>
> >
> >> +       return 0;
> >> +}
> >> +
> >>  /*
> >>   * fuse_uring_req_fetch command handling
> >>   */
> >> @@ -325,6 +767,14 @@ int __maybe_unused fuse_uring_cmd(struct io_uring=
_cmd *cmd,
> >>                         return err;
> >>                 }
> >>                 break;
> >> +       case FUSE_IO_URING_CMD_COMMIT_AND_FETCH:
> >> +               err =3D fuse_uring_commit_fetch(cmd, issue_flags, fc);
> >> +               if (err) {
> >> +                       pr_info_once("FUSE_IO_URING_COMMIT_AND_FETCH f=
ailed err=3D%d\n",
> >> +                                    err);
> >> +                       return err;
> >> +               }
> >> +               break;
> >>         default:
> >>                 return -EINVAL;
> >>         }
> >> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> >> index 4e46dd65196d26dabc62dada33b17de9aa511c08..80f1c62d4df7f0ca77c4d5=
179068df6ffdbf7d85 100644
> >> --- a/fs/fuse/dev_uring_i.h
> >> +++ b/fs/fuse/dev_uring_i.h
> >> @@ -20,6 +20,9 @@ enum fuse_ring_req_state {
> >>         /* The ring entry is waiting for new fuse requests */
> >>         FRRS_AVAILABLE,
> >>
> >> +       /* The ring entry got assigned a fuse req */
> >> +       FRRS_FUSE_REQ,
> >> +
> >>         /* The ring entry is in or on the way to user space */
> >>         FRRS_USERSPACE,
> >>  };
> >> @@ -70,7 +73,16 @@ struct fuse_ring_queue {
> >>          * entries in the process of being committed or in the process
> >>          * to be sent to userspace
> >>          */
> >> +       struct list_head ent_w_req_queue;
> >
> > What does the w in this stand for? I find the name ambiguous here.
>
> "entry-with-request-queue".  Do you have another naming suggestion?
>
>
> Thanks,
> Bernd
>

