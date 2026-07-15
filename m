Return-Path: <io-uring+bounces-14019-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id JwH9MTwsV2qpGwEAu9opvQ
	(envelope-from <io-uring+bounces-14019-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:44:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DEB475B2F2
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:44:12 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Tu2UuiuE;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14019-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-14019-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A1BF5301BC24
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 06:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B0FD20ADF8;
	Wed, 15 Jul 2026 06:40:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C67521CA03
	for <io-uring@vger.kernel.org>; Wed, 15 Jul 2026 06:40:05 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784097606; cv=none; b=o+H4XjDaoyZUbARt0GNFevbvpsPA9xFfppamLCpRgCAGQK4MNgtkHFi7lODMIlqJSHQLv5L3DHICb7yF3Ox+mk2AtYge6/ppi75Hd0PEJpOrhF31rheBpw6aQjTOQfhegPKfPr6dtCYCNJMm8Xayl6jYPBJa+51j9Vkq0Zkm7jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784097606; c=relaxed/simple;
	bh=31wuuNokgsIysJjLickavFdzuRpBUkAjeUj8VQXtfU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgdSiNAlzsm+enh7qOnMmWJZyrX0j3hj8QBYJt6szavoEog5hh7czQP87u4OQAD/U8vVGqjtgXJAYeczWqNBcDhG9NLAFZ0vPaGVG+Zh37GLDxR+bu7mcqPlr7h79d9E39tOuTJeGbPwHpyJm1Iii8P7JbUy0CSG6aHKTJOH2Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Tu2UuiuE; arc=none smtp.client-ip=198.137.202.133
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Y9u/pXe3NF+4fTSWEM78Xt2t8pQ5J9S9fSCK93nHVV0=; b=Tu2UuiuEXBOTFxRPUFlYIUe+BO
	vl6IQNQD9Apj2nBisB+zJuiTmNF+tSVpnoIPywxXs/5E2nJQSIwh/mzngjcb916kXs8pvMSfK9d0P
	Cm4ZIGSi40zzfapdKEfKwxCrt5MLGy1FKca7OLIJUvdg7lJ9+AJFuMSAiLccPmKhIdHt9Y3Nw4Tid
	AhtJCyTpKyKOEixQEKQclRrAvEXcDfg5jgKRVRpg+/6G+RPmXoZGdhzTeecZyAvlaIqGVFx+ELA6w
	CEXMBxSSysVihnILXXMtxzTTvBvbWTVHkZbA6IZ+l+T7BGQ9E13XohEmx4/Br+lrNvenDxaNGd3KA
	KFOWnTDQ==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjtHo-0000000DvDi-249E;
	Wed, 15 Jul 2026 06:40:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH 5/5] test: add zone_reset_all command test
Date: Wed, 15 Jul 2026 08:39:32 +0200
Message-ID: <20260715063947.2933606-6-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260715063947.2933606-1-hch@lst.de>
References: <20260715063947.2933606-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.06 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=bombadil.20210309];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), DKIM not aligned (relaxed),none];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-14019-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:dlemoal@kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[infradead.org:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,infradead.org:dkim,vger.kernel.org:from_smtp,lst.de:from_mime,lst.de:email,lst.de:mid]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 6DEB475B2F2

Basic sanity checking for the simply zone_reset_all command, mostly
taken from the discard test.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 test/Makefile             |   1 +
 test/cmd-zone-reset-all.c | 164 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 165 insertions(+)
 create mode 100644 test/cmd-zone-reset-all.c

diff --git a/test/Makefile b/test/Makefile
index d88a428774cc..8b276817d33c 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -90,6 +90,7 @@ test_srcs := \
 	connect-rep.c \
 	coredump.c \
 	cmd-discard.c \
+	cmd-zone-reset-all.c \
 	cq-full.c \
 	cq-overflow.c \
 	cq-peek-batch.c \
diff --git a/test/cmd-zone-reset-all.c b/test/cmd-zone-reset-all.c
new file mode 100644
index 000000000000..5d8fe4d5f380
--- /dev/null
+++ b/test/cmd-zone-reset-all.c
@@ -0,0 +1,164 @@
+/* SPDX-License-Identifier: MIT */
+
+#include <stdio.h>
+#include <assert.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+static const char *filename;
+
+static int queue_zone_reset_all(struct io_uring *ring, int bdev_fd)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int err;
+
+	sqe = io_uring_get_sqe(ring);
+	assert(sqe != NULL);
+	io_uring_prep_cmd_zone_reset_all(sqe, bdev_fd);
+
+	err = io_uring_submit_and_wait(ring, 1);
+	if (err != 1) {
+		fprintf(stderr, "io_uring_submit_and_wait failed %d\n", err);
+		exit(1);
+	}
+
+	err = io_uring_wait_cqe(ring, &cqe);
+	if (err) {
+		fprintf(stderr, "io_uring_wait_cqe failed %d\n", err);
+		exit(1);
+	}
+
+	err = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	return err;
+}
+
+
+static int basic_cmd_test(struct io_uring *ring)
+{
+	int ret, fd;
+
+	fd = open(filename, O_DIRECT | O_RDWR | O_EXCL);
+	if (fd < 0) {
+		if (errno == EINVAL || errno == EBUSY)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "open failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	ret = queue_zone_reset_all(ring, fd);
+	if (ret) {
+		if (ret == -EINVAL || ret == -EOPNOTSUPP) {
+			printf("cmd not supported, skip\n");
+			ret = T_EXIT_SKIP;
+		} else {
+			fprintf(stderr, "cmd_issue_verify fail ret %i\n", ret);
+			fprintf(stderr, "cmd fail\n");
+			ret = T_EXIT_FAIL;
+		}
+	}
+
+	close(fd);
+	return ret;
+}
+
+static int test_rdonly(struct io_uring *ring)
+{
+	int ret, fd;
+	int ro;
+
+	fd = open(filename, O_DIRECT | O_RDONLY | O_EXCL);
+	if (fd < 0) {
+		if (errno == EINVAL || errno == EBUSY)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "open failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	ret = queue_zone_reset_all(ring, fd);
+	if (ret >= 0) {
+		fprintf(stderr, "discarded with O_RDONLY %i\n", ret);
+		return 1;
+	}
+	close(fd);
+
+	fd = open(filename, O_DIRECT | O_RDWR | O_EXCL);
+	if (fd < 0) {
+		if (errno == EINVAL || errno == EBUSY)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "open failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	ro = 1;
+	ret = ioctl(fd, BLKROSET, &ro);
+	if (ret) {
+		fprintf(stderr, "BLKROSET 1 failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	ret = queue_zone_reset_all(ring, fd);
+	if (ret >= 0) {
+		fprintf(stderr, "discarded with O_RDONLY %i\n", ret);
+		return 1;
+	}
+
+	ro = 0;
+	ret = ioctl(fd, BLKROSET, &ro);
+	if (ret) {
+		fprintf(stderr, "BLKROSET 0 failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+	close(fd);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int fd, ret;
+
+	if (argc != 2)
+		return T_EXIT_SKIP;
+	filename = argv[1];
+
+	fd = open(filename, O_DIRECT | O_RDONLY | O_EXCL);
+	if (fd < 0) {
+		if (errno == EINVAL || errno == EBUSY)
+			return T_EXIT_SKIP;
+		fprintf(stderr, "open failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+	close(fd);
+
+	ret = io_uring_queue_init(16, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = basic_cmd_test(&ring);
+	if (ret == T_EXIT_FAIL) {
+		fprintf(stderr, "basic_cmd_test() failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_rdonly(&ring);
+	if (ret == T_EXIT_FAIL) {
+		fprintf(stderr, "test_rdonly() failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	if (ret != T_EXIT_SKIP)
+		ret = T_EXIT_PASS;
+
+	io_uring_queue_exit(&ring);
+	return ret;
+}
-- 
2.53.0


