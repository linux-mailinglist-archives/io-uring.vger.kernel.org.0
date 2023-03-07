Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A9D6AE242
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 15:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231142AbjCGO0N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 09:26:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjCGOZr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 09:25:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141CA911FF
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 06:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678198801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A+/fIrb0506DI1ezqKqU90isQNExiPGr2EwqQWVGFOo=;
        b=KltfBneyoFwFe3ypUOkTRTdy2DE7GGudyD5QCUhyb0KKFEcbUI/DIKnmukffcnzCPaBzCP
        ot21ihO1AXblmV58Vg3SqF7pRPK6bvwYF5PyHe7s1P/+V3LcAW5/xcbfUnQ07tCh7hCUKF
        9duQ8xO/z0mJD2U+y1PBV7R3xPtNYbI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-454-PdKJqBIfOqOXj5ZMFQsajw-1; Tue, 07 Mar 2023 09:16:12 -0500
X-MC-Unique: PdKJqBIfOqOXj5ZMFQsajw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D318E101A55E;
        Tue,  7 Mar 2023 14:16:11 +0000 (UTC)
Received: from localhost (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 142A1492C14;
        Tue,  7 Mar 2023 14:16:10 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 10/17] block: ublk_drv: clean up several helpers
Date:   Tue,  7 Mar 2023 22:15:13 +0800
Message-Id: <20230307141520.793891-11-ming.lei@redhat.com>
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

Convert the following pattern in several helpers
	if (Z)
		return true
	return false
into:
	return Z;

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 115590bb60b2..5b69e239dca3 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -298,9 +298,7 @@ static inline bool ublk_can_use_task_work(const struct ublk_queue *ubq)
 
 static inline bool ublk_need_get_data(const struct ublk_queue *ubq)
 {
-	if (ubq->flags & UBLK_F_NEED_GET_DATA)
-		return true;
-	return false;
+	return ubq->flags & UBLK_F_NEED_GET_DATA;
 }
 
 static struct ublk_device *ublk_get_device(struct ublk_device *ub)
@@ -349,25 +347,19 @@ static inline int ublk_queue_cmd_buf_size(struct ublk_device *ub, int q_id)
 static inline bool ublk_queue_can_use_recovery_reissue(
 		struct ublk_queue *ubq)
 {
-	if ((ubq->flags & UBLK_F_USER_RECOVERY) &&
-			(ubq->flags & UBLK_F_USER_RECOVERY_REISSUE))
-		return true;
-	return false;
+	return (ubq->flags & UBLK_F_USER_RECOVERY) &&
+			(ubq->flags & UBLK_F_USER_RECOVERY_REISSUE);
 }
 
 static inline bool ublk_queue_can_use_recovery(
 		struct ublk_queue *ubq)
 {
-	if (ubq->flags & UBLK_F_USER_RECOVERY)
-		return true;
-	return false;
+	return ubq->flags & UBLK_F_USER_RECOVERY;
 }
 
 static inline bool ublk_can_use_recovery(struct ublk_device *ub)
 {
-	if (ub->dev_info.flags & UBLK_F_USER_RECOVERY)
-		return true;
-	return false;
+	return ub->dev_info.flags & UBLK_F_USER_RECOVERY;
 }
 
 static void ublk_free_disk(struct gendisk *disk)
-- 
2.39.2

