Return-Path: <io-uring+bounces-4023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 076BD9B022E
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:23:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A7C581F2347B
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 12:23:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA86420263D;
	Fri, 25 Oct 2024 12:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SWZXlZFt"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ADBB1E1A39
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 12:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729858996; cv=none; b=MT4UBybrYlE2iSIlagMkzs9GZcCYTGubAvZQLWTh+SIinIrUvYYnnpN0I9c5bZk4gR2Cxo1gW1iT0MvNgxFexKx6HQEF8EEYPSQAhjB8h5qg9DqqzY9Ahk8xNzJYJAfJMhrvu8A+eTH6fvwdOD/1mw60BdJcY4pkHhNx9GZSKVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729858996; c=relaxed/simple;
	bh=z3vjFtkyi8S1A7ur2dmbu1WFpyaXcQe4CCIPF5e6/Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+qYED0sNEs0A23EzTSvZuE3n3pzyc5de+ZxFGisH2NQVcHCUFvw+nGLdoyG9ASG7NH8h+pHTQoudXEmcekVKL0OysnZnjFGY3s93eqKO45vrx0QGBc/UrioSMn3oseMKQnnwu7beisvHI3wVOXU5X+xGFEcN3z6iJUq1+BCY7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SWZXlZFt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729858993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PO8uGQ7tOYm3CIZufgCXnY8v91zqH0P/3o10fpPhS8s=;
	b=SWZXlZFtRKnE+UsQAQdHqaEK0rNPljVu/AdVS5QxMXMbwXLb60w7fQxvOEL/3zOrdKmYR/
	8LdgkbhPmweEkBtG7me88NhVLQonLWXgvIrG65vP5JuJ3qm0vTa1Cacqyk1DZPFdcvkrIm
	mFo1fVck+Kju7B4wxcCMtPk4bVrXtvQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-5AqOSgdLP2alENJAioQPFg-1; Fri,
 25 Oct 2024 08:23:10 -0400
X-MC-Unique: 5AqOSgdLP2alENJAioQPFg-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EF711955F67;
	Fri, 25 Oct 2024 12:23:09 +0000 (UTC)
Received: from localhost (unknown [10.72.116.106])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E1DB819560A2;
	Fri, 25 Oct 2024 12:23:07 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V8 2/7] io_uring: add io_submit_fail_link() helper
Date: Fri, 25 Oct 2024 20:22:39 +0800
Message-ID: <20241025122247.3709133-3-ming.lei@redhat.com>
In-Reply-To: <20241025122247.3709133-1-ming.lei@redhat.com>
References: <20241025122247.3709133-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add io_submit_fail_link() helper and put linking fail logic into this
helper.

This way simplifies io_submit_fail_init(), and becomes easier to add
sqe group failing logic.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 02f7dd58d44d..749ecc18049d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2118,22 +2118,17 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	return def->prep(req, sqe);
 }
 
-static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
+static __cold int io_submit_fail_link(struct io_submit_link *link,
 				      struct io_kiocb *req, int ret)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_submit_link *link = &ctx->submit_state.link;
 	struct io_kiocb *head = link->head;
 
-	trace_io_uring_req_failed(sqe, req, ret);
-
 	/*
 	 * Avoid breaking links in the middle as it renders links with SQPOLL
 	 * unusable. Instead of failing eagerly, continue assembling the link if
 	 * applicable and mark the head with REQ_F_FAIL. The link flushing code
 	 * should find the flag and handle the rest.
 	 */
-	req_fail_link_node(req, ret);
 	if (head && !(head->flags & REQ_F_FAIL))
 		req_fail_link_node(head, -ECANCELED);
 
@@ -2152,9 +2147,24 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 	else
 		link->head = req;
 	link->last = req;
+
 	return 0;
 }
 
+static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
+				      struct io_kiocb *req, int ret)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_submit_link *link = &ctx->submit_state.link;
+
+	trace_io_uring_req_failed(sqe, req, ret);
+
+	req_fail_link_node(req, ret);
+
+	/* cover both linked and non-linked request */
+	return io_submit_fail_link(link, req, ret);
+}
+
 /*
  * Return NULL if nothing to be queued, otherwise return request for queueing */
 static struct io_kiocb *io_link_sqe(struct io_submit_link *link,
-- 
2.46.0


