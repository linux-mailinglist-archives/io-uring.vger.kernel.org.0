Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 304656AE23B
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 15:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjCGOZq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 09:25:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjCGOZ2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 09:25:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BCA8C5AC
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 06:20:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678198761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RQpe5yrYiRdAwej0j43axVzdYRPoNAlMjHxJ4W7+COg=;
        b=FAejS5e/zQ41LRWpigwq5HsOj1fUUq8c8+RJNWjmbnwTHe4G65MfoOEuXB8EK+WJKfHFGj
        wZLdfM3G1o56/AUvMHCwLjAT2smdVvG1YXRBwHHPDxdyPOYN0Osvd85nL6DPnAe5VqFCm8
        6iwAQVz9A8M+C/0Z3acMCqXaP7C4bzc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-540-8RPNgXGMPl63F7F25p2f2A-1; Tue, 07 Mar 2023 09:16:10 -0500
X-MC-Unique: 8RPNgXGMPl63F7F25p2f2A-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 54F5D877CB4;
        Tue,  7 Mar 2023 14:16:08 +0000 (UTC)
Received: from localhost (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 835BB492C14;
        Tue,  7 Mar 2023 14:16:07 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 09/17] block: ublk_drv: add two helpers to clean up map/unmap request
Date:   Tue,  7 Mar 2023 22:15:12 +0800
Message-Id: <20230307141520.793891-10-ming.lei@redhat.com>
In-Reply-To: <20230307141520.793891-1-ming.lei@redhat.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add two helpers for checking if map/unmap is needed, since we may have
passthrough request which needs map or unmap in future, such as for
supporting report zones.

Meantime don't mark ublk_copy_user_pages as inline since this function
is a bit fat now.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 624ee4ca20e5..115590bb60b2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -488,8 +488,7 @@ static inline unsigned ublk_copy_io_pages(struct ublk_io_iter *data,
 	return done;
 }
 
-static inline int ublk_copy_user_pages(struct ublk_map_data *data,
-		bool to_vm)
+static int ublk_copy_user_pages(struct ublk_map_data *data, bool to_vm)
 {
 	const unsigned int gup_flags = to_vm ? FOLL_WRITE : 0;
 	const unsigned long start_vm = data->io->addr;
@@ -525,6 +524,16 @@ static inline int ublk_copy_user_pages(struct ublk_map_data *data,
 	return done;
 }
 
+static inline bool ublk_need_map_req(const struct request *req)
+{
+	return ublk_rq_has_data(req) && req_op(req) == REQ_OP_WRITE;
+}
+
+static inline bool ublk_need_unmap_req(const struct request *req)
+{
+	return ublk_rq_has_data(req) && req_op(req) == REQ_OP_READ;
+}
+
 static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 		struct ublk_io *io)
 {
@@ -535,7 +544,7 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 	 * context and the big benefit is that pinning pages in current
 	 * context is pretty fast, see ublk_pin_user_pages
 	 */
-	if (ublk_rq_has_data(req) && req_op(req) == REQ_OP_WRITE) {
+	if (ublk_need_map_req(req)) {
 		struct ublk_map_data data = {
 			.ubq	=	ubq,
 			.rq	=	req,
@@ -556,7 +565,7 @@ static int ublk_unmap_io(const struct ublk_queue *ubq,
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
 
-	if (req_op(req) == REQ_OP_READ && ublk_rq_has_data(req)) {
+	if (ublk_need_unmap_req(req)) {
 		struct ublk_map_data data = {
 			.ubq	=	ubq,
 			.rq	=	req,
@@ -770,7 +779,7 @@ static inline void __ublk_rq_task_work(struct request *req)
 		return;
 	}
 
-	if (ublk_need_get_data(ubq) && (req_op(req) == REQ_OP_WRITE)) {
+	if (ublk_need_get_data(ubq) && ublk_need_map_req(req)) {
 		/*
 		 * We have not handled UBLK_IO_NEED_GET_DATA command yet,
 		 * so immepdately pass UBLK_IO_RES_NEED_GET_DATA to ublksrv
-- 
2.39.2

