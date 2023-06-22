Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6D7C73ABF8
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 23:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbjFVV7l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jun 2023 17:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjFVV7l (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jun 2023 17:59:41 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D92921739;
        Thu, 22 Jun 2023 14:59:38 -0700 (PDT)
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-3fa7512e5efso502755e9.2;
        Thu, 22 Jun 2023 14:59:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687471177; x=1690063177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y7xfVnKi0DP1NtittcvkACNIGuIXZxKZkDplBO6fS4M=;
        b=bVmsxVcpsjj+glJlJOyj/g1+RHTlaMMaVIkEmgNEBO3klmQTM/S/B7u82sIlsEjmz7
         lZ/uTyV3uDY7k7QWZnvGHtKK1bN8n5EAznsylam3845C37f7JxWpGZ09Q087lnFxGgxc
         ZgMk94I2HgMcubLJVRp5aHPpIds1sKBoJ4w0DJcSBEwDi22kBcmyi+ZX/PGE/4zFvnTt
         7KoeLfyzsMt2mDFSOjc6NDHrjJhJExIS1/ETNRm9x/5MG77EQJT9PVskCr9O6pJ2oAjA
         70hQgeFiehjm70B3Xy/h63yYXCXQMA46e1I0v43LYjJ5YUPdUD3hpG+YBEaESZycfjUU
         RIDw==
X-Gm-Message-State: AC+VfDxlU55LVuDJYmKnzAw6Oh0efMuvAiwcFkVRNDIIz2e0Vz1Yf0ei
        ORSCOH7WxFzXijiME2TqIYq35hPeXX0Wjw==
X-Google-Smtp-Source: ACHHUZ6iZEQYDBr5SMoG1sHSwnJvbRZ7ITDmy6q/mQpoMIhzYBRmjUBzUIWxn1ZVEcWk37P0LJzbaQ==
X-Received: by 2002:a7b:c8c2:0:b0:3f7:5d:49ff with SMTP id f2-20020a7bc8c2000000b003f7005d49ffmr20473599wml.1.1687471176826;
        Thu, 22 Jun 2023 14:59:36 -0700 (PDT)
Received: from localhost (fwdproxy-cln-012.fbsv.net. [2a03:2880:31ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id c25-20020a7bc019000000b003fa52928fcbsm561126wmb.19.2023.06.22.14.59.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 14:59:36 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     gregkh@linuxfoundation.org,
        io-uring@vger.kernel.org (open list:IO_URING),
        linux-kernel@vger.kernel.org (open list),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH v3] io_uring: Add io_uring command support for sockets
Date:   Thu, 22 Jun 2023 14:59:14 -0700
Message-Id: <20230622215915.2565207-1-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Enable io_uring commands on network sockets. Create two new
SOCKET_URING_OP commands that will operate on sockets.

In order to call ioctl on sockets, use the file_operations->io_uring_cmd
callbacks, and map it to a uring socket function, which handles the
SOCKET_URING_OP accordingly, and calls socket ioctls.

This patches was tested by creating a new test case in liburing.
Link: https://github.com/leitao/liburing/tree/io_uring_cmd

Signed-off-by: Breno Leitao <leitao@debian.org>
---
V1 -> V2:
	* Keep uring code outside of network core subsystem
	* Uses ioctl to define uring operation
	* Use a generic ioctl function, instead of copying it over
V2 -> V3:
	* Do not use ioctl() helpers to create uring operations
	* Rename uring_sock_cmd to io_uring_cmd_sock
---
 include/linux/io_uring.h      |  6 ++++++
 include/uapi/linux/io_uring.h |  8 ++++++++
 io_uring/uring_cmd.c          | 27 +++++++++++++++++++++++++++
 net/socket.c                  |  2 ++
 4 files changed, 43 insertions(+)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 7fe31b2cd02f..f00baf2929ff 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -71,6 +71,7 @@ static inline void io_uring_free(struct task_struct *tsk)
 	if (tsk->io_uring)
 		__io_uring_free(tsk);
 }
+int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
@@ -102,6 +103,11 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
+static inline int io_uring_cmd_sock(struct io_uring_cmd *cmd,
+				    unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0716cb17e436..5c25f8c98aa8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -703,6 +703,14 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
+/*
+ * Argument for IORING_OP_URING_CMD when file is a socket
+ */
+enum {
+	SOCKET_URING_OP_SIOCINQ		= 0,
+	SOCKET_URING_OP_SIOCOUTQ,
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 5e32db48696d..31ce59567295 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -7,6 +7,7 @@
 #include <linux/nospec.h>
 
 #include <uapi/linux/io_uring.h>
+#include <uapi/asm-generic/ioctls.h>
 
 #include "io_uring.h"
 #include "rsrc.h"
@@ -156,3 +157,29 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 	return io_import_fixed(rw, iter, req->imu, ubuf, len);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
+
+int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	struct socket *sock = cmd->file->private_data;
+	struct sock *sk = sock->sk;
+	int ret, arg = 0;
+
+	if (!sk->sk_prot || !sk->sk_prot->ioctl)
+		return -EOPNOTSUPP;
+
+	switch (cmd->sqe->cmd_op) {
+	case SOCKET_URING_OP_SIOCINQ:
+		ret = sk->sk_prot->ioctl(sk, SIOCINQ, &arg);
+		if (ret)
+			return ret;
+		return arg;
+	case SOCKET_URING_OP_SIOCOUTQ:
+		ret = sk->sk_prot->ioctl(sk, SIOCOUTQ, &arg);
+		if (ret)
+			return ret;
+		return arg;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_sock);
diff --git a/net/socket.c b/net/socket.c
index b778fc03c6e0..09b105d00445 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -88,6 +88,7 @@
 #include <linux/xattr.h>
 #include <linux/nospec.h>
 #include <linux/indirect_call_wrapper.h>
+#include <linux/io_uring.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -159,6 +160,7 @@ static const struct file_operations socket_file_ops = {
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = compat_sock_ioctl,
 #endif
+	.uring_cmd =    io_uring_cmd_sock,
 	.mmap =		sock_mmap,
 	.release =	sock_close,
 	.fasync =	sock_fasync,
-- 
2.34.1

