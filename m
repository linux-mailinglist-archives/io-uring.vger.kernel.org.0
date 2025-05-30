Return-Path: <io-uring+bounces-8144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C78AAC8FA3
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:17:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9FFD8A47B28
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6861F22F3A8;
	Fri, 30 May 2025 12:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iOZclLyr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852F622F3B0
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 12:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748609463; cv=none; b=n4Z9n3A2JCUwRVN+u15vRpj2LC9euW9NEiExrSeRzmcyyGpXlEMEmzvWUmzXUTATZ6bBuA9q0vvUEExPyKCiRA/lZfU9rRsBl9/KKZQUnndjzVvlV2SXfxfvYpg8ZL07HKBaSl5i2qdpTRCkTfrHnK5jnH2/kA4xhDmSjQv0acc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748609463; c=relaxed/simple;
	bh=sKudk39lLdq5oOcwtWaROHBPPuCamysicZVExxekg+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqjNLrqlHNus35HP6HqNBAWtJ2YBMPawZ/Ai+WMoWZmx/ZXr32HysdRP1VhpvDG4jGhHOLwJC6AalMOI1OG1wLxncjSnBeHIWQYNir6/yzYK29Jp+/NV9qRH8mrDkCUKx+7jVgcK8JIkrCJll7VsCKCJgHflu44yH78GxAAuPEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iOZclLyr; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-ad8a6cda6a4so418137466b.0
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 05:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748609459; x=1749214259; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJOrwmBoBwX78jc9DRiK9XmidxR9TXl/t0n4vxL5y28=;
        b=iOZclLyrMResqb2vBvXmH3tYCdfxKwtg+/aL9jG3XEYXDOOJOziMCtqXnD2OF57dQF
         9EAFvQRl6ALpiqoRM2rh+SltIYN7d/O8twmtICFuOXKOpLNc1yFi2SU2XHkF69M7z4J2
         LEZD5ALs/KEyuKIbT0d+jDV9ftAy7XMOlWES/UbnBHuwfsjXphxHtBjTlg2TeKm6Njwa
         0MoUzxN6z7R+GLw4gVcyOLzXHPC3e4vMU28tDlsj5mHJbfZ6qJEzG0eVGrMQEA325dsE
         STdqcohRlAgk67drDApgNtJPswYv7gMlJitF2B7dFUTOl3vLZ7+8PfZzWwaOrUI4s5ep
         RoKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748609459; x=1749214259;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XJOrwmBoBwX78jc9DRiK9XmidxR9TXl/t0n4vxL5y28=;
        b=iC7/uUJZoaQTiL6ESOmhQkZtWEWLk0lnwDr4abF0esKwa8pQBHxliqVPtDMUQyc84i
         3f8g6KxVxPMErCthe0L72u229K29xzJ/AW1Kz6F87bhLazmNco7aDUvYDuTT00QOMjmp
         4BISM40Wrfz2T8yxSBoQqyH9iq1unh1w2SMykCIPvrDQyCXPDczUDiB/8XS4Lrwynqtj
         hTiqARjnQKRdHfqFbrTlaodoKASX97Es6y8AmYDP9LPVLh1JhsPd5enMFcUDhyxMgIJA
         w9BOBo6PJrvnDCC9csZvQ35G0ERj/H2AYvm+ygRSLk6oPqJM8lY7oDoBDOYj1gRFG/OA
         yXaA==
X-Gm-Message-State: AOJu0Yy8ZHfE1KWeeJGmZii+YIWmq7bPhgE13ia5V2yRykiYH+RHKp0O
	lNtoEkAddRZhkMwcIDBgCTagbIuDLmGTsCvA7N4vKpA6sR+/RG8gb2A++XIvGg==
X-Gm-Gg: ASbGnctlyQvs55OZ7Ve8B1zEEsnk6uqjGmtG91dSBJouC9aOa6b2QEs1/o1b1h1CjbC
	HqWI+XqTlBIbSV55qXXmLIpAUzfSVmKaz6DIYoYptRy8qeD2mtik/3+0+taimbhXb+BPPZnDVvf
	bgp3d634cYmM4/ceqlCiPYrPwwK9Bs/jljHUgReOt8QcxrQfwIk0CSx4RaKliWE2QPsw7+zvmEi
	K5Y0Y2lZoZiwgTKw5a5WX4gshmmtpijV4AWL/WIwfSXHF2oZDm5KJJKgBaY686JdQqMRRN3axM3
	2DbNTTBBE3+RwWLoZlz14HNPXTx7q2gGdZo=
X-Google-Smtp-Source: AGHT+IF/946Nf89igyPaz9SbkIsI1mLzhboXeptPFDYBs2J2a3l2rv44+JRxSS4e7d+vMk+3W23RtQ==
X-Received: by 2002:a17:907:da5:b0:ac7:81b0:62c9 with SMTP id a640c23a62f3a-adb32ca4d4fmr297729766b.20.1748609459189;
        Fri, 30 May 2025 05:50:59 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39420sm323234266b.136.2025.05.30.05.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:50:58 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 3/6] io_uring/mock: add sync read/write
Date: Fri, 30 May 2025 13:52:00 +0100
Message-ID: <feb9e283a0ea9ef23c021155504865ded731a5e0.1748609413.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748609413.git.asml.silence@gmail.com>
References: <cover.1748609413.git.asml.silence@gmail.com>
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
 io_uring/mock_file.c | 67 ++++++++++++++++++++++++++++++++++++++++----
 io_uring/mock_file.h |  4 ++-
 2 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 4982f71a3a9b..7dd87d0b83b2 100644
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
 
 	uarg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	uarg_size = READ_ONCE(sqe->len);
@@ -108,18 +153,28 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
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
@@ -130,7 +185,9 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
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
index 8475dfd827e9..dc6cc343410d 100644
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


