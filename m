Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE04956A52D
	for <lists+io-uring@lfdr.de>; Thu,  7 Jul 2022 16:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiGGOOV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 10:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235059AbiGGOOU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 10:14:20 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC2C2F39A
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 07:14:19 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id o25so32690093ejm.3
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 07:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FoaoLGayVR9g1LFSguZ7ChvtAEKoJH/jleNZLvLR1+A=;
        b=BOHYKCXCvG0ixGvUIhD265l0Fdv8ON05wJjzTgzVAaqCv/RO0CZkR8fpM15sQAAOAm
         IPEmS/v0pIss3Ou38Dv6R+qeUXWKN8EuLfIb8guzjYAjsV5mbmRR28uXrSinnHrN4Ifg
         8MCbkQaHATNHK/MtwV36busUIEmUW6rOfCfmzn/co3pZsusgd3Hei5Lq04P5iofDRAxz
         to71ljoKbpEuWDlIJN25CMRPDiqHB/hGojGqVFXQKN5r2l8KmyH9HblVc6byoj5Z52zy
         pNfioXGlBWIgRfe4bhDyF0f7v91m1MBlRLpdxrnXU04kKtEMIt6Jmo+8PWIu2qrzJV7c
         oE8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FoaoLGayVR9g1LFSguZ7ChvtAEKoJH/jleNZLvLR1+A=;
        b=6KsC4FLh/R6te1GxU7X9TEh1Xt2UX+TaO+RZxs8tvTbmCSM0dOpbLJG+Rm5MNRL0QA
         IRYyzh9I2wbtY2kBvQRJT/pxodH6nldZ1QNN7ddiJ+j3xGvv5wP/kU+6mtI8qBaV7BsR
         8MBc7aG0pFdERAry9zCYI7x1Qf7dUEAFtYHHzPAT2kIz72QUpP7C3AqbiCi2o1cFWbsl
         xK+Q9wZkaMGg7EMTtoUSHSWmBx6wCHoFE5qKmghSpniXfgReNbFAVHnI6fksSOJQN4Wh
         Um1oSmLyft8vPxwaS1vFHLXv6C2UuNGNszkdcdLxiYFg6CHb+yJbXIDnUI+p+YyeTr2j
         /dDA==
X-Gm-Message-State: AJIora/gGrrA81vKTNQXQuuq6bei91GXi+VUIZkbWMJerkHXpt9y71JU
        HSNYxHujNZLS2LSgIuU8dB/PQnNduiaeHdGF
X-Google-Smtp-Source: AGRyM1vzLNpzJaE/hHDIMcuELbEauevRRdSRR89Vd8EYZRQA8fnZ4mifuBXXz84IR3D9KvmvWZxYDg==
X-Received: by 2002:a17:907:72cf:b0:72a:e56a:3157 with SMTP id du15-20020a17090772cf00b0072ae56a3157mr14330079ejc.465.1657203258008;
        Thu, 07 Jul 2022 07:14:18 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:3fc3])
        by smtp.gmail.com with ESMTPSA id bq15-20020a056402214f00b00435a742e350sm28254125edb.75.2022.07.07.07.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:14:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/4] io_uring: don't race double poll setting REQ_F_ASYNC_DATA
Date:   Thu,  7 Jul 2022 15:13:15 +0100
Message-Id: <df6920f509c11115aa2bce8b34dc5fdb0eb98920.1657203020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1657203020.git.asml.silence@gmail.com>
References: <cover.1657203020.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just as with io_poll_double_prepare() setting REQ_F_DOUBLE_POLL, we can
race with the first poll entry when setting REQ_F_ASYNC_DATA. Move it
under io_poll_double_prepare().

Fixes: a18427bb2d9b ("io_uring: optimise submission side poll_refs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/poll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/poll.c b/io_uring/poll.c
index 3710a0a46a87..c1359d45a396 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -410,6 +410,8 @@ static void io_poll_double_prepare(struct io_kiocb *req)
 		spin_lock_irq(&head->lock);
 
 	req->flags |= REQ_F_DOUBLE_POLL;
+	if (req->opcode == IORING_OP_POLL_ADD)
+		req->flags |= REQ_F_ASYNC_DATA;
 
 	if (head)
 		spin_unlock_irq(&head->lock);
@@ -448,13 +450,11 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 			return;
 		}
 
-		io_poll_double_prepare(req);
 		/* mark as double wq entry */
 		wqe_private |= IO_WQE_F_DOUBLE;
 		io_init_poll_iocb(poll, first->events, first->wait.func);
+		io_poll_double_prepare(req);
 		*poll_ptr = poll;
-		if (req->opcode == IORING_OP_POLL_ADD)
-			req->flags |= REQ_F_ASYNC_DATA;
 	} else {
 		/* fine to modify, there is no poll queued to race with us */
 		req->flags |= REQ_F_SINGLE_POLL;
-- 
2.36.1

