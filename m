Return-Path: <io-uring+bounces-4764-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DAFE9D00FB
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 22:27:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C9496B24071
	for <lists+io-uring@lfdr.de>; Sat, 16 Nov 2024 21:27:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6C6019A2A3;
	Sat, 16 Nov 2024 21:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E3VZAPZ2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C94198E80
	for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 21:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731792440; cv=none; b=oKxRoRcHoFnQFqPcIgLoay1SaSVttNipYpNoMcqUlrdh4LkMljLjxJFMdMj5+43oTv62vPva0u+n24cmRiexJlJLfmsh7k8aUhsLiboje3elS8QMitSIFfJpxYys8710hZ9BptIBDS9f0wcusrPWc1GSu7MK3lgzZmH+t8iZirY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731792440; c=relaxed/simple;
	bh=hkVKUkENVbqyJqDlHt03FqumUOp2/hffMrETnKCt9fU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgNXSn8KSwxCJ+GoGHzXFxyHYPO2qAGVQ8mXkJGZYDhlRa0TwqDCg+92Em1lyqpLWC3KdJG89WQfdbAOI63xBBu6G+RdRP5aeL8xJoAPX1l9E4L8PeWSQ2fs4uOzDM8fnSDzutR2RFubYPtiLMBBxFv8YmAVYqf1zluQBjskFhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E3VZAPZ2; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4314c4cb752so15912665e9.2
        for <io-uring@vger.kernel.org>; Sat, 16 Nov 2024 13:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731792437; x=1732397237; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VknFPR0P1FV3lPWvCpBDYnQxmfE5/HgO96NgGZKcy3k=;
        b=E3VZAPZ2PSDeQTsp+VKAXMsTEOiFRWfyA9gMtLhmRt/qV8uyyQBIKDFw/BTh+RNV+n
         n5voIUvM+27nUbyY5DnWczhdmrxFxwjnlmkMgl6kw2nQAjOOEUhT1pMzceTZOBHwFok4
         CnBWi+ywirJqE5cvs9ZHPaSyrwV5oIkIoV6LH1brd26lNwwqK2RpEsRfXZ5cRRnWL6D6
         IzKciTQxkiu0BCsALmFVMzOs9sCMuI+VZmj+Qh0WlTnIgRKZD1znrC4+jsJeK6+v2Egq
         gLONyJzwhbO4jSGif4KSTLPapS1YOSBQIg/ajnMDiZVyiGnmsnpaLlJbAO3Y6SKoE5Oj
         pXxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731792437; x=1732397237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VknFPR0P1FV3lPWvCpBDYnQxmfE5/HgO96NgGZKcy3k=;
        b=Hc2WS2cncCuumKkGdnRPl1pAPPYiMwvk71ThVe0S+4kPJW88gb4peLhy1eyaVGrFlh
         UnpId0cY7Y3LqkL9m65MRBscUrQjBxFTt1HWxyyoC3EpciVpLEy8Pw+8xmp/BWQPWQZE
         pZPlpctwQBayDOTvczErUZiI4XLG7fzAZm25CNCxBHlJAY2oY10YTXR5m+G/bYuAA7Gj
         jAIxAI0I8oK/1F/Guih1ZFei+7GC3uhSMT3q5BUqgsksH+XtBGfTos7yGCKR0xdXL9fj
         BfpExEreG7bIxBAJjG+YOURwYhGqbvHfo1yabYr/xIStMI+YormEraffbBusdLKYonwB
         avGw==
X-Gm-Message-State: AOJu0YzP9hlnS8/gmpsNfPL/adN6uPQtFSJuMTh0CSjEj63aGQQ5IAi9
	0LTSjaC5bv9NUMlGYBHsXYmfPWBc/+QKops3p9OsmkB9KUz+vZud7kJQJA==
X-Google-Smtp-Source: AGHT+IFs4OzPha+cdEliLHnJJyGCyCfcnCSZdri0bkJMYlFWXms6Z0LeSee+Jgufvc9VeVUyaITwtQ==
X-Received: by 2002:a05:600c:3d86:b0:42f:8515:e490 with SMTP id 5b1f17b1804b1-432df7179c6mr63419375e9.5.1731792436996;
        Sat, 16 Nov 2024 13:27:16 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.146.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432dac0aef0sm101071325e9.28.2024.11.16.13.27.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2024 13:27:16 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH liburing 8/8] test/reg-wait: test various sized regions
Date: Sat, 16 Nov 2024 21:27:48 +0000
Message-ID: <84233449abb8f5f3c878e7ccabf8520880bac624.1731792294.git.asml.silence@gmail.com>
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
 test/reg-wait.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 1 deletion(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index 559228f..b7c823a 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -9,6 +9,8 @@
 #include <string.h>
 #include <fcntl.h>
 #include <sys/time.h>
+#include <sys/mman.h>
+#include <linux/mman.h>
 
 #include "liburing.h"
 #include "helpers.h"
@@ -63,6 +65,12 @@ err:
 	return ret;
 }
 
+static int init_ring_with_region(struct io_uring *ring, unsigned ring_flags,
+				 struct io_uring_mem_region_reg *pr)
+{
+	return __init_ring_with_region(ring, ring_flags, pr, true);
+}
+
 static int page_size;
 static struct io_uring_reg_wait *reg;
 
@@ -109,6 +117,14 @@ static int test_offsets(struct io_uring *ring, struct io_uring_reg_wait *base,
 	int copy_size;
 	int ret;
 
+	rw = base;
+	memcpy(rw, &brief_wait, sizeof(brief_wait));
+	ret = io_uring_submit_and_wait_reg(ring, &cqe, 1, 0);
+	if (ret != -ETIME) {
+		fprintf(stderr, "0 index failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
 	if (overallocated) {
 		rw = base + max_index;
 		memcpy(rw, &brief_wait, sizeof(brief_wait));
@@ -134,7 +150,7 @@ static int test_offsets(struct io_uring *ring, struct io_uring_reg_wait *base,
 		return T_EXIT_FAIL;
 	}
 
-	offset = page_size - sizeof(long);
+	offset = size - sizeof(long);
 	rw = (void *)base + offset;
 	copy_size = overallocated ? sizeof(brief_wait) : sizeof(long);
 	memcpy(rw, &brief_wait, copy_size);
@@ -354,6 +370,62 @@ static int test_regions(void)
 	return 0;
 }
 
+static void *alloc_region_buffer(size_t size, bool huge)
+{
+	int flags = MAP_PRIVATE | MAP_ANONYMOUS;
+	void *p;
+
+	if (huge)
+		flags |= MAP_HUGETLB | MAP_HUGE_2MB;
+	p = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, -1, 0);
+	return p == MAP_FAILED ? NULL : p;
+}
+
+static int test_region_buffer_types(void)
+{
+	const size_t huge_size = 1024 * 1024 * 2;
+	const size_t map_sizes[] = { page_size, page_size * 2, page_size * 16,
+				     huge_size, 2 * huge_size};
+	struct io_uring_region_desc rd = {};
+	struct io_uring_mem_region_reg mr = {};
+	struct io_uring ring;
+	int sz_idx, ret;
+
+	mr.region_uptr = (__u64)(unsigned long)&rd;
+	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
+
+	for (sz_idx = 0; sz_idx < ARRAY_SIZE(map_sizes); sz_idx++) {
+		size_t size = map_sizes[sz_idx];
+		void *buffer;
+
+		buffer = alloc_region_buffer(size, size >= huge_size);
+		if (!buffer)
+			continue;
+
+		rd.user_addr = (__u64)(unsigned long)buffer;
+		rd.size = size;
+		rd.flags = IORING_MEM_REGION_TYPE_USER;
+
+		ret = init_ring_with_region(&ring, 0, &mr);
+		if (ret) {
+			fprintf(stderr, "init ring failed %i\n", ret);
+			return 1;
+		}
+
+		ret = test_offsets(&ring, buffer, size, false);
+		if (ret) {
+			fprintf(stderr, "test_offsets failed, size %lu\n",
+				(unsigned long)size);
+			return 1;
+		}
+
+		munmap(buffer, size);
+		io_uring_queue_exit(&ring);
+	}
+
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int ret;
@@ -381,5 +453,12 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "test_wait_arg failed\n");
 		return 1;
 	}
+
+	ret = test_region_buffer_types();
+	if (ret == T_EXIT_FAIL) {
+		fprintf(stderr, "test_region_buffer_types failed\n");
+		return 1;
+	}
+
 	return 0;
 }
-- 
2.46.0


