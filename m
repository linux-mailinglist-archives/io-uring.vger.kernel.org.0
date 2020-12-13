Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892AF2D9091
	for <lists+io-uring@lfdr.de>; Sun, 13 Dec 2020 21:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405720AbgLMUcL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 13 Dec 2020 15:32:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405756AbgLMUcD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 13 Dec 2020 15:32:03 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26903C061794
        for <io-uring@vger.kernel.org>; Sun, 13 Dec 2020 12:31:23 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id g185so13447614wmf.3
        for <io-uring@vger.kernel.org>; Sun, 13 Dec 2020 12:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lyu9qmKaJsgfo2w2tI7YPKYDN0AQH0q2QKzrd2Ob2Yg=;
        b=MBMQJgkzv1yqOsPEbZ5RcRFM8xKuCxnF15iaHlBE6OVqiCtAyMJz1bdMFuXEOBqAWC
         kI5JVy9ll3Zxnk6jhsBM/3STzcEabSbckSDzQVX5nOr3FiuSEVmWOLYmL1Jx5V1GW/ys
         6jEFf77pCeoPYCtWWnKfs/TqMq3roteO+Ub0VI2St/L6dhKsPaqlU8h9a4hmA1nDKlNu
         Tf7KWLrfNGvCMdATsjV3IerWME0059O8nBE6JRUMyCqpSDIV49jE1WeooKA+pzRp3Cs9
         8wtpPySg8syvVgpJEl3Q4NDZvKJLrHGO6e59Bko2Dh70jryxffgq9/AcysL9o4POgkde
         cnwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lyu9qmKaJsgfo2w2tI7YPKYDN0AQH0q2QKzrd2Ob2Yg=;
        b=M+R30YNVxIi44jn7mIxs3qTq4tGg18MjR4k3TVmwbTC8srK6lYqmvdVnGlsYDp/KRz
         ewd5nP1ybRa18pGmp7XxWHDlyQnyhyr/FrSO7CJ5ydNx4l8iVuh85oSKo354HMZWdtmZ
         F1aRQ+adRzo5VLJ6sQSiAf2EDcexmvCu7YejgoMHbYYlg1DtvmU6JRFgB3gm217CRjkO
         2yDwSKNenhcMEZzqtRHGkH/Bi6DP9apB/Hiej7TpkZgP78awmAAl72k++znPBYQsvLTV
         tcP6LQSti6flhwjHfK5Z9vJxufsGLQE3KK5Up+kCfJFDKsJdsA6hZkzJsNOjrhDPb7Wx
         8rlw==
X-Gm-Message-State: AOAM530CNt2M6o1FrvY6yurvAW92YqUnRDcl9xnOXqLFREOxXQoiO+qL
        738ubiboVvpVWoAm0q1WIUVPc5kTou3hI0Sf/0OPMw==
X-Google-Smtp-Source: ABdhPJxbCEIccbCFIke6u7MQsej69N342Y5EVx8d6AQxJ6yi/M/YMm/V/nD8BiRdxIE+V+NdY64BPw==
X-Received: by 2002:a7b:cb46:: with SMTP id v6mr4115941wmj.19.1607891481642;
        Sun, 13 Dec 2020 12:31:21 -0800 (PST)
Received: from localhost.localdomain ([8.20.101.195])
        by smtp.gmail.com with ESMTPSA id j13sm27055007wmi.36.2020.12.13.12.31.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 13 Dec 2020 12:31:21 -0800 (PST)
From:   Victor Stewart <v@nametag.social>
To:     io-uring@vger.kernel.org, soheil@google.com,
        netdev@vger.kernel.org, jannh@google.com
Cc:     Victor Stewart <v@nametag.social>
Subject: [PATCH] allow UDP cmsghdrs through io_uring
Date:   Sun, 13 Dec 2020 20:31:12 +0000
Message-Id: <20201213203112.24152-2-v@nametag.social>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201213203112.24152-1-v@nametag.social>
References: <20201213203112.24152-1-v@nametag.social>
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

