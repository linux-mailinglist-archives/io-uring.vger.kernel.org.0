Return-Path: <io-uring+bounces-7563-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26075A943B0
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 16:12:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39EF63BAD69
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 14:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 597861DB366;
	Sat, 19 Apr 2025 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Dw6eGp/z"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1DCBA47;
	Sat, 19 Apr 2025 14:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745071922; cv=none; b=Tkax8wbixkupfYfhOSLEgVyHwHNVRo1hvNEtfKzuIb3+5JjUzMsCmQxrkecK2yPajI3bgy3j75QkaxqCw98IjpvK3mYXW5gGeKtCsPfCQjc+7A1ufdGdk/eKQ05YVMTqDINwmNkNfJt6OIYtfkIu7/w2oWLL6ZU2AXNHFFSghUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745071922; c=relaxed/simple;
	bh=MNzC4rQqbyndZAjOus390RcAcn7vXu1Ec1MfxlOcNsE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PuXiyx/g0bm5DEqeEpD/1zPvZ0tidrhzXYymtZ0+VPCW7S61JlkfkrexPH508demtXK7vZlDDpmpJd3fXi+eVqboZ6aEWk8OBq9FT0nXHQK9tDO3k8ygYxXql2FlELXmJO9jDmWH3fyKn+okdf+FM4P/Pys22Ampm0sb2x6IU7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Dw6eGp/z; arc=none smtp.client-ip=117.135.210.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=gm5/h
	KMZ2J598M5eOWBa4o8lh7YpwkH02uBcJBS2rvo=; b=Dw6eGp/zyVELjdT3Y+DUr
	YOowe3QcrgeNnyR7tx5xt6oYbwMpw099tYqM1OvAfo56mz5DhnP719+cGKc9OX+a
	GqDi5HsgvgxGyfHqx/skxplQSaFiHB9znlJsTC66TpXm93XY9wLhHy7W9uJhZKWV
	NP0doKc2CHyAiFYJsYdIVs=
Received: from localhost.localdomain (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDn7wkBrwNoKY4QBA--.26349S2;
	Sat, 19 Apr 2025 22:11:14 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
	linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v1] selftests: iou-zcrx: Get the page size at runtime
Date: Sat, 19 Apr 2025 22:10:15 +0800
Message-ID: <20250419141044.10304-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDn7wkBrwNoKY4QBA--.26349S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxZryfuw4UWF4DCF13GF1UGFg_yoW5WryfpF
	4Yka4qvr45AF45K3yrJr4kuw1Yvrn3Ja129r98u34rZFnxJF9xWa1xKFy5KFWUXrWkurWr
	CFZ2vF43uan8Ww7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0z_4SoJUUUUU=
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiEQA0a2gDqXrABQAAsz

Use the API `sysconf()` to query page size at runtime, instead of using
hard code number 4096.

And use `posix_memalign` to allocate the page size aligned momory.

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 .../selftests/drivers/net/hw/iou-zcrx.c       | 23 ++++++++++++-------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
index c26b4180eddd..8aa426014c87 100644
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
@@ -37,8 +37,8 @@
 
 #include <liburing.h>
 
-#define PAGE_SIZE (4096)
-#define AREA_SIZE (8192 * PAGE_SIZE)
+static long page_size;
+#define AREA_SIZE (8192 * page_size)
 #define SEND_SIZE (512 * 4096)
 #define min(a, b) \
 	({ \
@@ -66,7 +66,7 @@ static int cfg_oneshot_recvs;
 static int cfg_send_size = SEND_SIZE;
 static struct sockaddr_in6 cfg_addr;
 
-static char payload[SEND_SIZE] __attribute__((aligned(PAGE_SIZE)));
+static char *payload;
 static void *area_ptr;
 static void *ring_ptr;
 static size_t ring_size;
@@ -114,8 +114,8 @@ static inline size_t get_refill_ring_size(unsigned int rq_entries)
 
 	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
 	/* add space for the header (head/tail/etc.) */
-	ring_size += PAGE_SIZE;
-	return ALIGN_UP(ring_size, 4096);
+	ring_size += page_size;
+	return ALIGN_UP(ring_size, page_size);
 }
 
 static void setup_zcrx(struct io_uring *ring)
@@ -219,7 +219,7 @@ static void process_accept(struct io_uring *ring, struct io_uring_cqe *cqe)
 
 	connfd = cqe->res;
 	if (cfg_oneshot)
-		add_recvzc_oneshot(ring, connfd, PAGE_SIZE);
+		add_recvzc_oneshot(ring, connfd, page_size);
 	else
 		add_recvzc(ring, connfd);
 }
@@ -245,7 +245,7 @@ static void process_recvzc(struct io_uring *ring, struct io_uring_cqe *cqe)
 
 	if (cfg_oneshot) {
 		if (cqe->res == 0 && cqe->flags == 0 && cfg_oneshot_recvs) {
-			add_recvzc_oneshot(ring, connfd, PAGE_SIZE);
+			add_recvzc_oneshot(ring, connfd, page_size);
 			cfg_oneshot_recvs--;
 		}
 	} else if (!(cqe->flags & IORING_CQE_F_MORE)) {
@@ -370,7 +370,7 @@ static void usage(const char *filepath)
 
 static void parse_opts(int argc, char **argv)
 {
-	const int max_payload_len = sizeof(payload) -
+	const int max_payload_len = SEND_SIZE -
 				    sizeof(struct ipv6hdr) -
 				    sizeof(struct tcphdr) -
 				    40 /* max tcp options */;
@@ -443,6 +443,13 @@ int main(int argc, char **argv)
 	const char *cfg_test = argv[argc - 1];
 	int i;
 
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0)
+		return 1;
+
+	if (posix_memalign((void **)&payload, page_size, SEND_SIZE))
+		return 1;
+
 	parse_opts(argc, argv);
 
 	for (i = 0; i < SEND_SIZE; i++)
-- 
2.49.0


