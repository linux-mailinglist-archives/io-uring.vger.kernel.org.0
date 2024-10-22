Return-Path: <io-uring+bounces-3910-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 67D249AB113
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:42:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9104D1C22471
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDD9F1A0BCA;
	Tue, 22 Oct 2024 14:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LQgL0uq3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF937199248
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 14:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608164; cv=none; b=O/5YuzjxfMGlJXQcpiOlpUYrH4hTUPKigo6pEoN4AVzP/sQLBhp0VWlHnNI8smVw3PgpvOD8girW91pKjvpf8EszVcX2DXSoh2iTOFDGAq7gHuh1Y8hJ+1PXQFbkRjG9jmdONBVonF2SEzd9RcFwjvOYlQ93WwIqtZYuxi+nGNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608164; c=relaxed/simple;
	bh=okB6g+p4pcTttNUIMEH61K9UOYH9zmoDEyECFLDp8Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uORmQwuEa820rcnZwg8uynxMMKcLKjvOBKob1firGbIvHAHS9dE6RqNrVkzCF4fLKVkqJN03+4/U5nv4A4ByQeqrDP4aBs6Kd2SP41boIRo20gzii4Ko7MkX3c2A8LBrnFU7346GzYZeDz6/Al45zg1xA2qsz/MnfOJOtqG6tUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LQgL0uq3; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a99fa009adcso321916366b.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729608161; x=1730212961; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6rDvifaxatM+jj6SeF3/kFKoJFAV3SEh+iogj0f3cY0=;
        b=LQgL0uq3Hm6TTvFS7bjRVjNEpnCBXTzE1BbXJtFSLRW1CYMXjUOZ5loMI0xl5D/sGG
         jLB7gMw6LMUUOMLS99Fbu5vgSWB4i1zvTXmIZWctjphiNoZBdtphGTucHy1RHKBQxS1Y
         2umKbvhRoLa78YkPdP/BlFsuAqPbfFzbZQ6grUyg6Tt6XN3m9u9asaj5JFPtNPDWaXKE
         4wmH4pi0jCwOoVt7Zy1/ztOBUJWtHkTruD+AivxsS0uMfRVthV192enRv6DpsslnrX2t
         YP2IvDtJ93LVnwCYZW0EZ23vTqpDuCilw5Pl4UOtjlQGHoeLsCvV5qXwpX+dA9njRAcy
         DYjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729608161; x=1730212961;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6rDvifaxatM+jj6SeF3/kFKoJFAV3SEh+iogj0f3cY0=;
        b=Tk2Prrl/ME2YPifDsdk78kfK/jdNiiVwuGgW1GLiQcxPxfbxiBD1isOW0sbFzmS1nq
         zBDX3C24EC5egz6qoMtXK8LuS9PVmiv847+D3YowFwuj1sc9OW2AAcs4/u85zTq2p2CK
         LNdlHS5w/9T/WzLtZzQBlwH8e8/jB+yW/Z7kRqz4zFs2T+DDjr9Ws3nVK6ccIhFXo/u0
         KMhnLWhu/cknIPNrMg8TRvwM8aAi8fzvuWXho2PyEZfeQ4cOKxwB7+iiJp4XeKC9DybU
         /mzjyQdddxv5TpIx4bs1Dj9DdbTjRO6wXr0dw5F9a+fo83PmZKtY1YQAyXgkwQqqm3EO
         yRxw==
X-Gm-Message-State: AOJu0YzgoXZ+gdKGQHLi5a9Ofxyh/rP5B2+8Oe+3i7Q9l4I+XuuyqUuL
	6G/3dibTlUTEmxVM+3P6X3A831vtoK6tzuFMWiwBvXOtgvAhhUMioXb/KQ==
X-Google-Smtp-Source: AGHT+IE6QYzDt/KPaWV4bHCcRedEX5ukWtjFtVw0F/Ycr9LTFqlULfFE2kOyJnJlUs9k5zxdOioChg==
X-Received: by 2002:a05:6402:d06:b0:5ca:ef8:bff8 with SMTP id 4fb4d7f45d1cf-5ca0ef8c061mr12994385a12.33.1729608160709;
        Tue, 22 Oct 2024 07:42:40 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb6696b631sm3244434a12.9.2024.10.22.07.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 07:42:39 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 2/4] io_uring/net: don't store send address ptr
Date: Tue, 22 Oct 2024 15:43:13 +0100
Message-ID: <db3dce544e17ca9d4b17d2506fbbac1da8a87824.1729607201.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1729607201.git.asml.silence@gmail.com>
References: <cover.1729607201.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For non "msg" requests we copy the address at the prep stage and there
is no need to store the address user pointer long term. Pass the SQE
into io_send_setup(), let it parse it, and remove struct io_sr_msg addr
addr_len fields. It saves some space and also less confusing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 36 ++++++++++++++++--------------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index cfe467f9e19f..4d928017ed2a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -74,9 +74,7 @@ struct io_sr_msg {
 	unsigned			nr_multishot_loops;
 	u16				flags;
 	/* initialised and used only by !msg send variants */
-	u16				addr_len;
 	u16				buf_group;
-	void __user			*addr;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
@@ -356,24 +354,31 @@ void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req)
 	io_netmsg_iovec_free(io);
 }
 
-static int io_send_setup(struct io_kiocb *req)
+static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
+	void __user *addr;
+	u16 addr_len;
 	int ret;
 
+	if (READ_ONCE(sqe->__pad3[0]))
+		return -EINVAL;
+
 	kmsg->msg.msg_name = NULL;
 	kmsg->msg.msg_namelen = 0;
 	kmsg->msg.msg_control = NULL;
 	kmsg->msg.msg_controllen = 0;
 	kmsg->msg.msg_ubuf = NULL;
 
-	if (sr->addr) {
-		ret = move_addr_to_kernel(sr->addr, sr->addr_len, &kmsg->addr);
+	addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	addr_len = READ_ONCE(sqe->addr_len);
+	if (addr) {
+		ret = move_addr_to_kernel(addr, addr_len, &kmsg->addr);
 		if (unlikely(ret < 0))
 			return ret;
 		kmsg->msg.msg_name = &kmsg->addr;
-		kmsg->msg.msg_namelen = sr->addr_len;
+		kmsg->msg.msg_namelen = addr_len;
 	}
 	if (!io_do_buffer_select(req)) {
 		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
@@ -403,13 +408,9 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	sr->done_io = 0;
 
-	if (req->opcode == IORING_OP_SEND) {
-		if (READ_ONCE(sqe->__pad3[0]))
+	if (req->opcode != IORING_OP_SEND) {
+		if (sqe->addr2 || sqe->file_index)
 			return -EINVAL;
-		sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-		sr->addr_len = READ_ONCE(sqe->addr_len);
-	} else if (sqe->addr2 || sqe->file_index) {
-		return -EINVAL;
 	}
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -437,7 +438,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(!io_msg_alloc_async(req)))
 		return -ENOMEM;
 	if (req->opcode != IORING_OP_SENDMSG)
-		return io_send_setup(req);
+		return io_send_setup(req, sqe);
 	return io_sendmsg_setup(req);
 }
 
@@ -1263,12 +1264,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		io_req_set_rsrc_node(notif, ctx, 0);
 	}
 
-	if (req->opcode == IORING_OP_SEND_ZC) {
-		if (READ_ONCE(sqe->__pad3[0]))
-			return -EINVAL;
-		zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-		zc->addr_len = READ_ONCE(sqe->addr_len);
-	} else {
+	if (req->opcode != IORING_OP_SEND_ZC) {
 		if (unlikely(sqe->addr2 || sqe->file_index))
 			return -EINVAL;
 		if (unlikely(zc->flags & IORING_RECVSEND_FIXED_BUF))
@@ -1288,7 +1284,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(!io_msg_alloc_async(req)))
 		return -ENOMEM;
 	if (req->opcode != IORING_OP_SENDMSG_ZC)
-		return io_send_setup(req);
+		return io_send_setup(req, sqe);
 	return io_sendmsg_setup(req);
 }
 
-- 
2.46.0


