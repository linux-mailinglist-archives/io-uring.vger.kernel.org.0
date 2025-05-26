Return-Path: <io-uring+bounces-8107-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77898AC3AAB
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 09:31:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 45E6E1734BE
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 07:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4829114D2B7;
	Mon, 26 May 2025 07:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2h6mzN9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615B41E0DDC
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 07:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244690; cv=none; b=dQQEyLKr2Xv/3vGJFYUlIC4adxX0amwJsu4hIEjP0/zlAWelC6XiT+DcS8R5K973RuZjihl1fZtN7Qc3zJWFJiI9nbeuqcJAQMz65vTu0Yz66Et8DzgQHsBL/o4XoYLv2pOIVtiWEfkX4CJcsweT7pJvXcjr4CyHMOyfDZYuYMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244690; c=relaxed/simple;
	bh=1DRaynj9j8BgvSTSEp4313pd64mn65mCmB5MAvHYNtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcmLVqnrVK9ne47ia3OEZspooEk+E5/srzX0VmBwxQR7dqzQyYB16YN/oi6wJc50qZq04+8JjRNjWH52yZTblkUtgjBHtKp28Tnk/BX1MPI/UnluqLi+GH86CCsLkldwBjGPzIkSYhVjo1PWOee6+BjLj6XwLVN55OcnuQ8fc44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N2h6mzN9; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ad5566ac13cso279878166b.1
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 00:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748244686; x=1748849486; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irYJce+EvtEnXB4j4INEhsLH3ZIrFkTm7L8DKSMVAno=;
        b=N2h6mzN9SN8+B7TIePam1bLNBER2st84mJA6XBvNT/NOBo4Bm2qcyw2J6kvnepAm0r
         TnO02vOKSYP8umapcqE7YwB2FFg45W9SbjzwKbZImF8cKHbf+CtR9heMMlzuJoGHGkQs
         UwqLC2cmScq2OTwYApiHoF704m8nCg4y0d7Z2RBqCKJkmiveVlKDwAoivX943B7CB7xi
         aSBIe8BS2bsrq642mFARS78MQwly+vGFwDzcTZYQ+Klan68B4y80FdSi/ATEuMaPBle7
         KNSmeQmgWEfsg7r64dLqzbN0QrjewHhRLu0g1XuPW2rNrCPHGxKXzk2izGN1Qx7PbP3g
         2Uqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748244686; x=1748849486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=irYJce+EvtEnXB4j4INEhsLH3ZIrFkTm7L8DKSMVAno=;
        b=MzvePuXHtycI8OpRz637SSsc0LxUEJe9LaExJQe//JGtGwGAhAXsgy5lykZlNb7EWx
         VBK4IEFMpOtSLxGBpzJAzglFSI9YlY3JPB/aYcvVdh0hniZcyqQE7Gk5tOsSzq+WSYvj
         w/kwyEn6v9avj1Zh0TtGzyyYV+Cgo3gGTSmC5v7UyCeEVg85/Z2Y5YDFgQVzsqF9q8dt
         jt1vGmBokd5t+d9USiQ/HUgiQXvShL3Wm+ObE/J0H13V8tsVCz4lzxq72M/qUcSeHfB1
         Hs36gkQ8BrilOzVszheiX5g0lWxKQHX1UxOYrtDJsluGQfhjIwTtpRykmtfKRiODUmqG
         JrSQ==
X-Gm-Message-State: AOJu0YyyAiA9UvF8H9m5DGyG0Xgwba/JAuHbzYYQ5WpXuGf5tAScvbcz
	xrQnsHs2vQ2B++y3xrM4RoEO94XAkTY7FouOoFDC6RT2aOZUlBhupjVB+6iIKg==
X-Gm-Gg: ASbGncvBeqriVZRBKxrn5P+0QcsgnMNXRMejEi8mv0SmuxTppAxmY7C4GhJIGR/mjC3
	rCdQU6nT2QSoeg3bdwn9OJaDitEn5RY9MSSRG4meILl87lBKx+ENWwdQxIdn6+kNdLp64NHdKoB
	sH+t4y3J3iPaIG2M2XNwVzI9gjQowo/gD8RYnTGW9KCAOHZhEbXnj6BKN9JgJuInjx65d/P/F2L
	gQ3DFVilGwhp1hmSiHWyz3xu+fTpls3RnbYyTW79K7q64FLQRfFQBKSD3wgQMhqZsnQkQMvy5mp
	2GxfK9Vt3C7Wlh5vok9ty2SNN9kKoSEkB7rrcmbSf0IwMTjeeS75YqFLC8FLccFCQnBZSsWcHgM
	=
X-Google-Smtp-Source: AGHT+IEIAf51RJaZi770LHSiGsv6mzmfaqyikJYhNE68enWNIVCUkxEnNEa1W5cW81mZSWkekMfbFA==
X-Received: by 2002:a17:907:7f8a:b0:ad5:b18f:8898 with SMTP id a640c23a62f3a-ad85b0a573fmr690207966b.30.1748244686296;
        Mon, 26 May 2025 00:31:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad8816eb7e3sm12395166b.50.2025.05.26.00.31.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 00:31:25 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH v2 4/6] io_uring/mock: allow to choose FMODE_NOWAIT
Date: Mon, 26 May 2025 08:32:26 +0100
Message-ID: <71ee6d78ace8889d49fa50c0a4e25b5fc1b985be.1748243323.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748243323.git.asml.silence@gmail.com>
References: <cover.1748243323.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an option to choose whether the file supports FMODE_NOWAIT, that
changes the execution path io_uring request takes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 8 +++++++-
 io_uring/mock_file.h | 5 +++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index eaecad34ef03..6b9f1222397c 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -122,6 +122,8 @@ static const struct file_operations io_mock_fops = {
 	.llseek		= io_mock_llseek,
 };
 
+#define IO_VALID_CREATE_FLAGS (IORING_MOCK_CREATE_F_SUPPORT_NOWAIT)
+
 static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	const struct io_uring_sqe *sqe = cmd->sqe;
@@ -142,7 +144,9 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	memset(&mc, 0, sizeof(mc));
 	if (copy_from_user(&mc, uarg, uarg_size))
 		return -EFAULT;
-	if (!mem_is_zero(mc.__resv, sizeof(mc.__resv)) || mc.flags)
+	if (!mem_is_zero(mc.__resv, sizeof(mc.__resv)))
+		return -EINVAL;
+	if (mc.flags & ~IO_VALID_CREATE_FLAGS)
 		return -EINVAL;
 	if (mc.file_size > SZ_1G)
 		return -EINVAL;
@@ -165,6 +169,8 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	file->f_mode |= FMODE_READ | FMODE_CAN_READ |
 			FMODE_WRITE | FMODE_CAN_WRITE |
 			FMODE_LSEEK;
+	if (mc.flags & IORING_MOCK_CREATE_F_SUPPORT_NOWAIT)
+		file->f_mode |= FMODE_NOWAIT;
 
 	mc.out_fd = fd;
 	if (copy_to_user(uarg, &mc, uarg_size)) {
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index 85be7597c8db..224226abe23c 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
@@ -6,6 +6,7 @@
 enum {
 	IORING_MOCK_FEAT_CMD_COPY,
 	IORING_MOCK_FEAT_RW_ZERO,
+	IORING_MOCK_FEAT_RW_NOWAIT,
 
 	IORING_MOCK_FEAT_END,
 };
@@ -15,6 +16,10 @@ struct io_uring_mock_probe {
 	__u64		__resv[9];
 };
 
+enum {
+	IORING_MOCK_CREATE_F_SUPPORT_NOWAIT			= 1,
+};
+
 struct io_uring_mock_create {
 	__u32		out_fd;
 	__u32		flags;
-- 
2.49.0


