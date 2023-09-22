Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30FA27AB59D
	for <lists+io-uring@lfdr.de>; Fri, 22 Sep 2023 18:11:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjIVQLx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Sep 2023 12:11:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232140AbjIVQLv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Sep 2023 12:11:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A7D99
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 09:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695399057;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=od1mr+TbfZ9kgpeg8F1L9x1V0zrtt9NqVUngA0b92C0=;
        b=KczT5sPsF30cyUd5Fhb05ZDdvTLF/HJcZtexANOcnY0u1akpdEtVOkPQTafXAe4Y5XTiHz
        owPIb2/ms5IuN5GQK3VxnszvJd+gCtZ7lR+9XGEC+alGjy1tn9cT5cuQuxPXCnJ66PKIXK
        tu2TXbJK6EdbxRyhjxzC1iSiBJrpwfo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-628-Hs31LXcHPa6XnIH7wFXn7g-1; Fri, 22 Sep 2023 12:10:54 -0400
X-MC-Unique: Hs31LXcHPa6XnIH7wFXn7g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 006FF185A790;
        Fri, 22 Sep 2023 16:10:54 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2CC6E711282;
        Fri, 22 Sep 2023 16:10:52 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 1/2] io_uring: retain top 8bits of uring_cmd flags for kernel internal use
Date:   Sat, 23 Sep 2023 00:09:40 +0800
Message-ID: <20230922160943.2793779-2-ming.lei@redhat.com>
In-Reply-To: <20230922160943.2793779-1-ming.lei@redhat.com>
References: <20230922160943.2793779-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Retain top 8bits of uring_cmd flags for kernel internal use, so that we
can move IORING_URING_CMD_POLLED out of uapi header.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring.h      | 3 +++
 include/uapi/linux/io_uring.h | 5 ++---
 io_uring/uring_cmd.c          | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 106cdc55ff3b..ae08d6f66e62 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -22,6 +22,9 @@ enum io_uring_cmd_flags {
 	IO_URING_F_IOPOLL		= (1 << 10),
 };
 
+/* only top 8 bits of sqe->uring_cmd_flags for kernel internal use */
+#define IORING_URING_CMD_POLLED		(1U << 31)
+
 struct io_uring_cmd {
 	struct file	*file;
 	const struct io_uring_sqe *sqe;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 8e61f8b7c2ce..4df2f11f264f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -246,13 +246,12 @@ enum io_uring_op {
 };
 
 /*
- * sqe->uring_cmd_flags
+ * sqe->uring_cmd_flags		top 8bits aren't available for userspace
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
- * IORING_URING_CMD_POLLED	driver use only
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)
-#define IORING_URING_CMD_POLLED	(1U << 31)
+#define IORING_URING_CMD_MASK	0x00ffffffU
 
 
 /*
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 537795fddc87..52a455b67163 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -90,7 +90,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (sqe->__pad1)
 		return -EINVAL;
 
-	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
+	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags) & IORING_URING_CMD_MASK;
 	if (ioucmd->flags & ~IORING_URING_CMD_FIXED)
 		return -EINVAL;
 
-- 
2.41.0

