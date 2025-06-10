Return-Path: <io-uring+bounces-8301-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 42E4DAD42EA
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 21:30:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E8413A408D
	for <lists+io-uring@lfdr.de>; Tue, 10 Jun 2025 19:30:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0066B263F52;
	Tue, 10 Jun 2025 19:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b="ZkPlCIK+"
X-Original-To: io-uring@vger.kernel.org
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453111D9663
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 19:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.153.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749583845; cv=none; b=QcTe3qXgvGnwly/JssN/UTHYzOIXhsOqhZ2E57HgLmgpO5GdJiqkcNdzeMlFKYctQSoAH21y2RoE4znPQH1wtuUkGaW0bhksHRhUThXonagxZ4EinUcVkG8s43BTtxcaXfKzq+Yz+CFa71gjqJ7QqtovnGKf5JFN6Sc1iYyKupY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749583845; c=relaxed/simple;
	bh=sIHOlrBbhM+t1QCAhYC/OueNLdcHAXerOXm5uC//Z7Q=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=ljoMjVkOvlWYmfVu4fpn+5JMTQdjtlOCCI9q2SOER/oWXwKtgr2m8PDuP1xTPABiQiGokAIfrEbU+pLwJqnLZAu2XQMzfwYcrO8CP1Ro7bYRxKiiddfIohGOyX9Jsfv2AE5JZtlA/gKuQUtKnIrXklCQmMmRNi/MxUNQ8exIFHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com; spf=pass smtp.mailfrom=meta.com; dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.b=ZkPlCIK+; arc=none smtp.client-ip=67.231.153.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55AJJAgf006856
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 12:30:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=s2048-2021-q4; bh=yWONeWdLpy+4u/B7Rg
	wymF2j5hN0t5CRXawTaIqHTPA=; b=ZkPlCIK+mp6IgTfcnFsuQB7suGkgsxEA2i
	c5dAKJ2/3O29YBp7BvC8kcoLMkw/c5Uwiby6DYV4yO/sIqxJJvQsiEwUXbCDV3hR
	Z82G4NaY6cBxtUCVTMZshVeIzfTbnj1b0uLAJvhT8tQZKRzls3DIdkLdglkihuVP
	OH5qtWpIgj0eLLkGfpbd20BEzFNsYzhyBpIoOCfXBPqogXn6B7iugd4ga6BGOnjc
	tJv/b9zZwuLpMQY8xCA8VLMdwHaqvRUsbNkpfpm/HRG5p1x2qg3rF9vmXfHdX1lR
	K1p2lZVCoUar6dw0W+SGKreAWonRc+5ZHD6pxUFLynFm0IDOi6lg==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 476tfcg761-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <io-uring@vger.kernel.org>; Tue, 10 Jun 2025 12:30:43 -0700 (PDT)
Received: from twshared35278.32.frc3.facebook.com (2620:10d:c0a8:1c::11) by
 mail.thefacebook.com (2620:10d:c0a9:6f::8fd4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1748.24; Tue, 10 Jun 2025 19:30:41 +0000
Received: by devbig209.atn5.facebook.com (Postfix, from userid 544533)
	id C949185AB85; Tue, 10 Jun 2025 12:30:31 -0700 (PDT)
From: Keith Busch <kbusch@meta.com>
To: <io-uring@vger.kernel.org>
CC: <axboe@kernel.dk>, <superman.xpt@gmail.com>,
        Keith Busch
	<kbusch@kernel.org>
Subject: [PATCH] io_uring: consistently use rcu semantics with sqpoll thread
Date: Tue, 10 Jun 2025 12:30:28 -0700
Message-ID: <20250610193028.2032495-1-kbusch@meta.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEwMDE1OSBTYWx0ZWRfX+tvW7lPEmPn2 wSH9+BJzYLVnuaVLmo9pIdSBVzfjYEWYiyB9x6ueqoZ84hXANtnuYfNAT7gtavm8GxMKHIInluT lxt1s6pkjlnB3H3ibo3GwUEAPpo1AyR0rh8WnJcrEI5JqHn7DmSNskqlyv++SULa4W0OuTNQimS
 msTTgkhznX6T2tl18E0UmP8yaM8W187LP2qiGis4wiGigW9TJgGmfVvgdGzAjYJ0VCOHekEJ6pE PcdctnC36YiM+MZOGaTwAE4Vp6qw76ttAVtqm9d8ffbzt+pWcYKsoGkBnK8eJzb4riux09GkXaP 7igInN6Y5oxB2Ujy13/VIz6Cnj4wtvGwkM6D7/pxTzzZD6hQBSh/8ZcWV50GlPQjNutq4UwxKBX
 z+JnSICDaPZ7QBjn0tGqbGq3cTK0aT0Dod7pOxabAC0zl48ClxvSyk43Br5iOHbxWprpw3CN
X-Proofpoint-ORIG-GUID: INVd-Ulk1k-2JnVZl9BdBvVfdWOBZogb
X-Proofpoint-GUID: INVd-Ulk1k-2JnVZl9BdBvVfdWOBZogb
X-Authority-Analysis: v=2.4 cv=X81SKHTe c=1 sm=1 tr=0 ts=684887e3 cx=c_pps a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=R9wSGXSy0-88cy7IuDgA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-10_09,2025-06-10_01,2025-03-28_01

From: Keith Busch <kbusch@kernel.org>

It is already dereferenced with rcu read protection, so it needs to be
annotated as such, and consistently use rcu helpers for access and
assignment.

Fixes: ac0b8b327a5677d ("io_uring: fix use-after-free of sq->thread in __=
io_uring_show_fdinfo()")
Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 io_uring/sqpoll.c | 16 +++++++++-------
 io_uring/sqpoll.h |  2 +-
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 0625a421626f4..7c6d7de05e0a0 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -30,7 +30,7 @@ enum {
 void io_sq_thread_unpark(struct io_sq_data *sqd)
 	__releases(&sqd->lock)
 {
-	WARN_ON_ONCE(sqd->thread =3D=3D current);
+	WARN_ON_ONCE(rcu_access_pointer(sqd->thread) =3D=3D current);
=20
 	/*
 	 * Do the dance but not conditional clear_bit() because it'd race with
@@ -46,24 +46,24 @@ void io_sq_thread_unpark(struct io_sq_data *sqd)
 void io_sq_thread_park(struct io_sq_data *sqd)
 	__acquires(&sqd->lock)
 {
-	WARN_ON_ONCE(data_race(sqd->thread) =3D=3D current);
+	WARN_ON_ONCE(data_race(rcu_access_pointer(sqd->thread)) =3D=3D current)=
;
=20
 	atomic_inc(&sqd->park_pending);
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	mutex_lock(&sqd->lock);
 	if (sqd->thread)
-		wake_up_process(sqd->thread);
+		wake_up_process(rcu_access_pointer(sqd->thread));
 }
=20
 void io_sq_thread_stop(struct io_sq_data *sqd)
 {
-	WARN_ON_ONCE(sqd->thread =3D=3D current);
+	WARN_ON_ONCE(rcu_access_pointer(sqd->thread) =3D=3D current);
 	WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state));
=20
 	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	mutex_lock(&sqd->lock);
 	if (sqd->thread)
-		wake_up_process(sqd->thread);
+		wake_up_process(rcu_access_pointer(sqd->thread));
 	mutex_unlock(&sqd->lock);
 	wait_for_completion(&sqd->exited);
 }
@@ -486,7 +486,7 @@ __cold int io_sq_offload_create(struct io_ring_ctx *c=
tx,
 			goto err_sqpoll;
 		}
=20
-		sqd->thread =3D tsk;
+		rcu_assign_pointer(sqd->thread, tsk);
 		task_to_put =3D get_task_struct(tsk);
 		ret =3D io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
@@ -517,7 +517,9 @@ __cold int io_sqpoll_wq_cpu_affinity(struct io_ring_c=
tx *ctx,
 		io_sq_thread_park(sqd);
 		/* Don't set affinity for a dying thread */
 		if (sqd->thread)
-			ret =3D io_wq_cpu_affinity(sqd->thread->io_uring, mask);
+			ret =3D io_wq_cpu_affinity(
+				rcu_access_pointer(sqd->thread)->io_uring,
+				mask);
 		io_sq_thread_unpark(sqd);
 	}
=20
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 4171666b1cf4c..43f69d3cf2959 100644
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
--=20
2.47.1


