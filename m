Return-Path: <io-uring+bounces-13674-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id /Qn/CRHrKmqRzQMAu9opvQ
	(envelope-from <io-uring+bounces-13674-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 19:06:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AB8D673D7B
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 19:06:24 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DUasQFrk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4AlZumf1;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=DUasQFrk;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4AlZumf1;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13674-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13674-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=suse.de;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C98B03276A39
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 16:49:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DB34317145;
	Thu, 11 Jun 2026 16:49:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417FF2BEFEB
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 16:49:29 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781196571; cv=none; b=nMKJ6sqWR/D93QpRpaTFw0mBJV4tqXxq5RxBfGZ7/59+9eQ9a+JQmFp0cAF3xEfXq6LhFgetbYLcexPcFe8wy+LMY1k6WjeUdtQpL9o4GhTVVIY/yOK+x+xZOnPT2fy0pN6gRbqPg3l6xANIwAz7ggDnVW1cG7tDBpEbNPzrU7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781196571; c=relaxed/simple;
	bh=RhKbe/RYG89MCiKlYAvgrs000aRdfFJnqEbvO2M9SnQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=NBZptQeoYt3/SQdor3iBJOLboiaKdEeewUHVLwamtQ84GpZ1fiEWKjyvWeECmTTossL8uS2z5Jlhws4Y5RtS/WC2JRbXpMHdQY/b3tB6CX2jA11DcOY42gS+UhZhJPSoyfCq0Dzyk7rJVPpG9Z1isUUHlUnwbN8ztc6L3X4oAsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DUasQFrk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4AlZumf1; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=DUasQFrk; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=4AlZumf1; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 300B76AFE1;
	Thu, 11 Jun 2026 16:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781196567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yYU7NI9AAzGjzRgUAJbXGDxGuztKu8tHqEHKRph63w=;
	b=DUasQFrkQUD0lPwJgT4xlnPwb8lrxBSEe9gnOSEMXa0+1R8yNO+VpYXgOax9HQva3e0HjO
	71IaCO1Tcw3xtBTTiaXiMiHLRYSzg8vd2JC7QY1aiMcNDW/hvkSX67wlR9NOkNKmRI2Bd4
	TOgQgZVFpk+zp570VIYlHnj/NdtPui8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781196567;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yYU7NI9AAzGjzRgUAJbXGDxGuztKu8tHqEHKRph63w=;
	b=4AlZumf11nm83lrgmdxY2+bMprKKZoXGUqhR+D/f2QHAMvKMzY3DTxZkrJXAd+EO0Vn4iJ
	mm/4BwPXcBXceJBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781196567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yYU7NI9AAzGjzRgUAJbXGDxGuztKu8tHqEHKRph63w=;
	b=DUasQFrkQUD0lPwJgT4xlnPwb8lrxBSEe9gnOSEMXa0+1R8yNO+VpYXgOax9HQva3e0HjO
	71IaCO1Tcw3xtBTTiaXiMiHLRYSzg8vd2JC7QY1aiMcNDW/hvkSX67wlR9NOkNKmRI2Bd4
	TOgQgZVFpk+zp570VIYlHnj/NdtPui8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781196567;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+yYU7NI9AAzGjzRgUAJbXGDxGuztKu8tHqEHKRph63w=;
	b=4AlZumf11nm83lrgmdxY2+bMprKKZoXGUqhR+D/f2QHAMvKMzY3DTxZkrJXAd+EO0Vn4iJ
	mm/4BwPXcBXceJBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D30BF779A7;
	Thu, 11 Jun 2026 16:49:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xP/NKBbnKmqHWgAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 11 Jun 2026 16:49:26 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,  dvyukov@google.com
Subject: Re: [PATCH 1/2] io_uring/mpscq: add lockless multi-producer,
 single-consumer FIFO queue
In-Reply-To: <20260611160553.1486640-2-axboe@kernel.dk> (Jens Axboe's message
	of "Thu, 11 Jun 2026 09:58:41 -0600")
References: <20260611160553.1486640-1-axboe@kernel.dk>
	<20260611160553.1486640-2-axboe@kernel.dk>
Date: Thu, 11 Jun 2026 12:49:24 -0400
Message-ID: <87ldcldnu3.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -4.51
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_FROM(0.00)[bounces-13674-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:dvyukov@google.com,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_SENDER_FORWARDING(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6AB8D673D7B

Jens Axboe <axboe@kernel.dk> writes:

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
> empty state (tail == stub), allows the consumer to detach the final
> node without racing against producer link stores: that node is only
> handed out once the stub has been cmpxchg'ed back in as the tail. This
> also guarantees that the previous tail returned by mpscq_push() cannot
> get freed before that push has linked it, making it always valid for
> comparisons.
>
> The consumer cursor is deliberately not part of the queue struct - the
> caller owns it and passes it to mpscq_pop(). This is done to separate
> the consumer and producers cacheline.The cursor is written for

Interesting stuff!  The commit message is truncated here, though.

>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/io_uring_types.h |  12 ++++
>  io_uring/mpscq.h               | 121 +++++++++++++++++++++++++++++++++

There's nothing io_uring specific here.  Perhaps put in lib/ directly
some a wider audience can review  and use?

>  2 files changed, 133 insertions(+)
>  create mode 100644 io_uring/mpscq.h
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
> index aa4d5477f859..85e12b4884a5 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -55,6 +55,18 @@ struct io_wq_work_list {
>  	struct io_wq_work_node *last;
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
> +	struct llist_node	*tail;		/* producers */
> +	struct llist_node	stub;
> +};
> +
>  struct io_wq_work {
>  	struct io_wq_work_node list;
>  	atomic_t flags;
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
> + * llist_reverse_order() pass before entries can be processed in queue order,
> + * this queue hands out nodes in the order they were pushed.
> + *
> + * The consumer cursor is held by the caller rather than in the queue struct
> + * (see below), and with the stub reinsertion done as a single cmpxchg attempt
> + * instead of an unconditional push, keeping tail == stub a reliable empty test
> + * while a producer is in the middle of a push.
> + *
> + * Producers may run in any context (task, softirq, hardirq) and are wait-free:
> + * a push is one xchg() plus one store, with no retry loops. FIFO order between
> + * producers is the order in which the xchg() on ->tail serializes them.
> + *
> + * The price for linked-list FIFO is that a push publishes the node in two
> + * steps: the xchg() makes it the new tail, and the subsequent store links it to
> + * its predecessor. In between, the tail end of the queue is not yet reachable
> + * from the head. mpscq_pop() detects this and returns NULL, while mpscq_empty()
> + * reports false. The consumer must not treat such a NULL as "queue empty" - it
> + * should retry later. The window is two instructions wide, but a producer can
> + * be preempted inside it, so the consumer must not spin on it while holding
> + * resources the producer might need to make progress.
> + *
> + * The consumer side only supports a single consumer at a time, callers must
> + * provide their own serialization for it. The stub node is what allows the
> + * consumer to detach the final node without racing with the link stores of
> + * producers. This scheme also guarantees that the previous tail returned by
> + * mpscq_push() cannot be freed by the consumer until the push that returned it
> + * has linked it, hence it's always safe to compare against (but not
> + * dereference, unless the caller otherwise guarantees its lifetime).
> + *
> + * The queue struct only holds the producer side. The consumer keeps its cursor
> + * (the oldest not yet handed out node) externally and passes it to mpscq_pop(),
> + * so that it can be placed on a different cacheline: the cursor is written for
> + * every pop, and having it share a line with ->tail would have the consumer
> + * invalidating the line that producers need for every push.
> + */
> +static inline void mpscq_init(struct mpscq *q, struct llist_node **headp)
> +{
> +	q->tail = *headp = &q->stub;
> +	q->stub.next = NULL;
> +}
> +
> +/*
> + * Returns true if the queue holds no entries that mpscq_pop() hasn't handed out
> + * yet. May be called from any context. Note that !empty doesn't guarantee that
> + * mpscq_pop() will return an entry yet, see the in-flight producer window
> + * above.
> + */
> +static inline bool mpscq_empty(struct mpscq *q)
> +{
> +	return READ_ONCE(q->tail) == &q->stub;
> +}
> +
> +/*
> + * Push a node onto the queue. Safe against concurrent pushes from any context,
> + * and against the (single) consumer. Returns the previous tail node, which is
> + * &q->stub if and only if the queue was empty before this push.
> + */
> +static inline struct llist_node *mpscq_push(struct mpscq *q,
> +					    struct llist_node *node)
> +{
> +	struct llist_node *prev;
> +
> +	node->next = NULL;
> +	/*
> +	 * xchg() implies a full barrier, so the initialization of the
> +	 * entry (including ->next above) is visible before the node can
> +	 * be reached, either via ->tail or via ->next chasing from the
> +	 * head once the store below has linked it.
> +	 */
> +	prev = xchg(&q->tail, node);
> +	WRITE_ONCE(prev->next, node);
> +	return prev;
> +}
> +
> +/*
> + * Pop the oldest node off the queue, or return NULL if no node is available.
> + * NULL is returned both when the queue is empty and when a producer has
> + * published a node via ->tail but hasn't linked it yet; use mpscq_empty() to
> + * tell the two apart. Single consumer only, with headp being the consumer
> + * cursor that mpscq_init() set up.
> + */
> +static inline struct llist_node *mpscq_pop(struct mpscq *q,
> +					   struct llist_node **headp)
> +{
> +	struct llist_node *head = *headp;
> +	struct llist_node *next = READ_ONCE(head->next);
> +
> +	if (head == &q->stub) {
> +		if (!next)
> +			return NULL;
> +		*headp = next;
> +		head = next;
> +		next = READ_ONCE(head->next);
> +	}
> +	if (next) {
> +		*headp = next;
> +		return head;
> +	}
> +	/*
> +	 * 'head' is the last linked node, it can only be handed out once the
> +	 * stub has taken its place as the tail. If the cmpxchg fails, a
> +	 * producer has made a new node the tail but hasn't linked it to 'head'
> +	 * yet - bail and let the caller retry.
> +	 */
> +	q->stub.next = NULL;
> +	if (try_cmpxchg(&q->tail, &head, &q->stub)) {
> +		*headp = &q->stub;
> +		return head;
> +	}
> +	return NULL;
> +}
> +
> +#endif /* IOU_MPSCQ_H */

-- 
Gabriel Krisman Bertazi

