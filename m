Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3C1E561A4C
	for <lists+io-uring@lfdr.de>; Thu, 30 Jun 2022 14:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233715AbiF3M1F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jun 2022 08:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiF3M1F (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jun 2022 08:27:05 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CD262B254
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 05:27:04 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id eq6so26278368edb.6
        for <io-uring@vger.kernel.org>; Thu, 30 Jun 2022 05:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vTRdPms0kHjMI2HHjpGVPHKL/zda5MP2d24mvNqbgKU=;
        b=alGkPJ71nkU83ODBC/TG9p4+nCZSa4Oej/9jdNsd1buQmdwocOfsRafi+by1Oderz6
         NggHcvkZJHyhl4qBjHI0syFVM+N7wRg//8cDLnldp4cNLHQ5p1riSxXhvtMU62GGX1oq
         7Hpm539z7GjTL8QFGfCaTL5JKRmleVXNyXgYQYFwV0LwM69RBggqEM5emwM7yFF/9mfp
         KQlwfSqO4nyQKb90zJTbPYhflA6w8SSj48O9rgprOAU5rlatttu5IvR3MNB2pkIHOJCn
         UA4hfGpMq0/NxKRE/Df5Mx6BxUpOP3GYi6ehxUuiVfw5MSbT2QkAcmpsFKAY1++GzlZH
         /RbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vTRdPms0kHjMI2HHjpGVPHKL/zda5MP2d24mvNqbgKU=;
        b=KXskEa/KpGrhuHUq4vDbepFRuDOBlqZNMNblZg9wEk1Y8AMjCx30hYFjz9ZqQuiVUZ
         VGOllBCbfgnb9nDMc7Jzp6ijnnHTUhUgGgwVy2lM5InkpEvlhIsf/KlvhpSdH8z4f15+
         L8LufKBm+3OKEG2ZDt6XD3qtx9gQ/GttYp/ZdCfIICQR7CtrmDyW8hshswCUXg7RUJxe
         RxnsGyDsmdcNcP0xYxIg/HVqIczy3xXc5cykOFg6ZlkkFETuq2sNlGxSFLu079+GEAiQ
         S6IFcNPL0A7ovl7FZwzfV74L7KCim08LDzo3PSrXkZ8u2K/X2209WTMmsUf1qHjsjzQx
         qfgg==
X-Gm-Message-State: AJIora97sLS+sVMtswsXB2lbT9Isvnq1ugH4xRSskRV69EGU7YyG+IJG
        o4QtQnToOBdK8b7VR+54HO4IVmfG0a8EZA==
X-Google-Smtp-Source: AGRyM1vE5LtCQD0gt821/sy4sDOggn1S3/bwnUG66fRIosErgmYaIE7IlbKyVqBUOcVtH6ng8rt1Qg==
X-Received: by 2002:a05:6402:350f:b0:437:6618:174a with SMTP id b15-20020a056402350f00b004376618174amr11272980edd.329.1656592022528;
        Thu, 30 Jun 2022 05:27:02 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:de])
        by smtp.gmail.com with ESMTPSA id a12-20020a170906670c00b006fe8c831632sm8969695ejp.73.2022.06.30.05.27.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 05:27:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19] io_uring: keep sendrecv flags in ioprio
Date:   Thu, 30 Jun 2022 13:25:57 +0100
Message-Id: <06ab196021be1b5463879f637e080ac2c67ec91e.1656591720.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
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

We waste a u64 SQE field for flags even though we don't need as many
bits and it can be used for something more useful later. Store io_uring
specific send/recv flags in sqe->prio instead of ->addr2.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Changes uapi, but it came in 5.19 so it's still fine to change

 fs/io_uring.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ff2cdb425bc..aeb042ba5cc5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1183,6 +1183,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.needs_async_setup	= 1,
+		.ioprio			= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
 	},
 	[IORING_OP_RECVMSG] = {
@@ -1191,6 +1192,7 @@ static const struct io_op_def io_op_defs[] = {
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.needs_async_setup	= 1,
+		.ioprio			= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
 	},
 	[IORING_OP_TIMEOUT] = {
@@ -1266,6 +1268,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
 		.audit_skip		= 1,
+		.ioprio			= 1,
 	},
 	[IORING_OP_RECV] = {
 		.needs_file		= 1,
@@ -1273,6 +1276,7 @@ static const struct io_op_def io_op_defs[] = {
 		.pollin			= 1,
 		.buffer_select		= 1,
 		.audit_skip		= 1,
+		.ioprio			= 1,
 	},
 	[IORING_OP_OPENAT2] = {
 	},
@@ -6075,12 +6079,12 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 
-	if (unlikely(sqe->file_index))
+	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
-	sr->flags = READ_ONCE(sqe->addr2);
+	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~IORING_RECVSEND_POLL_FIRST)
 		return -EINVAL;
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
@@ -6311,12 +6315,12 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 
-	if (unlikely(sqe->file_index))
+	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
-	sr->flags = READ_ONCE(sqe->addr2);
+	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~IORING_RECVSEND_POLL_FIRST)
 		return -EINVAL;
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
-- 
2.36.1

