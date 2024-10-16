Return-Path: <io-uring+bounces-3754-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2A8D9A1204
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:54:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 82CB728230B
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:54:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C578C2170CC;
	Wed, 16 Oct 2024 18:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="RiAPnvgK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24C72170CD
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 18:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729104804; cv=none; b=drobHdSazel2gWdIp+zQHtwgNviP+jHrDmFEGnkFDKRXZPVWM9XcqsZdhSbxG4DhAg0RmzGviCrKMU/TbmxPswHjmMUdHCsuSSemSITBBa0qY7y7mx5P7Ju3n15GJOaMQzFnNM0zVzl2Gu6UROIAknuwKxXSMLnZjCi+opY5/A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729104804; c=relaxed/simple;
	bh=R2xg4awbMnuxmxxdZQvawbB6Glg1Q6V2IXHJy+GrJgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkWUulGBxxM94CwAinoDT3O++Cti7pMPMk2Jd06BGXDS8LGOUNpYaTCZyPzcP+bUeJqzhPmborynEZFMhdCTq+0WG/w1/ht/QqJS2ma3AZOmAgEZBVegDmyuYgnYNziTXrhalV9X+8OFFunycDVh2T0abAw2Knjg/tnguR07xnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=RiAPnvgK; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-71e49ef3bb9so95269b3a.1
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 11:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729104801; x=1729709601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pcqR/6GFofymoBmw+CHLZpbByxhu6rkcZaJ0jMgsDWE=;
        b=RiAPnvgK6zExA7UeqFGRhk0KxDZ67zFyBESZ92aSVDF8p96tdCFvoKZb5hQZx39bpI
         bngA4PQSPYmTINJBR6vxPTQ2Am9NwbQWNv7927Px1II6wjbspaw37DTfyIgtZM57VKrZ
         uCVhobruDG38tI+vMOsW4iEDX4eMqeJaSyM4AFDaaD89NLy39uxK9gGWxZqbfBAF7l6Q
         UTN2Uxs/B7qktCptjxFppUnWmWfReGxz4GmCuG3Wo2YAo/huazZM9S8Ev/MBhFP+ecEb
         X7gcunIdvJ11eLVeh5OkACqPRYUgVJ+rf1UOAEtjixwTSnObc8mOAt+/osZ8t1LI9MvW
         OI0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729104801; x=1729709601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pcqR/6GFofymoBmw+CHLZpbByxhu6rkcZaJ0jMgsDWE=;
        b=lkekuDQJv2dyag00jbRyGodA+AOQUZGxfBmQOq6iJPiskxYdbqMysq+avEAVh7uHR/
         IQAhR0BZtmvSmFaBZ1jbkWxCM5Sx56yaeYpEc+gHOxAvWZ7fAun3ARINVuze+E/EoUnI
         9GaDMHYkr66ZqAajlYNbc8BmPCKpcX0llBeFxlMN8aLzukWwUqbjjbdI99XB7J01mAkL
         4vRiE7/71eae1Yy5imrsVMGRTCnQIRTVFv94wCtN+iST1l7w5PH/Mm0RsZVpo0pYOt5f
         Urg8zzK8z/nd+rjCz8SiEuuBLIaNUGX6AQM6DST/m1ABkS/qF52zdZltoWMys0lU/Ejk
         dneg==
X-Gm-Message-State: AOJu0YzKLj1A9q87kWh6g7JeZEYbDz3G2BWF971PRMm0frDR2KkAj+TX
	nlTLvwm2RSgK1hUPtk+0ygc0/HyubA9lr86ZJ4Vmm6f/k1SNDqp5MO62QxIMj19Fw9rme8U5D2R
	i
X-Google-Smtp-Source: AGHT+IFq74+NXxlV/h/CvdQlFy6zQsMt566N2UrAfZP9nAHBsh0K1U4WjJq/895gJxJA1ElmiuflXg==
X-Received: by 2002:a05:6a00:3cd1:b0:71e:44f6:690f with SMTP id d2e1a72fcca58-71e8fd8d44dmr813114b3a.8.1729104801317;
        Wed, 16 Oct 2024 11:53:21 -0700 (PDT)
Received: from localhost (fwdproxy-prn-023.fbsv.net. [2a03:2880:ff:17::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e77518a5fsm3382791b3a.214.2024.10.16.11.53.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 11:53:20 -0700 (PDT)
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
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH v6 15/15] io_uring/zcrx: throttle receive requests
Date: Wed, 16 Oct 2024 11:52:52 -0700
Message-ID: <20241016185252.3746190-16-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241016185252.3746190-1-dw@davidwei.uk>
References: <20241016185252.3746190-1-dw@davidwei.uk>
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
index 9716ecdcb570..27966dfa2938 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1255,10 +1255,13 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
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


