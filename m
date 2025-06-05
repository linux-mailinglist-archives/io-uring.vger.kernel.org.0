Return-Path: <io-uring+bounces-8237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5AACFACF845
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 21:48:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0364189DED4
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 19:48:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1070A27CCEB;
	Thu,  5 Jun 2025 19:47:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RzLFXym1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE8027C163
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 19:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749152859; cv=none; b=rpsl2lCGyWunuSx44OFMoQPLPs7xODCz14EUgcQEqT9sqjxDV5IZwjvbmjV8O1F+g3Mt10UO1G3/eBEQRYAzKvuKVlnDEl3Zak6wE9f256F+4zyBkEKr0b9WetYDeqYV6W7LA2WXZ++y2fNr7dYqN7tIma3gtxDOZvZCcyWGnEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749152859; c=relaxed/simple;
	bh=nij8009+aH92YVWZ4VEdZHbO2xiEnWHsL18ntdrqaV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfRDZgxYmC+PbCihM5BsOa4zggVvSd7kkh82WrfcgTf7zcNM28SuXLF4xc5waSeqepsPUTXaXMyvC27th8nIE7XQvXWidfYTNIMeVmIl6Eq4Fd/SOG+3HDuWs6v0/7PX7eXwSyDYx3S9qUtIrza5jEq/5N9Sm0uBWNC+5H5TeY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RzLFXym1; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-86a464849c2so46945439f.1
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 12:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749152856; x=1749757656; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=so+ZsnOqqQRoGCtlXDVO6FDwAe8kk6OopdWs6cTWQig=;
        b=RzLFXym1yqKrgJ2/2LnAiMe9/JOEFQp0mX2dwdhARYLY5iZk4YpKd7vaR6E8ua0syv
         uMnco7n1/zXkS53U2aV90ozonUMwQV1MzWjwHAqd3ReVvmWmzfjY2ZwQQANVSNkjENwH
         RYBk8aaFCJY3nrCK+xvgmBF0P8On7ZsF7H4Z4zAP+CNlBu9TdxQpnQv+u7WlCXnzT5T3
         tdjKJXzhmrnYZWVuJHkWcZj5jOtKuqp8PwjKmXZ6KbASJiAhWySvprc1BPzRJz/UdhQT
         GfZsGPRel+jKayBnLGwABN8LN6VjRI86jKTDdDgKPeBVq36f9HX7w2ykTW8isOhwD5sh
         08mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749152856; x=1749757656;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=so+ZsnOqqQRoGCtlXDVO6FDwAe8kk6OopdWs6cTWQig=;
        b=OOXIkF3HMK62KbXZvv9J4zjogHDbkwCGGqwEuXbqsBncSO5/0nUKXeJ5pRl/lUKYiO
         HY5UuuU5IQNdUGBAOuQKYFQkNrJylPEeUwZ9+mreYyTK6qmNyPRvkqE5zsKX9Z217KeC
         ZLMR4ieTWY8glKATlbOorSZREnRGgcfNW4aRPssqPbT8Tj0jwiCGp7xwhcMruxmB379y
         B0qh5LQ6VqWCnkUy2MavgWR9fB5kEGRxiEDfeVbyXE6EbbUyQEilqcQUg7OJL/lapQWC
         a70A4aXN/ymiOV8fsWQRzXulHnTJnqQFL4ihWhat5WrY6KiFJdXHQclKkliLZ51tRpuZ
         cLWw==
X-Gm-Message-State: AOJu0Ywfq65YLG+go5axJow9RVE/abYORb76qwKrftWKIAItLEt/aWKY
	C/NkbdPNwdPRlUNbji/u3Td3Vmlwd6eC1wqNG7qBbtPdhhcnXcpw1sGmkDQo/kEuwpucZeU8ge8
	vefeq
X-Gm-Gg: ASbGnctz4mqpJqVghI/hk9GzJvYFMgFiMXST91Sm4S6D+YUiwQKR3hCJjiZGrUctyd6
	ptAw4XmBhGdWxtKm0LA0CEXc5eUOijapTbx04n2mCymxLbxjbLnJDo/yc0rDU0k1pm6B5bGSdLq
	QrRf8RNjklsLMDd3ywS+A3pQhataMGdo+mbnZuC2RZ7rvuchD5MAuU7QSvaUhLDJKl85idvcwF+
	am+aMcP1cLJEm9pLqIv9/2Vawh38AYU04D2LGddTdlnbVLlE+wPMtuBkeSz56NMTh1egEP3PZ8S
	fS33M5+sWUQ58lisVWIi2OBjoUTf9ZItug1w7Nu2F1e8zRD/ftTTuP3y27hI+/zoOg==
X-Google-Smtp-Source: AGHT+IE91z+NmCPzg+OliTKB5+WJoz+ZFGxV9Nef6eOdj2AggGlrfqT2DWNTMc3wGaOL8JocmyqYVw==
X-Received: by 2002:a05:6602:7213:b0:867:16f4:5254 with SMTP id ca18e2360f4ac-873371c1185mr67728839f.6.1749152855871;
        Thu, 05 Jun 2025 12:47:35 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-86cf5e79acfsm317783639f.19.2025.06.05.12.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 12:47:34 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/uring_cmd: get rid of io_uring_cmd_prep_setup()
Date: Thu,  5 Jun 2025 13:40:43 -0600
Message-ID: <20250605194728.145287-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250605194728.145287-1-axboe@kernel.dk>
References: <20250605194728.145287-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's a pretty pointless helper, just allocates and copies data. Fold it
into io_uring_cmd_prep().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/uring_cmd.c | 34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 929cad6ee326..e204f4941d72 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -181,8 +181,7 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-static int io_uring_cmd_prep_setup(struct io_kiocb *req,
-				   const struct io_uring_sqe *sqe)
+int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
 	struct io_async_cmd *ac;
@@ -190,6 +189,18 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	/* see io_uring_cmd_get_async_data() */
 	BUILD_BUG_ON(offsetof(struct io_async_cmd, data) != 0);
 
+	if (sqe->__pad1)
+		return -EINVAL;
+
+	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
+	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
+		return -EINVAL;
+
+	if (ioucmd->flags & IORING_URING_CMD_FIXED)
+		req->buf_index = READ_ONCE(sqe->buf_index);
+
+	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
+
 	ac = io_uring_alloc_async_data(&req->ctx->cmd_cache, req);
 	if (!ac)
 		return -ENOMEM;
@@ -207,25 +218,6 @@ static int io_uring_cmd_prep_setup(struct io_kiocb *req,
 	return 0;
 }
 
-int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-
-	if (sqe->__pad1)
-		return -EINVAL;
-
-	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
-	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
-		return -EINVAL;
-
-	if (ioucmd->flags & IORING_URING_CMD_FIXED)
-		req->buf_index = READ_ONCE(sqe->buf_index);
-
-	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
-
-	return io_uring_cmd_prep_setup(req, sqe);
-}
-
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-- 
2.49.0


