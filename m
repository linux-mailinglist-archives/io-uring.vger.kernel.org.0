Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDF84FEAFC
	for <lists+io-uring@lfdr.de>; Wed, 13 Apr 2022 01:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiDLXbo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 19:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiDLXbV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 19:31:21 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA19649F2A
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 15:16:07 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id e4so214062oif.2
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 15:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DAOJ+2Dw7odh73dz0PwJU+1pGsjezsYHV2vM38MSs88=;
        b=lGWY8rAe4Vy4evQsQJvRj5XO3VdNphEaelmiyDEGGx7ZQ3XPvMxaO0KRk50vpPwQeZ
         Q8EBGbj6+JC7sr2wmYu4rzv2ctD3TNwaH3VOruYmifXv+SyOYKuc+KxJCBdYnJvGiI+2
         yoUd7/Qm8+JmxETaBRNLXTmFc4ge2zTiT0ra9iKvVaT8EhkL+EgKogHvBPWKOek8Epdk
         NmYCeOLckRq9JIZm6dp/nBYtPjNmgxfO/PSucCcw81WoEACFrOAOVLOJ/PUWLlFyY7XS
         V8qdj9EjxZQjYdUQsnFbbiRqbpFuqmsUmV4NG1c+k2ry3tRbELpyL1283ec23VgcWSMO
         eBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DAOJ+2Dw7odh73dz0PwJU+1pGsjezsYHV2vM38MSs88=;
        b=nD3liIyu7zs9DBflbut/eEr6YZeeUsNT+2y/mJtkahYom1Ms+37eX+1XMscu7ux2eI
         0tPnI34brq9i7Xl2qC7xDVtu631UuWfYI4e+HPMcBdr6eKnEaa+kSsIIFaS3JUY2l20B
         u7uosYvP8OZfBN7QWZ9Zl6jxkLMRUweWVK5TltvdSox1UgNyy+6R6wHgNbKZ7DqKGloi
         RoN0S1mXliPpAC2B0zTZtU3+Ekqtr74Xyf5OVJoAK8bc7pzH0fzsoao431Il1y9+dwYz
         9vJ0Hhq/w7Xo3iTkS2eEiBprC6/NoWg4iaqsNoxJO3pKDEzRJ2BPU2dloMmIT95omT3z
         L6GQ==
X-Gm-Message-State: AOAM532C3rpgOu/awu4fAv/71N1aBlcryiJR9oIQCnJpUczkM6il2Tc9
        FGVc0loZS9ikBgX1WGD9maCP4yRtWw4ppJa+
X-Google-Smtp-Source: ABdhPJycsRiJanTh3wtw2KohBRMlkFr2bIjTqMD80zMNbSPd1Vas/+wa4hKSZlOf8uzVbxRel2O6Wg==
X-Received: by 2002:a17:90a:4308:b0:1cb:b996:1dc with SMTP id q8-20020a17090a430800b001cbb99601dcmr6982659pjg.224.1649795177596;
        Tue, 12 Apr 2022 13:26:17 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm3609084pgf.17.2022.04.12.13.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:26:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] net: allow sk_prot->release_cb() without sock lock held
Date:   Tue, 12 Apr 2022 14:26:11 -0600
Message-Id: <20220412202613.234896-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412202613.234896-1-axboe@kernel.dk>
References: <20220412202613.234896-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add helpers that allow ->release_cb() to acquire the socket bh lock
when needed. For normal sockets, ->release_cb() is always invoked with
that lock held. For nolock sockets it will not be held, so provide an
easy way to acquire it when necessary.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/net/sock.h    | 10 ++++++++++
 net/atm/common.c      |  5 ++++-
 net/ipv4/tcp_output.c |  2 ++
 net/mptcp/protocol.c  |  3 +++
 net/smc/af_smc.c      |  2 ++
 5 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index e8283a65b757..99fcc4d7eed9 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1696,6 +1696,16 @@ void release_sock(struct sock *sk);
 				SINGLE_DEPTH_NESTING)
 #define bh_unlock_sock(__sk)	spin_unlock(&((__sk)->sk_lock.slock))
 
+/* nolock helpers */
+#define bh_lock_sock_on_nolock(__sk)	do {			\
+	if ((__sk)->sk_no_lock)					\
+		spin_lock_bh(&(__sk)->sk_lock.slock);		\
+} while (0)
+#define bh_unlock_sock_on_nolock(__sk)	do {			\
+	if ((__sk)->sk_no_lock)					\
+		spin_unlock_bh(&(__sk)->sk_lock.slock);		\
+} while (0)
+
 bool __lock_sock_fast(struct sock *sk) __acquires(&sk->sk_lock.slock);
 
 /**
diff --git a/net/atm/common.c b/net/atm/common.c
index 1cfa9bf1d187..471363e929f6 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -126,8 +126,11 @@ static void vcc_release_cb(struct sock *sk)
 {
 	struct atm_vcc *vcc = atm_sk(sk);
 
-	if (vcc->release_cb)
+	if (vcc->release_cb) {
+		bh_lock_sock_on_nolock(sk);
 		vcc->release_cb(vcc);
+		bh_lock_sock_on_nolock(sk);
+	}
 }
 
 static struct proto vcc_proto = {
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 9ede847f4199..9f86ea63cbac 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1100,6 +1100,7 @@ void tcp_release_cb(struct sock *sk)
 	 * But following code is meant to be called from BH handlers,
 	 * so we should keep BH disabled, but early release socket ownership
 	 */
+	bh_lock_sock_on_nolock(sk);
 	sock_release_ownership(sk);
 
 	if (flags & TCPF_WRITE_TIMER_DEFERRED) {
@@ -1114,6 +1115,7 @@ void tcp_release_cb(struct sock *sk)
 		inet_csk(sk)->icsk_af_ops->mtu_reduced(sk);
 		__sock_put(sk);
 	}
+	bh_unlock_sock_on_nolock(sk);
 }
 EXPORT_SYMBOL(tcp_release_cb);
 
diff --git a/net/mptcp/protocol.c b/net/mptcp/protocol.c
index 0cbea3b6d0a4..ae9078e8e137 100644
--- a/net/mptcp/protocol.c
+++ b/net/mptcp/protocol.c
@@ -3065,6 +3065,8 @@ static void mptcp_release_cb(struct sock *sk)
 {
 	struct mptcp_sock *msk = mptcp_sk(sk);
 
+	bh_lock_sock_on_nolock(sk);
+
 	for (;;) {
 		unsigned long flags = (msk->cb_flags & MPTCP_FLAGS_PROCESS_CTX_NEED) |
 				      msk->push_pending;
@@ -3103,6 +3105,7 @@ static void mptcp_release_cb(struct sock *sk)
 		__mptcp_error_report(sk);
 
 	__mptcp_update_rmem(sk);
+	bh_unlock_sock_on_nolock(sk);
 }
 
 /* MP_JOIN client subflow must wait for 4th ack before sending any data:
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index f0d118e9f155..3456dc6cd38b 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -201,10 +201,12 @@ static void smc_release_cb(struct sock *sk)
 {
 	struct smc_sock *smc = smc_sk(sk);
 
+	bh_lock_sock_on_nolock(sk);
 	if (smc->conn.tx_in_release_sock) {
 		smc_tx_pending(&smc->conn);
 		smc->conn.tx_in_release_sock = false;
 	}
+	bh_unlock_sock_on_nolock(sk);
 }
 
 struct proto smc_proto = {
-- 
2.35.1

