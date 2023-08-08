Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4029773B75
	for <lists+io-uring@lfdr.de>; Tue,  8 Aug 2023 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbjHHPvN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Aug 2023 11:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjHHPtN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Aug 2023 11:49:13 -0400
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF371FCD;
        Tue,  8 Aug 2023 08:42:07 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5232d593646so4480642a12.0;
        Tue, 08 Aug 2023 08:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691509275; x=1692114075;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ChPT/lHzXHpKHyXlCB2W1LoY3mnd1UwLMSxiYiQjKmg=;
        b=Aq0HpdvkekfQbw+pkrnpkt0EUqI2o9wYwT779VYgsIebtZ323pxA6fUaihE2No2Ojq
         W+eHddT/Cjqr7KndK6kk7jMXK25ESTvHK3ysjzsCh5Jtf2p9o0Uw6ITaTpWtPuAUtejm
         1B4K776/QDeS5jATJ6wdyf9Ec5ZGmqxHCm+OS/hojhjIrwCqo/B4HS9erRyY/HYjeuea
         Sa6P0gFa3Fbm1EBj6eJf1d+/5txs1pLbAIZKAMAz80zPvwZXSgT8V2B0bLagraQxyGbF
         FTyiJ8vobs7KBmAV/Ybuwklvhx9wquFj3MrPO2J3nl48A7j9flOZc0B4ty6gnOfz+u4C
         HT2g==
X-Gm-Message-State: AOJu0Yw8iWUPcnIcnQoeBnZc5XwHH7eX3ZwUHposQ6766q/FczVlOHWH
        ERLrGmt4N6zSeBnJSY87Rf/50b+YRNQ=
X-Google-Smtp-Source: AGHT+IEtMdELcO0r2mho0d8dPID1Lr2S9Ywk3n1aEbs+vzrbTUu1jEy7bEX0QBvnj23d6IU/jIcNYQ==
X-Received: by 2002:a17:907:770b:b0:99b:ce9c:a94a with SMTP id kw11-20020a170907770b00b0099bce9ca94amr12488319ejc.4.1691502063751;
        Tue, 08 Aug 2023 06:41:03 -0700 (PDT)
Received: from localhost (fwdproxy-cln-018.fbsv.net. [2a03:2880:31ff:12::face:b00c])
        by smtp.gmail.com with ESMTPSA id h23-20020a1709067cd700b00992f309cfe8sm6775236ejp.178.2023.08.08.06.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Aug 2023 06:41:03 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     sdf@google.com, axboe@kernel.dk, asml.silence@gmail.com,
        willemdebruijn.kernel@gmail.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v2 1/8] net: expose sock_use_custom_sol_socket
Date:   Tue,  8 Aug 2023 06:40:41 -0700
Message-Id: <20230808134049.1407498-2-leitao@debian.org>
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

