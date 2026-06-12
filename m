Return-Path: <io-uring+bounces-13680-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id RuXvMJVdK2pt8AMAu9opvQ
	(envelope-from <io-uring+bounces-13680-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 03:15:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CE4567611D
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 03:15:01 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=FqKZwpAR;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13680-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13680-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4E6A230DC156
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 01:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97A4F1DF27D;
	Fri, 12 Jun 2026 01:14:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AB0E3016EB
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 01:14:55 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781226899; cv=pass; b=PRAxj0Nqn8jBAftCR7P6IUP3aT4jiOaCOIWwkjZFTKTifOTs9d9u5pT3OQEYh9kF4fUwJWCZ/DdFV0CTrlpsZD4s3GAVhu0teMqwHj/17cmNtBBNYOR/HLVyBv0Lr5FKbEeMw7sed3ykW2Y6bWmKa8aW9drTBpF/KFl5X4igBik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781226899; c=relaxed/simple;
	bh=prqi40CjQ+edsnKufQgtKNb4HZ0IHsGh/8NkQJpErSw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h5EskmRq6JLkuLxCSKPWM5LQ1MpObiDrSF1OFnuOJS/OJDEEm9ZqExTEwSE8hyfuHVfTYpQ56Oc8BPrMl8/1FmRZZaADaUXQShfOGkSHInUAQGpgWo6PDL0LuQxzzd8CXUj6zK9UcD3m6KFg8ivXmNXlRymtzg0YphO7nya2V6Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=FqKZwpAR; arc=pass smtp.client-ip=209.85.210.42
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e6f4728b8dso66480a34.3
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 18:14:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781226895; cv=none;
        d=google.com; s=arc-20240605;
        b=MBMaS/in6r12q8DdCnEZ+8SJgHAXNk9jPEpTPHSZO3OVT8CXq+fypoRL5d9WBVvCgX
         6N7OE6GmP91iVc0GqvrhDT7aIzwFHAecukkVJn5mSA6JURXKH4yg/RRh6JRm39fuj7ce
         0jfvlfBC17DjQxtuJBVN+E1k/XCaAZpjEK0lhW83G0yjId/lbMmCWSblJFVDEfS4oWYY
         6td2tIIW+Zr2UDUP4kWI/MID0iE3jaq7qo+2dbv0bxOAstvb0o7UlqvZ1jLAbX4P1H9+
         qQHz2ZidQenUbWf8PjrkloeN26IaA3okWT5aN/7wrpmuMQo3v9JCBI7FiOd4lFneLalr
         EQ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vhZtbgROslsAmvPeTpCggXwIFNAcgF//PW3iYlrcaKQ=;
        fh=8SanVj4MV0LZcXSROTGCY35wrAI3fk+fJGDl/3jrlWo=;
        b=bohrT+8Lu6NdUk5kTXqkfqqiNEgEUFZbiDxKTIVwW7WG+CWUOI+HRrXh4XjOJ/dqtR
         7q7C3tY1oSN+v5eC2an2n6tpFx+mTqTjRDAPgE6oz3x9cCPZB+KqWKMLZL3DlmtRtiEW
         NOZNLN2JkSFQvpE67+TMw8okrdOp29kUhq0f59XMihlqiBwWWci/VZrhVHll1HJ1bu16
         zyIXMhV//OUOqGCt+2YyKH9lnse6awuAYDROsC+/cElieszoYxgmm0BaoF/j47PBpiVh
         Mzuecl4z484hkvkVZbybHkQHkwaTnSONfhtTzyuYMfV85rIGmV4cBPkIq7j69yU87wka
         zbAA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781226895; x=1781831695; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhZtbgROslsAmvPeTpCggXwIFNAcgF//PW3iYlrcaKQ=;
        b=FqKZwpARSK8k+DrSEMr5yAu6eeDVq/OQ6va8eDlG0yVKyDEJUs8Uak0g5eai7u2rWp
         fhQAHzWRuBCzp8T8YTnisGhGPb/5Doi2nEj8hEQ/c5sqY/cx9jx5gB7gEeaQB2+UGjtW
         WKeWsCBweANhsoXZjcKfQip9oWNb0UAOyTTp2ahoHEDvwUx+uaCxvnqwhzOPFsVc2ZHf
         KiILFlbiTuY8w9teTPhA45hJONNtm6+sfTRF4O5Tp//uuwYCFbB4TrkCi9kMeGph47y9
         wZJ1GIIs6tJoTfcfIFAGWALdK/I73cdnWOYpiF4PUz/XOCRuHLtvVhRFEgjm1CRKp98X
         kGSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781226895; x=1781831695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vhZtbgROslsAmvPeTpCggXwIFNAcgF//PW3iYlrcaKQ=;
        b=T48+w28qi6/+iaKxBDq4T5LwUczlyjkx/2lrsSmdMKVxXRw7JVn9s4WfhOj4sCd62a
         T7sLzmem4lltdKHZeS/2qoYZzVSGRdJBbvlgnlHMO18l/DwKSF/KzGqdEZ5QPZB4WPgn
         thGF9ZD7E9X4KOxfn01np1XkuajiWRChl2lkgpeUgVHPZBerzQMmOrRZ5hafg0TBwbgf
         NvPOBmydujWlsYvRdhx1Yo2p/j95zftNGe9fC/fRxTYd7pOl81HqC8GlXhiQa0KqNUp3
         +8bWZ8oBVdwt9v3KIkghrCYeV2BZFRKQ2q4eoZ6iR9odvqdlYZbIlHAlXuI44N7tYZ1a
         PoAA==
X-Gm-Message-State: AOJu0YwnKDTpFphyTm2VQQwIpGD+OqHIZ87LjMLtZgFysQuq5u7GnX5h
	l3UfDSwIFkB6gwz8oBYZ0FLzah93ptT9grLQTWs9eI3OZOScx68wdoECgjYdDwhJNqJi7vz/u5c
	qGfPXa7r3/6Xucmn0jNp4Xe0nnYOJPBcROmg8fe8Vw8FUbqnzKOlSZII=
X-Gm-Gg: Acq92OEXLCCPCDIPl9d8fahEu8PdfCV8g3Cf+Uv4ABim/ozQe8gjp149H2Kei4LMtcg
	lRx1TGwg41srSVuk8F3XdstndunkCn3FCgxusheHjPkUlvgtvIr3vkdDeGiiCaXuayzvpCMHCUS
	4GaEqFJ3m7N913dLGlKQx6Nnyi8RZYK6EODXVc7s2oQJLJfRpmjrYGk7bs0rUoqrt3HHFBRSbva
	3pulHzjaHI99Ih5GwoE4wMc0+k/Voc6ud7EbzmhePvFOeXDB1rxCR13aQCZK4gUrvPJTiOwnApJ
	JTxS9eDp
X-Received: by 2002:a05:6808:1920:b0:486:39db:ebf1 with SMTP id
 5614622812f47-4872f57225emr298063b6e.7.1781226894753; Thu, 11 Jun 2026
 18:14:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260611160553.1486640-1-axboe@kernel.dk> <20260611160553.1486640-3-axboe@kernel.dk>
In-Reply-To: <20260611160553.1486640-3-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 11 Jun 2026 18:14:43 -0700
X-Gm-Features: AVVi8CeNtr9RAFoJErStFG3MoWAji5an2jfOJjd5kVCXLQtvWHF1vsxm5v6Idq4
Message-ID: <CADUfDZrzwvY6UpBBhLj1JynuNf5bo140+LbMYDOvU13=od+nkQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] io_uring: switch local task_work to a mpscq
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13680-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:dvyukov@google.com,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,vger.kernel.org:from_smtp,tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 4CE4567611D

On Thu, Jun 11, 2026 at 9:12=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> The local (DEFER_TASKRUN) task_work list is an llist, which is LIFO
> ordered, and hence __io_run_local_work() has to restore the right
> running order with an O(n) llist_reverse_order() pass first. On top of
> that, a batch that gets capped by max_events needs the leftover entries
> parked on a separate ->retry_llist, as they can't be pushed back to the
> shared list.
>
> Switch it to the FIFO mpscq. Adds are wait-free instead of a cmpxchg
> retry loop, entries are popped in queue order with no reversal pass,
> capping a run simply leaves the remainder on the queue, and
> ->retry_llist goes away entirely. The consumer cursor, ->work_head,
> lives with the rest of the ->uring_lock protected state rather than
> next to the queue, so that popping entries doesn't dirty the producer
> side cacheline.
>
> For low amounts of task_work, this ends up being a bit more efficient
> than the existing scheme. As an example of that, doing multishot
> receives for 8 clients has the following task_work overhead:
>
>      1.02%  sock-test  [kernel.kallsyms]  [k] io_req_local_work_add
>      0.88%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work_loop
>      0.60%  sock-test  [kernel.kallsyms]  [k] llist_reverse_order
>      0.14%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work
>      2.64% at ~46Gb/sec
>
> and after this change:
>
>      1.08%  sock-test  [kernel.kallsyms]  [k] io_req_local_work_add
>      1.03%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work
>      2.11% at ~53Gb/sec
>
> which has less overhead even though that test run was faster. For a case
> of having 1024 clients on a single ring:
>
>      2.22%  sock-test  [kernel.kallsyms]  [k] llist_reverse_order
>      0.84%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work_loop
>      0.42%  sock-test  [kernel.kallsyms]  [k] io_req_local_work_add
>      0.02%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work
>      3.50% at ~24Gb/sec
>
> we start to see the llist reversing taking a considerable amount of
> time, and the total add+run task_work overhead is around 3.5%. After
> the change:
>
>      0.90%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work
>      0.42%  sock-test  [kernel.kallsyms]  [k] io_req_local_work_add
>      1.32% at ~26Gb/sec
>
> most of that overhead is gone, and performance is better as well.

This is great stuff! I had also observed these hotspots on a ublk
workload. Since incoming ublk requests post task work to the ublk
server's io_urings and completed ublk requests post task work to the
client's io_urings, there is significant cross-CPU contention on the
task work queues.

>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |  14 +++-
>  io_uring/io_uring.c            |   2 +-
>  io_uring/loop.c                |   2 +-
>  io_uring/tw.c                  | 145 ++++++++++++++++-----------------
>  io_uring/tw.h                  |   4 +-
>  io_uring/wait.c                |   8 +-
>  io_uring/wait.h                |  20 ++++-
>  7 files changed, 106 insertions(+), 89 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 85e12b4884a5..e918301da5fc 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -351,6 +351,14 @@ struct io_ring_ctx {
>                  */
>                 atomic_t                cancel_seq;
>
> +               /*
> +                * Consumer cursor for ->work_list, protected by ->uring_=
lock.
> +                * Deliberately kept away from the producer side of the q=
ueue,
> +                * as it's written for every popped entry, and the produc=
er
> +                * cacheline is contended enough as it is.
> +                */
> +               struct llist_node       *work_head;
> +
>                 /*
>                  * ->iopoll_list is protected by the ctx->uring_lock for
>                  * io_uring instances that don't use IORING_SETUP_SQPOLL.
> @@ -417,10 +425,10 @@ struct io_ring_ctx {
>          */
>         struct {
>                 struct io_rings __rcu   *rings_rcu;
> -               struct llist_head       work_llist;
> -               struct llist_head       retry_llist;
> +               struct mpscq            work_list;
>                 unsigned long           check_cq;
>                 atomic_t                cq_wait_nr;
> +               atomic_t                cq_wait_added;
>                 atomic_t                cq_timeouts;
>                 struct wait_queue_head  cq_wait;
>         } ____cacheline_aligned_in_smp;
> @@ -742,8 +750,6 @@ struct io_kiocb {
>          */
>         u16                             buf_index;
>
> -       unsigned                        nr_tw;
> -
>         /* REQ_F_* flags */
>         io_req_flags_t                  flags;
>
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 753ac23401c5..16acd99ff083 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -280,7 +280,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(s=
truct io_uring_params *p)
>         INIT_LIST_HEAD(&ctx->defer_list);
>         INIT_LIST_HEAD(&ctx->timeout_list);
>         INIT_LIST_HEAD(&ctx->ltimeout_list);
> -       init_llist_head(&ctx->work_llist);
> +       mpscq_init(&ctx->work_list, &ctx->work_head);
>         INIT_LIST_HEAD(&ctx->tctx_list);
>         mutex_init(&ctx->tctx_lock);
>         ctx->submit_state.free_list.next =3D NULL;
> diff --git a/io_uring/loop.c b/io_uring/loop.c
> index bbbb6ef14e6a..2ecc1cf49f84 100644
> --- a/io_uring/loop.c
> +++ b/io_uring/loop.c
> @@ -11,7 +11,7 @@ static inline int io_loop_nr_cqes(const struct io_ring_=
ctx *ctx,
>
>  static inline void io_loop_wait_start(struct io_ring_ctx *ctx, unsigned =
nr_wait)
>  {
> -       atomic_set(&ctx->cq_wait_nr, nr_wait);
> +       io_cq_wait_arm(ctx, nr_wait);
>         set_current_state(TASK_INTERRUPTIBLE);
>  }
>
> diff --git a/io_uring/tw.c b/io_uring/tw.c
> index 023d5e6bc491..4cf350cffb6c 100644
> --- a/io_uring/tw.c
> +++ b/io_uring/tw.c
> @@ -14,6 +14,7 @@
>  #include "rw.h"
>  #include "eventfd.h"
>  #include "wait.h"
> +#include "mpscq.h"
>
>  void io_fallback_req_func(struct work_struct *work)
>  {
> @@ -170,11 +171,8 @@ static void io_ctx_mark_taskrun(struct io_ring_ctx *=
ctx)
>  void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>  {
>         struct io_ring_ctx *ctx =3D req->ctx;
> -       unsigned nr_wait, nr_tw, nr_tw_prev;
> -       struct llist_node *head;
> -
> -       /* See comment above IO_CQ_WAKE_INIT */
> -       BUILD_BUG_ON(IO_CQ_WAKE_FORCE <=3D IORING_MAX_CQ_ENTRIES);
> +       struct llist_node *prev;
> +       unsigned nr_wait;
>
>         /*
>          * We don't know how many requests there are in the link and whet=
her
> @@ -185,55 +183,47 @@ void io_req_local_work_add(struct io_kiocb *req, un=
signed flags)
>
>         guard(rcu)();

Is the RCU guard still required now that a work list element can't be
accessed after the consumer has popped it?

Best,
Caleb


>
> -       head =3D READ_ONCE(ctx->work_llist.first);
> -       do {
> -               nr_tw_prev =3D 0;
> -               if (head) {
> -                       struct io_kiocb *first_req =3D container_of(head,
> -                                                       struct io_kiocb,
> -                                                       io_task_work.node=
);
> -                       /*
> -                        * Might be executed at any moment, rely on
> -                        * SLAB_TYPESAFE_BY_RCU to keep it alive.
> -                        */
> -                       nr_tw_prev =3D READ_ONCE(first_req->nr_tw);
> -               }
> -
> -               /*
> -                * Theoretically, it can overflow, but that's fine as one=
 of
> -                * previous adds should've tried to wake the task.
> -                */
> -               nr_tw =3D nr_tw_prev + 1;
> -               if (!(flags & IOU_F_TWQ_LAZY_WAKE))
> -                       nr_tw =3D IO_CQ_WAKE_FORCE;
> -
> -               req->nr_tw =3D nr_tw;
> -               req->io_task_work.node.next =3D head;
> -       } while (!try_cmpxchg(&ctx->work_llist.first, &head,
> -                             &req->io_task_work.node));
> -
>         /*
> -        * cmpxchg implies a full barrier, which pairs with the barrier
> -        * in set_current_state() on the io_cqring_wait() side. It's used
> -        * to ensure that either we see updated ->cq_wait_nr, or waiters
> -        * going to sleep will observe the work added to the list, which
> -        * is similar to the wait/wawke task state sync.
> +        * The xchg() in mpscq_push() implies a full barrier, which pairs=
 with
> +        * the barrier in set_current_state() on the io_cqring_wait() sid=
e. This
> +        * ensures that either we see the updated ->cq_wait_nr, or waiter=
s going
> +        * to sleep will observe the work added to the list, which is sim=
ilar to
> +        * the wait/wake task state sync.
>          */
> +       prev =3D mpscq_push(&ctx->work_list, &req->io_task_work.node);
>
> -       if (!head) {
> +       if (prev =3D=3D &ctx->work_list.stub) {
>                 io_ctx_mark_taskrun(ctx);
>                 if (data_race(ctx->int_flags) & IO_RING_F_HAS_EVFD)
>                         io_eventfd_signal(ctx, false);
>         }
>
> -       nr_wait =3D atomic_read(&ctx->cq_wait_nr);
> -       /* not enough or no one is waiting */
> -       if (nr_tw < nr_wait)
> +       /* acquire pairs with the release in io_cq_wait_arm() */
> +       nr_wait =3D atomic_read_acquire(&ctx->cq_wait_nr);
> +       /* no one is waiting */
> +       if (nr_wait =3D=3D IO_CQ_WAKE_INIT)
>                 return;
> -       /* the previous add has already woken it up */
> -       if (nr_tw_prev >=3D nr_wait)
> +       /*
> +        * For a lazy wake, defer waking the task until enough work is pe=
nding
> +        * to satisfy the number of events it's waiting for. As a waiter =
only
> +        * sleeps on an empty queue, the lazy adds counted since it armed
> +        * ->cq_wait_nr are the full pending count, see io_cq_wait_arm().=
 If we
> +        * instead saw a stale, unarmed (or previous cycle) ->cq_wait_nr,=
 then
> +        * per the barrier pairing above, the waiter's check after arming=
 will
> +        * see our work and abort the sleep - no wakeup is needed from he=
re in
> +        * that case.
> +        */
> +       if ((flags & IOU_F_TWQ_LAZY_WAKE) &&
> +           atomic_inc_return(&ctx->cq_wait_added) < nr_wait)
>                 return;
> -       wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
> +       /*
> +        * Only one wake up is needed per arming of the wait. Claim it by
> +        * resetting ->cq_wait_nr - the waiter re-arms it for every wait =
cycle
> +        * and checks for pending work after arming, so a wakeup cannot g=
et
> +        * lost.
> +        */
> +       if (atomic_try_cmpxchg(&ctx->cq_wait_nr, &nr_wait, IO_CQ_WAKE_INI=
T))
> +               wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
>  }
>
>  void io_req_normal_work_add(struct io_kiocb *req)
> @@ -273,21 +263,27 @@ void io_req_task_work_add_remote(struct io_kiocb *r=
eq, unsigned flags)
>
>  void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
>  {
> -       struct llist_node *node;
> +       struct llist_node *node, *first =3D NULL, **tail =3D &first;
>
>         /*
> -        * Running the work items may utilize ->retry_llist as a means
> -        * for capping the number of task_work entries run at the same
> -        * time. But that list can potentially race with moving the work
> -        * from here, if the task is exiting. As any normal task_work
> -        * running holds ->uring_lock already, just guard this slow path
> -        * with ->uring_lock to avoid racing on ->retry_llist.
> +        * The work list consumer side is serialized by ->uring_lock, see
> +        * __io_run_local_work(). Grab it to guard against racing with no=
rmal
> +        * task_work running, as the task may be exiting.
>          */
>         guard(mutex)(&ctx->uring_lock);
> -       node =3D llist_del_all(&ctx->work_llist);
> -       __io_fallback_tw(node, false);
> -       node =3D llist_del_all(&ctx->retry_llist);
> -       __io_fallback_tw(node, false);
> +
> +       while (!mpscq_empty(&ctx->work_list)) {
> +               node =3D mpscq_pop(&ctx->work_list, &ctx->work_head);
> +               if (!node) {
> +                       /* a producer is mid-push, wait for it to link */
> +                       cpu_relax();
> +                       continue;
> +               }
> +               *tail =3D node;
> +               tail =3D &node->next;
> +       }
> +       *tail =3D NULL;
> +       __io_fallback_tw(first, false);
>  }
>
>  static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int even=
ts,
> @@ -302,22 +298,23 @@ static bool io_run_local_work_continue(struct io_ri=
ng_ctx *ctx, int events,
>         return false;
>  }
>
> -static int __io_run_local_work_loop(struct llist_node **node,
> +static int __io_run_local_work_loop(struct io_ring_ctx *ctx,
>                                     io_tw_token_t tw,
>                                     int events)
>  {
>         int ret =3D 0;
>
> -       while (*node) {
> -               struct llist_node *next =3D (*node)->next;
> -               struct io_kiocb *req =3D container_of(*node, struct io_ki=
ocb,
> -                                                   io_task_work.node);
> +       while (ret < events) {
> +               struct llist_node *node =3D mpscq_pop(&ctx->work_list, &c=
tx->work_head);
> +               struct io_kiocb *req;
> +
> +               if (!node)
> +                       break;
> +               req =3D container_of(node, struct io_kiocb, io_task_work.=
node);
>                 INDIRECT_CALL_2(req->io_task_work.func,
>                                 io_poll_task_func, io_req_rw_complete,
>                                 (struct io_tw_req){req}, tw);
> -               *node =3D next;
> -               if (++ret >=3D events)
> -                       break;
> +               ret++;
>         }
>
>         return ret;
> @@ -326,7 +323,6 @@ static int __io_run_local_work_loop(struct llist_node=
 **node,
>  static int __io_run_local_work(struct io_ring_ctx *ctx, io_tw_token_t tw=
,
>                                int min_events, int max_events)
>  {
> -       struct llist_node *node;
>         unsigned int loops =3D 0;
>         int ret =3D 0;
>
> @@ -335,24 +331,21 @@ static int __io_run_local_work(struct io_ring_ctx *=
ctx, io_tw_token_t tw,
>         if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
>                 atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
>  again:
> -       tw.cancel =3D io_should_terminate_tw(ctx);
> -       min_events -=3D ret;
> -       ret =3D __io_run_local_work_loop(&ctx->retry_llist.first, tw, max=
_events);
> -       if (ctx->retry_llist.first)
> -               goto retry_done;
> -
>         /*
> -        * llists are in reverse order, flip it back the right way before
> -        * running the pending items.
> +        * If the last loop made no progress while work is still pending,
> +        * a producer has published a node but hasn't linked it into the
> +        * queue yet (see mpscq_pop()). Give it a chance to finish rather
> +        * than spinning on the queue.
>          */
> -       node =3D llist_reverse_order(llist_del_all(&ctx->work_llist));
> -       ret +=3D __io_run_local_work_loop(&node, tw, max_events - ret);
> -       ctx->retry_llist.first =3D node;
> +       if (unlikely(loops && !ret))
> +               cond_resched();
> +       tw.cancel =3D io_should_terminate_tw(ctx);
> +       min_events -=3D ret;
> +       ret =3D __io_run_local_work_loop(ctx, tw, max_events);
>         loops++;
>
>         if (io_run_local_work_continue(ctx, ret, min_events))
>                 goto again;
> -retry_done:
>         io_submit_flush_completions(ctx);
>         if (io_run_local_work_continue(ctx, ret, min_events))
>                 goto again;
> diff --git a/io_uring/tw.h b/io_uring/tw.h
> index 415e330fabde..f42db5fdbded 100644
> --- a/io_uring/tw.h
> +++ b/io_uring/tw.h
> @@ -6,6 +6,8 @@
>  #include <linux/percpu-refcount.h>
>  #include <linux/io_uring_types.h>
>
> +#include "mpscq.h"
> +
>  #define IO_LOCAL_TW_DEFAULT_MAX                20
>
>  /*
> @@ -89,7 +91,7 @@ static inline int io_run_task_work(void)
>
>  static inline bool io_local_work_pending(struct io_ring_ctx *ctx)
>  {
> -       return !llist_empty(&ctx->work_llist) || !llist_empty(&ctx->retry=
_llist);
> +       return !mpscq_empty(&ctx->work_list);
>  }
>
>  static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
> diff --git a/io_uring/wait.c b/io_uring/wait.c
> index ec01e78a216d..05ac779635e8 100644
> --- a/io_uring/wait.c
> +++ b/io_uring/wait.c
> @@ -96,9 +96,13 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup=
(struct hrtimer *timer)
>          * the task and return.
>          */
>         if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> +               /*
> +                * No need to zero ->cq_wait_added when arming with 1, an=
y
> +                * counted add will satisfy it.
> +                */
>                 atomic_set(&ctx->cq_wait_nr, 1);
>                 smp_mb();
> -               if (!llist_empty(&ctx->work_llist))
> +               if (io_local_work_pending(ctx))
>                         goto out_wake;
>         }
>
> @@ -257,7 +261,7 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_e=
vents, u32 flags,
>                 unsigned long check_cq;
>
>                 if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> -                       atomic_set(&ctx->cq_wait_nr, nr_wait);
> +                       io_cq_wait_arm(ctx, nr_wait);
>                         set_current_state(TASK_INTERRUPTIBLE);
>                 } else {
>                         prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq=
,
> diff --git a/io_uring/wait.h b/io_uring/wait.h
> index a4274b137f81..2ecea3e2a63f 100644
> --- a/io_uring/wait.h
> +++ b/io_uring/wait.h
> @@ -5,12 +5,24 @@
>  #include <linux/io_uring_types.h>
>
>  /*
> - * No waiters. It's larger than any valid value of the tw counter
> - * so that tests against ->cq_wait_nr would fail and skip wake_up().
> + * No waiters. ->cq_wait_nr holds this when no task is waiting, and is
> + * reset back to it by the task work add side when it claims a wake up,
> + * so that only one wake up is issued per arming of the wait.
>   */
>  #define IO_CQ_WAKE_INIT                (-1U)
> -/* Forced wake up if there is a waiter regardless of ->cq_wait_nr */
> -#define IO_CQ_WAKE_FORCE       (IO_CQ_WAKE_INIT >> 1)
> +
> +/*
> + * A waiter only sleeps on an empty work list (it checks for pending wor=
k after
> + * arming), hence the number of lazy adds since arming is the full pendi=
ng
> + * count. The release pairs with the acquire in io_req_local_work_add(),=
 hence
> + * a producer observing the armed ->cq_wait_nr also observes the zeroed
> + * ->cq_wait_added.
> + */
> +static inline void io_cq_wait_arm(struct io_ring_ctx *ctx, int nr_wait)
> +{
> +       atomic_set(&ctx->cq_wait_added, 0);
> +       atomic_set_release(&ctx->cq_wait_nr, nr_wait);
> +}
>
>  struct ext_arg {
>         size_t argsz;
> --
> 2.53.0
>
>

