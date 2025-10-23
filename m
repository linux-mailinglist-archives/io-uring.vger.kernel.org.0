Return-Path: <io-uring+bounces-10154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 02614C008F4
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 12:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 8087C4FF402
	for <lists+io-uring@lfdr.de>; Thu, 23 Oct 2025 10:44:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 96A013093C7;
	Thu, 23 Oct 2025 10:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KOOhwequ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B96D3090D6
	for <io-uring@vger.kernel.org>; Thu, 23 Oct 2025 10:44:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761216249; cv=none; b=uEXtvJcotpQWexMsz4h9FsHhqnZ2qI0KG+GqUSp2F58/pJWAwJEHm9qMFHg19kOTNqubzL5bnoooFSXuJRlpt8OXaz0/6SYHTul9l/T/GXOSwkcIf5wQDPZ5BE8itPQpehHORzCyLFCG+DfXFRuOsdJV/ehNaDtackFbCJ0vDV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761216249; c=relaxed/simple;
	bh=X80sO19OQq1AAeWyYw6VVJB/0XMC/w+rt34aJP2xI/g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=N7RZRW5/6xKTlAlxIvNpHOa5jKveTmoJLU77k4oNXeUUx2qyQh9sTnOW1vJmAeY4MIhysZnGFnbtKj1UKWNYbrmuNSupl47vIKxTvnzej9adWCADKaV5SWQR1BmDGwyyT0i71wW+3lxOtOafzJVmwRMVxJ+pTh3kAayvJNkXIKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KOOhwequ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761216245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AQdpr7tiqgHdbDQVg93+dG/eG3fbl9u/USI4T+1JorE=;
	b=KOOhwequ5CS910jPOowIRAH0lbSigIaVejjC4/d/Gy/MF6zBHtVcnlB/Zrn69AF6CFcSKx
	Cgj/0PKJ/6GIQ8ZsOA1hvUPcuC20zDv6PQTK15tRpKpChl+us9QdMcW58mJ5tLE8rh0pyk
	wc8r2mKxkiY3d478wD5g+cQ73wFB9Dw=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-PNDzfMH5O6aZaXItZu2qpw-1; Thu,
 23 Oct 2025 06:44:04 -0400
X-MC-Unique: PNDzfMH5O6aZaXItZu2qpw-1
X-Mimecast-MFC-AGG-ID: PNDzfMH5O6aZaXItZu2qpw_1761216243
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4E7D31800741;
	Thu, 23 Oct 2025 10:44:03 +0000 (UTC)
Received: from localhost (unknown [10.72.120.30])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DC9AD180057E;
	Thu, 23 Oct 2025 10:44:01 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] io_uring: fix buffer auto-commit for multishot uring_cmd
Date: Thu, 23 Oct 2025 18:43:50 +0800
Message-ID: <20251023104350.2515079-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Commit 620a50c92700 ("io_uring: uring_cmd: add multishot support") added
multishot uring_cmd support with explicit buffer upfront commit via
io_uring_mshot_cmd_post_cqe(). However, the buffer selection path in
io_ring_buffer_select() was auto-committing buffers for non-pollable files,
which conflicts with uring_cmd's explicit upfront commit model.

This way consumes the whole selected buffer immediately, and causes
failure on the following buffer selection.

Fix this by adding io_commit_kbuf_upfront() to identify operations that
handle buffer commit explicitly (currently only IORING_OP_URING_CMD),
and skip auto-commit for these operations.

Cc: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 620a50c92700 ("io_uring: uring_cmd: add multishot support")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/kbuf.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index aad655e38672..e3f3dec8b135 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -155,6 +155,12 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 1;
 }
 
+/* So far, uring_cmd commits kbuf upfront, no need to auto-commit */
+static bool io_commit_kbuf_upfront(const struct io_kiocb *req)
+{
+	return req->opcode == IORING_OP_URING_CMD;
+}
+
 static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 					      struct io_buffer_list *bl,
 					      unsigned int issue_flags)
@@ -181,7 +187,8 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	sel.buf_list = bl;
 	sel.addr = u64_to_user_ptr(buf->addr);
 
-	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
+	if (issue_flags & IO_URING_F_UNLOCKED || (!io_file_can_poll(req) &&
+				!io_commit_kbuf_upfront(req))) {
 		/*
 		 * If we came in unlocked, we have no choice but to consume the
 		 * buffer here, otherwise nothing ensures that the buffer won't
-- 
2.47.1


