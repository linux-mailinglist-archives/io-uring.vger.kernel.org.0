Return-Path: <io-uring+bounces-8965-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 74963B2733D
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 01:53:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04FE5720C69
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 23:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DB772877F0;
	Thu, 14 Aug 2025 23:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FAFCeB25"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D742728934E;
	Thu, 14 Aug 2025 23:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755215512; cv=none; b=LcPBcoTXNGOKlyHKok9Ga1JDaj88sw5I3Q1EkYzBEIH4bP7vf5G7K9g+wdWj1jVLMap0nJX7MOangH6ceanfYxpAoH8KxrYBLvPuuZ+1xANW6+MePve2Z7STFM6Cscm7rNNRWYf13GyZL/MGutTmKMP4hL1/qLgHAnFyk907MmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755215512; c=relaxed/simple;
	bh=MwlJlG9BCmSDHDIQwnA9rfiKmfClrGDcoSa5O56YSc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7QxrEtpT3L9No6GFM/x3tpMxhGbFudNT5bPUwMDV3JpsGZmPSuZ/6QEo2Yr7zcDhpg8X4/j59NjrB1zbLe/AoURyhZ7Zw7ReLDsMIgYJg4oxWVid4ZSFycIaxTKoiQvOmR/o5sdGLqO3QxqS4TDatRg3olqXoRO1tGDPFV+iGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FAFCeB25; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-323267b98a4so1491108a91.1;
        Thu, 14 Aug 2025 16:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755215510; x=1755820310; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KR47jX9nVD4yPePrBT/Om9oTPyKyNSOhJ/PiCcVWOU4=;
        b=FAFCeB251r0CCJZADXi49pNQKiRdvq7labdaGXgo8hk7pSeJcP4fau6DPQ6K8Rth/s
         0+JTEDITaDLkxcXYoVJvmqzbj4WOdzhbjsIZ8rTvkMPxmTujI1YxBMx2B10cIo/zer81
         K597oQ3JDcs5P6EqL2AAVMrRQj2us5IY1zad4+hyECYuMQh1mBkYf8lUUWM3Wm9qLC9X
         vSV7jVv8VGhh5rRuTG7iG+L4P+xWC8K321kuaweMKisXAd+0K8mGSsqWb8EcgtNkGXpt
         g50JpAT6rOVoXNb8dwsW1CxUnNUuOrTjLO65eSJWU6sKyt+DOiupJoeIm41C+WfVO39o
         PRrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755215510; x=1755820310;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KR47jX9nVD4yPePrBT/Om9oTPyKyNSOhJ/PiCcVWOU4=;
        b=MJ3o5YB8CDfKFHqtXKk8CweOqwypvWzSU18Hxt/9MQ1KqvYIzK0sUEeStAGFn0UtAo
         +6Iflbyhh1Jw/b46SOLRQ/e17PGVdTiklhp89AAv2ilnejiedbGoaAsQnBagoCbgVOH+
         WFPPbEGuUvD837a7X7TlOKORvN0vhb7CkGu2l3KykXbY2CStb5qRW9KiE48LqfMCAi9d
         yw41hNx/4m2Q5VdaioXRAQ2X0u2YRaJw9Au/+XpVVR5DxdDLcOEo2oX13G9Q1teQbSBo
         NHL/E/9lN+Xhk8SrAv1OoM/0U5w4AaAb7jIq9utBWUaFXRQ8+NNSeXaxIjzeuv47OxCd
         yiAA==
X-Forwarded-Encrypted: i=1; AJvYcCUBTWso5wqvLfFq8hVfP8kGWzG04Uqo6LuJ9ZFhSCLgElTIMn/f4sQ41H3H1tzHUulGQCy+p8g4L10r7RjH@vger.kernel.org, AJvYcCX4Ag9F0ZKG2c6N07r/Wd1Vko6yRqQmoHGCf+RK/62+mxvmn5saF1i2gax5J8glDFxdDD7AEzhEKNFb@vger.kernel.org
X-Gm-Message-State: AOJu0Yx35EETgXe7Ik/uoPORi9vVfmDq3kkrM41dwXKUm7o1tDk9dx3h
	ehNdCbcGMFsjoKHwwc8BgAf9tD5x4jMr5bLwFwSouU6mv60lRnt0B7yjq28Av68Qyxk=
X-Gm-Gg: ASbGncv72QbZVY9/hYZL1vj23GntA5lriOiF6e78KFva8vrpHirSmKCIXnhJlp+WEvw
	dna7IoxLvmWs59WdZOrHRZj37758AJUfrNZkQnpmaEfRM4LjM/hFWPHXpSnWJAyaNtja6izISWb
	8+k4KiPSeROuJMCSlacI+T+/IHvidMVymcDV71EaHSBJyljpvCujLQyrYlz42lEhLJ15NCP7DfY
	7/yhcaGu8iKicHXK3+hSa0M6umvpfv5PhXJKVOEZDPKqjHxniJKo5RFNlP/sRLmsKVtO+L4Uljs
	0wAT9dOhdoQgnPmYgkpWMnDXOLUt5dDiBM+6g5adx5N0yNZirDB1XNuLskPA7Q+drxglLy2MNDn
	4HOfvqyybXtd80Jd5q/P1wQQ0
X-Google-Smtp-Source: AGHT+IEC8g+SGVBDGskmvJEGepb+f84DGBvsOk3jAI52ADtmj+InChQoanX+o/7UUGu75V8ZTcUuwg==
X-Received: by 2002:a17:90b:5450:b0:323:284a:5c3f with SMTP id 98e67ed59e1d1-32341e0f372mr235713a91.8.1755215509969;
        Thu, 14 Aug 2025 16:51:49 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233100c1d0sm2974721a91.17.2025.08.14.16.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 16:51:49 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 5/6] io_uring: add __io_open_prep() helper
Date: Thu, 14 Aug 2025 17:54:30 -0600
Message-ID: <20250814235431.995876-6-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814235431.995876-1-tahbertschinger@gmail.com>
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This adds a helper, __io_open_prep(), which does the part of preparing
for an open that is shared between openat*() and open_by_handle_at().

It excludes reading in the user path or file handle--this will be done
by functions specific to the kind of open().

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 io_uring/openclose.c | 30 ++++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 8 deletions(-)

diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index f15a9307f811..8be061783207 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -58,11 +58,10 @@ static bool io_openat_force_async(struct io_open *open)
 	return open->how.flags & (O_TRUNC | O_CREAT | __O_TMPFILE);
 }
 
-static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+/* Prep for open that is common to both openat*() and open_by_handle_at() */
+static int __io_open_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
-	const char __user *fname;
-	int ret;
 
 	if (unlikely(sqe->buf_index))
 		return -EINVAL;
@@ -74,6 +73,26 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		open->how.flags |= O_LARGEFILE;
 
 	open->dfd = READ_ONCE(sqe->fd);
+
+	open->file_slot = READ_ONCE(sqe->file_index);
+	if (open->file_slot && (open->how.flags & O_CLOEXEC))
+		return -EINVAL;
+
+	open->nofile = rlimit(RLIMIT_NOFILE);
+
+	return 0;
+}
+
+static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
+	const char __user *fname;
+	int ret;
+
+	ret = __io_open_prep(req, sqe);
+	if (ret)
+		return ret;
+
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	open->filename = getname(fname);
 	if (IS_ERR(open->filename)) {
@@ -82,11 +101,6 @@ static int __io_openat_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 		return ret;
 	}
 
-	open->file_slot = READ_ONCE(sqe->file_index);
-	if (open->file_slot && (open->how.flags & O_CLOEXEC))
-		return -EINVAL;
-
-	open->nofile = rlimit(RLIMIT_NOFILE);
 	req->flags |= REQ_F_NEED_CLEANUP;
 	if (io_openat_force_async(open))
 		req->flags |= REQ_F_FORCE_ASYNC;
-- 
2.50.1


