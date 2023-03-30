Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E432E6D0378
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 13:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjC3Ljg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 07:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231886AbjC3LjT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 07:39:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51CAD65A6
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 04:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680176275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G7J7NxUvNxJiJXz8UOhCEKtjVKBrvZEcpwlbEjhpVTc=;
        b=Tc1nC6ufiNwr6x9GYBHGn9B4W00asVPV7QIm8aaA9kRR+7F2ktGRSQqCt0gUExJ6Y582qn
        w4FDRwV1hpIsos2FBolT+pwV0nZ3uigXbMGEoTAwF0in/gEVY74kf4D2lzo2vX/xwGE5X6
        T54ZxyD+/paf2gITcPKLQlHVLjhw7Po=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-ZO_LHvdaOE6OlsaAbAgPTQ-1; Thu, 30 Mar 2023 07:37:50 -0400
X-MC-Unique: ZO_LHvdaOE6OlsaAbAgPTQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 78BDE3C025C4;
        Thu, 30 Mar 2023 11:37:49 +0000 (UTC)
Received: from localhost (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8455D18EC7;
        Thu, 30 Mar 2023 11:37:48 +0000 (UTC)
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
Subject: [PATCH V6 16/17] block: ublk_drv: don't check buffer in case of zero copy
Date:   Thu, 30 Mar 2023 19:36:29 +0800
Message-Id: <20230330113630.1388860-17-ming.lei@redhat.com>
In-Reply-To: <20230330113630.1388860-1-ming.lei@redhat.com>
References: <20230330113630.1388860-1-ming.lei@redhat.com>
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
index 0ff70cda4b91..a744d3b5da91 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1410,25 +1410,30 @@ static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
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

