Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E77596A6DEE
	for <lists+io-uring@lfdr.de>; Wed,  1 Mar 2023 15:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjCAOJU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 1 Mar 2023 09:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCAOJO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 1 Mar 2023 09:09:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88EC322016
        for <io-uring@vger.kernel.org>; Wed,  1 Mar 2023 06:08:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1677679688;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4743F7Qm1JF9Z8MoytAhj/h+tT8J4FaPqlcsGjHKeC4=;
        b=BEV+GZE08iF+/PVxcZ09F8dNTY7ZQwMe4r7fpX63yio669tH7QnTu2eQOx2jFRVsaTeXxT
        T+5U+5UDtbX07HdBCEgQA3kz6WSOOjy1dCGS8FcYUw0FKZd9MWX4v20oloYeIj69CRjBZ3
        FTDimOy4CGQLOFfAQrihWF5NCD197WE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-151-0gcjTk4UOnKMQavsQ6UFQA-1; Wed, 01 Mar 2023 09:08:06 -0500
X-MC-Unique: 0gcjTk4UOnKMQavsQ6UFQA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2620F8DBA77;
        Wed,  1 Mar 2023 14:06:35 +0000 (UTC)
Received: from localhost (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4B8FC40B40DF;
        Wed,  1 Mar 2023 14:06:33 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [RFC PATCH 03/12] io_uring: extend io_mapped_ubuf to cover external bvec table
Date:   Wed,  1 Mar 2023 22:06:02 +0800
Message-Id: <20230301140611.163055-4-ming.lei@redhat.com>
In-Reply-To: <20230301140611.163055-1-ming.lei@redhat.com>
References: <20230301140611.163055-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extend io_mapped_ubuf to cover external bvec table for supporting
fused command kbuf, in which the bvec table could be from one IO
request.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 5 +++--
 io_uring/rsrc.h | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a59fc02de598..c41edd197b0a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1221,7 +1221,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		goto done;
 	}
 
-	imu = kvmalloc(struct_size(imu, bvec, nr_pages), GFP_KERNEL);
+	imu = kvmalloc(struct_size(imu, __bvec, nr_pages), GFP_KERNEL);
 	if (!imu)
 		goto done;
 
@@ -1237,7 +1237,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		size_t vec_len;
 
 		vec_len = min_t(size_t, size, PAGE_SIZE - off);
-		bvec_set_page(&imu->bvec[i], pages[i], vec_len, off);
+		bvec_set_page(&imu->__bvec[i], pages[i], vec_len, off);
 		off = 0;
 		size -= vec_len;
 	}
@@ -1245,6 +1245,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	imu->ubuf = (unsigned long) iov->iov_base;
 	imu->ubuf_end = imu->ubuf + iov->iov_len;
 	imu->nr_bvecs = nr_pages;
+	imu->bvec = imu->__bvec;
 	*pimu = imu;
 	ret = 0;
 done:
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 774aca20326c..24329eca49ef 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -50,7 +50,8 @@ struct io_mapped_ubuf {
 	u64		ubuf_end;
 	unsigned int	nr_bvecs;
 	unsigned int	acct_pages;
-	struct bio_vec	bvec[];
+	struct bio_vec	*bvec;
+	struct bio_vec	__bvec[];
 };
 
 void io_rsrc_put_tw(struct callback_head *cb);
-- 
2.31.1

