Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB706E7F91
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 18:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbjDSQZ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 12:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231812AbjDSQZ5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 12:25:57 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B6A2718
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:25:56 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b9f00640eso15034b3a.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 09:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681921556; x=1684513556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pay37e3HWwU6Mn9CRHT9mBgWqRnQQUiumbcx6SUrx+o=;
        b=sjllGtxDUOycL4Hl8+0vNi0OGAGzUD1x85RZmps+ECdCQadVpJDa+oCm/otl/k29Tp
         SI5vtgii6/QQ2jVmo9sgIR+5589r4BGwmmUNxryboAFU1/my0kOMcDpFgaFlumEJ8Ikf
         k9vmqIP6m5Bq9cD3hRBY6wMJH4vvX4tGpASBtif+FIBwhBRAt2iXWz2HAxBTEUdnAVzH
         V7QIuAGaIEVOJBnhDnbYryhcjPaJ8Bj7FlK4SYWSii6VNkHf13GQ29LK19eurxJYWIuL
         oQWCTuXSMxry6Tvk+C6GOPoj7KbaIk6kMexwa7cX4OYCr25pmiKbwwnuukIOd9AhaxMk
         qx3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681921556; x=1684513556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pay37e3HWwU6Mn9CRHT9mBgWqRnQQUiumbcx6SUrx+o=;
        b=KgGRv0VyOYf+ZBT5Pg2eX53FJml5ClgxSiiH3vkYN+2mZhQH3papHvsZP+LkATwOuL
         zoryCKBy7FzmcJMGpQzOIiCd6FlgoYi1KvsvFAO4jQITF9L/M/mv006k95QjBLo9snHx
         Yvt3vb9P5CMHCBIsvToVVDAJwHWyeQ2Nocbjv8xc2aOaQMGkPqZ22fS27CG2ioq9AAIc
         8+3e455xZwTbV7InzvTRnIA+h0l6jJ8FrSiSMaI/4aak6BiJb/rVhDOiMcMVenuON6EJ
         RZk3eEYozMfFtm5X8qJXZBk7xOaPKUUlLyxBr61o1O5I1RtSY/puQWxDA57/0Uu2FaL7
         cKKw==
X-Gm-Message-State: AAQBX9eFrSKGlokyf5WwAs5X4p3yQ3fNlVfqR4A9PpLmO9LT/rlsCU6m
        WNJjF6ySkAOqLnZWOYHcSsykvkZnQFW+lp3XqOU=
X-Google-Smtp-Source: AKy350amlOL+a8MtF1sTY0pbbCdbA8ZRUTvajm9kdNhQRbDWvEeNaQF92/t/nSFpjkZU0TnwHVopvw==
X-Received: by 2002:a05:6a20:7da1:b0:f0:5bb4:9d0e with SMTP id v33-20020a056a207da100b000f05bb49d0emr9227702pzj.6.1681921555614;
        Wed, 19 Apr 2023 09:25:55 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id k19-20020aa790d3000000b0063d2cd02d69sm4531334pfk.54.2023.04.19.09.25.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:25:55 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     luhongfei@vivo.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] io_uring: grow struct io_kiocb 'flags' to a 64-bit value
Date:   Wed, 19 Apr 2023 10:25:47 -0600
Message-Id: <20230419162552.576489-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419162552.576489-1-axboe@kernel.dk>
References: <20230419162552.576489-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UPPERCASE_50_75 autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We've run out of flags at this point, and none of the flags are easily
removable. Bump the flags argument to 64-bit to add room for more.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h | 64 +++++++++++++++++-----------------
 io_uring/filetable.h           |  2 +-
 io_uring/io_uring.c            |  6 ++--
 3 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 1b2a20a42413..84f436cc6509 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -413,68 +413,68 @@ enum {
 
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
 	/* ->extra1 and ->extra2 are initialised */
-	REQ_F_CQE32_INIT	= BIT(REQ_F_CQE32_INIT_BIT),
+	REQ_F_CQE32_INIT	= BIT_ULL(REQ_F_CQE32_INIT_BIT),
 	/* recvmsg special flag, clear EPOLLIN */
-	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
+	REQ_F_CLEAR_POLLIN	= BIT_ULL(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
-	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
+	REQ_F_HASH_LOCKED	= BIT_ULL(REQ_F_HASH_LOCKED_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
@@ -535,7 +535,7 @@ struct io_kiocb {
 	 * and after selection it points to the buffer ID itself.
 	 */
 	u16				buf_index;
-	unsigned int			flags;
+	u64				flags;
 
 	struct io_cqe			cqe;
 
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 351111ff8882..cfa32dcd77a1 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -21,7 +21,7 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset);
 int io_register_file_alloc_range(struct io_ring_ctx *ctx,
 				 struct io_uring_file_index_range __user *arg);
 
-unsigned int io_file_get_flags(struct file *file);
+u64 io_file_get_flags(struct file *file);
 
 static inline void io_file_bitmap_clear(struct io_file_table *table, int bit)
 {
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3bca7a79efda..9568b5e4cf87 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1113,7 +1113,7 @@ __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 
 static inline void io_dismantle_req(struct io_kiocb *req)
 {
-	unsigned int flags = req->flags;
+	u64 flags = req->flags;
 
 	if (unlikely(flags & IO_REQ_CLEAN_FLAGS))
 		io_clean_op(req);
@@ -1797,7 +1797,7 @@ static bool __io_file_supports_nowait(struct file *file, umode_t mode)
  * any file. For now, just ensure that anything potentially problematic is done
  * inline.
  */
-unsigned int io_file_get_flags(struct file *file)
+u64 io_file_get_flags(struct file *file)
 {
 	umode_t mode = file_inode(file)->i_mode;
 	unsigned int res = 0;
@@ -4544,7 +4544,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(SQE_COMMON_FLAGS >= (1 << 8));
 	BUILD_BUG_ON((SQE_VALID_FLAGS | SQE_COMMON_FLAGS) != SQE_VALID_FLAGS);
 
-	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(u64));
 
 	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
 
-- 
2.39.2

