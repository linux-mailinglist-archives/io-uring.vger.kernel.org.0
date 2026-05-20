Return-Path: <io-uring+bounces-13444-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +J/KJBEoDWo8twUAu9opvQ
	(envelope-from <io-uring+bounces-13444-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 05:18:41 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 175AE58725E
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 05:18:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2760B300D6B8
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 03:12:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B679233262B;
	Wed, 20 May 2026 03:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="q5T3XNGC"
X-Original-To: io-uring@vger.kernel.org
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C7A233928
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 03:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.230.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779246778; cv=none; b=Rd49Xh6gQqQr861zpYNxIW+LO9N9GqEamiX3Ma0wdLmL5kQndE4e9wJdcc/HMly6RWbdtwCFHNSwZA1j/JUkfNz57MFisuT+8OTmCPGubdw9JHFQhZFv+L46reaUCkMpT1nt8CkpuTnU7srpPUh2zNzNIkVgMX3LuPqD9xhhpZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779246778; c=relaxed/simple;
	bh=4kswOfJ8zplxamkSlkSU4EKq1VQgkxSaZpC5XtjK3Nw=;
	h=Subject:Date:Cc:Message-Id:From:Content-Type:Mime-Version:To; b=q8xSdZXR+Ai64jKFyTMBLGwS5D9MAiwW0xlmXmOsv/PnM6Te7sOWeJBP6oOEji0Y+zLQqg7qZtcSUkK0AKWD8kBiUMGWIFx/fYUL4I7zLUpSk8IYqelhKExzZ6DstH0ubD46VtNsdFiW3I84IfW6603JKU7vYBgMdI1cGApp0Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=q5T3XNGC; arc=none smtp.client-ip=209.127.230.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1779246758; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=IQ7y2fxQ8vi9WDE9NC6Cwvxpaz8UFof8AhP2kZMCzXU=;
 b=q5T3XNGCVe1T0BXbuxYgcJiWsQRpOIMIrLDLv3/Ye2mEhUmvmOdEGcV6Xs3rf+0jYWSkBS
 3FYcBNkTVsU1RR8k94R80U3wUT0Pferyg83D+Esrt42aO2K/U9F3oyV5JyUbGQ9WgmcOqL
 LbP58rT8oc++jKSVeOjoeAKrIaPUTKhrmrnewwTZmeBLXu+QWmmMzTGR+uSrAFiOGla9x9
 oKXpqXwf14lSYzZfDk053fNciratfpdN2EMrp2bWNB2Ov3Lu0Q+lznnX6p7Vg2WOwnkegR
 7w1WobcDHa6VW1nAvf7EgLcmD9iBd2fFW3/55bLTs4qCHNWH5ni8ku3ZZwpytQ==
Subject: [PATCH] io_uring/io-wq: avoid repeated task_work scans during teardown
Date: Wed, 20 May 2026 11:12:21 +0800
X-Original-From: Fengnan Chang <changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Cc: "Fengnan Chang" <changfengnan@bytedance.com>
Message-Id: <20260520031221.83210-1-changfengnan@bytedance.com>
X-Lms-Return-Path: <lba+26a0d26a4+ea906d+vger.kernel.org+changfengnan@bytedance.com>
From: "Fengnan Chang" <changfengnan@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
To: <axboe@kernel.dk>, <io-uring@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <peterz@infradead.org>, 
	<rostedt@goodmis.org>
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[bytedance.com,quarantine];
	R_DKIM_ALLOW(-0.20)[bytedance.com:s=2212171451];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13444-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[changfengnan@bytedance.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[bytedance.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Queue-Id: 175AE58725E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

We hit hard-lockup reports from iou-wrk threads stuck in
task_work_cancel_match() during io-wq teardown in syzkaller test.
The root cause is that teardown repeatedly rescans the submitter task's
full task_work list under pi_lock, once per matched item.

Two spots are problematic:

1) io_wq_cancel_tw_create() loops calling task_work_cancel_match() to
   remove worker-creation callbacks one at a time. Each call re-walks
   the entire list from scratch while holding pi_lock.

2) io_worker_exit() unconditionally scans the submitter task_work list
   for its own create_work, even when it never queued one. With many
   workers exiting simultaneously against a large unrelated task_work
   list, this adds up fast.

Fix (1) by adding task_work_cancel_match_all() that unlinks all matching
callbacks in a single traversal, then iterating the returned list locally.
Same try_cmpxchg() synchronisation as before, stops at the work_exited
sentinel.

Fix (2) by skipping the cancel entirely unless create_state indicates a
pending create_work. Since create_state is exclusively owned via
test_and_set_bit_lock, at most one callback can be queued per worker, so
the cancel is also simplified from a loop to a single call.

With this fix the reproducer (FIFO-open + MSG_RING SEND_FD stress) no
longer triggers hard-lockup reports, and task_work_cancel_match samples
drop to microseconds.

Fixes: c80ca4707d1a ("io-wq: cancel task_work on exit only targeting the cu=
rrent 'wq'")
Fixes: 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency")
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 include/linux/task_work.h |  3 +++
 io_uring/io-wq.c          | 23 +++++++++++-------
 kernel/task_work.c        | 51 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 9 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 0646804860ff1..fb39d18c7c1fe 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -31,6 +31,9 @@ int task_work_add(struct task_struct *task, struct callba=
ck_head *twork,
=20
 struct callback_head *task_work_cancel_match(struct task_struct *task,
 	bool (*match)(struct callback_head *, void *data), void *data);
+struct callback_head *
+task_work_cancel_match_all(struct task_struct *task,
+			   bool (*match)(struct callback_head *, void *data), void *data);
 struct callback_head *task_work_cancel_func(struct task_struct *, task_wor=
k_func_t);
 bool task_work_cancel(struct task_struct *task, struct callback_head *cb);
 void task_work_run(void);
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 7a9f94a0ce6f2..58144bd5891fa 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -234,13 +234,15 @@ static void io_worker_exit(struct io_worker *worker)
 	struct io_wq *wq =3D worker->wq;
 	struct io_wq_acct *acct =3D io_wq_get_acct(worker);
=20
-	while (1) {
-		struct callback_head *cb =3D task_work_cancel_match(wq->task,
-						io_task_worker_match, worker);
-
-		if (!cb)
-			break;
-		io_worker_cancel_cb(worker);
+	if (test_bit(0, &worker->create_state)) {
+		/*
+		 * create_state is exclusively owned via test_and_set_bit_lock,
+		 * so at most one create_work can be pending per worker =E2=80=94 a
+		 * single cancel attempt is sufficient here.
+		 */
+		if (task_work_cancel_match(wq->task, io_task_worker_match,
+					   worker))
+			io_worker_cancel_cb(worker);
 	}
=20
 	io_worker_release(worker);
@@ -1319,11 +1321,13 @@ void io_wq_exit_start(struct io_wq *wq)
=20
 static void io_wq_cancel_tw_create(struct io_wq *wq)
 {
-	struct callback_head *cb;
+	struct callback_head *cb, *next;
=20
-	while ((cb =3D task_work_cancel_match(wq->task, io_task_work_match, wq)) =
!=3D NULL) {
+	cb =3D task_work_cancel_match_all(wq->task, io_task_work_match, wq);
+	while (cb) {
 		struct io_worker *worker;
=20
+		next =3D cb->next;
 		worker =3D container_of(cb, struct io_worker, create_work);
 		io_worker_cancel_cb(worker);
 		/*
@@ -1332,6 +1336,7 @@ static void io_wq_cancel_tw_create(struct io_wq *wq)
 		 */
 		if (cb->func =3D=3D create_worker_cont)
 			kfree(worker);
+		cb =3D next;
 	}
 }
=20
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 0f7519f8e7c93..c133f6988e844 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -143,6 +143,57 @@ task_work_cancel_match(struct task_struct *task,
 	return work;
 }
=20
+/**
+ * task_work_cancel_match_all - cancel all pending works matching @match
+ * @task: the task which should execute the work
+ * @match: match function to call
+ * @data: data to be passed in to match function
+ *
+ * Removes all currently queued matching works in one traversal.  The retu=
rned
+ * callbacks are linked through ->next in their original queue order.  Thi=
s is
+ * useful for teardown paths that need to cancel many callbacks of the sam=
e
+ * class without repeatedly rescanning the whole task_work list under
+ * task->pi_lock.
+ *
+ * RETURNS:
+ * The first found work or NULL if not found.
+ */
+struct callback_head *
+task_work_cancel_match_all(struct task_struct *task,
+			   bool (*match)(struct callback_head *, void *data),
+			   void *data)
+{
+	struct callback_head **pprev =3D &task->task_works;
+	struct callback_head *work, *next;
+	struct callback_head *head =3D NULL, **tail =3D &head;
+	unsigned long flags;
+
+	if (likely(!task_work_pending(task)))
+		return NULL;
+
+	raw_spin_lock_irqsave(&task->pi_lock, flags);
+	work =3D READ_ONCE(*pprev);
+	while (work && work !=3D &work_exited) {
+		next =3D READ_ONCE(work->next);
+		if (!match(work, data)) {
+			pprev =3D &work->next;
+			work =3D next;
+			continue;
+		}
+
+		if (!try_cmpxchg(pprev, &work, next))
+			continue;
+
+		work->next =3D NULL;
+		*tail =3D work;
+		tail =3D &work->next;
+		work =3D next;
+	}
+	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
+
+	return head;
+}
+
 static bool task_work_func_match(struct callback_head *cb, void *data)
 {
 	return cb->func =3D=3D data;
--=20
2.39.5 (Apple Git-154)

