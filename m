Return-Path: <io-uring+bounces-4602-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 17A4D9C3BB9
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 11:13:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D14CF28298F
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 10:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA75E149C4D;
	Mon, 11 Nov 2024 10:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CeVrh2k8"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37BE1487DC
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 10:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731320011; cv=none; b=BpXHijoPBlfbRQbOtee97Iwh7OQMsxhHv6q93BEWJtWWVDh/ILEV4Vj75Iowfe+Vf3BXi3cAMEid66Il+4vFTQEp+IQfA5Auo0qgzAwN0qJKw+Ep56LNidTxTEUAHfqJFfMG4W4lElhjTXirTrGJ4sFADiyb2btyvrA0WJ2Z85k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731320011; c=relaxed/simple;
	bh=eeMsht0fq/5vkHuGbnWPUg1e2bsEs6ODP9xVEu1c9NU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oLwpraxV542GDhLfay9wFyuQg1tBLBb9tCEpOVJ1Icb5NLjNHOzta6Zj/eDBy4TuoVjpRcXxaxcWkl/X/YEYiNLCyeX2oCn3qo0qwgLmniPSIsCwpFToPyAXSiuUSyyLr2fD5+kJ3+cdsSTGPFB9rAu/j6DkeWmy1d2EoAzhhqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CeVrh2k8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731320008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RFOv5I2JybypHq5q7M26Aqj/o+48sP+/DWqaDZsRe0o=;
	b=CeVrh2k8b/20utqNKnO3o8DYE+P0b6vGUnN/9zkDnzStJD4vOyvLdSz5sZPZ+31RjCDdoD
	ZGupHiaI7AQSBcIFfgJksT9ZibZMFFW1Pu1dlzlmYEmj77jrEkOqDQxcXCjv/0Uacd3XbS
	DtW3okcIYE9Q/V+P0RGZk9t2A5jK054=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-576-IxHx3ZJvOQWFV7cAx2Qtkw-1; Mon,
 11 Nov 2024 05:13:26 -0500
X-MC-Unique: IxHx3ZJvOQWFV7cAx2Qtkw-1
X-Mimecast-MFC-AGG-ID: IxHx3ZJvOQWFV7cAx2Qtkw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CF80619560B0;
	Mon, 11 Nov 2024 10:13:24 +0000 (UTC)
Received: from localhost (unknown [10.72.116.22])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 90C90195E488;
	Mon, 11 Nov 2024 10:13:22 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Ming Lei <ming.lei@redhat.com>,
	Guangwu Zhang <guazhang@redhat.com>,
	Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] io_uring/uring_cmd: fix buffer index retrieval
Date: Mon, 11 Nov 2024 18:13:18 +0800
Message-ID: <20241111101318.1387557-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Add back buffer index retrieval for IORING_URING_CMD_FIXED.

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Fixes: b54a14041ee6 ("io_uring/rsrc: add io_rsrc_node_lookup() helper")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/uring_cmd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e7723759cb23..1abb5c9f803f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -220,8 +220,9 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
 		struct io_ring_ctx *ctx = req->ctx;
 		struct io_rsrc_node *node;
+		u16 index = READ_ONCE(sqe->buf_index);
 
-		node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
+		node = io_rsrc_node_lookup(&ctx->buf_table, index);
 		if (unlikely(!node))
 			return -EFAULT;
 		/*
-- 
2.46.0


