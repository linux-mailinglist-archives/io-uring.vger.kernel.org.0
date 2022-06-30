Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16A86561DDC
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 16:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbiF3O1u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 10:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237219AbiF3O1b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 10:27:31 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D8C7B35E
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:10:58 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id e28so22350191wra.0
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 07:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iv9sCq1Dh8AT+NVbMp9Aj2CUQWJDfbOKsX2SJqvDIl4=;
        b=dE9k0pS6IjzW/AVEDtl7LNSTBZuH+yN+gnl3bITkD1RVNHoSUeCgF5FDjwa5RulgQE
         /ZQoiE+9M05QacQSxF/W7zvMbcXP10EkUROqQ7keafWFTJyCdOOMA85xx0k0TYvn9oF8
         sccMflHhfMSoxb2IWzqFyAVI0rHYxkMrtIWs4hy3NBxoeEAf2fT8RK06rOus4Qxc/v2U
         VmqeNNMQViiZA1gYsE4ozyIguAroSW4fSVxqN+RIy9YS22MJ7+EjDEtOxLDCmv74T8vZ
         OgrVeWylsdzTJ4eN4hdB/TuuHpi7uBwdFrmihsoLatKVm2lqV/zkXGnEhUC6VH9goZA3
         y/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iv9sCq1Dh8AT+NVbMp9Aj2CUQWJDfbOKsX2SJqvDIl4=;
        b=SpbYG87oE0ozbIWuwft3iFQmEMfhQ1osTKRHEbe4WxgDL/pAL2gKSNRCNwnHFpSYRe
         L9kK2qXjGiIN06bb/xp99EgQ1lIA/ve39iWMVfnTC5IuEMEIjpoFIcSmtaYE/a4ODWFH
         vcWdioCQ6f4kTLMDA+nW/2wm+l0IPCXFa7Tpfl68aTQeNAwY7hoQfoCruPvbqx/5E/J6
         Lv+0RX1azy5+uy8ROhkKre50cL0twFAX2BUr5AVA/dcTFk+4vXhO9ABHA+lsoo85mB79
         CZj82e3dmHtCwt+YqLosg5DiIiWXdaadsfJSKaIJIhdrrrZdw3dcsASS5O15FvX/G5DC
         Lxnw==
X-Gm-Message-State: AJIora8h/uujNcIbA+hH4y631ahwJRcwObp8dHGXZ1/W0xLN7NVhQkak
        7mwCdOLdy+Jwm/O+44VugJ0zm9Uk7RIdiQ==
X-Google-Smtp-Source: AGRyM1u2Ww9dxK7CycMWG+T8SuS+t/QgBZoZyYnuEMZS2Mu6KAmWQh+kBcTJTJeqgjiW7N+oR6QF3g==
X-Received: by 2002:a05:6000:10c4:b0:21b:8ea4:a27a with SMTP id b4-20020a05600010c400b0021b8ea4a27amr8642291wrx.575.1656598238918;
        Thu, 30 Jun 2022 07:10:38 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-232-9.dab.02.net. [82.132.232.9])
        by smtp.gmail.com with ESMTPSA id ay29-20020a05600c1e1d00b003a03be171b1sm3741392wmb.43.2022.06.30.07.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 07:10:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 2/5] alloc range helpers
Date:   Thu, 30 Jun 2022 15:10:14 +0100
Message-Id: <fc7d5dec683c2f989f2bf33906b22d820b4d175e.1656597976.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656597976.git.asml.silence@gmail.com>
References: <cover.1656597976.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 src/include/liburing.h |  3 +++
 src/liburing.map       |  1 +
 src/register.c         | 14 ++++++++++++++
 3 files changed, 18 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index bb2fb87..45b4da0 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -186,6 +186,9 @@ int io_uring_unregister_buf_ring(struct io_uring *ring, int bgid);
 int io_uring_register_sync_cancel(struct io_uring *ring,
 				 struct io_uring_sync_cancel_reg *reg);
 
+int io_uring_register_file_alloc_range(struct io_uring *ring,
+					unsigned off, unsigned len);
+
 /*
  * Helper for the peek/wait single cqe functions. Exported because of that,
  * but probably shouldn't be used directly in an application.
diff --git a/src/liburing.map b/src/liburing.map
index a487865..318d3d7 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -59,4 +59,5 @@ LIBURING_2.2 {
 LIBURING_2.3 {
 	global:
 		io_uring_register_sync_cancel;
+		io_uring_register_file_alloc_range;
 } LIBURING_2.2;
diff --git a/src/register.c b/src/register.c
index f2b1026..ee370d6 100644
--- a/src/register.c
+++ b/src/register.c
@@ -352,3 +352,17 @@ int io_uring_register_sync_cancel(struct io_uring *ring,
 	return ____sys_io_uring_register(ring->ring_fd,
 					 IORING_REGISTER_SYNC_CANCEL, reg, 1);
 }
+
+int io_uring_register_file_alloc_range(struct io_uring *ring,
+					unsigned off, unsigned len)
+{
+	struct io_uring_file_index_range range;
+
+	memset(&range, 0, sizeof(range));
+	range.off = off;
+	range.len = len;
+
+	return ____sys_io_uring_register(ring->ring_fd,
+					 IORING_REGISTER_FILE_ALLOC_RANGE,
+					 &range, 0);
+}
-- 
2.36.1

