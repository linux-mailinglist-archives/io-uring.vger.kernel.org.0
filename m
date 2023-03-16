Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6786BCF1C
	for <lists+io-uring@lfdr.de>; Thu, 16 Mar 2023 13:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCPMP2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Mar 2023 08:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbjCPMP1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Mar 2023 08:15:27 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0919F62D9B
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 05:15:26 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id cy23so6651457edb.12
        for <io-uring@vger.kernel.org>; Thu, 16 Mar 2023 05:15:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678968924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cX/OidKKVms1plQrNedKAjRZwpwb2EI67KhD7QZ5W24=;
        b=qSaAPf1jykJRp6GFGRuZmhltivik9stRXTQ/U6F3vxlYDb+YT/6cIN/W29DQxVpQ0P
         jMtu+5cizJOq30+OxB5Fcfd/COMewmw1qAzt59h11rKnCdZkPPHLo+g3xLtpdoEe9FzJ
         olyU18ogGd0RUjgNEIiXqMBHpJcWYo+gIom7VkIeE3UDSSxEMxhz6O3+9tCqi4jFyn2A
         ilY9fsgEKwa1v/+ec1kezAwzl0F51YQjILC11sRFy6qItZIFc3Jnx1Watf1fgZ/4OgD1
         T/Vbt/8+FrkWDd8ObSo0L5dUFEn0Rrf4L2zJ4URuQFiMV8TolYQvzsJdkh+5dTQvrriN
         XlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678968924;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cX/OidKKVms1plQrNedKAjRZwpwb2EI67KhD7QZ5W24=;
        b=mSpWVT3EVzwMkFWDt+3+AocLuYxKIqeoVwjgjF4jzSY0OJj4OSpeMa+m7gw7yKVo9x
         knvtEVe9FbvO/ypeP1uanaxRH7fuLTYJbbbg3ZbxOowPGiYRqRCgfqjKgfCBummfDhjE
         pP2Sd2hsJUWrfQa5ankuz0JdXDG/+8bKRZkQoGghlLHQHnFPWREImElQtEvcT0vyqDeq
         xWe4Qww8yIQ9djgM55m1RHKboJpPiqqRT0MZpLx4vsUkRB+mQJLPU4J+6yYhbTriojd6
         pFtLdanaXc7RA3uTKhF6bqWjvgGZEVpTAiJxFVgmzXR+K65HoQ98yBrVio7LQXeeQ09k
         MXxQ==
X-Gm-Message-State: AO0yUKXWTLz4mugeVV6sLFlxpVynwehK1SjxJC8G/BUitRKZYQypXdOG
        1t7VdWw1USey8CQtYAXZnYjVGTcxAbg=
X-Google-Smtp-Source: AK7set8K1urcQ1Su2zdODdU7uAwMS3cIlrx3/w4xU3eg8nUkrq3noLY/5C9d4SErdGsDcaillBMRcQ==
X-Received: by 2002:a17:906:28d:b0:8d6:626d:7e03 with SMTP id 13-20020a170906028d00b008d6626d7e03mr10787252ejf.40.1678968924341;
        Thu, 16 Mar 2023 05:15:24 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7abd])
        by smtp.gmail.com with ESMTPSA id n18-20020a170906701200b00927f6c799e6sm3762116ejj.132.2023.03.16.05.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 05:15:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/msg_ring: let target know allocated index
Date:   Thu, 16 Mar 2023 12:14:15 +0000
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

