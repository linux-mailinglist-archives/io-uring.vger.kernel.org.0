Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACA7D6AE263
	for <lists+io-uring@lfdr.de>; Tue,  7 Mar 2023 15:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjCGO2c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Mar 2023 09:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjCGO2I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Mar 2023 09:28:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50BA223DB5
        for <io-uring@vger.kernel.org>; Tue,  7 Mar 2023 06:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678198962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wyNM1N4WNAdhATuJ96hyAAFSa/inNN+RlUlxIKIFdaI=;
        b=G4ymQEw1WiIwfa4Nz+Xg714DIbtDezpGNe8lsguNlXSDJpktW2n8pu3KDrJf/63j7dffE3
        zdBmb2KvHfvmDgKLtkXd2uyUBFlDuJT6jMQDy5JDEbSuPv+mwef6Xe41lFH/rJu5Q6MehR
        RMCPV6Z81Ovp/4BoPolKB9JLBiXCfAo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-146-9n_NcqnqP1GKainxRp8UNA-1; Tue, 07 Mar 2023 09:16:33 -0500
X-MC-Unique: 9n_NcqnqP1GKainxRp8UNA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6DDF98828C1;
        Tue,  7 Mar 2023 14:16:32 +0000 (UTC)
Received: from localhost (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 92D731121314;
        Tue,  7 Mar 2023 14:16:31 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 16/17] block: ublk_drv: don't check buffer in case of zero copy
Date:   Tue,  7 Mar 2023 22:15:19 +0800
Message-Id: <20230307141520.793891-17-ming.lei@redhat.com>
In-Reply-To: <20230307141520.793891-1-ming.lei@redhat.com>
References: <20230307141520.793891-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case of zero copy, ublk server needn't to pre-allocate IO buffer
and provide it to driver more.

Meantime not set the buffer in case of zero copy any more, and the
userspace can use pread()/pwrite() to read from/write to the io request
buffer, which is easier & simpler from userspace viewpoint.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/block/ublk_drv.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 452deec571f7..2385cc3f8566 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1409,25 +1409,30 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 		if (io->flags & UBLK_IO_FLAG_OWNED_BY_SRV)
 			goto out;
 		/* FETCH_RQ has to provide IO buffer if NEED GET DATA is not enabled */
-		if (!ub_cmd->addr && !ublk_need_get_data(ubq))
-			goto out;
+		if (!ublk_support_zc(ubq)) {
+			if (!ub_cmd->addr && !ublk_need_get_data(ubq))
+				goto out;
+			io->addr = ub_cmd->addr;
+		}
 		io->cmd = cmd;
 		io->flags |= UBLK_IO_FLAG_ACTIVE;
-		io->addr = ub_cmd->addr;
-
 		ublk_mark_io_ready(ub, ubq);
 		break;
 	case UBLK_IO_COMMIT_AND_FETCH_REQ:
 		req = blk_mq_tag_to_rq(ub->tag_set.tags[ub_cmd->q_id], tag);
+
+		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
+			goto out;
 		/*
 		 * COMMIT_AND_FETCH_REQ has to provide IO buffer if NEED GET DATA is
 		 * not enabled or it is Read IO.
 		 */
-		if (!ub_cmd->addr && (!ublk_need_get_data(ubq) || req_op(req) == REQ_OP_READ))
-			goto out;
-		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
-			goto out;
-		io->addr = ub_cmd->addr;
+		if (!ublk_support_zc(ubq)) {
+			if (!ub_cmd->addr && (!ublk_need_get_data(ubq) ||
+						req_op(req) == REQ_OP_READ))
+				goto out;
+			io->addr = ub_cmd->addr;
+		}
 		io->flags |= UBLK_IO_FLAG_ACTIVE;
 		io->cmd = cmd;
 		ublk_commit_completion(ub, ub_cmd);
-- 
2.39.2

