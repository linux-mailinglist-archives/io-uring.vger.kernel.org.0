Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C297D6CC571
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 17:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233931AbjC1POY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 11:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233939AbjC1PNu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 11:13:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6084410A9D
        for <io-uring@vger.kernel.org>; Tue, 28 Mar 2023 08:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680016287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2HaaAMVXBOU9npIKRCm63G2Jnf2K0Y8PRLMtIL+XBWM=;
        b=OaoPxnQju5QJRcZYfoUNkMOv9APx3XtaMKxB7joTv4Yn8SrU/T/aVst3AMgzjz0U8dBUV5
        JYAIT11Uw6nN771KrhTrDDtkjbmkqUpOWyNq8jg6q6EqnTqtHO1qL1FQ5L1UMZy+HR32pj
        0sqdE1TBLusJSDmAGiYugyRQmDINBiY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-380-EKSnFKTlNW2-26zE5_Z4xw-1; Tue, 28 Mar 2023 11:11:23 -0400
X-MC-Unique: EKSnFKTlNW2-26zE5_Z4xw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D375E38149CC;
        Tue, 28 Mar 2023 15:11:21 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E684D4020C83;
        Tue, 28 Mar 2023 15:11:15 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V5 06/16] block: ublk_drv: add common exit handling
Date:   Tue, 28 Mar 2023 23:09:48 +0800
Message-Id: <20230328150958.1253547-7-ming.lei@redhat.com>
In-Reply-To: <20230328150958.1253547-1-ming.lei@redhat.com>
References: <20230328150958.1253547-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
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
index c73cc57ec547..bc46616710d4 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -655,14 +655,15 @@ static void ublk_complete_rq(struct request *req)
 	struct ublk_queue *ubq = req->mq_hctx->driver_data;
 	struct ublk_io *io = &ubq->ios[req->tag];
 	unsigned int unmapped_bytes;
+	blk_status_t res = BLK_STS_OK;
 
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

