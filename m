Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F596AE220
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 15:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbjCGOW6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 09:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjCGOWU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 09:22:20 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A528E83D7
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 06:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678198566;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/NBwVYnHSaZrYp0gKoT57Tl/vQn9azd4FuuYHvk1QnI=;
        b=UigyT633F3W18Zr+algCohnr4PlUfQIUKLGW5Q+wfAdSspGXmG2Bu/dndStjP5wUR2ePEo
        kGn9K5iweuaiblb5z+c+kOxn/5K0Zwk8uIZMUwSSC09Qsi3dPzSV3nOxHokxrao8HBsvx1
        ApxnScYUxMr8cnzyqfZ5STddLTV9Vdk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-564-0b6g09CRMgG8Ofc3pyTNSA-1; Tue, 07 Mar 2023 09:16:03 -0500
X-MC-Unique: 0b6g09CRMgG8Ofc3pyTNSA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9718838173CB;
        Tue,  7 Mar 2023 14:16:01 +0000 (UTC)
Received: from localhost (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2D132026D4B;
        Tue,  7 Mar 2023 14:16:00 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 07/17] block: ublk_drv: add common exit handling
Date:   Tue,  7 Mar 2023 22:15:10 +0800
Message-Id: <20230307141520.793891-8-ming.lei@redhat.com>
In-Reply-To: <20230307141520.793891-1-ming.lei@redhat.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Simplify exit handling a bit, and prepare for supporting fused command.

Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 2778c14a8407..c03728c13eea 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -655,14 +655,15 @@ static void ublk_complete_rq(struct request *req)
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
 	struct ublk_io *io = &ubq->ios[req->tag];
 	unsigned int unmapped_bytes;
+	int res = BLK_STS_OK;
 
 	/* failed read IO if nothing is read */
 	if (!io->res && req_op(req) == REQ_OP_READ)
 		io->res = -EIO;
 
 	if (io->res < 0) {
-		blk_mq_end_request(req, errno_to_blk_status(io->res));
-		return;
+		res = errno_to_blk_status(io->res);
+		goto exit;
 	}
 
 	/*
@@ -671,10 +672,8 @@ static void ublk_complete_rq(struct request *req)
 	 *
 	 * Both the two needn't unmap.
 	 */
-	if (req_op(req) != REQ_OP_READ && req_op(req) != REQ_OP_WRITE) {
-		blk_mq_end_request(req, BLK_STS_OK);
-		return;
-	}
+	if (req_op(req) != REQ_OP_READ && req_op(req) != REQ_OP_WRITE)
+		goto exit;
 
 	/* for READ request, writing data in iod->addr to rq buffers */
 	unmapped_bytes = ublk_unmap_io(ubq, req, io);
@@ -691,6 +690,10 @@ static void ublk_complete_rq(struct request *req)
 		blk_mq_requeue_request(req, true);
 	else
 		__blk_mq_end_request(req, BLK_STS_OK);
+
+	return;
+exit:
+	blk_mq_end_request(req, res);
 }
 
 /*
-- 
2.39.2

