Return-Path: <io-uring+bounces-8146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FB19AC8F6C
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 15:13:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 658C25038FB
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 13:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9844235050;
	Fri, 30 May 2025 12:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qe32dgzK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D603822F3B0
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 12:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748609465; cv=none; b=Csj54Anc1MFpdF0/7HPjwde+c5pLq3RJX+9NphDltxUaWgsjJJYknePsGc6wOz0N5+DJ4HVUQajAPmGJfRgDVZXSWiDVDdTGW3Hfc3j5WTbAChm7Zk515Oqdy0CFjk4d1aaHYvU5WX8GRuipernHuSKWqcoa6GwPN8aEsfwhrn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748609465; c=relaxed/simple;
	bh=RQP7fnHSl6LyBwSlN1lkznqg+BqqYjyOjVbuBDV6P40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crJrkUywuHFfXmByjhneMRlbWowVKh0mJIGEm3gtnhtkOTJsGeUHvGZ8Piv/3fP0e1Q5CTthCh4/9GKo51Gr6B2+pGirHJikoNMiUEWmTjMo4kjNZS8zK7a0E9+MdymyHK4bQqexbOBB1wMhwoMt6PNhoHBGlUugaPg/153v/9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qe32dgzK; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-acacb8743a7so350297666b.1
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 05:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748609462; x=1749214262; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4w4s5EL3LPAIcT3i39AVtBv9aMVg1xuQgId8pQECMpE=;
        b=Qe32dgzKx1c1KNZz5dPZirKRQnj9q9gC14Jy4vyZvayIo06pTw0UGcWo9YDmGTV94G
         Uz6nVpznKJRE1dr1Acgw5sV5ZeDGj48bNOnsVff1XYPUJ79TJCwqHgYw19w0zGr1hBNz
         4s5toXiBEtFqFB4HdQEGOiT5F+8bRF2EGhvYxgVsiPQfr+r7K3cxOwUpIlM7c7fkWMtK
         j/o8BWgMRYJsMDr5V3aDRxWQv0/nJGwxxdhc4+0XgMuYqE1n1BnHwYZVx9I5VLqqrk9A
         2v6Mfw1Oon1LErtuPf9+Oo2aI4esgx0Fvu/irUL8i9hZUr28MJtAxAcNnVlc0CAGjX7N
         0/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748609462; x=1749214262;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4w4s5EL3LPAIcT3i39AVtBv9aMVg1xuQgId8pQECMpE=;
        b=As+NRlSGdAaqiIkmB9X2OKNE8QsA0EzYd1BXA6Dgaj4jwmNcaGg5dIR8/8E93EOih0
         I+B/5gW5QLxcrTOb1WihmqV9c/mXmeAL0aHmDx8yH+IMycxxd/GnQHyu+YY4DQL4peiY
         yIyQMTvrfFnPLb8y2B2Du5tTYlVnn/AAOTEPRDPbuEvUtXE2hCRfprEyTR2uoonXhott
         JfPkqLk9rSm2RLDhEFW5kacO1art4KdItZpHxbx9jjJfPBq8pe1jSDEacatZHwHDMIu2
         901ny1GLB4CR7lxXrpvRuKZUfuCUvs/scx5b9Ma56a/swouVCPw3r3UTlo0fD+DWSiOv
         V1gQ==
X-Gm-Message-State: AOJu0YxIm60toebWLqq2sAxb5vDbBWnk5d5uIt8YJ1rXOFN0SsV9jNiK
	xW2gn5CH3YhVzTUZmQNjqgIMSzPdEu1cyH6ss2QHy6n5F7YaZPcgUICCuzQovA==
X-Gm-Gg: ASbGncsGbIZLkHBH3CaslXCYxYrQVN43tB/gc/wWnhiIjCSDvi+q3CqCGZtV32sWpfB
	Dcm0MBXCBex0YhJJyuSORQ3f6+q2a0zPyVVyA5Icqv7qHuzPEp4hT1Ex3KFreGAnOdqzT45G29r
	PubFUD1yEaSidzTGejyHwIvinY/SeAl3vqUy+MpdbEpY5u3aulVVfI0gL1cmwJnOSWgFiiEBKuD
	tccdKsnqt2oYasbyVvxG6XsOQySIHvmopt5DmXpBDO00q29Sb//9Mb/HTQIPFVvOiu/iPjCt/tn
	JvVCvjwTajlzaYhwpX/YvSuztzZX2dxlJtG7yfI534YP3crfntHe8g+Q
X-Google-Smtp-Source: AGHT+IFztvDZUlnuT0tPwdW2lwd1q+nnlbHAmPEJL71IHPDLTcJF5Pcr1p4MWYmzGAA51dvxkGDguQ==
X-Received: by 2002:a17:907:968d:b0:ad8:942b:1d53 with SMTP id a640c23a62f3a-ad8b0e8c9eamr616273566b.27.1748609461621;
        Fri, 30 May 2025 05:51:01 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:a320])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad39420sm323234266b.136.2025.05.30.05.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 05:51:00 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 5/6] io_uring/mock: support for async read/write
Date: Fri, 30 May 2025 13:52:02 +0100
Message-ID: <6e796628f8f9e7ad492b0353f244ab810c9866d7.1748609413.git.asml.silence@gmail.com>
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

Let the user to specify a delay to read/write request. io_uring will
start a timer, return -EIOCBQUEUED and complete the request
asynchronously after the delay pass.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 59 +++++++++++++++++++++++++++++++++++++++++---
 io_uring/mock_file.h |  4 ++-
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 517d75fac888..2f9a0269eedd 100644
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
 #include "mock_file.h"
 
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
@@ -159,6 +206,9 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 		return -EINVAL;
 	if (mc.file_size > SZ_1G)
 		return -EINVAL;
+	if (mc.rw_delay_ns > NSEC_PER_SEC)
+		return -EINVAL;
+
 	mf = kzalloc(sizeof(*mf), GFP_KERNEL_ACCOUNT);
 	if (!mf)
 		return -ENOMEM;
@@ -168,6 +218,7 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 		goto fail;
 
 	mf->size = mc.file_size;
+	mf->rw_delay_ns = mc.rw_delay_ns;
 	file = anon_inode_create_getfile("[io_uring_mock]", &io_mock_fops,
 					 mf, O_RDWR | O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index b2b669f7621f..0ca03562359f 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
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
-- 
2.49.0


