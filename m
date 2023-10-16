Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C5837CAAB9
	for <lists+io-uring@lfdr.de>; Mon, 16 Oct 2023 16:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjJPOBo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 16 Oct 2023 10:01:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233496AbjJPOBl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 16 Oct 2023 10:01:41 -0400
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BFD1F2;
        Mon, 16 Oct 2023 07:01:39 -0700 (PDT)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-9adca291f99so709066666b.2;
        Mon, 16 Oct 2023 07:01:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697464898; x=1698069698;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SQzK26J7czJDylxtxHZHIwCv9ElLol5pJu5kvBMM+Nc=;
        b=OooOgbKnmj5/iXvkRaewpp3iUs/c7waHJn66tHBcwJsGMDh9GtkyFImWGLgJyGlPLY
         BUIfJLEcyt9m3obuZ6En3dyf1ebjmFj7+BPST0sU47Qkt21hndYbIL2KHWwzuFlksg1l
         rSyEDoWtMINrfXJdlZ6rZeppzBUsLLN3IGjzaz0LdbsxBrW4rcv0uRISXpaUpYr+LQ3c
         VbipQiH0W2hxhIPSCj+k18BFgfWK68iOONjCxPSBWXVs9O0382QBu32llYkaktO7ecaz
         gWQ31f7ACfDXqlEFwqe4RW5y6det7t3j/lHX/UFvSET2Gvc/WLjK3J9DqX+a8X4SfWS1
         +P3g==
X-Gm-Message-State: AOJu0YyT6W4QzGTaDmIBQJTk21hdkM2N0JH1U6vsBTSq8+XDIre0hQs+
        zcgLTvxp8aBiDrJ1N+ReD3w=
X-Google-Smtp-Source: AGHT+IHe5Q+UzhZXa0SQryazPxzDrcN0ZkJgMojEXPmzisHt8+a8LsG17q9bkIEWJQHq6L6jUQFrCw==
X-Received: by 2002:a17:907:6e8a:b0:9be:2963:5671 with SMTP id sh10-20020a1709076e8a00b009be29635671mr7882396ejc.69.1697464897888;
        Mon, 16 Oct 2023 07:01:37 -0700 (PDT)
Received: from localhost (fwdproxy-cln-009.fbsv.net. [2a03:2880:31ff:9::face:b00c])
        by smtp.gmail.com with ESMTPSA id l16-20020a1709066b9000b009b65b2be80bsm4085616ejr.76.2023.10.16.07.01.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Oct 2023 07:01:37 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, kuba@kernel.org,
        pabeni@redhat.com, martin.lau@linux.dev, krisman@suse.de,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v7 03/11] net/socket: Break down __sys_setsockopt
Date:   Mon, 16 Oct 2023 06:47:41 -0700
Message-Id: <20231016134750.1381153-4-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231016134750.1381153-1-leitao@debian.org>
References: <20231016134750.1381153-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
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
Reviewed-by: Willem de Bruijn <willemb@google.com>
---
 include/net/sock.h |  2 ++
 net/socket.c       | 39 +++++++++++++++++++++++++--------------
 2 files changed, 27 insertions(+), 14 deletions(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 242590308d64..00103e3143c4 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1864,6 +1864,8 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, unsigned int optlen);
 int sock_setsockopt(struct socket *sock, int level, int op,
 		    sockptr_t optval, unsigned int optlen);
+int do_sock_setsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, int optlen);
 
 int sk_getsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, sockptr_t optlen);
diff --git a/net/socket.c b/net/socket.c
index 28d3eb339514..0087f8c071e7 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2279,31 +2279,21 @@ static bool sock_use_custom_sol_socket(const struct socket *sock)
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
 	const struct proto_ops *ops;
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
@@ -2326,6 +2316,27 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
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

