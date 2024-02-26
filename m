Return-Path: <io-uring+bounces-762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 130B6868106
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:30:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 998EDB2B6BF
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C096F12F5A4;
	Mon, 26 Feb 2024 19:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zAN/KWRW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3346712FF7F
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975519; cv=none; b=en+rmlgsVzeoYUn2fNSRQMTcMBztec76Wz6LZETsP7XJwLNJls7Nnmq0P04g4JzTBZIvW7LNbXSPzTBRAJFdi0j201SpleWBFySYV7YvtwRrMD9pbBqh5d9QBTtnYpy2DmPTidAawPVmejFWeP7GjqgSmmnaUSAtL54lP8qy0Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975519; c=relaxed/simple;
	bh=skXCAd8lJL3x9PKrWYWyooanNaZVeAY76tfivaB8mfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RybfkTgSvDFEOeetX1R1ib96k/qePv4zh1KrgOZ9dwsAcbU/6uQn9OZc12HilXtcq7FiNgxruGe1D4I3TOBOemoYQ6kuL4jPStOH+BwkYuBBRnZSYJHvzKGjyGL8wIM+GzWU/lcDH4TyOdSQk8ADFn7wcQX1kUJaBKIPS0T0nDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zAN/KWRW; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7c495be1924so52267839f.1
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:25:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708975517; x=1709580317; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HX0uTWcUaFWCJT9AIroI5EDz4rYPvNDwzbOev/pFU/I=;
        b=zAN/KWRWWnSJcO7QNjIyGkKieKiJNZvkPFZeUskOAFXIeY5eBXMekHjpNzz97UioIq
         Cj1pSrwqpgWKhUXlOzPd2g1bP4dcd0VtyRl+b281CHDPLshwG8Bdyh3T16gf+RQIw+/N
         wYbSgMA6FUvL2qNtj5NA3fmUFH41+IkcNTcdP1Do7sFPZYewl9qkjTQYQAuPbIPxIKeU
         PIZcNgV2oth5oy/TDpcpIF9Auh+x9e+85UysRFpsEjXgU7uSDZPBCMBMHRFF1AjJkEGW
         sfk/cQ6YahMYtTqWWeLrs9Li3+J0oVLvZ78kWD1rgMhd3LJOsOTgd355Rap3cl59PGlX
         nLzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975517; x=1709580317;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HX0uTWcUaFWCJT9AIroI5EDz4rYPvNDwzbOev/pFU/I=;
        b=WEQzPw0UUGgpUd50Tt4m0+JJar/9bVk4w+orTx7IxZhuYrpAjmvv2G4OEXHktfFJHQ
         5v2hHFqmitFZZJNpgbMFfeRFR4xWUbFalJuZedTHx+GF7olGq67Wah9pSraNq+LtFHA/
         EiwiWjq1boe0tI9ioNb4VncboI7iziZYXd77NyKcA86IlQ59LexZebAbJLzsUU6BWlnw
         IQHOSWD+ZwWJHlf2DKBXua1c+DFXPqRxiOXqZ+P9dM+xwQ9KE5IG0NiyNW2kUeA3nhMf
         yG2fEUW7I4njShSBufU8n3f1JzhkVliXZiUcvJiNwfZpgWyNtzOkx5Qm+2PAaD1QO+oc
         bMQg==
X-Gm-Message-State: AOJu0Yz2dGm7T+CcvD+5tZHcDsWCCh7ig/WasYOpyPu3bGw4qQO5ejXu
	4PTeEMtb+kmq34lDhJU29TU3Y7jWZJg0IKG98bA20cQTBaTGlG8rFnBZip1cBDPEIWnrZv6lAAB
	f
X-Google-Smtp-Source: AGHT+IETePzwVxcvpQCi4d4uM5Dd7N2z3raKofeec8FHrChu/Qy6VWPPdjtpaDyVP9GI3NJ4MYodcg==
X-Received: by 2002:a6b:6d08:0:b0:7c7:ba40:4ba8 with SMTP id a8-20020a6b6d08000000b007c7ba404ba8mr4323569iod.1.1708975517006;
        Mon, 26 Feb 2024 11:25:17 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm1370484jab.22.2024.02.26.11.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:25:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] io_uring/net: add generic multishot retry helper
Date: Mon, 26 Feb 2024 12:21:19 -0700
Message-ID: <20240226192458.396832-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240226192458.396832-1-axboe@kernel.dk>
References: <20240226192458.396832-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is just moving io_recv_prep_retry() higher up so we can use it
for sends as well, and renaming it to be generically useful for both
sends and receives.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index c73e4cd246ab..9ef11883a34a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -204,6 +204,16 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	return -EAGAIN;
 }
 
+static inline void io_mshot_prep_retry(struct io_kiocb *req)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+
+	req->flags &= ~REQ_F_BL_EMPTY;
+	sr->done_io = 0;
+	sr->len = 0; /* get from the provided buffer */
+	req->buf_index = sr->buf_group;
+}
+
 static bool io_recvmsg_multishot_overflow(struct io_async_msghdr *iomsg)
 {
 	int hdr;
@@ -654,15 +664,6 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static inline void io_recv_prep_retry(struct io_kiocb *req)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-
-	sr->done_io = 0;
-	sr->len = 0; /* get from the provided buffer */
-	req->buf_index = sr->buf_group;
-}
-
 /*
  * Finishes io_recv and io_recvmsg.
  *
@@ -697,7 +698,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 		int mshot_retry_ret = IOU_ISSUE_SKIP_COMPLETE;
 
-		io_recv_prep_retry(req);
+		io_mshot_prep_retry(req);
 
 		/* buffer list now empty, no point trying again */
 		if (req->flags & REQ_F_BL_EMPTY)
-- 
2.43.0


