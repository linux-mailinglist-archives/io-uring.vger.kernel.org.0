Return-Path: <io-uring+bounces-3637-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B77299BBCA
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 22:45:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AE99DB20EE3
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 20:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30D9A1514CE;
	Sun, 13 Oct 2024 20:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KAgYFBTG"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721FF82C7E
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 20:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728852325; cv=none; b=WpOZpa8Xoo0WbuelqkcX4hwljPOej14b4MsJk1Ohmrjejq1r2ucMzK3ddwFbWXDFg/uepGPYb3e+OCmpmwFQoYNvAWIWW/+kGksj+6OyA5UAG80rOU3dME5EJc4pKYI3B/RYcjqG42nPcooXV35+NIaQfV5lTZco3f7kz6Dzb2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728852325; c=relaxed/simple;
	bh=avldfsQ7dAPVuGQJrjBHF7JPmTu4FsehzURUNX6Ybt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pL4xhb0zGgPIwjT7er2Ghaf7CEMmBadxzo2/j0NWE95nPDasx0PeC0dkeaEiQy4gC+cqSb4oq5uCxqzHbx+LNxpBMdQVvDDylNtHrEquyepyuVj6nCICLymOIuE3smj9m8FszU9ih+Uz8bKj4d5eGuo2pIg8nZs3KjaJ2IQqM38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KAgYFBTG; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a99ea294480so167265166b.2
        for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 13:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728852321; x=1729457121; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mh5b3fLKFrmas27aO98OK/DGsN3T/vUtw+HvnH2RNqw=;
        b=KAgYFBTG2W9byqn6gJhFTsk8sG8YDgSWsiy+bDYl7eDHxNj1MO3A1WTYLbAWUfDqZn
         k5AaW50kx+Nvh/jGzjX8NhzJUgJ1hK/Tqw3UbypA0ergvZ2wIEpvZ7fkPPRKTOWzRXw5
         yZ7wzOpj8QZYd/V1kkz8B5w1vo8+6GNzIdYUrDpnOj+mDfhLxmehmii5Uhw4+nIY53Bm
         1CG2L9sYffrDkmFjxa8bD0X1/fnYWJxn1/w7seojO9ExAwzOmi4DSvQv90Wj9hl7kQVB
         yRa0gaSuUe+3aNh4Pc3BTwGTlTTfMT9+W3DFSGQMFDaVGYNPGcOslEieFZMk/mJ7ql0B
         ZmhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728852321; x=1729457121;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mh5b3fLKFrmas27aO98OK/DGsN3T/vUtw+HvnH2RNqw=;
        b=iCTKRXKtzAHtLHA5xpeamfk0zdnD4YFPChxfMJQUg56WrE+e+ENirgUWhL1/06/9Fd
         3QvI+ZWpnmBFCbZljyHVriR8Lv4HW/S3lDuBw7HpeCeABa4VMFc8ggwPXLKuZ3zYuipW
         B7t5aJxbO+p/vKWWMw5mIcB3XlxOpb/h1Lbsv+OP6JASCbeW76zt6RkfRKxE9ttfm/M0
         Dkkt9aYIbbY7UJ8Kp3q8ffd9c0tWbW2tfde/eErs/lpVFlUrVwCtdF3M03RZBPP0RomV
         I22lYRPu5IPsn6HWDuv3EFB3pj2PjVfHBbcVVAz+Mo+shzini7AZn9zf18XKe9T5HPRT
         2jfQ==
X-Gm-Message-State: AOJu0YwAvexuTIiY4wioZPdunDHaQZfuKmB4h1LuS70a6M8L5MooWrZA
	1DaP25rNBuFFdl96RO+y0DPWYnBQuNrtubY1W6BOtw1fP8nqVl6QUgs0Ng==
X-Google-Smtp-Source: AGHT+IEs0QAsrJvN9U2GVxq7bs2GnexaNmjuYi4OAo9wAvsNnvSYth/j2JDTTfya+8g85vZ1W1i0Pw==
X-Received: by 2002:a05:6402:5c9:b0:5c9:5745:de9a with SMTP id 4fb4d7f45d1cf-5c95ac15776mr9139379a12.9.1728852320836;
        Sun, 13 Oct 2024 13:45:20 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.233.136])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99f86b689dsm186078166b.181.2024.10.13.13.45.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 13:45:19 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 1/3] Add io_uring_prep_cmd_discard
Date: Sun, 13 Oct 2024 21:45:44 +0100
Message-ID: <45357cbdcbea27505bd43ed53e19722737fa4179.1728851862.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1728851862.git.asml.silence@gmail.com>
References: <cover.1728851862.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a helper for io_uring block discard commands. Since the discard
opcode is in newly added linux/blkdev.h we need to do some configure
magic defining it ourselves if the header is missing from the system.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 configure              | 32 ++++++++++++++++++++++++++++++++
 src/include/liburing.h | 10 ++++++++++
 2 files changed, 42 insertions(+)

diff --git a/configure b/configure
index e2221d3..6c9cea0 100755
--- a/configure
+++ b/configure
@@ -417,6 +417,21 @@ if compile_prog "" "" "futexv"; then
 fi
 print_config "futex waitv support" "$futexv"
 
+##########################################
+# Check block discard cmd support
+discard_cmd="no"
+cat > $TMPC << EOF
+#include <linux/blkdev.h>
+int main(void)
+{
+  return BLOCK_URING_CMD_DISCARD;
+}
+EOF
+if compile_prog "" "" "discard command"; then
+  discard_cmd="yes"
+fi
+print_config "io_uring discard command support" "$discard_cmd"
+
 ##########################################
 # Check idtype_t support
 has_idtype_t="no"
@@ -651,6 +666,23 @@ typedef enum
 } idtype_t;
 EOF
 fi
+
+if test "$discard_cmd" != "yes"; then
+cat >> $compat_h << EOF
+
+#include <linux/ioctl.h>
+
+#ifndef BLOCK_URING_CMD_DISCARD
+#define BLOCK_URING_CMD_DISCARD                        _IO(0x12, 0)
+#endif
+
+EOF
+else cat >> $discard_cmd << EOF
+#include <linux/blkdev.h>
+
+EOF
+fi
+
 cat >> $compat_h << EOF
 #endif
 EOF
diff --git a/src/include/liburing.h b/src/include/liburing.h
index c5a2fda..f5903d7 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1292,6 +1292,16 @@ IOURINGINLINE void io_uring_prep_ftruncate(struct io_uring_sqe *sqe,
 }
 #endif
 
+IOURINGINLINE void io_uring_prep_cmd_discard(struct io_uring_sqe *sqe,
+					     int fd,
+					     uint64_t offset, uint64_t nbytes)
+{
+	io_uring_prep_rw(IORING_OP_URING_CMD, sqe, fd, 0, 0, 0);
+	sqe->cmd_op = BLOCK_URING_CMD_DISCARD;
+	sqe->addr = offset;
+	sqe->addr3 = nbytes;
+}
+
 /*
  * Returns number of unconsumed (if SQPOLL) or unsubmitted entries exist in
  * the SQ ring
-- 
2.46.0


