Return-Path: <io-uring+bounces-4786-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D0AA9D1BD3
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 00:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C36AEB21763
	for <lists+io-uring@lfdr.de>; Mon, 18 Nov 2024 23:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3727F1885BF;
	Mon, 18 Nov 2024 23:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="boYHT9Kr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAE9154BEA;
	Mon, 18 Nov 2024 23:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731972624; cv=none; b=aK6/bXnelML67+9iij5vtDjsnTqdZraJiaOtBALjzST1wMSETwQYzaNHRzwq5rkXoNG6HtevRqHubwC3vWV5aruyzbrs3ptkqjDgpZaoROYzZceUicCToAx6gIMHEvtP9jGeCBPDYFT7Hx51nraTjkwRsufx9hkvVqTpum8eGsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731972624; c=relaxed/simple;
	bh=hATFqPu8f9Ti1oTYj4ZbbVZiPtL6eCx+CG69CiNO6rk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GHJ1V9v7wMpowyK8IyWDmoRBm5w477j7xY72eVY+iXL/MOsolFvHLusTosZVuW9Ra1H7Ffq/UdU3YbCEj+8tIoLWjt9R3RpLBM8X749ZIbYLuuX7bSCqPjBy745Q3xOMEhITEcXQ60sCTWej3uotKK5AFISweEerxlcP+q0n9FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=boYHT9Kr; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-460963d6233so23384001cf.2;
        Mon, 18 Nov 2024 15:30:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731972621; x=1732577421; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KvnqydXGQ2eMVAuarcgXvZzISyK+wvUJeJxNWI+7KDQ=;
        b=boYHT9Kr8utQk+Z5RpJrD5PBCPA2O8U2RFI/FvKf0KF1z62gy0rXlW2OtgV20gGtnX
         Srye7uww561TjIA4zN3DlLjbRhVu3NwYHmjvdc0vBnbXCpD5UClUiCmkpeVe84IaTu7l
         i3l+Xu1Hl75yAHaJxL1j3SzEn7JcScgrtrf2PF/Wya1QixLfJLNlgTnZRLc7ddCyYWim
         c/YgMaMZAW2MUCvS9BMycJnwVXtDkFxbp4syMwSnzudBkD3IkPVyull5823zqqBeG6nV
         fn3Mo0fl+tzTxDv4atxYU4DRNJySR+fwCHg5GI71lqIgh539kJOXEQ7XvONMBQ1erCgA
         2jug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731972621; x=1732577421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KvnqydXGQ2eMVAuarcgXvZzISyK+wvUJeJxNWI+7KDQ=;
        b=ebFS0k0ukgkr/6Q1/nD0gCiXB4tODwh4llf4j0yWzkWDDPiAGPKm1+T2/Su9HMj4ge
         yhp5/PxKRclTb+fvzduzlZav2vFzbQdvUwySnMnw0WlkDvrpUeYGvfsSr5bXRkZQW/u+
         9BalxwG1VpEXtBIBsn6Xd4E6fr36B6lLq21AgEqRANStCpmJ0jhebQ05gQ5OOBMn5sUW
         nBm2mnNtBECCa9TTY8ARoZW7xUdq1iJv7kmNL5z4uhpzFsoXfSLIbkQ3OJx6bj6lmAKS
         a//lezV/U9cqkw3vdU2zk8PCnv9iN1tQHBdo446e+bY8ej2b+zJmkRRZpgZwwNMce2hs
         ic6w==
X-Forwarded-Encrypted: i=1; AJvYcCUN2SLC7Hky0x187nWV30gX4ylU1uF85s806kj6fXDoccv/fY/EF9W60PQCFilqpdpmQnCKquVfOw==@vger.kernel.org, AJvYcCX8xZ+8Z4vg6p3fI/A4cRm49OnxpyT1Aq21d+coQyzCCuXbqP/WEJ1diEFwhyKXuJvvXcQq9WN5v4qJQSkGiw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc0ef4c/3E6yyAaiNyqF2F92Mq1Fhw8ElYwXVYaIaYvDhenNq/
	mC7z0+jRJiyncnxDqkCIf9AFcbCcOLTFMfmoW+2x9mjheDUzGmrIiB4UGsQ4mkyDTBuF88H0kCX
	Zl7xbj/24CB9QogE+Is3b7OXS6JE=
X-Google-Smtp-Source: AGHT+IEx21tL/dFgf6LSaeW07lZx1jvKRLo2+NTxHtnLs+j2uox5HTjKjTa1AtQb7sZI9XvVprD22a5sHe0F5uFCjgY=
X-Received: by 2002:a05:622a:260c:b0:45f:d8e0:9f05 with SMTP id
 d75a77b69052e-46363ebabb5mr266501131cf.52.1731972621218; Mon, 18 Nov 2024
 15:30:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107-fuse-uring-for-6-10-rfc4-v5-0-e8660a991499@ddn.com> <20241107-fuse-uring-for-6-10-rfc4-v5-15-e8660a991499@ddn.com>
In-Reply-To: <20241107-fuse-uring-for-6-10-rfc4-v5-15-e8660a991499@ddn.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 Nov 2024 15:30:10 -0800
Message-ID: <CAJnrk1YuoiWzq=ykn9wFKG3RZYdFm-AzSiXfoP=Js0S-P7eKZA@mail.gmail.com>
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

Do we have to check that the entry is on the ent_avail_queue, or can
we assume that if the ent->state is FRRS_WAIT, the only queue it'll be
on is the ent_avail_queue? I see only one case where this isn't true,
for teardown in fuse_uring_stop_list_entries() - if we had a
workaround for this, eg having some teardown state signifying that
io_uring_cmd_done() needs to be called on the cmd and clearing
FRRS_WAIT, then we could get rid of iteration through ent_avail_queue
for every cancelled cmd.

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

