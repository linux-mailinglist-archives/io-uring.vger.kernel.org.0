Return-Path: <io-uring+bounces-13679-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id j3YRMWddK2pY8AMAu9opvQ
	(envelope-from <io-uring+bounces-13679-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 03:14:15 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3679767610E
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 03:14:15 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b="Qp1Uq/n3";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13679-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13679-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3E31730DAE97
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 01:14:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2113626E6F2;
	Fri, 12 Jun 2026 01:14:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0081C3128CF
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 01:14:08 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781226852; cv=pass; b=ZqgLCwo2rqVlaGeNvB0F5hg7TNfPLqVYagYtvhoC48dENyOz/81WNEoaYHP6KXk3w6eLYBf2DhtWLe3RI8l5AAQVrYPMdyptj+BgZwqKhb7jWZLHd1YBlrDzsGa/dQdii8x9TtT261BHY64BRzKsqeubOwC2vO5bbsTjjnsSx8g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781226852; c=relaxed/simple;
	bh=BkoXl0YDfbQV+4G5840uRlLDNXWo8HVE7OMOOhE639E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KVbPorA8eN7MWhewH66Rcbi5AmrkZobDSGZmuv7SZzamoAe01/xHgyG/QosdmBlt0bO+qTbuLtWe31xVvDP6KzCt3wvG5f8ylTK8mnSBGMnuRriFWE6OKqqlW1GeE1eQA4rUYOvrhkkESeTJzeEBe2KT76X2blzY0/qTtdnzY7I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Qp1Uq/n3; arc=pass smtp.client-ip=209.85.167.180
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-486f43a4521so119540b6e.3
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 18:14:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781226848; cv=none;
        d=google.com; s=arc-20240605;
        b=eqrowEMDrseRPPfcIrS2TZlnV+Nx/Aay1Q+asRoRDDkrr0GxLkj2ctUYoYavpPcIJb
         mgbA+WznRZpabU08i850eH8pE+y5ZfYh3iRpNMKzrllNjJCh1WSrPrNWMev5aXt9EC5r
         8JryZpXs6wT6sTatjHAogyXm+BRYoE5RUvWKo7THWBmqvcVZoqdFucu29leC/fgT9Wgy
         zZYMG087mGKZlcYXQK3QNM569YCDsij+Xk+u+L4VrtG/ISdJjI3sYqLiZp8H42bKRwJQ
         fM4TCjqKhiGLlkl4yNiJy1aDqaQBTFGXtoxzTWMhL5eNoC4z5EP0E4597qvlw1fkUkPd
         Ak1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RKuB1tBom6aZEyGg3H3lvPdBeaMzwnCSuD7fM/j7VBo=;
        fh=8SanVj4MV0LZcXSROTGCY35wrAI3fk+fJGDl/3jrlWo=;
        b=CAJCGGsQytCWqvmvWzJb68JzlmBPGMJV7soCyiLZZD4AFudE9qYGir1OI6cTSpn93W
         HneFYrEYNBy8raAUUj5jxUI2jwdn9WSlBtCBSbffD9rHkcssnbd/un/nvrlilwHwNNTE
         nc4KHEwrK032BFg/yfDm59GBeNt3IMnaRFV8b4VF6uhlzP+xWfJUnnGQGvTWdDWi2UXp
         WgnDAf2PByOdK9e1/BEBeoRUKCE1s+HSDrvs8UAzyi2P1VhMZg2d5+CFkLTMoRPMydDp
         KTPmsKmyfgqucxiXQwhwaCD4JmgfDUmsz3Pon+USjTqvywiC6w7V30CyNIlRGi1ThqSN
         dMNA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781226847; x=1781831647; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RKuB1tBom6aZEyGg3H3lvPdBeaMzwnCSuD7fM/j7VBo=;
        b=Qp1Uq/n3Tj9jOxKB2DSh1fuxQ7b1PIkgHT/V1fudnt40nNNPEtXHvHrpAg1kyX2h+w
         lcBP5qbsTjipHCdRNQYOvvl9sZUGo7+fkj1PpYtNyUpY13M7Lfw0iydx/gKS8fpE3lta
         yhNFsO9HJMLZn/gj4CHP/IYa22KdK4Uex2YXiVsscFizQyPsVnKKgbh4gQHaoCUI9iUE
         UzDGT5QUYH2IU6eGeMTN6UbjQSMdXKUH3NKHqFOB6gMrABXl8iHppGyyFsRgvVOcQDoe
         K5ho9K+cRlgWw6W6FlHBoz3VL/S06QvS0YvjYg2NmsjwTy2UoX4WwquduYZ6TI0B33Tu
         Z27g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781226848; x=1781831648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RKuB1tBom6aZEyGg3H3lvPdBeaMzwnCSuD7fM/j7VBo=;
        b=PnTas0JsYy62QWNF6Pxyb7y4EhMHhoZmjc4TkIZf1YOpOSkWHZUZjDgAq/OxCYMUaz
         szvBIZWJyhG0T3uparxgXy4Wbh+LAotA09mNCoTDX3qLPGTdnpJ+lFWoThNoOqrOtZ34
         sXPN7+MAh8n9Let2EdCIn/KgDeTKJRzHn25fVKBFFaUNq9ZLoFDDyDMYQPtvlHTix7TN
         TVdYqxgQu7xpQCYRjuWrLCWdn8WyCRS+/bglqUlnoL8qywv3lYyJ2LsoP3kvehvLooWx
         12vcsEdJTp3ji933aDj40ybbB6dBRdnNw2zgVP98Z37BoaNLl/7qBYZYyvWs6eXMCpgE
         0BgA==
X-Gm-Message-State: AOJu0Ywmi6oZ4oE8Jt80Uf1suxy6lmYoeePopvsfJ3fWYA9lqgw0LQn+
	Q99z5arp9iV8PCql6uG+/GEm4cyc71twvjse+bRrhQLv1balAODEhsIayULVnUZKGMCjBzskDw/
	99nsemvQ3AJsJlXD3p0sZgjTuZXlklA+ge25qwoWeqg==
X-Gm-Gg: Acq92OGz+Fnz/BhPyp6tdblxQli7lVu0Xzy514Weinnp92dGxGvm4tc7g81iz8GdfAZ
	yn84dSJzD1e2qU55qBuUx2AuUgbL7OhwKe58LgrZDrEsCH0vhZvvjnI0F6zgMrzInC1NpoMsXgY
	HsyUoXZ0izE/yW7KWYuIN4aCOcm+9XN1mHLChVN3T24ZLTzGyYanUsXMFsqIYBmNkYQ+oscqAXb
	lcSWRU/2KJmYkj81tUJmOTlhIn3OxWOTGesVjrwasY0n6m3sbG4xmz8RP8pQiTIj07xJzDdnRwu
	KZYrVv+h
X-Received: by 2002:a05:6830:3812:b0:7e6:cbe3:cbbe with SMTP id
 46e09a7af769-7e784780139mr204765a34.7.1781226847408; Thu, 11 Jun 2026
 18:14:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260611160553.1486640-1-axboe@kernel.dk> <20260611160553.1486640-2-axboe@kernel.dk>
In-Reply-To: <20260611160553.1486640-2-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 11 Jun 2026 18:13:55 -0700
X-Gm-Features: AVVi8CcTz6vQfjROMtPptO1LhhLCaJtERwJowrLvjdh_IV8Rs_4nHzs8p5AdqFE
Message-ID: <CADUfDZpQuB=TsQT2aZFkwhsHBhXQnzowPJQa4Fs6z+PA558qcw@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring/mpscq: add lockless multi-producer,
 single-consumer FIFO queue
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
	TAGGED_FROM(0.00)[bounces-13679-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid,vger.kernel.org:from_smtp,kernel.dk:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 3679767610E

On Thu, Jun 11, 2026 at 9:12=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
>
> Local task_work is currently using llists for managing the work,
> but that's a LIFO type of list. This means that running this task_work
> needs to reverse the list first, to ensure fairness in running the
> queued items.
>
> Add a lockless FIFO queued, based on Dmitry Vyukov's intrusive MPSC
> node-based queue algorithm, modified with an externally held consumer
> cursor and conditional stub reinsertion. See comments in the header.
>
> Producers are wait-free: a push is a single xchg() on the queue tail,
> which serializes concurrent producers and defines the FIFO order, plus
> a store linking the node to its predecessor. There are no cmpxchg retry
> loops, and pushing is safe from any context, including hardirq.
>
> The cost of linked list FIFO ordering is that a push publishes the node
> in two steps - the xchg() makes it visible as the new tail before the
> subsequent store links it into the chain that is reachable from the
> head. A consumer hitting that window gets a NULL from mpscq_pop() while
> mpscq_empty() reports false, and must retry later rather than treat the
> queue as empty. The window is two instructions wide, but a producer can
> get preempted inside it, so the consumer must not busy wait on it.
>
> The consumer side supports a single consumer at a time, with callers
> providing their own serialization. A stub node, which also defines the
> empty state (tail =3D=3D stub), allows the consumer to detach the final
> node without racing against producer link stores: that node is only
> handed out once the stub has been cmpxchg'ed back in as the tail. This
> also guarantees that the previous tail returned by mpscq_push() cannot
> get freed before that push has linked it, making it always valid for
> comparisons.
>
> The consumer cursor is deliberately not part of the queue struct - the
> caller owns it and passes it to mpscq_pop(). This is done to separate
> the consumer and producers cacheline.The cursor is written for
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |  12 ++++
>  io_uring/mpscq.h               | 121 +++++++++++++++++++++++++++++++++
>  2 files changed, 133 insertions(+)
>  create mode 100644 io_uring/mpscq.h
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index aa4d5477f859..85e12b4884a5 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -55,6 +55,18 @@ struct io_wq_work_list {
>         struct io_wq_work_node *last;
>  };
>
> +/*
> + * Lockless multi-producer, single-consumer FIFO queue, see
> + * io_uring/mpscq.h for the implementation and rules. Defined here so
> + * that it can be embedded in io_ring_ctx. This is the producer side
> + * only - the consumer cursor is kept separately, on a cacheline that
> + * isn't dirtied by the producers.
> + */
> +struct mpscq {
> +       struct llist_node       *tail;          /* producers */
> +       struct llist_node       stub;
> +};
> +
>  struct io_wq_work {
>         struct io_wq_work_node list;
>         atomic_t flags;
> diff --git a/io_uring/mpscq.h b/io_uring/mpscq.h
> new file mode 100644
> index 000000000000..12172cef8394
> --- /dev/null
> +++ b/io_uring/mpscq.h
> @@ -0,0 +1,121 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef IOU_MPSCQ_H
> +#define IOU_MPSCQ_H
> +
> +/*
> + * mpscq - lockless multi-producer, single-consumer FIFO queue
> + *
> + * Unlike llist, which is LIFO ordered and hence needs an O(n)
> + * llist_reverse_order() pass before entries can be processed in queue o=
rder,
> + * this queue hands out nodes in the order they were pushed.
> + *
> + * The consumer cursor is held by the caller rather than in the queue st=
ruct
> + * (see below), and with the stub reinsertion done as a single cmpxchg a=
ttempt
> + * instead of an unconditional push, keeping tail =3D=3D stub a reliable=
 empty test
> + * while a producer is in the middle of a push.
> + *
> + * Producers may run in any context (task, softirq, hardirq) and are wai=
t-free:
> + * a push is one xchg() plus one store, with no retry loops. FIFO order =
between
> + * producers is the order in which the xchg() on ->tail serializes them.
> + *
> + * The price for linked-list FIFO is that a push publishes the node in t=
wo
> + * steps: the xchg() makes it the new tail, and the subsequent store lin=
ks it to
> + * its predecessor. In between, the tail end of the queue is not yet rea=
chable
> + * from the head. mpscq_pop() detects this and returns NULL, while mpscq=
_empty()
> + * reports false. The consumer must not treat such a NULL as "queue empt=
y" - it
> + * should retry later. The window is two instructions wide, but a produc=
er can
> + * be preempted inside it, so the consumer must not spin on it while hol=
ding
> + * resources the producer might need to make progress.
> + *
> + * The consumer side only supports a single consumer at a time, callers =
must
> + * provide their own serialization for it. The stub node is what allows =
the
> + * consumer to detach the final node without racing with the link stores=
 of
> + * producers. This scheme also guarantees that the previous tail returne=
d by
> + * mpscq_push() cannot be freed by the consumer until the push that retu=
rned it
> + * has linked it, hence it's always safe to compare against (but not
> + * dereference, unless the caller otherwise guarantees its lifetime).
> + *
> + * The queue struct only holds the producer side. The consumer keeps its=
 cursor
> + * (the oldest not yet handed out node) externally and passes it to mpsc=
q_pop(),
> + * so that it can be placed on a different cacheline: the cursor is writ=
ten for
> + * every pop, and having it share a line with ->tail would have the cons=
umer
> + * invalidating the line that producers need for every push.
> + */
> +static inline void mpscq_init(struct mpscq *q, struct llist_node **headp=
)
> +{
> +       q->tail =3D *headp =3D &q->stub;
> +       q->stub.next =3D NULL;
> +}
> +
> +/*
> + * Returns true if the queue holds no entries that mpscq_pop() hasn't ha=
nded out
> + * yet. May be called from any context. Note that !empty doesn't guarant=
ee that
> + * mpscq_pop() will return an entry yet, see the in-flight producer wind=
ow
> + * above.
> + */
> +static inline bool mpscq_empty(struct mpscq *q)
> +{
> +       return READ_ONCE(q->tail) =3D=3D &q->stub;
> +}
> +
> +/*
> + * Push a node onto the queue. Safe against concurrent pushes from any c=
ontext,
> + * and against the (single) consumer. Returns the previous tail node, wh=
ich is
> + * &q->stub if and only if the queue was empty before this push.
> + */
> +static inline struct llist_node *mpscq_push(struct mpscq *q,
> +                                           struct llist_node *node)

It seems odd to return the previous tail node. The pointer can't be
dereferenced, as the node could be popped and freed at any point. The
return value is only compared against &stub  to determine whether the
queue was empty. Seems like the interface would be simpler and avoid
leaking implementation details by just returning whether the queue was
empty before the push.

> +{
> +       struct llist_node *prev;
> +
> +       node->next =3D NULL;
> +       /*
> +        * xchg() implies a full barrier, so the initialization of the
> +        * entry (including ->next above) is visible before the node can
> +        * be reached, either via ->tail or via ->next chasing from the
> +        * head once the store below has linked it.
> +        */
> +       prev =3D xchg(&q->tail, node);
> +       WRITE_ONCE(prev->next, node);

I think this needs to be a release-order store and the READ_ONCE()s in
mpscq_pop() need to be acquire-order loads. Since mpscq_pop() doesn't
necessarily load q->tail, there's no happens-before relationship
between pushing a node and popping it.

> +       return prev;
> +}
> +
> +/*
> + * Pop the oldest node off the queue, or return NULL if no node is avail=
able.
> + * NULL is returned both when the queue is empty and when a producer has
> + * published a node via ->tail but hasn't linked it yet; use mpscq_empty=
() to
> + * tell the two apart. Single consumer only, with headp being the consum=
er
> + * cursor that mpscq_init() set up.
> + */
> +static inline struct llist_node *mpscq_pop(struct mpscq *q,
> +                                          struct llist_node **headp)
> +{
> +       struct llist_node *head =3D *headp;
> +       struct llist_node *next =3D READ_ONCE(head->next);
> +
> +       if (head =3D=3D &q->stub) {
> +               if (!next)
> +                       return NULL;
> +               *headp =3D next;
> +               head =3D next;
> +               next =3D READ_ONCE(head->next);
> +       }

I would find it a bit clearer to avoid using "next" to refer to the
actual head in the stub case:

struct llist_node *head =3D *headp, *next;
if (head =3D=3D &q->stub) {
        head =3D READ_ONCE(head->next);
        if (!head)
                return NULL;
       *headp =3D head;
}
next =3D READ_ONCE(head->next);

> +       if (next) {
> +               *headp =3D next;
> +               return head;
> +       }
> +       /*
> +        * 'head' is the last linked node, it can only be handed out once=
 the
> +        * stub has taken its place as the tail. If the cmpxchg fails, a
> +        * producer has made a new node the tail but hasn't linked it to =
'head'

nit: "but hasn't linked 'head' to it" since the pointer goes from head
to the new tail?

> +        * yet - bail and let the caller retry.
> +        */
> +       q->stub.next =3D NULL;
> +       if (try_cmpxchg(&q->tail, &head, &q->stub)) {
> +               *headp =3D &q->stub;
> +               return head;
> +       }
> +       return NULL;

An early return if the try_cmpxchg() fails would reduce indentation of
the successful path.

Best,
Caleb

> +}
> +
> +#endif /* IOU_MPSCQ_H */
> --
> 2.53.0
>
>

