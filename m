Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30DB0610052
	for <lists+io-uring@lfdr.de>; Thu, 27 Oct 2022 20:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233965AbiJ0SfN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 Oct 2022 14:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235323AbiJ0SfM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 Oct 2022 14:35:12 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD75524F01
        for <io-uring@vger.kernel.org>; Thu, 27 Oct 2022 11:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=br0bDi+/IAAefWEegku2/cAhQOooQZTfrLKX47KKbMI=; b=RBOYkqWU3+04m6nuSWKGHnNTbT
        teZUbdiKNTsoeWF0wGpX2wMVlH4MNzBCw+n2WSqhDWLzPM9rZcrEPNfsiWH+3EdJ7uupkleha3l15
        x+KasmuCQyn3IiWAaoilym/HBFrueeMH4p7MY8PP75qMoFO+WQ1ZyUdAMpJ33wtXHcj7lv2/K74xZ
        Pekr0PYtSvbEyFQ6vOo/0//nAkqntonPxWCburpAoPZa0pB9tu6ZOxsKrwIcTmXtTTNrAWtNVEQhV
        7r03I6yWO8Y9XGnmcEdiguAPmDZ7MpXApuN4yPYnYgQRyoSv9C2KxHQ5aEOCIz3l/CDbtGeeQMG6X
        DhpfD2b1UKHuy6CN/WUQVp/pBgHtkope7CO3qfaQKvCAuFDhWPly0WcibSVwlzLsy7ZkNWXjENVsR
        Oki6CWm9+fk1Wkmxjau9199i6cLtH3sR/+ljCu0sq6aAOcQLSVdCRtltXu1RHiWeMwh91Q9mnpnc8
        XbC/u4ichF0kj3NgyX9q1SH0;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oo7ic-0064Wg-1Z; Thu, 27 Oct 2022 18:35:06 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/1] io_uring/net: introduce IORING_SEND_ZC_REPORT_USAGE flag
Date:   Thu, 27 Oct 2022 20:34:45 +0200
Message-Id: <8945b01756d902f5d5b0667f20b957ad3f742e5e.1666895626.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1666895626.git.metze@samba.org>
References: <cover.1666895626.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It might be useful for applications to detect if a zero copy
transfer with SEND[MSG]_ZC was actually possible or not.
The application can fallback to plain SEND[MSG] in order
to avoid the overhead of two cqes per request.
Or it can generate a log message that could indicate
to an administrator that no zero copy was possible
and could explain degraded performance.

Link: https://lore.kernel.org/io-uring/fb6a7599-8a9b-15e5-9b64-6cd9d01c6ff4@gmail.com/T/#m2b0d9df94ce43b0e69e6c089bdff0ce6babbdfaa
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 include/uapi/linux/io_uring.h | 18 ++++++++++++++++++
 io_uring/net.c                |  6 +++++-
 io_uring/notif.c              | 12 ++++++++++++
 io_uring/notif.h              |  3 +++
 4 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ab7458033ee3..423f98781a20 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -296,10 +296,28 @@ enum io_uring_op {
  *
  * IORING_RECVSEND_FIXED_BUF	Use registered buffers, the index is stored in
  *				the buf_index field.
+ *
+ * IORING_SEND_ZC_REPORT_USAGE
+ *				If set, SEND[MSG]_ZC should report
+ *				the zerocopy usage in cqe.res
+ *				for the IORING_CQE_F_NOTIF cqe.
+ *				0 is reported if zerocopy was actually possible.
+ *				IORING_NOTIF_USAGE_ZC_COPIED if data was copied
+ *				(at least partially).
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
+#define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
+
+/*
+ * cqe.res for IORING_CQE_F_NOTIF if
+ * IORING_SEND_ZC_REPORT_USAGE was requested
+ *
+ * It should be treated as a flag, all other
+ * bits of cqe.res should be treated as reserved!
+ */
+#define IORING_NOTIF_USAGE_ZC_COPIED    (1U << 31)
 
 /*
  * accept flags stored in sqe->ioprio
diff --git a/io_uring/net.c b/io_uring/net.c
index 15dea91625e2..0a8cdc5ae7af 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -939,7 +939,8 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	zc->flags = READ_ONCE(sqe->ioprio);
 	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
-			  IORING_RECVSEND_FIXED_BUF))
+			  IORING_RECVSEND_FIXED_BUF |
+			  IORING_SEND_ZC_REPORT_USAGE))
 		return -EINVAL;
 	notif = zc->notif = io_alloc_notif(ctx);
 	if (!notif)
@@ -957,6 +958,9 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->imu = READ_ONCE(ctx->user_bufs[idx]);
 		io_req_set_rsrc_node(notif, ctx, 0);
 	}
+	if (zc->flags & IORING_SEND_ZC_REPORT_USAGE) {
+		io_notif_to_data(notif)->zc_report = true;
+	}
 
 	if (req->opcode == IORING_OP_SEND_ZC) {
 		if (READ_ONCE(sqe->__pad3[0]))
diff --git a/io_uring/notif.c b/io_uring/notif.c
index e37c6569d82e..4bfef10161fa 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -18,6 +18,10 @@ static void __io_notif_complete_tw(struct io_kiocb *notif, bool *locked)
 		__io_unaccount_mem(ctx->user, nd->account_pages);
 		nd->account_pages = 0;
 	}
+
+	if (nd->zc_report && (nd->zc_copied || !nd->zc_used))
+		notif->cqe.res |= IORING_NOTIF_USAGE_ZC_COPIED;
+
 	io_req_task_complete(notif, locked);
 }
 
@@ -28,6 +32,13 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 	struct io_notif_data *nd = container_of(uarg, struct io_notif_data, uarg);
 	struct io_kiocb *notif = cmd_to_io_kiocb(nd);
 
+	if (nd->zc_report) {
+		if (success && !nd->zc_used && skb)
+			WRITE_ONCE(nd->zc_used, true);
+		else if (!success && !nd->zc_copied)
+			WRITE_ONCE(nd->zc_copied, true);
+	}
+
 	if (refcount_dec_and_test(&uarg->refcnt)) {
 		notif->io_task_work.func = __io_notif_complete_tw;
 		io_req_task_work_add(notif);
@@ -55,6 +66,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	nd->account_pages = 0;
 	nd->uarg.flags = SKBFL_ZEROCOPY_FRAG | SKBFL_DONT_ORPHAN;
 	nd->uarg.callback = io_uring_tx_zerocopy_callback;
+	nd->zc_report = nd->zc_used = nd->zc_copied = false;
 	refcount_set(&nd->uarg.refcnt, 1);
 	return notif;
 }
diff --git a/io_uring/notif.h b/io_uring/notif.h
index 5b4d710c8ca5..4ae696273c78 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -13,6 +13,9 @@ struct io_notif_data {
 	struct file		*file;
 	struct ubuf_info	uarg;
 	unsigned long		account_pages;
+	bool			zc_report;
+	bool			zc_used;
+	bool			zc_copied;
 };
 
 void io_notif_flush(struct io_kiocb *notif);
-- 
2.34.1

