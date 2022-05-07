Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6275651E902
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 19:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235941AbiEGRtU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 13:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446729AbiEGRtS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 13:49:18 -0400
Received: from m15113.mail.126.com (m15113.mail.126.com [220.181.15.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AF26263CA
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 10:45:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=APVbN
        QhOP9OKApoqtEFZDpdTbO1Y7stkIQa0UP0d2dw=; b=idAcTT0sgdSVHi2rx+H4z
        SrThPoiWfjb08iIZ0OtNvHBZwGD81+Wi5xGivLjPOhdE5ZooZo/M3wOXxTh1i12M
        ye55aaw4PyBFBREnZp4NYXS47nKJeZFdRp0ADRzc/zie565Bojf+c1rnztG3y8r/
        NzPhJLthdqz1mB0ulvXVyw=
Received: from localhost.localdomain (unknown [115.197.24.253])
        by smtp3 (Coremail) with SMTP id DcmowADX5p4YqXZiJmdFBQ--.6995S4;
        Sun, 08 May 2022 01:15:05 +0800 (CST)
From:   Hao Xu <haoxu_linux@126.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/4] io_uring: add REQ_F_APOLL_MULTISHOT for requests
Date:   Sun,  8 May 2022 01:15:02 +0800
Message-Id: <20220507171504.151739-3-haoxu_linux@126.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220507171504.151739-1-haoxu_linux@126.com>
References: <20220507171504.151739-1-haoxu_linux@126.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcmowADX5p4YqXZiJmdFBQ--.6995S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7Kr1xWr4DGw4xXFyUWF4kZwb_yoW8GrWfpr
        13C3yvkwnxCa4DG3WIyFsxZrW5ZFs8Jw4Dtr429w4FgFsFvw1qk34jy3WDJryrAr4UCrWj
        vrZFvFnxCFZ8GaUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jL6pQUUUUU=
X-Originating-IP: [115.197.24.253]
X-CM-SenderInfo: xkdr53xbol03b06rjloofrz/1tbiOxn5V1pEGBBIPgAAss
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a flag to indicate multishot mode for fast poll. currently only
accept use it, but there may be more operations leveraging it in the
future. Also add a mask IO_APOLL_MULTI_POLLED which stands for
REQ_F_APOLL_MULTI | REQ_F_POLLED, to make the code short and cleaner.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b6d491c9a25f..c2ee184ac693 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -116,6 +116,8 @@
 #define IO_REQ_CLEAN_SLOW_FLAGS (REQ_F_REFCOUNT | REQ_F_LINK | REQ_F_HARDLINK |\
 				 IO_REQ_CLEAN_FLAGS)
 
+#define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
+
 #define IO_TCTX_REFS_CACHE_NR	(1U << 10)
 
 struct io_uring {
@@ -810,6 +812,7 @@ enum {
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_PARTIAL_IO_BIT,
+	REQ_F_APOLL_MULTISHOT_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -874,6 +877,8 @@ enum {
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
 	/* request has already done partial IO */
 	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
+	/* fast poll multishot mode */
+	REQ_F_APOLL_MULTISHOT	= BIT(REQ_F_APOLL_MULTISHOT_BIT),
 };
 
 struct async_poll {
-- 
2.25.1

