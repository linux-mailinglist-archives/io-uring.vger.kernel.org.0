Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B7B79ECD7
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 17:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjIMP2q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 11:28:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbjIMP2j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 11:28:39 -0400
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15F4B1BF2;
        Wed, 13 Sep 2023 08:28:35 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-52f31fb26e2so5405107a12.3;
        Wed, 13 Sep 2023 08:28:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694618913; x=1695223713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lDiXjrFRlF6VHQWvFjoZXtrdxjTNkGukVcEtNKPtPXI=;
        b=Sh3e4sFKi8aoMbuK3oScZ0WdKdjGR+lB9KaHR3tb17jej2kpnaMCNIJ2kbztNYGqzw
         fI2JXxV6k/Bs77yN1D/jXD/r3cpbjsejG3cpe3vhINoxUFqUYK/WI31nhXWn7/xt1FCw
         m3y1pV21Z8bpzrhvKlmAHX8vmyn7ZCeDS8nz9jCyKh+us2EA3l4HAlHvLVt1xFap/0qI
         NKn6BzGLsk2I3UJEc+zi0mfZOlLi9HevJM7gy4NCsVy2Gh3RlHHVUhzwgmg/Y0bhB6Er
         LM7E4uJXqlUQxF0moNLFd6j6doNMnTD/pTc1ONYrT/+uHU/ToFTYFGrOdUs6GsZu8XMC
         vj+w==
X-Gm-Message-State: AOJu0YxwbNAaFJmFJg7CzTwHYmNG6JZw8ZXQQ9TiEx4YgRtoTiGYu31Z
        7cBXC43QgGipnPvDM2YWQEk=
X-Google-Smtp-Source: AGHT+IFJQ2QuwiDxVrXozbquE3kCcqCx0DzLR5CvSuQnKYXRWIr8XPDK0iLZz5VQw3qTo/IS6L25YQ==
X-Received: by 2002:a05:6402:1b04:b0:523:d1e0:7079 with SMTP id by4-20020a0564021b0400b00523d1e07079mr2423946edb.21.1694618913506;
        Wed, 13 Sep 2023 08:28:33 -0700 (PDT)
Received: from localhost (fwdproxy-cln-009.fbsv.net. [2a03:2880:31ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id c2-20020aa7c982000000b0052e2aa1a0fcsm7495234edt.77.2023.09.13.08.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 08:28:33 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v6 6/8] io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT
Date:   Wed, 13 Sep 2023 08:27:42 -0700
Message-Id: <20230913152744.2333228-7-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230913152744.2333228-1-leitao@debian.org>
References: <20230913152744.2333228-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index 5753c3611b74..a2a6ac0c503b 100644
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

