Return-Path: <io-uring+bounces-6260-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A49C2A27BE6
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 20:49:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E00D163E20
	for <lists+io-uring@lfdr.de>; Tue,  4 Feb 2025 19:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12FBC21A42D;
	Tue,  4 Feb 2025 19:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SsvWfTrP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7622185BC
	for <io-uring@vger.kernel.org>; Tue,  4 Feb 2025 19:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698509; cv=none; b=KUQUSe0qXpGbM9k2psTArigudFijI12QGEhnjRQzvMs3TMaVsZrK4Z/mIgzWLTw0xb2C71eqC7MQ8Izb1Gaa+Gy4Z4EXwJgxgYUOhnLML+VnT9n8V3DMRpTJtcoCsrcB28GUY75zFAbkAo9GY6wbRrUdCn6K2dLFXGYTaZi/aeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698509; c=relaxed/simple;
	bh=im1ntOsYLHYjJiEvx6njeC6vx3wirWuYtKuqP171Gs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THd63mRu+qbHWWbopjgwFISEgaOmGq+nzwwvZfGqVHavBC51lgbfAaFFGcd+8hEJqv5i7TB1t7gIzZ62IiKga0oI4S/QqYzD3CuHdWJguPWn9wLFWic/m7mIC0qrivF9cNDJWBQMb+0Gpa+pnfkt7BpFWFYUat7YaaYyne8Hwlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SsvWfTrP; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-844d7f81dd1so171907739f.2
        for <io-uring@vger.kernel.org>; Tue, 04 Feb 2025 11:48:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738698506; x=1739303306; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TQ8sKu9TA7JXcFTCTxuSEZOOG4qI+mYE1gZPeZ19VjI=;
        b=SsvWfTrPPFbY5eWm1kGdmTK4bIFiTSznfzgR9fXviYxF+7VaB4SmDSUx0rSPBeIMNn
         f13pUbio3mp2TBgMC8WZwbwK1zCyDob5A4EJTdHW9WqdeyiDvNAxao/ZQPZd3k1q2mLH
         gvErpQzOaNyQJVuLFAQjYgS9J9CoNJwlNmdglJwZua0gm1dyAsT13bn32QR9Q7MkC1J4
         4+itUYlkQkeILa4XSo8s0biwRTaykHDnYmcZurDxm471Zitk1kLsEH2ZzFOn+otjMiF4
         a8G16c5/f/cobgJNwUyXWca8THYyA1mre63/j31MnKXssrODU695XAhza5iMtRaGsb6S
         NF6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698506; x=1739303306;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TQ8sKu9TA7JXcFTCTxuSEZOOG4qI+mYE1gZPeZ19VjI=;
        b=EbhlXbb91dmkR7/xdFTyA62Io0KTcDnDt5aO/lXqcvn5jBWxLYHNeUXEm2IEKYwXJ3
         muuPM8BY2qSrNdfSJMonmMyxTnL1I3L5JcmraVbEtO/XbbnxYR0G0NHzZWQ1fsb9keTe
         849L9vjDis9hoQmlQ/txgP2pQ+f0rpCchJoZzz8As5lUODCK4SwhcS2bnWK4EryOSnlD
         7PXtX8+L+dneOJNmNLtiplS97x62basl2h/HvRI73iP8K7FV7b3kNpJwW8z04i+dBI02
         fsYIyUDBetvtWdYLMqUZ3RaAITZ5F0t3tuGoIqflzsdE+MxJAystq/eEeeHcAGpwqSKb
         wZCw==
X-Gm-Message-State: AOJu0Yy6AibvppJ8Gowi0XR4PKcA5dpeJnNserRfvZ+jwY7ksqDWXDOQ
	e4XexmjVYtxxJqao6gsjKxsTwEpLXzbPvzUj21Jk3IHlqAs4gV4XAzXQ6fkujq6XL+ZN4BMrpNy
	l
X-Gm-Gg: ASbGncvVnvKtcO3WcjmYIbskk3swTQj8Qsr0HsCuDSEJOxmo+RHXC5E3JzaUWt9W+XW
	dwkYh18KRXCFSsyFgz3qDuekvZtEJ/ZaqLH84k1e1chl31AXESlfWphAcfQYXjMo3TFkHudMkHN
	lh3r3Ag4QH3DOxjXcqZphNF1+3ETJDFoDM9Jn8wEzr1RdfRBx+AOXFx7Br51WsUY+jvazWPCk9Q
	WfYYH3DzgUpDlJaJldb4OnASfeblzatATuFStPp5vhBQ4G59SRmyCZLwlx/7mCC+OeTpy0C1gIc
	28y2+SFQ/DmU1Q5L27I=
X-Google-Smtp-Source: AGHT+IGgKsTAIuMWIIUyjhHQg9pg2TRiKqIeaaiPRkZN0hdZykJCKB/DPuXnqQ84gaSqM31W+Yz5gA==
X-Received: by 2002:a05:6602:4192:b0:844:cbd0:66ca with SMTP id ca18e2360f4ac-854ea411c82mr28620039f.1.1738698506071;
        Tue, 04 Feb 2025 11:48:26 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c95c4sm2841466173.127.2025.02.04.11.48.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:48:25 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	brauner@kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/11] io_uring/poll: pull ownership handling into poll.h
Date: Tue,  4 Feb 2025 12:46:41 -0700
Message-ID: <20250204194814.393112-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250204194814.393112-1-axboe@kernel.dk>
References: <20250204194814.393112-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for using it from somewhere else. Rather than try and
duplicate the functionality, just make it generically available to
io_uring opcodes.

Note: would have to be used carefully, cannot be used by opcodes that
can trigger poll logic.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/poll.c | 30 +-----------------------------
 io_uring/poll.h | 31 +++++++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index bb1c0cd4f809..5e44ac562491 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -41,16 +41,6 @@ struct io_poll_table {
 	__poll_t result_mask;
 };
 
-#define IO_POLL_CANCEL_FLAG	BIT(31)
-#define IO_POLL_RETRY_FLAG	BIT(30)
-#define IO_POLL_REF_MASK	GENMASK(29, 0)
-
-/*
- * We usually have 1-2 refs taken, 128 is more than enough and we want to
- * maximise the margin between this amount and the moment when it overflows.
- */
-#define IO_POLL_REF_BIAS	128
-
 #define IO_WQE_F_DOUBLE		1
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -70,7 +60,7 @@ static inline bool wqe_is_double(struct wait_queue_entry *wqe)
 	return priv & IO_WQE_F_DOUBLE;
 }
 
-static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
+bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
 {
 	int v;
 
@@ -85,24 +75,6 @@ static bool io_poll_get_ownership_slowpath(struct io_kiocb *req)
 	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
 }
 
-/*
- * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
- * bump it and acquire ownership. It's disallowed to modify requests while not
- * owning it, that prevents from races for enqueueing task_work's and b/w
- * arming poll and wakeups.
- */
-static inline bool io_poll_get_ownership(struct io_kiocb *req)
-{
-	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
-		return io_poll_get_ownership_slowpath(req);
-	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
-}
-
-static void io_poll_mark_cancelled(struct io_kiocb *req)
-{
-	atomic_or(IO_POLL_CANCEL_FLAG, &req->poll_refs);
-}
-
 static struct io_poll *io_poll_get_double(struct io_kiocb *req)
 {
 	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
diff --git a/io_uring/poll.h b/io_uring/poll.h
index 04ede93113dc..2f416cd3be13 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -21,6 +21,18 @@ struct async_poll {
 	struct io_poll		*double_poll;
 };
 
+#define IO_POLL_CANCEL_FLAG	BIT(31)
+#define IO_POLL_RETRY_FLAG	BIT(30)
+#define IO_POLL_REF_MASK	GENMASK(29, 0)
+
+bool io_poll_get_ownership_slowpath(struct io_kiocb *req);
+
+/*
+ * We usually have 1-2 refs taken, 128 is more than enough and we want to
+ * maximise the margin between this amount and the moment when it overflows.
+ */
+#define IO_POLL_REF_BIAS	128
+
 /*
  * Must only be called inside issue_flags & IO_URING_F_MULTISHOT, or
  * potentially other cases where we already "own" this poll request.
@@ -30,6 +42,25 @@ static inline void io_poll_multishot_retry(struct io_kiocb *req)
 	atomic_inc(&req->poll_refs);
 }
 
+/*
+ * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
+ * bump it and acquire ownership. It's disallowed to modify requests while not
+ * owning it, that prevents from races for enqueueing task_work's and b/w
+ * arming poll and wakeups.
+ */
+static inline bool io_poll_get_ownership(struct io_kiocb *req)
+{
+	if (unlikely(atomic_read(&req->poll_refs) >= IO_POLL_REF_BIAS))
+		return io_poll_get_ownership_slowpath(req);
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+}
+
+static inline void io_poll_mark_cancelled(struct io_kiocb *req)
+{
+	atomic_or(IO_POLL_CANCEL_FLAG, &req->poll_refs);
+}
+
+
 int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_poll_add(struct io_kiocb *req, unsigned int issue_flags);
 
-- 
2.47.2


