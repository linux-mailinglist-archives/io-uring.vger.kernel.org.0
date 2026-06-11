Return-Path: <io-uring+bounces-13669-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 93yaB3IPKmo5iAMAu9opvQ
	(envelope-from <io-uring+bounces-13669-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:29:22 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A747066DA40
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:29:21 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=nKv2ZI4E;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13669-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13669-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7E847307BA33
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 01:29:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DAE01BBBFC;
	Thu, 11 Jun 2026 01:29:19 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8DC140D586
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 01:29:16 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781141359; cv=none; b=TVoNXIz4+K9ZeZDTqThmBesHQl2UrbB0ks5bzLsVkRx/i8oNCZ9VTCjy6ttTeM5OIsukVvKxySH+CJV5lxR3Caq1MDGOC58wbsGcMoNOJdcGTcTzN8GwfVeQ17r6xMJw5yw5nYTCpqV4zv3t9oOAdzq1RZoFe2DtaPIuf/ov+/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781141359; c=relaxed/simple;
	bh=+tew1i68tIICwm4XO3ZQTPgxj2Y7YBsr49B+xuj3ulw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=puBCUfiEVQVWeQNVgZuxnMz7eUC0CTFfmKTYinp3AXwN1yYW4v2iekjYWfv4kH+UvuddeKwA/hP8637Cd/CEFAo5D6O1HhwU6rw3jx7k2PvdB1ZRTiasKU/vMb52h+oEQLegHsQJklvV8l35uKUsScoJ+i0sAc8VzIhcMe4c3aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nKv2ZI4E; arc=none smtp.client-ip=117.135.210.3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=d9
	pHaJxSFXMYOd+iQibvc5JmEimP1WRO4UI+doqUgFM=; b=nKv2ZI4EeyhYk5nCol
	btp/7xgiyhfOvr0/UCVikgtKorOfAFTY3M79g8UyfQcEAxXV7QefkAOE83xKc5e0
	htRm2vP5I/PvOKVEddmO7996Er3UZJWMC/YlZsQyutc/CGg871v+IH98OhH+IpsS
	HPzX1PwoBmaKXvvj2Up2CpLxM=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCHMwNIDypqb8GyBg--.27485S4;
	Thu, 11 Jun 2026 09:28:42 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 2/2] test/link-timeout: add link timeout remove tests
Date: Thu, 11 Jun 2026 09:28:37 +0800
Message-Id: <20260611012837.3032351-3-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260611012837.3032351-1-yangxiuwei@kylinos.cn>
References: <20260611012837.3032351-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgCHMwNIDypqb8GyBg--.27485S4
X-Coremail-Antispam: 1Uf129KBjvJXoW3AFWxCw48XryxZF43Kw4rXwb_yoW7XrW3pr
	4aqwn8KrW8AF1jg343tr4UZr9Yyw42yay7GF9rCws3Ars2yF98Wr40gFy8Kan8JFZ7t343
	tFsaqa1qkr1DXa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j8OzsUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gr6i2oqD0rWZQAA3n
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[163.com:s=s110527];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORWARDED(0.00)[lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-13669-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:io-uring@vger.kernel.org,m:yangxiuwei@kylinos.cn,s:lists@lfdr.de];
	DMARC_NA(0.00)[kylinos.cn];
	FORGED_SENDER(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yangxiuwei@kylinos.cn,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[163.com:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: A747066DA40

Add tests for removing a pending link timeout, including a chain
with a linked nop that should still run after the head read completes.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 test/link-timeout.c | 230 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 230 insertions(+)

diff --git a/test/link-timeout.c b/test/link-timeout.c
index 07856ff3..e432e630 100644
--- a/test/link-timeout.c
+++ b/test/link-timeout.c
@@ -768,6 +768,224 @@ err:
 	return 1;
 }
 
+/*
+ * Test removal of a pending link timeout
+ */
+static int test_link_timeout_remove(struct io_uring *ring)
+{
+	struct __kernel_timespec ts;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int fds[2], ret, i;
+	struct iovec iov;
+	char buffer[128];
+
+	if (pipe(fds)) {
+		perror("pipe");
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+
+	iov.iov_base = buffer;
+	iov.iov_len = sizeof(buffer);
+	io_uring_prep_readv(sqe, fds[0], &iov, 1, 0);
+	sqe->flags |= IOSQE_IO_LINK;
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+
+	ts.tv_sec = 3600;
+	ts.tv_nsec = 0;
+	io_uring_prep_link_timeout(sqe, &ts, 0);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(ring);
+	if (ret != 2) {
+		printf("sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+	io_uring_prep_timeout_remove(sqe, 2, 0);
+	sqe->user_data = 3;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		printf("sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			printf("wait completion %d\n", ret);
+			goto err;
+		}
+		switch (cqe->user_data) {
+		case 2:
+			if (cqe->res != -ECANCELED) {
+				fprintf(stderr, "Link timeout got %d, wanted -ECANCELED\n",
+					cqe->res);
+				goto err;
+			}
+			break;
+		case 3:
+			if (cqe->res) {
+				fprintf(stderr, "Req %" PRIu64 " got %d\n",
+					(uint64_t) cqe->user_data, cqe->res);
+				goto err;
+			}
+			break;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	return 0;
+err:
+	return 1;
+}
+
+/*
+ * Test removal of a pending link timeout with a linked nop behind it
+ */
+static int test_link_timeout_remove_chain(struct io_uring *ring)
+{
+	struct __kernel_timespec ts;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int fds[2], ret, i;
+	struct iovec iov;
+	char buffer[128];
+	char byte = 'x';
+
+	if (pipe(fds)) {
+		perror("pipe");
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+
+	iov.iov_base = buffer;
+	iov.iov_len = sizeof(buffer);
+	io_uring_prep_readv(sqe, fds[0], &iov, 1, 0);
+	sqe->flags |= IOSQE_IO_LINK;
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+
+	ts.tv_sec = 3600;
+	ts.tv_nsec = 0;
+	io_uring_prep_link_timeout(sqe, &ts, 0);
+	sqe->flags |= IOSQE_IO_LINK;
+	sqe->user_data = 2;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+	io_uring_prep_nop(sqe);
+	sqe->user_data = 3;
+
+	ret = io_uring_submit(ring);
+	if (ret != 3) {
+		printf("sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+	io_uring_prep_timeout_remove(sqe, 2, 0);
+	sqe->user_data = 4;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		printf("sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			printf("wait completion %d\n", ret);
+			goto err;
+		}
+		switch (cqe->user_data) {
+		case 2:
+			if (cqe->res != -ECANCELED) {
+				fprintf(stderr, "Link timeout got %d, wanted -ECANCELED\n",
+					cqe->res);
+				goto err;
+			}
+			break;
+		case 4:
+			if (cqe->res) {
+				fprintf(stderr, "Req %" PRIu64 " got %d\n",
+					(uint64_t) cqe->user_data, cqe->res);
+				goto err;
+			}
+			break;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	if (write(fds[1], &byte, 1) != 1) {
+		perror("write");
+		goto err;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		printf("wait completion %d\n", ret);
+		goto err;
+	}
+	if (cqe->user_data != 1 || cqe->res != 1) {
+		fprintf(stderr, "Read got %d\n", cqe->res);
+		goto err;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		printf("wait completion %d\n", ret);
+		goto err;
+	}
+	if (cqe->user_data != 3 || cqe->res) {
+		fprintf(stderr, "Req %" PRIu64 " got %d\n",
+			(uint64_t) cqe->user_data, cqe->res);
+		goto err;
+	}
+	io_uring_cqe_seen(ring, cqe);
+
+	return 0;
+err:
+	return 1;
+}
+
 static int test_timeout_link_chain1(struct io_uring *ring)
 {
 	struct __kernel_timespec ts;
@@ -1365,5 +1583,17 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_link_timeout_remove(&ring);
+	if (ret) {
+		printf("test_link_timeout_remove failed\n");
+		return ret;
+	}
+
+	ret = test_link_timeout_remove_chain(&ring);
+	if (ret) {
+		printf("test_link_timeout_remove_chain failed\n");
+		return ret;
+	}
+
 	return T_EXIT_PASS;
 }
-- 
2.25.1


