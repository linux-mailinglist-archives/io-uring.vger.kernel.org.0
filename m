Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55486C7F62
	for <lists+io-uring@lfdr.de>; Fri, 24 Mar 2023 15:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbjCXOBC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Mar 2023 10:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbjCXOA1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Mar 2023 10:00:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30681BAEB
        for <io-uring@vger.kernel.org>; Fri, 24 Mar 2023 06:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679666353;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=uuQC+m3nWXpEvAHBrpKpd923ngOUWFuBZCOxaTw0mf8=;
        b=fepTpdr5Sqa8jBQTd1s687kXFAx1wY2Gy9tjCzP7Uz/QxZdAmnyy7FWaAzIq2XrP5Mpza2
        bipOR2VWTcXkwKnbPl2ulD33TppY0rRsjPU55sbx8ZI1E0dDjo0yq6ZPE/63rjvp8YQSH9
        BHbzGi2PFJmS++1taPLu9mKz/Z6vwX4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-267-OzWGU5o8N2yR7DVTUK2FWw-1; Fri, 24 Mar 2023 09:59:10 -0400
X-MC-Unique: OzWGU5o8N2yR7DVTUK2FWw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 49D26185A7AC;
        Fri, 24 Mar 2023 13:59:10 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 811204042AC9;
        Fri, 24 Mar 2023 13:59:09 +0000 (UTC)
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
Subject: [PATCH V4 14/17] block: ublk_drv: support to copy any part of request pages
Date:   Fri, 24 Mar 2023 21:58:05 +0800
Message-Id: <20230324135808.855245-15-ming.lei@redhat.com>
In-Reply-To: <20230324135808.855245-1-ming.lei@redhat.com>
References: <20230324135808.855245-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
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
 drivers/block/ublk_drv.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 88d5a657834d..26a14c54da1d 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -511,19 +511,36 @@ static void ublk_copy_io_pages(struct ublk_io_iter *data,
 	}
 }
 
+static bool ublk_advance_io_iter(const struct request *req,
+		struct ublk_io_iter *iter, unsigned int offset)
+{
+	struct bio *bio = req->bio;
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
-	struct ublk_io_iter iter = {
-		.bio	= req->bio,
-		.iter	= req->bio->bi_iter,
-	};
+	struct ublk_io_iter iter;
 	size_t done = 0;
 
+	if (!ublk_advance_io_iter(req, &iter, offset))
+		return 0;
+
 	while (iov_iter_count(uiter) && iter.bio) {
 		unsigned nr_pages;
 		size_t len, off;
@@ -576,7 +593,7 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 		import_single_range(dir, u64_to_user_ptr(io->addr), rq_bytes,
 				&iov, &iter);
 
-		return ublk_copy_user_pages(req, &iter, dir);
+		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
 }
@@ -596,7 +613,7 @@ static int ublk_unmap_io(const struct ublk_queue *ubq,
 
 		import_single_range(dir, u64_to_user_ptr(io->addr), io->res,
 				&iov, &iter);
-		return ublk_copy_user_pages(req, &iter, dir);
+		return ublk_copy_user_pages(req, 0, &iter, dir);
 	}
 	return rq_bytes;
 }
-- 
2.39.2

