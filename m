Return-Path: <io-uring+bounces-10179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 890C3C0405F
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 03:35:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 60BE84E25D7
	for <lists+io-uring@lfdr.de>; Fri, 24 Oct 2025 01:35:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE83912D1F1;
	Fri, 24 Oct 2025 01:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SQgrDEe/"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9684B2628D
	for <io-uring@vger.kernel.org>; Fri, 24 Oct 2025 01:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761269714; cv=none; b=rhrU3+8bnX2qfR4w91h39oGNhP80MhD/tLvf28CNIsN8enHxF/xM+m/cAsKelWnH4xarwcWeOAQa++iNe7I08YJNWbc4Z6db4cIB5QNOXcvlyqXTHJr25czgPgbDuh6bEYhdh90+GP8mGnWY4Pg2MvNH1orW2g4dz9f72+qX3rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761269714; c=relaxed/simple;
	bh=2Ooj+DzkPTJeTgmi30ZuvGFKJnVTwz10RI/rXHvjjdg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kyE2uXLnSFQqdUoYl/W15NGAizq/l+phVpVa3IvUXQuFuMo5VwqHPChchkr5Ftp5SGeNq44fliLqSxqzbV01+j+sbYt+OG6U7ITbdD7PiA53GE0+gTuNobNKpYnql644YrbvaWOTWWWc11ErjB0oXaQFi13ey1pOorV4wc0gYyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SQgrDEe/; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761269711;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=LFHrP3TO2c8KI8ufH3Dg9pNLx13w57eCYxZoEAFKwhg=;
	b=SQgrDEe/eK8eyJVWsgUdQ6Qsn9XD/tRH3EIsAkE1/8ii6jH+amVw8ZR+LbViYEKIiUBVCp
	MEqAsap2u+JDG/JT4rxYTfaZtsjjOzYJzEklPrCgbrcg2ZiFG+f0rKtTLufc665Ib/ZS/E
	DmJRqfBWrNZQdwoy85sdKLRSFViyd6Q=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-220--Cb4QiNsOG2L62xKThJP-Q-1; Thu,
 23 Oct 2025 21:35:09 -0400
X-MC-Unique: -Cb4QiNsOG2L62xKThJP-Q-1
X-Mimecast-MFC-AGG-ID: -Cb4QiNsOG2L62xKThJP-Q_1761269708
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B859218001E7;
	Fri, 24 Oct 2025 01:35:08 +0000 (UTC)
Received: from localhost (unknown [10.72.120.13])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9E23830002D7;
	Fri, 24 Oct 2025 01:35:07 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2] io_uring: fix buffer auto-commit for multishot uring_cmd
Date: Fri, 24 Oct 2025 09:34:59 +0800
Message-ID: <20251024013459.2591830-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Commit 620a50c92700 ("io_uring: uring_cmd: add multishot support") added
multishot uring_cmd support with explicit buffer upfront commit via
io_uring_mshot_cmd_post_cqe(). However, the buffer selection path in
io_ring_buffer_select() was auto-committing buffers for non-pollable files,
which conflicts with uring_cmd's explicit upfront commit model.

This way consumes the whole selected buffer immediately, and causes
failure on the following buffer selection.

Fix this by checking uring_cmd to identify operations that handle buffer
commit explicitly, and skip auto-commit for these operations.

Cc: Caleb Sander Mateos <csander@purestorage.com>
Fixes: 620a50c92700 ("io_uring: uring_cmd: add multishot support")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- add helper io_should_commit() (Jens)

 io_uring/kbuf.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index aad655e38672..a727e020fe03 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -155,6 +155,27 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 	return 1;
 }
 
+static bool io_should_commit(struct io_kiocb *req, unsigned int issue_flags)
+{
+	/*
+	* If we came in unlocked, we have no choice but to consume the
+	* buffer here, otherwise nothing ensures that the buffer won't
+	* get used by others. This does mean it'll be pinned until the
+	* IO completes, coming in unlocked means we're being called from
+	* io-wq context and there may be further retries in async hybrid
+	* mode. For the locked case, the caller must call commit when
+	* the transfer completes (or if we get -EAGAIN and must poll of
+	* retry).
+	*/
+	if (issue_flags & IO_URING_F_UNLOCKED)
+		return true;
+
+	/* uring_cmd commits kbuf upfront, no need to auto-commit */
+	if (!io_file_can_poll(req) && req->opcode != IORING_OP_URING_CMD)
+		return true;
+	return false;
+}
+
 static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 					      struct io_buffer_list *bl,
 					      unsigned int issue_flags)
@@ -181,17 +202,7 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	sel.buf_list = bl;
 	sel.addr = u64_to_user_ptr(buf->addr);
 
-	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
-		/*
-		 * If we came in unlocked, we have no choice but to consume the
-		 * buffer here, otherwise nothing ensures that the buffer won't
-		 * get used by others. This does mean it'll be pinned until the
-		 * IO completes, coming in unlocked means we're being called from
-		 * io-wq context and there may be further retries in async hybrid
-		 * mode. For the locked case, the caller must call commit when
-		 * the transfer completes (or if we get -EAGAIN and must poll of
-		 * retry).
-		 */
+	if (io_should_commit(req, issue_flags)) {
 		io_kbuf_commit(req, sel.buf_list, *len, 1);
 		sel.buf_list = NULL;
 	}
-- 
2.47.1


