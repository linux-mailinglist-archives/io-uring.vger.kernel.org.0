Return-Path: <io-uring+bounces-8307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 946CFAD6065
	for <lists+io-uring@lfdr.de>; Wed, 11 Jun 2025 22:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33AFF1BC1A93
	for <lists+io-uring@lfdr.de>; Wed, 11 Jun 2025 20:54:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E35923AB8D;
	Wed, 11 Jun 2025 20:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="nHq78SQx"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7888185920
	for <io-uring@vger.kernel.org>; Wed, 11 Jun 2025 20:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.145.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749675244; cv=none; b=La1YibDJsBJH3i8l/pSsByjTG2ZnHwJow75GxVSv+Iq2osyRekwTEl3GH26GWmkSG6sKBQ1BTkiUlyLXRqFLnmFEvKf6HLe72WeJfpcVvw7NUVyb+K4ZwugJ3N4Lw6KtM19yHsebtS9XkWoRshorXSUq7UqEN0BPjst6o97PH/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749675244; c=relaxed/simple;
	bh=2dyPcJML6Dua83nRsnsXnf9GaZhRyY9bXKBcu00Kmqg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=nk6kNvIJ8PD7on0D0XpWRmd6Ma7CA4o4COP2t7buSOw8rdPLIqVPe7rJEPZFGUpv7Uvip3da+vkkPaoyHu1u75DDmXA2s/OfaLWps1qFZylk0Z+vlkzLn+FN8kzZ8UFAftLbGlfZ7qUN2FXiQTautLxzxBNAQOLRV7DQ2KCn7aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=nHq78SQx; arc=none smtp.client-ip=67.231.145.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55BKH4PV008496
	for <io-uring@vger.kernel.org>; Wed, 11 Jun 2025 13:54:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=sHd/eDSuvK7j3NsEhC
	2tiuQW2NtwNfKjnrdyqXYAsgo=; b=nHq78SQxD1v5n7dCbZGURqoEv6Af+7C5Qa
	FxzpPcQGSigkiCv+tt32ng6gHxutzVH0aqvG0qoTL181Qvo5E0l3lpO/jgCxGzvw
	IwkjWfg6JWNydo+BXJAEc0pF1y2j+/eeXh8Shi4U8ADHICZhj/UgjSqV4QKXWAfY
	5hwATxNgKGZqkSq0o13B9ngGVymA7pyoyGLFl7vtKljUWvflTz2CwI13cxCa65tK
	8aAqUc5yUtvWA8ett382ejBEB6juHsaH0qMvrlJv/EMggKGHm10DC6Zymw3At6hK
	pn1wyZtmnT5lfx2r76B085IO6dl/kU6Rm0+7KjHlrwmbZiEEYTpg==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 476yf9q4wv-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Wed, 11 Jun 2025 13:54:01 -0700 (PDT)
Received: from twshared15756.17.prn3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.24; Wed, 11 Jun 2025 20:53:58 +0000
Received: by devbig1708.prn1.facebook.com (Postfix, from userid 544533)
	id 3BA441105A2; Wed, 11 Jun 2025 13:53:44 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>, <axboe@kernel.dk>
CC: <superman.xpt@gmail.com>, Keith Busch <kbusch@kernel.org>
Subject: [PATCHv2] io_uring: consistently use rcu semantics with sqpoll thread
Date: Wed, 11 Jun 2025 13:53:43 -0700
Message-ID: <20250611205343.1821117-1-kbusch@meta.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 9EX6OsN-tNXWee4oncn8SeSSWdsrJhIZ
X-Proofpoint-ORIG-GUID: 9EX6OsN-tNXWee4oncn8SeSSWdsrJhIZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjExMDE3NyBTYWx0ZWRfX9FeSzltWzthB xVvigQNbFIaLm6hEUUD0rLJAoFdOQbltjNTxfXxNeXP9obp+z9BXXzZ8MTGFhVc2c5bcXWmZ7lu Pp3I4cmd+LqHxnWylIsgjJGhNgnwMmwjFGbUF4vkKWVlkwFv6I3zIveNWG3IOe1g3P1B4XUZttj
 FzvRJHBYfX5lm4w3Kp7EMmdWeE69fmhNfWeCEao/Kw1+HxGlr8ElIq3igXOV6DYidBxlxu5wht6 taHB1BuzuyDtzo0fTPJfg4fq7ultxfpHbquEUAogjs7R4IIFPp5oWrWiaXXfTguNDX2VIfkYDvJ EDD4ScKRLR4nN0i0HKmKkrczKdfC7SOcpyi7Ua9zw2vdmGBR5/oCUhO9zfdCoPtmDOizwptPB2I
 0v/6uKmi3k830cqE14jndWkIQJ5KpKggfGO+XftjA5e4t9Z7OMXvkac3r3MKTzgiMwSKB4tF
X-Authority-Analysis: v=2.4 cv=Maxsu4/f c=1 sm=1 tr=0 ts=6849ece9 cx=c_pps a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=HAX7EVaDw1xFjUa2OAwA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-11_09,2025-06-10_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

The sqpoll thread is dereferenced with rcu read protection in one place,
so it needs to be annotated as an __rcu type, and should consistently
use rcu helpers for access and assignment to make sparse happy.

Since most of the accesses occur under the sqd->lock, we can use
rcu_dereference_protected() without declaring an rcu read section.
Provide a simple helper to get the thread from a locked context.

Fixes: ac0b8b327a5677d ("io_uring: fix use-after-free of sq->thread in __=
io_uring_show_fdinfo()")
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/io_uring.c |  4 ++--
 io_uring/sqpoll.c   | 34 ++++++++++++++++++++++++----------
 io_uring/sqpoll.h   |  8 +++++++-
 3 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf759c172083c..4e32f808d07df 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2906,7 +2906,7 @@ static __cold void io_ring_exit_work(struct work_st=
ruct *work)
 			struct task_struct *tsk;
=20
 			io_sq_thread_park(sqd);
-			tsk =3D sqd->thread;
+			tsk =3D sqpoll_task_locked(sqd);
 			if (tsk && tsk->io_uring && tsk->io_uring->io_wq)
 				io_wq_cancel_cb(tsk->io_uring->io_wq,
 						io_cancel_ctx_cb, ctx, true);
@@ -3142,7 +3142,7 @@ __cold void io_uring_cancel_generic(bool cancel_all=
, struct io_sq_data *sqd)
 	s64 inflight;
 	DEFINE_WAIT(wait);
=20
-	WARN_ON_ONCE(sqd && sqd->thread !=3D current);
+	WARN_ON_ONCE(sqd && sqpoll_task_locked(sqd) !=3D current);
=20
 	if (!current->io_uring)
 		return;
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 0625a421626f4..268d2fbe6160c 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -30,7 +30,7 @@ enum {
 void io_sq_thread_unpark(struct io_sq_data *sqd)
 	__releases(&sqd->lock)
 {
-	WARN_ON_ONCE(sqd->thread =3D=3D current);
+	WARN_ON_ONCE(sqpoll_task_locked(sqd) =3D=3D current);
=20
 	/*
 	 * Do the dance but not conditional clear_bit() because it'd race with
@@ -46,24 +46,32 @@ void io_sq_thread_unpark(struct io_sq_data *sqd)
 void io_sq_thread_park(struct io_sq_data *sqd)
 	__acquires(&sqd->lock)
 {
-	WARN_ON_ONCE(data_race(sqd->thread) =3D=3D current);
+	struct task_struct *tsk;
=20
 	atomic_inc(&sqd->park_pending);
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	mutex_lock(&sqd->lock);
-	if (sqd->thread)
-		wake_up_process(sqd->thread);
+
+	tsk =3D sqpoll_task_locked(sqd);
+	if (tsk) {
+		WARN_ON_ONCE(tsk =3D=3D current);
+		wake_up_process(tsk);
+	}
 }
=20
 void io_sq_thread_stop(struct io_sq_data *sqd)
 {
-	WARN_ON_ONCE(sqd->thread =3D=3D current);
+	struct task_struct *tsk;
+
 	WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state));
=20
 	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	mutex_lock(&sqd->lock);
-	if (sqd->thread)
-		wake_up_process(sqd->thread);
+	tsk =3D sqpoll_task_locked(sqd);
+	if (tsk) {
+		WARN_ON_ONCE(tsk =3D=3D current);
+		wake_up_process(tsk);
+	}
 	mutex_unlock(&sqd->lock);
 	wait_for_completion(&sqd->exited);
 }
@@ -486,7 +494,10 @@ __cold int io_sq_offload_create(struct io_ring_ctx *=
ctx,
 			goto err_sqpoll;
 		}
=20
-		sqd->thread =3D tsk;
+		mutex_lock(&sqd->lock);
+		rcu_assign_pointer(sqd->thread, tsk);
+		mutex_unlock(&sqd->lock);
+
 		task_to_put =3D get_task_struct(tsk);
 		ret =3D io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
@@ -514,10 +525,13 @@ __cold int io_sqpoll_wq_cpu_affinity(struct io_ring=
_ctx *ctx,
 	int ret =3D -EINVAL;
=20
 	if (sqd) {
+		struct task_struct *tsk;
+
 		io_sq_thread_park(sqd);
 		/* Don't set affinity for a dying thread */
-		if (sqd->thread)
-			ret =3D io_wq_cpu_affinity(sqd->thread->io_uring, mask);
+		tsk =3D sqpoll_task_locked(sqd);
+		if (tsk)
+			ret =3D io_wq_cpu_affinity(tsk->io_uring, mask);
 		io_sq_thread_unpark(sqd);
 	}
=20
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 4171666b1cf4c..b83dcdec9765f 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -8,7 +8,7 @@ struct io_sq_data {
 	/* ctx's that are using this sqd */
 	struct list_head	ctx_list;
=20
-	struct task_struct	*thread;
+	struct task_struct __rcu *thread;
 	struct wait_queue_head	wait;
=20
 	unsigned		sq_thread_idle;
@@ -29,3 +29,9 @@ void io_sq_thread_unpark(struct io_sq_data *sqd);
 void io_put_sq_data(struct io_sq_data *sqd);
 void io_sqpoll_wait_sq(struct io_ring_ctx *ctx);
 int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx, cpumask_var_t mas=
k);
+
+static inline struct task_struct *sqpoll_task_locked(struct io_sq_data *=
sqd)
+{
+	return rcu_dereference_protected(sqd->thread,
+					 lockdep_is_held(&sqd->lock));
+}
--=20
2.47.1


