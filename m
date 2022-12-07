Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 087AE6452BD
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiLGDys (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiLGDyn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:43 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D40652158
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:42 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id d20so23234328edn.0
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CQ9KJKd7U+9IDFMcUWamULroPRymnHOqPsKek3NuXMM=;
        b=C9jFDLvDjPZIC5ksjJJFom+cC9zQ0raq5uLSf4vKE/mV4HPzIqks0BTaMNoWWFoWUi
         bxZbUI2wTTDHv/9yVT3vIjaHsDMAPdtJaYuH+Or1nFxa2SI7jVyE3o0j8peCYRXRiEai
         T2TMkFHfUkzIVb3UX9uCGDFeVucqXbbBpjunRvP0XxwHYwSsH03i9E2onBwDcuSSUiM1
         surojpdbGw7tUhDpdVfjN45bDJzeXSf8TEHyWOrJZAWQjJieZn/lDuRo+cTeVsh7ONyL
         dmSBNZi6JulkiAQKxcgJA6dEuc3rFV66+RoY7ZXTxXjjKUgnEpyriUiK9NSGo7cl6WFL
         fRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CQ9KJKd7U+9IDFMcUWamULroPRymnHOqPsKek3NuXMM=;
        b=clQqtFOGy1a8NgTogB0HNiwuMuQcg0vv3Gub+3bGdnEVZjatRNsqO49CEf07wGv39i
         6Otl/3ieS+ojm9IBcBDJ5aQbu+3L1fbByRoA7SwP2Ao6ntSsEZZ1D8ZmGF7ZgqX6K9BA
         VDzifAYgKglNuHPFtG2E9BQpkpXurtGHTXp18QLNELgRAZv/dSksSU/wG1VufUefcIKl
         tBbd7z6zlLlNhqBbMOY/OAM2jk0ZjrZ8SUBX4MgZL2RNnWMvKz4B2FNZt7Vn6fbnrKbM
         ouu6QngbWpvr2iQ9MFDhsDyZ9PFqFsQ5VQEkwAKhr5o2YuRLx5m/tiafCwEDncu7V+tH
         FUmA==
X-Gm-Message-State: ANoB5pl0QGoq6wHcipdpFVKbaS9EdgU9EAiJjWs2h74Zmo8krO/A2aRv
        9fyzKfaZBuTTc3X6MfzNH4QiypIhfvY=
X-Google-Smtp-Source: AA0mqf7/9qBMMFy87ZWzndKGsXOTJVEfjmKR/ljZN1xCPqQky4EAnwybCYfhS6EU1yeYOlTqUmo7dA==
X-Received: by 2002:a05:6402:e04:b0:469:e6ef:9164 with SMTP id h4-20020a0564020e0400b00469e6ef9164mr31999116edh.185.1670385281035;
        Tue, 06 Dec 2022 19:54:41 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 10/12] io_uring: extract a io_msg_install_complete helper
Date:   Wed,  7 Dec 2022 03:53:35 +0000
Message-Id: <1500ca1054cc4286a3ee1c60aacead57fcdfa02a.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670384893.git.asml.silence@gmail.com>
References: <cover.1670384893.git.asml.silence@gmail.com>
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

Extract a helper called io_msg_install_complete() from io_msg_send_fd(),
will be used later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/msg_ring.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 387c45a58654..525063ac3dab 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -92,36 +92,25 @@ static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_fl
 	return file;
 }
 
-static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
+static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-	struct io_ring_ctx *ctx = req->ctx;
 	struct file *src_file = msg->src_file;
 	int ret;
 
-	if (target_ctx == ctx)
-		return -EINVAL;
-	if (!src_file) {
-		src_file = io_msg_grab_file(req, issue_flags);
-		if (!src_file)
-			return -EBADF;
-		msg->src_file = src_file;
-		req->flags |= REQ_F_NEED_CLEANUP;
-	}
-
 	if (unlikely(io_double_lock_ctx(target_ctx, issue_flags)))
 		return -EAGAIN;
 
 	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
 	if (ret < 0)
 		goto out_unlock;
+
 	msg->src_file = NULL;
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
 	if (msg->flags & IORING_MSG_RING_CQE_SKIP)
 		goto out_unlock;
-
 	/*
 	 * If this fails, the target still received the file descriptor but
 	 * wasn't notified of the fact. This means that if this request
@@ -135,6 +124,25 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	return ret;
 }
 
+static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ring_ctx *target_ctx = req->file->private_data;
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct file *src_file = msg->src_file;
+
+	if (target_ctx == ctx)
+		return -EINVAL;
+	if (!src_file) {
+		src_file = io_msg_grab_file(req, issue_flags);
+		if (!src_file)
+			return -EBADF;
+		msg->src_file = src_file;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+	return io_msg_install_complete(req, issue_flags);
+}
+
 int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
-- 
2.38.1

