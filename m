Return-Path: <io-uring+bounces-4902-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C3DD09D449A
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:39:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80813282D7C
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:39:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 584F91C4A24;
	Wed, 20 Nov 2024 23:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dixf142m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8031C304F
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145960; cv=none; b=mG2uHFyWih4Pt5tcApH0APaXaRiJAqlkm7xbsOJWlVxzowkgQeMMBsr9Xehr/HKV3+wdMTX20UI0e34XAHrzVtN8/mY7z+KOECnqHKnGB9rRoHpcfnxXM/Y16jv99h53HE4y6Nnf/3ieRwvd3eCx7NGSAwkAOmRNjIhACUeBU/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145960; c=relaxed/simple;
	bh=L2B3JsoWYtc7K/z17sFcQCnlYHwaq7AEdp+VwXjhI0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8iLtCp4cslirb18beHIIRrxa6Q8qN8qfFKL/WwXICrGsZkpfe22oBNMz14uDs4nOBmDjQoyv5Fxmw84RxkTaZovhLl4EOlPDl8V2eQFHY8PleQrkf/hGpv90Vo5ta/2dbQXAAOpo4LxWWKbP9cf9DSjp+fcgBdvjC5In5qEomM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dixf142m; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-53dcb6f68b1so116927e87.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:39:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145956; x=1732750756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+eqVQFABLZJJv+bkoApoYkStReOdoYQCm+mvVfO46wk=;
        b=Dixf142mMt+I/063sOg8gZ61QGQwx8JF5eiQvs5L2MLeXL4Jc5zdFWRl6e1Nqv5hVk
         anhcxW533RwhU8QoMwsZWtph2je02P92NHfm7q16eCQp0dRMSgM0w242ZBVTyDnSDmvh
         kx8KusUDhhYzpfn1yaxZ7G8D+9lJQIKs3lO4f6m/Ya7s27g/a88PUX0G36b3sQ6bVltL
         SJzj73SpiH5CRkSb6UPq+WcWFDT8Ofxe8yZotw/DiMz/uf0wzs7huf5DpT92E8HBzzfS
         DDhfNLjeW/mbEZDx5capOe7XINa+sJTyapJdOQG2/brTeTowEj/F1GsFVR0qdgp8Lkby
         3A3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145956; x=1732750756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+eqVQFABLZJJv+bkoApoYkStReOdoYQCm+mvVfO46wk=;
        b=lFIm4viGnR8iYzGjwd0wxrG3zlrOcdN497PcWMjubzcR1iA5OrfkmbLs+9swFtGeod
         p/IyVeP5QkEGnjKN42bGCWArCaYxd9Ok92b/VQ9MPaxlEcquJbq81qGZ35hgOohxzRx/
         mfnV3b4Uj3NPa16WmjJ9zfslKVK233YhXD2j7jNmY/4/n+wxRQZdU5YRGRi1LVOQEXGS
         hpAZ54zjoKWxhV+9XH9Rlg6/bo7MG0G50xg3dRxpJY++4gZRVgG4I2ZMQTV3d4DdBHp1
         nYjwtlUWDuICcAuioD0lk463a+rkA39QaLCNgiI8HmdiSx2hY/ePPdn3MPxm32CYz8fD
         qCBQ==
X-Gm-Message-State: AOJu0YzVNUXpw6H43cghqC8+ygXS8W3yj9+kHiU4bRflxI6kGl0TwBw+
	A0D7w37Ws0T92eTgWv95gphPWEwXRgH/2fJ67GZE7U5b2iq8nHI7fg/owA==
X-Gm-Gg: ASbGncvcl1G27vrJJVCkVx2yMlcJYLEo8YgLGXcoLu+5kIrF83uqrPIs7TxUZO0DpTU
	/Q39HFNZIOhz3N360iM/6+QnDbm6XCPh5knq6hvIeOFexaz1h3yhaVHkMjxKlT8Kbg2BG2e+7nR
	GAzdXkXm3s2XanAfvs0F6ktH7UKHMarqNPCrjXcyqWVRMt3PmOxu+A1YSZDTw2fHuKCYiuLouVL
	5RaLB+s7T3rBxZs8/x/SUZRjTUvM4CcBsbfJjWIpR8NALGOlhPy+7NnvzBd1Qyq
X-Google-Smtp-Source: AGHT+IHR60F02KPCqEE0F/4KiXNLNafuOOCQdC0QwkwufuV7ElgmnehKSFb5fnfhRZJQPaZAds/6+A==
X-Received: by 2002:a05:6512:3a87:b0:539:f93d:eb3d with SMTP id 2adb3069b0e04-53dc1369cbfmr2070679e87.46.1732145955514;
        Wed, 20 Nov 2024 15:39:15 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f418120fsm12544566b.78.2024.11.20.15.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:39:15 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 3/4] test/reg-wait: add allocation abstraction
Date: Wed, 20 Nov 2024 23:39:50 +0000
Message-ID: <75e1f917fa8cec832065e4edc08e2c04644545cf.1731987026.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731987026.git.asml.silence@gmail.com>
References: <cover.1731987026.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/reg-wait.c | 82 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 26 deletions(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index 9b18ab1..d59e51b 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -67,12 +67,6 @@ err:
 	return ret;
 }
 
-static int init_ring_with_region(struct io_uring *ring, unsigned ring_flags,
-				 struct io_uring_mem_region_reg *pr)
-{
-	return __init_ring_with_region(ring, ring_flags, pr, true);
-}
-
 static int page_size;
 static struct io_uring_reg_wait *reg;
 
@@ -407,15 +401,49 @@ out:
 	return 0;
 }
 
-static void *alloc_region_buffer(size_t size, bool huge)
+struct t_region {
+	void *ptr;
+	bool user_mem;
+	size_t size;
+};
+
+static void t_region_free(struct t_region *r)
 {
+	if (r->ptr)
+		munmap(r->ptr, r->size);
+}
+
+static int t_region_create_user(struct t_region *r,
+				struct io_uring *ring,
+				bool huge)
+{
+	struct io_uring_region_desc rd = {};
+	struct io_uring_mem_region_reg mr = {};
 	int flags = MAP_PRIVATE | MAP_ANONYMOUS;
 	void *p;
+	int ret;
 
 	if (huge)
 		flags |= MAP_HUGETLB | MAP_HUGE_2MB;
-	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, -1, 0);
-	return p == MAP_FAILED ? NULL : p;
+
+	p = mmap(NULL, r->size, PROT_READ | PROT_WRITE, flags, -1, 0);
+	if (p == MAP_FAILED)
+		return -ENOMEM;
+
+	mr.region_uptr = (__u64)(unsigned long)&rd;
+	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
+	rd.user_addr = (__u64)(unsigned long)p;
+	rd.flags = IORING_MEM_REGION_TYPE_USER;
+	rd.size = r->size;
+
+	ret = io_uring_register_region(ring, &mr);
+	if (ret) {
+		munmap(p, r->size);
+		return ret;
+	}
+	r->ptr = p;
+	r->user_mem = true;
+	return 0;
 }
 
 static int test_region_buffer_types(void)
@@ -423,40 +451,42 @@ static int test_region_buffer_types(void)
 	const size_t huge_size = 1024 * 1024 * 2;
 	const size_t map_sizes[] = { page_size, page_size * 2, page_size * 16,
 				     huge_size, 2 * huge_size};
-	struct io_uring_region_desc rd = {};
-	struct io_uring_mem_region_reg mr = {};
 	struct io_uring ring;
 	int sz_idx, ret;
 
-	mr.region_uptr = (__u64)(unsigned long)&rd;
-	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
-
 	for (sz_idx = 0; sz_idx < ARRAY_SIZE(map_sizes); sz_idx++) {
 		size_t size = map_sizes[sz_idx];
-		void *buffer;
+		struct t_region r = { .size = size, };
 
-		buffer = alloc_region_buffer(size, size >= huge_size);
-		if (!buffer)
-			continue;
-
-		rd.user_addr = (__u64)(unsigned long)buffer;
-		rd.size = size;
-		rd.flags = IORING_MEM_REGION_TYPE_USER;
+		ret = io_uring_queue_init(8, &ring, IORING_SETUP_R_DISABLED);
+		if (ret) {
+			fprintf(stderr, "ring setup failed: %d\n", ret);
+			return ret;
+		}
 
-		ret = init_ring_with_region(&ring, 0, &mr);
+		ret = t_region_create_user(&r, &ring, size >= huge_size);
 		if (ret) {
-			fprintf(stderr, "init ring failed %i\n", ret);
+			io_uring_queue_exit(&ring);
+			if (ret == -ENOMEM || ret == -EINVAL)
+				continue;
+			fprintf(stderr, "t_region_create_user failed\n");
 			return 1;
 		}
 
-		ret = test_offsets(&ring, buffer, size, false);
+		ret = io_uring_enable_rings(&ring);
+		if (ret) {
+			fprintf(stderr, "io_uring_enable_rings failure %i\n", ret);
+			return ret;
+		}
+
+		ret = test_offsets(&ring, r.ptr, size, false);
 		if (ret) {
 			fprintf(stderr, "test_offsets failed, size %lu\n",
 				(unsigned long)size);
 			return 1;
 		}
 
-		munmap(buffer, size);
+		t_region_free(&r);
 		io_uring_queue_exit(&ring);
 	}
 
-- 
2.46.0


