Return-Path: <io-uring+bounces-1481-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D489789E4BA
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 23:06:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8B47D1F23185
	for <lists+io-uring@lfdr.de>; Tue,  9 Apr 2024 21:06:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14951158863;
	Tue,  9 Apr 2024 21:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="2lpKR0DY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E828562A
	for <io-uring@vger.kernel.org>; Tue,  9 Apr 2024 21:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712696763; cv=none; b=hQthd9JIZYiZFFlJgxZJhz9a1hdnOYc6zGsRWzCAcVyxwQ3Mk+mvPcQf6ILNkfYUbpby1dbwcELNvAOPsvZ0oHNU2l8SqCEOK59qPaM/fM2hgdndCOPCRpPiYiou9iZJ9MaC223m+9h0yqEUPRY8OlwJppq0udu7VEyImePlyVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712696763; c=relaxed/simple;
	bh=VV1Al6eM4oDIJPOUUNqAKTRTVlZagWnWYWQYNzM5u/I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I2nLbTLnw1yzZl5R1jv0cyUUBQSLITZIT/fN+MRoqf/X1QKyOtH4oLzuhFwFMqjmhJeOfTUJXB0lBRXLXklAcbtFxS6RuYUrkHNL2pzafpoAl51hH/xcgHDstY3QE3siaZUrcxNgfM+Ec3cZ9/M8eD8o53C3ENex4nr7IrNtk6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=2lpKR0DY; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-6ecf8ebff50so3735215b3a.1
        for <io-uring@vger.kernel.org>; Tue, 09 Apr 2024 14:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1712696760; x=1713301560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDiNAbZ7JE0iELILHKGa3F434w2VxSXPGDynMxmjDuA=;
        b=2lpKR0DYrcPqTI50B353jSaryZuRi8uSDVBqnXcF9KnFYV0FLLqQJjCFA7Tmv3bu5o
         BpnQ7L4WOu5knW3V1j+RTohgcVjRzSKJRqmEBB6ENBzrjwLa5xuiz0fZksallhbDbttc
         EXqCMvUaY/+RBnzHRTRoiG5EBQo3Sz9XHF7mRQ9OzOfOcCa1Aer1xnI6uKWPVUIKw6Ei
         75kluNxHQAXpGs1KIKWPVRSolLLYK8Ro+BUwapXXOT9DjNDJgYKUq8f4FiQTk6E5Kue6
         JRgxkicB5+g/MP6eyoncFCNEm2ekz2g6ZEO6cx6P+oWEKomrjUZImAHR+wjQP+kOkh4l
         HTVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712696760; x=1713301560;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZDiNAbZ7JE0iELILHKGa3F434w2VxSXPGDynMxmjDuA=;
        b=LjRwlzb5YQmvpeS5Bf2nJV2vcKwE1GXWaGb/nOzBMN4l82045P13iEI+YsZ0P5S873
         RyuyQJ59gyl9NFHdi6kQ+1S3atrGeaCjOZhhp+i7g8amD6hbbvCyV+ry+QSWp60BsMq9
         G6y3grJRc4g/LR1U2qVtZcQOEK+aiETnY0Ndbf71o84eDTaCfPtn3gCoDwwBN4F1lr1Y
         np8f/dW2sBeLF5L7FXy5DS60zvMKx3Jgrlo56eMdnnpcsftkcm6naFun/8f3lYqslSyi
         EkziB0Ce36Jp6SHTM15O+ZfiM/bMrKnXWJkKS1vf4ocFVAa0ot5qXMCR6oNFGBMfS257
         KNtA==
X-Gm-Message-State: AOJu0YyGh9jpmxgevSag3gi3fCh3eoTDog0aQKJMs2R0bRuosZJ+svQB
	mir4a6qLgzeBvIrbNzqqiPzfzcjR5ILV0PRL+ap0dj2LpOSYL9TNxA4plAtqSqDFpuxsOh7qTMt
	Z
X-Google-Smtp-Source: AGHT+IHlp5osK/Ny+7SxEqWFbsVxHaPRtubToitayJUGlffa4ruNmIBPOZB25IN1XQGXLUuWbMGREA==
X-Received: by 2002:a05:6a00:4b05:b0:6ea:ed87:1348 with SMTP id kq5-20020a056a004b0500b006eaed871348mr964068pfb.13.1712696759294;
        Tue, 09 Apr 2024 14:05:59 -0700 (PDT)
Received: from localhost (fwdproxy-prn-000.fbsv.net. [2a03:2880:ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id y6-20020aa793c6000000b006e6fd17069fsm8767651pff.37.2024.04.09.14.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Apr 2024 14:05:59 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH for-next] io_uring: separate header for exported net bits
Date: Tue,  9 Apr 2024 14:05:53 -0700
Message-ID: <20240409210554.1878789-1-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

From: Pavel Begunkov <asml.silence@gmail.com>

We're exporting some io_uring bits to networking, e.g. for implementing
a net callback for io_uring cmds, but we don't want to expose more than
needed. Add a separate header for networking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
(cherry picked from commit 9218ba39c2bf0e7bb44e88968801cdc4e6e9fb3e)
Signed-off-by: David Wei <dw@davidwei.uk>

---

David: This has been pulled out from ZC Rx patchset as it can be merged
separately.

---
 include/linux/io_uring.h     |  6 ------
 include/linux/io_uring/net.h | 18 ++++++++++++++++++
 io_uring/uring_cmd.c         |  1 +
 net/socket.c                 |  2 +-
 4 files changed, 20 insertions(+), 7 deletions(-)
 create mode 100644 include/linux/io_uring/net.h

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 68ed6697fece..e123d5e17b52 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -11,7 +11,6 @@ void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
 const char *io_uring_get_opcode(u8 opcode);
-int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
 bool io_is_uring_fops(struct file *file);
 
 static inline void io_uring_files_cancel(void)
@@ -45,11 +44,6 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
-static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
-				    unsigned int issue_flags)
-{
-	return -EOPNOTSUPP;
-}
 static inline bool io_is_uring_fops(struct file *file)
 {
 	return false;
diff --git a/include/linux/io_uring/net.h b/include/linux/io_uring/net.h
new file mode 100644
index 000000000000..b58f39fed4d5
--- /dev/null
+++ b/include/linux/io_uring/net.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_IO_URING_NET_H
+#define _LINUX_IO_URING_NET_H
+
+struct io_uring_cmd;
+
+#if defined(CONFIG_IO_URING)
+int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
+
+#else
+static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
+				    unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+#endif
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 334d31dd6628..21ac5fb2d5f0 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -3,6 +3,7 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/io_uring/cmd.h>
+#include <linux/io_uring/net.h>
 #include <linux/security.h>
 #include <linux/nospec.h>
 #include <net/sock.h>
diff --git a/net/socket.c b/net/socket.c
index e5f3af49a8b6..01a71ae10c35 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -88,7 +88,7 @@
 #include <linux/xattr.h>
 #include <linux/nospec.h>
 #include <linux/indirect_call_wrapper.h>
-#include <linux/io_uring.h>
+#include <linux/io_uring/net.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
-- 
2.43.0


