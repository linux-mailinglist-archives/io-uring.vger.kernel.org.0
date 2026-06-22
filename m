Return-Path: <io-uring+bounces-13805-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id lVoFNhm9OGomhQcAu9opvQ
	(envelope-from <io-uring+bounces-13805-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 06:42:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C21816AC8FB
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 06:42:00 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=linux.dev header.s=key1 header.b=om1iuvj2;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13805-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13805-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=none) header.from=linux.dev;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DDBA93004058
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2026 04:41:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 714E13502A9;
	Mon, 22 Jun 2026 04:41:56 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B2B346ACD
	for <io-uring@vger.kernel.org>; Mon, 22 Jun 2026 04:41:54 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782103316; cv=none; b=K1VR3/ccj8Na9HRCulcYZYLYwffViHm0d9EZi6KCj+ffJUGZppQOJqqWsCRkQKOw23K6JdvVkpE/5Sf0Db0OMM8frqHVoIPJiUtjaOc/IebqYZamdP9FIvlet8wITBGmLSwQEmcwgQsa7Aqdzuk6cMAZ7/6wVyD5KSPfD33I2nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782103316; c=relaxed/simple;
	bh=wjf8fqze3+/0K/F+EzyayABkO69qoX1Qp2gt4bAu1XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jEolorkkD/W4Cv2tmtYjnCR5EJUkUHVm7hvX1FRqn3z5gvOKxnsU3tpXdhXIetEit5yEZkGJmPmIyoG+IjashgErm0x8q1ePzTl1fq6xf/3w/Bu5+NDe3cu5AnCGQFHsI3cGa99KtS3T0vVxmOE/pYmEnKN1exX/QopfDbN7bh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=om1iuvj2; arc=none smtp.client-ip=91.218.175.186
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782103313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c79vspB2QRNnw0LWMRq4lM7IqPNNV4DH4/iJQU9Iass=;
	b=om1iuvj2oy7tABnAvLEyDw+EI87L/++7ytv0a6lMtWOlzeQUqDWUwGIQo0sWOa8TrniHEg
	vMuizXXn19yj2Fc1EX9f+2yfGkBcLKePOKOQuiJFH3i9JozQjfkN1ri/BCFicNKwkadLxR
	m2CmeqpgqwEpLE24Xdocv7W2Y5bsf0Q=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 7/7] io_uring: Use mutable list iterators
Date: Mon, 22 Jun 2026 12:41:02 +0800
Message-ID: <20260622044102.32677-1-kaitao.cheng@linux.dev>
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
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:chengkaitao@kylinos.cn,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13805-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kaitao.cheng@linux.dev,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C21816AC8FB

From: Kaitao Cheng <chengkaitao@kylinos.cn>

The safe list iterators require callers to provide a temporary cursor
even when the cursor is only used by the iterator itself.  The mutable
iterator variants keep the same removal-safe traversal semantics while
allowing those internal cursors to be hidden from the call sites.

Convert io_uring users of list and hlist safe iterators to the new
mutable helpers.  Drop the now-unused temporary cursor variables where
the loop body does not inspect or reset them.

This is a mechanical cleanup with no intended change in traversal order
or list mutation behavior.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 io_uring/cancel.c    | 6 ++----
 io_uring/poll.c      | 3 +--
 io_uring/rw.c        | 4 ++--
 io_uring/timeout.c   | 8 ++++----
 io_uring/uring_cmd.c | 3 +--
 5 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 8c6fa6f367e4..2d5b27e64582 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -358,13 +358,12 @@ bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			  struct hlist_head *list, bool cancel_all,
 			  bool (*cancel)(struct io_kiocb *))
 {
-	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	bool found = false;
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	hlist_for_each_entry_safe(req, tmp, list, hash_node) {
+	hlist_for_each_entry_mutable(req, list, hash_node) {
 		if (!io_match_task_safe(req, tctx, cancel_all))
 			continue;
 		hlist_del_init(&req->hash_node);
@@ -379,12 +378,11 @@ int io_cancel_remove(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		     unsigned int issue_flags, struct hlist_head *list,
 		     bool (*cancel)(struct io_kiocb *))
 {
-	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	int nr = 0;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	hlist_for_each_entry_safe(req, tmp, list, hash_node) {
+	hlist_for_each_entry_mutable(req, list, hash_node) {
 		if (!io_cancel_req_match(req, cd))
 			continue;
 		if (cancel(req))
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0204affdc308..2b8d15fe1227 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -734,7 +734,6 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tc
 			       bool cancel_all)
 {
 	unsigned nr_buckets = 1U << ctx->cancel_table.hash_bits;
-	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	bool found = false;
 	int i;
@@ -744,7 +743,7 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tc
 	for (i = 0; i < nr_buckets; i++) {
 		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
 
-		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
+		hlist_for_each_entry_mutable(req, &hb->list, hash_node) {
 			if (io_match_task_safe(req, tctx, cancel_all)) {
 				hlist_del_init(&req->hash_node);
 				io_poll_cancel_req(req);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 63b6519e498c..25b896269e87 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1326,7 +1326,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	unsigned int poll_flags = 0;
 	DEFINE_IO_COMP_BATCH(iob);
-	struct io_kiocb *req, *tmp;
+	struct io_kiocb *req;
 	int nr_events = 0;
 
 	/*
@@ -1372,7 +1372,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	if (!rq_list_empty(&iob.req_list))
 		iob.complete(&iob);
 
-	list_for_each_entry_safe(req, tmp, &ctx->iopoll_list, iopoll_node) {
+	list_for_each_entry_mutable(req, &ctx->iopoll_list, iopoll_node) {
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			continue;
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index c4dd26cf342d..63671231cb08 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -164,14 +164,14 @@ static void io_kill_timeout(struct io_kiocb *req, struct list_head *list)
 
 __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
 {
-	struct io_timeout *timeout, *tmp;
+	struct io_timeout *timeout;
 	LIST_HEAD(list);
 	u32 seq;
 
 	raw_spin_lock_irq(&ctx->timeout_lock);
 	seq = READ_ONCE(ctx->cached_cq_tail) - atomic_read(&ctx->cq_timeouts);
 
-	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
+	list_for_each_entry_mutable(timeout, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 		u32 events_needed, events_got;
 
@@ -733,7 +733,7 @@ static bool io_match_task(struct io_kiocb *head, struct io_uring_task *tctx,
 __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			     bool cancel_all)
 {
-	struct io_timeout *timeout, *tmp;
+	struct io_timeout *timeout;
 	LIST_HEAD(list);
 
 	/*
@@ -742,7 +742,7 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct io_uring_task *tctx
 	 */
 	spin_lock(&ctx->completion_lock);
 	raw_spin_lock_irq(&ctx->timeout_lock);
-	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
+	list_for_each_entry_mutable(timeout, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 
 		if (io_match_task(req, tctx, cancel_all))
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 7b25dcd9d05f..ce6f4fe93b20 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -49,13 +49,12 @@ void io_uring_cmd_cleanup(struct io_kiocb *req)
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				   struct io_uring_task *tctx, bool cancel_all)
 {
-	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	bool ret = false;
 
 	lockdep_assert_held(&ctx->uring_lock);
 
-	hlist_for_each_entry_safe(req, tmp, &ctx->cancelable_uring_cmd,
+	hlist_for_each_entry_mutable(req, &ctx->cancelable_uring_cmd,
 			hash_node) {
 		struct io_uring_cmd *cmd = io_kiocb_to_cmd(req,
 				struct io_uring_cmd);
-- 
2.43.0


