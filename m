Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2A82D90A3
	for <lists+io-uring@lfdr.de>; Sun, 13 Dec 2020 21:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406175AbgLMUol (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Dec 2020 15:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406164AbgLMUob (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Dec 2020 15:44:31 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1BBC061793
        for <io-uring@vger.kernel.org>; Sun, 13 Dec 2020 12:43:51 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id x22so11974866wmc.5
        for <io-uring@vger.kernel.org>; Sun, 13 Dec 2020 12:43:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lyu9qmKaJsgfo2w2tI7YPKYDN0AQH0q2QKzrd2Ob2Yg=;
        b=kdOTK9NR3U3pzF7z2bYgXDZF30XcySw0F4g9kalvaTR5dcTKKPjpyAxvXnJGk9ICLV
         3T9uooJOtm6/8f009pMkIcfKb/PaOr/7Rg3VzH/HOpJwuu3rfDrIogt0hop5efe6+SyI
         SxBmKpdjkuE0m9eO8WnpiUOxycODtwOWz6wD0Lpt2TpaKVUQ9XX2HJ8mHYbI2+6BuxAR
         vihVn/+eyIrdDJ3PGOcNfU3Dy6sWoMFUxmwi845wrXx7vzFPALbji7qjJFvR1gpuD2Rc
         zjq00TrdWiOnHaT4YVuqs4ck6G3Od039GCcaaDPTqBUjYF04y356pSuDQgMp1CJMl/Ij
         i7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lyu9qmKaJsgfo2w2tI7YPKYDN0AQH0q2QKzrd2Ob2Yg=;
        b=VWAMcGp90qozP66XPYGYl5MZ3qLal4Rkxr9ZzV3or5Nk4h7Y8iKCkRm6/6fqHf9Z1c
         oOnNUpmWCz3c5EmJb1HAfzEm4yUlWhIQdru+GX/ufsQr/vVb+1HEmKEJwDcmOgh4PqW2
         tFUJbbL81Gywn5o0YxrpPWcQ8FwbRSkHtI6RNJABmVPFvvjkls6AXCr4doYJFv6L5Szd
         i7EcQgtzkOlmYZbi5yMpRiWKRbiiqbVxczHKIB1QJRnll37qf6gNR7K+nRzr+92AwoF7
         ms9Numeiw+5oG347m/NGd7+UL5mgaHlATZpa+OiF6hrf61SxMCmSAq9/ycfWw9Eg7ci8
         e5kA==
X-Gm-Message-State: AOAM53200T0UbIJAaGVQGhAXbgAkIGG/afSljcPK8F00Kb8Dk7Rby1NH
        saRdwvDD2iqYOh+xz4n3hLKxEgK0vQfUq+56cvy30g==
X-Google-Smtp-Source: ABdhPJzrTvSUx8gL8k1cJPZwjNPoSVdFE++5PiKON87vNF/qbfWrgl6eB7ntjzdhTvPmNmzGXA2kKw==
X-Received: by 2002:a1c:bc02:: with SMTP id m2mr24337925wmf.59.1607892229790;
        Sun, 13 Dec 2020 12:43:49 -0800 (PST)
Received: from localhost.localdomain ([8.20.101.195])
        by smtp.gmail.com with ESMTPSA id 34sm28264885wrh.78.2020.12.13.12.43.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Dec 2020 12:43:49 -0800 (PST)
From:   Victor Stewart <v@nametag.social>
To:     io-uring@vger.kernel.org, soheil@google.com,
        netdev@vger.kernel.org, jannh@google.com
Cc:     Victor Stewart <v@nametag.social>
Subject: [PATCH v3] Allow UDP cmsghdrs through io_uring
Date:   Sun, 13 Dec 2020 20:43:39 +0000
Message-Id: <20201213204339.24445-2-v@nametag.social>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213204339.24445-1-v@nametag.social>
References: <20201213204339.24445-1-v@nametag.social>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

---
 net/ipv4/af_inet.c  | 1 +
 net/ipv6/af_inet6.c | 1 +
 net/socket.c        | 8 +++++---
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index b7260c8cef2e..c9fd5e7cfd6e 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1052,6 +1052,7 @@ EXPORT_SYMBOL(inet_stream_ops);
 
 const struct proto_ops inet_dgram_ops = {
 	.family		   = PF_INET,
+	.flags		   = PROTO_CMSG_DATA_ONLY,
 	.owner		   = THIS_MODULE,
 	.release	   = inet_release,
 	.bind		   = inet_bind,
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index e648fbebb167..560f45009d06 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -695,6 +695,7 @@ const struct proto_ops inet6_stream_ops = {
 
 const struct proto_ops inet6_dgram_ops = {
 	.family		   = PF_INET6,
+	.flags		   = PROTO_CMSG_DATA_ONLY,
 	.owner		   = THIS_MODULE,
 	.release	   = inet6_release,
 	.bind		   = inet6_bind,
diff --git a/net/socket.c b/net/socket.c
index 6e6cccc2104f..6995835d6355 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2416,9 +2416,11 @@ static int ___sys_sendmsg(struct socket *sock, struct user_msghdr __user *msg,
 long __sys_sendmsg_sock(struct socket *sock, struct msghdr *msg,
 			unsigned int flags)
 {
-	/* disallow ancillary data requests from this path */
-	if (msg->msg_control || msg->msg_controllen)
-		return -EINVAL;
+	if (msg->msg_control || msg->msg_controllen) {
+		/* disallow ancillary data reqs unless cmsg is plain data */
+		if (!(sock->ops->flags & PROTO_CMSG_DATA_ONLY))
+			return -EINVAL;
+	}
 
 	return ____sys_sendmsg(sock, msg, flags, NULL, 0);
 }
-- 
2.26.2

