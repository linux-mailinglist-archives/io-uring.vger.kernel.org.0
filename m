Return-Path: <io-uring+bounces-5851-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E1219A0C4D6
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 23:45:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C0EB23A6F62
	for <lists+io-uring@lfdr.de>; Mon, 13 Jan 2025 22:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7141D0E28;
	Mon, 13 Jan 2025 22:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QqF7a4vN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47EF1EE7AC;
	Mon, 13 Jan 2025 22:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736808291; cv=none; b=o2vP0Oa7GSR4TGOiWPfPU9hH62Km1bpL4FFPto9j2LhKS/s0Y71eDQ8x01fvKDsVZgIM5s8qAAehjmOx/oG2rnvythr7V3hIjqckdyfNm4q0FO2swRnBkoTgowi46HMZjh+GN798InjuUOkBffVYfzv+6PrTI+UZ8R5JBcn28KE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736808291; c=relaxed/simple;
	bh=acFc9DA0jfAlB9wthoYPtUZUfS4n0tTIa5m908a6iwc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GWaR5nePNgL4QLeNMGYu/5POjKg2bTiko/JnNRvlp5P2rT0efiJO25QW5svnaWcD1vHhUXMYZR6dA41TpSHNc/3ZDHTauJsruL6jYF+n97llh9vVYnrs9IpefNC3kbkcHIFxQN79p7sXSWRXKxryi36nixkE8t7Y/hFL46MOSrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QqF7a4vN; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6dd1962a75bso38933646d6.3;
        Mon, 13 Jan 2025 14:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736808288; x=1737413088; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xG8MVm53U3gDiFtSLRvXEtZyvh5/QaA51V30EQQEpHc=;
        b=QqF7a4vNv6WEUhG7MbPilHMwKYEFTfH5qf7Z6l5c6JTZFdXTjbDpG4DZ58x7wxMzJK
         OUrRQ37sJxiQB+1smb4URzp8G9BBMK2Oa+A+kJAXSUaxd7/TVGTz2ZYISQPsmW2iZBlp
         JNfpMZ274dpcK7n8fZJfcRaiHSeNWezkWrvIBaPUVxH4aDDIJUdvzMjXFTSc95Wpu233
         4tRahyGUSGkV1t4XgIn5fqlxIAKckcnmIa8PhChbqgxpAjCeZ/h5nejSvx3npwe1eVsr
         bGwmMnQ/bezQG4r5u/eTt6ThbeDquScOJ73Rh39/3Ia3EETdz/f4si0Tj4E9DbCaySiO
         d29Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736808288; x=1737413088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xG8MVm53U3gDiFtSLRvXEtZyvh5/QaA51V30EQQEpHc=;
        b=tAQs3nCMA+R17aEqW41ecwcHFJGfrQxGykqt8AKMgF+mCY/v20asI80K9sio/DEhH6
         NtKNlUThZ6hlNLHQ/iEoj4BF1iyLeTf5n1UAPKmNmsPBCuRDsJnDk0qx3+8ScYAKxJOu
         WSB4b3ZGGpZIpyCLnXufzoHl7n9a6WcTiaAZpD1zgdTQsSuQ39qOINlPuqlg0uO5DKTY
         8HwSH/EKPEWR+qfxiR4Ro/2rKdNTSnLdnT81ymYSVT89iWhjsJevUTgyw3pBjQYcKM4B
         hCxIn8z9DVHVBsJ/EzrKx7NPIb3qyGZzIqqRIJz/OeCItzxk0B7/SfnWUSf8rR65ohvj
         EAAA==
X-Forwarded-Encrypted: i=1; AJvYcCWGiprGxC8lOvRXqFNjfHgRcuLVaVAvExEv+jihEPbYBv7oHoey69f4Z+Zuj2CsRPgZdWYs7z/goA==@vger.kernel.org, AJvYcCXkHJAa8k4qX0a8N68Cw/WKKgngpscIHx/A7JnPD1C+wwwh+aVXMYk3FPQp6t9Kz3UyJb8t2p2IaZeUvlqWWw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxzY4aRu2+EuJCeaB+o0RR8L5++IpVYdIpwf1jwpDB6Ceradp/2
	KboBugtmvVTFN2auxxiynSFnzLDBs0SfzMh604HPF7K1+35sQenWS6bIlPT4+8YgtYiUDl/QpCg
	aZbKZqeyXwx7/fpVFBrl9JNIpGjMzVqMN
X-Gm-Gg: ASbGncsr5dxuBuloLS0XOEOPW6R+pb76x8XPVWLi08oB4pQWRiipRbmNCk6sTRe1W2z
	rbG3RlfVMDzn+eOzoYT9cDs5+IN8txtEnFXSyNWMx
X-Google-Smtp-Source: AGHT+IEtz6qnJFQydRgoZt9BDxrIcXd621hjoJt5D2aRyoLrhQHUFrdWL2joqrLZ2uViulXH8EgZaRj1wFbtr9JmK3s=
X-Received: by 2002:ad4:5aeb:0:b0:6d4:211c:dff0 with SMTP id
 6a1803df08f44-6df9b250004mr329367136d6.29.1736808288398; Mon, 13 Jan 2025
 14:44:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com> <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
In-Reply-To: <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 13 Jan 2025 14:44:37 -0800
X-Gm-Features: AbW1kvZAs7Rq8kYYgqf7-z38ja2OMs0BU-cMCF9k8szotOmmJIiSlr70aoIIQic
Message-ID: <CAJnrk1afYmo+GNRb=OF7CUQzY5ocEus0h=93ax8usA9oa_qM4Q@mail.gmail.com>
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 6, 2025 at 4:25=E2=80=AFPM Bernd Schubert <bschubert@ddn.com> w=
rote:
>
> This adds support for fuse request completion through ring SQEs
> (FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
> the ring entry it becomes available for new fuse requests.
> Handling of requests through the ring (SQE/CQE handling)
> is complete now.
>
> Fuse request data are copied through the mmaped ring buffer,
> there is no support for any zero copy yet.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>  fs/fuse/dev_uring.c   | 450 ++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  fs/fuse/dev_uring_i.h |  12 ++
>  fs/fuse/fuse_i.h      |   4 +
>  3 files changed, 466 insertions(+)
>
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index b44ba4033615e01041313c040035b6da6af0ee17..f44e66a7ea577390da87e9ac7=
d118a9416898c28 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -26,6 +26,19 @@ bool fuse_uring_enabled(void)
>         return enable_uring;
>  }
>
> +static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_=
err,
> +                              int error)
> +{
> +       struct fuse_req *req =3D ring_ent->fuse_req;
> +
> +       if (set_err)
> +               req->out.h.error =3D error;

I think we could get away with not having the "bool set_err" as an
argument if we do "if (error)" directly. AFAICT, we can use the value
of error directly since  it always returns zero on success and any
non-zero value is considered an error.

> +
> +       clear_bit(FR_SENT, &req->flags);
> +       fuse_request_end(ring_ent->fuse_req);
> +       ring_ent->fuse_req =3D NULL;
> +}
> +
>  void fuse_uring_destruct(struct fuse_conn *fc)
>  {
>         struct fuse_ring *ring =3D fc->ring;
> @@ -41,8 +54,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
>                         continue;
>
>                 WARN_ON(!list_empty(&queue->ent_avail_queue));
> +               WARN_ON(!list_empty(&queue->ent_w_req_queue));
>                 WARN_ON(!list_empty(&queue->ent_commit_queue));
> +               WARN_ON(!list_empty(&queue->ent_in_userspace));
>
> +               kfree(queue->fpq.processing);
>                 kfree(queue);
>                 ring->queues[qid] =3D NULL;
>         }
> @@ -101,20 +117,34 @@ static struct fuse_ring_queue *fuse_uring_create_qu=
eue(struct fuse_ring *ring,
>  {
>         struct fuse_conn *fc =3D ring->fc;
>         struct fuse_ring_queue *queue;
> +       struct list_head *pq;
>
>         queue =3D kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
>         if (!queue)
>                 return NULL;
> +       pq =3D kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_K=
ERNEL);
> +       if (!pq) {
> +               kfree(queue);
> +               return NULL;
> +       }
> +
>         queue->qid =3D qid;
>         queue->ring =3D ring;
>         spin_lock_init(&queue->lock);
>
>         INIT_LIST_HEAD(&queue->ent_avail_queue);
>         INIT_LIST_HEAD(&queue->ent_commit_queue);
> +       INIT_LIST_HEAD(&queue->ent_w_req_queue);
> +       INIT_LIST_HEAD(&queue->ent_in_userspace);
> +       INIT_LIST_HEAD(&queue->fuse_req_queue);
> +
> +       queue->fpq.processing =3D pq;
> +       fuse_pqueue_init(&queue->fpq);
>
>         spin_lock(&fc->lock);
>         if (ring->queues[qid]) {
>                 spin_unlock(&fc->lock);
> +               kfree(queue->fpq.processing);
>                 kfree(queue);
>                 return ring->queues[qid];
>         }
> @@ -128,6 +158,214 @@ static struct fuse_ring_queue *fuse_uring_create_qu=
eue(struct fuse_ring *ring,
>         return queue;
>  }
>
> +/*
> + * Checks for errors and stores it into the request
> + */
> +static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
> +                                        struct fuse_req *req,
> +                                        struct fuse_conn *fc)
> +{
> +       int err;
> +
> +       err =3D -EINVAL;
> +       if (oh->unique =3D=3D 0) {
> +               /* Not supportd through io-uring yet */
> +               pr_warn_once("notify through fuse-io-uring not supported\=
n");
> +               goto seterr;
> +       }
> +
> +       err =3D -EINVAL;
> +       if (oh->error <=3D -ERESTARTSYS || oh->error > 0)
> +               goto seterr;
> +
> +       if (oh->error) {
> +               err =3D oh->error;
> +               goto err;
> +       }
> +
> +       err =3D -ENOENT;
> +       if ((oh->unique & ~FUSE_INT_REQ_BIT) !=3D req->in.h.unique) {
> +               pr_warn_ratelimited("unique mismatch, expected: %llu got =
%llu\n",
> +                                   req->in.h.unique,
> +                                   oh->unique & ~FUSE_INT_REQ_BIT);
> +               goto seterr;
> +       }
> +
> +       /*
> +        * Is it an interrupt reply ID?
> +        * XXX: Not supported through fuse-io-uring yet, it should not ev=
en
> +        *      find the request - should not happen.
> +        */
> +       WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
> +
> +       return 0;
> +
> +seterr:
> +       oh->error =3D err;
> +err:
> +       return err;
> +}
> +
> +static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
> +                                    struct fuse_req *req,
> +                                    struct fuse_ring_ent *ent)
> +{
> +       struct fuse_copy_state cs;
> +       struct fuse_args *args =3D req->args;
> +       struct iov_iter iter;
> +       int err, res;
> +       struct fuse_uring_ent_in_out ring_in_out;
> +
> +       res =3D copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_o=
ut,
> +                            sizeof(ring_in_out));
> +       if (res)
> +               return -EFAULT;
> +
> +       err =3D import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_=
sz,
> +                         &iter);
> +       if (err)
> +               return err;
> +
> +       fuse_copy_init(&cs, 0, &iter);
> +       cs.is_uring =3D 1;
> +       cs.req =3D req;
> +
> +       return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
> +}
> +
> + /*
> +  * Copy data from the req to the ring buffer
> +  */
> +static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_r=
eq *req,
> +                                  struct fuse_ring_ent *ent)
> +{
> +       struct fuse_copy_state cs;
> +       struct fuse_args *args =3D req->args;
> +       struct fuse_in_arg *in_args =3D args->in_args;
> +       int num_args =3D args->in_numargs;
> +       int err, res;
> +       struct iov_iter iter;
> +       struct fuse_uring_ent_in_out ent_in_out =3D {
> +               .flags =3D 0,
> +               .commit_id =3D ent->commit_id,
> +       };
> +
> +       if (WARN_ON(ent_in_out.commit_id =3D=3D 0))
> +               return -EINVAL;
> +
> +       err =3D import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz=
, &iter);
> +       if (err) {
> +               pr_info_ratelimited("fuse: Import of user buffer failed\n=
");
> +               return err;
> +       }
> +
> +       fuse_copy_init(&cs, 1, &iter);
> +       cs.is_uring =3D 1;
> +       cs.req =3D req;
> +
> +       if (num_args > 0) {
> +               /*
> +                * Expectation is that the first argument is the per op h=
eader.
> +                * Some op code have that as zero.
> +                */
> +               if (args->in_args[0].size > 0) {
> +                       res =3D copy_to_user(&ent->headers->op_in, in_arg=
s->value,
> +                                          in_args->size);
> +                       err =3D res > 0 ? -EFAULT : res;
> +                       if (err) {
> +                               pr_info_ratelimited(
> +                                       "Copying the header failed.\n");
> +                               return err;
> +                       }
> +               }
> +               in_args++;
> +               num_args--;
> +       }
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
> +       res =3D copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
> +                          sizeof(ent_in_out));
> +       err =3D res > 0 ? -EFAULT : res;
> +       if (err)
> +               return err;
> +
> +       return 0;
> +}
> +
> +static int
> +fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
> +{
> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> +       struct fuse_ring *ring =3D queue->ring;
> +       struct fuse_req *req =3D ring_ent->fuse_req;
> +       int err, res;
> +
> +       err =3D -EIO;
> +       if (WARN_ON(ring_ent->state !=3D FRRS_FUSE_REQ)) {
> +               pr_err("qid=3D%d ring-req=3D%p invalid state %d on send\n=
",
> +                      queue->qid, ring_ent, ring_ent->state);
> +               err =3D -EIO;
> +               goto err;
> +       }
> +
> +       /* copy the request */
> +       err =3D fuse_uring_copy_to_ring(ring, req, ring_ent);
> +       if (unlikely(err)) {
> +               pr_info_ratelimited("Copy to ring failed: %d\n", err);
> +               goto err;
> +       }
> +
> +       /* copy fuse_in_header */
> +       res =3D copy_to_user(&ring_ent->headers->in_out, &req->in.h,
> +                          sizeof(req->in.h));
> +       err =3D res > 0 ? -EFAULT : res;
> +       if (err)
> +               goto err;
> +
> +       set_bit(FR_SENT, &req->flags);
> +       return 0;
> +
> +err:
> +       fuse_uring_req_end(ring_ent, true, err);
> +       return err;
> +}
> +
> +/*
> + * Write data to the ring buffer and send the request to userspace,
> + * userspace will read it
> + * This is comparable with classical read(/dev/fuse)
> + */
> +static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent,
> +                                       unsigned int issue_flags)
> +{
> +       int err =3D 0;
> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> +
> +       err =3D fuse_uring_prepare_send(ring_ent);
> +       if (err)
> +               goto err;
> +
> +       spin_lock(&queue->lock);
> +       ring_ent->state =3D FRRS_USERSPACE;
> +       list_move(&ring_ent->list, &queue->ent_in_userspace);
> +       spin_unlock(&queue->lock);
> +
> +       io_uring_cmd_done(ring_ent->cmd, 0, 0, issue_flags);
> +       ring_ent->cmd =3D NULL;
> +       return 0;
> +
> +err:
> +       return err;
> +}
> +
>  /*
>   * Make a ring entry available for fuse_req assignment
>   */
> @@ -138,6 +376,210 @@ static void fuse_uring_ent_avail(struct fuse_ring_e=
nt *ring_ent,
>         ring_ent->state =3D FRRS_AVAILABLE;
>  }
>
> +/* Used to find the request on SQE commit */
> +static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent,
> +                                struct fuse_req *req)
> +{
> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> +       struct fuse_pqueue *fpq =3D &queue->fpq;
> +       unsigned int hash;
> +
> +       /* commit_id is the unique id of the request */
> +       ring_ent->commit_id =3D req->in.h.unique;
> +
> +       req->ring_entry =3D ring_ent;
> +       hash =3D fuse_req_hash(ring_ent->commit_id);
> +       list_move_tail(&req->list, &fpq->processing[hash]);
> +}
> +
> +/*
> + * Assign a fuse queue entry to the given entry
> + */
> +static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ring_en=
t,
> +                                          struct fuse_req *req)
> +{
> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> +
> +       lockdep_assert_held(&queue->lock);
> +
> +       if (WARN_ON_ONCE(ring_ent->state !=3D FRRS_AVAILABLE &&
> +                        ring_ent->state !=3D FRRS_COMMIT)) {
> +               pr_warn("%s qid=3D%d state=3D%d\n", __func__, ring_ent->q=
ueue->qid,
> +                       ring_ent->state);
> +       }
> +       list_del_init(&req->list);
> +       clear_bit(FR_PENDING, &req->flags);
> +       ring_ent->fuse_req =3D req;
> +       ring_ent->state =3D FRRS_FUSE_REQ;
> +       list_move(&ring_ent->list, &queue->ent_w_req_queue);
> +       fuse_uring_add_to_pq(ring_ent, req);
> +}
> +
> +/*
> + * Release the ring entry and fetch the next fuse request if available
> + *
> + * @return true if a new request has been fetched
> + */
> +static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ring_ent)
> +       __must_hold(&queue->lock)
> +{
> +       struct fuse_req *req;
> +       struct fuse_ring_queue *queue =3D ring_ent->queue;
> +       struct list_head *req_queue =3D &queue->fuse_req_queue;
> +
> +       lockdep_assert_held(&queue->lock);
> +
> +       /* get and assign the next entry while it is still holding the lo=
ck */
> +       req =3D list_first_entry_or_null(req_queue, struct fuse_req, list=
);
> +       if (req) {
> +               fuse_uring_add_req_to_ring_ent(ring_ent, req);
> +               return true;
> +       }
> +
> +       return false;
> +}
> +
> +/*
> + * Read data from the ring buffer, which user space has written to
> + * This is comparible with handling of classical write(/dev/fuse).
> + * Also make the ring request available again for new fuse requests.
> + */
> +static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
> +                             unsigned int issue_flags)
> +{
> +       struct fuse_ring *ring =3D ring_ent->queue->ring;
> +       struct fuse_conn *fc =3D ring->fc;
> +       struct fuse_req *req =3D ring_ent->fuse_req;
> +       ssize_t err =3D 0;
> +       bool set_err =3D false;
> +
> +       err =3D copy_from_user(&req->out.h, &ring_ent->headers->in_out,
> +                            sizeof(req->out.h));
> +       if (err) {
> +               req->out.h.error =3D err;
> +               goto out;
> +       }
> +
> +       err =3D fuse_uring_out_header_has_err(&req->out.h, req, fc);
> +       if (err) {
> +               /* req->out.h.error already set */
> +               goto out;
> +       }
> +
> +       err =3D fuse_uring_copy_from_ring(ring, req, ring_ent);
> +       if (err)
> +               set_err =3D true;
> +
> +out:
> +       fuse_uring_req_end(ring_ent, set_err, err);
> +}
> +
> +/*
> + * Get the next fuse req and send it
> + */
> +static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
> +                                    struct fuse_ring_queue *queue,
> +                                    unsigned int issue_flags)
> +{
> +       int err;
> +       bool has_next;
> +
> +retry:
> +       spin_lock(&queue->lock);
> +       fuse_uring_ent_avail(ring_ent, queue);
> +       has_next =3D fuse_uring_ent_assign_req(ring_ent);
> +       spin_unlock(&queue->lock);
> +
> +       if (has_next) {
> +               err =3D fuse_uring_send_next_to_ring(ring_ent, issue_flag=
s);
> +               if (err)
> +                       goto retry;
> +       }
> +}
> +
> +static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
> +{
> +       struct fuse_ring_queue *queue =3D ent->queue;
> +
> +       lockdep_assert_held(&queue->lock);
> +
> +       if (WARN_ON_ONCE(ent->state !=3D FRRS_USERSPACE))
> +               return -EIO;
> +
> +       ent->state =3D FRRS_COMMIT;
> +       list_move(&ent->list, &queue->ent_commit_queue);
> +
> +       return 0;
> +}
> +
> +/* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
> +static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_f=
lags,
> +                                  struct fuse_conn *fc)
> +{
> +       const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe_cmd(cmd=
->sqe);
> +       struct fuse_ring_ent *ring_ent;
> +       int err;
> +       struct fuse_ring *ring =3D fc->ring;
> +       struct fuse_ring_queue *queue;
> +       uint64_t commit_id =3D READ_ONCE(cmd_req->commit_id);
> +       unsigned int qid =3D READ_ONCE(cmd_req->qid);
> +       struct fuse_pqueue *fpq;
> +       struct fuse_req *req;
> +
> +       err =3D -ENOTCONN;
> +       if (!ring)
> +               return err;
> +
> +       if (qid >=3D ring->nr_queues)
> +               return -EINVAL;
> +
> +       queue =3D ring->queues[qid];
> +       if (!queue)
> +               return err;
> +       fpq =3D &queue->fpq;
> +
> +       spin_lock(&queue->lock);
> +       /* Find a request based on the unique ID of the fuse request
> +        * This should get revised, as it needs a hash calculation and li=
st
> +        * search. And full struct fuse_pqueue is needed (memory overhead=
).
> +        * As well as the link from req to ring_ent.
> +        */

imo, the hash calculation and list search seems ok. I can't think of a
more optimal way of doing it. Instead of using the full struct
fuse_pqueue, I think we could just have the "struct list_head
*processing" defined inside "struct fuse_ring_queue" and change
fuse_request_find() to take in a list_head. I don't think we need a
dedicated spinlock for the list either. We can just reuse queue->lock,
as that's (currently) always held already when the processing list is
accessed.


> +       req =3D fuse_request_find(fpq, commit_id);
> +       err =3D -ENOENT;
> +       if (!req) {
> +               pr_info("qid=3D%d commit_id %llu not found\n", queue->qid=
,
> +                       commit_id);
> +               spin_unlock(&queue->lock);
> +               return err;
> +       }
> +       list_del_init(&req->list);
> +       ring_ent =3D req->ring_entry;
> +       req->ring_entry =3D NULL;

Do we need to set this to NULL, given that the request will be cleaned
up later in fuse_uring_req_end() anyways?

> +
> +       err =3D fuse_ring_ent_set_commit(ring_ent);
> +       if (err !=3D 0) {
> +               pr_info_ratelimited("qid=3D%d commit_id %llu state %d",
> +                                   queue->qid, commit_id, ring_ent->stat=
e);
> +               spin_unlock(&queue->lock);
> +               return err;
> +       }
> +
> +       ring_ent->cmd =3D cmd;
> +       spin_unlock(&queue->lock);
> +
> +       /* without the queue lock, as other locks are taken */
> +       fuse_uring_commit(ring_ent, issue_flags);
> +
> +       /*
> +        * Fetching the next request is absolutely required as queued
> +        * fuse requests would otherwise not get processed - committing
> +        * and fetching is done in one step vs legacy fuse, which has sep=
arated
> +        * read (fetch request) and write (commit result).
> +        */
> +       fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);

If there's no request ready to read next, then no request will be
fetched and this will return. However, as I understand it, once the
uring is registered, userspace should only be interacting with the
uring via FUSE_IO_URING_CMD_COMMIT_AND_FETCH. However for the case
where no request was ready to read, it seems like userspace would have
nothing to commit when it wants to fetch the next request?

A more general question though: I imagine the most common use case
from the server side is waiting / polling until there is a request to
fetch. Could we not just do that here in the kernel instead with
adding a waitqueue mechanism and having fuse_uring_next_fuse_req()
only return when there is a request available? It seems like that
would reduce the amount of overhead instead of doing the
waiting/checking from the server side?

> +       return 0;
> +}
> +
>  /*
>   * fuse_uring_req_fetch command handling
>   */
> @@ -325,6 +767,14 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cm=
d *cmd,
>                         return err;
>                 }
>                 break;
> +       case FUSE_IO_URING_CMD_COMMIT_AND_FETCH:
> +               err =3D fuse_uring_commit_fetch(cmd, issue_flags, fc);
> +               if (err) {
> +                       pr_info_once("FUSE_IO_URING_COMMIT_AND_FETCH fail=
ed err=3D%d\n",
> +                                    err);
> +                       return err;
> +               }
> +               break;
>         default:
>                 return -EINVAL;
>         }
> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
> index 4e46dd65196d26dabc62dada33b17de9aa511c08..80f1c62d4df7f0ca77c4d5179=
068df6ffdbf7d85 100644
> --- a/fs/fuse/dev_uring_i.h
> +++ b/fs/fuse/dev_uring_i.h
> @@ -20,6 +20,9 @@ enum fuse_ring_req_state {
>         /* The ring entry is waiting for new fuse requests */
>         FRRS_AVAILABLE,
>
> +       /* The ring entry got assigned a fuse req */
> +       FRRS_FUSE_REQ,
> +
>         /* The ring entry is in or on the way to user space */
>         FRRS_USERSPACE,
>  };
> @@ -70,7 +73,16 @@ struct fuse_ring_queue {
>          * entries in the process of being committed or in the process
>          * to be sent to userspace
>          */
> +       struct list_head ent_w_req_queue;

What does the w in this stand for? I find the name ambiguous here.


Thanks,
Joanne

>         struct list_head ent_commit_queue;
> +
> +       /* entries in userspace */
> +       struct list_head ent_in_userspace;
> +
> +       /* fuse requests waiting for an entry slot */
> +       struct list_head fuse_req_queue;
> +
> +       struct fuse_pqueue fpq;
>  };
>
>  /**
> diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
> index e545b0864dd51e82df61cc39bdf65d3d36a418dc..e71556894bc25808581424ec7=
bdd4afeebc81f15 100644
> --- a/fs/fuse/fuse_i.h
> +++ b/fs/fuse/fuse_i.h
> @@ -438,6 +438,10 @@ struct fuse_req {
>
>         /** fuse_mount this request belongs to */
>         struct fuse_mount *fm;
> +
> +#ifdef CONFIG_FUSE_IO_URING
> +       void *ring_entry;
> +#endif
>  };
>
>  struct fuse_iqueue;
>
> --
> 2.43.0
>

