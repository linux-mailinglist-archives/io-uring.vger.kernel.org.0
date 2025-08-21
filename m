Return-Path: <io-uring+bounces-9151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 11C8BB2EC8B
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 06:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 966C63BF64B
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 384A936CE1A;
	Thu, 21 Aug 2025 04:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PFFTOh/n"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2C6111A8
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 04:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755748954; cv=none; b=mDbVlt4AxAaXUqYHCmujucx452bxhppt7JT/Fp0QiorhtJ8P37T3qUAUSFLqvXLeT76URs7VkGbS/I0RJqXTc34C8BVi7WwJfo9+b2fFGhfrrF7eygUFAD9e8NO71TjcI+aSjfSXXkkiOp7gNeilYATHczdImJrr8htZ1WLE9hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755748954; c=relaxed/simple;
	bh=ow/or4BGWWypQA34YmAHRcdiQmcqlBD108JhYvXb1bI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aKi6VpwD5Wx0AoInirENWaheQ000NMFtGkaCsgzUvG/0+XRRH99u+DJISXr8HXZS92I4okuHs7Yfvas5ZHswBWnL0b+L3400iadHAeSQwnZbOjJ1lYlgz+C3c/mkvm2b6c50JW5qxZLrXPqi6+S4IuSX1/nXQ/g1TQHGAkLBFJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PFFTOh/n; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755748951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+rGA19PJ/QjNvim4vV2VmcLZqzHvBOW6ghnAxIhmFFw=;
	b=PFFTOh/nOf4/gB7xpAxiQdeYw+jAcx6mAlqnFAyC/TGjW8NR/RV01AuF1cimGsLNzB16Rk
	bMo+CR+Q5WSZNuHU/NgyPqCn1Ue7sNb3Kl/RgG6xeVjEHxxVsOQjVsJy6j9fPS/Y4RV7dg
	aRi47nFygrUGlAr8Jt0veBP2q/g9N4c=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-414-7IiK00HcOnCrgp6Wv75brw-1; Thu,
 21 Aug 2025 00:02:27 -0400
X-MC-Unique: 7IiK00HcOnCrgp6Wv75brw-1
X-Mimecast-MFC-AGG-ID: 7IiK00HcOnCrgp6Wv75brw_1755748946
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 173AF19775A6;
	Thu, 21 Aug 2025 04:02:26 +0000 (UTC)
Received: from localhost (unknown [10.72.116.104])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EEE42300019F;
	Thu, 21 Aug 2025 04:02:22 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 1/2] io-uring: move `struct io_br_sel` into io_uring_types.h
Date: Thu, 21 Aug 2025 12:02:06 +0800
Message-ID: <20250821040210.1152145-2-ming.lei@redhat.com>
In-Reply-To: <20250821040210.1152145-1-ming.lei@redhat.com>
References: <20250821040210.1152145-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Move `struct io_br_sel` into io_uring_types.h and prepare for supporting
provided buffer on uring_cmd.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h | 19 +++++++++++++++++++
 io_uring/kbuf.h                | 18 ------------------
 2 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1d33984611bc..9c6c548f43f5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -85,6 +85,25 @@ struct io_mapped_region {
 	unsigned		flags;
 };
 
+/*
+ * Return value from io_buffer_list selection, to avoid stashing it in
+ * struct io_kiocb. For legacy/classic provided buffers, keeping a reference
+ * across execution contexts are fine. But for ring provided buffers, the
+ * list may go away as soon as ->uring_lock is dropped. As the io_kiocb
+ * persists, it's better to just keep the buffer local for those cases.
+ */
+struct io_br_sel {
+	struct io_buffer_list *buf_list;
+	/*
+	 * Some selection parts return the user address, others return an error.
+	 */
+	union {
+		void __user *addr;
+		ssize_t val;
+	};
+};
+
+
 /*
  * Arbitrary limit, can be raised if need be
  */
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 32f73adbe1e9..ada382ff38d7 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -62,24 +62,6 @@ struct buf_sel_arg {
 	unsigned short partial_map;
 };
 
-/*
- * Return value from io_buffer_list selection, to avoid stashing it in
- * struct io_kiocb. For legacy/classic provided buffers, keeping a reference
- * across execution contexts are fine. But for ring provided buffers, the
- * list may go away as soon as ->uring_lock is dropped. As the io_kiocb
- * persists, it's better to just keep the buffer local for those cases.
- */
-struct io_br_sel {
-	struct io_buffer_list *buf_list;
-	/*
-	 * Some selection parts return the user address, others return an error.
-	 */
-	union {
-		void __user *addr;
-		ssize_t val;
-	};
-};
-
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				  unsigned buf_group, unsigned int issue_flags);
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
-- 
2.47.0


