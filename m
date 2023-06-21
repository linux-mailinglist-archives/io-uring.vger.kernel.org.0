Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6C747392F9
	for <lists+io-uring@lfdr.de>; Thu, 22 Jun 2023 01:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbjFUXV6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Jun 2023 19:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjFUXV5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Jun 2023 19:21:57 -0400
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E39119A6;
        Wed, 21 Jun 2023 16:21:56 -0700 (PDT)
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3094910b150so6618021f8f.0;
        Wed, 21 Jun 2023 16:21:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687389715; x=1689981715;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yiB4M6We9Ffv/gAy4pJo1KcCEjN0r8CrdiYZ/KoY5tg=;
        b=bjDFVCx2LoQKD2NsV3sZ3d/ueLXy0CPKKuGThRQkNuiK9nPv2Xi63vCB1HIhUrN/Zj
         jkrzaCM5uzdcRDYQ1r0RCCPRbgWf55caTo1RLMrBFVQXnnhygrV8xhNfJwpWxFZowy9R
         QPatcaoGn24JDzRLL/j5QPHG68yHjLYfHdb8UtNgHuH5HNT2kUg/mlxG63yExV7ZkhAn
         /oiDiBv9WAnYOcJd2AvKgTrZ5/HuVlhAH7medsn9LO1I74Ituk8n88yXedkz9cQXi5Ar
         vTneCyDq246Ml88Z491BmFhmwqGF7rqGQ884X4Rc4HAyXZW4ET4ONvcmeBFLWbl9eRpx
         PfBw==
X-Gm-Message-State: AC+VfDxdM16ELPzJLtv/9Zdgwnv1GJhJdZkKPM0UQgKUNWkCgUwE57tc
        wlnFa+RAcKYFLc9yqXnKmR8=
X-Google-Smtp-Source: ACHHUZ51UC6DatOVWbMH3yTKJZ8YPx4aZLWwpezonY/wgEYAQ6tkuAGlmUY6hT8ACK7g8xJCkYvMtg==
X-Received: by 2002:adf:ce0f:0:b0:311:9bb:9384 with SMTP id p15-20020adfce0f000000b0031109bb9384mr12536902wrn.54.1687389714673;
        Wed, 21 Jun 2023 16:21:54 -0700 (PDT)
Received: from localhost (fwdproxy-cln-119.fbsv.net. [2a03:2880:31ff:77::face:b00c])
        by smtp.gmail.com with ESMTPSA id f15-20020a5d4dcf000000b0030ae53550f5sm5532419wru.51.2023.06.21.16.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 16:21:53 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     leit@meta.com, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steve French <stfrench@microsoft.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Simon Ser <contact@emersion.fr>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        io-uring@vger.kernel.org (open list:IO_URING),
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH] io_uring: Add io_uring command support for sockets
Date:   Wed, 21 Jun 2023 16:21:26 -0700
Message-Id: <20230621232129.3776944-1-leitao@debian.org>
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
SOCKET_URING_OP commands that will operate on sockets. Since these
commands are similar to ioctl, uses the _IO{R,W} helpers to embedded the
argument size and operation direction. Also allocates a unused ioctl
chunk for uring command usage.

In order to call ioctl on sockets, use the file_operations->uring_cmd
callbacks, and map it to a uring socket function, which handles the
SOCKET_URING_OP accordingly, and calls socket ioctls.

This patches was tested by creating a new test case in liburing.
Link: https://github.com/leitao/liburing/commit/3340908b742c6a26f662a0679c4ddf9df84ef431

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 .../userspace-api/ioctl/ioctl-number.rst      |  1 +
 include/linux/io_uring.h                      |  6 +++++
 include/uapi/linux/io_uring.h                 |  6 +++++
 io_uring/uring_cmd.c                          | 27 +++++++++++++++++++
 net/socket.c                                  |  2 ++
 5 files changed, 42 insertions(+)

diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
index 4f7b23faebb9..23348636f2ef 100644
--- a/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -361,6 +361,7 @@ Code  Seq#    Include File                                           Comments
 0xCB  00-1F                                                          CBM serial IEC bus in development:
                                                                      <mailto:michael.klein@puffin.lb.shuttle.de>
 0xCC  00-0F  drivers/misc/ibmvmc.h                                   pseries VMC driver
+0xCC  A0-BF  uapi/linux/io_uring.h                                   io_uring cmd subsystem
 0xCD  01     linux/reiserfs_fs.h
 0xCE  01-02  uapi/linux/cxl_mem.h                                    Compute Express Link Memory Devices
 0xCF  02     fs/smb/client/cifs_ioctl.h
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 7fe31b2cd02f..d1b20e2a9fb0 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -71,6 +71,7 @@ static inline void io_uring_free(struct task_struct *tsk)
 	if (tsk->io_uring)
 		__io_uring_free(tsk);
 }
+int uring_sock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags);
 #else
 static inline int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
@@ -102,6 +103,11 @@ static inline const char *io_uring_get_opcode(u8 opcode)
 {
 	return "";
 }
+static inline int uring_sock_cmd(struct io_uring_cmd *cmd,
+				 unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 0716cb17e436..e20ba410859d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -703,6 +703,12 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
+/*
+ * Argument for IORING_OP_URING_CMD when file is a socket
+ */
+#define SOCKET_URING_OP_SIOCINQ _IOR(0xcc, 0xa0, int)
+#define SOCKET_URING_OP_SIOCOUTQ _IOR(0xcc, 0xa1, int)
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 5e32db48696d..dcbe6493b03f 100644
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
+int uring_sock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
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
+EXPORT_SYMBOL_GPL(uring_sock_cmd);
diff --git a/net/socket.c b/net/socket.c
index b778fc03c6e0..db11e94d2259 100644
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
+	.uring_cmd =    uring_sock_cmd,
 	.mmap =		sock_mmap,
 	.release =	sock_close,
 	.fasync =	sock_fasync,
-- 
2.34.1

