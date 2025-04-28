Return-Path: <io-uring+bounces-7753-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8147FA9F16E
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 14:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9D7735A07BA
	for <lists+io-uring@lfdr.de>; Mon, 28 Apr 2025 12:52:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 122D626A098;
	Mon, 28 Apr 2025 12:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fYN2ec5v"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA4B2690D0
	for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 12:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745844708; cv=none; b=rWDDR9sNhwiqV1DH9VOhsZlxCjGHFEEnqdk6ngBzPs7Ujeo173FMOmN/gCe5BJRsr9pFxBKq/J1GF3WFyng5d+Mjwr4g144L5rJH8SCBIiL1uetE/ZtXsqwj10zyyihsI8BUvN95qlp0ULDW4YU76uYLV3xsiO7GaIXmaX2gcH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745844708; c=relaxed/simple;
	bh=59vLlDvRXc2ym4sjcVinrWIlA7UM2j0QqOXdx9YLWvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohD4vKuFtl56mK+98RxVEy65knqEnh4ZjaurJ/VntvfEqTEHtlT16MyJUSYmYsw7/7L46V9ebzUgAZjiqnF3S32vVzKqzRX8R9gplS69I2b+DQOe+PShqrhT0z9URA1AoeJVto6xX+tJK/nQBiZsTEChBmov5LnAgce9LRfJmLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fYN2ec5v; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac3fcf5ab0dso755365166b.3
        for <io-uring@vger.kernel.org>; Mon, 28 Apr 2025 05:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745844704; x=1746449504; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PoMeQUf2A/Rs3yw5iBBxk+tzFZkNU4qOBFUOTiWuKRw=;
        b=fYN2ec5v4N/IzikSY3g1bAYfOaktJ8D4pu953MYm1brXUplQn15TU2dCGtCqYXYnkq
         ICoFBynIs7a7ZE2nWLKCnM3b0iqjBY4UK/FtTWXSXJgTUxDXCKPcbKLHyLQEi6NNAnoW
         VcWol8nqQ8sMzQCLClBjKuPQBV4ol8hvpmEPBGJw0bvdSyZvCWge/Iza/dH6EyYq8JXP
         BHhq2m0xceGZaEv4AyHb/KnTDVPN01bzlTFlzIZf2cbrfqFDOGGcz4+uNUjo+siOJqiJ
         +BzIRcGKNXo1Moa12LRhY7gZR/gQDr2Lv8uGIpu8q23PV/GcaxV4A3PpizqMx7V8u6h2
         3/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745844704; x=1746449504;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PoMeQUf2A/Rs3yw5iBBxk+tzFZkNU4qOBFUOTiWuKRw=;
        b=vPYuMdLcue6f9oH5DYXvEb6rn0G6riAj+LV+PYrdg8Jo+GWOEOHrbgSVpr5oUdoPur
         jSF+cFkzL24xsCzdMEPHNzxWkbVQoeyuxm3n4qBQSdFUOFFOy5m6gtMzUiWdGbKjA79h
         lB8i9DxCnkEv7AhWz1pGM/dJUATifMhA4YzSKIzLBX0RZ7tpKaVGSnOrzsQA3Aw7Z+dr
         Zk2d9XkhNmY7MvkGjd+5yyRyiOf9WxhnacLUUitueHMFElz0b9rrdnQUhxhL/Raemd5u
         +a5SezqJIMUMHWbxcBUBSEl7nVBMVN7kcXsuE0mLWrrf4oEoMcCpYRuv3KIwwcnO7qcP
         qfCA==
X-Gm-Message-State: AOJu0YygR1Px20kkw9OfmMONH7wLOFNmycOGVMUQroPYcc1TZCCRyPS1
	mlhQ/r2vwEc1O+rDu2o56h3T5fCnA1GiUNZlEJwGXWc86xUvjx0+X14vVA==
X-Gm-Gg: ASbGnctbkBB5UUZErbdxx03VpL1Gxn+PTP+jNDKeRPf+I3QQcSgN+VC21V1o//+8S15
	XbNBHdGQNaXmnlFNzW1V26EnfkRRPJ9vHUnFmPLbehw6tVQAas7Gm42dmTB5/Sq+vCEbMOnfVFR
	nWRCgYfFbZawjSf9UJXmwDFYAZGn3IqVRqpCnjdbKf/vAZ/542Vow3JQpO3ZpRVL4okMV4W+j+w
	N0bAmsJSodDqmO76uaWLkC6/Xn+c0jGMoCjA5WFTRGSm5bZt+bqtlLiZ++/1qbu5muZfu0GQWqe
	eiAjquC3fPigWeP36c47hfij
X-Google-Smtp-Source: AGHT+IHR+qj41/4KYXCA5yq0NkJ0woyXCUGcBdRkbYb15IACWptVX3ybfwrXMrULObAOF45Hqte45w==
X-Received: by 2002:a17:906:6a23:b0:ace:6f45:b5c6 with SMTP id a640c23a62f3a-ace710c6dbemr1112418466b.22.1745844703603;
        Mon, 28 Apr 2025 05:51:43 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:c92c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ace6e58673dsm613010766b.76.2025.04.28.05.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 05:51:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: [PATCH RFC 2/7] io_uring/cmd: move net cmd into a separate file
Date: Mon, 28 Apr 2025 13:52:33 +0100
Message-ID: <747d0519a2255bd055ae76b691d38d2b4c311001.1745843119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1745843119.git.asml.silence@gmail.com>
References: <cover.1745843119.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We keep socket io_uring command implementation in io_uring/uring_cmd.c.
Separate it from generic command code into a separate file.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/Makefile    |  1 +
 io_uring/cmd_net.c   | 83 ++++++++++++++++++++++++++++++++++++++++++++
 io_uring/uring_cmd.c | 83 --------------------------------------------
 3 files changed, 84 insertions(+), 83 deletions(-)
 create mode 100644 io_uring/cmd_net.c

diff --git a/io_uring/Makefile b/io_uring/Makefile
index 3e28a741ca15..75e0ca795685 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -19,3 +19,4 @@ obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_EPOLL)		+= epoll.o
 obj-$(CONFIG_NET_RX_BUSY_POLL)	+= napi.o
+obj-$(CONFIG_NET) += cmd_net.o
diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
new file mode 100644
index 000000000000..e99170c7d41a
--- /dev/null
+++ b/io_uring/cmd_net.c
@@ -0,0 +1,83 @@
+#include <asm/ioctls.h>
+#include <linux/io_uring/net.h>
+#include <net/sock.h>
+
+#include "uring_cmd.h"
+
+static inline int io_uring_cmd_getsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd,
+					  unsigned int issue_flags)
+{
+	const struct io_uring_sqe *sqe = cmd->sqe;
+	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
+	int optlen, optname, level, err;
+	void __user *optval;
+
+	level = READ_ONCE(sqe->level);
+	if (level != SOL_SOCKET)
+		return -EOPNOTSUPP;
+
+	optval = u64_to_user_ptr(READ_ONCE(sqe->optval));
+	optname = READ_ONCE(sqe->optname);
+	optlen = READ_ONCE(sqe->optlen);
+
+	err = do_sock_getsockopt(sock, compat, level, optname,
+				 USER_SOCKPTR(optval),
+				 KERNEL_SOCKPTR(&optlen));
+	if (err)
+		return err;
+
+	/* On success, return optlen */
+	return optlen;
+}
+
+static inline int io_uring_cmd_setsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd,
+					  unsigned int issue_flags)
+{
+	const struct io_uring_sqe *sqe = cmd->sqe;
+	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
+	int optname, optlen, level;
+	void __user *optval;
+	sockptr_t optval_s;
+
+	optval = u64_to_user_ptr(READ_ONCE(sqe->optval));
+	optname = READ_ONCE(sqe->optname);
+	optlen = READ_ONCE(sqe->optlen);
+	level = READ_ONCE(sqe->level);
+	optval_s = USER_SOCKPTR(optval);
+
+	return do_sock_setsockopt(sock, compat, level, optname, optval_s,
+				  optlen);
+}
+
+int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct socket *sock = cmd->file->private_data;
+	struct sock *sk = sock->sk;
+	struct proto *prot = READ_ONCE(sk->sk_prot);
+	int ret, arg = 0;
+
+	if (!prot || !prot->ioctl)
+		return -EOPNOTSUPP;
+
+	switch (cmd->cmd_op) {
+	case SOCKET_URING_OP_SIOCINQ:
+		ret = prot->ioctl(sk, SIOCINQ, &arg);
+		if (ret)
+			return ret;
+		return arg;
+	case SOCKET_URING_OP_SIOCOUTQ:
+		ret = prot->ioctl(sk, SIOCOUTQ, &arg);
+		if (ret)
+			return ret;
+		return arg;
+	case SOCKET_URING_OP_GETSOCKOPT:
+		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
+	case SOCKET_URING_OP_SETSOCKOPT:
+		return io_uring_cmd_setsockopt(sock, cmd, issue_flags);
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index a9ea7d29cdd9..34b450c78e2b 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -3,13 +3,10 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/io_uring/cmd.h>
-#include <linux/io_uring/net.h>
 #include <linux/security.h>
 #include <linux/nospec.h>
-#include <net/sock.h>
 
 #include <uapi/linux/io_uring.h>
-#include <asm/ioctls.h>
 
 #include "io_uring.h"
 #include "alloc_cache.h"
@@ -302,83 +299,3 @@ void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 
 	io_req_queue_iowq(req);
 }
-
-static inline int io_uring_cmd_getsockopt(struct socket *sock,
-					  struct io_uring_cmd *cmd,
-					  unsigned int issue_flags)
-{
-	const struct io_uring_sqe *sqe = cmd->sqe;
-	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
-	int optlen, optname, level, err;
-	void __user *optval;
-
-	level = READ_ONCE(sqe->level);
-	if (level != SOL_SOCKET)
-		return -EOPNOTSUPP;
-
-	optval = u64_to_user_ptr(READ_ONCE(sqe->optval));
-	optname = READ_ONCE(sqe->optname);
-	optlen = READ_ONCE(sqe->optlen);
-
-	err = do_sock_getsockopt(sock, compat, level, optname,
-				 USER_SOCKPTR(optval),
-				 KERNEL_SOCKPTR(&optlen));
-	if (err)
-		return err;
-
-	/* On success, return optlen */
-	return optlen;
-}
-
-static inline int io_uring_cmd_setsockopt(struct socket *sock,
-					  struct io_uring_cmd *cmd,
-					  unsigned int issue_flags)
-{
-	const struct io_uring_sqe *sqe = cmd->sqe;
-	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
-	int optname, optlen, level;
-	void __user *optval;
-	sockptr_t optval_s;
-
-	optval = u64_to_user_ptr(READ_ONCE(sqe->optval));
-	optname = READ_ONCE(sqe->optname);
-	optlen = READ_ONCE(sqe->optlen);
-	level = READ_ONCE(sqe->level);
-	optval_s = USER_SOCKPTR(optval);
-
-	return do_sock_setsockopt(sock, compat, level, optname, optval_s,
-				  optlen);
-}
-
-#if defined(CONFIG_NET)
-int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
-{
-	struct socket *sock = cmd->file->private_data;
-	struct sock *sk = sock->sk;
-	struct proto *prot = READ_ONCE(sk->sk_prot);
-	int ret, arg = 0;
-
-	if (!prot || !prot->ioctl)
-		return -EOPNOTSUPP;
-
-	switch (cmd->cmd_op) {
-	case SOCKET_URING_OP_SIOCINQ:
-		ret = prot->ioctl(sk, SIOCINQ, &arg);
-		if (ret)
-			return ret;
-		return arg;
-	case SOCKET_URING_OP_SIOCOUTQ:
-		ret = prot->ioctl(sk, SIOCOUTQ, &arg);
-		if (ret)
-			return ret;
-		return arg;
-	case SOCKET_URING_OP_GETSOCKOPT:
-		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
-	case SOCKET_URING_OP_SETSOCKOPT:
-		return io_uring_cmd_setsockopt(sock, cmd, issue_flags);
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
-#endif
-- 
2.48.1


