Return-Path: <io-uring+bounces-13029-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qHFhIH+p22lsEwkAu9opvQ
	(envelope-from <io-uring+bounces-13029-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 16:17:35 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 254503E4309
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 16:17:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0E6573001FB8
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2026 14:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A296E244667;
	Sun, 12 Apr 2026 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fe4/+VO5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B01F175A92
	for <io-uring@vger.kernel.org>; Sun, 12 Apr 2026 14:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776003448; cv=none; b=YUihGRs7KhZ5VU/t5rLChbyj/GZBIX97UAdMmhA569GafLg4N75O0gT9hsZ2ytLhnZzLddmsacMUhXp18M2w1Z1ryojL+KhA7Xan6b5MHYjkXjSmWKy003siRIYO93goA8JCtuKjHKRyTHEwlyyJupgxij/bdjNvRa4z6YPaKpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776003448; c=relaxed/simple;
	bh=JZVgWkOGWtqIw+31RK1cXGh4vkY19ZUEOyuIl0wmuKM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=o+8aFm4wLWkFFGOwcHBfM1v3PEwutG6x/0PxuWILdbHRkSpFgnHCFLw8FNW8E23bWOge+xA2pElT7t0TrKt9h3w/Tf09VtwPyoYZzYTSZunrOjRLUxEYexgiavQbKjzy1wr3Fau+jYkZw7QcRj7zsHLWOa00EnFay3ye5Z3RCYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fe4/+VO5; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488b0e1b870so57896435e9.2
        for <io-uring@vger.kernel.org>; Sun, 12 Apr 2026 07:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776003443; x=1776608243; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PjCxzagPR2shMFeusYttfh7xkiNeQqc6vt3VruRWyXM=;
        b=fe4/+VO5HQI5GUhaujcs/PuqbZNlB9QdqaHaEM+BkiQpsIhWn7hbCelngrUf03Yjfg
         0Ru4wmEYDNd9mFwsjkSKbOzqdKP9Mtk8/lqeMp77dLeZ1fmZGalAwYwhKnjN0dMtkHri
         D2bH2M0mkukc4sOkIWgIIHk/ry0grRY9/E+o4VkwLpBIdyyCflKTgq4N8Mm8igcBBl5c
         l/DgrSe5GdNshjYtlZ7CSen3iXV4XJUw83nZaf98np80YBIn24pb+J9KlGiDSX4bQUJH
         2YlR0gtKs6Imf9G9pxGHMJ4KMRF/lM3q4KIFvLZoLmbC1NkUIO72bQZ0Zr6DUAhMrX7/
         nH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776003443; x=1776608243;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PjCxzagPR2shMFeusYttfh7xkiNeQqc6vt3VruRWyXM=;
        b=ae+d6ZBqDBQZrd8dSjZUAs9w+Z51BfzyuB5JOCM9Nu1CjM4u2AzQzKmXCafl+eUTT/
         augRsHyRIQ7gD863+iwO36TJg0wDwau/xl6fsqCIOSIzbGIQ854ZzenUEsTQCSVC91Aa
         FKXWHNOuwoKsPepFi6wBH/UueSe7Ha8IKLxClm/mMWN2WGeo8lDlzN/ex9fEs++hkmqe
         6NKpdRMJalVDMZMxA3YfX+mZYFV+5J+qpHzE7SYr177sa7ixwi0n6eYef/YgYl3J0sKD
         5B68EWJZugzJUSFz13dE42Ox4i1CIJZPfhrf23gzN3FiF33sei3qLkiHhoSw9vEvkN4E
         zmjA==
X-Gm-Message-State: AOJu0YzjJvYfYMj14n1uUd+aWvw1mWzqILlfrz6pgBU1JBUGkg6I47/W
	obrqPkPXLMfJLLC9YUpEPwWLbqCxWkGmldQ5hOzMmRlFUq53755H4z9A3hUe8g==
X-Gm-Gg: AeBDievbUTo9znrGF0MV98PiUNDCHnBUALc3cnRS7m/E9Fj1T4Ne88m9u/lZ+6Fk039
	Lf9OxrfJxp9Z43lSO7ZJ4G9rJUkq2inwh3eEhA9b8ODb5T8uFK9rwO7K0iGfQFHVXcrGWcors+G
	SeQBnOEgr4DrKorCVifVtsou3/G47Zxs+lUGhqNtR1O+Y3rMaQDdIkaE/4ASS8G6A1iIjIo1At4
	srdsCmL54THZUzdFjumD74jFwlxUcApa3hXwGDLvRwkqlZ8KvIYhyJFhOmVViGQxvUhPFwuVz/m
	bQHam5oOFb4Mt1fUqao/TxXIIJTBbRHT1gz2IwMPS+ZiP1mWdR2i6cd/+zqHIc3LUzYzZxTKAlF
	bPGnQB6N7x0VOFtqk8vo8y12opdx8tZNH19mLYBv6Omif3+2oTL7xKiUBYgPmmpNRL1A2oxtgj3
	6TrIc/oFz4vDjfRcCR5MxerZhVWONJ+EyalHrb9Q+NoDzcpwkrXOS+m2pMyK/+k1gHBEFi+8bxi
	eXKuV2vIwhhWywLeRE3jMPmQGtf+eQwM2V3zjrg
X-Received: by 2002:a05:600c:6990:b0:488:a2ac:a34c with SMTP id 5b1f17b1804b1-488d67f5bf5mr139921005e9.12.1776003442383;
        Sun, 12 Apr 2026 07:17:22 -0700 (PDT)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5380feesm275607265e9.9.2026.04.12.07.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2026 07:17:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk
Subject: [PATCH liburing 1/1] tests: fix zcrx tests
Date: Sun, 12 Apr 2026 15:17:31 +0100
Message-ID: <35996dec32a78ce0c93dff43197b52cadc2696ea.1776003410.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-13029-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,kernel.dk];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 254503E4309
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

zcrx.c is broken and clearly nobody is running it, do a complete
rewrite. It covers most of the cases it was supposed to check,
especially around invalid parameters, but also adds tests for different
control commands like rq flush and export. It relies on ZCRX_REG_NODEV
and doesn't require real hardware. It can get !NODEV support later, but
at least it allows to exercise most of paths on any machine.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing/io_uring.h |    6 +
 test/zcrx.c                     | 1561 ++++++++++++++++++-------------
 2 files changed, 913 insertions(+), 654 deletions(-)

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 1e58bc72..983aa265 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -1054,6 +1054,12 @@ struct io_uring_zcrx_area_reg {
 
 enum zcrx_reg_flags {
 	ZCRX_REG_IMPORT	= 1,
+	/*
+	 * Register a zcrx instance without a net device. All data will be
+	 * copied. The refill queue entries might not be automatically
+	 * consumed and need to be flushed, see ZCRX_CTRL_FLUSH_RQ.
+	 */
+	ZCRX_REG_NODEV		= 2,
 };
 
 enum zcrx_features {
diff --git a/test/zcrx.c b/test/zcrx.c
index 572e1185..04add8ce 100644
--- a/test/zcrx.c
+++ b/test/zcrx.c
@@ -1,6 +1,6 @@
 /* SPDX-License-Identifier: MIT */
 /*
- * Simple test case showing using send and recv through io_uring
+ * Zero copy receive tests
  */
 #include <errno.h>
 #include <stdio.h>
@@ -17,69 +17,111 @@
 #include "liburing.h"
 #include "helpers.h"
 
-static unsigned int ifidx, rxq;
+#define RING_FLAGS	(IORING_SETUP_DEFER_TASKRUN | \
+			 IORING_SETUP_CQE32 | \
+			 IORING_SETUP_SINGLE_ISSUER | \
+			 IORING_SETUP_SUBMIT_ALL)
+
+#define RQ_ENTRIES		128
+#define RQ_ENTRIES_SMALL	16
+#define AREA_SZ			(4096 * 132)
+#define HUGEPAGE_AREA_SZ	(16 << 20)
+#define T_ALIGN_UP(v, align) (((v) + (align) - 1) & ~((align) - 1))
+
+struct zcrx_reg {
+	struct io_uring_zcrx_area_reg area;
+	struct io_uring_region_desc rq_region;
+	struct io_uring_zcrx_ifq_reg zcrx;
+};
+
+struct t_executor {
+	struct io_uring_zcrx_rq rq;
+	struct io_uring ring;
+	struct zcrx_reg reg;
+	int fds[2];
+};
 
+static struct io_uring_query_zcrx query;
+static bool zcrx_supported = false;
 static long page_size;
 
-/* the hw rxq must consume 128 of these pages, leaving 4 left */
-#define AREA_PAGES	132
-#define AREA_SZ		(AREA_PAGES * page_size)
-#define RQ_ENTRIES	128
-/* this is one more than the # of free pages after filling hw rxq */
-#define LOOP_COUNT	5
-#define DEV_ENV_VAR	"NETIF"
-#define RXQ_ENV_VAR	"NETRXQ"
-#define RING_FLAGS	(IORING_SETUP_DEFER_TASKRUN | \
-			 IORING_SETUP_CQE32 | \
-			 IORING_SETUP_SINGLE_ISSUER)
+static void *def_rq_mem;
+static void *def_area_mem;
+static void *def_hugepage_area_mem;
+
+enum {
+	CONFIG_HUGEPAGE		= 1 << 0,
+	CONFIG_SMALL_RQ		= 1 << 1,
+};
+
+static struct io_uring_cqe *submit_and_wait_one(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	int ret;
 
-static char str[] = "iv5t4dl500w7wsrf14fsuq8thptto0z7i2q62z1p8dwrv5u4kaxpqhm2rb7bapddi5gfkh7f9695eh46t2o5yap2y43gstbsq3n90bg1i7zx1m4wojoqbuxhsrw4s4y3sh9qp57ovbaa2o9yaqa7d4to2vak1otvgkoxs5t0ovjbe6roginrjeh906kmjn1289jlho9a1bud02ex4xr3cvfcybpl6axnr117p0aesb3070wlvj91en7tpf8nyb1e";
+	ret = io_uring_submit(ring);
+	if (ret != 1)
+		t_error(1, ret, "submit_and_wait_one: submit fail\n");
 
-#define MSG_SIZE 512
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0)
+		t_error(1, ret, "submit_and_wait_one: wait fail\n");
 
-#define PORT	10202
-#define HOST	"127.0.0.1"
+	return cqe;
+}
 
-static int probe_zcrx(void *area)
+static void test_io_uring_prep_zcrx(struct io_uring_sqe *sqe, int fd, int zcrx_id)
 {
-	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = uring_ptr_to_u64(area),
-		.len = AREA_SZ,
-		.flags = 0,
-	};
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = ifidx,
-		.if_rxq = rxq,
-		.rq_entries = RQ_ENTRIES,
-		.area_ptr = uring_ptr_to_u64(&area_reg),
+	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, fd, NULL, 0, 0);
+	sqe->zcrx_ifq_idx = zcrx_id;
+	sqe->ioprio |= IORING_RECV_MULTISHOT;
+}
+
+static bool rq_ctrl_op_supported(int op)
+{
+	return query.nr_ctrl_opcodes > op;
+}
+
+static int t_zcrx_ctrl(struct io_uring *ring, struct zcrx_ctrl *ctrl)
+{
+	return io_uring_register(ring->ring_fd, IORING_REGISTER_ZCRX_CTRL, ctrl, 0);
+}
+
+static void query_zcrx(void)
+{
+	struct io_uring_query_hdr hdr = {
+		.size = sizeof(query),
+		.query_data = uring_ptr_to_u64(&query),
+		.query_op = IO_URING_QUERY_ZCRX,
 	};
-	struct io_uring ring;
 	int ret;
 
-	ret = t_create_ring(8, &ring, RING_FLAGS);
-	if (ret == T_SETUP_SKIP) {
-		fprintf(stderr, "required ring flags are not supported, skip\n");
-		return T_EXIT_SKIP;
-	}
-	if (ret) {
-		fprintf(stderr, "probe ring setup failure\n");
-		return T_EXIT_FAIL;
+	ret = io_uring_register(-1, IORING_REGISTER_QUERY, &hdr, 0);
+	if (ret < 0 || hdr.result < 0) {
+		memset(&query, 0, sizeof(query));
+		query.rq_hdr_size = page_size;
+		query.rq_hdr_alignment = page_size;
+	} else {
+		zcrx_supported = true;
 	}
+}
 
-	ret = io_uring_register_ifq(&ring, &reg);
-	if (ret == -EINVAL) {
-		fprintf(stderr, "zcrx is not supported, skip\n");
-		return T_EXIT_SKIP;
-	}
-	if (ret) {
-		fprintf(stderr, "probe zcrx register fail %i\n", ret);
-		return T_EXIT_FAIL;
-	}
-	io_uring_queue_exit(&ring);
-	return T_EXIT_PASS;
+static unsigned rq_nr_queued(struct io_uring_zcrx_rq *rq)
+{
+	return rq->rq_tail - io_uring_smp_load_acquire(rq->khead);
 }
 
-static int try_register_ifq(struct io_uring_zcrx_ifq_reg *reg)
+static int flush_rq(struct io_uring *ring, int zcrx_id)
+{
+	struct zcrx_ctrl ctrl = {
+		.zcrx_id = zcrx_id,
+		.op = ZCRX_CTRL_FLUSH_RQ,
+	};
+
+	return t_zcrx_ctrl(ring, &ctrl);
+}
+
+static int try_register_zcrx(struct io_uring_zcrx_ifq_reg *reg)
 {
 	struct io_uring ring;
 	int ret;
@@ -95,834 +137,1045 @@ static int try_register_ifq(struct io_uring_zcrx_ifq_reg *reg)
 	return ret;
 }
 
-static int test_invalid_if(void *area)
+static int clone_zcrx(int src_id, struct io_uring *src_ring, struct io_uring *dst_ring,
+		      struct io_uring_zcrx_ifq_reg *out_reg)
 {
-	int ret;
-	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = uring_ptr_to_u64(area),
-		.len = AREA_SZ,
-		.flags = 0,
-	};
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = -1,
-		.if_rxq = rxq,
-		.rq_entries = RQ_ENTRIES,
-		.area_ptr = uring_ptr_to_u64(&area_reg),
+	struct zcrx_ctrl export_ctrl;
+	int box_fd, ret;
+
+	export_ctrl = (struct zcrx_ctrl) {
+		.zcrx_id = src_id,
+		.op = ZCRX_CTRL_EXPORT,
 	};
+	ret = t_zcrx_ctrl(src_ring, &export_ctrl);
+	box_fd = export_ctrl.zc_export.zcrx_fd;
+	if (ret < 0) {
+		fprintf(stderr, "Export failed %i %i\n", ret, box_fd);
+		return ret;
+	}
 
-	ret = try_register_ifq(&reg);
-	if (ret != -EINVAL && ret != -ENODEV) {
-		fprintf(stderr, "registered invalid IF %i\n", ret);
-		return T_EXIT_FAIL;
+	*out_reg = (struct io_uring_zcrx_ifq_reg) {
+		.flags = ZCRX_REG_IMPORT,
+		.if_idx = box_fd,
+	};
+	ret = io_uring_register_ifq(dst_ring, out_reg);
+	if (ret) {
+		fprintf(stderr, "Import failed %i\n", ret);
+		return -1;
 	}
 
-	reg.if_idx = ifidx;
-	reg.if_rxq = -1;
+	close(box_fd);
+	return 0;
+}
 
-	ret = try_register_ifq(&reg);
-	if (ret != -EINVAL) {
-		fprintf(stderr, "registered invalid IFQ %i\n", ret);
-		return T_EXIT_FAIL;
-	}
-	return T_EXIT_PASS;
+static size_t get_rq_size(unsigned nr_entries)
+{
+	size_t sz;
+
+	sz = T_ALIGN_UP(query.rq_hdr_size, query.rq_hdr_alignment);
+	sz += nr_entries * sizeof(struct io_uring_zcrx_rqe);
+	return T_ALIGN_UP(sz, page_size);
 }
 
-static int test_invalid_ifq_collision(void *area)
+static void default_reg(struct zcrx_reg *reg, unsigned config_flags)
 {
-	struct io_uring ring, ring2;
-	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = uring_ptr_to_u64(area),
+	unsigned rq_entries = RQ_ENTRIES;
+
+	if (config_flags & CONFIG_SMALL_RQ)
+		rq_entries = RQ_ENTRIES_SMALL;
+
+	reg->rq_region = (struct io_uring_region_desc) {
+		.size = get_rq_size(rq_entries),
+		.user_addr = uring_ptr_to_u64(def_rq_mem),
+		.flags = IORING_MEM_REGION_TYPE_USER,
+	};
+	reg->area = (struct io_uring_zcrx_area_reg) {
+		.addr = uring_ptr_to_u64(def_area_mem),
 		.len = AREA_SZ,
 		.flags = 0,
 	};
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = ifidx,
-		.if_rxq = rxq,
-		.rq_entries = RQ_ENTRIES,
-		.area_ptr = uring_ptr_to_u64(&area_reg),
+	reg->zcrx = (struct io_uring_zcrx_ifq_reg) {
+		.flags = ZCRX_REG_NODEV,
+		.rq_entries = rq_entries,
+		.area_ptr = uring_ptr_to_u64(&reg->area),
+		.region_ptr = uring_ptr_to_u64(&reg->rq_region),
 	};
-	int ret;
 
-	ret = t_create_ring(8, &ring, RING_FLAGS);
-	if (ret != T_SETUP_OK) {
-		fprintf(stderr, "ring create failed: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
-	ret = t_create_ring(8, &ring2, RING_FLAGS);
-	if (ret != T_SETUP_OK) {
-		fprintf(stderr, "ring2 create failed: %d\n", ret);
-		return T_EXIT_FAIL;
+	if (config_flags & CONFIG_HUGEPAGE) {
+		reg->area.addr = uring_ptr_to_u64(def_hugepage_area_mem);
+		reg->area.len = HUGEPAGE_AREA_SZ;
 	}
+}
 
-	ret = io_uring_register_ifq(&ring, &reg);
-	if (ret) {
-		fprintf(stderr, "initial registration failed %i\n", ret);
-		return T_EXIT_FAIL;
-	}
+static int test_register_basic(void)
+{
+	struct zcrx_reg reg;
+	int ret;
 
-	/* register taken ifq */
-	ret = io_uring_register_ifq(&ring, &reg);
-	if (!ret) {
-		fprintf(stderr, "registered taken queue\n");
-		return T_EXIT_FAIL;
+	default_reg(&reg, 0);
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret == -EPERM)
+		return ret;
+	if (ret) {
+		fprintf(stderr, "default setup failed\n");
+		return ret;
 	}
 
-	ret = io_uring_register_ifq(&ring2, &reg);
-	if (!ret) {
-		fprintf(stderr, "registered taken queue ring2\n");
-		return T_EXIT_FAIL;
+	if (def_hugepage_area_mem) {
+		default_reg(&reg, CONFIG_HUGEPAGE);
+		ret = try_register_zcrx(&reg.zcrx);
+		if (ret) {
+			fprintf(stderr, "default setup+huge failed\n");
+			return ret;
+		}
 	}
 
-	io_uring_queue_exit(&ring);
-	io_uring_queue_exit(&ring2);
-	return T_EXIT_PASS;
+	return 0;
 }
 
-static int test_rq_setup(void *area)
+static int test_rq(void)
 {
+	struct zcrx_reg reg;
+	unsigned entries;
 	int ret;
-	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = uring_ptr_to_u64(area),
-		.len = AREA_SZ,
-		.flags = 0,
-	};
 
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = ifidx,
-		.if_rxq = rxq,
-		.rq_entries = 0,
-		.area_ptr = uring_ptr_to_u64(&area_reg),
-	};
+	default_reg(&reg, 0);
+	reg.zcrx.region_ptr = 0;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && ret != -EFAULT) {
+		fprintf(stderr, "registered w/o region\n");
+		return ret;
+	}
 
-	ret = try_register_ifq(&reg);
-	if (ret != -EINVAL) {
-		fprintf(stderr, "registered 0 rq entries\n");
-		return T_EXIT_FAIL;
+	default_reg(&reg, 0);
+	reg.rq_region.user_addr = 0;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && ret != -EFAULT) {
+		fprintf(stderr, "registered rq region with no memory\n");
+		return ret;
 	}
 
-	reg.rq_entries = (__u32)-1;
+	default_reg(&reg, 0);
+	reg.rq_region.size = 0;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && ret != -EFAULT) {
+		fprintf(stderr, "registered rq region size=0\n");
+		return ret;
+	}
 
-	ret = try_register_ifq(&reg);
-	if (ret != -EINVAL) {
-		fprintf(stderr, "registered unlimited nr of rq entries\n");
-		return T_EXIT_FAIL;
+	default_reg(&reg, 0);
+	entries = reg.zcrx.rq_entries;
+	reg.zcrx.rq_entries -= 1;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && reg.zcrx.rq_entries != entries) {
+		fprintf(stderr, "registered rq with non pow2 rq\n");
+		return ret;
 	}
 
-	reg.rq_entries = RQ_ENTRIES - 1;
-	ret = try_register_ifq(&reg);
-	if (ret != 0) {
-		fprintf(stderr, "ifq registration failed %i\n", ret);
-		return T_EXIT_FAIL;
+	default_reg(&reg, 0);
+	if (query.rq_hdr_size != page_size && reg.rq_region.size > page_size) {
+		reg.rq_region.size = page_size;
+		ret = try_register_zcrx(&reg.zcrx);
+		if (ret != -EINVAL && ret != -EFAULT) {
+			fprintf(stderr, "registered rq with non pow2 rq\n");
+			return ret;
+		}
 	}
 
-	if (reg.rq_entries == RQ_ENTRIES - 1) {
-		fprintf(stderr, "registered non pow2 refill entries %i\n",
-			reg.rq_entries);
-		return T_EXIT_FAIL;
+	default_reg(&reg, 0);
+	reg.zcrx.rq_entries = 0;
+	reg.zcrx.rq_entries = ~reg.zcrx.rq_entries;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && ret != -EFAULT) {
+		fprintf(stderr, "registered rq with unlimited entries\n");
+		return ret;
 	}
 
-	return T_EXIT_PASS;
+	default_reg(&reg, 0);
+	reg.zcrx.rq_entries += (page_size / sizeof(struct io_uring_zcrx_rqe));
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && ret != -EFAULT) {
+		fprintf(stderr, "registered rq with too many entries\n");
+		return ret;
+	}
+
+	return 0;
 }
 
-static int test_null_area_reg_struct(void)
+static int test_area(void)
 {
+	struct zcrx_reg reg;
 	int ret;
 
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = ifidx,
-		.if_rxq = rxq,
-		.rq_entries = RQ_ENTRIES,
-		.area_ptr = uring_ptr_to_u64(0),
-	};
+	default_reg(&reg, 0);
+	reg.area.len = 0;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && ret != -EFAULT) {
+		fprintf(stderr, "registered area size=0, %i\n", ret);
+		return ret;
+	}
 
-	ret = try_register_ifq(&reg);
-	return ret ? T_EXIT_PASS : T_EXIT_FAIL;
-}
+	default_reg(&reg, 0);
+	reg.area.addr = 0;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && ret != -EFAULT) {
+		fprintf(stderr, "registered with NULL area mem\n");
+		return ret;
+	}
 
-static int test_null_area(void)
-{
-	int ret;
+	default_reg(&reg, 0);
+	reg.zcrx.area_ptr = 0;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && ret != -EFAULT) {
+		fprintf(stderr, "registered with no area\n");
+		return ret;
+	}
 
-	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = uring_ptr_to_u64(0),
-		.len = AREA_SZ,
-		.flags = 0,
-	};
+	default_reg(&reg, 0);
+	reg.area.addr -= page_size;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "registered lower than area\n");
+		return ret;
+	}
 
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = ifidx,
-		.if_rxq = rxq,
-		.rq_entries = RQ_ENTRIES,
-		.area_ptr = uring_ptr_to_u64(&area_reg),
-	};
+	default_reg(&reg, 0);
+	reg.area.len += page_size;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "registered higher than area\n");
+		return ret;
+	}
 
-	ret = try_register_ifq(&reg);
-	return ret ? T_EXIT_PASS : T_EXIT_FAIL;
+	default_reg(&reg, 0);
+	reg.area.len -= page_size / 2;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EFAULT && ret != -EINVAL) {
+		fprintf(stderr, "registered unaligned area size\n");
+		return ret;
+	}
+
+	default_reg(&reg, 0);
+	reg.area.len /= 2;
+	reg.area.addr += page_size / 2;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EFAULT && ret != -EINVAL) {
+		fprintf(stderr, "registered unaligned area ptr\n");
+		return ret;
+	}
+
+	return 0;
 }
 
-static int test_misaligned_area(void *area)
+static int test_ro_params(void)
 {
+	size_t size = T_ALIGN_UP(sizeof (struct zcrx_reg), page_size);
+	struct zcrx_reg *reg;
+	void *mem;
 	int ret;
-	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = uring_ptr_to_u64(area + 1),
-		.len = AREA_SZ,
-		.flags = 0,
-	};
 
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = ifidx,
-		.if_rxq = rxq,
-		.rq_entries = RQ_ENTRIES,
-		.area_ptr = uring_ptr_to_u64(&area_reg),
-	};
+	mem = mmap(NULL, size, PROT_READ | PROT_WRITE,
+			MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		t_error(0, 1, "Can't allocate buffer");
 
-	if (!try_register_ifq(&reg))
-		return T_EXIT_FAIL;
+	reg = mem;
+	default_reg(reg, 0);
+	mprotect(mem, size, PROT_READ);
+
+	ret = try_register_zcrx(&reg->zcrx);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "registered unaligned area ptr\n");
+		return ret;
+	}
 
-	area_reg.addr = uring_ptr_to_u64(area);
-	area_reg.len = AREA_SZ - 1;
-	ret = try_register_ifq(&reg);
-	return ret ? T_EXIT_PASS : T_EXIT_FAIL;
+	munmap(mem, size);
+	return 0;
 }
 
-static int test_larger_than_alloc_area(void *area)
+static int test_invalid_rx_page(void)
 {
+	struct zcrx_reg reg;
 	int ret;
-	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = uring_ptr_to_u64(area),
-		.len = AREA_SZ + 4096,
-		.flags = 0,
-	};
 
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = ifidx,
-		.if_rxq = rxq,
-		.rq_entries = RQ_ENTRIES,
-		.area_ptr = uring_ptr_to_u64(&area_reg),
-	};
+	default_reg(&reg, 0);
+	reg.zcrx.rx_buf_len = ~reg.zcrx.rx_buf_len;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && ret != -ERANGE && ret != -EOVERFLOW) {
+		fprintf(stderr, "registered UINT_MAX rx buf len\n");
+		return ret;
+	}
 
-	ret = try_register_ifq(&reg);
-	return ret ? T_EXIT_PASS : T_EXIT_FAIL;
+	default_reg(&reg, 0);
+	reg.zcrx.rx_buf_len = 1U << 31;
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EINVAL && ret != -ERANGE && ret != -EOVERFLOW && ret != -EOPNOTSUPP) {
+		fprintf(stderr, "registered too_large rx buf len\n");
+		return ret;
+	}
+
+	return 0;
 }
 
-static int test_area_access(void)
+static int __prep_server(struct t_executor *ctx, unsigned config_flags)
 {
-	struct io_uring_zcrx_area_reg area_reg = {
-		.len = AREA_SZ,
-		.flags = 0,
-	};
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = ifidx,
-		.if_rxq = rxq,
-		.rq_entries = RQ_ENTRIES,
-		.area_ptr = uring_ptr_to_u64(&area_reg),
-	};
-	int i, ret;
-	void *area;
+	struct io_uring_zcrx_ifq_reg *zcrx_reg = &ctx->reg.zcrx;
+	char *rqp;
+	int ret;
 
-	for (i = 0; i < 2; i++) {
-		int ro = i & 1;
-		int prot = ro ? PROT_READ : PROT_WRITE;
+	ret = t_create_ring(128, &ctx->ring, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return -1;
+	}
 
-		area = mmap(NULL, AREA_SZ, prot,
-			    MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
-		if (area == MAP_FAILED) {
-			perror("mmap");
-			return T_EXIT_FAIL;
-		}
+	default_reg(&ctx->reg, config_flags);
+	rqp = (char *)ctx->reg.rq_region.user_addr;
+	memset(rqp, 0, get_rq_size(0));
 
-		area_reg.addr = uring_ptr_to_u64(area);
+	ret = io_uring_register_ifq(&ctx->ring, zcrx_reg);
+	if (ret) {
+		fprintf(stderr, "Can't register zcrx %i\n", ret);
+		return ret;
+	}
 
-		ret = try_register_ifq(&reg);
-		if (ret != -EFAULT) {
-			fprintf(stderr, "registered unaccessible memory\n");
-			return T_EXIT_FAIL;
-		}
+	ctx->rq.khead = (unsigned int *)((char *)rqp + zcrx_reg->offsets.head);
+	ctx->rq.ktail = (unsigned int *)((char *)rqp + zcrx_reg->offsets.tail);
+	ctx->rq.rqes = (struct io_uring_zcrx_rqe *)((char *)rqp + zcrx_reg->offsets.rqes);
+	ctx->rq.rq_tail = 0;
+	ctx->rq.ring_entries = zcrx_reg->rq_entries;
 
-		munmap(area, AREA_SZ);
+	ret = t_create_socket_pair(ctx->fds, true);
+	if (ret) {
+		fprintf(stderr, "t_create_socket_pair failed: %d\n", ret);
+		return ret;
 	}
 
-	return T_EXIT_PASS;
+	return 0;
 }
 
-static int create_ring_with_ifq(struct io_uring *ring, void *area, __u32 *id)
+static int prep_server(struct t_executor *ctx)
 {
-	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = uring_ptr_to_u64(area),
-		.len = AREA_SZ,
-		.flags = 0,
-	};
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = ifidx,
-		.if_rxq = rxq,
-		.rq_entries = RQ_ENTRIES,
-		.area_ptr = uring_ptr_to_u64(&area_reg),
-	};
-	int ret;
+	return __prep_server(ctx, 0);
+}
 
-	ret = t_create_ring(128, ring, RING_FLAGS);
-	if (ret != T_SETUP_OK) {
-		fprintf(stderr, "ring create failed: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
+static void fill_pattern(char *b, size_t size, unsigned long seq)
+{
+	for (long i = 0; i < size; i++)
+		b[i] = ((seq + i) * 1000000001UL) ^ 0xdeadbeef;
+}
 
-	ret = io_uring_register_ifq(ring, &reg);
-	if (ret) {
-		io_uring_queue_exit(ring);
-		fprintf(stderr, "ifq register failed %d\n", ret);
-		return T_EXIT_FAIL;
+static int check_pattern(char *b, size_t size, unsigned long seq)
+{
+	for (long i = 0; i < size; i++) {
+		char exp = ((seq + i) * 1000000001UL) ^ 0xdeadbeef;
+
+		if (exp != b[i])
+			return -3;
 	}
-	*id = reg.zcrx_id;
 	return 0;
 }
 
-static void test_io_uring_prep_zcrx(struct io_uring_sqe *sqe, int fd, int ifq)
+enum {
+	T_RETURN_BUFS = 0x1,
+	T_RETURN_LAZY = 0x2,
+};
+
+static int return_buffer(struct t_executor *ctx, struct io_uring_cqe *cqe,
+			 unsigned flags)
 {
-	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, fd, NULL, 0, 0);
-	sqe->zcrx_ifq_idx = ifq;
-	sqe->ioprio |= IORING_RECV_MULTISHOT;
+	struct io_uring_zcrx_rq *rq = &ctx->rq;
+	const struct io_uring_zcrx_cqe *rcqe = (void *)(cqe + 1);
+	struct io_uring_zcrx_rqe *rqe;
+	unsigned rq_mask;
+	int ret;
+
+	rq_mask = rq->ring_entries - 1;
+	rqe = &rq->rqes[rq->rq_tail & rq_mask];
+	rqe->off = (rcqe->off & ~IORING_ZCRX_AREA_MASK) | ctx->reg.area.rq_area_token;
+	rqe->len = cqe->res;
+	io_uring_smp_store_release(rq->ktail, ++rq->rq_tail);
+
+	if (rq_nr_queued(rq) >= rq->ring_entries || !(flags & T_RETURN_LAZY)) {
+		/* flush eagerly for the test */
+		ret = flush_rq(&ctx->ring, ctx->reg.zcrx.zcrx_id);
+		if (ret) {
+			fprintf(stderr, "RQ flush failed %i\n", ret);
+			return ret;
+		}
+	}
+	return 0;
 }
 
-static struct io_uring_cqe *submit_and_wait_one(struct io_uring *ring)
+static int transfer_bytes(struct t_executor *ctx, size_t length,
+			  unsigned flags)
 {
 	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	ssize_t bytes_tx = 0, bytes_rx = 0;
+	size_t tx_buf_size = page_size;
+	char *tx_buffer;
 	int ret;
 
-	ret = io_uring_submit(ring);
-	if (ret != 1) {
-		fprintf(stderr, "sqe submit failed: %d\n", ret);
-		return NULL;
+	tx_buffer = t_aligned_alloc(page_size, tx_buf_size);
+	if (!tx_buffer)
+		t_error(1, 0, "Can't alloc tx buffer");
+
+	sqe = io_uring_get_sqe(&ctx->ring);
+	test_io_uring_prep_zcrx(sqe, ctx->fds[0], ctx->reg.zcrx.zcrx_id);
+	sqe->len = length;
+	ret = io_uring_submit(&ctx->ring);
+	if (ret != 1)
+		t_error(1, ret, "transfer_bytes: submit fail\n");
+
+	while (bytes_rx < length) {
+		if (bytes_tx < length && (ssize_t)(bytes_tx - bytes_rx) < 2 * tx_buf_size) {
+			ssize_t to_send = length - bytes_tx;
+			ssize_t sent;
+
+			if (to_send > tx_buf_size)
+				to_send = tx_buf_size;
+			fill_pattern(tx_buffer, to_send, bytes_tx);
+			sent = send(ctx->fds[1], tx_buffer, tx_buf_size, 0);
+			if (sent <= 0)
+				t_error(1, sent, "Send failed\n");
+			bytes_tx += sent;
+		}
+
+		if (bytes_rx > bytes_tx)
+			t_error(1, 0, "unexpected tx/rx state");
+		if (bytes_tx == bytes_rx)
+			continue;
+
+		ret = io_uring_wait_cqe(&ctx->ring, &cqe);
+		if (ret < 0)
+			t_error(1, ret, "submit_and_wait_one: wait fail\n");
+		ret = 0;
+
+		if (!(cqe->flags & IORING_CQE_F_MORE)) {
+			ret = cqe->res < 0 ? cqe->res : -1;
+		} else if (cqe->res < 0) {
+			ret = cqe->res;
+		} else {
+			const struct io_uring_zcrx_cqe *rcqe = (void *)(cqe + 1);
+			__u64 mask = (1ULL << IORING_ZCRX_AREA_SHIFT) - 1;
+			char *data = (char *)ctx->reg.area.addr + (rcqe->off & mask);
+
+			if (check_pattern(data, cqe->res, bytes_rx)) {
+				ret = -3;
+				break;
+			}
+			bytes_rx += cqe->res;
+
+			if (flags & T_RETURN_BUFS) {
+				ret = return_buffer(ctx, cqe, flags);
+				if (ret < 0)
+					return ret;
+			}
+		}
+
+		io_uring_cqe_seen(&ctx->ring, cqe);
+		if (ret < 0)
+			goto done;
 	}
 
-	ret = io_uring_wait_cqe(ring, &cqe);
-	if (ret < 0) {
-		fprintf(stderr, "wait completion %d\n", ret);
-		return NULL;
+	ret = io_uring_wait_cqe(&ctx->ring, &cqe);
+	if (ret < 0)
+		t_error(1, ret, "submit_and_wait_one: wait fail\n");
+
+	if ((cqe->flags & IORING_CQE_F_MORE) || cqe->res != 0) {
+		ret = -2;
+		goto done;
 	}
+	io_uring_cqe_seen(&ctx->ring, cqe);
+	ret = 0;
+done:
+	free(tx_buffer);
+	return ret;
+}
 
-	return cqe;
+static void clean_server_noring(struct t_executor *ctx)
+{
+	close(ctx->fds[0]);
+	close(ctx->fds[1]);
 }
 
-static int test_invalid_zcrx_request(void *area)
+static void clean_server(struct t_executor *ctx)
+{
+	io_uring_queue_exit(&ctx->ring);
+	clean_server_noring(ctx);
+}
+
+static int test_invalid_recv(void)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
-	struct io_uring ring;
-	__u32 zcrx_id;
-	int ret, fds[2];
-
-	ret = create_ring_with_ifq(&ring, area, &zcrx_id);
-	if (ret != T_SETUP_OK) {
-		fprintf(stderr, "ifq-ring create failed: %d\n", ret);
-		return T_EXIT_FAIL;
-	}
+	struct t_executor ctx;
+	unsigned zcrx_id;
+	int ret;
 
-	ret = t_create_socket_pair(fds, true);
-	if (ret) {
-		fprintf(stderr, "t_create_socket_pair failed: %d\n", ret);
+	ret = prep_server(&ctx);
+	if (ret)
 		return ret;
-	}
+	zcrx_id = ctx.reg.zcrx.zcrx_id;
 
-	/* invalid file */
-	sqe = io_uring_get_sqe(&ring);
-	test_io_uring_prep_zcrx(sqe, ring.ring_fd, zcrx_id);
-
-	cqe = submit_and_wait_one(&ring);
-	if (!cqe) {
-		fprintf(stderr, "submit_and_wait_one failed\n");
-		return T_EXIT_FAIL;
-	}
+	sqe = io_uring_get_sqe(&ctx.ring);
+	test_io_uring_prep_zcrx(sqe, -1, zcrx_id);
+	cqe = submit_and_wait_one(&ctx.ring);
 	if (cqe->flags & IORING_CQE_F_MORE) {
-		fprintf(stderr, "unexpected F_MORE for invalid fd\n");
-		return T_EXIT_FAIL;
+		fprintf(stderr, "unexpected F_MORE for sockfd=-1\n");
+		return -1;
 	}
-	if (cqe->res != -ENOTSOCK) {
-		fprintf(stderr, "zcrx for non-socket file\n");
-		return T_EXIT_FAIL;
+	if (cqe->res != -ENOTSOCK && cqe->res != -EBADF) {
+		fprintf(stderr, "received from fd=-1 %i\n", cqe->res);
+		return -1;
 	}
-	io_uring_cqe_seen(&ring, cqe);
-
-	/* invalid ifq idx */
-	sqe = io_uring_get_sqe(&ring);
-	test_io_uring_prep_zcrx(sqe, fds[0], zcrx_id + 1);
+	io_uring_cqe_seen(&ctx.ring, cqe);
 
-	cqe = submit_and_wait_one(&ring);
-	if (!cqe) {
-		fprintf(stderr, "submit_and_wait_one failed\n");
-		return T_EXIT_FAIL;
+	sqe = io_uring_get_sqe(&ctx.ring);
+	test_io_uring_prep_zcrx(sqe, ctx.ring.ring_fd, zcrx_id);
+	cqe = submit_and_wait_one(&ctx.ring);
+	if (cqe->flags & IORING_CQE_F_MORE) {
+		fprintf(stderr, "unexpected F_MORE w/ sockfd=ring_fd\n");
+		return -1;
+	}
+	if (cqe->res != -ENOTSOCK && cqe->res != -EBADF) {
+		fprintf(stderr, "received form ring fd %i\n", cqe->res);
+		return -1;
 	}
+	io_uring_cqe_seen(&ctx.ring, cqe);
+
+	sqe = io_uring_get_sqe(&ctx.ring);
+	test_io_uring_prep_zcrx(sqe, ctx.fds[0], zcrx_id + 1);
+	cqe = submit_and_wait_one(&ctx.ring);
 	if (cqe->flags & IORING_CQE_F_MORE) {
-		fprintf(stderr, "unexpected F_MORE for invalid fd\n");
-		return T_EXIT_FAIL;
+		fprintf(stderr, "unexpected F_MORE for invalid zcrx_id\n");
+		return -1;
 	}
 	if (cqe->res != -EINVAL) {
-		fprintf(stderr, "zcrx recv with non-existent zcrx ifq\n");
-		return T_EXIT_FAIL;
+		fprintf(stderr, "received w/ invalid zcrx_id %i\n", cqe->res);
+		return -1;
 	}
-	io_uring_cqe_seen(&ring, cqe);
+	io_uring_cqe_seen(&ctx.ring, cqe);
 
-	close(fds[0]);
-	close(fds[1]);
-	io_uring_queue_exit(&ring);
+	clean_server(&ctx);
 	return 0;
 }
 
-struct recv_data {
-	pthread_barrier_t connect;
-	pthread_barrier_t startup;
-	pthread_barrier_t barrier;
-	pthread_barrier_t finish;
-
-	int accept_fd;
-	char buf[MSG_SIZE];
-	void *area;
-	void *ring_ptr;
-	unsigned int ring_sz;
-	struct io_uring_zcrx_rq rq_ring;
-};
-
-static int recv_prep(struct io_uring *ring, struct recv_data *rd, int *sock,
-		     __u32 zcrx_id)
+static int test_exit_with_inflight(void)
 {
-	struct sockaddr_in saddr;
+	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
-	int sockfd, ret, val, use_fd;
-	socklen_t socklen;
-
-	memset(&saddr, 0, sizeof(saddr));
-	saddr.sin_family = AF_INET;
-	saddr.sin_addr.s_addr = htonl(INADDR_ANY);
-	saddr.sin_port = htons(PORT);
+	struct t_executor ctx;
+	unsigned zcrx_id;
+	int ret;
 
-	sockfd = socket(AF_INET, SOCK_STREAM, 0);
-	if (sockfd < 0) {
-		perror("socket");
-		return 1;
+	ret = prep_server(&ctx);
+	if (ret)
+		return ret;
+	zcrx_id = ctx.reg.zcrx.zcrx_id;
+
+	sqe = io_uring_get_sqe(&ctx.ring);
+	test_io_uring_prep_zcrx(sqe, ctx.fds[0], zcrx_id);
+	ret = io_uring_submit(&ctx.ring);
+	if (ret != 1)
+		t_error(1, ret, "submit_and_wait_one: submit fail\n");
+
+	ret = io_uring_peek_cqe(&ctx.ring, &cqe);
+	if (ret == 0) {
+		fprintf(stderr, "Early terminated request\n");
+		return -1;
 	}
 
-	val = 1;
-	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
+	io_uring_queue_exit(&ctx.ring);
+	sleep(1);
+	clean_server_noring(&ctx);
+	return 0;
+}
 
-	ret = bind(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
-	if (ret < 0) {
-		perror("bind");
-		goto err;
-	}
+static int test_zcrx_invalid_clone(void)
+{
+	struct io_uring_zcrx_ifq_reg import;
+	struct io_uring r1, r2;
+	struct zcrx_ctrl ctrl;
+	struct zcrx_reg reg;
+	unsigned box_fd;
+	int ret;
 
-	ret = listen(sockfd, 1);
-	if (ret < 0) {
-		perror("listen");
-		goto err;
+	ret = t_create_ring(128, &r1, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring1 create failed: %d\n", ret);
+		return -1;
+	}
+	ret = t_create_ring(128, &r2, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring1 create failed: %d\n", ret);
+		return -1;
 	}
 
-	pthread_barrier_wait(&rd->connect);
+	ctrl = (struct zcrx_ctrl) {
+		.zcrx_id = 0,
+		.op = ZCRX_CTRL_EXPORT,
+	};
+	ret = io_uring_register(-1, IORING_REGISTER_ZCRX_CTRL, &ctrl, 0);
+	if (!ret) {
+		fprintf(stderr, "exported with no ring %i\n", ret);
+		return -1;
+	}
 
-	socklen = sizeof(saddr);
-	use_fd = accept(sockfd, (struct sockaddr *)&saddr, &socklen);
-	if (use_fd < 0) {
-		perror("accept");
-		goto err;
+	ctrl = (struct zcrx_ctrl) {
+		.zcrx_id = 0,
+		.op = ZCRX_CTRL_EXPORT,
+	};
+	ret = t_zcrx_ctrl(&r1, &ctrl);
+	if (ret == 0) {
+		fprintf(stderr, "exported without zcrx %i\n", ret);
+		return -1;
 	}
 
-	rd->accept_fd = use_fd;
-	pthread_barrier_wait(&rd->startup);
-	pthread_barrier_wait(&rd->barrier);
+	import = (struct io_uring_zcrx_ifq_reg) {
+		.flags = ZCRX_REG_IMPORT,
+		.if_idx = -1,
+	};
+	ret = io_uring_register_ifq(&r1, &import);
+	if (ret == 0) {
+		fprintf(stderr, "register invalid box %i\n", ret);
+		return -1;
+	}
 
-	sqe = io_uring_get_sqe(ring);
-	io_uring_prep_rw(IORING_OP_RECV_ZC, sqe, use_fd, NULL, 0, 0);
-	sqe->zcrx_ifq_idx = zcrx_id;
-	sqe->ioprio |= IORING_RECV_MULTISHOT;
-	sqe->user_data = 2;
+	default_reg(&reg, 0);
+	ret = io_uring_register_ifq(&r1, &reg.zcrx);
+	if (ret) {
+		fprintf(stderr, "Can't register zcrx\n");
+		return ret;
+	}
+	ctrl = (struct zcrx_ctrl) {
+		.zcrx_id = 0,
+		.op = ZCRX_CTRL_EXPORT,
+	};
+	box_fd = ctrl.zc_export.zcrx_fd;
+	ret = t_zcrx_ctrl(&r1, &ctrl);
+	if (ret < 0 || (int)box_fd < 0) {
+		fprintf(stderr, "Can'r export zcrx %i\n", ret);
+		return -1;
+	}
 
-	ret = io_uring_submit(ring);
-	if (ret <= 0) {
-		fprintf(stderr, "submit failed: %d\n", ret);
-		goto err;
+	import = (struct io_uring_zcrx_ifq_reg) {
+		.flags = ZCRX_REG_IMPORT,
+		.if_idx = box_fd,
+	};
+	ret = io_uring_register(-1, IORING_REGISTER_ZCRX_IFQ, &import, 1);
+	if (ret == 0) {
+		fprintf(stderr, "Imported wo ring %i\n", ret);
+		return ret;
 	}
 
-	*sock = sockfd;
+	close(box_fd);
+	io_uring_queue_exit(&r1);
+	io_uring_queue_exit(&r2);
 	return 0;
-err:
-	close(sockfd);
-	return 1;
 }
 
-static struct io_uring_zcrx_rqe* get_refill_entry(struct io_uring_zcrx_rq *rq_ring)
+static int test_zcrx_clone(void)
 {
-	unsigned mask = rq_ring->ring_entries - 1;
-	struct io_uring_zcrx_rqe* rqe;
+	struct io_uring ring_exp, ring_imp;
+	struct io_uring_zcrx_ifq_reg import_reg;
+	struct zcrx_reg reg;
+	int ret;
+
+	ret = t_create_ring(128, &ring_exp, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring1 create failed: %d\n", ret);
+		return -1;
+	}
+	ret = t_create_ring(128, &ring_imp, RING_FLAGS);
+	if (ret != T_SETUP_OK) {
+		fprintf(stderr, "ring2 create failed: %d\n", ret);
+		return -1;
+	}
+
+	default_reg(&reg, 0);
+	ret = io_uring_register_ifq(&ring_exp, &reg.zcrx);
+	if (ret) {
+		fprintf(stderr, "Can't register zcrx\n");
+		return ret;
+	}
 
-	rqe = &rq_ring->rqes[rq_ring->rq_tail & mask];
-	rq_ring->rq_tail++;
-	return rqe;
+	ret = clone_zcrx(reg.zcrx.zcrx_id, &ring_exp, &ring_imp, &import_reg);
+	if (ret)
+		return ret;
+
+	io_uring_queue_exit(&ring_imp);
+	io_uring_queue_exit(&ring_exp);
+	return 0;
 }
 
-static void refill_garbage(struct recv_data *rd, uint64_t area_token)
+static int test_rq_flush(void)
 {
-	struct io_uring_zcrx_rq *rq_ring = &rd->rq_ring;
-	struct io_uring_zcrx_rqe* rqe;
-	int i = 0;
+	struct t_executor ctx;
+	int ret;
 
-	/* invalid area */
-	rqe = get_refill_entry(rq_ring);
-	rqe->off = (area_token + 1) << IORING_ZCRX_AREA_SHIFT;
-	i++;
+	ret = prep_server(&ctx);
+	if (ret)
+		return ret;
 
-	/* invalid area offset */
-	rqe = get_refill_entry(rq_ring);
-	rqe->off = AREA_SZ | (area_token << IORING_ZCRX_AREA_SHIFT);
-	rqe->off += AREA_SZ;
-	i++;
+	ret = flush_rq(&ctx.ring, ctx.reg.zcrx.zcrx_id + 1);
+	if (!ret) {
+		fprintf(stderr, "Flushed non-existent zcrx %i\n", ret);
+		return ret;
+	}
 
-	for (; i < rq_ring->ring_entries; i++) {
-		rqe = get_refill_entry(rq_ring);
-		rqe->off = ((uint64_t)1 << IORING_ZCRX_AREA_SHIFT) - 1;
+	if (rq_ctrl_op_supported(ZCRX_CTRL_FLUSH_RQ)) {
+		ret = flush_rq(&ctx.ring, ctx.reg.zcrx.zcrx_id);
+		if (ret) {
+			fprintf(stderr, "RQ flush failed %i\n", ret);
+			return ret;
+		}
 	}
 
-	io_uring_smp_store_release(rq_ring->ktail, rq_ring->rq_tail);
+	clean_server(&ctx);
+	return 0;
 }
 
-static int do_recv(struct io_uring *ring, struct recv_data *rd,
-		   uint64_t refill_area_token)
+static int test_recv(void)
 {
-	struct io_uring_cqe *cqe;
-	struct io_uring_zcrx_cqe *zcqe;
-	int i, ret;
+	struct t_executor ctx;
+	int ret;
 
-	refill_garbage(rd, refill_area_token);
+	ret = prep_server(&ctx);
+	if (ret)
+		return ret;
 
-	for (i = 0; i < LOOP_COUNT - 1; i++) {
-		uint64_t off, mask = (1ULL << IORING_ZCRX_AREA_SHIFT) - 1;
-		void *addr;
+	ret = transfer_bytes(&ctx, page_size, 0);
+	if (ret) {
+		fprintf(stderr, "Transfer page failed %i\n", ret);
+		return ret;
+	}
+
+	ret = transfer_bytes(&ctx, ctx.reg.area.len * 2, 0);
+	if (!ret) {
+		fprintf(stderr, "Exhaust area test failed %i\n", ret);
+		return ret;
+	}
+	clean_server(&ctx);
 
-		ret = io_uring_wait_cqe(ring, &cqe);
+	if (rq_ctrl_op_supported(ZCRX_CTRL_FLUSH_RQ)) {
+		ret = prep_server(&ctx);
+		if (ret)
+			return ret;
+
+		ret = transfer_bytes(&ctx, page_size, T_RETURN_BUFS);
 		if (ret) {
-			fprintf(stdout, "wait_cqe: %d\n", ret);
-			return 1;
-		}
-		if (cqe->res == -EINVAL) {
-			fprintf(stdout, "recv not supported, skipping\n");
-			goto out;
-		}
-		if (cqe->res < 0) {
-			fprintf(stderr, "failed recv cqe: %d\n", cqe->res);
-			goto err;
-		}
-		if (cqe->res - 1 != strlen(str)) {
-			fprintf(stderr, "got wrong length: %d/%d\n", cqe->res,
-								(int) strlen(str) + 1);
-			goto err;
+			fprintf(stderr, "Transfer page + flush failed %i\n", ret);
+			return ret;
 		}
 
-		zcqe = (struct io_uring_zcrx_cqe *)(cqe + 1);
-		off = zcqe->off & mask;
-		addr = (char *) rd->area + off;
-		ret = strncmp(str, addr, sizeof(str));
-		if (ret != 0) {
-			fprintf(stderr, "recv incorrect payload: %s\n", (const char *)addr);
-			goto err;
+		ret = transfer_bytes(&ctx, ctx.reg.area.len * 2, T_RETURN_BUFS);
+		if (ret) {
+			fprintf(stderr, "Transfer 2xAREA failed %i\n", ret);
+			return ret;
+		}
+		clean_server(&ctx);
+
+		if (AREA_SZ > (RQ_ENTRIES_SMALL + 1) * page_size) {
+			ret = __prep_server(&ctx, CONFIG_SMALL_RQ);
+			if (ret)
+				return ret;
+
+			ret = transfer_bytes(&ctx, ctx.reg.area.len * 2, T_RETURN_BUFS | T_RETURN_LAZY);
+			if (ret) {
+				fprintf(stderr, "Transfer lazy return failed %i\n", ret);
+				return ret;
+			}
+			clean_server(&ctx);
 		}
-
-		io_uring_cqe_seen(ring, cqe);
-	}
-
-	ret = io_uring_wait_cqe(ring, &cqe);
-	if (ret) {
-		fprintf(stdout, "wait_cqe: %d\n", ret);
-		return 1;
-	}
-	if (cqe->res != -ENOMEM) {
-		fprintf(stdout, "final recv cqe did not return ENOMEM\n");
-		goto err;
 	}
 
-out:
-	io_uring_cqe_seen(ring, cqe);
-	pthread_barrier_wait(&rd->finish);
 	return 0;
-err:
-	io_uring_cqe_seen(ring, cqe);
-	pthread_barrier_wait(&rd->finish);
-	return 1;
 }
 
-static void *recv_fn(void *data)
+static int flush_invalid(struct t_executor *ctx, struct io_uring_zcrx_rqe *rqes,
+			 unsigned nr)
 {
-	struct recv_data *rd = data;
-	struct io_uring_params p = { };
-	struct io_uring ring;
-	int ret, sock;
-	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = uring_ptr_to_u64(rd->area),
-		.len = AREA_SZ,
-		.flags = 0,
-	};
-	struct io_uring_zcrx_ifq_reg reg = {
-		.if_idx = ifidx,
-		.if_rxq = rxq,
-		.rq_entries = RQ_ENTRIES,
-		.area_ptr = uring_ptr_to_u64(&area_reg),
-	};
+	struct io_uring_zcrx_rq *rq = &ctx->rq;
+	unsigned rq_mask = rq->ring_entries - 1;
+	struct io_uring_zcrx_rqe *rqe;
+	int i, ret;
 
-	p.flags = RING_FLAGS;
-	ret = t_create_ring_params(8, &ring, &p);
-	if (ret == T_SETUP_SKIP) {
-		ret = 0;
-		goto err;
-	} else if (ret < 0) {
-		goto err;
-	}
-
-	ret = io_uring_register_ifq(&ring, &reg);
-	if (ret != 0) {
-		fprintf(stderr, "register_ifq failed: %d\n", ret);
-		goto err_ring_exit;
-	}
-
-	/*
-	rd->ring_ptr = mmap(
-		0,
-		reg.offsets.mmap_sz,
-		PROT_READ | PROT_WRITE,
-		MAP_SHARED | MAP_POPULATE,
-		ring.enter_ring_fd,
-		IORING_OFF_RQ_RING
-	);
-
-	rd->ring_sz = reg.offsets.mmap_sz;
-	*/
-	rd->rq_ring.khead = (__u32*)((char*)rd->ring_ptr + reg.offsets.head);
-	rd->rq_ring.ktail = (__u32*)((char*)rd->ring_ptr + reg.offsets.tail);
-	rd->rq_ring.rqes = (struct io_uring_zcrx_rqe*)((char*)rd->ring_ptr + reg.offsets.rqes);
-	rd->rq_ring.rq_tail = 0;
-	rd->rq_ring.ring_entries = reg.rq_entries;
-
-	ret = recv_prep(&ring, rd, &sock, reg.zcrx_id);
-	if (ret) {
-		fprintf(stderr, "recv_prep failed: %d\n", ret);
-		goto err;
-	}
-	ret = do_recv(&ring, rd, area_reg.rq_area_token);
+	for (i = 0; i < nr; i++) {
+		rqe = &rq->rqes[rq->rq_tail & rq_mask];
+		memcpy(rqe, &rqes[i], sizeof(*rqe));
 
-	close(sock);
-	close(rd->accept_fd);
-err_ring_exit:
-	io_uring_queue_exit(&ring);
-err:
-	return (void *)(intptr_t)ret;
+		io_uring_smp_store_release(rq->ktail, ++rq->rq_tail);
+
+		ret = flush_rq(&ctx->ring, ctx->reg.zcrx.zcrx_id);
+		if (ret)
+			return ret;
+	}
+	return 0;
 }
 
-static int do_send(struct recv_data *rd)
+static int test_invalid_rq_pointers(void)
 {
-	struct sockaddr_in saddr;
-	struct iovec iov = {
-		.iov_base = str,
-		.iov_len = sizeof(str),
-	};
-	struct io_uring ring;
-	struct io_uring_cqe *cqe;
-	struct io_uring_sqe *sqe;
-	int i, sockfd, ret;
-
-	ret = io_uring_queue_init(8, &ring, 0);
-	if (ret) {
-		fprintf(stderr, "queue init failed: %d\n", ret);
-		return 1;
-	}
+	struct t_executor ctx;
+	struct io_uring_zcrx_rq *rq = &ctx.rq;
+	int ret;
 
-	memset(&saddr, 0, sizeof(saddr));
-	saddr.sin_family = AF_INET;
-	saddr.sin_port = htons(PORT);
-	inet_pton(AF_INET, HOST, &saddr.sin_addr);
+	if (!rq_ctrl_op_supported(ZCRX_CTRL_FLUSH_RQ))
+		return 0;
+	ret = prep_server(&ctx);
+	if (ret)
+		return ret;
+	*rq->ktail = 0;
+	*rq->khead = 1;
+	(void)flush_rq(&ctx.ring, ctx.reg.zcrx.zcrx_id);
+	clean_server(&ctx);
 
-	sockfd = socket(AF_INET, SOCK_STREAM, 0);
-	if (sockfd < 0) {
-		perror("socket");
-		goto err2;
-	}
+	ret = prep_server(&ctx);
+	if (ret)
+		return ret;
+	*rq->ktail = 2 * rq->ring_entries;
+	(void)flush_rq(&ctx.ring, ctx.reg.zcrx.zcrx_id);
+	clean_server(&ctx);
+	return 0;
+}
 
-	pthread_barrier_wait(&rd->connect);
+static int test_invalid_rqes(void)
+{
+	struct io_uring_zcrx_rqe *rqe, rqes[16];
+	struct t_executor ctx;
+	__u64 area_token;
+	int ret, i;
 
-	ret = connect(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
-	if (ret < 0) {
-		perror("connect");
-		goto err;
-	}
+	if (!rq_ctrl_op_supported(ZCRX_CTRL_FLUSH_RQ))
+		return 0;
 
-	pthread_barrier_wait(&rd->startup);
+	ret = prep_server(&ctx);
+	if (ret)
+		return ret;
+	area_token = ctx.reg.area.rq_area_token;
 
-	for (i = 0; i < LOOP_COUNT; i++) {
-		sqe = io_uring_get_sqe(&ring);
-		io_uring_prep_send(sqe, sockfd, iov.iov_base, iov.iov_len, 0);
-		sqe->user_data = 1;
+	for (i = 0; i < 16; i++) {
+		rqe = &rqes[i];
+		rqe->off = area_token;
+		rqe->len = 1;
 	}
+	ret = flush_invalid(&ctx, rqes, 16);
+	if (ret)
+		return ret;
+	clean_server(&ctx);
 
-	ret = io_uring_submit(&ring);
-	if (ret <= 0) {
-		fprintf(stderr, "submit failed: %d\n", ret);
-		goto err;
-	}
+	ret = prep_server(&ctx);
+	if (ret)
+		return ret;
+	area_token = ctx.reg.area.rq_area_token;
 
-	pthread_barrier_wait(&rd->barrier);
+	rqe = &rqes[0];
+	rqe->off = area_token + ctx.reg.area.len;
+	rqe->len = 1;
 
-	ret = io_uring_wait_cqe(&ring, &cqe);
-	if (cqe->res == -EINVAL) {
-		fprintf(stdout, "send not supported, skipping\n");
-		goto err;
-	}
-	if (cqe->res != iov.iov_len) {
-		fprintf(stderr, "failed cqe: %d\n", cqe->res);
-		goto err;
-	}
+	rqe = &rqes[1];
+	rqe->off = ((uint64_t)1 << IORING_ZCRX_AREA_SHIFT) - 1;
+	rqe->len = 1;
 
-	pthread_barrier_wait(&rd->finish);
+	rqe = &rqes[2];
+	rqe->off = area_token + ((__u64)1 << IORING_ZCRX_AREA_SHIFT);
+	rqe->len = 1;
 
-	close(sockfd);
-	io_uring_queue_exit(&ring);
-	return 0;
+	rqe = &rqes[3];
+	rqe->off = area_token;
+	rqe->len = 1;
+	rqe->__pad = 1;
 
-err:
-	close(sockfd);
-err2:
-	io_uring_queue_exit(&ring);
-	pthread_barrier_wait(&rd->finish);
-	return 1;
+	ret = flush_invalid(&ctx, rqes, 4);
+	if (ret)
+		return ret;
+	clean_server(&ctx);
+	return 0;
 }
 
-static int test_recv(void *area)
+static int test_area_ro(void)
 {
-	pthread_t recv_thread;
-	struct recv_data rd;
+	struct zcrx_reg reg;
+	void *area;
 	int ret;
-	void *retval;
 
-	memset(&rd, 0, sizeof(rd));
-	pthread_barrier_init(&rd.connect, NULL, 2);
-	pthread_barrier_init(&rd.startup, NULL, 2);
-	pthread_barrier_init(&rd.barrier, NULL, 2);
-	pthread_barrier_init(&rd.finish, NULL, 2);
-	rd.area = area;
+	default_reg(&reg, 0);
 
-	ret = pthread_create(&recv_thread, NULL, recv_fn, &rd);
-	if (ret) {
-		fprintf(stderr, "Thread create failed: %d\n", ret);
-		return 1;
+	area = mmap(NULL, reg.area.len, PROT_READ,
+		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (area == MAP_FAILED) {
+		perror("mmap");
+		return T_EXIT_FAIL;
 	}
 
-	do_send(&rd);
-	pthread_join(recv_thread, &retval);
-	return (intptr_t)retval;
+	reg.area.addr = uring_ptr_to_u64(area);
+	ret = try_register_zcrx(&reg.zcrx);
+	if (ret != -EFAULT) {
+		fprintf(stderr, "registered read-only memory\n");
+		return T_EXIT_FAIL;
+	}
+	munmap(area, AREA_SZ);
+	return 0;
 }
 
-int main(int argc, char *argv[])
+static int run_tests(void)
 {
-	char *dev, *rxq_str, *rxq_end;
-	void *area_outer, *area;
 	int ret;
 
-	if (argc > 1)
+	ret = test_register_basic();
+	if (ret == -EPERM) {
+		printf("-EPERM, zcrx requires NET_ADMIN, skip\n");
 		return T_EXIT_SKIP;
-
-	page_size = sysconf(_SC_PAGESIZE);
-	if (page_size < 0) {
-		perror("sysconf(_SC_PAGESIZE)");
+	}
+	if (ret) {
+		fprintf(stderr, "test_register_basic() failed %i\n", ret);
 		return T_EXIT_FAIL;
 	}
 
-	area_outer = mmap(NULL, AREA_SZ + 8192, PROT_NONE,
-		MAP_ANONYMOUS | MAP_PRIVATE | MAP_NORESERVE, -1, 0);
-	if (area_outer == MAP_FAILED) {
-		perror("mmap");
+	ret = test_rq();
+	if (ret) {
+		fprintf(stderr, "test_rq() failed %i\n", ret);
 		return T_EXIT_FAIL;
 	}
 
-	area = mmap(area_outer, AREA_SZ, PROT_READ | PROT_WRITE,
-			MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
-	if (area == MAP_FAILED) {
-		perror("mmap");
+	ret = test_area();
+	if (ret) {
+		fprintf(stderr, "test_area() failed %i\n", ret);
 		return T_EXIT_FAIL;
 	}
 
-	dev = getenv(DEV_ENV_VAR);
-	if (!dev)
-		return T_EXIT_SKIP;
-
-	ifidx = if_nametoindex(dev);
-	if (!ifidx)
-		return T_EXIT_SKIP;
-
-	rxq_str = getenv(RXQ_ENV_VAR);
-	if (!rxq_str)
-		return T_EXIT_SKIP;
-
-	rxq = strtol(rxq_str, &rxq_end, 10);
-	if (rxq_end == rxq_str || *rxq_end != '\0')
-		return T_EXIT_SKIP;
-
-	ret = probe_zcrx(area);
-	if (ret != T_EXIT_PASS)
-		return ret;
-
-	ret = test_rq_setup(area);
+	ret = test_area_ro();
 	if (ret) {
-		fprintf(stderr, "test_invalid_reg_struct failed\n");
-		return ret;
+		fprintf(stderr, "test_area() failed %i\n", ret);
+		return T_EXIT_FAIL;
 	}
 
-	ret = test_null_area_reg_struct();
-	if (ret) {
-		fprintf(stderr, "test_null_area_reg_struct failed\n");
-		return ret;
+	if (query.features & ZCRX_FEATURE_RX_PAGE_SIZE) {
+		ret = test_invalid_rx_page();
+		if (ret) {
+			fprintf(stderr, "test_invalid_rx_page() failed %i\n", ret);
+			return T_EXIT_FAIL;
+		}
 	}
 
-	ret = test_null_area();
+	ret = test_ro_params();
 	if (ret) {
-		fprintf(stderr, "test_null_area failed\n");
-		return ret;
+		fprintf(stderr, "test_ro_params() failed %i\n", ret);
+		return T_EXIT_FAIL;
 	}
 
-	ret = test_misaligned_area(area);
+	ret = test_invalid_recv();
 	if (ret) {
-		fprintf(stderr, "test_misaligned_area failed\n");
-		return ret;
+		fprintf(stderr, "test_invalid_recv() failed %i\n", ret);
+		return T_EXIT_FAIL;
 	}
 
-	ret = test_larger_than_alloc_area(area);
+	ret = test_exit_with_inflight();
 	if (ret) {
-		fprintf(stderr, "test_larger_than_alloc_area failed\n");
-		return ret;
+		fprintf(stderr, "test_exit_with_inflight() failed %i\n", ret);
+		return T_EXIT_FAIL;
 	}
 
-	ret = test_area_access();
-	if (ret) {
-		fprintf(stderr, "test_area_access failed\n");
-		return ret;
+	if (query.register_flags & ZCRX_REG_IMPORT) {
+		ret = test_zcrx_invalid_clone();
+		if (ret) {
+			fprintf(stderr, "test_zcrx_invalid_clone() failed %i\n", ret);
+			return T_EXIT_FAIL;
+		}
+
+		ret = test_zcrx_clone();
+		if (ret) {
+			fprintf(stderr, "test_zcrx_clone() failed %i\n", ret);
+			return T_EXIT_FAIL;
+		}
+	} else {
+		printf("zcrx import is not supported, skip\n");
 	}
 
-	ret = test_invalid_if(area);
+	ret = test_rq_flush();
 	if (ret) {
-		fprintf(stderr, "test_invalid_if failed\n");
-		return ret;
+		fprintf(stderr, "test_rq_flush() failed %i\n", ret);
+		return T_EXIT_FAIL;
 	}
 
-	ret = test_invalid_ifq_collision(area);
+	ret = test_invalid_rqes();
 	if (ret) {
-		fprintf(stderr, "test_invalid_ifq_collision failed\n");
-		return ret;
+		fprintf(stderr, "test_invalid_rqes() failed %i\n", ret);
+		return T_EXIT_FAIL;
 	}
 
-	ret = test_invalid_zcrx_request(area);
+	ret = test_invalid_rq_pointers();
 	if (ret) {
-		fprintf(stderr, "test_invalid_ifq_collision failed\n");
-		return ret;
+		fprintf(stderr, "test_invalid_rq_pointers() failed %i\n", ret);
+		return T_EXIT_FAIL;
 	}
 
-	ret = test_recv(area);
+	ret = test_recv();
 	if (ret) {
-		fprintf(stderr, "test_recv failed\n");
-		return ret;
+		fprintf(stderr, "test_recv() failed %i\n", ret);
+		return T_EXIT_FAIL;
 	}
 
-	munmap(area, AREA_SZ);
 	return T_EXIT_PASS;
 }
+
+static void setup(void)
+{
+	void *area_outer;
+
+	area_outer = mmap(NULL, AREA_SZ + 2 * page_size, PROT_NONE,
+		MAP_ANONYMOUS | MAP_PRIVATE | MAP_NORESERVE, -1, 0);
+	if (area_outer == MAP_FAILED)
+		perror("mmap");
+
+	def_area_mem = mmap(area_outer + page_size, AREA_SZ, PROT_READ | PROT_WRITE,
+				MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	if (def_area_mem == MAP_FAILED)
+		perror("mmap");
+
+	def_hugepage_area_mem = mmap(NULL, HUGEPAGE_AREA_SZ, PROT_READ | PROT_WRITE,
+				     MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB | MAP_HUGE_2MB,
+				     -1, 0);
+	if (def_hugepage_area_mem == MAP_FAILED) {
+		printf("can't allocate huge page, skip huge page tests\n");
+		def_hugepage_area_mem = NULL;
+	}
+
+	def_rq_mem = mmap(NULL, get_rq_size(RQ_ENTRIES), PROT_READ | PROT_WRITE,
+			  MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (def_rq_mem == MAP_FAILED)
+		t_error(1, 0, "mmap(): refill ring");
+
+	def_area_mem = mmap(NULL, AREA_SZ, PROT_READ | PROT_WRITE,
+			  MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (def_area_mem == MAP_FAILED)
+		t_error(1, 0, "mmap(): refill ring");
+	madvise(def_area_mem, AREA_SZ, MADV_NOHUGEPAGE);
+}
+
+int main(int argc, char *argv[])
+{
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	page_size = sysconf(_SC_PAGESIZE);
+	if (page_size < 0) {
+		perror("sysconf(_SC_PAGESIZE)");
+		return T_EXIT_FAIL;
+	}
+
+	query_zcrx();
+
+	if (!zcrx_supported) {
+		printf("zcrx and query are not supported, skip");
+		return T_EXIT_SKIP;
+	}
+	if (!(query.register_flags & ZCRX_REG_NODEV)) {
+		printf("zcrx nodev mode not supported, skip");
+		return T_EXIT_SKIP;
+	}
+
+	setup();
+	return run_tests();
+}
-- 
2.53.0


