Return-Path: <io-uring+bounces-7294-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 641D7A752D0
	for <lists+io-uring@lfdr.de>; Sat, 29 Mar 2025 00:10:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 716D2188FFCB
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 23:11:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D94F1EFF84;
	Fri, 28 Mar 2025 23:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c67AX/76"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D081F4C9E
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 23:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743203434; cv=none; b=WlHf22q86Kuj0kEs8PzqTBYh6mbLbDXjxQZvPX3RKjchG4p+L2vskOA/d6OAUoKPhZsNYIE6QbSKpyOUzOaZXRM+8AFG03CEkxhGqSQl2o9WEbpkdadddT7oaC4ySSI7/3r3gaa9XYbkSGrPYyPvy/0u6RTZKyrnSCfSfQ7irLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743203434; c=relaxed/simple;
	bh=ekDm7thqp/NdUIke9Zh/E7lpnAedleXFaIYXqLJfp0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5e0ihpkDzPmBgMg4nqV2d/MiR4XEgc6u5Np8pKRQzQXYnsuJYPYs3TOV0Lpaz5ygrGPy4ypWrZUVXSMPNuX+x3+PACHbkn0jMPQygeJ9hH7VNJi8mN9psyh4YQfst6IYpIYqz+IYjpH9Owk9hm4IPXrrw7axRe9I0prpzTOSR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c67AX/76; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ac2902f7c2aso456663766b.1
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 16:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743203430; x=1743808230; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6zjwoAz4Y23GOKZIoKGgRu48Sf407dlcgecALR70baY=;
        b=c67AX/76FjcjwYA6WtGMgDplPwlZF1+lidIIoSs93jmX41ntdR81vJqj+1zirK7kvM
         2XA4AThBSXGjdkLBM+yJ6gMVM8igh+vTdC15JcbWqpgL/bDvRhlyEibatrq+byUFmULf
         IHIiyQ68TYNkKqrONzPjbOrPaUbOVFKcFhrDLaTYlkihCiy6QzCgZRm6w7dGtr+lJ4zL
         gwkxJXF0FUPrnBx6Qq7BzYT1fBjTXEcLoCsQx5zEqJiWHRl3jeWPyzuhDLDmRkJ4stTO
         cwevzKE6r4A6tpiPpJOvp1pI2T16hxFUSZEIuqRyyLuPPmjRz5vHKlp7tyjumcPTAsKH
         FClA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743203430; x=1743808230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6zjwoAz4Y23GOKZIoKGgRu48Sf407dlcgecALR70baY=;
        b=ewhNtF08wmvGFdhsMlxaVJY09Dgnz6rAGOIVZ9pr4aDUpjysYx7evzbmcf9tGDVf00
         UPr/nXzXOuZH3OfmOLTNcpohBDPbOrBqasK21EEkgHsBFR8zBKjkwHKkfPXkNnTzZ+sf
         5hMZMWrxs2rR+UjMEGLQ/qXySCAbRGlLoSbrhdtLizwE47r2gX26Wo5KbkVX/zj5vxdS
         fK3Eii35PFK1S+2R3ZjsKaj7nbaZeQAoWCm2qxRcnikDSubHyBdXW/ooW/acHAziwR/T
         D0SbS9QqEyUuxbywFTi4WiR5Gw8tFEyUryNYmhQ4CEvH5Vo/s/cTW5+0HYpTd7Mez1bi
         XniQ==
X-Gm-Message-State: AOJu0YzSUEmt2JnBDan2HPzBF54iF8EfrblIVAjRUGs62FJpTxh3yoBE
	UunGiYPwOVQB7aoYgmAnoAkLr53meFV3jjj7BBuslKxb+KuUVlhAc/uE/g==
X-Gm-Gg: ASbGnctO2UoFJ4RiDf0UDvFVEz4+AhjKijz0Oyp+K5hVEZVpPAkp14OTViOsDm0MDFn
	+bXXjzSa+Me2cMt0M+MjNivbzdApk6mc8mZGAAUYKOFMxPbCwauhSTi136gBwMC7ciPrW5xY88h
	7ShJfsxpfMY/QWAGs4lpUnKgZWWXD+NG1d7zMVMX6EYIsw2Zi7oANLfm+Nt4yKAdVDet7s5YaW5
	UDgtLvwz9y1YRsUo/ABD0K1GKNDtDKV/e3xXk/HGIfBS+FizivGm5YQt/Q0tpnM66eVz3HsnxMW
	H9vYL2zn89gBiFJdRZVPg9KHlMHjXX4gJSFw9lBbsb/yz0+vYDMt2RXZiaA=
X-Google-Smtp-Source: AGHT+IHDevLnVAQqp3mGTfpMeQJ7mqGvXsMZKj1iAB0+kMkcFvTxu5+WgSOibRT91rHF58kPCCBKag==
X-Received: by 2002:a17:907:7e82:b0:ac3:cc9b:5b6d with SMTP id a640c23a62f3a-ac7389edcf6mr102597166b.16.1743203429994;
        Fri, 28 Mar 2025 16:10:29 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.232])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac71961f04dsm228915966b.91.2025.03.28.16.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:10:29 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 7/7] io_uring/net: import zc ubuf earlier
Date: Fri, 28 Mar 2025 23:11:00 +0000
Message-ID: <eb54f007c493ad9f4ca89aa8e715baf30d83fb88.1743202294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743202294.git.asml.silence@gmail.com>
References: <cover.1743202294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_send_setup() already sets up the iterator for IORING_OP_SEND_ZC, we
don't need repeating that at issue time. Move it all together with mem
accounting at prep time, which is more consistent with how the non-zc
version does that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index f3eaa35d9de3..f8dfa6166e3c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1319,23 +1319,23 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(!iomsg))
 		return -ENOMEM;
 
-	if (zc->flags & IORING_RECVSEND_FIXED_BUF)
-		iomsg->msg.sg_from_iter = io_sg_from_iter;
-	else
-		iomsg->msg.sg_from_iter = io_sg_from_iter_iovec;
-
 	if (req->opcode == IORING_OP_SEND_ZC) {
-		req->flags |= REQ_F_IMPORT_BUFFER;
-		return io_send_setup(req, sqe);
+		if (zc->flags & IORING_RECVSEND_FIXED_BUF)
+			req->flags |= REQ_F_IMPORT_BUFFER;
+		ret = io_send_setup(req, sqe);
+	} else {
+		if (unlikely(sqe->addr2 || sqe->file_index))
+			return -EINVAL;
+		ret = io_sendmsg_setup(req, sqe);
 	}
-	if (unlikely(sqe->addr2 || sqe->file_index))
-		return -EINVAL;
-	ret = io_sendmsg_setup(req, sqe);
 	if (unlikely(ret))
 		return ret;
 
-	if (!(zc->flags & IORING_RECVSEND_FIXED_BUF))
+	if (!(zc->flags & IORING_RECVSEND_FIXED_BUF)) {
+		iomsg->msg.sg_from_iter = io_sg_from_iter_iovec;
 		return io_notif_account_mem(zc->notif, iomsg->msg.msg_iter.count);
+	}
+	iomsg->msg.sg_from_iter = io_sg_from_iter;
 	return 0;
 }
 
@@ -1393,25 +1393,13 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
-	int ret;
 
-	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
-		sr->notif->buf_index = req->buf_index;
-		ret = io_import_reg_buf(sr->notif, &kmsg->msg.msg_iter,
-					(u64)(uintptr_t)sr->buf, sr->len,
-					ITER_SOURCE, issue_flags);
-		if (unlikely(ret))
-			return ret;
-	} else {
-		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
-		if (unlikely(ret))
-			return ret;
-		ret = io_notif_account_mem(sr->notif, sr->len);
-		if (unlikely(ret))
-			return ret;
-	}
+	WARN_ON_ONCE(!(sr->flags & IORING_RECVSEND_FIXED_BUF));
 
-	return ret;
+	sr->notif->buf_index = req->buf_index;
+	return io_import_reg_buf(sr->notif, &kmsg->msg.msg_iter,
+				(u64)(uintptr_t)sr->buf, sr->len,
+				ITER_SOURCE, issue_flags);
 }
 
 int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
-- 
2.48.1


