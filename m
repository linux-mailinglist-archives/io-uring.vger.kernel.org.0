Return-Path: <io-uring+bounces-8130-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1650EAC8A0B
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 10:37:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5D034A6537
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 08:37:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10BBB21885A;
	Fri, 30 May 2025 08:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WuVMOmua"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF7D2185A6
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 08:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748594238; cv=none; b=lIoVejgbgmXctAr5T7rYpkOBV8s+k90HugC5CgW6NvJfoXoTFEHjWcLDkC6X+K1CEUO4VZWdMHvckyFYLV6xGGB6PFHUquWSD0oJirakMnKBM3nzHCKuOpZZ33izmoT1AWFKUQEFC5I4jG1V3uk3r6OXAWuc9mR0gBh/rUevT0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748594238; c=relaxed/simple;
	bh=IRRGSaH22vHYZlWSqCBdkf7XnBSyUx8kxgH4rqO+5L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kOWZrWkSQu3algrrlp5jonnCamzJ1tSt36+jnZ7L6d3ofaJAK6N9DRiDKdjOpxRza2XIA9+c1IkgEZTVTp6MWA5EzODc0CUHh/3S1wvcA3Cx9O4v8m/3G++KM2d2WwKu0QvroGi7Iql/Zl6m+BTOCgaUbtbdyVZLt9mCiihHd8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WuVMOmua; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-ad88105874aso269939066b.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 01:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748594234; x=1749199034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UpX4Brl0srRkYBuqV7FaCgHV4mo0h9hRyOkegQKNjW8=;
        b=WuVMOmua7gOFvFNPkGzpPUGR62CPkHlCjZ8q0QbhbkiFk4eW/WH14798TU1v2XJXKD
         To+xoQJrA1wJt/juNCiOZDrkao2KpUnzYmG3EAxy4ZrFLjXBmt8XpaeOhZPyIxAXzmWR
         k3NHbFGzy0ssLxW7J6yBbh655MktsyGtMzjubsm6mRoKATyhoSL4AssaftS855/wS4eo
         SMP27yU82oA7+Y60/udxp0ZeM+4w0S7jbnyqk6B+Jd7crbmdH52jdYalWIbv4wPgMngX
         oC+8AA9nyr9GTlnS10VsnJ1UjI782Ps9PyVILDQtB+SkgWFoWr4gW+dNUhbIGe1T18xQ
         bJ2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748594234; x=1749199034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UpX4Brl0srRkYBuqV7FaCgHV4mo0h9hRyOkegQKNjW8=;
        b=ZwUKYGzPaAxkfRoPIabo22HFWP8V2OVaDZiDLaeRjp20Oj7VmXqhY9uTtUOKMkTGQ5
         Gq6MBr7l9Pba242spidnHuEAVrqoZBT6gC7O1vGvgaTr0lxmauFr0F1pdglZ4xGo9qom
         BcXz87cDOZrKYLu/ht8H1/1p3t4o1+JgiEWmxJX1YOMcpfMsFg2A+Z3kzaeEywYLCAjE
         BQzzNTUwIjO2pqfOMjMAiESB+BsLwHqYer9B/KLqlUk9O/6mpvERoBoNovGhnQ+Nc+U6
         vJoPWR0mxB8hs0B3ZwQwOlQPDXxES4HrWzp3Exu7vx59LTMYBQUVbeLF56AEWxd6Y+GX
         r9Og==
X-Gm-Message-State: AOJu0YwDR3S5oZR8/jZK74yrdWQhdqaGHTmcF+TU1p1cvME4QgSuZ2MP
	hoh1DPEpFkUqA21XCI0lLn4A7KR5p6z3BvMvMDcfRzTLULKtu5oI0pSmgUAGAw==
X-Gm-Gg: ASbGncuBzO6Y11l6/AKK+3QrWm0mgziA8Mnm5jImDoqU9xECFMe8ZxEfzpFDkjFAeiV
	cz1B5NcwFsLFdF2MqMyxLLpBddNLg3TPstCz0pgQAnKxQZ/4KNtP18apvqmlv95X+aqZ/hOljT2
	kJLYfZkIiz/vQ3nL1ZNx63S7km+bcvw0HOa3dZhjPvBvSJO8K98W+fk7N5CwZxhA4LxCdXgXKNL
	nCDOcBYYIqU2vE88E2POBIvuHnK1WlXTBOcMqGuThswPblj3VspaMTRtDeYbMOEXVA5g67y2USs
	ANEuNsujfgB2wTHtlLZAMyPb4ubCKGfhBgG5Ku3EEV6T9Q==
X-Google-Smtp-Source: AGHT+IFgVkB0b3wsgBkWCSWuL5qr9zmX1dW6h32zSsb6SoHPQb0u4rupprp59A5DLSsMR6NgTrEp3A==
X-Received: by 2002:a17:907:86ab:b0:ad8:8efe:31fc with SMTP id a640c23a62f3a-adb325805b6mr225180166b.41.1748594234201;
        Fri, 30 May 2025 01:37:14 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:65cd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad696d1sm288126566b.161.2025.05.30.01.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 01:37:13 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 6/6] io_uring: add trivial poll handler
Date: Fri, 30 May 2025 09:38:11 +0100
Message-ID: <94961dbc6e3e7bd9e84be8e0e914cc9cc308bef8.1748594274.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748594274.git.asml.silence@gmail.com>
References: <cover.1748594274.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a flag that enables polling on the mock file. For now it's trivially
says that there is always data available, it'll be extended in the
future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 37 +++++++++++++++++++++++++++++++++++--
 io_uring/mock_file.h |  2 ++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 6130fa66c914..78438f99229e 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -6,6 +6,7 @@
 #include <linux/anon_inodes.h>
 #include <linux/ktime.h>
 #include <linux/hrtimer.h>
+#include <linux/poll.h>
 
 #include <linux/io_uring/cmd.h>
 #include <linux/io_uring_types.h>
@@ -20,6 +21,8 @@ struct io_mock_iocb {
 struct io_mock_file {
 	size_t			size;
 	u64			rw_delay_ns;
+	bool			pollable;
+	struct wait_queue_head	poll_wq;
 };
 
 #define IO_VALID_COPY_CMD_FLAGS		IORING_MOCK_COPY_FROM
@@ -161,6 +164,18 @@ static loff_t io_mock_llseek(struct file *file, loff_t offset, int whence)
 	return fixed_size_llseek(file, offset, whence, mf->size);
 }
 
+static __poll_t io_mock_poll(struct file *file, struct poll_table_struct *pt)
+{
+	struct io_mock_file *mf = file->private_data;
+	__poll_t mask = 0;
+
+	poll_wait(file, &mf->poll_wq, pt);
+
+	mask |= EPOLLOUT | EPOLLWRNORM;
+	mask |= EPOLLIN | EPOLLRDNORM;
+	return mask;
+}
+
 static int io_mock_release(struct inode *inode, struct file *file)
 {
 	struct io_mock_file *mf = file->private_data;
@@ -178,10 +193,22 @@ static const struct file_operations io_mock_fops = {
 	.llseek		= io_mock_llseek,
 };
 
-#define IO_VALID_CREATE_FLAGS (IORING_MOCK_CREATE_F_SUPPORT_NOWAIT)
+static const struct file_operations io_mock_poll_fops = {
+	.owner		= THIS_MODULE,
+	.release	= io_mock_release,
+	.uring_cmd	= io_mock_cmd,
+	.read_iter	= io_mock_read_iter,
+	.write_iter	= io_mock_write_iter,
+	.llseek		= io_mock_llseek,
+	.poll		= io_mock_poll,
+};
+
+#define IO_VALID_CREATE_FLAGS (IORING_MOCK_CREATE_F_SUPPORT_NOWAIT | \
+				IORING_MOCK_CREATE_F_POLL)
 
 static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
+	const struct file_operations *fops = &io_mock_fops;
 	const struct io_uring_sqe *sqe = cmd->sqe;
 	struct io_uring_mock_create mc, __user *uarg;
 	struct io_mock_file *mf = NULL;
@@ -217,9 +244,15 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	if (fd < 0)
 		goto fail;
 
+	init_waitqueue_head(&mf->poll_wq);
 	mf->size = mc.file_size;
 	mf->rw_delay_ns = mc.rw_delay_ns;
-	file = anon_inode_create_getfile("[io_uring_mock]", &io_mock_fops,
+	if (mc.flags & IORING_MOCK_CREATE_F_POLL) {
+		fops = &io_mock_poll_fops;
+		mf->pollable = true;
+	}
+
+	file = anon_inode_create_getfile("[io_uring_mock]", fops,
 					 mf, O_RDWR | O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
 		ret = PTR_ERR(file);
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index 0ca03562359f..30456ea71d54 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
@@ -8,6 +8,7 @@ enum {
 	IORING_MOCK_FEAT_RW_ZERO,
 	IORING_MOCK_FEAT_RW_NOWAIT,
 	IORING_MOCK_FEAT_RW_ASYNC,
+	IORING_MOCK_FEAT_POLL,
 
 	IORING_MOCK_FEAT_END,
 };
@@ -19,6 +20,7 @@ struct io_uring_mock_probe {
 
 enum {
 	IORING_MOCK_CREATE_F_SUPPORT_NOWAIT			= 1,
+	IORING_MOCK_CREATE_F_POLL				= 2,
 };
 
 struct io_uring_mock_create {
-- 
2.49.0


