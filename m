Return-Path: <io-uring+bounces-2676-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B4F994C2AE
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 18:25:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B83D9B2823E
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 16:25:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511CA18E77E;
	Thu,  8 Aug 2024 16:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gw2Um3+7"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CDC18E752
	for <io-uring@vger.kernel.org>; Thu,  8 Aug 2024 16:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723134329; cv=none; b=dCXziwbaA9sBaKr/PMuyFtGQmc0WyDTQN4PhhtKxdHvIScdY4MRHJHRGTEAk0Ln35BoyYoPoV6CzPL3CLIejYt3PreB1WayXDlLjWwJZBnyAYXj5GSyJoXFYY628ooLKPm8DnRqeG2jAC0gyGSaMVOghJlk0XAiaCOwvYBRSNMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723134329; c=relaxed/simple;
	bh=ALO5J+VQ8/3IDtPrrTF02WDfeN8cw5/793BtZEdNqNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqDBRpd/hDtezIh0aSfQK5hGAJbvU9tl+RW48Ysto+ePfJKvG8sqCvRVCks40jiyVhnyTt1zZQru6wWjBsDQ8daaPqem7/9dbolw4Q8rXxJUVk3iZju/n16ekg8jQCOmCLHA+pMME0KmwF3hIbCWnuiajG89Js3tIe4DhlfgspU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Gw2Um3+7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723134326;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vDrT67P8Y0hVrPae1hqC0kgkuX3HWn+0sZdkMhfAGNE=;
	b=Gw2Um3+7DHxeJnTNq/khYRuBM0iKiFOv/DI/12Pcgrf4qr9ux7ZKezq3QvrWurt4a0ibky
	gnvx49ykdPiol6vjiSrZsfVPV2qCvlFWNGEkh7GL3YGRdEn4/6YId7sYlru2DCcPFA4sBU
	Wbr76mbsqg/kKDxj4gVk3zZjAFs5bZo=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-171-0Tr8A2hjOS6WYwqQJGVOKA-1; Thu,
 08 Aug 2024 12:25:23 -0400
X-MC-Unique: 0Tr8A2hjOS6WYwqQJGVOKA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FAEA1956054;
	Thu,  8 Aug 2024 16:25:22 +0000 (UTC)
Received: from localhost (unknown [10.72.116.29])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8A0BC19560A3;
	Thu,  8 Aug 2024 16:25:21 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 2/8] io_uring: add io_submit_fail_link() helper
Date: Fri,  9 Aug 2024 00:24:51 +0800
Message-ID: <20240808162503.345913-3-ming.lei@redhat.com>
In-Reply-To: <20240808162503.345913-1-ming.lei@redhat.com>
References: <20240808162503.345913-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Add io_submit_fail_link() helper and put linking fail logic into this
helper.

This way simplifies io_submit_fail_init(), and becomes easier to add
sqe group failing logic.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4848cd84af3d..34020cadee03 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2095,22 +2095,17 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
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
 
@@ -2129,9 +2124,24 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
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


