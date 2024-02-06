Return-Path: <io-uring+bounces-532-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B961084B6C0
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 14:44:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DDF1F1C22101
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 13:44:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0090A131E3D;
	Tue,  6 Feb 2024 13:41:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [195.130.137.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B972B13173B
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 13:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.130.137.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707226910; cv=none; b=kUqy6dYf0+ilIJFP0CF5PlhPuhiOYHvwXvX4Jth5cA05DZTj8iOqN2FfVXQbm3WLsCoE4Hi47nMp1kHot8Qr9wbWSd0p7o/MBvWHwp14iiQFMoSr/dlAJQqEUqZeMh5VVmkbd7hLPQnf1lsfSvIoEvkcAg+pFpgOF6SaTE1/1k8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707226910; c=relaxed/simple;
	bh=4wIZ2jTwtVGOUJGF0vRSAy0R6gYVisVKKtOkbt/2Z/U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=sns49NEjnYUKzg2I4+pN19dy5qM4UfMrg5hbkkGlM0ml+Jpf3dGR2OWQuYEqAaZEwI4vWYA0mqiBN0a1v2PKpx57fbNVek/FjGcseAoQ6aIK2CIHwOR3rPigQoUk/ED63TDCuXf1IcAueAqcGh4KmhFx6lyD6ZHqvNXNXhFl9lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be; spf=none smtp.mailfrom=linux-m68k.org; arc=none smtp.client-ip=195.130.137.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=glider.be
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux-m68k.org
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:1289:761a:478e:8420])
	by laurent.telenet-ops.be with bizsmtp
	id jphf2B00C1XjtVL01phfgc; Tue, 06 Feb 2024 14:41:39 +0100
Received: from rox.of.borg ([192.168.97.57])
	by ramsan.of.borg with esmtp (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1rXLhg-00HNlB-Dt;
	Tue, 06 Feb 2024 14:41:39 +0100
Received: from geert by rox.of.borg with local (Exim 4.95)
	(envelope-from <geert@linux-m68k.org>)
	id 1rXLhj-002Hce-1x;
	Tue, 06 Feb 2024 14:41:39 +0100
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH -next] io_uring: switch struct io_kiocb flag definitions to BIT_ULL()
Date: Tue,  6 Feb 2024 14:41:37 +0100
Message-Id: <1960190f37b94276df50d382b9f1488cd6b6e662.1707226862.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When building for 32-bit platforms:

    In file included from include/linux/bits.h:6,
		     from include/linux/bitops.h:6,
		     from include/linux/kernel.h:23,
		     from io_uring/io_uring.c:42:
    include/vdso/bits.h:7:40: warning: left shift count >= width of type [-Wshift-count-overflow]
	7 | #define BIT(nr)                 (UL(1) << (nr))
	  |                                        ^~
    include/linux/io_uring_types.h:538:35: note: in expansion of macro ‘BIT’
      538 |         REQ_F_CAN_POLL          = BIT(REQ_F_CAN_POLL_BIT),
	  |                                   ^~~
    include/vdso/bits.h:7:40: warning: left shift count >= width of type [-Wshift-count-overflow]
	7 | #define BIT(nr)                 (UL(1) << (nr))
	  |                                        ^~
    include/linux/io_uring_types.h:540:35: note: in expansion of macro ‘BIT’
      540 |         REQ_F_CANCEL_SEQ        = BIT(REQ_F_CANCEL_SEQ_BIT),
	  |                                   ^~~

The io_kiocb.flags variable was expanded to 64 bits, but none of the
existing or newly-added flag definitions were updated, causing build
issues on 32-bit platforms, where unsigned long is a 32-bit value.

Fix this by switching all flag definitions from BIT() (32 or 64 bits) to
BIT_ULL() (always 64 bits).

Fixes: e247b2bea90786fb ("io_uring: expand main struct io_kiocb flags to 64-bits")
Fixes: d964e844044278bf ("io_uring: add io_file_can_poll() helper")
Fixes: 3bdfba1b2a1fc23a ("io_uring/cancel: don't default to setting req->work.cancel_seq")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Boot-tested on arm32 and arm64.
---
 include/linux/io_uring_types.h | 66 +++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 33 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 431e099bb2c07682..f99330b177171003 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -472,72 +472,72 @@ enum {
 
 enum {
 	/* ctx owns file */
-	REQ_F_FIXED_FILE	= BIT(REQ_F_FIXED_FILE_BIT),
+	REQ_F_FIXED_FILE	= BIT_ULL(REQ_F_FIXED_FILE_BIT),
 	/* drain existing IO first */
-	REQ_F_IO_DRAIN		= BIT(REQ_F_IO_DRAIN_BIT),
+	REQ_F_IO_DRAIN		= BIT_ULL(REQ_F_IO_DRAIN_BIT),
 	/* linked sqes */
-	REQ_F_LINK		= BIT(REQ_F_LINK_BIT),
+	REQ_F_LINK		= BIT_ULL(REQ_F_LINK_BIT),
 	/* doesn't sever on completion < 0 */
-	REQ_F_HARDLINK		= BIT(REQ_F_HARDLINK_BIT),
+	REQ_F_HARDLINK		= BIT_ULL(REQ_F_HARDLINK_BIT),
 	/* IOSQE_ASYNC */
-	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
+	REQ_F_FORCE_ASYNC	= BIT_ULL(REQ_F_FORCE_ASYNC_BIT),
 	/* IOSQE_BUFFER_SELECT */
-	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
+	REQ_F_BUFFER_SELECT	= BIT_ULL(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
-	REQ_F_CQE_SKIP		= BIT(REQ_F_CQE_SKIP_BIT),
+	REQ_F_CQE_SKIP		= BIT_ULL(REQ_F_CQE_SKIP_BIT),
 
 	/* fail rest of links */
-	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
+	REQ_F_FAIL		= BIT_ULL(REQ_F_FAIL_BIT),
 	/* on inflight list, should be cancelled and waited on exit reliably */
-	REQ_F_INFLIGHT		= BIT(REQ_F_INFLIGHT_BIT),
+	REQ_F_INFLIGHT		= BIT_ULL(REQ_F_INFLIGHT_BIT),
 	/* read/write uses file position */
-	REQ_F_CUR_POS		= BIT(REQ_F_CUR_POS_BIT),
+	REQ_F_CUR_POS		= BIT_ULL(REQ_F_CUR_POS_BIT),
 	/* must not punt to workers */
-	REQ_F_NOWAIT		= BIT(REQ_F_NOWAIT_BIT),
+	REQ_F_NOWAIT		= BIT_ULL(REQ_F_NOWAIT_BIT),
 	/* has or had linked timeout */
-	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
+	REQ_F_LINK_TIMEOUT	= BIT_ULL(REQ_F_LINK_TIMEOUT_BIT),
 	/* needs cleanup */
-	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
+	REQ_F_NEED_CLEANUP	= BIT_ULL(REQ_F_NEED_CLEANUP_BIT),
 	/* already went through poll handler */
-	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
+	REQ_F_POLLED		= BIT_ULL(REQ_F_POLLED_BIT),
 	/* buffer already selected */
-	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
+	REQ_F_BUFFER_SELECTED	= BIT_ULL(REQ_F_BUFFER_SELECTED_BIT),
 	/* buffer selected from ring, needs commit */
-	REQ_F_BUFFER_RING	= BIT(REQ_F_BUFFER_RING_BIT),
+	REQ_F_BUFFER_RING	= BIT_ULL(REQ_F_BUFFER_RING_BIT),
 	/* caller should reissue async */
-	REQ_F_REISSUE		= BIT(REQ_F_REISSUE_BIT),
+	REQ_F_REISSUE		= BIT_ULL(REQ_F_REISSUE_BIT),
 	/* supports async reads/writes */
-	REQ_F_SUPPORT_NOWAIT	= BIT(REQ_F_SUPPORT_NOWAIT_BIT),
+	REQ_F_SUPPORT_NOWAIT	= BIT_ULL(REQ_F_SUPPORT_NOWAIT_BIT),
 	/* regular file */
-	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
+	REQ_F_ISREG		= BIT_ULL(REQ_F_ISREG_BIT),
 	/* has creds assigned */
-	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
+	REQ_F_CREDS		= BIT_ULL(REQ_F_CREDS_BIT),
 	/* skip refcounting if not set */
-	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
+	REQ_F_REFCOUNT		= BIT_ULL(REQ_F_REFCOUNT_BIT),
 	/* there is a linked timeout that has to be armed */
-	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
+	REQ_F_ARM_LTIMEOUT	= BIT_ULL(REQ_F_ARM_LTIMEOUT_BIT),
 	/* ->async_data allocated */
-	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
+	REQ_F_ASYNC_DATA	= BIT_ULL(REQ_F_ASYNC_DATA_BIT),
 	/* don't post CQEs while failing linked requests */
-	REQ_F_SKIP_LINK_CQES	= BIT(REQ_F_SKIP_LINK_CQES_BIT),
+	REQ_F_SKIP_LINK_CQES	= BIT_ULL(REQ_F_SKIP_LINK_CQES_BIT),
 	/* single poll may be active */
-	REQ_F_SINGLE_POLL	= BIT(REQ_F_SINGLE_POLL_BIT),
+	REQ_F_SINGLE_POLL	= BIT_ULL(REQ_F_SINGLE_POLL_BIT),
 	/* double poll may active */
-	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
+	REQ_F_DOUBLE_POLL	= BIT_ULL(REQ_F_DOUBLE_POLL_BIT),
 	/* request has already done partial IO */
-	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
+	REQ_F_PARTIAL_IO	= BIT_ULL(REQ_F_PARTIAL_IO_BIT),
 	/* fast poll multishot mode */
-	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
+	REQ_F_APOLL_MULTISHOT	= BIT_ULL(REQ_F_APOLL_MULTISHOT_BIT),
 	/* recvmsg special flag, clear EPOLLIN */
-	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
+	REQ_F_CLEAR_POLLIN	= BIT_ULL(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
-	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
+	REQ_F_HASH_LOCKED	= BIT_ULL(REQ_F_HASH_LOCKED_BIT),
 	/* don't use lazy poll wake for this request */
-	REQ_F_POLL_NO_LAZY	= BIT(REQ_F_POLL_NO_LAZY_BIT),
+	REQ_F_POLL_NO_LAZY	= BIT_ULL(REQ_F_POLL_NO_LAZY_BIT),
 	/* file is pollable */
-	REQ_F_CAN_POLL		= BIT(REQ_F_CAN_POLL_BIT),
+	REQ_F_CAN_POLL		= BIT_ULL(REQ_F_CAN_POLL_BIT),
 	/* cancel sequence is set and valid */
-	REQ_F_CANCEL_SEQ	= BIT(REQ_F_CANCEL_SEQ_BIT),
+	REQ_F_CANCEL_SEQ	= BIT_ULL(REQ_F_CANCEL_SEQ_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
-- 
2.34.1


