Return-Path: <io-uring+bounces-6624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BBBE4A40158
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 21:52:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A66317EE7E
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2025 20:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 279A124FC1E;
	Fri, 21 Feb 2025 20:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="nNpCmgLn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC112512FC
	for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 20:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740171121; cv=none; b=Vqkwex3z8mjJlzAqYYH/bSIXIDLUFJ3xWc6oYNe+IIIq5OxH8V1kiC069SC1QgsnRfUMLGCCnwMUyQxqq0eN3reo0hJSIETON4aKkRu4xrltFJfKINDmrtlt/J5x9ZrLHoN4BwFJdT9NuXHcZCNlLBwMqRiFmkGiDfaj5I0CtrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740171121; c=relaxed/simple;
	bh=d+/Diwfn4i0WAzOZ20FeNJXZTFZxEAR1uxgNnSqKxVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b3/fh2n1+C+rArLi14J/e+OpzZ7S82W9IVUpQMAJmgodCch1smnqSzkvJE4J8Rhmpy0wCdjMDOpKQKvstxZi+bljKZimArF1EXUzmsNwQwj8BUPAcSO+nNwO0b0+5UCH9xy8N2/L69m5pcEhSxk5SrA4AHGpfJjg0Z9Islo8Hso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=nNpCmgLn; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-220d132f16dso41698825ad.0
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2025 12:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740171119; x=1740775919; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E2hSAZOe5BATVouZtot34b7CHVyM5RkNqKHCij3Iup0=;
        b=nNpCmgLnYYDcuYFafOaAR1uoIYcbMJnIeoKVs2lu7MQwNyRCu5NT0MPaaUhs0O2wC5
         FwWcwFgvc9VTJMuIBDmZ7s3/HyULu5q4BY4WIMbOQODF1Jv28WODlvwCNDv7n3XHjX7M
         GCeIfa39VZ+KxG8vJYNAWUCF1+9kRQSmK8M2/52G4ft8XkSGaq82jTlyNsTGvaB6FQSH
         Pewf9ibyYqvjHOx2nmyCtzf3XhNugERIWDd/+PmaQE+xFz7/lrpXhsW+3NCdGZRa+qcZ
         QDoJn5zt/05g0AElyTovDovzCZLHA3LxcDpJicIbw8czKVCaYB8tNbFGAYsH9y/jNC6g
         31yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740171119; x=1740775919;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E2hSAZOe5BATVouZtot34b7CHVyM5RkNqKHCij3Iup0=;
        b=KsF+sgZydRlBRSL4nPzVOAxdgKCn1MMj17vHuVuAoZy1ozhPZ2JjH20dylqJZwEPQK
         joRZDWb58ND+lS8JHEIMUmRLhircduBR6DsRCScgUWF8NVzP6ZcLTbb+ykQJ25h5ifYe
         vvEXkDefgFOfKI1dvLGWGTeoxpwF/xelhXCilUMGu+T0xBMFYmK0Ii7N4uR16/5+ayBF
         FDPOnYK6qR6befCmyIOVBFleNK7cFGKVK92UkskBYUEKiUH32LRaWA/kXwqALRcqbwRY
         SobEgJUWZWkUHL48MtvTjSt9HzzkjXEt8leaStyKl+Xqk8/vQDfnrzKKVL6k7XvXKCY9
         LVUQ==
X-Gm-Message-State: AOJu0YzmKkJS3GO5uwdpbcD/KSu9O6TPynvmlPWYg1U1ecBiB8Z3uuYj
	S7j1JwOfl0hSovDA6E5bnjfqs1eFjZCxqDpkDUpb47+7CadXdjfs/dG7+XR+DOTKHLVyZHdCqar
	t
X-Gm-Gg: ASbGnct8di88Dkw20j0y5Mcb76+2NGG6EAdTMMEnTPJy5nHSbaY0C/stg+5HGPOl5Uc
	N7jxsWoquJzFJnlawNZ1ojBDay4f3sUmE//w0+JEv8ZupEw4D87TvYOzI+ACS68mx5HEPDZiRzb
	/AtJK/ljuYk11iNFpkroWb8IeKkoVubEjw5WVRbLDtIPKRQb3iAWYpdT6O7Aybuzt99tfsGsJAU
	O0jjzJ0MjJ1PatJMmyUJBZz2yXPvGlmpCfF/xesftezwI4sHVKaGqTO130up+NciGMpl4e8sDDT
	OFzWnQYrhg==
X-Google-Smtp-Source: AGHT+IHyXwNj70y9kgw+4MTcL9qnHVrGQ57LiXJ7ZPW+QiQBViLFXydwFzt8wVdpyJu/nL+Md7yJwA==
X-Received: by 2002:a05:6a00:4f8c:b0:730:8e2c:e53b with SMTP id d2e1a72fcca58-73426c8e2b8mr6911642b3a.5.1740171118732;
        Fri, 21 Feb 2025 12:51:58 -0800 (PST)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73262567338sm12603649b3a.49.2025.02.21.12.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 12:51:58 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v2 1/2] io_uring/zcrx: add single shot recvzc
Date: Fri, 21 Feb 2025 12:51:45 -0800
Message-ID: <20250221205146.1210952-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250221205146.1210952-1-dw@davidwei.uk>
References: <20250221205146.1210952-1-dw@davidwei.uk>
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
 io_uring/net.c  | 19 +++++++++++++++++--
 io_uring/zcrx.c | 17 ++++++++++++-----
 io_uring/zcrx.h |  2 +-
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 000dc70d08d0..cae34a24266c 100644
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
@@ -1250,6 +1251,12 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->ifq = req->ctx->ifq;
 	if (!zc->ifq)
 		return -EINVAL;
+	zc->len = READ_ONCE(sqe->len);
+	if (zc->len == UINT_MAX)
+		return -EINVAL;
+	/* UINT_MAX means no limit on readlen */
+	if (!zc->len)
+		zc->len = UINT_MAX;
 
 	zc->flags = READ_ONCE(sqe->ioprio);
 	zc->msg_flags = READ_ONCE(sqe->msg_flags);
@@ -1269,6 +1276,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
+	bool limit = zc->len != UINT_MAX;
 	struct socket *sock;
 	int ret;
 
@@ -1281,7 +1289,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
-			   issue_flags);
+			   issue_flags, &zc->len);
 	if (unlikely(ret <= 0) && ret != -EAGAIN) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1296,6 +1304,13 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 		return IOU_OK;
 	}
 
+	if (zc->len == 0) {
+		io_req_set_res(req, 0, 0);
+
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			return IOU_STOP_MULTISHOT;
+		return IOU_OK;
+	}
 	if (issue_flags & IO_URING_F_MULTISHOT)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	return -EAGAIN;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f2d326e18e67..74bca4e471bc 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -817,6 +817,7 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	len = min_t(size_t, len, desc->count);
 	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
 		return -EAGAIN;
 
@@ -894,26 +895,32 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 out:
 	if (offset == start_off)
 		return ret;
+	if (desc->count != UINT_MAX)
+		desc->count -= (offset - start_off);
 	return offset - start_off;
 }
 
 static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 				struct sock *sk, int flags,
-				unsigned issue_flags)
+				unsigned issue_flags, unsigned int *outlen)
 {
+	unsigned int len = *outlen;
+	bool limit = len != UINT_MAX;
 	struct io_zcrx_args args = {
 		.req = req,
 		.ifq = ifq,
 		.sock = sk->sk_socket,
 	};
 	read_descriptor_t rd_desc = {
-		.count = 1,
+		.count = len,
 		.arg.data = &args,
 	};
 	int ret;
 
 	lock_sock(sk);
 	ret = tcp_read_sock(sk, &rd_desc, io_zcrx_recv_skb);
+	if (limit && ret)
+		*outlen = len - ret;
 	if (ret <= 0) {
 		if (ret < 0 || sock_flag(sk, SOCK_DONE))
 			goto out;
@@ -930,7 +937,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		ret = IOU_REQUEUE;
 	} else if (sock_flag(sk, SOCK_DONE)) {
 		/* Make it to retry until it finally gets 0. */
-		if (issue_flags & IO_URING_F_MULTISHOT)
+		if (!limit && (issue_flags & IO_URING_F_MULTISHOT))
 			ret = IOU_REQUEUE;
 		else
 			ret = -EAGAIN;
@@ -942,7 +949,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 struct socket *sock, unsigned int flags,
-		 unsigned issue_flags)
+		 unsigned issue_flags, unsigned int *len)
 {
 	struct sock *sk = sock->sk;
 	const struct proto *prot = READ_ONCE(sk->sk_prot);
@@ -951,5 +958,5 @@ int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		return -EPROTONOSUPPORT;
 
 	sock_rps_record_flow(sk);
-	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags, issue_flags);
+	return io_zcrx_tcp_recvmsg(req, ifq, sk, flags, issue_flags, len);
 }
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index a16bdd921f03..1b4042dc48e2 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -46,7 +46,7 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx);
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx);
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 struct socket *sock, unsigned int flags,
-		 unsigned issue_flags);
+		 unsigned issue_flags, unsigned int *len);
 #else
 static inline int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 					struct io_uring_zcrx_ifq_reg __user *arg)
-- 
2.43.5


