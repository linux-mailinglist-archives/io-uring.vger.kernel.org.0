Return-Path: <io-uring+bounces-8286-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BA708AD2518
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 19:39:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B6B8188C940
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 17:39:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE6221B9FD;
	Mon,  9 Jun 2025 17:39:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iN6s32tL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7B0121C18E
	for <io-uring@vger.kernel.org>; Mon,  9 Jun 2025 17:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749490756; cv=none; b=CVb4sKrnbWMY+nFSno1Er1+S9WykEE3wxybptUrG7xnM0mzGJNogAlyGt0oEm9bFr05MWgxkCgwXbEzIAn/hTG7lRFbQ3C+mcJs/RaG6E/QxRvU7wBji/Dn0c6UrI8YiNh2Pc1rjm/yoT7N7mgZX/44TiRw21dnly+Kzv30xyKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749490756; c=relaxed/simple;
	bh=17fVATDwFpYOBnwIqV2RZwSGNL9+H+DvrO0u9e+KL3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=recH++pRdKsiiawXRBL3psT+jFQM7zhICYWhiVSUTW1Bf68gUy6bOW1UqhqR9p8P8CTgSTyNNT7MkwuTZOcmDgL809SJHdQtk7iRqmzIIW/OICjFhTqWscn5EH/rvoUukkarSZYhSBrD/JKysEATZHHmB8MoVI24xHQVv5ABoCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iN6s32tL; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-86d00726631so93258039f.1
        for <io-uring@vger.kernel.org>; Mon, 09 Jun 2025 10:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749490753; x=1750095553; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iaBNO3QGfghxuWbzTJ+OIZegAJYfbh9YP3iDMHuYK30=;
        b=iN6s32tLj8J22joFjY6weo9B5l2SWzF6ZZiJf+w4DKtwWGzBjXRmzxSxi7NtOGyUhV
         /nGVAlhPWVlcw2SZ4YsY/vnDkUd7aTP4pzk+KbFQxflh+UVxpPSNuQ0H1cPw05RDArHv
         VFRoPogI1+uD/+UISMQqO64jmwtmATg8813Ve6AjPglUxbbQCnmLSm3Rg+oaDFAkQ5o8
         OMH2L3eyNOoQkTH+2tfJyrAGI73VZ8nAOBmitbKJN4SAevRqvI9RwXzb880YgGo6fbB9
         lYEHA7SuwePWl9CWL31o0oeL3ZutrFw8WJk6vwwfJEZbnlDAmklj+FNth82lXMBtdhXp
         nEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749490753; x=1750095553;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iaBNO3QGfghxuWbzTJ+OIZegAJYfbh9YP3iDMHuYK30=;
        b=iljVn/SopnFvQLfgo+kb30tO0f7NxLxhb8woXfPe0p7GMhqqsaz7rnAolq05LpuOWv
         QwBVX+DDgAQqu0iohD1Cqaug7RzEWzF/nu3nYvRhtJqw3n8v5b0aolqiewUBzvISio90
         XraRXVoH0/8B6DBY5oRbL5Lge6JoFd4DAXpz2IAUb+NoOnyLijCXlNLMJdfAJJ56PToU
         e9yGfvnd/5LWx84I7N6KEEtGW5XMIJworWnmlQ/k06AXsJ8g3++Ea8y/FDTRYrZqaviI
         vp8+gWQy0Zn4XJ4efr+GJS7XPbpZmNX2aP9/eE66GgvsrWQXII3LxGhEuHyxWuQUC0NB
         YHfw==
X-Gm-Message-State: AOJu0Yxj0jkeJKDLB7w7QMptWWy5tgg8uN2ApnkiNUgeB9toRnBqcx3j
	9R5WYdfH/ZhCJlbXWFJk06cee0PljuQcDIumPIruRBNBDVWnBLcJzQ0+fJhbNbtxyrqpZxNuk6r
	Sjep9
X-Gm-Gg: ASbGncs6sKGD+BZfBnJPZEwa3H3vtX0xJ+vP+2HO4f7bldAvDhQboMbxM4P10kLQvzK
	efuGqGT32hF5wN+UtAMWmz5DRI4IwFytPmCFcQSK0VPeaZ75ArjfVPWPz/LF3iQ8O/bA3Iu3yKk
	yvE7QrZikdQJmqpXk60VRdUVXrjzjSuP+B2UyvodyL/xwE2FZawSk0fh1FOqKfNpRu5j6WHQD7B
	jDzfNXKfbVIwex3HyKDC3pRquf228OqZhzXh8M9GlwSVGlG2A8lmy9rMvFoW4pQqE8UsXThWiGu
	kFuNrDDdFp7W4vIWMRm+p0oGUhJrjp482Me/dtdOAfJWFeHsdEfm3U05
X-Google-Smtp-Source: AGHT+IFB2vGNAYl4TwJ/Z2k/ekPIPp3P6MG++SxEO5u5hueSQ2TnjXa5m5HiIZWDqXcnpA0TzbVqxQ==
X-Received: by 2002:a05:6602:7216:b0:867:237f:381e with SMTP id ca18e2360f4ac-8733661613amr1625117139f.2.1749490753495;
        Mon, 09 Jun 2025 10:39:13 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87338a1eb84sm166607639f.44.2025.06.09.10.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 10:39:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid unnecessary copies
Date: Mon,  9 Jun 2025 11:36:36 -0600
Message-ID: <20250609173904.62854-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250609173904.62854-1-axboe@kernel.dk>
References: <20250609173904.62854-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uring_cmd currently copies the full SQE at prep time, just in case it
needs it to be stable. However, for inline completions or requests that
get queued up on the device side, there's no need to ever copy the SQE.
This is particularly important, as various use cases of uring_cmd will
be using 128b sized SQEs.

Opt in to using ->sqe_copy() to let the core of io_uring decide when to
copy SQEs. This callback will only be called if it is safe to do so.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/opdef.c     |  1 +
 io_uring/uring_cmd.c | 21 ++++++++++++---------
 io_uring/uring_cmd.h |  1 +
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 6e0882b051f9..287f9a23b816 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -759,6 +759,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_URING_CMD] = {
 		.name			= "URING_CMD",
+		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
 	[IORING_OP_SEND_ZC] = {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e204f4941d72..a99dc2f9c4b5 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -205,17 +205,20 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!ac)
 		return -ENOMEM;
 	ac->data.op_data = NULL;
+	ioucmd->sqe = sqe;
+	return 0;
+}
+
+void io_uring_cmd_sqe_copy(struct io_kiocb *req)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	struct io_async_cmd *ac = req->async_data;
 
-	/*
-	 * Unconditionally cache the SQE for now - this is only needed for
-	 * requests that go async, but prep handlers must ensure that any
-	 * sqe data is stable beyond prep. Since uring_cmd is special in
-	 * that it doesn't read in per-op data, play it safe and ensure that
-	 * any SQE data is stable beyond prep. This can later get relaxed.
-	 */
-	memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
+	/* already copied, nothing to do */
+	if (ioucmd->sqe == ac->sqes)
+		return;
+	memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
 	ioucmd->sqe = ac->sqes;
-	return 0;
 }
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index e6a5142c890e..a6dad47afc6b 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -11,6 +11,7 @@ struct io_async_cmd {
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_uring_cmd_sqe_copy(struct io_kiocb *req);
 void io_uring_cmd_cleanup(struct io_kiocb *req);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
-- 
2.49.0


