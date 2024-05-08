Return-Path: <io-uring+bounces-1831-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 341AB8BFFF3
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 16:27:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7A7B1F22F00
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 14:27:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA4CB85623;
	Wed,  8 May 2024 14:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MuTZqe48"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10F877624
	for <io-uring@vger.kernel.org>; Wed,  8 May 2024 14:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715178451; cv=none; b=uJHKF6ZR1nf6of93jC5l8x/GXKtPz01GsoUlwY0i8OCk2aAWsPaAKxkQ8Sq5mpMosG9op6oU5XQNjbtVKw/N41QjQcqV3SfZTFEloLwKhv1AiWHQuNebVtL6lnX9rxMlJeP5QUqVG6nxFllqlusU9mpMDfnjaE/azL91jR1C/Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715178451; c=relaxed/simple;
	bh=ngeGAEp/ZBKHhQhDu65N2XXViW3ET3T58id989WUgew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t+mUdqQK45ikJi5NKqoAb0Qew6nQFY4X3MWw4+5zSMt3KDzBKUsa4WNrl+HAEl+F132TF/QMbUdf0BoAUz8B3djTVA7skCGOOtP2TnJ9f9eP2Tu2mt79pZwxDnKurhMh22kzsNytDYNEmWpNd1O4rf6ofyY6i6QZ8ec7cJxKwX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MuTZqe48; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-7e17a11da38so20494639f.3
        for <io-uring@vger.kernel.org>; Wed, 08 May 2024 07:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1715178448; x=1715783248; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HS+WCfJSQkl2qkWfmJpt8e1SuovUq9/OToUo67UUpKg=;
        b=MuTZqe486AWtpmI4oi0Q4RD2lsi4knW9n6nkCBnF0GeOOfYFfv/DWOVt0gi2J0qdwy
         JI/1wj1uyXYAhnsUaZXFxtbdBlxBbx2Y68FdJwUrSn5o2jN8LyCeotcU32PdKdIeF3Em
         IRE8QJivyp2uqoxoT5HE5qNa2GrGjtW0WLMc5DvygOknq4Zyt3sCGq4gDlc0vuMAFzRk
         Hu3FMLnOv+J+rfG56O+a0XfpdEqHFE1f9fbirBKmyse7BYpi45HnfeTXyO1uxmpstni0
         pq3H3kKMLsCz7n3WRG1o8S3Ok9mO6sKLj8d1GUiSICOWaFItew1IfPnI85Ch67YiZXgt
         LElw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715178448; x=1715783248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HS+WCfJSQkl2qkWfmJpt8e1SuovUq9/OToUo67UUpKg=;
        b=Icy3cK0hcCZ8tovDb9HP6RlCe6pVRhV32i9Xlkqz+hWYadx5vmRD5FuVePMheWjRyu
         8Kjtk10oRSXR8LAIGAGINfmM4hfN2MazfxMajdoOtWp0dP5ZTH0LH/zgCKpvUPQm/Opr
         oFyV+KXhY8UEwhYoO4qJemcFEiU09dQxCe9Bm+Qkg99NtPCZJveH1HBn5cakxMQPZWhP
         NG0D0YUbNV5l4/8KaQFWfcPAhZmcyF83p+9iAhSJpOvNImPcG/FnDAkeobNVOn5/cYtU
         WvGb/LNp/m+EgLpLd7TBGXCEEAr2+c0N7xIHcqLq42RqVnmzNFRPkttjzZEA1PuX8nH+
         yrng==
X-Gm-Message-State: AOJu0YxVLx8B7dURGnyqpMovV64AZK7dau54eu85t9v8vGPlM/+XgAUa
	K+cCUYSSIrTg6f4LB/7mBAezUISTJol5pZodt75DbNF5mndfeVkdeMn8U0K0B5lx86qP4FOMX6I
	h
X-Google-Smtp-Source: AGHT+IFpizDDpQB2G95by4GozZFZijqbiPqwT+G9bbKANObMpGbJbuf0SfgXhKO3nLMlAnPB391qHQ==
X-Received: by 2002:a05:6e02:1c2d:b0:36b:2a68:d7ee with SMTP id e9e14a558f8ab-36caecd9fbamr28890935ab.1.1715178448268;
        Wed, 08 May 2024 07:27:28 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k10-20020a92c24a000000b0036c6ebd0455sm3180672ilo.88.2024.05.08.07.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 May 2024 07:27:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/net: add IORING_ACCEPT_DONTWAIT flag
Date: Wed,  8 May 2024 08:25:36 -0600
Message-ID: <20240508142725.91273-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240508142725.91273-1-axboe@kernel.dk>
References: <20240508142725.91273-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This allows the caller to perform a non-blocking attempt, similarly to
how recvmsg has MSG_DONTWAIT. If set, and we get -EAGAIN on a connection
attempt, propagate the result to userspace rather than arm poll and
wait for a retry.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/net.c                | 15 +++++++++------
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f093cb2300d9..4a645d15516f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -379,6 +379,7 @@ enum io_uring_op {
  * accept flags stored in sqe->ioprio
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
+#define IORING_ACCEPT_DONTWAIT	(1U << 1)
 
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
diff --git a/io_uring/net.c b/io_uring/net.c
index b0bf8471ecb7..7861bc8fe8b1 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -28,6 +28,7 @@ struct io_accept {
 	struct sockaddr __user		*addr;
 	int __user			*addr_len;
 	int				flags;
+	int				iou_flags;
 	u32				file_slot;
 	unsigned long			nofile;
 };
@@ -1489,7 +1490,6 @@ void io_sendrecv_fail(struct io_kiocb *req)
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = io_kiocb_to_cmd(req, struct io_accept);
-	unsigned flags;
 
 	if (sqe->len || sqe->buf_index)
 		return -EINVAL;
@@ -1498,15 +1498,15 @@ int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
-	flags = READ_ONCE(sqe->ioprio);
-	if (flags & ~IORING_ACCEPT_MULTISHOT)
+	accept->iou_flags = READ_ONCE(sqe->ioprio);
+	if (accept->iou_flags & ~(IORING_ACCEPT_MULTISHOT | IORING_ACCEPT_DONTWAIT))
 		return -EINVAL;
 
 	accept->file_slot = READ_ONCE(sqe->file_index);
 	if (accept->file_slot) {
 		if (accept->flags & SOCK_CLOEXEC)
 			return -EINVAL;
-		if (flags & IORING_ACCEPT_MULTISHOT &&
+		if (accept->iou_flags & IORING_ACCEPT_MULTISHOT &&
 		    accept->file_slot != IORING_FILE_INDEX_ALLOC)
 			return -EINVAL;
 	}
@@ -1514,8 +1514,10 @@ int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
 		accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
-	if (flags & IORING_ACCEPT_MULTISHOT)
+	if (accept->iou_flags & IORING_ACCEPT_MULTISHOT)
 		req->flags |= REQ_F_APOLL_MULTISHOT;
+	if (accept->iou_flags & IORING_ACCEPT_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
 	return 0;
 }
 
@@ -1540,7 +1542,8 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (!fixed)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
-		if (ret == -EAGAIN && force_nonblock) {
+		if (ret == -EAGAIN && force_nonblock &&
+		    !(accept->iou_flags & IORING_ACCEPT_DONTWAIT)) {
 			/*
 			 * if it's multishot and polled, we don't need to
 			 * return EAGAIN to arm the poll infra since it
-- 
2.43.0


