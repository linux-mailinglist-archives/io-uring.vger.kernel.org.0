Return-Path: <io-uring+bounces-1436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FFD089B248
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 15:43:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FC671C211A4
	for <lists+io-uring@lfdr.de>; Sun,  7 Apr 2024 13:43:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF4773770B;
	Sun,  7 Apr 2024 13:28:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6043838A
	for <io-uring@vger.kernel.org>; Sun,  7 Apr 2024 13:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712496494; cv=none; b=c9YqtuXU/56YT42tKqbBN5yQyJhBQQHyDnCU3G7+x+oQVnArOKwLXO9Ke6ID5QrD6Vc2WT96m3m6MnWGUM31rCsjr7r7HY3Q8x2O8hwH26l/E9wJPcapHdqVcBMeSBvl0sJHJaiZuZj583XddUNfe4Eb2QUdMc7lG4Y3GnW/jEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712496494; c=relaxed/simple;
	bh=lwxr/A3QQKpmhq2uRXjqo5Oj1XzQ6mqXPTRcfIs2Yzk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AWy9KuR0uJWadvGh3R+Q7DcrbTU3vQ1Wk0UBR0paU6s3frqIsa4B2D7oMI/BCa/AsRdRME9+QukkiktetnpRSgkrOsI9SpwvNQrID+8WUD20jZkT0dDXP8bvTWm3DyJcFJoTtSZWmqkVOtyk3gbqHi1rbXdbyQIxVmGRONwSprI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-322-rgLzWgXBMHWIMlxe5xfKZw-1; Sun,
 07 Apr 2024 09:28:10 -0400
X-MC-Unique: rgLzWgXBMHWIMlxe5xfKZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3C9529AB3F7;
	Sun,  7 Apr 2024 13:28:09 +0000 (UTC)
Received: from localhost (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DDAFB1C0DD80;
	Sun,  7 Apr 2024 13:28:08 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2] io_uring: return void from io_put_kbuf_comp()
Date: Sun,  7 Apr 2024 21:27:59 +0800
Message-ID: <20240407132759.4056167-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

The only caller doesn't handle the return value of io_put_kbuf_comp(), so
change its return type into void.

Also follow Jen's suggestion to rename it as io_put_kbuf_drop().

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
V2:
	- rename & following check style in kbuf.c(Jens)

 io_uring/io_uring.c | 2 +-
 io_uring/kbuf.h     | 8 ++------
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index afbe0522e8d8..8df9ad010803 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -381,7 +381,7 @@ static void io_clean_op(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
 		spin_lock(&req->ctx->completion_lock);
-		io_put_kbuf_comp(req);
+		io_kbuf_drop(req);
 		spin_unlock(&req->ctx->completion_lock);
 	}
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 53c141d9a8b2..5a9635ee0217 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -120,18 +120,14 @@ static inline void __io_put_kbuf_list(struct io_kiocb *req,
 	}
 }
 
-static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
+static inline void io_kbuf_drop(struct io_kiocb *req)
 {
-	unsigned int ret;
-
 	lockdep_assert_held(&req->ctx->completion_lock);
 
 	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
-		return 0;
+		return;
 
-	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
 	__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
-	return ret;
 }
 
 static inline unsigned int io_put_kbuf(struct io_kiocb *req,
-- 
2.41.0


