Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87AA76BCF10
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 13:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjCPMNT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 08:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbjCPMNG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 08:13:06 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FEB3BDA2
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 05:12:59 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id cy23so6623145edb.12
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 05:12:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678968777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cX/OidKKVms1plQrNedKAjRZwpwb2EI67KhD7QZ5W24=;
        b=RLNUA5d/gokNS6HHW0KLR8of2ToILjyBOFVgc2c8jElg3dSqNL59xCKoIdfkfeezv4
         qXDrLGuZQueE3iFTPQ22PQKCWshd9LZHXDdzX1WTWeJk8MmHRDNSAC8+86mYfdVTC3WB
         24ly/gZhVJn7xlfG44Fspb/stfqORgHvzNMR/s4HcNAkL9FKSg1Hyojpt01T4H0mcN3N
         8PgS50s5dcAy3VZF3stg3YuGkZUClmLeJAFtdYXSU/wZOaCKzOaOlFl6pOAV6LrFpcHa
         kDzbyl7ZuN1Zv0t2vXQIeeQDJGQeE0917vscOmZNB1/2R4+hbDaRwr277yq/68l+52OQ
         A+6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678968777;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cX/OidKKVms1plQrNedKAjRZwpwb2EI67KhD7QZ5W24=;
        b=QukgapIh/sdUW6jjJF9eFcy/L1QUm/8austJp7cWx4dWvnnAYgYgahEiYc8a7GI75c
         fUGpfjy3TdHzbKLSMRXF9H2tY2OMsxJ8UDYhCSuPtzhg61HxGiaVexanE6IROhxlAWDV
         pW0nMFp2vCTgiDfK8YuJ+ewoMeyPqutS+s4EeAeFiSZl3P0/wsLr7kSLFsO2gZdCoHCI
         HiS3ZM4Cfk8F+nkfPbigbUALm1g72ZBHLdgjY++RBVoH+jLg9eGcb/r5yIQoWHmAuMya
         LBAp79DUj3dkr4t2N94Ijys/fTDWpul2iLk3D1Szbt+OWacQumxUK2WXi3IWaC4MLDuj
         8rXA==
X-Gm-Message-State: AO0yUKV3F5cBiXP3/CNw25BmyLv+EXptY4nsAxZ9ZGT/tQpsloPQCwa0
        HKAhkVR/FNO9S/YTU0x65/6WdLRCqSM=
X-Google-Smtp-Source: AK7set/LAdzUMr2c6K250GpQ7vlOON3hfKKtAt7EGg2J1cfesTamQwHQjUC+HfqTWfkwFdmLv1FKmg==
X-Received: by 2002:a17:907:a649:b0:879:ab3:93d1 with SMTP id vu9-20020a170907a64900b008790ab393d1mr12246661ejc.4.1678968777530;
        Thu, 16 Mar 2023 05:12:57 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:e196])
        by smtp.gmail.com with ESMTPSA id v30-20020a50d59e000000b004af7191fe35sm3791095edi.22.2023.03.16.05.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 05:12:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/msg_ring: let target know allocated index
Date:   Thu, 16 Mar 2023 12:11:42 +0000
Message-Id: <4a5ba7d8d439f1942118f93b9be5c05d6a46f2cd.1678937992.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

msg_ring requests transferring files support auto index selection via
IORING_FILE_INDEX_ALLOC, however they don't return the selected index
to the target ring and there is no other good way for the userspace to
know where is the receieved file.

Return the index for allocated slots and 0 otherwise, which is
consistent with other fixed file installing requests.

Cc: stable@vger.kernel.org # v6.0+
Fixes: e6130eba8a848 ("io_uring: add support for passing fixed file descriptors")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/msg_ring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 8803c0979e2a..85fd7ce5f05b 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -202,7 +202,7 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	 * completes with -EOVERFLOW, then the sender must ensure that a
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
-	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0))
 		ret = -EOVERFLOW;
 out_unlock:
 	io_double_unlock_ctx(target_ctx);
@@ -229,6 +229,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct file *src_file = msg->src_file;
 
+	if (msg->len)
+		return -EINVAL;
 	if (target_ctx == ctx)
 		return -EINVAL;
 	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
-- 
2.39.1

