Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6126A5616BC
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 11:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234460AbiF3Jqg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 05:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234410AbiF3Jqe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 05:46:34 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD4642EE1
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:46:32 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id o4so22482929wrh.3
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 02:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ac9hHkO9wt5MHtaeTyp9JsAetFGqQzXkLb9gEatSs7k=;
        b=YBOGIP9KccqF5CLt1UeyX0+U4V/wgszEOEJQh495TmAqjsnOE1b82CAFdFBvPKd7FX
         iIrAspLbsQudfekhU0sUYId5X8Gt5gW3tH4MU7o0hJh/BVzg6dezdTPLavPwwhspXcVv
         /J1GihJ+5bSmhtooKffY2Jsz+BYo8xc+JzC9any89Umf8Sd5raGSGgn+hOsfMorqJe2G
         JeSeIdP1XRewvM15V/Anrrqh49iV8uSQiA9W7xQ+ZrX00KurU9JKZjgZ4AIg2Zs83fTs
         OzwX+HJwNE9R89mCPPGwd26Og3BWPEW9bMq5P/8YqUgAGyDGwPu2XQypk9wDaChIuiox
         P0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ac9hHkO9wt5MHtaeTyp9JsAetFGqQzXkLb9gEatSs7k=;
        b=rOi/Vvm5AXziowHPUqSuQS/eCthIky0+Zc+1tlFYUnhQqZD5IVVTT6WWZRbLUxXRMK
         uTh2OzfXHsqbk7IAT7ms+6mB2QNiHRtGB2eUCXQzHOJr/HXtLUf1TnV/107qHL679zAF
         7Hb9GlY8wGX3lqRIEWu1QxcpAr/YFACsndPkmu1ChOpl2fnnG1uMxbwTWaWKQAWhmPxC
         4NOZI+zmlWKbYdT2BpfiAVAXeeeolqGQPp2XHhtNhKSknOZo0ThOE5JfddkxuMaQtQY3
         nOvZY/tE7ko6fMGneLGYLTTlC5wFmBM3kAZzbBDL1kzCXUKCMtyZMDuFxrv468f15fkm
         7otQ==
X-Gm-Message-State: AJIora90n7Hfw0BS2p7pg/rD/kMn1l+SOG+4m222QlPLeXuZyUvy+5pC
        MgCfmMLXwtgUXFGkjbj/ZCGg4njbn4hQLQ==
X-Google-Smtp-Source: AGRyM1ujseepO0l/YGU975em+aFy3+M6/HXXY0Op7YKzYrYv0/lKro1j2beTIyxzONBmC/+JVYgXwQ==
X-Received: by 2002:a5d:598e:0:b0:21d:3661:25e2 with SMTP id n14-20020a5d598e000000b0021d366125e2mr2806806wri.335.1656582391033;
        Thu, 30 Jun 2022 02:46:31 -0700 (PDT)
Received: from fedora.fritz.box ([2a02:8010:60a0:0:a00:27ff:feb2:6412])
        by smtp.gmail.com with ESMTPSA id a3-20020a056000100300b0021b943a50b3sm19456528wrx.85.2022.06.30.02.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 02:46:30 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     donald.hunter@gmail.com
Subject: [PATCH liburing] fix accept direct with index allocation
Date:   Thu, 30 Jun 2022 10:45:38 +0100
Message-Id: <20220630094538.33329-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When io_uring_prep_accept_direct is called with IORING_FILE_INDEX_ALLOC,
sqe->file_index ends up being set to 0 which disables fixed files.

This patch changes __io_uring_set_target_fixed_file to do the right thing,
in preference to a check in io_uring_prep_accept_direct. I thought this was
the better approach, to clean up the other special cases.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 src/include/liburing.h | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index bb2fb87..da9dd41 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -292,8 +292,13 @@ static inline void io_uring_sqe_set_flags(struct io_uring_sqe *sqe,
 static inline void __io_uring_set_target_fixed_file(struct io_uring_sqe *sqe,
 						    unsigned int file_index)
 {
-	/* 0 means no fixed files, indexes should be encoded as "index + 1" */
-	sqe->file_index = file_index + 1;
+	/*
+	 * 0 means no fixed files, indexes should be encoded as "index + 1"
+	 * but we must leave IORING_FILE_INDEX_ALLOC unchanged
+	 */
+	sqe->file_index = (file_index == IORING_FILE_INDEX_ALLOC
+			   ? IORING_FILE_INDEX_ALLOC
+			   : file_index + 1);
 }
 
 static inline void io_uring_prep_rw(int op, struct io_uring_sqe *sqe, int fd,
@@ -537,7 +542,7 @@ static inline void io_uring_prep_multishot_accept_direct(struct io_uring_sqe *sq
 							 int flags)
 {
 	io_uring_prep_multishot_accept(sqe, fd, addr, addrlen, flags);
-	__io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC - 1);
+	__io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC);
 }
 
 static inline void io_uring_prep_cancel64(struct io_uring_sqe *sqe,
@@ -881,7 +886,7 @@ static inline void io_uring_prep_socket_direct_alloc(struct io_uring_sqe *sqe,
 {
 	io_uring_prep_rw(IORING_OP_SOCKET, sqe, domain, NULL, protocol, type);
 	sqe->rw_flags = flags;
-	__io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC - 1);
+	__io_uring_set_target_fixed_file(sqe, IORING_FILE_INDEX_ALLOC);
 }
 
 /*
-- 
2.36.1

