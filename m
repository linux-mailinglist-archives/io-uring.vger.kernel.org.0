Return-Path: <io-uring+bounces-1785-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F5778BD295
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 18:23:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2493D1C226E0
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2988B155A4F;
	Mon,  6 May 2024 16:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M8E6vsaX"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F3E615575A
	for <io-uring@vger.kernel.org>; Mon,  6 May 2024 16:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715012609; cv=none; b=AIaqUektdJeyieAPnuZBHaY2ZN/Cs2+orrQuk4bHYNWrDNCXpvn8HGQHRNcWLqO6GWOdF5B9CyoW7S6AR95wYaH5Px1fkKqh9MqT7gzyVCUxbh8xaZQnT61qjvWpbDhfwj6X9Qj/MAEU9Ol8SVZlgJRtvxaq/WqR9pw9fbeB31E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715012609; c=relaxed/simple;
	bh=MKegbj/sSG6GrSO39MvSbwAdhEM0ymmBOZm1pzPMUtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=th6WC8dsevL4GMdmjpQtYfxPPun/0GWLXogGJY8p97946y9MYTRffZS4CRwGkfWYoIojIdpUqtLs5YqFipM0Z1W5jqoQRQJG70kcDKykrvGPWEYVTK16/0sYbaC9MN5o+yWafpEzm9QiGOPZ0dEPTo9k/JSkaF8/BbwjU5stnQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=M8E6vsaX; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715012606;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lKTTtY1y7k7AmfzI2jF98Rd0+0s+DQV8PWG07tTxXmY=;
	b=M8E6vsaXN0MSwD/LX20XUThg287ePUwJQ0r4Dg3O9sEC14DUJssarxbEmqOSpK+ycE41Y6
	kpm4OA/1HHp7nDiXuiNHapb4rY3R7DZqxJ4gDiUJ+5b5h6WoLVqQaejW/BJD/mLnMh5Taj
	zsRrO/mKSF0YpY08XworGsmNFUzZc2A=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-117-gcbJkRl2NPumxYRI_G6IFw-1; Mon,
 06 May 2024 12:23:22 -0400
X-MC-Unique: gcbJkRl2NPumxYRI_G6IFw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D39653C108C9;
	Mon,  6 May 2024 16:23:21 +0000 (UTC)
Received: from localhost (unknown [10.72.116.15])
	by smtp.corp.redhat.com (Postfix) with ESMTP id BABB65ADC40;
	Mon,  6 May 2024 16:23:20 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH V2 2/9] io_uring: add io_submit_fail_link() helper
Date: Tue,  7 May 2024 00:22:38 +0800
Message-ID: <20240506162251.3853781-3-ming.lei@redhat.com>
In-Reply-To: <20240506162251.3853781-1-ming.lei@redhat.com>
References: <20240506162251.3853781-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Add io_submit_fail_link() helper and put linking fail logic into this
helper.

This way simplifies io_submit_fail_init(), and becomes easier to add
sqe group failing logic.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c02c9291a2df..d3b9988cdae4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2135,22 +2135,17 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
 
@@ -2169,9 +2164,24 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
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
2.42.0


