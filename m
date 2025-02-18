Return-Path: <io-uring+bounces-6500-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F49A3A36B
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 18:00:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28CD03B0FA2
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 16:57:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2261226FA6A;
	Tue, 18 Feb 2025 16:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="BEVUy5jZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D12026FA5A
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739897841; cv=none; b=YdsMs372K1ymfENccXYvBEn9+yTMrcmFFhlLvJ2EhQmLh78mMklzw6bQwkLqlZMlVYxlpeQnuS3E1j+8nHM+MvMZMHDvmvx/Y3iCZhxHeAJPG8fyaVqoaCqxJXFDQ+45TFAVeBloCVheiOCg0CdXputur+PoCq+xDAIJjJduAPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739897841; c=relaxed/simple;
	bh=9Y7YJSRAQ7z5jg8snzZsmh2d/JVshhTsLe0Bym3i8GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+iIw2/HXBYq01MZVT98C0lnMHKjZqc82m0MkvTZnmk3XYjWNyVaZMu4qYdSbR9U+PCy/QkzxnzfhXKT6Out4dK8MGeg9RfGQrj5FypuYsQB/0agNHzY0sS0dg0uHy6G+FhiB+xM/nvpcyOEC5AubqpT30aPKyA2J3jL4muq75k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=BEVUy5jZ; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-22113560c57so58481425ad.2
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 08:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739897839; x=1740502639; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VQIadInEqZcmDRRaKuQ5fqFZ4vJm04VV/2ZJqNFL7Vo=;
        b=BEVUy5jZHlXSs0ip5v5dOJy1KNg6Hx4dTmJqzdCkvpXE6tcOYaQ/8Zv3IPawN4DXcP
         uNeokKuA6LVVjIdO7zg5Flbdh3666AbDfjkjzsBcIhUugqHp2pxjtLEnP0mJNAcqXcOP
         dEEWkCMcyqorUKG+idbmrrRcn6j0y3oZWtCYllL5ZCwmh+ZtfBsB9qZ44rYJ1C0wrxoy
         2khx1a6wRWYjI5HCH2ItY91VaZggbzXDFmUcI0t/4j0qnqpyId1R7bRb7xmxHwTfajQh
         jnPwSzZAGmePS3e21s7VUTTAgGD1Y1M1pBce54l/fAAF855t+FbjMvbMviPft9ArCF0n
         bQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739897839; x=1740502639;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VQIadInEqZcmDRRaKuQ5fqFZ4vJm04VV/2ZJqNFL7Vo=;
        b=uOB8EJPsRDaxtlpTKan2ZA4X1YhXyTSiqrHa0QngeQ2ucMkauH2qWyMORGuH2ggr7o
         AQ1eKkewc5Yh/r8pdo+5iMmMScz48OX0fCA+LaXMzmb26/G1oLwgDXKTyH0zkY5ZRArA
         OXp7MwtN+iAgz4NeOgV+noNNeTYOpTSv3W/RmMWSjCy0YHH9oI+xkhNXmxR+rR/uy+o8
         8wA9Oi2ezwfBBp5+EhaAA4vFp3VKO0NLB4qXbtp5nKNvnALuO93YUEPiT2WlykJ1mix4
         bmvN36hVafPEuByGcKHdhSMY5O/TOg2+lwri6hlwTo84vVfPLtL9TcT9ogK5KimrIaxQ
         Xc+Q==
X-Gm-Message-State: AOJu0YxWLNFLHOnqeCZGpI3g5ZUT6dqH9CsgkqiQyaED72eUuNBno3uw
	i5i0hf3CUjkFV4H2wO+i+AjglK0SkZ1g9Uy7mqtvIzZ4j1vB3Z82NfFy3RIKkE8mDbTI0BvOS78
	i
X-Gm-Gg: ASbGncsPR0AE0iX+DsoXp0lJzDVrM3pVXfaWduy9mI6+TWKSqbPVJt6Uo0lra8br2Jh
	q8aaLqLJiAekWGZVgyWQoMs/3jwn4RC9YCDrYkZEu7hVJJqtz0ym4jyQHb173wDhGxlfnkRcqZV
	V7MZuDOC4EC8iAtJMlclP2gzw55HlN7CO9gt9PqvLsq+mKe2tkoK62aPJRc6bKs49TEQlZ2xtO6
	MN25FwwJ2TNsZWiK4SerCiZYO2ADKFiupc5Y6LumWHxsbeyqU3UiQlpvqxJ/vm5+Lx4TZpEvME=
X-Google-Smtp-Source: AGHT+IGBkbI5mevWFMlzeDUaPRAhP14dnWLriFA5GQYH4C4r1VlgKI1PqcC5sOkO3Dse4e9RArHdrQ==
X-Received: by 2002:a17:902:d542:b0:216:644f:bc0e with SMTP id d9443c01a7336-2210404f783mr288840545ad.24.1739897838571;
        Tue, 18 Feb 2025 08:57:18 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d5349226sm91790055ad.24.2025.02.18.08.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2025 08:57:18 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>
Subject: [PATCH v1 1/2] io_uring/zcrx: add single shot recvzc
Date: Tue, 18 Feb 2025 08:57:13 -0800
Message-ID: <20250218165714.56427-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250218165714.56427-1-dw@davidwei.uk>
References: <20250218165714.56427-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently only multishot recvzc requests are supported, but sometimes
there is a need to do a single recv e.g. peeking at some data in the
socket. Add single shot recvzc requests where IORING_RECV_MULTISHOT is
_not_ set and the sqe->len field is set to the number of bytes to read
N.

There could be multiple completions containing data, like the multishot
case, since N bytes could be split across multiple frags. This is
followed by a final completion with res and cflags both set to 0 that
indicate the completion of the request, or a -res that indicate an
error.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/net.c  | 26 ++++++++++++++++++--------
 io_uring/zcrx.c | 17 ++++++++++++++---
 io_uring/zcrx.h |  2 +-
 3 files changed, 33 insertions(+), 12 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 000dc70d08d0..d3a9aaa52a13 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -94,6 +94,7 @@ struct io_recvzc {
 	struct file			*file;
 	unsigned			msg_flags;
 	u16				flags;
+	u32				len;
 	struct io_zcrx_ifq		*ifq;
 };
 
@@ -1241,7 +1242,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	unsigned ifq_idx;
 
 	if (unlikely(sqe->file_index || sqe->addr2 || sqe->addr ||
-		     sqe->len || sqe->addr3))
+		     sqe->addr3))
 		return -EINVAL;
 
 	ifq_idx = READ_ONCE(sqe->zcrx_ifq_idx);
@@ -1250,6 +1251,9 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->ifq = req->ctx->ifq;
 	if (!zc->ifq)
 		return -EINVAL;
+	zc->len = READ_ONCE(sqe->len);
+	if (zc->len == UINT_MAX)
+		return -EINVAL;
 
 	zc->flags = READ_ONCE(sqe->ioprio);
 	zc->msg_flags = READ_ONCE(sqe->msg_flags);
@@ -1257,12 +1261,14 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST | IORING_RECV_MULTISHOT))
 		return -EINVAL;
-	/* multishot required */
-	if (!(zc->flags & IORING_RECV_MULTISHOT))
-		return -EINVAL;
-	/* All data completions are posted as aux CQEs. */
-	req->flags |= REQ_F_APOLL_MULTISHOT;
-
+	if (zc->flags & IORING_RECV_MULTISHOT) {
+		if (zc->len)
+			return -EINVAL;
+		/* All data completions are posted as aux CQEs. */
+		req->flags |= REQ_F_APOLL_MULTISHOT;
+	}
+	if (!zc->len)
+		zc->len = UINT_MAX;
 	return 0;
 }
 
@@ -1281,7 +1287,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
-			   issue_flags);
+			   issue_flags, zc->len);
 	if (unlikely(ret <= 0) && ret != -EAGAIN) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1296,6 +1302,10 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 		return IOU_OK;
 	}
 
+	if (zc->len != UINT_MAX) {
+		io_req_set_res(req, ret, 0);
+		return IOU_OK;
+	}
 	if (issue_flags & IO_URING_F_MULTISHOT)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	return -EAGAIN;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index ea099f746599..834c887743c8 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -106,6 +106,7 @@ struct io_zcrx_args {
 	struct io_zcrx_ifq	*ifq;
 	struct socket		*sock;
 	unsigned		nr_skbs;
+	unsigned long		len;
 };
 
 static const struct memory_provider_ops io_uring_pp_zc_ops;
@@ -826,6 +827,10 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	if (args->len == 0)
+		return -EINTR;
+	len = (args->len != UINT_MAX) ? min_t(size_t, len, args->len) : len;
+
 	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
 		return -EAGAIN;
 
@@ -920,17 +925,21 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 out:
 	if (offset == start_off)
 		return ret;
+	args->len -= (offset - start_off);
+	if (args->len == 0)
+		desc->count = 0;
 	return offset - start_off;
 }
 
 static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 				struct sock *sk, int flags,
-				unsigned issue_flags)
+				unsigned issue_flags, unsigned long len)
 {
 	struct io_zcrx_args args = {
 		.req = req,
 		.ifq = ifq,
 		.sock = sk->sk_socket,
+		.len = len,
 	};
 	read_descriptor_t rd_desc = {
 		.count = 1,
@@ -956,6 +965,8 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		ret = IOU_REQUEUE;
 	} else if (sock_flag(sk, SOCK_DONE)) {
 		/* Make it to retry until it finally gets 0. */
+		if (len != UINT_MAX)
+			goto out;
 		if (issue_flags & IO_URING_F_MULTISHOT)
 			ret = IOU_REQUEUE;
 		else
@@ -968,7 +979,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 struct socket *sock, unsigned int flags,
-		 unsigned issue_flags)
+		 unsigned issue_flags, unsigned long len)
 {
 	struct sock *sk = sock->sk;
 	const struct proto *prot = READ_ONCE(sk->sk_prot);
@@ -977,7 +988,7 @@ int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		return -EPROTONOSUPPORT;
 
 	sock_rps_record_flow(sk);
-	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags, issue_flags);
+	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags, issue_flags, len);
 }
 
 #include <linux/io_uring/net.h>
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index a16bdd921f03..85da6a14543f 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -46,7 +46,7 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 struct socket *sock, unsigned int flags,
-		 unsigned issue_flags);
+		 unsigned issue_flags, unsigned long len);
 #else
 static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 					struct io_uring_zcrx_ifq_reg __user *arg)
-- 
2.43.5


