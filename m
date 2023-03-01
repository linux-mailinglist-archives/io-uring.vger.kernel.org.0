Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B2D6A6DF5
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 15:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbjCAOJX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 09:09:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229922AbjCAOJS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 09:09:18 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB5752CC47
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 06:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677679667;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Si0P7UPG8+bk/24ad9tKnEySBYUSXrBuipOxFX+Z8s=;
        b=G3qjRk4sRWFe1ZYY1zZa4xooKTGIDAb0UBbAGBLaXCbMcXSHxnvKkiK6cYi+2APi4TprMg
        mwcCeS6xfUhqEfJ0QNKJVv8jfS3Wo5yq2K0brqj9+glzGOk+z60esjpQDyGjEesbKf4c7B
        p2yED1AP3R8EQWRrdu+avO94hEI0MW4=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-655-GhigSr4IMZOwm5GZYVENow-1; Wed, 01 Mar 2023 09:07:39 -0500
X-MC-Unique: GhigSr4IMZOwm5GZYVENow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BAE233C10EF2;
        Wed,  1 Mar 2023 14:06:42 +0000 (UTC)
Received: from localhost (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E9C2B1121318;
        Wed,  1 Mar 2023 14:06:41 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 05/12] io_uring: export 'struct io_mapped_buf' for fused cmd buffer
Date:   Wed,  1 Mar 2023 22:06:04 +0800
Message-Id: <20230301140611.163055-6-ming.lei@redhat.com>
In-Reply-To: <20230301140611.163055-1-ming.lei@redhat.com>
References: <20230301140611.163055-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Export 'struct io_mapped_buf' for the coming fused cmd buffer,
which is based on bvec too.

This instance is supposed to be immutable in its whole lifetime.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 include/linux/io_uring.h | 19 +++++++++++++++++++
 io_uring/rsrc.h          |  9 ---------
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 934e5dd4ccc0..88205ea566d3 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -4,6 +4,7 @@
 
 #include <linux/sched.h>
 #include <linux/xarray.h>
+#include <linux/bvec.h>
 #include <uapi/linux/io_uring.h>
 
 enum io_uring_cmd_flags {
@@ -36,6 +37,24 @@ struct io_uring_cmd {
 	u8		pdu[32]; /* available inline for free use */
 };
 
+/* The mapper buffer is supposed to be immutable */
+struct io_mapped_buf {
+	u64		buf;
+	u64		buf_end;
+	unsigned int	nr_bvecs;
+	union {
+		unsigned int	acct_pages;
+
+		/*
+		 * offset into the bvecs, use for external user; with
+		 * 'offset', immutable bvecs can be provided for io_uring
+		 */
+		unsigned int	offset;
+	};
+	struct bio_vec	*bvec;
+	struct bio_vec	__bvec[];
+};
+
 #if defined(CONFIG_IO_URING)
 int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd);
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 5da54702cad1..4bd17877d53a 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -45,15 +45,6 @@ struct io_rsrc_node {
 	bool				done;
 };
 
-struct io_mapped_buf {
-	u64		buf;
-	u64		buf_end;
-	unsigned int	nr_bvecs;
-	unsigned int	acct_pages;
-	struct bio_vec	*bvec;
-	struct bio_vec	__bvec[];
-};
-
 void io_rsrc_put_tw(struct callback_head *cb);
 void io_rsrc_put_work(struct work_struct *work);
 void io_rsrc_refs_refill(struct io_ring_ctx *ctx);
-- 
2.31.1

