Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56DA07ABD51
	for <lists+io-uring@lfdr.de>; Sat, 23 Sep 2023 04:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjIWCwE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Sep 2023 22:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbjIWCwD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Sep 2023 22:52:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69AA91A5
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 19:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695437475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o3O9DSrjOej7YbI2/QtroCcl2kzZ52oGK9nN7toC7eg=;
        b=gAsw0siKVvgyqhkA1OA0JcA4p+kG25wktWVoXR76CGJjGSW3nTOZtzyqXPJmD4D7u+J0Wn
        EMpDTjCAEt+epW0C8bJaWrlBOubuI4OpvjaGHzc9fc7lzNjosevoWykLMXdB0mUMlsy5c1
        OWVN9G/Nch5VXMIMggeJldEd/8GHFNQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-235-FHHvEKmmOCCy8qAKL06Jqw-1; Fri, 22 Sep 2023 22:51:11 -0400
X-MC-Unique: FHHvEKmmOCCy8qAKL06Jqw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BA8E800883;
        Sat, 23 Sep 2023 02:51:11 +0000 (UTC)
Received: from localhost (unknown [10.72.120.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBF1E140E950;
        Sat, 23 Sep 2023 02:51:10 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 1/2] io_uring: retain top 8bits of uring_cmd flags for kernel internal use
Date:   Sat, 23 Sep 2023 10:50:02 +0800
Message-ID: <20230923025006.2830689-2-ming.lei@redhat.com>
In-Reply-To: <20230923025006.2830689-1-ming.lei@redhat.com>
References: <20230923025006.2830689-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
 io_uring/io_uring.c           | 3 +++
 io_uring/uring_cmd.c          | 2 +-
 4 files changed, 9 insertions(+), 4 deletions(-)

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
index 8e61f8b7c2ce..de77ad08b123 100644
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
+#define IORING_URING_CMD_MASK	IORING_URING_CMD_FIXED
 
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 783ed0fff71b..9aedb7202403 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -4666,6 +4666,9 @@ static int __init io_uring_init(void)
 
 	BUILD_BUG_ON(sizeof(atomic_t) != sizeof(u32));
 
+	/* top 8bits are for internal use */
+	BUILD_BUG_ON((IORING_URING_CMD_MASK & 0xff000000) != 0);
+
 	io_uring_optable_init();
 
 	/*
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 537795fddc87..a0b0ec5473bf 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -91,7 +91,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	ioucmd->flags = READ_ONCE(sqe->uring_cmd_flags);
-	if (ioucmd->flags & ~IORING_URING_CMD_FIXED)
+	if (ioucmd->flags & ~IORING_URING_CMD_MASK)
 		return -EINVAL;
 
 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
-- 
2.41.0

