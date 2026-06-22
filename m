Return-Path: <io-uring+bounces-13804-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id prstIBm1OGr9gQcAu9opvQ
	(envelope-from <io-uring+bounces-13804-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 06:07:53 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 15AC26AC704
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 06:07:53 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RKNYTOPI;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13804-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13804-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linux.dev;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A3B06300A4BC
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 04:07:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823A2357CE0;
	Mon, 22 Jun 2026 04:07:09 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66E1352014
	for <io-uring@vger.kernel.org>; Mon, 22 Jun 2026 04:07:06 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782101229; cv=none; b=HRebDmGvOkAuyO+qIJOFCtEo1bn067PiThgmskbqVwZyY8fCKLA+o1jZZdCJTda6FuQqzyfyaqhC/MGrh4pqaIF7WkuKbs+Xm78xbSjAuqT28hZyyXlWkKzpTHUDY88K32mQBcdLCwhfB6ohi0qnBZYP1kjo3i1RB3BYZ/+SN8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782101229; c=relaxed/simple;
	bh=m2LLV+BA5spGIUzLab9tWQ1i0a9h7daxqjgqeVb30rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e8FswySvW4fe2WigvJDq2yhOKA+D/xf4CLlcvWwkHwq27QzV0MxpLyiobP0eLRRzl3JKS/st5Fj10yF8G+itSastOV8AjTUVePaoWtauHeYpCXBhHI1tX9rXve9dzVsDk2O3VAXJFFIPa5iRbnoaTDyskOwbrbzRV7txlkjh1no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RKNYTOPI; arc=none smtp.client-ip=91.218.175.180
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782101224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vFaoYZTJfRDH9hDuVHVBgZkR1flChQcp5jR5STw0K2M=;
	b=RKNYTOPII31SLlFemAcWqWE/TeS/HQJl7crveXc7GdzZz5I+TjbXRbbkZaQSvN3TmVtVYT
	nSSDvsZk7jNyt6B/E4YmD4cYyLjd5RE2oOf/Hiy1FZ2NcIRHyitOaBZNUaYo6dvHseOLCi
	TzRgynUCXY7wguiC8GKfv0LXaYiHBGc=
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
Subject: [PATCH v3 2/7] llist: Add mutable iterator variants
Date: Mon, 22 Jun 2026 12:05:32 +0800
Message-ID: <20260622040533.29824-3-kaitao.cheng@linux.dev>
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
	TAGGED_FROM(0.00)[bounces-13804-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:rdns,sto.lore.kernel.org:helo,kylinos.cn:email,vger.kernel.org:from_smtp,linux.dev:dkim,linux.dev:mid,linux.dev:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 15AC26AC704

From: Kaitao Cheng <chengkaitao@kylinos.cn>

llist_for_each_safe() and llist_for_each_entry_safe() require callers to
provide a temporary cursor even when the cursor is only needed by the
iterator itself.  This makes call sites noisier than necessary for the
common case where the loop body may remove the current entry but does
not otherwise inspect the saved next pointer.

Add llist_for_each_mutable() and llist_for_each_entry_mutable() variants
that support both forms.  Callers may omit the temporary cursor and let
the helper create an internal unique cursor, or keep passing an explicit
cursor when the loop needs to inspect or reset it.

Keep the existing safe helpers as compatibility wrappers so current users
continue to build unchanged while new code can use the shorter mutable
form.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 include/linux/llist.h | 81 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 65 insertions(+), 16 deletions(-)

diff --git a/include/linux/llist.h b/include/linux/llist.h
index 8846b7709669..1c6f12411d5e 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -49,6 +49,7 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/args.h>
 #include <linux/container_of.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
@@ -143,12 +144,33 @@ static inline bool llist_on_list(const struct llist_node *node)
 #define llist_for_each(pos, node)			\
 	for ((pos) = (node); pos; (pos) = (pos)->next)
 
+/*
+ * llist_for_each_safe is an old interface, use llist_for_each_mutable instead.
+ */
+#define llist_for_each_safe(pos, n, node)			\
+	for ((pos) = (node); (pos) && ((n) = (pos)->next, true); (pos) = (n))
+
+#define __llist_for_each_mutable_internal(pos, tmp, node)		\
+	for (typeof(pos) tmp = ((pos) = (node)) ? (pos)->next : NULL;	\
+	     (pos);							\
+	     (pos) = tmp, tmp = (pos) ? (pos)->next : NULL)
+
+#define __llist_for_each_mutable1(pos, node)				\
+	__llist_for_each_mutable_internal(pos, __UNIQUE_ID(next), node)
+
+#define __llist_for_each_mutable2(pos, next, node)			\
+	llist_for_each_safe(pos, next, node)
+
 /**
- * llist_for_each_safe - iterate over some deleted entries of a lock-less list
- *			 safe against removal of list entry
+ * llist_for_each_mutable - iterate over some deleted entries of a lock-less list
+ *			    safe against removal of list entry
  * @pos:	the &struct llist_node to use as a loop cursor
- * @n:		another &struct llist_node to use as temporary storage
- * @node:	the first entry of deleted list entries
+ * @...:	either (node) or (next, node)
+ *
+ * next:	another &struct llist_node to use as optional temporary storage.
+ *		The temporary cursor is internal unless explicitly supplied by
+ *		the caller.
+ * node:	the first entry of deleted list entries
  *
  * In general, some entries of the lock-less list can be traversed
  * safely only after being deleted from list, so start with an entry
@@ -159,8 +181,9 @@ static inline bool llist_on_list(const struct llist_node *node)
  * you want to traverse from the oldest to the newest, you must
  * reverse the order by yourself before traversing.
  */
-#define llist_for_each_safe(pos, n, node)			\
-	for ((pos) = (node); (pos) && ((n) = (pos)->next, true); (pos) = (n))
+#define llist_for_each_mutable(pos, ...)				\
+	CONCATENATE(__llist_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
+		(pos, __VA_ARGS__)
 
 /**
  * llist_for_each_entry - iterate over some deleted entries of lock-less list of given type
@@ -182,13 +205,41 @@ static inline bool llist_on_list(const struct llist_node *node)
 	     member_address_is_nonnull(pos, member);			\
 	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
 
+/*
+ * llist_for_each_entry_safe is an old interface, use llist_for_each_entry_mutable instead.
+ */
+#define llist_for_each_entry_safe(pos, n, node, member)			       \
+	for (pos = llist_entry((node), typeof(*pos), member);		       \
+	     member_address_is_nonnull(pos, member) &&			       \
+	        (n = llist_entry(pos->member.next, typeof(*n), member), true); \
+	     pos = n)
+
+#define __llist_for_each_entry_mutable_internal(pos, tmp, node, member)	\
+	for (typeof(pos) tmp = ((pos) = llist_entry((node), typeof(*pos), member), \
+		member_address_is_nonnull(pos, member) ?			\
+		llist_entry((pos)->member.next, typeof(*pos), member) : NULL);	\
+	     member_address_is_nonnull(pos, member);				\
+	     (pos) = tmp, tmp = member_address_is_nonnull(pos, member) ?	\
+		llist_entry((pos)->member.next, typeof(*pos), member) : NULL)
+
+#define __llist_for_each_entry_mutable2(pos, node, member)			\
+	__llist_for_each_entry_mutable_internal(pos, __UNIQUE_ID(next), node, member)
+
+#define __llist_for_each_entry_mutable3(pos, next, node, member)		\
+	llist_for_each_entry_safe(pos, next, node, member)
+
 /**
- * llist_for_each_entry_safe - iterate over some deleted entries of lock-less list of given type
- *			       safe against removal of list entry
+ * llist_for_each_entry_mutable - iterate over some deleted entries of
+ *				  lock-less list of given type safe against
+ *				  removal of list entry
  * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @node:	the first entry of deleted list entries.
- * @member:	the name of the llist_node with the struct.
+ * @...:	either (node, member) or (next, node, member)
+ *
+ * next:	another type * to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * node:	the first entry of deleted list entries.
+ * member:	the name of the llist_node with the struct.
  *
  * In general, some entries of the lock-less list can be traversed
  * safely only after being removed from list, so start with an entry
@@ -199,11 +250,9 @@ static inline bool llist_on_list(const struct llist_node *node)
  * you want to traverse from the oldest to the newest, you must
  * reverse the order by yourself before traversing.
  */
-#define llist_for_each_entry_safe(pos, n, node, member)			       \
-	for (pos = llist_entry((node), typeof(*pos), member);		       \
-	     member_address_is_nonnull(pos, member) &&			       \
-	        (n = llist_entry(pos->member.next, typeof(*n), member), true); \
-	     pos = n)
+#define llist_for_each_entry_mutable(pos, ...)				\
+	CONCATENATE(__llist_for_each_entry_mutable,			\
+		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
 
 /**
  * llist_empty - tests whether a lock-less list is empty
-- 
2.43.0


