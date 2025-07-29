Return-Path: <io-uring+bounces-8857-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 48F2FB148DF
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 09:01:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 58DA018870DD
	for <lists+io-uring@lfdr.de>; Tue, 29 Jul 2025 07:01:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7260229B15;
	Tue, 29 Jul 2025 07:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TI4nHTFN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AD22472AE
	for <io-uring@vger.kernel.org>; Tue, 29 Jul 2025 07:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753772494; cv=none; b=UheVM2e3M5jmTadl8HicMgNvwcMJB4TvdvxAHUF2bNHW5W5DFaytiox8cfhrUgh41Ch6yGUW7qWcK2vz6TDgSDMPfutm4O4viRcZD4yCRJsrD1ORynxj9a56Ot92e1kINHWNoXaLJ95exl0T3S521a5mwX4uYugsYQ5Sk0h7R68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753772494; c=relaxed/simple;
	bh=7w0JM8YdDohEz3UFVl0i7fDeflk7eJj2M3P5XFtcVxo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=lIoeXq+Oc8kLUIW6kMaLGUhL/LSg6L912fiQ5nvVGaJjZU0kUeqlE9XjHB7PoLTS9tI6aescI4W0VYCtm3AlS7ocnDsQpVzcrv6qV4ZBF3nTLNi0t55TLXEny45FjjssT9xNqqXTwyttMoEWzt9J3rjHN4mDIFw0kcvuyzCPdqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TI4nHTFN; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-748f5a4a423so3597164b3a.1
        for <io-uring@vger.kernel.org>; Tue, 29 Jul 2025 00:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753772492; x=1754377292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hci2iY4+55q8LpoQddoBoltpGuIUKQGF+ptgR76rhs0=;
        b=TI4nHTFNlhhUxfTO2NvifKU7fFLt8uFjYLHj9GYxdNA6FMblpdXLYgHmAXHkdjIXwH
         uJSRMeN8LvftPnjXHojRb5U1Qy0ndpeNJuq5S+L/sg2qex1OXiRnv3FjMKeAHn2l+Rqf
         aje2fUUxtEjVMmr1d/HSbLt0g3OKb/OQ+cbIlzKRjnEhtGCeJrbVkGqkETj0gynMw892
         wTL0z5eLoj2Z6BOx7/t4afKE8UkIKeS0iPiMM1YV95Nrpim6RJ8OcFFvjCYDI216ZyDB
         xqLviDt9UToc9u5+Mo6dJ+DUWw5ZZNnRnpP/AgSyHk9nQCE7GbfkAUj8thFXtn6rIxQk
         Sknw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753772492; x=1754377292;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hci2iY4+55q8LpoQddoBoltpGuIUKQGF+ptgR76rhs0=;
        b=bJcBJW/B47J82VLlYVM4gey4SWNcoo7BJ2vIH0EkCVXXgNFrkZs/jK8NcK//D7oHmQ
         +riBmh2jazCN3yxQQW5Wn0dfFASHrOlDJdr47y182Nu6mtV5x/4acywCl4Hs8nPIryXW
         SYK2QI/x1HoGctFIgold0cPmevT7e4XW6hy56bg81Mo2Knb6tCvmiVQbuOrD6XJupQBU
         Ar4CPFssazQMB/l+7jonu6kP4/imcinTPnXUPIAfyyk126y4vBTpuEvFnXpyYjY78wUk
         kudqHrRSG8lLYkbS2BNbOg37s2zaahD2zWZ+tn1QF4oep28P9R+35xuz2ViiBgBQ/xEo
         8tPw==
X-Gm-Message-State: AOJu0Yx7+vTvjKJz1+SH+5I6hNX6PU2qyr+1jnkLaeeW8HkfBnB4QOGd
	vKYQgHFICdl0u7RZEUJlCmj1b8Zunw672XN7NlXDMfvqrja/2KO61h8hL8IzXf8b
X-Gm-Gg: ASbGncvWoyycbDnZJj6KSSuotn8aQrakf2txZYL6Lz95SduK7VDjYsNTAqt/7t3xtIy
	BZSqVcD1AzzhJsoNHPRUAmhWfyYWvbzmzaVyY2x+KmBUqGQO9o9k/8TZkD1FjJ3dAmsI4JxxLxd
	R61c+xDyTmJWkinjGZ9QFwjQniajVrpvk/aIXjjAYYBX2LpvgXlUNOYocAV0LuTSw2ZUKiu2Jw0
	0Zi8H7h7cTIDmc7fv8XVKc0MPsNNKk+vFozmw3FgKh9uDlOoNNj8U9oYoR7edzKCqkFPC/WX4do
	uBebGjVGJLehNXCOttjYaV+fDKhZ0BaBzEoyTzUhFKmG7diunhvoemzZlVZ5PAbo4GwXeX7xcYI
	IKLKAsvIYfwBKMJtGWMXzONL5xYpqJtX/7olhECO7YedmFcSPiMmKaExUBTZTh3CyVMOx6hertG
	daCTUI4pdoe6qFTDw=
X-Google-Smtp-Source: AGHT+IEIQnOCGVQXdObamoH4w95QsnoLtgUno+Ffdis1WHbOK2MJDT7zLTaDFJEQ+Q+nacjsL9FwDQ==
X-Received: by 2002:a05:6a20:5491:b0:235:e7b6:6a04 with SMTP id adf61e73a8af0-23d70172a05mr24722484637.24.1753772492216;
        Tue, 29 Jul 2025 00:01:32 -0700 (PDT)
Received: from localhost.localdomain (syn-072-130-199-032.res.spectrum.com. [72.130.199.32])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b3f7f569d24sm6350664a12.1.2025.07.29.00.01.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 29 Jul 2025 00:01:31 -0700 (PDT)
From: norman.maurer@googlemail.com
X-Google-Original-From: norman_maurer@apple.com
To: io-uring@vger.kernel.org
Cc: axboe@kernel.dk,
	Norman Maurer <norman_maurer@apple.com>
Subject: [PATCH v3] io_uring/net: Allow to do vectorized send
Date: Mon, 28 Jul 2025 20:59:53 -1000
Message-Id: <20250729065952.26646-1-norman_maurer@apple.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Norman Maurer <norman_maurer@apple.com>

At the moment you have to use sendmsg for vectorized send.
While this works it's suboptimal as it also means you need to
allocate a struct msghdr that needs to be kept alive until a
submission happens. We can remove this limitation by just
allowing to use send directly.

Signed-off-by: Norman Maurer <norman_maurer@apple.com>
---
Changes since v1: Simplify flag check and fix line length of commit message
Changes since v2: Adjust SENDMSG_FLAGS  

---
 include/uapi/linux/io_uring.h | 4 ++++
 io_uring/net.c                | 9 ++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b8a0e70ee2fd..6957dc539d83 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -392,12 +392,16 @@ enum io_uring_op {
  *				the starting buffer ID in cqe->flags as per
  *				usual for provided buffer usage. The buffers
  *				will be	contiguous from the starting buffer ID.
+ *
+ * IORING_SEND_VECTORIZED	If set, SEND[_ZC] will take a pointer to a io_vec
+ * 				to allow vectorized send operations.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
 #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
 #define IORING_RECVSEND_BUNDLE		(1U << 4)
+#define IORING_SEND_VECTORIZED		(1U << 5)
 
 /*
  * cqe.res for IORING_CQE_F_NOTIF if
diff --git a/io_uring/net.c b/io_uring/net.c
index ba2d0abea349..3ce5478438f0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -382,6 +382,10 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 	if (req->flags & REQ_F_BUFFER_SELECT)
 		return 0;
+
+	if (sr->flags & IORING_SEND_VECTORIZED)
+               return io_net_import_vec(req, kmsg, sr->buf, sr->len, ITER_SOURCE);
+
 	return import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
 }
 
@@ -409,7 +413,7 @@ static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	return io_net_import_vec(req, kmsg, msg.msg_iov, msg.msg_iovlen, ITER_SOURCE);
 }
 
-#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE)
+#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_RECVSEND_BUNDLE | IORING_SEND_VECTORIZED)
 
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
@@ -420,6 +424,9 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
 		return -EINVAL;
+	if (req->opcode == IORING_OP_SENDMSG && sr->flags & IORING_SEND_VECTORIZED)
+		return -EINVAL;
+
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
-- 
2.39.5 (Apple Git-154)


