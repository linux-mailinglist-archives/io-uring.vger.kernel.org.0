Return-Path: <io-uring+bounces-13668-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Q+omNW4PKmo4iAMAu9opvQ
	(envelope-from <io-uring+bounces-13668-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:29:18 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DBD866DA3B
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 03:29:18 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=163.com header.s=s110527 header.b=kyiSBNUS;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13668-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13668-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D0BE5307CEE1
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 01:29:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8184440D586;
	Thu, 11 Jun 2026 01:29:15 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7341BBBFC
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 01:29:12 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781141355; cv=none; b=kNpk4ml195WQ61TGAsgTS/1RrjDRQ6nEyznOV2Q/Bah5c6H7aA//Dz93CPzLBh33kPlKc2U7bwZxfVyMbLimx3Jw1X1JkF52GqHasom67DU35vn3d2Fc80FOC/ivatNo4KTJ62W8gAKmVXJQP8UEPct9NbkZM0Se/PtfxFFm0OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781141355; c=relaxed/simple;
	bh=C0vCpGOm7ebYpx7k++gsHozpcOhsZpUIG7TqezHULog=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aYmSw4/Lp1N1jaRc1LO4WUuBxO4d0SHcN/0cioObQTGgXkl9wh+2R9XOYa4NtQj2GPgVcP4otGEvs59Igbj5bimF6Gz4F+zEvly79Pc/gUrAQyQjRBIjhuZO4ZVf34z8oZMjB12dUBTpCC2X6T+g66/3E8A2ecSY5ootrxFTJic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=kyiSBNUS; arc=none smtp.client-ip=220.197.31.5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=wa
	EvaZAaMR2EcpDuKO1IfuREb9jUL8FAfNQ+D0FIaFQ=; b=kyiSBNUScscgVXvJ7e
	EgAeDh/kvN+yPOxtn7IH7PVtkb87BEikpcQsZGBB2mvCCNNYDesHPAZT5uYZPJ41
	ZoVG7tKp9SGObQEa7x34BjQdCbD+4pdQyOFfyN0Bbm9+GlS/77Pc87nw7ZQltvnC
	Y9uZqr+C2ZR94QeTDnRsZQZAY=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCHMwNIDypqb8GyBg--.27485S3;
	Thu, 11 Jun 2026 09:28:41 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org,
	Yang Xiuwei <yangxiuwei@kylinos.cn>
Subject: [PATCH 1/2] test/link-timeout: add natural disarm chain with short pipe read
Date: Thu, 11 Jun 2026 09:28:36 +0800
Message-Id: <20260611012837.3032351-2-yangxiuwei@kylinos.cn>
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
X-CM-TRANSID:PigvCgCHMwNIDypqb8GyBg--.27485S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZw1ruryDXw43GF4UCryUWrg_yoW5Wr15pr
	4a9398GrW8AF12ga43trWDZr9Yvw4Iya17GF97Can5ArsrAF9xWrW0gFy8KanxJrZ7t34a
	qFs3tF4j9r1DJ3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UuSoXUUUUU=
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6Qn6i2oqD0nNxQAA3f
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
	TAGGED_FROM(0.00)[bounces-13668-lists,io-uring=lfdr.de];
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
X-Rspamd-Queue-Id: 7DBD866DA3B

Add a test for read -> link timeout -> nop where the read completes
with a short pipe read, the link timeout is naturally disarmed with
-ECANCELED, and the linked nop still completes successfully.

Requires the kernel fix for short pipe read completion.

Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
---
 test/link-timeout.c | 102 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/test/link-timeout.c b/test/link-timeout.c
index 0e91604f..07856ff3 100644
--- a/test/link-timeout.c
+++ b/test/link-timeout.c
@@ -671,6 +671,103 @@ err:
 	return 1;
 }
 
+/*
+ * Test short pipe read that naturally disarms a link timeout
+ */
+static int test_link_timeout_natural_disarm_chain(struct io_uring *ring)
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
+	if (write(fds[1], &byte, 1) != 1) {
+		perror("write");
+		goto err;
+	}
+
+	for (i = 0; i < 3; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			printf("wait completion %d\n", ret);
+			goto err;
+		}
+		switch (cqe->user_data) {
+		case 1:
+			if (cqe->res != 1) {
+				fprintf(stderr, "Read got %d, wanted 1\n", cqe->res);
+				goto err;
+			}
+			break;
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
 static int test_timeout_link_chain1(struct io_uring *ring)
 {
 	struct __kernel_timespec ts;
@@ -1262,6 +1359,11 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_link_timeout_natural_disarm_chain(&ring);
+	if (ret) {
+		printf("test_link_timeout_natural_disarm_chain failed\n");
+		return ret;
+	}
 
 	return T_EXIT_PASS;
 }
-- 
2.25.1


