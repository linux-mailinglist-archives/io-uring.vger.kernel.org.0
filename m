Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05F2D75F9C4
	for <lists+io-uring@lfdr.de>; Mon, 24 Jul 2023 16:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbjGXOYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 10:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbjGXOYB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 10:24:01 -0400
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AFE10C3;
        Mon, 24 Jul 2023 07:23:53 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-4faaaa476a9so6705121e87.2;
        Mon, 24 Jul 2023 07:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690208631; x=1690813431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ChPT/lHzXHpKHyXlCB2W1LoY3mnd1UwLMSxiYiQjKmg=;
        b=X4sufUvUx313D5bZKrfZpnfttnOH0qc75uaSUQY8iTco6wHbtGIxtmk+pCdZCiAg5I
         mWT5uFi+UXheWqhYlsXACOieHsMVQQl+rg5EVHXgjd7hH1h6WYrUNMVOslNEp1OmZOBS
         mov6/QteUErk8VGB0URwmQPyDTBd31czj/C6YjcyCea/wf5B5cNrLFw0sEbOP491JEOk
         /gpAb8x7981SH3Pzx3Zu6i5oL0YfiCtWXt0I3qyeXHc0rMmlOK2MR0aTu+duFkl25eLx
         dGEl9U8/uPUjVqdcsIJ8nzt2TCsAvVfPCWT0yhuhyVjua6dU/GHUje6RabfRudBcsi6y
         Vtcg==
X-Gm-Message-State: ABy/qLYBtDOp8RBGgTc3EABtKmqktgOf9QbPJMNz73iDapzJsrgCEfyV
        5NSpeaCiCnVBFEVFv0jbOzdEOp7I3t0=
X-Google-Smtp-Source: APBJJlE991JcdDNxQmvs3s+jlsS0PAawC3OmvHXpKD54nLZID4BKysKlhxDO+z9x9+61alUm02K++A==
X-Received: by 2002:a05:6512:3083:b0:4f8:4512:c846 with SMTP id z3-20020a056512308300b004f84512c846mr5794975lfd.49.1690208631269;
        Mon, 24 Jul 2023 07:23:51 -0700 (PDT)
Received: from localhost (fwdproxy-cln-011.fbsv.net. [2a03:2880:31ff:b::face:b00c])
        by smtp.gmail.com with ESMTPSA id lr20-20020a170906fb9400b00992b3ea1ee4sm6948428ejb.149.2023.07.24.07.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 07:23:50 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, leit@meta.com
Subject: [PATCH 1/4] net: expose sock_use_custom_sol_socket
Date:   Mon, 24 Jul 2023 07:22:34 -0700
Message-Id: <20230724142237.358769-2-leitao@debian.org>
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

Exposing function sock_use_custom_sol_socket(), so it could be used by
io_uring subsystem.

This function will be used in the function io_uring_cmd_setsockopt() in
the coming patch, so, let's move it to the socket.h header file.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/linux/net.h | 5 +++++
 net/socket.c        | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/net.h b/include/linux/net.h
index 41c608c1b02c..14a956e4530e 100644
--- a/include/linux/net.h
+++ b/include/linux/net.h
@@ -355,4 +355,9 @@ u32 kernel_sock_ip_overhead(struct sock *sk);
 #define MODULE_ALIAS_NET_PF_PROTO_NAME(pf, proto, name) \
 	MODULE_ALIAS("net-pf-" __stringify(pf) "-proto-" __stringify(proto) \
 		     name)
+
+static inline bool sock_use_custom_sol_socket(const struct socket *sock)
+{
+	return test_bit(SOCK_CUSTOM_SOCKOPT, &sock->flags);
+}
 #endif	/* _LINUX_NET_H */
diff --git a/net/socket.c b/net/socket.c
index 1dc23f5298ba..8df54352af83 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2216,11 +2216,6 @@ SYSCALL_DEFINE4(recv, int, fd, void __user *, ubuf, size_t, size,
 	return __sys_recvfrom(fd, ubuf, size, flags, NULL, NULL);
 }
 
-static bool sock_use_custom_sol_socket(const struct socket *sock)
-{
-	return test_bit(SOCK_CUSTOM_SOCKOPT, &sock->flags);
-}
-
 /*
  *	Set a socket option. Because we don't know the option lengths we have
  *	to pass the user mode parameter for the protocols to sort out.
-- 
2.34.1

