Return-Path: <io-uring+bounces-8539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 56CEDAEE69C
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 20:15:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9A2A21BC0FD5
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:16:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BAB11D63DD;
	Mon, 30 Jun 2025 18:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fpEDJ4Lz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5DB2745C
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 18:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751307342; cv=none; b=E2jEFCgj1wtC1Z22pzuuTcnFvF1lI8mNABA0e4QbIdXwa8odf54Tc2W0tlnTVDtMs3gmCDV0oHHw67KMtVS9FstOueCh1u8EwP4P6iCnU8yEe8g+GZlwreodzhh4/WrFF9Qd3DNJd86sOjhZtFxk/5BUPmT5sTwrEsm7q3cQj04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751307342; c=relaxed/simple;
	bh=vFiaBmHz3pRnoVhAfW0FrHYHsryBIegpAJXbeMrD3D4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXnu/8VD+Dmwk/0rBTjuD/+9OWCTQbboemTH+4EGvtGGmLg90QwqVC0AXHtplh79BuHExJda/oLnlC727M52isXf6AhJyYcawfyGTGFscZ3hBHRGUStHLcN5fJTCeW8e0nOvjJT7ngLnTZnZIIgbJYLghrvCQab/2Jhye+bPlGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fpEDJ4Lz; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-747c2cc3419so4633492b3a.2
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 11:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751307339; x=1751912139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrZNAkfi0Eu0ZyvPuypSFCLrhKnHv7GgW32xdRv3vuk=;
        b=fpEDJ4LzhqzH22V0rHJUzk94Kr6+8/Hq0V22DrIlbhRpjzil1a/DLhi2vVCJ81+G67
         sxZ6XcfKgqZziwvkw8QSMllo/Ld6gMnpDKD3B5Fns35d9cHFQkd3LoyO6dxljBMg9kfV
         4t6HiRBGAm0geOHsE03E6ek2w6zSDCTAZENSbQLAIp6/p6o2FkpP9g9Id+Rsx0ouxyEI
         joTtMdCbSEwoO6QbY7rjM733bN+g9jXHqFg/+w39KSJDoAzzQUyfFIdl8VPSslxB3fr4
         orJ4IxrB2vWMQNe6Vg0RFUuHfvMhyxi5cPVLm2zFcTiwbgsCmr5f18S8wbTubLkUVloD
         mlrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751307339; x=1751912139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LrZNAkfi0Eu0ZyvPuypSFCLrhKnHv7GgW32xdRv3vuk=;
        b=Qu5PfoEg/g74To2Tos3XTyb1hznYRBgCRS6w2byvlVjvIYMP3rGP+Pgw+4QjtnERjz
         f9Rqc7q/XZ9TChOJiWSXV+R29skLle2Egi1b3CWVXbRVPmZX/s+5VTa3JxNDuODkNiiq
         pi4JU8mEZTKd6F4p3tHtn+GT0bY5jy4s0WIy6IBawtm/rLy9ahkYpemeHlA6eQbBkOri
         PvH++popH+BtDzDB6PtAgUfmGX7nGTWakz8qjgXkrXyYWUsD6s3PioXiFKK5/Kvuy2fe
         Pds4OmC8Olt4bVrM7kh5fmTDI/Oe4pIxUnrYG/V2K5tln2O+rqVL4i+R8Jzr0o7A2AMg
         1nuA==
X-Gm-Message-State: AOJu0YzzA+cIcdGT11hOKil1+ktmecBjaTRaVjDFdWh+r/OjzYva9tE7
	D2nYrEvuIvC5vASHB5+ZMNy1qLLf/N6rpCTd5AV5q0KWyA3+w7Mylnqqb5TWrfgw
X-Gm-Gg: ASbGnctnN+MVtrg3KH5sj9Gj2CoEgfzP5+aFSGRI2XLXjfjhikewB9fiLw+mfPEGE1O
	hKmlkgzj/A3wLuThhDLKTkSZo3hM23uXCoJcX/Z/Zr0NTN3HxoOD/TqVJuhI1Zt/hZx3+nT6C5b
	/ke/QIpa6M4MaRvOcNiuUA9eOMVUalshbSlx4RsaeH7LJFLFogIc7+BHSKmT3NsvT2rMZ8rXGY1
	Myt96xQd0Bq9v4LxMMxIt040b+pOkeAL6ID449X3Y9nps/SKKA3PFiYHM0JoQbp9Uy1QuTiT4jt
	cLkTgmIjxm1FiKqaHDRYMs58iV8w+oHRoYTgR4KmbU6khg==
X-Google-Smtp-Source: AGHT+IFDQk87Phhg2KG+5/bFYaH5czcSRTqKf4jpUfOHdPrRubN9Mn3GHvrLTU5TMVLvjOlaM9YYlw==
X-Received: by 2002:a05:6a00:3e17:b0:748:33f3:8da3 with SMTP id d2e1a72fcca58-74af6f2f9d7mr21984799b3a.19.1751307339466;
        Mon, 30 Jun 2025 11:15:39 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5421c59sm9505960b3a.48.2025.06.30.11.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 11:15:38 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v5 3/6] io_uring/mock: add sync read/write
Date: Mon, 30 Jun 2025 19:16:53 +0100
Message-ID: <571f3c9fe688e918256a06a722d3db6ced9ca3d5.1750599274.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750599274.git.asml.silence@gmail.com>
References: <cover.1750599274.git.asml.silence@gmail.com>
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
 include/uapi/linux/io_uring/mock_file.h |  4 +-
 io_uring/mock_file.c                    | 67 +++++++++++++++++++++++--
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring/mock_file.h b/include/uapi/linux/io_uring/mock_file.h
index 73aca477d5c8..de27295bb365 100644
--- a/include/uapi/linux/io_uring/mock_file.h
+++ b/include/uapi/linux/io_uring/mock_file.h
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
diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 8285393f4a5b..90160ccb50f0 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -9,6 +9,10 @@
 #include <linux/io_uring_types.h>
 #include <uapi/linux/io_uring/mock_file.h>
 
+struct io_mock_file {
+	size_t size;
+};
+
 #define IO_VALID_COPY_CMD_FLAGS		IORING_MOCK_COPY_FROM
 
 static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
@@ -82,18 +86,59 @@ static int io_mock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
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
+static int io_mock_release(struct inode *inode, struct file *file)
+{
+	struct io_mock_file *mf = file->private_data;
+
+	kfree(mf);
+	return 0;
+}
+
 static const struct file_operations io_mock_fops = {
 	.owner		= THIS_MODULE,
+	.release	= io_mock_release,
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
 
 	/*
 	 * It's a testing only driver that allows exercising edge cases
@@ -114,18 +159,28 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
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
@@ -136,7 +191,9 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	fd_install(fd, file);
 	return 0;
 fail:
-	put_unused_fd(fd);
+	if (fd >= 0)
+		put_unused_fd(fd);
+	kfree(mf);
 	return ret;
 }
 
-- 
2.49.0


