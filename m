Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1B66C7F37
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 14:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbjCXN7S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 09:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjCXN7R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 09:59:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A7F1D310
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 06:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679666309;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PDsglB1VronX+vyTurKZAVkq744xdNdCqr4KsItiReA=;
        b=cbo8PjOYfvFEO88E2nW4wxxyBgoAimteSzLslJQ/RKM4AXNRXUfiXkK9olVM78GZXf/zIy
        33CoLrtyJb0GCk23NmjmT0HuAGSlSKZy2oFFAJdfbU3zaoUXKDJpE65nkDgUT8V0xPN87r
        ZCx+JuVASootvdnMvNJR4EerPfPgFUQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-qLJy3HcJPuqL9nybjRBXyQ-1; Fri, 24 Mar 2023 09:58:25 -0400
X-MC-Unique: qLJy3HcJPuqL9nybjRBXyQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87DE880C8C4;
        Fri, 24 Mar 2023 13:58:24 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9996D140EBF4;
        Fri, 24 Mar 2023 13:58:23 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 01/17] io_uring: increase io_kiocb->flags into 64bit
Date:   Fri, 24 Mar 2023 21:57:52 +0800
Message-Id: <20230324135808.855245-2-ming.lei@redhat.com>
In-Reply-To: <20230324135808.855245-1-ming.lei@redhat.com>
References: <20230324135808.855245-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=0.6 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,UPPERCASE_50_75 autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The 32bit io_kiocb->flags has been used up, so extend it to 64bit.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring_types.h | 65 +++++++++++++++++-----------------
 io_uring/io_uring.c            |  2 +-
 2 files changed, 34 insertions(+), 33 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3d152bdcd30a..aab657cd2b77 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -409,68 +409,68 @@ enum {
 
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
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
@@ -531,7 +531,8 @@ struct io_kiocb {
 	 * and after selection it points to the buffer ID itself.
 	 */
 	u16				buf_index;
-	unsigned int			flags;
+	u32				__pad;
+	u64				flags;
 
 	struct io_cqe			cqe;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 24be4992821b..449508912a9c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4486,7 +4486,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_ON(SQE_COMMON_FLAGS >= (1 << 8));
 	BUILD_BUG_ON((SQE_VALID_FLAGS | SQE_COMMON_FLAGS) != SQE_VALID_FLAGS);
 
-	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(int));
+	BUILD_BUG_ON(__REQ_F_LAST_BIT > 8 * sizeof(u64));
 
 	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
 
-- 
2.39.2

