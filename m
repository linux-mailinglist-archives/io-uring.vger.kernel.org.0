Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0D22791B83
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 18:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353336AbjIDQ0I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Sep 2023 12:26:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240655AbjIDQ0I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Sep 2023 12:26:08 -0400
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com [209.85.208.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69B91717;
        Mon,  4 Sep 2023 09:25:44 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id 38308e7fff4ca-2bcc4347d2dso23589711fa.0;
        Mon, 04 Sep 2023 09:25:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693844743; x=1694449543;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AGn7P2kniOoJAPFpEjpeFP2KmuJaT92ea2flbYwh/Ag=;
        b=VU/Z4xW4SDgj4/dTSEAYDzGbYwuQW0RC45f+5O7ePjeEJiLxWYIEolMgJe+gEHc6My
         XIpRuwmPwurS9v3aBLp29eJw1iD1Y1h3uqyzor+bEzxXdvSWR08CuJdfZ6fSYPTtflZ1
         wpYrfQWlHZDh6GXgk7CEepeL5y2wBVgI0+O5a7wx3fKz9J6bkp791W/MKFkqgza6E0eP
         OXUQjbW0WA0Tc3LoMoWOUuypBhxPhmX0KA8GfQiBVuYAx7/ux2Xadc6uWXrsML1TZCaY
         FND3IURr9XObGE2ARzp+Zj6SMIbyc3GT1hfRDdky97yoEkdQFnB4DZgmL08OBe/lJL2H
         s3Zg==
X-Gm-Message-State: AOJu0YxkxVyDKxK0SzJD/LLIdskcn8IN1gsuEOsE5qhd2PmGgfXy13+A
        KXn26k0o9oaitYKrHhKqSRk=
X-Google-Smtp-Source: AGHT+IEOWdzK7pcauKxr2iSsZpnNIHeyYsYsBZ6mgLjFdwd6CFHkNerSAdwxp2WKFlDa7owY8oEGpg==
X-Received: by 2002:a2e:9c97:0:b0:2bc:b75e:b8b with SMTP id x23-20020a2e9c97000000b002bcb75e0b8bmr7617249lji.38.1693844742846;
        Mon, 04 Sep 2023 09:25:42 -0700 (PDT)
Received: from localhost (fwdproxy-cln-022.fbsv.net. [2a03:2880:31ff:16::face:b00c])
        by smtp.gmail.com with ESMTPSA id gj17-20020a170906e11100b0098921e1b064sm6383648ejb.181.2023.09.04.09.25.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 09:25:42 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH v4 09/10] io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
Date:   Mon,  4 Sep 2023 09:25:02 -0700
Message-Id: <20230904162504.1356068-10-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230904162504.1356068-1-leitao@debian.org>
References: <20230904162504.1356068-1-leitao@debian.org>
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
 io_uring/uring_cmd.c          | 17 +++++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 29efa02a4dcb..3b443da353ba 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -741,6 +741,7 @@ enum {
 	SOCKET_URING_OP_SIOCINQ		= 0,
 	SOCKET_URING_OP_SIOCOUTQ,
 	SOCKET_URING_OP_GETSOCKOPT,
+	SOCKET_URING_OP_SETSOCKOPT,
 };
 
 #ifdef __cplusplus
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index c373e05ba9ce..bec4730fb208 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -193,6 +193,21 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
 	return optlen;
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
+	return do_sock_setsockopt(sock, compat, level, optname, optval_s,
+				  optlen);
+}
+
 #if defined(CONFIG_NET)
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
@@ -217,6 +232,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
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

