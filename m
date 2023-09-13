Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F5979ECD2
	for <lists+io-uring@lfdr.de>; Wed, 13 Sep 2023 17:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjIMP2b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Sep 2023 11:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjIMP20 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Sep 2023 11:28:26 -0400
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B811BC3;
        Wed, 13 Sep 2023 08:28:22 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-502e0b7875dso925656e87.0;
        Wed, 13 Sep 2023 08:28:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694618900; x=1695223700;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HNDakB63GeZKBPdnx2EtHPN64oGZn+t0qvDI93lexvQ=;
        b=fvCHy6ZcoUIYrtFltO0XIziKj5/zzrXcoANIOXCNMIGvhE7dW4y/2RfYPpDblDZlIb
         hBTxL++nfoMUvP8wKbluFXmMSzDb+7+iZIEaKTrXbhlETCFMIQ7WwGRoB8YJtIq+PCq+
         n+mP0F7cLlfiqwQ/xnMatPavlzjUiFZ0nF4nRwWDNt4ucOS6ukt/OEI/qTFlAocX0ZSP
         T65d74W3ZvXaf8sH8ngpAmWEoxiuXPPZ7Av5lLDVbNTxSfJ4D7lsWgr/QStFVlrJAZWh
         So65SFqEpkqeNTLn1wHgTv0T1mqSK8FVhe/+droqTT5lt2pcw67D+SMlHZSjZjGrB35G
         H5xw==
X-Gm-Message-State: AOJu0YyD4hrFwSBwkpebL58O4cV7D9N1lzD9A5kbo4eVTnU+xLVf3CMi
        +T5eCPdAx5+vkGGBjwa5b0E=
X-Google-Smtp-Source: AGHT+IHTNXupugjcqdM561DSjH0sQbE2ecX6oqqyTB94YrWwm5n/1rgUsWrwfNEHN7R4dgkuUMt4sg==
X-Received: by 2002:ac2:53a9:0:b0:500:b64a:ad15 with SMTP id j9-20020ac253a9000000b00500b64aad15mr2104579lfh.52.1694618900057;
        Wed, 13 Sep 2023 08:28:20 -0700 (PDT)
Received: from localhost (fwdproxy-cln-016.fbsv.net. [2a03:2880:31ff:10::face:b00c])
        by smtp.gmail.com with ESMTPSA id n13-20020a170906b30d00b0099cc36c4681sm8596578ejz.157.2023.09.13.08.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 08:28:19 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v6 2/8] net/socket: Break down __sys_getsockopt
Date:   Wed, 13 Sep 2023 08:27:38 -0700
Message-Id: <20230913152744.2333228-3-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230913152744.2333228-1-leitao@debian.org>
References: <20230913152744.2333228-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split __sys_getsockopt() into two functions by removing the core
logic into a sub-function (do_sock_getsockopt()). This will avoid
code duplication when executing the same operation in other callers, for
instance.

do_sock_getsockopt() will be called by io_uring getsockopt() command
operation in the following patch.

Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/net/sock.h |  3 +++
 net/socket.c       | 48 +++++++++++++++++++++++++++++-----------------
 2 files changed, 33 insertions(+), 18 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index aa8fb54ad0af..fbd568a43d28 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1863,6 +1863,9 @@ int sock_setsockopt(struct socket *sock, int level, int op,
 		    sockptr_t optval, unsigned int optlen);
 int do_sock_setsockopt(struct socket *sock, bool compat, int level,
 		       int optname, char __user *user_optval, int optlen);
+int do_sock_getsockopt(struct socket *sock, bool compat, int level,
+		       int optname, char __user *user_optval,
+		       int __user *user_optlen);
 
 int sk_getsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, sockptr_t optlen);
diff --git a/net/socket.c b/net/socket.c
index 360332e098d4..fb943602186e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2333,28 +2333,17 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 							 int optname));
 
-/*
- *	Get a socket option. Because we don't know the option lengths we have
- *	to pass a user mode parameter for the protocols to sort out.
- */
-int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
-		int __user *optlen)
+int do_sock_getsockopt(struct socket *sock, bool compat, int level,
+		       int optname, char __user *optval,
+		       int __user *optlen)
 {
 	int max_optlen __maybe_unused;
 	const struct proto_ops *ops;
-	int err, fput_needed;
-	struct socket *sock;
-
-	sock = sockfd_lookup_light(fd, &err, &fput_needed);
-	if (!sock)
-		return err;
+	int err;
 
 	err = security_socket_getsockopt(sock, level, optname);
 	if (err)
-		goto out_put;
-
-	if (!in_compat_syscall())
-		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+		return err;
 
 	ops = READ_ONCE(sock->ops);
 	if (level == SOL_SOCKET)
@@ -2365,11 +2354,34 @@ int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 		err = ops->getsockopt(sock, level, optname, optval,
 					    optlen);
 
-	if (!in_compat_syscall())
+	if (!compat) {
+		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
 		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
 						     optval, optlen, max_optlen,
 						     err);
-out_put:
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(do_sock_getsockopt);
+
+/* Get a socket option. Because we don't know the option lengths we have
+ * to pass a user mode parameter for the protocols to sort out.
+ */
+int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
+		     int __user *optlen)
+{
+	bool compat = in_compat_syscall();
+	int err, fput_needed;
+	struct socket *sock;
+
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	if (!sock)
+		return err;
+
+	err = do_sock_getsockopt(sock, compat, level, optname, optval,
+				 optlen);
+
 	fput_light(sock->file, fput_needed);
 	return err;
 }
-- 
2.34.1

