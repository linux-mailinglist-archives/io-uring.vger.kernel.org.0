Return-Path: <io-uring+bounces-2002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 542138D4F0E
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E77521F21701
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 15:28:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC0713212C;
	Thu, 30 May 2024 15:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sCkuRuX/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB20D839E4
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 15:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717082917; cv=none; b=CA354DIeNx0fiz/YP0lZXHTR6z93CPRxicG5GAVfflW4JRfhdilr7bX0cwjGLZmOf4C5oeYqtoMkV3nIH2g8rC//a8ahA8mdxu0QeU3zOuQw9KR/v0pYT+O5A0TcQ2QkF3+mZhcjYEdEW2OkVwq1piY88eK2I6bMpsxc1c73aVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717082917; c=relaxed/simple;
	bh=5h1TIwk485xzuo65BPvZ2GQeWf4HXjNF6I31wjce8EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku3tbiqJu1UPyeF9AJt1XpkFfv+niuv91aP3I9QAdFHD2QUHkIfK7UsFfKmXFdN1NEDD8QT6rsMTH80Zm5nvO58jNZb0iQ9H6L+jxGrR8pjWHlGzAZF6D9hQtf9AKTONP4/AcnVD7Q3ExLN7Ji2sNB+ZD1WB0bjYTpxKmfUB/b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sCkuRuX/; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3d1b5f32065so37656b6e.2
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 08:28:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717082913; x=1717687713; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iYXbRi7M2c1HqxvzjiKFqL80MUJ6pePfMWM0r/nvfyU=;
        b=sCkuRuX/jkUgNtJpzUPpruaXQkixC/fIX/RaEIkE7o+pzjqPLb+xhEcy/3f85uz2o/
         8cfkkknIOA7BxL2rxP4JxHW00XigGW5EQHb3Bd//MZN9k+WIwpcpTGx7Vdc2i2MKS5R0
         SEUfgh0PoKB/UQlHLQZOTMuTuAyT/7w5uTKczVNoFnxonB0bBlOlUR+XtLroPtf6wjTq
         lPtG3YnNJSR6NGgGjd2anZGePChi4FOMqxeiV0rQgYbnkGoA2cmPCGs8L+GDsZdfm0Qh
         J3KCgo404SjaAIpE26M1oRSCSmfWS0ECOZo1Q6qS571wRVT+mlimMu2N5RHlrz8jESM4
         j1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717082913; x=1717687713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iYXbRi7M2c1HqxvzjiKFqL80MUJ6pePfMWM0r/nvfyU=;
        b=PkIrdHMh8C0+QFcpryUxFGIMGW9AlOtIyw3xXEskoa6iyqvJg9OOrJpzwpiWfRWXjB
         8A/VM/YDRsE0is9DcMVhq92gJ819ZwWM41+5pzsu+eP3bKkkkk5WykJaQpf+7VDUHQzj
         3XLQUE9JJl09AEeRINOrGaLATrttTC75GIVhRfYwTvSVp5Xlx6Z+jsDsv00zwus62kuc
         hCKeFttd26OI/8W2ZH3F5Rktn8lZY+2G2qe3hli2MRT608ukx9tVNrMREMed8rmkVcV8
         uCrXF3Ao8O1/FfPpvZgdH2Ku+q+xGTM8RU9pCSiTuDLPo4JS8BzY2l0mOXqE2s4S8LHh
         OxIg==
X-Gm-Message-State: AOJu0YyLc6UVBtYODimTnvD3j0QEON0TaQQFekQGtABQ3X5sD6jIu6Da
	6kC7ltZ0CYKcdYsgangRqmDkmzFH6ALl92Ku6S8Zh4O+tiLlS7LN8sDUj2yIbbyuPTvBDBKklNK
	5
X-Google-Smtp-Source: AGHT+IGJoG2Y4LxcGTgiPojUK0jk3S73/+ZV9d23fCQu8V1VMs/tIU9t5cCc/uYDvprxMpJwK8OstQ==
X-Received: by 2002:a05:6808:1903:b0:3d1:df5a:2e01 with SMTP id 5614622812f47-3d1df5a3ac4mr1658766b6e.5.1717082913172;
        Thu, 30 May 2024 08:28:33 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b3682381sm2008136b6e.2.2024.05.30.08.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 08:28:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/7] io_uring/msg_ring: split fd installing into a helper
Date: Thu, 30 May 2024 09:23:38 -0600
Message-ID: <20240530152822.535791-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240530152822.535791-2-axboe@kernel.dk>
References: <20240530152822.535791-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No functional changes in this patch, just in preparation for needing to
complete the fd install with the ctx lock already held.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 81c4a9d43729..feff2b0822cf 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -173,25 +173,23 @@ static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_fl
 	return file;
 }
 
-static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flags)
+static int __io_msg_install_complete(struct io_kiocb *req)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct file *src_file = msg->src_file;
 	int ret;
 
-	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
-		return -EAGAIN;
-
 	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
 	if (ret < 0)
-		goto out_unlock;
+		return ret;
 
 	msg->src_file = NULL;
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (msg->flags & IORING_MSG_RING_CQE_SKIP)
-		goto out_unlock;
+		return ret;
+
 	/*
 	 * If this fails, the target still received the file descriptor but
 	 * wasn't notified of the fact. This means that if this request
@@ -199,8 +197,20 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
 	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0))
-		ret = -EOVERFLOW;
-out_unlock:
+		return -EOVERFLOW;
+
+	return ret;
+}
+
+static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *target_ctx = req->file->private_data;
+	int ret;
+
+	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
+		return -EAGAIN;
+
+	ret = __io_msg_install_complete(req);
 	io_double_unlock_ctx(target_ctx);
 	return ret;
 }
-- 
2.43.0


