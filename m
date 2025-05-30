Return-Path: <io-uring+bounces-8129-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EF92AAC8A0D
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 10:37:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 69EBB9E7C17
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 08:36:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F78D2185BC;
	Fri, 30 May 2025 08:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hrnLGRk3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8F72192EF
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 08:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748594237; cv=none; b=XFpX00H/7gofX6suhMBXG4/xhuuI+uyzaV7lH5S3gW4BaKssEXhIpnzLZKBzeGEQE1NIYrCS/4d23VeTMar9+np4AQmlOTvHXj905oKyP+/wBCi/+mxqNcQg+6zQWBfd2Su0sxlpYU6m7HYzLosHFIongI97SzybSbBoLmZstuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748594237; c=relaxed/simple;
	bh=MrpdoXYeJ9kWOhR00pfkPW2c+CZnvgIRt2NyR4WN1gs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dohm2qXM1i28ICaOxn/0XkxBKWASTlUKp8JlP4viUpsX7LKsdwLSka/b7p6VldRPoSziheWOVLV20fI/g1OgIa7au5L9DJWjHM3wGjNHid6RFnkDrwmxEprkPwswYXW6wTOCdjQrr6vyq9xEOnq102qTvm26jo7u3bQ3nngXIsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hrnLGRk3; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9ebdfso3241171a12.3
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 01:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748594233; x=1749199033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/VShvbRvJ9UOPjbwFBZsnICFgcJNl/+eXnDJ6U+Qmio=;
        b=hrnLGRk3JuHn0jOTjKPxsFJpBSh/UTEvD47QLW9p/xq6+e16p6cV/7eY26cQTNKg5r
         KcYU3eLMWgpMCiNrjNNIffJ+RMnovOoMDmm6I8Nlsb65OI+Tv43yiga4EDydNAVI2mVa
         2GIyKfjRowdq0NfZhNVQ47YqjBMpk6HYchncceYwcct/hbz42qeM6odjd4vQhy/ffVUe
         Qcv6Iu1zoGX6WMK8aGU9I0JxsT23cCgZlosLJE2S47k1rwOFknzHpvfjAVDBbFxlohJa
         sT2Cu/uOJ8rg2HZ3Z9EmQydNPKMvItiehVbI4Ml2HpTZBI3cIFYe9yR5B9LCfU1udPGt
         ykkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748594233; x=1749199033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/VShvbRvJ9UOPjbwFBZsnICFgcJNl/+eXnDJ6U+Qmio=;
        b=lPiR28n0vee+vd0vR+4b2aBUCSm/IlJIzR2SV7PTdeMoNkwyMw9ck/92oMN0H9jptR
         wfAsXHfwx/qNDe0veG4OYr69cDv9fv1ssC2ECqxuIay/mEtCHNs6R2B4j3IxxQcVYPfT
         OtLpHf9VOzKF5dqHk5OeZHZSZgeutCXt/3vvqKOfyYYwbvFseZRhB9N7pJcN7SXw5AFo
         n0y8k96OWlIWpWNQjbGB7UUGyvvx5e/Hfjz9NVvL78tr4lm62N/+9OBgTiVEE5VJrVUu
         SO+R7i06bIhegGE8F65ADNdaLF76mfh3sfB36iMfIv9Y8UOTzUXQtxswnlnC7QJFzlfT
         g1+A==
X-Gm-Message-State: AOJu0YxuCNo6sQfPpYgy8TtC3hpnOCj2a1uYmwWfW6LteUcGScypnSBt
	yCB7o76E/AIU+Ibwp9+LTsX0KrAj1EWRhjwIeYTzAlyztih7jrWYlMRJJLTnwA==
X-Gm-Gg: ASbGncudOvYpcX5FAiLT0kbFN7W/uGJC7snfkND4LZoxlVQnt4wh83MqEXe3lThf0Cq
	V8LlWg6ar9J0xTiFaZ5jsGavK4D++NoW8Le0YLdzRJCLOYlosDezwhcCXcPuqODHiw6HTvlIoLA
	E87Jx9/+3ZyXC3KffRutjtt5GKxZV78CdBYcFBEDnLhC1RcGx/v+/lZHW7mx7kNa6zuL38J3TNp
	wnUcHEgQxSfMrB2OMWtg1QmQto/bwN4Utn4FKEoCikjnSFSyBhaYOpcFZX9PnDfWc0cTcNziHPy
	KYI6giudNbQz5DE2K5MXYbf9ddrI4gA6sGzwaIZzCQnh1Q==
X-Google-Smtp-Source: AGHT+IGQSP3d22X0tpxU+ffkPumbBtyAFMyUXJJB9KnZckyzfxtejrLjmH/UmO9w4sN9HL19AZ95lw==
X-Received: by 2002:a17:907:c0d:b0:ad4:d00f:b4ca with SMTP id a640c23a62f3a-adb36bf0694mr106292066b.50.1748594232690;
        Fri, 30 May 2025 01:37:12 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:65cd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad696d1sm288126566b.161.2025.05.30.01.37.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 01:37:11 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 5/6] io_uring/mock: support for async read/write
Date: Fri, 30 May 2025 09:38:10 +0100
Message-ID: <0ac9909b43ef5878348694399dd94982935576b3.1748594274.git.asml.silence@gmail.com>
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

Let the user to specify a delay to read/write request. io_uring will
start a timer, return -EIOCBQUEUED and complete the request
asynchronously after the delay pass.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 59 +++++++++++++++++++++++++++++++++++++++++---
 io_uring/mock_file.h |  4 ++-
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 63c7d2f07f11..6130fa66c914 100644
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


