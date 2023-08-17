Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8058877F9DA
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 16:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352416AbjHQO5B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Aug 2023 10:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352435AbjHQO4g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Aug 2023 10:56:36 -0400
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C332F30DE;
        Thu, 17 Aug 2023 07:56:13 -0700 (PDT)
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-9923833737eso1035599966b.3;
        Thu, 17 Aug 2023 07:56:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692284172; x=1692888972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=07ENq1IVrS75f2tHkaWZQfDYx4uyK/eennegrV/Q9BY=;
        b=eUElgFImSn2iZBFv9ALM7bP5yoUrNa6bB88hZ0GlXZjbuq51DRTXL2D1m+yhpd1vzI
         8NDjwECRXcnxDQtYnUKd9BLQtzNPjWsQ2kI6W7OG7hwB+P75vwICN3s4bAKqFp3VHxM4
         cVg4T/cibCGHCzdiq9x6nSO6aMEfpiE4ZiZlys/BtQkb9pYolebI5FSvqA9HL5C1UFeZ
         9BENy2pAqp/rfP3JQCuJJF64nhrO+tsu7xUFbcxFxPJA69M7irvm0JoIrTBWnLE7KDZJ
         QIaTsDSkfkvgC9mSSc1vnI7J2z5GYo8YtEk76+rpkwsPP+iA2qUgY5dqyoj4oy3XOo45
         oGoQ==
X-Gm-Message-State: AOJu0YzPnqecP8IqrS+HeiSPsXAD4E8Gx+kWxv5xCuY+WCJBX1IGhDrf
        DsOcs0vZNBqG9nqDAFQYd4o=
X-Google-Smtp-Source: AGHT+IGHMFukyZW7NjVpxCzf5qHvR+CXI0/jTXaxVfGokF53UyD0G+B7x3n49Y4x/Di3eesbN33oYA==
X-Received: by 2002:a17:906:d18c:b0:98d:4000:1bf9 with SMTP id c12-20020a170906d18c00b0098d40001bf9mr4253849ejz.65.1692284171876;
        Thu, 17 Aug 2023 07:56:11 -0700 (PDT)
Received: from localhost (fwdproxy-cln-000.fbsv.net. [2a03:2880:31ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id qx27-20020a170906fcdb00b0098e0a937a6asm10222970ejb.69.2023.08.17.07.56.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 07:56:11 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org, krisman@suse.de
Subject: [PATCH v3 3/9] net/socket: Break down __sys_setsockopt
Date:   Thu, 17 Aug 2023 07:55:48 -0700
Message-Id: <20230817145554.892543-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230817145554.892543-1-leitao@debian.org>
References: <20230817145554.892543-1-leitao@debian.org>
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

Split __sys_setsockopt() into two functions by removing the core
logic into a sub-function (do_sock_setsockopt()). This will avoid
code duplication when doing the same operation in other callers, for
instance.

do_sock_setsockopt() will be called by io_uring setsockopt() command
operation in the following patch.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/net/sock.h |  2 ++
 net/socket.c       | 39 +++++++++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 2eb916d1ff64..2a0324275347 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1853,6 +1853,8 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, unsigned int optlen);
 int sock_setsockopt(struct socket *sock, int level, int op,
 		    sockptr_t optval, unsigned int optlen);
+int do_sock_setsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, int optlen);
 
 int sk_getsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, sockptr_t optlen);
diff --git a/net/socket.c b/net/socket.c
index 2c3ef8862b4f..b5e4398a6b4d 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2221,30 +2221,20 @@ static bool sock_use_custom_sol_socket(const struct socket *sock)
 	return test_bit(SOCK_CUSTOM_SOCKOPT, &sock->flags);
 }
 
-/*
- *	Set a socket option. Because we don't know the option lengths we have
- *	to pass the user mode parameter for the protocols to sort out.
- */
-int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
-		int optlen)
+int do_sock_setsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, int optlen)
 {
-	sockptr_t optval = USER_SOCKPTR(user_optval);
 	char *kernel_optval = NULL;
-	int err, fput_needed;
-	struct socket *sock;
+	int err;
 
 	if (optlen < 0)
 		return -EINVAL;
 
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		return err;
-
 	err = security_socket_setsockopt(sock, level, optname);
 	if (err)
 		goto out_put;
 
-	if (!in_compat_syscall())
+	if (!compat)
 		err = BPF_CGROUP_RUN_PROG_SETSOCKOPT(sock->sk, &level, &optname,
 						     optval, &optlen,
 						     &kernel_optval);
@@ -2266,6 +2256,27 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
 					    optlen);
 	kfree(kernel_optval);
 out_put:
+	return err;
+}
+EXPORT_SYMBOL(do_sock_setsockopt);
+
+/* Set a socket option. Because we don't know the option lengths we have
+ * to pass the user mode parameter for the protocols to sort out.
+ */
+int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
+		     int optlen)
+{
+	sockptr_t optval = USER_SOCKPTR(user_optval);
+	bool compat = in_compat_syscall();
+	int err, fput_needed;
+	struct socket *sock;
+
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	if (!sock)
+		return err;
+
+	err = do_sock_setsockopt(sock, compat, level, optname, optval, optlen);
+
 	fput_light(sock->file, fput_needed);
 	return err;
 }
-- 
2.34.1

