Return-Path: <io-uring+bounces-305-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C15E48191EE
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 22:04:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7F8DA28215E
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 21:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF18B3B795;
	Tue, 19 Dec 2023 21:04:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="Erzzqqgj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833443B79F
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 21:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6d411636a95so76073b3a.0
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 13:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1703019850; x=1703624650; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxF16fAD5eY0vARRtlHeEdU6+P5TPKLrnZoJ3mN5VeE=;
        b=ErzzqqgjalS5ujCO50KqgFAMsFMtWp1/zrlkAU6OCuzTTHXuRB8eB649YsZa7WIG1S
         Z5E4ICEorKlo4kxD4YRQqUWl9WX5rJRHnz/K/cYE4oAfx9DG3rJc1eAc/6tWY5PqQJaJ
         XrvsLt/FfVEEEhVezufe+skQMskQnWoZaFq0sIsdsXiQVcFLsSNsgrFKWcBZ5M4MYEGR
         0NtRqazGtD695JYR1s+CUyVlxLaTvLyLQPsGOhABh2c45mDh0wUANOC6/1t/d3k3eKtB
         y8Q49aCxdbtgtrhOS5YeAnl/1+bnWlMA8ApBS7WkcOx6raCijxVYo+IgrTEOOnzKIoVQ
         VcYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703019850; x=1703624650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bxF16fAD5eY0vARRtlHeEdU6+P5TPKLrnZoJ3mN5VeE=;
        b=H0aGwPLfyYiqg15GYz3J407v5VZa7q5uGo3DaFgnc8yfKo9z6UKYplRmyMdx3deAzD
         pwFQAwKSbUqohl5RtuPk2RFqdEQI4ZY9CHcf3bZhqCNSXKpb9v4q86jh+thOEZv3zaq9
         +8bFkZj4ytPfMV2Sqqck9O0BB5QjvnBbRn8ql3hRjsBzOnCXXasbY5W3BJAh5r0c/ADZ
         8hepld0oCE1mqUqI6rnsVGnwfjwvyrOOjJrrZWThPPy3ZqStnQ7effsxUZJam/HxhFv8
         3Z4A6fRYQuxS82+hNNP6m1ALbMzlctDfGyzsHKSLzb5TfxJ+ctkfXKucE6ZBOXoIwSnR
         B9mQ==
X-Gm-Message-State: AOJu0YyglvBXaS0r06izyMbLOWqnEyCEOg2lqSjmJESX2yRAnt6JMckI
	AHuBpelSnZdm8LUJ6bQ6Ju0LF/A6xmCIdk1FiomjhA==
X-Google-Smtp-Source: AGHT+IHQu3MDTkpc00SBCiVZjqGTylNNidHL0fESRWK86uvjemoU13/tRBE4mX3qs2HdkNdYcVbOmg==
X-Received: by 2002:a05:6a20:6311:b0:18f:354f:58c2 with SMTP id h17-20020a056a20631100b0018f354f58c2mr1314596pzf.44.1703019850627;
        Tue, 19 Dec 2023 13:04:10 -0800 (PST)
Received: from localhost (fwdproxy-prn-025.fbsv.net. [2a03:2880:ff:19::face:b00c])
        by smtp.gmail.com with ESMTPSA id c3-20020aa78803000000b006d451d8d7f3sm6017911pfo.76.2023.12.19.13.04.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Dec 2023 13:04:10 -0800 (PST)
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
Subject: [RFC PATCH v3 06/20] io_uring: separate header for exported net bits
Date: Tue, 19 Dec 2023 13:03:43 -0800
Message-Id: <20231219210357.4029713-7-dw@davidwei.uk>
X-Mailer: git-send-email 2.39.3
In-Reply-To: <20231219210357.4029713-1-dw@davidwei.uk>
References: <20231219210357.4029713-1-dw@davidwei.uk>
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
index d8fc93492dc5..88d9aae7681b 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -12,7 +12,6 @@ void __io_uring_cancel(bool cancel_all);
 void __io_uring_free(struct task_struct *tsk);
 void io_uring_unreg_ringfd(void);
 const char *io_uring_get_opcode(u8 opcode);
-int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
 static inline void io_uring_files_cancel(void)
 {
@@ -49,11 +48,6 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
-static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
-				    unsigned int issue_flags)
-{
-	return -EOPNOTSUPP;
-}
 #endif
 
 #endif
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
index 34030583b9b2..c98749eff5ce 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -3,6 +3,7 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/io_uring/cmd.h>
+#include <linux/io_uring/net.h>
 #include <linux/security.h>
 #include <linux/nospec.h>
 
diff --git a/net/socket.c b/net/socket.c
index 3379c64217a4..d75246450a3c 100644
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
2.39.3


