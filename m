Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79BCF51E900
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 19:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244465AbiEGRtS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 13:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235941AbiEGRtP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 13:49:15 -0400
X-Greylist: delayed 1813 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 07 May 2022 10:45:26 PDT
Received: from m15113.mail.126.com (m15113.mail.126.com [220.181.15.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C54FB1085
        for <io-uring@vger.kernel.org>; Sat,  7 May 2022 10:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=CTmfe
        QYmoKpOzmPx2QTFs47NY5SS0xt187uvNKmpg+c=; b=KQZZm/pLqicHdA/wpANhU
        wfmunP86DuHRvhFaq7iIrvwaXNVnKbUVihkZrhOi9B5Mui3RXdSFeqBzNnPsaL32
        KwvbJzzBAl4+TmNhPczIe0U6Qpi9GykJ/mbZTeQPwYGeNARLRc+M0lyC9O+doBvB
        PgNvxjoHCKe5R5268kGb+0=
Received: from localhost.localdomain (unknown [115.197.24.253])
        by smtp3 (Coremail) with SMTP id DcmowADX5p4YqXZiJmdFBQ--.6995S3;
        Sun, 08 May 2022 01:15:05 +0800 (CST)
From:   Hao Xu <haoxu_linux@126.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 1/4] io_uring: add IORING_ACCEPT_MULTISHOT for accept
Date:   Sun,  8 May 2022 01:15:01 +0800
Message-Id: <20220507171504.151739-2-haoxu_linux@126.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220507171504.151739-1-haoxu_linux@126.com>
References: <20220507171504.151739-1-haoxu_linux@126.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DcmowADX5p4YqXZiJmdFBQ--.6995S3
X-Coremail-Antispam: 1Uf129KBjvdXoW7Jr47uw43Ww13Zr4UAw1DWrg_yoWxtwc_X3
        97Jr18ur4xZr1xuw4vkF1kXryagw48CryUWr1fKr18JF9rAr43G3s7AFnrtrsIga1UGryf
        ZFs09w1Sg3WaqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUn3UU5UUUUU==
X-Originating-IP: [115.197.24.253]
X-CM-SenderInfo: xkdr53xbol03b06rjloofrz/1tbiehn5V1pEFT8nEgAAsM
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

add an accept_flag IORING_ACCEPT_MULTISHOT for accept, which is to
support multishot.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/uapi/linux/io_uring.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 06621a278cb6..7c3d70d12428 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -223,6 +223,11 @@ enum {
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 
+/*
+ * accept flags stored in sqe->ioprio
+ */
+#define IORING_ACCEPT_MULTISHOT	(1U << 0)
+
 /*
  * IO completion data structure (Completion Queue Entry)
  */
-- 
2.25.1

