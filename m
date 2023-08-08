Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA8E773D16
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbjHHQNx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 12:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjHHQMa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 12:12:30 -0400
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB267EC1;
        Tue,  8 Aug 2023 08:47:00 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2b9e6cc93d8so93815801fa.0;
        Tue, 08 Aug 2023 08:47:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691509614; x=1692114414;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r9Qw/F0brYOmpW9rwZop//d4heqX4w4nP09GhRsKIik=;
        b=T4BQwXpXdsCuYvtifYD93c+gJl9rrz++/mR+4CynnqIvkUphBdDQ+lCgTW1D5Bi+Pd
         VzU5S/44j9RzUIScS4QKgvxAIEgjOrRy8tDji1l921ZgNNxUFqrtES9Ziv9X6D3dHBib
         G7vP+ZDfprdS+SwSUuLv58BN+BeGptCqziUtKUOPiyKKG+ub3vTum+zI2bk9IZ7ZIcAE
         iSuXNg9/rEwuUhXUCKN7a5MpHlyfMeNolQIQE3qUpI2Py1QozWcyrh4m/mjELJrfeoB+
         nLeM6ywoACfu+zpBe7U8v+g8pnpYv0x5wwMHOJx4MIrMUzz8K2294mNLzrRmA+yMxSJu
         R+/A==
X-Gm-Message-State: AOJu0Yw68NILxUrlrTB/SJ1JZ9iclpb5ZGtyYQEOzYatsri3G6neoxCe
        +OsiLVGqovmnCRwfei7OonbnVu78xjE=
X-Google-Smtp-Source: AGHT+IEqhkwYaYSGAbqiw/LtPf5oEi+RgNvatwnvbRraW5eX4hKHlnSYlRuneFBiMukqQzpmDTlkmg==
X-Received: by 2002:aa7:dad0:0:b0:51d:9ddf:f0f6 with SMTP id x16-20020aa7dad0000000b0051d9ddff0f6mr10088298eds.36.1691502065220;
        Tue, 08 Aug 2023 06:41:05 -0700 (PDT)
Received: from localhost (fwdproxy-cln-012.fbsv.net. [2a03:2880:31ff:c::face:b00c])
        by smtp.gmail.com with ESMTPSA id bc5-20020a056402204500b005230f06de15sm6767707edb.78.2023.08.08.06.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 06:41:04 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH v2 2/8] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Date:   Tue,  8 Aug 2023 06:40:42 -0700
Message-Id: <20230808134049.1407498-3-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230808134049.1407498-1-leitao@debian.org>
References: <20230808134049.1407498-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
where a sockptr_t is either userspace or kernel space, and handled as
such.

Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().

Differently from the getsockopt(2), the optlen field is not a userspace
pointers. In getsockopt(2), userspace provides optlen pointer, which is
overwritten by the kernel.  In this implementation, userspace passes a
u32, and the new value is returned in cqe->res. I.e., optlen is not a
pointer.

Important to say that userspace needs to keep the pointer alive until
the CQE is completed.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  7 +++++++
 io_uring/uring_cmd.c          | 28 ++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 9fc7195f25df..8152151080db 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -43,6 +43,10 @@ struct io_uring_sqe {
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
 		__u64	splice_off_in;
+		struct {
+			__u32	level;
+			__u32	optname;
+		};
 	};
 	__u32	len;		/* buffer size or number of iovecs */
 	union {
@@ -79,6 +83,7 @@ struct io_uring_sqe {
 	union {
 		__s32	splice_fd_in;
 		__u32	file_index;
+		__u32	optlen;
 		struct {
 			__u16	addr_len;
 			__u16	__pad3[1];
@@ -89,6 +94,7 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		__u64	optval;
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
@@ -729,6 +735,7 @@ struct io_uring_recvmsg_out {
 enum {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
+	SOCKET_URING_OP_GETSOCKOPT,
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 8e7a03c1b20e..582931879482 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -166,6 +166,32 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+static inline int io_uring_cmd_getsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd)
+{
+	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	int optname = READ_ONCE(cmd->sqe->optname);
+	int optlen = READ_ONCE(cmd->sqe->optlen);
+	int level = READ_ONCE(cmd->sqe->level);
+	int err;
+
+	err = security_socket_getsockopt(sock, level, optname);
+	if (err)
+		return err;
+
+	if (level == SOL_SOCKET) {
+		err = sk_getsockopt(sock->sk, level, optname,
+				    USER_SOCKPTR(optval),
+				    KERNEL_SOCKPTR(&optlen));
+		if (err)
+			return err;
+
+		return optlen;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -187,6 +213,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		if (ret)
 			return ret;
 		return arg;
+	case SOCKET_URING_OP_GETSOCKOPT:
+		return io_uring_cmd_getsockopt(sock, cmd);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

