Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B327B590D6F
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 10:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiHLIfH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 04:35:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236197AbiHLIfG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 04:35:06 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37AEDA5C56
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 01:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=Wiv8VdAbG7iP9BnJPv4+YCUL3Mbo2bTkF0cP44h2fsM=; b=kxffGrZ4eSWFLumidhkiDph/uy
        N4MMZy0IrBMpI8wNcMwCoWiLf3pxwAQjDGCAe0cw7mdewX8VhvGF3pBBJC5iE9iYkQbGGFRckHNgQ
        eIxu9GB8HP5oFIxRO7rGZD/sMK3/+4pliqxaL8WVW+JN6IHllBLvsmxmexwLaw+Fz87QAb1hqweq3
        WN9+y76ySz9Bq/n6/inzfYHw1Te+rB7gk1RvN8JuCzmGxf5LhZS41m0EGRiBnpisIHiC4AqdVnvHe
        RtR00J+mZyF2uaMTQg51tjwwX2CrIrSR6d7w12NcCgR/t99fcCZBtFG6VcSz+JdemyIS2yy9WIbfq
        WalxQmbNwKKZXSyanNvEiE07GjrWVxn91KoqIs0Lyml5lKMo3EJdRRmLSnASUpJvpyugfSh6f7RKA
        GvO/xop2j8D9HViQPa83N5D8puFOKCta64SsLCE6h7azh5v4ivPf6SaiQKwaA6qmMMpHtsH1dLWmX
        m0ylqywMvAf/oes9BtMIXKRh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oMQ8E-009JbT-Lr; Fri, 12 Aug 2022 08:35:02 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [RFC PATCH 3/8] io_uring: check legacy layout of struct io_uring_sqe with BUILD_BUG_SQE_LEGACY*
Date:   Fri, 12 Aug 2022 10:34:27 +0200
Message-Id: <f8fbaaff66246111ec0469ecb6da5d833d3af618.1660291547.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1660291547.git.metze@samba.org>
References: <cover.1660291547.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This makes the next changes easier.

Signed-off-by: Stefan Metzmacher <metze@samba.org>
---
 io_uring/io_uring.c | 88 +++++++++++++++++++++++----------------------
 1 file changed, 46 insertions(+), 42 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 427dde7dfbd1..60426265ee9f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3908,6 +3908,10 @@ static int __init io_uring_init(void)
 #define BUILD_BUG_SQE_ALIAS(eoffset, etype, ename, aname) \
 	__BUILD_BUG_VERIFY_ALIAS(struct io_uring_sqe, eoffset, sizeof(etype), ename, aname)
 
+#define BUILD_BUG_SQE_LEGACY(eoffset, etype, lname) \
+	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe, eoffset, sizeof(etype), lname)
+#define BUILD_BUG_SQE_LEGACY_SIZE(eoffset, esize, lname) \
+	__BUILD_BUG_VERIFY_OFFSET_SIZE(struct io_uring_sqe, eoffset, esize, lname)
 #define BUILD_BUG_SQE_LEGACY_ALIAS(eoffset, etype, ename, lname) \
 	__BUILD_BUG_VERIFY_ALIAS(struct io_uring_sqe, eoffset, sizeof(etype), ename, lname)
 
@@ -3941,48 +3945,48 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(48, __u64,  u64_ofs48);
 	BUILD_BUG_SQE_ELEM(56, __u64,  u64_ofs56);
 	/* Legacy layout */
-	BUILD_BUG_SQE_ELEM(0,  __u8,   opcode);
-	BUILD_BUG_SQE_ELEM(1,  __u8,   flags);
-	BUILD_BUG_SQE_ELEM(2,  __u16,  ioprio);
-	BUILD_BUG_SQE_ELEM(4,  __s32,  fd);
-	BUILD_BUG_SQE_ELEM(8,  __u64,  off);
-	BUILD_BUG_SQE_ELEM(8,  __u64,  addr2);
-	BUILD_BUG_SQE_ELEM(8,  __u32,  cmd_op);
-	BUILD_BUG_SQE_ELEM(12, __u32, __pad1);
-	BUILD_BUG_SQE_ELEM(16, __u64,  addr);
-	BUILD_BUG_SQE_ELEM(16, __u64,  splice_off_in);
-	BUILD_BUG_SQE_ELEM(24, __u32,  len);
-	BUILD_BUG_SQE_ELEM(28,     __kernel_rwf_t, rw_flags);
-	BUILD_BUG_SQE_ELEM(28, /* compat */   int, rw_flags);
-	BUILD_BUG_SQE_ELEM(28, /* compat */ __u32, rw_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  fsync_flags);
-	BUILD_BUG_SQE_ELEM(28, /* compat */ __u16,  poll_events);
-	BUILD_BUG_SQE_ELEM(28, __u32,  poll32_events);
-	BUILD_BUG_SQE_ELEM(28, __u32,  sync_range_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  msg_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  timeout_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  accept_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  cancel_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  open_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  statx_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  fadvise_advice);
-	BUILD_BUG_SQE_ELEM(28, __u32,  splice_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  rename_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  unlink_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  hardlink_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  xattr_flags);
-	BUILD_BUG_SQE_ELEM(28, __u32,  msg_ring_flags);
-	BUILD_BUG_SQE_ELEM(32, __u64,  user_data);
-	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
-	BUILD_BUG_SQE_ELEM(40, __u16,  buf_group);
-	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
-	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
-	BUILD_BUG_SQE_ELEM(44, __u32,  file_index);
-	BUILD_BUG_SQE_ELEM(44, __u16,  notification_idx);
-	BUILD_BUG_SQE_ELEM(46, __u16,  addr_len);
-	BUILD_BUG_SQE_ELEM(48, __u64,  addr3);
-	BUILD_BUG_SQE_ELEM_SIZE(48, 0, cmd);
-	BUILD_BUG_SQE_ELEM(56, __u64,  __pad2);
+	BUILD_BUG_SQE_LEGACY(0,  __u8,   opcode);
+	BUILD_BUG_SQE_LEGACY(1,  __u8,   flags);
+	BUILD_BUG_SQE_LEGACY(2,  __u16,  ioprio);
+	BUILD_BUG_SQE_LEGACY(4,  __s32,  fd);
+	BUILD_BUG_SQE_LEGACY(8,  __u64,  off);
+	BUILD_BUG_SQE_LEGACY(8,  __u64,  addr2);
+	BUILD_BUG_SQE_LEGACY(8,  __u32,  cmd_op);
+	BUILD_BUG_SQE_LEGACY(12, __u32, __pad1);
+	BUILD_BUG_SQE_LEGACY(16, __u64,  addr);
+	BUILD_BUG_SQE_LEGACY(16, __u64,  splice_off_in);
+	BUILD_BUG_SQE_LEGACY(24, __u32,  len);
+	BUILD_BUG_SQE_LEGACY(28,     __kernel_rwf_t, rw_flags);
+	BUILD_BUG_SQE_LEGACY(28, /* compat */   int, rw_flags);
+	BUILD_BUG_SQE_LEGACY(28, /* compat */ __u32, rw_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  fsync_flags);
+	BUILD_BUG_SQE_LEGACY(28, /* compat */ __u16,  poll_events);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  poll32_events);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  sync_range_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  msg_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  timeout_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  accept_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  cancel_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  open_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  statx_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  fadvise_advice);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  splice_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  rename_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  unlink_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  hardlink_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  xattr_flags);
+	BUILD_BUG_SQE_LEGACY(28, __u32,  msg_ring_flags);
+	BUILD_BUG_SQE_LEGACY(32, __u64,  user_data);
+	BUILD_BUG_SQE_LEGACY(40, __u16,  buf_index);
+	BUILD_BUG_SQE_LEGACY(40, __u16,  buf_group);
+	BUILD_BUG_SQE_LEGACY(42, __u16,  personality);
+	BUILD_BUG_SQE_LEGACY(44, __s32,  splice_fd_in);
+	BUILD_BUG_SQE_LEGACY(44, __u32,  file_index);
+	BUILD_BUG_SQE_LEGACY(44, __u16,  notification_idx);
+	BUILD_BUG_SQE_LEGACY(46, __u16,  addr_len);
+	BUILD_BUG_SQE_LEGACY(48, __u64,  addr3);
+	BUILD_BUG_SQE_LEGACY_SIZE(48, 0, cmd);
+	BUILD_BUG_SQE_LEGACY(56, __u64,  __pad2);
 
 	BUILD_BUG_ON(sizeof(struct io_uring_files_update) !=
 		     sizeof(struct io_uring_rsrc_update));
-- 
2.34.1

