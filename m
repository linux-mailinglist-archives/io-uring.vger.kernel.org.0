Return-Path: <io-uring+bounces-13672-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 1+TdIfDcKmpTyQMAu9opvQ
	(envelope-from <io-uring+bounces-13672-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 18:06:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F80B6734BD
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 18:06:08 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=G8TYeumi;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13672-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13672-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 3A5E13014775
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 16:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46554403E99;
	Thu, 11 Jun 2026 16:06:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AEB6403126
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 16:06:02 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781193965; cv=none; b=SRd9fkbQvVZc2gdQ6eggwYPPfv5gVizY1UgqH9R206pk0C6fVEB/c/5nPGBUFqPi+8GPXHB6yuQ6W0kmKfSjEilG0UUusYpCV+hn8BGWadiokcvXLpszf56pn9tbbAYuvk0gRCgn+LtjIafG8Wu57EHSOoXGeWDQ0+xfMtn/5mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781193965; c=relaxed/simple;
	bh=1LpbatQMJcANVSYN68bB5y+jG4a3YiAyND2sn+GwOgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g+YdeGilq+JPUnUWi+iO5tLGVaHc//t3p9evgFjAVJAGrVKCtIcKTos/IfkvexzCF5xFwgmKqL7KqxWd3266ubQfXfaD/GY5Mz3p5DPHolN2GqQR4nPQr5Z/gBXbyZWL3dJp7QXIoUkHloiwCL3cxLMFb0Ec3Pf3DwVrXGPBP2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=G8TYeumi; arc=none smtp.client-ip=209.85.167.178
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-4865e953031so969814b6e.0
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 09:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781193962; x=1781798762; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBf1425MouukAZG1WrCDYn5Vsm/awamr18Hvi8peBMk=;
        b=G8TYeumijnsD+EeoAp66hXVQgpfh8mmiHhbFSKJGyvCZmvGgl2rQCeW2DzWiJgucxM
         9BHNRLur6oekt3lnUIka2amDKhVn1TANFz8ue1+QBsgLDcQ7DLTqAbwlLAbiH2LgMbM7
         m7LjfzsuP+aESYm/b+cC9/aq0EUIouFSJ3lxAg3YtG/+DZm8drcFkLSnDMubpk41h0cq
         Gw7OWJHNt7/EGyBXBzT7r1buFJLABdJYclyTLwKRNFC7KHTf+j1ss4JCj9kjMfTeVLAu
         VjQwhTktdxcHXMOo39z1c5nXegqG2I+Gwzct57F/nN9aNQ7v9c9MoGqRxLTtYvLIspMX
         /b8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781193962; x=1781798762;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bBf1425MouukAZG1WrCDYn5Vsm/awamr18Hvi8peBMk=;
        b=Ic5NmepsYwBTJWnNoToIP6HDE/VuS+3j3c3jYHljWrnX8PnGxEMDqeP3RUVoNT8meJ
         oID/wn1vRE/xJ75GCT0CnX4Ld0GnI/8CyjdIGHOi8g1oqZ7Olwj2Q8l4UN2wtv1h8I1n
         2PV6KUEj8sZgvegsHdbpptmUQtaIOzrvV+q5Hk5vBbppOXSHBeN9uTLjN5TOBuo2vi38
         CvOerpNY72iw95EU9E3qE2lJv52i5SLn7BBRRvTn+7udDLyfb4fxiH2bzM4+LuiCV5dg
         NV4J4HaJpgkyKKF/ge/ZcQ0MH5WEFO1T8OGTuPrf34FzdjbIb2cXP4ISAW7+zL8AhpA3
         a8pw==
X-Gm-Message-State: AOJu0Yx8AOhbnzAnrY21vzUBwG8m7kNXyEI82yvyn7jhYDv6RXaDbkNC
	DKmnbXAXEyHYgoigNWn7Du01/bbMD4iro6ozz2cRgeIqem9Aumn4vqNwDriyq1r8ImZLw8PG0qF
	6BMl6Tn4=
X-Gm-Gg: Acq92OGaue92maztLk/B2sHqV7KehEEHVVMfEuMp1zjDQ2viwsOuBrozIRREKSwgbJ1
	P6AA1swhsdeCvqRtFfgnFjAaTL9h/5tqXAXuOsuGEfzO1OLW04hcX6LKlu65bj/YB324GHM1RvP
	nDKVr3qrOMnTvEpHAtOv1hM0jrjlnpgDmjSB2ePjDLIyPQo/UwAmZfTftptxWKbhXMadEwFjWp6
	QsarredOms7IakJ0m82aw3DKSV94Mko7M2d50FMuerPGuS80sB6JTz3ltIIOVqPpAC2Fvcj2Sj+
	GsziJipuMPv9anbcCnRk6vbV3POXb3xroW4SVRQEMsZ+r2x3sAzXSA/Jicbm6P5CseAl9q5bOi5
	pkiKbNyPWdKN1YMXJRyYuBnDjNAbdxhw0hKqaXwxJwySgTK6BUmUkHie3QgZzBv0rV4Dqp1ch9K
	qq06ZGfbl9IwepIfnH/NMa8nTOh4ok3lzlYIrxpuX0jyTHBvV5BRGXMwHXASnLLfuSoVJwp68ha
	E6eoQ==
X-Received: by 2002:a05:6808:221b:b0:485:729e:6ac8 with SMTP id 5614622812f47-4871a867dd9mr1767667b6e.5.1781193961834;
        Thu, 11 Jun 2026 09:06:01 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-442444c7d9csm1353221fac.3.2026.06.11.09.06.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 09:06:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dvyukov@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/mpscq: add lockless multi-producer, single-consumer FIFO queue
Date: Thu, 11 Jun 2026 09:58:41 -0600
Message-ID: <20260611160553.1486640-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611160553.1486640-1-axboe@kernel.dk>
References: <20260611160553.1486640-1-axboe@kernel.dk>
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
	TAGGED_FROM(0.00)[bounces-13672-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:axboe@kernel.dk,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 0F80B6734BD

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
the consumer and producers cacheline.The cursor is written for

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  12 ++++
 io_uring/mpscq.h               | 121 +++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)
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
index 000000000000..12172cef8394
--- /dev/null
+++ b/io_uring/mpscq.h
@@ -0,0 +1,121 @@
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
+ * producers. This scheme also guarantees that the previous tail returned by
+ * mpscq_push() cannot be freed by the consumer until the push that returned it
+ * has linked it, hence it's always safe to compare against (but not
+ * dereference, unless the caller otherwise guarantees its lifetime).
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
+ * and against the (single) consumer. Returns the previous tail node, which is
+ * &q->stub if and only if the queue was empty before this push.
+ */
+static inline struct llist_node *mpscq_push(struct mpscq *q,
+					    struct llist_node *node)
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
+	return prev;
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
+	struct llist_node *head = *headp;
+	struct llist_node *next = READ_ONCE(head->next);
+
+	if (head == &q->stub) {
+		if (!next)
+			return NULL;
+		*headp = next;
+		head = next;
+		next = READ_ONCE(head->next);
+	}
+	if (next) {
+		*headp = next;
+		return head;
+	}
+	/*
+	 * 'head' is the last linked node, it can only be handed out once the
+	 * stub has taken its place as the tail. If the cmpxchg fails, a
+	 * producer has made a new node the tail but hasn't linked it to 'head'
+	 * yet - bail and let the caller retry.
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


