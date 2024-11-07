Return-Path: <io-uring+bounces-4524-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D38FE9C0328
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 13889285D45
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71DC1F12EA;
	Thu,  7 Nov 2024 11:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKhEJCfP"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C8041EF0A4
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977336; cv=none; b=AlwNMJT3B8tyMBpubNLSWWFNJFtBIhIAt2B6gCOD/D/K1aXGxHIbeRpuDgUxJSs0G68tDoEhq2fvuHtpq2oLRWOxh6s4q83MeeYYDKLowDKBuhovMx7UXlnPajrAqt6N8rtTi/XXBlNJ0tGMr2P6XyAw5yn6WCtK3BtI5bsYR+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977336; c=relaxed/simple;
	bh=ZFGfCyVjeZFrKdSqsUR0uFSnTKseX+QMM+62DjV+jHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2wPhqYKDu/wphEV1XFaesMgfKNXsgRVvWr2yxVrIK1HpFiy4Gg5YraAJtlzHQ7Qv4EfQXMEFyXbqPo7oxAaXV+EafQoWNopvLim7YFuhdZWEBgrsMybZffKqU8Tur6Rer3bEmemRCUehkPrTJypP+TGyEzOmdUxqDo2Q1hKS9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKhEJCfP; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730977334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GnbXVXfSuPoRT3IWiwcDDUSOQBe/hc8zNrNe+93is/4=;
	b=UKhEJCfPsN1RdXhlxsFuCOfLSdp8nsIIkbJUvXwAC6z7zfCvEkM2n+YwcR7trogCzdO8+2
	4QD3pKHtMxQoo8DKFxLpK/JhRyQs7p6LPfpiIU1SkMYJYLwhzoEgnvkplYRBH/0T8WZ4nH
	kPfyoMie3AoKBDX78fTltB6uyf4TV9w=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-500-26Fc9L7lO1OR2iT-G6DWFA-1; Thu,
 07 Nov 2024 06:02:09 -0500
X-MC-Unique: 26Fc9L7lO1OR2iT-G6DWFA-1
X-Mimecast-MFC-AGG-ID: 26Fc9L7lO1OR2iT-G6DWFA
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB6DA1955D4D;
	Thu,  7 Nov 2024 11:02:07 +0000 (UTC)
Received: from localhost (unknown [10.72.116.54])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8BF6E196BC05;
	Thu,  7 Nov 2024 11:02:05 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 02/12] io_uring/rsrc: remove '->ctx_ptr' of 'struct io_rsrc_node'
Date: Thu,  7 Nov 2024 19:01:35 +0800
Message-ID: <20241107110149.890530-3-ming.lei@redhat.com>
In-Reply-To: <20241107110149.890530-1-ming.lei@redhat.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Remove '->ctx_ptr' of 'struct io_rsrc_node', and add 'type' field,
meantime remove io_rsrc_node_type().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 4 ++--
 io_uring/rsrc.h | 9 +--------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d7db36a2c66e..adaae8630932 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -124,7 +124,7 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type)
 
 	node = kzalloc(sizeof(*node), GFP_KERNEL);
 	if (node) {
-		node->ctx_ptr = (unsigned long) ctx | type;
+		node->type = type;
 		node->refs = 1;
 	}
 	return node;
@@ -449,7 +449,7 @@ void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 	if (node->tag)
 		io_post_aux_cqe(ctx, node->tag, 0, 0);
 
-	switch (io_rsrc_node_type(node)) {
+	switch (node->type) {
 	case IORING_RSRC_FILE:
 		if (io_slot_file(node))
 			fput(io_slot_file(node));
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c9057f7a06f5..c8a64a9ed5b9 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -11,12 +11,10 @@
 enum {
 	IORING_RSRC_FILE		= 0,
 	IORING_RSRC_BUFFER		= 1,
-
-	IORING_RSRC_TYPE_MASK		= 0x3UL,
 };
 
 struct io_rsrc_node {
-	unsigned long			ctx_ptr;
+	unsigned char			type;
 	int				refs;
 
 	u64 tag;
@@ -106,11 +104,6 @@ static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 	}
 }
 
-static inline int io_rsrc_node_type(struct io_rsrc_node *node)
-{
-	return node->ctx_ptr & IORING_RSRC_TYPE_MASK;
-}
-
 static inline void io_req_assign_rsrc_node(struct io_rsrc_node **dst_node,
 					   struct io_rsrc_node *node)
 {
-- 
2.47.0


