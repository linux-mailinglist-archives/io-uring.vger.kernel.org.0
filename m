Return-Path: <io-uring+bounces-8542-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1EFEAEE69D
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 20:16:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F30A4189EB5A
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:16:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CECF1C5D57;
	Mon, 30 Jun 2025 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KHKDVHO3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5680190462
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751307345; cv=none; b=tS6Uy0SqD4Gx7wPvhRpMjZ9JyAD9feMr9aevU6Oe3wmcc7VldZ9GgisQYJYZPxkSr+Dh8Js6Up84ZPowgyV/N193LqZcIXEa8dZ+AmW0yTTPJOB5wLnqm4yWg6OQRd4ysXWwoNdI6un8eE13w+jrETSM6XoHEsOxCWo/xBPeThE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751307345; c=relaxed/simple;
	bh=Wvj73gS7V2GlGeAFUDD1/pEy7b8tX5MYcZgZ02FALeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFpqiHnu5XLcAmMrcgYgoi90ID2ceOzPkL/GpD1wXiyw84xwN8ZBFHMw56+vwp80MT/vNc1yVJUM9L7htwn65QYQTcJaMiAqZhaO4FwE71fc4QWeFJCcnwC/VnjGgzifgtJFG1m4sxVyFuefd8GZpdM5CpVv2q+hb/9px0z7jY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KHKDVHO3; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7490702fc7cso3528209b3a.1
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 11:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751307343; x=1751912143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0eSxYzFhzU62KMn+G7pRE88xIXfZgmCaBpH5g5dooaw=;
        b=KHKDVHO3TB6O3Hgn2BKY00iKEz2lHnTrth0Tvwrb3yQjVeCJ+yg3UgGsmZorvabdUB
         kl9RFYkuxSCWXuIOwdANhajzKUlwkjNa4fadSJ8IwSeEIQ7TIiKFKA8SsOqOd9nDyMBN
         KM+63hJY8xSMIX1tQnLfCQwk6JGFVy+tLjIdf6e28ZmA6OW6QN0qxOipaySkY6O13nks
         0XJRXFmL1pt0N2tZlgpePgvgSPXuyjvId/1yQ0cIG3HuNkU6areaWnDRLhvtjVybjYsv
         qKo+/fgCAHw/Gz+fe5Tc2OuyGYsMxGOlNqUG4NuwgQORWH7ETGOGUuSU2ZFTXZNkC0W8
         C/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751307343; x=1751912143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0eSxYzFhzU62KMn+G7pRE88xIXfZgmCaBpH5g5dooaw=;
        b=jmLWQnIFNs1ACA2Cr2y+I7GGGT/QXoNhtXjTD5ZH20p1hySrh/ZDxtSBpY+iYvIFg1
         AeAmeQDt619dsB/HCdAXTTSpY4EyceM2yC+695q8S7EzJBZhOz+riYijHCX0Al+PQMYN
         tv8T+sbMYbaFXuy4xLPldMUXOlmtTJfIOeVOnbxaa03X7spfjKU3BTNQ3sqfNau0Osir
         HIwqmllJDPEyDGGa+ymfgyC3w4n/3yfjP13f3LKzhwqFLelwM8SnanZRFFeqj69OgrCl
         Pa0PNDmGBL3xBIb9tdmoejEvDBUXUqmCCReyXpbmmgSXb04dbNoZ6q/viy3HRX3BWFxi
         GluA==
X-Gm-Message-State: AOJu0Yy8sEfC+OGj3JVPQ/km0D2hkZS0/Zlb8UwVOQ+SPAEvW8IFhV3R
	Si4epC1eXzWW+5dCIi9H00jzuMpUdKlF4zmNqS91ohuKZG2j5z3RTk9fQ7HxXjMX
X-Gm-Gg: ASbGncu0izqyNLY6lVw0GxtAFZNfzOPe17AjiydguzFRvd+cFUH410RL4Gi8bJsIOLp
	7lqoIB0ac+wMeYd7V5cmAGh9f9JlwQja+nZhdR//+f70YU+h2PIT1aOvB/f8qH03k95VLQeYVTu
	SUzRrkZ7x+JxtwCBIFqbwQWbkC4bdVrOK4fPF1/2y5hWB0fw24Jyw6n5m5mlbFnpz7gykuC78ya
	+95sldcjKCMC1joQwthPteW90eBbusYTW0EEdN/5LJroZknDZuelhQHRuCjxX0Tsefj+NiYF0RR
	yo9C3k1ktQjKnw8QPRIFTwtkbMsxsLucQLyEKcNxpyHDtg==
X-Google-Smtp-Source: AGHT+IHVnpPuIQTrOOlPzji09mTQPeBsud/ljrcmYyq+RmGLQfRiniw9xUUoLkOU/c/InEJRSqBU/g==
X-Received: by 2002:a05:6a00:883:b0:748:ff39:a0f7 with SMTP id d2e1a72fcca58-74af6e91613mr18112941b3a.9.1751307342781;
        Mon, 30 Jun 2025 11:15:42 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5421c59sm9505960b3a.48.2025.06.30.11.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 11:15:42 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v5 6/6] io_uring/mock: add trivial poll handler
Date: Mon, 30 Jun 2025 19:16:56 +0100
Message-ID: <f16de043ec4876d65fae294fc99ade57415fba0c.1750599274.git.asml.silence@gmail.com>
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

Add a flag that enables polling on the mock file. For now it's trivially
says that there is always data available, it'll be extended in the
future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/mock_file.h |  2 ++
 io_uring/mock_file.c                    | 37 +++++++++++++++++++++++--
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/io_uring/mock_file.h b/include/uapi/linux/io_uring/mock_file.h
index c8fa77e39c68..debeee8e4527 100644
--- a/include/uapi/linux/io_uring/mock_file.h
+++ b/include/uapi/linux/io_uring/mock_file.h
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
diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index ed6a5505763e..45d3735b2708 100644
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
@@ -223,9 +250,15 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
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
-- 
2.49.0


