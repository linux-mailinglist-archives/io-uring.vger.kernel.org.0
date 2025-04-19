Return-Path: <io-uring+bounces-7562-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50353A9439B
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 15:39:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6491417346D
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 13:39:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 719D81C8609;
	Sat, 19 Apr 2025 13:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="RnBzTyGO"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3751D54FE
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 13:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745069942; cv=none; b=D2KpKCEfkJRF/qTOAWCwuqAENPPMY5jKjM0a5fW+hnTjGAZ1YhyEwsqrUbiy8Xg3YOiPlskS02PHc5A01S3sotmibaDAMR6LNo/sZWRBe6pmFJ0SltY77Q/Q2JqyZe6dn6am8YGubqiDv9U65zI8QrMy+MIZxcVxBpTaPq5zMw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745069942; c=relaxed/simple;
	bh=nAjKgyxhGEckj6C/upbbntSbqwDtClSU6ONEmHPPIaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f9Y6PVvElO4JJm19YFUdq4rkXvCYOfKzMreaVnNhpJvt1etnu2Gvk1RRGc/x5cfleKt+ElQOFSSqhdZbExn9YC0WJrpDi2aFac4FJKXBzrcM/kdp/JCA3/rBx8C8jZvG/gfqch1JnDSRrU4BAMrvRJBF78oF/utohWsk2VEplSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=RnBzTyGO; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=5FOcI
	O3Hb6x0FYZAQ++V1dQbxwx9yQ4feZNnTgG04KY=; b=RnBzTyGOdLQP+alh6vRXp
	vcrfTnpJh2N4iT3y+ExVU/7fxVMAm+qQTBJ7zeFQI3T3CwR/Zzc+QpLBEPk7B461
	p3hyLuUYdYNuhdzwym6iu4TstH2R4ngYHMHoS+1uET9mxYQ/86uXjaleytEDSBtc
	pBYBqcJyUA9OkhvOpKs17w=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD33+FlpwNo_e2yAw--.29628S2;
	Sat, 19 Apr 2025 21:38:49 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v1] zcrx: Get the page size at runtime
Date: Sat, 19 Apr 2025 21:38:06 +0800
Message-ID: <20250419133819.7633-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD33+FlpwNo_e2yAw--.29628S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxArW7ZF17GF4UGFyktw17GFg_yoW5WFW5pF
	4jka4vyF4Fka43KayrJrWkC3WYvws3JF47Zryku3WrZF13XrZIqa18tFy5KF4UXrWvvrWU
	JrsIqF4ruF4UWF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR_HUhUUUUU=
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiSgI0a2gDoBr3vwAAsO

Use the API `sysconf()` to query page size at runtime, instead of using
hard code number 4096.

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 examples/zcrx.c | 20 +++++++++++++-------
 test/zcrx.c     | 11 +++++++++--
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 8393cfe..9a9b8b9 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -39,8 +39,8 @@
 #include "liburing.h"
 #include "helpers.h"
 
-#define PAGE_SIZE (4096)
-#define AREA_SIZE (8192 * PAGE_SIZE)
+static long page_size;
+#define AREA_SIZE (8192 * page_size)
 #define SEND_SIZE (512 * 4096)
 
 static int cfg_port = 8000;
@@ -65,8 +65,8 @@ static inline size_t get_refill_ring_size(unsigned int rq_entries)
 {
 	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
 	/* add space for the header (head/tail/etc.) */
-	ring_size += PAGE_SIZE;
-	return T_ALIGN_UP(ring_size, 4096);
+	ring_size += page_size;
+	return T_ALIGN_UP(ring_size, page_size);
 }
 
 static void setup_zcrx(struct io_uring *ring)
@@ -169,7 +169,7 @@ static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 
 	connfd = cqe->res;
 	if (cfg_oneshot)
-		add_recvzc_oneshot(ring, connfd, PAGE_SIZE);
+		add_recvzc_oneshot(ring, connfd, page_size);
 	else
 		add_recvzc(ring, connfd);
 }
@@ -207,7 +207,7 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 
 	if (cfg_oneshot) {
 		if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs) {
-			add_recvzc_oneshot(ring, connfd, PAGE_SIZE);
+			add_recvzc_oneshot(ring, connfd, page_size);
 			cfg_oneshot_recvs--;
 		}
 	} else if (!(cqe->flags & IORING_CQE_F_MORE)) {
@@ -329,7 +329,13 @@ static void parse_opts(int argc, char **argv)
 
 int main(int argc, char **argv)
 {
-	parse_opts(argc, argv);
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0) {
+		perror("sysconf(_SC_PAGESIZE)");
+		return 1;
+	}
+
+        parse_opts(argc, argv);
 	run_server();
 	return 0;
 }
diff --git a/test/zcrx.c b/test/zcrx.c
index b60462a..61c984d 100644
--- a/test/zcrx.c
+++ b/test/zcrx.c
@@ -19,10 +19,11 @@
 
 static unsigned int ifidx, rxq;
 
+static long page_size;
+
 /* the hw rxq must consume 128 of these pages, leaving 4 left */
 #define AREA_PAGES	132
-#define PAGE_SIZE	4096
-#define AREA_SZ		AREA_PAGES * PAGE_SIZE
+#define AREA_SZ		(AREA_PAGES * page_size)
 #define RQ_ENTRIES	128
 /* this is one more than the # of free pages after filling hw rxq */
 #define LOOP_COUNT	5
@@ -822,6 +823,12 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return T_EXIT_SKIP;
 
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0) {
+		perror("sysconf(_SC_PAGESIZE)");
+		return T_EXIT_FAIL;
+	}
+
 	area_outer = mmap(NULL, AREA_SZ + 8192, PROT_NONE,
 		MAP_ANONYMOUS | MAP_PRIVATE | MAP_NORESERVE, -1, 0);
 	if (area_outer == MAP_FAILED) {
-- 
2.49.0


