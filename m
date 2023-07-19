Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14311759305
	for <lists+io-uring@lfdr.de>; Wed, 19 Jul 2023 12:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230317AbjGSK33 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Jul 2023 06:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231292AbjGSK3S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Jul 2023 06:29:18 -0400
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9CE2701;
        Wed, 19 Jul 2023 03:28:44 -0700 (PDT)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-3fbc59de0e2so62471495e9.3;
        Wed, 19 Jul 2023 03:28:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689762477; x=1692354477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ChPT/lHzXHpKHyXlCB2W1LoY3mnd1UwLMSxiYiQjKmg=;
        b=ac0dv5CuPxNhSixnj7G/aMAG2v7RmhsTO6Srguly6jqHEuo3f/seW+3CLvA/yXirdL
         BCG4qEkxQSbu4aI0j1OyKhSxkFcY4uTbaaSqrrhkwsqtcndXo0oYFn9clBO2iBL+6KAT
         MoeaCcrc84dHLP55rNo65ZoemN+KEOD97TsLBmvVux+IWR/PVCJVrhMD8nJFwG9lvujP
         0dIVfFDULDqla+M5TuIU5GyjI0rh/WjY6gtsY271zv1bVL8yYFzeqBEiqA0cK8j3b/YN
         68812p6K3h8BnxDJr/QD7n5nrm1xOctTbY90SSvEee15/giuENITbZD/bvK9QTZS3TDU
         cHuA==
X-Gm-Message-State: ABy/qLa+5A66xhNnZBsyd1x3DBwgo3JyHBfqX+YlT6BbzCteFW18Uc/i
        tAFnOvQOdbf88C9byVO3sew=
X-Google-Smtp-Source: APBJJlFmifkLiv/RuceB8nTtJrRR283eiSqSY2zSuGIWWfK0SsJFGj/U8dfUmLkGrIGlPkCwIRzwAQ==
X-Received: by 2002:a7b:ce15:0:b0:3fb:d68d:4c6f with SMTP id m21-20020a7bce15000000b003fbd68d4c6fmr3780930wmc.14.1689762476806;
        Wed, 19 Jul 2023 03:27:56 -0700 (PDT)
Received: from localhost (fwdproxy-cln-120.fbsv.net. [2a03:2880:31ff:78::face:b00c])
        by smtp.gmail.com with ESMTPSA id p13-20020a1c740d000000b003fbb0c01d4bsm1363718wmc.16.2023.07.19.03.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jul 2023 03:27:56 -0700 (PDT)
From:   Breno Leitao <leitao@debian.org>
To:     asml.silence@gmail.com, axboe@kernel.dk,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     io-uring@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/3] net: expose sock_use_custom_sol_socket
Date:   Wed, 19 Jul 2023 03:27:35 -0700
Message-Id: <20230719102737.2513246-2-leitao@debian.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230719102737.2513246-1-leitao@debian.org>
References: <20230719102737.2513246-1-leitao@debian.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
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

