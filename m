Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B9B7BD72C
	for <lists+io-uring@lfdr.de>; Mon,  9 Oct 2023 11:36:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345838AbjJIJgH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Oct 2023 05:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345818AbjJIJgF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Oct 2023 05:36:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30818CF
        for <io-uring@vger.kernel.org>; Mon,  9 Oct 2023 02:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696844086;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NKHZfvG6Z8aGlAnyqm9NbYAuSR+v/Mw4bxijcdGmwVY=;
        b=YbW/iZhe5DY6iZy8Ux+s/j9/Ka0NmdDrmAZ8VUAv788x2sxAOmXr0h+BRBsLVd4HyfJLAv
        94IhDPaxoa52o+jmJOYAkxZV2KE0q9r2ErLuGIhB1avfz4kyHv+Qz+hmmefQhqkPiGouC0
        j6n8jDIZCsTrfGr5vuKYAWBIi+3Rgls=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-RnjU7tFYOK-OI3_NUiaRSw-1; Mon, 09 Oct 2023 05:34:40 -0400
X-MC-Unique: RnjU7tFYOK-OI3_NUiaRSw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2EA0685A5BE;
        Mon,  9 Oct 2023 09:34:40 +0000 (UTC)
Received: from localhost (unknown [10.72.120.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 627EBC0FE2D;
        Mon,  9 Oct 2023 09:34:39 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH for-6.7/io_uring 4/7] ublk: rename mm_lock as lock
Date:   Mon,  9 Oct 2023 17:33:19 +0800
Message-ID: <20231009093324.957829-5-ming.lei@redhat.com>
In-Reply-To: <20231009093324.957829-1-ming.lei@redhat.com>
References: <20231009093324.957829-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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

Rename mm_lock field of ublk_device as lock, so that this lock can be reused
for protecting access of ub->ub_disk, which will be used for simplifying
ublk_abort_queue() by quiesce queue in next patch.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 15b52210488a..ab8828ab3a0c 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -170,7 +170,7 @@ struct ublk_device {
 
 	struct mutex		mutex;
 
-	spinlock_t		mm_lock;
+	spinlock_t		lock;
 	struct mm_struct	*mm;
 
 	struct ublk_params	params;
@@ -1361,12 +1361,12 @@ static int ublk_ch_mmap(struct file *filp, struct vm_area_struct *vma)
 	unsigned long pfn, end, phys_off = vma->vm_pgoff << PAGE_SHIFT;
 	int q_id, ret = 0;
 
-	spin_lock(&ub->mm_lock);
+	spin_lock(&ub->lock);
 	if (!ub->mm)
 		ub->mm = current->mm;
 	if (current->mm != ub->mm)
 		ret = -EINVAL;
-	spin_unlock(&ub->mm_lock);
+	spin_unlock(&ub->lock);
 
 	if (ret)
 		return ret;
@@ -2341,7 +2341,7 @@ static int ublk_ctrl_add_dev(struct io_uring_cmd *cmd)
 	if (!ub)
 		goto out_unlock;
 	mutex_init(&ub->mutex);
-	spin_lock_init(&ub->mm_lock);
+	spin_lock_init(&ub->lock);
 	INIT_WORK(&ub->quiesce_work, ublk_quiesce_work_fn);
 	INIT_WORK(&ub->stop_work, ublk_stop_work_fn);
 	INIT_DELAYED_WORK(&ub->monitor_work, ublk_daemon_monitor_work);
-- 
2.41.0

