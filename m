Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6916CC578
	for <lists+io-uring@lfdr.de>; Tue, 28 Mar 2023 17:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233190AbjC1POj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 28 Mar 2023 11:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjC1POP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 28 Mar 2023 11:14:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB851732
        for <io-uring@vger.kernel.org>; Tue, 28 Mar 2023 08:12:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680016302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aRW9a0ZHd+MGeZHqXvtwA5Cp/cxaEC4LxuKjGisTMi4=;
        b=Ekn3v70BlN/cdy68PMq8Ikgw/jNlBb1pby3UT2P7DvU2gWwqxY/Gku8axLuaQSpO9bulPe
        Wes9qtzcFKIJeLb7SjP1kvi+AJY4cRlIm4UKrr00EF21e+lh4SqF6AV0vXl5pAXVndyNCX
        s0HdYgpqlbCQFK9rbcSfqAV2O4SZ77g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-437-CwbPgIyQOWK4ebslNp_Dkg-1; Tue, 28 Mar 2023 11:11:37 -0400
X-MC-Unique: CwbPgIyQOWK4ebslNp_Dkg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2C00E185A791;
        Tue, 28 Mar 2023 15:11:37 +0000 (UTC)
Received: from localhost (ovpn-8-20.pek2.redhat.com [10.72.8.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 304CC440D6;
        Tue, 28 Mar 2023 15:11:35 +0000 (UTC)
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
Subject: [PATCH V5 10/16] block: ublk_drv: cleanup 'struct ublk_map_data'
Date:   Tue, 28 Mar 2023 23:09:52 +0800
Message-Id: <20230328150958.1253547-11-ming.lei@redhat.com>
In-Reply-To: <20230328150958.1253547-1-ming.lei@redhat.com>
References: <20230328150958.1253547-1-ming.lei@redhat.com>
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

'struct ublk_map_data' is passed to ublk_copy_user_pages()
for copying data between userspace buffer and request pages.

Here what matters is userspace buffer address/len and 'struct request',
so replace ->io field with user buffer address, and rename max_bytes
as len.

Meantime remove 'ubq' field from ublk_map_data, since it isn't used
any more.

Then code becomes more readable.

Reviewed-by: Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 1c057003a40a..fdccbf5fdaa1 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -420,10 +420,9 @@ static const struct block_device_operations ub_fops = {
 #define UBLK_MAX_PIN_PAGES	32
 
 struct ublk_map_data {
-	const struct ublk_queue *ubq;
 	const struct request *rq;
-	const struct ublk_io *io;
-	unsigned max_bytes;
+	unsigned long	ubuf;
+	unsigned int	len;
 };
 
 struct ublk_io_iter {
@@ -483,14 +482,14 @@ static inline unsigned ublk_copy_io_pages(struct ublk_io_iter *data,
 static int ublk_copy_user_pages(struct ublk_map_data *data, bool to_vm)
 {
 	const unsigned int gup_flags = to_vm ? FOLL_WRITE : 0;
-	const unsigned long start_vm = data->io->addr;
+	const unsigned long start_vm = data->ubuf;
 	unsigned int done = 0;
 	struct ublk_io_iter iter = {
 		.pg_off	= start_vm & (PAGE_SIZE - 1),
 		.bio	= data->rq->bio,
 		.iter	= data->rq->bio->bi_iter,
 	};
-	const unsigned int nr_pages = round_up(data->max_bytes +
+	const unsigned int nr_pages = round_up(data->len +
 			(start_vm & (PAGE_SIZE - 1)), PAGE_SIZE) >> PAGE_SHIFT;
 
 	while (done < nr_pages) {
@@ -503,13 +502,13 @@ static int ublk_copy_user_pages(struct ublk_map_data *data, bool to_vm)
 				iter.pages);
 		if (iter.nr_pages <= 0)
 			return done == 0 ? iter.nr_pages : done;
-		len = ublk_copy_io_pages(&iter, data->max_bytes, to_vm);
+		len = ublk_copy_io_pages(&iter, data->len, to_vm);
 		for (i = 0; i < iter.nr_pages; i++) {
 			if (to_vm)
 				set_page_dirty(iter.pages[i]);
 			put_page(iter.pages[i]);
 		}
-		data->max_bytes -= len;
+		data->len -= len;
 		done += iter.nr_pages;
 	}
 
@@ -538,15 +537,14 @@ static int ublk_map_io(const struct ublk_queue *ubq, const struct request *req,
 	 */
 	if (ublk_need_map_req(req)) {
 		struct ublk_map_data data = {
-			.ubq	=	ubq,
 			.rq	=	req,
-			.io	=	io,
-			.max_bytes =	rq_bytes,
+			.ubuf	=	io->addr,
+			.len	=	rq_bytes,
 		};
 
 		ublk_copy_user_pages(&data, true);
 
-		return rq_bytes - data.max_bytes;
+		return rq_bytes - data.len;
 	}
 	return rq_bytes;
 }
@@ -559,17 +557,16 @@ static int ublk_unmap_io(const struct ublk_queue *ubq,
 
 	if (ublk_need_unmap_req(req)) {
 		struct ublk_map_data data = {
-			.ubq	=	ubq,
 			.rq	=	req,
-			.io	=	io,
-			.max_bytes =	io->res,
+			.ubuf	=	io->addr,
+			.len	=	io->res,
 		};
 
 		WARN_ON_ONCE(io->res > rq_bytes);
 
 		ublk_copy_user_pages(&data, false);
 
-		return io->res - data.max_bytes;
+		return io->res - data.len;
 	}
 	return rq_bytes;
 }
-- 
2.39.2

