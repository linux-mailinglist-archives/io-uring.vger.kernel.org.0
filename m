Return-Path: <io-uring+bounces-8541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C352AAEE69B
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 20:15:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1567217CE8C
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:15:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 517821D54F7;
	Mon, 30 Jun 2025 18:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ds1u3nJo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A982C2745C
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 18:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751307344; cv=none; b=HXeFd5Vbu1T+D0QBtomt99EWhz7XbM2OydrQ3ACHZcE5k3aLQxpFJLsk9GBLXCz3WRlpMk8lZBoOntuA9U25rg7zRYdL4Qh7LQSxAXKbMQZWo/+Faja77TdyOG+SAsbq8/5mWsCHTiniuDhFUs8b8oakoKXTIad1xrHTvg0t/lM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751307344; c=relaxed/simple;
	bh=PFlDQy6laaPjcokM86p3g23n4SjLO0tF3svUx1x9i5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FN13BILRFoeKFlfi4nP7Ni51QHAA7mjUWfQ21v8Gc5X+l4q8tIVYyscBXxwjHHTVShJgV07Bk/ozk8R3zFQKMrJIBoc9zPQl2xMKLLq7o2rYepQf7pZhoiacZwIfxh5vBkoT7khfHsPk8GFfWfb4Ynenzzb1gC10X9Wkr35XccM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ds1u3nJo; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-748e378ba4fso6598699b3a.1
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 11:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751307342; x=1751912142; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ALBm8qs99KZUw/XElkcQj0hCl6KVgO6LxoTI57S6yoU=;
        b=Ds1u3nJoihPFxOsz3t+AdeSOePDuZGh590w2OJ42YlZqBukKb/aO0g9gKWtcstJXfx
         Hte5TkmodpDsthhiJv792B+9ijfMKG2FhEkjOxpukGRjena/2N0ME5AzfW92eQZFRqba
         HmYy8i/pBU8sF3inYBiCPJliBhPsrothj86a5m0A23X4Pa0Zj/gwefoeggt6vcpMeCPw
         gCA9DQKqsVA9ViydIDDx6GNt07C0rZBFmFS+nEo5j0fBmcrT6ArhF87aq/L4C+3Cza1A
         8QQr5PfCVFBDC5cXwwB5acskmk9xcUIBiHYEU6DCUuI19E8OmvGg76Ab2qdheJipxvTu
         Z5/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751307342; x=1751912142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ALBm8qs99KZUw/XElkcQj0hCl6KVgO6LxoTI57S6yoU=;
        b=pGQAlkHZAMMMwtzgcCo8CJaZxteWcy+kaV42hNfItrEBDo+3MT0AlPM+n24DtXVggz
         9HTvX8Bm7FcxoGhtmn9i3SsiNpLd5MgA/2Fgw6R4vfR3lkOduQBNtKhkQIa3cj8qP+su
         h1pLjYjGcN1xV1hGW+D/7ztuRrV5Pk76MvdwEPftvRbDnSuPvSniJx9sclG9FPpNJmS1
         +vd6z9FGCGyJDE/g4U4AFRf3Ocz84XPsms8nAfd+AiR+/HxtVsJrQW+hveqyqeKwY6i3
         BSVFzISA/3Je/s3zxLgBoMOWk1jn8PZ/GKAglOvVNu2ahHxVYdyS3Td4MQsU/JxeBWvu
         VQaQ==
X-Gm-Message-State: AOJu0YyZVJXnkhZJuMFr9gsCoAUvxMXXUkwOunNdfd65A8t/S9LZWUnq
	oLwqFd8nn3JTztjO/R1ut4GPhrCx6jJPxH0PU4CglsUL1E+c3ECUl7IxEqkLV+TH
X-Gm-Gg: ASbGnctXjoRNfiKKRT+d5Knk5wFZqshzIntO5w+pz0hEOiyWWAMBO3BG3ZsVUJb1VzT
	c7n6riR3Izu3sUJz2O07Au5saM+UyZKTnN/1M6VhkTgZ7XhvqDDAVci+etjdBhTE4AhoD/q70Ar
	FvESd5uUY8GSd/rRRdx6kDk5yrLlDuDs7c9CeUGNf2YUbAuvF/92A1TQ7i+WQnbNBLKawNQF8f+
	H+r7Pm4ogD15eYTsauHY4UFFZqb6uphlaU1JwYVeWcdwM//xLaG9if4FfexG6YLbBTO7lGX7nJW
	ytUe/3pzQ+MO49JLAvPQfeEJqVX9++W/UfCkYBsJkwbOrQ==
X-Google-Smtp-Source: AGHT+IE25JsrzryV1wfDfmLJfkDZozoGsz21fHcDQr1OVUtPYnQ2ybuaKRXkHutQXLr/WQ4DHCXQqQ==
X-Received: by 2002:a05:6a00:2315:b0:748:e585:3c42 with SMTP id d2e1a72fcca58-74af6f40ba7mr18267226b3a.15.1751307341637;
        Mon, 30 Jun 2025 11:15:41 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5421c59sm9505960b3a.48.2025.06.30.11.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 11:15:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v5 5/6] io_uring/mock: support for async read/write
Date: Mon, 30 Jun 2025 19:16:55 +0100
Message-ID: <38f9d2e143fda8522c90a724b74630e68f9bbd16.1750599274.git.asml.silence@gmail.com>
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

Let the user to specify a delay to read/write request. io_uring will
start a timer, return -EIOCBQUEUED and complete the request
asynchronously after the delay pass.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/mock_file.h |  4 +-
 io_uring/mock_file.c                    | 59 +++++++++++++++++++++++--
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring/mock_file.h b/include/uapi/linux/io_uring/mock_file.h
index 125949d2b5ce..c8fa77e39c68 100644
--- a/include/uapi/linux/io_uring/mock_file.h
+++ b/include/uapi/linux/io_uring/mock_file.h
@@ -7,6 +7,7 @@ enum {
 	IORING_MOCK_FEAT_CMD_COPY,
 	IORING_MOCK_FEAT_RW_ZERO,
 	IORING_MOCK_FEAT_RW_NOWAIT,
+	IORING_MOCK_FEAT_RW_ASYNC,
 
 	IORING_MOCK_FEAT_END,
 };
@@ -24,7 +25,8 @@ struct io_uring_mock_create {
 	__u32		out_fd;
 	__u32		flags;
 	__u64		file_size;
-	__u64		__resv[14];
+	__u64		rw_delay_ns;
+	__u64		__resv[13];
 };
 
 enum {
diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 0eb1d3bd6368..ed6a5505763e 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -4,13 +4,22 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/anon_inodes.h>
+#include <linux/ktime.h>
+#include <linux/hrtimer.h>
 
 #include <linux/io_uring/cmd.h>
 #include <linux/io_uring_types.h>
 #include <uapi/linux/io_uring/mock_file.h>
 
+struct io_mock_iocb {
+	struct kiocb		*iocb;
+	struct hrtimer		timer;
+	int			res;
+};
+
 struct io_mock_file {
-	size_t size;
+	size_t			size;
+	u64			rw_delay_ns;
 };
 
 #define IO_VALID_COPY_CMD_FLAGS		IORING_MOCK_COPY_FROM
@@ -86,14 +95,48 @@ static int io_mock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	return -ENOTSUPP;
 }
 
+static enum hrtimer_restart io_mock_rw_timer_expired(struct hrtimer *timer)
+{
+	struct io_mock_iocb *mio = container_of(timer, struct io_mock_iocb, timer);
+	struct kiocb *iocb = mio->iocb;
+
+	WRITE_ONCE(iocb->private, NULL);
+	iocb->ki_complete(iocb, mio->res);
+	kfree(mio);
+	return HRTIMER_NORESTART;
+}
+
+static ssize_t io_mock_delay_rw(struct kiocb *iocb, size_t len)
+{
+	struct io_mock_file *mf = iocb->ki_filp->private_data;
+	struct io_mock_iocb *mio;
+
+	mio = kzalloc(sizeof(*mio), GFP_KERNEL);
+	if (!mio)
+		return -ENOMEM;
+
+	mio->iocb = iocb;
+	mio->res = len;
+	hrtimer_setup(&mio->timer, io_mock_rw_timer_expired,
+		      CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_start(&mio->timer, ns_to_ktime(mf->rw_delay_ns),
+		      HRTIMER_MODE_REL);
+	return -EIOCBQUEUED;
+}
+
 static ssize_t io_mock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct io_mock_file *mf = iocb->ki_filp->private_data;
 	size_t len = iov_iter_count(to);
+	size_t nr_zeroed;
 
 	if (iocb->ki_pos + len > mf->size)
 		return -EINVAL;
-	return iov_iter_zero(len, to);
+	nr_zeroed = iov_iter_zero(len, to);
+	if (!mf->rw_delay_ns || nr_zeroed != len)
+		return nr_zeroed;
+
+	return io_mock_delay_rw(iocb, len);
 }
 
 static ssize_t io_mock_write_iter(struct kiocb *iocb, struct iov_iter *from)
@@ -103,8 +146,12 @@ static ssize_t io_mock_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (iocb->ki_pos + len > mf->size)
 		return -EINVAL;
-	iov_iter_advance(from, len);
-	return len;
+	if (!mf->rw_delay_ns) {
+		iov_iter_advance(from, len);
+		return len;
+	}
+
+	return io_mock_delay_rw(iocb, len);
 }
 
 static loff_t io_mock_llseek(struct file *file, loff_t offset, int whence)
@@ -165,6 +212,9 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 		return -EINVAL;
 	if (mc.file_size > SZ_1G)
 		return -EINVAL;
+	if (mc.rw_delay_ns > NSEC_PER_SEC)
+		return -EINVAL;
+
 	mf = kzalloc(sizeof(*mf), GFP_KERNEL_ACCOUNT);
 	if (!mf)
 		return -ENOMEM;
@@ -174,6 +224,7 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 		goto fail;
 
 	mf->size = mc.file_size;
+	mf->rw_delay_ns = mc.rw_delay_ns;
 	file = anon_inode_create_getfile("[io_uring_mock]", &io_mock_fops,
 					 mf, O_RDWR | O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
-- 
2.49.0


