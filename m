Return-Path: <io-uring+bounces-8147-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E35B1AC8FAC
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:18:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 245771C230AC
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:12:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7989235053;
	Fri, 30 May 2025 12:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bD/57xU3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC1D822CBE4
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 12:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748609466; cv=none; b=tsY7uLwDe1me/j+/UhrmQCEEgkp8EhQWSU3Qtm69wz+4oK2LOEsXfmUo9kkvvxAHhtlLihe5Yei4xPzHjlyb4M74lqkLJlOijrx0Pe27KAKRpomCnhztxFTGasAB5ChM45RCQQOjp2PLnkHI2p8bNkew5dmcRrcRLTzyWgdV+m4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748609466; c=relaxed/simple;
	bh=aj9BKkSsoCun8wjdXcnRc0rUasCOgGv4WBUMiNdB37Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUMGyd7mv7fwRg95Btki7bkYwaQoBovzeUQE3MnV8YHDpneyCCd2OUKR500LmRqAAk3YUyp4k9XihG8XtjZpsjpf2/R4JBtGB5mfxvfTcpDyLeL0tSI+7MTAhLsUPlKor2HDa7qgnqGOj3pLvuAsvmmGi63PaFyLoL4ocFJmnK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bD/57xU3; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-ad891bb0957so354035866b.3
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 05:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748609463; x=1749214263; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bpCeIzB7BUXAxuZUWilsJWfReoUP0aKhFB0gV7cSsko=;
        b=bD/57xU3udhymeqjEbt1JF83w3kyCAkxAnx5yCNcE4fqNLBZJdU94inAejG3CxxWEL
         JHyePtEUbAm6J0QAh4u/zfWJC0ZemNLnZI1ekaBIACrNH/szOIkJX1unYCwOAkABYqOS
         FaKIJBBQ4Pv6KuoGZKeaBXXbdnnbAJzyCCBT1576RvgQkUpAmJ/YEyXfoRIBkAb33O//
         9jk/KPx42t3wMsf9b1yHt466au6ByVnCZzufkz9Sc/52/WBvkqJVH08rbPNGS2CwtmQT
         6xUyxPejJC+EbPJVtWwQG1w2xffWzj5yHOC0VQgEGSEv7leVBopErWfEhZmiFtKWqXwp
         tjTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748609463; x=1749214263;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bpCeIzB7BUXAxuZUWilsJWfReoUP0aKhFB0gV7cSsko=;
        b=pMsxXSfZNCbqd/ottkHxMYSlHpA5Z8qaDIFhSZ5LprsQ7Ran6r6UUOAgYlXoBS7/bt
         6A6kpu42E+GX+ByGWBUvJCpbdjjMBZyYmFMCYa4EDGz5Wv+O0MqCBdyLwcfpQ90Si4y7
         mfmq204LvopIXsJ8vcN7UWNqoCjXYo3ggvMyRBqJ9IZFnVuWJ/nwBP4FXhYFSD0YYdGV
         iK+Z6zs/tODyo+Dl+zqgUxVHSi7NYVkZtqOOZQ/AfX7rP/LVDPW2Pf6lkEBwLuF3Wl50
         +y9LVFgKLTdDQ4kFPRb+yhVKYkKsQ2YMZJcActeHJslKVjkV2Fy/1QC626MEWPZJQH7o
         UOYQ==
X-Gm-Message-State: AOJu0Yzth2xhGnJWnqCK6EOjc9LP1gLP8vvL6bI50mYr5I9DKZBeEfr0
	O+b8hil9l4yQKqPyNHPXr7MHBGty09IPeBjIZNxPKV8rIt0L1f2KGLziqntUQA==
X-Gm-Gg: ASbGncse5Gjc3Jqxlphc4E95ropObkpPvWsfrXMcELPzAKkoVRP6epeOmkXsOWsfgfi
	0Va+yJTUqgyDNdEac0l1MjFc2TL/H+sfCBSURbI5dgj3CZwWLF6xYWVZhDAQ7SWm3WcvDuGPLmC
	Q7kFuaqSHjcY8xKSMjSL5L2GdJyAeqUi/BNpSp0EpUYZrtdLGDIMOeBie8zRkhfyH/X7jSh3h8n
	BZ5Sq938jz24LOWzLqTQHPyOBc7yKFd3x2fDOCj0SnSrFaK6gGOWx9aUMGJ+95H14Fk5PiROfxp
	EXWvsFrASgGkaQ9KvPlOa0n3Hpvxj7ooe8OPqh5m2PtEeouTuDCgkuVs
X-Google-Smtp-Source: AGHT+IHaRT1OIpcxmmQL7hDqjoxLH6PHKicEh8dMoYLbq+TSm1dW0CAzt6VzXLzDefksAE+NjTsehg==
X-Received: by 2002:a17:907:948d:b0:ac3:3e40:e183 with SMTP id a640c23a62f3a-adb322b33b1mr316245566b.3.1748609462731;
        Fri, 30 May 2025 05:51:02 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39420sm323234266b.136.2025.05.30.05.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:51:01 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 6/6] io_uring/mock: add trivial poll handler
Date: Fri, 30 May 2025 13:52:03 +0100
Message-ID: <0225fdfe961ca8cc153611d3d8ff33f67c1c2df0.1748609413.git.asml.silence@gmail.com>
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

Add a flag that enables polling on the mock file. For now it's trivially
says that there is always data available, it'll be extended in the
future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 37 +++++++++++++++++++++++++++++++++++--
 io_uring/mock_file.h |  2 ++
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 2f9a0269eedd..81401e9a1a6b 100644
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


