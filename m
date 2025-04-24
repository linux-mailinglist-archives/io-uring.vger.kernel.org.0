Return-Path: <io-uring+bounces-7702-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 51C18A9ABCF
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 13:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C4C934A5086
	for <lists+io-uring@lfdr.de>; Thu, 24 Apr 2025 11:30:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B1BD1EB182;
	Thu, 24 Apr 2025 11:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BPS/SKT9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2023221FCC
	for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 11:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745494216; cv=none; b=hoWPL7p23pxNMMcy/6eRkVIebxcTkTURYm9g6DE22OdpHPd0JZJTpR1UtZkmMAo2bEMZW4azvU/saasKDBMZO4nNtkgrSlmTzd1PVMqv2LXM690X9hbPMtNWEdFepm18ZDLCu0PqbtJI8UmjSDBCK+WhZ7Xnj7qwxVd83lGoKOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745494216; c=relaxed/simple;
	bh=uhQVfn/8lrMwdAFD1RRgN0GHJjwuFVzSrtGYKDkdu64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oi6WCB+RxVj4p+9ZVfJN90o/zqtU4AFReU+AEcXAUkGpsbf5oWLUAokm4CBIDhzBEFm7sfquowXW0bjrIfK72dkPSyZHZp3HI8DcqivFBLdyAQngG18U+mPSM6hiWPT2lT45u0I/r+Rp3XIhBmqMLtwRMcwwgE8MtOGN14MgPd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BPS/SKT9; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-acb39c45b4eso141534966b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Apr 2025 04:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745494212; x=1746099012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=33nLsn5mIo0rXYG/uVjE7zNRmUpohL5demuyRpwHx18=;
        b=BPS/SKT9Mo7m1JS0vAeXncuaAUAIWm0PhUefQ9Fr/+AcoD2Pf+cUw3gcj1W5gu5NFF
         L/CRhpE/OUrWUV7hkjoAgqnanex/lRaVsRF+uAYeKJ6Ibo+tASOZfGY22xifPme1T1IH
         rsYoW5IJfDhXXdmP4+fBMi9Gw/DkBeuiyw5CIqAnW/LXACNVD4tIxB9s/tfxgvIDZHxq
         Q4v2jBXuI5vZc/m5qrYRdsx5oMsm8c3BYG4VMPcaOSHlDQ88Qb4YiJhLVmyRwKAIhL+L
         fqAnOCqz94jDA4kqD2Ltwpi+WgSnPJ27ydLjZ1VtIjTRMDTOxSJmCSdRGvZg1qviyO7t
         Km0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745494212; x=1746099012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=33nLsn5mIo0rXYG/uVjE7zNRmUpohL5demuyRpwHx18=;
        b=lgCXP0g7ici1Lmo7UokOROseuKCSm6SvqqZ8nrlMVeXcOIftxVf4M6tYU93lt96LTg
         hylt9CHDVtXcxaozhzUl/+LN5U1pRuCodXLvjRZn57cFleUWevYGMbvvOwPGarffGR6C
         EuWa5QIOInh3d0dyI9Yrz4uhojJph632FjKfMRQ8BkdabkP0CLYX0n80AA1JIcAZBMHJ
         n8NNJgrexfrWjbjsxzp0c6tuwUGcyZqS4QpvuDLfAsOPhOZkaOBePYI656w1V/7bHY6v
         RBlEGuOmBknwRIQ7fUCXHBWGzv9oJOhdQTrFZxBs31xcY34LR6aqye1UpCFgZTmy2Oes
         C+6A==
X-Gm-Message-State: AOJu0YzMb5TOrv0skqlu4ZOJmhsJT0XqI1m+TGHh60/VsJ0rBXNLfLPA
	vM2/ONPanKiAfqjReLH1x1KAsWzRcl2blh9dlqXGIYrnDGUy9VmoZ2s0Tg==
X-Gm-Gg: ASbGncuW/4yEgE0qmQxcQD8mZgnKecOHD7YprvLvkwNhBhDEpiv23HNlwxbwKHNg0ho
	S2jv9ThhPTsUhv36u+6AyreY1E9zJZ5hPpQcelyOi8dOAT8CINhFXuiJQ6FwEk3fbdotmlAHeMo
	wWfqRir4qA5nowwJLvymkvr99NzdzHa5ZwPC/PCbbIqFOj6dSAIpYOSPtKA3f6FvQGqITPUaP7g
	hR8oHLhkNe7cGrHsj936fznaUIbq7TJ0NA726u9/MXggNoMMebInSHvu5HWV9xbEw04GFKluNsf
	rP5nB9yHSTGKPoIPbE89cSTA
X-Google-Smtp-Source: AGHT+IGc2x4yUaDx3XlUBbrD7itFOnFkRmP/0VKC8D8WAxD+YvjKBGViODpqKQ+DFPgMNCjhz5TKRA==
X-Received: by 2002:a17:906:794b:b0:ac1:f002:d85d with SMTP id a640c23a62f3a-ace570e301emr218769266b.6.1745494212302;
        Thu, 24 Apr 2025 04:30:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c716])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace59c26316sm93675266b.151.2025.04.24.04.30.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 04:30:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/3] io_uring/eventfd: open code io_eventfd_grab()
Date: Thu, 24 Apr 2025 12:31:18 +0100
Message-ID: <5cb53ce3876c2819db9e8055cf41dca4398521db.1745493845.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745493845.git.asml.silence@gmail.com>
References: <cover.1745493845.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_eventfd_grab() doesn't help wit understanding the path, it'll be
simpler to keep the helper open coded.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/eventfd.c | 40 ++++++++++------------------------------
 1 file changed, 10 insertions(+), 30 deletions(-)

diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 8c2835ac17a0..78f8ab7db104 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -65,38 +65,11 @@ static bool __io_eventfd_signal(struct io_ev_fd *ev_fd)
 
 /*
  * Trigger if eventfd_async isn't set, or if it's set and the caller is
- * an async worker. If ev_fd isn't valid, obviously return false.
+ * an async worker.
  */
 static bool io_eventfd_trigger(struct io_ev_fd *ev_fd)
 {
-	if (ev_fd)
-		return !ev_fd->eventfd_async || io_wq_current_is_worker();
-	return false;
-}
-
-/*
- * On success, returns with an ev_fd reference grabbed and the RCU read
- * lock held.
- */
-static struct io_ev_fd *io_eventfd_grab(struct io_ring_ctx *ctx)
-{
-	struct io_ev_fd *ev_fd;
-
-	/*
-	 * rcu_dereference ctx->io_ev_fd once and use it for both for checking
-	 * and eventfd_signal
-	 */
-	ev_fd = rcu_dereference(ctx->io_ev_fd);
-
-	/*
-	 * Check again if ev_fd exists in case an io_eventfd_unregister call
-	 * completed between the NULL check of ctx->io_ev_fd at the start of
-	 * the function and rcu_read_lock.
-	 */
-	if (io_eventfd_trigger(ev_fd) && refcount_inc_not_zero(&ev_fd->refs))
-		return ev_fd;
-
-	return NULL;
+	return !ev_fd->eventfd_async || io_wq_current_is_worker();
 }
 
 void io_eventfd_signal(struct io_ring_ctx *ctx, bool cqe_event)
@@ -108,9 +81,16 @@ void io_eventfd_signal(struct io_ring_ctx *ctx, bool cqe_event)
 		return;
 
 	guard(rcu)();
-	ev_fd = io_eventfd_grab(ctx);
+	ev_fd = rcu_dereference(ctx->io_ev_fd);
+	/*
+	 * Check again if ev_fd exists in case an io_eventfd_unregister call
+	 * completed between the NULL check of ctx->io_ev_fd at the start of
+	 * the function and rcu_read_lock.
+	 */
 	if (!ev_fd)
 		return;
+	if (!io_eventfd_trigger(ev_fd) || !refcount_inc_not_zero(&ev_fd->refs))
+		return;
 
 	if (cqe_event) {
 		/*
-- 
2.48.1


