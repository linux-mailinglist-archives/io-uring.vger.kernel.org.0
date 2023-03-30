Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A64A6D0358
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 13:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbjC3Li0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 07:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbjC3LiV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 07:38:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9C56A7F
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 04:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176216;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cMvtAiZrEHr/RuIr5EK3Qcf9yPL0DeQpzw5d26wmtC4=;
        b=VnxVlDK1+obyJCE1HGKZLPeMbWuSVA5PCswgluKcF+KZF6lUMcM6OtrNyIuDRkj+lH/Suu
        lssFFBIlGj6rIDJFZ9fA5K8xXPNNixAS/wt2lJYvVsyvGB2LMuX56Ze4bodgnyYOSBSvBV
        OevpIVlCtJhDJKb44Keq0AFt4YK6EOs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-528-PTeUdGuBPCWYIzRDacSIJA-1; Thu, 30 Mar 2023 07:36:54 -0400
X-MC-Unique: PTeUdGuBPCWYIzRDacSIJA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5717585A588;
        Thu, 30 Mar 2023 11:36:54 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 675CE14171BE;
        Thu, 30 Mar 2023 11:36:52 +0000 (UTC)
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
Subject: [PATCH V6 02/17] io_uring: use ctx->cached_sq_head to calculate left sqes
Date:   Thu, 30 Mar 2023 19:36:15 +0800
Message-Id: <20230330113630.1388860-3-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-1-ming.lei@redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Use ctx->cached_sq_head to calculate 'left' sqes, and prepare for supporting
fused requests, which need to get req/sqe in its own ->prep() callback.

ctx->cached_sq_head should always be cached or to be fetched, so this change
is just fine.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 693558c4b10b..25a940f0ab68 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2429,15 +2429,16 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries = io_sqring_entries(ctx);
-	unsigned int left;
+	unsigned old_head = ctx->cached_sq_head;
+	unsigned int left = 0;
 	int ret;
 
 	if (unlikely(!entries))
 		return 0;
 	/* make sure SQ entry isn't read before tail */
-	ret = left = min3(nr, ctx->sq_entries, entries);
-	io_get_task_refs(left);
-	io_submit_state_start(&ctx->submit_state, left);
+	ret = min3(nr, ctx->sq_entries, entries);
+	io_get_task_refs(ret);
+	io_submit_state_start(&ctx->submit_state, ret);
 
 	do {
 		const struct io_uring_sqe *sqe;
@@ -2456,11 +2457,12 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		 */
 		if (unlikely(io_submit_sqe(ctx, req, sqe)) &&
 		    !(ctx->flags & IORING_SETUP_SUBMIT_ALL)) {
-			left--;
+			left = 1;
 			break;
 		}
-	} while (--left);
+	} while ((ctx->cached_sq_head - old_head) < ret);
 
+	left = ret - (ctx->cached_sq_head - old_head) - left;
 	if (unlikely(left)) {
 		ret -= left;
 		/* try again if it submitted nothing and can't allocate a req */
-- 
2.39.2

