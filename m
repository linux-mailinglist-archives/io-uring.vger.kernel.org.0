Return-Path: <io-uring+bounces-13803-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 0hEmFv60OGrzgQcAu9opvQ
	(envelope-from <io-uring+bounces-13803-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 06:07:26 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDEA76AC6E3
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 06:07:25 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U+k2BeK5;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13803-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13803-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linux.dev;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 203813008C23
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 04:07:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1A23546DE;
	Mon, 22 Jun 2026 04:06:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B493546F0
	for <io-uring@vger.kernel.org>; Mon, 22 Jun 2026 04:06:53 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782101219; cv=none; b=nbxnIyYbwOhu5i+TaJQiLN15JC6rW/DLXtzsIOCNJRpzmfou5ybq2bvZQelskSCzzj48rUcNji20B6Z0jkT7KL3hYRGf1MBfkVSUEdUZXT76D9dG3YYWQDEH2rLKkr5I/gZH5lJpJeudeqZw4DX63Rt4LZjKqz7GxbFWB8vljBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782101219; c=relaxed/simple;
	bh=3hj4vsPUJDxfEYfiZALpitLc4rdoWBuYdp2GxysY30s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOzj86VGr9O/o10Iee8adpEuAE4qL0u5csvJWplarzCwNVWDxcPx4ZJfbIAgzNR7Mscr2kdRycjfLyINYWNw1ppFwZe0ovCoOZ/tsQ6m5ExQIHUJsveLT8Xdcjg8jwIw4IJJ06KRi3AAC5kJMdaVnODgneY0JMxE0ZGzij6GyMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=U+k2BeK5; arc=none smtp.client-ip=91.218.175.171
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782101210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ifihl8QoiBoywP+aXJrYFC3QhTRNuzfTpuEgOqKFH8M=;
	b=U+k2BeK53z2j05swHRT0lacq0ZTVsZXyAyHCLZNDF76tNliwPGXmpiDoHZSwTAZAVNO1bW
	D0heyFxlfRNySZ2eTObHrN21BX8AQCwBl+WBAUkcc4UCehXoqyuJU7Kdwf8tJzpvbifLz7
	HteD2STjYo7LJnqoMTdXNA1BRgkU+dM=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Paul Moore <paul@paul-moore.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: David Howells <dhowells@redhat.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Randy Dunlap <rdunlap@infradead.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Philipp Stanner <phasta@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	audit@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	damon@lists.linux.dev,
	llvm@lists.linux.dev,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 1/7] list: Add mutable iterator variants
Date: Mon, 22 Jun 2026 12:05:31 +0800
Message-ID: <20260622040533.29824-2-kaitao.cheng@linux.dev>
In-Reply-To: <20260622040533.29824-1-kaitao.cheng@linux.dev>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13803-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:akpm@linux-foundation.org,m:david@kernel.org,m:axboe@kernel.dk,m:tj@kernel.org,m:viro@zeniv.linux.org.uk,m:brauner@kernel.org,m:ast@kernel.org,m:daniel@iogearbox.net,m:andrii@kernel.org,m:hannes@cmpxchg.org,m:peterz@infradead.org,m:mingo@redhat.com,m:acme@kernel.org,m:namhyung@kernel.org,m:tglx@kernel.org,m:juri.lelli@redhat.com,m:vincent.guittot@linaro.org,m:paul@paul-moore.com,m:andriy.shevchenko@linux.intel.com,m:paulmck@kernel.org,m:shakeel.butt@linux.dev,m:christian.koenig@amd.com,m:dhowells@redhat.com,m:simona.vetter@ffwll.ch,m:rdunlap@infradead.org,m:luca.ceresoli@bootlin.com,m:phasta@kernel.org,m:linux-block@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:cgroups@vger.kernel.org,m:linux-ntfs-dev@lists.sourceforge.net,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:audit@vger.kernel.org,m:bpf@vger.kernel.org,m:netdev@vger.kernel.org,m:dri-devel@lists.freedesktop.org,m:linux-perf-users@vger.kernel.org,m:linux-trace-kernel@vger.kernel.org
 ,m:kexec@lists.infradead.org,m:live-patching@vger.kernel.org,m:linux-modules@vger.kernel.org,m:linux-crypto@vger.kernel.org,m:linux-pm@vger.kernel.org,m:rcu@vger.kernel.org,m:sched-ext@lists.linux.dev,m:linux-mm@kvack.org,m:virtualization@lists.linux.dev,m:damon@lists.linux.dev,m:llvm@lists.linux.dev,m:chengkaitao@kylinos.cn,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_GT_50(0.00)[51];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kylinos.cn:email,sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,vger.kernel.org:from_smtp,linux.dev:dkim,linux.dev:mid,linux.dev:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DDEA76AC6E3

From: Kaitao Cheng <chengkaitao@kylinos.cn>

The list_for_each*_safe() helpers are used when the loop body may
remove the current entry.  Their API exposes the temporary cursor at
every call site, even though most users only need it for the iterator
implementation and never reference it in the loop body.

Add *_mutable() variants for list and hlist iteration.  The new helpers
support both forms: callers may keep passing an explicit temporary cursor
when they need to inspect or reset it, or omit it and let the helper use
a unique internal cursor.

This makes call sites that only mutate the list through the current entry
less noisy, while keeping the existing *_safe() helpers available for
compatibility.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 231 insertions(+), 38 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 09d979976b3b..1081def7cea9 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -7,6 +7,7 @@
 #include <linux/stddef.h>
 #include <linux/poison.h>
 #include <linux/const.h>
+#include <linux/args.h>
 
 #include <asm/barrier.h>
 
@@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_for_each_prev(pos, head) \
 	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
 
-/**
- * list_for_each_safe - iterate over a list safe against removal of list entry
- * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
+/*
+ * list_for_each_safe is an old interface, use list_for_each_mutable instead.
  */
 #define list_for_each_safe(pos, n, head) \
 	for (pos = (head)->next, n = pos->next; \
 	     !list_is_head(pos, (head)); \
 	     pos = n, n = pos->next)
 
+#define __list_for_each_mutable_internal(pos, tmp, head)		\
+	for (typeof(pos) tmp = (pos = (head)->next)->next;		\
+	     !list_is_head(pos, (head));				\
+	     pos = tmp, tmp = pos->next)
+
+#define __list_for_each_mutable1(pos, head)				\
+	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
+
+#define __list_for_each_mutable2(pos, next, head)			\
+	list_for_each_safe(pos, next, head)
+
 /**
- * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
+ * list_for_each_mutable - iterate over a list safe against entry removal
  * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
+ * @...:	either (head) or (next, head)
+ *
+ * next:	another &struct list_head to use as optional temporary storage.
+ *		The temporary cursor is internal unless explicitly supplied by
+ *		the caller.
+ * head:	the head for your list.
+ */
+#define list_for_each_mutable(pos, ...)					\
+	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
+		(pos, __VA_ARGS__)
+
+/*
+ * list_for_each_prev_safe is an old interface, use list_for_each_prev_mutable instead.
  */
 #define list_for_each_prev_safe(pos, n, head) \
 	for (pos = (head)->prev, n = pos->prev; \
 	     !list_is_head(pos, (head)); \
 	     pos = n, n = pos->prev)
 
+#define __list_for_each_prev_mutable_internal(pos, tmp, head)		\
+	for (typeof(pos) tmp = (pos = (head)->prev)->prev;		\
+	     !list_is_head(pos, (head));				\
+	     pos = tmp, tmp = pos->prev)
+
+#define __list_for_each_prev_mutable1(pos, head)			\
+	__list_for_each_prev_mutable_internal(pos, __UNIQUE_ID(prev), head)
+
+#define __list_for_each_prev_mutable2(pos, prev, head)			\
+	list_for_each_prev_safe(pos, prev, head)
+
+/**
+ * list_for_each_prev_mutable - iterate over a list backwards safe against entry removal
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @...:	either (head) or (prev, head)
+ *
+ * prev:	another &struct list_head to use as optional temporary storage.
+ *		The temporary cursor is internal unless explicitly supplied by
+ *		the caller.
+ * head:	the head for your list.
+ */
+#define list_for_each_prev_mutable(pos, ...)				\
+	CONCATENATE(__list_for_each_prev_mutable, COUNT_ARGS(__VA_ARGS__)) \
+		(pos, __VA_ARGS__)
+
 /**
  * list_count_nodes - count nodes in the list
  * @head:	the head for your list.
@@ -895,12 +940,8 @@ static inline size_t list_count_nodes(struct list_head *head)
 	for (; !list_entry_is_head(pos, head, member);			\
 	     pos = list_prev_entry(pos, member))
 
-/**
- * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_head within the struct.
+/*
+ * list_for_each_entry_safe is an old interface, use list_for_each_entry_mutable instead.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_first_entry(head, typeof(*pos), member),	\
@@ -908,15 +949,36 @@ static inline size_t list_count_nodes(struct list_head *head)
 	     !list_entry_is_head(pos, head, member); 			\
 	     pos = n, n = list_next_entry(n, member))
 
+#define __list_for_each_entry_mutable_internal(pos, tmp, head, member)	\
+	for (typeof(pos) tmp = list_next_entry(pos =			\
+		list_first_entry(head, typeof(*pos), member), member);	\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = tmp, tmp = list_next_entry(tmp, member))
+
+#define __list_for_each_entry_mutable2(pos, head, member)		\
+	__list_for_each_entry_mutable_internal(pos, __UNIQUE_ID(next), head, member)
+
+#define __list_for_each_entry_mutable3(pos, next, head, member)		\
+	list_for_each_entry_safe(pos, next, head, member)
+
 /**
- * list_for_each_entry_safe_continue - continue list iteration safe against removal
+ * list_for_each_entry_mutable - iterate over a list safe against entry removal
  * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_head within the struct.
+ * @...:	either (head, member) or (next, head, member)
  *
- * Iterate over list of given type, continuing after current point,
- * safe against removal of list entry.
+ * next:	another type * to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * head:	the head for your list.
+ * member:	the name of the list_head within the struct.
+ */
+#define list_for_each_entry_mutable(pos, ...)				\
+	CONCATENATE(__list_for_each_entry_mutable, COUNT_ARGS(__VA_ARGS__)) \
+		(pos, __VA_ARGS__)
+
+/*
+ * list_for_each_entry_safe_continue is an old interface,
+ * use list_for_each_entry_mutable_continue instead.
  */
 #define list_for_each_entry_safe_continue(pos, n, head, member) 		\
 	for (pos = list_next_entry(pos, member), 				\
@@ -924,30 +986,79 @@ static inline size_t list_count_nodes(struct list_head *head)
 	     !list_entry_is_head(pos, head, member);				\
 	     pos = n, n = list_next_entry(n, member))
 
+#define __list_for_each_entry_mutable_continue_internal(pos, tmp, head, member) \
+	for (typeof(pos) tmp = list_next_entry(pos =			\
+		list_next_entry(pos, member), member);			\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = tmp, tmp = list_next_entry(tmp, member))
+
+#define __list_for_each_entry_mutable_continue2(pos, head, member)	\
+	__list_for_each_entry_mutable_continue_internal(pos,		\
+		__UNIQUE_ID(next), head, member)
+
+#define __list_for_each_entry_mutable_continue3(pos, next, head, member) \
+	list_for_each_entry_safe_continue(pos, next, head, member)
+
 /**
- * list_for_each_entry_safe_from - iterate over list from current point safe against removal
+ * list_for_each_entry_mutable_continue - continue list iteration safe against removal
  * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_head within the struct.
+ * @...:	either (head, member) or (next, head, member)
  *
- * Iterate over list of given type from current point, safe against
- * removal of list entry.
+ * next:	another type * to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * head:	the head for your list.
+ * member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type, continuing after current point,
+ * safe against removal of list entry.
+ */
+#define list_for_each_entry_mutable_continue(pos, ...)			\
+	CONCATENATE(__list_for_each_entry_mutable_continue,		\
+		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
+
+/*
+ * list_for_each_entry_safe_from is an old interface,
+ * use list_for_each_entry_mutable_from instead.
  */
 #define list_for_each_entry_safe_from(pos, n, head, member) 			\
 	for (n = list_next_entry(pos, member);					\
 	     !list_entry_is_head(pos, head, member);				\
 	     pos = n, n = list_next_entry(n, member))
 
+#define __list_for_each_entry_mutable_from_internal(pos, tmp, head, member) \
+	for (typeof(pos) tmp = list_next_entry(pos, member);		\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = tmp, tmp = list_next_entry(tmp, member))
+
+#define __list_for_each_entry_mutable_from2(pos, head, member)		\
+	__list_for_each_entry_mutable_from_internal(pos,		\
+		__UNIQUE_ID(next), head, member)
+
+#define __list_for_each_entry_mutable_from3(pos, next, head, member)	\
+	list_for_each_entry_safe_from(pos, next, head, member)
+
 /**
- * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
+ * list_for_each_entry_mutable_from - iterate over list from current point safe against removal
  * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_head within the struct.
+ * @...:	either (head, member) or (next, head, member)
  *
- * Iterate backwards over list of given type, safe against removal
- * of list entry.
+ * next:	another type * to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * head:	the head for your list.
+ * member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type from current point, safe against
+ * removal of list entry.
+ */
+#define list_for_each_entry_mutable_from(pos, ...)			\
+	CONCATENATE(__list_for_each_entry_mutable_from,			\
+		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
+
+/*
+ * list_for_each_entry_safe_reverse is an old interface,
+ * use list_for_each_entry_mutable_reverse instead.
  */
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
 	for (pos = list_last_entry(head, typeof(*pos), member),		\
@@ -955,6 +1066,37 @@ static inline size_t list_count_nodes(struct list_head *head)
 	     !list_entry_is_head(pos, head, member); 			\
 	     pos = n, n = list_prev_entry(n, member))
 
+#define __list_for_each_entry_mutable_reverse_internal(pos, tmp, head, member) \
+	for (typeof(pos) tmp = list_prev_entry(pos =			\
+		list_last_entry(head, typeof(*pos), member), member);	\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = tmp, tmp = list_prev_entry(tmp, member))
+
+#define __list_for_each_entry_mutable_reverse2(pos, head, member)	\
+	__list_for_each_entry_mutable_reverse_internal(pos,		\
+		__UNIQUE_ID(prev), head, member)
+
+#define __list_for_each_entry_mutable_reverse3(pos, prev, head, member)	\
+	list_for_each_entry_safe_reverse(pos, prev, head, member)
+
+/**
+ * list_for_each_entry_mutable_reverse - iterate backwards over list safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @...:	either (head, member) or (prev, head, member)
+ *
+ * prev:	another type * to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * head:	the head for your list.
+ * member:	the name of the list_head within the struct.
+ *
+ * Iterate backwards over list of given type, safe against removal
+ * of list entry.
+ */
+#define list_for_each_entry_mutable_reverse(pos, ...)			\
+	CONCATENATE(__list_for_each_entry_mutable_reverse,		\
+		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
+
 /**
  * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
  * @pos:	the loop cursor used in the list_for_each_entry_safe loop
@@ -1189,6 +1331,31 @@ static inline void hlist_splice_init(struct hlist_head *from,
 	for (pos = (head)->first; pos && ({ n = pos->next; 1; }); \
 	     pos = n)
 
+#define __hlist_for_each_mutable_internal(pos, tmp, head)		\
+	for (typeof(pos) tmp = (pos = (head)->first) ? pos->next : NULL; \
+	     pos;							\
+	     pos = tmp, tmp = pos ? pos->next : NULL)
+
+#define __hlist_for_each_mutable1(pos, head)				\
+	__hlist_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
+
+#define __hlist_for_each_mutable2(pos, next, head)			\
+	hlist_for_each_safe(pos, next, head)
+
+/**
+ * hlist_for_each_mutable - iterate over a hlist safe against entry removal
+ * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @...:	either (head) or (next, head)
+ *
+ * next:	another &struct hlist_node to use as optional temporary storage.
+ *		The temporary cursor is internal unless explicitly supplied by
+ *		the caller.
+ * head:	the head for your hlist.
+ */
+#define hlist_for_each_mutable(pos, ...)				\
+	CONCATENATE(__hlist_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
+		(pos, __VA_ARGS__)
+
 #define hlist_entry_safe(ptr, type, member) \
 	({ typeof(ptr) ____ptr = (ptr); \
 	   ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
@@ -1224,18 +1391,44 @@ static inline void hlist_splice_init(struct hlist_head *from,
 	for (; pos;							\
 	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
 
-/**
- * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @pos:	the type * to use as a loop cursor.
- * @n:		a &struct hlist_node to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
+/*
+ * hlist_for_each_entry_safe is an old interface, use hlist_for_each_entry_mutable instead.
  */
 #define hlist_for_each_entry_safe(pos, n, head, member) 		\
 	for (pos = hlist_entry_safe((head)->first, typeof(*pos), member);\
 	     pos && ({ n = pos->member.next; 1; });			\
 	     pos = hlist_entry_safe(n, typeof(*pos), member))
 
+#define __hlist_for_each_entry_mutable_internal(pos, tmp, head, member)	\
+	for (struct hlist_node *tmp = (pos =				\
+		hlist_entry_safe((head)->first, typeof(*pos), member)) ? \
+		pos->member.next : NULL;				\
+	     pos;							\
+	     pos = hlist_entry_safe((tmp), typeof(*pos), member),	\
+		tmp = pos ? pos->member.next : NULL)
+
+#define __hlist_for_each_entry_mutable2(pos, head, member)		\
+	__hlist_for_each_entry_mutable_internal(pos,			\
+		__UNIQUE_ID(next), head, member)
+
+#define __hlist_for_each_entry_mutable3(pos, next, head, member)	\
+	hlist_for_each_entry_safe(pos, next, head, member)
+
+/**
+ * hlist_for_each_entry_mutable - iterate over hlist safe against entry removal
+ * @pos:	the type * to use as a loop cursor.
+ * @...:	either (head, member) or (next, head, member)
+ *
+ * next:	a &struct hlist_node to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * head:	the head for your hlist.
+ * member:	the name of the hlist_node within the struct.
+ */
+#define hlist_for_each_entry_mutable(pos, ...)				\
+	CONCATENATE(__hlist_for_each_entry_mutable,			\
+		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
+
 /**
  * hlist_count_nodes - count nodes in the hlist
  * @head:	the head for your hlist.
-- 
2.43.0


