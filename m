Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0BC175F9D2
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 16:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbjGXOYJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 10:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231576AbjGXOYH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 10:24:07 -0400
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279FD10D1;
        Mon, 24 Jul 2023 07:23:56 -0700 (PDT)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-51bece5d935so6773698a12.1;
        Mon, 24 Jul 2023 07:23:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690208634; x=1690813434;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bOToxxMOJSR6oGgH66HubRQXkmn+GAGTh6HLEh6tf7M=;
        b=JwzrUIHZgzQhbJQEqerBA6RBVWqLwTsiXqA7ryzqbd/jT+exopK+AgMcHLcKIuCs32
         T+kURX6Il+6TpAPAS4ngbQklGBsLXi6svTBye3ETBDFEGWKIs0dZT0eNBOvBUVU83vmf
         dj8p6zEAOOAgFuXXNoYQCjjxu8K7dJCbyJoohK+Fv9q+q5u335uVm4i3fWnOaMVG7rqs
         oKSU3ZIooKjWRxH5pT77ZOAi3tFCa1dL37BqTQLMQBv7NqbpiYZqpXSzKQYoC2fPeIdH
         Y+GUibY5sEljLUI+nzhHlsDoY+Ko9WDp8b+BUyTchOcHBzR3JzgesN/neyaBaqkSN5x4
         VuJw==
X-Gm-Message-State: ABy/qLYtSGoOvuWpmBLPhbogrKrfXT8GZVzFox4XnjWazkhRCRzb580X
        2OYF82C41HUj8g//97H6C1eZ5HV1oIk=
X-Google-Smtp-Source: APBJJlGmuBkY1OlQSkN73mY2qEXbwBF2GMxcxHACK1Y5JcR2eD1f735oMrmidg/L8Rnh0ydjnbrcAg==
X-Received: by 2002:aa7:d315:0:b0:522:38f9:e653 with SMTP id p21-20020aa7d315000000b0052238f9e653mr1183931edq.30.1690208634391;
        Mon, 24 Jul 2023 07:23:54 -0700 (PDT)
Received: from localhost (fwdproxy-cln-117.fbsv.net. [2a03:2880:31ff:75::face:b00c])
        by smtp.gmail.com with ESMTPSA id f9-20020a056402150900b005222005e361sm2928296edw.45.2023.07.24.07.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 07:23:54 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org, leit@meta.com
Subject: [PATCH 3/4] io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
Date:   Mon, 24 Jul 2023 07:22:36 -0700
Message-Id: <20230724142237.358769-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230724142237.358769-1-leitao@debian.org>
References: <20230724142237.358769-1-leitao@debian.org>
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

Add initial support for SOCKET_URING_OP_SETSOCKOPT. This new command is
similar to setsockopt. This initial implementation just cares about
SOL_SOCKET level for now. The next patch implements the generic case.

Function io_uring_cmd_setsockopt() is inspired by the function
__sys_setsockopt().

"optval" is currently copied to kernel space in io_uring_cmd_setsockopt(),
so, the setsockopt() protocol callbacks operate on kernel space memory
after io_uring handlers.

Important to say that userspace needs to keep the pointer's memory alive
until the operation is completed.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/uring_cmd.c          | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

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
index 16c857cbf3b0..d63a3b0f93a3 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -207,6 +207,39 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
 		return optlen;
 }
 
+static inline int io_uring_cmd_setsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd)
+{
+	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	int optname = READ_ONCE(cmd->sqe->optname);
+	int optlen = READ_ONCE(cmd->sqe->optlen);
+	int level = READ_ONCE(cmd->sqe->level);
+	void *koptval;
+	int err;
+
+	err = security_socket_setsockopt(sock, level, optname);
+	if (err)
+		return err;
+
+	koptval = kmalloc(optlen, GFP_KERNEL);
+	if (!koptval)
+		return -ENOMEM;
+
+	err = copy_from_user(koptval, optval, optlen);
+	if (err)
+		goto fail;
+
+	err = -EOPNOTSUPP;
+	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock)) {
+		err = sock_setsockopt(sock, level, optname,
+				      KERNEL_SOCKPTR(koptval), optlen);
+	}
+
+fail:
+	kfree(koptval);
+	return err;
+}
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -230,6 +263,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		return arg;
 	case SOCKET_URING_OP_GETSOCKOPT:
 		return io_uring_cmd_getsockopt(sock, cmd);
+	case SOCKET_URING_OP_SETSOCKOPT:
+		return io_uring_cmd_setsockopt(sock, cmd);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.34.1

