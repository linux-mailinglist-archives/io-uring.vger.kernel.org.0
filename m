Return-Path: <io-uring+bounces-1074-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E525787E15E
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 206A21C21399
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E147D2232B;
	Mon, 18 Mar 2024 00:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OVO5+WEc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDF221A19;
	Mon, 18 Mar 2024 00:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722635; cv=none; b=licibyaJ/61Hwy4UyUuRIvXEtuHZL9vHGTMSMAcqat7+T6QK6UuFqFv+DeokERqSMYeow2KW5MSKIJMCcbnq03SiUeXFCUsa5vZ6/CvFvZD5yI3+Kz0hCn+cIx+Msv+mMXjy9PWarbqRAxVpXwDqDNN1q/tiFc+AbzmTbopG00I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722635; c=relaxed/simple;
	bh=i0Hj4ZJyn+qslQjM0g9NmEqa1lCv6CqW2NFU4mBV/4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqs3HgtR3BAxHMeCsH5CQdOB2tBevaf78EeWnjoBnnQvKEAiJ1+P9MWfzBnJurDYZk9Rl+osZTilTsWf81XtcLn3IW/8HpjUl8l/liaDCicH32mA7tAx/45hPyRQOi9+O4oo8TuYyeJwV0K7XBLUuSAdkR8VwWTNju4ZxAEBpL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OVO5+WEc; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-513da1c1f26so3759614e87.3;
        Sun, 17 Mar 2024 17:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722632; x=1711327432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=glxNnNtmfNsWk//vdNi4gUCF0HOiRABAhUOOJS4lOws=;
        b=OVO5+WEciHioOAkUvPwgo5dLB7Nrz7t9DHHU7KQ/CvvFECH3W8FjKYx6CGcIxkQsZw
         QWJhR0iHVMalTjiA7QTGHZIaytkEhAsp/YUr53abzJvEAuK9VLBgdI0n/PvtdhzWhV1i
         QBWLqGu3765Pq7rGC7YEoKgHoQpZ25gc6RYZVPCrtf22ZMXrUnl9jaOmXpsU69ZU9PcZ
         U377JanAHBuhGxaxmcZkG/nd07QlLMc/KYV6gyTptAMhfGqd/M1yZ64BmngcQQYI1b82
         oL4Ap5fzdlvGNMiWQE4zLgkzJoC5lV+5fKdAfCdyViFPQYAw6V8j3j/4is0lcfEYGOHE
         FtcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722632; x=1711327432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=glxNnNtmfNsWk//vdNi4gUCF0HOiRABAhUOOJS4lOws=;
        b=Fu6oQsx4khmBnF9lrRWfRUTLa72e2gPMDQLmbEIzyMOrHdrOR08MnFLrLXzTUzoDLs
         +CVbyPhI6ZP08pegU6ksyGB/KQD74xHbTSRWFhCL4xMEnwaabB8Im7k5w4BOu1cK3V1y
         GSxJeJJwdGwpuGXh51cy8MQIaNp7fysahi0eu82DCn3KJhu4jbPBz3jgZgbiWQifoml8
         cTWkSfHwFc7pZbp/ct1E2ewrmwXhJTxi2IeLdFUjwGU2QRO45ESFE7J+K1LBHVLNuDmm
         XOzY6juTvFQnV7KOjqljOUQ1Lz1pg/9UW7fLywTKTFeyF+M40Y1n7WbMApGe2lIYyIrJ
         iSzw==
X-Gm-Message-State: AOJu0Yxwz/L/KgK++8P49yN4fdYem8c3fFxz7HWKABWkxvt6b/2XWOiP
	aR6TuS3o/BhjUB1fEDwEMlT3PDya+7UWgzTTR++CwmFLMsQ8SE2aTj8Yxn14
X-Google-Smtp-Source: AGHT+IFQNKagcRwQtrYAYAucEd2H5Vhhb3L1d+K2JiCynErIw6OO3RwKIguNGLzwBVCIcgY7tkGwwQ==
X-Received: by 2002:a05:6512:3087:b0:513:cfa0:b688 with SMTP id z7-20020a056512308700b00513cfa0b688mr8584863lfd.60.1710722631943;
        Sun, 17 Mar 2024 17:43:51 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 12/14] io_uring: remove current check from complete_post
Date: Mon, 18 Mar 2024 00:41:57 +0000
Message-ID: <104a91a59f1c3a1af938ce7c1614f4a3e659bef3.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

task_work execution is now always locked, and we shouldn't get into
io_req_complete_post() from them. That means that complete_post() is
always called out of the original task context and we don't even need to
check current.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/c6a57b44418fe12d76656f0a1be8c982f5151e20.1710538932.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8c485bcb5cb7..0b89fab65bdc 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -978,7 +978,7 @@ void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (ctx->task_complete && ctx->submitter_task != current) {
+	if (ctx->task_complete) {
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
 	} else if (!(issue_flags & IO_URING_F_UNLOCKED) ||
-- 
2.44.0


