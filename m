Return-Path: <io-uring+bounces-906-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 12716879DBD
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 22:46:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BEA30282481
	for <lists+io-uring@lfdr.de>; Tue, 12 Mar 2024 21:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4294D1448DE;
	Tue, 12 Mar 2024 21:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="2UpLVQHJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFBF144055
	for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 21:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710279880; cv=none; b=ZBtm7/ZL1x+CMfExKA+XmC/FkvzKyEPza/TGFm5J+J/luD4uOT4WwVGvoKKQ/Csgn1z9i+en+xFr/oBr8B1xnZGIy9k3cLmsLMw0LZ5DbslXKYrFgyPHJwFL9TCQzr7l/nHDGRZ3eAZXQ8mitsc/jHcwhY2KENjisMvfHZCIcIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710279880; c=relaxed/simple;
	bh=I4DkiUJPKP/SNnghbAnRFXvAzrtp+wFZDRulKLlCD6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwJX0Uajk/KG3fLeLPLzClKAZTuEuOb+Y/tZMUPvJjEowDjK/09fTmgzB7AbgPldbOcW4CfuQJYc/t05Q7CnZfW60bHVlajw9g/S3J4c1jZCwo4ofnVN5OIvbW4FRmtVsGHYI1njMMtRc2pcnt79qhXZo9hdeEy+BruJFhHa5vU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=2UpLVQHJ; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-6e6b6e000a4so86896b3a.0
        for <io-uring@vger.kernel.org>; Tue, 12 Mar 2024 14:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1710279878; x=1710884678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OHnlF2xfY1sV5nPIj52b/9LW93hoRYAyd9rWuaJTtKA=;
        b=2UpLVQHJG0fDY8HG5IWIn1MIctW8hyHIXq8ZDotVbnBQQSvXs6sGCPuFVKuMc046Qz
         lfa1sGrtJfYA56SyQ48n8fg5QZ+bQdk45nnrB9fIVWp/TQ5/WSBVWOVuqqY5Z2VWgRlU
         D3fKcPA+xxZ0JA76GjYXtlusoKyXCDSLtJQntRaUf2+8i/pme20zt/Phq6wCoeZdFPuU
         8FlV/X34qrlqbA1E0d+yz3AOfmRK2iTTa9DJzY4wCoTfYt+mrIH3GCu/4L78QhYHEwfN
         XosFR6e3D4hAN8gx9uX19vpBYVuEvOZAMASYYZjOxefBhqDQdCX7IQyaW+wFjLJlQ6KB
         K6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710279878; x=1710884678;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OHnlF2xfY1sV5nPIj52b/9LW93hoRYAyd9rWuaJTtKA=;
        b=csjcud+IpimiEWwNqteSE4xZZniHYCwgEXVqSx0QlXinmZENnizzUnD4suuosDNkci
         54JACkPBC4MjDj4c1ErZvKGEl2LFNztul3hLO6q6lWS0zjt6LO+OdTjU3Kg+ob3f3LpG
         lMspnuNMXO8LEWGNOG/+GSQOBC9aASr0nggt9RmqVG4B2aut1vbLCZCZ97vp7vmOzzcy
         ob0Hdsgc7MipXxKfNk5Mb4v8klsMtxoYukVqJ/PXWsZcz2nu3N0/YCeoAH4oivn/LpMn
         sB+O8VsayrsP2D1d8CE5mEq1FdNNicm843LAPXs2x18J7El19dsHkpEqYPMP01J8o0/i
         ukbw==
X-Gm-Message-State: AOJu0Yy2GTs5THFAwQq99+jJeKyDq4q8ytiwktwMroYnmuabBXtbSEpx
	G4kcL8PPCV8vnQTuE0Hc4LjMUNNOcpVBocEU/mhpNNnfRi8syXmEgLeMIcFnjLgjSmPjZwXuFtZ
	i
X-Google-Smtp-Source: AGHT+IGijpkcSJHwZGLpndsro/SSwC0BV49Gse2r6r8xefCXAEDgDSknnBQKaFjRr1FvLb0RWkrOEw==
X-Received: by 2002:a05:6a20:1583:b0:1a3:1180:4232 with SMTP id h3-20020a056a20158300b001a311804232mr1061647pzj.29.1710279877802;
        Tue, 12 Mar 2024 14:44:37 -0700 (PDT)
Received: from localhost (fwdproxy-prn-020.fbsv.net. [2a03:2880:ff:14::face:b00c])
        by smtp.gmail.com with ESMTPSA id c15-20020aa78c0f000000b006e623357178sm6774016pfd.176.2024.03.12.14.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Mar 2024 14:44:37 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [RFC PATCH v4 04/16] io_uring: separate header for exported net bits
Date: Tue, 12 Mar 2024 14:44:18 -0700
Message-ID: <20240312214430.2923019-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240312214430.2923019-1-dw@davidwei.uk>
References: <20240312214430.2923019-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

We're exporting some io_uring bits to networking, e.g. for implementing
a net callback for io_uring cmds, but we don't want to expose more than
needed. Add a separate header for networking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
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
index 42f63adfa54a..0b504b33806c 100644
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
index ed3df2f749bf..c69cd0e652b8 100644
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


