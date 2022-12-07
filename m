Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009EC6452B8
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiLGDyl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiLGDyk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:40 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764835216D
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:39 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id n20so11184054ejh.0
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BzK/zrdj76nrH7tgY872zfma02vZfGuAP6Fn/6zdEXI=;
        b=n7eguXwsQ0qfm1aLJchTAdxOyM9dWwFjfm9/jySjjXRqSM/ga6hyjRSv31DqHYU7JG
         lu//oJ7zscuZQUj/fqs/H79NRo9ypEasYQ1xJ0Mox22fXAuQsZcmSR/LVxKxu5I1KHBF
         Z0cq2sq/484Ha52Lxbr9mxIY3oUya2OPGXAicpIbctVzM9mbMCIiPpblaxEbL8G5nZgz
         bcxEzfj11QOFvN0EyLj/AA4OhuRN/4gkF44MpLq4SPMFY0XGmTAYnEkWEStga58RHuaz
         4k3WBkeBdH4nPR9qd6jPiBmVeotSMKa4n9PDfmL4+j+xTV0Gm+g3wpVsVOxVj4QWKFWj
         FgOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BzK/zrdj76nrH7tgY872zfma02vZfGuAP6Fn/6zdEXI=;
        b=TnIt6sTzMhnKUAorghqVCIL8mgEpgQUFBlWIJnXQ59q+7+d51PAQ6iCWvYMwpSonRi
         j0voRpjIrhpd+4MMS8l5Cym0MbFcEKX0wSIdu23gvAd+l7GuFN5LLxf/zXaIhogu32ET
         AifDq+7g9/ypYusdQ/dlo4wOEhVUL7SAuyk08kRO06/SV9fFtJRZOD0SxxSMFGQ1UiC4
         WP0KwOxG0E6Dy/wvKEzcUvDxaGuOOk7u+7DOCZd5A4nwZBsoBWZ/naa+yPgV765ybN8D
         vh84dEVPcknsmdgi3Oliox8WG74zyNXleVTR5bVOeIGht2J+GTRibxa3DtMQSxTTgmn4
         2CoQ==
X-Gm-Message-State: ANoB5pnxfOw+a76pMwUjZxBohjh7ucgGFAABRsN4WJORNbSsKv3sPYuK
        uSqdCn8+ysBsNACj/rbp8h1maSZXG1o=
X-Google-Smtp-Source: AA0mqf6SnTUGML1/xmclXec+2OkM1iXAOZlbGwRULnBFke3XlTRXso8367M8SFCZX5GeGYqfTx8hxQ==
X-Received: by 2002:a17:906:c011:b0:778:f9b6:6fc with SMTP id e17-20020a170906c01100b00778f9b606fcmr76790178ejz.580.1670385277852;
        Tue, 06 Dec 2022 19:54:37 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 06/12] io_uring: force multishot CQEs into task context
Date:   Wed,  7 Dec 2022 03:53:31 +0000
Message-Id: <d7714aaff583096769a0f26e8e747759e556feb1.1670384893.git.asml.silence@gmail.com>
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

Multishot are posting CQEs outside of the normal request completion
path, which is usually done from within a task work handler. However, it
might be not the case when it's yet to be polled but has been punted to
io-wq. Make it abide ->task_complete and push it to the polling path
when executed by io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index 90342dcb6b1d..f276f6dd5b09 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -67,6 +67,19 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
+static inline bool io_check_multishot(struct io_kiocb *req,
+				      unsigned int issue_flags)
+{
+	/*
+	 * When ->locked_cq is set we only allow to post CQEs from the original
+	 * task context. Usual request completions will be handled in other
+	 * generic paths but multipoll may decide to post extra cqes.
+	 */
+	return !(issue_flags & IO_URING_F_IOWQ) ||
+		!(issue_flags & IO_URING_F_MULTISHOT) ||
+		!req->ctx->task_complete;
+}
+
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
@@ -730,6 +743,9 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_msg(req, kmsg, issue_flags);
 
+	if (!io_check_multishot(req, issue_flags))
+		return io_setup_async_msg(req, kmsg, issue_flags);
+
 retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
@@ -829,6 +845,9 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
 
+	if (!io_check_multishot(req, issue_flags))
+		return -EAGAIN;
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
@@ -1280,6 +1299,8 @@ int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
+	if (!io_check_multishot(req, issue_flags))
+		return -EAGAIN;
 retry:
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
-- 
2.38.1

