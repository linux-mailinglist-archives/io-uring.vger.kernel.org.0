Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F92C7BABE8
	for <lists+io-uring@lfdr.de>; Thu,  5 Oct 2023 23:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjJEVZC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Oct 2023 17:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbjJEVZB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Oct 2023 17:25:01 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2DFF1
        for <io-uring@vger.kernel.org>; Thu,  5 Oct 2023 14:24:58 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 70CAB1F38D;
        Thu,  5 Oct 2023 21:24:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696541096; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=DRTG2rpkgLUKQnzakW1/FY87hpkIAsONBCguCNDmUfw=;
        b=z86euCXIpJAVJgD0LZAbrz8sgkEJRQ3Bso8g02CuIANtsUggAzhzNm7L7eK4EJ/R9UIUAp
        hK0NopaIWLrfm/ZGFWx0JFto/YzcmvwWJfPyQaFpONWrJnwL+mJi/dfhz+tU3COsS86LDK
        Dszb8RbNEPYeKRWcpoiJ1V7QPM7Isuc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696541096;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=DRTG2rpkgLUKQnzakW1/FY87hpkIAsONBCguCNDmUfw=;
        b=+MkIRZlwbKxE0yTWF6sv1paUitm8G5/AemCoQHbFvxBXcf4U3JmpvJmRyYS2vN48nkhfBE
        L0RYipNLaWZ23qCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 394FA139C2;
        Thu,  5 Oct 2023 21:24:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GwZCCKgpH2XVegAAMHmgww
        (envelope-from <krisman@suse.de>); Thu, 05 Oct 2023 21:24:56 +0000
From:   Gabriel Krisman Bertazi <krisman@suse.de>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Gabriel Krisman Bertazi <krisman@suse.de>
Subject: [PATCH liburing] tests: Add test for bid limits of provided_buffer commands
Date:   Thu,  5 Oct 2023 17:24:25 -0400
Message-ID: <20231005212425.3059-1-krisman@suse.de>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

A couple of tests for bid limits when allocating/freeing
buffers with provide_buffers command.

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 test/Makefile          |   1 +
 test/provide-buffers.c | 132 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 133 insertions(+)
 create mode 100644 test/provide-buffers.c

diff --git a/test/Makefile b/test/Makefile
index f16cedc..60ca45f 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -138,6 +138,7 @@ test_srcs := \
 	poll-v-poll.c \
 	pollfree.c \
 	probe.c \
+	provide-buffers.c \
 	read-before-exit.c \
 	read-write.c \
 	recv-msgall.c \
diff --git a/test/provide-buffers.c b/test/provide-buffers.c
new file mode 100644
index 0000000..62fd8d8
--- /dev/null
+++ b/test/provide-buffers.c
@@ -0,0 +1,132 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test BID checks for provide buffers command.
+ */
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <limits.h>
+#include <sys/mman.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+/* BID id address space is 16 bits. */
+#define MAX_BID_NR (1<<16)
+
+int test_bid_space_limits()
+{
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	void * buf;
+	int buf_len;
+	int ret;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret < 0) {
+		fprintf(stderr, "queue_init: %s\n", strerror(-ret));
+		return 1;
+	}
+
+	/*
+	 * Individual buffer size (buf_len) is irrelevant for this
+	 * test. As long as the full size can be mapped and io_uring
+	 * likes it. sizeof(int) is always safe.
+	 */
+	buf_len = sizeof(int);
+	buf = mmap(NULL, MAX_BID_NR*buf_len, PROT_READ|PROT_WRITE,
+		   MAP_PRIVATE|MAP_ANON, -1, 0);
+	if (buf == MAP_FAILED) {
+		fprintf(stderr, "mmap failed\n");
+		return 1;
+	}
+
+	/* allocate/free the last tag possible for a given bid. */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_provide_buffers(sqe, buf, buf_len, 1, 0, USHRT_MAX);
+	io_uring_submit(&ring);
+	io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe %d\n", ret);
+		return 1;
+	} else if (cqe->res != 0) {
+		fprintf(stderr, "Failed to register buffer with tag USHRT_MAX. (res = %d)\n",
+			cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_remove_buffers(sqe, 1, 0);
+	io_uring_submit(&ring);
+	io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe %d\n", ret);
+		return 1;
+	} else if (cqe->res != 1) {
+		fprintf(stderr, "Failed to remove buffer with tag USHRT_MAX. (res = %d)\n",
+			cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* Wrapping the bid counter could be valid but is confusing, thus it is disabled. */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_provide_buffers(sqe, buf, buf_len, 2, 0, USHRT_MAX);
+	io_uring_submit(&ring);
+	io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe %d\n", ret);
+		return 1;
+	} else if (cqe->res == 0) {
+		fprintf(stderr, "Shouldn't have succeded to register the BID counter.\n");
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* Allocate and free the full address space */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_provide_buffers(sqe, buf, buf_len, MAX_BID_NR, 0, 0);
+	io_uring_submit(&ring);
+	io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe %d\n", ret);
+		return 1;
+	} else if (cqe->res != 0) {
+		fprintf(stderr, "Failed to register 65536 buffers. (res = %d)\n",
+			cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_remove_buffers(sqe, MAX_BID_NR, 0);
+	io_uring_submit(&ring);
+	io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe %d\n", ret);
+		return 1;
+	} else if (cqe->res != MAX_BID_NR) {
+		fprintf(stderr, "Failed to remove 65536 buffers.\n");
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_queue_exit(&ring);
+
+	return 0;
+}
+
+int main (int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret = test_bid_space_limits();
+	if (ret)
+		return T_EXIT_FAIL;
+	return T_EXIT_PASS;
+}
-- 
2.42.0

