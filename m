Return-Path: <io-uring+bounces-1327-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D68978920E4
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 16:51:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EEDD287B5A
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 15:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 529C325778;
	Fri, 29 Mar 2024 15:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f2loAW6D"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4331C0DEF
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711727473; cv=none; b=f6Gr9deeiwAN9llrbKyuqyzuufz7SYidTD/jB6C8IFai1ueOj+cSImXUgXC9S9S6z+C3JA2eK6KOf1S/Hhqh2eFx6PVfwe40FIZUhMlUKXBdHjI3V8NlP1RaqGwbdG57i2g2uhqlZ+O7BVXRlNxjlhm3zvl5noHt4CiLrMP2MiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711727473; c=relaxed/simple;
	bh=CLCIeXGy07/Hs5IDkchIGGB1R2lAohLB80aUeVnBwfE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hwvlY+WK0LIE24MEpLnl/mgWqucL9RJPuR/2mG2zyKs/mXc8NEGK3BmBTdjmkdZBi0/6Lc6sjPLQXW0tczG2NJ4wh4IJEivk0mzz3ewsPUmowjirOrdZEUeUXPjAvr95OYX1eQJNZlNasxHKBrYRO4mEmuV0rQD6F+BH5/JQa5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f2loAW6D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711727469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=BVramutEZbfu7U1/WIpVhb1+ZPzAXktPRpSja3QpAxA=;
	b=f2loAW6DXoyy7TZqQUkgGKD+GJNTF+EPY/tspRW7P1+ZtjfuL96ew1l8YTREy6J9YRX/cq
	CJ/KsroB9X1RT1aaEehaVUSh51jX56u9TrTEyLRbQKO0MxKyGDzA3GFLxx3matahd7hHi4
	WUBaHyYhjnhSCeyLMo5IpN5En/JMNuE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-116-PqMYuH_eOq-yVLFJ1Cu0XA-1; Fri, 29 Mar 2024 11:51:08 -0400
X-MC-Unique: PqMYuH_eOq-yVLFJ1Cu0XA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3982E800265;
	Fri, 29 Mar 2024 15:51:08 +0000 (UTC)
Received: from localhost (unknown [10.72.116.18])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 473CB2024517;
	Fri, 29 Mar 2024 15:51:06 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] io_uring: return void from io_put_kbuf_comp()
Date: Fri, 29 Mar 2024 23:50:54 +0800
Message-ID: <20240329155054.1936666-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4

The two callers don't handle the return value of io_put_kbuf_comp(), so
change its return type into void.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/kbuf.h | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 1c7b654ee726..86931fa655ad 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -119,18 +119,12 @@ static inline void __io_put_kbuf_list(struct io_kiocb *req,
 	}
 }
 
-static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
+static inline void io_put_kbuf_comp(struct io_kiocb *req)
 {
-	unsigned int ret;
-
 	lockdep_assert_held(&req->ctx->completion_lock);
 
-	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
-		return 0;
-
-	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
-	__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
-	return ret;
+	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
+		__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
 }
 
 static inline unsigned int io_put_kbuf(struct io_kiocb *req,
-- 
2.41.0


