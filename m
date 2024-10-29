Return-Path: <io-uring+bounces-4170-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5961D9B567A
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:07:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A8A91C20F3F
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 23:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F62420D51C;
	Tue, 29 Oct 2024 23:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="R+YYehnA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E85D420CCD8
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 23:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730243181; cv=none; b=odbHZYHKPO5gMYhm/rrZePgnumiHliTbS2Gu+RVI1gqD8rLLoDnP1TEW71jXIAVY/he8wuL4HJWPPH1SnHASoTE0UTRv4Etrg7SmSFsjVfqFpSME1vbCXDVBp9oQjdBheGLCWIYXrpkxd1tP8pQNntq+FgivcvTkNoFRLBF+cio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730243181; c=relaxed/simple;
	bh=Au6AN8yfyazUUk9v9fcNH1YO+69ADNVrgDbw4mvV8HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPHHHmn2rbZSH+rEFt7LJ+SDCSLxCF7fW358zbS/iicKaTN2GFfcLhv7i/Tr3BuSKMuOCPSlmDohZc01/cxZyj7ph4xMW+u60ZFhctwzKwAYXSUfbAw9ZNj87OTpWR+T+QBwuJve2aqbSzNLwZ1BZOM64ABhMcQZJdGecLzVwQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=R+YYehnA; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-71e953f4e7cso4440338b3a.3
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 16:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1730243178; x=1730847978; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqXTZJWkdTVEgjeilhHk8BZ1ynAufoDLVRHn5o54aOg=;
        b=R+YYehnAbk2uA9/FfplEwmAwpxoe2wTqzgvT9SF9mtwbNEVnH7RUuoM26KA+rAb+Gr
         VwL3MojnLbaCvUeEssqk3ZMtESUwXRBpazlmHLB/VGRFO/4slPGtCGqHbArw/IgIps4b
         yyHO6evNVcGZQPvAk+HtMlv8/aKu41iwEbIVplm3S/oVQ6B5RToVjHwqMPL3JJmhsLtZ
         jXnkhfnnzhuULP+seiGcTdtzF6jpJkLRvpTUJfyDqrMNAM91QRsguHvn/RiDHea0r2OQ
         w8PhedHab0zw0htlrshAnEAxYb4upNrgEFJM+Nm4rEyKiku78dFx1vP61YbMDSyiMzf8
         jrGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730243178; x=1730847978;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pqXTZJWkdTVEgjeilhHk8BZ1ynAufoDLVRHn5o54aOg=;
        b=O4RPDHvoB8sObP+TPphbc91sJsEfRTAFhYnOiSdU/vhcb8Itlv6GEWTgscHTWL4/FU
         LczswXZh0WAW64f9/joUGoxpjvzt/QIcfVMz9iFo9a318T/zhFXP3lOz9GalsvCzHd3G
         jmvAd8S2nBpCB8xKZsBStXSWJ5+0f0czHM5rmKUMGD/JCE1an/GCrRMJlKurfV9rR/gC
         7Df/0bk4xakZrX3lXMNfIeivtAy9STKMT4rP4JIYMwVM/+s0ODOEd8pvmxtiFIzQec6d
         9KgwqO8GR7w+9/SbHb5/5tFzWZdL+fHnjBYIBpNOanu4b7eEAIQL5AHokaE/OaJzvViH
         hZXQ==
X-Gm-Message-State: AOJu0YxTfJK/jQQqkNlny3qv7dQxO/ZpsH4TanfrYRoadm9YcL0WVIvC
	Gw8XkJMjezRHoqmzP06YLuEMvWLeYpROC6ioRsu94HRIjJcorF7N8vLlLoS2VLOmMYDJqRwYNO6
	ZgTk=
X-Google-Smtp-Source: AGHT+IFc1nfMHIuQ/hIQC+POg1TOelh10OutJBD3En13JXkTOjNIXlnvIzpbP9gO8BUDMJIRGuOdbQ==
X-Received: by 2002:a05:6a00:3e1f:b0:720:36c5:b548 with SMTP id d2e1a72fcca58-72062fb8112mr17944813b3a.16.1730243178116;
        Tue, 29 Oct 2024 16:06:18 -0700 (PDT)
Received: from localhost (fwdproxy-prn-017.fbsv.net. [2a03:2880:ff:11::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72057921619sm8136813b3a.4.2024.10.29.16.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 16:06:17 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH v7 15/15] io_uring/zcrx: throttle receive requests
Date: Tue, 29 Oct 2024 16:05:18 -0700
Message-ID: <20241029230521.2385749-16-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241029230521.2385749-1-dw@davidwei.uk>
References: <20241029230521.2385749-1-dw@davidwei.uk>
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
index 5c015b47582f..f44344942d32 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1261,10 +1261,13 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT);
+	ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
+			   issue_flags);
 	if (unlikely(ret <= 0) && ret != -EAGAIN) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret == IOU_REQUEUE)
+			return IOU_REQUEUE;
 
 		req_set_fail(req);
 		io_req_set_res(req, ret, 0);
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 1f4db70e3370..a2c753e8e46e 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -24,10 +24,13 @@
 
 #define IO_RQ_MAX_ENTRIES		32768
 
+#define IO_SKBS_PER_CALL_LIMIT	20
+
 struct io_zcrx_args {
 	struct io_kiocb		*req;
 	struct io_zcrx_ifq	*ifq;
 	struct socket		*sock;
+	unsigned		nr_skbs;
 };
 
 struct io_zc_refill_data {
@@ -701,6 +704,9 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
+		return -EAGAIN;
+
 	if (unlikely(offset < skb_headlen(skb))) {
 		ssize_t copied;
 		size_t to_copy;
@@ -778,7 +784,8 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 }
 
 static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-				struct sock *sk, int flags)
+				struct sock *sk, int flags,
+				unsigned int issue_flags)
 {
 	struct io_zcrx_args args = {
 		.req = req,
@@ -804,6 +811,9 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 			ret = -ENOTCONN;
 		else
 			ret = -EAGAIN;
+	} else if (unlikely(args.nr_skbs > IO_SKBS_PER_CALL_LIMIT) &&
+		   (issue_flags & IO_URING_F_MULTISHOT)) {
+		ret = IOU_REQUEUE;
 	} else if (sock_flag(sk, SOCK_DONE)) {
 		/* Make it to retry until it finally gets 0. */
 		ret = -EAGAIN;
@@ -814,7 +824,8 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 }
 
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-		 struct socket *sock, unsigned int flags)
+		 struct socket *sock, unsigned int flags,
+		 unsigned int issue_flags)
 {
 	struct sock *sk = sock->sk;
 	const struct proto *prot = READ_ONCE(sk->sk_prot);
@@ -823,5 +834,5 @@ int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		return -EPROTONOSUPPORT;
 
 	sock_rps_record_flow(sk);
-	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags);
+	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags, issue_flags);
 }
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 5d7920972e95..45485bdce61a 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -48,7 +48,8 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
-		 struct socket *sock, unsigned int flags);
+		 struct socket *sock, unsigned int flags,
+		 unsigned int issue_flags);
 #else
 static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 					struct io_uring_zcrx_ifq_reg __user *arg)
@@ -62,7 +63,8 @@ static inline void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
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


