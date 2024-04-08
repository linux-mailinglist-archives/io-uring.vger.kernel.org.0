Return-Path: <io-uring+bounces-1450-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A44789B4FD
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 03:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BE54F1F212DF
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:04:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B7AC63A;
	Mon,  8 Apr 2024 01:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Czm8M7/y"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B87A17EF
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 01:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712538251; cv=none; b=husszPJxylwetWMtriqj5LeE0b4xBmE0q8L2c23XyiKFm2TnKBMyHGcZRXfU9HONsB+kjbK2qE8JFM1bShf7POlP86+vv8d05ni1fywEBHSOifxs8xGEb3Cs4tHu4yjJymaUVPGiXDcDM2SdF55TIdOY8GG4uC9DoJHrO09qUIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712538251; c=relaxed/simple;
	bh=guAhS/Fnx0PSMY2Pw5vSYBO2D5nZIMb7GKoSEHwTMx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6qo6nqiHm7GXKIjgnB7M+H/uRdlkn3RLth3BbbmoJkJK9zs/cDQLDuqZQUEy7qXXptphGEd391xv8yw+bEAztq3mvmvSyp0zAFoU4o0TXQqLSubizN997uLO0FqflqWVZAQnUPIm/+tlGpIxRt/403HDZa+R/4GTrO2r+atIoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Czm8M7/y; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712538248;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eK5sUnEeiBFgGX0FYS4kDF4HFOxZuYXlVr4lMLlEA34=;
	b=Czm8M7/yML1retUXuCg7qT8cpYMVnvjIJmjFHwlHvcPwBzcUmvc0cnSgdMeu1dbgn4NZ0d
	TVGr2jY2j5LHlEMVNOTiGfJ+gYeBnI4hdjAqLmtZwkY2ra6XTCUvANRUBfJQ1qnFVXr//7
	DI9gBUwNiB6U2bu/o78e5P3CqxvZCdY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-536-6nY_BZUJMmio7HPMkqMbBw-1; Sun, 07 Apr 2024 21:04:05 -0400
X-MC-Unique: 6nY_BZUJMmio7HPMkqMbBw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 14FDA10499A1;
	Mon,  8 Apr 2024 01:04:04 +0000 (UTC)
Received: from localhost (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1ED1923D61;
	Mon,  8 Apr 2024 01:04:02 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/9] io_uring: add helper for filling cqes in __io_submit_flush_completions()
Date: Mon,  8 Apr 2024 09:03:16 +0800
Message-ID: <20240408010322.4104395-4-ming.lei@redhat.com>
In-Reply-To: <20240408010322.4104395-1-ming.lei@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

No functional change, and prepare for supporting SQE group.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6d4def11aebf..c73819c04c0b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1458,16 +1458,14 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 	} while (node);
 }
 
-void __io_submit_flush_completions(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
+static inline void io_fill_cqe_lists(struct io_ring_ctx *ctx,
+				     struct io_wq_work_list *list)
 {
-	struct io_submit_state *state = &ctx->submit_state;
 	struct io_wq_work_node *node;
 
-	__io_cq_lock(ctx);
-	__wq_list_for_each(node, &state->compl_reqs) {
+	__wq_list_for_each(node, list) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
-					    comp_list);
+						    comp_list);
 
 		if (!(req->flags & REQ_F_CQE_SKIP) &&
 		    unlikely(!io_fill_cqe_req(ctx, req))) {
@@ -1480,6 +1478,15 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			}
 		}
 	}
+}
+
+void __io_submit_flush_completions(struct io_ring_ctx *ctx)
+	__must_hold(&ctx->uring_lock)
+{
+	struct io_submit_state *state = &ctx->submit_state;
+
+	__io_cq_lock(ctx);
+	io_fill_cqe_lists(ctx, &state->compl_reqs);
 	__io_cq_unlock_post(ctx);
 
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
-- 
2.42.0


