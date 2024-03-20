Return-Path: <io-uring+bounces-1175-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4874E8819B6
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B41441F22790
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C71891E87E;
	Wed, 20 Mar 2024 22:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="I3a2IQ6w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C8485C6C
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975499; cv=none; b=dNCcvPAKeqU9SGkhafxzdTxDAgb23LWy+N+1H+V+DdrWW4nbUneraEKxI3TJs00p8WEs2BxtEWHAA8QrtXWXdrvUq49xOKkJVz/nwml0hanMvkB96IAguhYqdbC0EphEYsIuTWjPVObAF8geyPN6a5cLiaeaOKnAxwqIIQMW0Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975499; c=relaxed/simple;
	bh=jjPA7eqCgGJ/H4xZpGgM6c/JlF5Tl7lHIjK6/3EPDSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q55WnAQRy0BFwvFy9nxgqo//X6MPIZfPfpSwjt/08jmbQMBrBEvLjC5x2qdR2X/Hmw4AgH0Yj2QRZWDgqTJPRy0X1ZbnksWgiL766XK5j6jU1P5C5r47IZamK0Zun8bvm7OzDUnSqpi2f4+MXDJmePQ5ihm+SyBzVPjTgSpgmks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=I3a2IQ6w; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so2541939f.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975496; x=1711580296; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RyqUyQc1GXdt3Svgvt+zg4mr+tNs2Tqlbg+SmXyDLhI=;
        b=I3a2IQ6wOpHtraUjThKika8rLt4bywLGvTLwTJbi3Q9E3C7/ooP5nnicUF18iinb2r
         qoWVvZOYvMOhhDtBFdEyJlY6x/c3cDiJJ6y2hw9yQfRotK/TfDRZcWPhmNk+D5l9YMSF
         hX9Hs/ZppBDs6Z9wvqPT+tO6iNJ6L+XNnDBouf+ATsgc4nkKbsjaTFr/mmCtgO/WpTV5
         ODW7BS/juy4j5Cdv2dq7qxNqk5o4Lt0QoAcvNM701gN1hqS8W46BEd+oEGA/S+tuptKU
         1hhJVJcwPyYolu/FPw/MHZr4bZ03QDxQR5Lz8Mykv1AjQxOGBjHR1J1k4FYRfHJHkxme
         dKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975496; x=1711580296;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RyqUyQc1GXdt3Svgvt+zg4mr+tNs2Tqlbg+SmXyDLhI=;
        b=wC+WZ8cIRrc0FLIEPomBfiG6eEXXAG/ibO5zV0p+HHfU6LHwPyeEX00QiPyc/c9CEH
         ZSYc3h/5z8+A6s7D6+4vRPlLbJmsZYADRmbOiLEA8i9w2fAgU2PT5NBbcoXqcajR95hl
         OqOg+6PXFPaMMmtjWnkRJ8l8g/qGaC/eWMwIw2dfYhRBi0j52SoVl3fK9Zk0JQg6ndL7
         JIfeRcV1+2Knhq+iNtcm0PBBmadoMgvg90v1hvMUmAvimoONEPzqRwPdTk3zw6cSvBLK
         GqLq93d4AOylM9Qkq/c+3ksx6nCuPXjjKBuhjLobSCjXiC+XvU3qAfgmN2TODXsUN5gP
         NVUA==
X-Gm-Message-State: AOJu0YyDJ0aeJ+cU4fXs6tK81Tw2nY0+GFrAZdgUJSI/CLr6ZcmF1l5r
	nukpWSM3/twWKVnrFm2aesA5ER9+n8Mkz49AiYo1o2nxGfXpuAEhEO3IKuDukJLN61xG8skqwxO
	/
X-Google-Smtp-Source: AGHT+IHzFlEcXiChhjU8L0ccSuy4ATsGD81l7uKSeDfLPXOciJoYqCRMDj/FnuGhyAjC47zy0pYwwg==
X-Received: by 2002:a5e:c10d:0:b0:7cf:28df:79e2 with SMTP id v13-20020a5ec10d000000b007cf28df79e2mr701145iol.1.1710975496675;
        Wed, 20 Mar 2024 15:58:16 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/17] io_uring/net: move connect to always using async data
Date: Wed, 20 Mar 2024 16:55:28 -0600
Message-ID: <20240320225750.1769647-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While doing that, get rid of io_async_connect and just use the generic
io_async_msghdr. Both of them have a struct sockaddr_storage in there,
and while io_async_msghdr is bigger, if the same type can be used then
we get recycling for free.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 41 +++++++++++------------------------------
 io_uring/net.h   |  5 -----
 io_uring/opdef.c |  3 +--
 3 files changed, 12 insertions(+), 37 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 9472a66e035c..5794b941254c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1430,17 +1430,10 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-int io_connect_prep_async(struct io_kiocb *req)
-{
-	struct io_async_connect *io = req->async_data;
-	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
-
-	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->address);
-}
-
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_connect *conn = io_kiocb_to_cmd(req, struct io_connect);
+	struct io_async_msghdr *io;
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -1448,32 +1441,26 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	conn->addr_len =  READ_ONCE(sqe->addr2);
 	conn->in_progress = conn->seen_econnaborted = false;
-	return 0;
+
+	io = io_msg_alloc_async(req);
+	if (unlikely(!io))
+		return -ENOMEM;
+
+	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->addr);
 }
 
 int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
-	struct io_async_connect __io, *io;
+	struct io_async_msghdr *io = req->async_data;
 	unsigned file_flags;
 	int ret;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 
-	if (req_has_async_data(req)) {
-		io = req->async_data;
-	} else {
-		ret = move_addr_to_kernel(connect->addr,
-						connect->addr_len,
-						&__io.address);
-		if (ret)
-			goto out;
-		io = &__io;
-	}
-
 	file_flags = force_nonblock ? O_NONBLOCK : 0;
 
-	ret = __sys_connect_file(req->file, &io->address,
-					connect->addr_len, file_flags);
+	ret = __sys_connect_file(req->file, &io->addr, connect->addr_len,
+				 file_flags);
 	if ((ret == -EAGAIN || ret == -EINPROGRESS || ret == -ECONNABORTED)
 	    && force_nonblock) {
 		if (ret == -EINPROGRESS) {
@@ -1483,13 +1470,6 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 				goto out;
 			connect->seen_econnaborted = true;
 		}
-		if (req_has_async_data(req))
-			return -EAGAIN;
-		if (io_alloc_async_data(req)) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		memcpy(req->async_data, &__io, sizeof(__io));
 		return -EAGAIN;
 	}
 	if (connect->in_progress) {
@@ -1507,6 +1487,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 out:
 	if (ret < 0)
 		req_set_fail(req);
+	io_req_msg_cleanup(req, issue_flags);
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
diff --git a/io_uring/net.h b/io_uring/net.h
index 0aef1c992aee..b47b43ec6459 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -28,10 +28,6 @@ struct io_async_msghdr {
 
 #if defined(CONFIG_NET)
 
-struct io_async_connect {
-	struct sockaddr_storage		address;
-};
-
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_shutdown(struct io_kiocb *req, unsigned int issue_flags);
 
@@ -53,7 +49,6 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags);
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_socket(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_connect_prep_async(struct io_kiocb *req);
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index fcae75a08f2c..1951107210d4 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -557,8 +557,7 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_CONNECT] = {
 		.name			= "CONNECT",
 #if defined(CONFIG_NET)
-		.async_size		= sizeof(struct io_async_connect),
-		.prep_async		= io_connect_prep_async,
+		.async_size		= sizeof(struct io_async_msghdr),
 #endif
 	},
 	[IORING_OP_FALLOCATE] = {
-- 
2.43.0


