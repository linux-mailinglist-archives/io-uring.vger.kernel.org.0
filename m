Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 089537BD724
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 11:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345708AbjJIJfW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Oct 2023 05:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345695AbjJIJfW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Oct 2023 05:35:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7788F97
        for <io-uring@vger.kernel.org>; Mon,  9 Oct 2023 02:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696844075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TX7Wzkd4ZYKzaRjV/dKAq+t7hN8oAyiuhJUvpnY/OP8=;
        b=PI+yF3gWJGpIAzOxl22ImeelyT4YnqUYvEuETK88rS7veFaFLQ5Xs0NWwjkBwjgeLiz+FY
        2B568y0rZCbtUBTZlg13kmkAVBah+65vxyBKi4dXIA1n7o1kQy6B3m6YE8DyKRFzqebzZv
        3kf4A7mIGT8POwV7FKULEMqcbgQSwv8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-691-uELNN7glPqKhLNU7_H5v9Q-1; Mon, 09 Oct 2023 05:34:29 -0400
X-MC-Unique: uELNN7glPqKhLNU7_H5v9Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 946C6101A597;
        Mon,  9 Oct 2023 09:34:29 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C0D604026FB;
        Mon,  9 Oct 2023 09:34:28 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-6.7/io_uring 1/7] ublk: don't get ublk device reference in ublk_abort_queue()
Date:   Mon,  9 Oct 2023 17:33:16 +0800
Message-ID: <20231009093324.957829-2-ming.lei@redhat.com>
In-Reply-To: <20231009093324.957829-1-ming.lei@redhat.com>
References: <20231009093324.957829-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
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

ublk_abort_queue() is called in ublk_daemon_monitor_work(), in which
it is guaranteed that the device is live because monitor work is
canceled when removing device, so no need to get the device reference.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 630ddfe6657b..9b3c0b3dd36e 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1419,9 +1419,6 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 {
 	int i;
 
-	if (!ublk_get_device(ub))
-		return;
-
 	for (i = 0; i < ubq->q_depth; i++) {
 		struct ublk_io *io = &ubq->ios[i];
 
@@ -1437,7 +1434,6 @@ static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
 				__ublk_fail_req(ubq, io, rq);
 		}
 	}
-	ublk_put_device(ub);
 }
 
 static void ublk_daemon_monitor_work(struct work_struct *work)
-- 
2.41.0

