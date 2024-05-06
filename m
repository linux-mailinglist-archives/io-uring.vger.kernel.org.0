Return-Path: <io-uring+bounces-1786-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C3458BD298
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 18:23:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 110BA1F21F56
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:23:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6C9515664B;
	Mon,  6 May 2024 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XMMZE71k"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5468A156645
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 16:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012611; cv=none; b=RuYxrPctoDLKjEGEx3Scp1hgrVeQEn8SnuvBS9zX8nN9TxRzmVs9muYYrEJ5T5UU9/eUE+daONhKsQTmNIv5v4BetY7aOFQcN7N9BjF2fUNmqoe7PyVsPsszokB3Sxqy+YRvvQLY1wpGWa6tPwBXwZkqdPv7SdNoTAZ521ZyGbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012611; c=relaxed/simple;
	bh=RUOhxvOtwKxi8yL0/dOuRGEplMbd+DYC0ZTrMyC7qtg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ahIErFSAVROVYf+YBRr5cNnQHzJj416tIFT7f+xB0fXqfXh9G04hcK+GEPHFjATzsjtkG0uxdHeERjNF6A5pi27cxYpoKpOwwsIaEOfGQFowUtZvRYAZ1nyJZCDKlopQu9l5lD99K7HFbG0Zo71NmbJvd09N9+IqMTcDFHRjIGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XMMZE71k; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715012609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wwBph75tjF3+qUTs7CgZePkK74u79ZtRZYo09Hj5YWg=;
	b=XMMZE71kfetvJeXFNhcD/EomTDMS/PJxd2A/mNfqtMa0Z5q5bOMcGaRZYUp/E5ucNICxI8
	myIDi3dZLvlasKWjsbSgiDHTROWq9RkM/tGtHUIofZrqF6iQ3XCC308VsFRA9UvR0sz69i
	TfhmnKiGs1ZxM8b+s9cu31sg9PLoimQ=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-512-SWj1qkrPNOa3K9Kt9FCLqg-1; Mon,
 06 May 2024 12:23:26 -0400
X-MC-Unique: SWj1qkrPNOa3K9Kt9FCLqg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4A8183C025D2;
	Mon,  6 May 2024 16:23:26 +0000 (UTC)
Received: from localhost (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTP id AB111EC683;
	Mon,  6 May 2024 16:23:25 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH V2 3/9] io_uring: add helper of io_req_commit_cqe()
Date: Tue,  7 May 2024 00:22:39 +0800
Message-ID: <20240506162251.3853781-4-ming.lei@redhat.com>
In-Reply-To: <20240506162251.3853781-1-ming.lei@redhat.com>
References: <20240506162251.3853781-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

Add helper of io_req_commit_cqe() which can be used in posting CQE
from both __io_submit_flush_completions() and io_req_complete_post().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d3b9988cdae4..e4be930e0f1e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -910,6 +910,22 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	return posted;
 }
 
+static __always_inline void io_req_commit_cqe(struct io_kiocb *req,
+		bool lockless_cq)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	if (unlikely(!io_fill_cqe_req(ctx, req))) {
+		if (lockless_cq) {
+			spin_lock(&ctx->completion_lock);
+			io_req_cqe_overflow(req);
+			spin_unlock(&ctx->completion_lock);
+		} else {
+			io_req_cqe_overflow(req);
+		}
+	}
+}
+
 static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -932,10 +948,8 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	}
 
 	io_cq_lock(ctx);
-	if (!(req->flags & REQ_F_CQE_SKIP)) {
-		if (!io_fill_cqe_req(ctx, req))
-			io_req_cqe_overflow(req);
-	}
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		io_req_commit_cqe(req, false);
 	io_cq_unlock_post(ctx);
 
 	/*
@@ -1454,16 +1468,8 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
 
-		if (!(req->flags & REQ_F_CQE_SKIP) &&
-		    unlikely(!io_fill_cqe_req(ctx, req))) {
-			if (ctx->lockless_cq) {
-				spin_lock(&ctx->completion_lock);
-				io_req_cqe_overflow(req);
-				spin_unlock(&ctx->completion_lock);
-			} else {
-				io_req_cqe_overflow(req);
-			}
-		}
+		if (!(req->flags & REQ_F_CQE_SKIP))
+			io_req_commit_cqe(req, ctx->lockless_cq);
 	}
 	__io_cq_unlock_post(ctx);
 
-- 
2.42.0


