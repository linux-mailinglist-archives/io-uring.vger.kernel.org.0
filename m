Return-Path: <io-uring+bounces-6355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E369A3272D
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 14:32:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 215997A1AC5
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 13:31:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65EC20A5C4;
	Wed, 12 Feb 2025 13:32:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RBSOo2QF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117EE134A8
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 13:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739367150; cv=none; b=NjxWZIhd76pe8P1OxJY6tWE/IT0MSskUnX+xgc+lw1OUNa+RgHWrpCzmTlZFHAlJ/H2LhDJWsBDqKpDIaP2glmA7uVAnhkJGdUwd4YZRlQ9fNjmI7hKBNIkeJ/74cxSt7JP+adieCrhc9mY0Y8gWZp/UElNAw/Kgx3iB41U1a4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739367150; c=relaxed/simple;
	bh=GGFFBQ9ADBEAWUtB00GjJkk4v7J1QAXqszGBkfT0L08=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XI2XfI2zf5FubyMC87AdOsYyAhxKtqxy7YhHzB8dYggEBydGpEqyXUyox7E/ngCFi/dk/+3eA/lArhHWEXgaAqJNa+BhHGfpXSdXO9EBgur4/rECZRj1KjyzEXvukg092YDmNsz+F+nb1b0bBzj6r7fhnAVS4ogKgzshr329Mdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RBSOo2QF; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-439585a067eso8665905e9.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 05:32:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739367147; x=1739971947; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4uIKG9i3Ax22BqLm22GQKN6E5pqttC9LasLuJ7Ag4AQ=;
        b=RBSOo2QFxrOsyrVHP5m2iapCLyEudQcaV6UVXUJaiesoeEmZ4vOoSaeMNlHeLP/Cxz
         qYEmiesOfRr9jWWQ2Cl1YkpLMudiSCtg8jpGyRMS8Y1LVac/Ixpq6OH4ay0EUWmbj+GE
         fma/yE7Lck6SW3stWNT/Il3TADqo23/2Ebz8miUabulsYGD3b3k26KxrFrGvBg4Ls8nU
         sJkx3Hpn95pEavY7bbrc+tS3vZ+SDg2aVNL3bI/tQk2RkMEPyb3HNvJlyOLpAtSDgJCU
         5gdSQREx1L+2DjB4bogx0z3xJpZAwY2qb8lSoOGVW7rTq2Yq/Egk2aVrvxmCCY1Jjddg
         Bd+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739367147; x=1739971947;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4uIKG9i3Ax22BqLm22GQKN6E5pqttC9LasLuJ7Ag4AQ=;
        b=R1dCdByTkxU2jKbWc5PgNs2gVhTf8ZAhCY38NFk3zVJAPN6z3hxa73NfZTvXSlLUyu
         VkQDq2fGraOgZlENzrnr3BGiF5xo0aTe7wdOe2WF1QygLROBDbkYspBQaXNe1NbHAP04
         5ttSQbyVQ/XzdpLMiLASx0e4tcVGeGqWiF/G87d2aHMFfCqesKJk34bHfVF61J71YvoE
         pHozTm3dtjzSEVZlfoaJ61n9BgG4UYa3zASzo/RMScQHQVfEdb6o15OjS57K+qS3b9Qu
         ryaYcoIhcTLp655UV/mGLhGfN/IjYYCawBoQNoEB5gOSIEkpu+pE4RqXLVjN5AOi4Jbq
         hhPg==
X-Gm-Message-State: AOJu0Yyw0rTjiJmqhhncwcFLa7qBb5okIESAiaoiuUibkHc/DX2Fv+9C
	4gcI6mFNZVbYLwM08sIdMEwxqewDgJKO6AFUXaeZ5dhenHKdrVSmkWFgHQ==
X-Gm-Gg: ASbGncs+xxo4bfEMR13goHJw+W5nKHwQmwA/spw6iI7AklequE6E5g/WfjEG1Tu+jdb
	jFfmR3VF0RzIAbHZDT5/YvpGXB3a2rxGZenJiwdtZ+WQrBOEDZwzUWHguCTyXVh4bzpkjg7VL1H
	IIaStqgaSUNt7EpPLt+2Sn6LZTUD8+I2DeMyfu/DhgoU9ttuhwbpmZ5kycVuci735basBY2Daw8
	t1+Z33cxmIXbyrAg3uVxGTiGrsKzrnbFxT1SdgyL8sHosC3XZnMephfAjxPB0T0pwkpLkc5wpzG
	ajC1SNROAI8xMOUJiLWvZP3w5e8W
X-Google-Smtp-Source: AGHT+IGbAepkiL77F/VpI2zZcrlhVpVcBtCFuhgNwwRJT/nGzJHTPSOMUyz3M8UiuiLCX2BdkOjyJA==
X-Received: by 2002:a05:600c:1ca9:b0:439:5541:53cc with SMTP id 5b1f17b1804b1-439581be340mr32392495e9.29.1739367146149;
        Wed, 12 Feb 2025 05:32:26 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.128.10])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a04f217sm19916515e9.1.2025.02.12.05.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 05:32:25 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/1] io_uring/waitid: don't abuse io_tw_state
Date: Wed, 12 Feb 2025 13:33:24 +0000
Message-ID: <9857d8768ee689f515c6f12b3ec5842c545c8959.1739367134.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct io_tw_state is managed by core io_uring, and opcode handling code
must never try to cheat and create their own instances, it's plain
incorrect.

io_waitid_complete() attempts exactly that outside of the task work
context, and even though the ring is locked, there would be no one to
reap the requests from the defer completion list. It only works now
because luckily it's called before io_uring_try_cancel_uring_cmd(),
which flushes completions.

Fixes: f31ecf671ddc4 ("io_uring: add IORING_OP_WAITID support")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/waitid.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 853e97a7b0ec..c4096d93a287 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -118,7 +118,6 @@ static int io_waitid_finish(struct io_kiocb *req, int ret)
 static void io_waitid_complete(struct io_kiocb *req, int ret)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
-	struct io_tw_state ts = {};
 
 	/* anyone completing better be holding a reference */
 	WARN_ON_ONCE(!(atomic_read(&iw->refs) & IO_WAITID_REF_MASK));
@@ -131,7 +130,6 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
-	io_req_task_complete(req, &ts);
 }
 
 static bool __io_waitid_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
@@ -153,6 +151,7 @@ static bool __io_waitid_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
 	list_del_init(&iwa->wo.child_wait.entry);
 	spin_unlock_irq(&iw->head->lock);
 	io_waitid_complete(req, -ECANCELED);
+	io_req_queue_tw_complete(req, -ECANCELED);
 	return true;
 }
 
@@ -258,6 +257,7 @@ static void io_waitid_cb(struct io_kiocb *req, struct io_tw_state *ts)
 	}
 
 	io_waitid_complete(req, ret);
+	io_req_task_complete(req, ts);
 }
 
 static int io_waitid_wait(struct wait_queue_entry *wait, unsigned mode,
-- 
2.48.1


