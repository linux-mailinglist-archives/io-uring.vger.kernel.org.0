Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 723D57748FB
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 21:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbjHHTqU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 15:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236545AbjHHTp6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 15:45:58 -0400
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B78116AFF;
        Tue,  8 Aug 2023 09:49:33 -0700 (PDT)
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2b9d3dacb33so95357021fa.1;
        Tue, 08 Aug 2023 09:49:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691513371; x=1692118171;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o+9mxu8b+EhzS+5yoGnjlhzry4jkjQ5Q19ANuPNesrY=;
        b=l+J8ftwOUHMt2R84TGYZQ0G1AyQ5zfkFhgjdQq3p9CwjDoGfVT0ysWkD4m4cTgcsrz
         VnSiC+kxrEl2uMHN/bL/TWpw3x/mq6elkVx75+/P3kKsTIglIOftRjuzOuvoaACqXp5r
         ymAK9h6w30XQZ1yTTXBX14Rsgdaq0/Tnz3ManZ2HMz/vrr9bX9l3o4rk6dp7jIHxFxK0
         81K3x0pf3DSIIlzuWGkGhAedjyFcksBQFrZWjqx6gZIEINC08DeLtTyLKyvCNAy6YSiQ
         Wy5ry/WBQUcvIamvkyq2r9r86dOB12CigvoxmhcZt1udmO7m48wgpDKTtKoZb+qTtnL/
         OQ2w==
X-Gm-Message-State: AOJu0YzXUznEAgznzLGg5rUubd3OEPwCcoK9CwyNaiwAWf5suWi4nRWW
        836OXhYYY1oNvNd2OR8qzhldv0OOJBs=
X-Google-Smtp-Source: AGHT+IFaiSD6la9EEN/hiA8ab/8s4dP7Ut5NjsQn3lAyBLxiI8Mq1SO2WnI7EtR5m+sRlgD67JjEaA==
X-Received: by 2002:aa7:dc07:0:b0:522:37f1:5fd0 with SMTP id b7-20020aa7dc07000000b0052237f15fd0mr11327506edu.5.1691502066712;
        Tue, 08 Aug 2023 06:41:06 -0700 (PDT)
Received: from localhost (fwdproxy-cln-018.fbsv.net. [2a03:2880:31ff:12::face:b00c])
        by smtp.gmail.com with ESMTPSA id p8-20020a05640210c800b005231e1780aasm6116955edu.91.2023.08.08.06.41.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 06:41:06 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com
Subject: [PATCH v2 3/8] io_uring/cmd: Introduce SOCKET_URING_OP_SETSOCKOPT
Date:   Tue,  8 Aug 2023 06:40:43 -0700
Message-Id: <20230808134049.1407498-4-leitao@debian.org>
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

Add initial support for SOCKET_URING_OP_SETSOCKOPT. This new command is
similar to setsockopt. This initial implementation just cares about
SOL_SOCKET level for now. The next patch implements the generic case.

Function io_uring_cmd_setsockopt() is inspired by the function
__sys_setsockopt().

Important to say that userspace needs to keep the pointer's memory alive
until the operation is completed.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/uring_cmd.c          | 23 +++++++++++++++++++++++
 2 files changed, 24 insertions(+)

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
index 582931879482..5404b788ca14 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -192,6 +192,27 @@ static inline int io_uring_cmd_getsockopt(struct socket *sock,
 	return -EOPNOTSUPP;
 }
 
+static inline int io_uring_cmd_setsockopt(struct socket *sock,
+					  struct io_uring_cmd *cmd)
+{
+	void __user *optval = u64_to_user_ptr(READ_ONCE(cmd->sqe->optval));
+	int optname = READ_ONCE(cmd->sqe->optname);
+	int optlen = READ_ONCE(cmd->sqe->optlen);
+	int level = READ_ONCE(cmd->sqe->level);
+	int err;
+
+	err = security_socket_setsockopt(sock, level, optname);
+	if (err)
+		return err;
+
+	err = -EOPNOTSUPP;
+	if (level == SOL_SOCKET && !sock_use_custom_sol_socket(sock))
+		err = sock_setsockopt(sock, level, optname,
+				      USER_SOCKPTR(optval), optlen);
+
+	return err;
+}
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	struct socket *sock = cmd->file->private_data;
@@ -215,6 +236,8 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
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

