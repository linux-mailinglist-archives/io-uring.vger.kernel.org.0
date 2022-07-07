Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5F256A4C3
	for <lists+io-uring@lfdr.de>; Thu,  7 Jul 2022 16:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234585AbiGGOBj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 Jul 2022 10:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbiGGOBi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 Jul 2022 10:01:38 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9105FE3
        for <io-uring@vger.kernel.org>; Thu,  7 Jul 2022 07:01:37 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id j22so6344624ejs.2
        for <io-uring@vger.kernel.org>; Thu, 07 Jul 2022 07:01:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hz3MGrWks6xhhbOL+BQtE6VgdP1MUAYnO8ndqZEB/y4=;
        b=FSxqQgJWD8hHWKVl1knyMUreSVHGCtUdZa33YJegB1dqVL9i/8fwNDA6EtfdgQEKjn
         vPz52JGMNQK3PQNQaGeM8KXQ6UEdN5Otkri7j+INP0MFsWGiTuRf/QQ+2m5ZYKl0pH4s
         68p/WgZL93obtmYja8xps3T630cXLWN8NLvZc95iyo5PpY1I+YTsGLGoghhx1Ph02uTk
         lsgz4xm+PDbgfCg4uUu0HozCTWzfFJTqf8TmGQ8aZI1Ii2TQMk3aLpTXruoDjBC8gAGw
         S9iKy17PHe1zemBP0s6pgRph4fGa/qOezclAxDH7Z/0tXzHO5TGy8Vt6m4h69Xsb+xC7
         2AEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hz3MGrWks6xhhbOL+BQtE6VgdP1MUAYnO8ndqZEB/y4=;
        b=fQqeTLaAOLwqxwfwWeLAzoBblrS8gUvTIvF37LxvxUO6hbPoNZlxlz+7bXiFiwAhxi
         c9YPfdfh7kuWgrD2kIpe+y+c0o4sd2Iy6BqvAuzZNHfnqgimRuhEfuCFOe+AYFlbSxBc
         3y6MNU9LJ7h1OvqfwBKSP2qAK8470vdY7miCKim11VpaRTZdrJjNo0xbxxVAyNT+SClM
         5hhPiraIfAuVyOf1ZribqE0sfj6rs2nrHWkho0bFpll6qVodBetg3KOHVH9MgC2qJMz6
         A2BTaJc3fzzS8PEkrbMuPMyB5RmmuYFSJP1SG0WHvJR3VODxXKS84IaVU3vuJei2oYf1
         1znw==
X-Gm-Message-State: AJIora++mk5QKonv99gKjUug/2VffW/NaQqJdOHwyx5hloXsYm3TAciO
        r7t4VPgpvSfhHlPRFCc1rkAqyUdoSuvoEOmY
X-Google-Smtp-Source: AGRyM1u9a18SMpaoxGOZX+J4szd0N1vIdaD1vxiKiVgYJ9aMHbvGGcVehYOD+BTlURr4FFo/WsUAMQ==
X-Received: by 2002:a17:907:1b25:b0:6da:8206:fc56 with SMTP id mp37-20020a1709071b2500b006da8206fc56mr45492899ejc.81.1657202495971;
        Thu, 07 Jul 2022 07:01:35 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:338f])
        by smtp.gmail.com with ESMTPSA id g22-20020a056402091600b0043aa17dc199sm259374edz.90.2022.07.07.07.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 07:01:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 1/1] io_uring: explicit sqe padding for ioctl commands
Date:   Thu,  7 Jul 2022 15:00:38 +0100
Message-Id: <e6b95a05e970af79000435166185e85b196b2ba2.1657202417.git.asml.silence@gmail.com>
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

32 bit sqe->cmd_op is an union with 64 bit values. It's always a good
idea to do padding explicitly. Also zero check it in prep, so it can be
used in the future if needed without compatibility concerns.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 2 +-
 include/uapi/linux/io_uring.h | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0d491ad15b66..3b5e798524e5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5066,7 +5066,7 @@ static int io_uring_cmd_prep(struct io_kiocb *req,
 {
 	struct io_uring_cmd *ioucmd = &req->uring_cmd;
 
-	if (sqe->rw_flags)
+	if (sqe->rw_flags | sqe->__pad1)
 		return -EINVAL;
 	ioucmd->cmd = sqe->cmd;
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f10b59d6693e..0ad3da28d2fc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -22,7 +22,10 @@ struct io_uring_sqe {
 	union {
 		__u64	off;	/* offset into file */
 		__u64	addr2;
-		__u32	cmd_op;
+		struct {
+			__u32	cmd_op;
+			__u32	__pad1;
+		};
 	};
 	union {
 		__u64	addr;	/* pointer to buffer or iovecs */
-- 
2.36.1

