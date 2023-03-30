Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F063F6D0372
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 13:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231747AbjC3Lje (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 07:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231757AbjC3LjK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 07:39:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4A2A256
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 04:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176250;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Plah9oxK2vEYgPKSe8zMQk868IGL1eXPxQld6RUGB/s=;
        b=ER2e2kZr9VphOUy0UlfWS1GVDeG7ESE4KkpmkNYJcPKxCJK8ZBrR5pg/w1ym4GTYHYKoaX
        s5eHf2vsuYIfk0bc7e5A6cDqhUisx05cwbk4kPHrcQwCa2MbpVevaA8MQgPU7iAu9Jqemp
        NfUw/uxNY3AfT0DGPQdTs60+CK8xpiE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-274-OlcWq4k8Nrismr90--zAhw-1; Thu, 30 Mar 2023 07:37:26 -0400
X-MC-Unique: OlcWq4k8Nrismr90--zAhw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9FD2B884EC6;
        Thu, 30 Mar 2023 11:37:25 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B3CC018EC7;
        Thu, 30 Mar 2023 11:37:24 +0000 (UTC)
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
Subject: [PATCH V6 10/17] block: ublk_drv: clean up several helpers
Date:   Thu, 30 Mar 2023 19:36:23 +0800
Message-Id: <20230330113630.1388860-11-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-1-ming.lei@redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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

Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index f87597a7d679..1c057003a40a 100644
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

