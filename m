Return-Path: <io-uring+bounces-4525-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D88D9C0325
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 660EF1C216E9
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF39C1EF958;
	Thu,  7 Nov 2024 11:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aTJdKcop"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7801EF957
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977337; cv=none; b=Lc6pWS/SfUBrbkEtqfj50RvTa4c9IH6HTDOxOQh7yHreOw6sTTfMYXg2T+mRZ/3j3hFrs1ez0yAyLcf0djRWYq2+5Wgy4uO4lvM/h7V2p01wjSTCduffOtyS4yieqSCJIcU29OL3qd/NG+mlviyeZ0U+zIeikS9EAGNu+4yXftc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977337; c=relaxed/simple;
	bh=/nBuYkm4ZIQSzZbsrM5SCU14YE72rgNY/zfy7ccWjSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ml1MQwyyskxXtAqrPGdooiWDF07MkNbR1Q1ZWV9FXyKi3oTCUoWxPiNurNQJUEud3Eca5aYb9nYwwPU6F9O0qdKeHUPnh5nVKoZJFhz7XkDvubb0MIwimp4tbLep6IPID/L5fguHt97pYmiv3d08DdhN/zjWAZ2kyso5ffIJ7/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aTJdKcop; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730977335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PBrVpfuh5t1ju1o2rH+qwizzz9nWJDofQ3E+XgyAU+M=;
	b=aTJdKcopSQtp7fmj1gNimpgnZz4ti0BWgo9KCmpOm6gyV0PCr4eYR0mOnFpwTHh4OLyvOS
	ZpCy3mB9hK4RefBhtkoignK4p2XmXnjd3eMdYWFmh+F2K4kZClyNjEMHZPznnmb2i8tbeN
	GP+bV3xqgVYE9QtIqJ3ve19rGkyvmQU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-58-Zi9wzdZhOGmAGtHh48VJrw-1; Thu,
 07 Nov 2024 06:02:14 -0500
X-MC-Unique: Zi9wzdZhOGmAGtHh48VJrw-1
X-Mimecast-MFC-AGG-ID: Zi9wzdZhOGmAGtHh48VJrw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 98A511954B0A;
	Thu,  7 Nov 2024 11:02:12 +0000 (UTC)
Received: from localhost (unknown [10.72.116.54])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6429B1953883;
	Thu,  7 Nov 2024 11:02:10 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 03/12] io_uring/rsrc: add & apply io_req_assign_buf_node()
Date: Thu,  7 Nov 2024 19:01:36 +0800
Message-ID: <20241107110149.890530-4-ming.lei@redhat.com>
In-Reply-To: <20241107110149.890530-1-ming.lei@redhat.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The following pattern becomes more and more:

+       io_req_assign_rsrc_node(&req->buf_node, node);
+       req->flags |= REQ_F_BUF_NODE;

so make it a helper, which is less fragile to use than above code, for
example, the BUF_NODE flag is even missed in current io_uring_cmd_prep().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/net.c       | 3 +--
 io_uring/nop.c       | 3 +--
 io_uring/rsrc.h      | 7 +++++++
 io_uring/rw.c        | 3 +--
 io_uring/uring_cmd.c | 2 +-
 5 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 2ccc2b409431..df1f7dc6f1c8 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1348,8 +1348,7 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 		io_ring_submit_lock(ctx, issue_flags);
 		node = io_rsrc_node_lookup(&ctx->buf_table, sr->buf_index);
 		if (node) {
-			io_req_assign_rsrc_node(&sr->notif->buf_node, node);
-			sr->notif->flags |= REQ_F_BUF_NODE;
+			io_req_assign_buf_node(sr->notif, node);
 			ret = 0;
 		}
 		io_ring_submit_unlock(ctx, issue_flags);
diff --git a/io_uring/nop.c b/io_uring/nop.c
index bc22bcc739f3..6d470d4251ee 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -67,8 +67,7 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 		io_ring_submit_lock(ctx, issue_flags);
 		node = io_rsrc_node_lookup(&ctx->buf_table, nop->buffer);
 		if (node) {
-			io_req_assign_rsrc_node(&req->buf_node, node);
-			req->flags |= REQ_F_BUF_NODE;
+			io_req_assign_buf_node(req, node);
 			ret = 0;
 		}
 		io_ring_submit_unlock(ctx, issue_flags);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index c8a64a9ed5b9..7a4668deaa1a 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -111,6 +111,13 @@ static inline void io_req_assign_rsrc_node(struct io_rsrc_node **dst_node,
 	*dst_node = node;
 }
 
+static inline void io_req_assign_buf_node(struct io_kiocb *req,
+					  struct io_rsrc_node *node)
+{
+	io_req_assign_rsrc_node(&req->buf_node, node);
+	req->flags |= REQ_F_BUF_NODE;
+}
+
 int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
 int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index e368b9afde03..b62cdb5fc936 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -341,8 +341,7 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
 	if (!node)
 		return -EFAULT;
-	io_req_assign_rsrc_node(&req->buf_node, node);
-	req->flags |= REQ_F_BUF_NODE;
+	io_req_assign_buf_node(req, node);
 
 	io = req->async_data;
 	ret = io_import_fixed(ddir, &io->iter, node->buf, rw->addr, rw->len);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 40b8b777ba12..b62965f58f30 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -219,7 +219,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		 * being called. This prevents destruction of the mapped buffer
 		 * we'll need at actual import time.
 		 */
-		io_req_assign_rsrc_node(&req->buf_node, node);
+		io_req_assign_buf_node(req, node);
 	}
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 
-- 
2.47.0


