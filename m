Return-Path: <io-uring+bounces-4762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 14AC19D00F9
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 22:27:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1E3A2837D5
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 21:27:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8741AAE23;
	Sat, 16 Nov 2024 21:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RbQnkqpm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A666199951
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 21:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731792438; cv=none; b=IMaRLiDPdBBwxXCkgmV2bDrhZvHt8ffyQlClBIjzXRxZUpaP91hbEXPEhdvIOAZA9ireQufjj4u30I6ZNHXAYp2+sq6XWIYSZPvDpaBqTPLZG4LSbO4WHfmPLt5o+DqJgYWifwjFaueyzkI/Pb79hP87OiN+YT1t/0yZJwqVn8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731792438; c=relaxed/simple;
	bh=6oCskojPouHFBRFauRD/kfM65ctb7KylFZnjAcIfZDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6xVFMhH2uwiPWJ12EOBP0dkc0kFax4FVBbBlQTo996JXyGLAHbSInVrLPq7tbxQkfHTD319lTY5mqM/dIyo/uI7yOQDGw37c5CrJqLT0+Sun4qB2/PiKUIppgEQxlyOBD35aRceyMsHOySshmN1WXipcl7X22pMiT5Vqy2k53I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RbQnkqpm; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43159c9f617so23991105e9.2
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 13:27:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731792435; x=1732397235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=40pR5Lk5LlWwR03ynPbwgMitElQCwkmpfLSghqHxoGc=;
        b=RbQnkqpmt+6jpCKeV8PgbY/bL5S7FcMLw6xo2NoJ0ExKNlOGWtF4UAh+tpin2DEXHN
         zpye11pz9EVfy3+zeahLQm4LtqBRcGXlH4RcOv2hMZjl/NDHTHVL2sbJlTn7G0KmekDl
         vctrpWWnspE/I7z572ju48/W8b7yyJmjKphQYSztuwj6mTV62YC2MWtAeGxcvkDEH/6Z
         /FyY2s1mGj1nNI65jm04YiUjlx5RwZf/0l/yfzlGvqA5ekAaHO5qyR5/B4XedPhib7lz
         xo1zdIGqjTMdF+l1EbZ2NgT8XRPbsMhyBE7oOCBfO04LViSmzYP3WWR1S4HUTax4yH1H
         BtXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731792435; x=1732397235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=40pR5Lk5LlWwR03ynPbwgMitElQCwkmpfLSghqHxoGc=;
        b=LICqMBgJVv7QvomJo4zir4HaCCxHUKISu2pyeXYbYmt7YN5ITWhtL/yuCecLYW13hO
         CiD7ptIdarDy2GYvvchRHETBCuN79QCFNuHgrEVVhjMgl4t3Ru4IBl75atwQLkkbBEvv
         fmWpfVGpqlNdRqFHdaEm1k0S9X5Lka7ipyXW6Isy/gPbDXKSzX6+ZpyqjVAtAHJBuBZx
         1mWBcXfp2IJQ4KPG4POOsH+x+8V7iRT0NbhybOHxeMvH6Sx+4aYN35dPowDnAjr/qxy2
         a7xjkqZNjs/UaZKP5YbtjN3JdG6mAZNFc1EZchcj5XrYwys/IiWYwRrn6aBcJmAzwOBI
         Arfw==
X-Gm-Message-State: AOJu0YzsYyquXAxpsz8gPCbkfotUb8cohgSSIyRLi5UqU0Zk8ZF0dyvp
	lqzCECYnC7FXSbcdxFDJYyBPXKx5zA39U29uMGg28Z7rgiVvneF2IbLWKg==
X-Google-Smtp-Source: AGHT+IFUQDcmQ6FnNbiOFbch06uSSeEhc4P2iKk97XQIlu9yE9bQZS28+XDTjRKD8kegVuubxnC8ww==
X-Received: by 2002:a05:600c:4e12:b0:431:5d4f:73b9 with SMTP id 5b1f17b1804b1-432df77c7ccmr55209615e9.26.1731792435049;
        Sat, 16 Nov 2024 13:27:15 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0aef0sm101071325e9.28.2024.11.16.13.27.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 13:27:14 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 6/8] test/reg-wait: parameterise test_offsets
Date: Sat, 16 Nov 2024 21:27:46 +0000
Message-ID: <939b7af82e46d7e857aec12cfaa74fbd42fab5a2.1731792294.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731792294.git.asml.silence@gmail.com>
References: <cover.1731792294.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index 10ab3a2..ffe4c1d 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -68,23 +68,27 @@ static int test_invalid_sig(struct io_uring *ring)
 	return T_EXIT_PASS;
 }
 
-static int test_offsets(struct io_uring *ring)
+static int test_offsets(struct io_uring *ring, struct io_uring_reg_wait *base,
+			size_t size, bool overallocated)
 {
 	struct io_uring_cqe *cqe;
-	int max_index = page_size / sizeof(struct io_uring_reg_wait);
+	int max_index = size / sizeof(struct io_uring_reg_wait);
 	struct io_uring_reg_wait *rw;
 	unsigned long offset;
+	int copy_size;
 	int ret;
 
-	rw = reg + max_index;
-	memcpy(rw, &brief_wait, sizeof(brief_wait));
+	if (overallocated) {
+		rw = base + max_index;
+		memcpy(rw, &brief_wait, sizeof(brief_wait));
+	}
 	ret = io_uring_submit_and_wait_reg(ring, &cqe, 1, max_index);
 	if (ret != -EFAULT) {
 		fprintf(stderr, "max+1 index failed: %d\n", ret);
 		return T_EXIT_FAIL;
 	}
 
-	rw = reg + max_index - 1;
+	rw = base + max_index - 1;
 	memcpy(rw, &brief_wait, sizeof(brief_wait));
 	ret = io_uring_submit_and_wait_reg(ring, &cqe, 1, max_index - 1);
 	if (ret != -ETIME) {
@@ -100,8 +104,10 @@ static int test_offsets(struct io_uring *ring)
 	}
 
 	offset = page_size - sizeof(long);
-	rw = (void *)reg + offset;
-	memcpy(rw, &brief_wait, sizeof(brief_wait));
+	rw = (void *)base + offset;
+	copy_size = overallocated ? sizeof(brief_wait) : sizeof(long);
+	memcpy(rw, &brief_wait, copy_size);
+
 	ret = test_wait_reg_offset(ring, 1, offset);
 	if (ret != -EFAULT) {
 		fprintf(stderr, "OOB offset failed: %d\n", ret);
@@ -109,7 +115,7 @@ static int test_offsets(struct io_uring *ring)
 	}
 
 	offset = 1;
-	rw = (void *)reg + offset;
+	rw = (void *)base + offset;
 	memcpy(rw, &brief_wait, sizeof(brief_wait));
 	/* undefined behaviour, check the kernel doesn't crash */
 	(void)test_wait_reg_offset(ring, 1, offset);
@@ -201,7 +207,7 @@ static int test_wait_arg(void)
 		goto err;
 	}
 
-	ret = test_offsets(&ring);
+	ret = test_offsets(&ring, buffer, page_size, true);
 	if (ret == T_EXIT_FAIL) {
 		fprintf(stderr, "test_offsets failed\n");
 		goto err;
-- 
2.46.0


