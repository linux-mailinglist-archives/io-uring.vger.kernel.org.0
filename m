Return-Path: <io-uring+bounces-1157-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C05E88090D
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7ED4E1F244F9
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 221DF5CA1;
	Wed, 20 Mar 2024 01:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="bry3kIQS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77124747F
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897804; cv=none; b=LGkFldNHTBy4ksmcMsnPfe6D3hJSORMJ7RoR0oZYFqIgysxMkDBlYoaDQ/T/0lMCOrUxoj/MfIgbxmKl/xqchSc7cdYJ6zrzBGXSO3xLRAvXzC0aBpavJZKALqbBM4x/yZZGXl45lyt3hpx6Fa+O6og8JWc2g7ZTkGq5I39l/cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897804; c=relaxed/simple;
	bh=zOLolhSc9/Eqwo7Wy3b5pFoWLFFxhzd0SqPQBnjbOGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFKe8D+xCkxfJUVSeBtlZt540jT9P/DJJ5nt3zfv3m2OxQw2Nau9qKgoZXbZ6fwi+An1p9PJbF+KREGbMR1574xsvi3mXpSGfNy5IWdVSu5iJNq0ShsZEMNA7kBiiTa4LcJ6hpL7u6uPtL8wK7Xo3o/ewlZr9p64N+Ae7spPyho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=bry3kIQS; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-5a46b30857bso871960eaf.1
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897801; x=1711502601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L4rmuK/7dZjd4CaRMeFqboSSutQU3yibk6XIDIyy8gY=;
        b=bry3kIQS6+Rpz3ySR1HU3+tt/JJWgUc7wu1nKIKEIUxlVkE6PEWbC3D7pK9mo5AWKy
         pMko/WxjsKVFHyGBLj408L1H0R0Vm/OoDnWUGdNAumqWqxU8waDlKG34lc+/eS1pPf8k
         D+7q5M52lqQtj8g5IqH7SkaOC05nLBQoJ1BUlYxs2WNe+vLeU66QjDvBOUAmJgIHiypC
         UOAVZUrlX/BOQrniGaXlzqY0+Ay2pu9hSRRsYJaM2enveDFeedwq0ojNwKJpSCUdOAGb
         gCn2oCJPc3i2Ri5QreFn5AumRHWBEH1VsA26wc+NGCulNtcqFh48VuxyELsMD+6vGpDB
         4nXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897801; x=1711502601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L4rmuK/7dZjd4CaRMeFqboSSutQU3yibk6XIDIyy8gY=;
        b=rWznhzGGHpbX+Q3p7DIRbFc7jAZBoHLW6dEa938zFilKqZorIHmkRKcLR1gVEK7GWK
         EJA2p+gNP8jjVul1/qxIUAk/Yu+NY1GMOK5dX0K+Gb17bF6UkmTO6etUnZtiPs1MicYr
         2z3E3nhRrtsWCF410bUweuGM8FVXDtraptIixQntsEHqxy0NxyelD8UYXzblMHjaQdq1
         ByfW+ob8ETLYzHYPx9V58flrcuctQtDdCfwEffAX2nbzh6ed3GZUKEbAdEyqxKdedqMx
         FicAYQz0ui1wnm22tVoBqK609XleruUs8Md3XX7S9YuEmctVHoAyriYU/dcR5Ssf3xUJ
         p5lQ==
X-Gm-Message-State: AOJu0YwPuZ9d6PqrPclnf+tOVGcy0icLEtcTeZjl49uXJVUXBRug4o+a
	EaDYE3xrKQpzj2pVDAym1KJnnW+hBPSNm/hvoCLCCOeGQFaPzaw3rw2Btn91/WhiBDqP73gFqIo
	y
X-Google-Smtp-Source: AGHT+IGgxi/Xn4c4xaSD11DL2tExDZcrHmxd0qYoPVLGfvkKQB4UJhg+WwcRqDrp3pfH8OeSBPKpsA==
X-Received: by 2002:a05:6820:288a:b0:5a2:26c7:397b with SMTP id dn10-20020a056820288a00b005a226c7397bmr356045oob.0.1710897801327;
        Tue, 19 Mar 2024 18:23:21 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/15] io_uring/net: move connect to always using async data
Date: Tue, 19 Mar 2024 19:17:41 -0600
Message-ID: <20240320012251.1120361-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320012251.1120361-1-axboe@kernel.dk>
References: <20240320012251.1120361-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Not using an alloc cache, probably not that needed here.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 38 ++++++++++----------------------------
 io_uring/net.h   |  1 -
 io_uring/opdef.c |  1 -
 3 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 82f314da1326..60b8c7f58fd7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1422,17 +1422,10 @@ int io_socket(struct io_kiocb *req, unsigned int issue_flags)
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
+	struct io_async_connect *io;
 
 	if (sqe->len || sqe->buf_index || sqe->rw_flags || sqe->splice_fd_in)
 		return -EINVAL;
@@ -1440,28 +1433,22 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	conn->addr_len =  READ_ONCE(sqe->addr2);
 	conn->in_progress = conn->seen_econnaborted = false;
-	return 0;
+
+	if (io_alloc_async_data(req))
+		return -ENOMEM;
+
+	io = req->async_data;
+	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->address);
 }
 
 int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_connect *connect = io_kiocb_to_cmd(req, struct io_connect);
-	struct io_async_connect __io, *io;
+	struct io_async_connect *io = req->async_data;
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
 
 	ret = __sys_connect_file(req->file, &io->address,
@@ -1475,13 +1462,6 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1497,6 +1477,8 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 out:
+	kfree(req->async_data);
+	req->flags &= ~REQ_F_ASYNC_DATA;
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
diff --git a/io_uring/net.h b/io_uring/net.h
index 783dd601a432..9b47d61a9cf3 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -55,7 +55,6 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags);
 int io_socket_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_socket(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_connect_prep_async(struct io_kiocb *req);
 int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index fcae75a08f2c..065c92c57878 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -558,7 +558,6 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "CONNECT",
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_connect),
-		.prep_async		= io_connect_prep_async,
 #endif
 	},
 	[IORING_OP_FALLOCATE] = {
-- 
2.43.0


