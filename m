Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A899F5BB461
	for <lists+io-uring@lfdr.de>; Sat, 17 Sep 2022 00:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbiIPWYY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Sep 2022 18:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIPWYX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Sep 2022 18:24:23 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E58DEBBA74
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 15:24:22 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id b5so38127598wrr.5
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 15:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=V/LyM2KlFiskJxqVPe2BePdoQjQ7Q/OEqRuwrCX3IR4=;
        b=LHfXysCBMZzLxSZPwDbwha2VXEgnvwcpl95HGt0Pzc5+Zofr7h4/xmlIIMd0wMRF+h
         Nae4MpOxWcm4976gp3tRrXKf7dvfGI3vNoF8SCAmCHslZzGLa1df6k4zxpOh6l/4lz9G
         SYN45cRL0k6tp6jFtdkq4Jq5nHCtH7rrZyWe4HmTeSdxKpdkbl2B8+7TAxDDX42I+bej
         YAIXie5OgUjXmx9lggMyjTTqHb1hslTL9rTeixFOPL1obP4v+8oPWGSmVBzeoVuHFICz
         PM3VCtaREDoxgPf1VWBpc3QZpdZdAy4rGzhYZ5B61Jz6JF8Um8t4wDbEeZKJEp51wOAF
         xqNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=V/LyM2KlFiskJxqVPe2BePdoQjQ7Q/OEqRuwrCX3IR4=;
        b=ftLoY5XQ1cmKThPyUK31Zj1oPfQREQdVsnbcswdacDAH7Gc6hHXOI4VPLKa7c80Qmf
         lgiRKy8J+4ToJTiQMtBp/NGH8nd8GYv786k5z0vWgq/1KDsdsiUT/IS32DQdVqWGMnf4
         nQ/9SciSuYX+n4wu9Mp0ldjd/9sTl/czYrrrymt44PK1FsVfLAoDTw7u0JawntOOLCTe
         j3DgftE/xzrMa2nXNQuxouImta00xA+Mgn2OvPijGRSee4nTVY5cXDXmzuI81J4O76qE
         JeItATg857RDvD53Iyuvw5ihnd+W0MILqPtukaNlC8GG60caMIseZjI4CLG6szEmNbmy
         77Iw==
X-Gm-Message-State: ACrzQf0VijcB2ZzKauoRrK2iuRimEBZKaD5UE0MGHdF1JKbjY6ognR5u
        7sr1OrU0t8CEMSqA7O/+i5dBnPuHBUIhaQ==
X-Google-Smtp-Source: AMsMyM7iOf3xgFpEkRpls94BiWSn6wcBD8KZ6MBK7RUG+x0PV+WmYa6IT9mWAnuk2+XMwj33r7XyLQ==
X-Received: by 2002:a5d:540a:0:b0:22a:35f1:2d61 with SMTP id g10-20020a5d540a000000b0022a35f12d61mr4026554wrv.535.1663367060935;
        Fri, 16 Sep 2022 15:24:20 -0700 (PDT)
Received: from 127.0.0.1localhost.0.0.1localhost ([185.205.229.29])
        by smtp.gmail.com with ESMTPSA id t66-20020a1c4645000000b003a540fef440sm3512456wma.1.2022.09.16.15.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 15:24:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/1] io_uring/net: fix zc fixed buf lifetime
Date:   Fri, 16 Sep 2022 23:22:57 +0100
Message-Id: <dd6406ff8a90887f2b36ed6205dac9fda17c1f35.1663366886.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
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

Notifications usually outlive requests, so we need to pin buffers with
it by assigning a rsrc to it instead of the request.

Fixed: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index e9efed40cf3d..60e392f7f2dc 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -905,6 +905,13 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (zc->flags & ~(IORING_RECVSEND_POLL_FIRST |
 			  IORING_RECVSEND_FIXED_BUF))
 		return -EINVAL;
+	notif = zc->notif = io_alloc_notif(ctx);
+	if (!notif)
+		return -ENOMEM;
+	notif->cqe.user_data = req->cqe.user_data;
+	notif->cqe.res = 0;
+	notif->cqe.flags = IORING_CQE_F_NOTIF;
+	req->flags |= REQ_F_NEED_CLEANUP;
 	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
 		unsigned idx = READ_ONCE(sqe->buf_index);
 
@@ -912,15 +919,8 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EFAULT;
 		idx = array_index_nospec(idx, ctx->nr_user_bufs);
 		req->imu = READ_ONCE(ctx->user_bufs[idx]);
-		io_req_set_rsrc_node(req, ctx, 0);
+		io_req_set_rsrc_node(notif, ctx, 0);
 	}
-	notif = zc->notif = io_alloc_notif(ctx);
-	if (!notif)
-		return -ENOMEM;
-	notif->cqe.user_data = req->cqe.user_data;
-	notif->cqe.res = 0;
-	notif->cqe.flags = IORING_CQE_F_NOTIF;
-	req->flags |= REQ_F_NEED_CLEANUP;
 
 	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	zc->len = READ_ONCE(sqe->len);
-- 
2.37.2

