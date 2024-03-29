Return-Path: <io-uring+bounces-1324-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 858FD8920CF
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41D94286622
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 15:47:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C40FB1C0DD4;
	Fri, 29 Mar 2024 15:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gjzejZL2"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A4025778
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 15:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711727272; cv=none; b=a2sHe/mr3HWZ1xkPw21m9asXpK4+rCJ15UeP1gsL5f5lcYOkmNMUqNmkMHBH2tQRfOtIfyw89RWjc1KhflEizxx3jwr6OpVscYnZqxuN9ZmbLN2tYFmn/Xw7riEL1dwjfQoDBsdpQvM47qL30S5Se9vs0NPj8mfpQHZe4wZEEC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711727272; c=relaxed/simple;
	bh=IC4TtRmPMzs0LfSFqt1ASMa1jqs8+KoT0nyvUzNEMSo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=EJZGzXPq/W1RO1ItTrcHHXjp/uEnNd+YlP7iNMM2c27H963spMyKYAS4mC5AUYWRStZ0ljowKrt4PXr394xnrMk93T1yGBvAhmwUFxT8xLvGmYsGzny7mvwj9s2IuiF5WNFLQ11dtkjnfD6xBNXR6c7K916zHRfqqyOrrHyxMTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gjzejZL2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711727269;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tkfTjfmZ6GFNprHXcMrHpO3RNF5KU9D+Nf0vYldunoc=;
	b=gjzejZL2OAj4+v+CNIMVbLWw30Zuc+JUTNI8uRkM1gA1WnMS/b/4HCDl3lBhyl0ngEBoMq
	tmQvm2OSrjzAe/MMNzzpDawwp+pX/opH1WfGd+TdcZEvBiwp8Mxz3NiRc4yq+DxjdizReg
	IaHJpfzg7ULS4bcGhTDaxQS9mpSZbVU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-221-hM_arud-P-GJTNhoX7co8Q-1; Fri, 29 Mar 2024 11:47:46 -0400
X-MC-Unique: hM_arud-P-GJTNhoX7co8Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E8F168007A2;
	Fri, 29 Mar 2024 15:47:45 +0000 (UTC)
Received: from localhost (unknown [10.72.116.18])
	by smtp.corp.redhat.com (Postfix) with ESMTP id EDF883C20;
	Fri, 29 Mar 2024 15:47:44 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH] io_uring: kill dead code in io_req_complete_post
Date: Fri, 29 Mar 2024 23:47:12 +0800
Message-ID: <20240329154712.1936153-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

Since commit 8f6c829491fe ("io_uring: remove struct io_tw_state::locked"),
io_req_complete_post() is only called from io-wq submit work, where the
request reference is guaranteed to be grabbed and won't drop to zero
in io_req_complete_post().

Kill the dead code, meantime add req_ref_put() to put the reference.

Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 37 ++-----------------------------------
 io_uring/refs.h     |  7 +++++++
 2 files changed, 9 insertions(+), 35 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 104899522bc5..ac2e5da4558a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -929,7 +929,6 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_rsrc_node *rsrc_node = NULL;
 
 	/*
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
@@ -946,42 +945,10 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 		if (!io_fill_cqe_req(ctx, req))
 			io_req_cqe_overflow(req);
 	}
-
-	/*
-	 * If we're the last reference to this request, add to our locked
-	 * free_list cache.
-	 */
-	if (req_ref_put_and_test(req)) {
-		if (req->flags & IO_REQ_LINK_FLAGS) {
-			if (req->flags & IO_DISARM_MASK)
-				io_disarm_next(req);
-			if (req->link) {
-				io_req_task_queue(req->link);
-				req->link = NULL;
-			}
-		}
-		io_put_kbuf_comp(req);
-		if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
-			io_clean_op(req);
-		io_put_file(req);
-
-		rsrc_node = req->rsrc_node;
-		/*
-		 * Selected buffer deallocation in io_clean_op() assumes that
-		 * we don't hold ->completion_lock. Clean them here to avoid
-		 * deadlocks.
-		 */
-		io_put_task_remote(req->task);
-		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
-		ctx->locked_free_nr++;
-	}
 	io_cq_unlock_post(ctx);
 
-	if (rsrc_node) {
-		io_ring_submit_lock(ctx, issue_flags);
-		io_put_rsrc_node(ctx, rsrc_node);
-		io_ring_submit_unlock(ctx, issue_flags);
-	}
+	/* called from io-wq submit work only, the ref won't drop to zero */
+	req_ref_put(req);
 }
 
 void io_req_defer_failed(struct io_kiocb *req, s32 res)
diff --git a/io_uring/refs.h b/io_uring/refs.h
index 1336de3f2a30..63982ead9f7d 100644
--- a/io_uring/refs.h
+++ b/io_uring/refs.h
@@ -33,6 +33,13 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
+static inline void req_ref_put(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
+	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
+	atomic_dec(&req->refs);
+}
+
 static inline void __io_req_set_refcount(struct io_kiocb *req, int nr)
 {
 	if (!(req->flags & REQ_F_REFCOUNT)) {
-- 
2.41.0


