Return-Path: <io-uring+bounces-13691-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id sZykHCR7K2p2+QMAu9opvQ
	(envelope-from <io-uring+bounces-13691-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 05:21:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C38D676695
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 05:21:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=IiirD3j1;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13691-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13691-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5F513300382E
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 03:21:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3B7D76025;
	Fri, 12 Jun 2026 03:21:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978561E531
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 03:20:59 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781234461; cv=pass; b=Hl4QSDqg9Ms+Tyr1sFQ2V2y5X67xJfQQl/4NYZAnHApW8xV60F/lMZiFKfxD9IukAJIj/U0lhlHL0ZEFtbLBl8BswcvN59GZ2Ge81HlaWZ+kSlOhTDejJrpzcY/rD0TV4CKQB2wYz/91rDnS7GhiaN+LBZVR89EreIJKBb9qUYs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781234461; c=relaxed/simple;
	bh=oL21cBBjEcd41r1WR8//j9PmYkC9xAWBkbohVGOQ1Jg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dvPvCXsv4sAVnkg809nkO+8aeC91AwY8Xs32kgpppMDpae2SxUol6KP76yQlDu/By92nqIYbiJpzIGuxqspGoH4/Vx7qZ2V9GI97i0ecDsaaPSjE9UJXlev6DIPvs6dKrCZ2td+B8Bq6PfgKWbGDif+Ircwt0ElR3HgU1yg+EZM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=IiirD3j1; arc=pass smtp.client-ip=209.85.167.181
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-48642132f13so16583b6e.3
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 20:20:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781234458; cv=none;
        d=google.com; s=arc-20240605;
        b=V8ekv0mL4m/Q168puEryhYqbvUiviuqjOdBBWMsAlPg0oSmnrFjzgA4hqSycGGy/JV
         WjBfWO3PXkerGoru4aiJHk6ZKy28l3GmnxFYbcXZG2rRmDBTE2ePLWPw0CRZEBfT8K/o
         UjKcqGKcDsT/7Kd4+s8FhbD9OVueqyt1QhkVQLurfmvKI+Pb5Zj7cJ3gb/W0bcnpDrWf
         zsx4NEZz5GLD3xgTc5k9yt/YC9pUYB/5ErUPEOFKBAk1olO6GTSMQh12I36GTx7Y4NyJ
         riYwScz/TUJMKCYtES+pgmkZbDE5N5dI3A7CV1jRreW5NALvkxQVjId9d0V6ba8XHiEZ
         vDQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x4NMpLeiu8gknG66/B6pGIjRLBfy+z/qUe59zRBjtIw=;
        fh=tcB1jbK5Mfh49jFaBDMFCl5E4RG50sbZDH32oaESUuc=;
        b=K/92LR0VueZCAuWwrkk/JCFhWXqzDQjw7W3PVGbbdlnDa8SQqv7QkxhpM7MkjCC23t
         b0gG+/tOcmw/L2BIcrJkSMV6m0nFdHxJGPhWlkaPJyiN0l1LYVWB5HnRwXgbMqUbDSt4
         Sbv2zXK2wPKCol0H/z+9nGhns+gsrYu34329gASo1JLbRb0U2nYnDShljAJdXa0Udsu5
         uJ/gy3ExCYE/bsSSHofrNhozQezzztyswrTgrJLQcFK/h0qF6Xc30ad0WYteW6DRO8jI
         g5q6tWCF5Z6O/4mtMERdKiOF8OVcdMAh+I0QDQxN66h/N/JQgCE5oIE5E5dshRn5lXX7
         nN8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781234458; x=1781839258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x4NMpLeiu8gknG66/B6pGIjRLBfy+z/qUe59zRBjtIw=;
        b=IiirD3j1d4hF4FY+or5JQ5CbZ8iaTEDrn3BMfKtq9w9gbyAO/JxsGLgmpQSCuWUJGk
         o6FCFFwajjpDxHbYFC4aw7Ysx/aohkdp0omzt6KPyrOUXO5B5tOpGIgIf6XgMdHj4IEm
         SF8zEgF0xfzIArNGYFAiPozYkF8inT6EYkLEKYqmcjRtYlHD89eXQxZhzgAsxwPDxkZA
         fNiMORb5bNDN16IPhO7d9Nlat8WdpSkzHvhrlkYEB8Gbqaqci/eev3LJmr0QaT2oNsax
         AGWM5sHuVnOtvP0ti8cAjRw0bjHr8+hHoU/2/TMmU61230Wkwxk29yJoogmHaYmrvoxH
         csyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781234458; x=1781839258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x4NMpLeiu8gknG66/B6pGIjRLBfy+z/qUe59zRBjtIw=;
        b=VBc/2MaijiyytrEOpq6QcXZ6DOYmm5A7RqeLDB7yrvo0/RYHevOAFljouLxOORS1d3
         RV5i0Ga/iUj4hzB50sYsTfQqnu2LGpjz/L31/VBd7b2T5CtmoRXiRj4AKa59oQ2Z1/CD
         UlCeXMMLMcyt5kp3flMAh1iOh5NgV+TbFr3btJTz7b8HQ8z7C+4k7ntjdYPOXlZiLyf9
         cnUOB8kkWMp9AKzN6/nZb5dXyMDlh/p4ZA0Bci665C5taodAeHuBuwSz8yfx9Tae0ngR
         o9zhHOZm4oY3YN+o0Fsj9m5e4sZ+UH4RmOnP+slvuOWS5I46pSyawN6Q1F0qNTT7DBol
         87jQ==
X-Gm-Message-State: AOJu0YyZ1P02MNtFfx7UkY6GOKlpm/oC/DyKx99kINHxHMF+a3aShZAi
	pIcZ/KQm0rsK1OvvaOXS6GLpm89/VkaQxd/fLmcwiCs5i5F8MvioLCW2jpVSF4pKGmUKfU9tGl3
	dum2/TAuFJDZyVQmwZ10VlGbn9f94qp5o9R/72QWUAw==
X-Gm-Gg: Acq92OHQIm2fcEIsMlIF15snGmbvKQFd/9mnvyjCLgG73kd+TzZhvvrGRto/JErEMUH
	zIwPQKOcaS91GM4WDbuLOTEHHrN+wnBRg1XXDWMeiPOuljNx7wYOsGMk1/FXOa23zRl/MUVICsN
	DMBXAlZwaRQr4g9MaDdd0wWp9lxyGUqvYgdt/gjHj2XgqKI92ccZqd8zRbnIU0MKNQhmPFAWCIb
	uD+4hTVGovr8uJhNV8Dup+X1C8mpCLrnuKBL/VpEQh3/ygx2mor4tSpaivT1cr9jSTZbfXZwqd5
	DwS9gJEf
X-Received: by 2002:a05:6808:1b2a:b0:485:5f33:92a9 with SMTP id
 5614622812f47-4872f573b37mr432681b6e.8.1781234458228; Thu, 11 Jun 2026
 20:20:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612025125.1690253-1-axboe@kernel.dk> <20260612025125.1690253-4-axboe@kernel.dk>
In-Reply-To: <20260612025125.1690253-4-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 11 Jun 2026 20:20:47 -0700
X-Gm-Features: AVVi8CdEF7kPykBPIG9O90-egSq6oxXAvLDPLoEnoTHl8trx5W8XPfNQOzKMUA8
Message-ID: <CADUfDZrTmc_yBU0o_wMwAKZNcEDaFvKxFxzbzg78=OLU114JiA@mail.gmail.com>
Subject: Re: [PATCH 3/6] io_uring: switch local task_work to a mpscq
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13691-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,mail.gmail.com:mid,purestorage.com:dkim,purestorage.com:from_mime,kernel.dk:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 5C38D676695

On Thu, Jun 11, 2026 at 7:51=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
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
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |  13 +++-
>  io_uring/io_uring.c            |   2 +-
>  io_uring/tw.c                  | 135 ++++++++++++++-------------------
>  io_uring/tw.h                  |   4 +-
>  io_uring/wait.c                |   2 +-
>  io_uring/wait.h                |  10 ++-
>  6 files changed, 78 insertions(+), 88 deletions(-)
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 85e12b4884a5..9df5584ec3b1 100644
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

Looks like this field has padding both before (next to atomic_t) and
after (next to bool). Probably doesn't matter currently, as the outer
struct is cache-aligned and has 16 bytes of padding at the end, but
could save 8 bytes of padding by reordering next to an existing
8-byte-aligned field.

> +
>                 /*
>                  * ->iopoll_list is protected by the ctx->uring_lock for
>                  * io_uring instances that don't use IORING_SETUP_SQPOLL.
> @@ -417,8 +425,7 @@ struct io_ring_ctx {
>          */
>         struct {
>                 struct io_rings __rcu   *rings_rcu;
> -               struct llist_head       work_llist;
> -               struct llist_head       retry_llist;
> +               struct mpscq            work_list;
>                 unsigned long           check_cq;
>                 atomic_t                cq_wait_nr;
>                 atomic_t                cq_timeouts;
> @@ -742,8 +749,6 @@ struct io_kiocb {
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
> diff --git a/io_uring/tw.c b/io_uring/tw.c
> index f4335c8d50d9..b8d6027aaeff 100644
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
> @@ -170,11 +171,7 @@ static void io_ctx_mark_taskrun(struct io_ring_ctx *=
ctx)
>  void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
>  {
>         struct io_ring_ctx *ctx =3D req->ctx;
> -       unsigned nr_wait, nr_tw, nr_tw_prev;
> -       struct llist_node *head;
> -
> -       /* See comment above IO_CQ_WAKE_INIT */
> -       BUILD_BUG_ON(IO_CQ_WAKE_FORCE <=3D IORING_MAX_CQ_ENTRIES);
> +       int nr_wait;
>
>         /*
>          * We don't know how many requests there are in the link and whet=
her
> @@ -183,56 +180,37 @@ void io_req_local_work_add(struct io_kiocb *req, un=
signed flags)
>         if (req->flags & IO_REQ_LINK_FLAGS)
>                 flags &=3D ~IOU_F_TWQ_LAZY_WAKE;
>
> -       guard(rcu)();
> -
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
> -
> -       if (!head) {
> +       if (mpscq_push(&ctx->work_list, &req->io_task_work.node)) {
>                 io_ctx_mark_taskrun(ctx);
>                 if (data_race(ctx->int_flags) & IO_RING_F_HAS_EVFD)
>                         io_eventfd_signal(ctx, false);
>         }
>
> +       /*
> +        * No one is waiting (IO_CQ_WAKE_INIT), or this cycle's wake up h=
as
> +        * already been issued (zero or negative, see below).
> +        */
>         nr_wait =3D atomic_read(&ctx->cq_wait_nr);
> -       /* not enough or no one is waiting */
> -       if (nr_tw < nr_wait)
> +       if (nr_wait <=3D 0)
>                 return;
> -       /* the previous add has already woken it up */
> -       if (nr_tw_prev >=3D nr_wait)
> +       if (flags & IOU_F_TWQ_LAZY_WAKE) {
> +               /*
> +                * ->cq_wait_nr counts down the number of lazy adds, once=
 it
> +                * hits zero we're good to wake the waiter.
> +                */
> +               if (!atomic_dec_and_test(&ctx->cq_wait_nr))
> +                       return;

It's possible that another task work wakes up the task before this one
reaches the atomic_dec_and_test(), right? If the submitter task begins
a new wait in between, this could decrement cq_wait_nr even though the
queued task work has already been processed after the previous wakeup.
I guess that's okay; in the worse case, the waiter will be woken
prematurely.

> +       } else if (!atomic_try_cmpxchg(&ctx->cq_wait_nr, &nr_wait, IO_CQ_=
WAKE_INIT)) {
> +               /* lost the race against another wake up, this one is cov=
ered */
>                 return;
> +       }
>         wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
>  }
>
> @@ -273,21 +251,27 @@ void io_req_task_work_add_remote(struct io_kiocb *r=
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
> @@ -302,22 +286,23 @@ static bool io_run_local_work_continue(struct io_ri=
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
> @@ -326,7 +311,6 @@ static int __io_run_local_work_loop(struct llist_node=
 **node,
>  static int __io_run_local_work(struct io_ring_ctx *ctx, io_tw_token_t tw=
,
>                                int min_events, int max_events)
>  {
> -       struct llist_node *node;
>         unsigned int loops =3D 0;
>         int ret =3D 0;
>
> @@ -335,24 +319,21 @@ static int __io_run_local_work(struct io_ring_ctx *=
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
> index ec01e78a216d..c5fc34d2ce97 100644
> --- a/io_uring/wait.c
> +++ b/io_uring/wait.c
> @@ -98,7 +98,7 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(=
struct hrtimer *timer)
>         if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
>                 atomic_set(&ctx->cq_wait_nr, 1);
>                 smp_mb();
> -               if (!llist_empty(&ctx->work_llist))
> +               if (io_local_work_pending(ctx))
>                         goto out_wake;
>         }
>
> diff --git a/io_uring/wait.h b/io_uring/wait.h
> index a4274b137f81..6d494297e1ce 100644
> --- a/io_uring/wait.h
> +++ b/io_uring/wait.h
> @@ -5,12 +5,14 @@
>  #include <linux/io_uring_types.h>
>
>  /*
> - * No waiters. It's larger than any valid value of the tw counter
> - * so that tests against ->cq_wait_nr would fail and skip wake_up().
> + * ->cq_wait_nr is armed with the number of lazy task_work adds the wait=
er
> + * still needs, and counted down by the add side, with the add reaching =
zero
> + * issuing the (single) wake up for this wait cycle. Zero and below mean=
s no
> + * wake up is to be issued: IO_CQ_WAKE_INIT when no task is waiting (als=
o
> + * what a forced wake up resets it to when claiming one), zero once the
> + * countdown has fired.
>   */
>  #define IO_CQ_WAKE_INIT                (-1U)

Since cq_wait_nr is now used as a signed value, would it make sense to
drop the U here?

Best,
Caleb

> -/* Forced wake up if there is a waiter regardless of ->cq_wait_nr */
> -#define IO_CQ_WAKE_FORCE       (IO_CQ_WAKE_INIT >> 1)
>
>  struct ext_arg {
>         size_t argsz;
> --
> 2.53.0
>

