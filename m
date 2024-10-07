Return-Path: <io-uring+bounces-3457-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27B2E993A0D
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:18:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7B483B21782
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:18:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B0E01DE4DD;
	Mon,  7 Oct 2024 22:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="01wA2JLY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D18B31DD54E
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339408; cv=none; b=YHl48xybv3vRUo8x255X2SifVJC1CfAhXczPyqkcQJwEQ81652iW1IQdn6c2KUec4yNCoImpPKifG0uKCv4Ko209ZsGbgCfQg+j6Fl8OoWpYRz2OIMuHqyf9Cs5q+K8RMLekD08OVxlQe869JjkT8uKTIC5HHYuyJcnfJNmbBjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339408; c=relaxed/simple;
	bh=8byHPkmyqil4BRS4TqeQPgrllEa8K8cBiR2yYsnDLjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D1fzjhEDTTf5K1kFn22yTyHVYJ7ux9Ed4sdzn+EGmUz4gTHXwrnhaK0WSKC6y2reOrG5gMPGzbRov7TMvpwVuC8HDn48HSW00GXsv2WKsrO4P6O8+u1HA3Toxpcmgw9b4BNwR3sejaHmqMEFBs4XyRTprQ8JE/pWp//D1J2Dng0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=01wA2JLY; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20ba9f3824fso36977135ad.0
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339406; x=1728944206; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZx20d5L+OyVbNtxxiSkP5O3ww6PEtO7CAmaLbxuvto=;
        b=01wA2JLYGHgSeBiGQFVtPj5XmmWpJyM7P8CTNjiVl2KJ2Ji/XfmK5cBgAQoYxCRUN2
         YQ6s7WZVfgFZ1VZeUOiaZLKy4f6bZz4308VNwOHyEDHOT/gMpjs5Nmo0GE9fgVIwE+CS
         77KtoGsXtMJAoD6aD8ck7HFfGmb2sLbOT13uUwuzokkLIm51VJemVI8rdLp36lhZ09uj
         BotTSEeLEg1EI0r9AcWty5VAaII4BAxYrhl3uIDx6n/dEkUgUy+3OPxhGh+VRfSp0Mwx
         KD+iAhe5O6SSJdEhWE1pBSaNBOxei6apLJdA9EjOP3YDXS8gpanCcWARAztTj2Vy+GbJ
         0feQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339406; x=1728944206;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZx20d5L+OyVbNtxxiSkP5O3ww6PEtO7CAmaLbxuvto=;
        b=fEW3QYvkInl7GQNkOPmqjXq6Crno39gYCAbTw1HvwDtCjE1MFOtQx5gZDiueCUwjZ+
         r5dgkjvxednToeKnGSrY2vo7TABUneVNdZmNfMe/Fkkj0kVa8EV+6s9zrQPFnIBsi3KP
         BB2yu8a71KoDEBtIibkr4Lvti4Iq/ssOmZloGJR0YgLh2Acnv8iUO908qAiwAYe0EA2T
         qFgqv2B+qxLzomu8QD3Ek33rVoUJiDqI+3SqplwVrPJwu1egj+hkly5UMOIKgQrzlKV5
         bU8lRj2zcE7ZsnI9ElgDdEDMhQGJKZs2q8RpgP2v0LA7qmNV1EUPYrELdWzC799wSklv
         l3ow==
X-Gm-Message-State: AOJu0YxcW8Z4TRQ0ndnKhbLQekoJHpDrMYLTEtyApZbEwbVFQM4jK+rN
	Pp6pUsVoO8t5POOgvhmHOsTnqIPRD1lgu2dPNjEYn+QCPGjt+vE4xac4A2y6yWkS9dwCaoC8SXT
	o
X-Google-Smtp-Source: AGHT+IGG+x8hF8UTMd+j5BFtku8i621L8kiAlMLyUacTPS2TDiYZJc55o5i83AgH/0u7kK+7KB6Q2A==
X-Received: by 2002:a17:903:234f:b0:20c:3d9e:5f2b with SMTP id d9443c01a7336-20c3d9e60acmr48053035ad.57.1728339406294;
        Mon, 07 Oct 2024 15:16:46 -0700 (PDT)
Received: from localhost (fwdproxy-prn-024.fbsv.net. [2a03:2880:ff:18::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c139a1792sm44280965ad.293.2024.10.07.15.16.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:45 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 15/15] io_uring/zcrx: throttle receive requests
Date: Mon,  7 Oct 2024 15:16:03 -0700
Message-ID: <20241007221603.1703699-16-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

io_zc_rx_tcp_recvmsg() continues until it fails or there is nothing to
receive. If the other side sends fast enough, we might get stuck in
io_zc_rx_tcp_recvmsg() producing more and more CQEs but not letting the
user to handle them leading to unbound latencies.

Break out of it based on an arbitrarily chosen limit, the upper layer
will either return to userspace or requeue the request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/net.c  |  5 ++++-
 io_uring/zcrx.c | 17 ++++++++++++++---
 io_uring/zcrx.h |  6 ++++--
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 482e138d2994..c99e62c7dcfb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1253,10 +1253,13 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	if (!ifq)
 		return -EINVAL;
 
-	ret = io_zcrx_recv(req, ifq, sock, zc->msg_flags | MSG_DONTWAIT);
+	ret = io_zcrx_recv(req, ifq, sock, zc->msg_flags | MSG_DONTWAIT,
+			   issue_flags);
 	if (unlikely(ret <= 0) && ret != -EAGAIN) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret == IOU_REQUEUE)
+			return IOU_REQUEUE;
 
 		req_set_fail(req);
 		io_req_set_res(req, ret, 0);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 7939f830cf5b..a78d82a2d404 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -26,10 +26,13 @@
 
 #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_INET)
 
+#define IO_SKBS_PER_CALL_LIMIT	20
+
 struct io_zcrx_args {
 	struct io_kiocb		*req;
 	struct io_zcrx_ifq	*ifq;
 	struct socket		*sock;
+	unsigned		nr_skbs;
 };
 
 struct io_zc_refill_data {
@@ -708,6 +711,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
+		return -EAGAIN;
+
 	if (unlikely(offset < skb_headlen(skb))) {
 		ssize_t copied;
 		size_t to_copy;
@@ -785,7 +791,8 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 }
 
 static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-				struct sock *sk, int flags)
+				struct sock *sk, int flags,
+				unsigned int issue_flags)
 {
 	struct io_zcrx_args args = {
 		.req = req,
@@ -811,6 +818,9 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			ret = -ENOTCONN;
 		else
 			ret = -EAGAIN;
+	} else if (unlikely(args.nr_skbs > IO_SKBS_PER_CALL_LIMIT) &&
+		   (issue_flags & IO_URING_F_MULTISHOT)) {
+		ret = IOU_REQUEUE;
 	} else if (sock_flag(sk, SOCK_DONE)) {
 		/* Make it to retry until it finally gets 0. */
 		ret = -EAGAIN;
@@ -821,7 +831,8 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 }
 
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-		 struct socket *sock, unsigned int flags)
+		 struct socket *sock, unsigned int flags,
+		 unsigned int issue_flags)
 {
 	struct sock *sk = sock->sk;
 	const struct proto *prot = READ_ONCE(sk->sk_prot);
@@ -830,7 +841,7 @@ int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		return -EPROTONOSUPPORT;
 
 	sock_rps_record_flow(sk);
-	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags);
+	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags, issue_flags);
 }
 
 #endif
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index ddd68098122a..bb7ca61a251e 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -46,7 +46,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-		 struct socket *sock, unsigned int flags);
+		 struct socket *sock, unsigned int flags,
+		 unsigned int issue_flags);
 #else
 static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 					struct io_uring_zcrx_ifq_reg __user *arg)
@@ -60,7 +61,8 @@ static inline void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 }
 static inline int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-			       struct socket *sock, unsigned int flags)
+				struct socket *sock, unsigned int flags,
+				unsigned int issue_flags)
 {
 	return -EOPNOTSUPP;
 }
-- 
2.43.5


