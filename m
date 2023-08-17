Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2CE77F9E8
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 16:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352449AbjHQO5E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Aug 2023 10:57:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352470AbjHQO4p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Aug 2023 10:56:45 -0400
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D89E2711;
        Thu, 17 Aug 2023 07:56:27 -0700 (PDT)
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4ff9bbc83a5so1172221e87.1;
        Thu, 17 Aug 2023 07:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692284185; x=1692888985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1zsiVk5fOq/xRYSBgy8waxMhVPUrHepcvkTYmhSMbvQ=;
        b=HxHlsb/k1TJ1T2giGWOMMKVLGCrvhkBFVagfZOq5mMo3XYgpzma5On/iDIqgO9VoaJ
         kHTcFPP1Lyjz6x6HGqZTo8FBXqlHu43pKClyOmmxSrNEMqWUn7wCbGbbAjIE2ms35+sy
         KCwlkemrgPvyz3AVqunVKhWr3LFdTLcQdwLIwykA6MzlSP1tvFvtrN3cT9MEHkcaDutb
         91TKxzW4ZboeptQ+Y1lhjiaGggUUioEnsdqa+vFyA3HVZ0Uo7W6qe5QJy8H+NcoPQlo2
         Y+4UgcmTx3ETbWF+GZAkFE5C3O6vsFDdzZ7AWAAKASadwrrCIaVTeKBrqO2uDoMdJXC0
         DeEQ==
X-Gm-Message-State: AOJu0YwHi5vug7dvfQjjJpVeyrYJBSaEJVAsMCLS/MjHzAXsRsB90OAN
        +2Qr/6+/VgFrKYqED6xuHx2QWuZJuzc=
X-Google-Smtp-Source: AGHT+IHXQDkzLphQZrs8p1+383d4Zsu9MU09SBJmIQm0eNZXILoDP/CuV7WCev740FE2T6uKjVLeoA==
X-Received: by 2002:ac2:5938:0:b0:4fe:c4e:709f with SMTP id v24-20020ac25938000000b004fe0c4e709fmr3647259lfi.20.1692284185184;
        Thu, 17 Aug 2023 07:56:25 -0700 (PDT)
Received: from localhost (fwdproxy-cln-006.fbsv.net. [2a03:2880:31ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id ck9-20020a170906c44900b00993664a9987sm10251897ejb.103.2023.08.17.07.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 07:56:24 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, krisman@suse.de
Subject: [PATCH v3 7/9] io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
Date:   Thu, 17 Aug 2023 07:55:52 -0700
Message-Id: <20230817145554.892543-8-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230817145554.892543-1-leitao@debian.org>
References: <20230817145554.892543-1-leitao@debian.org>
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

Add initial support for SOCKET_URING_OP_SETSOCKOPT. This new command is
similar to setsockopt. This implementation leverages the function
do_sock_setsockopt(), which is shared with the setsockopt() system call
path.

Important to say that userspace needs to keep the pointer's memory alive
until the operation is completed. I.e, the memory could not be
deallocated before the CQE is returned to userspace.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/uring_cmd.c          | 16 ++++++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8152151080db..3fe82df06abf 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -736,6 +736,7 @@ enum {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
+	SOCKET_URING_OP_SETSOCKOPT,
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 7b768f1bf4df..a567dd32df00 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -197,6 +197,20 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
 	return -EOPNOTSUPP;
 }
 
+static inline int io_uring_cmd_setsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd,
+					  unsigned int issue_flags)
+{
+	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	bool compat = !!(issue_flags & IO_URING_F_COMPAT);
+	int optname = READ_ONCE(cmd->sqe->optname);
+	sockptr_t optval_s = USER_SOCKPTR(optval);
+	int optlen = READ_ONCE(cmd->sqe->optlen);
+	int level = READ_ONCE(cmd->sqe->level);
+
+	return do_sock_setsockopt(sock, compat, level, optname, optval_s, optlen);
+}
+
 #if defined(CONFIG_NET)
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
@@ -221,6 +235,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		return arg;
 	case SOCKET_URING_OP_GETSOCKOPT:
 		return io_uring_cmd_getsockopt(sock, cmd, issue_flags);
+	case SOCKET_URING_OP_SETSOCKOPT:
+		return io_uring_cmd_setsockopt(sock, cmd, issue_flags);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

