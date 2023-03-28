Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC426CC649
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 17:29:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbjC1P3E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 11:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbjC1P2d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 11:28:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E4AEB6E
        for <io-uring@vger.kernel.org>; Tue, 28 Mar 2023 08:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680017175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cTxPpka+LhrPaNriA70AKnPyZgOXWneoLBopgtDoZwU=;
        b=PiBmOXWD/9qKG90EpSQ9FO5821tz8JkwD8KaOqPHHWABoNcvxqIKKuuI/POWsvJXpuK8YB
        fTH6g+CIT13CMfbiVl0NXnd7wQLxhLolXFM3I7/I8KjwxIsDhTGgex92k3t9Hk0OQX1CTs
        voGl25naVb5MwW8E3+ey8Q1mANY9t3Q=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-PUrBr7alNgOUiXBQAgnAyQ-1; Tue, 28 Mar 2023 11:11:57 -0400
X-MC-Unique: PUrBr7alNgOUiXBQAgnAyQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E7052823806;
        Tue, 28 Mar 2023 15:11:49 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9EB1D4020C83;
        Tue, 28 Mar 2023 15:11:48 +0000 (UTC)
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
Subject: [PATCH V5 13/16] block: ublk_drv: support to copy any part of request pages
Date:   Tue, 28 Mar 2023 23:09:55 +0800
Message-Id: <20230328150958.1253547-14-ming.lei@redhat.com>
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

Add 'offset' to 'struct ublk_map_data', so that ublk_copy_user_pages()
can be used to copy any sub-buffer(linear mapped) of the request.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 31 ++++++++++++++++++++++++-------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 0dc8eb04b9a5..32304942ab87 100644
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

