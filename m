Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2B66C7F4C
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 15:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjCXOAW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 10:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231939AbjCXOAH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 10:00:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E601B2E8
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 06:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679666334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wz2FGQNTIGH4rfgIOsbrI06KOjBXUtm/DnvsfScX6mQ=;
        b=hZrzcvCADMDOAkiPBKKxXKdmQmoCssOR33ruBH33Sf809HpV3LELdkFE+cY/iEeHh/PtaQ
        PZ1H2zCSUWyRmFH+TmsHOJacvd4pYtMJJym/7KLH2gqCjNbNu0F9GTAJOcl0tjr5drjH87
        efJ6KAc+mUI/e0mATFmssIeFxBBaTng=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-480-pgonzQZOOe-UOoX2wHsxtg-1; Fri, 24 Mar 2023 09:58:49 -0400
X-MC-Unique: pgonzQZOOe-UOoX2wHsxtg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 64B322817233;
        Fri, 24 Mar 2023 13:58:49 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A49D440D6;
        Fri, 24 Mar 2023 13:58:48 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 08/17] block: ublk_drv: don't consider flush request in map/unmap io
Date:   Fri, 24 Mar 2023 21:57:59 +0800
Message-Id: <20230324135808.855245-9-ming.lei@redhat.com>
In-Reply-To: <20230324135808.855245-1-ming.lei@redhat.com>
References: <20230324135808.855245-1-ming.lei@redhat.com>
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

There isn't data in request of REQ_OP_FLUSH always, so don't consider
it in both ublk_map_io() and ublk_unmap_io().

Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index b8998ed87a0f..4fe324da97a0 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -529,15 +529,13 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 		struct ublk_io *io)
 {
 	const unsigned int rq_bytes = blk_rq_bytes(req);
+
 	/*
 	 * no zero copy, we delay copy WRITE request data into ublksrv
 	 * context and the big benefit is that pinning pages in current
 	 * context is pretty fast, see ublk_pin_user_pages
 	 */
-	if (req_op(req) != REQ_OP_WRITE && req_op(req) != REQ_OP_FLUSH)
-		return rq_bytes;
-
-	if (ublk_rq_has_data(req)) {
+	if (ublk_rq_has_data(req) && req_op(req) == REQ_OP_WRITE) {
 		struct ublk_map_data data = {
 			.ubq	=	ubq,
 			.rq	=	req,
@@ -772,9 +770,7 @@ static inline void __ublk_rq_task_work(struct request *req)
 		return;
 	}
 
-	if (ublk_need_get_data(ubq) &&
-			(req_op(req) == REQ_OP_WRITE ||
-			req_op(req) == REQ_OP_FLUSH)) {
+	if (ublk_need_get_data(ubq) && (req_op(req) == REQ_OP_WRITE)) {
 		/*
 		 * We have not handled UBLK_IO_NEED_GET_DATA command yet,
 		 * so immepdately pass UBLK_IO_RES_NEED_GET_DATA to ublksrv
-- 
2.39.2

