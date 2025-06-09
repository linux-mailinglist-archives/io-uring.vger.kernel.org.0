Return-Path: <io-uring+bounces-8285-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6288BAD2516
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 19:39:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 798C33B096D
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 17:38:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9533621C189;
	Mon,  9 Jun 2025 17:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WGT53i0p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F53321B9FD
	for <io-uring@vger.kernel.org>; Mon,  9 Jun 2025 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749490755; cv=none; b=B6vbyixEj619rTbI4JbvL3p3RgGsGHvaMXYW9+S7s52Biw/khoCdlYeMfJe217LgeJDsWo4NxIwZcwa8UaO39taLyeQgqzmJIatNNmDWE5QcIr01sHssnSyLlyvBZacxUoXmVEfqvqQts4QfQ1kkvozdtFz9InkzAfEMnrxQR14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749490755; c=relaxed/simple;
	bh=g+APxTQKXRTYsz6owFeZ+JlCf53hETF+sSeiIgJNf98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzGVBC6fwgRLGfPipreh2d1vQ7G3ZywRLk3VPIIGjielbqUSWdpcoGRqRDqhU72jU59BGW02BHAYv+pE0SVNa4PpV9Ij0kf5u+ANvKxOoWf6qPm/5j44sWrJEI/G1vpOVsvZFq3pTiUhToTF5MgTQfUHJkm28a6zB06MdQLF6cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WGT53i0p; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-86d0bd7ebb5so109503239f.0
        for <io-uring@vger.kernel.org>; Mon, 09 Jun 2025 10:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749490752; x=1750095552; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=72wHMGW29er2mMjStBMjhCbN10dSDbF3JE6FUGZU8l8=;
        b=WGT53i0pgVX9NyiNhc4Sftx4OGYhKPXIAHk3o/CWDFplm5kqiEYN15ANXaawx7B+m/
         XfyGQ3nj0C2cysYTGFnGJHNTnn5Z6LcsdwEhRULs4yaZzdgbeBb5lm6E+YECzZyI9GJ1
         C0Oka0L4sybonZmpNnNCKo/aaZCzGutsOFBan5M/yb7obGQJ6VATvJNmzYqx9CMOanrA
         ZEQrU8QB6GLry/HwoOsfb63Qhtb+BSOFOPYKOvKi8bvs+SZN0PbYwqmc7v0t7XGeu3E9
         DiEILDnBScXiSNOHL8nw03+nTcrWAcleDqXlZgXmt/DuND9NrITnvGdrqIVxiJ8DJVen
         FeQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749490752; x=1750095552;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=72wHMGW29er2mMjStBMjhCbN10dSDbF3JE6FUGZU8l8=;
        b=TK00N5WQ+cbcR9oFS+Z8JCxwCeT7X0GITJGnHwJYX81KJYRVRPtPsQtbU+uFjqyegE
         AHGkpIZJjPZAV/FkR0fJX8Xe6WymUy7MkQ/Dg4SGQt5BUoWR6afJc2Dn8PixoTPkwzyB
         AYv89aKCjRRsOmUSugVfrc0qSSaXy9ByQxMyaCq9/TjFZQW1JrnwfvxvSpckDfdGHgNW
         P/NKKTYaJ7/P289pT0Av17GUFDMlAFaze05wm/20HeHzTF7pri2dIx72s4AvFJzMz1o7
         HGdZV0lwlW4CD4P0zHGrgF5hbLwe+24slQIvHYzNndoXJ3rMAnDwfFcM0O7oOQZShUIj
         NdiA==
X-Gm-Message-State: AOJu0YzYkZ/nd0iFX952b1GxC56nUn0a7SgVGziRJOuoB4WqpGfLO2da
	0B2CR0qhgBg6kW54GO0He7m0xPuLaCPrbOjVx/YSQtV3/uqnbzDyEPDUb+53fObaZ1ivGFDy8hx
	WmMqj
X-Gm-Gg: ASbGncvFR8egb01DSwhlBEHCKLGxGGIGNYpDXgxbfd54LjzJKeJIZozwRZfOkQiFkRd
	nq63i7lJB7NHj2/mMdSQF+oCttx+0X8RNz28hUl4SFxb55tBPwrR5/Rtyi7zjT3MnT11OMZZMlf
	YTWLr8Iltoyb89aP3LxsKNNkiWO7sMLN1EME0G1wnoV2mzgQU1Agtl+QR1jytJdvUlpEl2hFlHu
	oS7Ai+GIcDngrOdlrWuCeiR00DIGqJzAYWmELVcXdIG0x1E9OO4/XIt8jEzDzluBulFjAYmuzEv
	E+EpZRfDUwYN0NjrASILU2odawHSFvgmeDOy0SvXsSw54pRGVjH/Fqww
X-Google-Smtp-Source: AGHT+IFvyRAzfMo9j2+6GHx9uYqzNAGxHqiCWTdJ30DyNP/EGSC0FyoeZvjV7HOC6R1w0rvTQtFQqQ==
X-Received: by 2002:a05:6602:3945:b0:864:4a9b:f1f1 with SMTP id ca18e2360f4ac-873366fcb5bmr1618840739f.14.1749490752116;
        Mon, 09 Jun 2025 10:39:12 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87338a1eb84sm166607639f.44.2025.06.09.10.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 10:39:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>,
	Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH 3/4] io_uring/uring_cmd: get rid of io_uring_cmd_prep_setup()
Date: Mon,  9 Jun 2025 11:36:35 -0600
Message-ID: <20250609173904.62854-4-axboe@kernel.dk>
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

It's a pretty pointless helper, just allocates and copies data. Fold it
into io_uring_cmd_prep().

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
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


