Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73417791B73
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 18:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245100AbjIDQZd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Sep 2023 12:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237311AbjIDQZd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Sep 2023 12:25:33 -0400
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B659D;
        Mon,  4 Sep 2023 09:25:29 -0700 (PDT)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-9a1de3417acso542957066b.0;
        Mon, 04 Sep 2023 09:25:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693844728; x=1694449528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=82OoBXgBAbznwkXu05U9ZI1aovNZn8WR0zg3FquGFJc=;
        b=k8Sopg0P1FsXkxle1F3S6sAVObIuQSuBOLU41iXnxjBOSL5LyIoErzP6pYN5NO83dm
         Hjs/sCIdAtC1sI3LpgYqMiD9mNIp31cWadl5S1MFOoLt+Us994bVsk+a+fnT1pdEIXef
         WH0nzaIwbfzhpUf3MQ7dq+YfgASgln/33VsrFDtBv6kOuzBBvh1nXCIGGBrgfP68AFC5
         HoE5lmoRtuth4XL9vzmXhA1VW6+5pgm95gPR1dqyUnYYScks/insI2beu+G3XBvyKTRZ
         z3b93BZ1aGpGv079T+oszboV78W5Hc2PQTnPtv4aOaRMVIpThfkO54m7xxNUTu3xEUtQ
         fMhw==
X-Gm-Message-State: AOJu0YzgMJmRo/VsTQoXP1Y+0FbW2L1aSfGKhCDCUu3dOVcaMP6Ax/8p
        qmGHIjsvREh0TIoqL3yvDoI=
X-Google-Smtp-Source: AGHT+IF4peA8bbZRtqCcH5BZyiuX1dDl1ated1EUKd9FT2qyulTi0W5D90fIRaNHdoPDFpMjb44shg==
X-Received: by 2002:a17:907:1c86:b0:9a5:b2d8:e925 with SMTP id nb6-20020a1709071c8600b009a5b2d8e925mr15418113ejc.33.1693844728005;
        Mon, 04 Sep 2023 09:25:28 -0700 (PDT)
Received: from localhost (fwdproxy-cln-120.fbsv.net. [2a03:2880:31ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id p27-20020a17090635db00b009a168ab6ee2sm6316951ejb.164.2023.09.04.09.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 09:25:27 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>,
        Yonghong Song <yonghong.song@linux.dev>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>,
        Xin Long <lucien.xin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jason Xing <kernelxing@tencent.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 04/10] net/socket: Break down __sys_getsockopt
Date:   Mon,  4 Sep 2023 09:24:57 -0700
Message-Id: <20230904162504.1356068-5-leitao@debian.org>
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
 include/net/sock.h         |  2 ++
 net/core/sock.c            |  8 -----
 net/socket.c               | 62 ++++++++++++++++++++++++--------------
 4 files changed, 42 insertions(+), 32 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index cecfe8c99f28..ffaca1ab5e8d 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -378,7 +378,7 @@ static inline bool cgroup_bpf_sock_enabled(struct sock *sk,
 ({									       \
 	int __ret = 0;							       \
 	if (cgroup_bpf_enabled(CGROUP_GETSOCKOPT))			       \
-		get_user(__ret, optlen);				       \
+		copy_from_sockptr(&__ret, optlen, sizeof(int));		       \
 	__ret;								       \
 })
 
diff --git a/include/net/sock.h b/include/net/sock.h
index b059f9272303..c0185121efe4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1863,6 +1863,8 @@ int sock_setsockopt(struct socket *sock, int level, int op,
 		    sockptr_t optval, unsigned int optlen);
 int do_sock_setsockopt(struct socket *sock, bool compat, int level,
 		       int optname, sockptr_t optval, int optlen);
+int do_sock_getsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, sockptr_t optlen);
 
 int sk_getsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, sockptr_t optlen);
diff --git a/net/core/sock.c b/net/core/sock.c
index 666a17cab4f5..cf15394ed664 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2009,14 +2009,6 @@ int sk_getsockopt(struct sock *sk, int level, int optname,
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
index 3bf29a27653f..c79d2b2b902e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2332,6 +2332,42 @@ SYSCALL_DEFINE5(setsockopt, int, fd, int, level, int, optname,
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
@@ -2339,37 +2375,17 @@ INDIRECT_CALLABLE_DECLARE(bool tcp_bpf_bypass_getsockopt(int level,
 int __sys_getsockopt(int fd, int level, int optname, char __user *optval,
 		int __user *optlen)
 {
-	int max_optlen __maybe_unused;
-	const struct proto_ops *ops;
 	int err, fput_needed;
+	bool compat = in_compat_syscall();
 	struct socket *sock;
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		return err;
 
-	err = security_socket_getsockopt(sock, level, optname);
-	if (err)
-		goto out_put;
-
-	if (!in_compat_syscall())
-		max_optlen = BPF_CGROUP_GETSOCKOPT_MAX_OPTLEN(optlen);
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

