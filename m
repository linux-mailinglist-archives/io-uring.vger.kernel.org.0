Return-Path: <io-uring+bounces-4745-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC7A09CFA54
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 23:46:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7469B47FC1
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 22:06:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6801FDFA8;
	Fri, 15 Nov 2024 21:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YoqGRVPB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED82E1FDF92
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 21:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706407; cv=none; b=RKnf3uDZ4SZ5blPfJwxEnID2p+gS/mknbJFOqogbQz3at0g2RQhXGO87377sCybylMrJS0QVawi/5zzW9mbK1L8KjLhcFuBnDlT6+6holOoROAeODwUOJYNizxSskGXOvkS4B7CfIp/7CQ/8HK6bto9femfB1Z4MvIvtas3bdvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706407; c=relaxed/simple;
	bh=E6JcGxrQ+7CI4dw2g5XIAUujxTwRMxCMZ1VlKh1CyeA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YuuMp4aIe46aOlFuaDV/6Vn6JCvC8cI5QSHHTRJ/X/tnaNgDnoIB1ZRurBap955FhE+xDKXIc503v7HP7t7X06ueWxkYzdK5CLHZW+UN1cBHZpfDyZucgkwXPa7VkxszWTLzUUXS6XfxA5CttCFECu8fkJU6WMyJgmsB8OK4cyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YoqGRVPB; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4316a44d1bbso9456905e9.3
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 13:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731706400; x=1732311200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=978b0PnZIA0363nKNgqJcGov/ZEBqzZkx8b+53XQc8g=;
        b=YoqGRVPB4n9ZDNpMcYU1ZwacpXVtb7NtkItzESHKrBG/NUjg35+HyGBd4UGdrTHoje
         oPyljMZnAxqkjvjhguRqaZICtivgneuDD0+wHS68iJ8FfVF60FWRcge4T6MgM4YnpXqD
         pXIL+jAreq5mCZBjaXgmjnv5oevhz35UKblxfqwwFnvlTpMTZCl4xxRE+Ye1IiSPdS7x
         0eVig6Nn61sxF79CJn0X13TKLu/9OlZljoG620OSf64gyiIy6s0TwmGvP1Sw4AdwZPlm
         aSSYOLD6FBy4sCv4IJ8e6smwc9nx36+tJzslncXa7eidBMyNZsfXzkTdhKdpX6NG+0Pc
         rzvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731706400; x=1732311200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=978b0PnZIA0363nKNgqJcGov/ZEBqzZkx8b+53XQc8g=;
        b=tkW7i15I5err+oUGdAt0SXlwjPyotscEyfL3kV8kfXaL37Y/zAbqI0wBkA/H0U2dYc
         lAy16BGOLP2kteZnhE4ke/9sTey0J81X3i3queCdbXT0ODk/QTLRUF7xFbl1t+tL3QRm
         VcUTGKvS7dYIePS2nLkb1ASxazeIbhSUS7dFLGZv1yygAPzkWIgJkrNSbh4CRWVRxgHZ
         C8MgJpspmUHVz+3EdbNcmKQA+RpPiP/6GlgI0Nfb43mzE6Fd41n0IShwnZwnOPrg8Hyr
         wzcokfUSvJM4U56C2xdig52Cloc4yGAahEbQhmqNVLq6JI4q2oEB9bfFhxWZ8xBSjLcP
         gbCQ==
X-Gm-Message-State: AOJu0Yyfl8Sikn9J9UhaPXJNaNM31Jxm80WczLZpMhGIrU+r5GY/Xyaf
	5yiaTqZyNRscZ77GdTYbNW9N4tLUKsQWNPund/tXFSiLJTbI4FAybBifrw==
X-Google-Smtp-Source: AGHT+IF/QEUbxqRM0biEbM7CJl+6wn6eteBwUsknhptFAdffiwqQIKZiFy43Cy2MOgqfkLgbXoOzkw==
X-Received: by 2002:a05:600c:4e4f:b0:430:57f2:bae5 with SMTP id 5b1f17b1804b1-432df792b27mr32720635e9.27.1731706400288;
        Fri, 15 Nov 2024 13:33:20 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382247849b0sm3397258f8f.97.2024.11.15.13.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:33:19 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 5/8] tests: convert reg-wait to regions
Date: Fri, 15 Nov 2024 21:33:52 +0000
Message-ID: <c58770f162232e03ed7a7d5dd34aad371dcf7a5c.1731705935.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731705935.git.asml.silence@gmail.com>
References: <cover.1731705935.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 217 ++++++++++++++++++------------------------------
 1 file changed, 83 insertions(+), 134 deletions(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index 6a5123a..5f5a62a 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -14,123 +14,9 @@
 #include "helpers.h"
 #include "test.h"
 
+static int page_size;
 static struct io_uring_reg_wait *reg;
 
-static int test_invalid_reg2(void)
-{
-	struct io_uring ring;
-	void *buf, *ptr;
-	int ret;
-
-	io_uring_queue_init(1, &ring, 0);
-
-	if (posix_memalign(&buf, 4096, 4096))
-		return T_EXIT_FAIL;
-	memset(buf, 0, 4096);
-	ptr = buf + 4096 - 32;
-
-	ret = io_uring_register_wait_reg(&ring, ptr, 1);
-	if (ret != -EINVAL) {
-		fprintf(stderr, "register cqwait: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
-
-	ptr = buf + (sizeof(struct io_uring_reg_wait) / 2);
-	ret = io_uring_register_wait_reg(&ring, ptr, 1);
-	if (ret != -EINVAL) {
-		fprintf(stderr, "register cqwait: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
-
-	free(buf);
-	buf = (void *) 0x1000;
-	ret = io_uring_register_wait_reg(&ring, buf, 1);
-	if (ret != -EFAULT) {
-		fprintf(stderr, "register cqwait: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
-
-	buf = (void *) 0x1240;
-	ret = io_uring_register_wait_reg(&ring, buf, 1);
-	if (ret != -EFAULT) {
-		fprintf(stderr, "register cqwait: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
-
-	buf = (void *) 0x1241;
-	ret = io_uring_register_wait_reg(&ring, buf, 1);
-	if (ret != -EINVAL) {
-		fprintf(stderr, "register cqwait: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
-
-	io_uring_queue_exit(&ring);
-	return T_EXIT_PASS;
-}
-
-static int test_invalid_reg(void)
-{
-	struct io_uring_reg_wait *ireg;
-	struct io_uring_cqe *cqe;
-	struct io_uring ring;
-	struct timeval tv;
-	void *buf, *ptr;
-	int ret;
-
-	io_uring_queue_init(1, &ring, 0);
-
-	if (posix_memalign(&buf, 4096, 4096))
-		return T_EXIT_FAIL;
-	memset(buf, 0, 4096);
-	ptr = buf + 512;
-	ireg = ptr;
-
-	ret = io_uring_register_wait_reg(&ring, ireg, 56);
-	if (ret) {
-		fprintf(stderr, "register cqwait: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
-
-	ireg = ptr;
-	memset(ireg, 0, sizeof(*ireg));
-	ireg->ts.tv_sec = 1;
-	ireg->ts.tv_nsec = 0;
-	ireg->flags = IORING_REG_WAIT_TS;
-
-	gettimeofday(&tv, NULL);
-	ret = io_uring_submit_and_wait_reg(&ring, &cqe, 1, 0);
-	if (ret != -ETIME) {
-		fprintf(stderr, "wait_reg failed: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
-
-	ret = mtime_since_now(&tv);
-	/* allow some slack, should be around 1.1s */
-	if (ret < 1000 || ret > 1200) {
-		fprintf(stderr, "wait too long or short: %d\n", ret);
-		goto err;
-	}
-
-	memset(ireg, 0, sizeof(*ireg));
-	ireg->ts.tv_sec = 1;
-	ireg->ts.tv_nsec = 0;
-	ireg->flags = IORING_REG_WAIT_TS;
-
-	gettimeofday(&tv, NULL);
-	ret = io_uring_submit_and_wait_reg(&ring, &cqe, 1, 56);
-	if (ret != -EFAULT) {
-		fprintf(stderr, "out-of-range reg_wait failed: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
-
-	free(buf);
-	io_uring_queue_exit(&ring);
-	return T_EXIT_PASS;
-err:
-	io_uring_queue_exit(&ring);
-	return T_EXIT_FAIL;
-}
-
 static int test_invalid_sig(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
@@ -164,6 +50,39 @@ static int test_invalid_sig(struct io_uring *ring)
 	return T_EXIT_PASS;
 }
 
+static int test_offsets(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	int max_index = page_size / sizeof(struct io_uring_reg_wait);
+	struct io_uring_reg_wait *rw;
+	int ret;
+
+	rw = reg + max_index;
+	memset(rw, 0, sizeof(*rw));
+	rw->ts.tv_sec = 0;
+	rw->ts.tv_nsec = 1000;
+
+	ret = io_uring_submit_and_wait_reg(ring, &cqe, 1, 0);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "max+1 index failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	rw = reg + max_index - 1;
+	memset(rw, 0, sizeof(*rw));
+	rw->flags = IORING_REG_WAIT_TS;
+	rw->ts.tv_sec = 0;
+	rw->ts.tv_nsec = 1000;
+
+	ret = io_uring_submit_and_wait_reg(ring, &cqe, 1, max_index - 1);
+	if (ret != -ETIME) {
+		fprintf(stderr, "last index failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	return 0;
+}
+
 static int test_basic(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
@@ -192,27 +111,50 @@ err:
 	return T_EXIT_FAIL;
 }
 
-static int test_ring(void)
+static int test_wait_arg(void)
 {
+	struct io_uring_region_desc rd = {};
+	struct io_uring_mem_region_reg mr = {};
 	struct io_uring ring;
-	struct io_uring_params p = { };
+	void *buffer;
 	int ret;
 
-	p.flags = 0;
-	ret = io_uring_queue_init_params(8, &ring, &p);
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_R_DISABLED);
 	if (ret) {
+		if (ret == -EINVAL) {
+			printf("IORING_SETUP_R_DISABLED not supported, skip\n");
+			return 0;
+		}
 		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	buffer = aligned_alloc(page_size, page_size * 4);
+	if (!buffer) {
+		fprintf(stderr, "allocation failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	rd.user_addr = (__u64)(unsigned long)buffer;
+	rd.size = page_size;
+	rd.flags = IORING_MEM_REGION_TYPE_USER;
+	mr.region_uptr = (__u64)(unsigned long)&rd;
+	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
+
+	ret = io_uring_register_region(&ring, &mr);
+	if (ret) {
+		fprintf(stderr, "region reg failed %i\n", ret);
 		return 1;
 	}
 
-	reg = io_uring_setup_reg_wait(&ring, 64, &ret);
-	if (!reg) {
-		if (ret == -EINVAL)
-			return T_EXIT_SKIP;
-		fprintf(stderr, "setup_reg_wait: %d\n", ret);
+	ret = io_uring_enable_rings(&ring);
+	if (ret) {
+		fprintf(stderr, "io_uring_enable_rings failure %i\n", ret);
 		return T_EXIT_FAIL;
 	}
 
+	reg = buffer;
+
 	ret = test_basic(&ring);
 	if (ret == T_EXIT_FAIL) {
 		fprintf(stderr, "test failed\n");
@@ -225,27 +167,34 @@ static int test_ring(void)
 		goto err;
 	}
 
-	ret = test_invalid_reg();
+	ret = test_offsets(&ring);
 	if (ret == T_EXIT_FAIL) {
-		fprintf(stderr, "test_invalid_reg failed\n");
+		fprintf(stderr, "test_offsets failed\n");
 		goto err;
 	}
-
-	ret = test_invalid_reg2();
-	if (ret == T_EXIT_FAIL) {
-		fprintf(stderr, "test_invalid_reg2 failed\n");
-		goto err;
-	}
-
 err:
+	free(buffer);
 	io_uring_queue_exit(&ring);
 	return ret;
 }
 
 int main(int argc, char *argv[])
 {
+	int ret;
+
 	if (argc > 1)
 		return 0;
 
-	return test_ring();
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0) {
+		perror("sysconf(_SC_PAGESIZE)");
+		return 1;
+	}
+
+	ret = test_wait_arg();
+	if (ret == T_EXIT_FAIL) {
+		fprintf(stderr, "test_wait_arg failed\n");
+		return 1;
+	}
+	return 0;
 }
-- 
2.46.0


