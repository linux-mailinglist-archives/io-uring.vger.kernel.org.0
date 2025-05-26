Return-Path: <io-uring+bounces-8106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CF397AC3AAA
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 09:31:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 712367A2346
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 07:30:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 278B81E130F;
	Mon, 26 May 2025 07:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k3dw3gqP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361561DF270
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 07:31:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244689; cv=none; b=dXUmgIbPFv+Rygt8MM0VVqJ9dJ7FSYKUrosplShxVtIAIJmikHD4j3e06n6xC4zhDT6rt23Gz8zV2JWIEJV+N9Nhd9EFVLlE3au/AWcUUnPAwqdfDfDVW42R9Un6IGN8Gw6nhR7tRBBJQoWamaHakW/DTxF3mXMKE+J6if0rfCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244689; c=relaxed/simple;
	bh=35AZYdg4J0r6ittgurqKQICiwBIJX9nvm4pGjOAUrNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p6uyef6jip7AYh+lmD8ugxXAC346wNQ0fk71rRQspMM80WYuidQdjnzLPEwBwFjiQv6nU6ciCoTTDPfpAKYf5W6D2tRJCJ7fjRTAFRmINBvpXwIRh9Q499IL1CUbJ46fypbUNZP9gXO4Ufy5VeQdjd/n6aHoai6KBhfsBJpaaEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k3dw3gqP; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ac34257295dso394043966b.2
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 00:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748244685; x=1748849485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sH1tT4PH7AkwUcGEWr07xjTn4FFO9TACfC9ggHqKbd4=;
        b=k3dw3gqPx/syfo50jcMl52jaP+NchAv7SH6HelVxDy9KI/fnuO8ZpL8R7wGu2RNS+2
         ZBP2tgytI4tO+Xdz71tQynTI9SzEKgf4FAYetKYgM0Dal8+0y/8Uxsp4GR2zUb9WWQ+x
         WviMa8vu+Z2CidQCvAzFaFOMKi6DDNVusENoTjdEAWBUf6Md/VHNvTPoxGsLL5WEff/9
         0Q3O79WzTROx22odUYZ6NqQF+HfLLcKMKZ+E8sl6PexSGaUHf6GyilNvPCSJKtSwfQzX
         AST4c/JHutpFaISImObJ5yRF6YZrpIxazgw5uDQnbhdUnIa/yW1fHHAxZ5LrduiPDoFz
         6TYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748244685; x=1748849485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sH1tT4PH7AkwUcGEWr07xjTn4FFO9TACfC9ggHqKbd4=;
        b=TRvuNglltHDX1hJcfnktRmdePka64KiVOMdmOvFDTJypNNkKN0xAGQiP5kn5Rx3d9f
         GjA966qSyhahC84ItyfVfU4S5/hw1jZ+Wy+gyTWvmsYYDwxBNeYljkQkZyGC2Lqfe3h0
         3WtQHnLj6jAYY66HyQ9YIBvDi11ISEvvJBUKXTMLxsfH8BtwJjzvUABs+QLUxtITJKaB
         WoVhU1XAFch6ba96PTHvcjDvXr8+LWmEeuJGM/GxuMC/7J6eo11uhmg27iAEDg7LGT9p
         rAvBVvGzF5iHyHUzR9SksdxT9Xg9b0zRRXVzEQizq/wv/NHVBK5MUDcuucICKMGV9cMI
         48Ig==
X-Gm-Message-State: AOJu0YyktldFzBao87s37h+/d3ELLBeUNvu8stpvMbvmaiX2ojwbkZAt
	i8n+D3bJz0+rkOD6LKgFa8c+mAgD6TSUASet7JffFfl8dAYW6otSb287ZPWZ3g==
X-Gm-Gg: ASbGnctX6ZNPIUjEGutYqKPh2ohTMA/WMCKTLeJA4sjd0BYG9QX+GkENeUfaWxttdRz
	mxrTwGJOZE5X6ZQ/jFS2WHqWoW4shF5ZZJLQvixl3d85Iav26UgAWxSrf2h+4RQxxpDGS/QFYmo
	nlCXI3vkPUA0zmVush1BCxgj4T0ZFlSqRgSYGFlzGYZDa1WCOmFfTIhV5b2a9moPYv981iHNZ15
	FJtm2Uduu1tzWk8Kf3rYDV1dw/0UDm4G/qaZfjZTzZrfLxx5kkraXwR7vUYq3c+mhATeCkuHjK+
	hSDKG3uKNgOHOrUSY3cNhaxLJVVL4FxRJizl+x7b2eZ3LjnFH3RTC5tlFMLESFs6
X-Google-Smtp-Source: AGHT+IHYLI+/kDGdyf6Q3ts/bF7tA7n5414Kj1FK5Ib+ZgDw9aBcTXiGsBjMdPgwRkttPnasbICkwA==
X-Received: by 2002:a17:906:f595:b0:ad2:48f4:5968 with SMTP id a640c23a62f3a-ad85b1bd264mr701177166b.25.1748244684785;
        Mon, 26 May 2025 00:31:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad8816eb7e3sm12395166b.50.2025.05.26.00.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 00:31:24 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH v2 3/6] io_uring/mock: add sync read/write
Date: Mon, 26 May 2025 08:32:25 +0100
Message-ID: <3ab0c417b401d0230e8fd0cc64e52c731e195ab6.1748243323.git.asml.silence@gmail.com>
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

Add support for synchronous zero read/write for mock files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 58 ++++++++++++++++++++++++++++++++++++++++----
 io_uring/mock_file.h |  4 ++-
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 6d6100052a26..eaecad34ef03 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -9,6 +9,10 @@
 #include <linux/io_uring_types.h>
 #include "mock_file.h"
 
+struct io_mock_file {
+	size_t size;
+};
+
 #define IO_VALID_COPY_CMD_FLAGS		IORING_MOCK_COPY_FROM
 
 static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
@@ -82,18 +86,50 @@ static int io_mock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	return -ENOTSUPP;
 }
 
+static ssize_t io_mock_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct io_mock_file *mf = iocb->ki_filp->private_data;
+	size_t len = iov_iter_count(to);
+
+	if (iocb->ki_pos + len > mf->size)
+		return -EINVAL;
+	return iov_iter_zero(len, to);
+}
+
+static ssize_t io_mock_write_iter(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct io_mock_file *mf = iocb->ki_filp->private_data;
+	size_t len = iov_iter_count(from);
+
+	if (iocb->ki_pos + len > mf->size)
+		return -EINVAL;
+	iov_iter_advance(from, len);
+	return len;
+}
+
+static loff_t io_mock_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct io_mock_file *mf = file->private_data;
+
+	return fixed_size_llseek(file, offset, whence, mf->size);
+}
+
 static const struct file_operations io_mock_fops = {
 	.owner		= THIS_MODULE,
 	.uring_cmd	= io_mock_cmd,
+	.read_iter	= io_mock_read_iter,
+	.write_iter	= io_mock_write_iter,
+	.llseek		= io_mock_llseek,
 };
 
 static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	const struct io_uring_sqe *sqe = cmd->sqe;
 	struct io_uring_mock_create mc, __user *uarg;
+	struct io_mock_file *mf = NULL;
 	struct file *file = NULL;
 	size_t uarg_size;
-	int fd, ret;
+	int fd = -1, ret;
 
 	uarg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	uarg_size = READ_ONCE(sqe->len);
@@ -108,18 +144,28 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 		return -EFAULT;
 	if (!mem_is_zero(mc.__resv, sizeof(mc.__resv)) || mc.flags)
 		return -EINVAL;
+	if (mc.file_size > SZ_1G)
+		return -EINVAL;
+	mf = kzalloc(sizeof(*mf), GFP_KERNEL_ACCOUNT);
+	if (!mf)
+		return -ENOMEM;
 
-	fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	ret = fd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
 	if (fd < 0)
-		return fd;
+		goto fail;
 
+	mf->size = mc.file_size;
 	file = anon_inode_create_getfile("[io_uring_mock]", &io_mock_fops,
-					 NULL, O_RDWR | O_CLOEXEC, NULL);
+					 mf, O_RDWR | O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
 		goto fail;
 	}
 
+	file->f_mode |= FMODE_READ | FMODE_CAN_READ |
+			FMODE_WRITE | FMODE_CAN_WRITE |
+			FMODE_LSEEK;
+
 	mc.out_fd = fd;
 	if (copy_to_user(uarg, &mc, uarg_size)) {
 		fput(file);
@@ -130,7 +176,9 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	fd_install(fd, file);
 	return 0;
 fail:
-	put_unused_fd(fd);
+	if (fd >= 0)
+		put_unused_fd(fd);
+	kfree(mf);
 	return ret;
 }
 
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index 0833eb7af1ac..85be7597c8db 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
@@ -5,6 +5,7 @@
 
 enum {
 	IORING_MOCK_FEAT_CMD_COPY,
+	IORING_MOCK_FEAT_RW_ZERO,
 
 	IORING_MOCK_FEAT_END,
 };
@@ -17,7 +18,8 @@ struct io_uring_mock_probe {
 struct io_uring_mock_create {
 	__u32		out_fd;
 	__u32		flags;
-	__u64		__resv[15];
+	__u64		file_size;
+	__u64		__resv[14];
 };
 
 enum {
-- 
2.49.0


