Return-Path: <io-uring+bounces-4026-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C49809B0234
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:24:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 874452841C6
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 12:24:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8F091F9431;
	Fri, 25 Oct 2024 12:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fd2iPOuB"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79E5E1E1A39
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 12:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729859041; cv=none; b=WDvoEqDjqQ3s3Hc5x/cLbjMfaubAjWauScJ4y+0iinpNC9thAQ9V+cf5OBh/HB4pk8Xi5DKRsJZqUgjOYz5C0/W82I9aHWv555iA5i18V859QdQZKU7xf5L6fD1kwE/NLB3P7MKm8KgF+kejVXv1S/GS7jFnYwjKaTU/k2rBjgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729859041; c=relaxed/simple;
	bh=2lW3tx2drdKGhaeUZ2vPyduwEZzVpqIgcMsEP5dYjM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a6gyoyilngx+818AF7RFk7vEXhIZHGV/8FsrTppDHxiHxqamPfKSmWocqMu25CR/mLcbqAJLgGGeLwoqLkM+DdNASZIfaOFeLxJx+FOrRzIzLYvG115YBpRwIt/MYovAYFsSnZ0Hl/+QjFg50imw1L/uO56DyHqvnnJrkLX9+ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fd2iPOuB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729859038;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DIMBfrwdYfNOX2UOeCTE0NWQIo7aiZOeYzAIGl4DTI0=;
	b=fd2iPOuBCq+GFed2FC+JFBkJ2vKmQlR9nxKNW2h7qcYC20tcXcfMGaq5vVsjCWF92RiDVd
	RIgPDJePHQXUFF1nJIjFoQDPi1p7+roKxgboaaJs5EeRQpwSdqJ+xdi0I3DVEzOdeH9J6A
	P+6zqo57Zzz7JgyOS4hMR1bpNswiarQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-664--FMOeRDWPISgRPgoDVPnag-1; Fri,
 25 Oct 2024 08:23:57 -0400
X-MC-Unique: -FMOeRDWPISgRPgoDVPnag-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39464197904E;
	Fri, 25 Oct 2024 12:23:13 +0000 (UTC)
Received: from localhost (unknown [10.72.116.106])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 046101956088;
	Fri, 25 Oct 2024 12:23:11 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V8 3/7] io_uring: add helper of io_req_commit_cqe()
Date: Fri, 25 Oct 2024 20:22:40 +0800
Message-ID: <20241025122247.3709133-4-ming.lei@redhat.com>
In-Reply-To: <20241025122247.3709133-1-ming.lei@redhat.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Add helper of io_req_commit_cqe() for simplifying
__io_submit_flush_completions() a bit.

No functional change, and the added helper will be reused in sqe group
code with same lock rule.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 749ecc18049d..33856560ff87 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -898,6 +898,20 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	return posted;
 }
 
+static __always_inline void io_req_commit_cqe(struct io_ring_ctx *ctx,
+		struct io_kiocb *req)
+{
+	if (unlikely(!io_fill_cqe_req(ctx, req))) {
+		if (ctx->lockless_cq) {
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
@@ -1436,16 +1450,8 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
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
+			io_req_commit_cqe(ctx, req);
 	}
 	__io_cq_unlock_post(ctx);
 
-- 
2.46.0


