Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913217A3FE9
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 06:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239462AbjIREN2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 00:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbjIREM6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 00:12:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C582121
        for <io-uring@vger.kernel.org>; Sun, 17 Sep 2023 21:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695010300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ek6c8oKP7WrCCE1Di4TBl2jO8h2lwVhBOJLN+tp+jLk=;
        b=JNstWIoCi8dQ3DBdbO+ioMgshhXDxaN7lM6glEXtQTXkvNoeEd7a+cHHlJTXNtPKP87812
        GkhVYBP9lDTxn/YwbHOy4etBSIQOlU+UVTr7A6Q5us4diCBrIHDldrM/kTvi0Gqu494lHa
        ejQ+RecFoop4yXvmPVDviVJC0n2o6E0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-0tFN9_eMNoWyqQusowO1og-1; Mon, 18 Sep 2023 00:11:36 -0400
X-MC-Unique: 0tFN9_eMNoWyqQusowO1og-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8FF38945922;
        Mon, 18 Sep 2023 04:11:36 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 963F02026D4B;
        Mon, 18 Sep 2023 04:11:35 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 04/10] ublk: don't get ublk device reference in ublk_abort_queue()
Date:   Mon, 18 Sep 2023 12:11:00 +0800
Message-Id: <20230918041106.2134250-5-ming.lei@redhat.com>
In-Reply-To: <20230918041106.2134250-1-ming.lei@redhat.com>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

ublk_abort_queue() is called in ublk_daemon_monitor_work(), in which
it is guaranteed that ublk device is live, so no need to get the device
reference.

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
2.40.1

