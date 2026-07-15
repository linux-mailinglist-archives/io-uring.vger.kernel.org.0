Return-Path: <io-uring+bounces-14017-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id jxOvETgsV2qiGwEAu9opvQ
	(envelope-from <io-uring+bounces-14017-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:44:08 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D4DEC75B2E0
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 08:44:07 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=AhhF6ZJP;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-14017-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="io-uring+bounces-14017-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=lst.de (policy=none);
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 47A9E300CC0E
	for <lists+io-uring@lfdr.de>; Wed, 15 Jul 2026 06:40:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E69FD2F1FDE;
	Wed, 15 Jul 2026 06:40:01 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA06325B088
	for <io-uring@vger.kernel.org>; Wed, 15 Jul 2026 06:39:59 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784097601; cv=none; b=ERBHF24wp45z3+z+7M9023yyPBO/2u8pspwHNaeoiEACIVfg7TRa6U0ZEYMFIMM87Q5ZDhYn26lpHQlO5bd7Asny2GKzeHMt9Htj2BUXVW8qM/Hm9q0JhQCNkWLhNmT8V8VJ91zqikR7gBW9rnUsjROYCWvkYenFuV6Wg1LYduY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784097601; c=relaxed/simple;
	bh=f01o9VSX+207SprA683i1Npyi/Fy5Ph4sSgWbG/+WFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQn7PKabjm/SAyAK462Xw2c7vXzojKbQPbMHFxfUoWhr4zKehJPFXDDaCf4rQEcSVdRwEyVH9VdPCDzZX7UKF6QtA7ldcEXujiigzseK1/MrGcxy47NR8wV2iA9HKPQtxcx6JM68RHgUB1ODYO69hAZsaJemVrXh/0cvqY63Kno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=AhhF6ZJP; arc=none smtp.client-ip=198.137.202.133
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bytv/OQZzQfp3N3NYmHOsmPiqr6VxUZB1pm4lsk0LDA=; b=AhhF6ZJPVSlk+3uun/rnSQFrtX
	dfy2usFL/TC69TJbG7VaiUWlEAhtAc5f8r+5CQq5Dh4H5x93FE5CmYQEFmTAV4H9473FVtSGN3WzF
	fG2e6nPtNf2XJmqA3oaNWsF1Mt+4Z6znxIjYfOe0WIO5cQWFNToWHb3sziBXNjmtj6YeTZfy8Di9X
	oiJxTlxWwZAyqeHrPcYX04pnQgNuI0LTvY0FqzE+vkgUp+8yzrY45n2dmPcsEbw8BJ62D55zMt4YM
	UaCVXi3tXNNnwXIL4nzyFVsfI+4w5oT7DN1d8f5jgjc0P3X4yRSxsolZ0UKSWH13aXKa9lifgBk3t
	xVURxL+A==;
Received: from 2a02-8389-2301-9f00-3397-c9eb-6d8a-9179.cable.dynamic.v6.surfer.at ([2a02:8389:2301:9f00:3397:c9eb:6d8a:9179] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjtHi-0000000DvCq-3Fsi;
	Wed, 15 Jul 2026 06:39:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH 3/5] liburiung: add io_uring_prep_cmd_zone_reset
Date: Wed, 15 Jul 2026 08:39:30 +0200
Message-ID: <20260715063947.2933606-4-hch@lst.de>
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
	TAGGED_FROM(0.00)[bounces-14017-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:axboe@kernel.dk,m:dlemoal@kernel.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
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
X-Rspamd-Queue-Id: D4DEC75B2E0

Add a helper for io_uring zone_reset_all commands.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 configure              | 31 +++++++++++++++++++++++++++++++
 src/include/liburing.h |  7 +++++++
 src/liburing-ffi.map   |  5 +++++
 3 files changed, 43 insertions(+)

diff --git a/configure b/configure
index b953eddd6ddc..8c5ca801f487 100755
--- a/configure
+++ b/configure
@@ -469,6 +469,21 @@ if compile_prog "" "" "discard command"; then
 fi
 print_config "discard command support" "$discard_cmd"
 
+##########################################
+# Check block zone_reset_all cmd support
+zone_reset_all_cmd="no"
+cat > $TMPC << EOF
+#include <linux/blkdev.h>
+int main(void)
+{
+  return BLOCK_URING_CMD_ZONE_RESET_ALL;
+}
+EOF
+if compile_prog "" "" "zone_reset_all command"; then
+  zone_reset_all_cmd="yes"
+fi
+print_config "zone_reset_all command support" "$zone_reset_all_cmd"
+
 ##########################################
 # Check idtype_t support
 has_idtype_t="no"
@@ -797,6 +812,22 @@ else cat >> $compat_h << EOF
 EOF
 fi
 
+if test "$zone_reset_all_cmd" != "yes"; then
+cat >> $compat_h << EOF
+
+#include <linux/ioctl.h>
+
+#ifndef BLOCK_URING_CMD_ZONE_RESET_ALL
+#define BLOCK_URING_CMD_ZONE_RESET_ALL			_IO(0x12, 1)
+#endif
+
+EOF
+else cat >> $compat_h << EOF
+#include <linux/blkdev.h>
+
+EOF
+fi
+
 cat >> $compat_h << EOF
 #endif
 EOF
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 0188937b0de4..214c7778d6a7 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -1685,6 +1685,13 @@ IOURINGINLINE void io_uring_prep_cmd_discard(struct io_uring_sqe *sqe,
 	sqe->addr3 = nbytes;
 }
 
+IOURINGINLINE void io_uring_prep_cmd_zone_reset_all(struct io_uring_sqe *sqe,
+						    int fd)
+	LIBURING_NOEXCEPT
+{
+	io_uring_prep_uring_cmd(sqe, BLOCK_URING_CMD_ZONE_RESET_ALL, fd);
+}
+
 IOURINGINLINE void io_uring_prep_pipe(struct io_uring_sqe *sqe, int *fds,
 				      int pipe_flags)
 {
diff --git a/src/liburing-ffi.map b/src/liburing-ffi.map
index bd7bc64416d3..fc9701b63907 100644
--- a/src/liburing-ffi.map
+++ b/src/liburing-ffi.map
@@ -275,3 +275,8 @@ LIBURING_2.15 {
 		io_uring_register_zcrx_ctrl;
 		io_uring_register_query;
 } LIBURING_2.14;
+
+LIBURING_2.16 {
+	global:
+		io_uring_prep_cmd_zone_reset_all;
+} LIBURING_2.14;
-- 
2.53.0


