Return-Path: <io-uring+bounces-13740-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 8TklDDljMGq+SQUAu9opvQ
	(envelope-from <io-uring+bounces-13740-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 22:40:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 64710689F7F
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 22:40:24 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=cT3o2Iox;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13740-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-13740-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 35048304C134
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2026 20:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5EDE3B5841;
	Mon, 15 Jun 2026 20:40:22 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76BF33B531A
	for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 20:40:20 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781556022; cv=pass; b=mnHQaizKXX8wTTaCDyUrupxQKtBUxY9bBXJJKz7ksMzAE9BhLNiV4qTngsGwG/KXio7iIN1rnwNSbriAhxXSc7PuiYM2O389+FzyxkhFkEy1FOJivGx1uwXRee3q+6LxKEKOunWhFGT50r6mBi4QVw13uxOWyGiPy8k8qtvBuFk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781556022; c=relaxed/simple;
	bh=SW2k3jj1ErMw3i5+H2iTRfz66fBNgsZjdPSgzVNJFo8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WAmOruc7N6jkqodCda9LYQv1C24Wz4i4acTTjdLTS7AJckc6V5bwprWUUyodXDXMHYJPAPb66lyp9a48fYkJk1or4MlzBjTS0Nmdndy9peMy5dExOg9QrGLjobmG430IOc4KYTqM/emLRuwnw5vDmj2m73At2bQxRnu/IaMn2aI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=cT3o2Iox; arc=pass smtp.client-ip=209.85.210.52
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7e5f63ab07cso495193a34.1
        for <io-uring@vger.kernel.org>; Mon, 15 Jun 2026 13:40:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781556019; cv=none;
        d=google.com; s=arc-20240605;
        b=Au81D1k5s+I5M9xs3XWIzyWjb28rtLyUKCNqzQ3u7r15qf5jgXuLcxnt6DJ4gAM1d2
         C88NJmmMixtiY0QHKFLdmEadntG2WZI6P1fySUFuxIsyEaTpqPrzYtfszAir1NdTcY6E
         GRKO6H+MuDL8cPA64V6ShgXljqfMozViKWaTanFcEIYRqOn69SIm/kfwCKcVY7ifrv15
         xvfqnq2xBfwFlkHLapNFoF8Ir1XfRQ18FZQ+0mYJPRt1vsqOwT7tx9tgbZVIVBrHjGj3
         DDO/8C+SpM/W9mfE7Rnxkjcs1KOe8IVnvdlOMsEDHNK4dFq6pKaoi7x0oTaWPosPSHij
         /9ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Wa6Cil3F7sLRo8/J1mhaMsg0NIZsgOhYLu887XCYS00=;
        fh=tcB1jbK5Mfh49jFaBDMFCl5E4RG50sbZDH32oaESUuc=;
        b=LWW+KZXE98RiwPdcVnbkaJqSnNwhRFhACEc3EfaqrRGs3B6aV142ZV7x3+mTngKhZA
         v2bi1O5RNqnMHzbJHvPldV5yzu574iD6MEduBoRfQUHDGj903/nwsYPsQeZXZrK8plCI
         TKEnaUqUNPOp6Ggo8vMYhSXs5Dq5AmzIvjaQF/PhPjX3BidXXJmNKHnvWMw6nJTC0G6e
         EOqz+aKBw/t0Cjj+yHy+/V/mM8NoJrzaMHXhvN8vOgG3mg92Qfga70Ah9JVoC1QBjee8
         RhqP7aBk+CqVhC6l3IB6AT+ZBDaIE1BNoemoqL726dbSdi+5SSup+RC4xXqAI6ghfmX/
         HtuQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781556019; x=1782160819; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wa6Cil3F7sLRo8/J1mhaMsg0NIZsgOhYLu887XCYS00=;
        b=cT3o2Iox3j0aZF3xWRSt9z8poFFW7Q/ZsSTHliWIZz97lb9nfFzgsaQyhg7ry6xiEc
         Rev90rs80p1Bkue5FhuR7oVy0oCJxqhK968C6UiLMCtAYC/RUyXIJUQZOKWZkOHXKT1l
         7dvTe3roKKm+QDIi10KVKys6crn4OeghLAnNepJq1gJivo8m82mr6a21wxYbp/1Wjyqz
         QizWIuSp4xJUQqFtqyKdWonVJIyNckU85eHBDUlfUfeE/tP13xlLR08B6xrO2BedV9MJ
         fAU5q44Erk0+88i7rPYRskN3QPxYyPlHnEUZ1w2tJy4tQxDvMc8ApzD9qkl116pQQLP/
         pglw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781556019; x=1782160819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wa6Cil3F7sLRo8/J1mhaMsg0NIZsgOhYLu887XCYS00=;
        b=SRLNixs7A/60k3KRKV9WbBeUSPkK6GMEaNID9YUG/KKU2Eii+UmNjUYqhV7jSalKYj
         mVCcqauBPfdyS7hPQvWX1JF2ycqzm1SvaHPKlC1NTU9fS8VVUibNjE8lDEo3pFdqA8VE
         pHPafmsJXKNoas2RkZ3yWM/pv6FgAGFfmDKtBx2I0ZNlRAAxNMShi8aYvKz9Aunxoy1q
         kFE/oQcxj9RvIBErjhxnN62aSCtDc5q5oIZsMIf12SMkWVUV/BXsCPV+vb8dY+yMDY+6
         fbXaWZScswcMYx2EFAdHCXb8gmgJEltapeUvLwPjFiHzQS85Gv86jqhPVVWC25i8M2WB
         /X1Q==
X-Gm-Message-State: AOJu0YwaZYGgxFUjCM+qKIvUPb+5pWRq+w+UIAjEFDCAN9OUzEHd6xWZ
	UTBUdkJMrBotDBGiPXEe41eY1a9anSTLF9L79FF4DqaMcwVeFs6ttzBrKbHTEB5gy6eWN2X2DT2
	eFlFtdJCCsJcG95Lk4ZUqwtLAhK2tbGZAMQjfdrfwLg==
X-Gm-Gg: Acq92OGQ87/ORv9NMVLb456tSmeZqrU03wL2p1mfdSavn5qD1j2Qhk5M9zN42f69Gul
	NZw5MWESQamHFEx0AWcoJA8vdEhG24dGoEzgRTvk1VDQ4Kkm1UvBMlUYF35G7RCqxtp+odzkrE7
	k/blD9h4/F4sfAG61rHkFtO6tTKrHu+Ei/HnJzdvLpflVhR1y8FLQXFuWHpQdcOZhPIcnzSJNSz
	nSKO6ZrrLI2PLuzuterVhAJcTWSn0SZyfGu8D+yfQTCnILxvJxdAC80PJDTKB/8PAqcGqhHjfrN
	XEz8Y2U=
X-Received: by 2002:a05:6830:4429:b0:7d7:ea6e:322b with SMTP id
 46e09a7af769-7e7844def8cmr6965247a34.0.1781556019264; Mon, 15 Jun 2026
 13:40:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612025125.1690253-1-axboe@kernel.dk> <20260612025125.1690253-5-axboe@kernel.dk>
 <CADUfDZqrbUyJR9yn8i+eVbVwEuvs7a4mR8kfXF_umnZ9RUAc6g@mail.gmail.com>
 <f230eccc-819e-4e64-954e-a25578888c94@kernel.dk> <CADUfDZq2gkcjsQxb_M82WnuFWjF5-kA3sa8wUAJoRL_84a91HA@mail.gmail.com>
 <9785f0a4-a85c-4f2f-9209-ab7da042d97a@kernel.dk> <CADUfDZotc7tRWiYoDGu4nGdG=AR5wmZDyw8C1-Kp5BhxL=ZEmA@mail.gmail.com>
 <d0f05189-6192-46ca-9caf-2c71c07ddc4c@kernel.dk> <553cba4a-b4b1-4a2f-a484-4ef1d10b0c90@kernel.dk>
In-Reply-To: <553cba4a-b4b1-4a2f-a484-4ef1d10b0c90@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 15 Jun 2026 13:40:08 -0700
X-Gm-Features: AVVi8CfZTl2xAwBuQ3AxwtAcTx4e-ry92TdwLW60BTJFkOJskT42By1HKYr2vSQ
Message-ID: <CADUfDZrKED1o-bEMF0hNN9R2q0Sq_OWWy8GhCwBw3w2fZJK_Bw@mail.gmail.com>
Subject: Re: [PATCH 4/6] io_uring: switch normal task_work to a mpscq
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13740-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:krisman@suse.de,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,kernel.dk:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 64710689F7F

On Mon, Jun 15, 2026 at 1:04=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 6/15/26 12:47 PM, Jens Axboe wrote:
> > On 6/15/26 12:33 PM, Caleb Sander Mateos wrote:
> >> On Sat, Jun 13, 2026 at 5:08?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> On 6/12/26 8:26 PM, Caleb Sander Mateos wrote:
> >>>> On Fri, Jun 12, 2026 at 12:37?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>
> >>>>> On 6/12/26 12:59 PM, Caleb Sander Mateos wrote:
> >>>>>>> @@ -236,10 +262,14 @@ void io_req_normal_work_add(struct io_kiocb=
 *req)
> >>>>>>>                 return;
> >>>>>>>         }
> >>>>>>>
> >>>>>>> +       /* task_work must only be added once */
> >>>>>>> +       if (test_and_set_bit(0, &tctx->tw_pending))
> >>>>>>> +               return;
> >>>>>>
> >>>>>> Is tw_pending necessary? How come the task_work_add() exclusivity
> >>>>>> isn't already provided by the mpscq_push() check above?
> >>>>>
> >>>>> It is, because the transition from empty -> not-empty no longer wor=
ks
> >>>>> for that, as the mpscq emtpies one-by-one rather than with a delete=
-all
> >>>>> kind of primitive.
> >>>>
> >>>> Sorry, I'm still not following why the empty check doesn't suffice.
> >>>> It's true that mpscq elements can be removed from the head one at a
> >>>> time, but mpscq_push() will continue to return false until the
> >>>> consumer pops all the elements and successfully sets tail back to
> >>>> &stub. mpscq_push() will return true once when tail transitions away
> >>>> from &stub, and then not again until the task work runs and sets tai=
l
> >>>> back to &stub.
> >>>
> >>> Let's say the task_work is currently running, a producer is adding mo=
re.
> >>> It finds queue empty, re-adds the task_work. That part is fine, we ca=
n
> >>> add the task_work while it's running as it has been detached already.
> >>> The task_work keeps running and also prunes this new item. Producer a=
dds
> >>> another one, finds the queue empty, re-adds task_work. This one is no=
t
> >>> OK, the task_work was already re-added when it previously found it
> >>> empty. Boom.
> >>
> >> Ah right, I forgot that mpscq_pop() can both return a popped node and
> >> set the tail back to &stub. Maybe it would make sense for it to return
> >> whether the queue has been marked empty and break out of
> >> tctx_task_work_run() in that case instead of relying on a separate
> >> call to mpscq_empty()? The atomic RMW for tw_pending every time the
> >> queue transitions between empty and non-empty seems like it could be
> >> quite expensive.
> >
> > We could tweak it like that. I didn't look too closely as this is the
> > !DEFER case and hence a lot less interesting, but if you want to send a
> > patch my way I'd be happy to stage it on top.
>
> I took a look, and yes I think it actually comes out nicer this way.
> Good suggestion! It also helps cap the number of task_work items run,
> which is a nice side effect. What do you think?

Yeah, looks nice! Thanks for doing this.

>
> Needs a commit message obviously.
>
> commit 572a1fb6d0f25b706ff044fcf141827f49db2ec0
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Mon Jun 15 13:43:16 2026 -0600
>
>     io_uring: get rid of tw_pending for !DEFER task work
>
>     Suggested-by: Caleb Sander Mateos <csander@purestorage.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 6415a3353ee0..87151a5b62c1 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -149,8 +149,6 @@ struct io_uring_task {
>
>         struct { /* task_work */
>                 struct mpscq            task_list;
> -               /* BIT(0) guards adding tw only once */
> -               unsigned long           tw_pending;
>                 struct callback_head    task_work;
>         } ____cacheline_aligned_in_smp;
>  };
> diff --git a/io_uring/mpscq.h b/io_uring/mpscq.h
> index c801384c6a0a..f910526766fd 100644
> --- a/io_uring/mpscq.h
> +++ b/io_uring/mpscq.h
> @@ -122,4 +122,13 @@ static inline struct llist_node *mpscq_pop(struct mp=
scq *q,
>         return NULL;
>  }
>
> +/*
> + * Returns true if the most recent mpscq_pop() that returned a node also
> + * emptied the queue. Consumer must be serialized.
> + */
> +static inline bool mpscq_pop_emptied(struct mpscq *q, struct llist_node =
*head)
> +{
> +       return head =3D=3D &q->stub;
> +}
> +
>  #endif /* IOU_MPSCQ_H */
> diff --git a/io_uring/tw.c b/io_uring/tw.c
> index e74372233f40..f2ce806b01a1 100644
> --- a/io_uring/tw.c
> +++ b/io_uring/tw.c
> @@ -34,10 +34,6 @@ void io_tctx_fallback_work(struct work_struct *work)
>                                                   fallback_work);
>         unsigned int count =3D 0;
>
> -       /* see tctx_task_work() - a set bit must always have a run coming=
 */
> -       clear_bit(0, &tctx->tw_pending);
> -       smp_mb__after_atomic();
> -
>         /*
>          * Run the entries directly. We're in PF_KTHRED context, hence
>          * io_should_terminate_tw() is true and they will be marked as
> @@ -101,6 +97,13 @@ void tctx_task_work_run(struct io_uring_task *tctx, u=
nsigned int max_entries,
>                                 io_poll_task_func, io_req_rw_complete,
>                                 (struct io_tw_req){req}, ts);
>                 (*count)++;
> +               /*
> +                * Break if most recent pop emptied the queue. This helps
> +                * bound task_work run, and also protects the regular
> +                * task_work addition.
> +                */
> +               if (mpscq_pop_emptied(&tctx->task_list, tctx->task_head))
> +                       break;

I think we can now remove the "if (mpscq_empty(&tctx->task_list))
break;" above? The queue must be nonempty initially, otherwise the
task work wouldn't have been scheduled. And if the queue is empty
after an attempted pop, the previous iteration of this loop must have
successfully marked the queue as empty.

Best,
Caleb

>                 if (unlikely(need_resched())) {
>                         ctx_flush_and_put(ctx, ts);
>                         ctx =3D NULL;
> @@ -127,8 +130,6 @@ void tctx_task_work(struct callback_head *cb)
>         unsigned int count =3D 0;
>
>         tctx =3D container_of(cb, struct io_uring_task, task_work);
> -       clear_bit(0, &tctx->tw_pending);
> -       smp_mb__after_atomic();
>         tctx_task_work_run(tctx, UINT_MAX, &count);
>  }
>
> @@ -206,7 +207,7 @@ void io_req_normal_work_add(struct io_kiocb *req)
>         struct io_uring_task *tctx =3D req->tctx;
>         struct io_ring_ctx *ctx =3D req->ctx;
>
> -       /* task_work already pending, we're done */
> +       /* tw run already pending, nothing else to do */
>         if (!mpscq_push(&tctx->task_list, &req->io_task_work.node))
>                 return;
>
> @@ -223,10 +224,6 @@ void io_req_normal_work_add(struct io_kiocb *req)
>                 return;
>         }
>
> -       /* task_work must only be added once */
> -       if (test_and_set_bit(0, &tctx->tw_pending))
> -               return;
> -
>         if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->noti=
fy_method)))
>                 return;
>
>
> --
> Jens Axboe

