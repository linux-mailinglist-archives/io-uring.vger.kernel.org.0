Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5E7533305
	for <lists+io-uring@lfdr.de>; Tue, 24 May 2022 23:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbiEXVhm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 May 2022 17:37:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241943AbiEXVhl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 May 2022 17:37:41 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906D97CB43
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:39 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gz24so1675pjb.2
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 14:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UtwF8cedt/87lkaIX+o7YF0XPzxX7aNyfWm9R+ZxrV4=;
        b=4uGvYBII+wErWZK2p1rKZsl0bqAbdQDwOpVwhpFL9PRxh0HhwqzFR7alODAl791dd9
         k2OJq546m2MRjav/MIiBMHpTnFC+aQtLLI6HyqtuY708XtwZkDvcETxrdXvY2OGEL2AQ
         B/zXh7kgvSA8quoiWBv6xcAHr4pNWTW+uB+vvjUsrCWuqcC3D6ZZ7gj46bd90RDMNm+V
         xFaxua6rDIvKyAyX4Z6vwZQTo4b+bJg2Sl9Jtv17ExwZ2t+HkWIzSus0f+7T5pdo4fF4
         x0YTTkRr56eM9hre3FhZsu87DgneoEX/kBBbo3j2CpJdY4VsVMkRajOD0YK+pqcb0M5U
         HiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UtwF8cedt/87lkaIX+o7YF0XPzxX7aNyfWm9R+ZxrV4=;
        b=Qja0MeRcoKxvpRA+CJBKH1IZyPbW27J4eE+ElR+PG6r1ZlCRqdjLvm+XxrwXOXshQl
         TcmqUkDN7xA8VP6k8aYwQIGrTX4wHkCESFVyrHV4BEZeRkBjgbcLMdUSYnJhE2wWD8lW
         7iFkiBC1FP0e9+AK/7e1chRAUgS/Kil65kv2T+++YSxFUcquJzMTkhWyNGzp7k1+O0qi
         TgYWjhB678RMV/8mWXSEQCCqB2jMmSXsDLoAsBVxss4Xtor3MDkwyd78G9ztHsxsoYtY
         z5Yx0cN30zKeICCI9DecLfjRL1QFV/5jShQVUYkQT18KczkuHBpemxoEcTzYfqspOX8R
         RAJA==
X-Gm-Message-State: AOAM533DrIF1SGMYoxx3m9HHxpbact26elrVW1Xzm94LNFgL2HJOvQDb
        9rB5e7YX+y0yfjwZYVlpnbBmQ0fp/Bb7CQ==
X-Google-Smtp-Source: ABdhPJzB7dx+MXuAYBH8OI8fgJrk0LBJGhaCah/r05+rAdo/2lgczzQ7FLNhu2dtQoXi1opZoMS/Og==
X-Received: by 2002:a17:902:b58b:b0:162:2e01:9442 with SMTP id a11-20020a170902b58b00b001622e019442mr9151256pls.6.1653428258582;
        Tue, 24 May 2022 14:37:38 -0700 (PDT)
Received: from localhost.localdomain ([2600:380:4a61:523:72ca:65a5:f684:5e4])
        by smtp.gmail.com with ESMTPSA id k21-20020a170902761500b0015e8d4eb1easm7834327pll.52.2022.05.24.14.37.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 May 2022 14:37:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: move shutdown under the general net section
Date:   Tue, 24 May 2022 15:37:27 -0600
Message-Id: <20220524213727.409630-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524213727.409630-1-axboe@kernel.dk>
References: <20220524213727.409630-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Gets rid of some ifdefs and enables use of the net defines for when
CONFIG_NET isn't set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 66 +++++++++++++++++++++++----------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8188c47956ad..9624ab114a40 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5113,42 +5113,6 @@ static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static int io_shutdown_prep(struct io_kiocb *req,
-			    const struct io_uring_sqe *sqe)
-{
-#if defined(CONFIG_NET)
-	if (unlikely(sqe->off || sqe->addr || sqe->rw_flags ||
-		     sqe->buf_index || sqe->splice_fd_in))
-		return -EINVAL;
-
-	req->shutdown.how = READ_ONCE(sqe->len);
-	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
-}
-
-static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
-{
-#if defined(CONFIG_NET)
-	struct socket *sock;
-	int ret;
-
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		return -EAGAIN;
-
-	sock = sock_from_file(req->file);
-	if (unlikely(!sock))
-		return -ENOTSOCK;
-
-	ret = __sys_shutdown_sock(sock, req->shutdown.how);
-	io_req_complete(req, ret);
-	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
-}
-
 static int __io_splice_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -6073,6 +6037,34 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 #if defined(CONFIG_NET)
+static int io_shutdown_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	if (unlikely(sqe->off || sqe->addr || sqe->rw_flags ||
+		     sqe->buf_index || sqe->splice_fd_in))
+		return -EINVAL;
+
+	req->shutdown.how = READ_ONCE(sqe->len);
+	return 0;
+}
+
+static int io_shutdown(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct socket *sock;
+	int ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	ret = __sys_shutdown_sock(sock, req->shutdown.how);
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static bool io_net_retry(struct socket *sock, int flags)
 {
 	if (!(flags & MSG_WAITALL))
@@ -6777,8 +6769,10 @@ IO_NETOP_PREP_ASYNC(recvmsg);
 IO_NETOP_PREP_ASYNC(connect);
 IO_NETOP_PREP(accept);
 IO_NETOP_PREP(socket);
+IO_NETOP_PREP(shutdown);
 IO_NETOP_FN(send);
 IO_NETOP_FN(recv);
+IO_NETOP_FN(shutdown);
 #endif /* CONFIG_NET */
 
 struct io_poll_table {
-- 
2.35.1

