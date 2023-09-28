Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92ECE7B1CC8
	for <lists+io-uring@lfdr.de>; Thu, 28 Sep 2023 14:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231752AbjI1Moe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 28 Sep 2023 08:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjI1Moc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 28 Sep 2023 08:44:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D6419D
        for <io-uring@vger.kernel.org>; Thu, 28 Sep 2023 05:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695905025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DfLlvPH45HtA+ABsFEkKa0PbHb5o88ZJzs3bc5tDHII=;
        b=PDYpuq2UbXV6OAteHqc8Vs56NMNI4WYAh2L4eJb6v/OolQgsXZ59ha7ysOCciGXgW2Li8G
        0tDJrxpbrL6LpGxcDVwpJL3Bi+aVQ5BpYhR6QecMud0ago+6ePQL7tZjI/dGPEIaUT3pMU
        qDkeNW70Az2Tq3YzUcp6pgeKKK0jKc0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-399-NZS41LVtMWivMpwHQNdnpw-1; Thu, 28 Sep 2023 08:43:40 -0400
X-MC-Unique: NZS41LVtMWivMpwHQNdnpw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B5F3811E7B;
        Thu, 28 Sep 2023 12:43:39 +0000 (UTC)
Received: from localhost (unknown [10.72.120.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6B8B40C2070;
        Thu, 28 Sep 2023 12:43:38 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Gabriel Krisman Bertazi <krisman@suse.de>,
        Anuj Gupta <anuj20.g@samsung.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 1/2] io_uring: retain top 8bits of uring_cmd flags for kernel internal use
Date:   Thu, 28 Sep 2023 20:43:24 +0800
Message-ID: <20230928124327.135679-2-ming.lei@redhat.com>
In-Reply-To: <20230928124327.135679-1-ming.lei@redhat.com>
References: <20230928124327.135679-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Retain top 8bits of uring_cmd flags for kernel internal use, so that we
can move IORING_URING_CMD_POLLED out of uapi header.

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
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

