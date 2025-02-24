Return-Path: <io-uring+bounces-6652-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 864ADA4146A
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 05:13:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2896188F67C
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2025 04:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D0DC1A840E;
	Mon, 24 Feb 2025 04:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="SgOMqChl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09471A3153
	for <io-uring@vger.kernel.org>; Mon, 24 Feb 2025 04:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740370409; cv=none; b=V94M2O/6IybcgaWbayrGjcz3AC0xlfQfQGpidgaBcSEpbCiSsDwX4NkdngWle4DubkASSShlwiBBxy/xCHdXLUYOJkjY/K+/yMtCfSA9eDcRTPA7njp29nvAApW6VNA/pHRTxeicKC9ndNLE77jd46QKyMHQ9Z5RaobKBwB+6hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740370409; c=relaxed/simple;
	bh=qoGJuhfAM/GrrI6Ad3pf+lICUybgMkjrvfjx6jpWUkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frXMhR9njLMlDBo5wzEsz/ZFXCDyuIyJ4OyBYLJ7E318yiAvvM8uvjF3dtylqMlmshOQVN/NgojCQ+sVJOPtCnB1Nlt9pKWuF68U+bkckV4vt7/PfTFQYrLnpL7LebIXYP/GyEjkQowsWCqKD74PiopqOsc/XlG3F0f9UojZeO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=SgOMqChl; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-220ecbdb4c2so107382355ad.3
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2025 20:13:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1740370407; x=1740975207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=309qxo+NF552Sxk1loXw1Qhg/8BIp4mW5450HVTYn6A=;
        b=SgOMqChl8r148RY4hMAHwf9Cq3e0mWCAiAcIiLmj7g82oHZkR8gGIlvDTsPYUTJ6Vb
         S12PVumHjVaH5d6c6EYKIULn7tV/WwEX1JhQUcBkEy7gSzMpRaOAEHAt/lQOzaCrS0fD
         0VD9K3kRAZ7SDicsI8i8bvFH1wtZfjvoEML4WY84bpcOBlb0ofphfH6x34/mqfjAZOiw
         wqQK41E8b3zpr3MfrdP97jMxyInj4/KW9e9NLqc6RvsLnp0t1Zjwb0oR0tC1U2ezdys4
         W+tdqKGes3XJlN+bZl/DfdqH8SR6vQd3lDWifwuisY2vVRBW5pqZehD0F/n6n8VDl+oG
         2/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740370407; x=1740975207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=309qxo+NF552Sxk1loXw1Qhg/8BIp4mW5450HVTYn6A=;
        b=V3RPUxqSURksZd9cZ/AGyARDLyeYjJKYtCBFWyRe4qQlqBesOEQ1ClzqqW51BaR6qF
         O26wiyBFfmu3Tg/V2LkRjb1Fl/x+6NDrFDcnPFUYg1Iquz9EEqo4m0NNEH5eONmEDbLO
         QYe8wSlcaMoU++g6wy7hXGSGkqu2OasMkgVhtHTVZxt3nJ0w1cVHX4CpQ45gNIguU4Fq
         MHXhb+raOV3gG4io7nauaSEEjRlyR5No0WZdx6qGX2izURHOadZp61gb91fcXEDrz+zT
         fFw+RMx77ZkfbGDBUdhMMzPIIPKAyauFamOpaqmnabV2TU57AhGS8pGes8wFuOJf2ExS
         ayIA==
X-Gm-Message-State: AOJu0YzeA58aojzaodUJexP86RItUWcTofAMTVx06AJ89WUlwJjyMYMZ
	TqK3dafz1WdM399QR+rjP9xIO5Vz4Hq5iB3M2H5+YSxiwVyLWR7WSDd5lOhUKx0bbjI0gFiBSYP
	6
X-Gm-Gg: ASbGncv6NMXUJKpAFqHxpI3fEqyX0swLi46MB4bIoZuFiK+l6931I6dUX5bJOi3dXE2
	SL11jbPdfa7dbc5woAoqUlJdKhhruw1/cOJy++4XyDZ/Wvx3/2PdNf0OkUvdYsZHy0/UDISDNrc
	FdQH2capv27CuIkgnAjlJKZ/3Y+SQqNsGAz0Ue76FoarXXT//FhVcw8EBWIjcH26U1jAKnml3uD
	5h3nDmtrpSZK3XWzIo1WuEQfHFQdjMJA+b6pty/jTuPCXlG3qvUTv1vP5dbY8xs/7EeuAL8VRHI
	PpFxwxhGl1s=
X-Google-Smtp-Source: AGHT+IHCBiLAs1JeLQLRY84VtQJWcZUtv1VwVqRBLEPf2Ws/C8bUz37vTxf9QADjFzL/XXAZYUmXVw==
X-Received: by 2002:a17:902:e546:b0:220:cd9a:a167 with SMTP id d9443c01a7336-221a0ec3cf2mr233629695ad.4.1740370407138;
        Sun, 23 Feb 2025 20:13:27 -0800 (PST)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d545d498sm171508325ad.134.2025.02.23.20.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2025 20:13:26 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	lizetao <lizetao1@huawei.com>
Subject: [PATCH v3 1/2] io_uring/zcrx: add a read limit to recvzc requests
Date: Sun, 23 Feb 2025 20:13:18 -0800
Message-ID: <20250224041319.2389785-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250224041319.2389785-1-dw@davidwei.uk>
References: <20250224041319.2389785-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently multishot recvzc requests have no read limit and will remain
active so as long as the socket remains open. But, there are sometimes a
need to do a fixed length read e.g. peeking at some data in the socket.

Add a length limit to recvzc requests `len`. A value of 0 means no limit
which is the previous behaviour. A positive value N specifies how many
bytes to read from the socket.

Data will still be posted in aux completions, as before. This could be
split across multiple frags. But the primary recvzc request will now
complete once N bytes have been read. The completion of the recvzc
request will have res and cflags both set to 0.

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/net.c  | 16 +++++++++++++---
 io_uring/zcrx.c | 13 +++++++++----
 io_uring/zcrx.h |  2 +-
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 000dc70d08d0..4850d4d898f9 100644
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
@@ -1250,7 +1251,7 @@ int io_recvzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	zc->ifq = req->ctx->ifq;
 	if (!zc->ifq)
 		return -EINVAL;
-
+	zc->len = READ_ONCE(sqe->len);
 	zc->flags = READ_ONCE(sqe->ioprio);
 	zc->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (zc->msg_flags)
@@ -1270,6 +1271,7 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_recvzc *zc = io_kiocb_to_cmd(req, struct io_recvzc);
 	struct socket *sock;
+	unsigned int len;
 	int ret;
 
 	if (!(req->flags & REQ_F_POLLED) &&
@@ -1280,8 +1282,16 @@ int io_recvzc(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
+	len = zc->len;
 	ret = io_zcrx_recv(req, zc->ifq, sock, zc->msg_flags | MSG_DONTWAIT,
-			   issue_flags);
+			   issue_flags, &zc->len);
+	if (len && zc->len == 0) {
+		io_req_set_res(req, 0, 0);
+
+		if (issue_flags & IO_URING_F_MULTISHOT)
+			return IOU_STOP_MULTISHOT;
+		return IOU_OK;
+	}
 	if (unlikely(ret <= 0) && ret != -EAGAIN) {
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f2d326e18e67..9c95b5b6ec4e 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -817,6 +817,7 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 	int i, copy, end, off;
 	int ret = 0;
 
+	len = min_t(size_t, len, desc->count);
 	if (unlikely(args->nr_skbs++ > IO_SKBS_PER_CALL_LIMIT))
 		return -EAGAIN;
 
@@ -894,26 +895,30 @@ io_zcrx_recv_skb(read_descriptor_t *desc, struct sk_buff *skb,
 out:
 	if (offset == start_off)
 		return ret;
+	desc->count -= (offset - start_off);
 	return offset - start_off;
 }
 
 static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 				struct sock *sk, int flags,
-				unsigned issue_flags)
+				unsigned issue_flags, unsigned int *outlen)
 {
+	unsigned int len = *outlen;
 	struct io_zcrx_args args = {
 		.req = req,
 		.ifq = ifq,
 		.sock = sk->sk_socket,
 	};
 	read_descriptor_t rd_desc = {
-		.count = 1,
+		.count = len ? len : UINT_MAX,
 		.arg.data = &args,
 	};
 	int ret;
 
 	lock_sock(sk);
 	ret = tcp_read_sock(sk, &rd_desc, io_zcrx_recv_skb);
+	if (len && ret > 0)
+		*outlen = len - ret;
 	if (ret <= 0) {
 		if (ret < 0 || sock_flag(sk, SOCK_DONE))
 			goto out;
@@ -942,7 +947,7 @@ static int io_zcrx_tcp_recvmsg(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 
 int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 		 struct socket *sock, unsigned int flags,
-		 unsigned issue_flags)
+		 unsigned issue_flags, unsigned int *len)
 {
 	struct sock *sk = sock->sk;
 	const struct proto *prot = READ_ONCE(sk->sk_prot);
@@ -951,5 +956,5 @@ int io_zcrx_recv(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
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


