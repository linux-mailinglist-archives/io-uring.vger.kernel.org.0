Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0FD57A3FED
	for <lists+io-uring@lfdr.de>; Mon, 18 Sep 2023 06:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239221AbjIREN3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Sep 2023 00:13:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238654AbjIREM6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Sep 2023 00:12:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF3C7126
        for <io-uring@vger.kernel.org>; Sun, 17 Sep 2023 21:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695010303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+D1tdoJY1LNEs7CO9yqwlRl9HUhkTckA0MTM2Mzt9+U=;
        b=EeWKGXSvC6AMWc80+Z9d4kKV2V35pxWKucM65Sr/SanfRenQMne5b7n4JELIyW0uaCtD8J
        5HP5zQ4x7rb23GyXNp0PP8uU/1jTReyrbHf6aKEJhjARH6AKR6dM2Lo1kMrLKgBLUmILy8
        3BiKWoZuQ3dLWac/ELOFjxoqLT3S7UQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-511-8mnrePgoPseT-tlH8xPF_A-1; Mon, 18 Sep 2023 00:11:40 -0400
X-MC-Unique: 8mnrePgoPseT-tlH8xPF_A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 775E585A5BA;
        Mon, 18 Sep 2023 04:11:40 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8AF9240C6EA8;
        Mon, 18 Sep 2023 04:11:38 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 05/10] ublk: make sure ublk uring cmd handling is done in submitter task context
Date:   Mon, 18 Sep 2023 12:11:01 +0800
Message-Id: <20230918041106.2134250-6-ming.lei@redhat.com>
In-Reply-To: <20230918041106.2134250-1-ming.lei@redhat.com>
References: <20230918041106.2134250-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In well-done ublk server implementation, ublk io command won't be
linked into any link chain. Meantime we are always handled in no-wait
style, so basically ublk uring cmd handling is always done in submitter
task context.

However, the server may set IOSQE_ASYNC, or io command is linked to one
chain mistakenly, then we may still run into io-wq context and
ctx->uring_lock isn't held.

So in case of IO_URING_F_UNLOCKED, schedule this command by
io_uring_cmd_complete_in_task to run it in submitter task. Then
ublk_ch_uring_cmd_local() is always called with context uring_lock held,
and we needn't to worry about sync among submission code path.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 9b3c0b3dd36e..46d499d96ca3 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1810,7 +1810,8 @@ static inline struct request *__ublk_check_and_get_req(struct ublk_device *ub,
 	return NULL;
 }
 
-static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+static inline int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
 {
 	/*
 	 * Not necessary for async retry, but let's keep it simple and always
@@ -1824,9 +1825,28 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		.addr = READ_ONCE(ub_src->addr)
 	};
 
+	WARN_ON_ONCE(issue_flags & IO_URING_F_UNLOCKED);
+
 	return __ublk_ch_uring_cmd(cmd, issue_flags, &ub_cmd);
 }
 
+static void ublk_ch_uring_cmd_cb(struct io_uring_cmd *cmd,
+		unsigned int issue_flags)
+{
+	ublk_ch_uring_cmd_local(cmd, issue_flags);
+}
+
+static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	/* well-implemented server won't run into unlocked */
+	if (unlikely(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_uring_cmd_complete_in_task(cmd, ublk_ch_uring_cmd_cb);
+		return -EIOCBQUEUED;
+	}
+
+	return ublk_ch_uring_cmd_local(cmd, issue_flags);
+}
+
 static inline bool ublk_check_ubuf_dir(const struct request *req,
 		int ubuf_dir)
 {
-- 
2.40.1

