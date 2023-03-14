Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A73E6B957D
	for <lists+io-uring@lfdr.de>; Tue, 14 Mar 2023 14:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbjCNNHa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Mar 2023 09:07:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232206AbjCNNHG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Mar 2023 09:07:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A7F274B6
        for <io-uring@vger.kernel.org>; Tue, 14 Mar 2023 06:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678798922;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lLi7uO/x73sXNOWJ/5oEGjBJBAMRFd2rXWC9xLHwC+o=;
        b=i0ZLYDFctvGstvXR7/iDx0E/Vqv1rSrOQjCuJ5zUBqjIdSQfAfGC0ntBvG5hcLeEkFc3ry
        ZZRSbYPhr8wyLjk/C3MlMIVAdGjhUM3f0CY81FqfGg6Z5VX3/sO8KO00pCrGoWxWTqot/C
        uDXEs75l/Csv45TBN/o3JrU38HDGsS0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-652-bHIQUcMBNey8O8KgaHB2CA-1; Tue, 14 Mar 2023 08:58:20 -0400
X-MC-Unique: bHIQUcMBNey8O8KgaHB2CA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 359E8800B23;
        Tue, 14 Mar 2023 12:58:20 +0000 (UTC)
Received: from localhost (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 716A240AE2C0;
        Tue, 14 Mar 2023 12:58:19 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 13/16] block: ublk_drv: support to copy any part of request pages
Date:   Tue, 14 Mar 2023 20:57:24 +0800
Message-Id: <20230314125727.1731233-14-ming.lei@redhat.com>
In-Reply-To: <20230314125727.1731233-1-ming.lei@redhat.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add 'offset' to 'struct ublk_map_data', so that ublk_copy_user_pages()
can be used to copy any sub-buffer(linear mapped) of the request.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0e036a579b9b..f79af40d1a8c 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -511,19 +511,37 @@ static void ublk_copy_io_pages(struct ublk_io_iter *data,
 	}
 }
 
+static bool ublk_advance_io_iter(struct ublk_io_iter *iter, unsigned int offset)
+{
+	struct bio *bio = iter->bio;
+
+	for_each_bio(bio) {
+		if (bio->bi_iter.bi_size > offset) {
+			iter->bio = bio;
+			iter->iter = bio->bi_iter;
+			bio_advance_iter(iter->bio, &iter->iter, offset);
+			return true;
+		}
+		offset -= bio->bi_iter.bi_size;
+	}
+	return false;
+}
+
 /*
  * Copy data between request pages and io_iter, and 'offset'
  * is the start point of linear offset of request.
  */
 static size_t ublk_copy_user_pages(const struct request *req,
-		struct iov_iter *uiter, int dir)
+		unsigned offset, struct iov_iter *uiter, int dir)
 {
 	struct ublk_io_iter iter = {
 		.bio	= req->bio,
-		.iter	= req->bio->bi_iter,
 	};
 	size_t done = 0;
 
+	if (!ublk_advance_io_iter(&iter, offset))
+		return 0;
+
 	while (iov_iter_count(uiter) && iter.bio) {
 		unsigned nr_pages;
 		size_t len, off;
@@ -576,7 +594,7 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 		import_single_range(dir, u64_to_user_ptr(io->addr), rq_bytes,
 				&iov, &iter);
 
-		return ublk_copy_user_pages(req, &iter, dir);
+		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
 }
@@ -596,7 +614,7 @@ static int ublk_unmap_io(const struct ublk_queue *ubq,
 
 		import_single_range(dir, u64_to_user_ptr(io->addr), io->res,
 				&iov, &iter);
-		return ublk_copy_user_pages(req, &iter, dir);
+		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
 }
-- 
2.39.2

