Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B81759302
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 12:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjGSK32 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 06:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbjGSK3Q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 06:29:16 -0400
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465BE1BC0;
        Wed, 19 Jul 2023 03:28:42 -0700 (PDT)
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-4fba8f2197bso11402351e87.3;
        Wed, 19 Jul 2023 03:28:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689762478; x=1692354478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bw5UDGeKJ7BUad+TVKsaKYkD1Z7MysjHU3RtJUQyTus=;
        b=QiRIrUtQSOnpg2Z6Q1REzFbHVQcZj2nJ4i2xWZpVGGaHadCRQOeqe2yc4e3sHYr4Ln
         UFPmjrIo6jv1md6Ssufxzdh+gyVL/4a61z+dyDYXxbU+y9gkYmTekvmWVMktPeEDL5G1
         EGXrcyDQGff0qdOb3ry7HInuRgPWWMLdk9QjPqDFGokZf87s8kj+Ft3MOZeTiEWoRKue
         nnlj0HnPaYLuJpvSqNRodUpzOr7FEGiRgbiAhYPUNvwz+NxyRI5yKE349L4jl6tzp7DI
         oCwz/xjNjdXorekR1XppntWatgEij20E/vUyohyq2oAdyWjWoplxyoI79L/Hfe+Lmqyw
         ep9g==
X-Gm-Message-State: ABy/qLY0kMpuiV9K2Ia22pHgZVJhDB4m8dKNQj7vV0n1skPBdrM8YlXi
        5080BDkq7gaveSbajt7OXDI=
X-Google-Smtp-Source: APBJJlEEOc6gjgYbIAHBLCQvcbbtUcamp2A6N2rmOuVFwOvJ0Eryjtf3OX6/o0elQUGRqHtvPsOQOA==
X-Received: by 2002:a05:6512:3d89:b0:4f9:6528:fb15 with SMTP id k9-20020a0565123d8900b004f96528fb15mr13879527lfv.12.1689762478288;
        Wed, 19 Jul 2023 03:27:58 -0700 (PDT)
Received: from localhost (fwdproxy-cln-119.fbsv.net. [2a03:2880:31ff:77::face:b00c])
        by smtp.gmail.com with ESMTPSA id q14-20020a1cf30e000000b003fbe561f6a3sm1339780wmq.37.2023.07.19.03.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 03:27:57 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/3] io_uring/cmd: Add support for getsockopt command
Date:   Wed, 19 Jul 2023 03:27:36 -0700
Message-Id: <20230719102737.2513246-3-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230719102737.2513246-1-leitao@debian.org>
References: <20230719102737.2513246-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for getsockopt function, where level is SOL_SOCKET. This is
leveraging the sockptr_t infrastructure, where a sockptr_t is either
userspace or kernel space, and handled as such.

Function io_uring_cmd_getsockopt() is inspired by __sys_getsockopt().

Differently from the getsockopt(2), the optlen field is not a userspace
pointers. In getsockopt(2), userspace provides a pointer, which is
overwritten by the kernel.

In this implementation, userspace passes a u32, and the new value is
returned in cqe->res.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  7 +++++++
 io_uring/uring_cmd.c          | 27 +++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

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
index 8e7a03c1b20e..28fd09351be7 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -166,6 +166,31 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+static inline int io_uring_cmd_getsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd)
+{
+	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	int optlen = READ_ONCE(cmd->sqe->optlen);
+	int optname = READ_ONCE(cmd->sqe->optname);
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
+		if (err < 0)
+			return err;
+		return optlen;
+	}
+
+	return -EOPNOTSUPP;
+}
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -187,6 +212,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
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

