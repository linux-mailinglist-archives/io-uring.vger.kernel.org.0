Return-Path: <io-uring+bounces-13715-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id BFICCUnDLGqcWAQAu9opvQ
	(envelope-from <io-uring+bounces-13715-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 04:41:13 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA7E67D8D6
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 04:41:12 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=purestorage.com header.s=google2022 header.b=Sbimfnub;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13715-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13715-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=purestorage.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=2")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1F43331D1CB9
	for <lists+io-uring@lfdr.de>; Sat, 13 Jun 2026 02:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8AC027A476;
	Sat, 13 Jun 2026 02:41:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F10335BA8
	for <io-uring@vger.kernel.org>; Sat, 13 Jun 2026 02:41:07 +0000 (UTC)
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781318469; cv=pass; b=mPwsw1xGuOaeBWeZvvNnroh9bsVFEQkl15edaFKtSRYK9CsxLWuvqJ7PUWPlwKmqBT82Vt8Hu0BDGRIH01+nhh9qZCUCVPkqM2g8mZhw4QNcsu9ra9Gih4z3vpNOT2qe5yMKJf10phMlIJAbREoKJNx/tztAi6KPj3KumoPO7Ik=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781318469; c=relaxed/simple;
	bh=Y4r+xGC+26teVIz3+V/lYHP/CiqXpMrqCc4GwkXUa+Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q5JDJ3HGPrhBmA8XrM6HflPRj1OPRlD8o+4xZNCPTfGzRDCnEbxMtRikOm6UNmWJKgUMjGIqJ5H3G4JUb9kmQ9RZWBie+V6rQ2//G9/TSFN9OJQuKj1s6oKXG5iR/bGjcWED5yMOvqCdA+LpvvwYgNsJ5teLxVlpnuz4+SmurzE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Sbimfnub; arc=pass smtp.client-ip=209.85.210.48
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e6b574c105so233358a34.1
        for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 19:41:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781318467; cv=none;
        d=google.com; s=arc-20240605;
        b=kRrCf0X3T6WN+lYIA6QMWKHSsho3MGmyXBhN7v11aZxnX1jEEQrLRhiB5qr0P6y8/d
         lhSeU7/nu9Bw51lXBRA+RsjbWW7hRf8oxofhlyObeJmamj8m8IWUiThbyTGlnQPyUzDG
         vMLNLoFy3oxy9LhAAmnqn+T/qyGMkSRpV4eIXw6Ev4FKFadUpV2mN5kQBTnPvj5DcsT8
         fbqrYwZxbsZrDL6Hc2HsCmGa2JNe7LELIWhrXk3Ldoo+dMWajykPd9hasiZ9MN/meosH
         2U76U0psX4p/GjrRfwe7SHDumMnL/sDdFJwyEG2NFjyu799WEpl9SAEgqO4wJ/+NgHzz
         qwhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=olAgFFCks6mmGCXIYO840o+w+fC6zyRiuT6JX0a8aGs=;
        fh=tcB1jbK5Mfh49jFaBDMFCl5E4RG50sbZDH32oaESUuc=;
        b=d6uaZN/HCmSXAtBzq3QeC9NCI57hDyh5AfkBTFTIZb64dLWG7W9kqQcAjSMWmQiYAk
         pDnCHMp5/18XSMaxnCiN127UrvltOJcoDxVelicqRKGLn9RjajMPPU9k1Yk1YZEZMWNI
         5pLxEgRWpTViVVvMa8WokZTJJ8kDeNbJ/zxcjOafztReZxWlnCryoUIsP9Ly6SDRtxrx
         IstpDj6bkpPUH9B4liRa7v2V4pcib6V4qPIsOvToVYv2C5vvSks/uq9lHQsQjljXtI3n
         IwJdD1vyRzGJ0L1piGxWtU4vhIXvsow9GFiVuruQYjE7vxR/v8BJ8XKTPK/uyhpZFlWu
         vLGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1781318467; x=1781923267; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=olAgFFCks6mmGCXIYO840o+w+fC6zyRiuT6JX0a8aGs=;
        b=SbimfnubxIFQKh8mavrmDK2gajVUyX8Dpj1fzvx7cSycDpK/5UKFeCStZ8ucjkAC8/
         ulGlsPOjGppG6CZWYsu6pUJXxjLrqSlLypVbc8rhsAjTLR3uEJjNoJEVi7RuthN1Vm4u
         ykj+f3pOED0nqVPIkcMWxa0XGlWFuAxWCb3Z7SSJHLVWSZYN3xampZvKuAgFrnkwkPKH
         3K9d0qvQTLHSZam8Ual1lqXG8XJkdHjKnOIxKxqBMZCCdXaSnpU+Shjar7Vk5+4dZtvg
         aJkwQF9pm+0EU6WUJrcQ+xgxZDLi1RkXrDWzQSPjGzCEZu9w5FR2URK9h7n1Irrumvmr
         EbLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781318467; x=1781923267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=olAgFFCks6mmGCXIYO840o+w+fC6zyRiuT6JX0a8aGs=;
        b=gG42seHj/4JmYsdq7d2rkK6k8nEEbetCykZLS5q1b47ZwbB4PrSGxyNb6N6MTlCRZK
         HTBjHREQPLi5AsqXbWCbRSIYIK63oUHvWAZvtBxQmvOS6o5Cv6HsgptH71ySW99kfpV8
         IzmqTz0ltpNGHNSOjqRDIL5Jp8iFxi45ECdWXbY0u9MqQfwliOatHvJerza6dLE+Zbr6
         MfggdGyqyupqEm1M1lLiVVN7J99IlqN/UgBI/ocTEAMs3mXJmWO/SLNuxD2LdFslLPK6
         zN9l+D1dFdvLgUEalxE7uSHlwk4eIr7on2MHn3zmBxno+VpLa7haSZVCWEIo39Z7X/2j
         SLrg==
X-Gm-Message-State: AOJu0YwIIrwsQTwiXiaeslCsnB7KPEToexPd4RlGoDbuGw2FQi0ZoPr5
	hwK1j47jYcT+5bWfjNDhVezWuihVHQ+zvSBtzbBXoVdfkm0JRA0ctzQa7TKFbzb4CPLeRtAJuM9
	XUagHuTziv1bf0oF6YRhpW+B73k792ly71dRDbMlMMw==
X-Gm-Gg: Acq92OFDWjOrzHcXNGeuFWpJL/IkM8PoH1QvO1uzGkV55NVfYLD9HEGZagl6lbRk6fo
	OE0iGY82afnKxxvjo17hU/WI8eXQKhYjtE4OFF/2pekfwtogtSoqDwfCFOkF8zQ6jYqVVgvEJ/A
	tNTc4dodAPoA5Yizfdr+XWgSvn74OOOKbHML3oX1CuxzdO4CnsNoJfjd72m9PHZAb0Ej5xLYy2F
	rgQok9JFKKBQSmW2uCVjVndIq76jfCFHJwsz/nPhiG+RJPRn8WxiQ1+VgMpxxJ2oq4bnFwzD2hk
	oj3PK5VCpkuH8XD1gjk=
X-Received: by 2002:a4a:e7c7:0:b0:695:94b4:d4bf with SMTP id
 006d021491bc7-69edc3985c5mr1331352eaf.0.1781318466522; Fri, 12 Jun 2026
 19:41:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260612025125.1690253-1-axboe@kernel.dk> <20260612025125.1690253-3-axboe@kernel.dk>
In-Reply-To: <20260612025125.1690253-3-axboe@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 12 Jun 2026 19:40:54 -0700
X-Gm-Features: AVVi8CeniavQAaURB0Xra8S8S9dWOTfkwS51pFMoABfZc3yI8oEq3IGNsWvz2Aw
Message-ID: <CADUfDZoLTJ6mtQ5yaP83_K18N7eK3u72gkNSPrnhg-vjb=8p1Q@mail.gmail.com>
Subject: Re: [PATCH 2/6] io_uring/mpscq: add lockless multi-producer,
 single-consumer FIFO queue
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, dvyukov@google.com, krisman@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13715-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,mail.gmail.com:mid,purestorage.com:dkim,purestorage.com:email,purestorage.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6DA7E67D8D6

On Thu, Jun 11, 2026 at 7:51=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
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
> the consumer and producers cacheline. The cursor is written for every
> popped entry, and keeping it on the same cacheline as ->tail would have
> the consumer invalidating the line that producers need for every push.
> Keeping it external lets the caller place it with its own consumer side
> data instead.
>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |  12 ++++
>  io_uring/mpscq.h               | 118 +++++++++++++++++++++++++++++++++
>  2 files changed, 130 insertions(+)
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
> index 000000000000..bc482d10e0f3
> --- /dev/null
> +++ b/io_uring/mpscq.h
> @@ -0,0 +1,118 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef IOU_MPSCQ_H
> +#define IOU_MPSCQ_H

#include <linux/io_uring_types.h> so this header can compile on its own?

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
> + * producers. This scheme also guarantees that the previous tail observe=
d by
> + * mpscq_push() cannot be freed by the consumer until the push has linke=
d it,
> + * which is what makes the deferred link store safe.
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
> + * and against the (single) consumer. Returns true if the queue was empt=
y
> + * before this push.
> + */
> +static inline bool mpscq_push(struct mpscq *q, struct llist_node *node)
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
> +       return prev =3D=3D &q->stub;
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
> +       struct llist_node *head =3D *headp, *next;
> +
> +       if (head =3D=3D &q->stub) {
> +               head =3D READ_ONCE(head->next);
> +               if (!head)
> +                       return NULL;
> +               *headp =3D head;
> +       }
> +       next =3D READ_ONCE(head->next);
> +       if (next) {
> +               *headp =3D next;
> +               return head;
> +       }
> +       /*
> +        * 'head' is the last linked node, it can only be handed out once=
 the
> +        * stub has taken its place as the tail. If the cmpxchg fails, a
> +        * producer has made a new node the tail but hasn't linked 'head'=
 to
> +        * it yet - bail and let the caller retry.
> +        */
> +       q->stub.next =3D NULL;

I think this could be moved before *headp =3D head. That way it only
runs once each time the queue becomes nonempty rather than on every
attempt to switch tail back to &stub. And it would keep next =3D
READ_ONCE(head->next) and try_cmpxchg(&q->tail, &head, &q->stub))
closer together, reducing the window where the consumer could lose the
race to pop the last element.

Other that that,
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

> +       if (try_cmpxchg(&q->tail, &head, &q->stub)) {
> +               *headp =3D &q->stub;
> +               return head;
> +       }
> +       return NULL;
> +}
> +
> +#endif /* IOU_MPSCQ_H */
> --
> 2.53.0
>

