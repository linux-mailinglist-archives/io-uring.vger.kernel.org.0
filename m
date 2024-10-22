Return-Path: <io-uring+bounces-3911-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4FFA9AB114
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 16:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 763C72845BE
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 14:42:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7D5B1A0BD1;
	Tue, 22 Oct 2024 14:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J2Nd4df+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258D919F49C
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 14:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729608165; cv=none; b=PoRSUlyagC4iG/de1P0auuzuE2xs09qkLeRV3HQyYt5GMYMt2ogR9TYtW9WIjSN99tqZR3xGxIwoiuvlfPvh8Kow9mb3Gct4fhMWvdMP6XAPVe9iqR6veatEYIjF99gCqNNfMtXJ4ZCRHJrIssUsM78dt3IJAuxV8M9KyeopeR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729608165; c=relaxed/simple;
	bh=rNGJWymqGy0BJzwu0qxFxqk0iOJl3vElePVs0FY1LaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChLM3PlPPmcSLoYFOl4eNbZcmPFsxKAjmVaW/d77fAzosqTp2ztneFUh47U/U9FMR1ka4EwMXTn4E/kHhAi4fs45Ecz7h2q2Z+5VH36S8+FvQfbBm8VBNQO01/fUp2su/I/4a58XhizzPyA4kO7EBIAanfLTXpDzbMM7pbTCemc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J2Nd4df+; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c40aea5c40so1896032a12.0
        for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 07:42:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729608162; x=1730212962; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F5lAwpEciN4YcPMS8u5Za8JEhBJIL0rRq0tPDhhMWRs=;
        b=J2Nd4df+jEqgpFjU4kaXJovQ6jbiNVYWyUZH00CaDw7K0DXNZOTfwpuHDXheBuf7mr
         gdsXNMB4+bR6d0RsScWWcQMh9PopVoHRZ77fQ/lnJRNl+LS4R335zN7CncWaOGI9MclW
         CagojBDCPGjdSOrbs2tWHrk3dx8ONS20Mthd/HrMbc0Ld13t6qjbL2xVwssD0Onq/HYl
         VSNJE/ORHAO8uy5GymL937KHVPAGadR3fSmeJx8NyxJ6R4Md9KzUnZl+hSATw0Tm5M3J
         XGdrgmTHlOopxotPLZHaYZbtRU0croRk05YqjR9wJEDCv9zHas1DRw+NtVgspZfvSD4E
         O1Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729608162; x=1730212962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F5lAwpEciN4YcPMS8u5Za8JEhBJIL0rRq0tPDhhMWRs=;
        b=eo0dmPS3aWGl/f1fr8Ny2IPIjGJtQGU+tIXFsKs8Ti4sXomMDt+GICV73Gdvazb6SY
         pJq7+dJ2OEpTIHSUsO48kQKozXot7kqL2vG7HSAkf9v98GNyidXs03FWqWA1CesClIID
         ZzwdzP3ZMEmJanfk4kZ5iuBtzsNnYa/nnBC7hr9HBy0OnPeT/KKQKBhP4HS3P+VOpQ1R
         2elTqhmM7gPu76FtRJ3SrW4vBaaqSfj9L+K6BDTBjAhl3x7IcvcpVveYTaMGS2C/qJq7
         gHbf8pXFZuTypuSFIHLZH1DgLvS1OZkjLtZa1e8U5+GW0C8UkStwn7wMJP9Hcy59Pnxr
         gNtQ==
X-Gm-Message-State: AOJu0YxmJfwG3/6k5bPnTgaa9p4X9dUuiIIEku45ISiDrwIB5ZeLwRqz
	eyKhWVk/BsXmzZps3M8FMbNtj78d5KcDq2t5AEcrV7aIj+B0bzIqbdRXCg==
X-Google-Smtp-Source: AGHT+IFbStHA6GKxvSXPcYgJVRo1H030j9QC9w3/WSjA+Iv+v5xOx8jqZmn/afSyZgU6+lZCePPofA==
X-Received: by 2002:a05:6402:35cf:b0:5cb:6b7e:985a with SMTP id 4fb4d7f45d1cf-5cb79451b54mr3673671a12.2.1729608162035;
        Tue, 22 Oct 2024 07:42:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.112])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5cb6696b631sm3244434a12.9.2024.10.22.07.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 07:42:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring/net: don't alias send user pointer reads
Date: Tue, 22 Oct 2024 15:43:14 +0100
Message-ID: <685d788605f5d78af18802fcabf61ba65cfd8002.1729607201.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1729607201.git.asml.silence@gmail.com>
References: <cover.1729607201.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We keep user pointers in an union, which could be a user buffer or a
user pointer to msghdr. What is confusing is that it potenitally reads
and assigns sqe->addr as one type but then uses it as another via the
union. Even more, it's not even consistent across copy and zerocopy
versions.

Make send and sendmsg setup helpers read sqe->addr and treat it as the
right type from the beginning. The end goal would be to get rid of
the use of struct io_sr_msg::umsg for send requests as we only need it
at the prep side.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 4d928017ed2a..7ff2cb771e1f 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -362,6 +362,8 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	u16 addr_len;
 	int ret;
 
+	sr->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
+
 	if (READ_ONCE(sqe->__pad3[0]))
 		return -EINVAL;
 
@@ -389,11 +391,14 @@ static int io_send_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_sendmsg_setup(struct io_kiocb *req)
+static int io_sendmsg_setup(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
 	int ret;
 
+	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+
 	ret = io_sendmsg_copy_hdr(req, kmsg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
@@ -413,7 +418,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EINVAL;
 	}
 
-	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
@@ -439,7 +443,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -ENOMEM;
 	if (req->opcode != IORING_OP_SENDMSG)
 		return io_send_setup(req, sqe);
-	return io_sendmsg_setup(req);
+	return io_sendmsg_setup(req, sqe);
 }
 
 static void io_req_msg_cleanup(struct io_kiocb *req,
@@ -1271,7 +1275,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EINVAL;
 	}
 
-	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	zc->len = READ_ONCE(sqe->len);
 	zc->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL | MSG_ZEROCOPY;
 	if (zc->msg_flags & MSG_DONTWAIT)
@@ -1285,7 +1288,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -ENOMEM;
 	if (req->opcode != IORING_OP_SENDMSG_ZC)
 		return io_send_setup(req, sqe);
-	return io_sendmsg_setup(req);
+	return io_sendmsg_setup(req, sqe);
 }
 
 static int io_sg_from_iter_iovec(struct sk_buff *skb,
-- 
2.46.0


