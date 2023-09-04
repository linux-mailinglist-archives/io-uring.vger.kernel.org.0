Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84B0791B70
	for <lists+io-uring@lfdr.de>; Mon,  4 Sep 2023 18:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241348AbjIDQZ3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Sep 2023 12:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240384AbjIDQZ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Sep 2023 12:25:29 -0400
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF2809D;
        Mon,  4 Sep 2023 09:25:25 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-52713d2c606so2198624a12.2;
        Mon, 04 Sep 2023 09:25:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693844724; x=1694449524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PBda6rT0pL/B59nG5AgliJCLsy8+kPWSe+s29wcarWY=;
        b=BDajSyoHg1pnz7M7ag0XKpV0LkJPVrcUIIhZndCm2em5LDAQDiRJcB2jKZaBfpE7QK
         F1RVMy4ifhzk6MIbQ2W6SaVpJEFXjobkcZqLSmJ8fv7CXBsvWSo2tPILzbBZttKTNGvA
         1wjN95OZpMr72384lnisUvU+/USaM4fZa5RlqatcgLXrgm0j/wZzbvYmJzvR9niWy9tJ
         8xPyinC5Esx/BdR9p8k/sAurdjn3ISAsltHN7G7AP/REU9k9DbYcU3Y8WSoFIzebGSBS
         ViDraF3jTL/Y5A2gpHtLV5ZfmH2MnpGV6stDPB9H/EwUFkNiYV0huLaxpnuo38TBDGvz
         Qj4Q==
X-Gm-Message-State: AOJu0YwjB/92yKlZLI3K9TLz93uqG3TqQRHud/uI7JgKA2cVx5mrXmit
        RLTWU4rJlcopBe1ksb54/ac=
X-Google-Smtp-Source: AGHT+IHZKR+9DvETpBcmV6dj1OZh+YayfA1YpM9KTsLZ6mqWKVA1d3MF8/OaJ9OgfHCIheZcXhOCEQ==
X-Received: by 2002:a17:907:78c1:b0:9a1:c991:a51c with SMTP id kv1-20020a17090778c100b009a1c991a51cmr7528046ejc.2.1693844724180;
        Mon, 04 Sep 2023 09:25:24 -0700 (PDT)
Received: from localhost (fwdproxy-cln-118.fbsv.net. [2a03:2880:31ff:76::face:b00c])
        by smtp.gmail.com with ESMTPSA id m26-20020a170906259a00b0099ca4f61a8bsm6406935ejb.92.2023.09.04.09.25.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 09:25:23 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com, martin.lau@linux.dev,
        krisman@suse.de, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>
Subject: [PATCH v4 03/10] net/socket: Break down __sys_setsockopt
Date:   Mon,  4 Sep 2023 09:24:56 -0700
Message-Id: <20230904162504.1356068-4-leitao@debian.org>
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
index 11d503417591..b059f9272303 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1861,6 +1861,8 @@ int sk_setsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, unsigned int optlen);
 int sock_setsockopt(struct socket *sock, int level, int op,
 		    sockptr_t optval, unsigned int optlen);
+int do_sock_setsockopt(struct socket *sock, bool compat, int level,
+		       int optname, sockptr_t optval, int optlen);
 
 int sk_getsockopt(struct sock *sk, int level, int optname,
 		  sockptr_t optval, sockptr_t optlen);
diff --git a/net/socket.c b/net/socket.c
index 9ec9a8a07c0e..3bf29a27653f 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2261,31 +2261,21 @@ static bool sock_use_custom_sol_socket(const struct socket *sock)
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
@@ -2308,6 +2298,27 @@ int __sys_setsockopt(int fd, int level, int optname, char __user *user_optval,
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

