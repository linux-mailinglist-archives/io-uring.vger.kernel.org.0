Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F5A79BAD2
	for <lists+io-uring@lfdr.de>; Tue, 12 Sep 2023 02:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242556AbjIKWKd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Sep 2023 18:10:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236416AbjIKKeq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Sep 2023 06:34:46 -0400
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BBAB120;
        Mon, 11 Sep 2023 03:34:42 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-9aa2468bdb4so140522166b.0;
        Mon, 11 Sep 2023 03:34:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694428480; x=1695033280;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v7j1QmeYuygIkE0CEX687y6FT8cxPJYvkR7OuyNEGnA=;
        b=xTIjGoaS9x7SyoPH/RZK0YXmnAXJP/Us65YhiUGYToDDzBPrYXAkzQUo7GyENrLJVZ
         Kax5zZKSN0Sw9s6VpgXQKpzamwzuBb2nlglNgusvBTVY+1umdTZ5ktmFj4iGmFQCehO4
         iXNkpJ5TUt8dlboNxSu8lkoovFyE1ANW0ddU8Pgm9yf+7SYygNC4I+0zKy4uYlJ+JuAk
         e8833AhuUx2lROhG6SB+c1iCGvgUwsHjDfNCkdpEASLbp2CU8SPy5uUvnkjhB2UqIUqT
         qNyCbcd2lpbnzXvYxPJ8aWJ6qzhWz3E262/OwXBC18GEP4J/Uxcc/Qw4YneQjNA9yz4G
         Jk9g==
X-Gm-Message-State: AOJu0YzoXlRNrOV4NOy7osr63KBaDl1porO1+WA4trSYQK8he2vXTDZ4
        BNbUIKBcyT6pJJVfsXxWdRc=
X-Google-Smtp-Source: AGHT+IFAFUQkUnUVJBxRblUhkO6iA2j5fqxMkm4dviZ752xsU5s8G6ckrf+vOXr2K+4laWtPH4ogvQ==
X-Received: by 2002:a17:906:3111:b0:9a1:e941:6f49 with SMTP id 17-20020a170906311100b009a1e9416f49mr7703599ejx.44.1694428480677;
        Mon, 11 Sep 2023 03:34:40 -0700 (PDT)
Received: from localhost (fwdproxy-cln-002.fbsv.net. [2a03:2880:31ff:2::face:b00c])
        by smtp.gmail.com with ESMTPSA id op5-20020a170906bce500b0098de7d28c34sm5169672ejb.193.2023.09.11.03.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 03:34:40 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, pabeni@redhat.com
Subject: [PATCH v5 6/8] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Date:   Mon, 11 Sep 2023 03:34:05 -0700
Message-Id: <20230911103407.1393149-7-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230911103407.1393149-1-leitao@debian.org>
References: <20230911103407.1393149-1-leitao@debian.org>
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
level is SOL_SOCKET. This is similar to the getsockopt(2) system
call, and both parameters are pointers to userspace.

Important to say that userspace needs to keep the pointer alive until
the CQE is completed.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  9 +++++++++
 io_uring/uring_cmd.c          | 15 +++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8e61f8b7c2ce..1c789ee6462d 100644
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
@@ -89,6 +93,10 @@ struct io_uring_sqe {
 			__u64	addr3;
 			__u64	__pad2[1];
 		};
+		struct {
+			__u64	optval;
+			__u64	optlen;
+		};
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
@@ -734,6 +742,7 @@ struct io_uring_recvmsg_out {
 enum {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
+	SOCKET_URING_OP_GETSOCKOPT,
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index a7d6a7d112b7..2806330a021f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -167,6 +167,19 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+static inline int io_uring_cmd_getsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd,
+					  unsigned int issue_flags)
+{
+	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	int __user *optlen = u64_to_user_ptr(READ_ONCE(cmd->sqe->optlen));
+	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
+	int optname = READ_ONCE(cmd->sqe->optname);
+	int level = READ_ONCE(cmd->sqe->level);
+
+	return do_sock_getsockopt(sock, compat, level, optname, optval, optlen);
+}
+
 #if defined(CONFIG_NET)
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
@@ -189,6 +202,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
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

