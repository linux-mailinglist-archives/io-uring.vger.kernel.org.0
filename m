Return-Path: <io-uring+bounces-8282-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ED231AD2513
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 19:39:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D798C3B06FD
	for <lists+io-uring@lfdr.de>; Mon,  9 Jun 2025 17:38:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4ABA721B8E0;
	Mon,  9 Jun 2025 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FrVUe0Gs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C8021ABC2
	for <io-uring@vger.kernel.org>; Mon,  9 Jun 2025 17:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749490753; cv=none; b=o3ofd6z0YSCptiN11zh1KCLlMxQZqjEZcBGs0szmHMqQtLDTGHvyDpz4Sru4ApYiH9PmTk/mq9nAH5uOigJyGBmJrtaFYQHMhpITMCX8mtuhJ7UYc3bIqZ6pgmRFsHkqlrfgMZvosxBmOIPIioDmQGFFUkKp4zEjssNtbMUPZV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749490753; c=relaxed/simple;
	bh=xe4TdDifyTiAtD8ujjZyQOcard8pvJYIMvKtTxG0oWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRpiJGqvKQw8q2JBgaFb88D9rbcJmmnMYltU6HR5/ZtTuHL7EGvTcl91h0gXuu3JFvFl0nyFdlHTNP+VtFi3m7Gb5jT3GPG3eejlh+y4dITMEsDq2yfRl4b9B2z9aCVhFx+xBCHzB2KgXBng0LAW1jEizKE4Bg+BSUnLM8N0XBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FrVUe0Gs; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-86d1131551eso131200139f.3
        for <io-uring@vger.kernel.org>; Mon, 09 Jun 2025 10:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749490749; x=1750095549; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKm6RQm0xvheY9Wq7P4wJobbzcwsRd8lkGrR/lI30Dg=;
        b=FrVUe0GsikLjiGEWmpAoa5B1BRJtHUZdDI6vv1IjeZEd4Qm3d42Bx60v32CeE2tZxT
         GqQU0BHVqPgeywmv/rSiIBDS1Ii6MVArcjk1321oDtH8J2cz5P0Dwrsn1fmG9yRF/i5N
         9zxydk+Oryx8znfW94K3L6N1Bi3ADEaE8I26etOeNk8W6l9QGoMHsuRbjFjJThvnwfrI
         kKAHmaInoqXIZg4Lzo+1QK1Ka/FLNTw8JY/DVAqXRkgYbAW64zteWoDGPKNOFccru4yB
         YOMmgKVVfqE90SPFoUyNmRe2r0AScG8+ZicsnQB1GEtzaVIqMG31pNAuWg6YEU7ZJWLl
         4nnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749490749; x=1750095549;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKm6RQm0xvheY9Wq7P4wJobbzcwsRd8lkGrR/lI30Dg=;
        b=OhjZwJZNujexQN6pGZAH6vcVzp8+dYOWdG7JkZk1JKbY3mZYPsbo5H6Q2RfEHw35He
         5EcI8P9Vvdfl9kkoGoRATyoKzQDXSO3ZnmpI9KwG356VnGtYdOmL3uYsTSAjtUe5UKrC
         JY9vA/U1MkcMfDNSc5dQbQsZI71guLDZIds2LdESwTG7Qyh4sGv5tqgv78uGHr3FWDbW
         JiZYX5Rmy3YoEzaqo/dxkyP0ctK/CoMdxwf/YFBDIt2IDVNL1nLOUClOkYIr54s/PV5E
         HMuX9ipHa35Q4TfEvsKBeJ16mzvIaeTySUHMWOl954+w21oe0WqjAUAue029rCDkIXjR
         zJNA==
X-Gm-Message-State: AOJu0YwB9Cg0fE9WMN8z00NdspGB1AnOzfBL4c46ra2JvWhL6D95rucu
	9kWVefrElMrmPTdOyx6lpjKNHU2abmiMaGhMif83sgdPBYfR0fBVTt/k4FQYJB4kQlzcHayY+VG
	7m0nt
X-Gm-Gg: ASbGnctqSkhZN8Dyv4KLz39ayZoMHp6BLgB+XaaioPB2prQnHFpKkx2dUW2/+mlNI10
	sW2g4zssb3QcNck7SbOh3fmTBXasEK+ST2lvFH5CYJZgH96eEkVC27Lggd4B0076/oTJ3ClKYpL
	I8Kkkoi1dcM7Rj0pV5X5Rcy425yjXkrAc3YJylUQICFOpbGQoSnnftMVOARXukkdq9FRljyPbeS
	X62HlHWKDVmnnfyv5fHEXAkwlJXbEfeZddZcOtmQGqA3i8XXLqeoEg7S+tbY+YwfkTUXe6UJaUd
	GI0BLNxAu4fM/hu5pY8tyxrrTuRJ1SVZUlFSMlmUuKwuzzd9R3mP4RGQ4JlO1FDV1cQ=
X-Google-Smtp-Source: AGHT+IE742tJ1le4C8ChyR3+nMblszsKR8oZ0Ft3zstCLCpfrwupiqjkYG+3BocpoaVNADlCYmPwfw==
X-Received: by 2002:a05:6602:728b:b0:85a:eecd:37b with SMTP id ca18e2360f4ac-873366e0b75mr1467290339f.11.1749490749282;
        Mon, 09 Jun 2025 10:39:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-87338a1eb84sm166607639f.44.2025.06.09.10.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jun 2025 10:39:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: add IO_URING_F_INLINE issue flag
Date: Mon,  9 Jun 2025 11:36:33 -0600
Message-ID: <20250609173904.62854-2-axboe@kernel.dk>
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

Set when the execution of the request is done inline from the system
call itself. Any deferred issue will never have this flag set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 12 +++++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 2922635986f5..054c43c02c96 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -26,6 +26,8 @@ enum io_uring_cmd_flags {
 	IO_URING_F_MULTISHOT		= 4,
 	/* executed by io-wq */
 	IO_URING_F_IOWQ			= 8,
+	/* executed inline from syscall */
+	IO_URING_F_INLINE		= 16,
 	/* int's last bit, sign checks are usually faster than a bit test */
 	IO_URING_F_NONBLOCK		= INT_MIN,
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf759c172083..0f9f6a173e66 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -147,7 +147,7 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool cancel_all,
 					 bool is_sqpoll_thread);
 
-static void io_queue_sqe(struct io_kiocb *req);
+static void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags);
 static void __io_req_caches_free(struct io_ring_ctx *ctx);
 
 static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
@@ -1377,7 +1377,7 @@ void io_req_task_submit(struct io_kiocb *req, io_tw_token_t tw)
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req);
 	else
-		io_queue_sqe(req);
+		io_queue_sqe(req, 0);
 }
 
 void io_req_task_queue_fail(struct io_kiocb *req, int ret)
@@ -1957,12 +1957,14 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 	}
 }
 
-static inline void io_queue_sqe(struct io_kiocb *req)
+static inline void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags)
 	__must_hold(&req->ctx->uring_lock)
 {
+	unsigned int issue_flags = IO_URING_F_NONBLOCK |
+				   IO_URING_F_COMPLETE_DEFER | extra_flags;
 	int ret;
 
-	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
+	ret = io_issue_sqe(req, issue_flags);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
@@ -2218,7 +2220,7 @@ static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return 0;
 	}
 
-	io_queue_sqe(req);
+	io_queue_sqe(req, IO_URING_F_INLINE);
 	return 0;
 }
 
-- 
2.49.0


