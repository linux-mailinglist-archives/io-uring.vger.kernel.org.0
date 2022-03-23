Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02CD94E5569
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 16:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238016AbiCWPlY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 11:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238021AbiCWPlX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 11:41:23 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ED9B28E2F
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:39:54 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id 125so2117038iov.10
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 08:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=queLCbLbBp9RPHGd3ddr23Y8JQXH3I18TMu8UzSltBA=;
        b=2m39VBx3TjpJO7KPZQ+DOOhr/JfzOk8CaHi27EOU2aGuP8qrY6WVDrELq2inpT9amo
         BQ11nR8oYglxWvCYIFGRl9MpGpEVZ1xX2trGyc8kyaQV3zZe34GymAT5SuG7zvMZrJJ+
         iijNcO5mxGiOJ37rI73Sk2YiNzafpLXeUcdukFoJfzpZ5UlQSVqLkqdEaftc7p54sUMx
         XrHNakVqccLdZNU7A4aBX62bw2eu7jy0Kl5OxkxG4weI3WgG2IN1ue0g0Ns8TSnXiGoL
         qkG06y2XoU9QhIzkGlYWyRqJuL4gY+dbgYoLC3LXdO/m6pEQStNJCJyCPTrRLLebd4TP
         yf/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=queLCbLbBp9RPHGd3ddr23Y8JQXH3I18TMu8UzSltBA=;
        b=Oe1q50pjSG8QLw5ZbRZ+UypND83qiSwIHCjxVqggWTWwRTY0j8DlfOeotzO0e0orFU
         44wIcHVLHM3lxFsAk0Gx5NDTXtJMVqmyzxJBf3v+Bt5oh5pTVJ4eU+uHxsMVemo3H4EV
         6XEV+sySxP5tmcK5F1oBENVfX+cKSxaInnrY9mcCiHM8JPuGYCRJ+Ej9mbbIMSC+uJdu
         mIT5oxfV61UgLburlyqO5s1jNiYsU2/wg4/crEMdO0VJiWr3QqDAIB2UXjQ+TKN7FQML
         oTDL2dgBlpJCKypaJQQdKIxzD6XGdh5GB3lEVdae3X9O7jNwQUZMMwDm9fa445ZWGFCQ
         COAQ==
X-Gm-Message-State: AOAM532bz667u/aP2/vOxITghV93qzyefT49SRkHD63ZHlFbnJa0nBPv
        Nt86IuRALujGxhrsk1hj63IlELzH3ycBhdRD
X-Google-Smtp-Source: ABdhPJyXdqk/ODco36E7cghcRqJ05ikp6tdYvSPF2Ybsbic35QVWUOWJXsBM+DAOkjDUQtjn0Zrprg==
X-Received: by 2002:a05:6602:2d06:b0:648:e7d2:ae5a with SMTP id c6-20020a0566022d0600b00648e7d2ae5amr367122iow.2.1648049993527;
        Wed, 23 Mar 2022 08:39:53 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id s10-20020a6b740a000000b006413d13477dsm124365iog.33.2022.03.23.08.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 08:39:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: add flag for disabling provided buffer recycling
Date:   Wed, 23 Mar 2022 09:39:47 -0600
Message-Id: <20220323153947.142692-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323153947.142692-1-axboe@kernel.dk>
References: <20220323153947.142692-1-axboe@kernel.dk>
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

If we need to continue doing this IO, then we don't want a potentially
selected buffer recycled. Add a flag for that.

Set this for recv/recvmsg if they do partial IO.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2cd67b4ff924..5c6f4abbf294 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -783,6 +783,7 @@ enum {
 	REQ_F_SKIP_LINK_CQES_BIT,
 	REQ_F_SINGLE_POLL_BIT,
 	REQ_F_DOUBLE_POLL_BIT,
+	REQ_F_PARTIAL_IO_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -845,6 +846,8 @@ enum {
 	REQ_F_SINGLE_POLL	= BIT(REQ_F_SINGLE_POLL_BIT),
 	/* double poll may active */
 	REQ_F_DOUBLE_POLL	= BIT(REQ_F_DOUBLE_POLL_BIT),
+	/* request has already done partial IO */
+	REQ_F_PARTIAL_IO	= BIT(REQ_F_PARTIAL_IO_BIT),
 };
 
 struct async_poll {
@@ -1392,6 +1395,9 @@ static void io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 
 	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
 		return;
+	/* don't recycle if we already did IO to this buffer */
+	if (req->flags & REQ_F_PARTIAL_IO)
+		return;
 
 	if (issue_flags & IO_URING_F_UNLOCKED)
 		mutex_lock(&ctx->uring_lock);
@@ -5470,6 +5476,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			ret = -EINTR;
 		if (ret > 0 && flags & MSG_WAITALL) {
 			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg);
 		}
 		req_set_fail(req);
@@ -5539,6 +5546,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
 			return -EAGAIN;
 		}
 		req_set_fail(req);
-- 
2.35.1

