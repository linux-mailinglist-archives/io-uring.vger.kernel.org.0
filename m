Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF7F6AE223
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 15:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbjCGOXO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 09:23:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231142AbjCGOWj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 09:22:39 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3685C3028B
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 06:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678198560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P26ujjVK6+cVEWytyY3vOQfQzYjDdlY3n3B9f9x4iO4=;
        b=Nte95Z48xuMMit6Ixbc9ErAuQCU04SPtgjGCLXQMkCz6sbo75UTx0K30wZJpJfBbFT0Lms
        E+WZ3nExGwdWV7jWem5cmLwTu3yzblmsHpqFV6S2pZG2+ZN0nzLKkEcbVGxIq1xCBrp3lL
        WTw5IetMDE5IwHHa+2pcjoMEaUDB0JQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-RbvNbJXBMpOmXH05u58B6Q-1; Tue, 07 Mar 2023 09:15:58 -0500
X-MC-Unique: RbvNbJXBMpOmXH05u58B6Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 570351C06EC0;
        Tue,  7 Mar 2023 14:15:58 +0000 (UTC)
Received: from localhost (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8DB332026D4B;
        Tue,  7 Mar 2023 14:15:57 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 06/17] block: ublk_drv: mark device as LIVE before adding disk
Date:   Tue,  7 Mar 2023 22:15:09 +0800
Message-Id: <20230307141520.793891-7-ming.lei@redhat.com>
In-Reply-To: <20230307141520.793891-1-ming.lei@redhat.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IO can be started before add_disk() returns, such as reading parititon table,
then the monitor work should work for making forward progress.

So mark device as LIVE before adding disk, meantime change to
DEAD if add_disk() fails.

Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 088d9efffe6b..2778c14a8407 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1605,17 +1605,18 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
 
 	get_device(&ub->cdev_dev);
+	ub->dev_info.state = UBLK_S_DEV_LIVE;
 	ret = add_disk(disk);
 	if (ret) {
 		/*
 		 * Has to drop the reference since ->free_disk won't be
 		 * called in case of add_disk failure.
 		 */
+		ub->dev_info.state = UBLK_S_DEV_DEAD;
 		ublk_put_device(ub);
 		goto out_put_disk;
 	}
 	set_bit(UB_STATE_USED, &ub->state);
-	ub->dev_info.state = UBLK_S_DEV_LIVE;
 out_put_disk:
 	if (ret)
 		put_disk(disk);
-- 
2.39.2

