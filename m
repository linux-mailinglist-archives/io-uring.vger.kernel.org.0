Return-Path: <io-uring+bounces-11699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id E03E6D1D49A
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 09:57:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 262BC30281EA
	for <lists+io-uring@lfdr.de>; Wed, 14 Jan 2026 08:56:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80E5137F8DD;
	Wed, 14 Jan 2026 08:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JKL3B5fE"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFBC3803CF
	for <io-uring@vger.kernel.org>; Wed, 14 Jan 2026 08:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768380866; cv=none; b=p6xw7AyECYpOX05JIdQ/sjZNhwzayS9vhHKuVdPJYq/5oWjiFAIm3h2n4dm6gpc2XwM7NdhUzPOeG4ln4K2ap7Ub7lkAO9JTeoBrowyHeSnRwNpTp0G84Ve3PSqMwZfjIzN9STyi2CEnW0SSJjyZp0dIbTBeLMfJSNUSWXWb8F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768380866; c=relaxed/simple;
	bh=XyuABFG6/YRo1l0ISb8LvMu84znUkQz9OKE907BxwBM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q8SI81OHx9B2FVlrFL09BeqxW1WbXesBkL2BS5HoIcBjElgfN9DUroLUcYbFPtlta2V8h0yB7rg35ZYg/IP+m2tGnHGRsCRzrfCd1VT0uNFFJyKoVt3y+zQgwSfsg7h+fhrikoTdaJf5YHaytbZP+lufMaZgL7hGv6iDzp46CaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JKL3B5fE; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768380860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WwwD3IP8UdTkiyx/FhIRaihaea2NW0EMXNQqPAeK3Qo=;
	b=JKL3B5fETBaOz8pN+SwiBnZwchnJFk7ndZzmrNpjoUMB0z70psBR1fmqT06HdJmwnkSu6b
	YITrVWfk1fN1FsEHmaYCroJM7JImqfv0TJI+uroVdc7gPjaiygOQ2GyDJ5d/NoxvHooW/6
	38RPdDcrc6h8Xhi9H8Pq1YWKzf5WBzM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-628-Rj5V06gIPuC449-JydYMEg-1; Wed,
 14 Jan 2026 03:54:15 -0500
X-MC-Unique: Rj5V06gIPuC449-JydYMEg-1
X-Mimecast-MFC-AGG-ID: Rj5V06gIPuC449-JydYMEg_1768380854
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EA2DD195605A;
	Wed, 14 Jan 2026 08:54:13 +0000 (UTC)
Received: from localhost (unknown [10.72.116.198])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DAB74180066A;
	Wed, 14 Jan 2026 08:54:12 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	stable@vger.kernel.org
Subject: [PATCH] io_uring: move local task_work in exit cancel loop
Date: Wed, 14 Jan 2026 16:54:05 +0800
Message-ID: <20260114085405.346872-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

With IORING_SETUP_DEFER_TASKRUN, task work is queued to ctx->work_llist
(local work) rather than the fallback list. During io_ring_exit_work(),
io_move_task_work_from_local() was called once before the cancel loop,
moving work from work_llist to fallback_llist.

However, task work can be added to work_llist during the cancel loop
itself. There are two cases:

1) io_kill_timeouts() is called from io_uring_try_cancel_requests() to
cancel pending timeouts, and it adds task work via io_req_queue_tw_complete()
for each cancelled timeout:

2) URING_CMD requests like ublk can be completed via
io_uring_cmd_complete_in_task() from ublk_queue_rq() during canceling,
given ublk request queue is only quiesced when canceling the 1st uring_cmd.

Since io_allowed_defer_tw_run() returns false in io_ring_exit_work()
(kworker != submitter_task), io_run_local_work() is never invoked,
and the work_llist entries are never processed. This causes
io_uring_try_cancel_requests() to loop indefinitely, resulting in
100% CPU usage in kworker threads.

Fix this by moving io_move_task_work_from_local() inside the cancel
loop, ensuring any work on work_llist is moved to fallback before
each cancel attempt.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 87a87396e940..b7a077c11c21 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3003,12 +3003,12 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 			mutex_unlock(&ctx->uring_lock);
 		}
 
-		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-			io_move_task_work_from_local(ctx);
-
 		/* The SQPOLL thread never reaches this path */
-		while (io_uring_try_cancel_requests(ctx, NULL, true, false))
+		do {
+			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+				io_move_task_work_from_local(ctx);
 			cond_resched();
+		} while (io_uring_try_cancel_requests(ctx, NULL, true, false));
 
 		if (ctx->sq_data) {
 			struct io_sq_data *sqd = ctx->sq_data;
-- 
2.47.1


