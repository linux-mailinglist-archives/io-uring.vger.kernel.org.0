Return-Path: <io-uring+bounces-7745-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 44B88A9ED29
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 11:50:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFD1B188A9D3
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 09:48:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED37126770A;
	Mon, 28 Apr 2025 09:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GVim+ypv"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DE3F267711
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 09:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745833493; cv=none; b=s2Mj0X/bWdIXvLsjc7wXiq32Eho7cDR9qFApf/2yR/md98tpU245yI861hylyXaQbcggIwCdv/3mTcaM5mesOmmMTv5hsup5HcKlUu+lUp918/JUXbs9nO35y5fyFx4qCe6Dg13SlBKcFv1t0/qTmzESHl5ZZfysbzqDly+NHUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745833493; c=relaxed/simple;
	bh=RySI8+IEkHwxsSJMl3215Shy2Tpsccb02c7PDAMc1g0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJ170tt9XScykO/LLvchqbnW3HQAzI+ydiX/KQnyye2b/ergUif+jUlzYmHpY5vo6KGmi8CgUx0vyW4rDjbklthKjdvpLHL3kThlOFpIJKJUsQiOy/+IwFkhooEtl+agNbkDy0x5CyFOj3AFYBalJ6DIpdUWfrQfzzMm5ZzqByA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GVim+ypv; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745833491;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VED5b4K6fUG2nVI2j3FYZcFqAe41fY2ybvhVS20nA6s=;
	b=GVim+ypvXjmsnk22Ia4UalwnlOs5t+N76QsimxYER74mhA93wLOQ8Sn/erci1Dxb4A7cpi
	39ilEzgcLDnCvQmT0QgXejFDcoLz6cwxuAqGEm2o1PJ4oNI0MRkdMlvfMHunja9pQIENyB
	edb6sMJ1fbd1pSOs/lD/km6NnMm6yPg=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-310-Vb3aI88KOZ6n3fzMzaTXIg-1; Mon,
 28 Apr 2025 05:44:48 -0400
X-MC-Unique: Vb3aI88KOZ6n3fzMzaTXIg-1
X-Mimecast-MFC-AGG-ID: Vb3aI88KOZ6n3fzMzaTXIg_1745833486
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A25971955DC5;
	Mon, 28 Apr 2025 09:44:46 +0000 (UTC)
Received: from localhost (unknown [10.72.116.134])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9FDE919560A3;
	Mon, 28 Apr 2025 09:44:44 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org
Cc: Uday Shankar <ushankar@purestorage.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Keith Busch <kbusch@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 3/7] io_uring: support to register bvec buffer to specified io_uring
Date: Mon, 28 Apr 2025 17:44:14 +0800
Message-ID: <20250428094420.1584420-4-ming.lei@redhat.com>
In-Reply-To: <20250428094420.1584420-1-ming.lei@redhat.com>
References: <20250428094420.1584420-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Extend io_buffer_register_bvec() and io_buffer_unregister_bvec() for
supporting to register/unregister bvec buffer to specified io_uring,
which FD is usually passed from userspace.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring/cmd.h |  4 ++
 io_uring/rsrc.c              | 83 +++++++++++++++++++++++++++---------
 2 files changed, 67 insertions(+), 20 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 78fa336a284b..7516fe5cd606 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -25,6 +25,10 @@ struct io_uring_cmd_data {
 
 struct io_buf_data {
 	unsigned short index;
+	bool has_fd;
+	bool registered_fd;
+
+	int ring_fd;
 	struct request *rq;
 	void (*release)(void *);
 };
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 5f8ab130a573..701dd33fecf7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -969,21 +969,6 @@ static int __io_buffer_register_bvec(struct io_ring_ctx *ctx,
 	return 0;
 }
 
-int io_buffer_register_bvec(struct io_uring_cmd *cmd,
-			    struct io_buf_data *buf,
-			    unsigned int issue_flags)
-{
-	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
-	int ret;
-
-	io_ring_submit_lock(ctx, issue_flags);
-	ret = __io_buffer_register_bvec(ctx, buf);
-	io_ring_submit_unlock(ctx, issue_flags);
-
-	return ret;
-}
-EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
-
 static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
 				       struct io_buf_data *buf)
 {
@@ -1006,19 +991,77 @@ static int __io_buffer_unregister_bvec(struct io_ring_ctx *ctx,
 	return 0;
 }
 
-int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
-			      struct io_buf_data *buf,
-			      unsigned int issue_flags)
+static inline int do_reg_unreg_bvec(struct io_ring_ctx *ctx,
+				    struct io_buf_data *buf,
+				    unsigned int issue_flags,
+				    bool reg)
 {
-	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	int ret;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	ret = __io_buffer_unregister_bvec(ctx, buf);
+	if (reg)
+		ret = __io_buffer_register_bvec(ctx, buf);
+	else
+		ret = __io_buffer_unregister_bvec(ctx, buf);
 	io_ring_submit_unlock(ctx, issue_flags);
 
 	return ret;
 }
+
+static int io_buffer_reg_unreg_bvec(struct io_ring_ctx *ctx,
+				    struct io_buf_data *buf,
+				    unsigned int issue_flags,
+				    bool reg)
+{
+	struct io_ring_ctx *remote_ctx = ctx;
+	struct file *file = NULL;
+	int ret;
+
+	if (buf->has_fd) {
+		file = io_uring_register_get_file(buf->ring_fd, buf->registered_fd);
+		if (IS_ERR(file))
+			return PTR_ERR(file);
+		remote_ctx = file->private_data;
+		if (!remote_ctx)
+			return -EINVAL;
+	}
+
+	if (remote_ctx == ctx) {
+		do_reg_unreg_bvec(ctx, buf, issue_flags, reg);
+	} else {
+		if (!(issue_flags & IO_URING_F_UNLOCKED))
+			mutex_unlock(&ctx->uring_lock);
+
+		do_reg_unreg_bvec(remote_ctx, buf, IO_URING_F_UNLOCKED, reg);
+
+		if (!(issue_flags & IO_URING_F_UNLOCKED))
+			mutex_lock(&ctx->uring_lock);
+	}
+
+	if (file)
+		fput(file);
+
+	return ret;
+}
+
+int io_buffer_register_bvec(struct io_uring_cmd *cmd,
+			    struct io_buf_data *buf,
+			    unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+
+	return io_buffer_reg_unreg_bvec(ctx, buf, issue_flags, true);
+}
+EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
+
+int io_buffer_unregister_bvec(struct io_uring_cmd *cmd,
+			      struct io_buf_data *buf,
+			      unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
+
+	return io_buffer_reg_unreg_bvec(ctx, buf, issue_flags, false);
+}
 EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
 
 static int validate_fixed_range(u64 buf_addr, size_t len,
-- 
2.47.0


