Return-Path: <io-uring+bounces-4744-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 413A39CF90D
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 23:06:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD80B28149E
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 22:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371181FB3D5;
	Fri, 15 Nov 2024 21:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OSYXS2P6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B2541FDF92
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 21:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731706405; cv=none; b=YMOb0Yy79XJwsAy+xrQqIbKrXjFi8clrvDJt6pkeIiB36OEs0MbnLeL/mkrhpvo624kYbSH6BUm4Blgoame+7gukLAf5o17eaWVo2mIcoon863GV7uIYSKWU4k6boLONFrn5j/otawEd6x5jnQXtNzFSlWgTHbJNpKDDZjWUfn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731706405; c=relaxed/simple;
	bh=zBrYdvmR0T1XcG/DyeBSjti4eEZ9Z4IkaqV/O2X47Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3ykOpYr3toJl4imLQ5Mr5Zcl+4u/l4wFW3RUoyuXQLEglipCy17DIOyIvX3w3cLpOnHwsIX0VkLZXUEv1NhyfxWFrZR7aYuMk87lyasXF4K6nOwNDYNnHmjvT2S16Yc0ONa3CF7DFT0Gv3g936CzAiAVmjd0ac/UqSCE0IC6R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OSYXS2P6; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37d518f9abcso1581211f8f.2
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 13:33:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731706399; x=1732311199; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hTRlc2vdOeYWq9i9ffDOQgc0z4rPfWnbn+mnV5mimfA=;
        b=OSYXS2P6DDUoisbPKKOuf05Sb1nhhZjcyeUZoJjihxfCsxtmpcitBuvReKW3vaWG00
         VEdWbc2jlVWUS9qbnuELs6LOCoTV/GTAZ4HXjTV1UQSn62h1g3RY06v2mpbK4o8KfT+8
         Mjs0LPH2LnxRQJpfpWbGDUkifbcXpEaztBR5rYRIG1A/6meTbiMaO84LJzzqvVkwTfjO
         gJ/1qW0G2mLSCepTflS+dE52BgZG2K+rqEX8ivTm82yLQ+Ds1i0KvghkixKeBbu7NfUr
         PYhmV6QOGrDSyDVx3kDg7XrTze41ZoylTmyEWk9EWngm0XQSaCaM1ct9JrCcxKu9TNFK
         SEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731706399; x=1732311199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hTRlc2vdOeYWq9i9ffDOQgc0z4rPfWnbn+mnV5mimfA=;
        b=eMCcpS8+SBsxlS0ED1y9TpQAivn2kWZEBHAPPWv6Rmu5DsE53XJ4tf0LzZZQf5YEIx
         h2/UV4h4Od2tt2PgvK9znpHBO5PAvYIfe5rlCu7XyIqRGRejdfDN5V9XsAhYDq/+kjTs
         IaRLLNJ2RLlaMaa0TLO9fkUbLOoRyTCKbiH9+ZQn6aDARsZksxvuWsfs2MOP68uoDsss
         z0RA58gqKQ6clGBrKduhmQdbscZj3SZWemjAQrIAJQhhv1W+Nk/A109yXGYrYPezNog1
         NIg27crf6Fvb4r81oZKo/Ui2wcK/C+fsJBwHTFrjZ/b5alUMGAXJR3FzKdBqdV5tSi8L
         EeDA==
X-Gm-Message-State: AOJu0Yx2fwcDSxBDgJSzQeHhzWYMF8SBMVVQL2r+LCb+q1VXzuPvWBbX
	th9u6INRedHAq/C6qVfZclr46SJFl5yrjurrgh7M59oDP29MTGd7Yx/y9w==
X-Google-Smtp-Source: AGHT+IE3dV9YKC/QHTHKwPboyKTZZ/tZIE1wHalGB8mdItxRfZxAzdTiMpy6lgFoEqQyvkAdxt0tFQ==
X-Received: by 2002:a5d:47a9:0:b0:382:359f:5333 with SMTP id ffacd0b85a97d-382359f54e6mr3839f8f.22.1731706398700;
        Fri, 15 Nov 2024 13:33:18 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-382247849b0sm3397258f8f.97.2024.11.15.13.33.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 13:33:14 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 4/8] examples: convert reg-wait to new api
Date: Fri, 15 Nov 2024 21:33:51 +0000
Message-ID: <45f88d24de240c3823e6cc04496a54d62d5d6305.1731705935.git.asml.silence@gmail.com>
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
 examples/reg-wait.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/examples/reg-wait.c b/examples/reg-wait.c
index 375538c..0e119aa 100644
--- a/examples/reg-wait.c
+++ b/examples/reg-wait.c
@@ -38,6 +38,20 @@ static unsigned long long mtime_since_now(struct timeval *tv)
 	return mtime_since(tv, &end);
 }
 
+static int register_memory(struct io_uring *ring, void *ptr, size_t size)
+{
+	struct io_uring_region_desc rd = {};
+	struct io_uring_mem_region_reg mr = {};
+
+	rd.user_addr = (__u64)(unsigned long)ptr;
+	rd.size = size;
+	rd.flags = IORING_MEM_REGION_TYPE_USER;
+	mr.region_uptr = (__u64)(unsigned long)&rd;
+	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
+
+	return io_uring_register_region(ring, &mr);
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring_reg_wait *reg;
@@ -48,30 +62,43 @@ int main(int argc, char *argv[])
 	unsigned long msec;
 	struct timeval tv;
 	int ret, fds[2];
+	int page_size;
 
 	if (argc > 1) {
 		fprintf(stdout, "%s: takes no arguments\n", argv[0]);
 		return 0;
 	}
 
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0) {
+		fprintf(stderr, "sysconf(_SC_PAGESIZE) failed\n");
+		return 1;
+	}
+
 	if (pipe(fds) < 0) {
 		perror("pipe");
 		return 1;
 	}
 
-	ret = io_uring_queue_init(8, &ring, 0);
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_R_DISABLED);
 	if (ret) {
 		fprintf(stderr, "Queue init: %d\n", ret);
 		return 1;
 	}
 
 	/*
-	 * Setup wait region. We'll use 32 here, but 64 is probably a more
-	 * logical value, as it'll pin a page regardless of size. 64 is the
-	 * max value on a 4k page size architecture.
+	 * Setup a region we'll use to pass wait arguments. It should be
+	 * page aligned, we're using only first two wait entries here and
+	 * the rest of the memory can be reused for other purposes.
 	 */
-	reg = io_uring_setup_reg_wait(&ring, 32, &ret);
+	reg = aligned_alloc(page_size, page_size);
 	if (!reg) {
+		fprintf(stderr, "allocation failed\n");
+		return 1;
+	}
+
+	ret = register_memory(&ring, reg, page_size);
+	if (ret) {
 		if (ret == -EINVAL) {
 			fprintf(stderr, "Kernel doesn't support registered waits\n");
 			return 1;
@@ -80,6 +107,12 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	ret = io_uring_enable_rings(&ring);
+	if (ret) {
+		fprintf(stderr, "io_uring_enable_rings failure %i\n", ret);
+		return 1;
+	}
+
 	/*
 	 * Setup two distinct wait regions. Index 0 will be a 1 second wait,
 	 * and region 2 is a short wait using min_wait_usec as well. Neither
@@ -154,6 +187,6 @@ int main(int argc, char *argv[])
 	 * Cleanup after ourselves
 	 */
 	io_uring_queue_exit(&ring);
-	io_uring_free_reg_wait(reg, 32);
+	free(reg);
 	return 0;
 }
-- 
2.46.0


