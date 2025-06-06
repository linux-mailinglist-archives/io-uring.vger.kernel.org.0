Return-Path: <io-uring+bounces-8270-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DA57AD09C9
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 23:56:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E71EF7A2187
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 21:55:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EC7E1F8747;
	Fri,  6 Jun 2025 21:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="pn+QYo70"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF7532367BA
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 21:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749247001; cv=none; b=J8tLlt1SCHZfziGbcAneOkwexdO+pyhkw5FGQEgm2m8vOAG3DYVq+7rWY06wWFDw6J+PXbS3bQswUH1JeRgn4o8kxo5AvIEMOoYYabA2XW4oh92DbZ1mcKgb3oesppXtcZb9t8Dymv8RL2hKDnxQU+Ut2SdkSjuhiZ8xiLOGJNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749247001; c=relaxed/simple;
	bh=xe4TdDifyTiAtD8ujjZyQOcard8pvJYIMvKtTxG0oWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XwZ/vtGtRGE6XrRKCemdPMVuxE6pXaUDILmE3NwgM4A2DZ5rLLo0KqkFpYyUUKGtQ3RsH/iboSxnFFrxzocJguEEE587wY+gHjqmucfjV2mGzcZck9sj3jg10U8Ea95ntYLp3zU7edMjj1qXpTzkH2yuCP/tyF2q03yMYXkf9sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=pn+QYo70; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8723a232750so212446739f.1
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 14:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749246998; x=1749851798; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKm6RQm0xvheY9Wq7P4wJobbzcwsRd8lkGrR/lI30Dg=;
        b=pn+QYo70pXkp8oaPA3hrxGlfFLnsusM91Mkh7dhjCjKlXUi6SUr0SUXbz+t3uv3jdG
         mjwqwtf7n48lOOcWfQdIFrQdQ/gXxWn2Smtwc9zlH4RuoRWiyj41LgW01+PCvAPxANRh
         xWhEBYXph/ox/S/qluHsqIkKyBJUsLdcRztwBgoWepDotw7pG228kowf4pP89Q3xitni
         15iW0NjDLTJonHtoRMp+zOznYV4jD3hVpjgOkVa1L7fV/7EhD6VJa9/S/nrvYKX87onD
         liRl/w3WFbL0HXHEHw1oBEqiuELtdLKGTmf2G2BAopJ3sK4sA2MuTMtW62t79cfUTCh1
         6rLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749246998; x=1749851798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKm6RQm0xvheY9Wq7P4wJobbzcwsRd8lkGrR/lI30Dg=;
        b=N90r+o6fVKzDSswNS0HyyUgBXOe6B0KlFz04n6OAHWojf0wwHrS7cIutH+erh64j80
         6mBaCsVG23oUYysI0XyM9EraP6HPdGA2ee6i6XccvyWhqnpdQIKHZgsKmjtYWlY0QvZp
         JEK0+4/M84YL7nhbEqSaxq3hLCT2MzQD69C1V/UcG7sdWYwaIT0rH+opAlTH/lTQAFHi
         T3NgCaTIQ8imjpmVIYlA4fbA/kRcGkVegdfhBqy/8yg4ql/uzlvuxV2W/DwwjL2VXXzY
         6V7oaDXukQ7JbdOFv5ivwj6OudkrCtOUi0ATiSz8JlmHbIlvDwkLFdZsU4lsRodu6clE
         9fgQ==
X-Gm-Message-State: AOJu0YwlxthCcdPxDrPVteIlWrpvipK2Y/laoPonjvDt6LGtNhqiZzhM
	rrl9OlFXDzxS8eaYZfoSNnFLH9EFOSVStqxU+Byv2gULjRX5Aigxj+QD9tFZKf4Fqh/TX2KsfY1
	CgzWH
X-Gm-Gg: ASbGncvLQrXUUifH4r6zPARSnr5onpi7PDKOPb5M32ayXBIBWVqXFHEl1uJ0XEykZGV
	y7qt+MTBB2AAVBS+XzHA7oc53NLl970M2jeSMs13BwQVkxKzJ2bEELSvz+SyopW/BrKDFdIjlv7
	mjZe/mF3JQ0G0iP1V7dUqaxTeiQTc5+IfishU4nrMsRLcYbEe4roswLZZz/cP2hOBEJZtXdI8Hd
	omHA8yOq88CvzrVOjZPq217igXOPBS9uFt8wX34FhFfb2Ey+9m8+YASOGvJacO9BldyTJmkeDNM
	lKDjQiLv9YSzdHL+spKOHnJXamSNqNiDDEgfGMUr7v2hCjZHvRuORPDF
X-Google-Smtp-Source: AGHT+IFXKBGrdpp+J+GTnViG9KCPBqAiwZx/cBgnQbUN5XdACvl+kA29bS4hIWHC01MG3DnKAmsk2Q==
X-Received: by 2002:a05:6e02:2701:b0:3d6:cbad:235c with SMTP id e9e14a558f8ab-3ddce421dcemr61147405ab.6.1749246997714;
        Fri, 06 Jun 2025 14:56:37 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf1585bfsm5735105ab.30.2025.06.06.14.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 14:56:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: add IO_URING_F_INLINE issue flag
Date: Fri,  6 Jun 2025 15:54:26 -0600
Message-ID: <20250606215633.322075-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250606215633.322075-1-axboe@kernel.dk>
References: <20250606215633.322075-1-axboe@kernel.dk>
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


