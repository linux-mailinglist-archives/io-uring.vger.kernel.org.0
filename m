Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E97F791B80
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 18:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351144AbjIDQZ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Sep 2023 12:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353321AbjIDQZ6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Sep 2023 12:25:58 -0400
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 308B31702;
        Mon,  4 Sep 2023 09:25:43 -0700 (PDT)
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-98377c5d53eso236833866b.0;
        Mon, 04 Sep 2023 09:25:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693844741; x=1694449541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QGYqr/X7qoWEF8S4cg2Y5VhwvHoy/1iQUzz6K2rqzWE=;
        b=Zei0RopdVUIgfzDbRZyStEX3i6YLFswa080LeELOg9Uig15QRR4zi5sAlmPHra2HlO
         d7ftSCXBRBbDOL7GKvNZd/YETo3cnw2m73scNycjX0rL1PB0LmLQXaq1K36OOipKObJV
         MYGDSft3FQBvn/c1qK8dG+dmMAb132tzZW8C4n31OryTryZJDD/UXqZLceNaTyJ2E/p5
         aRRzvPyszLHAuyQWBfQ6pRtsyXM3Nt18J+jBNZvA80v1W9Da1qfsDxIiLnFtVzvxQwdj
         ZxLNrTWPtb2CV5tQ28qPuhjmOln0g0WM3R0ujS536EsxcQt6AwC4L4MvkwxFtifaTkQ5
         9M7Q==
X-Gm-Message-State: AOJu0Yx2xqsnSh66TJlNs6aRBGCA9T83ELbI8UDQA2BkOcWA376Y9tKi
        1DxRjDBl5Xc3+rhyvkzY6fo=
X-Google-Smtp-Source: AGHT+IGMBRPqYPoiQIu9IJkYob544kMn3mCaj8Qzc4kFstpgwfFh0gEa3qEfW6zMVwR/kd843fg5+g==
X-Received: by 2002:a17:906:5397:b0:993:d536:3cb7 with SMTP id g23-20020a170906539700b00993d5363cb7mr5762395ejo.11.1693844741376;
        Mon, 04 Sep 2023 09:25:41 -0700 (PDT)
Received: from localhost (fwdproxy-cln-116.fbsv.net. [2a03:2880:31ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id t2-20020a1709064f0200b00992076f4a01sm6354066eju.190.2023.09.04.09.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 09:25:40 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH v4 08/10] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Date:   Mon,  4 Sep 2023 09:25:01 -0700
Message-Id: <20230904162504.1356068-9-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904162504.1356068-1-leitao@debian.org>
References: <20230904162504.1356068-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support for getsockopt command (SOCKET_URING_OP_GETSOCKOPT), where
level is SOL_SOCKET. This is leveraging the sockptr_t infrastructure,
where a sockptr_t is either userspace or kernel space, and handled as
such.

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
index 8e61f8b7c2ce..29efa02a4dcb 100644
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
@@ -734,6 +740,7 @@ struct io_uring_recvmsg_out {
 enum {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
+	SOCKET_URING_OP_GETSOCKOPT,
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 6a91e1af7d05..c373e05ba9ce 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -167,6 +167,32 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
+							 int optname));
+static inline int io_uring_cmd_getsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd,
+					  unsigned int issue_flags)
+{
+	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
+	int optlen = READ_ONCE(cmd->sqe->optlen);
+	int optname = READ_ONCE(cmd->sqe->optname);
+	int level = READ_ONCE(cmd->sqe->level);
+	int err;
+
+	if (level != SOL_SOCKET)
+		return -EOPNOTSUPP;
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
 #if defined(CONFIG_NET)
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
@@ -189,6 +215,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		if (ret)
 			return ret;
 		return arg;
+	case SOCKET_URING_OP_GETSOCKOPT:
+		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

