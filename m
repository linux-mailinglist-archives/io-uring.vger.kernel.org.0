Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B04657CAABE
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 16:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbjJPOBr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 10:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233530AbjJPOBp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 10:01:45 -0400
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8577F9C;
        Mon, 16 Oct 2023 07:01:43 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-9adb9fa7200so939372966b.0;
        Mon, 16 Oct 2023 07:01:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464902; x=1698069702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T6jABNP5fatbdRkQ6crb5lOkIMwJ1jpThfXk6besz34=;
        b=svSPev20qqFYc6cxgBdXbsM146GrIMKnDFLGTIIXScZ378s8NiVXMknTvoxi3qMzv7
         gzBrpBq6pdwALNBc1sLUhzY7WZfiTissGFOKnvYiv6+U/4F+PVdz5Wae4Q85rg4ebPCP
         snvt16e5tfyRO07ccug2rTnq0jtoZ6ezcQGhYQwu1Rv/fhqTdQROEffE4x2ds/lDDa99
         NtHx58FR2D+rJN/sW8pGMJIGnXbvWw1vw9a9j4epT9Q0eoEiU2Ree4v50lRrfFz5JDVh
         2CnxyNxjGqI5Yq1JJSN+2ePBESMIk1aZplLxwrbqcmGh4GIdSSc5/tSNRRaL+cAN8g7m
         Q90w==
X-Gm-Message-State: AOJu0YzBKYU1+TEBeknCXZURN94IGLbiwXAvnokUw8V+GJ8i44wUrPLK
        v6orHw2QQcwKfdw8oRQ6RnM=
X-Google-Smtp-Source: AGHT+IHUu/g9ym5TxgIGSDFjs7IALdnvoQvEUE8XDlq1Xf3v/iRN5OBKz0QrdD/SLdTvKjZJbWnARQ==
X-Received: by 2002:a17:906:3fd1:b0:9bf:952d:a8ad with SMTP id k17-20020a1709063fd100b009bf952da8admr3081678ejj.5.1697464901665;
        Mon, 16 Oct 2023 07:01:41 -0700 (PDT)
Received: from localhost (fwdproxy-cln-013.fbsv.net. [2a03:2880:31ff:d::face:b00c])
        by smtp.gmail.com with ESMTPSA id gw11-20020a170906f14b00b0098669cc16b2sm4055503ejb.83.2023.10.16.07.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 07:01:41 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH v7 04/11] net/socket: Break down __sys_getsockopt
Date:   Mon, 16 Oct 2023 06:47:42 -0700
Message-Id: <20231016134750.1381153-5-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231016134750.1381153-1-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split __sys_getsockopt() into two functions by removing the core
logic into a sub-function (do_sock_getsockopt()). This will avoid
code duplication when doing the same operation in other callers, for
instance.

do_sock_getsockopt() will be called by io_uring getsockopt() command
operation in the following patch.

The same was done for the setsockopt pair.

Suggested-by: Martin KaFai Lau <martin.lau@linux.dev>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/bpf-cgroup.h |  2 +-
 include/net/sock.h         |  4 +--
 net/core/sock.c            |  8 -----
 net/socket.c               | 63 ++++++++++++++++++++++++--------------
 4 files changed, 43 insertions(+), 34 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2912dce9144e..a789266feac3 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -393,7 +393,7 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
 ({									       \
 	int __ret = 0;							       \
 	if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT))			       \
-		get_user(__ret, optlen);				       \
+		copy_from_sockptr(&__ret, optlen, sizeof(int));		       \
 	__ret;								       \
 })
 
diff --git a/include/net/sock.h b/include/net/sock.h
index 00103e3143c4..1d6931caf0c3 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1866,11 +1866,11 @@ int sock_setsockopt(struct socket *sock, int level, int op,
 		    sockptr_t optval, unsigned int optlen);
 int do_sock_setsockopt(struct socket *sock, bool compat, int level,
 		       int optname, sockptr_t optval, int optlen);
+int do_sock_getsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, sockptr_t optlen);
 
 int sk_getsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, sockptr_t optlen);
-int sock_getsockopt(struct socket *sock, int level, int op,
-		    char __user *optval, int __user *optlen);
 int sock_gettstamp(struct socket *sock, void __user *userstamp,
 		   bool timeval, bool time32);
 struct sk_buff *sock_alloc_send_pskb(struct sock *sk, unsigned long header_len,
diff --git a/net/core/sock.c b/net/core/sock.c
index 290165954379..d4cb8d6e75b7 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2003,14 +2003,6 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
 	return 0;
 }
 
-int sock_getsockopt(struct socket *sock, int level, int optname,
-		    char __user *optval, int __user *optlen)
-{
-	return sk_getsockopt(sock->sk, level, optname,
-			     USER_SOCKPTR(optval),
-			     USER_SOCKPTR(optlen));
-}
-
 /*
  * Initialize an sk_lock.
  *
diff --git a/net/socket.c b/net/socket.c
index 0087f8c071e7..f4c156a1987e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2350,6 +2350,42 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
 INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 							 int optname));
 
+int do_sock_getsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, sockptr_t optlen)
+{
+	int max_optlen __maybe_unused;
+	const struct proto_ops *ops;
+	int err;
+
+	err = security_socket_getsockopt(sock, level, optname);
+	if (err)
+		return err;
+
+	ops = READ_ONCE(sock->ops);
+	if (level == SOL_SOCKET) {
+		err = sk_getsockopt(sock->sk, level, optname, optval, optlen);
+	} else if (unlikely(!ops->getsockopt)) {
+		err = -EOPNOTSUPP;
+	} else {
+		if (WARN_ONCE(optval.is_kernel || optlen.is_kernel,
+			      "Invalid argument type"))
+			return -EOPNOTSUPP;
+
+		err = ops->getsockopt(sock, level, optname, optval.user,
+				      optlen.user);
+	}
+
+	if (!compat) {
+		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
+						     optval, optlen, max_optlen,
+						     err);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL(do_sock_getsockopt);
+
 /*
  *	Get a socket option. Because we don't know the option lengths we have
  *	to pass a user mode parameter for the protocols to sort out.
@@ -2357,37 +2393,18 @@ INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 		int __user *optlen)
 {
-	int max_optlen __maybe_unused;
-	const struct proto_ops *ops;
 	int err, fput_needed;
 	struct socket *sock;
+	bool compat;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		return err;
 
-	err = security_socket_getsockopt(sock, level, optname);
-	if (err)
-		goto out_put;
-
-	if (!in_compat_syscall())
-		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
+	compat = in_compat_syscall();
+	err = do_sock_getsockopt(sock, compat, level, optname,
+				 USER_SOCKPTR(optval), USER_SOCKPTR(optlen));
 
-	ops = READ_ONCE(sock->ops);
-	if (level == SOL_SOCKET)
-		err = sock_getsockopt(sock, level, optname, optval, optlen);
-	else if (unlikely(!ops->getsockopt))
-		err = -EOPNOTSUPP;
-	else
-		err = ops->getsockopt(sock, level, optname, optval,
-					    optlen);
-
-	if (!in_compat_syscall())
-		err = BPF_CGROUP_RUN_PROG_GETSOCKOPT(sock->sk, level, optname,
-						     USER_SOCKPTR(optval),
-						     USER_SOCKPTR(optlen),
-						     max_optlen, err);
-out_put:
 	fput_light(sock->file, fput_needed);
 	return err;
 }
-- 
2.34.1

