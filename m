Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD7275EFF3B
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 23:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbiI2VY1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 17:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiI2VYZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 17:24:25 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C72E147A1C
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 14:24:25 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id u10so3915152wrq.2
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 14:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=W2XU0GRFslhefZjZneGK9jg0cksro/rrhthPTsEjARI=;
        b=SZO7PWO6akNFT9bz/fUvd6Sg0hPg+xlpYuaHUg/jjA7s1DC1rAOJQ9IM9qSibOumwT
         uOFmAFC9BTdolJxqQm8+3Ahskbm/dKP9hjOhmyDEVpdLyAAPuJ4vs6hQDoLlWSPryJNl
         20pgdUVZQ5WkQJ9oP7yEff9vUDJ138y59Vq/dmZXzYzc5EmN8rV1ChJYgeeAZrhAsU1+
         JbWz/xssw/pIpE+xm9SR4YqdimwWVqokqE7Es/PxtTyWLX16pjUEqqXdVbiPdaNUYcyx
         zzSydOLCU6wqQs1HPBwjTmeZin7pnPOQhLEkRQzzftxIPNvzhY1yh4XfsPssHWCW29U6
         3x1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=W2XU0GRFslhefZjZneGK9jg0cksro/rrhthPTsEjARI=;
        b=ECcEJbV773fi21AyyoIBmVmaay3nXQ7oCRFjSpXRS6v6RmawCYmcFIyy4yTZecV2Pm
         sQpWgcSSGoRF2S82jRnUtUFphF1wFfD3bovI+R8XTUu468P2ylIFeyUHv9tyOyRIiRqb
         9g5UDdJ3c3aQZ5XnVJZUDZ83+t4kyi+FDSIEy6WhO7+EGCAYvn4Jt+AXuGnN9NE4o0uN
         1aGrDyGUU7Xr9Hq2Xlhbk1LPiSopN5aOE6FxkivHcM68ALE+cefz9E0C2BZORtKgt6If
         o/HuBlnlY3KxeRjQ8Ux54I98oQDSWh/nvmDCGi/kyNTdWXbQiBa8BRgL6gnvcGmSs3c5
         dwIw==
X-Gm-Message-State: ACrzQf1mA/bd2meyz9B4/oEuHMIP/9/cSyAB1l72R5hQBSHnoj3v1qCY
        Jc7tuEV9KkNIbeW2fHqZ4js790lkkbI=
X-Google-Smtp-Source: AMsMyM4gPPhivGiPFNp87icosInbtfSumZxEZH5SMGkYprOc75KEQxhtQ1tgoJkWLSS5ML6rwC4bFQ==
X-Received: by 2002:adf:e904:0:b0:22c:be06:5001 with SMTP id f4-20020adfe904000000b0022cbe065001mr3640273wrm.400.1664486663272;
        Thu, 29 Sep 2022 14:24:23 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id x24-20020a05600c189800b003b4727d199asm435023wmp.15.2022.09.29.14.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 14:24:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 2/2] io_uring/net: fix notif cqe reordering
Date:   Thu, 29 Sep 2022 22:23:19 +0100
Message-Id: <0031f3a00d492e814a4a0935a2029a46d9c9ba06.1664486545.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1664486545.git.asml.silence@gmail.com>
References: <cover.1664486545.git.asml.silence@gmail.com>
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

send zc is not restricted to !IO_URING_F_UNLOCKED anymore and so
we can't use task-tw ordering trick to order notification cqes
with requests completions. In this case leave it alone and let
io_send_zc_cleanup() flush it.

Cc: stable@vger.kernel.org
Fixes: 53bdc88aac9a2 ("io_uring/notif: order notif vs send CQEs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 604eac5f7a34..caa6a803cb72 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1127,8 +1127,14 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	else if (zc->done_io)
 		ret = zc->done_io;
 
-	io_notif_flush(zc->notif);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	/*
+	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
+	 * flushing notif to io_send_zc_cleanup()
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_notif_flush(zc->notif);
+		req->flags &= ~REQ_F_NEED_CLEANUP;
+	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }
@@ -1182,8 +1188,10 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 		req_set_fail(req);
 	}
 	/* fast path, check for non-NULL to avoid function call */
-	if (kmsg->free_iov)
+	if (kmsg->free_iov) {
 		kfree(kmsg->free_iov);
+		kmsg->free_iov = NULL;
+	}
 
 	io_netmsg_recycle(req, issue_flags);
 	if (ret >= 0)
@@ -1191,8 +1199,14 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 
-	io_notif_flush(sr->notif);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	/*
+	 * If we're in io-wq we can't rely on tw ordering guarantees, defer
+	 * flushing notif to io_send_zc_cleanup()
+	 */
+	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
+		io_notif_flush(sr->notif);
+		req->flags &= ~REQ_F_NEED_CLEANUP;
+	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }
-- 
2.37.2

