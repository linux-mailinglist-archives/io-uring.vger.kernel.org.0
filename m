Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B74D4FE991
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 22:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiDLUnq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 16:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiDLUnZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 16:43:25 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADBA10EC46
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 13:38:09 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-e2afb80550so10095494fac.1
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 13:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zf27ijhZ6DfOjYkh/DtQyUcCz+B8LVWzZLm6lKBsAd4=;
        b=K6UWMKlZ8bGn9pFrvtfp3wp8/pqMdON9qMlVBNZ00YbV7rSBtD+oaoZfcKdZyRU7+Q
         qCo137H4JtvBQtSa8XDiRRWrb3ETzP3dJGVd5lzFTIl/jP1AipH5UM/+aXAenFiE7Hpl
         lV9q+w6it2qbUrFUtbI0IqFj6yMtDaG9j7FlgZUfRBU0ybRZVJh7Sni0KLxnRlRmeQdD
         jtyA6DFMoQKdlA1aoB9mltVCEV/kINjxeZUnMbnqXoYG0oZUTunVipXB85OUPvpL1FyB
         Rq+4dYBUwFpcJ6aVW20IhsubUOILVmjcmeTxVW+jQwrY+uOYut6zo2sgnnAUZhWod9y7
         mlXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zf27ijhZ6DfOjYkh/DtQyUcCz+B8LVWzZLm6lKBsAd4=;
        b=6M/NEhwW31JBmO547j3YMKkCXyWV+IxOWmy74p7vAG5LM00XsYMTC/xPvs6Qm78FDB
         3boIhXVmOosPAKRRIEIXQ8NN8jDDeXK6MHkiVjvqeNcusGGaBa/5ZHKNbxj0jLpoTBkg
         ixBR4WzQyKTetcrgEdiGa0GMiUR3KdLIG+uly4v7lWQch9x/5ysJd6IxUgmWYcpI3DQz
         RjXLNhQS8BJN7sWiLMGc+O4D2Faq2OWDYNhMJ430WBM87Njnm4A04KMpSeK1G0SQ0SH1
         3HcekDwdg/aBwY6limyjVFBP69x1zz6uS8aN+Rs36XGX2ZPo+fpD+nmtY6z2jL1iVc5z
         8eyQ==
X-Gm-Message-State: AOAM530meHNNKm7d2aHmVxxdlwFGapXTp2x8EdQ6FgUPA6CsxMgf/7zG
        h9oH8I0WpdHgQ9pWY6EuxXelqVJs/aEywkgs
X-Google-Smtp-Source: ABdhPJyGv6IcVqddymzY/44cjNsd2brF8YFhvMuJWIr10Rb4OGyLDBB681rPG4QjqjnJqkXPIRVWTA==
X-Received: by 2002:a17:90a:d082:b0:1ca:be58:c692 with SMTP id k2-20020a17090ad08200b001cabe58c692mr6902747pju.238.1649795180090;
        Tue, 12 Apr 2022 13:26:20 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm3609084pgf.17.2022.04.12.13.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 13:26:19 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: mark accept direct socket as no-lock
Date:   Tue, 12 Apr 2022 14:26:13 -0600
Message-Id: <20220412202613.234896-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412202613.234896-1-axboe@kernel.dk>
References: <20220412202613.234896-1-axboe@kernel.dk>
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

Mark a socket as nolock if we're accepting it directly, eg without
installing it into the process file table.

For direct issue or task_work issue, we already grab the uring_lock
for those, and hence they are serializing access to the socket for
send/recv already. The only case where we don't always grab the lock
is for async issue. Add a helper to ensure that it gets done if this
is a nolock socket.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0a6bcc077637..17b4dc9f130f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5918,6 +5918,19 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+/*
+ * Mark the socket as not needing locking, io_uring will serialize access
+ * to it. Note there's no matching clear of this condition, as this is only
+ * applicable for a fixed/registerd file, and those go away when we unregister
+ * anyway.
+ */
+static void io_sock_nolock_set(struct file *file)
+{
+	struct sock *sk = sock_from_file(file)->sk;
+
+	sk->sk_no_lock = true;
+}
+
 static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_accept *accept = &req->accept;
@@ -5947,6 +5960,7 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		fd_install(fd, file);
 		ret = fd;
 	} else {
+		io_sock_nolock_set(file);
 		ret = io_install_fixed_file(req, file, issue_flags,
 					    accept->file_slot - 1);
 	}
@@ -7604,11 +7618,31 @@ static struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	return req ? &req->work : NULL;
 }
 
+/*
+ * This could be improved with an FFS flag, but since it's only done for
+ * the slower path of io-wq offload, no point in optimizing it further.
+ */
+static bool io_req_needs_lock(struct io_kiocb *req)
+{
+#if defined(CONFIG_NET)
+	struct socket *sock;
+
+	if (!req->file)
+		return false;
+
+	sock = sock_from_file(req->file);
+	if (sock && sock->sk->sk_no_lock)
+		return true;
+#endif
+	return false;
+}
+
 static void io_wq_submit_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	unsigned int issue_flags = IO_URING_F_UNLOCKED;
+	struct io_ring_ctx *ctx = req->ctx;
 	bool needs_poll = false;
 	struct io_kiocb *timeout;
 	int ret = 0, err = -ECANCELED;
@@ -7645,6 +7679,11 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		}
 	}
 
+	if (io_req_needs_lock(req)) {
+		mutex_lock(&ctx->uring_lock);
+		issue_flags &= ~IO_URING_F_UNLOCKED;
+	}
+
 	do {
 		ret = io_issue_sqe(req, issue_flags);
 		if (ret != -EAGAIN)
@@ -7659,8 +7698,10 @@ static void io_wq_submit_work(struct io_wq_work *work)
 			continue;
 		}
 
-		if (io_arm_poll_handler(req, issue_flags) == IO_APOLL_OK)
-			return;
+		if (io_arm_poll_handler(req, issue_flags) == IO_APOLL_OK) {
+			ret = 0;
+			break;
+		}
 		/* aborted or ready, in either case retry blocking */
 		needs_poll = false;
 		issue_flags &= ~IO_URING_F_NONBLOCK;
@@ -7669,6 +7710,9 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	/* avoid locking problems by failing it from a clean context */
 	if (ret)
 		io_req_task_queue_fail(req, ret);
+
+	if (!(issue_flags & IO_URING_F_UNLOCKED))
+		mutex_unlock(&ctx->uring_lock);
 }
 
 static inline struct io_fixed_file *io_fixed_file_slot(struct io_file_table *table,
-- 
2.35.1

