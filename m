Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDE95BFCD9
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiIULUu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiIULUs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:20:48 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E5771719
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:46 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id n10so9263974wrw.12
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=vhu/Sfk+5d98pOfwD0Ug0t7w0suS8hFfAmIKFJaf/BI=;
        b=XlfGp8SXiCwo67QauJt2vOcNWwdGN+GcXWBxfk6i/q+Im/Hff0gHRR357xlxFbExHC
         sK4Jxak2dKkGPjBMeAfKCZ9BAc2nzDbbn3ttfC6cdUuTq+b889OKOfR4NBPry8Vb/C4e
         s+YLY1TT4el+XebZwpCSmh/oeS8LYhPBp+6LQS3wpyyOtMXtTzBqzulHKsA5O9YkGXPN
         h7wB0umoK0VRETIFHV2qB/oNa72LO270iove7PQuAhx7sqstPycH/F1hEw9DSi7DjA0d
         d9/Xem7coh7O8XdoLmHk+F5vnmvCmjR7yv9uM3hyhKzpokiKQtvsLKEIC5ykljnvSoVU
         CAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=vhu/Sfk+5d98pOfwD0Ug0t7w0suS8hFfAmIKFJaf/BI=;
        b=NRUV68bUAb3KLMzlwXU+EEo/N6mYcdhHnfJrWFhu0HUaeMwdJBSLJEWpeUA4W/VIm6
         1Fpw3WnHP/KzWcIjGr+h6WIvdGt2BKOMp8z1qnNQIxLxfAYIChcIbj1z7PyK7M4Juqbl
         bdICivtNFqL/3yrz8hubsorilHffcAN3TtENmL8qk5L/9B9a3S4fLT+NZE5ZANFd2aci
         B9x0XiP9WNYPqTA2pHh3rlYx48Iyw6o2C2IVBIR64fQakim0Ffdvdb0IjhryRrFC0LJI
         jnL/Xx9H/UQYSyBWB6bzbBnZ0AGSizjRQYTwFTuTnCElm9bDKivdXdsjpZ589B/nI2uA
         ic0g==
X-Gm-Message-State: ACrzQf1p/mSx0nERuiXIrSl9qLq+y2mIS3bxzw0JkSQxkJxF2IKlIccK
        O/Jc+i+mIIG7rOs6lqwiELuNUAhCmS0=
X-Google-Smtp-Source: AMsMyM4xhgKcZ/PhPASSsZiRpf34yg/nun83ej+bTW0uD19wayqjfZLGnYV8O8Kj5F762lzC46frjQ==
X-Received: by 2002:a05:6000:1cc:b0:22a:e8c6:9f57 with SMTP id t12-20020a05600001cc00b0022ae8c69f57mr12576081wrx.527.1663759244869;
        Wed, 21 Sep 2022 04:20:44 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d6a91000000b00228da845d4dsm2206732wru.94.2022.09.21.04.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:20:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/9] io_uring/net: don't lose partial send_zc on fail
Date:   Wed, 21 Sep 2022 12:17:49 +0100
Message-Id: <5673285b5e83e6ceca323727b4ddaa584b5cc91e.1663668091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663668091.git.asml.silence@gmail.com>
References: <cover.1663668091.git.asml.silence@gmail.com>
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

Partial zc send may end up in io_req_complete_failed(), which not only
would return invalid result but also mask out the notification leading
to lifetime issues.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 16 ++++++++++++++++
 io_uring/net.h   |  1 +
 io_uring/opdef.c |  1 +
 3 files changed, 18 insertions(+)

diff --git a/io_uring/net.c b/io_uring/net.c
index e86a82ef4fbf..5e7fadefe2d5 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1103,6 +1103,22 @@ void io_sendrecv_fail(struct io_kiocb *req)
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
+void io_send_zc_fail(struct io_kiocb *req)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	int res = req->cqe.res;
+
+	if (req->flags & REQ_F_PARTIAL_IO) {
+		if (req->flags & REQ_F_NEED_CLEANUP) {
+			io_notif_flush(sr->notif);
+			sr->notif = NULL;
+			req->flags &= ~REQ_F_NEED_CLEANUP;
+		}
+		res = sr->done_io;
+	}
+	io_req_set_res(req, res, req->cqe.flags);
+}
+
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = io_kiocb_to_cmd(req, struct io_accept);
diff --git a/io_uring/net.h b/io_uring/net.h
index 109ffb3a1a3f..e7366aac335c 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -58,6 +58,7 @@ int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags);
 int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_sendzc_cleanup(struct io_kiocb *req);
+void io_send_zc_fail(struct io_kiocb *req);
 
 void io_netmsg_cache_free(struct io_cache_entry *entry);
 #else
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 8d8a0f9bb5b6..f5e7a0e01729 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -497,6 +497,7 @@ const struct io_op_def io_op_defs[] = {
 		.issue			= io_sendzc,
 		.prep_async		= io_sendzc_prep_async,
 		.cleanup		= io_sendzc_cleanup,
+		.fail			= io_send_zc_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-- 
2.37.2

