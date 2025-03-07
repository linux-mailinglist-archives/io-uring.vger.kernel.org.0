Return-Path: <io-uring+bounces-7023-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B531DA57083
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 19:28:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 34712189B932
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 18:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 883B023E242;
	Fri,  7 Mar 2025 18:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BcsdT38e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C478123BCFA
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 18:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741372108; cv=none; b=U5/feL4o6xL6fj0UZAibQBjwz7JupofeIFUPkGhtgtTZOIl9+EBkoH+HvS2/MeX4rEnLSPAkmtA9HifwKmCmUEu9gChduVarzU2ry53sGwybjNr3nedI2BkEWk+7fiGV4kpGyBW7baMFjO01E84/XBjJfAIGtf9roMb6fmVzkKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741372108; c=relaxed/simple;
	bh=8g9zRX6sHAB3sw6JN99B9kMYnKKz/dlCYEj7U1/xouE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvK8qfFrBz64+nBlzO1qq2tSZWgONUeRnWQWtQcSkzmpCP7A38Oj3DU/MgOrb5bOvOFrpzUfl7pCHKr85Qik+DpI73lANd6osv6bCZrMGdLOLPuAQCHd3AR49ILR4bTR2LmdcA4oScIYaK897FfrgiltPcXzQ9HKjySehxqQl0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BcsdT38e; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5e058ca6806so4214781a12.3
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 10:28:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741372105; x=1741976905; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8WP4++kaTGZ4gQVnE5wRyc3mctW9Uz2qpENJImUi5S4=;
        b=BcsdT38eJIqm9Ik41HF9aXCeI9rfBtzYgE15WNl9ehtnnF2sOpuC+yaindBxbdBtzb
         LGe4QjkYLoapw3dPNgQcD8RbF/60NCh96JZ0dowsSpp4ntw/NKCAvklgSNn44PxUVuru
         blDQpR109jf8DaEO6YizsnUTW7mpPS5+Ck67+xKy1HO2vEuDEb4a8DWDXUroIrPKGJKF
         ntEmiJMV4iOUB+eyWglVGHtefhFnsyZbmIqvV0eqtK9JJdXAgFy/fL9zLnFn/10yOoL7
         JnQwVmV+GBRGmtCnqEVs8F5b3zAjEwe4IqsSrGSjBZ3csb/G2CTcixalyGyjYSV/np64
         JWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741372105; x=1741976905;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8WP4++kaTGZ4gQVnE5wRyc3mctW9Uz2qpENJImUi5S4=;
        b=guWGrAnq5JS8vHz23uNBSCYo9HgnNAsoi30iTSJWf3dTE8nPO0oSoiAZ8GqhgVPxUP
         NaUZpHl5c0jJag37f9A+2VCs8K6a+ZCAof5j48A6JgznSnFyd/7gY7l23AP453TA7tPu
         aIFWNH2T0Clht4zBT2tEzcXhPA8AUly/sl/t6h0T5Os0mZEIWMDz2R+TqhhCFfUDrN+T
         YEiWNyQcUfJhjRzaxBh8hf2JJgCYdjp6JKM0S+wt/LEppAzpce5NR5kPCD+aNub2YwFD
         va7/cVqBdcTOmxp6PAbaClu4q5pDfWspkIDeqzCvfQ2trwVfXAlagNB2jaAwQN5sVf8n
         8C3Q==
X-Gm-Message-State: AOJu0YwS/vv9NyMBRzjTN9nJ2R6x6QZjnDFDnG/Yxa9fBhFUAiwLez4M
	IBI+aBNFunb+Cx8LgZRzTKI4run0tc/YjAzNqA6TCdpE2i0JjLJnqgFn+g==
X-Gm-Gg: ASbGncs+4hGGFbijWrqXV2TYDDcEUhstAUnyx2lQpZEl6lbJqHK1kD3wn6KPgS9F7Ba
	Z0BDKLktQfECAZ8uihg/x5RMk4sSRE/jIrtLQmOiYKuqyNjuYd5vT6x0hToqsAtCJazPEEgeOzt
	kNHidf7DD09e99K2EOKGY0w0L6dQtvf6whZR7ATRlAylb8Ki+5FXqFRTza++j6BZvVCHPvkSScj
	4+VfqlHMbjFGwruLpRv1gv8CvcAJ72oDj7cDRuJ/ovSwi6elhMXR1IC/UFm2J2+D8D4nuDpe5To
	YWlUHcFE4pFn7LaLQSIh3MxHGco70LsGukuF+QVm3kOmjIS5DMNkTRnIzQ==
X-Google-Smtp-Source: AGHT+IEBFcYyeDRCkTpMTF7olUDzL59N4kF633L43rJW8IL+C3+7sCDWlFmGutSjimkQiZwveR0kuw==
X-Received: by 2002:a05:6402:2750:b0:5e5:49af:411d with SMTP id 4fb4d7f45d1cf-5e5e22da050mr6789905a12.17.1741372104359;
        Fri, 07 Mar 2025 10:28:24 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.206])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c74a9315sm2883230a12.46.2025.03.07.10.28.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 10:28:23 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing v2 1/4] Add vectored registered buffer req init helpers
Date: Fri,  7 Mar 2025 18:28:53 +0000
Message-ID: <2ca386bcdbfe1518822f372f4462c346a40bc4a3.1741372065.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741372065.git.asml.silence@gmail.com>
References: <cover.1741372065.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h | 31 +++++++++++++++++++++++++++++++
 src/liburing-ffi.map   |  3 +++
 2 files changed, 34 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index d162d0e6..ae2021b9 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -556,6 +556,16 @@ IOURINGINLINE void io_uring_prep_read_fixed(struct io_uring_sqe *sqe, int fd,
 	sqe->buf_index = (__u16) buf_index;
 }
 
+IOURINGINLINE void io_uring_prep_readv_fixed(struct io_uring_sqe *sqe, int fd,
+					     const struct iovec *iovecs,
+					     unsigned nr_vecs, __u64 offset,
+					     int flags, int buf_index)
+{
+	io_uring_prep_readv2(sqe, fd, iovecs, nr_vecs, offset, flags);
+	sqe->opcode = IORING_OP_READV_FIXED;
+	sqe->buf_index = (__u16)buf_index;
+}
+
 IOURINGINLINE void io_uring_prep_writev(struct io_uring_sqe *sqe, int fd,
 					const struct iovec *iovecs,
 					unsigned nr_vecs, __u64 offset)
@@ -580,6 +590,16 @@ IOURINGINLINE void io_uring_prep_write_fixed(struct io_uring_sqe *sqe, int fd,
 	sqe->buf_index = (__u16) buf_index;
 }
 
+IOURINGINLINE void io_uring_prep_writev_fixed(struct io_uring_sqe *sqe, int fd,
+				       const struct iovec *iovecs,
+				       unsigned nr_vecs, __u64 offset,
+				       int flags, int buf_index)
+{
+	io_uring_prep_writev2(sqe, fd, iovecs, nr_vecs, offset, flags);
+	sqe->opcode = IORING_OP_WRITEV_FIXED;
+	sqe->buf_index = (__u16)buf_index;
+}
+
 IOURINGINLINE void io_uring_prep_recvmsg(struct io_uring_sqe *sqe, int fd,
 					 struct msghdr *msg, unsigned flags)
 {
@@ -964,6 +984,17 @@ IOURINGINLINE void io_uring_prep_sendmsg_zc(struct io_uring_sqe *sqe, int fd,
 	sqe->opcode = IORING_OP_SENDMSG_ZC;
 }
 
+IOURINGINLINE void io_uring_prep_sendmsg_zc_fixed(struct io_uring_sqe *sqe,
+						int fd,
+						const struct msghdr *msg,
+						unsigned flags,
+						unsigned buf_index)
+{
+	io_uring_prep_sendmsg_zc(sqe, fd, msg, flags);
+	sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+	sqe->buf_index = buf_index;
+}
+
 IOURINGINLINE void io_uring_prep_recv(struct io_uring_sqe *sqe, int sockfd,
 				      void *buf, size_t len, int flags)
 {
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index 294d2abf..75c9e9bd 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -230,4 +230,7 @@ LIBURING_2.10 {
 	global:
 		io_uring_register_ifq;
 		io_uring_prep_epoll_wait;
+		io_uring_prep_writev_fixed;
+		io_uring_prep_readv_fixed;
+		io_uring_prep_sendmsg_zc_fixed;
 } LIBURING_2.9;
-- 
2.48.1


