Return-Path: <io-uring+bounces-4780-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE849D18FB
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 20:33:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ECF028230C
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 19:33:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642961E1311;
	Mon, 18 Nov 2024 19:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZBMSoMUF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B11217BBF;
	Mon, 18 Nov 2024 19:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731958376; cv=none; b=fk1Mh8u1ahx9E3QFPPufRxGmypgFmQybkoXIE4btrZmmwJaFPPO1j9sKkYCAcNGlenv/jpsSrlTUHgspZXZEP2ZcscuQW0KoOSVkg6s9YbLiNwQGeNceOY0NfammT2aeeCpjQ2etYAyqNmhLkoLQEEmX0C4hcv9Ab7VRtxBPVdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731958376; c=relaxed/simple;
	bh=CXrVOy7sVwbasAR7srnupV5NSzNrjv/HeZ8lV60+Zqw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EOTt3+f0LARcD+6SfCoea2V6td2F+A7AoedHuGhCZsx6ryo4J41yd+tY4K5Jc+YTQmHHLDJqnXVBI6Ipajbi6taFPGNoF252E9HtB6tIvgsnVNIafnGRhL6Aa90aOKEaBsh5oPQlJ/VWXABHdrCPGzQAFUh06QBRcz104qev2j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZBMSoMUF; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-46094b68e30so22708341cf.0;
        Mon, 18 Nov 2024 11:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731958373; x=1732563173; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3aw+l9dNkcLkNrO2Pq7kW0cBMAuFKpkuRyv9EfA/6Y=;
        b=ZBMSoMUFKgON/mnRyhLgWm/Ndv1M/3cGpkIh6DTbNSx4CgsJ7e666r0Ol+C+hx6Jq2
         tyIxqhQdVc7IZ74rpHmJYJudqdqLDfPCM9kGz39DHPSIRZbOM9U3ugO2he4GuiYbDTDE
         d5sAmIFpHbdi1IighWD4twTFGpPv1Z1wa4djjIcueBOsfnKBLhgNYNoG8uOnPnbpYZWI
         JjFq4mNa0VevvaS5+I+e6XjdVO8M3p8N1ACv/ZpYWmvJkbV1ptIiVXN53jEOczwV4RG4
         HN7y2a1h7ClWGwtnjngRdMy82w1OW/KgNp4k+UCMqnEAnHlxIQ3TkQp3iQcV6bMUaqPw
         R/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731958373; x=1732563173;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D3aw+l9dNkcLkNrO2Pq7kW0cBMAuFKpkuRyv9EfA/6Y=;
        b=OQAG8uTEpsFDF0i81jXTfCNg4/FHRTSQ5N3E+lh8k7f4Gd5jMfOSfzrBNMXwmJMuoY
         OHvesBQZFbc/2a/aXcgDULA6k0RlgavfII3evarO6Y6O0bvdpCPVJvI2xDuQ5gNeJrbU
         t7wyttEBjdGsNOZWzVlxlMx1A3XX+dZuYVs4uf5yJFYHJ61lBCK6DmP7SlRsfuKjRAbM
         0C7ald4PkvE8KJ5x7Ha+fpX4GI/V5CusfNQ/XSgeNHRJpigep3TxcTGKcVJaeKXfkCcY
         oF7/Kt64iYibpOlb3gJ6ktWsZU5j5WF1r7lJBzH9L5BCk3mqanXeGEPMjshCq1C54G17
         Vx9w==
X-Forwarded-Encrypted: i=1; AJvYcCVaMWF764sOezDzKlPv4rqfyQPhmAfo4emDlsPKRzmUfwgwDKNkKcgV+wxpzJC6zKwEU0SoY1M5PA==@vger.kernel.org, AJvYcCXDBSpWW2+QpJV9ia+WgvUE8zq0Sr/R9aNGlwP9/UOM4rl3CwvSMspijRiHEbtx25qV5eq1zazapZEiPR2NbA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxtmG8Hg7cLra86McV+mgGXIINVMl2wqleV9xYZ5LPcLxneHewb
	IBsWBS33KJfZBY0JeCaEGJ4asUJq/yezlJSkyMsPioiIYM/B/vqC/GmowCrBqXSkiytoTRtU0+3
	lTGoeIfVMY84+13BDTZJfaplI0oY=
X-Google-Smtp-Source: AGHT+IFldBnd1UdGeKQ2PGX9AW0KXnjkGEzEcD0/ycQg0O0d2R/gC78fXYAZXMtIWK0Gy6I6cm2o8UuQg53g09J+T44=
X-Received: by 2002:a05:622a:24c:b0:463:1039:fae7 with SMTP id
 d75a77b69052e-46363eb5c20mr196063751cf.49.1731958373479; Mon, 18 Nov 2024
 11:32:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com> <20241107-fuse-uring-for-6-10-rfc4-v5-15-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-15-e8660a991499@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 Nov 2024 11:32:42 -0800
Message-ID: <CAJnrk1ZexeFu7PopHUe_jPNRCGWWG5ha-P9min0VV+LJO5mAZw@mail.gmail.com>
Subject: Re: [PATCH RFC v5 15/16] fuse: {io-uring} Prevent mount point hang on
 fuse-server termination
To: Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 9:04=E2=80=AFAM Bernd Schubert <bschubert@ddn.com> w=
rote:
>
> When the fuse-server terminates while the fuse-client or kernel
> still has queued URING_CMDs, these commands retain references
> to the struct file used by the fuse connection. This prevents
> fuse_dev_release() from being invoked, resulting in a hung mount
> point.

Could you explain the flow of what happens after a fuse server
terminates? How does that trigger the IO_URING_F_CANCEL uring cmd?

>
> This patch addresses the issue by making queued URING_CMDs
> cancelable, allowing fuse_dev_release() to proceed as expected
> and preventing the mount point from hanging.
>
> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
> ---
>  fs/fuse/dev_uring.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++=
+-----
>  1 file changed, 70 insertions(+), 6 deletions(-)
>
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index 6af515458695ccb2e32cc8c62c45471e6710c15f..b465da41c42c47eaf69f09bab=
1423061bc8fcc68 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -23,6 +23,7 @@ MODULE_PARM_DESC(enable_uring,
>
>  struct fuse_uring_cmd_pdu {
>         struct fuse_ring_ent *ring_ent;
> +       struct fuse_ring_queue *queue;
>  };
>
>  /*
> @@ -382,6 +383,61 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)
>         }
>  }
>
> +/*
> + * Handle IO_URING_F_CANCEL, typically should come on daemon termination
> + */
> +static void fuse_uring_cancel(struct io_uring_cmd *cmd,
> +                             unsigned int issue_flags, struct fuse_conn =
*fc)
> +{
> +       struct fuse_uring_cmd_pdu *pdu =3D (struct fuse_uring_cmd_pdu *)c=
md->pdu;
> +       struct fuse_ring_queue *queue =3D pdu->queue;
> +       struct fuse_ring_ent *ent;
> +       bool found =3D false;
> +       bool need_cmd_done =3D false;
> +
> +       spin_lock(&queue->lock);
> +
> +       /* XXX: This is cumbersome for large queues. */
> +       list_for_each_entry(ent, &queue->ent_avail_queue, list) {
> +               if (pdu->ring_ent =3D=3D ent) {
> +                       found =3D true;
> +                       break;
> +               }
> +       }
> +
> +       if (!found) {
> +               pr_info("qid=3D%d Did not find ent=3D%p", queue->qid, ent=
);
> +               spin_unlock(&queue->lock);
> +               return;
> +       }
> +
> +       if (ent->state =3D=3D FRRS_WAIT) {
> +               ent->state =3D FRRS_USERSPACE;
> +               list_move(&ent->list, &queue->ent_in_userspace);
> +               need_cmd_done =3D true;
> +       }
> +       spin_unlock(&queue->lock);
> +
> +       if (need_cmd_done)
> +               io_uring_cmd_done(cmd, -ENOTCONN, 0, issue_flags);
> +
> +       /*
> +        * releasing the last entry should trigger fuse_dev_release() if
> +        * the daemon was terminated
> +        */
> +}
> +
> +static void fuse_uring_prepare_cancel(struct io_uring_cmd *cmd, int issu=
e_flags,
> +                                     struct fuse_ring_ent *ring_ent)
> +{
> +       struct fuse_uring_cmd_pdu *pdu =3D (struct fuse_uring_cmd_pdu *)c=
md->pdu;
> +
> +       pdu->ring_ent =3D ring_ent;
> +       pdu->queue =3D ring_ent->queue;
> +
> +       io_uring_cmd_mark_cancelable(cmd, issue_flags);
> +}
> +
>  /*
>   * Checks for errors and stores it into the request
>   */
> @@ -606,7 +662,8 @@ static int fuse_uring_send_next_to_ring(struct fuse_r=
ing_ent *ring_ent)
>   * Put a ring request onto hold, it is no longer used for now.
>   */
>  static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
> -                                struct fuse_ring_queue *queue)
> +                                struct fuse_ring_queue *queue,
> +                                unsigned int issue_flags)
>         __must_hold(&queue->lock)
>  {
>         struct fuse_ring *ring =3D queue->ring;
> @@ -626,6 +683,7 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent=
 *ring_ent,
>         list_move(&ring_ent->list, &queue->ent_avail_queue);
>
>         ring_ent->state =3D FRRS_WAIT;
> +       fuse_uring_prepare_cancel(ring_ent->cmd, issue_flags, ring_ent);
>  }
>
>  /* Used to find the request on SQE commit */
> @@ -729,7 +787,8 @@ static void fuse_uring_commit(struct fuse_ring_ent *r=
ing_ent,
>   * Get the next fuse req and send it
>   */
>  static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
> -                                   struct fuse_ring_queue *queue)
> +                                   struct fuse_ring_queue *queue,
> +                                   unsigned int issue_flags)
>  {
>         int has_next, err;
>         int prev_state =3D ring_ent->state;
> @@ -738,7 +797,7 @@ static void fuse_uring_next_fuse_req(struct fuse_ring=
_ent *ring_ent,
>                 spin_lock(&queue->lock);
>                 has_next =3D fuse_uring_ent_assign_req(ring_ent);
>                 if (!has_next) {
> -                       fuse_uring_ent_avail(ring_ent, queue);
> +                       fuse_uring_ent_avail(ring_ent, queue, issue_flags=
);
>                         spin_unlock(&queue->lock);
>                         break; /* no request left */
>                 }
> @@ -813,7 +872,7 @@ static int fuse_uring_commit_fetch(struct io_uring_cm=
d *cmd, int issue_flags,
>          * and fetching is done in one step vs legacy fuse, which has sep=
arated
>          * read (fetch request) and write (commit result).
>          */
> -       fuse_uring_next_fuse_req(ring_ent, queue);
> +       fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
>         return 0;
>  }
>
> @@ -853,7 +912,7 @@ static void _fuse_uring_fetch(struct fuse_ring_ent *r=
ing_ent,
>         struct fuse_ring *ring =3D queue->ring;
>
>         spin_lock(&queue->lock);
> -       fuse_uring_ent_avail(ring_ent, queue);
> +       fuse_uring_ent_avail(ring_ent, queue, issue_flags);
>         ring_ent->cmd =3D cmd;
>         spin_unlock(&queue->lock);
>
> @@ -1021,6 +1080,11 @@ int fuse_uring_cmd(struct io_uring_cmd *cmd, unsig=
ned int issue_flags)
>         if (fc->aborted)
>                 goto out;
>
> +       if ((unlikely(issue_flags & IO_URING_F_CANCEL))) {
> +               fuse_uring_cancel(cmd, issue_flags, fc);
> +               return 0;
> +       }
> +
>         switch (cmd_op) {
>         case FUSE_URING_REQ_FETCH:
>                 err =3D fuse_uring_fetch(cmd, issue_flags, fc);
> @@ -1080,7 +1144,7 @@ fuse_uring_send_req_in_task(struct io_uring_cmd *cm=
d,
>
>         return;
>  err:
> -       fuse_uring_next_fuse_req(ring_ent, queue);
> +       fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
>  }
>
>  /* queue a fuse request and send it if a ring entry is available */
>
> --
> 2.43.0
>

