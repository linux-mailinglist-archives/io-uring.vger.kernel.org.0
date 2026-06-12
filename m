Return-Path: <io-uring+bounces-13686-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id OND9Njl0K2qe9wMAu9opvQ
	(envelope-from <io-uring+bounces-13686-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:51:37 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B866867654E
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:51:37 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=xDVK9QQx;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13686-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13686-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id CB0EC302F259
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 570ED2F12AD;
	Fri, 12 Jun 2026 02:51:34 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5EF3905E4
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 02:51:32 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781232694; cv=none; b=YWQQUxHV0VkVRsLZmSINmXVAH1UyCz9gyRmMt0tq1z7HVpqwyYZuiKoRom3JAV0s91FsgYMx9rWuLY2BvpDA5yKE8BWz71vGR+M5zd0ZL8lJbG+OdF1SAljqqahFKXgIVrqC4mZp6L4lcjv3SLezP4R8DwnYLzJv9JKmg0Y2Aqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781232694; c=relaxed/simple;
	bh=0XZod8sbYDUtVhgVJ1K5w82K0J6mTKVTOyWb0Fytk70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMYE8rLsaY31fIu6/uqA1Lkg8eQvWKlUgp/fTukkAQmPu05fMSjy3i/DdEpxEDhWNAv9p2rol/Svi7K1ITw8R3307I0e6XJTiLlwPKxTZJiORgah594Hnj197WeoBCQTmoGb0BP2PZBn54t5mQYXTFReDUScnZnBpMVNsXxv2wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=xDVK9QQx; arc=none smtp.client-ip=209.85.210.41
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7e71dd64ea2so364220a34.3
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 19:51:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781232691; x=1781837491; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5nMW3kVQdD81bbha4oSvPT6cSEM5vEkdQuRFCvBM54=;
        b=xDVK9QQxUI+JmQXkmP+bN56KABr86qpWaGpzSzNJrK0cx4j+w2VrdNvEbBBbFF56Qy
         iZeAiR234n9tLJjpG8H/8kKmCGi69BqrviAlAWGlLs1B6Vy4rtPC3jRXqF9z1RBcJMfm
         AZHsSBcz9hT0HkUKDy5xHQUfGjeiJQ+zJiINm3WeVqE8s1BefLJIF45fX6S4a3Pq80SK
         j/q9IytHwX2ENRmorNUjFJc5chPaE81y4R7KRYlQyR7C/WWOZF67WqkJEWcNwSNep8hG
         o10ChDLMwO05URE8v0VdMy5xnyVIQipp9HI7GWcv+JtUlXUsp52fNOCXsZklKR72/gNx
         wvWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781232691; x=1781837491;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v5nMW3kVQdD81bbha4oSvPT6cSEM5vEkdQuRFCvBM54=;
        b=NeOgM0RX9uEyvKt7Jx8zZcoV/Mh9qX45GdOAgMJ3SBrR9T8ALP8COyFgorU+Z9u/hu
         wrIIuEtihLTemmRWQZbnDwFCg6nIAy4pujls3P2U7XQfiOeWWHMh3dxmvIkRk25Hw2iF
         Oioyim9XBb+1UihRoyw2ApditGi4Oc7RsWb+uhHrM8SiVEVy4Z6A8CDwakGWSbb5IDLB
         R2kTb035jYBuTYiKxKxVN3R8kkgnUtEK6SEXuhnsxXuGoutNrqUr6XCpekeeOCqpVJ8f
         APdGuwjvjaY3D/yE4Wpr2i5zmlXCfi7wmgWCPIfAk8rI9lxH/gQY0WfDuo1uGaooQzpq
         9qKw==
X-Gm-Message-State: AOJu0Yyw+dsMwnZ4aYUHpaAp7OKxtrTMtCE61fE6CQr62KlB9BG0nur+
	/EoKhTZaD/l6cEE7KbwIMJeWGzreY6MsglMQSqqsgx/On1CS23k6NACnyz0gjC3CmThGld8H9D0
	D81BJNIg=
X-Gm-Gg: Acq92OEZxBxMVsMfC/RfTHDJDKLIuEe8EYiJqGei+tuQaWV5XBJL5l0D4GX2XgEpBAP
	2UXKNTXPZC/+XOCNwqDm3o9KK1Qx/Po4DoxWeJAWeifOi1vQoFh8SNO9UAfoBGhvOohggPan991
	/hT+yl5e8uirOvU9aSv6UTm279dX8y0wpUITctSmOGgdj+KYoHdACOBr9e5Hj8A5KbbLX3oCg3P
	CqznaAzLhuYRogPeXMbhcb/AeL16YohXypj48kHxPNKzEHwXgteTPSn0NyAm2HIrCOVziEEOXid
	VJa4kZ+MCcOne6jEb4x8WcNQ6WQEhu8RuEvWvBPoNsI8trGyiBLG+6huh+b3C+7qw/Y1iBRRR/l
	Rk8+bcM2ltmrvAFzkfQ+PNjB5hGYFz5/TTyAYqkxBx5+sAPp/IwrE+a/EylPYNoUdxV7CQA+92l
	mQSVxrfNsHjPRe6YYJfT/WIyHOoY85ArV4nWRyL7yeenLQ9M8FuHXvIj5+jLVTfoTBbk/m
X-Received: by 2002:a05:6830:83b3:b0:7e6:c819:22e9 with SMTP id 46e09a7af769-7e78479a3c1mr537329a34.17.1781232691321;
        Thu, 11 Jun 2026 19:51:31 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e781734190sm862128a34.19.2026.06.11.19.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 19:51:30 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dvyukov@google.com,
	csander@purestorage.com,
	krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring/mpscq: add lockless multi-producer, single-consumer FIFO queue
Date: Thu, 11 Jun 2026 20:48:28 -0600
Message-ID: <20260612025125.1690253-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612025125.1690253-1-axboe@kernel.dk>
References: <20260612025125.1690253-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13686-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:csander@purestorage.com,m:krisman@suse.de,m:axboe@kernel.dk,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kernel.dk:email,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B866867654E

Local task_work is currently using llists for managing the work,
but that's a LIFO type of list. This means that running this task_work
needs to reverse the list first, to ensure fairness in running the
queued items.

Add a lockless FIFO queued, based on Dmitry Vyukov's intrusive MPSC
node-based queue algorithm, modified with an externally held consumer
cursor and conditional stub reinsertion. See comments in the header.

Producers are wait-free: a push is a single xchg() on the queue tail,
which serializes concurrent producers and defines the FIFO order, plus
a store linking the node to its predecessor. There are no cmpxchg retry
loops, and pushing is safe from any context, including hardirq.

The cost of linked list FIFO ordering is that a push publishes the node
in two steps - the xchg() makes it visible as the new tail before the
subsequent store links it into the chain that is reachable from the
head. A consumer hitting that window gets a NULL from mpscq_pop() while
mpscq_empty() reports false, and must retry later rather than treat the
queue as empty. The window is two instructions wide, but a producer can
get preempted inside it, so the consumer must not busy wait on it.

The consumer side supports a single consumer at a time, with callers
providing their own serialization. A stub node, which also defines the
empty state (tail == stub), allows the consumer to detach the final
node without racing against producer link stores: that node is only
handed out once the stub has been cmpxchg'ed back in as the tail. This
also guarantees that the previous tail returned by mpscq_push() cannot
get freed before that push has linked it, making it always valid for
comparisons.

The consumer cursor is deliberately not part of the queue struct - the
caller owns it and passes it to mpscq_pop(). This is done to separate
the consumer and producers cacheline. The cursor is written for every
popped entry, and keeping it on the same cacheline as ->tail would have
the consumer invalidating the line that producers need for every push.
Keeping it external lets the caller place it with its own consumer side
data instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  12 ++++
 io_uring/mpscq.h               | 118 +++++++++++++++++++++++++++++++++
 2 files changed, 130 insertions(+)
 create mode 100644 io_uring/mpscq.h

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index aa4d5477f859..85e12b4884a5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -55,6 +55,18 @@ struct io_wq_work_list {
 	struct io_wq_work_node *last;
 };
 
+/*
+ * Lockless multi-producer, single-consumer FIFO queue, see
+ * io_uring/mpscq.h for the implementation and rules. Defined here so
+ * that it can be embedded in io_ring_ctx. This is the producer side
+ * only - the consumer cursor is kept separately, on a cacheline that
+ * isn't dirtied by the producers.
+ */
+struct mpscq {
+	struct llist_node	*tail;		/* producers */
+	struct llist_node	stub;
+};
+
 struct io_wq_work {
 	struct io_wq_work_node list;
 	atomic_t flags;
diff --git a/io_uring/mpscq.h b/io_uring/mpscq.h
new file mode 100644
index 000000000000..bc482d10e0f3
--- /dev/null
+++ b/io_uring/mpscq.h
@@ -0,0 +1,118 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef IOU_MPSCQ_H
+#define IOU_MPSCQ_H
+
+/*
+ * mpscq - lockless multi-producer, single-consumer FIFO queue
+ *
+ * Unlike llist, which is LIFO ordered and hence needs an O(n)
+ * llist_reverse_order() pass before entries can be processed in queue order,
+ * this queue hands out nodes in the order they were pushed.
+ *
+ * The consumer cursor is held by the caller rather than in the queue struct
+ * (see below), and with the stub reinsertion done as a single cmpxchg attempt
+ * instead of an unconditional push, keeping tail == stub a reliable empty test
+ * while a producer is in the middle of a push.
+ *
+ * Producers may run in any context (task, softirq, hardirq) and are wait-free:
+ * a push is one xchg() plus one store, with no retry loops. FIFO order between
+ * producers is the order in which the xchg() on ->tail serializes them.
+ *
+ * The price for linked-list FIFO is that a push publishes the node in two
+ * steps: the xchg() makes it the new tail, and the subsequent store links it to
+ * its predecessor. In between, the tail end of the queue is not yet reachable
+ * from the head. mpscq_pop() detects this and returns NULL, while mpscq_empty()
+ * reports false. The consumer must not treat such a NULL as "queue empty" - it
+ * should retry later. The window is two instructions wide, but a producer can
+ * be preempted inside it, so the consumer must not spin on it while holding
+ * resources the producer might need to make progress.
+ *
+ * The consumer side only supports a single consumer at a time, callers must
+ * provide their own serialization for it. The stub node is what allows the
+ * consumer to detach the final node without racing with the link stores of
+ * producers. This scheme also guarantees that the previous tail observed by
+ * mpscq_push() cannot be freed by the consumer until the push has linked it,
+ * which is what makes the deferred link store safe.
+ *
+ * The queue struct only holds the producer side. The consumer keeps its cursor
+ * (the oldest not yet handed out node) externally and passes it to mpscq_pop(),
+ * so that it can be placed on a different cacheline: the cursor is written for
+ * every pop, and having it share a line with ->tail would have the consumer
+ * invalidating the line that producers need for every push.
+ */
+static inline void mpscq_init(struct mpscq *q, struct llist_node **headp)
+{
+	q->tail = *headp = &q->stub;
+	q->stub.next = NULL;
+}
+
+/*
+ * Returns true if the queue holds no entries that mpscq_pop() hasn't handed out
+ * yet. May be called from any context. Note that !empty doesn't guarantee that
+ * mpscq_pop() will return an entry yet, see the in-flight producer window
+ * above.
+ */
+static inline bool mpscq_empty(struct mpscq *q)
+{
+	return READ_ONCE(q->tail) == &q->stub;
+}
+
+/*
+ * Push a node onto the queue. Safe against concurrent pushes from any context,
+ * and against the (single) consumer. Returns true if the queue was empty
+ * before this push.
+ */
+static inline bool mpscq_push(struct mpscq *q, struct llist_node *node)
+{
+	struct llist_node *prev;
+
+	node->next = NULL;
+	/*
+	 * xchg() implies a full barrier, so the initialization of the
+	 * entry (including ->next above) is visible before the node can
+	 * be reached, either via ->tail or via ->next chasing from the
+	 * head once the store below has linked it.
+	 */
+	prev = xchg(&q->tail, node);
+	WRITE_ONCE(prev->next, node);
+	return prev == &q->stub;
+}
+
+/*
+ * Pop the oldest node off the queue, or return NULL if no node is available.
+ * NULL is returned both when the queue is empty and when a producer has
+ * published a node via ->tail but hasn't linked it yet; use mpscq_empty() to
+ * tell the two apart. Single consumer only, with headp being the consumer
+ * cursor that mpscq_init() set up.
+ */
+static inline struct llist_node *mpscq_pop(struct mpscq *q,
+					   struct llist_node **headp)
+{
+	struct llist_node *head = *headp, *next;
+
+	if (head == &q->stub) {
+		head = READ_ONCE(head->next);
+		if (!head)
+			return NULL;
+		*headp = head;
+	}
+	next = READ_ONCE(head->next);
+	if (next) {
+		*headp = next;
+		return head;
+	}
+	/*
+	 * 'head' is the last linked node, it can only be handed out once the
+	 * stub has taken its place as the tail. If the cmpxchg fails, a
+	 * producer has made a new node the tail but hasn't linked 'head' to
+	 * it yet - bail and let the caller retry.
+	 */
+	q->stub.next = NULL;
+	if (try_cmpxchg(&q->tail, &head, &q->stub)) {
+		*headp = &q->stub;
+		return head;
+	}
+	return NULL;
+}
+
+#endif /* IOU_MPSCQ_H */
-- 
2.53.0


